# README for statistical analyses and data visualization in Viceroy manuscript

## Statistical Analyses
+ Question: Should **year** or **date** be used for random effect? Current code uses the 
latter. Should the former (year) be more appropriate, it can be extracted via:

```
all.data$Year <- factor(substr(x = as.character(all.data$Collection.Date), 
                        start = nchar(as.character(all.data$Collection.Date)) - 1, 
                        stop = nchar(as.character(all.data$Collection.Date))))
```

+ Section: Species abundance across Florida
    + Topic: abundances
    + Method: We are using count data to predict count data; Poisson regression
    See: http://www.theanalysisfactor.com/generalized-linear-models-in-r-part-6-poisson-regression-count-variables/
        + Viceroys & willows in all sites - what are these tests?
        + Viceroy abundance ~ Queen abundance
            + Analysis script: analysis-queens-on-viceroy-abundance.R
            + Output file: output/analysis-results/queens-on-viceroy-abundance.txt
        + Queen abundance ~ twinevine abundance
            + Analysis script: analysis-twinevine-on-queen-abundance.R
            + Output file: output/analysis-results/twinevine-on-queen-abundance.txt
+ Section: Viceroy butterfly and larval host plant chemical defenses
    + Topic: chemistry
    + Method: Linear mixed-effect model (with site & year as random effects)
        + Viceroy non-volatile phenolics
            + Analysis script: analysis-queens-on-non-volatiles-viceroys.R
            + Output file: output/analysis-results/queens-on-non-volatiles-viceroys.txt
            + Models
                + Viceroy total (non-volatile) phenolics ~ Queen abundance
                + Viceroy salicin ~ Queen abundance
                + Viceroy salicortin ~ Queen abundance
                + Viceroy tremulacin ~ Queen abundance
        + Viceroy volatile phenolics
            + Analysis script: analysis-queens-on-volatiles-viceroys.R
            + Output file: output/analysis-results/queens-on-volatiles-viceroys.txt
            + Models
                + Viceroy total volatile phenolics ~ Queen abundance
                + Viceroy benzaldhyde ~ Queen abundance
                + Viceroy salicylaldehyde ~ Queen abundance
        + Willow non-volatile phenolics
            + Analysis script: analysis-queens-on-non-volatiles-willows.R
            + Output file: output/analysis-results/queens-on-non-volatiles-willows.txt
            + Models
                + Willow total (non-volatile) phenolics ~ Queen abundance
                + Willow salicin ~ Queen abundance
                + Willow salicortin ~ Queen abundance
                + Willow tremulacin ~ Queen abundance
+ Section: Predator behavioral responses to viceroy butterflies
    + Topic: palatability
    + Method: Linear mixed-effect model (with site & year as random effects)
        + Predator behavior
            + Analysis script: analysis-queens-on-palatability.R
            + Output file: output/analysis-results/queens-on-palatability.txt
            + Models
                + Aversion learning ~ Queen abundance
                + Memory retention ~ Queen abundance

## Figure list
+ Figure 1
    + Description: Abundance maps for insects (viceroys & queens) and their 
    respective host plants (willows & twinevine)
    + Code source: map-abundance.R
    + Shape: 2 x 2, insects as ~rows, plants as columns
        | Viceroy | Willow    |
        | Queen   | Twinevine |
    + Size: Half column width (full column width?)
    + Status: 
        + _Draft_ on OSF; created from single image svg output
        + svg/figure-1.svg
+ Figure 2
    + Description: Chemical defense (non- volatile) in viceroys and willows, 
    shown as both a map and an inset boxplot
    + Code source:
        + map-and-boxplot-viceroy-non-volatiles.R
        + map-and-boxplot-willow-non-volatiles.R
    + Shape: 4 x 2, chemicals as rows, source (viceroy or willow) as columns
    + Size: One column width (two column width?)
    + Status:
        + _Draft_ on OSF; hand-made from separate image files
        + svg/figure-2.svg
+ Figure 3
    + Description: Palatability of viceroys, shown as both a map and an inset 
    box plot
    + Code source: map-and-boxplot-palatability.R
    + Shape: 1 x 2
    + Size: One column width (two column width?)
    + Status:
        + _Draft_ on OSF; hand-made from separate image files
        + svg/figure-3.svg
+ Figure S1:
    + Description: Chemical defense (volatiles) in viceroys, shown as both a 
    map and an inset box plot
    + Code source: map-and-boxplot-viceroys-volatiles.R
    + Shape: 1 x 3
    + Size: Two column width
    + Status:
        + _Draft_ on OSF; hand-made from separate image files
        + svg/figure-S1.svg

--------------------------------------------------------------------------------
