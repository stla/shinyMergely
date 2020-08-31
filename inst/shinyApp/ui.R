library(shinythemes)
library(shinyjqui)

languages <- list(
  CSS = "css",
  Haskell = "haskell",
  HTML = "htmlmixed",
  Julia = "julia",
  JavaScript = "javascript",
  JSX = "jsx",
  LaTeX = "stex",
  Markdown = "markdown",
  Python = "python",
  R = "r",
  Rmarkdown = "markdown",
  SAS = "sas",
  SQL = "sql",
  SVG = "xml",
  Text = "text/plain",
  XML = "xml"
)

fluidPage(
  theme = shinytheme("cyborg"),
  tags$head(
    tags$script(src = "bootstrap-flash-alert.js"),
    tags$link(rel = "stylesheet", href = "animate.css"),
    tags$script(src = "codemirror/lib/codemirror.js"),
    tags$link(rel = "stylesheet", media = "all", href = "codemirror/lib/codemirror.css"),
    tags$script(src = "codemirror/addon/dialog/dialog.js"),
    tags$link(rel = "stylesheet", href = "codemirror/addon/dialog/dialog.css"),
    tags$script(src = "codemirror/addon/search/searchcursor.js"),
    tags$script(src = "codemirror/addon/search/search.js"),
    tags$link(rel = "stylesheet", href = "codemirror/theme/cobalt.css"),
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
    tags$script(src = "codemirror/mode/sas/sas.js"),
    tags$script(src = "codemirror/mode/sql/sql.js"),
    tags$script(src = "codemirror/mode/stex/stex.js"),
    tags$script(src = "codemirror/mode/xml/xml.js"),
    tags$script(src = "mergely/package/lib/mergely.js"),
    tags$link(rel = "stylesheet", media = "all", href = "mergely/package/lib/mergely.css"),
    tags$link(rel = "stylesheet", href = "shinyMergely.css"),
    tags$script(src = "shinyMergely.js"),
    tags$link(rel = "stylesheet", href = "shootingStars.css")
  ),
  br(),
  wellPanel(
    style = "display: none;",
    fluidRow(
      column(
        width = 1,
        id = "switch-column",
        tags$div(
          id = "switch-container",
          `data-toggle` = "tooltip",
          `data-placement` = "bottom",
          title = paste0(
            "Select two files at once (from the same folder) or select two ",
            "files one by one."
          ),
          tags$input(
            id = "switch",
            type = "checkbox"
          ),
          tags$label(`for` = "switch")
        )
      ),
      column(
        width = 9,
        id = "fileInput",
        conditionalPanel(
          "!input.switch",
          fileInput(
            "files", NULL, multiple = TRUE,
            buttonLabel = "Select two files at once..."
          )
        ),
        conditionalPanel(
          "input.switch",
          style = "display: none;",
          fluidRow(
            column(
              width = 6,
              fileInput(
                "file1", NULL,
                buttonLabel = "Select left file..."
              )
            ),
            column(
              width = 6,
              fileInput(
                "file2", NULL,
                buttonLabel = "Select right file..."
              )
            )
          )
        )
      ),
      column(
        width = 2,
        actionButton("swap", "Swap", class = "btn-lg btn-block mainPanel",
                     icon = icon("transfer", lib = "glyphicon"))
      )
    ),
    fluidRow(
      column(
        width = 10,
        tags$div(
          class = "mainPanel",
          selectizeInput(
            "language",
            NULL,
            languages,
            options = list(
              placeholder = "Select language...",
              onInitialize = I("onInitialize")
            )
          )
        )
      ),
      column(
        width = 2,
        actionButton(
          "close",
          "Close this panel",
          class = "btn-sm btn-block mainPanel",
          `data-toggle` = "tooltip",
          `data-placement` = "left",
          title = paste0(
            "Close this panel to gain some place. You can vertically resize the ",
            "editor windows by dragging the bottom border."
          )
        )
      )
    )
  ),
  fluidRow(
    class = "mainPanel",
    column(
      width = 12,
      fluidRow(
        id = "diffButtons-row",
        column(
          width = 1,
          actionButton("copyLeft", "Copy")
        ),
        column(
          width = 4,
          class = "files",
          tags$p(id = "fileLeft")
        ),
        column(
          width = 2,
          id = "diffButtons",
          `data-toggle` = "tooltip",
          `data-placement` = "top",
          title = paste0(
            "previous difference / next difference "
          ),
          actionButton(
            "prevDiff", NULL,
            icon = icon("triangle-top", lib = "glyphicon")
          ),
          actionButton(
            "nextDiff", NULL,
            icon = icon("triangle-bottom", lib = "glyphicon")
          )
        ),
        column(
          width = 4,
          class = "files",
          tags$p(id = "fileRight")
        ),
        column(
          width = 1,
          actionButton("copyRight", "Copy")
        )
      ),
      jqui_resizable(
        tags$div(
          id = "mergely-container",
          tags$div(id = "mergely")
        ),
        options = list(
          alsoResize = ".CodeMirror",
          handles = "s"
        )
      )
    )
  ),

  tags$div(
    class = "sky",
    tags$div(
      class = "night",
      do.call(tagList, rep(list(tags$div(class = "shooting_star")), 20L))
    )
  )

)
