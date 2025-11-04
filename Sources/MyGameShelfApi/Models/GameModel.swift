import Vapor
import Fluent

// 👇 Agregamos @unchecked Sendable
final class GameModel: Model, Content, @unchecked Sendable {
    static let schema = "games"

    @ID(custom: .id)
    var id: Int?

    @Field(key: "nombre")
    var nombre: String

    @Field(key: "descripcion")
    var descripcion: String

    @Field(key: "rating")
    var rating: Double

    @Field(key: "plataformas")
    var plataformas: [String]

    @Field(key: "genero")
    var genero: String

    @Field(key: "precio")
    var precio: Double

    @Field(key: "imagen_url")
    var imagenURL: String

    init() { }

    init(
        id: Int? = nil,
        nombre: String,
        descripcion: String,
        rating: Double,
        plataformas: [String],
        genero: String,
        precio: Double,
        imagenURL: String
    ) {
        self.id = id
        self.nombre = nombre
        self.descripcion = descripcion
        self.rating = rating
        self.plataformas = plataformas
        self.genero = genero
        self.precio = precio
        self.imagenURL = imagenURL
    }
}

// MARK: - DTO mapping
extension GameModel {
    func toDTO() -> GameDTO {
        GameDTO(
            id: self.id ?? 0,               // si por alguna razón es nil, mandamos 0
            nombre: self.nombre,
            descripcion: self.descripcion,
            rating: self.rating,
            plataformas: self.plataformas,
            genero: self.genero,
            precio: self.precio,
            imagenURL: self.imagenURL
        )
    }
}
