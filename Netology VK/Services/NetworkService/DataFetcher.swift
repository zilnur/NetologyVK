//
//  DataFetcher.swift
//  Netology VK
//
//  Created by Ильнур Закиров on 13.11.2022.
//

import Foundation

class DataFetcher {
    
    let network = NetworkService()
    
    //Создает JSONDecoder и преобразует данные в указанную модель
    func jsonDecoded<T:Codable>(type: T.Type, data: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = data,
              let responce = try? decoder.decode(type.self, from: data) else {
            print("Ooops!")
            return nil
        }
        return responce
    }
    
}
