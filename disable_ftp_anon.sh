#Sets the file path to the default file location
FILE_PATH = "/etc/vsftpd.conf"

# Check if the file path exists
if [ -f "$FILE_PATH" ]; then
	# Search for the anonymous login line (the line that starts with "anonymous_enable") and replace it, switching it to "NO"
	sed -i '/anonymous_enable/s/.*/anonymous_enable=NO/' "$FILE_PATH"
 
	#Print success message
	echo "The anonymous_enable setting has been changed to "NO" in $FILE_PATH."
 
else
	# Print an error message if the file doesn't exist
	echo "File $FILE_PATH does not exist."
 
	exit 1
fi
