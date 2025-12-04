import Fluent

struct CreatePlaylistGame: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema(PlaylistGame.schema)
            .id()
            .field("playlist_id", .uuid, .required,
                   .references("playlists", "id", onDelete: .cascade))
            .field("game_id", .int, .required)
            .unique(on: "playlist_id", "game_id")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema(PlaylistGame.schema).delete()
    }
}
