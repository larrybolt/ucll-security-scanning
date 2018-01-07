# Security Assignment
My initial goal is to set up a low-cost device that scans the network for changes in active devices and open ports on those devices. In a certain sense it would function as an IDS.

Being aware of what changes happen to a network and what devices are on the network seems like useful information for ICT savy people.

The amount of IoT-devices will only increase, and the switch to IPv6 means more devices will be accessable directly trough the Internet.
## Strategies
### Gathering information
First of all it's useful to gather information about current devices in a network and the services provided by the device (http/ssh/telnet...)

Futher it's useful identify the verion of services, to check if updates are due or the version of the running software on a device is vulnerable.
### Monitoring changes
Whenever a new device appears in the network, or a new service becomes available it could be due to an intrusion.


## TODO
- [ ] check how golismero could be used to scan IoT devices with a webinterface?
- [ ] check if masscan is faster to scan for ports? 
miranda
smb->SMBMap
snmp->snmp-check
http->nikto 
all in one tool: sparta
sslscan
blindelephant

for any ipv6 thc-ipv6
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
###nmap
Useful to get list of active hosts by ip and MAC address and open ports with service/version detection.

###arp-scan
Get a list of all devices connection to the network trough ethernet and the IP's and MAC-addresses for those devices.

## hardware choice
I'll be using a raspberry pi, because it's low cost (also to keep it online) [1], it's possible to run kali linux on it [2] and it's a device that has and will keep existing.

I also happen to have laying around a RPi3 (and others).

## Problems / Issues & solutions
In most consumer networks the DHCP server only issues temporary leases, which means in order to identify devices we should not see IP-address changes as changes, but rather check the MAC-addresses.

MAC Address Randomization Works on Windows 10 [3] breaks keeping track of devices based on MAC address









[1]: https://raspberrypi.stackexchange.com/questions/5033/how-much-energy-does-the-raspberry-pi-consume-in-a-day
[2]: https://www.offensive-security.com/kali-linux-arm-images/
[3]: https://www.mathyvanhoef.com/2016/03/how-mac-address-randomization-works-on.html