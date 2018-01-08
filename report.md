# Security Assignment

https://github.com/larrybolt/ucll-security-scanning/blob/master/report.md

My initial goal is to set up a low-cost device that scans the network for changes in active devices and open ports on those devices. In a certain sense it would function as an IDS and general network device monitoring tool.

Being aware of what changes happen to a network and what devices are on the network seems like useful information for ICT savy people.

The amount of IoT-devices will only increase, and the switch to IPv6 means more devices will be accessable directly trough the Internet.

(best skip to conclusion, the following topics are more of a listing/write-up I used along the way)
## Strategies / Steps
### Current network (scan.sh)
In order for any tools to work we need to get a range of ip's belonging to the current network, using `ifconfig` and a bit bash magic we can figure those out automatically. See [./scan.sh](./scan.sh) for a script doing just that.

It resolves based on current ip and netmask (for both OSX and linux) the ip range with cidr.

These can be fed into nmap.
### Gathering information (nmap)
First of all it's useful to gather information about current devices in a network and the services provided by the device (http/ssh/telnet...)

Futher it's useful identify the version of services, to check if updates are due or the version of the running software on a device is vulnerable.
### Monitoring changes
Whenever a new device appears in the network, or a new service becomes available it could be due to an intrusion.

By doing regular scans and diffing them (in a smart way, taking IP and MAC addresses into account) we could identify if a new device appears on the network, or an existing device starts/stops a service.
## (still) TODO
- [ ] all in one tool: sparta (doesn't work after having updated kali)

## original assignment
Kali Linux scan tools uittesten
Alle mogelijke scan tools uittesten die kali linux bevat om een overzicht te
krijgen van alle mogelijk toestellen en IoT-devices
in een (consumer) netwerk en mogelijke onveiligheden.

(Rand)voorwaarden:

- alle scan-tools (netwerk en protocol/applicatie specifieke scans) voor als je al in het netwerk zit.
- niet rekening houden met IDS-tools (meer richten op consumer netwerken of small business)
- zo veel mogelijk automatiseren, nmap voor lijst van hosts, http-traffic tool gebruiken voor de hosts met poorten die http open hebben staan
- alle resultaten proberen te verzamelen (niet parsen, gewoon verzamelen)

## Scaning tools in kali that are usable
### nmap
Useful to get list of active hosts by ip and MAC address and open ports with service/version detection.

```
nmap -sV 10.0.0.0/8 --version-all
```
### masscan
Masscan is similar to nmap, the most famous port scanner. Internally, it operates more like scanrand, unicornscan, and ZMap, using asynchronous transmission. The major difference is that it's faster than these other scanners. In addition, it's more flexible, allowing arbitrary address ranges and port ranges.

Seems like a good choice instead of nmap in larger networks, depending on the network connection, example command and output

```
masscan 10.10.0.0/16 -p80 --max-rate 1000 --banners --source-ip 10.10.11.12

Starting masscan 1.0.4 (http://bit.ly/14GZzcT) at 2018-01-07 23:52:46 GMT
 -- forced options: -sS -Pn -n --randomize-hosts -v --send-eth
Initiating SYN Stealth Scan
Scanning 65536 hosts [1 port/host]
Discovered open port 80/tcp on 10.10.0.20                      
Discovered open port 80/tcp on 10.10.0.1                   
Banner on port 80/tcp on 10.10.0.20: [http] HTTP/1.0 404 Not Found\x0d\x0aContent-Type: text/plain; charset=utf-8\x0d\x0aServer: Caddy\x0d\x0aX-Content-Type-Options: nosniff\x0d\x0aDate: Sun, 07 Jan 2018 23:53:24 GMT\x0d\x0aContent-Length: 19\x0d\x0a\x0d
Banner on port 80/tcp on 10.10.0.1: [title] 301 Moved Permanently
Banner on port 80/tcp on 10.10.0.1: [http] HTTP/1.1 301 Moved Permanently\x0d\x0aDate: Sun, 07 Jan 2018 23:53:40 GMT\x0d\x0aServer: Apache\x0d\x0aLocation: http://localhost/r49602,/playzone,/\x0d\x0aContent-Length: 243\x0d\x0aConnection: close\x0d\x0aContent-Type: text/html; charset=iso-8859-1\x0d\x0a\x0d

```

### GoLismero
Has plugins for:

- dns
- dns_malware
- fingerprint_web
- geoip
- punkspider
- robots
- shodan
- spider
- spiderfoot
- theharvester
- brute_directories
- brute_dns
- brute_url_extensions
- brute_url_permutations
- brute_url_predictables
- brute_url_prefixes
- brute_url_suffixes
- nikto
- nmap
- openvas
- plecost
- sslscan
- zone_transfer
- heartbleed
- sqlmap
- xsser

Using a command we can select which plugins will be used to scan and provide a path for the report, this tool will only report vulnerabilities:
```
golismero scan http://10.10.0.20:9000 \
	-e fingerprint_web \
	-e robots \
	-e brute* \
	-e nikto \
	-e plecost \
	-e sslscan \
	-e heartbleed \
	-e sqlmap \
	-e xsser \
	-o /root/report.html
```

###arp-scan
Get a list of all devices connection to the network trough ethernet and the IP's and MAC-addresses for those devices.

### smbmap 
can be used to scan samba shares
```
smbmap -H 10.10.0.1

```
### snmp-check
For devices that have snmp enabled
```
snmp-check ip-address
```
### thc-ipv6
for any ipv6 related stuff [4]

### BlindElephant.py
BlindElephant Web Application Fingerprinter

For certain webapps, drupal with 16 plugins and wordpress with 26 plugins out of the box.

### miranda
Universal Plug-N-Play client application designed to discover, query and interact with UPNP devices, particularly Internet Gateway Devices (aka, routers)

Use `miranda` to launch the cli repl tool.

### nbtscan
Look for NETBIOS nameservers on a local or remote TCP/IP network

`nbtscan -r 10.0.0.0/8` to scan local network.
## hardware choice
I'll be using a raspberry pi, because it's low cost (also to keep it online) [1], it's possible to run kali linux on it [2] and it's a device that has and will keep existing.

I also happen to have laying around a RPi3 (and others).

## Problems / Issues & solutions
In most consumer networks the DHCP server only issues temporary leases, which means in order to identify devices we should not see IP-address changes as changes, but rather check the MAC-addresses.

MAC Address Randomization Works on Windows 10 [3] breaks keeping track of devices based on MAC address

Lot of tools use web interfaces to interact, but others can be used from the CLI, web-ui tools might have an API though.

## Conclusion
First I set out on a way to get the local range of ips to scan, see `scan.sh`, kind of annoying this information isn't provided out of the box by ifconfig (but you can check the routing map.. but I want automatisation!):

```
PUBLIC IP: [redacted]
range: 10.0.0.0/8 (own ip: 10.10.11.12)     # yes our network at home is A-class
range: 10.211.55.0/24 (own ip: 10.211.55.2) # internal ips set by virtualbox
range: 10.37.129.0/24 (own ip: 10.37.129.2)
```

Next I set out to see how to find all active services using **nmap**:

```
nmap -sV 10.10.0.1 --version-all                                                                               Starting Nmap 7.40 ( https://nmap.org ) at 2018-01-08 01:01 CET
Nmap scan report for 10.10.0.1
Host is up (0.0043s latency).
Not shown: 989 closed ports
PORT     STATE SERVICE     VERSION
22/tcp   open  ssh         Dropbear sshd 2016.73 (protocol 2.0)
80/tcp   open  http        Apache httpd
111/tcp  open  rpcbind     2 (RPC #100000)
139/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
443/tcp  open  ssl/http    Apache httpd
445/tcp  open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
548/tcp  open  afp         Netatalk 2.2.1 (name: nasc; protocol 3.3)
631/tcp  open  ipp         CUPS 1.1
2049/tcp open  nfs         2-3 (RPC #100003)
8082/tcp open  http        Apache httpd
9091/tcp open  http        Transmission BitTorrent management httpd
Service Info: OSs: Linux, Unix; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 16.88 seconds
```

and **masscan** in the hopes it would be faster:

```
sudo masscan 10.10.0.1  -p0-65535 --max-rate 1000 --banners --source-ip 10.10.11.12
Starting masscan 1.0.4 (http://bit.ly/14GZzcT) at 2018-01-08 00:10:56 GMT
 -- forced options: -sS -Pn -n --randomize-hosts -v --send-eth
Initiating SYN Stealth Scan
Scanning 1 hosts [65536 ports/host]
Discovered open port 60889/tcp on 10.10.0.1                    
Discovered open port 5563/tcp on 10.10.0.1                 
Discovered open port 631/tcp on 10.10.0.1                  
Discovered open port 22/tcp on 10.10.0.1                   
Banner on port 22/tcp on 10.10.0.1: [ssh] SSH-2.0-dropbear_2016.73
Discovered open port 548/tcp on 10.10.0.1
Discovered open port 4745/tcp on 10.10.0.1                 
Discovered open port 8082/tcp on 10.10.0.1                 
Discovered open port 4595/tcp on 10.10.0.1                 
Discovered open port 8082/tcp on 10.10.0.1                 
Discovered open port 80/tcp on 10.10.0.1                   
Discovered open port 111/tcp on 10.10.0.1                   
Discovered open port 2049/tcp on 10.10.0.1                  
Discovered open port 8082/tcp on 10.10.0.1                  
Discovered open port 443/tcp on 10.10.0.1                   
Discovered open port 139/tcp on 10.10.0.1                   
Banner on port 443/tcp on 10.10.0.1: [ssl] TLS/1.1 cipher:0xc014, NSA325-v2
Banner on port 443/tcp on 10.10.0.1: [X509] MIICWTCCAcKgAwIBAgIJ...redacted...QNljst+o=
Discovered open port 9091/tcp on 10.10.0.1                  
Discovered open port 445/tcp on 10.10.0.1                   
Banner on port 80/tcp on 10.10.0.1: [title] 301 Moved Permanently
Banner on port 80/tcp on 10.10.0.1: [http] HTTP/1.1 301 Moved Permanently\x0d\x0aDate: Mon, 08 Jan 2018 00:11:28 GMT\x0d\x0aServer: Apache\x0d\x0aLocation: http://localhost/r49602,/playzone,/\x0d\x0aContent-Length: 243\x0d\x0aConnection: close\x0d\x0aContent-Type: text/html; charset=iso-8859-1\x0d\x0a\x0d
```
Nmap results can be exported using the `-oX` flag to xml format, which can be imported in other tools such as **GoLismero** using the `golismero import` command.

For the other tools scripting would be required, the nmap output is more usfull since it reports the kind of service (http/netbios-ssn/...)

Other relevant scripts could be smbmap, miranda, nbtscan. A lot of webapp scanning tools exist that call tools on their own such as GoLismero.

Other tools for this might exist too, such as `Open-AudIT` [5] but those are more geared towards network management. My ideal tool would report about changes and allow full scans of the network and services for known vulnerabilities.

## sources
- https://tools.kali.org/tools-listing

[1]: https://raspberrypi.stackexchange.com/questions/5033/how-much-energy-does-the-raspberry-pi-consume-in-a-day
[2]: https://www.offensive-security.com/kali-linux-arm-images/
[3]: https://www.mathyvanhoef.com/2016/03/how-mac-address-randomization-works-on.html
[4]: https://tools.kali.org/information-gathering/thc-ipv6
[5]: http://www.open-audit.org/about.php
