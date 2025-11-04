import Vapor
import Fluent

// MARK: - DTOs que ve Android

struct GameDTO: Content {
    let id: Int
    let nombre: String
    let descripcion: String
    let rating: Double
    let plataformas: [String]
    let genero: String
    let precio: Double
    let imagenURL: String
}

struct CompanyDTO: Content {
    let id: Int
    let nombre: String
    let fundacion: Int
    let historia: String
    let imagenURL: String
}

// DTOs para crear (body de los POST / PUT)
struct CreateGameRequest: Content {
    let nombre: String
    let descripcion: String
    let rating: Double
    let plataformas: [String]
    let genero: String
    let precio: Double
    let imagenURL: String
}

struct CreateCompanyRequest: Content {
    let nombre: String
    let fundacion: Int
    let historia: String
    let imagenURL: String
}

// MARK: - Auth DTOs (alineados con Android)

struct RegisterDTO: Content {
    let name: String
    let email: String
    let password: String
}

struct LoginDTO: Content {
    let email: String
    let password: String
}

/// Respuesta unificada para register, login y operaciones de auth
/// Android usa:
/// data class AuthResponse(
///     val message : String,
///     @SerialName("isLogged") val islogged : Boolean,
///     val userId: String? = null
/// )
struct AuthResponseDTO: Content {
    let message: String
    let isLogged: Bool
    let userId: String?
}

// DTOs para gestión de usuarios (CRUD)
struct UserDTO: Content {
    let id: UUID
    let name: String
    let email: String
}

struct UpdateUserRequest: Content {
    let name: String?
    let email: String?
    let password: String?
}

// MARK: - Rutas

public func routes(_ app: Application) throws {

    // ---------- Health ----------
    app.get("health") { _ in
        ["status": "ok"]
    }

    app.post("test") { req async throws -> String in
        return "POST /test OK"
    }

    // =========================================================
    //                      GAMES (sin /api)
    // =========================================================

    // GET /games
    app.get("games") { req async throws -> [GameDTO] in
        let games = try await GameModel.query(on: req.db).all()
        return games.map { $0.toDTO() }
    }

    // GET /games/:id
    app.get("games", ":id") { req async throws -> GameDTO in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }
        guard let game = try await GameModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Juego no encontrado")
        }
        return game.toDTO()
    }

    // POST /games (crear)
    app.post("games") { req async throws -> GameDTO in
        let body = try req.content.decode(CreateGameRequest.self)

        let game = GameModel(
            nombre: body.nombre,
            descripcion: body.descripcion,
            rating: body.rating,
            plataformas: body.plataformas,
            genero: body.genero,
            precio: body.precio,
            imagenURL: body.imagenURL
        )

        try await game.save(on: req.db)
        return game.toDTO()
    }

    // PUT /games/:id (actualizar)
    app.put("games", ":id") { req async throws -> GameDTO in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }

        guard let game = try await GameModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Juego no encontrado")
        }

        let body = try req.content.decode(CreateGameRequest.self)

        game.nombre = body.nombre
        game.descripcion = body.descripcion
        game.rating = body.rating
        game.plataformas = body.plataformas
        game.genero = body.genero
        game.precio = body.precio
        game.imagenURL = body.imagenURL

        try await game.save(on: req.db)
        return game.toDTO()
    }

    // DELETE /games/:id (eliminar)
    app.delete("games", ":id") { req async throws -> HTTPStatus in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }

        guard let game = try await GameModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Juego no encontrado")
        }

        try await game.delete(on: req.db)
        return .noContent
    }

    // =========================================================
    //                  COMPANIES (sin /api)
    // =========================================================

    // GET /companies
    app.get("companies") { req async throws -> [CompanyDTO] in
        let companies = try await CompanyModel.query(on: req.db).all()
        return companies.map { $0.toDTO() }
    }

    // GET /companies/:id
    app.get("companies", ":id") { req async throws -> CompanyDTO in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }
        guard let company = try await CompanyModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Compañía no encontrada")
        }
        return company.toDTO()
    }

    // POST /companies (crear)
    app.post("companies") { req async throws -> CompanyDTO in
        let body = try req.content.decode(CreateCompanyRequest.self)

        let company = CompanyModel(
            nombre: body.nombre,
            fundacion: body.fundacion,
            historia: body.historia,
            imagenURL: body.imagenURL
        )

        try await company.save(on: req.db)
        return company.toDTO()
    }

    // PUT /companies/:id (actualizar)
    app.put("companies", ":id") { req async throws -> CompanyDTO in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }

        guard let company = try await CompanyModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Compañía no encontrada")
        }

        let body = try req.content.decode(CreateCompanyRequest.self)

        company.nombre = body.nombre
        company.fundacion = body.fundacion
        company.historia = body.historia
        company.imagenURL = body.imagenURL

        try await company.save(on: req.db)
        return company.toDTO()
    }

    // DELETE /companies/:id (eliminar)
    app.delete("companies", ":id") { req async throws -> HTTPStatus in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }

        guard let company = try await CompanyModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Compañía no encontrada")
        }

        try await company.delete(on: req.db)
        return .noContent
    }

    // =========================================================
    //                  Versión /api/...
    // =========================================================

    let api = app.grouped("api")

    // -------- GAMES /api/games --------

    // GET /api/games
    api.get("games") { req async throws -> [GameDTO] in
        let games = try await GameModel.query(on: req.db).all()
        return games.map { $0.toDTO() }
    }

    // GET /api/games/:id
    api.get("games", ":id") { req async throws -> GameDTO in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }
        guard let game = try await GameModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Juego no encontrado")
        }
        return game.toDTO()
    }

    // POST /api/games (crear)
    api.post("games") { req async throws -> GameDTO in
        let body = try req.content.decode(CreateGameRequest.self)

        let game = GameModel(
            nombre: body.nombre,
            descripcion: body.descripcion,
            rating: body.rating,
            plataformas: body.plataformas,
            genero: body.genero,
            precio: body.precio,
            imagenURL: body.imagenURL
        )

        try await game.save(on: req.db)
        return game.toDTO()
    }

    // PUT /api/games/:id (actualizar)
    api.put("games", ":id") { req async throws -> GameDTO in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }

        guard let game = try await GameModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Juego no encontrado")
        }

        let body = try req.content.decode(CreateGameRequest.self)

        game.nombre = body.nombre
        game.descripcion = body.descripcion
        game.rating = body.rating
        game.plataformas = body.plataformas
        game.genero = body.genero
        game.precio = body.precio
        game.imagenURL = body.imagenURL

        try await game.save(on: req.db)
        return game.toDTO()
    }

    // DELETE /api/games/:id (eliminar)
    api.delete("games", ":id") { req async throws -> HTTPStatus in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }

        guard let game = try await GameModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Juego no encontrado")
        }

        try await game.delete(on: req.db)
        return .noContent
    }

    // -------- COMPANIES /api/companies --------

    // GET /api/companies
    api.get("companies") { req async throws -> [CompanyDTO] in
        let companies = try await CompanyModel.query(on: req.db).all()
        return companies.map { $0.toDTO() }
    }

    // GET /api/companies/:id
    api.get("companies", ":id") { req async throws -> CompanyDTO in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }
        guard let company = try await CompanyModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Compañía no encontrada")
        }
        return company.toDTO()
    }

    // POST /api/companies (crear)
    api.post("companies") { req async throws -> CompanyDTO in
        let body = try req.content.decode(CreateCompanyRequest.self)

        let company = CompanyModel(
            nombre: body.nombre,
            fundacion: body.fundacion,
            historia: body.historia,
            imagenURL: body.imagenURL
        )

        try await company.save(on: req.db)
        return company.toDTO()
    }

    // PUT /api/companies/:id (actualizar)
    api.put("companies", ":id") { req async throws -> CompanyDTO in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }

        guard let company = try await CompanyModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Compañía no encontrada")
        }

        let body = try req.content.decode(CreateCompanyRequest.self)

        company.nombre = body.nombre
        company.fundacion = body.fundacion
        company.historia = body.historia
        company.imagenURL = body.imagenURL

        try await company.save(on: req.db)
        return company.toDTO()
    }

    // DELETE /api/companies/:id (eliminar)
    api.delete("companies", ":id") { req async throws -> HTTPStatus in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }

        guard let company = try await CompanyModel.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Compañía no encontrada")
        }

        try await company.delete(on: req.db)
        return .noContent
    }

    // =========================================================
    //                      AUTH (con BD + CRUD)
    // =========================================================

    let auth = app.grouped("auth")

    // MARK: - Register

    // POST /auth/register
    auth.post("register") { req async throws -> AuthResponseDTO in
        let body = try req.content.decode(RegisterDTO.self)

        // ¿El correo ya existe?
        if try await User.query(on: req.db)
            .filter(\.$email == body.email)
            .first() != nil
        {
            return AuthResponseDTO(
                message: "El correo ya está registrado",
                isLogged: false,
                userId: nil
            )
        }

        // Crear usuario
        let user = User(
            name: body.name,
            email: body.email,
            passwordHash: body.password // TODO: hash real
        )
        try await user.save(on: req.db)

        let id = try user.requireID()

        return AuthResponseDTO(
            message: "Registro exitoso",
            isLogged: true,
            userId: id.uuidString
        )
    }

    // MARK: - Login

    // POST /auth/login
    auth.post("login") { req async throws -> AuthResponseDTO in
        let body = try req.content.decode(LoginDTO.self)

        // Buscar usuario por email
        guard let user = try await User.query(on: req.db)
            .filter(\.$email == body.email)
            .first()
        else {
            return AuthResponseDTO(
                message: "Credenciales inválidas",
                isLogged: false,
                userId: nil
            )
        }

        // Validar contraseña (por ahora comparación directa)
        guard user.passwordHash == body.password else {
            return AuthResponseDTO(
                message: "Credenciales inválidas",
                isLogged: false,
                userId: nil
            )
        }

        let id = try user.requireID()

        return AuthResponseDTO(
            message: "Login exitoso",
            isLogged: true,
            userId: id.uuidString
        )
    }

    // MARK: - CRUD de usuarios (Auth como CRUD)

    // GET /auth/users  -> lista de usuarios
    auth.get("users") { req async throws -> [UserDTO] in
        let users = try await User.query(on: req.db).all()
        return try users.map { user in
            UserDTO(
                id: try user.requireID(),
                name: user.name,
                email: user.email
            )
        }
    }

    // GET /auth/users/:id -> detalle de usuario
    auth.get("users", ":id") { req async throws -> UserDTO in
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }

        guard let user = try await User.find(id, on: req.db) else {
            throw Abort(.notFound, reason: "Usuario no encontrado")
        }

        return UserDTO(
            id: id,
            name: user.name,
            email: user.email
        )
    }

    // PUT /auth/users/:id -> actualizar usuario
    auth.put("users", ":id") { req async throws -> AuthResponseDTO in
        guard let id = req.parameters.get("id", as: UUID.self) else {
            return AuthResponseDTO(
                message: "id inválido",
                isLogged: false,
                userId: nil
            )
        }

        guard let user = try await User.find(id, on: req.db) else {
            return AuthResponseDTO(
                message: "Usuario no encontrado",
                isLogged: false,
                userId: nil
            )
        }

        let body = try req.content.decode(UpdateUserRequest.self)

        if let name = body.name {
            user.name = name
        }
        if let email = body.email {
            user.email = email
        }
        if let password = body.password {
            user.passwordHash = password // TODO: hash real igual que en register
        }

        try await user.save(on: req.db)

        return AuthResponseDTO(
            message: "Usuario actualizado correctamente",
            isLogged: true,
            userId: id.uuidString
        )
    }

    // DELETE /auth/users/:id -> eliminar usuario
    auth.delete("users", ":id") { req async throws -> AuthResponseDTO in
        guard let id = req.parameters.get("id", as: UUID.self) else {
            return AuthResponseDTO(
                message: "id inválido",
                isLogged: false,
                userId: nil
            )
        }

        guard let user = try await User.find(id, on: req.db) else {
            return AuthResponseDTO(
                message: "Usuario no encontrado",
                isLogged: false,
                userId: nil
            )
        }

        try await user.delete(on: req.db)

        return AuthResponseDTO(
            message: "Usuario eliminado correctamente",
            isLogged: true,
            userId: id.uuidString
        )
    }
}
