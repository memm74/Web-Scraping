# need scrapearchive.R first so that function scrapearchive is known
# will extract pencil names and prices from archived pages

library(rvest)
# overview <- html("https://web.archive.org/web/*/http://www.cultpens.com/acatalog/Pencils.html")
# overview <- html("https://web.archive.org/web/20130101000000*/http://www.cultpens.com/acatalog/Pencils.html")
# 2013  https://web.archive.org/web/20130101000000*/http://www.cultpens.com/acatalog/Pencils.html

# archive.org doesn't use css, so can't use rvest?

urls <-
  overview %>% 
  html_nodes("date captures") %>%
  html_text()



# overview <- readLines("http://web.archive.org/web/*/http://www.cultpens.com/acatalog/Pencils.html")
overview <- readLines("http://web.archive.org/web/20130101000000*/http://www.cultpens.com/acatalog/Pencils.html")

# Get lines with links
htmllines <- overview[grep("<a href=\"/web/20", overview)]


# \/web.*\.html
# \/ matches the character / literally
# . matches any character (except newline)
# Quantifier: * Between zero and unlimited times
# can check at https://regex101.com

# get address out 
# R needs escape characters escaped!!!!!
relativeaddress <- regmatches(htmllines, gregexpr("\\/web.*\\.html",htmllines))



absoluteaddress <- paste0 ("https://web.archive.org", relativeaddress)

#http://nicercode.github.io/guides/repeating-things/
result <- lapply(absoluteaddress, scrapearchive)
#head( do.call(rbind, result) )
test <- do.call(rbind, result) 

# test$date <- as.Date(test$date, "%Y%m%d")

# Save to a file
save(test, file = "test.R")

# this is by year
# merge vertically e.g. pencils <- rbind(pencils2010, pencils2013)


# write csv example 
# write.csv(pencils, file = "pencils2010-14.csv")

