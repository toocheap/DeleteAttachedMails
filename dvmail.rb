#!/usr/bin/env ruby
# vim: fileencoding=utf-8

require 'net/pop'
require 'mail'
require 'tempfile'
require 'set'

internal_from = Set['alsi.co.jp', 'netstar-inc.com']

pop = Net::POP3.new('10.10.121.33',110)
pop.start('tomoyuki.matsuda', 'mats0416')
if pop.mails.empty?
  $stderr.puts 'no mail.'
else
  pop.mails.each_with_index do |m, idx|
    File.open "inbox#{idx}","wb" do |tf|
      tf.write m.pop
      mail = Mail.read(tf.path)
      if mail.multipart?
        mail.from.each do |from|
          if internal_from.member? from.split("@")[1]
            next
          else
            $stderr.puts "#{idx}:#{from}:#{mail.subject}"
            # str = $stdin.getc
            # if str.downcase() == 'y'
            #   mail.delete
            #   $stderr.puts "Deleted."
            # end
          end
        end
      end
      tf.close
      File.unlink tf.path
    end
  end
end


