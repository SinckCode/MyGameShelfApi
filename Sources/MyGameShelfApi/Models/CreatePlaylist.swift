import Fluent

struct CreatePlaylist: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(Playlist.schema)
            .id()
            .field("name", .string, .required)
            .field("user_id", .uuid, .required,
                   .references("users", "id", onDelete: .cascade))
            .field("created_at", .datetime)
            .field("updated_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(Playlist.schema).delete()
    }
}
