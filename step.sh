#!/bin/bash
set -ex

if [ -z "${linting_path}" ] ; then
  echo " [!] Missing required input: linting_path"
  exit 1
fi

if [ -z "${lint_config_file}" ] ; then
  echo " [!] Missing required input: lint_config_file"
  exit 1
fi

cd "${linting_path}"

swiftlint lint --path "${lint_config_file}"