#상관관계 : 두 정량적 변수의 관련이 있는 정도를 의미. 
#회귀(regression) : "go back to an earlier and worse condition"(옛날 상태로 돌아감). 영국의 유전학자인 Francis Galton의 연구(1885년 발표)에 기인 
#UsingR 패키지에 들어 있는 galton 데이터로 상관분석, 회귀분석을 더 알아보자.

install.packages("UsingR")
require(UsingR)
data(galton) ; str(galton) #928개의 부모와 아이의 키 자료
colSums(is.na(galton)) #결측치 체크

par(mfrow=c(1,2))
hist(galton$child,col="blue",breaks=10)
hist(galton$parent,col="blue",breaks=100)
par(mfrow=c(1,1))
cor.test(galton$child,galton$parent) #귀무가설 : 상관관계가 없다. 
#p-value가 0.05보다 작다 = 통계적으로 유의하다 = 귀무가설(부모와 자식의 키가 상관이 없다)이 참이라고 할 때 나타나기엔 너무 우연이라고 볼 수 없다. 
#Pearson 상관계수는 선형적인 상관관계를 보여주며 인과관계는 검증할 수 없다. 

xtabs(~child+parent,data=galton) #분할표
result=lm(child~parent,data=galton) #linear modeling 
summary(result)
plot(child ~ parent,data=galton)
abline(result,col="red")

require(ggplot2)
ggplot(data=galton,aes(x=parent,y=child))+geom_count()+geom_smooth(method="lm")