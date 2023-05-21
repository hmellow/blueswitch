config_file="$HOME/blueswitch-config.txt"

# First line of config is ssh IP
read -r sshIP < "$config_file"
# Remaining lines are intended devices
mapfile -t devices < <(tail -n +2 "$config_file")

stat=$(/usr/local/bin/blueutil --is-connected "${devices[0]}")
if [[ "$stat" = '1' ]]; then
	for item in "${devices[@]}"; do
		/usr/local/bin/blueutil --unpair "$item"
	done
else
	for item in "${devices[@]}"; do
		/usr/local/bin/blueutil --unpair "$item"
		/usr/local/bin/blueutil --pair "$item"
		/usr/local/bin/blueitil --connect "$item"
	done
fi
