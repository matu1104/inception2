module DeviseHelper
  def devise_error_message!
    return '' if resource.errors.empty?

    html = content_tag :div, {class: 'alert alert-danger', role: 'alert', id: 'error_explanation'} do
      content_tag :ul do
        resource.errors.full_messages.collect { |item| concat(content_tag(:li, item)) }
      end
    end

    html.html_safe
  end

  def login_error_message!
    return '' if flash[:alert].nil?

    html = content_tag :div, {class: 'alert alert-danger', role: 'alert', id: 'error_explanation'} do
      content_tag(:strong, 'Upss!! ') + flash[:alert]
    end

    html.html_safe
  end

  def tweets_hashtag
    @tweets ||= TwitterConnection.instance.tweets_with_hashtag('#twitter', 10)
  end

  def hashtag_name
    @hashtag_name ||= '#twitter'
  end

end