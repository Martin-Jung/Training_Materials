---
title: "Installing necesary packages"
output: 
  html_document: 
    theme: yeti
---

To work with spatial data in R, you have to have a number of packages installed. Packages are the main way in R to distribute and run other peoples code.
For this tutorial to work you need to sucessfully (e.g. without any errors) install the following packages:


```r
install.packages('sp') # Basic spatial vector data
install.packages('rgdal') # Interface to the gdal library in R
install.packages('raster') # To load raster data in R
install.packages('sf') # The sucessor to the sp package - tidy vector data
install.packages('stars') # The sucessor to the raster package - tidy raster data
install.packages('ncmeta') # Required for stars ncdf support
install.packages('ncdf4') # For loading the propertiary ncdf format

install.packages('rgeos') # Wrapper for the GEOS library
install.packages('velox') # Fast extraction from raster data 
install.packages('exactextractr') # Fast extraction from raster data 
install.packages('gdalUtils') # A wrapper for accessing the gdal tools within R 
install.packages('remotes') # For installing package not available on CRAN, but github only
remotes::install_github("paleolimbot/qgisprocess") # A wrapper for accessing qgis functions within R (requires QGIS to be installed)

install.packages('mapview') # For intactive spatial visualizations
install.packages('tmap') # For thematic map visualizations
install.packages('cartography') # For thematic map visualizations
```

If one or two of the package installations fail, then copy the error description and search for it using your search engine of choice.
