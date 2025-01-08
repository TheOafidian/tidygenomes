tidypangenome_f <- system.file("extdata", "pangenome.gz", package = "tidygenomes")

test_that("Can read a tidygenomes saved object", {
    tg <- read_tidygenomes(tidypangenome_f)
    expect_s3_class(tg, "tidygenomes")
})

test_that("Can write a tidygenomes object", {
    tg <- read_tidygenomes(tidypangenome_f)
    write_tidygenomes(tg, "tidypangenome_test.gz")
    tg2 <- read_tidygenomes("tidypangenome_test.gz")
    expect_s3_class(tg2, "tidygenomes")
    unlink("tidypangenome_test.gz")
})
