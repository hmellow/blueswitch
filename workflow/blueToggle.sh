config_file="$HOME/blueswitch-config.txt"

# Read the first line of config as SSH IP
read -r sshIP < "$config_file"

# Read the second line of config as the username
read -r sshUSER < <(sed -n '2p' "$config_file")

# Read the remaining lines as an array of devices
mapfile -t devices < <(tail -n +3 "$config_file")

# Rest of the code remains the same...
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
sleep 1

# Do it on the other device
if [[ "$stat" = '1' ]]; then
    for item in "${devices[@]}"; do
        ssh "$sshUSER@$sshIP" "/usr/local/bin/blueutil --unpair \"$item\""
    done
else
    for item in "${devices[@]}"; do
        ssh "$sshUSER@$sshIP" "/usr/local/bin/blueutil --unpair \"$item\""
        ssh "$sshUSER@$sshIP" "/usr/local/bin/blueutil --pair \"$item\""
        ssh "$sshUSER@$sshIP" "/usr/local/bin/blueutil --connect \"$item\""
    done
fi
