#############################################################################################################################################################################
#                                행정안전부 주민등록주소코드                                                                                                                #
#############################################################################################################################################################################

url2 = "https://www.mois.go.kr/cmm/fms/FileDown.do?atchFileId=FILE_00085815ScciWdD&fileSn=1"
local.copy = "jscode20190701.zip"
download.file(url2, local.copy, mode = "wb")
library(openxlsx)
UNZIP_FILE=unzip(zipfile = local.copy)
location = read.xlsx(UNZIP_FILE[5], sheet=1)
location = location[!is.na(location$시군구명) & 
                     !is.na(location$읍면동명) & !is.na(location$동리명),]
location$loccode = as.numeric(substr(location$법정동코드,1,5))
location[, c("법정동코드", "읍면동명", "동리명", "생성일자", "말소일자")] = NULL
rownames(location) = NULL
nrow(location)
location2 = location[!duplicated(location$loccode),]
location.seoul = location2[location2$시도명 == "서울특별시",]
nrow(location.seoul)


#############################################################################################################################################################################
#                                국토교통부 실거래신고가격 스크래핑                                                                                                         #
#############################################################################################################################################################################

library(glue)
url = "http://openapi.molit.go.kr/OpenAPI_ToolInstallPackage/service/rest/RTMSOBJSvc/getRTMSDataSvcAptTradeDev?LAWD_CD={BJD_CODE}&DEAL_YMD={SALES_DATE}&serviceKey={MyKey}"
BJD_CODE = "11110"
SALES_DATE = "201901"
#인증키 보안
MyKey = ""  #공공데이터포털(www.data.go.kr)에서 각자 인증
glue(url)

library(XML)
library(RCurl)
xml = getURL(glue(url), .encoding = "UTF-8"); xml
xml.parsed = xmlParse(xml)
items = xpathSApply(xml.parsed, "//item")
length(items)
items[[1]]
unname(xmlSApply(items[[1]], xmlValue))
APT = data.frame()
for (i in 1:length(items)) {
  item = xmlSApply(items[[i]], xmlValue)
  item = data.frame(SALES_PRICE = item[1],
                    BLD_YEAR = item[2],
                    DATE_YEAR = item[3],
                    ROAD_NAME = item[4],
                    ROAD_BONBUN = item[5],
                    ROAD_BOOBUN = item[6],
                    ROAD_SIGUNGU = item[7],
                    ROAD_SEQ = item[8],
                    ROAD_GND_YN = item[9],
                    ROAD_CD = item[10],
                    BJD_NAME = item[11],
                    BJD_BONBUN = item[12],
                    BJD_BOOBUN = item[13],
                    BJD_SIGUNGU = item[14],
                    BJD_EMD = item[15],
                    BJD_JIBUN = item[16],
                    APT_NAME = item[17],
                    DATE_MONTH = item[18],
                    DATE_DAY = item[19],
                    SALES_SEQ = item[20],
                    APREA = item[21],
                    JIBUN = item[22],
                    BJD_CODE = item[23],
                    FLOOR = item[24],
                    stringsAsFactors = FALSE)
  APT = rbind(APT, item)
}
rownames(APT) = NULL
nrow(APT)
head(APT,3)


#############################################################################################################################################################################
#                                실거래가 스크래핑 복수 기간                                                                                                                #
#############################################################################################################################################################################

makeYearMonth = function(from, to) {
  from = as.Date(paste0(from, "01"), "%Y%m%d")
  to = as.Date(paste0(to, "01"), "%Y%m%d")
  yearmonth = format(seq(from = from, to = to, by = "month"), "%Y%m%d")
  yearmonth = substring(as.character(yearmonth), 1, 6)
}

yearmonth = makeYearMonth(from = "201901", to = "201910")
yearmonth

urls = c()
for (loc in location.seoul$loccode) {
  for (date in yearmonth) {
    url.each = glue(url)
    urls = c(urls, url.each)
  }
}
length(urls)
urls

APT_ALL = data.frame()
for (url in urls) {
  xml = getURL(glue(url), .encoding = "UTF-8"); xml
  xml.parsed = xmlParse(xml)
  items = xpathSApply(xml.parsed, "//item")
  length(items)
  items[[1]]
  unname(xmlSApply(items[[1]], xmlValue))
  APT = data.frame()
  for (i in 1:length(items)) {
    item = xmlSApply(items[[i]], xmlValue)
    item = data.frame(SALES_PRICE = item[1],
                      BLD_YEAR = item[2],
                      DATE_YEAR = item[3],
                      ROAD_NAME = item[4],
                      ROAD_BONBUN = item[5],
                      ROAD_BOOBUN = item[6],
                      ROAD_SIGUNGU = item[7],
                      ROAD_SEQ = item[8],
                      ROAD_GND_YN = item[9],
                      ROAD_CD = item[10],
                      BJD_NAME = item[11],
                      BJD_BONBUN = item[12],
                      BJD_BOOBUN = item[13],
                      BJD_SIGUNGU = item[14],
                      BJD_EMD = item[15],
                      BJD_JIBUN = item[16],
                      APT_NAME = item[17],
                      DATE_MONTH = item[18],
                      DATE_DAY = item[19],
                      SALES_SEQ = item[20],
                      APREA = item[21],
                      JIBUN = item[22],
                      BJD_CODE = item[23],
                      FLOOR = item[24],
                      stringsAsFactors = FALSE)
    APT = rbind(APT, item)
  }
  APT_ALL = rbind(APT_ALL, APT)
}  #This may take long
nrow(APT_ALL)
write.table(APT_ALL, "C:/TEST/APT_ALL.txt", sep = "|", row.names = FALSE, quote = FALSE)
