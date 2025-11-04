import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(User.schema)
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("password_hash", .string, .required)
            .unique(on: "email")
            .create()
    }

    func revert(on db: any Database) async throws {
        try await db.schema(User.schema).delete()
    }
}
