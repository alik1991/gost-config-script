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


echo "Gost Configured, Enjoy"