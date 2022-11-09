#!/bin/env bash
fname=$(echo $0|sed -r 's|'$(pwd)'/||g')
fname=$fname'|'$fname

usage() {
echo -e "Usage:"
echo -e "   ${fname} -h --help for that help menu"
echo -e "   ${fname} newman [options][command] for newman command"
echo -e "   ${fname} parallel [options] [command [arguments]] <list_of_arguments for parallel command"
echo -e "   ${fname} -t --tag tagging"
}
##################################################################
options=$(getopt -o ht: --long help  --long tagging: -- "$@" -- '')
##################################################################
while true; do
    case "$1" in
    -h|--help)
        usage;
        break
        ;;
    newman)
        #some NewMan Code
        echo "executing '${@}'"
        eval $@
        break
        ;;
    parallel)
        echo $@
        ./parallel_exec.sh $(echo $@|sed "s|parallel||")
        break
        ;;
    -t|--tagging)
        argss=$(echo $@|sed "s|-t||"|sed "s|--tag||")
        #echo $argss
        ./tagging.sh $argss
        break
        ;;
    *)
        usage;
        shift
        break
        ;;

    esac
    shift
done
