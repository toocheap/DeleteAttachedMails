#!/usr/bin/env ruby
# vim: fileencoding=utf-8

require 'net/pop'
require 'mail'
require 'set'

internal_from = Set['alsi.co.jp', 'netstar-inc.com']

Mail.defaults do
  retriever_method :pop3, :address =>'10.10.121.33',:port => 110, :user_name => 'tomoyuki.matsuda', :password =>'mats0416'
end
emails = Mail.all
if emails.length == 0
  $stderr.puts 'no mail.'
else
  emails.each_with_index do |m, idx|
    if m.multipart?
      m.from.each do |from|
        if internal_from.member? from.split("@")[1]
          next
        else
          $stderr.puts "Delete?(y/n) From:#{m.from}/#{m.subject}"
          str = $stdin.getc
          if str.downcase() == 'y'
            p m
            m.delete
          end
        end
      end
    end
  end
end


