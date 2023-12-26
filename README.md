Install packer and run this:
```
$ packer init debian12.pkr.hcl
$ packer build --var-file=nuc.pkrvars.hcl debian12.pkr.hcl
```
This will create a DEBIAN12 template.

```
$ packer init ubuntu2204.pkr.hcl
$ packer build --var-file=nuc.pkrvars.hcl ubuntu2204.pkr.hcl
```
This will create a UBUNTU2204 template.

Where ~/nuc.pkrvars.hcl is:
```
proxmox_url      = "https://nuc.hasiotis.loc:8006/"
proxmox_node     = "nuc"
proxmox_username = "root@pam"
proxmox_password = "YOUR_PASSWORD"
```
