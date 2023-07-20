#### Directorio de trabajo
```{r}
setwd("C:/Users/gabar/OneDrive/Documentos/R ejercicios/Camverdes")
```

#### Librerías a utilizar
Para poder manipular los datos con mayor facilidad se utiliza la librería tidyverse

```{r, warning=FALSE, message=FALSE}
library(tidyverse)
```

Leer el archivo "camverdes.csv" y se asigna en el objeto campanas, header = T: es porque el archivo tiene encabezados, sep=",": es porque los separadores del archivo .csv viene en ",".

```{r}
campanas <- read.csv("camverdes.csv",header = T, sep = ",")

```

Usamos names() para traer el nombre de las columnas y seleccionar las que necesitamos 
```{r}
names(campanas)
```

Seleccionamos las variables que queremos con select() y las asignamos al nuevamente al objeto "campanas"
```{r}
campanas <- select(campanas, barrio, Comuna)
```

Pedimos el encabezado del nuevo objeto "campanas" para corrobrar los cambios
```{r}
head(campanas)
```
Creamos un nuevo objeto llamado "por_comuna" donde asignaremos la cantidad de campanas verdes por Comuna, ordenadas desde la que tiene menor cantidad a a la mayor:
  ```{r}
por_comuna <- campanas %>%
  group_by(Comuna) %>% 
  summarise(Cant_por_comuna = n()) %>% 
  arrange(Cant_por_comuna)
por_comuna
```


Creamos un nuevo objeto llamado "por_comuna" donde asignaremos la cantidad de campanas verdes por Comuna, ordenadas desde la que tiene menor cantidad a a la mayor:
  
  ```{r}
por_barrio <- campanas %>%
  group_by(barrio) %>% 
  summarise(Cant_por_barrio = n()) %>% 
  arrange(Cant_por_barrio)
por_barrio
```

Graficamos la cantidad de campanas por Comuna, usamos varias opciones para demostrar el potencial que tiene ggplot. Se agregaron colores a los rellenos, al tema de fondo, bordes tanto color como ancho,  las comunas se pasaron en sentido horizontal
```{r, warning=FALSE}
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

```

Agrupamos por Comuna con gruop_by(), le pedimos que haga un conteo de las campanas por Comuna, a la vez queremos saber en cada Comuna quien es el barrio que tiene la mayor cantidad de campanas (max()) y que barrio la menor cantidad (min()) por barrio
```{r}
campanas %>% 
  group_by(Comuna) %>% 
  summarise(conteo = n(),
            Mayor_cant_barrio = max(n=(barrio)),
            Menor_cant_barrio = min(n=(barrio)),
  )

```

### Importamos el archivo de censo
Pasamos a importar el archivo .csv con los datos de la población del censo 2022 de CABA. Usamos read.csv. el nombre del archivo va entre comillas, como tiene encabezado usamos la función header = T. El separador usamos la función sep="," para indicar que los datos del archivo csv están separados por ","
```{r}
censo <- read.csv("censocaba2022.csv", header = T, sep = ",")

```

```{r}
str(censo) #
view(censo)
```

#### Se realizan cambios en las variables
Cambiamos el nombre de las variables para facilitar el trabajo.
```{r}
censo <- mutate(censo, viviparti = Total.de.viviendas.particulares)
censo <- mutate(censo, vivicole = Total.de.viviendas.colectivas)
censo <- mutate(censo, poblacion = Total.de.población)
View(censo)
```

Se suma en la variable "vivienda" las cantidades de viviendas particulares y viviendas colectivas
```{r}
censo <- mutate(censo, vivienda = viviparti + vivicole)
```

Sacamos las variables innecesarias, y con select, dejamos Comuna, vivienda y población, asignado en "censo"
```{r}
censo <- select(censo, Comuna, vivienda, poblacion)

```


Realizamos la unión de las bases de campanas y censo, uniéndolas por la variable en común "Comuna", asignando en "campanaycenso"
```{r}
campanaycenso <- campanas %>% 
  left_join(censo, by = "Comuna")
```

Realizamos una corroboración pidiendo las primeras columnas con la función head(). Se podrá observar que tanto vivienda como población, repite sus observaciones en cada Comuna.
```{r}
head(campanaycenso)
```



#grafica de población por comuna, pero no se ven los nombres
```{r}
ggplot(campanaycenso)+
  geom_col(mapping = aes(x = Comuna, y = poblacion))+
  coord_flip()
```


### Donde terminan tus reciclables?
https://buenosaires.gob.ar/centro-de-reciclaje-de-la-ciudad


#### Planta de orgánicos
La planta de orgánicos trata 30 toneladas diarias de restos orgánicos que, gracias al proceso de fermentación aeróbica, se transforman en enmienda orgánica.

#### ¿Dónde terminan tus reciclables?
Todos los materiales recolectados van a los 16 Centros Verdes que tiene la Ciudad. Ahí las cooperativas de recuperadores le agregan valor a los reciclables con clasificación y procesamiento, para luego volver a la industria.
[ciudadverde](https://ciudadverde.gob.ar/)

