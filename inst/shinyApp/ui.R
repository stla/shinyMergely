library(shinyjqui)
#shinyOptions(shiny.jquery.version = 1)

fluidPage(
  theme = shinytheme("cyborg"),
  tags$head(
    tags$script(src="bootstrap-flash-alert.js"),
    tags$link(rel="stylesheet", href="animate.css"),
    tags$script(src="codemirror/lib/codemirror.js"),
    tags$link(rel="stylesheet", media="all", href="codemirror/lib/codemirror.css"),
    tags$script(src="codemirror/addon/search/searchcursor.js"),
    tags$link(rel="stylesheet", href="codemirror/theme/cobalt.css"),
    tags$script(src = "codemirror/mode/meta.js"),
    tags$script(src = "codemirror/mode/css/css.js"),
    tags$script(src = "codemirror/mode/haskell/haskell.js"),
    tags$script(src = "codemirror/mode/htmlmixed/htmlmixed.js"),
    tags$script(src = "codemirror/mode/javascript/javascript.js"),
    tags$script(src = "codemirror/mode/jsx/jsx.js"),
    tags$script(src = "codemirror/mode/julia/julia.js"),
    tags$script(src = "codemirror/mode/markdown/markdown.js"),
    tags$script(src = "codemirror/mode/python/python.js"),
    tags$script(src = "codemirror/mode/r/r.js"),
    tags$script(src = "codemirror/mode/sql/sql.js"),
    tags$script(src = "codemirror/mode/stex/stex.js"),
    tags$script(src = "codemirror/mode/xml/xml.js"),
    tags$script(type="text/javascript", src="mergely/package/lib/mergely.js"),
    tags$link(rel="stylesheet", media="all", href="mergely/package/lib/mergely.css"),
    tags$link(rel="stylesheet", href="shinyMergely.css"),
    tags$script(src = "shinyMergely.js")
    #tags$script(src = "https://cdn.jsdelivr.net/watch-element-resize.js/latest/watch-element-resize.min.js")
  ),
  br(),
  wellPanel(
    fluidRow(
      column(
        width = 10,
        fileInput(
          "files", NULL, multiple = TRUE, buttonLabel = "Select two files..."
        )
      ),
      column(
        width = 2,
        #conditionalPanel(
        #"output.uploaded",
        actionButton("swap", "Swap", class = "btn-lg mainPanel",
                     icon = icon("transfer", lib = "glyphicon"))
        #)
      )
    )
  ),
  fluidRow(
    class = "mainPanel",
    column(
      width = 12,
      fluidRow(
        column(
          width = 6,
          #style = "margin-left: -2px;",
          tags$p(id = "fileLeft"),
          actionButton("copyLeft", "Copy")
        ),
        column(
          width = 6,
#          style = "margin-left: -13px;",
          tags$p(id = "fileRight"),
          actionButton("copyRight", "Copy")
        )
      ),
      #conditionalPanel(
      # "output.uploaded",
      jqui_resizable(
        tags$div(id="x",tags$div(id = "mergely")),
        options = list(alsoResize = ".CodeMirror", handles = "s")
      )
      #)
    )
  )
)
