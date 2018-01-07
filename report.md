# Security Assignment
My initial goal is to set up a low-cost device that scans the network for changes in active devices and open ports on those devices. In a certain sense it would function as an IDS and general network device monitoring tool.

Being aware of what changes happen to a network and what devices are on the network seems like useful information for ICT savy people.

The amount of IoT-devices will only increase, and the switch to IPv6 means more devices will be accessable directly trough the Internet.
## Strategies / Steps
### Current network (scan.sh)
In order for any tools to work we need to get a range of ip's belonging to the current network, using `ifconfig` and a bit bash magic we can figure those out automatically. See [./scan.sh](./scan.sh) for a script doing just that.

It resolves based on current ip and netmask (for both OSX and linux) the ip range with cidr.

These can be fed into nmap.
### Gathering information (nmap)
First of all it's useful to gather information about current devices in a network and the services provided by the device (http/ssh/telnet...)

Futher it's useful identify the verion of services, to check if updates are due or the version of the running software on a device is vulnerable.
### Monitoring changes
Whenever a new device appears in the network, or a new service becomes available it could be due to an intrusion.

By doing regular scans and diffing them (in a smart way, taking IP and MAC addresses into account) we could identify if a new device appears on the network, or an existing device starts/stops a service.
## TODO
- [ ] check if masscan is faster to scan for ports?
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

8 minutes for 1 host
```
nmap -sV 10.0.0.0/8 --version-all
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
smbmap -H 10.10.0.1```
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

## sources
- https://tools.kali.org/tools-listing

[1]: https://raspberrypi.stackexchange.com/questions/5033/how-much-energy-does-the-raspberry-pi-consume-in-a-day
[2]: https://www.offensive-security.com/kali-linux-arm-images/
[3]: https://www.mathyvanhoef.com/2016/03/how-mac-address-randomization-works-on.html
[4]: https://tools.kali.org/information-gathering/thc-ipv6
