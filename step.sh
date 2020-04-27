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

  swiftlint lint --reporter "${reporter}" ${FLAGS} > $report_path
  
  echo "Saved swiftlint output in file, it's path is saved in ${report_path}"
  ;;
esac
