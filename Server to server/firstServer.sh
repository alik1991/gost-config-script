#!/bin/bash
echo "Welcome to the Gost config script by acrux"
echo ""
echo "Step 1 create the key for ssh connection"


read -p "Enter the name of the key: " KEY_NAME
read -p "Enter the path to save the key (default: /root/.ssh): " KEY_PATH

if [ -z "$KEY_PATH" ]; then
  KEY_PATH="/root/.ssh"
fi

# Create the directory if it doesn't exist
sudo mkdir -p "$KEY_PATH"

# Generate the SSH key
sudo ssh-keygen -t ed25519 -N "" -f "${KEY_PATH}/${KEY_NAME}"

echo "SSH key generated at ${KEY_PATH}/${KEY_NAME}!"

echo "Step 2 Sending The Public Key to the other server"
echo ""

# Send Public Key to the Other Server

read -p "Enter the destination port (if the port is the default please enter 22): " DS_PORT
read -p "Enter the Public key address that you want transfer: " PB_KEY_PATH
read -p "Enter the username for destination ip address: " USR
read -p "Enter the destination ip address: " DS_IP
read -p "Enter the destination path that you want to transfer: " DS_PATH


scp -P ${DS_PORT} ${PB_KEY_PATH} ${USR}@${DS_IP}:${DS_PATH}

echo "Public Key Transfered"

echo "Create The supervisor config for your bash script"
# Prompt for config name and program name
read -p "Enter the name of the config file: " CONF_NAME
read -p "Enter the name of the program: " PROG_NAME

# Write supervisor config file
cat> /etc/supervisor/conf.d/${CONF_NAME}.conf <<EOF
[program:${PROG_NAME}]
command=/root/${CONF_NAME}.sh
autostart=true
autorestart=true
stderr_logfile=/var/log/${PROG_NAME}.err.log
stdout_logfile=/var/log/${PROG_NAME}.out.log
EOF

#Write gost config for client side
read -p "Enter the ServerSide Address: " IP_ADDRESS
read -p "Enter the ServerSide port: " SR_PORT
read -p "Enter the Private Key Path: " PR_KEY_PATH
read -p "Enter the your desired port to connect: " CL_PORT
read -p "Please provide your own password(note that the password should be 12 character): " PASSWORD

#Create the gost config
cat> /root/${CONF_NAME}.sh <<EOF
#!/bin/bash
gost -L=ss+ohttp://chacha20-ietf-poly1305:${PASSWORD}@:${CL_PORT} -F="ssh://${IP_ADDRESS}:${SR_PORT}?ssh_key=${PR_KEY_PATH}" 
EOF

#Make the Programm executable
sudo chmod +x /root/${CONF_NAME}.sh

# Restart supervisor to apply changes
sudo supervisorctl reread
sudo supervisorctl update


echo "Gost Configured, Enjoy"
