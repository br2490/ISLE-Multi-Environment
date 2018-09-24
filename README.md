# ISLE Docker Multi-Environment Example Repo

Docker Image GitHub Repos that comprise this stack: 
 - [`isle-fedora`](https://github.com/Islandora-Collaboration-Group/isle-fedora/)
 - [`isle-solr`](https://github.com/Islandora-Collaboration-Group/isle-solr/)
 - [`isle-apache`](https://github.com/Islandora-Collaboration-Group/isle-apache/)
 - [`isle-imageservices`](https://github.com/Islandora-Collaboration-Group/isle-imageservices/)

## Requirements  
* Docker-CE or EE
* Docker-compose
* Git
* **Memory allocated of 8GB at the very minimum.**
* **Windows Users**: Please open the .env and uncomment `COMPOSE_CONVERT_WINDOWS_PATHS=1`

## Details and Anatomy of the Multi-Environment configuration
[Jump to the Quick Start](#quick-start) or [Jump to the Quick Start Scripts](#quick-start-scripts)

This Quick Guide and pre-configured repository will walk through creating a "multi-environment" setup that contains a development (dev), staging (stage), and production (prod) instance of ISLE.
You may remove or add as many additional instances to this configuration.  

This is the anatomy of multi-env (**nb:** this section only a explanation of the stacks. It is _not_ a guide to be followed.)
- Note well that in testing these _must_ be configured in your /etc/hosts files or they will not resolve.
  - /etc/hosts: `127.0.0.1 admin.isle.localdomain portainer.isle.localdomain isle.localdomain dev.isle.localdomain stage.isle.localdomain localhost`
  - On a production server adding a single A record for the base_domain with a wild-card CNAME pointing to that record should suffice.
- Create a single ingress-network (i.e., isle-external) for _all environments_ to use.  
  This is accomplished by executing: `docker network create isle-proxy`.  
  This tells docker to create a bridged network with the name **isle-proxy**. Note the name is arbitrary but it is used multiple times throughout, so take note.
- Create one (1) "master" ISLE-Proxy and ISLE-Portainer  
  Editing the .env allows us to specify the name of the ingress-network we created, and our **base domain**.
  - `docker-compose up -d` this master proxy and Portainer only once.
- For each environment (e.g., dev, stage, prod, etc.) copy the ISLE stack's **basic** docker-compose.yml and .env files to new directories.
  - Edit the .env file to do most of the work in these directories:
    - Specify the name of the ingress-network (**isle-proxy**), and create unique values for the project name, short id, and **base domain**.
    - Launch each environment, one-by-one, normally with `docker-compose up -d`.
    - Instantiate Islandora by running  `docker exec -it isle-apache-{CONTAINER_SHORT_ID} bash /utility-scripts/isle_drupal_build_tools/isle_islandora_installer.sh`
- Note well that only ISLE-Apache in the environments are added to the isle-external network by default.  
  **DO NOT EXPOSE OTHER COMPONENTS TO THE INGRESS NETWORK**
  - For example:
    - In .env our BASE_DOMAIN is `dev.isle.localdomain`
    - Change the port mapping to unique values (e.g., for `dev` this is 8380, 8381, 8382; `stage` this is 8280, 8281, 8283; etc.)
    - The site is available at: http://dev.isle.localdomain
    - Fedora is available at: http://localhost:8380
    - Solr is available at: http://localhost:8381
    - Image-Services are available at: http://localhost:8382/adore-djatoka, http://localhost:8382/cantaloupe/admin

## Quick Start Scripts
**This section is currently only available for Linux/Mac users.**
- Startup:
1. Edit your /etc/hosts or equivalent
`127.0.0.1 admin.isle.localdomain portainer.isle.localdomain isle.localdomain dev.isle.localdomain stage.isle.localdomain localhost`
2. Clone this repo 
    - `git clone https://github.com/Islandora-Collaboration-Group/ISLE-Multi-Environment.git` 
3. Run `quick-start.sh` on nix/Mac environments.
    - `chmod +x quick-start.sh`
    - `./quick-start.sh`
4. See step 12 of [Quick Start](#quick-start) to remove an environment
5. Skip to [Locations, Ports](#locations-ports)

- Shutdown:
1. Run `quick-stop.sh` on nix/Mac environments.
    - `chmod +x quick-stop.sh`
    - `./quick-stop.sh`

## Quick Start
1. Edit your /etc/hosts or equivalent
`127.0.0.1 admin.isle.localdomain portainer.isle.localdomain isle.localdomain dev.isle.localdomain stage.isle.localdomain localhost`
2. Create the proxy that all images will connect to: 
    - `docker network create isle-proxy`
3. Clone this repo 
    - `git clone https://github.com/Islandora-Collaboration-Group/ISLE-Multi-Environment.git` 
4. Change directory to the cloned directory:
    - `cd ISLE-Multi-Environment` (by default)
5. Pull the latest Traefik (proxy) and Portainer images:
    - `docker-compose pull`
**Windows Users**: Please open the .env and uncomment `COMPOSE_CONVERT_WINDOWS_PATHS=1`  
6. Start the master ISLE-Proxy and Portainer instances:
    - `docker-compose up -d`  
* For the first environment:
7. Change to environment's directory (e.g. dev):
    - `cd dev`
8. Pull the latest ISLE images:
    - `docker-compose pull`
9. Launch the environment:
    - `docker-compose up -d`  
* For the remaining environments:
10. Change to environment's directory and launch the environment:
    * Assuming we're still in the dev environment's folder 
    - `cd ../stage`
    - `docker-compose up -d`
    - `cd ../prod`
    - `docker-compose up -d`
    - etc.  
* For **ALL** environments:
11. Instantiate Islandora on the respective ISLE-apache containers:
    - Note you are running this for each environment, and will need to replace the name of the container:
    - Where CONTAINER_SHORT_ID in this repository's example is `dev`, `stage`, and `prod`
    - `docker exec -it isle-apache-{CONTAINER_SHORT_ID} bash /utility-scripts/isle_drupal_build_tools/isle_islandora_installer.sh`
* Removing Environment(s)
12. To remove an environment:
    - In the folder of the environment to destroy (contains docker-compose.yml): `docker-compose down -v`
13. To remove the master Proxy and Portainer
    - In the main folder (contains docker-compose.yml): `docker-compose down -v`
14. To remove the Ingress `proxy` network:
    - `docker network rm proxy`


**Visit http://portainer.isle.localdomain to review the running stacks, logs, etc.**

## Important Notes, Ports, Pages and Usernames/Passwords
@SEE: https://github.com/Islandora-Collaboration-Group/ISLE  
[Portainer](https://portainer.io/) is a GUI for managing Docker containers. It has been built into ISLE for your convenience.  
**Windows Users**: Please open the .env and uncomment `COMPOSE_CONVERT_WINDOWS_PATHS=1`  
**Note that both HTTP and HTTPS work** Please accept the self-signed certificate for testing when using HTTPS.

### Locations, Ports:
* Make sure your /etc/hosts contains `127.0.0.1 admin.isle.localdomain portainer.isle.localdomain isle.localdomain dev.isle.localdomain stage.isle.localdomain localhost`. See original docs on how-to.

**Administrative Portals**  
* Traefik is available at http://admin.isle.localdomain
* Portainer is available at http://portainer.isle.localdomain

**Development Environment**  
* Islandora is available at http://dev.isle.localdomain
* Fedora is available at http://localhost:8280/
* Solr is available at http://localhost:8281/
* ImageServices are available at http://localhost:8282/

**Staging Environment**  
* Islandora is available at http://stage.isle.localdomain
* Fedora is available at http://localhost:8180/
* Solr is available at http://localhost:8181/
* ImageServices are available at http://localhost:8182/

**Production Environment**  
* Islandora is available at http://isle.localdomain
* Fedora is available at http://localhost:8080/
* Solr is available at http://localhost:8081/
* ImageServices are available at http://localhost:8082/

### Users and Passwords
Read as username:password

Islandora (Drupal) user and pass (default):
 * `isle`:`isle`

All Tomcat services come with the default users and passwords:
* `admin`:`isle_admin`
* `manager`:`isle_manager`

Portainer's authentication can be configured: 
* By default there is no username or password required to login to Portainer.
* [Portainer Configuration](https://portainer.readthedocs.io/en/stable/configuration.html)
