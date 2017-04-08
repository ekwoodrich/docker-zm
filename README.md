# docker-zm
A docker image for Zoneminder 1.30.2 based on Ubuntu 16.04, which fixes common hangups with Zoneminder and Ubuntu out of the box. 

## Howto
Just run the Docker container with the command:

```
~/docker run -d --shm-size=4096m -p 80 -p 443 ekwoodrich/docker-zm
```

The id of the container will be output to the terminal, which can be used to access a root shell for the Docker image:

```
~/docker exec -it [container_id] /bin/bash
```

e.g verify zoneminder is running:

'''
~/service zoneminder status
running
'''


##Enjoy!
