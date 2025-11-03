import Vapor

// MARK: - Modelos / DTOs

struct Game: Content {
    let id: Int
    let nombre: String
    let descripcion: String
    let rating: Double
    let plataformas: [String]
    let genero: String
    let precio: Double
    let imagenURL: String
}

struct Company: Content {
    let id: Int
    let nombre: String
    let fundacion: Int
    let historia: String
    let imagenURL: String
}

struct RegisterDTO: Content {
    let name: String
    let email: String
    let password: String
}

struct LoginDTO: Content {
    let email: String
    let password: String
}

struct AuthResponse: Content {
    let message: String
    let isLogged: Bool
    let userId: Int
}

// MARK: - Rutas

public func routes(_ app: Application) throws {

    // ---------- Health ----------
    app.get("health") { _ in
        ["status": "ok"]
    }

    // ---------- Datos dummy (luego los sacamos de BD) ----------

    let demoGames: [Game] = [
        .init(
            id: 1,
            nombre: "Street Fighter 6",
            descripcion: "Juego de peleas competitivo",
            rating: 4.7,
            plataformas: ["PS5","PC","Xbox Series"],
            genero: "Lucha",
            precio: 59.99,
            imagenURL: "https://m.media-amazon.com/images/I/61sBcZGwLFL._AC_.jpg"
        ),
        .init(
            id: 2,
            nombre: "Monster Hunter World",
            descripcion: "Acción RPG de cacería de monstruos",
            rating: 4.6,
            plataformas: ["PS4","PC","Xbox One"],
            genero: "Acción",
            precio: 39.99,
            imagenURL: "https://m.media-amazon.com/images/I/81ptcMaPW6L._AC_SL1500_.jpg"
        )
    ]

    let demoCompanies: [Company] = [
        .init(
            id: 1,
            nombre: "Capcom",
            fundacion: 1979,
            historia: "Compañía japonesa responsable de Street Fighter, Monster Hunter, Resident Evil, etc.",
            imagenURL: "https://upload.wikimedia.org/wikipedia/commons/2/2f/Capcom_logo.png"
        ),
        .init(
            id: 2,
            nombre: "SEGA",
            fundacion: 1960,
            historia: "Histórica compañía japonesa creadora de Sonic, Yakuza, etc.",
            imagenURL: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c7/SEGA_logo_JPN.svg/1200px-SEGA_logo_JPN.svg.png"
        )
    ]

    // ---------- Games ----------

    app.get("games") { _ in
        demoGames
    }

    app.get("games", ":id") { req -> Game in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }
        guard let game = demoGames.first(where: { $0.id == id }) else {
            throw Abort(.notFound, reason: "No se encontró el juego")
        }
        return game
    }

    // ---------- Companies ----------

    app.get("companies") { _ in
        demoCompanies
    }

    app.get("companies", ":id") { req -> Company in
        guard let id = req.parameters.get("id", as: Int.self) else {
            throw Abort(.badRequest, reason: "id inválido")
        }
        guard let company = demoCompanies.first(where: { $0.id == id }) else {
            throw Abort(.notFound, reason: "No se encontró la compañía")
        }
        return company
    }

    // ---------- Auth (demo) ----------

    let auth = app.grouped("auth")

    // POST /auth/register
    auth.post("register") { req -> AuthResponse in
        let body = try req.content.decode(RegisterDTO.self)
        print("REGISTER demo: \(body.email)")

        // por ahora respondemos un userId fijo (1)
        return AuthResponse(
            message: "Registro exitoso (demo)",
            isLogged: true,
            userId: 1
        )
    }

    // POST /auth/login
    auth.post("login") { req -> AuthResponse in
        let body = try req.content.decode(LoginDTO.self)
        print("LOGIN demo: \(body.email)")

        // aquí luego validaremos contra BD; por ahora siempre OK
        return AuthResponse(
            message: "Login exitoso (demo)",
            isLogged: true,
            userId: 1
        )
    }
}
