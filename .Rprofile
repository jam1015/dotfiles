options(menu.graphics = FALSE)

if (interactive()) {
  options(
    browser = "firefox",
    tabSize = 4,
    lintr.linter_file = "~/.lintr"
  )

  if (requireNamespace("styler", quietly = TRUE)) {
    options(
      languageserver.formatting_style = function(options) {
        styler::tidyverse_style(indent_by = 2)
      }
    )
  }

  .ls_objects <- function(pos = 1, pattern,
                          order_by, decreasing = FALSE, head = FALSE, n = 5) {
    napply <- function(names, fn) {
      sapply(names, function(x) {
        fn(get(x, pos = pos))
      })
    }
    names <- ls(pos = pos, pattern = pattern)
    obj_class <- napply(names, function(x) as.character(class(x))[1])
    obj_mode <- napply(names, mode)
    obj_type <- ifelse(is.na(obj_class), obj_mode, obj_class)
    obj_prettysize <- napply(names, function(x) {
      format(utils::object.size(x), units = "auto")
    })
    obj_size <- napply(names, object.size)
    obj_dim <- t(napply(names, function(x) {
      as.numeric(dim(x))[1:2]
    }))
    vec <- is.na(obj_dim)[, 1] & (obj_type != "function")
    obj_dim[vec, 1] <- napply(names, length)[vec]
    out <- data.frame(obj_type, obj_size, obj_prettysize, obj_dim)
    names(out) <- c("Type", "Size", "PrettySize", "Length/Rows", "Columns")
    if (!missing(order_by)) {
      out <- out[order(out[[order_by]], decreasing = decreasing), ]
    }
    if (head) {
      out <- head(out, n)
    }
    out
  }

  lsos <- function(..., n = 10000) {
    .ls_objects(..., order_by = "Size", decreasing = TRUE, head = TRUE, n = n)
  }


  .r_pkg_dir <- "~/dotfiles/r_packages"
  if (!dir.exists(.r_pkg_dir)) dir.create(.r_pkg_dir, recursive = TRUE)

  .append_to_manifest <- function(pkgs, file) {
    path <- file.path(.r_pkg_dir, file)
    existing <- if (file.exists(path)) readLines(path, warn = FALSE) else character()
    new <- setdiff(pkgs, existing)
    if (length(new) > 0) {
      writeLines(sort(unique(c(existing, new))), path)
      message("Added to ", file, ": ", paste(new, collapse = ", "))
    }
  }

  .original_install.packages <- utils::install.packages
  install.packages <- function(pkgs, ...) {
    .original_install.packages(pkgs, ...)
    .append_to_manifest(pkgs, "cran.csv")
  }

  # BiocManager — lazy since it may not be loaded yet
  .hook_bioc <- function() {
    if ("BiocManager" %in% loadedNamespaces()) {
      env <- asNamespace("BiocManager")
      if (!exists(".original_bioc_install", envir = .GlobalEnv)) {
        assign(".original_bioc_install", BiocManager::install, envir = .GlobalEnv)
        assignInNamespace("install", function(pkgs = character(), ...) {
          .original_bioc_install(pkgs, ...)
          if (length(pkgs) > 0) .append_to_manifest(pkgs, "bioc.csv")
        }, ns = "BiocManager")
      }
    }
  }
  setHook(packageEvent("BiocManager", "onLoad"), function(...) .hook_bioc())

  # pak
  .hook_pak <- function() {
    if (!exists(".original_pak", envir = .GlobalEnv)) {
      assign(".original_pak", pak::pak, envir = .GlobalEnv)
      assignInNamespace("pak", function(pkg, ...) {
        .original_pak(pkg, ...)
        .append_to_manifest(pkg, "github.csv")
      }, ns = "pak")
    }
  }
  setHook(packageEvent("pak", "onLoad"), function(...) .hook_pak())


  message("welcome to R JordanadroJ R ot emoclew")
}
