#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import sys
import os

this_dir = os.path.dirname(__file__)
saints_file = os.path.join(this_dir, '..', 'data', 'all_saints.txt')

# skip when we find these
START_DATE_RE = re.compile('^((Jan|Feb|Mär|Apr|Mai|Jun|Jul|Aug|Sept|Oct|Nov|Dec)[.a-zA-Z]*\s+\d+)(\s+\(!\))?:')
SKIPS_RE      = re.compile('^(Antonii m\.|v\.|b\.|vid\.|auf|Ein |Vgl\.|Nur |m\.|III\.|\|\d{3}\|)')

# strip stuff off with these
HAS_DATE_RE   = re.compile('((Jan|Feb|Mär|Apr|Mai|Jun|Jul|Aug|Sept|Oct|Nov|Dec)[.a-zA-Z]*\s+\d+).*')
OTHER_NUM_RE  = re.compile(' ?\(?\d{4}\)? ?')
NACH_RE       = re.compile(' \((auch|ausser|nach)\s+[^)]\)?.*')
PARENS_RE     = re.compile('^\s*\(([^)]+)\)\s*$')


feasts = set()

for line in open(sys.argv[1]):
    if re.search(r'^SKIP', line):
        pass
    else:
        saint, feast, date, section = line.split('\t')
        feast = feast.strip()
        if START_DATE_RE.search(feast) or SKIPS_RE.search(feast):
            pass
        else:
            feast = re.sub(',\s*$', '', re.sub(NACH_RE, '', re.sub(OTHER_NUM_RE, '', re.sub(HAS_DATE_RE, '', feast)))).strip()
            # if PARENS_RE.match(feast):
            #     feast = re.sub(PARENS_RE, r'\1', feast)
            feasts.add(feast)

all_lines = None
with open(saints_file) as f:
    all_lines = f.readlines()

# import re
# filter(lambda x:re.search(r'aet', x), names)

feast_list = list(feasts)
feast_list.sort()

subs = []
counts = {}

for feast in feast_list:
    counts.setdefault(feast, 1)
    r = re.compile(r'\b%s\b' % re.escape(feast))
    print r.pattern
    match_feasts = filter(lambda x:r.search(x), all_lines)
    for m in match_feasts:
        counts[feast] += len(r.findall(m))
    for sub in subs:
        if feast.find(sub) > -1:
            counts[sub] -= counts[feast]
        else:
            del subs[subs.index(sub)]
    subs.append(feast)

for feast in feast_list:
    print "%6d\t%s" % (counts[feast], feast)


# for feast in sorted(list(feasts)):
#     print feast
