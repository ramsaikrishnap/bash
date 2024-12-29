# Linux Commands Reference Guide

## File and Directory Management
```bash
ls                      # List directory contents
ls -la                  # List detailed directory contents including hidden files
pwd                     # Print working directory
cd directory           # Change directory
mkdir directory        # Create directory
rmdir directory        # Remove empty directory
rm file               # Remove file
rm -r directory       # Remove directory and contents
cp source dest        # Copy file
cp -r source dest     # Copy directory and contents
mv source dest        # Move/rename file or directory
touch file            # Create empty file/update timestamp
chmod permissions file # Change file permissions
chown user:group file # Change file ownership
find / -name file    # Find file in filesystem
tar -czf archive.tar.gz files  # Create compressed archive
tar -xzf archive.tar.gz       # Extract compressed archive
```

## Text Processing
```bash
cat file              # Display file contents
less file             # View file contents page by page
head file             # Display first 10 lines
tail file             # Display last 10 lines
tail -f file          # Follow file updates in real-time
grep pattern file     # Search for pattern in file
sed 's/old/new/g' file # Replace text in file
awk '{print $1}' file # Process text file
sort file             # Sort file contents
uniq file             # Remove duplicate lines
wc file              # Count lines, words, characters
diff file1 file2     # Compare files
```

## System Information
```bash
uname -a              # System information
hostname              # Display hostname
whoami                # Current username
id                    # User/group IDs
date                  # Show date/time
uptime                # System uptime
w                     # Who is logged in
last                  # Last logged in users
df -h                 # Disk space usage
free -h               # Memory usage
top                   # Process information
htop                  # Interactive process viewer
ps aux               # Process status
```

## Network Commands
```bash
ping host             # Test network connectivity
ifconfig              # Network interface configuration
ip addr               # IP address information
netstat               # Network statistics
ss                    # Socket statistics
nslookup domain       # DNS lookup
dig domain            # DNS lookup (detailed)
wget url              # Download file
curl url              # Transfer data
ssh user@host         # Secure shell
scp file user@host:   # Secure copy
nc host port          # Netcat
```

## Package Management (Debian/Ubuntu)
```bash
apt update            # Update package list
apt upgrade           # Upgrade packages
apt install package   # Install package
apt remove package    # Remove package
apt search package    # Search for package
dpkg -i package.deb   # Install .deb package
```

## Package Management (RedHat/CentOS)
```bash
yum update            # Update package list
yum upgrade           # Upgrade packages
yum install package   # Install package
yum remove package    # Remove package
yum search package    # Search for package
rpm -i package.rpm    # Install .rpm package
```

## User Management
```bash
useradd username      # Create user
userdel username      # Delete user
passwd username       # Change password
groupadd groupname    # Create group
groupdel groupname    # Delete group
usermod -aG group user # Add user to group
su username           # Switch user
sudo command          # Execute as superuser
```

## Process Management
```bash
ps                    # Process status
kill pid              # Kill process by ID
killall process       # Kill process by name
pkill pattern         # Kill process by pattern
nice value command    # Run with modified priority
renice value -p pid   # Change process priority
nohup command &       # Run immune to hangups
screen                # Terminal multiplexer
tmux                  # Terminal multiplexer
```

## File System
```bash
mount                 # Mount filesystem
umount filesystem     # Unmount filesystem
fsck filesystem       # Check filesystem
df -h                 # Disk space usage
du -h                 # Directory space usage
lsblk                 # List block devices
fdisk -l              # List disk partitions
mkfs.ext4 /dev/sda1   # Create ext4 filesystem
```

## System Control
```bash
shutdown -h now       # Shutdown system
reboot                # Restart system
systemctl start service    # Start service
systemctl stop service     # Stop service
systemctl status service   # Check service status
systemctl enable service   # Enable service at boot
journalctl            # View system logs
dmesg                 # Kernel ring buffer
```

## Performance Monitoring
```bash
top                   # System monitor
htop                  # Interactive process viewer
iotop                 # I/O monitor
iostat                # I/O statistics
vmstat                # Virtual memory stats
mpstat                # CPU statistics
sar                   # System activity reporter
```

## Security
```bash
chmod permissions file # Change file permissions
chown user:group file # Change file ownership
su                    # Switch user
sudo                  # Execute as superuser
passwd                # Change password
ssh-keygen            # Generate SSH key
iptables             # Firewall management
ufw                  # Uncomplicated firewall
```

## Hardware Information
```bash
lscpu                 # CPU information
lsmem                 # Memory information
lspci                 # PCI devices
lsusb                 # USB devices
lshw                  # Hardware configuration
dmidecode             # DMI/SMBIOS info
sensors               # Hardware sensors
```

## Archive and Compression
```bash
tar -czf archive.tar.gz files  # Create tar.gz archive
tar -xzf archive.tar.gz        # Extract tar.gz archive
zip archive.zip files          # Create zip archive
unzip archive.zip             # Extract zip archive
gzip file                     # Compress file
gunzip file.gz               # Decompress file
bzip2 file                   # Compress file
bunzip2 file.bz2            # Decompress file
```