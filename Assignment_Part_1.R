##  BIO8069
### Assignment - Part 1:Wildife Acoustics 

#read in relevant packages. The packages listed below won't all be used. 
#I have set up this code over the course of the practicals for this module as I can then
#easily copy and paste it into scripts, which has helped prevent re-installation of packages.

necessary.packages<-c("devtools","behaviouR","tuneR","seewave","ggplot2","dplyr",
                      "warbleR","leaflet","lubridate","sp","sf","raster","mapview",
                      "leafem","BIRDS","xts","zoo", "stringr","vegan","rmarkdown","shiny")

already.installed <- necessary.packages%in%installed.packages()[,'Package'] #asks if the necessary packages are already installed
if (length(necessary.packages[!already.installed])>=1) { #if not installed download now
  install.packages(necessary.packages[!already.installed],dep=1)
}
sapply(necessary.packages, function(p){require(p,quietly = T,character.only = T)})

#The analysis was conducted in three parts.
#The first part examined and compared the calls and songs of the European Robin.
#The second part compared the calls of European Robins with two other common garden birds.
#Finally, the third part compared the songs of European Robins with the songs of other members of the 
#Subfamily Erithacinae. 

#### Part 1

# European Robins (Erithacus rubecula)
# Using query_xc () to check for presence of recordings on the xeno-canto website prior to download.
# download = FALSE - prevents recordings from being downloaded, while 'cnt:' specifies the country, 
#'type:' specifies the call type and 'len:' specifies the length of the recording.
# requires the package warbleR

robin_song <-query_xc(qword = 'Erithacus rubecula cnt:"united kingdom" type:song len:5-25', download = FALSE)
robin_call<-query_xc(qword = 'Erithacus rubecula cnt:"united kingdom" type:call len:5-25', download = FALSE)

#using the map_xc() function and the leaflet package the site of each recording can be visualised. 
#Clicking on the pop-up will give links to spectograms and 'listen' links on the xeno-canto website.

map_xc(robin_song, leaflet.map = TRUE)

#Now that the sets of recordings have been specified, they can then be downloaded for analysis.
#Sub-folders are then created in the RStudio Project for songs and calls.
#As the robin songs and calls will be used in two separate analyses, multiple sub-folders have been created

dir.create(file.path("robin_song"))
dir.create(file.path("robin_song2"))
dir.create(file.path("robin_call"))
dir.create(file.path("robin_call2"))

#The .MP3 files can then be downloaded into the separate sub-folders
query_xc(X = robin_song, path="robin_song")
query_xc(X = robin_song, path="robin_song2")
query_xc(X = robin_call, path="robin_call")
query_xc(X = robin_call, path="robin_call2")

#Renaming files
#Using the _stringr_ package, the structure of the names of the .MP3 files was changed using the code below.
#This allowed for more succinct and manageable file names.
#str_split() divides the name into 3 pieces
#str_c()concatenates the file name together merging the scientific name followed by -song_ and adding in the file
#number .mp3. For example; Erithacusrubecula-song_374144.mp3.

#songs
old_files <- list.files("robin_song", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-song_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)

#songs2
old_files <- list.files("robin_song2", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-song_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)

#calls
old_files <- list.files("robin_call", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-call_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)

#call2
old_files <- list.files("robin_call2", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-call_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)


#Three separate analyses will be run - one comparing sparrow sounds and one comparing common garden bird calls
#and finally, one containing the songs of the sub-family Erithacinae.
#So three separate folders are created.

#Robins
dir.create(file.path("robin_audio"))
file.copy(from=paste0("robin_song/",list.files("robin_song")),
          to="robin_audio")
file.copy(from=paste0("robin_call/",list.files("robin_call")),
          to="robin_audio")

#Common garden birds calls (birds)
dir.create(file.path("birds_audio"))
file.copy(from=paste0("robin_call2/",list.files("robin_call2")),
          to="birds_audio")

#Sub-family Erithacinae
dir.create(file.path("erithacinae_audio"))
file.copy(from=paste0("robin_song2/",list.files("robin_song2")),
          to="erithacinae_audio")


#Change files from MP3 to WAV files using the mp32wav() function from the warbler package.
#The .mp3 files are then stored as a new object and subsequently removed to save disk space,
#before removing the .mp3 files check that the conversion has happened.

mp32wav(path="robin_audio", dest.path="robin_audio")
unwanted_mp3 <- dir(path="robin_audio", pattern="*.mp3")
file.remove(paste0("robin_audio/", unwanted_mp3))

#Visualisation and analysis of the song and alarm calls can be carried out
#An oscillogram is generated using the function oscillo() from the seewave package
 
#Single robin song oscillogram 
#first a single robin song is read using the readWave() fuction found in the package TuneR.
#This reading is stored in a new object - robin_wav.

robin_wav<- readWave("robin_audio/Erithacusrubecula-song_374144.wav")
robin_wav

#The oscillo() function is then run on the object to plot the full frequency diagram.
oscillo(robin_wav)

#To view the frquency diagram in greater detail it is possible to zoom in. 
#Here section 0.59 to 0.60 has been specified.

oscillo(robin_wav, from = 0.59, to = 0.60)

#Additionally the SpectrogramSingle() function from the DenaJGibbon/behaviouR package
#can be used to visualise the spectrum of frequencies over time, which can be presented in colour. 

SpectrogramSingle(sound.file = "robin_audio/Erithacusrubecula-song_374144.wav",
                  Colors = "Colors")

#Single robin call oscillogram and spectrogram
robinc_wav<- readWave("robin_audio/Erithacusrubecula-call_70122.wav")
oscillo(robinc_wav)

oscillo(robinc_wav, from = 0.59, to = 0.60)

SpectrogramSingle(sound.file = "robin_audio/Erithacusrubecula-call_70122.wav",
                  Colors = "Colors")

#MFCC of robin song and calls
#Before the PCA was carried out the data was simplified by pushing it through 
#Mel-frequency cepstral coefficients (MFCC), which identifies repeated patterns 
#and extracts them to form a simplified data set that can be used in the PCA.
#An MFCC can be applied simply by using the MFCCfunction().

source("nes8010.R") #use NES8010.R as a source for stored functions used in the PCA 

robin_mfcc <- MFCCFunction(input.dir = "robin_audio",
                               max.freq=7000)
dim(robin_mfcc) #shows the key components have been extracted simplifying the data to 178 components.

#PCA of Robin songs and calls
#the vegan package is required.
#Using the ordi_pca() function and the ordi_scores() function from the source script to carry
#out the PCA.

robin_pca <- ordi_pca(robin_mfcc[, -1], scale=TRUE)# Use [, -1] to keep all rows but omit first column
summary(robin_pca)

robin_sco <- ordi_scores(robin_pca, display="sites")
robin_sco <- mutate(robin_sco, group_code = robin_mfcc$Class)

#robin_sco can then be plotted using ggplot - allowing for the variation between call types to be visualised.
ggplot(robin_sco, aes(x=PC1, y=PC2, colour=group_code)) + 
  geom_point() +
  scale_colour_discrete(name = "Call Type",
                        labels = c("Red Breasted Robin call", "Red Breasted Robin song")) +
  theme_classic()

#### Part 2 
#Part 2 of the analysis, the robin call was then compared with the calls of two other
#common garden birds found in the United Kingdom, the house sparrow (Passer domesticus) 
#and the coal tit (Periparus ater).
#This analysis will follow the same process as Part 1. 

## Using query_xc () to check for presence of recordings on the xeno-canto website prior to download
#House Sparrow
sparrow_call<-query_xc(qword = 'Passer domesticus cnt:"united kingdom" type:call len:5-25', download = FALSE)
#Coal tit
coaltit_call<-query_xc(qword = 'Periparus ater  cnt:"united kingdom" type:call len:5-25', download = FALSE)

#Sub-folders are then created in the RStudio Project for calls.
#Recordings are downloaded into these folders 

#House sparrow
dir.create(file.path("sparrow_call"))
query_xc(X = sparrow_call, path="sparrow_call")
#Coal tit
dir.create(file.path("coaltit_call"))
query_xc(X = coaltit_call, path="coaltit_call")

#Renaming files
#Using the _stringr_ package, the structure of the names of the .MP3 files was changed using the code below.
#This allowed for more succinct and manageable file names.

#House sparrow 
old_files <- list.files("sparrow_call", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-call_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)

#Coal tit 
old_files <- list.files("coaltit_call", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-call_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)

#House sparrow and Coal tit recordings are then copied to the birds_audio folder

file.copy(from=paste0("sparrow_call/",list.files("sparrow_call")),
          to="birds_audio")
file.copy(from=paste0("coaltit_call/",list.files("coaltit_call")),
          to="birds_audio")

#Change files from MP3 to WAV files using the mp32wav() function from the warbler package.
#The .mp3 files are then stored as a new object and subsequently removed to save disk space,
#before removing the .mp3 files check that the conversion has happened.

mp32wav(path="birds_audio", dest.path="birds_audio")
unwanted_mp3 <- dir(path="birds_audio", pattern="*.mp3")
file.remove(paste0("birds_audio/", unwanted_mp3))

#Visualisation and analysis of the calls can be carried out using oscillograms and spectrograms

#House sparrow
sparrow_wav<- readWave("birds_audio/Passerdomesticus-call_208481.wav")
oscillo(sparrow_wav)
oscillo(sparrow_wav, from = 0.59, to = 0.60)

SpectrogramSingle(sound.file = "birds_audio/Passerdomesticus-call_208481.wav",
                  Colors = "Colors")

#Coal tit
coal_wav<- readWave("birds_audio/Periparusater-call_307342.wav")
oscillo(coal_wav)
oscillo(coal_wav, from = 0.59, to = 0.60)

SpectrogramSingle(sound.file = "birds_audio/Periparusater-call_307342.wav",
                  Colors = "Colors")

#MFCC of common garden bird calls
birds_mfcc <- MFCCFunction(input.dir = "birds_audio",
                           max.freq=7000)
dim(birds_mfcc)#reduced to 178 components

#PCA of common bird calls
birds_pca <- ordi_pca(birds_mfcc[, -1], scale=TRUE)
summary(birds_pca)

birds_sco <- ordi_scores(birds_pca, display="sites")
birds_sco <- mutate(birds_sco, group_code = birds_mfcc$Class)
summary(birds_sco)
#Plot the generated scores using ggplot - adding labels to specify bird type
ggplot(birds_sco, aes(x=PC1, y=PC2, colour=group_code)) +
  geom_point() +
  scale_colour_discrete(name = "Bird Type",
                      labels = c("Red Breasted Robin", "House Sparrow", "Coal Tit")) +
  theme_classic()

#### Part 3
#This section explores the variation in the songs of Old World Flycatchers, 
#focusing on the Subfamily Erithacinae. This analysis included the European Robin, 
#the Cape Robin-chat (Cossypha caffra), the Spotted Palm Thrush (Cichladusa guttata) 
#and the Forest Robin (Stiphrornis erythrothorax.
#This analysis will follow the same process as Part 1.

# Using query_xc () to check for presence of recordings on the xeno-canto website prior to download
#Cape robin-chat
crobin_song <-query_xc(qword = 'Cossypha caffra cnt:"south africa" type:song len:5-25', download = FALSE) #country specified: South Africa
#Spotted Palm Thrush
palm_song <-query_xc(qword = 'Cichladusa guttata cnt:"kenya" type:song len:5-25', download = FALSE) #country specified: Kenya
#Forest robin
frobin_song <-query_xc(qword = 'Stiphrornis erythrothorax type:song len:5-25', download = FALSE) 
#No country specification as the recordings were all within the central African region and some parts 
#of Western Africa and there were too few recordings to limit by country.

#Sub-folders are then created in the RStudio Project for these songs.
#Recordings are then downloaded into these folders 

#Cape robin-chat
dir.create(file.path("crobin_song"))
query_xc(X = crobin_song, path= "crobin_song")
#Spotted Palm Thrush
dir.create(file.path("palm_song"))
query_xc(X = palm_song, path="palm_song")
#Forest robin
dir.create(file.path("frobin_song"))
query_xc(X = frobin_song, path="frobin_song")

#Renaming files
#Using the _stringr_ package, the structure of the names of the .MP3 files was changed using the code below.
#This allowed for more succinct and manageable file names.

#Cape robin-chat 
old_files <- list.files("crobin_song", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-call_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)

#Spotted Palm Thrush
old_files <- list.files("palm_song", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-call_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)

#Forest  Robin
old_files <- list.files("frobin_song", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-call_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)

#The recordings are then copied to the erithacinae_audio folder

file.copy(from=paste0("crobin_song/",list.files("crobin_song")),
          to="erithacinae_audio")
file.copy(from=paste0("palm_song/",list.files("palm_song")),
          to="erithacinae_audio")
file.copy(from=paste0("frobin_song/",list.files("frobin_song")),
          to="erithacinae_audio")

#Change files from MP3 to WAV files using the mp32wav() function from the warbler package.
#The .mp3 files are then stored as a new object and subsequently removed to save disk space,
#before removing the .mp3 files check that the conversion has happened.

mp32wav(path="erithacinae_audio", dest.path="erithacinae_audio")
unwanted_mp3 <- dir(path="erithacinae_audio", pattern="*.mp3")
file.remove(paste0("erithacinae_audio/", unwanted_mp3))

#Visualisation and analysis of the songs can be carried out using oscillograms and spectrograms
#allowing comparisons between individual songs to be made.

#Cape Robin-chat
crobin_wav<- readWave("erithacinae_audio/Cossyphacaffra-call_324664.wav")
oscillo(crobin_wav)
oscillo(crobin_wav, from = 0.59, to = 0.60)

SpectrogramSingle(sound.file = "erithacinae_audio/Cossyphacaffra-call_324664.wav",
                  Colors = "Colors")

#Spotted Palm Thrush
palm_wav<- readWave("erithacinae_audio/Cichladusaguttata-call_371366.wav")
oscillo(palm_wav)
oscillo(palm_wav, from = 0.59, to = 0.60)

SpectrogramSingle(sound.file = "erithacinae_audio/Cichladusaguttata-call_371366.wav",
                  Colors = "Colors")

#Forest robin
forest_wav<- readWave("erithacinae_audio/Stiphrorniserythrothorax-call_284893.wav")
oscillo(forest_wav)
oscillo(forest_wav, from = 0.59, to = 0.60)

SpectrogramSingle(sound.file = "erithacinae_audio/Stiphrorniserythrothorax-call_284893.wav",
                  Colors = "Colors")

#MFCC of the sub-family Erithacinae bird songs to reduce data complexity.
erithacinae_mfcc <- MFCCFunction(input.dir = "erithacinae_audio",
                           max.freq=7000)
dim(erithacinae_mfcc)#reduced to 178 components

#PCA of sub-family Erithacinae bird songs 
erithacinae_pca <- ordi_pca(erithacinae_mfcc[, -1], scale=TRUE)
summary(erithacinae_pca)

erith_sco <- ordi_scores(erithacinae_pca, display="sites")
erith_sco <- mutate(erith_sco, group_code = erithacinae_mfcc$Class)

#Plot the generated scores using ggplot - adding labels to specify bird type
ggplot(erith_sco, aes(x=PC1, y=PC2, colour=group_code)) +
  geom_point() +
  scale_colour_discrete(name = "Bird Type",
                        labels = c("Spotted Palm Thrush", "Cape Robin-chat", "Red Breasted Robin", "Forest Robin")) +
  theme_classic()


