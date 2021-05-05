###BIO8069
##Assignment - Part 1:Wildife Acoustics 

#read in relevant packages 

necessary.packages<-c("devtools","behaviouR","tuneR","seewave","ggplot2","dplyr",
                      "warbleR","leaflet","lubridate","sp","sf","raster","mapview",
                      "leafem","BIRDS","xts","zoo", "stringr","vegan")

already.installed <- necessary.packages%in%installed.packages()[,'Package'] #asks if the necessary packages are already installed
if (length(necessary.packages[!already.installed])>=1) { #if not installed download now
  install.packages(necessary.packages[!already.installed],dep=1)
}
sapply(necessary.packages, function(p){require(p,quietly = T,character.only = T)})

#starling_song <- query_xc(qword = 'Sturnus vulgaris cnt:"united kingdom" type:song len:5-25', download = FALSE)
#starling_alarm <- query_xc(qword = 'Sturnus vulgaris cnt:"united kingdom" type:alarm len:5-25', download = FALSE)
#starling_mimic <- query_xc(qword = 'Sturnus vulgaris cnt:"united kingdom" type:mimicry len:5-25', download = FALSE)
#starling_begging <-query_xc(qword = 'Sturnus vulgaris cnt:"united kingdom" type:begging len:5-25', download = FALSE)

#Robins
robin_song <-query_xc(qword = 'Erithacus rubecula cnt:"united kingdom" type:song len:5-25', download = FALSE)
robin_call<-query_xc(qword = 'Erithacus rubecula cnt:"united kingdom" type:call len:5-25', download = FALSE)

#House Sparrow
sparrow_call<-query_xc(qword = 'Passer domesticus cnt:"united kingdom" type:call len:5-25', download = FALSE)

#wood_pigeon <-query_xc(qword = 'Columba palumbus cnt:"united kingdom" type:call len:5-25', download = FALSE)

#Greylag Goose
#greylag_call <-query_xc(qword = 'Anser anser cnt:"united kingdom" type:call len:5-25', download = FALSE)

#coal tit
coaltit_call<-query_xc(qword = 'Periparus ater  cnt:"united kingdom" type:call len:5-25', download = FALSE)

map_xc(robin_song, leaflet.map = TRUE)

# Create subfolders in your RStudio Project for song calls and alarm calls

#robins
dir.create(file.path("robin_song"))
dir.create(file.path("robin_call"))
dir.create(file.path("robin_call2"))

# Download the .MP3 files into two separate sub-folders
query_xc(X = robin_song, path="robin_song")
query_xc(X = robin_call, path="robin_call")
query_xc(X = robin_call, path="robin_call2")

#sparrows
dir.create(file.path("sparrow_call"))
query_xc(X = sparrow_call, path="sparrow_call")

#Coal tit
dir.create(file.path("coaltit_call"))
query_xc(X = coaltit_call, path="coaltit_call")

#Renaming files
#Robins 

#songs
old_files <- list.files("robin_song", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-song_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)

#call
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

#sparrow call
old_files <- list.files("sparrow_call", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-call_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)

#coal tit call
old_files <- list.files("coaltit_call", full.names=TRUE)
new_files <- NULL
for(file in 1:length(old_files)){
  curr_file <- str_split(old_files[file], "-")
  new_name <- str_c(c(curr_file[[1]][1:2], "-call_", curr_file[[1]][3]), collapse="")
  new_files <- c(new_files, new_name)
}
file.rename(old_files, new_files)

#Two separate analyses will be run - one comparing sparrow sounds and one comparing common garden bid calls
#so two separate folders to be created

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
file.copy(from=paste0("sparrow_call/",list.files("sparrow_call")),
          to="birds_audio")
file.copy(from=paste0("coaltit_call/",list.files("coaltit_call")),
          to="birds_audio")

#change files from MP3 to WAV files 

mp32wav(path="robin_audio", dest.path="robin_audio")
unwanted_mp3 <- dir(path="robin_audio", pattern="*.mp3")
file.remove(paste0("robin_audio/", unwanted_mp3))

mp32wav(path="birds_audio", dest.path="birds_audio")
unwanted_mp3 <- dir(path="birds_audio", pattern="*.mp3")
file.remove(paste0("birds_audio/", unwanted_mp3))

#Visualise and analyse the song and alarm calls
#Single robin, oscillogram and spectrogram

robin_wav<- readWave("robin_audio/Erithacusrubecula-song_374144.wav")
robin_wav

oscillo(robin_wav)
oscillo(robin_wav, from = 0.59, to = 0.60)

SpectrogramSingle(sound.file = "robin_audio/Erithacusrubecula-song_374144.wav",
                  Colors = "Colors")


#MFCC of robin song and calls
#use NES8010.R for stored function

source("nes8010.R")

robin_mfcc <- MFCCFunction(input.dir = "robin_audio",
                               max.freq=7000)
dim(robin_mfcc)

#PCA Robin sounds
robin_pca <- ordi_pca(robin_mfcc[, -1], scale=TRUE)
summary(robin_pca)

robin_sco <- ordi_scores(robin_pca, display="sites")
robin_sco <- mutate(robin_sco, group_code = robin_mfcc$Class)

ggplot(robin_sco, aes(x=PC1, y=PC2, colour=group_code)) +
  geom_point() +
  scale_colour_discrete(name = "Call Type",
                        labels = c("Red Breasted Robin call", "Red Breasted Robin song")) +
  theme_classic()

#MFCC Garden Bird calls
birds_mfcc <- MFCCFunction(input.dir = "birds_audio",
                           max.freq=7000)
dim(birds_mfcc)

#PCA Bird calls
birds_pca <- ordi_pca(birds_mfcc[, -1], scale=TRUE)
summary(birds_pca)

birds_sco <- ordi_scores(birds_pca, display="sites")
birds_sco <- mutate(birds_sco, group_code = birds_mfcc$Class)

ggplot(birds_sco, aes(x=PC1, y=PC2, colour=group_code)) +
  geom_point() +
  scale_colour_discrete(name = "Bird Type",
                      labels = c("Red Breasted Robin", "House Sparrow", "Coal Tit")) +
  theme_classic()
