#!/bin/bash
echo -e "\n######### Started: `date` #########\n"
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
createNewmanCommands() {
    IFS=',';
    folders=($1);
    unset IFS;
    command='parallel :::';
    #adding folders as options
    # -c collection 
    # -e env
    #
    for (( i = 0; i < ${#folders[@]}; i++ )); do
        folders[$i]="'newman run ${collection} --folder \""${folders[$i]}"\" -e ${environment} '";
        command="${command}${folders[$i]}";
    done
    echo -e "Command generated with folders - ${command}\n";
    eval $command;
}
if [[ -z "$1" ]]; then
    echo -e "No argument supplied, running all tests \n"
    newman run Cosmos.postman_collection.json -e cosmos.postman_environment.json
else
 environment='cosmos.postman_environment.json'
 collection='Cosmos.postman_collection.json'
 optparse $@
 shift $(( OPTIND - 1 ))
 #echo $collection
 #echo $environment
 createNewmanCommands $@
fi
echo -e "\n######### Completed: `date` #########\n"
