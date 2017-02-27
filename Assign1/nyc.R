install.packages("sparklyr")
spark_install(version = "1.6.2")

devtools::install_github("rstudio/sparklyr")



# 例

iris_tbl <- copy_to(sc, iris, "iris", overwrite = TRUE) 

# 以下の二つはどちらでもちゃんと動く
install.packages("titanic")
library(titanic)
write.csv(titanic_train, file="/Users/susu/Desktop/Hong\ Kong/Semester2/Big_Data/assignment_data/as1/titanic.csv", row.names=FALSE)

titanic <- read_csv("/Users/susu/Desktop/Hong\ Kong/Semester2/Big_Data/assignment_data/as1/titanic.csv")
titanic_tbl <- copy_to(sc, titanic, "titanic", overwrite = TRUE)

spark_read_csv(sc, name="titanic_local", path="/Users/susu/Desktop/Hong\ Kong/Semester2/Big_Data/assignment_data/as1/titanic.csv", header=TRUE)
