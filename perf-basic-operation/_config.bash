COUNT=5000
readonly TEST_VAR='/a/b/c.txt/'

printf "sourced %s %s by %s\n" "COUNT=$COUNT" "TEST_VAR=$TEST_VAR" "$BASH"
