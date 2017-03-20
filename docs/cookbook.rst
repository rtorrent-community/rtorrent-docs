Configuration Cookbook
======================

To help you with basic configuration tasks, this chapter contains a quick start
into the ‘scripting language’ rTorrent uses for its configuration files.
It then goes on showing how to solve some :ref:`common configuration use-cases <common-tasks>`.


Quick Start
-----------

**TODO**


The rTorrent Command Line
^^^^^^^^^^^^^^^^^^^^^^^^^

Calling ``rtorrent -h`` shows this usage message regarding command line options
(with the last three missing):

.. code-block:: none

    Usage: rtorrent [OPTIONS]... [FILE]... [URL]...
      -h                Display this very helpful text
      -n                Don't try to load ~/.rtorrent.rc on startup
      -b <a.b.c.d>      Bind the listening socket to this IP
      -i <a.b.c.d>      Change the IP that is sent to the tracker
      -p <int>-<int>    Set port range for incoming connections
      -d <directory>    Save torrents to this directory by default
      -s <directory>    Set the session directory
      -o key=opt,...    Set options, see 'rtorrent.rc' file

      -D                Disable deprecated commands
      -I                Disable intermediate commands
      -K                Allow intermediate commands without XMLRPC (just in config files)

The really useful ones are ``-n`` and ``-o import=‹file›``,
to load configuration from a non-standard location.
Everything else is better set in a configuration file.

*rTorrent* renamed a lot of configuraiton commands with the release
of version ``0.8.9``.
It is recommended to add ``-D`` and ``-I`` to your start script,
so that all the old command names are gone. However, some external
software (web UIs and so on) might not be able to work with such a
reduced command set.
Also be aware that those undocumented switches changed their semantics
with the release of ``0.9.6`` – the above shows the current situation.


.. _common-tasks:

Common Tasks
------------

**TODO**
