require 'test_helper'
require 'fakeweb'

class TwitterConnectionTest < Test::Unit::TestCase
  def setup
    @twitter_connection = TwitterConnection.new
    FakeWeb.allow_net_connect = false
  end

  def teardown
    FakeWeb.clean_registry
  end
  context 'last trending topics' do
    setup do
      trends = File.open(File.join(Rails.root, 'test', 'fixtures', 'trends.json'))
      FakeWeb.register_uri(:get, "#{TwitterConnection::TWITTER_API_URL}trends/place.json?id=#{TwitterConnection::WOEID_BA}", body: trends.read)
    end

    should 'return all trending topics from response' do
      trending_topics = @twitter_connection.trending_topics

      trending_topics_expected = ['#GanaPuntosSi',
                                  '#WordsThatDescribeMe',
                                  '#10PersonasQueExtrañoMucho',
                                  'Apple $1.5',
                                  'Zelko',
                                  'LWWY',
                                  'Lance Armstrong',
                                  'Gonzo',
                                  'Premium Rush',
                                  'Sweet Dreams'
                                 ]
      assert_equal trending_topics_expected, trending_topics
    end
  end

  context 'tweets with hashtag' do
    setup do
      search_tweet = File.open(File.join(Rails.root, 'test', 'fixtures', 'search_tweet.json'))
      FakeWeb.register_uri(:get, "#{TwitterConnection::TWITTER_API_URL}search/tweets.json?q=#{URI.encode('#freebandnames')}&count=4",
                           body: search_tweet.read)
    end

    should 'return the amount of tweets returned' do
      assert_equal 4, @twitter_connection.tweets_with_hashtag('#freebandnames', 4).size
    end

    should 'get all fields from tweets correctly' do
      tweets = @twitter_connection.tweets_with_hashtag('#freebandnames', 4)

      tweet_expected = { id: 250_075_927_172_759_552,
                         text: 'Aggressive Ponytail #freebandnames',
                         date: 'Mon Sep 24 03:35:21 +0000 2012',
                         user_id: 137_238_150,
                         user_image_path: 'http://a0.twimg.com/profile_images/2359746665/1v6zfgqo8g0d3mk7ii5s_normal.jpeg',
                         user_bio: 'Born 330 Live 310'
      }
      assert_expected_tweet(tweet_expected, tweets[0])

      tweet_expected = { id: 249_292_149_810_667_520,
                         text: 'Thee Namaste Nerdz. #FreeBandNames',
                         date: 'Fri Sep 21 23:40:54 +0000 2012',
                         user_id: 29_516_238,
                         user_image_path: 'http://a0.twimg.com/profile_images/447958234/Lichtenstein_normal.jpg',
                         user_bio: 'You will come to Durham, North Carolina. I will sell you some records then, here in Durham, North Carolina. Fun will happen.'
      }
      assert_expected_tweet(tweet_expected, tweets[1])

      tweet_expected = { id: 249_289_491_129_438_208,
                         text: 'Mexican Heaven, Mexican Hell #freebandnames',
                         date: 'Fri Sep 21 23:30:20 +0000 2012',
                         user_id: 70_789_458,
                         user_image_path: 'http://a0.twimg.com/profile_images/2219333930/Froggystyle_normal.png',
                         user_bio: 'Science Fiction Writer, sort of. Likes Superheroes, Mole People, Alt. Timelines.'
      }
      assert_expected_tweet(tweet_expected, tweets[2])

      tweet_expected = { id: 249_279_667_666_817_024,
                         text: 'The Foolish Mortals #freebandnames',
                         date: 'Fri Sep 21 22:51:18 +0000 2012',
                         user_id: 37_539_828,
                         user_image_path: 'http://a0.twimg.com/profile_images/1629790393/shrinker_2000_trans_normal.png',
                         user_bio: 'Cartoonist, Illustrator, and T-Shirt connoisseur'
      }
      assert_expected_tweet(tweet_expected, tweets[3])
    end
  end

  context 'when rate limit exceeded is returned by twitter API' do
    setup do
      error = File.open(File.join(Rails.root, 'test', 'fixtures', 'twitter_error.json'))
      FakeWeb.register_uri(:get, "#{TwitterConnection::TWITTER_API_URL}trends/place.json?id=#{TwitterConnection::WOEID_BA}", body: error.read)
    end

    should 'raise a RuntimeError Exception with message' do
      assert_raise(RuntimeError.new('Rate limit exceeded')) { @twitter_connection.trending_topics }
    end
  end

  context 'Could not get Twitter response' do
    should 'raise a RuntimeError Exception with message' do
      assert_raise(RuntimeError.new('Could not get Twitter response')) { @twitter_connection.trending_topics }
    end
  end

  private

  def assert_expected_tweet(tweet_expected, tweet)
    assert_equal tweet_expected[:id], tweet.id
    assert_equal tweet_expected[:text], tweet.text
    assert_equal tweet_expected[:date], tweet.date
    assert_equal tweet_expected[:user_id], tweet.user_id
    assert_equal tweet_expected[:user_image_path], tweet.user_image_path
    assert_equal tweet_expected[:user_bio], tweet.user_bio
  end
end
