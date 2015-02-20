
#downloading files from github
download.file("http://r-bio.github.io/data/holothuriidae-specimens.csv",
              "data/holothuriidae-specimens.csv")
download.file("http://r-bio.github.io/data/holothuriidae-nomina-valid.csv",
              "data/holothuriidae-nomina-valid.csv")

hol <- read.csv(file="data/holothuriidae-specimens.csv", stringsAsFactors=FALSE)
nom <- read.csv(file="data/holothuriidae-nomina-valid.csv", stringsAsFactors=FALSE)

str(hol)  #class is stored as a vector in class character
head(hol)
class_hol <- hol[,c("dwc.class")]
length(class_hol)
#There are [1] 2984 entries for specimens in holothuriidae specimens data sheet

#Maybe some are missing? We can check for NA in 2 ways:
# First, use na.omit function (only used on vectors, and dwc.class is a vector)
class_hol_noNA <- na.omit(hol$dwc.class)
length(class_hol_noNA)  This gives us 2984 entries
# Second try the !is.na function
class_hol_complete <- class_hol[!is.na(class_hol)]
length(class_hol_complete) #Still 2984 entries in this column 
## **Note these functions do not check for EMPTY entries, as we can tell below from using the function nzchar **

# want to manipulate the elements of the data.frame as factors
# so import file again but leave strings as factors, then you can find the levels to see how many different names are in the column and what they are
hol_factors <- read.csv(file="data/holothuriidae-specimens.csv")

#check structure of hol_factors file
str(hol_factors)
museum_name <- hol_factors$dwc.institutionCode   # Getting the museums into a new list
museum_name   #check to see that new object was created and contains right info
str(museum_name)   # 4 levels are present in the factor
plot(museum_name)  #plotting the number of entries in the list per museum

#finding the year the oldest specimen was collected.

year <- hol_factors$dwc.year   #first, get the year as a new object
str(year)

year_complete <- year[!is.na(year)]  #remove NA entries from list
year_complete
min(year_complete)  ## get 1 but this isn't correct. We need a YEAR

##oldest <- length(year_complete)  #get the length of year_complete
##sort(year_complete,partial=oldest+1)[oldest+1]  # sort 
##head(oldest)

length <- length(year_complete)   #get length of year_complete and store it so you can refer back to it
sort(year_complete, decreasing = TRUE)[length-1]  ## Sorth through the list and find the second lowest entry in the list (it's 91!)

sort(year_complete, decreasing = TRUE)[length-1:10] ## But since we doubt folks were actually collecting specimens in the year 91, let's check the last 10 entries.
## The earliest YEAR is 1902.  ##

## Finding missing entries in Class list using nzchar function

orig_class <- is.na(class_hol)
orig_class

#Using the data set that has NO factors in it:
class <- hol$dwc.class   #getting the class column from the data.frame
head(class)
# is.na(class)  #Tried this but it doesn't work, gives you ALL FALSE in list.
str(class)
class_TF <- nzchar(class)  #Now using nzchar and it works! Stored it as a logical called class_TF 

## Note: also tried with data set that has factors in it, BUT nzchar won't work if the elements aren't characters
## > class_fac <- hol_factors$dwc.class
## > nzchar(class_fac)
##   Error: 'nzchar()' requires a character vector

#Need to sort the vector called class containing characters (not factors). *****SUM FXN DOESNT WORK BUT I DONT KONW WHY! *****
#sum(class_TF)  #Returns:  [1] 2935
#sum(class_TF, na.rm=TRUE)  #I expected this to be different but it gives the same number as the sum(class_TF)
#sum(TRUE, class_TF)  #gives you all the elements labeled TRUE??  Returns: [1] 2935
#sum(FALSE, class_TF)   # Returns:  [1] 2934  *Why are there this many FALSE entries reported here? I can see they're not actually that many if I look at the list


length(class_TF)
length(class_TF[class_TF==TRUE])   # Returns [1] 2934
length(class_TF[class_TF==FALSE])  # Returns [1] 50  FALSE (empty) values, a much more sensible answer than when using SUM. 

## Replacing false entries with class Holothuroidea
#trying extract function on the class_hol object (characters)
#class_hol[" "]  <- "Holothuroidea"  ## NO! This gets rid of EVERYTHING!

#copying hol to a new name so i don't delete it by mistake
hol2 <- hol
str(hol2)
hol2[" ", "Holotheroidea"]

#okay, trying something different now
hol2$dwc.class[hol2$dwc.class==""] <- "Holothoroidea"
hol2$class.renamed <- hol2$dwc.class
class.renamed <- hol2$dwc.class
check_tf <- nzchar(class.renamed)
length(check_tf[check_tf==TRUE])  ## Returns 2894 so all empty values have been replaced.
#can now remove check_tf since the number of objects I have stored are getting out of hand...
rm(check_tf)
