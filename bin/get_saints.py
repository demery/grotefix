#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import sys

MONTH_RE = re.compile('((Jan|Feb|Mär|Apr|Mai|Jun|Jul|Aug|Sept|Oct|Nov|Dec)[.a-zA-Z]*\s+\d+)(\s+\([^)]+\))?:')

def get_the_first_part(match,section):
    return section[:match.start()]

def print_days(saint, part, num):
    if MONTH_RE.search(part):
        for m in MONTH_RE.finditer(part):
            if num > 0 and m.start() > 0:
                print "%s\t%s\t%s\t%s" % (saint, get_the_first_part(m, part), m.group(1), part)
            else:
                print "%s\t%s\t%s\t%s" % (saint, '', m.group(1), part)
    else:
        print "SKIPPED SECTION: %s" % part

for line in open(sys.argv[1]):
    parts =  line.strip().split('||')
    m = MONTH_RE.search(parts[0])
    if m:
        saint = get_the_first_part(m,parts[0])
        i = 0
        for p in parts:
            print_days(saint, p, i)
            i += 1
    else:
        print "SKIPPED LINE: %s" % line.strip()
