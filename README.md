# Linokku
A CLI to roll new Linode servers, install Dokku, and manage deployed apps.

``` shell
linokku roll                      # provisions server and displays host ip
linokku install REMOTE_IP         # configures dokku on host server

linokku setup REMOTE_IP APP_NAME DOMAIN

git push APP_NAME
```

In four steps, linokku sets up a [Heroku][heroku]-like service, [Dokku][dokku],
hosted on a [Linode][linode] server and configures everything under the covers.

The `linokku setup` will add a new remote to the git repository in the current
working directory. The name of the remote will be the value of `APP_NAME`, and
will be used for subsequent pushes, i.e. `git push APP_NAME`. 

`linokku` supports deploying multiple apps to a single host, e.g.
`api.example.com`, `mob-feed.example.com`, `auth.example.com` could all be
seperately deployed applications on one server.

## Motivation
Dockerfiles provide an excellent way to standardize run-time environments,
independent of host machines. Deploying non-public Dockerfiles [can be
complicated][private-repo], but services such as [Heroku][heroku] step in to
make integrating with private Dockerfile-based repos incredibly simple. Heroku
is a popular way of deploying applications due to its ease, and inspired the
creation of [Dokku][dokku]. 

Heroku comes with many drawbacks when optimizing for [cost][heroku-price] and
[availability][heroku-sleep] compared to "DIY" hosting providers like
[Linode][linode] and DigitalOcean. Like Heroku, Dokku allows for local
deployment to servers, however Dokku must be configured on a host server before
use.

`linokku` merges the affordable and accessible Linode platform with Dokku to
create a four-step process for deploying an app to the cloud starting from only
a local Docker repository. Multiple containerized apps can be run on a single
host with individual domains handled by [Dokku's proxy][dokku-proxy].

[dokku]: https://dokku.com
[heroku]: https://heroku.com
[linode]: https://linode.com
[private-repo]: https://www.digitalocean.com/community/tutorials/how-to-set-up-a-private-docker-registry-on-ubuntu-20-04
[heroku-price]: https://blog.back4app.com/heroku-pricing/
[heroku-sleep]: https://devcenter.heroku.com/articles/free-dyno-hours
[dokku-proxy]: https://dokku.com/docs/networking/proxy-management/
