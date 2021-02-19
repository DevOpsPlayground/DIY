## Loadbalance traffic to our containers with haproxy
[Home](../README.md) | [Deploy web application as standalone container](standalone.md) | [Deploy application on the Swarm cluster](swarm.md) | [Deploy application on the Kubernetes cluster](k8s.md)
## Lets move to the master node

You should already be logged in to your master-node go back to the tab for your master node and continue from here: you master node should have the username `master-node`

We need to create haproxy.cfg file which will contain configuration of our load-balancer. 
Lets move up from ```app``` directory and create load-balancer configuration in the ```haproxy``` directory. We can do so by executing

```bash
cd .. # Takes you back one directory. 
vim haproxy/haproxy.cfg # Opens the VIM visual editor. 
```
Config file is almost ready to use and should look like the one below. We need to specify our ```<host-addresses>``` and ```<ports>``` to make it ready to run.


```bash
global
    daemon

defaults
    mode    http
    timeout connect 5000
    timeout client  50000
    timeout server  50000

frontend haproxynode
    bind *:80
    mode http
    default_backend backendnodes

backend backendnodes
    balance roundrobin
    option forwardfor
    server node1 <host-address:port> check
    server node2 <host-address:port> check

```
in the previous step we created two docker containers on port `8080` for the `master` and the `worker` for `<<host-address:port>` enter the IP and port for each of these e.g. `192.169.0.1:8080` for master and `192.161.72.1` for worker. 

`NOTE: The IP's will be in your terraform outputs or in the address bar for each instance tab. `



Finally run lets run the container with the load-balancer using:
```bash
docker run --detach --name load-balancer --volume `pwd`/haproxy:/usr/local/etc/haproxy:ro --publish 8081:80 haproxy
```
Now lets type our ```<master-node-address>:8081``` in the browser, then refresh the page a few times. You should see how traffic is directed to the different nodes/containers.

It is a glimpse of the container world without orchestration. Lets cleanup and remove the containers on both nodes by executing:


```bash
docker ps 
docker rm -f `docker ps -a -q`
```

[Next - Deploy application on the Swarm cluster](swarm.md)
