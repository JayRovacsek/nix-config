sudo systemctl stop microvm@igglybuff.service
sudo systemctl stop microvms.target 
sudo systemctl stop microvm-tap-interfaces@igglybuff.service 
sudo systemctl stop microvm-virtiofsd@igglybuff.service  
sudo rm -rf /var/lib/microvms/igglybuff 
sudo systemctl stop microvm@aipom.service 
sudo systemctl stop microvms.target 
sudo systemctl stop microvm-tap-interfaces@aipom.service 
sudo systemctl stop microvm-virtiofsd@aipom.service  
sudo rm -rf /var/lib/microvms/aipom 
sudo rm -rf /etc/systemd/network/ 
nixos-rebuild switch --flake .# --use-remote-sudo 
sudo systemctl daemon-reload 
sudo networkctl reload