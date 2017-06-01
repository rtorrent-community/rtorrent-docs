.. _faq:

Frequently Asked Questions
==========================


.. _faq-stop-using-sed:

How Can I Stop All Torrents From a Shell?
-----------------------------------------

This is most useful when *rTorrent* consistently crashes shortly after starting up.
That often means you have an item that refers to a data file with an I/O error or
a similar fault. To solve this, you need stop all torrents from the outside, since
you cannot use the crashing client for it.

Before you do this, **make a backup of your session folder!** Then call this command:

.. code-block:: shell

    for i in ~/rtorrent/.session/*.torrent.rtorrent; do \
        sed -i -re 's/5:statei1e/5:statei0e/' $i; done

Now you can start the client, and there's a good chance it won't crash this time.
To start items one by one, use this:

.. code-block:: shell

    while true; do rtcontrol --from-view stopped is_complete=y -/1 \
                             --start --flush -qo name || break; sleep 2; done

When the bad item is started, the crash might be triggered immediately, or with some delay.
Increase the sleep time if removing the last item shown (and possibly the one following it)
does not solve the problem.


.. _faq-paused-vs-stopped:

What is the Difference Between 'paused' and 'stopped'?
------------------------------------------------------

**TODO**
