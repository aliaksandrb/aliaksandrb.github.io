module CustomHelpers
  def text_to_end_in_minutes(content_string)
    # https://en.wikipedia.org/wiki/Words_per_minute#Reading_and_comprehension
    "#{(content_string.split.size / 200.0).ceil} min"
  end
end
