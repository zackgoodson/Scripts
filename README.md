# Scripts

___
### **Script 1 : Disabling Anonymous Login on FTP** 

Script 1 is a Bash script designed to quickly turn off the anonymous login setting of a device running FTP. This can be used in security incidents, simulated or real, to rapidly fill a security hole if needed.

  **What it is:** <br> 
      It's a simple .sh script, a file given execute privilege, that will go to the file, 'vsftpd.conf' in the etc directory and then scans the file for the line that begins with       
      "anonymous_enable". It then replaces that line with "anonymous_enable=NO". 

  **What it's good for:** <br> 
      This script can be staged to shut down FTP services if a breach is detected. Changing rapidly between configurations allows for quick patching and hardening a machine if deemed necessary. One example of this I experienced at a Network Defense/Blue Team competition. The Red Team kept getting in with the default anonymous login ability in FTP. Had I been able to disable this feature quickly, I may have been caused less trouble. 
      If you have FTP services running and have not disabled anonymous logon, or chosen deliberately to configure it so, you might want to use this script. If your system is scanned, it's likely this will show up as a vulnerablility that can be exploited and it can give free-reign to any Red Team or bad actor. Currently the script changes one line but it can be easily edited to adjust as many lines as necessary in the vsftpd.conf file, and could thereby automatically configure the FTP settings according to your needs.
      
  **What it uses:** <br> 
      The key to finding the line with that particular setting and then replacing it is the 'Sed" text tool that comes installed in many Linux-based systems. If you are attempting to use it but do not have sed installed, you can install it with the following:
          For Ubuntu/Debian/APT-based systems: 
              sudo apt update
              sudo apt install sed
          For CentOS/RedHat/YUM or DNF-based systems use:
              sudo yum install sed
              
  **Other requirements:** <br> 
     - This script is for vsftpd FTP systems, and will not work with ProFTPD or pure-FTPd. These systems have other ways of disabling anonymous login if they have been activated. <br>
     - Make sure when installing the script the file is given execute permission or it will not run as a script. This can be done with the chmod command as follows: <br>
        chmod +x disable_ftp_anon.sh <br>
     - To run the script, type: <br>
        sudo ./disable_ftp_anon.sh
            

  **What it looks like in action:**<br><br>
      Here we see it enabled in the vsftopd.conf file
      ![vsftpd.conf file with anonymous login enabled](/vsftpd.conf--before_script.png?)

  Then we see the script successfully has made the change and outputs the corresponding console text:
      ![successfully run script with noted change to vsftpd.conf file](/successful_script_run.png)

  Then we go back into the file, and see that the change has indeed taken effect as designed:
      ![vsftpd.conf file with anonymous login disabled](vsftpd.conf--after_script.png?)
___

### **Script 2 : Disabling Anonymous Access on SMB Protocol**

Script 2 is a .ps1 (Powershell) script designed to quickly block the anonymous access to information including usernames, lists of shared resources, and device and network attributes. This can be used in security incidents, simulated or real, to rapidly plug this information leak prevalent on machines running Windows 2008 or earlier Windows versions.

  **What it is:**
      It's a Powershell script that will go into the proper registry file and change the access level parameter for SMB to 2, which blocks all anonymous access via the 
      Server Message Block (SMB) protocol.
  
 **What it's good for:**
      This script can be staged to immediately shut down information leaks via SMB, blocking requests for information that can be used for privilege escalation, lateral movement on the network, and reconnaissance. This SMB-accessible informtion can be used in social engineering efforts to add legitimacy to requests, to enumerate systems and specifically design targeted attacks against specific OS versions, to brute-force credentials with specific usernames, and to gather vital information without running network enumeration scans. <br>
      Without having to dive into the registry files and find where in the hundreds of registry settings this hole is, simply run the script and another security hole is filled.

  **What it uses:** <br>
      Just Powershell. It searches and validates that the registry file path exists, that the setting is there, and then changes it to 2, disabling access to information to anonymous users. Then it reads out the current setting of the Restrict Access value. The script is composed of Windows Registry file navigation and Powershell commands--that being said, it will not work on anything but Windows. 

**Other Requirements** <br>
      -Make sure when running the script your current user has the correct permissions to execute scripts. <br>
      -A reminder that this script is for **Windows versions 2008 and earlier** <br>
      -Sometimes the SMB service or computer must be restarted for the effect to take full effect.

  **What it looks like in action:** <br>
      Here we see it enabled in the registry file:
      ![registry file with anonymous access set to 0, which is open to all](/anon_smb_access_open.png)

  Then we see the script successfully has made the registry value change and outputs the corresponding console text:
      ![successfully run script with current setting in registry file](/smb_anon_disable_output.png)

  Then we go back into the registry file, and see that the change has indeed taken effect as designed:
      ![registry file with anonymous access set to 2, which is closed to all anonymous users](/anon_smb_access_closed.png)

___
### **Script 3 : Securing or Disabling vsftpd (secure_vsftpd.sh)** 

Script 3 is a Bash script designed to quickly configure either the immediate diabling or immediate securing of vsftpd according to best practices. This can be used in security incidents, simulated or real, to rapidly fill potential security holes and maintain a secure vsftpd server or disable it entirely.

  **What it is:** <br> 
      This script is more complex and robust version of Script 1. It not only disables anonymous login, but sets a dozen more parameters in the vsftpd.conf file to secure holes that come with running an improperly configured vsftpd server. It also does a few other things in addition that are definitely more robust than Script 1; let's break its functionalities down step by step. <br>
            First, it checks to make sure the script is run as root, this is because if not, often changes to the vsftpd.conf file will not work. <br>
            Second, It prompts the user if they wish to disable the vsftpd service entirely or run it securely. The user enters 1 or 2 respectively. Upon entering 1, the command is run to stop the service and then the command to disable the process to run it and the program is complete. Entering option 2 brings a lot more functionality. <br>
      Third, (the following steps are only when option 2 is selected) the scripts creates a backup vsftpd.conf file (if it is not already backed up) in case something goes wrong and the user wishes to undo the changes, preventing the loss of the original configuration. The backup is saved at this location: /etc/vsftpd.conf.bak <br>
      Fourth, it goes into the vsftpd.conf file and uses a function (add_or_update_line) to change the values for several important configuration values if they are already included in the file, or if not, they are added in. There are 15 changes; these with their impact/purpose are listed below:

1. ssl_enable=YES
-Enables SSL/TLS encryption for all FTP connections. Without this, all traffic (including credentials) is sent in plaintext.

2. ssl_sslv3=NO
3. ssl_sslv2=NO
These two disable use of SSLv2 and SSLv3, which are super outdated and exceedingly insecure. (For those of you wondering, there is no SSLv1 to worry about.)

4. ssl_tlsv1=NO
5. ssl_tlsv1_1=NO
These two disable using insecure protocols of TLS, (TLS 1.0 and 1.1) which, like SSL, are outdated and vulnerable to known attacks (e.g., [POODLE](https://en.wikipedia.org/wiki/POODLE)).

6. ssl_tlsv1_2=YES
7. ssl_tlsv1_3=YES
These two enable using TLS 1.2 and 1.3, which are the more recent and secure versions, and are widely used and supported. (TLS 1.3 is the most secure and efficient version of the TLS protocol. It's more resistant to attacks and reduces handshake overhead)

8. force_local_data_ssl=YES
-Forces SSL/TLS encryption for all data transfers, ensuring no sensitive data is sent in plaintext.

9. force_local_logins_ssl=YES
-Requires SSL/TLS encryption for user login credentials, protecting usernames and passwords from interception.

10. anonymous_enable=NO
-Disables anonymous FTP access, requiring users to authenticate with valid credentials. This prevents unauthorized access to the server.

11. chroot_local_user=YES
-Restricts authenticated local users to their home directories. This prevents them from accessing files and directories outside their own directory.

12. allow_writeable_chroot=NO
-Disables writeable permissions for the root directory in a chroot jail, improving security by preventing users from modifying the directory structure.

13. xferlog_enable=YES
-Enables logging of all file transfers. The logs are stored in /var/log/xferlog and can be used for monitoring or troubleshooting.

14. log_ftp_protocol=YES
-Logs all FTP commands and responses for deeper insight into FTP activity, useful for debugging or auditing.

15. ssl_ciphers=HIGH
-Restricts the SSL/TLS cipher suites to strong, high-security algorithms, ensuring secure encryption and preventing the use of weak ciphers.
 
    Fifth, the script generates a TLS certificate if there isn't one. **NOTE: This is not ideal, especially in production or lager scale environments.** Avoid using this method outside of internal and small-scale use cases as it can introduce usability and potential security issues, especially in a production environment. Get a legitimate certificate from a Certificate Authority (there are lots of resources on this topic online). The self-signed key (if generated) is stored at this location: /etc/ssl/certs/vsftpd.pem and /etc/ssl/private/vsftpd.key

    Sixth, the script restarts the service, ensuring the changes are implemented, and enables vsftpd to start on boot.


  **What it's good for:** <br> 
      This script can be staged to shut down FTP services if a breach is detected. Changing rapidly between configurations allows for quick patching and hardening a machine if deemed necessary. One example of this I experienced at a Network Defense/Blue Team competition. The Red Team kept getting in with the default anonymous login ability in FTP. Had I been able to quickly configure this service, I would have prevented several attacks and issues that lasted the duration of the competition.
      If you have FTP services running and have not disabled anonymous logon, or chosen deliberately to configure it so, you might want to use this script. If your system is scanned, it's likely this will show up as a vulnerablility that can be exploited and it can give free-reign to any Red Team or bad actor. The script can be modified as needed to fit the needs of your project, device, and/or organization. 
      One key to this is that it gives you both the option to just get rid of the service entirely, and also provides a super easy way to allow the service to run in a secure manner. That's the real key here, being able to securely provide functionality according to best practices.
      
  **What it uses:** <br> 
      The key to finding the line with that particular setting and then replacing it is the 'Sed" text tool that comes installed in many Linux-based systems. If you are attempting to use it but do not have sed installed, you can install it with the following:
          For Ubuntu/Debian/APT-based systems: 
              sudo apt update
              sudo apt install sed
          For CentOS/RedHat/YUM or DNF-based systems use:
              sudo yum install sed
              
  **Other requirements:** <br> 
     - This script is for vsftpd FTP systems, and will not work with ProFTPD or pure-FTPd. These systems have other ways of disabling anonymous login if they have been activated. <br>
     - Make sure when installing the script the file is given execute permission or it will not run as a script. This can be done with the chmod command as follows: <br>
        chmod +x secure_vsftpd.sh <br>
     - To run the script, type: <br>
        sudo ./secure_vsftpd.sh
            

  **What it looks like in action:**<br><br>
      Here we see a full run output when Option 1 is selected (Just disabling it entirely):
      ![Option 1 Disable](sv_disable_run.png?) <br>
Here we see certain pre-existing paramters in the vsftpd file before we run the script:
      ![vsftpd.conf file before running the script](vs_file_pre-run.png?) <br>
Here we have the full run of the script when option 2 is selected, and a certificate is created:
      ![Full output of the script with certificate signing](sv_first_run.png?) <br>
Here we have the vsftpd.conf file parameters with the changes made and added parameters at the end of the file:
      ![vsftpd.conf file after running the script](vs_file_post-run.png?) <br>
      
      
          
        












      

  

  
