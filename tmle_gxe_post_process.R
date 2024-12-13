library(ggplot2)
library(ggpubr)

plot.tmle_gxe = function(object, ...)
{
  # check for fgwqsr object
  if(!methods::is(object, "tmle_gxe"))
  {
    stop("Must pass the object output of the tmle_gxe() function.")
  }
  
  passed_args = list(...)
  
  alpha = 0.05
  if(length(passed_args) >= 1)
  {
    alpha = passed_args[[1]]
  }
  
  sig_lvl = -1*log(alpha, base = 10)
  
  result_frame = object
  G_names = colnames(result_frame)
  
  if(length(passed_args) == 1)
  {
    sig_lvl = -1*log(passed_args[[1]], base = 10)
  }
  
  #############################################################################
  # ATE Plots #################################################################
  #############################################################################
  
  # ATE estimate plot
  
  
  # ATE pvalue plot
  
  ATE_aov_pvalues = result_frame["ATE_EM_pvalue", ]
  ATE_lin_pvalues = result_frame["ATE_EM_lin_pvalue", ]
  
  ATE_signif_aov = ifelse(-1*log(ATE_aov_pvalues, base = 10) < sig_lvl, 0, 1) %>% factor
  ATE_signif_lin = ifelse(-1*log(ATE_lin_pvalues, base = 10) < sig_lvl, 0, 1) %>% factor
  
  ATE_aov_data = data.frame(G_names = G_names %>% factor(levels =G_names, ordered = T),
                               neg_log_10_pvalues = -1 * log(ATE_aov_pvalues, base = 10),
                               Significant = ATE_signif_aov)
  ATE_linear_data = data.frame(G_names = G_names %>% factor(levels =G_names, ordered = T),
                            neg_log_10_pvalues = -1 * log(ATE_lin_pvalues, base = 10),
                            Significant = ATE_signif_lin)
  
  ATE_aov_plot = ggplot(data = ATE_aov_data, mapping = aes(x = G_names, y = neg_log_10_pvalues)) +
    geom_point(mapping = aes(color = Significant)) +
    scale_color_manual(values = c("black", "red")) +
    geom_hline(yintercept = sig_lvl, color = "red", linetype = "dashed") +
    ylab(latex2exp::TeX("$-log_{10}(pvalue)$")) + xlab("SNP") +
    geom_text(mapping = aes(x = G_names, y = neg_log_10_pvalues, label =G_names),
              data = subset(ATE_aov_data, ATE_aov_data$Significant == 1),
              check_overlap = F, hjust = -0.2, vjust = .5, size = 3.5) +
    ggtitle("Effect Modification for Average Treatment Effect: tlGxE Anova") +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank()) +
    guides(color = guide_legend(order = 1), shape = guide_legend(order = 2))
    
  ATE_linear_plot = ggplot(data = ATE_linear_data, mapping = aes(x = G_names, y = neg_log_10_pvalues)) +
    geom_point(mapping = aes(color = Significant)) +
    scale_color_manual(values = c("black", "red")) +
    geom_hline(yintercept = sig_lvl, color = "red", linetype = "dashed") +
    ylab(latex2exp::TeX("$-log_{10}(pvalue)$")) + xlab("SNP") +
    geom_text(mapping = aes(x = G_names, y = neg_log_10_pvalues, label =G_names),
              data = subset(ATE_linear_data, ATE_linear_data$Significant == 1),
              check_overlap = F, hjust = -0.2, vjust = .5, size = 3.5) +
    ggtitle("Effect Modification for Average Treatment Effect: tlGxE 1df") +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank()) +
    guides(color = guide_legend(order = 1), shape = guide_legend(order = 2))
  
  
  
  
  #############################################################################
  
  
  #############################################################################
  # MOR Plots #################################################################
  #############################################################################
  
  # MOR estimate plot
  # MOR pvalue plot
  
  MOR_aov_pvalues = result_frame["MOR_EM_pvalue", ]
  MOR_mult_pvalues = result_frame["MOR_EM_mult_pvalue", ]
  
  MOR_signif_aov = ifelse(-1*log(MOR_aov_pvalues, base = 10) < sig_lvl, 0, 1) %>% factor
  MOR_signif_mult = ifelse(-1*log(MOR_mult_pvalues, base = 10) < sig_lvl, 0, 1) %>% factor
  
  
  
  MOR_aov_data = data.frame(G_names = G_names %>% factor(levels =G_names, ordered = T),
                                    neg_log_10_pvalues = -1*log(MOR_aov_pvalues, base = 10),
                                    Significant = MOR_signif_aov)
  MOR_mult_data = data.frame(G_names = G_names %>% factor(levels =G_names, ordered = T),
                            neg_log_10_pvalues = -1*log(MOR_mult_pvalues, base = 10),
                            Significant = MOR_signif_mult)
  
  MOR_aov_plot = ggplot(data = MOR_aov_data, mapping = aes(x = G_names, y = neg_log_10_pvalues)) +
    geom_point(mapping = aes(color = Significant)) +
    scale_color_manual(values = c("black", "red")) +
    geom_hline(yintercept = sig_lvl, color = "red", linetype = "dashed") +
    ylab(latex2exp::TeX("$-log_{10}(pvalue)$")) + xlab("SNP") +
    geom_text(mapping = aes(x = G_names, y = neg_log_10_pvalues, label =G_names),
              data = subset(MOR_aov_data, MOR_aov_data$Significant == 1),
              check_overlap = F,hjust = -0.2, vjust = .5, size = 3.5) +
    ggtitle("Effect Modification for Marginal Odds Ratio: tlGxE Anova") +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank()) +
    guides(color = guide_legend(order = 1), shape = guide_legend(order = 2))
  
  
  MOR_mult_plot = ggplot(data = MOR_mult_data, mapping = aes(x = G_names, y = neg_log_10_pvalues)) +
    geom_point(mapping = aes(color = Significant)) +
    scale_color_manual(values = c("black", "red")) +
    geom_hline(yintercept = sig_lvl, color = "red", linetype = "dashed") +
    ylab(latex2exp::TeX("$-log_{10}(pvalue)$")) + xlab("SNP") +
    geom_text(mapping = aes(x = G_names, y = neg_log_10_pvalues, label =G_names),
              data = subset(MOR_mult_data, MOR_mult_data$Significant == 1),
              check_overlap = F,hjust = -0.2, vjust = .5, size = 3.5) +
    ggtitle("Effect Modification for Marginal Odds Ratio: tlGxE 1df") +
    theme_classic() +
    theme(plot.title = element_text(hjust = 0.5),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank()) +
    guides(color = guide_legend(order = 1), shape = guide_legend(order = 2))
  
  #############################################################################
  
  plot = ggpubr::ggarrange(ATE_aov_plot, ATE_linear_plot, 
                           MOR_aov_plot, MOR_mult_plot, 
                           nrow = 2, ncol = 2)
  
  return(plot)
}