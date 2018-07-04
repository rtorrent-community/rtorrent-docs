.. rTorrent Handbook master file
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

.. no image:: _static/img/logo.png

Welcome to the “rTorrent Handbook”!
===================================

This is a comprehensive manual and user guide for the `rTorrent`_ bittorrent client,
written by and for the community.
See also the `homepage of the community project`_ and the `community wiki`_.

*rTorrent* is written in C++ and uses the ``ncurses`` library to provide a textual user interface.
It can be used in a (SSH) terminal session together with a terminal multiplexer like ``tmux``,
providing a very lean bittorrent solution.
Using its XMLRPC remote control API, alternative user interfaces can be provided by web clients
like `ruTorrent`_, or command line clients like `pyrocore`_ and its ``rtcontrol`` command.

The :doc:`overview` chapter offers you a guided tour through this manual,
or browse through the table of contents below to find what you're looking for.

If you like what is here but are missing something,
the best way to fill that hole is to pour what you know into it.
Every contribution counts, and instead of lamenting the situation,
please go fix it by taking small steps in the right direction.
If everyone chimes in, we all profit in the end.

:doc:`contributing` tells you more about how to add your changes to the project.


.. _`rTorrent`: https://github.com/rakshasa/rtorrent/wiki
.. _`homepage of the community project`: https://rtorrent-community.github.io/
.. _`community wiki`: https://github.com/rtorrent-community/rtorrent-community.github.io/wiki
.. _`ruTorrent`: https://github.com/Novik/ruTorrent
.. _`pyrocore`: https://github.com/pyroscope/pyrocore


Contents of This Manual
=======================

..  toctree::
    :maxdepth: 2
    :caption: Getting Started

    overview
    installation
    cookbook

..  toctree::
    :maxdepth: 2
    :caption: Using rTorrent

    use-cases
    faq

..  toctree::
    :maxdepth: 2
    :caption: rTorrent Scripting

    scripting
    cmd-ref

..  toctree::
    :maxdepth: 2
    :caption: Other Topics

    contributing


Indices & Tables
----------------

* :ref:`genindex`
* :ref:`search`
