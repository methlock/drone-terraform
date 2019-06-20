# drone-terraform
*Drone.io CI/CD tool setup with terraform and DigitalOcean*


Prerequisites
-
1. Terraform - https://learn.hashicorp.com/terraform/getting-started/install.html
2. Domain or subdomain for your drone server.
    - It is better to link this domain to FloatingIP and then to server droplet.
3. DigitalOcean account
4. Drone GitHub app - step number 1 in https://docs.drone.io/installation/github/single-machine/


Usage
-
When your `terraform.tfvars` are correctly filled, you can type `terraform plan`
in console, which will preview your changes to infrastructure and then
`terraform apply` which actually make this changes.


Additional info
-
Don't forget fill drone admin username and drone users filter in `setup_drone_server.sh.tpl`.
Or remove this lines if you don't care... 

There are also two things in setup, which you probably don't need.
1. DigitalOcean Volume attached to drone server.
    - Drone database is mounted from there. It is useful, when need to make
      significant changes to drone server. So you make a snapshot of that
      volume and then attach it to new server = no drone data loss (repos, build history, ...)    
2. Drone server plugin for trigger when some file changes.
    - This can be useful when you have build step in your pipeline, but you
      wanna trigger this step only when some files are changed, eg. Dockerfile or requirements.