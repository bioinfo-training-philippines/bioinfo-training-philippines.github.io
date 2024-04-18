pacman::p_load(dplyr, tidyr, ggtree, treeio, ggplot2)

## read in trees
# treeio package has many read.* functions.
# eg read.beast, read.newick
tree = treeio::read.iqtree("~/Desktop/Influenza_A_H3N2_HA.fasta.treefile")
# read in meta data, csv or tsv
# first column must match the tree labels/taxa
meta = read.csv("~/Desktop/meta.csv", sep = "\t")

# similar to ggplot, use `ggtree` function to start the plotting
plot = ggtree(tree) %<+% meta
# now add your first genome - geom_tiplab as taxa names
plot = plot +
    geom_tiplab(aes(color = country), size = 5, offset = 0.001)

# next we can add tip points, these are usually little circles. In this case we 
# binding the shape to the variable "year"
plot = p +
    geom_tippoint(aes(fill = factor(year),shape = factor(year)), size = 2)
# next we add the bootstrap values to the branches.
# this is tricky as we have to combine the two values
# we use paste to do this
# we also filter to only show high quality support
# this is advance! thanks mr mysterious
plot = p +
    geom_text(aes(x=branch, label = paste(SH_aLRT, "/", UFboot, sep = "")),
              size = 2, vjust = -1,
              data = td_filter(SH_aLRT > 85 & UFboot > 90))
# this adds a vertical bar next to a clade
# use as input the names of the top and bottom taxa
plot = p + 
    geom_strip("A_Wisconsin_33_2020", 
               "A_Iowa_17_2020", 
               color = "red", 
               label ="fake_clade_1", offset = 0.015) + 
    # this adds clade colors
    geom_hilight(node = 57, color = "steelblue", extend=0.02)

# finally we modify some of the default settings to look better
plot = p +
    xlim(NA, 0.05) + 
    scale_color_viridis_d() + 
    scale_fill_viridis_d() +
    geom_treescale(x = 0.01, y = 5)
    
# thenb we save on a a4 page
ggsave(filename = "~/Desktop/test.pdf", plot, width = 210, height = 297, units = "mm")

# everything combined





plot = ggtree(tree) %<+% meta +
    geom_tiplab(aes(color = country), size = 5, offset = 0.001) +
    geom_tippoint(aes(fill = factor(year),shape = factor(year)), size = 2) +
    geom_text(aes(x=branch, label = paste(SH_aLRT, "/", UFboot, sep = "")),
              size = 2, vjust = -1,
              data = td_filter(SH_aLRT > 85 & UFboot > 90)) +
    geom_strip("A_Wisconsin_33_2020", 
               "A_Iowa_17_2020", 
               color = "red", 
               label ="fake_clade_1", offset = 0.015) + 
    geom_hilight(node = 57, color = "steelblue", extend=0.02)+
    xlim(NA, 0.05) + 
    scale_color_viridis_d() + 
    scale_fill_viridis_d() +
    geom_treescale(x = 0.01, y = 5)
plot
