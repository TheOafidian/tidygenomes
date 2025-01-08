#' Write tidygenomes object to a gzipped serialized JSON object.
#' @param tg A tidygenomes object
#' @param outf Output file
write_tidygenomes <- function(tg, outf = "tidygenome.gz") {
  gz <- gzfile(outf, "w")
  serialized <- jsonlite::serializeJSON(tg)
  write(serialized, gz)
  close(gz)
}

#' Read tidygenomes object from a gzipped serialized JSON object.
#' @param inf Input file
read_tidygenomes <- function(inf) {
  gz <- gzfile(inf, "rb")
  tg <- jsonlite::unserializeJSON(gz)
  close(gz)
  tg
}