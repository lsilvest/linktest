##' Trying to satisfy the documentation
##' @param  y y
##' @param  m m
##' @param  d d
##' @param  hh hh
##' @param  mm mm
##' @param  ss ss
##' @param  tz tz
##' @export
convertToSeconds <- function(y, m, d, hh, mm, ss, tz) {
  .Call("__linktest_convertToSeconds", y, m, d, hh, mm, ss, tz)
}
