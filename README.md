# CSM Docker: SLE Python

A SLE Server Python Docker image used for RPM builds.

## Available Images

See a list of available Python Images with `git tag`, but in general there are:

- `latest`, `3.10`, and `3.10.4`
- `3.8` and `3.8.13`

Tags can also be seen directly at [https://artifactory.algol60.net/artifactory/csm-docker/stable/csm-docker-sle-python](https://artifactory.algol60.net/artifactory/csm-docker/stable/csm-docker-sle-python).

## Building

The provided `Makefile` adds Jenkins Pipeline variables to the `docker build` command. The commands below are for use outside of the CSM Jenkins Pipeline.

```bash
export DOCKER_BUILDKIT=1
export SLES_REGISTRATION_CODE=<registration_code>

# Build Python 3.8.13
docker build --secret id=SLES_REGISTRATION_CODE --arg PY_FULL_VERSION=3.8.13 .

```

## Running

```bash
# Latest
docker run -it artifactory.algol60.net/csm-docker/stable/csm-docker-sle-python:latest

# Python Major Minor Version
docker run -it artifactory.algol60.net/csm-docker/stable/csm-docker-sle-python:3.8

# Python Version
docker run -it artifactory.algol60.net/csm-docker/stable/csm-docker-sle-python:3.8.13

# Git Hash
docker run -it artifactory.algol60.net/csm-docker/stable/csm-docker-sle-python:<hash>
```

## Python Version(s)

The version is controlled by the `Dockerfile`. Each image built and pushed to Artifactory is tagged with:
- `latest`
- A short Git hash
- The Python Version from the [`Jenkinsfile`](https://github.com/Cray-HPE/csm-docker-sle-python/blob/main/Jenkinsfile.github#L4)

