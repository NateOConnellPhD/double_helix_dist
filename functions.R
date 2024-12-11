library(ggplot2)
library(ggimage)
library(dplyr)


#Plot generation function
generate_plot = function(Norm=T, #Logical: Show normal distribution
                         Chisq=F, #Logical: show Chi-Square distribution
                         norm_vals = c(3, 1), #vector of mean and sd for Normal dist (ignored if Norm=F)
                         chisq_vals = c(2,0), #vector of DF and non centrality for chi-sq (Ignored if Chisq=F)
                         amp=0.02, #amplitude of SIN wave to create double helix; adjusts height of strand
                         freq=10, #frequency of SIN wave to create double helix; adjusts width of strands
                         xlims= c(0,10), # vector of min and max x-values for distribution generation and plot
                         ylims= c(-0.05, .45), #vector of y limits for height of plot
                         text="", #optional text to add to plot
                         text_pos = c(3,0), #vector of (x,y) coordinates for text on plot
                         text_size=12, #test size 
                         text_col = "cyan4", #color ot text
                         helix_cols = c("cyan3", "cyan4", 
                                        "firebrick2", "firebrick4"), #color of helix strands
                         basepair_cols = c("darkorange3", "darkred",
                                           "darkblue", "darkgreen"),
                         background_col = "azure1") #color of basepairs
                         { 
  # Define the range for x values
  x <- seq(xlims[1], xlims[2], length.out = 200)
  
  # Standard normal distribution
  y <- dnorm(x, mean=norm_vals[1], sd=norm_vals[2])
  y_chi <- dchisq(x, chisq_vals[1], chisq_vals[2])
  
  # Double helix effect
  # Define two sinusoidal patterns, shifted in phase
  y1 <- y + amp * sin(freq * x)
  y2 <- y - amp * sin(freq * x)
  
  y_chi1 <- y_chi + amp * sin(freq * x)
  y_chi2 <- y_chi - amp * sin(freq * x)
  
  # Create a data frame for the helices
  data <- data.frame(x = c(x, x, x, x), 
                     y = c(y1, y2, y_chi1, y_chi2), 
                     group = rep(c("Helix1", "Helix2", "Helix3", "Helix4"), each = length(x)),
                     dist = rep(c("Normal", "Normal", "Chisq", "Chisq"), each=length(x)))
  
  # data_chi = data.frame(x = c(x, x), 
  #                       y = c(y_chi1, y_chi2), 
  #                       group = rep(c("Helix3", "Helix4"), each = length(x)))
  # 
  
  # Create a data frame for base pair connections
  base_pairs <- data.frame(x = c(x,x),
                           y1 = c(y1,y_chi1),
                           y2 = c(y2, y_chi2),
                           dist=c(rep("Norm", length(x)), rep("Chisq", length(x))))
  
  
  # Define possible pairs of bases
  base_pairs_options <- c("Adenine-Thymine", "Thymine-Adenine", 
                          "Cytosine-Guanine", "Guanine-Cytosine")
  
  # Randomly assign base pair types
  set.seed(42) # Set seed for reproducibility
  base_pairs$base_type <- sample(base_pairs_options, length(x), replace = TRUE)
  
  #Add empty space between base pairs
  
  # Calculate the midpoint between the two helices for each x
  base_pairs$mid_y <- (base_pairs$y1 + base_pairs$y2) / 2
  #base_pairs$mid_y_chi <- (base_pairs$y_chi1 + base_pairs$y_chi2) / 2
  
  # Define colors for each base pair based on the base type
  color_start <- ifelse(base_pairs$base_type == "Adenine-Thymine",  basepair_cols[1], 
                        ifelse(base_pairs$base_type == "Thymine-Adenine", basepair_cols[1], 
                               ifelse(base_pairs$base_type=="Cytosine-Guanine", basepair_cols[3], basepair_cols[4])))
  
  color_end <- ifelse(base_pairs$base_type == "Adenine-Thymine",  basepair_cols[1], 
                      ifelse(base_pairs$base_type == "Thymine-Adenine", basepair_cols[1], 
                             ifelse(base_pairs$base_type=="Cytosine-Guanine",  basepair_cols[4], basepair_cols[3])))
  
  #Include/exclude distributions
  include = c(rep(Norm, 2*length(x)), rep(Chisq, 2*length(x)))
  data = data[include,]
  
  include = c(rep(Norm, length(x)), rep(Chisq, length(x)))
  base_pairs = base_pairs[include,]
  color_start = color_start[include]
  color_end = color_end[include]
  
  # Plot with ggplot2 and add the base pairs
  ggplot() +
    # Add the base pair lines in two segments: helix to midpoint, midpoint to helix
    geom_segment(data = base_pairs, aes(x = x, y = y1, xend = x, yend = mid_y),
                 color = color_start, size = 0.5, alpha=.5) +
    geom_segment(data = base_pairs, aes(x = x, y = mid_y, xend = x, yend = y2),
                 color = color_end, size = 0.5, alpha=.5) +
    
    # Add the double helix lines
    geom_line(data = data, aes(x = x, y = y, color = group), size = 1) +
    scale_color_manual(values = c("Helix1" = helix_cols[1], "Helix2" = helix_cols[2],
                                  "Helix3" = helix_cols[3], "Helix4" = helix_cols[4])) +
    #add axis labels
    labs(title = element_blank(),
         x = element_blank(), y = element_blank(), color = "") +
    
    #Add text to figure
    geom_text(aes(x = text_pos[1], y = text_pos[2], label = text), 
              size = text_size, color = text_col, family="Monaco") +
    
    #define figure limits
    xlim(xlims[1], xlims[2])+ylim(ylims[1],ylims[2]) +
    
    #Edit theme to get rid of tix and panels
    theme(axis.title.x=element_blank(),
          axis.title.y=element_blank(),
          axis.text.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.x=element_blank(),
          axis.ticks.y=element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.background = element_rect(fill = background_col, color = NA,),)+
    theme(legend.position = "none")
  
}


