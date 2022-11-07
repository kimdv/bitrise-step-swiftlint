#!/bin/bash

set -o pipefail

if [ -n "${linting_path}" ] ; then
  echo "Changing directory to ${linting_path}"
  cd "${linting_path}"
fi

FLAGS=''

if [ -s "${lint_config_file}" ] ; then
  FLAGS=$FLAGS' --config '"${lint_config_file}"
fi

if [ "${strict}" = "yes" ] ; then
  echo "Running strict mode"
  FLAGS=$FLAGS' --strict'
fi

if [ "${quiet}" = "yes" ] ; then
  echo "Running quiet mode"
  FLAGS=$FLAGS' --quiet'  
fi

filename="swiftlint_report"
case $reporter in
    xcode|emoji)
      filename="${filename}.txt"
      ;;
    markdown)
      filename="${filename}.md"
      ;;
    csv|html)
      filename="${filename}.${reporter}"
      ;;
    checkstyle|junit)
      filename="${filename}.xml"
      ;;
    json|sonarqube)
      filename="${filename}.json"
      ;;
esac

report_path="${BITRISE_DEPLOY_DIR}/${filename}"

case $lint_range in 
  "changed")
  echo "Linting diff only"
    files=$(git diff HEAD^ --name-only --diff-filter=d -- '*.swift')

    echo $files

    for swift_file in $(git diff HEAD^ --name-only --diff-filter=d -- '*.swift')
    do 
      swiftlint_output+=$"$(swiftlint lint --path "$swift_file" --reporter ${reporter} ${FLAGS})"
      lint_code=$?
      if [[ lint_code -ne 0 ]]; then 
        swiftlint_exit_code=${lint_code}
      fi
    done
    ;;
  
  "all") 
    echo "Linting all files"
    swiftlint_output="$(swiftlint lint --reporter ${reporter} ${FLAGS})"
    swiftlint_exit_code=$?
    ;;
esac

# This will set the `swiftlint_output` in `SWIFTLINT_REPORT` env variable. 
# so it can be used to send in Slack etc. 
envman add --key "SWIFTLINT_REPORT" --value "${swiftlint_output}"
echo "Saved swiftlint output in SWIFTLINT_REPORT"

# This will print the `swiftlint_output` into a file and set the envvariable
# so it can be used in other tasks
echo "${swiftlint_output}" > $report_path
envman add --key "SWIFTLINT_REPORT_PATH" --value "${report_path}"
echo "Saved swiftlint output in file at path SWIFTLINT_REPORT_PATH"

exit ${swiftlint_exit_code}
