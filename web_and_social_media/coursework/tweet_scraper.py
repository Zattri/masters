import os
import json
from twython import Twython
import pandas as pd
import re as regex
import time

# Loading credentials
creds = {}
creds_path = os.path.dirname(os.path.abspath(__file__)) + "/twitter_credentials.json"

with open(creds_path, "r") as file:
    creds = json.load(file)
twython_client = Twython(creds["api_key"], creds["api_secret"])

# Regex string
retweet_regex = "^(RT @[\w\d_]+: )+"

# Building query for sending
def build_query(search_term, result_type="popular", res_count="10"):
    query = {
        "q": search_term,
        "result_type": result_type, # Popular, recent or mixed (both)
        "count": res_count,
        "lang": "en"}
    return query

# Send query and format return results extracting fields
def fetch_and_format(query):
    return_sample = twython_client.search(**query)

    fields = {"user": [], "date": [], "text": [], "hashtags": [], "is_retweet": [],
              "favourites": [], "retweets": [], "source": [],
              "location": [], "latitude": [], "longitude": []}

    for status in return_sample["statuses"]:
        fields["user"].append(status["user"]["screen_name"])
        fields["date"].append(status["created_at"])
        fields["favourites"].append(status["favorite_count"])
        fields["retweets"].append(status["retweet_count"])
        
        split_source = status["source"].split(">") # Splitting on tag and removing end tag to get full source
        if len(split_source) >= 2:
            fields["source"].append(split_source[1][:-3]) # Source device used to tweet
        else:
            fields["source"].append(status["source"])

        if (status["place"] != None):
            fields["location"].append(status["place"]["full_name"] + ", " + status["place"]["country"])
            fields["longitude"].append(status["place"]["bounding_box"]["coordinates"][0][0][0])
            fields["latitude"].append(status["place"]["bounding_box"]["coordinates"][0][0][1])
        else:
            fields["location"].append("")
            fields["longitude"].append("")
            fields["latitude"].append("")

        # Formatting text to remove RT tag
        if regex.search(retweet_regex, status["text"]):
            new_text = regex.sub(retweet_regex, "", status["text"])
            fields["text"].append(new_text)
            fields["is_retweet"].append("True")
        else:            
            fields["text"].append(status["text"])
            fields["is_retweet"].append("False")
        
        # Scraping and formatting hashtags        
        hashtags = []
        if len(status["entities"]["hashtags"]) >= 1:
            json_dict = status["entities"]["hashtags"]
            for obj in json_dict:
                hashtags.append(obj["text"])
            
        fields["hashtags"].append(" ".join(hashtags))
        
    
    return pd.DataFrame(fields)

def save_results(results, file_path=os.path.dirname(os.path.abspath(__file__)), file_name="results", append=True):
    full_path = file_path + "\\" + file_name + ".csv"
    
    if append and os.path.exists(full_path):
        old_data = pd.read_csv(full_path, index_col=0)
        results = old_data.append(results, ignore_index=True)
    
    results.to_csv(file_path + "\\" + file_name + ".csv", encoding='utf-8')
    

# Build query and fetch fields

sarah_query = build_query("#SarahEverard", "recent", res_count=100)

for i in range(0, 60):
    query_results = fetch_and_format(sarah_query)
    save_results(query_results, file_name="source_test")
    print("Saved", i)
    time.sleep(60)
    
# Testing
#test_query = build_query("#SarahEverard", "mixed", res_count=100)
#return_sample = twython_client.search(**test_query)


