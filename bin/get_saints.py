#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import sys

MONTH_RE =  re.compile('((Jan|Feb|Mär|Apr|Mai|Jun|Jul|Aug|Sept|Oct|Nov|Dec)[.a-zA-Z]*\s+\d+):')

def print_days(saint, section):
    if MONTH_RE.search(section):
        for m in MONTH_RE.finditer(section):
            print "%s\t%s\t%s" % (saint, m.group(1), section)
    else:
        print "SKIPPED SECTION: %s" % section

for line in open(sys.argv[1]):
    parts =  line.strip().split('||')
    m = MONTH_RE.search(parts[0])
    if m:
        saint = parts[0][:m.start()]
        for p in parts:
            print_days(saint, p)
    else:
        print "SKIPPED LINE: %s" % line.strip()
