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


options(menu.graphics = FALSE)
#invisible(require(colorout))
options(
    browser = "firefox-developer-edition", tabSize = 4
)

invisible(
    options(
        languageserver.formatting_style = function(options) {
            styler::tidyverse_style(indent_by = 2)
        }
    )
)

.ls.objects <- function(pos = 1, pattern, order.by, decreasing = FALSE, head = FALSE, n = 5) {
    napply <- function(names, fn) {
        sapply(names, function(x) {
            fn(get(x, pos = pos))
        })
    }
    names <- ls(pos = pos, pattern = pattern)
    obj.class <- napply(names, function(x) as.character(class(x))[1])
    obj.mode <- napply(names, mode)
    obj.type <- ifelse(is.na(obj.class), obj.mode, obj.class)
    obj.prettysize <- napply(names, function(x) {
        format(utils::object.size(x), units = "auto")
    })
    obj.size <- napply(names, object.size)
    obj.dim <- t(napply(names, function(x) {
        as.numeric(dim(x))[1:2]
    }))
    vec <- is.na(obj.dim)[, 1] & (obj.type != "function")
    obj.dim[vec, 1] <- napply(names, length)[vec]
    out <- data.frame(obj.type, obj.size, obj.prettysize, obj.dim)
    names(out) <- c("Type", "Size", "PrettySize", "Length/Rows", "Columns")
    if (!missing(order.by)) {
        out <- out[order(out[[order.by]], decreasing = decreasing), ]
    }
    if (head) {
        out <- head(out, n)
    }
    out
}

#' @export
lsos <- function(..., n = 10000) {
    .ls.objects(..., order.by = "Size", decreasing = TRUE, head = TRUE, n = n)
}



print("welcome to R JordanadroJ R ot emoclew")
