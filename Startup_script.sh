#!/bin/bash

echo "**************************************************** Please Remember to  Run This Script with sudo ************************************* "

# Check if the script is executed with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo."
  exit 1
fi

# Starting By updating the Repositories
echo " Doing Required Repos Updates & Upgrades "
apt update ; apt upgrade

echo " Installing Required Packages via apt ......." 
ListPackages=(git gitk gcc make htop net-tools cpu-checker tree ffmpeg)

for item in "${ListPackages[@]}"; do
	echo "######################################################################################################"
	echo " ********************************** Instaling Now : $item *******************************************"
	apt install $item
	echo "#####################################################################################################"

done

#########################################################################################################################################

echo "Verifiy KVM now -----> "
kvm-ok

echo "Adding VSCODE to the  apt Manager "

sudo apt-get install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" |sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
rm -f packages.microsoft.gpg


sudo apt install apt-transport-https
sudo apt update
sudo apt install code # or code-insiders


echo " Installing joplin as your notes manager "
# Bug : we have issue here since joplin installation is not requiring a root access 

# 	-> to handle this by setting flag --alow-root or to make a function to switch to normal user and execute the installation , we will be managing how to do so 
wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash


read -p " Do you want to run Joplin now ? (y/n): " user_answer

#Convert the user_answer to lowercase to avoid all unhandled other cases
user_answer=$(echo "$user_answer" | tr '[:upper]' '[:lower]')


# Handle User input

if [[ "$user_answer" == "y" || "$user_answer" == "yes" ]] ; then
	echo "Starting joplin now"
	joplin-desktop
elif [[ "$user_answer" == "n" || "$user_answer" == "no" ]] ; then
	echo " Procedding , not starting joplin "
else
	echo "Invalid input ! , Proceed anyway !! "
fi


echo "Joplin is install on :"
find ~ -name "Joplin*.AppImage"

echo "adding this lignes into bashrc file to make a command alias to start joplin desktop"
#------------------->  echo "alias joplin="~/.joplin/Joplin-AppImage""

##########################################################################################
	#Joplin aliases to start joplin-desktop app
	#alias joplin="~/.joplin/Joplin.AppImage"
#########################################################################################


read -p "Do you want to increase the swap size to 16GB ? (y/n) " user_answer
#Convert the user_answer to lowercase to avoid all unhandled other cases 
user_answer=$(echo "$user_answer" | tr '[:upper]' '[:lower]')
#handle input 

if [[ "$user_answer" == "y" || "$user_answer" == "yes" ]] ; then
	echo "Increasing the swap size to 16GB
	# Turn swap off
	# This moves stuff in swap to the main memory and might take several minutes
	swapoff -a

	# Create an empty swapfile
	# Note that "1M" is basically just the unit and count is an integer.
	# Together, they define the size. In this case 16GiB.
	dd if=/dev/zero of=/swapfile bs=1M count=16384

	# Set the correct permissions
	chmod 0600 /swapfile

	mkswap /swapfile  # Set up a Linux swap area
	swapon /swapfile  # Turn the swap on

	echo "Check now we shall see that swap is increase to 16GiB "
	grep Swap /proc/meminfo

	echo "We need to make the swap change persist into the machine ... "

else
	echo "Continue now without increasing swap size  ..........."
fi


echo "installing ffmpeg "
apt-get install ffmpeg
