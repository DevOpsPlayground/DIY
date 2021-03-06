<p align="center">
<img src=../../README_images/go_logo.jpeg width="400">
</p>

<h1 align="center">Welcome to the October playground! Hands on with Ansible</h1>

[The Playground link](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019.git)

# Intro

Hello and welcome to the October playground DIY.


Let's go!

# Check Before You Start!

We will be building the required infrastructure using Terraform so if you do not have this currently installed please [visit the Hashicorp website](https://learn.hashicorp.com/tutorials/terraform/install-cli) for how to do this.

**All infrastructure will require an AWS account so please make sure you have run through the installation process for AWS CLI and AWS config in the [root README.md file](../../README.md)**

## Important:

Before we get started there are a few things that are worth noting. We have set the defaults to a number of variables that can be changed within the `variables.tf` file if required:

* The current code will build two EC2 instances one for a workstation and a second for the ansible remote host.
* The workstation instance and remote host will run two containers. One with the project directory uploaded and wetty installed allowing SSH from the web. The other has VS Code installed providing a text editor to amend and save changed code. 
* If you prefer to use VIM then you can ! If not, you can use the VS Code IDE.
* If you have your own hosted zone set up in Route53 then you can use your own domain for each instance rather than the IPs. To do this uncomment lines `51-67` in `main.tf`, lines `25-31` in `outputs.tf` and lines `23-27` in `variables.tf`
* The default `region` is set to `eu-west-2`
* The default `deploy_count` is set to 1. Change this if you are running the playground for more than one user.
* The default `instance_type` is set to `t2.medium` as the t2.micro does not have enough resource to efficiently run the workstation. This on-demand pricing is $0.0464 per hour (£0.034 per hour) per instance. Should you leave this running for 1 month (720 hours), you would be charged $33.63 (£24.48) per instance. **make sure you delete the instance when finished with the playground!**

# Build Infrastructure

Make sure you are in the `October_2019` directory and run:

```
$ terraform init
```  
This will initialise a working directory containing our Terraform configuration files. This command is always safe to run multiple times, to bring the working directory up to date with changes in the configuration. You should see the following:

<p align="center">
<img src=../../README_images/tf_init.png width="600">
</p>

Then run:
```
$ terraform plan
```

This command is used to create an execution plan. Terraform performs a refresh, unless explicitly disabled, and then determines what actions are necessary to achieve the desired state specified in the configuration files.

This command is a convenient way to check whether the execution plan for a set of changes matches your expectations without making any changes to real resources or to the state. For example, terraform plan might be run before committing a change to version control, to create confidence that it will behave as expected. The plan will be fairly long but if all went well you should see the following in your terminal:

<p align="center">
<img src=../../README_images/oct-19-plan.png width="600">
</p>

Finally you need to run:
```
$ terraform apply
```

This command is used to apply the changes required to reach the desired state of the configuration, or the pre-determined set of actions generated by a terraform plan execution plan. You will be prompted to enter a value to perform the action. Type `yes` as the value and hit enter.

Terraform will now build our required AWS infrastructure. This should complete after a minute or so showing the following:

<p align="center">
<img src=../../README_images/oct-19-apply.png width="600">
</p>

> IMPORTANT! - make a note of the `WorkstationPassword` and `RemoteHostPassword` as these are auto-generated and will only be shown once. If lost you may need to build your instances again.

Once the apply has completed your EC2 instance(s) will now be initialising and running the required script(s). Once the `instances state` have changed to `Running` they may take a further 4/5 minutes to install all the required dependencies. 

## Access

To access your instances check outputs in terminal after running `terraform apply`:

* Workstation instance - <workstation_ip>/wetty e.g. 318.130.177.57/wetty
* Remote Host instance - <remote_host_ip>/wetty e.g. 318.131.177.57/wetty
browser e.g. 18.130.177.57:3000/wetty
* IDE access - <workstation_ip>:8000 in browser e.g. 318.130.177.57:8000
* Workstation password - provided at the end of terraform apply
* Remote Host password - provided at the end of terraform apply
# Ansible Hands On
### Our task: Create a real-world LAMP stack for development and deploy Wordpress app using Ansible
## Summary:

[Let's](#lets-start "Goto Let's start")

[1. Install Ansible](#step-1-install-ansible "Goto Step 1. Install Ansible")

[2. SSH Access to the remote host](#step-2-configuring-passwordless-ssh-access-to-the-remote-host "Goto Step 2. Configuring passwordless SSH Access to the remote host")

[3. Connectivity with the host](#step-3-lets-check-out-the-connectivity-with-the-host "Goto Step 3. Let's check out the connectivity with the host")

[4. Ansible hostfile and configuration file](#step-4-ansible-hostfile-and-configuration-file "Goto Step 4. Ansible Hostfile and configuration file")

[5. Simple playbook](#step-5-write-a-simple-playbook "Goto Step 5. Write a simple playbook")

[6. Run the playbook](#step-6-run-the-playbook "Goto Step 6. Run the playbook")

[7. Build a LAMP stack and deploy Wordpress](#step-7-build-a-lamp-stack-and-deploy-wordpress "Goto Step 7. Build a LAMP stack and deploy Wordpress")

[8. Playbook basics](#8-playbook-basics "Goto 8. Playbook basics")

[9. Notes](#9-notes "Goto 9. Notes")

[10. References](#10-references "Goto 10. References")

-----
### Let's start

1. Open up the `<WORKSTATION_IP>/wetty/` 

2. Use the workstation password provided within the terraform outputs to login.

3. Type some shell commands to get familiar with the web terminal.
   From now on we will be working from the browsers only.

4. Without changing machine, (you are in your workstation instance), set up some ENVIRONMENT variables that you will use later. 

We'll append two useful env vars to your .profile, as follows
- Remote Host IP and Remote Host Password are outputted in the terminal after apply enter these values below. 
- for the password surround it in quotes e.g. `export PASSWORD='password123'`

```bash
cat << EOF >> ~/.profile
export REMOTE_HOST=REMOTE_HOST_IP
export PASSWORD=remote_host_password
cd ~/workdir/Hands-on-with-Ansible-Oct-2019/playbook/roles
EOF
```

but substituting the IP address and password of your  machine: This will be the `remote_host_ip` from your terraform apply and the `remote_host_password` outputs, e.g. "18.133.245.208" and "playground" 

```bash
cat << EOF >> ~/.profile
export REMOTE_HOST=52.51.15.91
export PASSWORD=mySecret
cd ~/workdir//Hands-on-with-Ansible-Oct-2019/playbook/roles
EOF

# then 
source ~/.profile
```
After this change log out `exit` and log back in with your workstation password and verify that your session has the environment variables.

```bash
echo $REMOTE_HOST, $PASSWORD
52.51.15.91, Ansible     # You will see something like this

```
-----
## Step 1. Install Ansible

Check whether Ansible is installed by running:

Ansible is installed during the creation of the instances but just in case run the following command. 

```bash
ansible --version  
ansible 2.8.6       # If Ansible is installed you will see something like this
...
```

If for some reason it isn't installed run the following:

```bash
sudo apt update     #  (respond with your password at the `[sudo] password for playground:` prompt)
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

```bash
ansible --version
```

Now all should be working as expected.

## Step 2. Configuring passwordless SSH Access to the remote host

Run the following command from your `workstation`.

```bash
cd ~/Hands-on-with-Ansible-Oct-2019
./setup.sh $REMOTE_HOST
```
You should see output something like the following:

![Output1](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/images/Screenshot%202019-10-21%20at%2023.57.21.png)

Answer yes to this question, then the process should continue something like the following:

![Output2](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/images/Screenshot%202019-10-22%20at%2000.01.24.png)

## Step 3. Let's check out the connectivity with the host

Run the following to ping the remote host.

And, yes! That `comma` is right in its place! It tells ansible that there is only that one host in your inline inventory.

```bash
ansible all -i "$REMOTE_HOST," -m ping
```

 Or check its memory and disk space:

```bash
ansible all -i "$REMOTE_HOST," -m shell -a 'free -m && df -h'
```

What we did just now was to run ansible `ad-hoc commands` on our remote host. [Let's explore ad-hoc commands :panda_face:](https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html)

## Step 4. Ansible Hostfile and configuration file

Let's  create the inventory of hosts and Ansible configuration file at the root of our project. Run:

```bash
./inventory_and_config.sh $REMOTE_HOST
```

Let's take a look what those two files look like for us:

```bash
cat playbook/inventory
# you should see something like:
[lamp]
lampstack ansible_host=52.214.226.94 ansible_become_pass=my_pass
```

Ansible has a `default inventory` and a `default configuration file`. Let's explore them as examples :panda_face:

```bash
less /etc/ansible/hosts
```

and

```bash
less /etc/ansible/ansible.cfg
```

## Step 5. Write a simple playbook

We will put together a simple playbook to update our remote host, and check its memory and disk space. The first time around we did this using ad-hoc commands but this time we will transform them into a playbook file. We can now store this in version control, we can let other systems check it out and run it as many times as we want.
Create a file `update.yml`

```bash
# in ~/Hands-on-with-Ansible-Oct-2019

vi update.yml
```

and paste the following. Careful with the spaces - YAML is fussy!

```YAML
---
- hosts: lamp
  remote_user: playground
  become: yes

  tasks:
    - name: Update all packages on a Debian/Ubuntu
      apt:
        update_cache: yes
        upgrade: dist
        force_apt_get: yes

    - name: Check disk space and memory
      shell: free -m && df -h
```

### Tip!

What if we don't have access to the documentation in the web? Ansible ships with the `ansible-doc` tool. We can access the documentation from the command line.

```bash
ansible-doc apt
```

Explore the output in the command line :panda_face:

It starts like this:
![ansible-doc apt output](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/images/Screenshot%202019-10-22%20at%2012.36.18.png)

## Step 6. Run the playbook

```bash
ansible-playbook -i playbook/inventory update.yml
```

### Success! :+1: :+1: :+1:

You should see something similar:
![Result](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/images/Screenshot%202019-10-20%20at%2018.49.34.png)

## Step 7. Build a LAMP stack and deploy Wordpress

We will now look at how to write a LAMP stack playbook using the features offered by Ansible.

The directory, where all our playbook files will live, has already been created for you. Unsurprisingly it is called `playbook`. But you can name it according to what its purpose is. It will become a good mnemonic for you.

Here is the high-level hierarchy structure of the playbook:

```YAML
- name: LAMP stack setup and Wordpress installation on Ubuntu 18.04
  hosts: lamp
  remote_user: "{{ remote_username }}"
  become: yes
  
  roles:
    - role: common
    - role: webserver
    - role: db
    - role: php
    - role: wordpress
```

Before we start, take a look at the directory structure of a fully fledged playbook. Click here:
[Playbook directory structure](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/hierarchy_structure.md#hierarchy-structure-of-playbook). This is what we are aiming for ;-)

To save time, I have already created some roles for you. Go back to the Web Terminal of your `workstation`.

### Step 7.1 The Webserver Role

We will now write a Role to install and configure the Apache2 server.

#### 7.1.1 Install, configure and start apache2

First thing first - we'll install Apache2. Create the folder structure for the tasks:

```bash
cd playbook/roles     # if you haven't already :-)
mkdir -p webserver/tasks && vi webserver/tasks/main.yml
```

The following code will tell our Ansible to install Apache2 and configure it. It'll also add Apache2 to the startup service.

```YAML
- name: install apache2 server
  apt:
    name: apache2
    state: present
    force_apt_get: yes

- name: set the apache2 port to 8080
  template:
    src: web.port.j2
    dest: /etc/apache2/ports.conf
    owner: root
    group: root
    mode: 0644

- name: update the apache2 server configuration
  template:
    src: web.conf.j2
    dest: /etc/apache2/sites-available/000-default.conf
    owner: root
    group: root
    mode: 0644

- name: enable apache2 on startup
  systemd:
    name: apache2
    enabled: yes
  notify:
    - start apache2
```

Let's discuss what this task file is doing.
Hint: Use the `ansible-doc` command to help you. Example: `ansible-doc systemd`.

Did you spot the `notify` parameter at the end of the file? What you see listed as a parameter of the notify is the name of a `handler`. [Let's explore handlers :panda_face:](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html#handlers-running-operations-on-change)

Something interesting is going on here. The `handlers` are just another set of tasks, for example, `start apache2`, that will trigger a process only if they get `notified`. They get `notified` only if anything changes after the playbook has run. Another interesting fact is that, regardless of how many tasks throughout the playbook `notify` that particular `handler`, the process of restarting apache2 will be triggered only once. Time and resources saving!

Ok, let's create the handlers now.

#### 7.1.2 Handling apache2 start

In `webserver/handlers/` create `main.yaml`

```bash
# in ~/Hands-on-with-Ansible-Oct-2019/playbook/roles

mkdir -p webserver/handlers && vi webserver/handlers/main.yaml
```

and paste there the following:

```YAML
- name: start apache2
  systemd:
    state: started
    name: apache2

- name: stop apache2
  systemd:
    state: stopped
    name: apache2

- name: restart apache2
  systemd:
    state: restarted
    name: apache2
    daemon_reload: yes
```

##### What is  [Idempotence](https://en.wikipedia.org/wiki/Idempotence)? :panda_face:

#### 7.1.3 Templating

We need to configure our Apache server. For this purpose we will use the `template` module.
[Let's explore templates :panda_face:](https://docs.ansible.com/ansible/2.5/modules/template_module.html#template-templates-a-file-out-to-a-remote-server)

Ansible templates leverage the powerful and widely adopted Jinja2 templating language. Let's go ahead and create two templates in this location -> `webserver/templates`.

```bash
# in ~/Hands-on-with-Ansible-Oct-2019/playbook/roles

mkdir -p webserver/templates/ && vi webserver/templates/web.port.j2
```

Paste

```XML
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 8080

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
````

Then

```bash
# in ~/workdir/Hands-on-with-Ansible-Oct-2019/playbook/roles

vi webserver/templates/web.conf.j2
```

Paste:

```XML
<VirtualHost *:8080>
    ServerAdmin {{server_admin_email}}
    DocumentRoot {{server_document_root}}
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Our template is using variables that will be replaced with their values, at the time we run the playbook, and then sent off to the remote server.
Where is a good place to define variables? [Let's explore defining variables :panda_face:](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#defining-variables-in-included-files-and-roles)

These variables belong to the `webserver` role. Their place is in a designed for the purpose location `webserver/vars/main.yml`:

```bash
# in ~/Hands-on-with-Ansible-Oct-2019/playbook/roles

mkdir -p webserver/vars && vi webserver/vars/main.yml
```

Paste:

```YAML
server_admin_email: playground@localhost.local
server_document_root: /var/www/html
```

#### Tip! Check your [playbook directory structure](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/hierarchy_structure.md#hierarchy-structure-of-playbook) is correct!

### And now let's create and run our playbook

Do you remember the YAML that was showing high-level structure of a playbook? Let's create it.

```bash
cd .. && vi site.yml

# We are now back in playbook/
```

Paste:

```YAML
- name: LAMP stack setup and Wordpress installation on Ubuntu 18.04
  hosts: lamp
  remote_user: "{{ remote_username }}"
  become: yes
  
  roles:
    - role: common
    - role: webserver
    - role: db
    - role: php
    - role: wordpress
```

Let' set our remote user globally:

```bash
# in ~/Hands-on-with-Ansible-Oct-2019/playbook

echo remote_username: "playground" > group_vars/lamp.yml
```

#### You may want to check last time the  [playbook directory structure](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/hierarchy_structure.md#hierarchy-structure-of-playbook#hierarchy-structure-of-playbook)

### And now run the playbook!

```bash
ansible-playbook -i inventory site.yml
```

Success! :+1: :+1: :+1:

#### Go to `<remote_host_ip>:8080/wordpress e.g`. `3.10.154.170:8080/wordpress`

You should see:

![Wordpress welcome page](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/images/Screenshot%202019-10-19%20at%2013.23.54.png)

## 8. Playbook basics

### 8.1 How can we abbreviate the command we ran above?

Let's tell Ansible where we want it to look up the inventory.

```bash
# in ~/Hands-on-with-Ansible-Oct-2019/playbook

echo -e "inventory = inventory" >> ansible.cfg
```

Now run the playbook like this:

```bash
ansible-playbook site.yml
```

### 8.2 Linting

We can use the linter that comes with Ansible to catch bugs and stylistic errors. Especially helpful for those that start with Ansible but handy for experts as well.
Let's pull the linter down now:

```bash
sudo apt install ansible-lint
```

Run

```bash
ansible-lint site.yml
```

And watch the linter complain!

### 8.3 Dry-run

When ansible-playbook is executed with --check it will not make any changes on remote systems. Instead it will try to predict what changes it would make. This works great with `--diff` when you make small changes to files or templates.

```bash
ansible-playbook site.yml --check --diff
```

### 8.4 Tags

Playbooks can easily become large and can run for long time. We don't want to watch them rerun in their entirety every time we make a change to a task. How can we save time and run only what we are interested in? [Let's explore tags :panda_face:](https://docs.ansible.com/ansible/latest/user_guide/playbooks_tags.html)

```bash
vi site.yml
```

Delete all the contents in the file and paste the following.

```YAML
- name: LAMP stack setup and Wordpress installation on Ubuntu 18.04
  hosts: lamp
  remote_user: "{{ remote_username }}"
  become: yes
  
  roles:
    - role: common
    - role: webserver
      tags: [web]
    - role: db
      tags: [db]
    - role: php
    - role: wordpress
      tags: [wp, db]
```

Now run your playbook in the following mode:

```bash
ansible-playbook site.yml --tags=web
```

#### Hint! We placed `tags` on roles, but we can be more granular and tag any task in the playbook. If you have time, modify a task file to bear a tag with your name. Then rerun the playbook with your tag to see only that task being played.

### 8.5 Enable Debug and Increase Verbosity

[Let's explore ways to debug :panda_face:](https://docs.ansible.com/ansible/latest/user_guide/playbooks_debugger.html)

#### Break the playbook

```bash
# in ~/Hands-on-with-Ansible-Oct-2019/playbook

vi roles/webserver/tasks/main.yml
```

Change the name of the package as shown:

![Wrong package](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/images/Screenshot%202019-10-22%20at%2015.34.10.png)

#### Run the debugger

```bash
ANSIBLE_STRATEGY=debug ansible-playbook site.yml --tags=web
```

This setting will trigger the debugger at any failed or unreachable task, unless specifically disabled.

The `-v` gives us a more detailed output for connection debugging. Ansible is rich with feedback data. Try running the same command but with `-vv` or even `-vvv`.

You will see:

![Debug message](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/images/Screenshot%202019-10-22%20at%2015.55.20.png)

```bash
# in [lampstack] TASK: webserver : install apache2 server (debug)>
# type:

p task.args
```

you will see the following:

![output](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/images/Screenshot%202019-10-22%20at%2016.07.10.png)

Let's fix the error on the fly:

```bash
# in [lampstack] TASK: webserver : install apache2 server (debug)>
# type:

 task.args['name'] = 'apache2'
```

output
![Output](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/images/Screenshot%202019-10-22%20at%2013.41.58.png)

and then run again the failed task

```bash
# in [lampstack] TASK: webserver : install apache2 server (debug)>
# type:

redo
```

![Redo](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/images/Screenshot%202019-10-22%20at%2013.43.08.png)

#### Success! :+1: :+1: :+1:

### Don't forget to fix the error in the file, once you are happy with your solution.

#### Bonus

The `-v` gives us a more detailed output for connection debugging. Ansible is rich with feedback data. Try running the same command but with `-vv` or even `-vvv`.

```bash
ANSIBLE_STRATEGY=debug ansible-playbook site.yml --tags=web -v
```

## 9. Notes

If you want to create the LAMP stack playbook from scratch, [here](https://github.com/DevOpsPlayground/Hands-on-with-Ansible-Oct-2019/blob/master/step_by_step/LAMP_stack_step_by_step.md#ansible-hands-on).

## 10. References

Some materials were adopted from this cool book:

[Security Automation with Ansible 2: Leverage Ansible 2 to Automate Complex Security Tasks Like Application Security, Network Security, and Malware Analysis](https://g.co/kgs/xbJUnr)

## Thanks for participating!

## Clean up

**Once you have finished playing around remember to delete the infrastructure to avoid any additional running charges as mentioned**

Make sure you are in the `May_2020` directory and run the following command:
```
$ terraform destroy
```
The command does exactly what it says on the tin. Infrastructure managed by Terraform will be destroyed. This will ask for confirmation before destroying, so please type `yes` when prompted.

**Again, you will continue to be charged by AWS if you do not run this final step**


