install.packages('sp')
install.packages('rgdal')
install.packages('leaflet')

library(dplyr)
library(sp)
library(rgdal)
library(leaflet)
old <- setwd(tempdir())
dir.create(file.path("nybus"), showWarnings = FALSE)

# Download shapefile of bus routes
url <- "https://wfs.gc.cuny.edu/SRomalewski/MTA_GISdata/nycbusroutes_100401_tripheadinfo.zip"
download.file(url, "./nybus/nycbusroutes_100401_tripheadinfo.zip", quiet = TRUE, mode = "wb")
dir.create(file.path("nybus/nycbusroutes_100401_tripheadinfo"), showWarnings = FALSE)
unzip("./nybus/nycbusroutes_100401_tripheadinfo.zip", exdir="./nybus/nycbusroutes_100401_tripheadinfo")
dsn <- "nybus/nycbusroutes_100401_tripheadinfo"
bus.route <- readOGR(dsn=path.expand(dsn))
# これでCRSをbusstopと統一する。かつ、地図上に投影する。
bus.pj <- spTransform(bus.route, CRS("+proj=longlat +datum=WGS84"))

# Download shapfile of bus stops
url <- "https://wfs.gc.cuny.edu/SRomalewski/MTA_GISdata/nycbusstops_100401.zip"
download.file(url, "./nybus/nycbusstops_100401.zip", quiet = TRUE, mode = "wb")
dir.create(file.path("nybus/nycbusstops_100401"), showWarnings = FALSE)
unzip("./nybus/nycbusstops_100401.zip", exdir="./nybus/nycbusstops_100401")
dsn <- "nybus/nycbusstops_100401"
# read OGRはshape fileの読み込み。readshapeと違い、dbfやprjなどの付随するメタデータも一緒に読みこんでくれる。
bus.st <- readOGR(dsn=path.expand(dsn))
# これでCRSをbusrouteと統一する（WGS84に統一）。かつ、地図上に投影する。
bus.st.pj <- spTransform(bus.st, CRS("+proj=longlat +datum=WGS84"))

## resolve bus.pj@lines into list(Line.objs). One route may contain more than one lines
# @が下で使われてるのでtmpはspatial data frame
# readORGの結果の例を見てイメージをつかもう→readORGのoutputはsummaryで要約を観れるのでそれを見る
# summaryの結果、bus.pjはSpatialLinesDataFrame。plot(bus.pj)でbusのルートはすでにプロットできる（bus.st.pjも同様）

# geometryはattributeの要素を消して、geographicなcoordinatesのみを残してくれる。
# length(tmp)=733なので733本の線を引くということ？→違うなLine_listが3043だからそれだけ引く？
tmp <- geometry(bus.pj)
Line_list <- list()
for (i in 1:length(tmp)) {
  Line_list <- c(Line_list, tmp[i]@lines[[1]]@Lines)
}

####こっから

## Reconstruct SpatialLinesDataFrame if necessary
# Line_listに入ってる各バス路線の線（を示すcoordinates）に一つ一つIDを付与して、その後Spatial linesでSpatial natureを与える。
SL <- sapply(1:length(Line_list), function(x) Lines(Line_list[[x]], ID = x)) %>% 
  SpatialLines()

## make new ids (originalID_nth)
# get original ids
ori_id <- c()
for (i in 1:length(tmp)) {
  ori_id <- c(ori_id, tmp[i]@lines[[1]]@ID)
}
rm(tmp)

###ここまでいらない？

# SpatiallinesDataFrameからlineに直接アクセスできる
LinLS <- sapply(bus.pj@lines, function(x) length(x@Lines))  # how many Line.obj does each Lines.obj has
new_id <- sapply(1:length(LinLS), function(x) paste0(x, "_", seq.int(LinLS[[x]]))) %>% 
  unlist()

## make a new data.frame (only route_id)
df <- data.frame(route_id = rep(bus.pj@data$route_id, times = LinLS))
rownames(df) <- new_id

## integrate Line.objs, ids and a data.frame into SpatialLinesDataFrame.obj
SLDF <- mapply(function(x, y) Lines(x, ID = y), x = Line_list, y = new_id) %>% 
  SpatialLines() %>% SpatialLinesDataFrame(data = df)

leaflet() %>%
  setView(lng = -73.932667, lat = 40.717266, zoom = 11) %>%
  addPolylines(data = SLDF, color = "black", opacity = 1, weight = 1) %>% 
  addCircles(data=bus.st.pj@data,~stop_lon, ~stop_lat, color = "red", weight = 0.3) %>%
  addTiles()

setwd(old)
