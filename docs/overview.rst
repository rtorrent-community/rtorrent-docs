Overview
========

rTorrent Feature Summary
------------------------

 * No-frills *ncurses* interface.
 * Runs as a daemon, using a terminal multiplexer like ``tmux`` or ``screen`` (and 0.9.7+ has a ‘real’ daemon mode).
 * Resource-friendly, ideal to run on a *Raspberry Pi* or a small seedbox VPS.
 * Scriptable and extensible via built-in commands and XMLRPC clients.
 * Very large choice of web frontends.
 * Support for DHT and PEX.
 * Magnet links.
 * Supported on nearly all trackers.
 * Implemented in C++, runs on all major POSIX platforms.


Guided Tour
-----------

The :doc:`installation` has some pointers to common ways of installing
rTorrent on your machine. It does not provide yet another way to do that,
because there already are plentiful and redundant sources out there.

To help you with basic configuration tasks, the :doc:`cookbook`
contains a quick start into the ‘scripting language’ rTorrent uses
for its configuration files.

:doc:`use-cases` then goes on showing how to handle
a number of typical configuration needs,
adding more features to the basic configuration.

Building on that, the :doc:`scripting` explains more complex commands and
constructs of said language. It also helps with controlling rTorrent
from the outside, via the XMLRPC protocol.

The :doc:`cmd-ref` chapter lists all relevant XMLRPC and ‘private’ commands
of *rTorrent* with a short explanation.


Getting Interactive Help via Chat
---------------------------------

.. include:: include-contacts.rst

.. unofficial help & support channel for rTorrent: irc://irc.freenode.net/rtorrent
.. webchat: https://webchat.freenode.net/?channels=%23%23rtorrent
.. freenode.net IRC network: https://freenode.net/


Web Resources Related to rTorrent
---------------------------------

Here is a list of web links to related information:

* `rtorrent GitHub project <https://github.com/rakshasa/rtorrent/>`_
* `libtorrent GitHub project <https://github.com/rakshasa/libtorrent>`_
* `rTorrent Community GitHub organization <https://rtorrent-community.github.io/>`_
* `Arch Wiki rTorrent page <https://wiki.archlinux.org/title/RTorrent>`_
* `rTorrent Quick Reference Card <https://ciux.org/rtorrent_ref.pdf>`_ (PDF)

.. * ` <>`_
.. END overview
