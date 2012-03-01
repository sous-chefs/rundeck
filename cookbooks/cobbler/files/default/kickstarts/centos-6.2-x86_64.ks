# System language
lang en_US.UTF-8
# System keyboard
keyboard us
# Use network installation
url --url $tree $SNIPPET('centos_proxy')
# Use text mode install
text
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Firewall configuration
firewall --disabled
# Run the Setup Agent on first boot
firstboot --disable
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
# Reboot after installation
reboot
#Root password
rootpw --iscrypted $1$DrRRb8N0$hJweIDC65ESZcpR.GI6PK1
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# System timezone
timezone --utc Etc/UTC
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr

# Partitioning
$SNIPPET('centos_partitioning')

%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')

%packages
$SNIPPET('func_install_if_enabled')
$SNIPPET('puppet_install_if_enabled')

%post
$SNIPPET('log_ks_post')
# Start yum configuration 
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('func_register_if_enabled')
$SNIPPET('puppet_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
$SNIPPET('centos_update')
$SNIPPET('centos_chef')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('kickstart_done')
# End final steps

