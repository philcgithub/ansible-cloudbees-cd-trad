# ansible-cloudbees-cd-trad

## Table of Contents ##

1. [Introduction](#Introduction)
2. [Preparing to run the playbooks](#Preparing-to-run-the-playbooks)

  - [1. Set the variables](#1.-Set-the-variables)
  - [2. Supply required files](#2.-Supply-required-files)
  - [3. Prepare the inventory file](#3.-Prepare-the-inventory-file)
  - [4. Prepare the environment](#4.-Prepare-the-environment)

3. [Running the playbooks](#Running-the-playbooks)
## Introduction ##
These playbooks are for installing and upgrading CloudBees CD for Traditional.

It currently only installs the Express Server (builtin MariaDB database) and Analytics.

The upgrade playbook has not been tested and will most likely need some changes.

There is currently a single role defined:

- cdserver

And this role contains several playbooks:

- install_cd_express.yaml (Installs CloudBees CD Express Servers, wait for initial startup to complete, and sets admin password)
- install_cd_ext_mysql (Installs CloudBees CD connecting to an external mysql database, sets password and imports license if supplied)
- install_analytics.yaml (Installs the Analytics component)
- letsencrypt_certs.yaml (obtains a set of valid certs using letsencrypt and deploys them to the Apache config, also setting up auto renew)
- main.yaml (a default main file calling all the contained playbooks)
- setup_env.yaml (create OS user and make sure it can run the installers using sudo)

## Preparing to run the playbooks ##

### 1. Set the variables ###

Set the variables in the cdserver role (vars/main.yaml) as appropriate.

### 2. Supply required files ###

If running any of the playbooks except express, you may need to supply the following files (under roles/cdserver/files):

- license.xml (A CloudBees CD license file supplied by CloudBees)
- mysql-connector-java-8.0.22.jar (A mysql connector jar file)
### 3. Prepare the inventory file ###

The playbooks assume you already have a single vm ready to install CloudBees CD Express Server on to.  Modify the line in the inventory.txt file to match your vm instance:

```ini
cdserver ansible_host=12.345.678.901 ansible_connection=ssh ansible_user=phil ansible_ssh_private_key_file="~/id_rsa"
```

### 4. Prepare the environment ###

Use ssh-agent and ssh-add so you don't need to enter the SSH key passphrase during execution (which is unreliable with Ansible).

```bash
eval "$(ssh-agent -s)"
ssh-add "/Users/phil/Google Drive/Keys/GCE SSH Key/id_rsa"
```

## Running the playbooks ##

Install CloudBees CD Express Server, Analytics and obtain valid certs:

```bash
ansible-playbook install_express_server.yaml --extra-vars 'files_yaml=../ansible-cloudbees-cd-trad-priv/cbcd-preview/vars.yaml' -i inventory.txt
```

If you just want to obtain valid certs from an existing system:

```bash
ansible-playbook certsonly.yaml -i inventory.txt --extra-vars 'files_yaml=../ansible-cloudbees-cd-trad-priv/cbcd-preview/vars.yaml' -i inventory.txt
```
