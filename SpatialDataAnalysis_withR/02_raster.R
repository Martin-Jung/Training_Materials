#' ---
#' title: "Raster data"
#' output: 
#'   html_document: 
#'     theme: yeti
#' ---
#' 

#' 
#' [<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](`r output`).  Download this file and open it (or copy-paste into a new script) with RStudio if you want to follow along.  
#' 
#' # Working with raster data
#' 
#' Raster data in R can be loaded in a relatively straight forward way using the **raster** package. There are other ways of loading raster data, including implementations in **sp**, where raster data can be formatted as 'SpatialPixelsDataFrame()'. 
#' 
#' The **raster** package is still the most widely used package though, although it is increasingly being replaced by an approach that is based on a tidy concept (separating raw data from metadata and spatial information). More on this later
#' 
#' First, lets load the raster package and some first prepared data. If the loading below does not work, download the tif <a href="ht_004_clipped.tif"> here</a> or from the repository
#' 
## -----------------------------------------------------------------------------
library(raster)

# The data to load is from Jung et al. (2020), https://www.nature.com/articles/s41597-020-00599-8
# I have prepared a subset for the Alpes to load in here. 
# These contain the fraction (multiplied with 1000) of a grid cell containing forest or arti at 1km. 

# We now load the forest layer from this object
ras <- raster('ht_004_clipped.tif',layer = 1)

class(ras)

# Note that the range of values is loaded by default to the minimum and maximum possible
# Reset like this
ras <- setMinMax(ras)
# -> range of values 1 - 1000

# Plot the raster data
plot(ras, col = topo.colors(100))


#' 
#' Here we loaded in the first band of the data as Raster object, but there are others (more about this below).
#' 
#' <div class="well">
#' Can you load in and plot the second band (artifical landscapes)?
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo1">Show Solution</button>
#' <div id="demo1" class="collapse">

#' 
#' </div>
#' </div>
#' 
#' ## Raster information
#' 
#' There are multiple functions to assess the metadata associated with a raster
#' 
## -----------------------------------------------------------------------------

# Plot the extent
extent(ras)

# How many rows and columns are there? How many cells
nrow(ras)
ncol(ras)
ncell(ras)

# We can also define a custom function to work with raster data information
# This one here converts the extent to a WKT bounding box object
bbox2wkt <- function(bbox=NULL){
  if(!is.null(bbox)) bbox <- c(bbox[1], bbox[3], bbox[2], bbox[4]) else stop('Provide a an extent object')
  stopifnot(length(bbox)==4) #check for 4 digits
  paste('POLYGON((', 
        sprintf('%s %s',bbox[1],bbox[2]), ',', sprintf('%s %s',bbox[3],bbox[2]), ',', 
        sprintf('%s %s',bbox[3],bbox[4]), ',', sprintf('%s %s',bbox[1],bbox[4]), ',', 
        sprintf('%s %s',bbox[1],bbox[2]), 
        '))', sep="")
}
# Print the extent in WKT format
bbox2wkt(extent(ras))


#' 
#' <div class="well">
#' Now we want to know what the mean fraction of forest across the scene is?
#' To do so you first need to convert the units to fractions (0-1) and then calculate a mean using the function 'cellStats()'. 
#' Check the help to see how to use this function via `?cellStats`
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo2">Show Solution</button>
#' <div id="demo2" class="collapse">

#' 
#' </div>
#' </div>
#' 
#' ## Convert rasters to other formats
#' 
#' In essence raster files are just large matrices, thus it is relatively straight forward to convert the raster object to other common r data formats
#' 
## ---- eval = FALSE------------------------------------------------------------
## # One can access all raster data like this
## ras[] # Careful, large file!
## 
## # or all coordinates
## coordinates(ras)
## 
## # Convert to matrix
## mat <- as.matrix(ras)
## 
## # Or to data.frame. Here we set the option xy to TRUE, which saves the coordinates of each cell as well
## df <- as.data.frame(ras,xy = TRUE)
## 

#' 
#' 
#' Similarly the raster data can be manipulated by accessing the raw data
#' 
## -----------------------------------------------------------------------------
# For instance, suppose we want to set all cells with values lower than 500 (50%) to NA (No data)
# CAREFUL: This overwrites the original data in R!
ras[ras < 500] <- NA

# Plot
plot(ras)

#' 
#' 
#' ## Writing rasters
#' 
#' Finally we going to write the output as new raster
#' 
## -----------------------------------------------------------------------------
# What is the data type of the raster?
dataType(ras)
# The output data type decides how you can save the raster most space efficiently.
# If you have for instance an integer raster, then it is a waste of space saving it with floating point precision.

# Here is a list of all output formats your system supports via the gdal library
knitr::kable(writeFormats() )

#' 
#' <div class="well">
#' Can you save the ras object as new file ? The function is called 'writeRaster'
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo3">Show Solution</button>
#' <div id="demo3" class="collapse">

#' 
#' </div>
#' </div>
#' 
#' 
#' # Multidimensional rasters
#' 
#' Above we have overwritten the original data object. You might have also noticed that the provided raster file contains two bands, one forest and one for artifical landscapes
#' Let's load it back again, but this time as multidimensional raster **stack**
#' 
#' 
## -----------------------------------------------------------------------------
library(raster)
ras <- stack('ht_004_clipped.tif')

# Notice the difference in class
class(ras)

# When plotted, by default all layers are shown
plot(ras)


#' 
#' 
#' However quite often these stacks are provided in formats that require other wrapper packages. I have saved the above file also in NetCDF (Network Common Data Form) format (https://en.wikipedia.org/wiki/NetCDF), which is a self-describing data format that supports for instance metadata.
#' 
#' Generally these data are a convenient format to store spatial-temporal information or other spatial data with more than two axes (for instance depth or height in addition to coordinates).
#' The file can be found <a href="ht_004_clipped.nc"> here</a>. 
#' 
## -----------------------------------------------------------------------------
library(ncdf4)
# When the ncdf4 package is installed, nc files should be loadable directly with raster
# (might spit out a few warnings though)
ras <- raster('ht_004_clipped.nc')

# Another way to open these files are the functions from the ncdf4 package
ras <- nc_open('ht_004_clipped.nc')

# This format looks a bit different
# Notice how there are variables, dimensions and global attributes
ras

#' 
#' What we going to do now is to save an attribute directly to the file, that specifies the type of data contained in the file.
#' 
## ---- eval = FALSE------------------------------------------------------------
## # Description
## desc <- 'This file contains data on forested and artifical habitats'
## 
## # Reopen the file in write mode
## ras <- nc_open('ht_004_clipped.nc',write = TRUE)
## # We are writing a global attribute with the description of the file
## ncatt_put(nc = ras,varid = 0 ,attname = 'description',attval = desc)
## # And close
## nc_close(ras)
## 
## # Now load again to check that the description is there
## ras <- nc_open('ht_004_clipped.nc')
## ras

#' 
#' 
#' More data manipulation functions with this format can be found in the help files (?ncdf4).
#' 
#' ## Multidimensional rasters with stars
#' 
#' The raster package can be slow, especially if your files are large. Splitting them up in tiles is usually a good idea for processing. There is an upcoming replacement package called [terra](https://github.com/rspatial/terra) that aims to implement most raster packages functions in faster, more efficient code.
#' 
#' Another new package of loading and analysing multidimensional data is the [**stars** package](https://r-spatial.github.io/stars/). This new package specifically aims at processing multidimensional rasters and works with netCDF files too.
#' 
## -----------------------------------------------------------------------------
library(stars)

# Load in the ncdf or tif file
ras <- read_stars('ht_004_clipped.tif')

ras

plot(ras,
     downsample = TRUE # Show only as many colours as fit in the pixel size of the image
     )

#' 
#' Another very useful feature of **stars** is that it allows to read in lazy object. This is particularly useful for very large files. The object can be created and investigated even without loading all data into memory. Only if any calculation requires the data stored within the **stars** object, it is loaded into memory. 
#' 
#' 
## -----------------------------------------------------------------------------
ras <- read_stars('ht_004_clipped.tif',proxy = TRUE)

# There are also ways to load in for instance only a specific area (bbox) or range of the data into R.

#' 
#' 
#' If you are familiar with the methods of the **tidyverse** family of packages:
#' **Stars** objects interact with a number of functions from these package. For instance, here is how I would select the top 100 cell values (e.g. those from left to right) from the stars object for band 1 (Forest) and plot it
#' 
## -----------------------------------------------------------------------------
suppressPackageStartupMessages(library(tidyverse))
# Take the raster object and 'pipe' into slice for the y-coordinate (Latitude)
ras %>% slice(y, 1:100) %>% 
  # Filter to band 1
  filter(band == 1) %>% 
  # Plot the output of the chain
  plot()

# Note that nothing is saved as part of this processing chain, although one obviously could save the output in a new object.

# Equally one access the attributes and dimensions of any stars object
# The first arguement to any stars object is the attribute (could be time), the next the dimensions
# For instance if I want to plot the first 20 values (upper left corner), here is how
plot(ras[,1:10,1:20])


#' 
#' See here for a number of functions provided by the stars package. Some of which we will explore later on. 
#' (Can you find the function that lets you write a stars file?)
#' 
## -----------------------------------------------------------------------------
# All functions of the stars package
methods(class = "stars")

#' 
#' <div class="well">
#' Final exercise:
#' Remember the outline of Laxenburg park that was saved in the [vector](01_vector.html) exercise? 
#' Take the artifical dataset loaded via stars and clip it to the bounding box of the Laxenburg park!
#' 
#' <button data-toggle="collapse" class="btn btn-primary btn-sm round" data-target="#demo4">Show Solution</button>
#' <div id="demo4" class="collapse">

#' 
#' 
#' </div>
#' </div>
#' 
#' Another big field of application for **stars** is the analysis of multi-temporal raster stacks or data-cubes. Custom-written function can then be easily applied to entire stacks of rasters, e.g. `stars::st_apply()`. We don't explore this as part of this tutorial, but have a look at the **stars** website for some example code.
#' 
#' 
#' <img src='https://raw.githubusercontent.com/r-spatial/stars/master/images/cube1.png'></img>
#' (source: https://r-spatial.github.io/stars/ )
