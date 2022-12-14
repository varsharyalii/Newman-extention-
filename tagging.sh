#!/bin/bash
optparse(){
while getopts "e:c:" opt; do
  case "$opt" in
    e)
    environment=$OPTARG
    ;;
    c)
    collection=$OPTARG
    ;;
  esac
done
shift $(( OPTIND - 1 ))
tag=$1
#echo 'tag is '$tag
}

tagging(){
#-c collection
#-e env
newman run <(cat $collection | jq -c '
      del(..| select(
     (.request)?
     and (
        (.name)? | test("\\['${tag}'\\]") | not
        )
     ))
 ')  --environment $environment --reporters cli,junit,htmlextra --reporter-junit-export "newman_result.xml" --reporter-htmlextra-export "newman_result.html" 
}
if [[ -z $1 ]]; then
 echo -e 'No enough args :('
 exit 1
else
 #environment='cosmos.postman_environment.json'
 #collection='Cosmos.postman_collection.json'
 optparse $@
 echo 'env is :' $environment 'col is:' $collection 'tag is ' $tag
 tagging
fi
