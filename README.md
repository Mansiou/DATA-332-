# DATA-332

# Description 
I analyzed the dataset of consumer complaints about different issues that occurred in various banks such as loans, student loans, credit card and many more and whether the issue was resolved.


## Clean up data
I made a table of four columns that I needed to perform the sentiment analysis as not all the data in the consumer complaints were necessary. I used the columns Complaint ID, timely response, consumer disputed and company’s response to consumer. I added a new column of word using the company response to consumer by usuing unnest_tokens function toconvert the tokens to lowercase and using the anti_join function that returns only columns from the left Data Frame for non-matched records.
```bash
unnest_tokens(word, Company.response.to.consumer)
```
```bash
anti_join(word)
```

## Usage

```python
import foobar

# returns 'words'
foobar.pluralize('word')

# returns 'geese'
foobar.pluralize('goose')

# returns 'phenomenon'
foobar.singularize('phenomena')
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate.
