#!/bin/bash

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
read -p "Enter the ServerSide port: " SR_PORT
read -p "Enter the Public Key Path: " PB_KEY_PATH

#Create the gost config
cat> /root/${CONF_NAME}.sh <<EOF
#!/bin/bash
gost -L="ssh://:${SR_PORT}?ssh_authorized_keys=${PB_KEY_PATH}"
EOF

#Make the Programm executable
sudo chmod +x /root/${CONF_NAME}.sh

# Restart supervisor to apply changes
sudo supervisorctl reread
sudo supervisorctl update


echo "Gost Configured, Enjoy"