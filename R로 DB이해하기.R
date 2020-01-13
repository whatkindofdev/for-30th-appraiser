install.packages("RSQLite") #R에서 SQLite 인터페이스 제공
install.packages("DBI") #R에서 DB와의 연결을 돕는 표준화된 인터페이스 함수를 제공
library(RSQLite, DBI) 
library(stringi,dplyr)

cat('\014')
rm(list = ls())

##SETTING
getwd() #[1] "C:/Users/Choi_Woohyun/Desktop"
dir.create("data") 
con = dbConnect(SQLite(), dbname = "data/SQLiteDB.sqlite") #DB file
dbDisconnect(con)



#Table 생성
con = dbConnect(SQLite(), dbname = "data/SQLiteDB.sqlite") #DB file
dbWriteTable(con, "iris", iris)
dbWriteTable(con, "cars", cars)
dbListTables(con)
dbRemoveTable(con, "cars")
dbListTables(con)
dbRemoveTable(con, "iris")
dbListTables(con)


#실습
iris_mydata = iris
names(iris_mydata) = c("sepal_length", "sepal_width", "petal_length", "petal_width", "species")
dbExistsTable(con, "iris_mydata")
result = dbSendQuery(con,                                   #dbSendQuery는 입력/수정/삭제 용도
                     "CREATE TABLE IF NOT EXISTS iris_mydata
                     (irisID INTEGER PRIMARY KEY AUTOINCREMENT,  
                     sepal_length NUMERIC,
                     sepal_width NUMERIC,
                     petal_length NUMERIC,
                     petal_width NUMERIC,
                     species TEXT)")
dbClearResult(result) #dbSendQuery-dbClearResult는 반드시 커플.
dbExistsTable(con, "iris_mydata")


#Table에서 데이터 검색(데이터를 가져오기까지)
sample_iris = dbGetQuery(con, "SELECT * FROM iris_mydata")
dim(sample_iris)
sample_iris = dbGetQuery(con, "SELECT * FROM iris_mydata WHERE species = 'verginica'")
dim(sample_iris)

#Table에 데이터(instance) 1행 넣기
result = dbSendQuery(con, 
                    "INSERT INTO iris_mydata
                    (sepal_length, sepal_width, petal_length, petal_width, species)
                    VALUES
                    (\'5.1\',
                    \'3.5\',
                    \'1.4\',
                    \'0.2\',
                    \'setosa\')")
dbClearResult(result)
sample_iris = dbGetQuery(con, "SELECT * FROM iris_mydata")
dim(sample_iris)


#Table에 데이터(instance) 한 번에 여러 행 넣기
dbWriteTable(con, "iris_mydata", iris_mydata, row.names = FALSE, append = TRUE)
sample_iris = dbGetQuery(con, "SELECT * FROM iris_mydata")
dim(sample_iris)

#Table에 있는 데이터 수정
sample_virginica = dbGetQuery(con, "SELECT * FROM iris_mydata WHERE species = 'virginica'")
dim(sample_virginica)
result = dbSendQuery(con, "UPDATE iris_mydata SET species = 'versicolor' WHERE species = 'virginica'")
dbClearResult(result)

sample_virginica = dbGetQuery(con, "SELECT * FROM iris_mydata WHERE species = 'virginica'")
dim(sample_virginica) #0 6
sample_versicolor = dbGetQuery(con, "SELECT * FROM iris_mydata WHERE species = 'versicolor'")
dim(sample_versicolor)

#Table에 있는 데이터 삭제
result = dbSendQuery(con, "DELETE FROM iris_mydata WHERE species = 'versicolor'")
dbClearResult(result)

sample_versicolor = dbGetQuery(con, "SELECT * FROM iris_mydata WHERE species = 'versicolor'")
dim(sample_versicolor)

sample_iris = dbGetQuery(con, "SELECT * FROM iris_mydata")
dim(sample_iris)

#Table 삭제
result = dbSendQuery(con, "DROP TABLE iris_mydata")
dbClearResult(result)

sample_iris = dbGetQuery(con, "SELECT * FROM iris_mydata")
dbExistsTable(con, "iris_mydata")

dbDisconnect(con)
##EOF







