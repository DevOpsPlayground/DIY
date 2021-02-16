## Build and run the containerised application
[Home](../README.md) | [Deploy and use load-balancer](lb.md) | [Deploy application on the Swarm cluster](swarm.md) | [Deploy application on the Kubernetes cluster](k8s.md)

## Lets move to the master node!

First lets log-in to the master node: You can obtain the IP and password from the terraform outputs after applying

> MasterNodeIps = <YOUR_MASTER_NODE_IP/wetty> e.g 192.168.0.1/wetty
MasterNodePassword = <YOUR_MASTER_NODE_PASSWORD e.g 'PASSWORD123'

For todays workshop we have provided a dockerised web application that We we will be deploying. You will find it in ```workdir/Hands-on-with-container-orchestration-using-Docker-Swarm-and-Kubernetes/app``` directory. You can move there by typing

######NOTE: If you're typing manually you can use tab to autocomplete. 

 ```bash
 cd workdir/Hands-on-with-container-orchestration-using-Docker-Swarm-and-Kubernetes/app


 ```
 Our first step will be to create a docker image with the application. We are going to use ```Dockerfile``` to do so. You can see that there is one in our directory already but it require your personal touch. Lets have a look on it by typing
 ```
 vim Dockerfile
 ```
Our ```Dockerfile``` should look like below:

```dockerfile
FROM python:3.7-alpine

WORKDIR /app

COPY . /app

RUN pip install --trusted-host pypi.python.org -r requirements.txt

EXPOSE 80

ENV NAME <your-name>

ENTRYPOINT ["python3.7", "app.py"]
```
Lets build an image.
```bash
docker build --tag devopspg/web-app:1.0 .
```
Lets list the local images by typing:
```bash
docker image ls
```
You should see:
```
REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
devopspg/web-app           1.0                 f47638dd1c0e        4 seconds ago       97.2MB
```
Now it is time to run our application:
```bash
docker run --name web-app --detach --publish 8080:80 devopspg/web-app:1.0
```
You can see it from web browser by typing ```<instance-address>:8080```

## Lets move to the worker node!

Now that you've run the application on the master node do the same on the worker node: Open another browser tab and navigate to the worker node IP address and enter the password. 

##### NOTE: Both are provided in the terraform outputs.

> WorkerNodeIps = <YOUR_NODE_IP/wetty> \
WorkerNodePassword = <YOUR_NODE_PASSWORD  

Once this is done you should have two Dockerizsed web applications running: 

><YOUR_MASTER_NODE_IP:8080> e.g. 92.168.0.11:8080 \
<YOUR_WORKER_NODE_IP:8080> e.g. 92.168.0.2:8080



[Next - Deploy and use load-balancer](lb.md)
