{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  environment.extraInit = ''
    # Do not want this in the environment. NixOS always sets it and does not
    # provide any option not to, so I must unset it myself via the
    # environment.extraInit option.
    unset -v SSH_ASKPASS
  '';
  
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
                "electron-12.2.3"
  ];

  programs.dconf.enable = true;


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "norte"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  
  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  virtualisation.docker.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Nerd";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.windowManager.dwm.enable = true;
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "norte";

  # services.printing.enable = true; 

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.libinput.enable = true; # Touchpad support
  services.xserver.libinput.touchpad.naturalScrolling = true;

  services.gnome.gnome-keyring.enable = true;

  ##### Configuration #####

  # User config
  users.users.norte = {
     isNormalUser = true;
     extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       brave
     ];
   };

  # System Packages
  environment.systemPackages = with pkgs; [
     	vim			# Vim
	wget			# Wget
	terminus-nerdfont	# NerdFont
	neofetch		# Neofetch
	zsh			# Zsh shell
	oh-my-zsh		# Zsh framework
	alacritty		# Terminal
	starship		# Custom prompt
	exa 			# ls replacement
	git			# Git
	dmenu			# DynamicMenu
	dwm			# DynamicWindowManager
	neovim			# Nvim
	mlocate 		# Locate
	gnumake 		# Make
	xorg.xinit 		# Xinit
	libgccjit 		# GCC
	pavucontrol		# Audio
	xclip			# Clipboard
	font-awesome_5		# Fonts
	evince			# PDF viewer
	docker			# Docker
	docker-compose		# Docker-compose
	xfce.thunar		# File explorer
	slack			# Slack
	brightnessctl		# Brightness
	python311Packages.pynvim # Python3.11 nvim
	vscode			# Vscode
	go			# Golang
	kubectl			# Kubectl
	pre-commit		# Pre-commit
	python311		# Python3.11
	poetry			# Poetry
  	(google-cloud-sdk.withExtraComponents[google-cloud-sdk.components.gke-gcloud-auth-plugin])
	pdfarranger		# Arrange PDFs
	telegram-desktop	# Telegram
	postman			# Postman
	unetbootin		# bootable usb


   ];

  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "Hack" ]; })
    ];
  };
  

# Build dwm
     nixpkgs.overlays = [
    	(final: prev: {
   		dwm = prev.dwm.overrideAttrs (old: { src = /home/norte/builds/dotfiles/dwm;});
   	})
     ];


  programs.git = {
    enable = true;
    config = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };
  
  services.openssh.enable = true;
  networking.firewall.enable = false;

  system.copySystemConfiguration = true;
  system.stateVersion = "23.05";

}

