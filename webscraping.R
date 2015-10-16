library(rvest)
pencils <- html("https://web.archive.org/web/20130730001143/http://www.cultpens.com/acatalog/Pencils.html")

# pencil product names
pnames <-
  pencils %>% 
  html_nodes("p a") %>%
  html_text()

# web page formatting will result in empty lines
# remove empty lines
pnames <- grep ("[a-z]", pnames, value=TRUE)

# product names into vector pnames
paragraphs <-
  pencils %>% 
  html_nodes("p") %>%
  html_text()

#remove all entries without a pound sign
paragraphs <- grep ("£", paragraphs, value=TRUE)


# only keep prices
t1 <- regmatches(paragraphs, gregexpr("£([0-9])+.[0-9][0-9]",paragraphs))

# only keep first price
price = do.call("rbind", lapply(t1, "[[", 1))


# both vecors into a dataframe
df <- data.frame(pnames,price)
# names for the columns
names(df) <- c("name", "price")

