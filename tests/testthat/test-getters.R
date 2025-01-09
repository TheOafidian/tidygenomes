tidypangenome_f <- system.file("extdata", "pangenome.gz", package = "tidygenomes")
ttg <- read_tidygenomes(tidypangenome_f)

test_that("Raise error when no tree available", {
  expect_error(get_tree(ttg), "No tree available")
})

test_that("Return a pangenome matrix", {
    M <- pangenome_matrix(ttg)
    expect_contains(class(M), "matrix")
    expect_type(M, "double")
})

