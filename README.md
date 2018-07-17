# Android, Go, and gomobile

This image was built for use with Drone CI but can be used with any docker setup you want.

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
