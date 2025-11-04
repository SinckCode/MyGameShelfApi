import Fluent

struct CreateGame: AsyncMigration {
    // 👇 aquí
    func prepare(on db: any Database) async throws {
        try await db.schema(GameModel.schema)
            .field(.id, .int, .identifier(auto: true))
            .field("nombre", .string, .required)
            .field("descripcion", .string, .required)
            .field("rating", .double, .required)
            .field("plataformas", .array(of: .string), .required)
            .field("genero", .string, .required)
            .field("precio", .double, .required)
            .field("imagen_url", .string, .required)
            .create()
    }

    // 👇 y aquí
    func revert(on db: any Database) async throws {
        try await db.schema(GameModel.schema).delete()
    }
}
