# TODO: use uchardet

function(input, output, session){

  uploaded <- reactiveVal(FALSE)
  files <- reactiveVal()

  output[["uploaded"]] <- reactive({
    uploaded()
  })
  outputOptions(output, "uploaded", suspendWhenHidden = FALSE)

  observeEvent(input[["files"]], {
    files <- input[["files"]][["datapath"]]
    if(length(files) == 2L){
      uploaded(TRUE)
      lhs <- paste0(readLines(files[1L]), collapse = "\n")
      rhs <- paste0(readLines(files[2L]), collapse = "\n")
      session$sendCustomMessage("mergely", list(lhs = lhs, rhs = rhs))
      fileNames <- input[["files"]][["name"]]
      files(fileNames)
      session$sendCustomMessage(
        "fileNames",
        list(left = fileNames[1L], right = fileNames[2L])
      )
      ext <- tools::file_ext(fileNames[1L])
      mode <- switch(
        tolower(ext),
        css = "css",
        hs = "haskell",
        html = "htmlmixed",
        jl = "julia",
        js = "javascript",
        jsx = "jsx",
        md = "markdown",
        py = "python",
        r = "r",
        rmd = "markdown",
        sql = "sql",
        svg = "xml",
        tex = "stex",
        xml = "xml"
      )
      if(is.null(mode)) mode <- "text/plain"
      session$sendCustomMessage("setMode", mode)
    }
  })

  observeEvent(input[["swap"]], {
    session$sendCustomMessage("swap", "x")
    fileNames <- files()
    session$sendCustomMessage(
      "fileNames",
      list(left = fileNames[2L], right = fileNames[1L])
    )
    files(fileNames[2L:1L])
  })

}
