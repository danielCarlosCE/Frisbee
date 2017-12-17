![](https://i.imgur.com/ELeuGch.png)

#

[![Build Status](https://www.bitrise.io/app/27a5e39dc511ba7c/status.svg?token=HZCmnpdBTIy3rOQdUv6HOg&branch=master)](https://www.bitrise.io/app/27a5e39dc511ba7c) [![CocoaPods](https://img.shields.io/cocoapods/v/Frisbee.svg)]() [![CocoaPods](https://img.shields.io/cocoapods/p/Frisbee.svg)]() [![Carthage](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg)]()

# Install
##### Carthage
To integrate Frisbee into your Xcode project using Carthage, specify it in your Cartfile:

```
github "ronanrodrigo/Frisbee"
```

Run carthage update to build the framework and drag the built Frisbee.framework into your Xcode project.

##### CocoaPods
To integrate Frisbee into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Frisbee'
end
```

Then, run the following command:

```bash
$ pod install
```

#### Swift Package Manager
To integrate Frisbee into your Swift Package Manager project, set the dependencies in your `Package.swift`:

```swift
// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "MyPackage",
    dependencies: [
        .package(url: "https://github.com/ronanrodrigo/Frisbee.git", from: "0.0.23")
    ],
    targets: [
        .target(name: "MyPackage", dependencies: ["Frisbee"])
    ]
)
```

# How to use

##### Create some decodable entity
```swift
struct Movie: Decodable {
    let name: String
}
```

##### This are an exemple of some code that will request some data across network.
```swift
class MoviesController {
    private let getRequest: FBEGetable
    var moviesQuantity = 0

    init(getRequest: FBEGetable) {
        self.getRequest = getRequest
    }

    func didTouchAtListMovies() {
        getRequest.get(url: "") { (moviesResult: FBEResult<[Movie]>) in
            switch moviesResult {
                case let .success(movies): self.moviesQuantity = movies.count
                case let .fail(error): print(error)
            }
        }
    }
}

```

##### In production-ready code you must inject an instance of `FBENetworkGet`.
```swift
// Who will call the MoviesController must inject a FBENetworkGet instance
MoviesController(getRequest: FBENetworkGet())
```

# How to test your APP

##### In test target code you can create your own `FBEGetable` mock.
```swift
public class FBEMockGet: FBEGetable {
    var decodableMock: Decodable!

    public func get<Entity: Decodable>(url: URL, completionHandler: @escaping (FBEResult<Entity>) -> Void) {
        get(url: url.absoluteString, completionHandler: completionHandler)
    }

    public func get<Entity: Decodable>(url: String, completionHandler: @escaping (FBEResult<Entity>) -> Void) {
        if let decodableMock = decodableMock as? Entity {
            completionHandler(.success(decodableMock))
        }
    }

}

```

##### And instead `FBENetworkGet` you will use to test the `FBEMockGet` on `MoviesController`
```swift

class MoviesControllerTests: XCTestCase {
    func testDidTouchAtListMoviesWhenHasMoviesThenPresentAllMovies() {
        let mockGet = FBEMockGet()
        let movies = [Movie(name: "Star Wars")]
        mockGet.decodableMock = movies
        let controller = MoviesController(getRequest: mockGet)

        controller.didTouchAtListMovies()

        XCTAssertEqual(controller.moviesQuantity, movies.count)
    }
}
```

# Frisbee next features
- [x] Get request
- [x] Create Carthage distribution
- [x] Create Cocoapod distribution
- [ ] Post request
- [ ] Cache policy
- [ ] Some mock ready for use

