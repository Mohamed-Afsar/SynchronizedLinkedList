// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SynchronizedLinkedList",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "SynchronizedLinkedList",
            targets: ["SynchronizedLinkedList"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Mohamed-Afsar/DoublyLinkedList.git",
        .exact("1.0.0"))
//        .package(path: "../DoublyLinkedList")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SynchronizedLinkedList",
            dependencies: ["DoublyLinkedList"],
            path: "SynchronizedLinkedList/Sources/SynchronizedLinkedList"),
        .testTarget(
            name: "SynchronizedLinkedListTests",
            dependencies: ["SynchronizedLinkedList"],
            path: "SynchronizedLinkedList/Tests/SynchronizedLinkedListTests"),
    ]
)
