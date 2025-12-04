import Fluent
import Vapor

final class PlaylistGame: Model, Content {
    static let schema = "playlist_games"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "playlist_id")
    var playlist: Playlist

    // suponiendo que Game.id es Int
    @Field(key: "game_id")
    var gameId: Int

    init() {}

    init(id: UUID? = nil, playlistID: UUID, gameId: Int) {
        self.id = id
        self.$playlist.id = playlistID
        self.gameId = gameId
    }
}
