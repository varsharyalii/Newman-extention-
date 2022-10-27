#!/bin/bash
echo -e "\n######### Started: `date` #########\n"
createNewmanCommands() {
    IFS=',';
    folders=($1);
    unset IFS;
    command='parallel :::';
    for (( i = 0; i < ${#folders[@]}; i++ )); do
        folders[$i]=" 'newman run PostmanAutomation.json --folder \""${folders[$i]}"\" -e envvariables.json '";
        command="${command}${folders[$i]}";
    done
    echo -e "Command generated with folders - ${command}\n";
    eval $command;
}
if [[ -z "$1" ]]; then
    echo -e "No argument supplied, running all tests \n"
    newman run PostmanRP.json -e envvariables.json
else
    createNewmanCommands "$1";
fi
echo -e "\n######### Completed: `date` #########\n"
