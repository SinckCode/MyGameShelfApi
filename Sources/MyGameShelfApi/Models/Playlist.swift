import Fluent
import Vapor

final class Playlist: Model, Content, @unchecked Sendable {
    static let schema = "playlists"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Parent(key: "user_id")
    var user: User

    @Children(for: \.$playlist)
    var gamesPivot: [PlaylistGame]

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() {}

    init(id: UUID? = nil, name: String, userID: UUID) {
        self.id = id
        self.name = name
        self.$user.id = userID
    }
}
