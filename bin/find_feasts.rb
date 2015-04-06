# -*- coding: utf-8 -*-
require 'ostruct'
require 'pp'

month_re = /Apr\.|April|Aug|August|August\.|December|Februar|Januar|Jul\.|Juli|Juli\.|Juni|Juni\.|Mai|März|November|Oct|October/

date_re = /(Apr\.|April|Aug|August|August\.|December|Februar|Januar|Jul\.|Juli|Juli\.|Juni|Juni\.|Mai|Mai\.|März|November|Oct|October)\s+(\d{1,2})/

class Feast
  def lex_line line
    line.script.scan(/8a|[[:digit:]]+|[[:alpha:]]+|[-.:)(,|+*;!'?=&\[\]]/).chunk do |x|
      case x
      when /-/                 then :dash
      when /\./                then :dot
      when /:/                 then :colon
      when /\(/                then :open_paren
      when /\)/                then :close_paren
      when /,/                 then :comma
      when /\|/                then :pipe
      when /\+/                then :dagger
      when /\*/                then :asterisk
      when /;/                 then :semi_colon
      when /\!/                then :bang
      when /'/                 then :apostrophe
      when /\?/                then :question
      when /=/                 then :equals
      when /&/                 then :ampersan
      when /\[/                then :open_bracket
      when /\]/                then :close_bracket
      when month_re            then :month
      when /\d+/               then :number
      when /\b8a\b/            then :octave
      when /\bb\b/             then :bishop
      when /\babb\b/           then :abbot
      when /\baep\b/           then :archbishop
      when /\bap|apost\b/      then  :apostle
      when /\barcha|archang\b/ then :archangel
      when /\barchidiac\b/     then :archdeacon
      when /\barchiep\b/       then :archbishop
      when /\bb\b/             then :beloved
      when /\bbapt\b/          then :baptist
      when /\bcf|conf\b/       then :confessor
      when /\bdiac\b/          then :deacon
      when /\bdoct\b/          then :doctor
      when /\bdomini\b/        then :domini
      when /\beccl\b/          then :preacher
      when /\bep\b/            then :bishop
      when /\berem\b/          then :hermit
      when /\bev|evang\b/      then :evangelist
      when /\bimp\b/           then :emperor
      when /\bm\b/             then :martyr
      when /\bmin\b/           then :franciscan
      when /\bmon\b/           then :monk
      when /\bord\b/           then :order
      when /\bpatr\b/          then :patriarch
      when /\bpb\b/            then :elder
      when /\bpont\b/          then :pontiff
      when /\bpp\b/            then :pope
      when /\bpred\b/          then :dominican
      when /\bprep\b/          then :prior
      when /\bproph\b/         then :prophet
      when /\bprotom\b/        then :protomartyr
      when /\breg\b/           then :king_queen
      when /\bs\b/             then :saint_or_vid
      when /\bsacerd\b/        then :priest
      when /\bsc\b/            then :scilicet
      when /\bsoc\b/           then :companions
      when /\bsolit\b/         then :solitary
        # what is solitarii? does this men recluse? or s.t. like a hermit
        # or does it mean that this saint is found in one place;
        # none of the GTZ entries appear in MNET
      when /\bv\b/             then :virgin_or_venerable
        # virgin after names, but venerable when before a name
      when /\bvid\b/           then :widow
      when /[[:alpha:]]/       then :word
      end
    end
  end
end
