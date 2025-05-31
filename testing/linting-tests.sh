#!/bin/bash

# Default this variable to 0
test_failed="0"

# Copy the example linting configuration files to the current directory
cp example-configs/states-repo/.*lint .

# Make a copy of the testing files in /tmp
cp -prf testing/files /tmp/

# Tests that are expected to succeed
# YAML tests have to run last as they will comment out jinja templating lines
while IFS='|' read -r type filename; do
    #printf -- "-- $type linting $filename --\n"
    if bash scripts/linting -t "$type" -s single -f "/tmp/files/$filename" ; then
        echo "Test Succeeded"
    else
        echo "Test Failed"
        test_failed="1"
    fi
    printf -- "\n"
done <<EOF
jinja|good.sls
salt|good.sls
yaml|good.sls
EOF

# Tests that are expected to generate errors
# YAML tests have to run last as they will comment out jinja templating lines
while IFS='|' read -r type filename expected_error; do
    printf -- "-- $type linting $filename, looking for \"$expected_error\" --\n"
    if bash scripts/linting -t "$type" -s single -f "/tmp/files/$filename" | grep "$expected_error" >/dev/null; then
        echo "Test Succeeded"
    else
        echo "Test Failed"
        test_failed="1"
    fi

    printf -- "\n"
done <<EOF
jinja|jinja-bad.sls|jinja-statements-single-space
jinja|jinja-bad.sls|Unexpected end of template
salt|salt-bad.sls|210
salt|salt-bad.sls|213
yaml|yaml-bad.sls|mapping values are not allowed here (syntax)
yaml|yaml-bad1.sls|wrong indentation
EOF

# Output final result
if [[ "$test_failed" == 0 ]]; then
    printf "** All tests succeeded **\n"
else
    printf "** One or more tests failed **\n"
fi

# Cleanup
rm .*lint
rm -rf /tmp/files

# Exit with the appropriate errorlevel
exit "$test_failed"
