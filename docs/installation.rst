Installation Guide
==================

This chapter has some pointers to common ways of installing
*rTorrent* on your machine
– and in many cases, also ruTorrent and other related apps and services.
It does not provide yet another way to do that,
because there already are plentiful and redundant sources out there.


Installation Using OS Packages
------------------------------

While installing using pre-compiled packages is the easiest way
to get a working *rTorrent* executable onto your system,
it has the unfortunate side-effect that quite often these packages
contain a rather outdated version of it.

You might want to look in the “testing” or “experimental” repositories
of your distribution, or alternatively install from source (see below).

 * The `rTorrent wiki <https://github.com/rakshasa/rtorrent/wiki#packages>`_ lists package names and installation commands for a lot of *Linux* distributions and other operating systems.
 * DEB packages of *rTorrent-PS* for Debian and Ubuntu are on `GitHub <https://github.com/pyroscope/rtorrent-ps/releases/>`_.
 * *“Arch User Repository”* (AUR) PKGBUILDs maintained by `@xsmile <https://github.com/xsmile>`_ for
   `libtorrent-ps <https://aur.archlinux.org/packages/libtorrent-ps/>`_ and
   `rtorrent-ps <https://aur.archlinux.org/packages/rtorrent-ps/>`_.
   See also the *Arch Linux* `wiki page <https://wiki.archlinux.org/title/RTorrent#Installation>`_.


Automated Installation
----------------------

This is just a selection of the myriad of projects out there that perform automated installs.
If you miss something, please make sure a potential new entry is actually still maintained,
and mention what target platforms it is designed and tested for.

Projects that work on *Debian* very likely also work on *Ubuntu*.
Just make sure the release dates match reasonably, i.e. *Jessie* is equivalent to either *Xenial* or *Trusty*.
If you want to run *ruTorrent*, the default version of *PHP* is very important (either 5 or 7).

.. glossary::

    `pimp-my-box <https://github.com/pyroscope/pimp-my-box#pimp-my-box>`_

        *Ansible · Ubuntu Xenial + Trusty · Debian Jessie + Wheezy · Raspian*

        This will install *rTorrent-PS*, *pyrocore*, and related software onto any remote dedicated server or VPS with root access, running *Debian* or a Debian-like OS. It does so via *Ansible*, which is in many ways superior to the usual *“call a bash script to set up things once and never be able to update them again”*, since you can run this setup repeatedly to either fix problems, or to install upgrades and new features added to the project's repository.

    `QuickBox <https://github.com/QuickBox>`_ and `Swizzin <https://github.com/swizzin/swizzin>`_

        *bash + Javascript*

        *QuickBox* provides easy seedbox and services management from a web dashboard.
        With the click of a button users can install additional application packages.

        *Swizzin* is a fork and strives to be more light-weight and modular.

    `AtoMiC-ToolKit <https://github.com/htpcBeginner/AtoMiC-ToolKit>`_

        *bash · Ubuntu/Mint · full HTPC setup*

        *AtoMiC Toolkit* simplifies the setup of a HTPC or home server and its management, on *Ubuntu* and *Debian* variants including *Raspbian*. It currently supports:

        .. hlist::
            :columns: 5

            * CouchPotato
            * Emby
            * Headphones
            * HTPC Manager
            * Lazy Librarian
            * Mylar
            * Nzbget
            * NZBHydra
            * Plex
            * PlexPy
            * PyLoad
            * qBittorrent
            * Radarr
            * Sabnzbdplus
            * Sickgear
            * Sickrage
            * Sonarr
            * TransmissionBT
            * Webmin

    `rtinst <https://github.com/arakasi72/rtinst>`_

        *bash · Trusty · Wheezy / Jessie*

        Seedbox installation script for *Ubuntu* and *Debian* systems.

    `Kerwood <https://github.com/Kerwood/Rtorrent-Auto-Install>`_

        *bash · Debian Jessie + Wheezy · Raspian*

        Auto install script for *rTorrent*, with *ruTorrent* as the web client.


Installing from Source
----------------------

If you compile your own executable, you are free to chose whatever version you want,
including the current bleeding edge of development *(git HEAD)*, or any “release tarball”.

.. glossary::

    `Installing (rTorrent wiki) <https://github.com/rakshasa/rtorrent/wiki/Installing>`_

        Installation information and some trouble-shooting hints in the *rTorrent* wiki.

    `Manual Turn-Key System Setup <https://rtorrent-ps.readthedocs.io/en/latest/install.html#debianinstallfromsource>`_ (PyroScope)

        Installation instructions for a working *rTorrent* instance in combination with *PyroScope* from scratch, on *Debian* and most Debian-derived distros, but also Fedora 26 and others with a little variation.

    `Installing the “Ultimate Torrent Setup” <https://github.com/xombiemp/ultimate-torrent-setup/wiki#ultimate-torrent-setup>`_

        Guide to install *rtorrent*, *ruTorrent*, *Sonarr*, and *CouchPotato* on *Ubuntu*,
        proxied by *Apache httpd*.

    `Using rtorrent on Linux like a pro <https://web.archive.org/web/20170614105017/https://ahotech.com/2010/06/30/tutorial-using-rtorrent-on-linux-like-a-pro>`_

        An oldie (originally from 2010), but still good.


rTorrent Distributions
----------------------

.. glossary::

    `rTorrent-PS <https://github.com/pyroscope/rtorrent-ps#rtorrent-ps>`_

        A *rTorrent* distribution (not a fork of it), in form of a set of patches that improve the user experience and stability of official *rTorrent* releases. The notable additions are the more condensed ncurses UI with colorization and a network bandwidth graph, and a default configuration providing many new features, based in part on an extended command set.

    `rTorrent-PS-CH <https://github.com/chros73/rtorrent-ps-ch_setup/wiki>`_

        This puts more patches and a different default configuration on top of *rTorrent-PS*. It also tries to work with the current git HEAD of *rTorrent*, which *rTorrent-PS* does not.
