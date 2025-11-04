// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "MyGameShelfApi",
    platforms: [
       .macOS(.v13)
    ],
    dependencies: [
        // 💧 Vapor
        .package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
        // 🔵 Swift NIO (ya lo tenías)
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.65.0"),
        // 🟠 Fluent ORM
        .package(url: "https://github.com/vapor/fluent.git", from: "4.9.0"),
        // 🟣 Driver de Postgres para Fluent
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.6.0"),
    ],
    targets: [
        .executableTarget(
            name: "MyGameShelfApi",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOPosix", package: "swift-nio"),
                .product(name: "Fluent", package: "fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
            ],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "MyGameShelfApiTests",
            dependencies: [
                .target(name: "MyGameShelfApi"),
                .product(name: "VaporTesting", package: "vapor"),
            ],
            swiftSettings: swiftSettings
        )
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("ExistentialAny"),
] }
