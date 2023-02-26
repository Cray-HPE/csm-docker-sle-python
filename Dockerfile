# MIT License
#
# (C) Copyright 2022-2023 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
ARG SLE_VERSION
FROM artifactory.algol60.net/csm-docker/stable/csm-docker-sle:${SLE_VERSION} AS base

ARG PY_VERSION=''

# Install helpful build environment items:
# NOTE: RPMs take precedence to PIP packages; install RPMs when available, and pip packages otherwise to avoid
#       file conflicts.
# - python-rpm-*      : Specfile macros.
# - python-base       : Base Python package.
# - python-devel      : Extensions and headers for building Python modules.
# - python-pip        : The published/paired pip for the given Python base.
# - python-setuptools : The published/paired setuptools for the given Python base.
# NOTE: python36 is called python3 in SLE15.2.
RUN zypper refresh \
    && zypper --non-interactive install --no-recommends --force-resolution \
    python-rpm-generators \
    python-rpm-macros \
    python${PY_VERSION%.*}-base \
    python${PY_VERSION%.*}-devel \
    python${PY_VERSION%.*}-pip \
    python${PY_VERSION%.*}-setuptools \
    && zypper clean -a

# Install packages not available via Zypper.
RUN python3 -m pip install --disable-pip-version-check --no-cache-dir -U \
    'build' \
    'virtualenv' \
    'wheel'

WORKDIR /build