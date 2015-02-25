ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'test/unit'
require 'shoulda'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...
  def twitterConnectionLocal(limit_exceed = false)
    if limit_exceed
      error = File.open(File.join(Rails.root, 'test', 'fixtures', 'twitter_error.json'))
      FakeWeb.register_uri(:get, "#{TwitterConnection::TWITTER_API_URL}trends/place.json?id=#{TwitterConnection::WOEID_BA}", body: error.read)
      FakeWeb.register_uri(:get, "#{TwitterConnection::TWITTER_API_URL}search/tweets.json?q=#{URI.encode('#GanaPuntosSi')}&count=10",
                           body: error.read)
    else
      trends = File.open(File.join(Rails.root, 'test', 'fixtures', 'trends.json'))
      FakeWeb.register_uri(:get, "#{TwitterConnection::TWITTER_API_URL}trends/place.json?id=#{TwitterConnection::WOEID_BA}", body: trends.read)

      search_tweet = File.open(File.join(Rails.root, 'test', 'fixtures', 'search_tweet.json'))
      FakeWeb.register_uri(:get, "#{TwitterConnection::TWITTER_API_URL}search/tweets.json?q=#{URI.encode('#GanaPuntosSi')}&count=10",
                           body: search_tweet.read)
    end
  end
end

class Test::Unit::TestCase
  include FactoryGirl::Syntax::Methods
end
