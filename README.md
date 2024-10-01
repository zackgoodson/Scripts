# Scripts


Script 1 is a Bash script designed to quickly turn off the anonymous login setting of a device running FTP. This can be used in security incidents, simulated or real, to rapidly fill a security hole if needed.

  What it is:
      It's a simple .sh script, a file given execute privilege, that will go to the file, 'vsftpd.conf' in the etc directory and then scans the file for the line that begins with       
      "anonymous_enable". It then replaces that line with "anonymous_enable=NO". 

  What it's good for:
      This script can be staged to shut down FTP services if a breach is detected. Changing rapidly between configurations allows for quick patching and hardening a machine if deemed necessary. One example of this I experienced at a Network Defense/Blue Team competition. The Red Team kept getting in with the default anonymous login ability in FTP. Had I been able to disable this feature quickly, I may have been caused less trouble. If you have FTP services running and have not disabled anonymous logon, or chosen deliberately to configure it so, you might want to use this script. If your system is scanned, it's likely this will show up as a vulnerablility that can be exploited and it can give free-reign to any Red Team or bad actor.
      
  What it uses:
      The key to finding the line with that particular setting and then replacing it is the 'Sed" text tool that comes installed in many Linux-based systems. If you are attempting to use it but do not have sed installed, you can install it with the following:
          For Ubuntu/Debian/APT-based systems: 
              sudo apt update
              sudo apt install sed
          For CentOS/RedHat/YUM or DNF-based systems use:
              sudo yum install sed
              
  Other requirements:
     - This script is for vsftpd FTP systems, and will not work with ProFTPD or pure-FTPd. These systems have other ways of disabling anonymous login if they have been activated.
     - Make sure when installing the script the file is given execute permission or it will not run as a script. This can be done with the chmod command as follows:
           chmod +x disable_ftp_anon.sh
         
     - To run the script, type: 
        sudo ./disable_ftp_anon.sh
            

  What it looks like in action:
      Here we see it enabled in the vsftopd.conf file
      ![vsftpd.conf file with anonymous login enabled](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)

      Then we see the script successfully has made the change and outputs the corresponding console text:
      ![successfully run script with noted change to vsftpd.conf file](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)

      Then we go back into the file, and see that the change has indeed taken effect as designed:
      ![vsftpd.conf file with anonymous login disabled](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)


  

      
          
        












      

  

  
