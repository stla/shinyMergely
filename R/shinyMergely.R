#' Shiny Mergely
#' @description Launch a Shiny app allowing to compare and merge two files.
#'
#' @importFrom shiny shinyAppDir
#' @export
shinyMergely <- function(){
  shinyAppDir(system.file("shinyApp", package = "shinyMergely"))
}
