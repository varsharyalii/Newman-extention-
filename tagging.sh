#!/bin/bash
tagging() {
  IFS=',';
  tag=($1);
  unset IFS;
 cosmos=$(cat Cosmos.postman_collection.json |jq -c '  del(..| select(    (.request)?    and (      (.name)? | test("[${tag}]") | not    )))')
 newman run <(echo $cosmos)  --environment cosmos.postman_environment.json
}
tagging
