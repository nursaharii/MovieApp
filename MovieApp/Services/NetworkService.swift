//
//  NetworkService.swift
//  MVVM-C_BoilerPlate
//
//  Created by Nurşah Ari on 17.02.2024.
//

import Foundation
import Alamofire
import Combine

class NetworkService {
    
    private var session = Session(configuration: URLSessionConfiguration.af.default,
                                      serverTrustManager: ServerTrustManager(evaluators: [ "www.omdbapi.com" : DisabledTrustEvaluator()]))
    
    func fetchResource<T: Decodable>(from endpoint: API) -> AnyPublisher<T, AFError> {
        return session.request(endpoint.url, method: endpoint.method, parameters: endpoint.parameters, encoding: JSONEncoding.default)
            .publishDecodable(type: T.self) // Alamofire ve Combine entegrasyonu
            .value() // Yalnızca başarılı sonuçları al
            .receive(on: RunLoop.main) // Ana iş parçacığında al
            .eraseToAnyPublisher() // Geri dönüş tipini AnyPublisher olarak belirle
    }
}

