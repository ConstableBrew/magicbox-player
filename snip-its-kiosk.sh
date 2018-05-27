#!/bin/bash

# Snip-its Kiosk Generator
# Forked from KIOSK generator for Scientific Linux and CentOS

############### Configuration

mainsite=http://snipits-overhead-video.herokuapp.com/
#Site that will be loaded as default after KIOSK start.

log=/var/log/make-kiosk.log
# The directiry and file name where log output will be saved.
# You may specify any location because script run from root account.

user=$( whoami )
# User name that run the script. No reasons to change it.

############### End of configuration options

echo -e "Welcome in \e[93mSnip-its Kiosk generator \e[39mfor CentOS."
echo -e "Supporting CentOS 7."
echo ""
echo "This script will install additional software and will make changes"
echo "in system config files to make it work in KIOSK mode after reboot"
echo "with Chrome started as web browser."
echo ""
echo "The log file will be created in /var/log/make-kiosk.log"
echo "Please attach this file for error reports."
echo ""
if [ $user != root ]
then
    echo "You must be root. Mission aborted!"
    echo "You are trying to start this script as: $user"
    echo "User $user didn't have root rights!" >> make-kiosk.log
    exit 0
fi
echo "------------------- ---------- -------- ----- -" >> $log
date >> $log
echo "Generating detected CPU & Kernel log."
cat /etc/*-release >> $log
uname -a >> $log
lscpu 1>> $log 2>> $log
echo "This process will take some time, please be patient..."

echo "Operation done in 5%"
echo "Adding user kiosk."
echo "Adding user kiosk." >> $log
useradd kiosk 1>> $log 2>> $log
echo "Installing wget."
echo "Installing wget." >> $log
yum -y install wget 1>> $log 2>> $log

echo "Operation done in 10%"
echo "Installing X Window system with GDM/Gnome/Matchbox. It will take very long!!! Be patient!!! Downloading up to ~300MB"
echo "Installing X Window system with GDM/Gnome/Matchbox." >> $log
yum -y groupinstall basic-desktop x11 fonts base-x 1>> $log 2>> $log
yum -y install gdm 1>> $log 2>> $log
yum -y install matchbox-window-manager 1>> $log 2>> $log
yum -y install rsync 1>> $log 2>> $log

echo "Operation done in 60%"
echo "Adding Xinit Session support." >> $log
echo "Adding Xinit Session support."
yum -y install gnome-session-xsession 1>> $log 2>> $log
yum -y install xorg-x11-xinit-session 1>> $log 2>> $log

echo "Creating google-chrome yum repo file" >> $log
echo "Creating google-chrome yum repo file"
touch /etc/yum.repos.d/google-chrome.repo
echo "[google-chrome]" >> /etc/yum.repos.d/google-chrome.repo
echo "[google-chrome]" >> $log
echo "name=google-chrome" >> /etc/yum.repos.d/google-chrome.repo
echo "name=google-chrome" >> $log
echo "baseurl=http://dl.google.com/linux/chrome/rpm/stable/$basearch" >> /etc/yum.repos.d/google-chrome.repo
echo "baseurl=http://dl.google.com/linux/chrome/rpm/stable/$basearch" >> $log
echo "enabled=1" >> /etc/yum.repos.d/google-chrome.repo
echo "enabled=1" >> $log
echo "gpgcheck=1" >> /etc/yum.repos.d/google-chrome.repo
echo "gpgcheck=1" >> $log
echo "gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub" >> /etc/yum.repos.d/google-chrome.repo
echo "gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub" >> $log
echo "Installing google-chrome" >> $log
echo "Installing google-chrome"
yum -y install google-chrome-stable 1>> $log 2>> $log

echo "Operation done in 85%"
echo "Configuring login manager (GDM), adding lines for autologin kiosk user."

echo "Adding line to /etc/gdm/custom.conf for automatic login."
echo "Adding line to /etc/gdm/custom.conf for automatic login." >> $log
sed -i '/daemon]/aAutomaticLoginEnable=true' /etc/gdm/custom.conf 1>> $log 2>> $log
echo "Adding line to /etc/gdm/custom.conf for login user name."
echo "Adding line to /etc/gdm/custom.conf for login user name." >> $log
sed -i '/AutomaticLoginEnable=true/aAutomaticLogin=kiosk' /etc/gdm/custom.conf 1>> $log 2>> $log
echo "Adding line to /etc/gdm/custom.conf for default X Session in EL7." >> $log
echo "And creating session file for specific user in /var/lib/AccountsService/users/kiosk." >> $log
sed -i '/AutomaticLogin=kiosk/aDefaultSession=xinit-compat.desktop' /etc/gdm/custom.conf 1>> $log 2>> $log
touch /var/lib/AccountsService/users/kiosk
chmod 644 /var/lib/AccountsService/users/kiosk
echo "[User]" >> /var/lib/AccountsService/users/kiosk
echo "Language=" >> /var/lib/AccountsService/users/kiosk
echo "XSession=xinit-compat" >> /var/lib/AccountsService/users/kiosk
echo "SystemAccount=false" >> /var/lib/AccountsService/users/kiosk

echo "Operation done in 90%"
echo "Configuring system to start in graphical mode."
echo "Configuring system to start in graphical mode." >> $log
echo "Current starting mode in EL7 (text or graphical is:" >> $log
systemctl get-default 1>> $log 2>> $log
echo "Setting up graphical boot in EL7." >> $log
systemctl set-default graphical.target 1>> $log 2>> $log

echo "Operation done in 93%"
echo "Disabling firstboot."
echo "Disabling firstboot." >> $log
echo "RUN_FIRSTBOOT=NO" > /etc/sysconfig/firstboot

echo "Operation done in 94%"
echo "Generating browser startup config file."
echo "Generating browser startup config file." >> $log
echo "xset s off" > /home/kiosk/.xsession
echo "xset -dpms" >> /home/kiosk/.xsession
echo "matchbox-window-manager &" >> /home/kiosk/.xsession
echo "while true; do" >> /home/kiosk/.xsession
echo "rsync -qr --delete --exclude='.Xauthority' /opt/kiosk/ /home/kiosk/" >> /home/kiosk/.xsession
echo "google-chrome --kiosk --no-first-run $mainsite" >> /home/kiosk/.xsession
echo "done" >> /home/kiosk/.xsession

echo "Operation done in 96%"
echo "Copying files for reseting every user restart." >> $log
echo "Copying files for reseting every user restart."
cp -r /home/kiosk /opt/
chmod 755 /opt/kiosk
chown kiosk:kiosk -R /opt/kiosk
echo "Operation done in 100%"
echo "Mission completed!"
echo ""
echo "If You got any comments or questions: marcin@marcinwilk.eu"
echo "Remember that after reboot it should start directly in KIOSK."
echo -e "\e[92mUse \e[93mCTRL+ALT+F2 \e[92mto go to console in KIOSK mode!!!"
echo -e "\e[39mThank You."
echo "Job done!" >> $log
sleep 6
