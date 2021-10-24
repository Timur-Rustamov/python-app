# Lab: containerizing and deploying application into K8S cluster
## Task 1. Build docker image with Python  application(3 points)
To build custom docker image we have to:
1. Create new file;
2. Chose the most relevant origin image from any registry(public or our own);
3. Write any custom layers for our own image.
For this task i wrote Dockerfile based on python:3.7-alpine, because this image was the smallest image from all images with python. 
Link to file - https://github.com/Timur-Rustamov/python-app/blob/main/Dockerfile 
Dockerfile config:
````sh
FROM python:3.7-alpine
RUN adduser -D python
USER python
WORKDIR /home/python
COPY application /home/python
ENV PATH="/home/python/.local/bin:${PATH}"
RUN pip install --user -e . && python3.7 setup.py install --user
CMD python3 -m demo
 ````
To build a new image we use the commad **"docker build ."** in directory with our Dockerfile. Because of huge log i did screenshots of the biginning building and the end.
![image](https://user-images.githubusercontent.com/84975945/138605317-49bd5783-1097-4651-8211-af49af1a7606.png)
![image](https://user-images.githubusercontent.com/84975945/138605401-b6376de6-61c4-40b3-b69b-a7322e6ba273.png)
Size of final image is 53MB:
![image](https://user-images.githubusercontent.com/84975945/138605458-3755056f-ed4b-422f-be78-569e6b6b2ca6.png)
Screenshot of running the container from image:
![image](https://user-images.githubusercontent.com/84975945/138605618-0ec2348a-385e-43bd-8ae8-b1a3e9482094.png)
Log from container: 
![image](https://user-images.githubusercontent.com/84975945/138605696-871b356f-2efc-4e85-a130-a9d6693afb0a.png)
Also i added .dockerignore file with only 2 lines. Link to file - https://github.com/Timur-Rustamov/python-app/blob/main/.dockerignore. 
## Task 2. Setup K8S cluster using Minikube(1 master + 1 worker node is enough) (1 point)
To setup K8S cluster with 2 nodes using minikube i used commands: 
````sh
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/
minikube start --nodes 2
 ````
Than i installed kubectl with commands: 
````sh
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
 ````
 Final result:
 ![image](https://user-images.githubusercontent.com/84975945/138606228-9906a66a-71de-4c12-94a0-a41ffcf3f201.png)
 ## Task 3. Deploy the application into the K8S cluster (3 points)
### Create Deployment.yaml file with containerized application
Link to Deployment.yaml - https://github.com/Timur-Rustamov/python-app/blob/main/Deployment

To deploy Deployment, Service and etc from yaml file we use command(in example we are working with Deployment file):
````sh
kubectl apply -f Deployment
 ````
**Log from pod**
![image](https://user-images.githubusercontent.com/84975945/138607179-dd67532f-61f3-4f58-b581-bd8543e6a0ba.png)

## (\*) The deployment requires 3 replicas, “RollingUpdate” strategy. Emulate the “RollingUpdate” strategy by updating docker image. Provide screenshots. Define the liveness and readiness probes to /health endpoint and 8080 port, resources(requests/limits)(*)
Configuration the number of replicas, RollingUpdate strategy, defining liveness and readiness probes to /health endpoint(8080 port) and resources(requests/limits) you can find in Deployment.yaml(link above).
![image](https://user-images.githubusercontent.com/84975945/138607541-45745341-d873-4d02-9459-374cee3b55c1.png)

**Emulating RollingUpdate**
<img width="835" alt="Rollout" src="https://user-images.githubusercontent.com/84975945/138606823-17a2e053-2c85-411f-9b50-e4448c9d3636.png">

## (*) Create a “Service” object which exposes Pods with application outside the K8S cluster in order to access each of the replicas through the single IP address/DNS name 
Link to Service.yaml - https://github.com/Timur-Rustamov/python-app/blob/main/Service
<img width="1201" alt="NodePortWorks" src="https://user-images.githubusercontent.com/84975945/138606959-81b69e29-0f24-4952-8816-782da9127dd2.png">

## (*) Specify PodDistruptionBudget which defines that only 1 replica can be down 
Link to PodDisruptionBudget.yaml https://github.com/Timur-Rustamov/python-app/blob/main/PodDisruptionBudget
<img width="1702" alt="PodDistruptionBudget" src="https://user-images.githubusercontent.com/84975945/138607045-dc91d7c5-cf3f-406a-8704-d70ad457a41b.png">





