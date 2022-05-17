# MIT License
# 
# (C) Copyright [2021-2022] Hewlett Packard Enterprise Development LP
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
FROM artifactory.algol60.net/csm-docker/stable/csm-docker-sle:15.3 AS base

RUN --mount=type=secret,id=SLES_REGISTRATION_CODE SUSEConnect -r "$(cat /run/secrets/SLES_REGISTRATION_CODE)"
CMD ["/bin/bash"]
FROM base AS py-base

ARG PY_FULL_VERSION=''
ARG PY_VERSION=''

RUN zypper refresh \
    && zypper --non-interactive install --no-recommends --force-resolution \
    libffi-devel \
    && zypper clean -a \
    && SUSEConnect --cleanup

WORKDIR .python
RUN curl -O "https://www.python.org/ftp/python/$PY_FULL_VERSION/Python-$PY_FULL_VERSION.tar.xz" \
    && tar -xvf "./Python-$PY_FULL_VERSION.tar.xz" \
    && rm "Python-$PY_FULL_VERSION.tar.xz"

WORKDIR ".python/Python-$PY_FULL_VERSION"
RUN ./configure --enable-optimizations --enable-shared LDFLAGS='-Wl,-rpath /usr/local/lib' \
    && make altinstall

RUN ln -snf "../local/bin/python$PY_VERSION" /usr/bin/python3 \
    && ln -snf "../local/bin/pip$PY_VERSION" /usr/bin/pip3

RUN python3 -m pip install -U pip \
    && python3 -m pip install -U setuptools \
    && python3 -m pip install -U virtualenv \
    && python3 -m pip install -U wheel

WORKDIR /build
