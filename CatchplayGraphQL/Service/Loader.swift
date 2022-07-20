//
//  Loader.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import Foundation

protocol RequestLoader {
    func load<req: GraphQLRequest>(_ request: req, completion: @escaping (Result<req.Value, req.QLError>)->())
}

struct URLSeesionRequestLoader: RequestLoader {
    
    func load<req: GraphQLRequest>(_ request: req, completion: @escaping (Result<req.Value, req.QLError>) ->()) {
        URLSession.shared.dataTask(with: request.getURLRequest()) {
            data, res, err in
            if let error = request.convertError(data, res, err) {
                completion(.failure(error))
                return
            }
            completion(request.decode(data))
        }.resume()
    }
    
}
