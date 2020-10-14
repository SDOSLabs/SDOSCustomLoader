// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SDOSCustomLoader",
    platforms: [
        .iOS("9.0")
    ],
    products: [
        .library(
            name: "SDOSCustomLoader",
            targets: ["SDOSCustomLoader"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SDOSCustomLoader",
            path: "src",
            publicHeadersPath: "",
            cSettings: [
                .headerSearchPath("Classes"),
                .headerSearchPath("Classes/Helper"),
                .headerSearchPath("Classes/Progress"),
                  ]
        ),
    ]
)
