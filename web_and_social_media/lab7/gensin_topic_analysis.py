import os 
os.chdir("C:\\Users\\Zattri\\Desktop\\masters\\web_and_social_media\\lab7")

import os.path
from gensim import corpora
from gensim.models import LsiModel
from nltk.tokenize import RegexpTokenizer
from nltk.corpus import stopwords
from nltk.stem.porter import PorterStemmer
from gensim.models.coherencemodel import CoherenceModel
import matplotlib.pyplot as plt

def loadData(path, fileName):
    documentsList = []
    titles = []
    with open(os.path.join(path, fileName), "r", encoding="utf8") as file:
        for line in file.readlines():
            text = line.strip()
            documentsList.append(text)
    
    print("Num of Documents:", len(documentsList))
    titles.append(text[0:min(len(text), 100)])
    return documentsList, titles

def preprocessData(documentSet):
    tokenizer = RegexpTokenizer(r"\w+")
    engStop = set(stopwords.words("english"))
    pStemmer = PorterStemmer()
    texts = []
    
    for i in documentSet:
        raw = i.lower()
        tokens = tokenizer.tokenize(raw)
        stoppedTokens = [i for i in tokens if not i in engStop]
        stemmedTokens = [pStemmer.stem(i) for i in stoppedTokens]
        texts.append(stemmedTokens)
    return texts

def prepareCorpus(document):
    dictionary = corpora.Dictionary(document)
    documentTermMatrix = [dictionary.doc2bow(doc) for doc in document]
    return dictionary, documentTermMatrix
    
def initGensimLsaModel(document, topicNum, words):
    dictionary, documentTermMatrix = prepareCorpus(document)
    lsaModel = LsiModel(documentTermMatrix, num_topics=topicNum, id2word=dictionary)
    print(lsaModel.print_topics(num_topics=topicNum, num_words=words))
    return lsaModel

def printFormattedTopicWords(model, topicNum=0, wordCount=10):
    topicWordString = model.print_topic(topicNum, wordCount)
    topicStrings = topicWordString.split(" + ")
    for term in topicStrings:
        brokenTerm = term.split("*")
        print(brokenTerm[0], brokenTerm[1])

# LSA Model
topicNum = 7
words = 10
documentList, titles  = loadData("", "articles.csv")
cleanedText = preprocessData(documentList)
model = initGensimLsaModel(cleanedText, topicNum, words)
printFormattedTopicWords(model, 0, 10)

