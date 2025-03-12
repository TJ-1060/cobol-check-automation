#!/bin/bash

export PATH=$PATH:/usr/lpp/java/J8.0_64/bin
export JAVA_HOME=/usr/lpp/java/J8.0_64
export PATH=$PATH:/usr/lpp/zowe/cli/node/bin

java -version

#set zowe username

ZOWE_USERNAME="Z44509"

cd cobol-check
echo "Directory Changed to $(pwd)."
ls -la

#Make cobolcheck +x
chmod +x cobolcheck
echo "Made cobolcheck +x."

cd scripts
chmod +x linux_gnucobol_run_tests
echo "Made linux_gnucobol_run_tests +x."
cd ..

#Function to run cobolcheck and copy files
run_cobolcheck() {
	program=$1
	echo "Running cobolcheck for program $program."

	./cobolcheck -p $program
	echo "Cobolcheck execution completed for $prgram (exceptions might have occured)!"

	#check if CC##99.CBL was created
	if [ -f "CC##99.CBL" ]; then
		#Copy MVS dataset
		if cp "CC##99.CBL" "//'${ZOWE_USERNAME}.CBL($program)'"; then
			echo "Copied CC##99.CBL to ${ZOWE_USERNAME}.CBL($program)."
		else
			echo "Failed to copy CC##99.CBL to ${ZOWE_USERNAME}.CBL($program)."
		fi
	else
		echo "CC##99.CBL not found for $program"
	fi

	#Copy JCL if exists
	if [ -f "${program}.JCL" ]; then
		if cp ${program}.JCL "//'${ZOWE_USERNAME}.JCL{$program}'"; then
			echo "Copied ${program}.JCL to ${ZOWE_USERNAME}.JCL($program)."
		else
			echo "Failed to copy ${program}.JCL to ${ZOWE_USERNAME}.JCL($program)."
		fi
	else
		echo "${program}.JCL not found."
	fi
}

for program in NUMBERS EMPPAY DEPTPAY; do
	run_cobolcheck $program
donw

echo "Mainframe operations completed!"
echo ">>>--------------------------------------------<<<"
