library(linktest)

res <- linktest::convertToSeconds(2019, 9, 9, 12, 12, 12, "America/New_York")
print(res)

resPOSIXct <- as.POSIXct(res, origin="1970-01-01")
print(resPOSIXct)

resChar <- format(resPOSIXct, tz="America/New_York")
print(resChar)

if (resChar != "2019-09-09 12:12:12") 
  stop("error in convert function")

