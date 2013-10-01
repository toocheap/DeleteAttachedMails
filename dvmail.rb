#!/usr/bin/env ruby
# vim: fileencoding=utf-8

require 'net/pop'
require 'mail'
require 'set'

whiltelist_from = Set[
  'alsi.co.jp',
  'netstar-inc.com',
  'itcnetwork.co.jp',
  'grassroots.co.jp',
  'athome.co.jp',
  'g.softbank.co.jp',
  'jp.alsi.biz',
  'jnsa.org',
]

pop = Net::POP3.new('10.10.121.33',110)
pop.start('tomoyuki.matsuda', 'mats0416')
if pop.mails.empty?
  $stderr.puts 'no mail.'
else
  $stderr.puts "Mailbox has #{pop.mails.length} mails."
  pop.mails.each_with_index do |m, idx|
    begin
      mail = Mail.new(m.pop)
    rescue 
      $stderr.puts "#{idx} had an exception. go next...."
      next
    end
    if mail.multipart?
      mail.from.each do |from|
        if whiltelist_from.member? from.split("@")[1]
          next
        else
          $stderr.puts "#{idx}:#{from}:"
          $stderr.puts "  #{mail.subject}"
          m.delete
        end
      end
    end
  end
end
pop.finish
