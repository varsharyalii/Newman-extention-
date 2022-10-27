#!/bin/bash
tagging() {
  IFS=',';
  tag=($1);
  unset IFS;
command = newman run <(cat Cosmos.postman_collection.json | jq -c '
  del(..| select(
    (.request)?
    and (
      (.name)? | test("\\[${Tag}\\]") | not
    )
  ))
') --environment cosmos.postman_environment.json
