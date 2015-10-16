scrapearchive <- function(address) {
  #scrapearchive will look at an archived version of the pencil page and will extract pencil names and prices
  #exampleuse 
  # test4 <- scrapearchive("https://web.archive.org/web/20140417064443/http://www.cultpens.com/acatalog/Pencils.html")
  
  library(rvest)
  
  #get date out, ignore time as unlikely for price to have changed so not worth recording this info
  archivedate <- regmatches(address, gregexpr("20[0-9]{6}",address))
  
  #pencils <- html("https://web.archive.org/web/20130730001143/http://www.cultpens.com/acatalog/Pencils.html")
  pencils <- html(address)
  
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
  
  
  # both vectors into a dataframe
  tryCatch({
    data.frame(name=pnames, price=price, date=unlist(archivedate))
  }, error=function(e) data.frame(name=character(0),
                                  price=numeric(0),
                                  date=character(0)))
}