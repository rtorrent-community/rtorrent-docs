# -*- coding: utf-8 -*-
#
# Project Tasks
#
from __future__ import print_function, unicode_literals

import os
import sys
import time
import shutil
import contextlib
import subprocess
import webbrowser

try:
    from pathlib import Path
except ImportError:
    from pathlib2 import Path

from invoke import task


SPHINX_AUTOBUILD_PORT = int(os.environ.get('SPHINX_AUTOBUILD_PORT', '8340'))


@contextlib.contextmanager
def pushd(folder):
    """Context manager to temporarily change directory."""
    cwd = os.getcwd()
    try:
        os.chdir(folder)
        yield folder
    finally:
        os.chdir(cwd)


def watchdog_pid(ctx):
    """Get watchdog PID via ``netstat``."""
    result = ctx.run('netstat -tulpn 2>/dev/null | grep 127.0.0.1:{:d}'
                     .format(SPHINX_AUTOBUILD_PORT), warn=True, pty=False)
    pid = result.stdout.strip()
    pid = pid.split()[-1] if pid else None
    pid = pid.split('/', 1)[0] if pid and pid != '-' else None

    return pid


@task(help={
    'open-tab': "Open docs in new browser tab after initial build"
})
def docs(ctx, open_tab=False):
    """Start watchdog to build the Sphinx docs."""
    build_dir = 'docs/_build'
    index_html = build_dir + '/html/index.html'

    stop(ctx)
    if os.path.exists(build_dir):
        shutil.rmtree(build_dir)

    print("\n*** Generating HTML doc ***\n")
    subprocess.check_call(
        'command cd docs >/dev/null'
        ' && . {pwd}/.venv/bin/activate'
        ' && nohup {pwd}/docs/Makefile SPHINXBUILD="sphinx-autobuild --port {port:d}'
        '          --ignore \'.*\' --ignore \'*.log\' --ignore \'*.png\' --ignore \'*.txt\'" html >autobuild.log 2>&1 &'
        .format(port=SPHINX_AUTOBUILD_PORT, pwd=os.getcwd()), shell=True)

    for i in range(25):
        time.sleep(2.5)
        pid = watchdog_pid(ctx)
        if pid:
            ctx.run("touch docs/index.rst")
            ctx.run('ps {}'.format(pid), pty=False)
            url = 'http://localhost:{port:d}/'.format(port=SPHINX_AUTOBUILD_PORT)
            if open_tab:
                webbrowser.open_new_tab(url)
            else:
                print("\n*** Open '{}' in your browser...".format(url))
            break


@task
def stop(ctx):
    "Stop Sphinx watchdog."
    print("\n*** Stopping watchdog ***\n")
    for i in range(4):
        pid = watchdog_pid(ctx)
        if not pid:
            break
        else:
            if not i:
                ctx.run('ps {}'.format(pid), pty=False)
            ctx.run('kill {}'.format(pid), pty=False)
            time.sleep(.5)


@task
def undoc(ctx):
    """List undocumented commands."""
    checks = dict(
        public=[
            'scheduler.(max|simple)', 'd.custom[0-5]',
            'pyro',
            'ui.color.custom[0-9]', 'ui.color.*.set',

            # Groups that need work (excluded for brevity)
            'choke_group', 'file.prioritize_toc', 'group2.seeding', 'group.seeding', 'group.insert', 'ratio',
        ],
        private=[
            'ui.color.[^.]+.index', 'completion_', 'pyro._', 'pmb._',

            # Internal / automatic state management
            'd.complete.set',
            'd.connection_leech.set',
            'd.connection_seed.set',
            'd.down.choke_heuristics.leech.set',
            'd.down.choke_heuristics.seed.set',
            'd.hashing.set',
            'd.loaded_file.set',
            'd.mode.set',
            'd.state_changed.set',
            'd.state_counter.set',
            'd.state.set',
            'd.timestamp.finished.set',
            'd.timestamp.finished.set_if_z',
            'd.timestamp.started.set',
            'd.timestamp.started.set_if_z',
        ],
    )
    commands_097 = [x for x in """
        d.is_meta
        directory.watch.added
        load.raw_start_verbose
        math.add
        math.avg
        math.cnt
        math.div
        math.max
        math.med
        math.min
        math.mod
        math.mul
        math.sub
        network.http.current_open
        network.http.ssl_verify_host
        network.http.ssl_verify_host.set
        strings.log_group
        strings.tracker_event
        system.daemon
        system.daemon.set
        system.env
        system.shutdown.normal
        system.shutdown.quick
        torrent_list_layout
        ui.current_view
        ui.torrent_list.layout
        ui.torrent_list.layout.set
    """.strip().split()]

    for kind, exceptions in checks.items():
        ctx.run('rtxmlrpc system.has.{kind}_methods | '
                'while read cmd; do'
                '    egrep -m1 "^    $cmd" docs/*rst >/dev/null || echo "$cmd"; '
                'done | egrep -v "^({exc_re})" | sort'
                .format(kind=kind, exc_re='|'.join(exceptions)))

    ctx.run(': v0.9.7 commands')
    for cmd_name in commands_097:
        ctx.run('egrep -m1 "^    {cmd}" docs/*rst >/dev/null || echo "{cmd}"'
                .format(cmd=cmd_name), echo=False)
