#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root. Exiting."
   exit 1
fi

# Prompt the user for action
echo "What would you like to do with vsftpd?"
echo "1) Disable vsftpd entirely"
echo "2) Secure vsftpd according to best practices and allow it to continue running"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo "Disabling vsftpd..."

        # Stop vsftpd service
        echo "Stopping vsftpd service..."
        systemctl stop vsftpd
        echo "vsftpd service stopped."

        # Disable vsftpd service
        echo "Disabling vsftpd from starting on boot..."
        systemctl disable vsftpd
        echo "vsftpd has been disabled and will not run on startup."
        ;;
    2)
        echo "Securing vsftpd with the latest best practices..."

        # Ensure vsftpd is installed
        if ! command -v vsftpd >/dev/null 2>&1; then
            echo "vsftpd is not installed. Please install it first."
            exit 1
        fi

        # Back up the current vsftpd.conf file if not already backed up
        CONF_FILE="/etc/vsftpd.conf"
        BACKUP_FILE="/etc/vsftpd.conf.bak"
        if [ ! -f "$BACKUP_FILE" ]; then
            echo "Backing up the current vsftpd configuration to $BACKUP_FILE..."
            cp "$CONF_FILE" "$BACKUP_FILE"
            echo "Backup created."
        else
            echo "Backup of vsftpd.conf already exists at $BACKUP_FILE."
        fi

        # Update vsftpd configuration with best practices

        # Function to add or update lines in the config file
        add_or_update_line() {
            local key="$1"
            local value="$2"
            # If the line exists, update it
            if grep -q "^$key" "$CONF_FILE"; then
                sed -i "s|^$key=.*|$key=$value|" "$CONF_FILE"
                echo "Updated: $key=$value"
            else
                # If the line doesn't exist, add it
                echo "$key=$value" >> "$CONF_FILE"
                echo "Added: $key=$value"
            fi
        }

        # Update or add lines with secure values
        add_or_update_line "ssl_enable" "YES"
        add_or_update_line "ssl_tlsv1" "NO"
        add_or_update_line "ssl_tlsv1_1" "NO"
        add_or_update_line "ssl_tlsv1_2" "YES"
        add_or_update_line "ssl_tlsv1_3" "YES"
        add_or_update_line "ssl_sslv2" "NO"
        add_or_update_line "ssl_sslv3" "NO"
        add_or_update_line "force_local_data_ssl" "YES"
        add_or_update_line "force_local_logins_ssl" "YES"
        add_or_update_line "anonymous_enable" "NO"
        add_or_update_line "chroot_local_user" "YES"
        add_or_update_line "allow_writeable_chroot" "NO"
        add_or_update_line "xferlog_enable" "YES"
        add_or_update_line "log_ftp_protocol" "YES"
        add_or_update_line "ssl_ciphers" "HIGH"

        echo "vsftpd configuration updated with the following security measures:"
        echo "- Enabled SSL/TLS encryption."
        echo "- Allowed only TLS 1.2 and TLS 1.3 for secure communication."
        echo "- Forced encryption for both login and data transfer."
        echo "- Disabled anonymous access."
        echo "- Restricted users to their home directories."
        echo "- Enabled logging for monitoring FTP activity."
        echo "- Configured strong cipher suites for TLS."

        # Generate a self-signed TLS certificate if one doesn't exist
        CERT_FILE="/etc/ssl/certs/vsftpd.pem"
        KEY_FILE="/etc/ssl/private/vsftpd.key"
        if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
            echo "No TLS certificate found. Generating a self-signed TLS certificate..."
            mkdir -p /etc/ssl/private
            openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
                -keyout "$KEY_FILE" -out "$CERT_FILE" \
                -subj "/CN=$(hostname)"
            chmod 600 "$KEY_FILE"
            chmod 644 "$CERT_FILE"
            echo "Self-signed TLS certificate generated at $CERT_FILE."
        else
            echo "TLS certificate already exists. Skipping generation."
        fi

        # Restart vsftpd to apply changes
        echo "Restarting vsftpd to apply new configuration..."
        systemctl restart vsftpd
        echo "vsftpd restarted successfully."

        # Enable vsftpd on boot
        echo "Enabling vsftpd to start on boot..."
        systemctl enable vsftpd
        echo "vsftpd enabled to start on boot."

        # Set the correct permissions for xferlog to secure the logs
        echo "Securing vsftpd logs by setting proper permissions on /var/log/xferlog..."
        chmod 640 /var/log/xferlog
        chown root:adm /var/log/xferlog
        echo "Permissions set: only root and adm group can read the xferlog."

        echo "vsftpd has been secured and is running with the latest best practices."
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac
