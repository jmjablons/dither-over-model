today <- function() stringr::str_remove_all(Sys.Date(), pattern = "-")
defaultfile <- function(.set = temp_set, .output = "result_model"){
  paste0("result/",.output,"_",.set,"_",today(),".rds")}
