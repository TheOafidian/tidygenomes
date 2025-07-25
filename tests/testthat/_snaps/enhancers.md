# Can add patterns to pangenome

    Code
      ttgp$patterns
    Output
      # A tibble: 7 x 2
        pattern frequency
        <chr>       <int>
      1 p1             57
      2 p2            105
      3 p3           1006
      4 p4             67
      5 p5             26
      6 p6             10
      7 p7             46

# Can add orthogroup measures

    Code
      ttgn$orthogroups
    Output
      # A tibble: 1,317 x 3
         orthogroup og_genes og_genomes
         <chr>         <int>      <int>
       1 F0315_01          3          3
       2 F0315_02          3          3
       3 F0315_03          3          3
       4 F0315_04          3          3
       5 F0315_05          3          3
       6 F0315_06          3          3
       7 F0315_07          1          1
       8 F0315_08          3          3
       9 F0315_09          3          3
      10 F0315_10          3          3
      # i 1,307 more rows

