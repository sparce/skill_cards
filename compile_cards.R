library(googlesheets)
library(rmarkdown)
library(staplr)
library(pagedown)

gs_auth(cache=T)
sheet <- gs_key("1pVDMAY6-BM22BIzeIHffbtRGcAF7e0lcXcuLlXMom0w")

skills <- gs_read(sheet)$skill

for (i in seq_along(skills)) {
  
  render(
    "front.Rmd", 
    output_file = glue::glue("Cards/components/{skills[i]}_front.html"), 
    params = list(skill = i)
    )
  
  render(
    "back.Rmd", 
    output_file = glue::glue("Cards/components/{skills[i]}_back.html"), 
    params = list(skill = i)
  )
  
  pagedown::chrome_print(
    input = glue::glue("Cards/components/{skills[i]}_front.html"), 
    output = glue::glue("Cards/components/{skills[i]}_front.pdf"), 
    options = list(preferCSSPageSize=T, marginTop=0, marginBottom=0,marginLeft=0,marginRight=0)
    )
  
  pagedown::chrome_print(
    input = glue::glue("Cards/components/{skills[i]}_back.html"), 
    output = glue::glue("Cards/components/{skills[i]}_back.pdf"), 
    options = list(preferCSSPageSize=T, marginTop=0, marginBottom=0,marginLeft=0,marginRight=0)
  )
  
  staple_pdf(
    input_files = c(
      glue::glue("Cards/components/{skills[i]}_front.pdf"),  
      glue::glue("Cards/components/{skills[i]}_back.pdf")
      ),
    output_filepath = glue::glue("Cards/{skills[i]}_combined.pdf")
    )
}
