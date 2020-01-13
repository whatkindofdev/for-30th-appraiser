###############################################################################################################################
#                                               인코딩 이해하기                                                               #
###############################################################################################################################
#R은 운영체제에서 채택하고 있는 인코딩 방식에 따라 텍스트를 처리.
#한글 윈도우의 경우 운영체제에 내장된 로케일(Locale)에 따라 텍스트 인코딩 수행.

Sys.getlocale() #현재의 로케일 설정 보기
#"LC_COLLATE=Korean_Korea.949;LC_CTYPE=Korean_Korea.949;LC_MONETARY=Korean_Korea.949;LC_NUMERIC=C;LC_TIME=Korean_Korea.949"
#LC_CLLATE : 콜레이션. 문자열의 정렬순서, LC_MONETARY : 화폐단위, LC_NUMERIC : (화폐금액이 아닌)숫자단위, LC_TIME : 시간단위

Sys.getlocale(category = "LC_CTYPE") #현재 로케일에서 사용중인 문자셋. 문자분류(알파벳, 숫자, 한글 또는 소문자/대문자 등) 용도
localeToCharset() #현재 시스템에서 채택하고 있는 인코딩명. CP949. CP = Code Page. 
#CP949 = MS에서 도입한 확장완성형(또는 통합형) 한글 인코딩 체계. 11,172개의 한글 글자 표현 가능.
#EUC-KR(Extended Unix COde-KR) = 완성형 한글 인코딩 체계. 2,350여개의 한글 글자 표현 가능.
#UTF-8= Mac OS 또는 Linux 용 유니코드 표준 인코딩.

mydata = "아이엠어보이. 유알아 어프레이져. 2019 copyright."
Encoding(mydata) #unknown은 시스템의 로케일
mydata2 = iconv(x=mydata, from=localeToCharset(), to="UTF-8")
Encoding(mydata2)
Encoding(mydata2) = "CP949"
mydata2 #한글깨짐. 시스템은 CP949 인코딩 테이블에 따라 문자 변환하고자 하는데, 실제 텍스트는 UTF-8로 인코딩되었기 때문.
Encoding(mydata2) = "UTF-8"
mydata2

length(iconvlist()) #현재 인코딩 테이블 수, 374
sample(iconvlist(),10)