#!/usr/bin/env bash

################################################################################
# util functions
################################################################################

_color_print() {
  local color="$1"
  shift

  # about CI env var
  #   https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables
  if [[ -t 1 || true = "${GITHUB_ACTIONS:-}" ]]; then
    printf "\e[${color}m%s\e[0m\n" "$*"
  else
    printf '%s\n' "$*"
  fi
}

print_bar() {
  local bar="============================================================"
  _color_print '2;44' "$bar"
}

head_style_print() {
  print_bar
  _color_print '1;33;44' "$@"
  print_bar
}

note_print() {
  _color_print '0;35' "($*)"
}

info_print() {
  _color_print '1;36' "$*"
}

die() {
  _color_print '1;31' "Error: $*" >&2
  exit 1
}

loop() {
  local count=$1
  [[ $count =~ ^[0-9]+$ ]] || die "invalid count: $count"
  shift

  for ((i = 0; i < count; ++i)); do
    "$@"
  done
}

################################################################################
# parse options
################################################################################

fast_mode=false
if [[ $1 = -f || $1 = '--fast' ]]; then
  fast_mode=true
fi
readonly fast_mode

################################################################################
# perform test logic
################################################################################

# - # - # - # - # - # - # - # - # - # - # - #

head_style_print "env info"
printf "bash: %s, v%s\n\n" "$BASH" "$BASH_VERSION"

# - # - # - # - # - # - # - # - # - # - # - #

head_style_print "the overhead of loop(aka. empty loop body)"
echo

info_print "the time consumption of 100K time loop:"
note_print "including the overhead of the bash runtime startup(1 instance)"
time -p "$BASH" ./00-empty-loop-case.bash 100000
note_print "call function, no new bash instance"
time -p loop 100000 :
note_print "embedded loop statement, no new bash instance"
time -p for ((i = 0; i < 100000; i++)); do
  :
done

if ! $fast_mode; then
  echo

  info_print "the time consumption of 1M time loop:"
  note_print "including the overhead of the bash runtime startup(1 instance)"
  time -p "$BASH" ./00-empty-loop-case.bash 1000000
  note_print "call function, no new bash instance"
  time -p loop 1000000 :
  note_print "embedded loop statement, no new bash instance"
  time -p for ((i = 0; i < 1000000; i++)); do
    :
  done
fi

# - # - # - # - # - # - # - # - # - # - # - #

echo
head_style_print "the overhead of bash runtime(aka. empty script)"
note_print "including the overhead of the loop"
echo

info_print "the time consumption of 100 time:"
time -p loop 100 "$BASH" ./00-empty-bash-case.bash

if ! $fast_mode; then
  info_print "the time consumption of 1K time:"
  time -p loop 1000 "$BASH" ./00-empty-bash-case.bash
fi

# - # - # - # - # - # - # - # - # - # - # - #

echo
head_style_print "the overhead of var assignment"
note_print "including the overhead of the bash runtime startup(1 instance) and the loop"
echo

info_print "the time consumption of 100K time:"
time -p "$BASH" ./01-simple-assignment.bash 100000

if ! $fast_mode; then
  info_print "the time consumption of 1M time:"
  time -p "$BASH" ./01-simple-assignment.bash 1000000
fi

# - # - # - # - # - # - # - # - # - # - # - #

echo
head_style_print "the overhead of param expansion"
note_print "including the overhead of the bash runtime startup(1 instance) and the loop"
echo

info_print "the time consumption of 100K time:"
time -p "$BASH" 10-param-expansion.bash 100000

if ! $fast_mode; then
  info_print "the time consumption of 1M time:"
  time -p "$BASH" 10-param-expansion.bash 1000000
fi

# - # - # - # - # - # - # - # - # - # - # - #

echo
head_style_print "the overhead of command substitution"
note_print "including the overhead of the loop"
echo

info_print "the time consumption of 1K time:"
time -p "$BASH" ./20-command-substitution.bash 1000

if ! $fast_mode; then
  info_print "the time consumption of 10K time:"
  time -p "$BASH" ./20-command-substitution.bash 10000
fi
