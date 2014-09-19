.onLoad <- function(libname, pkgname)
{
  suppressMessages({
    addResourcePath("www", system.file("www", package="listRed"))
  })
}