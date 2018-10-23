# Variation in model abundance drives a mimicry continuum
## Statistical analyses and data visualization

Code for analyzing and visualizing chemical defenses in viceroy butterflies.

### Dependencies
+ lmerTest
+ plyr
+ rgdal
+ ggplot2
+ gstat
+ raster
+ sp
+ RColorBrewer

Note all these additional packages can be installed by running the script `scripts/setup.R`.

### Structure
+ `data`: tab-delimited data files for analysis
    + `shapefiles`: shapefiles used for geographic visualization
+ `functions`: generic R functions for analysis and visualization
+ (`output`): not under version control, but assumed as destination for output 
files; created by running `scripts/setup.R`
+ `scripts`
    + `analysis`: linear analysis R code
    + `data-processing`: pre-processing data, such as converting date formats
    + `visualization`: data and analysis visualization R code
+ `svg`: figure SVG files

### Descriptions of statistical analyses
+ **Species abundance across Florida**
    + Response: abundance
    + Method: count data to predict count data; Poisson regression See: http://www.theanalysisfactor.com/generalized-linear-models-in-r-part-6-poisson-regression-count-variables/
        + Queen abundance on viceroy abundance
            + Model: Viceroy abundance ~ Queen abundance
            + Analysis script: scripts/analysis/analysis-queens-on-viceroy-abundance.R
            + Output file: output/analysis-results/queens-on-viceroy-abundance.txt
        + Twinevine abundance on viceroy abundance
            + Model: Queen abundance ~ twinevine abundance
            + Analysis script: scripts/analysis/analysis-twinevine-on-queen-abundance.R
            + Output file: output/analysis-results/twinevine-on-queen-abundance.txt
+ **Viceroy butterfly and larval host plant chemical defenses**
    + Response: chemistry
    + Method: Linear mixed-effect model (with site & year as random effects)
        + Queen abundance on viceroy _non-volatile_ phenolics
            + Models
                + Viceroy total (non-volatile) phenolics ~ Queen abundance
                + Viceroy salicin ~ Queen abundance
                + Viceroy salicortin ~ Queen abundance
                + Viceroy tremulacin ~ Queen abundance
            + Analysis script: scripts/analysis/analysis-queens-on-non-volatiles-viceroys.R
            + Output file: output/analysis-results/queens-on-non-volatiles-viceroys.txt
        + Queen abundance on viceroy _volatile_ phenolics
            + Models
                + Viceroy total volatile phenolics ~ Queen abundance
                + Viceroy benzaldhyde ~ Queen abundance
                + Viceroy salicylaldehyde ~ Queen abundance
            + Analysis script: scripts/analysis/analysis-queens-on-volatiles-viceroys.R
            + Output file: output/analysis-results/queens-on-volatiles-viceroys.txt
        + Queen abundance on willow _non-volatile_ phenolics
            + Models
                + Willow total (non-volatile) phenolics ~ Queen abundance
                + Willow salicin ~ Queen abundance
                + Willow salicortin ~ Queen abundance
                + Willow tremulacin ~ Queen abundance
            + Analysis script: scripts/analysis/analysis-queens-on-non-volatiles-willows.R
            + Output file: output/analysis-results/queens-on-non-volatiles-willows.txt
        + Twinevine abundance on viceroy _volatile_ and _non-volatile_ phenolics
            + Models
                + Viceroy total (non-volatile) phenolics ~ twinevine abundance
                + Viceroy salicin ~ twinevine abundance
                + Viceroy salicortin ~ twinevine abundance
                + Viceroy tremulacin ~ twinevine abundance
                + Viceroy total volatile phenolics ~ twinevine abundance
                + Viceroy benzaldhyde ~ twinevine abundance
                + Viceroy salicylaldehyde ~ twinevine abundance
            + Analysis script: scripts/analysis/analysis-twinevine-on-viceroy-phenolics.R
            + Output file: output/analysis-results/twinevine-on-non-viceroy-phenolics.txt
        + Willow non-volatiles on viceroy _non-volatile_ phenolics
            + Models
                + Viceroy total (non-volatile) phenolics ~ willow total (non-volatile) phenolics
                + Viceroy salicin ~ willow salicin
                + Viceroy salicortin ~ willow salicortin
                + Viceroy tremulacin ~ willow tremulacin
            + Analysis script: scripts/analysis/analysis-willows-on-non-volatiles-viceroys.R
            + Output file: output/analysis-results/willows-on-non-volatiles-viceroys.txt
            + Note: There were two willows sampled per date. Predictor for a date is the average value of the willow compound for that date.
+ **Predator behavioral responses to viceroy butterflies**
    + Response: palatability
    + Method: Linear mixed-effect model (with site & year as random effects)
        + Queen abundance on predator behavior
            + Models
                + Aversion learning ~ Queen abundance
                + Memory retention ~ Queen abundance
            + Analysis script: scripts/analysis/analysis-queens-on-palatability.R
            + Output file: output/analysis-results/queens-on-palatability.txt
+ **Categorization of sites based on queen abundance**
    + Method: K-means clustering of sampling locations based solely on queen abundance, where _K_ is selected via elbow method
        + Analysis script: scripts/analysis/analysis-kmeans-queen-abundance.R
        + Output files:
            + output/visualization/k-means-queens.pdf
            + output/analysis-results/k-means-queens.txt

### Figure list
Note most of the code sources provide incomplete graphical objects that were further edited in [Inkscape](https://inkscape.org/en/).

+ Figure
    + Description: Abundance maps for insects (viceroys & queens) and their 
    respective host plants (willows & twinevine)
    + Code source: scripts/visualization/map-abundance.R
    + Shape: 2 x 2
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
