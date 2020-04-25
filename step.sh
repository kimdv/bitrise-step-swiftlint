#!/bin/bash
set -ex

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
  swiftlint lint --reporter "${reporter}" ${FLAGS}
  ;;
esac
