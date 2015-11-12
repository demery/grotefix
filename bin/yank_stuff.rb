# -*- coding: utf-8 -*-

card_dates = /(?:Jan|Feb|Mär|Apr|Mai|Jun|Jul|Aug|Sep|Oct|Nov|Dec)(?:[.a-z]*)\s+(?:\d{1,2})/

ord_dates = /(\d{1,2}\.)\s+(Jan|Feb|Mär|Apr|Mai|Jun|Jul|Aug|Sep|Oct|Nov|Dec)([.a-z]*)/

death_re = /\(\+[^)]+\d+[^)]\)/

ARGF.each_line do |line|
  line.scan(card_dates).each { |s| puts s }
  # line.scan(death_re).each { |s| puts "#{s}" }
end
