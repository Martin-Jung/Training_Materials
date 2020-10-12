---
title: " Raster data"
output: 
  html_document: 
    theme: yeti
---



[<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](02_raster.R).  Download this file and open it (or copy-paste into a new script) with RStudio if you want to follow along.  

# Working with raster data

Raster data in R can be loaded in a relatively straight forward way using the **raster** package. There are other ways of loading raster data, including implementations in **sp**, where raster data can be formatted as 'SpatialPixelsDataFrame()'. 

The **raster** package is still the most widely used package though, although it is increasingly being replaced by an approach that is based on a tidy concept (separating raw data from metadata and spatial information). More on this later

First, lets load the raster package and some first data


```r
library(raster)

# The data to load is from Jung et al. (2020), https://www.nature.com/articles/s41597-020-00599-8
# I have prepared a subset for the Alpes to load in here. 
# These contain the fraction (multiplied with 1000) of a grid cell containing forest or arti at 1km. 

# We now load the forest layer from this object
ras <- raster('ht_004_clipped.tif',layer = 1)

class(ras)
```

```
## [1] "RasterLayer"
## attr(,"package")
## [1] "raster"
```

```r
# Plot the raster data
plot(ras, col = topo.colors(100))
```

![](02_raster_files/figure-html/unnamed-chunk-2-1.png)<!-- -->

Here we loaded in the first band of the data as Raster object, but there are others (more about this in [multidimensional](multidim.html)).

<div class="well">
Can you load in and plot the second band (artifical landscapes)?

<button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo1">Show Solution</button>
<div id="demo1" class="collapse">

```r
ras_crop <- raster('ht_004_clipped.tif',layer = 2)

plot(ras, col = heat.colors(100))
```

![](02_raster_files/figure-html/unnamed-chunk-3-1.png)<!-- -->

</div>
</div>

