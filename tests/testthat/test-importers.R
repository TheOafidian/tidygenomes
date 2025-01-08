pangenome_f <- system.file("extdata", "pangenome.tsv", package = "tidygenomes")
colnames_pan <- c("gene", "genome", "orthogroup")
suppressMessages(
  pangenome_data <- readr::read_table(pangenome_f, col_names = colnames_pan)  
)
genome_data <- dplyr::select(pangenome_data, -c(gene, orthogroup))
genome_data <- dplyr::distinct(genome_data)  
tidygenomes_class <- "tidygenomes"

test_that("Can read a genome table", {
  testthat::expect_message(
    tg <- as_tidygenomes(genome_data),
    regexp = "Creating tidygenomes object from genome table"
  )
  testthat::expect_s3_class(tg, tidygenomes_class)
})

test_that("Can read a pangenome table", {
  testthat::expect_message(
    tg <- as_tidygenomes(pangenome_data),
    "Creating tidygenomes object from pangenome table"
  )
  testthat::expect_s3_class(tg, tidygenomes_class)
})

test_that("Can read a genome tree", {
  # read in physeq tree
  tree_f <- system.file("extdata", "biom-tree.phy", package = "phyloseq")
  tree_phy <- phyloseq::read_tree(tree_f)

  testthat::expect_message(
    tg <- as_tidygenomes(tree_phy),
    "Creating tidygenomes object from genome tree"
  )
  testthat::expect_s3_class(tg, tidygenomes_class)
  testthat::expect_s3_class(tg$tree, "phylo")
})

# test_that("Can read a genome pair table",{
    
# })

test_that("Throw error when data has overlapping data", {
  testthat::expect_message(
    tg <- as_tidygenomes(pangenome_data),
    "Creating tidygenomes object from pangenome table"
  )
  testthat::expect_message(
    tg2 <- as_tidygenomes(pangenome_data),
    "Creating tidygenomes object from pangenome table"
  )
  expect_error(
    tg_merge <- add_tidygenomes(tg, tg2),
    "contain overlapping components"
  )
})

test_that("Can add tidygenomes object to tidygenomes object", {
    testthat::expect_message(
      tg <- as_tidygenomes(genome_data),
      "Creating tidygenomes object from genome table"
    )
    tg_merge <- add_tidygenomes(tg, pangenome_data)
    expect_s3_class(tg_merge, "tidygenomes")
})