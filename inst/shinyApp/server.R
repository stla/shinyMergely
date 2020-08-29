# TODO: use uchardet

getMode <- function(ext){
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
    sas = "sas",
    sql = "sql",
    svg = "xml",
    tex = "stex",
    xml = "xml"
  )
  if(is.null(mode)) mode <- "text/plain"
  mode
}

function(input, output, session){

  # uploaded <- reactiveVal(FALSE)
  files <- reactiveVal()

  # output[["uploaded"]] <- reactive({
  #   uploaded()
  # })
  # outputOptions(output, "uploaded", suspendWhenHidden = FALSE)

  observeEvent(input[["files"]], {
    req(length(input[["files"]][["datapath"]]) == 2L)
    # uploaded(TRUE)
    session$sendCustomMessage("start", "x")
    started(TRUE)
  }, priority = 2)

  observeEvent(input[["files"]], {
    req(length(input[["files"]][["datapath"]]) == 2L)
    lhs <- paste0(readLines(input[["files"]][["datapath"]][1L]), collapse = "\n")
    rhs <- paste0(readLines(input[["files"]][["datapath"]][2L]), collapse = "\n")
    session$sendCustomMessage("mergely", list(lhs = lhs, rhs = rhs))
    fileNames <- input[["files"]][["name"]]
    files(fileNames)
    session$sendCustomMessage(
      "fileNames",
      list(left = fileNames[1L], right = fileNames[2L])
    )
    ext <- tools::file_ext(fileNames[1L])
    mode <- getMode(ext)
    if(mode != input[["language"]]){
      updateSelectizeInput(session, "language", selected = mode)
    }else{
      session$sendCustomMessage("setMode", mode)
    }
  }, priority = 1)

#  separatedFiles <- reactiveValues(file1 = NULL, file2 = NULL)
  file1 <- reactiveVal(FALSE)
  file2 <- reactiveVal(FALSE)
  separatedFiles <- eventReactive(list(file1(),file2()), {
    file1() && file2()
  })
  started <- reactiveVal(FALSE)

  observeEvent(input[["file1"]], {
    req(isFALSE(file1()))
#    separatedFiles(c(separatedFiles(), input[["file1"]][["name"]]))
    session$sendCustomMessage("changeBorders", "file1")
    file1(TRUE) # pb si le user re-upload
  })
  observeEvent(input[["file2"]], {
    req(isFALSE(file2()))
#    separatedFiles(c(separatedFiles(), input[["file2"]][["name"]]))
    session$sendCustomMessage("changeBorders", "file2")
    file2(TRUE)
  })

  observeEvent(separatedFiles(), {
    req(separatedFiles() && !started())
    session$sendCustomMessage("start", "x")
    started(TRUE)
  }, priority = 2)

  observeEvent(separatedFiles(), {
    req(separatedFiles())
    lhs <- paste0(readLines(input[["file1"]][["datapath"]]), collapse = "\n")
    rhs <- paste0(readLines(input[["file2"]][["datapath"]]), collapse = "\n")
    session$sendCustomMessage("mergely", list(lhs = lhs, rhs = rhs))
    files(c(input[["file1"]][["name"]],input[["file2"]][["name"]]))
    session$sendCustomMessage(
      "fileNames",
      list(left = input[["file1"]][["name"]], right = input[["file2"]][["name"]])
    )
    ext <- tools::file_ext(input[["file1"]][["name"]])
    mode <- getMode(ext)
    if(mode != input[["language"]]){
      updateSelectizeInput(session, "language", selected = mode)
    }else{
      session$sendCustomMessage("setMode", mode)
    }
    file1(FALSE); file2(FALSE)#; separatedFiles(NULL)
  }, priority = 1)

  observeEvent(input[["language"]], {
    print(input[["language"]])
    if(input[["language"]] != ""){
      session$sendCustomMessage("setMode", input[["language"]])
    }
  }, ignoreInit = TRUE)

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
