setwd("~/GitHub/Web-Scraping")
library(rvest)
pencils <- html("source/Graphite Pencils | Cult Pens 2015-06-15.html")

# product names into vector pnames
pnames <-
  pencils %>% 
  html_nodes(".prod-name a") %>%
  html_text()

# product prices into vector pprices
pprices <-
  pencils %>% 
  html_nodes(".prod-price a") %>%
  html_text()

# entry currently looks like
# Only £5.95inc VAT £4.96 ex VAT
# grep down to 
# ([0-9])+.[0-9][0-9]
# can check at http://www.regexr.com
# remove all letters, spaces, pound sign
# [a-zA-Z £]
# regmatches ("([0-9])+.[0-9][0-9]", pprices)
# regmatches("[a-zA-Z £]*", pprices)

# test <- regmatches(pprices, gregexpr("([0-9])+.[0-9][0-9]",pprices))
# ^ returns a list that contains two elements in each line (price with and without VAT)
novat <- as.numeric(regmatches(pprices, gregexpr("[0-9]+.[0-9][0-9] ",pprices)))
# ^ returns the second match (without VAT), as-numeric to get rid of space afterwards

# both vectors into a dataframe
df <- data.frame(pnames,novat)
# names for the columns
names(df) <- c("name", "price w/o vat")
