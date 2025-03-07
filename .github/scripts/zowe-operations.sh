#!/bin/bash
# zowe_operations.sh
# convert username to lowercase
export PATH=$PATH:/usr/lpp/zowe/cli/node/bin
LOWERCASE_USERNAME=$(echo "$ZOWE_USERNAME" | tr '[:upper:]' '[:lower:]')

# check if dir exists
if ! zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck" &>/dev/null; then
	echo "Directory does not exist. Creating it."
	zowe zos-files create uss-directory /z/$LOWERCASE_USERNAME/cobolcheck
else
	echo "Directory already exists."
fi

#Upload Files

zowe zos-files upload dir-to-uss "./cobol-check" "/z/$LOWERCASE_USERNAME/cobolcheck" --recursive --binary-files "cobol-check-0.2.16.jar"

#Verify upload
echo "Verifying upload:"
zowe zos-files list uss-files "/z/$LOWERCASE_USERNAME/cobolcheck"

