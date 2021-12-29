//
//  NetworkService.swift
//  CatsAPI_MVVM
//
//  Created by Roman Gorshkov on 23.12.2021.
//

import Foundation
import Combine

enum NetworkErrors: Error {
    case wrongURL
    case dataIsEmpty
    case decodeIsFail
    case noConnection
}

final class NetworkService {
    
    func baseRequest<T: Decodable>(request: URLRequest) -> AnyPublisher<T, Error> {
        var dataTask: URLSessionDataTask?
        let onSubscription: (Subscription) -> Void = { _ in dataTask?.resume() }
        let onCancel: () -> Void = { dataTask?.cancel() }
        return Future<T, Error> { promise in
            guard let _ = request.url else {
                promise(.failure(NetworkErrors.wrongURL))
                return
            }
            
            dataTask = URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let data = data else {
                    promise(.failure(NetworkErrors.dataIsEmpty))
                    return
                }
                do {
                    let decodedModel = try JSONDecoder().decode(T.self, from: data)
                    promise(.success(decodedModel))
                } catch {
                    promise(.failure(NetworkErrors.decodeIsFail))
                }
            }
        }
        .handleEvents(receiveSubscription: onSubscription, receiveCancel: onCancel)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
