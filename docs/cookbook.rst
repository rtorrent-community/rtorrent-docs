Configuration Cookbook
======================

To help you with fundamental configuration tasks, this chapter contains a quick start
into the ‘scripting language’ rTorrent uses for its configuration files.
:ref:`config-deconstructed` uses a basic configuration file to explain what
the contained commands are doing, also showing common syntax constructs by example.

The rest of the chapter then goes on showing
how to implement some :ref:`common configuration use-cases <common-tasks>`,
adding more features to that basic configuration.

The `ArchLinux wiki page`_ is also a good source on *rTorrent* in general
and its configuration in particular.

.. note::

    *rTorrent* started to rename a lot of configuration commands
    with the release of version ``0.8.9``.
    This handbook uses the new commands throughout,
    and does not mention the old ones.

    See the `RPC Migration 0.9`_ wiki page for more details.
    That pages also links to a `sed script`_ that can transform old snippets
    you found on the web and might want to use to using the new command names.

    :ref:`rtorrent-cli` shows you how you can prevent *rTorrent* from adding
    most of the old names as aliases for the new ones, by using the ``-D -I``
    command line options.


.. _`RPC Migration 0.9`: https://github.com/rakshasa/rtorrent/wiki/RPC-Migration-0.9
.. _`sed script`: https://github.com/rakshasa/rtorrent/blob/master/doc/scripts/update_commands_0.9.sed
.. _`ArchLinux wiki page`: https://wiki.archlinux.org/index.php/Rtorrent


Quick Start
-----------

.. _rtorrent-basics:

rTorrent Basics
^^^^^^^^^^^^^^^

We're assuming you used one of the ways in the :doc:`installation` to
add the *rTorrent* binary to your host, ready to be configured and started.
Try calling ``rtorrent -h`` to make sure that worked.

To be really useful, *rTorrent* must be given a basic configuration file,
with some essential settings that ensure you get more than the bare-bones defaults.
Follow the configuration steps in this chapter on a fresh installation,
then try to start *rTorrent* and initiate your first downloads.
Or check if you see something you want to add to your existing setup.

After some time, when you're familiar with the basic operation of *rTorrent*,
try to work through the :doc:`scripting` if you want to dive deeper into
customizing *rTorrent*.


.. _config-template:

Modernized Configuration Template
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Any configuration should start with using the modernized `rTorrent wiki config template`_.
The configuration is loaded from the file ``~/.rtorrent.rc`` by
default (that is the hidden file ``.rtorrent.rc`` in your user home
directory). This command fetches the template from *GitHub* and writes it
into that file:

.. code-block:: shell

    curl -Ls "https://raw.githubusercontent.com/wiki/rakshasa/rtorrent/CONFIG-Template.md" \
        | grep -A9999 '^######' | grep -B9999 '^### END' \
        | sed -re "s:/home/USERNAME:$HOME:" >~/.rtorrent.rc

To create the directory tree this configuration expects, also call these commands:

.. code-block:: shell

    mkdir -p "$HOME/rtorrent"/{.session,download,log,watch/load,watch/start}

That means that all files *rTorrent* uses are located
in the ``~/rtorrent`` directory, except the main configuration file.

Here is a copy of the template in full, see :ref:`config-deconstructed`
below for a detailed explanation of its parts.

.. literalinclude:: rtorrent.rc
   :language: ini

And here is a simple start script that you should use before you tackle
auto-starting *rTorrent* at boot time. First make it work for you,
then add the bells and whistles. Copy the script to ``~/rtorrent/start``,
and make it executable using ``chmod a+x ~/rtorrent/start``.

.. literalinclude:: start.sh
   :language: shell

You can call it in a simple shell prompt first, but for normal operation
is must be launched in a ``tmux`` session. More on that later on.


.. _`rTorrent wiki config template`: https://github.com/rakshasa/rtorrent/wiki/CONFIG-Template


.. _rtorrent-cli:

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

It is recommended to add ``-D`` and ``-I`` to your start script,
so that all the old command names are gone. However, some external
software (web UIs and so on) might not be able to work with such a
reduced command set.
Also be aware that those undocumented switches changed their semantics
with the release of ``0.9.6`` – the above shows the current situation.


.. _basic-syntax:

Basic Syntax Elements
---------------------

The configuration ‘scripts’ have some usual syntax elements, and some not so usual ones.
If you're versed in *any* computer language, you surely spotted some of them in the
:ref:`config-template`.
Comments start with a ``#``,
and you can break long lines apart by escaping the line ends with ``\``.

The basic structure of lines is ``‹commmand› = ‹arg1›[, ‹arg2›, …]``.
In configuration files, the ``command`` either sets some value, or has some side effect:
defining a method or schedule, executing a OS command, and so on.
This is the ‘old’ syntax, and still relevant on the top level of configuration files.

Other elements are escaped text in quotes (these are *not* strings in the classical sense),
lists in braces ``{…}``, and commands in single or double parentheses ``(…)``.
At some places, a semicolon ``;`` separates multiple commands executed in sequence.

Quoted text keeps words separated by spaces together,
passing all of it as a single argument to a command – quite similar to a string.
However, simple words do not need to be escaped; simply put,
everything that's not a command is a string.

Quoting can be nested, but the inner quotes have to be escaped using ``\``,
and on the third level the backslashes have to be escaped too, leading to abominations like
``"…\"…\\\"…\\\"…\"…"``.
Just avoid that, keep it to two levels at most,
e.g. quoted text within a quoted sequence of commands.
If you need more complex structures, work with helper methods
where you can ‘start fresh’ when it comes to escaping levels.

Be pragmatical, and have no fear of mixing ‘old’ and ‘new’ syntax to your advantage.
Prefer the new one with parentheses,
but that your syntax works and does the thing you want is most important,
readability is next, and any theoretical pureness of syntax ideas come in last.


.. _config-deconstructed:

Config Template Deconstructed
-----------------------------

**TODO** format of rc file, what are commands, etc.

**TODO** Include parts and explain them, linking to commands used


.. _common-tasks:

Common Tasks
------------

The `Common Tasks in rTorrent`_ wiki page contains more of these typical configuration use-cases.

.. _`Common Tasks in rTorrent`: https://github.com/rakshasa/rtorrent/wiki/Common-Tasks-in-rTorrent


Set a Download Item to “Seed Only”
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``d.seed_only`` command helps you to stop all download activity on an item.
Select any unfinished item, press ``Ctrl-X``, and enter ``d.seed_only=`` followed by ``⏎``.
Then all files in that item are set to ``off``, and any peers still sending you data are cut off.
The data you have is still seeded, as long as the item is not stopped.

.. code-block:: ini

    method.insert = d.seed_only, private|simple,\
        "f.multicall = *, f.priority.set=0 ;\
         d.update_priorities= ;\
         d.disconnect.seeders="

:term:`f.multicall` calls :term:`f.priority.set` on every file,
:term:`d.update_priorities` makes these changes known,
and finally :term:`d.disconnect.seeders` kicks any active seeders.


Scheduled Bandwidth Shaping
^^^^^^^^^^^^^^^^^^^^^^^^^^^

This example shows how to use :term:`schedule2` with absolute start times,
to set the download rate depending on the wall clock time, at 10AM and 4PM.
The result is a very simple form of bandwidth shaping,
with full speed transfers enabled while you're at work (about 16 MiB/s in the example),
and only very moderate bandwidth usage when you're at home.

.. code-block:: ini

    schedule2 = throttle_full, 10:00:00, 24:00:00, ((throttle.global_down.max_rate.set_kb, 16000))
    schedule2 = throttle_slow, 16:00:00, 24:00:00, ((throttle.global_down.max_rate.set_kb,  1000))

Use :term:`throttle.global_up.max_rate.set_kb` for setting the upload rate.

If you call these commands via XMLRPC from an outside script,
you can implement more complex rules,
e.g. `throttling when other computers are visible on the network`_.

External scripts should also be used when saving money is the goal,
in cases where you have to live with disadvantageous ISP plans with bandwidth caps.
Run such a script very regularly (via ``cron``),
to enforce the bandwidth rules continuously.


.. _`throttling when other computers are visible on the network`: http://pyrocore.readthedocs.io/en/latest/advanced.html#global-throttling-when-other-computers-are-up

.. END cookbook
