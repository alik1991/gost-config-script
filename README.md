# Gost-Config-Script

Certainly, I can provide a brief documentation for the code you provided:

## Description

This script is designed to create a supervisor config file and a Gost config file for a bash script. Supervisor is a process control system that allows you to monitor and control a number of processes on UNIX-like operating systems. Gost is a simple command-line tunneling service that can be used to forward traffic over a secure SSH connection.

## How to use

1. Make sure you have supervisor and gost installed on your system.
2. Copy the code into a text editor and save it with a .sh extension.
3. Open a terminal and navigate to the directory where the script is saved.
4. Run the script using the following command:

   ```bash
   bash scriptname.sh
   ```

5. Follow the prompts to enter the necessary information, such as the name of the config file, the name of the program, the server-side port, and the public key path.
6. The script will create the supervisor config file and the Gost config file, make the bash script executable, and restart supervisor to apply the changes.

## What the script does

1. Prompts the user to enter the name of the supervisor config file and the program name.
2. Creates a supervisor config file in the /etc/supervisor/conf.d/ directory with the specified name and program name.
3. Prompts the user to enter the server-side port and the public key path.
4. Creates a Gost config file in the /root/ directory with the specified name and program name.
5. Makes the Gost config file executable.
6. Restarts supervisor to apply the changes.

## Note

This script requires root privileges to create and modify files in the /etc/supervisor/conf.d/ and /root/ directories. Make sure you run the script as a user with sufficient privileges. Additionally, be sure to configure Gost and supervisor to meet your specific needs.
