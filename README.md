# RemoteRemote
RemoteRemote is a [Flutter](https://flutter.dev) app allows you to remotely control parameters, via OSC, of an [openFrameworks](https://openframeworks.cc) application that uses my [ofxRemoteParameters](https://github.com/c-mendoza/ofxRemoteParameters) addon. Please see that [project's page](https://github.com/c-mendoza/ofxRemoteParameters) for instructions on how to integrate ofxRemoteParameters with your OF project. Spoiler alert: it's easy!

![Animated example of RemoteRemote](https://github.com/c-mendoza/Bucket/blob/master/capture.gif?raw=true)

## Compatibility
Tested and built for:
* iOS
* MacOS
* Android (Simulator only, please let me know if it works with actual phones!)

The Web platform is currently not supported. Linux and Windows are untested.

## Building
You will need to have [Flutter installed](https://flutter.dev/docs/get-started/install). If you are building for iOS or MacOS, you'll need Xcode. If you are building for Android you will need an Android SDK, but you should probably just install Android Studio.

* Clone the repo to your chosen folder.
* In Terminal, navigate to the folder and type:
* `flutter pub get`
* `flutter run -d [YOUR DEVICE ID]` (run `flutter -d` to find devices attached to your system)
* **NOTE**: If you are building for iOS you might need to select a development team in the ios/Runner.xcworkspace file

Projects for iOS, MacOS, and Android, are provided.

## Usage
* Run an OF App with an `ofxRemoteParameters::Server`, either in your local machine or elsewhere in the local network. I recommend you start with the `basic_server` example in the ofxRemoteParameters addon, and that you run it locally.
* Run RemoteRemote.
* Provide the Server address. This can be an IP address or an mDNS hostname, or '127.0.0.1' if you are running the server locally.
* Press 'Connect'. If the server is found you should see a new screen with your parameters, ready to be edited!

## Compatible Data Types
* ofParameterGroup
* int
* float
* double
* bool
* ofColor
* ofFloatColor
* string
* vec2, vec3, vec4
* ofRectangle

Any unknown data types will be treated as Strings, so technically you'll still be able to edit them, albeit not very conveniently.

### Adding New Types
You can add support for new types by creating the appropriate Widget, serializer, and deserializer. Take a look at the `OFParameterController` constructor to see how types are added to the system.  Note that any new data types need to be supported by `ofxRemoteParameters::Server`, and that the 'stringification' of the parameter needs to be implemented in both RemoteRemote and the Server.
