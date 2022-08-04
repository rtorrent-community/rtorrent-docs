#! /usr/bin/env bash
#
# Set up project
#
# Copyright (c) 2010-2017 The PyroScope Project <pyroscope.project@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

VENV_NAME="rtorrent-docs"

SCRIPTNAME="$0"
test "$SCRIPTNAME" != "-bash" -a "$SCRIPTNAME" != "-/bin/bash" || SCRIPTNAME="${BASH_SOURCE[0]}"

test ! -x "$1" || PYTHON="$1"

deactivate 2>/dev/null || true
test -z "$PYTHON" -a -x "/usr/bin/python3" && PYTHON="/usr/bin/python3"
test -z "$PYTHON" -a -x "/usr/bin/python" && PYTHON="/usr/bin/python"
test -z "$PYTHON" && PYTHON="python3"

test -n "$VENV_NAME" || VENV_NAME="$(basename $(builtin cd $(dirname "$SCRIPTNAME") && pwd))"
test -x ".venv/bin/python" || ${PYTHON} -m venv --prompt "$VENV_NAME" ".venv"
. ".venv/bin/activate"

pip install -U pip setuptools wheel
pip install -r requirements.txt
