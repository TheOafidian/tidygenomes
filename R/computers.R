
#' Estimates the Heap coefficient for a pangenome
#'
#' This function samples a large amount of orthogroups per genome and then fits
#' a function through the resulting ratios to determine the Heap's coefficient
#' using formula P = kN^lambda
#' with P the amount of orthogroups, N the amount of genomes,
#' k an empiric parameter depending on the pangenome and lambda the Heap's coefficient.
#'
#' @param tg A tidygenomes object
#' @param permutations How many times the original data will be sampled for a range of genome numbers.
#' @param plot Whether to return a plot showing the datapoints and curve used to calculate the coefficient.
#' Defaults to true.
#' 
#' @return A genome table
#' 
#' @export
calculate_heap_coefficient <- function(tg, permutations=10, plot=FALSE) {

  # TODO: calculate a smart # permutations and steps based on size of pangenome
  ngenomes <- nrow(tg$genomes)
  select_ngenomes <- seq(1, ngenomes, by=ceiling(ngenomes/200))

  # Calculates the # orthogroups per # of genomes
  ## do this X permutations to get a general idea
  inner_loop <- function() {
  selected_genomes <- sapply(select_ngenomes, function(x) sample(tg$genomes$genome, x))
  get_n_orthogroups_for_genomes <- function(tg, genomes) {
    tg %>% 
    filter_genomes(genome %in% genomes) %>% 
    genes() %>% 
    summarize(orthogroups = n_distinct(orthogroup)) %>%
    pull(orthogroups)
  }
  orthogroups <- sapply(selected_genomes, function(x) get_n_orthogroups_for_genomes(tg, x))
  data <- tibble(ngenomes=select_ngenomes,orthogroups=orthogroups)
  }

  combined_data <- tibble()
  for (i in seq(1,permutations)) {
    message(paste("Running permutation",i))
    perm_data <- inner_loop()
    combined_data <- bind_rows(combined_data, perm_data)
  }
  fit <- tryCatch ({
   return(
       nls(orthogroups~a*ngenomes^b, start=list(a=1,b=0.4), data=combined_data)
   )}, error = function(msg) {
   message("Nonlinear regression failed; likely you have too little genomes.")
   message("Using a log transformed verion of the formula")
   return(
       lm(log(orthogroups)~log(ngenomes), data=combined_data)
   )})
   result <- summary(fit)
   a <- result$coefficients[1, 1]
   b <- result$coefficients[2, 1]

  results <- list(
    model = fit,
    data = combined_data,
    heap = b,
    plot = plot
  )

  if (plot) {
      if (any(fit$call %>% as.character() %>% startsWith("lm"))) {
        results$plot <-combined_data %>%
        ggplot(aes(x=log(ngenomes), y=log(orthogroups))) +
        geom_point() +
        geom_smooth(method = "lm", color = "red")
      } else {
      results$plot <- combined_data %>%
      ggplot(aes(x = ngenomes, y = orthogroups)) +
      geom_point() +
      stat_function(fun = function(x) a * x^b, color = "red")
      }
  }

  return(results)
}
