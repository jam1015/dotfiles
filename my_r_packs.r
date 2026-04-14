# my_r_packs.r
# Installs/updates CRAN, Bioconductor, and GitHub packages only when needed.

options(repos = c(CRAN = "https://cloud.r-project.org"))

### CRAN PACKAGES ###
cran_packages <- unique(c(
  # tidyverse core
  "tidyverse", "dplyr", "ggplot2", "tidyr", "purrr", "readr", "tibble",
  "stringr", "forcats", "lubridate",

  # tidyverse adjacent
  "broom", "dbplyr", "dtplyr", "googledrive", "googlesheets4",
  "haven", "modelr", "readxl", "reprex", "rvest", "conflicted",

  # completion / dev
  "data.table", "DBI", "renv", "styler", "knitr", "rmarkdown",
  "quarto", "tinytex", "ragg",

  # infrastructure
  "cli", "rlang", "glue", "vctrs", "pillar", "lifecycle", "R6",
  "withr", "memoise", "cachem", "fastmap",

  # io / web
  "curl", "httr", "jsonlite", "xml2", "yaml", "openssl", "askpass",
  "mime", "gargle", "ids", "uuid",

  # string / text
  "stringi", "clipr", "crayon",

  # graphics support
  "scales", "farver", "colorspace", "viridisLite", "RColorBrewer",
  "isoband", "munsell", "labeling", "gtable", "systemfonts",
  "textshaping", "fontawesome",

  # html / web rendering
  "htmltools", "bslib", "jquerylib", "sass", "selectr",

  # data formats
  "bit", "bit64", "blob", "cellranger", "hms", "timechange", "tzdb",
  "vroom", "readr",

  # process / system
  "callr", "processx", "ps", "sys", "fs", "rappdirs", "prettyunits",
  "progress",

  # misc
  "digest", "base64enc", "cpp11", "evaluate", "highr", "xfun",
  "backports", "rematch", "rematch2", "generics", "pkgconfig",
  "fansi", "utf8",

  # R utilities
  "R.cache", "R.methodsS3", "R.oo", "R.utils", "NCmisc", "nvimcom",
  "reader",

  # spatial / stats
  "e1071", "proxy", "classInt", "sp", "units", "maps", "mapproj",
  "hexbin", "quantreg", "SparseM", "MatrixModels", "nortest",

  # testing / packaging
  "brio", "diffobj", "praise", "rprojroot", "RUnit", "Rcpp",

  # fonts
  "fontBitstreamVera", "fontLiberation"
))

# Filter out base packages that can't be updated
base_pkgs <- rownames(installed.packages(priority = "base"))
cran_packages <- setdiff(cran_packages, base_pkgs)

installed_pkgs <- installed.packages()[, "Package"]
available_pkgs <- available.packages()

is_missing_or_outdated <- function(pkg) {
  if (!(pkg %in% installed_pkgs)) return(TRUE)
  if (!(pkg %in% rownames(available_pkgs))) return(FALSE)
  packageVersion(pkg) < package_version(available_pkgs[pkg, "Version"])
}

to_install <- cran_packages[sapply(cran_packages, is_missing_or_outdated)]
if (length(to_install) > 0) {
  message("Installing/updating CRAN packages: ", paste(to_install, collapse = ", "))
  install.packages(to_install)
} else {
  message("All CRAN packages are up-to-date.")
}

### BIOCONDUCTOR PACKAGES ###
bioc_packages <- c("GenomicRanges", "Biostrings", "pkgKitten", "BiocFileCache")

if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

# update = FALSE prevents BiocManager from trying to update system library packages
BiocManager::install(bioc_packages, ask = FALSE, update = FALSE)

### GITHUB PACKAGES ###
if (!requireNamespace("pak", quietly = TRUE)) {
  install.packages("pak")
}

github_packages <- c("hadley/emo", "jalvesaq/colorout", "git::https://gitlab.com/djvanderlaan/terminalgraphics.git")

for (gh_pkg in github_packages) {
  message("Installing/updating GitHub package: ", gh_pkg)
  pak::pak(gh_pkg)
}
