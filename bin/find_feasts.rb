# -*- coding: utf-8 -*-
require 'ostruct'
require 'pp'

date_re = /(Apr\.|April|Aug|August|August\.|December|Februar|Januar|Jul\.|Juli|Juli\.|Juni|Juni\.|Mai|Mai\.|März|November|Oct|October)\s+(\d{1,2})/



class Feast

  SAINT_ABBREVIATIONS = %w(
    8a
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
    v.
  )

  ABBREV_PATTERNS = SAINT_ABBREVIATIONS.map { |s|
    s =~ /\.$/ ? "\\b#{Regexp.escape s}" : "\\b#{s}\\b"
  }.join '|'

  MONTHS = %w(
    Apr.
    April
    Aug
    August
    August.
    December
    Februar
    Januar
    Jul.
    Juli
    Juli.
    Juni
    Juni.
    Mai
    März
    November
    Oct
    October
    Sept
    September
  )

  MONTHS_PATTERN = MONTHS.map { |month|
    month =~ /\.$/ ? "\\b#{Regexp.escape month}" : "\\b#{month}\\b"
  }.join '|'

  CARDINAL_DATES_PATTERN = MONTHS.map { |month|
    "\\b#{Regexp.escape month}\\s+\\d{1,2}"
  }.join '|'

  CARDINAL_DATES_RE = /#{CARDINAL_DATES_PATTERN}/

  ORDINAL_DATES_PATTERN = MONTHS.map { |month|
    "\\d{1,2}\\.\\s+#{Regexp.escape month}"
  }.join '|'

  ORDINAL_DATES_RE = /#{ORDINAL_DATES_PATTERN}/

  MONTHS_RE = /#{MONTHS_PATTERN}/

  PUNCTS_PATTERN = "[-.:(),|+*;!'?=&\\[\\]]"

  PUNCTS_RE = /#{PUNCTS_PATTERN}/

  # Source abbreviations
  # A. - L'Art de verifier les Dates.
  #
  # A. S. - Acta Sanctorum Bollandiana.
  #
  # A. S. H. - Acta Sanctorum Hiberniae.
  #
  # D. - Dupont, Liste générale des Saints (Annuaire historique publié par la Société d'Histoire de France 1857, 1858, 1860).
  #
  # E. - Ebner, Quellen zur Geschichte des Missale Romanum. Iter italicum (Freiburg, 1896).
  #
  # G. - Gams, Series episcoporum (Regensburg, 1873).
  #
  # H. - Hampson, medii aevi kalendarium (London 1841).
  #
  # M. - Cte de Mas Latrie, Tresor de la Chronologie (Paris 1889).
  #
  # Mab. - Mabillon, acta sanctorum ord. s. Benedicti.
  #
  # P. - Pilgram, Calendarium chronologicum (Wien 1781).
  #
  # R. D. - Reinsberg-Düringsfeld, Calendrier Belge (Brüssel 1861) oder Festkalender aus Böhmen (Prag 1862).
  #
  # S. - Surius, de probatis sanctorum historiis.
  #
  # W. - Warren, the liturgy of the Celtic Church (1881)
  #

  SOURCES = [
             'A. S. H.',
             'A. S.',
             'A.S.H.',
             'A.S.',
             'R. D.',
             'R.D.',
             'A.',
             'D.',
             'E.',
             'G.',
             'H.',
             'M.',
             'Mab.',
             'P.',
             'S.',
             'W.'
            ]

  SOURCE_PATTERNS = SOURCES.map { |source|
    "\\b#{Regexp.escape source}"
  }.join '|'

  SOURCE_RE = /#{SOURCE_PATTERNS}/

  ALT_SOURCE_LOCALE_PATTERN = "\\[[^\\]]+\\]"

  ALT_SOURCE_LOCALE_RE = /#{ALT_SOURCE_LOCALE_PATTERN}/

  DEATH_PATTERN = "\\(\\+[^)]+\\d+[^)\|]\\)"

  DEATH_RE = /#{DEATH_PATTERN}/

  SUBSECTION_PATTERN = "\\|\\|"

  AND_PATTERN = "\\bet\\b"

  AND_RE = /#{AND_PATTERN}/

  SUBSECTION_RE = /#{SUBSECTION_PATTERN}/

  NAME_PATTERN = "[[:upper:]][[:alpha:]]+"

  NAME_RE = /#{NAME_PATTERN}/

  DITTO_PATTERN = "^- "

  DITTO_RE = /#{DITTO_PATTERN}/

  def lex_line line
    line.strip.scan(/#{DITTO_RE}|#{DEATH_PATTERN}|#{ALT_SOURCE_LOCALE_PATTERN}|#{ABBREV_PATTERNS}|#{CARDINAL_DATES_PATTERN}|#{ORDINAL_DATES_PATTERN}|#{SOURCE_PATTERNS}|#{AND_PATTERN}|#{NAME_PATTERN}|[[:alpha:]]+|[[:digit:]]+|#{SUBSECTION_PATTERN}|#{PUNCTS_PATTERN}/).chunk do |x|

      case x
      when DITTO_RE then :ditto
      when DEATH_RE then :death
      when ORDINAL_DATES_RE then :ordinal_date
      when CARDINAL_DATES_RE then :cardinal_date
      when ALT_SOURCE_LOCALE_RE then :alt_source_locale
      when SOURCE_RE then :source
      when AND_RE then :and
      when SUBSECTION_RE then :subsection
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
      when NAME_RE then :name
      when /[[:alpha:]]+/       then :word
      when /[[:digit:]]+/ then :number
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
      end
    end
  end
end

count = 0
feast = Feast.new
ARGF.each_line do |line|
  puts feast.lex_line(line).to_a.inspect
  break if count > 40
  count += 1
end
