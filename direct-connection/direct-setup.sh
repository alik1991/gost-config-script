#!/bin/bash

echo "Create The supervisor config for your bash script"
# Prompt for config name and program name
read -p "Enter the name of the connection: " CONF_NAME

# Write supervisor config file
cat> /etc/supervisor/conf.d/${CONF_NAME}.conf <<EOF
[program:${CONF_NAME}]
command=/root/${CONF_NAME}.sh
autostart=true
autorestart=true
stderr_logfile=/var/log/${CONF_NAME}.err.log
stdout_logfile=/var/log/${CONF_NAME}.out.log
EOF

#Write gost config for client side
read -p "Enter the your desired port to connect: " CL_PORT
read -p "Please provide your own password(note that the password should be 12 character): " PASSWORD

#Create the gost config
cat> /root/${CONF_NAME}.sh <<EOF
#!/bin/bash
gost -L=ss+ohttp://chacha20-ietf-poly1305:${PASSWORD}@:${CL_PORT} 
EOF

#Make the Programm executable
sudo chmod +x /root/${CONF_NAME}.sh

# Restart supervisor to apply changes
sudo supervisorctl reread
sudo supervisorctl update

echo ""

echo "Gost Configured, Enjoy"

# Print port number and password
echo "Port Number: ${CL_PORT}"
echo "Password: ${PASSWORD}"


echo "Gost Configured, Enjoy"