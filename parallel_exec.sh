#!/bin/bash
echo -e "\n######### Started: `date` #########\n"
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
        folders[$i]="'newman run Cosmos.postman_collection.json --folder \""${folders[$i]}"\" -e cosmos.postman_environment.json '";
        command="${command}${folders[$i]}";
    done
    echo -e "Command generated with folders - ${command}\n";
    eval $command;
}
if [[ -z "$1" ]]; then
    echo -e "No argument supplied, running all tests \n"
    newman run Cosmos.postman_collection.json -e cosmos.postman_environment.json
else
    createNewmanCommands "$1";
fi
echo -e "\n######### Completed: `date` #########\n"
