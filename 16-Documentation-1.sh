source "${TEST_DIR}/funcs.bash"

file_failed=false

test_start "Documentation Check" \
    "Ensures documentation is provided for each function and data structure"

if ! ( which doxygen &> /dev/null ); then
    # "Doxygen is not installed. Please install (as root) with:"
    # "pacman -Sy doxygen"
    test_end 1
fi

# All .c and .h files will be considered; if you'd like to exclude temporary or
# backup files then add a different extension (such as .bak).
for file in $(find . -type f \( -iname "*.c" -o -iname "*.h" \) -not -path "./tests/*"); do
    if ! ( grep '@file' "${file}" &> /dev/null ); then
        echo "@file documentation preamble not found in ${file}"
        file_failed=true
    fi
done

if [[ ${file_failed} == true ]]; then
    # A file didn't have the @file preamble
    test_end 1
fi

doxygen "${TEST_DIR}/Doxyfile" 2>&1 \
    | grep -v '(variable)' \
    | grep -v '(macro definition)' \
    | grep 'is not documented' \
        && test_end 1

test_end 0
