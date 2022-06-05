#!/bin/bash
# find all demos with markers in the auto/ folder
# and move them to markers/ folder

if [ ! -d auto ]
then
	echo "Error: auto/ dir not found"
	exit 1
fi

mkdir -p markers
mkdir -p 2markers

total="$(find auto -name "*.demo" | wc -l)"
current=0

while read -r demo
do
	markers="$(tw_demo "$demo" --markers)"
	if [ "$markers" -gt "0" ]
	then
		tw_demo "$demo" || exit 1
		if [ "$markers" -gt "1" ]
		then
			mv "$demo" 2markers/ || exit 1
		else
			mv "$demo" markers/ || exit 1
		fi
	fi
	current="$((current + 1))"
	if [[ "$((current % 100))" == "0" ]]
	then
		printf '[%4d/%4d] %s\n' $current "$total" "$demo"
	fi
done < <(find auto -name "*.demo")

