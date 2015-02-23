require 'json'
require 'oauth'
require 'yaml'
require 'singleton'

class TwitterConnection
  include Singleton

  # WHERE ON EARTH ID = BUENOS AIRES ( Montevideo doesn't have trending topics)
  WOEID_BA = 468_739

  TWITTER_API_URL = 'https://api.twitter.com/1.1/'
  def initialize
    @access_token = authenticate
  end

  def trending_topics
    js_response = make_get_request("trends/place.json?id=#{WOEID_BA}")
    js_response[0]['trends'].map { |trend| trend['name'] }
  end

  def tweets_with_hashtag(hashtag, count)
    json_response = make_get_request("search/tweets.json?q=#{URI.encode(hashtag)}&count=#{count}")
    json_response['statuses'].map do |tweet_json|
      tweet = Tweet.new
      tweet.id = tweet_json['id']
      tweet.text = tweet_json['text']
      tweet.date = tweet_json['created_at']
      tweet.user_id = tweet_json['user']['id']
      tweet.user_image_path = tweet_json['user']['profile_image_url']
      tweet.username = tweet_json['user']['screen_name']
      tweet.user_bio = tweet_json['user']['description']
      tweet
    end
  end

  private

  def authenticate
    credentials_file = File.join(Rails.root, 'config', 'twitter.yml')
    credentials = YAML.load_file(credentials_file)['credentials']

    consumer = OAuth::Consumer.new(credentials['consumer_key'],
                                   credentials['consumer_secret'],
                                   site: 'https://api.twitter.com',
                                   scheme: :header)

    # create access token
    token_hash = { oauth_token: credentials['access_key'],
                   oauth_token_secret: credentials['access_secret'] }
    OAuth::AccessToken.from_hash(consumer, token_hash)
  end

  def make_get_request(uri)
    begin
      response = @access_token.request(:get, TWITTER_API_URL +  uri)
      response_json = JSON.parse(response.body)
    rescue
      raise 'Could not get Twitter response'
    end

    if response_json.is_a?(Hash) && response_json['errors']
      fail response_json['errors'][0]['message']
    end

    response_json
  end

end
