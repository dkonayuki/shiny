require 'date'

module Shiny
  module TimeAgo
    def time_ago
      raise 'Not compatible class.' unless self.kind_of? Time

      time_diff = Time.now.to_i - self.to_i

      if (time_diff > (86400 * 3))
        self
      else
        time_ago_in_words(time_diff)
      end
    end

private
    def time_ago_in_words(time_diff)
      case time_diff
      when 0..20                      then "just now"
      when 21..119                    then "about a minute ago"
      when 120..3599                  then "#{time_diff / 60} minutes ago"
      when 3600..86399                then "#{(time_diff / 3600).round} hours ago"
      when 86400..259199              then "#{(time_diff / 86400).round} days ago"
      when 2592000..(86400 * 365 - 1) then "#{(time_diff / (86400 * 30))} months ago"
      else "#{(time_diff / (86400 * 365))} years ago"
      end
    end
  end
end
