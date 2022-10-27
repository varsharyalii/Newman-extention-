#!/bin/bash

# USAGE: ./img_checker.sh [OPTIONS...]

NAME="newmanext.sh"
DIR="."

usage() { echo "Usage: $0 [-h <help>] [-t <tagging>] [-p <parallel_execution>] " 1>&2; exit 1;}

while getopts "ht:p:" opt; do
	case "${opt}" in

		h)	# option "help"
			echo "Usage: $NAME [OPTION...]"
			echo ""
			echo "	-t <tag>, specify the tags to be executed"
			echo "	-p <parallel_execution>, the script will run all the folders parallely"
			exit 0
			;;
		t)	# option "tag"
			t="${OPTARG}"
			;;
		p)	# option "parallel_execution"
			p="${OPTARG}"
			;;
		\?)
			echo -e "Invalid option: $OPTARG\n" 1>&2
			usage
			;;
		:)	# invalid option
			echo -e "Invalid option: $OPTARG requires an argument\n" 1>&2
			usage
			;;
	esac
done
shift $((OPTIND-2))

tot_pkmn=0
current_correct=1
tot_wrong=0
i=1
old_name=""
for f in $(find "${DIR}" -name "*.jpg" -or -name "*.jpeg" -or -name "*.png")
do

	current_correct=1
	current_pkmn_name=$(echo "${f}" | cut -d '/' -f 2)
	if [ "${old_name}" != "${current_pkmn_name}" ]
	then
		old_name="${current_pkmn_name}"
		i=1
	fi

	# option -r
	if [ "$p" -eq 1 ]
	then
    parallel_execution() {
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
		filename="${f##*/}"
		extension="${filename##*.}"
		pokemon_name=$(echo "${f}" | cut -d '/' -f 2)

		mv -n "${f}" "${DIR}/${current_pkmn_name}/${current_pkmn_name}$i.${extension}"

		f="${DIR}/${current_pkmn_name}/${current_pkmn_name}$i.${extension}"
	fi

	ident=$(identify "${f}")
	dim=$(echo $ident | cut -d ' ' -f3)
	width=$(echo $dim | cut -d 'x' -f1)
	height=$(echo $dim | cut -d 'x' -f2)

	output="$f"

	# option -s
	if [ "$s" -eq 1 ]
	then
		# square check
		(($width == $height)) || output="$output: $(echo 'not squared,')"
		(($width == $height)) || current_correct=0
	fi

	# option -m
	if [ "$m" -ne -1 ]
	then
		(($width >= $m && $height >= $m)) || output="$output $(echo 'beyond the minimum size,')"
		(($width >= $m && $height >= $m)) || current_correct=0
	fi

	# option -M
	if [ "$M" -ne -1 ]
	then
		(($width <= $M && $height <= $M)) || output="$output $(echo 'beyond the maximum size')"
		(($width <= $M && $height <= $M)) || current_correct=0
	fi

	# option -l
	if [ "$l" ]
	then
		((current_correct == 1)) || echo "$output" >> "$l"
	else
		((current_correct == 1)) || echo "$output"
	fi

	((current_correct == 1)) || tot_wrong=$(expr $tot_wrong + 1)
	tot_pkmn=$(expr $tot_pkmn + 1)
	i=$(expr $i + 1)
	# echo "${f}" # test
done

echo "Tot pokémon: $tot_pkmn"
echo "Tot wrong: $tot_wrong"
