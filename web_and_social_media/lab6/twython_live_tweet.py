from twython import TwythonStreamer
import csv
import json

import os 
os.chdir("C:\\Users\\Zattri\\Desktop\\masters\\web_and_social_media\\lab6")

with open("twitter_credentials.json", "r") as file:
    creds = json.load(file)

def process_tweet(tweet):
    d = {}
    d["hashtags"] = [hashtag["text"] for hashtag in tweet["entities"]["hashtags"]]
    d["text"] = tweet["text"]
    d["user"] = tweet["user"]["screen_name"]
    d["user_loc"] = tweet["user"]["location"]
    return d

class MyStreamer(TwythonStreamer):
        
    cached_tweets = []
    tweet_num = 0
    tweet_limit = 10
    
    def on_success(self, data):
        if data["lang"] == "en":
            self.tweet_num += 1
            print("Tweet", self.tweet_num, "/", self.tweet_limit)
            tweet_data = process_tweet(data)
            self.cached_tweets.append(list(tweet_data.values()))
            if (len(self.cached_tweets) >= self.tweet_limit):
                self.save_to_csv_and_stop()
            
    def on_error(self, status_code, data):
        print(status_code, data)
        self.disconnect()
        
    def save_to_csv_and_stop(self):
        print("Writing to file")
        with open(r"saved_tweets.csv", "a", encoding="utf-8", newline="") as file:
            writer = csv.writer(file)
            writer.writerow(header_fields)
            writer.writerows(self.cached_tweets)
        self.disconnect()
            
            
header_fields = ["hashtags", "text", "user", "user_location"]

stream = MyStreamer(creds["api_key"], creds["api_secret"], creds["access_token"], creds["access_secret"])
stream.statuses.filter(track="python")


