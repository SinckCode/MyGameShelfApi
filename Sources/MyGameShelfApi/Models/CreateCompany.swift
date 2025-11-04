import Fluent

struct CreateCompany: AsyncMigration {
    func prepare(on db: any Database) async throws {
        try await db.schema(CompanyModel.schema)
            .field(.id, .int, .identifier(auto: true))
            .field("nombre", .string, .required)
            .field("fundacion", .int, .required)
            .field("historia", .string, .required)
            .field("imagen_url", .string, .required)
            .create()
    }

    func revert(on db: any Database) async throws {
        try await db.schema(CompanyModel.schema).delete()
    }
}
