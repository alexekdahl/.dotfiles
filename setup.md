### Change username
1. Create a TEMP user.
2. Add TEMP user to sudo group
3. Use TEMP user to change first user (we will called first user ADMIN in this example) login name
4. Delete TEMP use

```
sudo -s
useradd -G sudo temp
passwd temp
shutdown now -r
```

# Logout and log back in as the new “temp” user. Elevate privileges and change username of first account (ADMIN).

```
sudo -s
usermod -l alex admin
sudo usermod -d /home/alex -m alex
```

# Log back in as the renamed admin user (renamed above to “alex”) and delete out the temp user.

```
sudo -s
deluser temp
```
-------------------------------------------------------------------------------------------------------------------
### Free up port 53, used by systemd-resolved

```
sudo vim /etc/systemd/resolved.conf
```

# This is how it should look

```
DNS=1.1.1.1
#FallbackDNS=
#Domains=
#LLMNR=no
#MulticastDNS=no
#DNSSEC=no
#DNSOverTLS=no
#Cache=no
DNSStubListener=no
#ReadEtcHosts=yes
```

# Create symlink

```
sudo ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
```

# Reboot

### Hostsfiles

```
/etc/hosts
/etc/hostname
```
