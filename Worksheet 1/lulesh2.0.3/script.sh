#!/bin/bash

#Remove output files
rm noflags.txt
rm 7flags.txt

sed -i '29d' Makefile
sed -i '29i CXXFLAGS = -g -O3 -I. -Wall' Makefile

sed -i '30d' Makefile
sed -i '30i LDFLAGS = -g -O3' Makefile

#Without flags
for j in {1..5}
do
	make clean
	make	
	echo ========================================================================================================================================= >> noflags.txt
	echo No Flags >> noflags.txt
	echo ========================================================================================================================================= >> noflags.txt

	./lulesh2.0 >> noflags.txt

	echo ---------------------------- running lulesh2.0 binary without flags $j times------------------------

done

#Array of flags
array='-flto'

#Loop through flags
for i in $array
do 
	FLAGCXX="CXXFLAGS = -g -O3 -I. -Wall -march=native -fomit-frame-pointer -floop-strip-mine -funroll-loops -floop-interchange -floop-block $i"
	FLAGLD="LDFLAGS = -g -O3 -march=native -fomit-frame-pointer -floop-strip-mine -funroll-loops -floop-interchange -floop-block $i"

	# Delete lines and insert flags on the Makefile
	sed -i '29d' Makefile
	sed -i '29i '"$FLAGCXX"'' Makefile

	sed -i '30d' Makefile
	sed -i '30i '"$FLAGLD"'' Makefile

	# Loop to make an average
	for N in {1..5}
	do
		make clean
		make 

		echo ========================================================================================================================================= >> 7flags.txt
		echo Current flag - incl -march=native -fomit-frame-pointer -floop-strip-mine -funroll-loops -floop-interchange -floop-block : $i >> 7flags.txt
		echo ========================================================================================================================================= >> 7flags.txt

		./lulesh2.0 >> 7flags.txt

		echo ---------------------------- running lulesh2.0 binary $N times------------------------

	done

done
