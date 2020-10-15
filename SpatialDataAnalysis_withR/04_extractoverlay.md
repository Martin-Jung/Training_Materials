---
title: "Extractions and overlays"
output: 
  html_document: 
    theme: yeti
---



[<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](04_extractoverlay.R).  Download this file and open it (or copy-paste into a new script) with RStudio if you want to follow along.  

# Raster extractions

Data extractions are quite common GIS tasks both for vector and raster data. Here the raster package support a number of functions to extract values from another or different data sources (vector files).

It is possible to extract data directly from a raster file

```r
library(raster)

# Get the forest cover
ras <- raster('ht_004_clipped.tif', 1)
ras <- setMinMax(ras)

# The value in the upper left corner
ras[1,1]

# Take 10 point values at random
sampleRandom(ras, 10)

# Or regularly spaced
sampleRegular(ras, 10 )

# or stratefied in case you have zones 
# sampleStratified()
```

Note that the **sf** package has similar methods, see `st_sample()`

Another common application are 'zonal' statistics, so where one raster layer provides the target estimates to be extracted and another specific zones for which the values are requested.


```r
# Load both forest and artifical land cover data
forest <- raster('ht_004_clipped.tif',1)
artif <- raster('ht_004_clipped.tif',2)

# Create a zone based on artifical coverage
# E.g. values below 50% get 1 and above get 2
artif <- reclassify(artif, c(0,500,1,
                             500,1000,2)
                    )
# Check that both have the same extent and resolution, otherwise need to rescale
compareRaster(forest,artif)
```

```
## [1] TRUE
```

```r
# Now calculate for both zones the mean fraction of forest within them 
zonal(forest, artif, fun = 'mean')
```

```
##      zone     mean
## [1,]    1 633.9627
## [2,]    2 143.4728
```

Considerable more common however is the extraction of rasterdata within a given polygon or point


```r
# Artifical
ras <- raster('ht_004_clipped.tif',2)
# Load Laxenburg shape
laxpol <- st_read('Laxenburg.gpkg')
```

```
## Reading layer `Laxenburg' from data source `C:\Users\Martin\IIASA\Talks\20201022_ESMtraining\CDAT_Materials\SpatialDataAnalysis_withR\Laxenburg.gpkg' using driver `GPKG'
## Simple feature collection with 1 feature and 2 fields
## geometry type:  POLYGON
## dimension:      XY
## bbox:           xmin: 16.35322 ymin: 48.05182 xmax: 16.38144 ymax: 48.07108
## geographic CRS: WGS 84
```

```r
ex <- extract(ras, laxpol, fun = mean)
ex
```

```
##          [,1]
## [1,] 530.3333
```

```r
# Another useful way for extracting values is to first clip and mask the input raster
# Often this can be considerably faster speedwise
# First crop
ras <- crop(ras, laxpol)
# Then mask
ras <- mask(ras, laxpol)
# Note the options for masking though (?mask)

# Now we simply get all values and calculate the mean directly
mean( values(ras) , na.rm = T)
```

```
## [1] 530.3333
```


## Even faster extractions

There are other packages such as ´velox´ or ´exactextractr´ that support even faster extraction of raster data.
Here we extract the coverage fraction of each


```r
library(sf)
library(raster)
library(exactextractr)
# Load Forest
ras <- raster('ht_004_clipped.tif', 1)

# Load Laxenburg polygon
laxpol <- st_read('Laxenburg.gpkg')
```

```
## Reading layer `Laxenburg' from data source `C:\Users\Martin\IIASA\Talks\20201022_ESMtraining\CDAT_Materials\SpatialDataAnalysis_withR\Laxenburg.gpkg' using driver `GPKG'
## Simple feature collection with 1 feature and 2 fields
## geometry type:  POLYGON
## dimension:      XY
## bbox:           xmin: 16.35322 ymin: 48.05182 xmax: 16.38144 ymax: 48.07108
## geographic CRS: WGS 84
```

```r
# The coverage fraction of each value
frac  <- exact_extract(ras, laxpol)[[1]]
frac
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["value"],"name":[1],"type":["int"],"align":["right"]},{"label":["coverage_fraction"],"name":[2],"type":["dbl"],"align":["right"]}],"data":[{"1":"1","2":"0.18493184","_rn_":"2"},{"1":"3","2":"0.30571020","_rn_":"3"},{"1":"57","2":"0.29263368","_rn_":"4"},{"1":"NA","2":"0.01929993","_rn_":"5"},{"1":"332","2":"0.88389969","_rn_":"6"},{"1":"859","2":"0.82368040","_rn_":"7"},{"1":"428","2":"0.11912980","_rn_":"8"},{"1":"115","2":"0.10292924","_rn_":"10"},{"1":"407","2":"0.04447726","_rn_":"11"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
# Or alternatively summarize a mean
exact_extract(ras, laxpol, fun = 'mean')
```

```
## [1] 398.8206
```

