# Android, Go, and gomobile

This image was built for use with Drone CI but can be used with any docker setup you want.

Versions are:

- 2021.03
	- Go 1.15.10
	- Android API 29
	- NDK 21.0.6113669
- 2018.07
	- Go 1.10.3
	- Android API 28
	- NDK 17.2.4988734

## Install and Use

### Version 2021.03

This image includes:

- Android SDK, NDK, tools, and API version 29 and Buildtools 30.0.2 at `/usr/local/android-sdk`
- Go lang 1.10.3 at `/usr/local/go`
- $GOPATH set to `/gomobile`
	- GOPATH includes gomobile cmd tools and source

This container has its own GOPATH with only gomobile in it, so to use, you'll need to re-get your go dependancies and then run `gomobile init`.  The following example shows a Drone CI step using this image

    gomobile-build:
      image: openpriv/android-go-mobile:2021.03
      commands:
        - go mod download
	- gomobile init
	- make

### Version 2018.07

This image includes:

- Android SDK, NDK, tools, and API version 28 at `/usr/local/android-sdk`
- Go lang 1.10.3 at `/usr/local/go`
- $GOPATH set to `/workspace/go`
- A go directory with an initialized gomobile installed at `/go`

This image comes with gomobile checkedout and preinitialized (time and space consuming). In order to install this predone work from the image into your Drone CI workspace (a docker volume mounted to `/workspace`), you will want your first pipeline step to be:

    go-link:
      image: openpriv/android-go-mobile
      commands:
        - cp -as /go /workspace/go

`cp -as` recreates the directory structure from /go in /workspace/go but for each file, it just creates a symlink. This is the quickest and most efficent way to mirror the work supplied with the image into your workspace.
