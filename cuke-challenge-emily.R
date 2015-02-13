
#downloading files from github
download.file("http://r-bio.github.io/data/holothuriidae-specimens.csv",
              "data/holothuriidae-specimens.csv")
download.file("http://r-bio.github.io/data/holothuriidae-nomina-valid.csv",
              "data/holothuriidae-nomina-valid.csv")

hol <- read.csv(file="data/holothuriidae-specimens.csv", stringsAsFactors=FALSE)
nom <- read.csv(file="data/holothuriidae-nomina-valid.csv", stringsAsFactors=FALSE)

str(hol)
#class is stored as a vector in class character
head(hol)
class_hol <- hol[,c("dwc.class")]
length(class_hol)
#There are [1] 2984 entries for specimens in holothuriidae specimens data sheet

museums_hol <- hol[,c("dwc.institutionCode")]
plot(museums_hol)  # This doesn't work
##Get this error: Error in plot.window(...) : need finite 'ylim' values
##  Error in plot.window(...) : need finite 'ylim' values
##  In addition: Warning messages:
##  1: In xy.coords(x, y, xlabel, ylabel, log) : NAs introduced by coercion
##  2: In min(x) : no non-missing arguments to min; returning Inf
##  3: In max(x) : no non-missing arguments to max; returning -Inf

str(museums_hol)
## as.numeric(as.character(museums_hol))  ##dont do this
nlevels(museums_hol)
head(museums_hol)  #

museum = hol$dw.institutionCode
museum
