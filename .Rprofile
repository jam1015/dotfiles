#invisible(
#    .libPaths(
#        c(file.path("/Users/jordanmandel/R_packs", R.Version()$major), .libPaths())
#    )
#)

# improved list of objects
# invisible(
# options(
# repos = c(options()$repos,BiocManager::repositories())
# )
# )

utils::chooseCRANmirror <- function(ind = NULL, local.only = FALSE, 
                                    graphics = FALSE, 
                                    CRAN = getOption("repos")[["CRAN"]]) 
{
  utils:::choose_mirror(ind = ind, local.only = local.only,
                        graphics = graphics, CRAN = CRAN)
}

invisible(require(colorout))
options(
    browser = "firefox-developer-edition", tabSize = 4
)

invisible(
    options(
        languageserver.formatting_style = function(options) {
            styler::tidyverse_style(indent_by = 4)
        }
    )
)

print("welcome to R JordanadroJ R ot emoclew")
