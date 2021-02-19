import sklearn
import pandas as pd
import nltk
from nltk.tokenize import word_tokenize

df = pd.read_table("Movie_Review.csv", sep=",")