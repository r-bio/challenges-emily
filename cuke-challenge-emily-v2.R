## This version is stripped down without my notes on the functions that didn't work EXCEPT at the end where it all falls apart! 
## See "cuke-challenge-emily.R" for the first version with extra info/notes

#downloading files from github
download.file("http://r-bio.github.io/data/holothuriidae-specimens.csv",
              "data/holothuriidae-specimens.csv")
download.file("http://r-bio.github.io/data/holothuriidae-nomina-valid.csv",
              "data/holothuriidae-nomina-valid.csv")

hol <- read.csv(file="data/holothuriidae-specimens.csv", stringsAsFactors=FALSE)
nom <- read.csv(file="data/holothuriidae-nomina-valid.csv", stringsAsFactors=FALSE)

str(hol)  #class is stored as a vector in class character
class_hol <- hol[,c("dwc.class")]
length(class_hol)
## There are [1] 2984 entries for specimens in holothuriidae specimens data sheet
rm(class_hol)

##Maybe some are missing? We can check for NA:
class_hol_noNA <- na.omit(hol$dwc.class)
length(class_hol_noNA)  ## This gives us 2984 entries
rm(class_hol_noNA)

# want to manipulate the elements of the data.frame as factor
hol_factors <- read.csv(file="data/holothuriidae-specimens.csv")

#check structure of hol_factors file
str(hol_factors)
# Getting the museums into a new list
museum_name <- hol_factors$dwc.institutionCode   
#plotting the number of entries in the list per museum
plot(museum_name)

# Finding the year the oldest specimen was collected.
year <- hol_factors$dwc.year
#remove NA entries from list
year_complete <- year[!is.na(year)]  
year_complete
# Get length of year_complete and store it so you can refer back to it
length <- length(year_complete)

# Sort through the list and find the second lowest entry in the list (it's 91!)
sort(year_complete, decreasing = TRUE)[length-1] 
## But since we doubt folks were actually collecting specimens in the year 91, let's check the last 10 entries.
sort(year_complete, decreasing = TRUE)[length-1:10] 
## The earliest YEAR is 1902.  ##

## Finding missing entries in Class list using nzchar function
#Using the data set that has NO factors in it:
#getting the class column from the data.frame
class <- hol$dwc.class
#Now using nzchar and it works! Stored it as a logical called class_TF 
class_TF <- nzchar(class)  
length(class_TF)
length(class_TF[class_TF==TRUE])   # Returns [1] 2934
length(class_TF[class_TF==FALSE])  # Returns [1] 50  FALSE (empty) values.


## Replacing false entries with class Holothuroidea
hol[" ", "Holotheroidea"]
hol$dwc.class[hol$dwc.class==""] <- "Holothoroidea"
hol$class.renamed <- hol$dwc.class
class.renamed <- hol$dwc.class
check_tf <- nzchar(class.renamed)
length(check_tf[check_tf==TRUE])  
## Returns 2984 so all empty values have been replaced.
#can now remove check_tf since the number of objects I have stored are getting out of hand...
rm(check_tf)
rm(class.renamed)

#Now getting list of genera that have subgenera associated with them.
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


subgenus_noNA <- subgenus[complete.cases(subgenus)]  # Fxn complete.cases works with characters
length(subgenus_noNA)
## There are 59 subgenera listed.  
##this is not the ideal way to find it though since you're only looking in the subgenus column and you want to know how many genera have subgenera associated wtih them...
#let's test it out with the logical subgen_length
subgen_length_noNA <- subgen_length[complete.cases(subgen_length)]
length(subgen_length_noNA[subgen_length_noNA==TRUE])

## Making new column with genus and species names in hol data.frame and adding it to the hol data.frame
## hol_copy <- data.frame(hol)  # made copy of data.frame just in case it didn't work
hol_gen_sp <- paste(hol$dwc.genus, hol$dwc.specificEpithet, sep=" ")
hol_new <- data.frame(cbind(hol, hol_gen_sp))  ## Successfully added column to hol_new data.frame

## Making new column with genus and species names in nom data.frame and adding it to the nom data.frame
nom_copy <- data.frame(nom)
nom_gen_sp <- paste(nom$Genus.current, nom$species.current, sep=" ")
nom_new <- data.frame(cbind(nom, nom_gen_sp))
rm(nom_copy)

#Combining new data frames (hol_new and nom_new)
nom_hol <- merge(hol_new, nom_new, all.hol_new=TRUE, sort=TRUE)
head(nom_hol)


######## This is all the crap that didn't work yesterday. Just here for the record ##########

##### making the genus and species new objects (basically copying them out of hte data.frames)
##### didn't work when I tried to glue them back together)
## getting genus and species from hol_NA dataset (using datasets with NA in them)
#hol_genus <- hol_NA$dwc.genus
#hol_species <- hol_NA$dwc.specificEpithet
#hol_genus_species <- paste(hol_genus, hol_species, sep=" ")
#head(hol_genus_species)

## getting genus and species from nom_NA dataset (using datasets with NA in them)
#nom_genus <- nom_NA$Genus.current
#nom_species <- nom_NA$species.current
#nom_genus_species <- paste(nom_genus, nom_species, sep=" ")




## Need to add the value "nom_genus_species" as a new column in nom_NA data.frame and need to add "hol_genus_species" to hol data.frame.

#now paste "nom_genus_species" as a new column into the hol data.frame  ##these don't work
#hol_new <- paste(hol_NA, hol_genus_species, sep=" ")
#hol_new <- data.frame(paste(hol_NA, hol_genus_species, sep=" "))
## hol2_data <- paste(nom_genus, hol_species, sep=" ")
## cbind(nom_genus_species, hol2_data)  ##NO


#using merge function to combine 2 objects. use all.x  or all.y option to add extra rows
# hol_genus_species has 2984 elements but nom_genus_species only has 199 elements

#Here's how I would combine these using merge if I could get them added to the data.frames.
#gen_sp_combined <- merge(hol_genus_species, nom_genus_species, all.hol_genus_species=TRUE, sort=TRUE)  ## get same number with all.hol_genus_species=all as with all.hol_genus_species=TRUE
#nrow(gen_sp_combined)

#combining hol_NA and nom_NA data.frames
#all_data <- merge(hol_NA, nom_NA, gen_sp_combined, all.hol2=TRUE, sort=TRUE)


