Install packer and run this:
```
$ packer build -var-file ~/.packer-home.hcl debian11.json
```
This will create a DEBIAN10 template.

Where ~/.packer-home.hcl is:
```
{
    "url": "https://pve.hasiotis.loc:8006/",
    "username": "root@pam",
    "password": "YOUR_PASSWORD",
    "storage_pool": "local-lvm"
}
```
