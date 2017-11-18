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
  CONFIG_FLAG =
else
  CONFIG_FLAG =	--'config' "${lint_config_file}"
fi

swiftlint lint ${CONFIG_FLAG} --reporter "${reporter}" ${STRICT_FLAG}
