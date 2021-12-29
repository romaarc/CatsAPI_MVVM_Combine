//
//  NetworkServiceProtocol.swift
//  CatsAPI_MVVM
//
//  Created by Roman Gorshkov on 23.12.2021.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetchBreeds(with page: Int) -> AnyPublisher<Response, Error>
}
