# global_packages.R
# This script installs/updates CRAN, Bioconductor, and GitHub packages only when needed.

### CRAN PACKAGES ###

cran_packages <- c("dplyr", "ggplot2", "tidyr")

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

bioc_packages <- c("GenomicRanges", "Biostrings")

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
