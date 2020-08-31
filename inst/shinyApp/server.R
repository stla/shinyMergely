library(uchardet)

flashMessage_invalidFile <- function(fileName){
  list(
    message = sprintf("The file '%s' is not of type 'text'.", fileName),
    title = "Invalid file!",
    type = "danger",
    icon = "glyphicon glyphicon-ban-circle",
    withTime = FALSE,
    closeTime = 10000,
    animShow = "flash",
    animHide = "backOutDown",
    position = list("center", list(0, 0))
  )
}

getMode <- function(ext){
  switch(
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
}

function(input, output, session){

  files <- reactiveVal()

  observeEvent(input[["files"]], {
    req(length(input[["files"]][["datapath"]]) == 2L)
    session$sendCustomMessage("start", "x")
    started(TRUE)
  }, priority = 2)

  observeEvent(input[["files"]], {
    req(length(twoFiles <- input[["files"]][["datapath"]]) == 2L)

    fileNames <- input[["files"]][["name"]]

    enc <- suppressWarnings(detect_file_enc(twoFiles[1L]))
    if(is.na(enc)){
      session$sendCustomMessage(
        "flashMessage", flashMessage_invalidFile(fileNames[1L])
      )
      return(NULL)
    }
    enc <- suppressWarnings(detect_file_enc(twoFiles[2L]))
    if(is.na(enc)){
      session$sendCustomMessage(
        "flashMessage", flashMessage_invalidFile(fileNames[2L])
      )
      return(NULL)
    }

    lhs <- paste0(readLines(twoFiles[1L]), collapse = "\n")
    rhs <- paste0(readLines(twoFiles[2L]), collapse = "\n")
    session$sendCustomMessage("mergely", list(lhs = lhs, rhs = rhs))

    files(fileNames)
    session$sendCustomMessage(
      "fileNames",
      list(left = fileNames[1L], right = fileNames[2L])
    )

    mode <- getMode(tools::file_ext(fileNames[1L]))
    if(is.null(mode)) mode <- getMode(tools::file_ext(fileNames[2L]))
    if(is.null(mode)) mode <- "text/plain"

    if(mode != input[["language"]]){
      updateSelectizeInput(session, "language", selected = mode)
    }else{
      session$sendCustomMessage("setMode", mode)
    }
  }, priority = 1)

  file1 <- reactiveVal(FALSE)
  file2 <- reactiveVal(FALSE)
  separatedFiles <- eventReactive(list(file1(),file2()), {
    file1() && file2()
  })
  started <- reactiveVal(FALSE)
  changedBorders1 <- reactiveVal(FALSE)
  changedBorders2 <- reactiveVal(FALSE)

  observeEvent(input[["file1"]], {
    req(isFALSE(file1()))
    if(!changedBorders1()){
      session$sendCustomMessage("changeBorders", "file1")
      changedBorders1(TRUE)
    }
    file1(TRUE)
  })
  observeEvent(input[["file2"]], {
    req(isFALSE(file2()))
    if(!changedBorders2()){
      session$sendCustomMessage("changeBorders", "file2")
      changedBorders2(TRUE)
    }
    file2(TRUE)
  })

  observeEvent(separatedFiles(), {
    req(separatedFiles() && !started())
    session$sendCustomMessage("start", "x")
    started(TRUE)
  }, priority = 2)

  observeEvent(separatedFiles(), {
    req(separatedFiles())
    twoFiles <-
      c(input[["file1"]][["datapath"]], input[["file2"]][["datapath"]])
    fileNames <- c(input[["file1"]][["name"]], input[["file2"]][["name"]])

    enc <- suppressWarnings(detect_file_enc(twoFiles[1L]))
    if(is.na(enc)){
      session$sendCustomMessage(
        "flashMessage", flashMessage_invalidFile(fileNames[1L])
      )
      return(NULL)
    }
    enc <- suppressWarnings(detect_file_enc(twoFiles[2L]))
    if(is.na(enc)){
      session$sendCustomMessage(
        "flashMessage", flashMessage_invalidFile(fileNames[2L])
      )
      return(NULL)
    }

    lhs <- paste0(readLines(twoFiles[1L]), collapse = "\n")
    rhs <- paste0(readLines(twoFiles[2L]), collapse = "\n")
    session$sendCustomMessage("mergely", list(lhs = lhs, rhs = rhs))

    files(fileNames)

    session$sendCustomMessage(
      "fileNames",
      list(left = fileNames[1L], right = fileNames[2L])
    )

    mode <- getMode(tools::file_ext(fileNames[1L]))
    if(is.null(mode)) mode <- getMode(tools::file_ext(fileNames[2L]))
    if(is.null(mode)) mode <- "text/plain"

    if(mode != input[["language"]]){
      updateSelectizeInput(session, "language", selected = mode)
    }else{
      session$sendCustomMessage("setMode", mode)
    }

    file1(FALSE); file2(FALSE)

  }, priority = 1)

  observeEvent(input[["language"]], {
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
