# Load required library
source("functions.R")

# Generate Plot
p1 = generate_plot(Norm=T, #Logical: Show normal distribution
                   Chisq=T, #Logical: show Chi-Square distribution
                   norm_vals = c(4, .9), #vector of mean and sd for Normal dist (ignored if Norm=F)
                   chisq_vals = c(3,0 ), #vector of DF and non centrality for chi-sq (Ignored if Chisq=F)
                   amp=0.015,  #amplitude of SIN wave to create double helix; adjusts height of strand
                   freq=10, #frequency of SIN wave to create double helix; adjusts width of strands
                   bp_density= 200, #how dense the base-pairs between strands appear (200 is default; higher = more dense)
                   xlims= c(0,8), # vector of min and max x-values for distribution generation and plot
                   ylims= c(-0.05, .5),  #vector of y limits for height of plot
                   text="Biostatistics \nand Data Science",  #optional text to add to plot
                   text_pos = c(4,.015), #vector of (x,y) coordinates for text on plot
                   text_size=7, #text size 
                   helix_cols = c("cyan3", "cyan4",
                                  "firebrick2", "firebrick4"), #color of helix strands
                   basepair_cols = c("darkorange3", "darkred",
                                     "darkblue", "darkgreen") #Colors for connected base-pairs
                   )
#Show plot
p1




