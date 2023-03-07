#load required packages
library(tidyverse)
library(tidytext)
library(ggplot2)
library(dplyr)
library(readxl)
library(lubridate)
library(janeaustenr)
library(dplyr)
library(stringr)
library(syuzhet)
library(sentimentr)
library(magrittr)
library(lexicon)
library(ggthemes)
library(wordcloud)
library(tm)


rm(list=ls())
setwd("~/Desktop/DATA 332")

#import text dataset 
complaints <- read.csv('Consumer_Complaints.csv')
saveRDS(complaints,'Consumer_Complaints.rsd')

#cleaning data and eliminating colums
table1<-complaints %>%
  select(Complaint.ID,Consumer.disputed.,Timely.response.,Company.response.to.consumer,Company)%>%
  unnest_tokens(word, Company.response.to.consumer) %>%
  anti_join(stop_words)

# sentimental analysis using nrc
sentiments <- get_sentiments("nrc")

#get total count of sentiments 
sentiment_scores <- table1 %>% 
  inner_join(sentiments) %>% 
  group_by(word) %>% 
  count(sentiment, sort = TRUE) 

# word cloud 
wordcloud(sentiment_scores$sentiment,scale=c(3,0.5),min.freq=1, max.words= Inf, random.order = FALSE,rot.per=0.35, colors= brewer.pal(8,"Dark2"))

#create graph to categories the column 'word' to in the sentiments got
sentiment_scores %>%
  group_by(sentiment) %>%
  slice_max(n, n = 10) %>% 
  ungroup() %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(n, word, fill = sentiment)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~sentiment, scales = "free_y") +
  labs(x = "Contribution to sentiment",
       y = NULL)

#create graph of count of sentiment_scores
sentiment_count<-sentiment_scores %>%
  group_by(sentiment) %>%
  summarise(n = n()) %>%
  ungroup() %>%
  mutate(sentiment = reorder(sentiment, n)) %>%
  
  ggplot(aes(sentiment,n , fill = -n)) +
  geom_col() +
  guides(fill = "none") + 
  labs(x = NULL, y = "Word Sentiment Count")  +
  ggtitle("NRC sentiment count") +
  coord_flip()
plot(sentiment_count)
