# rTorrent Handbook

[![Documentation Status](https://readthedocs.org/projects/rtorrent-docs/badge/?version=latest)](http://rtorrent-docs.readthedocs.io/en/latest/?badge=latest)

This is the handbook for the [rTorrent](https://github.com/rakshasa/rtorrent/wiki)
bittorrent client, written by and for the community.

See also the [homepage](https://rtorrent-community.github.io/) of the community project
and the [community wiki](https://github.com/rtorrent-community/rtorrent-community.github.io/wiki).

:copyright: | The content in this repository is licensed [CC-BY-SA-4.0](https://creativecommons.org/licenses/by-sa/4.0/). By contributing, you grant this project and its members the right to publish your contribution under the terms of that license.
---: | :---


## How to build the handbook locally

First, create a working directory for the project:

```sh
git clone "https://github.com/rtorrent-community/rtorrent-docs.git"
cd rtorrent-docs
./bootstrap.sh && source .env
```

Then to start the build watchdog, call ``invoke docs``.
Stop the watchdog using ``invoke stop``.
The documentation is available at http://localhost:8340/.
