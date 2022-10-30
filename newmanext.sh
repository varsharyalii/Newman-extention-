#!/bin/env bash
fname=$(echo $0|sed -r 's|'$(pwd)'/||g')
fname=$fname'|'$fname

usage() {
echo -e "Usage:"
echo -e "   ${fname} -h --help for that help menu"
echo -e "   ${fname} -n --newmax for newmax command"
echo -e "   ${fname} -p --parallel for parallel command"
echo -e "   ${fname} -t --tag tagging"
}
##################################################################
options=$(getopt -o hn:e:p --long help --long newmax: --long parallel: -- "$@")
##################################################################
while true; do
    case "$1" in
    -h|--help)
        usage;
        break
        ;;
    -n|--newman)
        #some NewMan Code
        eval newman run $@
        break
        ;;
    -p|--parallel)
        echo 'parallel'
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

