# Mashup of soniclidi/alpine-ocserv + USECALLMANAGER.nz patch
  
I don't know what I'm doing, wanted to build a VPN concentrator container.  
  
Security considerations are not made in this repo.


to run: 

- `docker network create --subnet=10.0.0.0/16 dockernet` 
- `vi ocserv.conf`
  - `ipv4-network = 10.10.0.0`  
  - `ipv4-netmask = 255.255.0.0`
  - `dns = 10.10.0.1`
  - `route = 10.0.0.0/255.0.0.0`
  - `no-route = 192.168.0.0/255.255.0.0`
  - `persistent-cookies = true`
- `docker rm -f ocserv; docker run --name ocserv --privileged -p 443:443 --net dockernet --ip 10.0.0.10 -v /root/ocserv-conf:/etc/ocserv/ numpad0/ocserv`
- `route add -net 10.10.0.0 gw 10.0.0.10 netmask 255.255.0.0`

.  
.  
.  
.  
.  


# alpine-ocserv
Ocserv VPN docker image based on Alpine Linux

Tiny small, only 60MB!!!

Some codes from https://github.com/TommyLau/docker-ocserv

no-route list from https://github.com/CNMan/ocserv-cn-no-route


useage: docker run --name ocserv --privileged -p 443:443 -p 443:443/udp -d soniclidi/alpine-ocserv

this will run an instance with a default user "test" and password "test".

add user: docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd newuser

delete user: docker exec -ti ocserv ocpasswd -c /etc/ocserv/ocpasswd -d test
