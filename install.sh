#!/bin/sh

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

####################################
# custom install script for LightDM#
# and following GPU BusID's        #
# intel iGPU BusID  00:02:0        #
# nvidia dGPU BusID  01:00:0       #
# chmod +x install.sh  first!      #
####################################

echo '##################################################################'
echo '# be sure you have all requirements BEFORE running this script  ##'
echo '# "pacman -S linux-headers acpi_call-dkms xf86-video-intel git" ##'
echo '# ****installing in 5 sec... CTRL+C to abort****                ##'
echo '##################################################################'
sleep 6
echo ' '
echo '##################################################################'
echo '#errors about removing files can be ignored, i wrote this script##'
echo '#with the most common files in mind, you will not have all of   ##'
echo '#them, this is ok!                                              ##'
echo '##################################################################'
echo '## IF YOU HAVE ERRORS ABOUT COPYING FILES, SOMETHING IS WRONG   ##'
echo '## MAKE SURE THIS IS RUN WITH SUDO AND FROM DIRECTORY           ##'
echo '## /home/$USER/optimus-switch/  (this is very important!!!)     ##'
echo '##################################################################'
sleep 5

echo ' '
echo 'Removing current nvidia prime setup if applicable, file not found can be ignored......'
rm -rf /etc/X11/mhwd.d/nvidia.conf
rm -rf /etc/X11/mhwd.d/nvidia.conf.nvidia-xconfig-original
echo 'rm -rf /etc/X11/mhwd.d/nvidia.conf*'
rm -rf /etc/X11/xorg.conf.d/90-mhwd.conf
echo 'rm -rf /etc/X11/xorg.conf.d/90-mhwd.conf'
rm -rf /etc/modprobe.d/mhwd-gpu.conf
rm -rf /etc/modprobe.d/optimus.conf
rm -rf /etc/modprobe.d/nvidia.conf
echo 'rm -rf /etc/modprobe.d/mhwd-gpu.conf'
rm -rf /etc/modprobe.d/nvidia-drm.conf
rm -rf /etc/modprobe.d/nvidia.conf
echo 'rm -rf /etc/modprobe.d/nvidia*.conf'
rm -rf /etc/modules-load.d/mhwd-gpu.conf
echo 'rm -rf /etc/modules-load.d/mhwd-gpu.conf'
rm -rf /usr/local/bin/optimus.sh
rm -rf /usr/local/share/optimus.desktop
echo 'rm -rf /usr/local/share/optimus.desktop'
sleep 2

echo 'Copying contents of ~/optimus-switch/* to /etc/ .......'
mkdir /etc/switch/
cp -r * /etc/

sleep 2
echo 'Copying set-intel.sh and set-nvidia.sh to /usr/local/bin/'

cp /etc/switch/set-intel.sh /usr/local/bin/set-intel.sh

cp /etc/switch/set-nvidia.sh /usr/local/bin/set-nvidia.sh

###This section not needed for LightDM but can be used if want, its not required.
#cp /etc/switch/optimus.desktop /usr/local/share/optimus.desktop
#sleep 1
#echo 'Copying disable-nvidia.service to /etc/systemd/system/' 
#cp /etc/switch/intel/disable-nvidia.service /etc/systemd/system/disable-nvidia.service
#chown root:root /etc/systemd/system/disable-nvidia.service
#chmod 644 /etc/systemd/system/disable-nvidia.service

sleep 1
echo 'Setting nvidia prime mode (sudo set-nvidia.sh).......'

cp /etc/switch/nvidia/nvidia-mhwd.conf /etc/X11/mhwd.d/99-nvidia.conf
cp /etc/switch/nvidia/nvidia-xorg.conf /etc/X11/xorg.conf.d/99-nvidia.conf
cp /etc/switch/nvidia/nvidia-modprobe.conf /etc/modprobe.d/99-nvidia.conf
cp /etc/switch/nvidia/nvidia-modules.conf /etc/modules-load.d/99-nvidia.conf
cp /etc/switch/nvidia/optimus.sh /usr/local/bin/optimus.sh

sleep 1
echo 'Setting permissions........'
chmod +x /usr/local/bin/set-intel.sh
chmod +x /usr/local/bin/set-nvidia.sh
chmod a+rx /usr/local/bin/optimus.sh
chmod a+rx /etc/switch/intel/no-optimus.sh
chmod a+rx /etc/switch/nvidia/optimus.sh

sleep 1
echo 'Currently boot mode is set to nvidia prime.'
echo 'you can switch to intel only mode with sudo set-intel.sh and reboot.'
echo 'same can be done for nvidia prime mode with sudo set-nvidia.sh'
echo '######################################################################'
echo '*                                                                    *'
echo '* dont forget to edit [Seat:*] section of /etc/lightdm/lightdm.conf  *'
echo '* to specify the display setup script. without this will fail to     *'
echo '* load a graphical environment. uncomment and edit line as follows:  *'
echo '* display-setup-script=/usr/local/bin/optimus.sh                     *'
echo '*                                                                    *'
echo '*#####################################################################'
sleep 1
echo 'Install finished!'



