library(shiny)
library(plotrix)

shinyUI(fluidPage(
  
  headerPanel("Exemplo de análise de regressão"),
  
  sidebarPanel(
    sliderInput("beta","Inclinação da reta",min=0, max=10, value=2),
    sliderInput("variancia","Variância dos dados", min=1, max=100, value=1),
    sliderInput("n","Número de observações",
                min = 30,
                max = 200,
                value = 50),
    br(),
    h4("Para fazer"),
    p("* Veja o comportamento dos resíduos quando "),
    br(),
    radioButtons("relacao",label=h3("Tipo de relação"), 
                 choices=list("Relação linear" = 1, "Relação não linear" = 2), selected=1),
    h4("Opções"),
    checkboxInput("line","Mostrar reta da regressão?", T),
    checkboxInput("means","Mostrar média de Y?"),
    checkboxInput("confianca","Mostrar banda de confiança da reta?")
    ),
  
  mainPanel(
    navbarPage("",
      tabPanel("Análise",
               h3("Gráfico dos dados"),
               plotOutput("plot"),
               h3("Ajuste do modelo de regressão linear no R."),
               code("modelo <- lm(Y ~ X)", style = "color:blue"), br(),
               code("summary(modelo)", style = "color:blue"),
               verbatimTextOutput("summary")
               ),
      navbarMenu("Gráficos de resíduos",
                 tabPanel("Resíduos x Valores de X",
                          h3("Resíduos x Valores de X"),
                          plotOutput("residuos1")),
                 tabPanel("Resíduos x Valores ordenados de X",
                          h3("Resíduos x Valores ordenados de X"),
                          plotOutput("residuos2"))
      ),
      tabPanel("Exemplo de código do R.",
               code("# Gerar a variável explicativa.", style = "color:black"), br(),
               code("X <- 1:100", style = "color:black"), br(),
               code("# Gerar a variável resposta em função de X.", style = "color:black"), br(),
               code("Y <- 100 + 2*X + rnorm(100, sd=10)", style = "color:black"), br(),
               br(),
               code("# Ajustar modelo de regressão", style = "color:black"), br(),
               code("model <- lm(Y ~ X)", style = "color:black"), br(),
               br(),
               code("#Estatísticas resumo do modelo.", style = "color:black"), br(),
               code("summary(model)", style = "color:black"), br(),
               br(),
               code("#Plotar os dados e a reta da regressão.", style = "color:black"), br(),
               code("plot(Y ~ X)", style = "color:black"), br(),
               code("abline(model)", style = "color:black")
      )
    )
  )
))