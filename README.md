# Android and Go

likely you are using gomobile for development, so you will want a first step in your pipeline:
   
    gomobile:
      image: openpriv/android-go-mobile
      commands:
        - go get golang.org/x/mobile/cmd/gomobile
        - gomobile init -ndk $ANDROID_HOME/ndk-bundle/

