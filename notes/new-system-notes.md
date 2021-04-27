```
sudo eopkg it -c system.devel
```

# docker 

```
sudo groupadd docker
sudo usermod -aG docker ${USER}
# logout => login
- copy over ~/.docker dir

# cd to xq dir
make pull-pkgs
```

## gcloud

install the google [cloud sdk sdk]( https://cloud.google.com/sdk/docs/downloads-versioned-archives )
establish login credentials

```
gcloud auth login
gcloud compute project-info describe
# gcloud compute instances create instance-name --metadata enable-oslogin=FALSE
# gcloud compute project-info add-metadata --metadata-from-file ssh-keys=./.secrets/gcloud_ssh_keys
```
https://cloud.google.com/compute/docs/instances/managing-instance-access

Google compute engine.
- copy '~/.ssh' dir from old-home  
- check you can login to ssh login to instance
- create a bash login alias `alias SSH='gcloud compute ssh gmack@gmack'

## git, github and gh client


