enum NetworkServiceError: Error, Equatable {
    case connectionFailure
    case sessionError
    case httpError
    case responseError
    case dataError
    case decodeError
    case urlRequestError
    case urlError
    case none
}
