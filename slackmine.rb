#!/usr/bin/env ruby

require 'rss'
require 'open-uri'
require 'json'
require 'sanitize'

atom_urls = { "#channel_name" => ['http://redmine_atom_url', 'https://hooks.slack.com/services/your_slack_webhook']}

lastupdate = Time.now-59

class Webhook
  attr_reader :feed
  
  def initialize(url)
    open(url) do |atom|
      @feed = RSS::Parser.parse(atom, false)
    end
    return @feed
  end
  
  def updated?(since=Time.now-86400)
    if @feed.updated.content >= since
      return true
    else
      return false
    end
  end
  
  def post_updates(since=Time.now-86400, channel, webhook)
    @feed.entries.reverse.each do |entry|
      if entry.updated.content >= since
        color = colorize(entry)
        attachment = [{"author_name" => entry.author.name.content, "title" => entry.title.content, "title_link" => entry.id.content, "text" => Sanitize.clean(entry.content.content).strip.gsub(/\n|\t/,""), "color" => color}]
        payload = {"channel" => channel, "username" => "Redmine", "text" => "Redmine Activity", "icon_emoji" => ":redmine:", "attachments" => attachment}
        `curl -X POST --data-urlencode 'payload=#{payload.to_json}' #{webhook}`
        puts payload.to_json
      end
    end
  end
     
  private
  
  def colorize(entry)
    case entry.title.content
    when /Closed/
      color = "good"
    when /New/
      color = "#2299ff"
    when /Feedback/
      color = "#ff7373"
    when /Ready for testing/
      color = "#ff7373"
    when /Resolved/
      color = "#6bd2db"
    else 
      color = "#595959"
    end
    return color
  end

end


atom_urls.each do |channel,urls|
  feed = Webhook.new(urls[0])
  if feed.updated?(lastupdate) == true
    feed.post_updates(lastupdate,channel,urls[1])
  end
end