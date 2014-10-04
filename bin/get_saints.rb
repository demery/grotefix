#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

MONTH_RE = /((Jan|Feb|Mär|Apr|Mai|Jun|Jul|Aug|Sept|Oct|Nov|Dec)[.a-zA-Z]*\s\d+):/

def print_days saint, section
  section.scan(MONTH_RE).each do |d|
    puts(sprintf "%s\t%s\t%s", saint, d[0], section)
  end
end

IO.foreach(ARGV.shift) do |line|
  parts = line.strip.split(/\|\|/)
  if parts[0] =~ MONTH_RE
    saint = $`
    parts.each do |p|
      print_days saint, p
    end
  end
end
