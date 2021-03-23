# Android, Go, and gomobile

This image was built for use with Drone CI but can be used with any docker setup you want.

Versions are:

- 2021.03
	- Go 1.15.10
	- Android API 29
- 2018.07
	- Go 1.10.3
	- Android API 28

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

