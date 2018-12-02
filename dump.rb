#!/usr/bin/env ruby

require 'fileutils'
require 'json'

require 'rubygems'
require 'bundler/setup'

require 'intercom'
require 'pry'
require 'restclient'


def resource_url(path)
  "https://api.intercom.io/#{path}"
end


def headers
  {
    'Authorization' => "Bearer #{ENV['ACCESS_TOKEN']}",
    'Accept' => 'application/json'
  }
end


def retrieve(url)
  $stdout.write "Dumping #{url}: "
  JSON.parse(RestClient.get(url, headers)).tap do |hash|
    puts 'ok'
  end
rescue RestClient::NotFound => e
  puts e
end


def filename_for_page(resource, pages)
  if pages.nil?
    "#{resource}.json"
  else
    max_digits = pages['total_pages'].to_s.size
    number = sprintf("%0#{max_digits}d", pages['page'])
    "#{resource}-#{number}.json"
  end
end


def save_json(page, filename)
  full_path = File.join('intercom-dump', filename)
  FileUtils.mkdir_p(File.dirname(full_path))
  open(full_path, 'w') { |file| JSON.dump(page, file) }
end


def next_page(pages)
  return nil if pages.nil?
  next_page_url = pages['next']
  retrieve(next_page_url) if next_page_url
end


def dump_pages_to_json(intercom, resource)
  page = retrieve(resource_url(resource))
  while page
    pages = page.fetch('pages', nil)
    save_json(page, filename_for_page(resource, pages))
    page = next_page(pages)
  end
end


def main
  intercom = Intercom::Client.new(token: ENV['ACCESS_TOKEN'])
  %w[
    admins
    companies
    conversations
    data_attributes/company
    data_attributes/customer
    leads
    segments
    tags
    teams
    users
  ].each do |resource|
    dump_pages_to_json(intercom, resource)
  end
end


main
