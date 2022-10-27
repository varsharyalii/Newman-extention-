#!/bin/bash
tagging() {
  IFS=',';
  tag=($1);
  unset IFS;
command = newman run <(cat PostmanRP.json | jq -c '
  del(..| select(
    (.request)?
    and (
      (.name)? | test("\\[${tag}\\]") | not
    )
  ))
') \
  --environment envvariables.json
