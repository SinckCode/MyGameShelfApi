import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) async throws {
    // ========= CORS =========
    let cors = CORSMiddleware(configuration: .init(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .DELETE, .OPTIONS],
        allowedHeaders: [.accept, .authorization, .contentType, .origin]
    ))

    app.middleware.use(cors)

    // ========= Base de datos: Postgres =========
    let hostname = Environment.get("DB_HOST") ?? "localhost"
    let port = Environment.get("DB_PORT").flatMap(Int.init)
        ?? SQLPostgresConfiguration.ianaPortNumber
    let username = Environment.get("DB_USER") ?? "mygameshelf"
    let password = Environment.get("DB_PASSWORD") ?? "onesto01"
    let database = Environment.get("DB_NAME") ?? "mygameshelf"

    app.databases.use(
        .postgres(
            configuration: .init(
                hostname: hostname,
                port: port,
                username: username,
                password: password,
                database: database,
                tls: .disable
            )
        ),
        as: .psql
    )

    // ========= Migraciones =========
    app.migrations.add(CreateUser())
    app.migrations.add(CreateGame())
    app.migrations.add(CreateCompany())

    // 🔹 NUEVO: playlists
    app.migrations.add(CreatePlaylist())
    app.migrations.add(CreatePlaylistGame())

    // Ejecutar migraciones al arrancar
    try await app.autoMigrate()

    // ========= Rutas =========
    try routes(app)
}
