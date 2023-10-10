// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "PotatoGit",
    products: [
        .library(
            name: "PotatoGit",
            targets: ["PotatoGit"]),
    ],
    targets: [
        .systemLibrary(
            name: "Clibgit",
            pkgConfig: "libgit2",
            providers: [
                .brew(["libgit2"]),
                .apt(["libgit2-dev"])
            ]
        ),

        .target(
            name: "PotatoGit",
            dependencies: ["Clibgit"]),
        .testTarget(
            name: "PotatoGitTests",
            dependencies: ["PotatoGit"]),
    ]
)
