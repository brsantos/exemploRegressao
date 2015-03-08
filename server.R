library(shiny)
library(plotrix)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output){
  
  data <- reactive({
    set.seed(100)
    n <- input$n
    xx <- runif(n)*20
    slope <- input$beta
    noise <- input$variancia
    if (input$relacao == 1) yy <- slope*xx + rnorm(n, 0, sd=sqrt(noise))
    else yy <- exp(0.3*xx) + rnorm(n, 0, sd=sqrt(noise))
    data.frame(X=xx, Y=yy)
  })
  
  output$plot <- renderPlot({
    g <- ggplot(data(), aes(x=X, y=Y)) + theme_bw() + geom_point()
    if(input$line) {
      if(input$confianca) g <- g + geom_smooth(method='lm')
      else g <- g + geom_smooth(method='lm', se=F)
    }
    if(input$means) {
      g <- g + geom_abline(intercept = mean(data()[,2]), slope=0)
    } 
#     if(input$ant) {
#       model = lm(Y ~ X, data=data())
#       txt = paste("The equation of the line is:\nY = ",
#                   round(coefficients(model)[1],0)," + ",
#                   round(coefficients(model)[2],3),"X + error")
#       
#       boxed.labels(50,600,labels=txt,bg="white", cex=1.25)
#     }    
    g
  })

  output$residuos1 <- renderPlot({
    residuos <- lm(Y ~ X, data=data())$residuals
    
    g <- ggplot(data.frame(x=data()[,1], res=residuos), aes(x=x, y=res)) + theme_bw() + geom_point()
    g + geom_abline(intercept=0, slope=0)
  })

  output$residuos2 <- renderPlot({
    residuos <- lm(Y ~ X, data=data())$residuals
    x <- data()[,1]
    dados <- data.frame(res=residuos, x=x)
    dados <- arrange(dados, x)

    g <- ggplot(dados, aes(x=x, y=res)) + theme_bw() + geom_point() + geom_line()
    g + geom_abline(intercept=0, slope=0)
  })
  
  output$summary <- renderPrint({
    model = lm(Y ~ X, data=data())
    summary(model)
  })
  
})