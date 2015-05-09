#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'axlsx'

outfile = File.expand_path('../../junk.xlsx', __FILE__)

months = 'Apr\b|April|Aug\b|August\b|December|Februar|Januar\b|Jul\b|Juli\b|Juni\b|Mai\b|März|November|Oct\b|October|September|Sept\b'
month_re = /(#{months})/

ord_date_re  = /(\d{1,2})\.\s+(#{months})/
card_date_re = /(#{months})\s+(\d{1,2})/

def month_number month
  case month
  when /Jan/ then 1
  when /Feb/ then 2
  when /Mär/ then 3
  when /Apr/ then 4
  when /Mai/ then 5
  when /Jun/ then 6
  when /Jul/ then 7
  when /Aug/ then 8
  when /Sep/ then 9
  when /Oct/ then 10
  when /Nov/ then 11
  when /Dec/ then 12
  end
end

p = Axlsx::Package.new
wb = p.workbook
header =  %w{ Month Day Date Feast Alt LineNo Line }

wb.add_worksheet name: 'feasts' do |wksh|
  wksh.add_row header
  last_feast = nil

  ARGF.each do |line|
    # axlsx requires htmlentities, which changes ARGF.lineno; we have to
    # access ARGF.file.lineno
    lineno = ARGF.file.lineno
    alt = nil
    if line =~ /\A(-.*?)(#{months})/
      alt = $1
    elsif line =~ /\A(.*?)(#{months})/
      feast = $1
      last_feast = feast
    else
      row                        = []
      # row[header.index 'Feast']  = line
      row[header.index 'LineNo'] = lineno
      row[header.index 'Line']   = line
      wksh.add_row row
      next
    end

    line.strip.scan(card_date_re).each do |date|
      month                      = month_number date.first
      row                        = []
      row[header.index 'Month']  = month
      row[header.index 'Day']    = date.last
      row[header.index 'Date']   = date.join(' ')
      row[header.index 'Feast']  = (feast||last_feast)
      row[header.index 'Alt']    = alt
      row[header.index 'LineNo'] = lineno
      row[header.index 'Line']   = line
      wksh.add_row row
    end
    line.strip.scan(ord_date_re).each do |date|
      month                      = month_number date.last
      row                        = []
      row[header.index 'Month']  = month
      row[header.index 'Day']    = date.first
      row[header.index 'Date']   = date.join(' ')
      row[header.index 'Feast']  = (feast||last_feast)
      row[header.index 'Alt']    = alt
      row[header.index 'LineNo'] = lineno
      row[header.index 'Line']   = line
      wksh.add_row row
    end
  end
  # ugh, override auto column widths
  widths = (0..4).map { 30 }
  wksh.column_widths(*widths)
end

p.serialize outfile

puts "Wrote #{outfile}"
