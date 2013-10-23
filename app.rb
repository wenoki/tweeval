# coding: utf-8
 
require "eventmachine"
require "twitter"
require "tweetstream"
require "logger"
 
twitter_consumer_key = ENV["CLIENT_CONSUMER_KEY"]
twitter_consumer_secret = ENV["CLIENT_CONSUMER_SECRET"]
twitter_access_token = ENV["CLIENT_ACCESS_TOKEN"]
twitter_access_token_secret = ENV["CLIENT_ACCESS_TOKEN_SECRET"]
twitter_user_id = ENV["CLIENT_USER_ID"]
 
log = Logger.new STDOUT
STDOUT.sync = true
 
rest = Twitter::Client.new(
  consumer_key: twitter_consumer_key,
  consumer_secret: twitter_consumer_secret,
  oauth_token: twitter_access_token,
  oauth_token_secret: twitter_access_token_secret,
)
 
TweetStream.configure do |config|
  config.consumer_key = twitter_consumer_key
  config.consumer_secret = twitter_consumer_secret
  config.oauth_token = twitter_access_token
  config.oauth_token_secret = twitter_access_token_secret
  config.auth_method = :oauth
end
 
stream = TweetStream::Client.new
 
EventMachine.error_handler do |ex|
  log.error ex.message
end
 
EventMachine.run do
  stream.on_inited do
    log.info "init"
  end
 
  stream.userstream do |status|
    log.info "status from @#{status.from_user}: #{status.text}"
    next if status.retweet? || status.user.id != twitter_user_id
    
    if status.text.match /\A(@\w+\s)*-e\s((--\w+\s)*)(.+)\z/m
      expr = Regexp.last_match[4]
      mentions = Regexp.last_match[1]
      options = Regexp.last_match[2].split(" ").map {|item| item.delete("--").intern}
    else
      next
    end
    
    rest.status_destroy status.id if options.include? :destroy
    
    result = begin
      eval expr
    rescue => exception
      exception
    end
 
    text = if options.include? :raw
      result.to_s
    else
      "=> #{result.inspect}"
    end
    
    tweet = if status.reply?
      rest.update mentions + text, in_reply_to_status_id: status.in_reply_to_user_id
    else
      rest.update mentions ? mentions + text : text
    end
    
    log.info "tweeted: #{tweet.text}" if tweet
  end
end
