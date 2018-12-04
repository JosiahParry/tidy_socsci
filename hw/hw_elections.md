ML HW 1
================

Install `devtools` (developer tools). We will use this to download packages from GitHub.

``` r
install.packages("devtools")
```

Install the `socviz` package from GitHub.

``` r
devtools::install_github("kjhealy/socviz")
```

    ## Skipping install of 'socviz' from a github remote, the SHA1 (30fc6ec9) has not changed since last install.
    ##   Use `force = TRUE` to force installation

Note the above code. It is calling a function from a package without loading the entire package (`library(package)`). This is called calling the `namespace` (package name). The code looks inside the `devtools` package and uses the `install_github()` function. The function points to the `socviz` reospitory by `\@kjhealy`.

Load the `socviz` package and the `election` dataset.

``` r
library(socviz)
data("election")
```

HW:

-   Select the `st`, `total_vote`, `clinton_vote`, `trump_vote`, variables
-   Create two new variables `pct_trump` and `pct_clinton` as the percentage of the vote they won
-   Find the margin of victory for each state as an absolute value (always positive)
-   Create a new variable calle `winner` that indicates the candidate that won.
-   use an `ifelse` statement
-   create a barchart that shows the % clinton vote by state. Color by winner
-   Create a graph that shows only the states that hillary clinton won and show the margin of victory for each state.
-   Create a graph that shows only the states that hillary clinton lost by and show the margin of victory for trump as a percentage of the total vote.
