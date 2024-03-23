#!/bin/bash

# Gather a list of files included in the merge request
slsfiles="$(git diff --name-only origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME | grep -E '\.sls$')"

# Test if any sls files have been modified in the merge request
# If there are, execute the linting type based on the argument that was passed
if grep -E '\.sls$' <<< "$slsfiles" &>/dev/null; then
    if [[ "$1" == 'jinja' ]]; then
        # jinja linting
        git diff --name-only origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME | grep -E '\.sls$' | xargs j2lint --ignore jinja-statements-indentation --extensions sls
    elif [[ "$1" == 'salt' ]]; then
        # salt linting
        git diff --name-only origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME | grep -E '\.sls$' | xargs salt-lint
    elif [[ "$1" == 'yaml' ]]; then
        # strip jinja templating from sls files. yamllint won't work if it is left in place
        while read filename; do
            sed -i -E 's/^\s*\{%.*%}//g' "$filename"
            done <<< $slsfiles
        
        # Evaluate sls files
        yamllint --strict $(while read filename; do printf "$filename "; done <<< "$slsfiles")
    else
       echo "The argument that was passed to the script did not match any linting types"
    fi
else
    echo "No sls files found, skipping $1 linting"
    exit 0
fi
