# Wanderlust - Your Ultimate Travel Blog 🌍✈️

WanderLust is a simple MERN travel blog website ✈ This project is aimed to help people to contribute in open source, upskill in react and also master git.

![Preview Image](https://github.com/krishnaacharyaa/wanderlust/assets/116620586/17ba9da6-225f-481d-87c0-5d5a010a9538)
#

# Wanderlust Mega Project End to End Implementation

### In this demo, we will see how to deploy an end to end three tier MERN stack application on EKS cluster.
#
### <mark>Project Deployment Flow:</mark>
<img src="https://github.com/DevMadhup/Wanderlust-Mega-Project/blob/main/Assets/DevSecOps%2BGitOps.gif" />

#

## Tech stack used in this project:
- GitHub (Code)
- Docker (Containerization)
- Jenkins (CI)
- OWASP (Dependency check)
- SonarQube (Quality)
- Trivy (Filesystem Scan)
- ArgoCD (CD)
- Redis (Caching)
- AWS EKS (Kubernetes)
- Terraform (Infrastructure Provisioning)
- Ansible (Configuration Management)
- Helm (Monitoring using grafana and prometheus)

### How pipeline will look after deployment:
- <b>CI pipeline to build and push</b>
![image](https://github.com/user-attachments/assets/20542d8b-0701-43ed-b2f8-82f8ed28d053)

- <b>CD pipeline to update application version</b>
![image](https://github.com/user-attachments/assets/8fd13807-622e-45f7-af23-dcc1ba30ca5d)

- <b>ArgoCD application for deployment on EKS</b>
![image](https://github.com/user-attachments/assets/1ea9d486-656e-40f1-804d-2651efb54cf6)

#
> [!Important]
> Below table helps you to navigate to the particular tool installation section fast.

| Tech stack    | Installation |
| -------- | ------- |
| Jenkins Master | <a href="#Jenkins-master">Create a Jenkins Master EC2 instance</a>     |
| Jenkins-Worker | <a href="#Jenkins-worker">Create a Jenkins-Worker EC2 instance</a>     |
| Bastion-Host | <a href="bastion">Create a Bastion Host to provision Clusters using terraform and Configure master and worker nodes using ansible</a>
| Terraform | <a href="#terraform">Provision EKS Cluster with Terraform</a>     |
| Ansible | <a href="#ansible">Perform Configuration Management on Jenkins Master and Jenkins Worker</a>     |
| Jenkins Worker Setup| <a href="#jenkins-worker-setup">Setup Jenkins Worker as a node to run jobs in Jenkins Master.</a>     |
| Argocd | <a href="#Argo">Install and configure ArgoCD</a>     |
| OWASP setup | <a href="#Owasp">Install and configure OWASP</a>     |
| SonarQube | <a href="#Sonar">Configure SonarQube</a>     |
| Email Notification Setup | <a href="#Mail">Email notification setup</a>     |
| Monitoring | <a href="#Monitor">Prometheus and grafana setup using helm charts</a>
| Clean Up | <a href="#Clean">Clean up</a>     |
#

### Pre-requisites to implement this project:
#
- Root user access
```bash
sudo su
```
> [!Note]
> This project will be implemented on Mumbai region (ap-south-1).

This instance primary use is to launch the EKS cluster using Terraform and 

- <b id="Jenkins-master">Create 1 Master machine on AWS with 2CPU, 8GB of RAM (t2.large) and 29 GB of storage.</b>
#
- <b>Open the below ports in security group of master machine and also attach same security group to Jenkins worker node (We will create worker node shortly)</b>
![image](https://github.com/user-attachments/assets/4e5ecd37-fe2e-4e4b-a6ba-14c7b62715a3)

> [!Note]
> We are creating this master machine because we will configure Jenkins master on this machine.

- <b id="Jenkins-Worker">Create 1 Jenkins Worker Instance on AWS with 2CPU, 8GB of RAM (t2.large) and 29 GB of storage.</b>

> [!Note]
> We are creating this worker machine because we will run Jenkins jobs on this machine.

After creating these 2 ec2 instances , we will configure Jenkins master and Jenkins worker using Ansible, and Provision EKS cluster on AWS using Terraform.

- <b id="bastion"> Create 1 Bastion Machine on AWS with 2CPU, 2GB of RAM (t2.small) and 8GB of storage.</b>

> [!Note]
> We are creating this bastion machine because we will use this machine to provision EKS cluster using terraform and configure master and worker nodes using ansible.

Install Terraform, Ansible, and AWS CLI in the bastion machine 

1. Install AWS CLI
```bash
#Installing AWS CLI
sudo apt update
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install
```

- Configure AWS CLI with Access key
```bash
aws configure
```
- Input the aws credentials of the IAM user
<b>Access Key</b>
<b>Secret Key</b>
<b>Set the Region</b>


2. Install Terraform 
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt-get install terraform -y
```

3. Install Ansible
```bash
#Installing Ansible
sudo apt update
 sudo apt install software-properties-common
 sudo apt-add-repository --yes --update ppa:ansible/ansible
 sudo apt install ansible -y
```

After Installing these tools, we will use them to provision EKS cluster and configure master and worker nodes.

- Clone this Repository in the VM to get the access of those terraform files and ansible configurations.
```bash
git clone https://github.com/rcheeez/Wanderlust-Mega-Project.git
```

- <b id="terraform">Run terraform to provision EKS cluster</b>

```bash
cd terraform
terraform init
terraform plan
terraform apply 
```

Writing these commands, will provision EKS cluster on AWS Cloud.

> [!Note]
>  Make sure the ssh-public-key "ec2-key-pair" is available in your aws account"

<img src="./Assets/terraform-provisioning.png">


# <b id="ansible">Run Ansible to configure master and worker nodes</b>

Let's first configure the hosts file in the ansible directory to point to the master and worker nodes. We will use the IP addresses of the master and worker nodes.

you can locate this file at /etc/ansible/hosts

You have to update this file with this data.

```ini
[master]
master_server ansible_host= <public-ip-address>

[agent]
worker_server ansible_host= <public-ip-address>

[all-vars]
ansible_python_interpreter=/usr/bin/python3
ansible_user=ubuntu
ansible_ssh_private_key_file=/home/ubuntu/keys/<key-pair-name> #ec2-key-pair.pem 
```

> [!Note]
> Give a decent access to the private key (.pem) file to run perfectly.

```bash
sudo chmod 600 <key-pair-pem-file>
```

Now, let's run the playbook to configure the master and worker nodes.

- Run this command first to install collection of community.docker so that ansible can also create containers inside the vm

```bash
ansible-galaxy collection install community.docker
```

- Now run the final command to start the configurations in the VMs
```bash
ansible-playbook -i /etc/ansible/hosts master_server_play.yml # to run the configurations in the jenkins master
ansible-playbook -i /etc/ansible/hosts agent_server_play.yml # to run the configurations in the jenkins worker
```
Jenkins Master Configuration
<img src="./Assets/ansible-master-installation.png">
<br>
<br>
Jenkins Worker Configuration
<img src="./Assets/ansible-worker-installation.png">
> [!Note]
> Make sure the master and worker nodes are up and running before running the playbook. Also, make sure the ssh-public-key "ec2-key-pair" is available in your aws account. 

This will setup all the configuration on those 2 EC2 instances.

After that let's setup the worker instance as a Jenkins Agent to run Jobs.

# Jenkins Worker Setup in Jenkins
  - <b>Now, go to the jenkins master and navigate to <mark>Manage jenkins --> Nodes</mark>, and click on Add node </b>
    - <b>name:</b> Node
    - <b>type:</b> permanent agent
    - <b>Number of executors:</b> 2
    - Remote root directory
    - <b>Labels:</b> Node
    - <b>Usage:</b> Only build jobs with label expressions matching this node
    - <b>Launch method:</b> Via ssh
    - <b>Host:</b> \<public-ip-worker-jenkins\>
    - <b>Credentials:</b> <mark>Add --> Kind: ssh username with private key --> ID: Worker --> Description: Worker --> Username: root --> Private key: Enter directly --> Add Private key</mark>
    - <b>Host Key Verification Strategy:</b> Non verifying Verification Strategy
    - <b>Availability:</b> Keep this agent online as much as possible
#
  - And your jenkins worker node is added
  ![image](https://github.com/user-attachments/assets/cab93696-a4e2-4501-b164-8287d7077eef)

After setting up the eks cluster infrastructure on AWS cloud using terraform we can Configure Argo CD by creating Namespace, applying manifests and changing the service Type to NodePort.
#
- <b id="Argo">Configure ArgoCD</b>
  - <b>Create argocd namespace</b>
  ```bash
  kubectl create namespace argocd
  ```
  - <b>Apply argocd manifest</b>
  ```bash
  kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
  ```
  - <b>Make sure all pods are running in argocd namespace</b>
  ```bash
  watch kubectl get pods -n argocd
  ```
  - <b>Install argocd CLI</b>
  This has been already installed using Ansible in the Jenkins master machine with executive permissions.
  - <b>Check argocd services</b>
  ```bash
  kubectl get svc -n argocd
  ```
  - <b>Change argocd server's service from ClusterIP to NodePort</b>
  ```bash
  kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
  ```
  - <b>Confirm service is patched or not</b>
  ```bash
  kubectl get svc -n argocd
  ```
  - <b> Check the port where ArgoCD server is running and expose it on security groups of a worker node</b>
  ![image](https://github.com/user-attachments/assets/a2932e03-ebc7-42a6-9132-82638152197f)
  - <b>Access it on browser, click on advance and proceed with</b>
  ```bash
  <public-ip-worker>:<port>
  ```
  ![image](https://github.com/user-attachments/assets/29d9cdbd-5b7c-44b3-bb9b-1d091d042ce3)
  ![image](https://github.com/user-attachments/assets/08f4e047-e21c-4241-ba68-f9b719a4a39a)
  ![image](https://github.com/user-attachments/assets/1ffa85c3-9055-49b4-aab0-0947b95f0dd2)
  - <b>Fetch the initial password of argocd server</b>
  ```bash
  kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
  ```
  - <b>Username: admin</b>
  - <b> Now, go to <mark>User Info</mark> and update your argocd password
#
## Steps to add email notification
- <b id="Mail">Go to your Jenkins Master EC2 instance and allow 465 port number for SMTPS</b>
#
- <b>Now, we need to generate an application password from our gmail account to authenticate with jenkins</b>
  - <b>Open gmail and go to <mark>Manage your Google Account --> Security</mark></b>
> [!Important]
> Make sure 2 step verification must be on

  ![image](https://github.com/user-attachments/assets/5ab9dc9d-dcce-4f9d-9908-01095f1253cb)

  - <b>Search for <mark>App password</mark> and create a app password for jenkins</b>
  ![image](https://github.com/user-attachments/assets/701752da-7703-4685-8f06-fe1f65dd1b9c)
  ![image](https://github.com/user-attachments/assets/adc8d8c0-8be4-4319-9042-4115abb5c6fc)
  
#
- <b> Once, app password is create and go back to jenkins <mark>Manage Jenkins --> Credentials</mark> to add username and password for email notification</b>
![image](https://github.com/user-attachments/assets/2a42ec62-87c8-43c8-a034-7be0beb8824e)

# 
- <b> Go back to <mark>Manage Jenkins --> System</mark> and search for <mark>Extended E-mail Notification</mark></b>
![image](https://github.com/user-attachments/assets/bac81e24-bb07-4659-a251-955966feded8)
#
- <b>Scroll down and search for <mark>E-mail Notification</mark> and setup email notification</b>
> [!Important]
> Enter your gmail password which we copied recently in password field <mark>E-mail Notification --> Advance</mark>

![image](https://github.com/user-attachments/assets/14e254fc-1400-457e-b3f4-046404b66950)
![image](https://github.com/user-attachments/assets/7be70b3a-b0dc-415c-838a-b1c6fd87c182)
![image](https://github.com/user-attachments/assets/cffb6e1d-4838-483e-97e0-6851c204ab21)

#
## Steps to implement the project:
- <b>Go to Jenkins Master and click on <mark> Manage Jenkins --> Plugins --> Available plugins</mark> install the below plugins:</b>
  - OWASP
  - SonarQube Scanner
  - Docker
  - Pipeline: Stage View
#
- <b id="Owasp">Configure OWASP, move to <mark>Manage Jenkins --> Plugins --> Available plugins</mark> (Jenkins Worker)</b>
![image](https://github.com/user-attachments/assets/da6a26d3-f742-4ea8-86b7-107b1650a7c2)

- <b id="Sonar">After OWASP plugin is installed, Now move to <mark>Manage jenkins --> Tools</mark> (Jenkins Worker)</b>
![image](https://github.com/user-attachments/assets/3b8c3f20-202e-4864-b3b6-b48d7a604ee8)
#
- <b>Login to SonarQube server and create the credentials for jenkins to integrate with SonarQube</b>
  - Navigate to <mark>Administration --> Security --> Users --> Token</mark>
  ![image](https://github.com/user-attachments/assets/86ad8284-5da6-4048-91fe-ac20c8e4514a)
  ![image](https://github.com/user-attachments/assets/6bc671a5-c122-45c0-b1f0-f29999bbf751)
  ![image](https://github.com/user-attachments/assets/e748643a-e037-4d4c-a9be-944995979c60)

#
- <b>Now, go to <mark> Manage Jenkins --> credentials</mark> and add Sonarqube credentials:</b>
![image](https://github.com/user-attachments/assets/0688e105-2170-4c3f-87a3-128c1a05a0b8)
#
- <b>Go to <mark> Manage Jenkins --> Tools</mark> and search for SonarQube Scanner installations:</b>
![image](https://github.com/user-attachments/assets/2fdc1e56-f78c-43d2-914a-104ec2c8ea86)
#
- <b> Go to <mark> Manage Jenkins --> credentials</mark> and add Github credentials to push updated code from the pipeline:</b>
![image](https://github.com/user-attachments/assets/4d0c1a47-621e-4aa2-a0b1-71927fcdaef4)
> [!Note]
> While adding github credentials add Personal Access Token in the password field.
#
- <b>Go to <mark> Manage Jenkins --> System</mark> and search for SonarQube installations:</b>
![image](https://github.com/user-attachments/assets/ae866185-cb2b-4e83-825b-a125ec97243a)
#
- <b>Now again, Go to <mark> Manage Jenkins --> System</mark> and search for Global Trusted Pipeline Libraries:</b
![image](https://github.com/user-attachments/assets/874b2e03-49b9-4c26-9b0f-bd07ce70c0f1)
![image](https://github.com/user-attachments/assets/1ca83b43-ce85-4970-941d-9a819ce4ecfd)
#
- <b>Login to SonarQube server, go to <mark>Administration --> Webhook</mark> and click on create </b>
![image](https://github.com/user-attachments/assets/16527e72-6691-4fdf-a8d2-83dd27a085cb)
![image](https://github.com/user-attachments/assets/a8b45948-766a-49a4-b779-91ac3ce0443c)
#
- <b>Now, go to github repository and under <mark>Automations</mark> directory update the <mark>instance-id</mark> field on both the <mark>updatefrontendnew.sh updatebackendnew.sh</mark> with the k8s worker's instance id</b>
![image](https://github.com/user-attachments/assets/3cb044b4-df88-4d68-bf7c-775cf78d5bf2)
#
- <b>Navigate to <mark> Manage Jenkins --> credentials</mark> and add credentials for docker login to push docker image:</b>
![image](https://github.com/user-attachments/assets/1a8287fc-b205-4156-8342-3f660f15e8fa)
#
- <b>Create a <mark>Wanderlust-CI</mark> pipeline</b>
![image](https://github.com/user-attachments/assets/55c7b611-3c20-445f-a49c-7d779894e232)

#
- <b>Create one more pipeline <mark>Wanderlust-CD</mark></b>
![image](https://github.com/user-attachments/assets/23f84a93-901b-45e3-b4e8-a12cbed13986)
![image](https://github.com/user-attachments/assets/ac79f7e6-c02c-4431-bb3b-5c7489a93a63)
![image](https://github.com/user-attachments/assets/46a5937f-e06e-4265-ac0f-42543576a5cd)
#
- <b>Provide permission to docker socket so that docker build and push command do not fail (Jenkins Worker)</b>
```bash
chmod 777 /var/run/docker.sock
```
![image](https://github.com/user-attachments/assets/e231c62a-7adb-4335-b67e-480758713dbf)
#
- <b> Go to Master Machine and add our own eks cluster to argocd for application deployment using cli</b>
  - <b>Login to argoCD from CLI</b>
  ```bash
   argocd login 52.53.156.187:32738 --username admin
  ```
> [!Tip]
> 52.53.156.187:32738 --> This should be your argocd url

  ![image](https://github.com/user-attachments/assets/7d05e5ca-1a16-4054-a321-b99270ca0bf9)

  - <b>Check how many clusters are available in argocd </b>
  ```bash
  argocd cluster list
  ```
  ![image](https://github.com/user-attachments/assets/76fe7a45-e05c-422d-9652-bdaee02d630f)
  - <b>Get your cluster name</b>
  ```bash
  kubectl config get-contexts
  ```
  ![image](https://github.com/user-attachments/assets/4cab99aa-cef3-45f6-9150-05004c2f09f8)
  - <b>Add your cluster to argocd</b>
  ```bash
  argocd cluster add Wanderlust@wanderlust.us-west-1.eksctl.io --name wanderlust-eks-cluster
  ```
  > [!Tip]
  > Wanderlust@wanderlust.us-west-1.eksctl.io --> This should be your EKS Cluster Name.

  ![image](https://github.com/user-attachments/assets/0f36aafd-bab9-4ef8-ba5d-3eb56d850604)
  - <b> Once your cluster is added to argocd, go to argocd console <mark>Settings --> Clusters</mark> and verify it</b>
  ![image](https://github.com/user-attachments/assets/4490b632-19fd-4499-a341-fabf8488d13c)
#
- <b>Go to <mark>Settings --> Repositories</mark> and click on <mark>Connect repo</mark> </b>
![image](https://github.com/user-attachments/assets/cc8728e5-546b-4c46-bd4c-538f4cd6a63d)
![image](https://github.com/user-attachments/assets/eb3646e2-db84-4439-a11a-d4168080d9cc)
![image](https://github.com/user-attachments/assets/a07f8703-5ef3-4524-aaa7-39a139335eb7)
> [!Note]
> Connection should be successful

- <b>Now, go to <mark>Applications</mark> and click on <mark>New App</mark></b>

![image](https://github.com/user-attachments/assets/ec2d7a51-d78f-4947-a90b-258944ad59a2)

> [!Important]
> Make sure to click on the <mark>Auto-Create Namespace</mark> option while creating argocd application

![image](https://github.com/user-attachments/assets/55dcd3c2-5424-4efb-9bee-1c12bbf7f158)
![image](https://github.com/user-attachments/assets/3e2468ff-8cb2-4bda-a8cc-0742cd6d0cae)

- <b>Congratulations, your application is deployed on AWS EKS Cluster</b>
![image](https://github.com/user-attachments/assets/bc2d9680-fe00-49f9-81bf-93c5595c20cc)
![image](https://github.com/user-attachments/assets/1ea9d486-656e-40f1-804d-2651efb54cf6)
- <b>Open port 31000 and 31100 on worker node and Access it on browser</b>
```bash
<worker-public-ip>:31000
```
![image](https://github.com/user-attachments/assets/a4b2a4b4-e1aa-4b22-ac6b-f40003d0723a)
![image](https://github.com/user-attachments/assets/06f9f1c8-094d-4d9f-a9d8-256fb18a9ae4)
![image](https://github.com/user-attachments/assets/64394f90-8610-44c0-9f63-c3a21eb78f55)
- <b>Email Notification</b>
![image](https://github.com/user-attachments/assets/0ab1ef47-f939-4618-8651-6aa9274721f4)

#
## How to monitor EKS cluster, kubernetes components and workloads using prometheus and grafana via HELM (On Master machine)
- <p id="Monitor">Install Helm Chart</p>
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
```
```bash
chmod 700 get_helm.sh
```
```bash
./get_helm.sh
```

#
-  Add Helm Stable Charts for Your Local Client
```bash
helm repo add stable https://charts.helm.sh/stable
```

#
- Add Prometheus Helm Repository
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

#
- Create Prometheus Namespace
```bash
kubectl create namespace prometheus
```
```bash
kubectl get ns
```

#
- Install Prometheus using Helm
```bash
helm install stable prometheus-community/kube-prometheus-stack -n prometheus
```

#
- Verify prometheus installation
```bash
kubectl get pods -n prometheus
```

#
- Check the services file (svc) of the Prometheus
```bash
kubectl get svc -n prometheus
```

#
- Expose Prometheus and Grafana to the external world through Node Port
> [!Important]
> change it from Cluster IP to NodePort after changing make sure you save the file and open the assigned nodeport to the service.

```bash
kubectl edit svc stable-kube-prometheus-sta-prometheus -n prometheus
```
![image](https://github.com/user-attachments/assets/90f5dc11-23de-457d-bbcb-944da350152e)
![image](https://github.com/user-attachments/assets/ed94f40f-c1f9-4f50-a340-a68594856cc7)

#
- Verify service
```bash
kubectl get svc -n prometheus
```

#
- Now,let’s change the SVC file of the Grafana and expose it to the outer world
```bash
kubectl edit svc stable-grafana -n prometheus
```
![image](https://github.com/user-attachments/assets/4a2afc1f-deba-48da-831e-49a63e1a8fb6)

#
- Check grafana service
```bash
kubectl get svc -n prometheus
```

#
- Get a password for grafana
```bash
kubectl get secret --namespace prometheus stable-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
> [!Note]
> Username: admin

#
- Now, view the Dashboard in Grafana
![image](https://github.com/user-attachments/assets/d2e7ff2f-059d-48c4-92bb-9711943819c4)
![image](https://github.com/user-attachments/assets/3d6652d0-7795-4fe9-8919-f33eac88db73)
![image](https://github.com/user-attachments/assets/13321ee5-5d7b-4976-b409-25d3b865a42a)
![image](https://github.com/user-attachments/assets/75a22e4b-ae81-4cad-9c92-21dd90d126a8)

#
## Clean Up
- <b id="Clean">Delete eks cluster</b>
```bash
eksctl delete cluster --name=wanderlust --region=us-west-1
```

#
