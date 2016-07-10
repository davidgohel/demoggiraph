library(ggiraph)
library(maps)


shinyServer(function(input, output, session) {

  selected_dep <- reactive({
    if( is.null(input$plot_selected)){
      character(0)
    } else input$plot_selected
  })

  selected_nuance <- reactive({
    if( is.null(input$detail_plot_selected)){
      character(0)
    } else input$detail_plot_selected
  })
  selected_dep2 <- reactive({
    if( is.null(input$nuance_across_fr_selected)){
      character(0)
    } else input$nuance_across_fr_selected
  })


  output$plot <- renderggiraph({
    colors <- c("#fee0d2", "#fc9272", "#de2d26")
    gg_map <- ggplot(dep_overall, aes(map_id = lidep))
    gg_map <- gg_map +
      geom_map_interactive(aes( fill = abstentions, tooltip = tooltip, data_id = lidep ), map = france) +
      scale_fill_gradientn(colors = colors) +
      coord_map() +
      expand_limits(x = france$long, y = france$lat) + th_

    ggiraph(code = print(gg_map), width = .8, selection_type = "single",
            hover_css = "fill:wheat;cursor:pointer;",
            tooltip_extra_css= "background-color:wheat;color:gray20;border-radius:10px;padding:3pt;text-align:right;")
  })

  output$data <- DT::renderDataTable({
    selnua <- selected_nuance()
    if( length(selnua) < 1 ) return()
    seldep <- selected_dep2()
    selnua <- str_replace_all(selnua, "'", "&#39;")

    data <- dep_detail
    data <- data %>% filter(conu==selnua) %>% select(-conu)
    if( length(seldep) > 0 )
      data <- data %>% filter(lidep %in% seldep)
    else return(NULL)
    data

  })
  output$nuance_across_fr <- renderggiraph({
    selnua <- selected_nuance()
    if( length(selnua) < 1 ) return()

    selnua <- str_replace_all(selnua, "'", "&#39;")

    gg_map <- ggplot(dep_detail %>% filter(conu==selnua), aes(map_id = lidep))
    gg_map <- gg_map +
      geom_map_interactive(aes( fill = sieges, data_id = lidep ), map = france) +
      coord_map() +
      scale_fill_gradient(low = "#ece7f2", high = "#2b8cbe") +
      expand_limits(x = france$long, y = france$lat) + th_

    ggiraph(code = print(gg_map), width = 1, zoom_max = 4,
            selection_type = "multiple")
  })

  observeEvent(input$reset, {
    session$sendCustomMessage(type = 'nuance_across_fr_set', message = character(0))
  })


  output$detail_plot <- renderggiraph({

    session$sendCustomMessage(type = 'detail_plot_set', message = character(0))

    seldep <- selected_dep()
    if( length(seldep) < 1 ) return()

    data <- dep_detail %>% filter(lidep == selected_dep()) %>%
      mutate( tooltip = paste0(voix, " voix"))
    data$conu <- str_replace_all(data$conu, "'", "&#39;")

    gg <- ggplot(data)
    gg <- gg +
      geom_point_interactive(aes(y=sieges, x=voix,
                                 data_id = conu, tooltip = conu ),
                             size = 5, color = "gray10") +
      guides(color = FALSE)

    gg <- gg + labs(x="nombre de voix", y="nombre de sièges",
                    title="Sièges obtenus par nuance politique",
                    caption="données 2015")
    gg <- gg + theme_minimal(base_family="Arial Narrow")
    gg <- gg + theme(panel.grid.major.x=element_blank(), plot.background = element_rect(color="transparent", fill = rgb(1,1,1, .01)))
    gg <- gg + theme(axis.text.y=element_text(margin=margin(r=-5, l=0)))
    gg <- gg + theme(plot.margin=unit(rep(30, 4), "pt"))
    gg <- gg + theme(plot.title=element_text(face="bold"))
    gg <- gg + theme(plot.caption=element_text(size=8, margin=margin(t=3)))

    ggiraph(print(gg), width = 1,
            zoom_max = 5,
            selection_type = "single",
      tooltip_extra_css= "background-color:wheat;color:gray20;border-radius:10px;padding:3pt;")
  })

  output$title_departement <- renderUI({
    value <- selected_dep()
    if(length(value) < 1 ) h4("pas de département sélectionné", style="text-align:center;")
    else h4(value, style="text-align:center;")
  })
  output$title_nuance <- renderUI({
    value <- selected_nuance()
    if(length(value) < 1 ) h4("pas de nuance politique sélectionnée", style="text-align:center;")
    else h4(value, style="text-align:center;")
  })
})

