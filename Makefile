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
NAME ?= ${NAME}
DOCKER_BUILDKIT ?= ${DOCKER_BUILDKIT}
LEAP_VERSION := $(shell awk -v replace="'" '/leapVersion/{gsub(replace,"", $$NF); print $$NF; exit}' Jenkinsfile.github)
PY_FULL_VERSION := $(shell awk -v replace="'" '/pythonVersion/{gsub(replace,"", $$NF); print $$NF; exit}' Jenkinsfile.github)
PY_VERSION := $(shell echo ${PY_FULL_VERSION} | awk -F '.' '{print $$1"."$$2}')
VERSION ?= ${VERSION}

all: image

image:
	docker build --secret id=SLES_REGISTRATION_CODE --pull ${DOCKER_ARGS} --build-arg PY_VERSION=${PY_VERSION} --build-arg PY_FULL_VERSION=${PY_FULL_VERSION} --tag '${NAME}:${VERSION}' .
	docker tag '${NAME}:${VERSION}' ${NAME}:${PY_FULL_VERSION}_leap${LEAP_VERSION}
	docker tag '${NAME}:${VERSION}' ${NAME}:${PY_VERSION}_leap${LEAP_VERSION}
	docker tag '${NAME}:${VERSION}' ${NAME}:latest
