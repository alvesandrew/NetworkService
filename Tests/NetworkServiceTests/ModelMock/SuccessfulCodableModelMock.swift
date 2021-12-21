import Foundation

struct SuccessfulCodableModelMock: Codable {
    let count: Int
    let results: [Result]
}

struct Result: Codable {
    let index, name, url: String
}
