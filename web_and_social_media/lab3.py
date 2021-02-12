import matplotlib.pyplot as plt
from wordcloud import WordCloud
import nltk
from nltk.corpus import stopwords
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer
import os 
import pandas as pd

# Set working dir
os.chdir("C:\\Users\\Zattri\\Desktop\\masters\\web_and_social_media")

corpus = open("ObamaSpeech.txt", "r").read().lower()

words = nltk.word_tokenize(corpus)

stop_words = set(stopwords.words("english"))

filtered_words = []

for w in words:
    if w not in stop_words:
        filtered_words.append(w)

# Words = Full corpus lowered with stop words
# Filtered_words = Corpus lowered without stop words

# Include stop words
frequency_dist = nltk.FreqDist(words)
# Exclude stop words
frequency_dist = nltk.FreqDist(filtered_words)


sorted(frequency_dist, key=frequency_dist.__getitem__, reverse=True)[0:30]

# Select only the words where the length of the word is greater than 3
large_words = dict([(k,v) for k,v in frequency_dist.items() if len(k) > 3])

frequency_dist = nltk.FreqDist(large_words)
frequency_dist.plot(30, cumulative=False)

wordcloud = WordCloud(max_font_size=50, max_words=100, background_color="black").generate_from_frequencies(frequency_dist)
plt.figure()
plt.imshow(wordcloud, interpolation="bilinear")

with open("hotel.txt", "r") as file:
    documents = file.read().splitlines()
    
print(documents)

# Bag of words counter
count_vectorizer = CountVectorizer()
bag_of_words = count_vectorizer.fit_transform(documents)
feature_names = count_vectorizer.get_feature_names()
df = pd.DataFrame(bag_of_words.toarray(), columns=feature_names)

# This doesn't really work as there's only 1 document, and comparing 
# sentences to each other in a large speech is a big waste of time, as they are unrelated
obama_words = count_vectorizer.fit_transform(large_words)
obama_feature_names = count_vectorizer.get_feature_names()
obama_df = pd.DataFrame(obama_words.toarray(), columns=obama_feature_names)

# TF-IDF Vectorizer on Hotel review documents
tfid_vectorizer = TfidfVectorizer()
values = tfid_vectorizer.fit_transform(documents)
hotel_feature_names = tfid_vectorizer.get_feature_names()
tfidf_matrix = pd.DataFrame(values.toarray(), columns=hotel_feature_names)
