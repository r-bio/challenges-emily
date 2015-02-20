
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

#Now getting list of gnerea that have subgenera associated with them.
#Use nom data.frame

str(nom)
subgenus <- nom$Subgenus.orig
subgen_length <- nzchar(subgenus)  # Finding FALSE entries for missing data using nzchar function (on a character vector). Making a logical object
length(subgen_length)  #total length of entries?? I think it's all of them... Returned:   [1] 199
length(subgen_length[subgen_length=TRUE])  ## Returns [1] 199 if you only use 1 equals sign (even after importing with na.strings="" function). But I think there are missing values here. 
length(subgen_length[subgen_length==TRUE])  ## Returns [1] 59 if you use 2 equal signs, == instead of =

##Problem is that empty cells aren't being recognized as na-- How do you deal with this without re-importing file?
## Re-importing files to fill blanks with NA
hol_NA <- read.csv(file="data/holothuriidae-specimens.csv", stringsAsFactors=FALSE, na.strings="")
nom_NA <- read.csv(file="data/holothuriidae-nomina-valid.csv", stringsAsFactors=FALSE, na.strings="")
## extracting subgenus again from new file with NA
subgenus <- nom_NA$Subgenus.orig   #subgenus is a character object
subgenus_noNA <- na.omit(nom_NA$Subgenus.orig)  ## totally empty but we know they're not all NA. NA.OMIT ONLY WORKS ON VECTORS! oops.
subgenus_noNA2 <- na.omit(subgenus)  ## also totally empty  :(
## remove subgenus_noNA, and subgenus_noNA2
rm(subgenus_noNA)
rm(subgenus_noNA2)
## Try complete cases??
## SYNTAX:  surveys_complete <- surveys[complete.cases(surveys), ]
subgenus_noNA <- subgenus[complete.cases(subgenus)]  # Fxn complete.cases works with characters
length(subgenus_noNA)
## There are 59 subgenera listed.  ##this is not the ideal way to find it though since you're only looking in the subgenus column and you want to know how many genera have subgenera associated wtih them...
#let's test it out with  the logical subgen_length
subgen_length_noNA <- subgen_length[complete.cases(subgen_length)]
length(subgen_length_noNA[subgen_length_noNA==TRUE])

## getting genus and species from hol dataset (using datasets with NA in them)
hol_genus <- hol_NA$dwc.genus
hol_species <- hol_NA$dwc.specificEpithet
hol_genus_species <- paste(hol_genus, hol_species, sep=" ")
head(hol_genus_species)

nom_genus <- nom_NA$Genus.current
nom_species <- nom_NA$species.current
nom_genus_species <- paste(nom_genus, nom_species, sep=" ")

#now paste this column into the hol data.frame
hol2 <- paste(hol, nom_genus_species, sep=" ")
#using merge function to combine 2 objects. use all.x  or all.y option to add extra rows
# hol_genus_species has 2984 elements but nom_genus_species only has 199 elements

gen_sp_combined <- merge(hol_genus_species, nom_genus_species, all.hol_genus_species=TRUE, sort=TRUE)  ## get same number with all.hol_genus_species=all as with  all.hol_genus_species=TRUE
head(gen_sp_combined)
nrow(gen_sp_combined)

#combining hol and nom data.frames
all_data <- merge(hol2, nom, all.hol2=TRUE, sort=TRUE)
head(all_data)

