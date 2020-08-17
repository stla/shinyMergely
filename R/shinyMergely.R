#' Shiny Mergely
#' @description Launch a Shiny app for comparing and merging two files.
#'
#' @importFrom shiny shinyAppDir
#' @export
shinyMergely <- function(){
  shinyAppDir(system.file("shinyApp", package = "shinyMergely"))
}
