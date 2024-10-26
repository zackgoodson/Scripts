# Scripts

___
### **Script 1 : Disabling Anonymous Login on FTP** 

Script 1 is a Bash script designed to quickly turn off the anonymous login setting of a device running FTP. This can be used in security incidents, simulated or real, to rapidly fill a security hole if needed.

  **What it is:**
      It's a simple .sh script, a file given execute privilege, that will go to the file, 'vsftpd.conf' in the etc directory and then scans the file for the line that begins with       
      "anonymous_enable". It then replaces that line with "anonymous_enable=NO". 

  **What it's good for:** <br>
      This script can be staged to shut down FTP services if a breach is detected. Changing rapidly between configurations allows for quick patching and hardening a machine if deemed necessary. One example of this I experienced at a Network Defense/Blue Team competition. The Red Team kept getting in with the default anonymous login ability in FTP. Had I been able to disable this feature quickly, I may have been caused less trouble. 
      If you have FTP services running and have not disabled anonymous logon, or chosen deliberately to configure it so, you might want to use this script. If your system is scanned, it's likely this will show up as a vulnerablility that can be exploited and it can give free-reign to any Red Team or bad actor. Currently the script changes one line but it can be easily edited to adjust as many lines as necessary in the vsftpd.conf file, and could thereby automatically configure the FTP settings according to your needs.
      
  **What it uses:** <br>
      The key to finding the line with that particular setting and then replacing it is the 'Sed" text tool that comes installed in many Linux-based systems. If you are attempting to use it but do not have sed installed, you can install it with the following: <br>
          > For Ubuntu/Debian/APT-based systems: 
              > sudo apt update
              > sudo apt install sed
          > For CentOS/RedHat/YUM or DNF-based systems use:
              > sudo yum install sed
              
  **Other requirements:** <br>
     - This script is for vsftpd FTP systems, and will not work with ProFTPD or pure-FTPd. These systems have other ways of disabling anonymous login if they have been activated. <br>
     - Make sure when installing the script the file is given execute permission or it will not run as a script. This can be done with the chmod command as follows: <br>  
        > chmod +x disable_ftp_anon.sh <br>
     - To run the script, type: <br>
        > sudo ./disable_ftp_anon.sh
            

  **What it looks like in action:**
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
      This script can be staged to immediately shut down information leaks via SMB, blocking requests for information that can be used for privilege escalation, lateral movement on the network, and reconnaissance. This SMB-accessible informtion can be used in social engineering efforts to add legitimacy to requests, to enumerate systems and specifically design targeted attacks against specific OS versions, to brute-force credentials with specific usernames, and to gather vital information without running network enumeration scans. 
      Without having to dive into the registry files and find where in the hundreds of registry settings this hole is, simply run the script and another security hole is filled.

  **What it uses:**
      Just Powershell. It searches and validates that the registry file path exists, that the setting is there, and then changes it to 2, disabling access to information to anonymous users. Then it reads out the current setting of the Restrict Access value. The script is composed of Windows Registry file navigation and Powershell commands--that being said, it will not work on anything but Windows. 

**Other Requirements** <br>
      -Make sure when running the script your current user has the correct permissions to execute scripts. <br>
      -A reminder that this script is for **Windows versions 2008 and earlier** <br>
      -Sometimes the SMB service or computer must be restarted for the effect to take full effect.

  **What it looks like in action:**
      Here we see it enabled in the registry file:
      ![registry file with anonymous access set to 0, which is open to all](/anon_smb_access_open.png)

  Then we see the script successfully has made the registry value change and outputs the corresponding console text:
      ![successfully run script with current setting in registry file](/smb_anon_disable_output.png)

  Then we go back into the registry file, and see that the change has indeed taken effect as designed:
      ![registry file with anonymous access set to 2, which is closed to all anonymous users](/anon_smb_access_closed.png)
      
          
        












      

  

  
