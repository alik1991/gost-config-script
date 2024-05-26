#!/bin/bash

echo "Welcome to the Gost config script by acrux"
echo ""

# Ask user if they want to create a directory to store the script
read -p "Do you want to create a directory to store your script? (yes/no): " CREATE_DIR

if [[ $CREATE_DIR == "yes" ]]; then
    read -p "Enter the path where you want to create the directory (default: /root/connections): " DIR_PATH
    if [ -z "$DIR_PATH" ]; then
        DIR_PATH="/root/connections"
    fi
    sudo mkdir -p "$DIR_PATH"
    SCRIPT_PATH="$DIR_PATH"
else
    SCRIPT_PATH="/root"
fi

echo ""

# Generate SSH key
echo "Step 1: Create the key for SSH connection"
read -p "Enter the name of the key: " KEY_NAME
read -p "Enter the path to save the key (default: /root/.ssh): " KEY_PATH

if [ -z "$KEY_PATH" ]; then
  KEY_PATH="/root/.ssh"
fi

sudo mkdir -p "$KEY_PATH"
sudo ssh-keygen -t ed25519 -N "" -f "${KEY_PATH}/${KEY_NAME}"

echo "SSH key generated at ${KEY_PATH}/${KEY_NAME}!"

# Get the public key path
PB_KEY_PATH="${KEY_PATH}/${KEY_NAME}.pub"

echo ""

# Send Public Key to the Other Server
echo "Step 2: Sending The Public Key to the other server"

read -p "Enter the destination port (default: 22): " DS_PORT
read -p "Enter the USERNAME for destination ip address: " USR
read -p "Enter the destination IP address: " DS_IP
read -p "Enter the destination key path that you want to transfer: " DS_PATH

scp -P ${DS_PORT} ${PB_KEY_PATH} ${USR}@${DS_IP}:${DS_PATH}

echo "Public Key Transferred"

echo ""

# Create Gost config
echo "Step 3: Create the Gost config"
read -p "Enter the name of the connection: " CONF_NAME
read -p "Enter the ServerSide Address: " IP_ADDRESS
read -p "Enter the ServerSide port: " SR_PORT
read -p "Enter the desired port that you want to connect: " CL_PORT
read -p "Please provide your own password (note that the password should be 12 characters): " PASSWORD

# Get the private key path
PR_KEY_PATH="${KEY_PATH}/${KEY_NAME}"

cat> ${SCRIPT_PATH}/${CONF_NAME}.sh <<EOF
#!/bin/bash
gost -L=ss+ohttp://chacha20-ietf-poly1305:${PASSWORD}@:${CL_PORT} -F="ssh://${IP_ADDRESS}:${SR_PORT}?ssh_key=${PR_KEY_PATH}" 
EOF

sudo chmod +x ${SCRIPT_PATH}/${CONF_NAME}.sh

echo "Gost config created at ${SCRIPT_PATH}/${CONF_NAME}.sh"

echo ""

# Write supervisor config file
echo "Step 4: Create the Supervisor config for your bash script"
cat> /etc/supervisor/conf.d/${CONF_NAME}.conf <<EOF
[program:${CONF_NAME}]
command=${SCRIPT_PATH}/${CONF_NAME}.sh
autostart=true
autorestart=true
stderr_logfile=/var/log/${CONF_NAME}.err.log
stdout_logfile=/var/log/${CONF_NAME}.out.log
EOF

# Restart supervisor to apply changes
sudo supervisorctl reread
sudo supervisorctl update

echo ""

echo "Gost Configured, Enjoy"
