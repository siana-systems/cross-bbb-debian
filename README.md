# BeagleBone cross-compilation in a Docker container.

Installs the BeagleBone cross-compilation toolchain into a [debian:jessie Docker image](https://hub.docker.com/_/debian/).
This project is available as [siana/cross-bbb-debian](https://registry.hub.docker.com/u/siana/cross-bbb-debian/) on [Docker Hub](https://hub.docker.com/) (not yet).
Based on the work of [sdt/docker-raspberry-pi-cross-compiler](https://github.com/sdt/docker-raspberry-pi-cross-compiler), all credits for them.

## Features

* the arm-linux-gnueabihf toolchain for the BeagleBone Black target, included in this package.
* commands in the container are run as the calling user, so that any created files have the expected ownership (ie. not root).
* make variables (`CC`, `LD` etc) are set to point to the appropriate tools in the container.
* `ARCH`, `CROSS_COMPILE` and `HOST` environment variables are set in the container
* current directory is mounted as the container's workdir, `/build`
* works with boot2docker on OSX and Windows (TBC).

## Installation

This image is not intended to be run manually. Instead, there is a helper script which comes bundled with the image.

To install the helper script, run the image with no arguments, and redirect the output to a file.

eg.
```
docker run siana/cross-bbb-debian > bbbxc
chmod +x bbbxc
mv bbbxc ~/bin/
```

Because the tool calls docker, tha caller has to be run with root privileges (on Ubuntu at least). To use the tool as a non-root user, do the following:

Add the `docker` group if not already there and add yourself to it:
```
sudo groupadd docker
sudo gpasswd -a ${USER} docker
```

Restart the `docker` service by issuing either `sudo service docker restart` OR `sudo service docker.io restart` (Depending on your distribution).

Then log out and log in back or log into the group by issuing `newgrp docker`.

NOTE: Guide taken from [this Ubuntu thread](http://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo).

## Usage

`bbbxc [command] [args...]`

Execute the given command-line inside the container.

If the command matches one of the bbbxc built-in commands (see below), that will be executed locally, otherwise the command is executed inside the container.

---

`bbbxc -- [command] [args...]`

To force a command to run inside the container (in case of a name clash with a built-in command), use `--` before the command.

### Built-in commands

`bbbxc update-image`

Fetch the latest version of the docker image.

---

`bbbxc update-script`

Update the installed bbbxc script with the one bundled in the image.

----

`bbbxc update`

Update both the docker image, and the bbbxc script.

## Configuration

The following command-line options and environment variables are used. In all cases, the command-line option overrides the environment variable.

### BBBXC_CONFIG / --config &lt;path-to-config-file&gt;

This file is sourced if it exists.

Default: `~/.bbbxc`

### BBBXC_IMAGE / --image &lt;docker-image-name&gt;

The docker image to run.

Default: siana/cross-bbb

### BBBXC_ARGS / --args &lt;docker-run-args&gt;

Extra arguments to pass to the `docker run` command.

## Examples

`bbbxc make`

Build the Makefile in the current directory.

---

`bbbxc bbbxc-gcc -o hello ./examples/hello.c`
`file hello`

Standard bintools are available by adding an `bbbxc-` prefix.

---

`bbbxc bash -c 'find . -name \*.o | sort > objects.txt'`

Note that commands are executed verbatim. If you require any shell processing for environment variable expansion or redirection, please use `bash -c 'command args...'`.
