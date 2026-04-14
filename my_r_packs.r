# my_r_packs.r
# Installs/updates CRAN, Bioconductor, and GitHub packages from CSV manifests.

options(repos = c(CRAN = "https://cloud.r-project.org"))

pkg_dir <- "~/dotfiles/r_packages"

read_manifest <- function(file) {
  path <- file.path(pkg_dir, file)
  if (file.exists(path)) {
    pkgs <- readLines(path, warn = FALSE)
    pkgs[nzchar(trimws(pkgs))]
  } else {
    message("Manifest not found: ", path)
    character()
  }
}

### CRAN PACKAGES ###
cran_packages <- read_manifest("cran.csv")

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
bioc_packages <- read_manifest("bioc.csv")

if (length(bioc_packages) > 0) {
  if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
  }
  BiocManager::install(bioc_packages, ask = FALSE, update = FALSE)
} else {
  message("No Bioconductor packages in manifest.")
}

### GITHUB PACKAGES ###
github_packages <- read_manifest("github.csv")

if (length(github_packages) > 0) {
  if (!requireNamespace("pak", quietly = TRUE)) {
    install.packages("pak")
  }
  for (gh_pkg in github_packages) {
    message("Installing/updating GitHub package: ", gh_pkg)
    pak::pak(gh_pkg)
  }
} else {
  message("No GitHub packages in manifest.")
}
