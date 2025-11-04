import Vapor
import Fluent

final class CompanyModel: Model, Content, @unchecked Sendable {
    static let schema = "companies"

    @ID(custom: .id)
    var id: Int?

    @Field(key: "nombre")
    var nombre: String

    @Field(key: "fundacion")
    var fundacion: Int

    @Field(key: "historia")
    var historia: String

    @Field(key: "imagen_url")
    var imagenURL: String

    init() { }

    init(
        id: Int? = nil,
        nombre: String,
        fundacion: Int,
        historia: String,
        imagenURL: String
    ) {
        self.id = id
        self.nombre = nombre
        self.fundacion = fundacion
        self.historia = historia
        self.imagenURL = imagenURL
    }
}

// MARK: - DTO mapping
extension CompanyModel {
    func toDTO() -> CompanyDTO {
        CompanyDTO(
            id: self.id ?? 0,
            nombre: self.nombre,
            fundacion: self.fundacion,
            historia: self.historia,
            imagenURL: self.imagenURL
        )
    }
}
