remove(list = ls())

# pour la syntaxe R ----
library(magrittr)

# tidyverse ----
library(dplyr)
library(purrr)
library(stringr)
library(ggplot2)

# le package en demo ------
library(ggiraph)



# carte de france ----
library(mapproj)
france <- map_data("france")

dep_overall <- readRDS("data/dep_overall.RDS")
dep_detail <- readRDS("data/dep_details.RDS")

do_tt_table <- function(){
  out <- "<table><theader><tr><th>statistique</th><th>valeur</th></tr></theader>"
  out <- paste0("<h4>", str_replace_all(dep_overall$lidep, "'", "&#39;"),"</h4>", out)
  inscrits <- paste0( "<tr><td>inscrits</td><td>", dep_overall$inscrits, "</td></tr>")
  abstentions <- paste0( "<tr><td>abstentions</td><td>", as.integer(dep_overall$abstentions*100), " % inscrits</td></tr>")
  votants <- paste0( "<tr><td>votants</td><td>", as.integer(dep_overall$votants*100), " % inscrits</td></tr>")
  blancs <- paste0( "<tr><td>blancs</td><td>", as.integer(dep_overall$blancs*100), " % inscrits</td></tr>")
  nuls <- paste0( "<tr><td>nuls</td><td>", as.integer(dep_overall$nuls*100), " % inscrits</td></tr>")
  exprimes <- paste0( "<tr><td>exprimes</td><td>", as.integer(dep_overall$exprimes*100), " % inscrits</td></tr>")
  paste0(out, "<tbody>", inscrits, abstentions, votants, blancs, nuls, exprimes, "</tbody></table>")
}
dep_overall$tooltip = do_tt_table()


th_ <- theme_minimal(base_family="Arial Narrow") +
  theme(panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        axis.title=element_blank(),
        plot.background = element_rect(color="transparent",
                                       fill = "#fefefefe")) +
  theme(axis.text.y=element_blank() ) +
  theme(axis.text.x=element_blank() ) +
  theme(plot.margin=unit(rep(30, 4), "pt")) +
  theme(plot.title=element_text(face="bold")) +
  theme(plot.caption=element_text(size=8, margin=margin(t=3)))

