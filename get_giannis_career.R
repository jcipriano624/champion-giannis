################## Load Packages ###########################

library(tidyverse)
library(lubridate)
# Uncomment and run to install ballr so it can be loaded
#install.packages("devtools")
#library(devtools)
#install_github("rtelmore/ballr")
library(ballr)

############# Functions for Scraping ######################

# Scrapes the Bucks' final standings from that year and merges with data
get_final_standings <- function(team_year_df) {
  year <- team_year_df$year[[1]]
  final_date <- team_year_df$date[[nrow(team_year_df)]]

  # Scrape the year of the data provided
  NBAStandingsByDate(final_date)$East %>%

    # Make sure all the types are defined so the dataframes can actually merge
    mutate(
      rank = rank(desc(w_lpercent)),
      year = year,
      w_lpercent = as.double(w_lpercent),
      pw = as.double(pw),
      pl = as.double(pw),
      ps_g = as.double(ps_g),
      pa_g = as.double(pa_g)
    ) %>%
    relocate(year) %>%
    relocate(rank) %>%

    # Filter for Milwaukee's place in the standings
    filter(startsWith(eastern_conference, "Mil")) %>%

    # Give it something to merge on
    mutate(team = "MIL") %>%
    right_join(team_year_df) %>%

    # Remove unnecessary columns
    select(-c(eastern_conference, w, l)) %>%
    return()
}

slow_get_final_standings <- purrr::slowly(f = get_final_standings, rate = rate_delay(1))

# Scrape for Giannis' season stats and merge
get_giannis <- function(team_year_df) {
  year <- team_year_df$year[[1]]

  # Scrape the individual player statistics for a year
  NBAPerGameStatisticsPer36Min(year) %>%

    # Only look at the Giannis row
    filter(player == "Giannis Antetokounmpo") %>%
    rename(
      "team" = tm,
      "games_played" = g,
      "games_started" = gs
    ) %>%
    select(-rk) %>%
    right_join(team_year_df) %>%
    return()
}

slow_get_giannis <- purrr::slowly(f = get_giannis, rate = rate_delay(1))

# Get the info from all games the Bucks played that season
clean_team_year <- function(team, year) {
  NBASeasonTeamByYear(team, year) %>%
    select(-c(x, x_2, notes, daysbetweengames, start_et)) %>%

    # So many confusing names and wrongly assigned names
    rename(
      "game" = g,
      "cumulative_wins" = w,
      "cumulative_losses" = l,
      "cumulative_away" = away,
      "game_outcome" = x_4,
      "overtime" = x_5,
      "tm_score" = tm,
      "opp_score" = opp,
      "away_game" = away_indicator
    ) %>%

    # Add things to merge on, parse date
    mutate(
      year = year,
      team = team,
      date = parse_date_time(substr(date, 6, nchar(date)), "%b %d, %Y"),
      away_game = if_else(away_game == "@", 1, 0)
    ) %>%
    return()
}

slow_clean_team_year <- purrr::slowly(f = clean_team_year, rate = rate_delay(1))

# Wrapper function that does all for a certain year
tot_year_info <- function(year) {
  slow_clean_team_year("MIL", year) %>%
    slow_get_final_standings() %>%
    slow_get_giannis() %>%
    relocate(year) %>%
    return()
}

slow_tot_year_info <- purrr::slowly(f = tot_year_info, rate = rate_delay(1))


########### Actually Scrape the Data ###############

df_vector <- vector(mode = "list", length = length(2014:2021))
for (i in 1:length(2014:2021)) {
  df_vector[[i]] <- slow_tot_year_info(2013 + i)
}
bind_rows(df_vector) %>%
  write_csv("data/giannis_career.csv")
