#!/bin/bash

make --quiet
rm -rf screenshots
mkdir -p screenshots
paths=$(find maps/mandatory/valid -name "*.cub")

SCREENSHOT_NAME='screenshot.bmp'

for path in $paths ; do
	error=$(./cub3D $path --save 2>&1)
	if [ ! $? -eq 0 ]; then
		echo $error > log
		printf "\e[31mERROR ON $path\n$(cat $path)\n" >> log
		printf "\n$error\n" >> log
		cat log
		printf "\e[32mDebug with lldb?"
		read -p " [y/n] " -n 1 -r
		printf "\e[0m\n"
		if [[ $REPLY =~ ^[Yy]$ ]]
		then
			lldb -o run ./cub3D -- $path --save
		fi
		exit
	fi
	cp screenshot.bmp screenshots/$(basename $path | sed 's/.cub/.bmp/g')
done

paths=$(find maps/mandatory/invalid -name "*.cub")

for path in $paths ; do
	error=$(./cub3D $path --save 2>&1)
	sig=$?
	if [ $sig -eq 0 ] || [ $sig -eq 11 ] || [ $sig -eq 6 ] ; 
	then
		echo $error > log
		printf "\e[31mERROR ON $path\n$(cat $path)\n" >> log
		printf "\n$error\n" >> log
		cat log
		printf "\e[32mDebug with lldb?"
		read -p " [y/n] " -n 1 -r
		printf "\e[0m\n"
		if 	[[ $REPLY =~ ^[Yy]$ ]]
		then
			lldb -o run ./cub3D -- $path --save
		fi
		exit
	fi
done

printf "\e[32mSUCCESS\n"
