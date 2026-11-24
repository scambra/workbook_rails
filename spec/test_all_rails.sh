#!/usr/bin/env bash

status=0
for version in 7.2 8.0 8.1; do
  if ! "spec/test_${version}.sh"; then
    status=1
  fi
done

exit "$status"
