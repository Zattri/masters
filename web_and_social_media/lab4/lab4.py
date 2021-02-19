import sklearn
import pandas as pd
import nltk
import matplotlib.pyplot as plt
from wordcloud import WordCloud
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
import re
from sklearn.feature_extraction.text import TfidTransformer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split
from sklearn.naive_bayes import MultinomialNB
from sklearn.metrics import accuracy_score

# Dataset loading
df = pd.read_table("Movie_Review.csv", sep=",")

# Tokenisation
reviews = df.review.str.cat(sep=" ")
tokens = word_tokenize(reviews.lower())
token_set = set(tokens)
print("Token length:", len(token_set))

# Stop word single character and symbol removal
stop_words = set(stopwords.words("english"))
tokens = [w for w in tokens if not w in stop_words]
tokens = [w for w in tokens if len(w) > 2]

non_symbol_tokens = []
regex = re.compile("[^a-zA-Z']")
for word in tokens:
    subbed_word = regex.sub('', word)    
    if subbed_word != "" and subbed_word != "''":
        non_symbol_tokens.append(subbed_word)

# Frequency distribution and top 50 words
freq_dist = nltk.FreqDist(non_symbol_tokens)
top50 = sorted(freq_dist, key=freq_dist.__getitem__, reverse=True)[0:50]
freq_dist.plot(30, cumulative=False)


# Train test split
x_train, x_test, y_train, y_test = train_test_split(df["review"], df["sentiment"], test_size=0.3, random_state=1)

# Vectorisation
vectorizer = TfidfVectorizer(max_features=10000)
train_vectors = vectorizer.fit_transform(x_train)
test_vectors = vectorizer.transform(x_test)
print(train_vectors.shape)
print(test_vectors.shape)

# Multinomial Naive Bayes
clf = MultinomialNB().fit(train_vectors, y_train)
prediction = clf.predict(test_vectors)
print(accuracy_score(y_test, prediction))