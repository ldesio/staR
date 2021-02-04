library(foreign); data <- read.dta('ind.dta');
attributes(data)

library(knitr); library(summarytools); 
analysis <- function(data) {
  #print(data)
  kable(freq(data$age5),'html',digits=2)
  
};

library(haven)
library(expss)
stardata = haven::read_dta("ind.dta")
for (v in colnames(stardata)) val_lab(stardata[,v])=val_lab(stardata[,v])


library(knitr); library(expss);
# val_lab(stardata$sex)=NULL;
levs <- levels(stardata$sex); if (is.null(levs)) levs <- sort(unique(stardata$sex));

library(haven); library(expss); library(foreign); stardata <- haven::read_dta('ind.dta');
for (v in colnames(stardata)) val_lab(stardata[,v])=val_lab(stardata[,v]);

library(knitr); library(summarytools); library(expss); 
levs <- levels(stardata$sex); if (is.null(levs)) levs <- sort(unique(stardata$sex));
for (lev in levs) {
  ss <- subset(stardata,as.numeric(data.matrix(sex))==lev);
  nss <- data.frame(data.matrix(ss));
  cat(paste0("<h3 style='background-color:#cccccc; border-radius:10px; padding:10px'><i>sex==",lev," [",names(val_lab(stardata$sex)[lev]),"]<br>(",nrow(ss)," observations):</i></h3>"));
  cat("<div style='margin-left:40px; margin-bottom:20px'>");
  cat(paste0('<h3>Frequency distribution of edu5 (<i>What is the highest level of education you have completed or the highest degree</i>)</h3>'))
  #cat(knit_print(fre(ss$edu5)))
  cat("</div>");
}








install.packages("lfactors")
require(lfactors)

for(i in unique(data$sex)) { print(i);}

numdata <- data.frame(data.matrix(data))


vals <- levels(data$age5);
if (is.null(vals)) vals <- sort(unique(data$age5))

if (vals)
for(i in 1:length(vals)){
  # print(paste0("**",attributes(data)$label.table$age5[i]));
  ss <- subset(data,age5==vals[i])
  print(paste0(vals[i],": ",nrow(ss)," cases"));
  # print(kable(freq(ss$age5),'html',digits=2))
  analysis(ss);
  # print(i);
  
  #this.a <- unique(a)[i]
}
for (val in vals) {
    ss <- subset(data,age5==val);
    print(paste0("age5==",val," (",nrow(ss)," observations):"));
    analysis(ss);
}

library(foreign); data <- read.dta('ind.dta');
library(knitr); library(summarytools); 

varlabel <- function(arg1) return (attributes(data)$var.labels[match(arg1,attributes(data)$names)]);

                                   
cat(kable(freq(data$sex),'html',digits=2))

data <- apply_labels(data,sex=varlabel("sex"),polint=varlabel("polint"))
knit_print(cro(data$sex, data$polint))

by(data,data$sex, analysis);