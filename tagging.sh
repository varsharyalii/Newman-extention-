#!/bin/bash
#IFS=',';
tag=$1
#unset IFS;
newman run <(cat Cosmos.postman_collection.json | jq -c '
      del(..| select(
     (.request)?
     and (
        (.name)? | test("\\['${tag}'\\]") | not
        )
     ))
 ')  --environment cosmos.postman_environment.json
