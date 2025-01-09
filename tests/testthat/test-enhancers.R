tidypangenome_f <- system.file("extdata", "pangenome.gz", package = "tidygenomes")
ttg <- read_tidygenomes(tidypangenome_f)

# add_patterns()
test_that("Can add patterns to pangenome", {
    ttgp <- ttg %>% add_patterns()

    expect_true("pattern" %in% colnames(ttgp$orthogroups))
    expect_true("components" %in% names(ttgp))
    expect_true("patterns" %in% names(ttgp))

    expect_snapshot(ttgp$patterns)
})

# map_patterns()
test_that("Raise error when no tree present", {
    expect_error(ttg %>% map_patterns(),
    regexp = "No tree found")
})

# test_that("Raise error when no patterns present" , {

# })

# test_that("Can map patterns" , {
# TODO: add test object with tree
# })

# add_orthogroup_measures()
test_that("Raise error when gene table missing", {
    ttg_no_gene_table <- ttg
    ttg_no_gene_table$genes <- NULL
    expect_error(ttg_no_gene_table %>% add_orthogroup_measures(),
    regexp = "No gene table present")
})

test_that("Raise error when orthogroup missing", {
    ttg_no_gene_table <- ttg
    ttg_no_gene_table$orthogroups <- NULL
    expect_error(ttg_no_gene_table %>% add_orthogroup_measures(),
    regexp = "No orthogroup table present")
})

test_that("Can add orthogroup measures", {
    ttgn <- ttg %>% add_orthogroup_measures()
    expect_snapshot(ttgn$orthogroups)
})

# add_phylogroup_measures()

test_that("Raise error when no phylogroups present", {
    expect_error(ttg %>% add_phylogroup_measures(),
    regexp = "No phylogroups present")
})

# add_gcd()

# test_that("Can add gene content distance", {
#     ttgd <- ttg %>% add_gcd() # TODO: needs pairs!
# })