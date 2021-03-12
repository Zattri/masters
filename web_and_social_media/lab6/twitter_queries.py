import json
from twython import Twython
import pandas as pd

import os 
os.chdir("C:\\Users\\Zattri\\Desktop\\masters\\web_and_social_media\\lab6")

creds = {}
creds["api_key"]="KoxWeYinrMCQmctlabNZgufc8"
creds["api_secret"]="JK59EB1uTPlwIO4IaJa7b9sgk26LBd9YkLakWNmS7cuOxw7qnt"
creds["bearer_token"]="AAAAAAAAAAAAAAAAAAAAABN%2FNQEAAAAAlZCRxKec%2FBlROkjsBxGslRWKwwk%3DMvAVVMPAUVuz9znbbz76qL29jzfGUYVFKBnHAHdTJ50ow9yOV5"
creds["access_token"]="1359116185011445766-KvjnAb5TRSI6YMzU7NsqGFpDym6aDY"
creds["access_secret"]="o6pp5u2BtaXGIyX9T2pLJ4Bxbm3avPPM92LoxjVLQe15Y"

# Write creds to file
with open("twitter_credentials.json", "w") as file:
    json.dump(creds, file)
    
python_tweets = Twython(creds["api_key"], creds["api_secret"])

query = {
    "q": "COVID-19 Vaccine",
    "result_type": "popular",
    "count": 10,
    "lang": "en"}

return_sample = python_tweets.search(**query)

fields = {"user": [], "date": [], "text": [], "favorite_count": [] }

for status in return_sample["statuses"]:
    fields["user"].append(status["user"]["screen_name"])
    fields["date"].append(status["created_at"])
    fields["text"].append(status["text"])
    fields["favorite_count"].append(status["favorite_count"])
    
df = pd.DataFrame(fields)
df.sort_values(by="favorite_count", inplace=True, ascending=False)

df.head(5)
