#!/usr/bin/awk -f

# colorize - add color to go test output
# usage:
#   go test ./... | ./bin/colorize
#

BEGIN {
    RED="\033[31m"
    GREEN="\033[32m"
    CYAN="\033[36m"
    BRRED="\033[91m"
    BRGREEN="\033[92m"
    BRCYAN="\033[96m"
    NORMAL="\033[0m"
    GREEN_EMOJI="🐍" # Green Circle Emoji
    RED_EMOJI="🔴"   # Red Circle Emoji
}
         { color=NORMAL }
/^\?/    { next } # Skip lines starting with "?"
/^ok /   { color=BRGREEN; print color GREEN_EMOJI " " $0 NORMAL; next }
/^FAIL/  { color=BRRED; print color RED_EMOJI " " $0 NORMAL; next }
/^SKIP/  { color=BRCYAN }
/^RUN/   { color=BRCYAN }
/RUN/    { color=CYAN }
/PASS:/  { color=GREEN; print color GREEN_EMOJI " " $0 NORMAL; next }
/FAIL:/  { color=RED; print color RED_EMOJI " " $0 NORMAL; next }
/SKIP:/  { color=CYAN }
         { print color $0 NORMAL }

# vi: ft=awk
