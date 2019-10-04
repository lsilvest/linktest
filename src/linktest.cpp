#include <Rcpp.h>
#include "cctz/civil_time.h"
#include "cctz/time_zone.h"


RcppExport SEXP __linktest_convertToSeconds(SEXP y_p, SEXP m_p, SEXP d_p, SEXP hh_p, SEXP mm_p, SEXP ss_p, SEXP tz_p) {
  const Rcpp::NumericVector y(y_p);
  const Rcpp::NumericVector m(m_p);
  const Rcpp::NumericVector d(d_p);
  const Rcpp::NumericVector hh(hh_p);
  const Rcpp::NumericVector mm(mm_p);
  const Rcpp::NumericVector ss(ss_p);
  const Rcpp::CharacterVector tz(tz_p);
  const char* tzstr = tz[0];
  Rcpp::Rcout << tzstr << std::endl;
  cctz::time_zone cctz;
  if (!load_time_zone(tzstr, &cctz)) {
    Rcpp::stop("cannot retrieve timezone");
  }
  const cctz::civil_second cvt(y[0], m[0], d[0], hh[0], mm[0], ss[0]);
  auto tp = cctz::convert(cvt, cctz);
  Rcpp::NumericVector res(1);
  res[0] = tp.time_since_epoch().count();
  return res;
}
