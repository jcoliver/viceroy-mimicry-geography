# Variation in model abundance drives a mimicry continuum
## Statistical analyses and data visualization

Code for analyzing and visualizing chemical defenses in viceroy butterflies.

## TODO
+ Add dependencies to this README
+ Add setup script for dependencies and output structure
+ Add asterisks for significant differences in boxplot

### Structure
+ `data`: tab-delimited data files for analysis
    + `shapefiles`: shapefiles used for geographic visualization
+ `functions`: generic R functions for analysis and visualization
+ (`output`): not under version control, but assumed as destination for output 
files
+ `scripts`
    + `analysis`: linear analysis R code
    + `data-processing`: pre-processing data, such as converting date formats
    + `visualization`: data and analysis visualization R code
+ `svg`: figure SVG files

### Description
+ Section: Species abundance across Florida
    + Response: abundances
    + Method: count data to predict count data; Poisson regression See: http://www.theanalysisfactor.com/generalized-linear-models-in-r-part-6-poisson-regression-count-variables/
        + Viceroy abundance ~ Queen abundance
            + Analysis script: scripts/analysis/analysis-queens-on-viceroy-abundance.R
            + Output file: output/analysis-results/queens-on-viceroy-abundance.txt
        + Queen abundance ~ twinevine abundance
            + Analysis script: scripts/analysis/analysis-twinevine-on-queen-abundance.R
            + Output file: output/analysis-results/twinevine-on-queen-abundance.txt
+ Section: Viceroy butterfly and larval host plant chemical defenses
    + Response: chemistry
    + Method: Linear mixed-effect model (with site & year as random effects)
        + Queen abundance on **viceroy non-volatile phenolics**
            + Analysis script: scripts/analysis/analysis-queens-on-non-volatiles-viceroys.R
            + Output file: output/analysis-results/queens-on-non-volatiles-viceroys.txt
            + Models
                + Viceroy total (non-volatile) phenolics ~ Queen abundance
                + Viceroy salicin ~ Queen abundance
                + Viceroy salicortin ~ Queen abundance
                + Viceroy tremulacin ~ Queen abundance
        + Queen abundance on **viceroy volatile phenolics**
            + Analysis script: scripts/analysis/analysis-queens-on-volatiles-viceroys.R
            + Output file: output/analysis-results/queens-on-volatiles-viceroys.txt
            + Models
                + Viceroy total volatile phenolics ~ Queen abundance
                + Viceroy benzaldhyde ~ Queen abundance
                + Viceroy salicylaldehyde ~ Queen abundance
        + Queen abundance on **willow non-volatile phenolics**
            + Analysis script: scripts/analysis/analysis-queens-on-non-volatiles-willows.R
            + Output file: output/analysis-results/queens-on-non-volatiles-willows.txt
            + Models
                + Willow total (non-volatile) phenolics ~ Queen abundance
                + Willow salicin ~ Queen abundance
                + Willow salicortin ~ Queen abundance
                + Willow tremulacin ~ Queen abundance
        + Twinevine abundance on **viceroy volatile and non-volatile phenolics**
            + Analysis script: scripts/analysis/analysis-twinevine-on-viceroy-phenolics.R
            + Output file: output/analysis-results/twinevine-on-non-viceroy-phenolics.txt
            + Models
                + Viceroy total (non-volatile) phenolics ~ twinevine abundance
                + Viceroy salicin ~ twinevine abundance
                + Viceroy salicortin ~ twinevine abundance
                + Viceroy tremulacin ~ twinevine abundance
                + Viceroy total volatile phenolics ~ twinevine abundance
                + Viceroy benzaldhyde ~ twinevine abundance
                + Viceroy salicylaldehyde ~ twinevine abundance
        + Willow non-volatiles on **viceroy non-volatile phenolics**
            + Analysis script: scripts/analysis/analysis-willows-on-non-volatiles-viceroys.R
            + Output file: output/analysis-results/willows-on-non-volatiles-viceroys.txt
            + Note: There were two willows sampled per date. Predictor for a date is the 
            average value of the willow compound for that date.
            + Models
                + Viceroy total (non-volatile) phenolics ~ willow total (non-volatile) phenolics
                + Viceroy salicin ~ willow salicin
                + Viceroy salicortin ~ willow salicortin
                + Viceroy tremulacin ~ willow tremulacin
+ Section: Predator behavioral responses to viceroy butterflies
    + Topic: palatability
    + Method: Linear mixed-effect model (with site & year as random effects)
        + Queen abundance on **predator behavior**
            + Analysis script: scripts/analysis/analysis-queens-on-palatability.R
            + Output file: output/analysis-results/queens-on-palatability.txt
            + Models
                + Aversion learning ~ Queen abundance
                + Memory retention ~ Queen abundance

### Figure list
+ Figure 1
    + Description: Abundance maps for insects (viceroys & queens) and their 
    respective host plants (willows & twinevine)
    + Code source: scripts/visualization/map-abundance.R
    + Shape: 2 x 2:
        | Viceroy | Willow    |
        | Queen   | Twinevine |
    + Size: Half column width
    + Location: svg/figure-1.svg
+ Figure 2
    + Description: Chemical defense (non- volatile) in viceroys and willows, 
    shown as both a map and an inset boxplot
    + Code source:
        + scripts/visualization/map-and-boxplot-viceroy-non-volatiles.R
        + scripts/visualization/map-and-boxplot-willow-non-volatiles.R
    + Shape: 4 x 2
    + Size: One column width
    + Location: svg/figure-2.svg
+ Figure 3
    + Description: Palatability of viceroys, shown as both a map and an inset 
    box plot
    + Code source: scripts/visualization/map-and-boxplot-palatability.R
    + Shape: 1 x 2
    + Size: One column width (two column width?)
    + Location: svg/figure-3.svg
+ Figure ED1:
    + Description: Chemical defense (volatiles) in viceroys, shown as both a 
    map and an inset box plot
    + Code source: scripts/visualization/map-and-boxplot-viceroys-volatiles.R
    + Shape: 1 x 3
    + Size: Two column width
    + Location: svg/figure-ED1.svg

