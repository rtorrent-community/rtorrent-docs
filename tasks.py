# -*- coding: utf-8 -*-
#
# Project Tasks
#
from __future__ import print_function, unicode_literals

import os
import time
import shutil

from invoke import task

SPHINX_AUTOBUILD_PORT = 8340


@task
def docs(ctx):
    """Start watchdog to build the Sphinx docs."""
    build_dir = 'docs/_build'
    index_html = build_dir + '/html/index.html'

    stop(ctx)
    if os.path.exists(build_dir):
        shutil.rmtree(build_dir)

    print("\n*** Generating HTML doc ***\n")
    ctx.run('builtin cd docs'
            ' && . {pwd}/.pyvenv/*/bin/activate'
            ' && nohup {pwd}/docs/Makefile SPHINXBUILD="sphinx-autobuild -p {port:d}'
            '          -i \'.*\' -i \'*.log\' -i \'*.png\' -i \'*.txt\'" html >autobuild.log 2>&1 &'
            .format(port=SPHINX_AUTOBUILD_PORT, pwd=os.getcwd()), pty=False)

    for i in range(25):
        time.sleep(2.5)
        result = ctx.run('netstat -tulpn 2>/dev/null | grep 127.0.0.1:{:d}'
                         .format(SPHINX_AUTOBUILD_PORT), warn=True, pty=False)
        pid = result.stdout.strip()
        print(pid)
        if pid:
            ctx.run("touch docs/index.rst")
            pid, _ = pid.split()[-1].split('/', 1)
            ctx.run('ps %s' % pid, pty=False)
            url = 'http://localhost:%d/' % SPHINX_AUTOBUILD_PORT
            print("\n*** Open '%s' in your browser..." % url)
            break


@task
def stop(ctx):
    "Stop Sphinx watchdog"
    for i in range(4):
        result = ctx.run('netstat -tulpn 2>/dev/null | grep 127.0.0.1:{:d}'
                         .format(SPHINX_AUTOBUILD_PORT), warn=True, pty=False)
        pid = result.stdout.strip()
        print(pid)
        if pid:
            pid, _ = pid.split()[-1].split('/', 1)
            if not i:
                ctx.run('ps %s' % pid, pty=False)
            ctx.run('kill %s' % pid, pty=False)
            time.sleep(.5)
        else:
            break
