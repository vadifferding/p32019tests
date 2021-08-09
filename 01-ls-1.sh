source "${TEST_DIR}/funcs.bash"

test_start "Unix Utilities" \
    "Runs 'ls /'  with custom memory allocator"

# Check to make sure the library exists
[[ -e "./allocator.so" ]] || test_end 1

expected=$(ls /)
actual=$(LD_PRELOAD=./allocator.so ls /) || test_end
compare <(echo "${expected}") <(echo "${actual}") || test_end

test_end
