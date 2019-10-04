library(linktest)
res <- linktest::convertToSeconds(2019, 9, 9, 12, 12, 12, "America/New_York")
if (as.POSIXct(res, origin="1970-01-01") != "2019-09-09 12:12:12 EDT") 
  stop("error in convert function")

