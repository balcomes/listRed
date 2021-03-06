\name{listRed-package}
\alias{listRed-package}
\alias{listRed}
\docType{package}
\title{
View/edit R list objects in the browser via httpuv:
listRed
}
\description{
View/edit R list objects in the browser via httpuv.
}

\details{
\tabular{ll}{
Package: \tab listRed\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2014-09-19\cr
License: \tab Artistic-2.0 | file LICENSE\cr
}
Insert overview and important functions later.
}
\author{
Shawn Balcome

Author/Maintainer: Shawn Balcome <balc0022@umn.edu>

Acknowledgements:Paul Shannon, Martin Morgan, Jos de Jong

}

\keyword{ httpuv }
\keyword{ RJSONIO }
\keyword{ R.utils }
\seealso{

\code{\link[httpuv:httpuv-package]{httpuv}}

\code{\link[RJSONIO:RJSONIO-package]{RJSONIO}}

\code{\link[R.utils:R.utils-package]{R.utils}}

}
\examples{
if(interactive()) {
go()
sendList(as.list(mtcars))
new_list <- returnList()
stopws("myws")
}
}
