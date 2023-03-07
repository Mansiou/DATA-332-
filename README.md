# DATA-332

# Description 

I analyzed the dataset of consumer complaints about different issues that occurred in various banks such as loans, student loans, credit card and many more and whether the issue was resolved.

<img width="401" alt="Screen Shot 2023-03-06 at 10 54 04 PM" src="https://user-images.githubusercontent.com/97116253/223324312-5d55e2f9-5749-4436-a5d3-b7b0fecd7748.png">

## Dictionary
The columns that were used:

1. Complaint.ID: a unique ID for each complaint that was recorded.
2. Consumer.disputed: to know the sentiment of the consumer
3. Timely.response: whether the company resolved the issue on time 
4. Company: the name of the company 
5. Company.response.to.consumer: to know whether the issue was resolved and if they got any benefit


## Data Cleaning

There were many columns in the dataset that was not necessary to perform the sentimental analysis so I eliminated the rest and kept the important colums.It can be seen in the table below.

I made a table of four columns that I needed to perform the sentiment analysis as not all the data in the consumer complaints were necessary. I used the columns Complaint ID, timely response, consumer disputed and company’s response to consumer. I added a new column of word using the company response to consumer by usuing unnest_tokens function toconvert the tokens to lowercase and using the anti_join function that returns only columns from the left Data Frame for non-matched records.
```bash
unnest_tokens(word, Company.response.to.consumer)
```
```bash
anti_join(word)
```
Code used to make the table:
```bash
table1<-complaints %>%
  select(Complaint.ID,Consumer.disputed.,Timely.response.,Company.response.to.consumer,Company)%>%
  unnest_tokens(word, Company.response.to.consumer) %>%
  anti_join(stop_words)

```
<img width="752" alt="Screen Shot 2023-03-06 at 2 21 41 PM" src="https://user-images.githubusercontent.com/97116253/223323130-895deda1-d144-4901-b506-38c78fd50b51.png">

## Data Summary
To create an overview of the feelings of consumers, I used the nrc function that calculates the presence of emotions using the column word in table1 and get a total number of the sentiments.
```bash
sentiments <- get_sentiments("nrc")

sentiment_scores <- table1 %>% 
  inner_join(sentiments) %>% 
  group_by(word) %>% 
  count(sentiment, sort = TRUE)
```
Here is the summary of the sentimental analysis:

<img width="262" alt="Screen Shot 2023-03-07 at 3 05 34 AM" src="https://user-images.githubusercontent.com/97116253/223376142-3320c014-50b0-4e0a-b628-d863969606d9.png">



## Data Analysis 
1. Number of sentiments recorded

<img width="1440" alt="Screen Shot 2023-03-06 at 10 38 53 PM" src="https://user-images.githubusercontent.com/97116253/223383674-541c8cf8-8fe6-471f-a746-de3a5888de0c.png">

In this graph, positive feelings were the highest count.

```bash
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
```
2. Categorical division of sentiments

<img width="1440" alt="Screen Shot 2023-03-07 at 3 51 54 AM" src="https://user-images.githubusercontent.com/97116253/223387012-6af71b4a-0d6b-4210-8193-28b74659f896.png">

This analysis is important as it places the feelings of consumer using the column 'word' in four different emotions. From this grapg, we know whether the response of the company to the consumer was positive or negative. 

```bash
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

```
3. word cloud 

Wordclouds are useful for quickly perceiving the most prominent terms in the data.

<img width="1440" alt="Screen Shot 2023-03-07 at 4 08 49 AM" src="https://user-images.githubusercontent.com/97116253/223390951-a3aa3cbc-6cd1-4f79-bee1-560f0efe749d.png">

Here, we cen see that the term positive dominates whice shows that the companies pleased most of its consumers.

```bash
wordcloud(sentiment_scores$sentiment,scale=c(3,0.5),min.freq=1, max.words= Inf, random.order = FALSE,rot.per=0.35, colors= brewer.pal(8,"Dark2"))
```



## Conclusion 
The issues of the consumers were dealt in an effective way as most of the consumers felt positive.

