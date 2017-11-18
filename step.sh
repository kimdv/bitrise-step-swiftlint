#!/bin/bash
set -ex

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

swiftlint lint --reporter "${reporter}" ${FLAGS}
