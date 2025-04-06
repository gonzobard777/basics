# Python

## Продукты OSGeo

### Установка

[OSGeo4W](https://trac.osgeo.org/osgeo4w/). Установит сразу: QGIS, GDAL, PROJ и еще много других своих проектов.  
Но разрабоатывать на питоне с использованием функционала OSGeo это не особо поможет.  
Поэтому устанавливаем [Anaconda](https://www.anaconda.com/), согласно одной из рекомендаций отсюда [Installing GDAL with Python on Windows](https://gis.stackexchange.com/questions/2276/installing-gdal-with-python-on-windows).  
А потом [конфигурируем окружение Pycharm на использование Anaconda](https://www.anaconda.com/docs/tools/working-with-conda/ide-tutorials/pycharm) и, наконец, подключаем GDAL как зависимость в свой Python-проект.

### Примеры работы

[Примеры использования инструментов GDAL](https://wiki.gis-lab.info/w/%D0%9F%D1%80%D0%B8%D0%BC%D0%B5%D1%80%D1%8B_%D0%B8%D1%81%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D0%BD%D0%B8%D1%8F_%D0%B8%D0%BD%D1%81%D1%82%D1%80%D1%83%D0%BC%D0%B5%D0%BD%D1%82%D0%BE%D0%B2_GDAL)

`gdalinfo -mm test.tif` - посмотреть метаданные в geotiff-файле

**Репрожект в меркатор**  
`gdalwarp -overwrite -t_srs EPSG:3857 -of GTiff source.tif target.tif`

[**Axisswap**](https://proj.org/en/9.3/operations/conversions/axisswap.html)  
`gdalwarp -overwrite -ct "+proj=pipeline +step +proj=axisswap +order=1,2" -of GTiff source.tif target.tif`  
либо у проекции geos есть свойство sweep:  
`gdalwarp -overwrite -ct "+proj=pipeline +step +sweep=x" -of GTiff source.tif target.tif`

**PROJ**  
[Mercator](https://proj.org/en/stable/operations/projections/merc.html)  
[Stereographic](https://proj.org/en/stable/operations/projections/stere.html)  
[Geostationary Satellite](https://proj.org/en/stable/operations/projections/geos.html)  
MSG IODC  
`+proj=geos +lon_0=45.5 +h=35785831 +x_0=0 +y_0=0 +a=6378169 +rf=295.488065897014 +units=m +no_defs +type=crs`  
Himawari  
`+proj=geos +lon_0=140.7 +h=35785831 +x_0=0 +y_0=0 +a=6378169 +rf=295.488065897001 +units=m +no_defs`

Цепочка репрожекта - [Computation of coordinate operations between two CRS](https://proj.org/en/stable/operations/operations_computation.html)  
`projinfo -s From -t EPSG:3857 -o PROJ`

Cartographic projection  
https://proj.org/en/stable/usage/projections.html

Ellipsoids  
https://proj.org/en/stable/usage/ellipsoids.html

[World Geodetic System - WGS_84](https://en.wikipedia.org/wiki/World_Geodetic_System#WGS_84)  
a=6378137.0 метров, semi-major axis  
b=6356752.3 метров, semi-minor axis    
R=6371008.8 метров, сфера

Список эллипсов: Имя и параметры  
`proj -le`

Список проекций: Имя и расшифровка  
`proj -l`  
