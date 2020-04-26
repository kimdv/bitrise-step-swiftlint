#!/bin/bash

run_swiftlint() {
    local filename="${1}"
    local reporter="${2}"
    local flags="${3}"

    if [[ "${filename##*.}" == "swift" ]]; then
        swiftlint lint --path "${filename}" --reporter "${reporter}" "${flags}"
    fi
}

if [ -z "${linting_path}" ] ; then
  echo " [!] Missing required input: linting_path"

  exit 1
fi

FLAGS=''

if [ "${strict}" = "yes" ] ; then
  FLAGS=$FLAGS' --strict'
fi

if [ -s "${lint_config_file}" ] ; then
  FLAGS=$FLAGS' --config '"${lint_config_file}"  
fi

cd "${linting_path}"

case $lint_range in 
"changed")
  git diff --name-only | while read filename; do run_swiftlint "${filename}" "${reporter}" "${FLAGS}"; done
  git diff --cached --name-only | while read filename; do run_swiftlint "${filename}" "${FLAGS}"; done 
  ;;
"all")
  output="$(swiftlint lint --reporter "${reporter}" ${FLAGS})"
  envman add --key "SWIFTLINT_REPORT" --value "${output}"
  echo "Saved swiftlint output in SWIFTLINT_REPORT"
  filename="swiftlint_report.${reporter}"
  report_path="${BITRISE_DEPLOY_DIR}/${filename}"
  echo "${output}" > $report_path
  envman add --key "SWIFTLINT_REPORT_PATH" --value "${report_path}"
  echo "Saved swiftlint output in file, it's path is saved in SWIFTLINT_REPORT_PATH"
  ;;
esac
