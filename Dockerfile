# Android section of this Dockerfile from https://medium.com/@elye.project/intro-to-docker-building-android-app-cb7fb1b97602

FROM openjdk:8


ENV SDK_URL="https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip" \
    ANDROID_HOME="/usr/local/android-sdk" \
    ANDROID_SDK=$ANDROID_HOME \
    ANDROID_VERSION=29 \
    ANDROID_BUILD_TOOLS_VERSION=30.0.2

## Download Android SDK
RUN mkdir "$ANDROID_HOME" .android \
    && cd "$ANDROID_HOME" \
    && curl -o sdk.zip $SDK_URL \
    && unzip sdk.zip \
    && rm sdk.zip \
    && yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

## Install Android Build Tool and Libraries
RUN $ANDROID_HOME/tools/bin/sdkmanager --update
RUN $ANDROID_HOME/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "platforms;android-${ANDROID_VERSION}" \
    "platform-tools"

# Install NDK
RUN $ANDROID_HOME/tools/bin/sdkmanager "ndk-bundle"
ENV ANDROID_NDK_ROOT $ANDROID_HOME/ndk-bundle

# Go section of this Dockerfile from Docker golang: https://github.com/docker-library/golang/blob/master/1.10/alpine3.8/Dockerfile
# Adapted from alpine apk to debian apt

## set up nsswitch.conf for Go's "netgo" implementation
## - https://github.com/golang/go/blob/go1.9.1/src/net/conf.go#L194-L275
## - docker run --rm debian:stretch grep '^hosts:' /etc/nsswitch.conf
RUN echo 'hosts: files dns' > /etc/nsswitch.conf

ENV GOLANG_VERSION 1.15.10
ENV GOLANG_SHA256 c1dbca6e0910b41d61a95bf9878f6d6e93d15d884c226b91d9d4b1113c10dd65

RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		 bash \
		build-essential \
		openssl \
		libssl-dev \
		golang \
	; \
	rm -rf /var/lib/apt/lists/*; \
	export \
## set GOROOT_BOOTSTRAP such that we can actually build Go
		GOROOT_BOOTSTRAP="$(go env GOROOT)" \
## ... and set "cross-building" related vars to the installed system's values so that we create a build targeting the proper arch
## (for example, if our build host is GOARCH=amd64, but our build env/image is GOARCH=386, our build needs GOARCH=386)
		GOOS="$(go env GOOS)" \
		GOARCH="$(go env GOARCH)" \
		GOHOSTOS="$(go env GOHOSTOS)" \
		GOHOSTARCH="$(go env GOHOSTARCH)" \
	; \
## also explicitly set GO386 and GOARM if appropriate
## https://github.com/docker-library/golang/issues/184
	aptArch="$(dpkg-architecture  -q DEB_BUILD_GNU_CPU)"; \
	case "$aptArch" in \
		arm) export GOARM='6' ;; \
		x86_64) export GO386='387' ;; \
	esac; \
	\
	wget -O go.tgz "https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz"; \
	echo "$GOLANG_SHA256 *go.tgz" | sha256sum -c -; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
	\
	cd /usr/local/go/src; \
	./make.bash; \
	\
	export PATH="/usr/local/go/bin:$PATH"; \
	go version

# persist new go in PATH
ENV PATH /usr/local/go/bin:$PATH

ENV GOMOBILEPATH /gomobile
# Setup /workspace
RUN mkdir $GOMOBILEPATH
# Set up GOPATH in /workspace
ENV GOPATH $GOMOBILEPATH
ENV PATH $GOMOBILEPATH/bin:$PATH
RUN mkdir -p "$GOMOBILEPATH/src" "$GOMOBILEPATH/bin" "$GOMOBILEPATH/pkg" && chmod -R 777 "$GOMOBILEPATH"

# install gomobile
RUN go get golang.org/x/mobile/cmd/gomobile
RUN go get golang.org/x/mobile/cmd/gobind
RUN go get golang.org/x/mobile/bind

RUN gomobile clean
