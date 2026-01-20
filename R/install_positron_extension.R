#' @title Install Positron Extension
#' @description Manually installs the requested Positron extension.
#' @param extension_url character; The URL to an extension VSIX file.
#' @details
#' Check [open-vsx.org](https://open-vsx.org/?search=posit&sortBy=relevance&sortOrder=desc)
#' for the latest versions of extensions available for Positron.
#' Find the `Download` button, copy the link, and provide that
#' url to this function.
#'
#' @returns Nothing. Installs the Positron extension.
#'
#' @export
install_positron_extension <- function(extension_url) {
  # Define files and folders
  extension_filename <- basename(extension_url)
  extension_version <- tools::file_path_sans_ext(extension_filename)
  temp_dir <- tempdir(check = TRUE)
  version_dir <- file.path(temp_dir, extension_version)
  if (!dir.exists(version_dir)) {
    dir.create(version_dir)
  }
  downloaded_vsix <- file.path(temp_dir, extension_filename)

  # Download extension as vsix file
  download.file(
    url = extension_url,
    destfile = downloaded_vsix,
    method = "curl",
    mode = "wb",
    extra = "-L"
  )

  # Get extension package metadata
  tryCatch(
    {
      unzip(
        zipfile = downloaded_vsix,
        files = "extension/package.json",
        exdir = version_dir
      )
    },
    error = function(e) {
      stop("Failed to extract package.json from VSIX: ", e$message)
    }
  )

  package_json_path <- file.path(version_dir, "extension", "package.json")
  package_data <- jsonlite::fromJSON(package_json_path)
  ext_name <- paste0(package_data$publisher, ".", package_data$name)
  required_version <- package_data$engines$positron
  if (is.null(required_version)) {
    min_version <- NULL
  } else {
    # Remove ^ or >= prefix to get the minimum version
    min_version <- gsub("^[\\^>=]+", "", required_version)
    # Handle versions with 'x' wildcards (e.g., "^2025.1.x")
    min_version <- gsub("\\.x$", ". 0", min_version)
  }
  positron_version <- Sys.getenv("POSITRON_VERSION")
  if (is.null(positron_version) || positron_version == "") {
    positron_version <- NULL
  } 

  # Compare versions
  ## Positron version not set = compatible NA
  if (is.null(positron_version)) { # not set: NA
    is_compatible <- NA
    reason = "Installed Positron version can't be determined"
  } else if (is.null(min_version) || min_version == "*") { # No requirement: compatible
    is_compatible <- TRUE
    reason = "No minimum Positron version specified"
  } else if (numeric_version(positron_version) >= numeric_version(min_version)) { # > min: compatible
    is_compatible <- TRUE
    reason = "Installed Positron version meets the extension minimum version"
  } else {
    is_compatible <- FALSE
    reason = "Installed Positron version does not meet the extension minimum required version"
  }

  if (is_compatible) {
    system(
      paste("positron --install-extension", shQuote(downloaded_vsix))
    )
  }

  compatibility <- list(
    compatible = is_compatible,
    extension = ext_name,
    extension_version = package_data$version,
    positron_version = positron_version,
    required_version = required_version,
    reason = reason
  )
  return(compatibility)
}
