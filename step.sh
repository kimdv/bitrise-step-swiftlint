#!/bin/bash
set -ex

if [ -z "${linting_path}" ] ; then
  echo " [!] Missing required input: linting_path"

  exit 1
fi

if [ "${strict}" = "no" ] ; then
  STRICT_FLAG=
else
  STRICT_FLAG='--strict'
fi

cd "${linting_path}"

if [ -z "${lint_config_file}" ] ; then
  	swiftlint lint --reporter "${reporter}" ${STRICT_FLAG}
else
	swiftlint lint --config "${lint_config_file}" --reporter "${reporter}" ${STRICT_FLAG}
fi
