# -*- coding: utf-8 -*-
require 'ostruct'
require 'pp'

date_re = /(Apr\.|April|Aug|August|August\.|December|Februar|Januar|Jul\.|Juli|Juli\.|Juni|Juni\.|Mai|Mai\.|März|November|Oct|October)\s+(\d{1,2})/



class Feast

  SAINT_ABBREVIATIONS = %w(
    b.
    abb.
    aep.
    ap.
    apost.
    archa.
    archang.
    archidiac.
    archiep.
    b.
    bapt.
    cf.
    conf.
    diac.
    doct.
    domini.
    eccl.
    ep.
    erem.
    ev.evang.
    imp.
    m.
    min.
    mon.
    ord.
    patr.
    pb.
    pont.
    pp.
    pred.
    prep.
    proph.
    protom.
    reg.
    s.
    sacerd.
    sc.
    soc.
    solit.
  )


  ABBREV_PATTERNS = ([ '\\b8a\\b' ] + SAINT_ABBREVIATIONS.map { |s| "\\b#{Regexp.escape(s)}" }).join '|'

  MONTHS = %w(

  )

  MONTH_RE = "Apr\.|April\b|Aug\b|August\b|August\.|December\b|Februar\b|Januar\b|Jul\.|Juli\b|Juli\.|Juni\b|Juni\.|Mai\b|März\b|November\b|Oct\b|October\b"

  def lex_line line
    line.strip.scan(/#{ABBREV_PATTERNS}|/).chunk do |x|

    # line.strip.scan(/#{ABBREV_PATTERNS}|[[:digit:]]+|[[:alpha:]]+|[-.:)(,|+*;!'?=&\[\]]/).chunk do |x|
      case x
      when MONTH_RE            then :month
      when /\d+/               then :number
      when /\b8a\b/            then :octave
      when /\bb\./             then :blessed
        # confirm beati, beate is blessed
      when /\babb\./           then :abbot
      when /\baep\./           then :archbishop
      when /\bap\.|apost\./      then  :apostle
      when /\barcha\.|archang\./ then :archangel
      when /\barchidiac\./     then :archdeacon
      when /\barchiep\./       then :archbishop
      when /\bb\./             then :beloved
      when /\bbapt\./          then :baptist
      when /\bcf\.|conf\./       then :confessor
      when /\bdiac\./          then :deacon
      when /\bdoct\./          then :doctor
      when /\bdomini\./        then :domini
      when /\beccl\./          then :preacher
      when /\bep\./            then :bishop
      when /\berem\./          then :hermit
      when /\bev\.|evang\./      then :evangelist
      when /\bimp\./           then :emperor
      when /\bm\./             then :martyr
      when /\bmin\./           then :franciscan
      when /\bmon\./           then :monk
      when /\bord\./           then :order
      when /\bpatr\./          then :patriarch
      when /\bpb\./            then :elder
      when /\bpont\./          then :pontiff
      when /\bpp\./            then :pope
      when /\bpred\./          then :dominican
      when /\bprep\./          then :prior
      when /\bproph\./         then :prophet
      when /\bprotom\./        then :protomartyr
      when /\breg\./           then :king_queen
      when /\bs\./             then :saint_or_vid
      when /\bsacerd\./        then :priest
      when /\bsc\./            then :scilicet
      when /\bsoc\./           then :companions
      when /\bsolit\./         then :solitary
        # what is solitarii? does this men recluse? or s.t. like a hermit
        # or does it mean that this saint is found in one place;
        # none of the GTZ entries appear in MNET
      when /\bv\./             then :virgin_or_venerable
        # virgin after names, but venerable when before a name
      when /\bvid\./           then :widow
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
      when /[[:alpha:]]/       then :word

      end
    end
  end
end

count = 0
feast = Feast.new
ARGF.each_line do |line|
  puts feast.lex_line(line).to_a.pretty_inspect
  break if count > 10
  count += 1
end
