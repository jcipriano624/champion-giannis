# Giannis and the Bucks: NBA Champions

## Project Introduction

This was a project I completed as a part of my coursework for a UChicago course I participated in in the Summer of 2021. We were given the open ended assignment of completing some sort of rudimentary analysis on a data set that we had retrieved using web scraping or an API. At the time of the assignment, Giannis Antetokounmpo had just won his first NBA Championship as part of the Milwaukee Bucks. I decided to celebrate their accomplishment by using data acccessed via [Basketball-Reference.com](https://www.basketball-reference.com/) to analyze Giannis' career up to that point and the team's overall growth since he had been drafted back in 2014. This project gave me experience working with package that operate as interfaces for APIs and the problems that arise when that package is slightly out of date and/or missing a few key features. 

## Links to Files

[Giannis and the Bucks RMarkdown](https://github.com/jcipriano624/hw08/blob/main/bball_ref.Rmd)

[Giannis and the Bucks Knit Markdown](https://github.com/jcipriano624/hw08/blob/main/bball_ref.md)

## Reproducibility

All relevant outputs are available in the repository. In case these files are ever unavailable or you would like to change something and run the output again, here is the order what you should do and what files should be run from in what order

1. **Run get_giannis_career.R**
  - This scrapes Basketball Reference for every game that the bucks have played in since Giannis was drafted back in 2014. This also compiles the year long statistics for Giannis and the team for the year that game was played in.
2. **Run RMarkdown Document**
  - This produces a github document that you can use to read my analysis and observe my visualizations.


## Libraries to Install

1. `devtools`: This package is necessary to be able to install the package that interfaces with the Basketball reference API. You can simply use the standard CRAN method of installing packages (`install.packages("devtools")`) which I have provided at the top of the Markdown document. Simply uncomment the code and run.
1. `ballr`: This is the package developed that allows us to interface with the API for the website [Basketball Reference](https://www.basketball-reference.com/). Using the devtools package, we download the package from github using `install_github("rtelmore/ballr")` and then we can load it like any other library. All code for doing this is commented out in the setup chunk of both the R script and the RMarkdown file. More info available on [the github page for the package](https://github.com/rtelmore/ballr). **Note:** When I downloaded this package for the first time and tried to use it, it gave me a lazy load error. If that happens, just restart R and it should work.
