import Foundation

struct FailureCodableModelMock: Codable {
    let count: Int
    let results: [FailureResult]
}

struct FailureResult: Codable {
    let value, spells, score: String
}
