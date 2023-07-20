setwd("C:/Users/gabar/OneDrive/Documentos/R ejercicios/Camverdes")
getwd()
library(tidyverse)
library(DataEditR)

#leer csv de campanas
campanas <- read.csv("camverdes.csv",header = T, sep = ",")
View(campanas)

names(campanas)

campanas <- select(campanas, barrio, Comuna)

head(campanas)

por_comuna <- campanas %>%
  group_by(Comuna) %>% 
  summarise(Cant_por_comuna = n()) %>% 
  arrange(Cant_por_comuna)
por_comuna

write.xlsx(por_comuna, "por_comuna.xlsx", asTable = T)
tiff("por_comuna1.tif")

por_barrio <- campanas %>%
  group_by(barrio) %>% 
  summarise(Cant_por_barrio = n()) %>% 
  arrange(Cant_por_barrio)
por_barrio

round(mean(por_barrio$Cant_por_barrio))
head(por_barrio, 6)
tail(por_barrio, 6)

install.packages("openxlsx")
library(openxlsx)

pb6 <- head(por_barrio, 6)
pbm6 <- tail(por_barrio, 6)
write.xlsx(pb6, "pb6.xlsx", asTable = T)
write.xlsx(pbm6, "pbm6.xlsx", asTable = T)

#pasar a factor la variable Comuna para ser categórica y luego ordenar x niveles
attach(campanas)
Comuna <- factor(Comuna)
#asignar niveles
levels(Comuna) <- c("Comuna 1","Comuna 2","Comuna 3","Comuna 4","Comuna 5","Comuna 6","Comuna 7","Comuna 8","Comuna 9","Comuna 10","Comuna 11","Comuna 12","Comuna 13","Comuna 14","Comuna 15")
Comuna <- ordered(Comuna)

# Gráfico por comuna, con colores en las barras usando fill y color en el fondo usando theme
ggplot(campanas)+
  geom_bar(mapping = aes(x= Comuna, fill = Comuna))+
  theme(panel.background = element_rect(fill = "#993E6C"))+
  theme(panel.border = element_rect(fill = "transparent", # Necesario para agregar el borde
                                    color = 4,            # Color del borde
                                    size = 2))+           # Ancho del borde
  theme(plot.background = element_rect(fill = "gray86"))+ # Color de fondo de la figura
  theme(plot.background = element_rect(color = "black", # Color del borde
                                       size = 2))+       # Ancho del borde
  coord_flip() #para cambiar los ejes 



# usando esta manera importa colomnas como numeros
censo <- read.csv("censocaba2022.csv, header = True")

head(censo)
str(censo)
view(censo)
spec(censo)

#cambiar el nombre de las variables
censo <- mutate(censo, viviparti = `Total de viviendas particulares`)
censo <- mutate(censo, vivicole = `Total de viviendas colectivas`)
censo <- mutate(censo, poblacion =`Total de población`)

#sumamos en vivienda las viviendas particulares y colectivas
censo <- mutate(censo, vivienda = viviparti + vivicole)

head(censo)
#sacamos las variables innecesarias
censo <- select(censo, Comuna, vivienda, poblacion)




# union x Comuna
campanaycenso <- campanas %>% 
  left_join(censo, by = "Comuna")

view(campanaycenso)
#

#agrupamos por comuna, conteo x comuna, saca maximo y mínimo barrio por comuna
campanas %>% 
  group_by(Comuna) %>% 
  summarise(conteo = n(),
            barrio_mayor_cant = max(n=(barrio)),
            barrio_menor_canti = min(n=(barrio)))

campanas %>% 
  group_by(Comuna, barrio) %>% 
  summarise(conteo = n(),
            Mayor_cant_barrio = max(n=(barrio)),
            max(barrio(n())),
            Menor_cant_barrio = min(n=(barrio)),
            min(barrio)
  )
df%>%
  group_by(equipo, posición)%>%
  summarise(max = max (puntos, na.rm = TRUE ))


#seleccionar los barrios y la cantidad de campanas verdes por barrio
campanaycenso %>% 
  group_by(barrio) %>% 
  summarise(conteo = n()) %>% 
  arrange(desc(conteo))  

#hago una tabla de frecuencias
Camcomuna <- table(campanaycenso$Comuna)
head(Comuna)


#hago una tabla de frecuencias
barrio <- table(campanaycenso$barrio)
head(barrio)

#porcentaje de campanas por comuna
propbarrio <- table(campanaycenso$Comuna)/length(Comuna)
propbarrio

barplot(Comuna)

#grafica de campanas por comuna, pero no se ven los nombres
ggplot(data=campanaycenso)+
  geom_bar(mapping=aes(x=Comuna, fill=Comuna))

#grafica de población por comuna, pero no se ven los nombres
ggplot(data=campanaycenso)+
  geom_bar(mapping=aes(x=Comuna, y= poblacion, fill=Comuna))



#si le agregamos color a la barra con fill=cut
ggplot(data=diamonds)+
  geom_bar(mapping=aes(x=cut, fill=clarity))

View(diamonds)

#codigo de ejemplo de suavizado no entendí
ggplot(data, aes(x=distance, 
                 y= dep_delay)) +
  geom_point() +
  geom_smooth()

#suavizado Loess menos de 1000 puntos codigo de ejemplo
ggplot(data, aes(x=, y=))+ 
  geom_point() +       
  geom_smooth(method="loess")

#suavizado GAM gran cantidad de puntos codigo de ejemplo
ggplot(data, aes(x=, y=)) + 
  geom_point() +        
  geom_smooth(method="gam", 
              formula = y ~s(x))


