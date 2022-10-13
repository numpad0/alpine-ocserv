# Mashup of soniclidi/alpine-ocserv + USECALLMANAGER.nz patch
  
I don't know what I'm doing, wanted to build a VPN concentrator container.  
  
Security considerations are not made in this repo.


to run: `docker run --name ocserv --privileged -p 443:443 -p 443:443/udp -v /etc/ocserv/:~/ocserv-conf/ -d numpad0/ocserv`  

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
