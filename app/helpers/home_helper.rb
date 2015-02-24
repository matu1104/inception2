module HomeHelper
  def user_bio(tweet)
    if tweet.user_bio.empty?
      content_tag :div, {class: 'alert alert-danger', role: 'alert', id: 'error_explanation'} do
        content_tag(:strong, tweet.username) + ' hasn\'t got a description '
      end
    else
      tweet.user_bio
    end
  end
end
