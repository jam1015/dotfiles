# global_packages.R
# This script installs/updates CRAN, Bioconductor, and GitHub packages only when needed.

### CRAN PACKAGES ###

cran_packages <- c("dplyr", "ggplot2", "tidyr",
"askpass"        ,   "backports"     ,    "base64enc"        , 
"bit"            ,   "bit64"         ,    "blob"             , 
"broom"          ,   "bslib"         ,    "cachem"           , 
"callr"          ,   "cellranger"    ,    "cli"              , 
"clipr"          ,   "colorspace"    ,    "conflicted"       , 
"cpp11"          ,   "crayon"        ,    "curl"             , 
"data.table"     ,   "DBI"           ,    "dbplyr"           , 
"digest"         ,   "dplyr"         ,    "dtplyr"           , 
"evaluate"       ,   "fansi"         ,    "farver"           , 
"fastmap"        ,   "fontawesome"   ,    "forcats"          , 
"fs"             ,   "gargle"        ,    "generics"         , 
"ggplot2"        ,   "glue"          ,    "googledrive"      , 
"googlesheets4"  ,   "gtable"        ,    "haven"            , 
"highr"          ,   "hms"           ,    "htmltools"        , 
"httr"           ,   "ids"           ,    "isoband"          , 
"jquerylib"      ,   "jsonlite"      ,    "knitr"            , 
"labeling"       ,   "lifecycle"     ,    "lubridate"        , 
"magrittr"       ,   "memoise"       ,    "mime"             , 
"modelr"         ,   "munsell"       ,    "NCmisc"           , 
"nvimcom"        ,   "openssl"       ,    "pillar"           , 
"pkgconfig"      ,   "prettyunits"   ,    "processx"         , 
"progress"       ,   "ps"            ,    "purrr"            , 
"R.cache"        ,   "R.methodsS3"   ,    "R.oo"             , 
"R.utils"        ,   "R6"            ,    "ragg"             , 
"rappdirs"       ,   "RColorBrewer"  ,    "reader"           , 
"readr"          ,   "readxl"        ,    "rematch"          , 
"rematch2"       ,   "renv"          ,    "reprex"           , 
"rlang"          ,   "rmarkdown"     ,    "rstudioapi"       , 
"rvest"          ,   "sass"          ,    "scales"           , 
"selectr"        ,   "stringi"       ,    "stringr"          , 
"styler"         ,   "sys"           ,    "systemfonts"      , 
"textshaping"    ,   "tibble"        ,    "tidyr"            , 
"tidyselect"     ,   "tidyverse"     ,    "timechange"       , 
"tinytex"        ,   "tzdb"          ,    "utf8"             , 
"uuid"           ,   "vctrs"         ,    "viridisLite"      , 
"vroom"          ,   "withr"         ,    "xfun"             , 
"xml2"           ,   "yaml"          ,    "base"             , 
"base64enc"      ,   "boot"          ,    "brio"             , 
"class"          ,   "classInt"      ,    "cluster"          , 
"codetools"      ,   "colorspace"    ,    "compiler"         , 
"crayon"         ,   "datasets"      ,    "diffobj"          , 
"digest"         ,   "e1071"         ,    "evaluate"         , 
"fansi"          ,   "farver"        ,    "fontBitstreamVera", 
"fontLiberation" ,   "foreign"       ,    "fs"               , 
"glue"           ,   "graphics"      ,    "grDevices"        , 
"grid"           ,   "hexbin"        ,    "highr"            , 
"jsonlite"       ,   "KernSmooth"    ,    "knitr"            , 
"labeling"       ,   "lattice"       ,    "magrittr"         , 
"mapproj"        ,   "maps"          ,    "MASS"             , 
"Matrix"         ,   "MatrixModels"  ,    "methods"          , 
"mgcv"           ,   "munsell"       ,    "nlme"             , 
"nnet"           ,   "nortest"       ,    "parallel"         , 
"pkgconfig"      ,   "praise"        ,    "prettyunits"      , 
"proxy"          ,   "ps"            ,    "quantreg"         , 
"RColorBrewer"   ,   "Rcpp"          ,    "rpart"            , 
"rprojroot"      ,   "RUnit"         ,    "sp"               , 
"SparseM"        ,   "spatial"       ,    "splines"          , 
"stats"          ,   "stats4"        ,    "survival"         , 
"tcltk"          ,   "testit"        ,    "tinytest"         , 
"tools"          ,   "units"         ,    "utf8"             , 
"utils"          ,   "viridisLite"   ,    "withr"            , 
"xfun"           ,   "yaml"
)

# Get list of installed packages and available CRAN packages
installed_pkgs <- installed.packages()[, "Package"]
available_pkgs <- available.packages()

# Helper function: returns TRUE if a package is not installed or is older than the CRAN version.
is_missing_or_outdated <- function(pkg) {
  if (!(pkg %in% installed_pkgs)) {
    return(TRUE)
  } else {
    installed_ver <- packageVersion(pkg)
    # Check if package is available on CRAN (it might not be if it's not a CRAN package)
    if (!pkg %in% rownames(available_pkgs)) {
      return(FALSE)
    }
    available_ver <- package_version(available_pkgs[pkg, "Version"])
    return(installed_ver < available_ver)
  }
}

# Identify which CRAN packages need to be installed or updated
to_install <- cran_packages[sapply(cran_packages, is_missing_or_outdated)]
if (length(to_install) > 0) {
  message("Installing/updating CRAN packages: ", paste(to_install, collapse = ", "))
  install.packages(to_install)
} else {
  message("All CRAN packages are up-to-date.")
}


### BIOCONDUCTOR PACKAGES ###

bioc_packages <- c("GenomicRanges", "Biostrings","pkgKitten","BiocFileCache")

# Ensure BiocManager is available, then install/update Bioconductor packages.
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}
message("Installing/updating Bioconductor packages...")
# BiocManager::install() handles missing/out-of-date packages automatically.
BiocManager::install(bioc_packages, ask = FALSE, update = TRUE)


### GITHUB PACKAGES ###

# Ensure devtools is available for GitHub installations.
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# List GitHub packages in "username/repository" format.
github_packages <- c("hadley/emo")

# Use upgrade = "default" to update out-of-date GitHub packages.
for (gh_pkg in github_packages) {
  message("Installing/updating GitHub package: ", gh_pkg)
  devtools::install_github(gh_pkg, upgrade = "default")
}
