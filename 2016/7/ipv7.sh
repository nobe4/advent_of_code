#!/bin/sh

# Solution 1
# - Remove all aaaa+ lines from the file
# - Don't match the abba inside [[]
# - Match all other lines
# - Count the results
cat data.txt \
  | sed 's/\(.\)\1\{3,\}//g' \
  | grep -Ev '\[\w*(\w)(\w)\2\1\w*\]' \
  | grep -E '(\w)(\w)\2\1' \
  | wc -l


# Solution 2
# - Replace all aaa+ sequence with aa
# - Breakdown:
#   (^|\])            start of the line or a closing bracket, will ensure we match an group outside a []
#   \w*               letters outside []
#   (.)(.)\2          aba pattern with matching group 2 and 3
#   .*                anything until
#   \[                start of the []
#     \w*             any letter, stay in []
#     \3\2\3          bab
#   |                 or
#   \[                start in a []
#     \w*             any letters until
#     (.)(.)\4        aba with matchings groups 4 and 5
#     .*              anything until
#   \]                end of []
#   \w*               any letters, stays out of []
#   \5\4\5            bab

cat data.txt \
  | sed 's/\(.\)\1\{2,\}/\1/g' \
  | grep -E '(^|\])\w*(.)(.)\2.*\[\w*\3\2\3|\[\w*(.)(.)\4.*\]\w*\5\4\5' \
  | wc -l
