#!/bin/bash
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
 ')  --environment $environment
}
if [[ -z $1 ]]; then
 echo -e 'No enough args :('
 exit 1
else
 environment='cosmos.postman_environment.json'
 collection='Cosmos.postman_collection.json'
 optparse $@
 shift $(( OPTIND - 1 ))
 echo $@
 tagging $@
fi
