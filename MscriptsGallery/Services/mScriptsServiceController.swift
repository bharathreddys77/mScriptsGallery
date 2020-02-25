//
//  mScriptsServiceController.swift
//  MscriptsGallery
//
//  Created by A6049116 on 2/23/20.
//  Copyright © 2020 Mscripts. All rights reserved.
//

import Foundation

struct mScriptsServiceController:NetworkingController {
    enum ServiceType:String {
        case GET,POST,PUT,DELETE
    }
    private let timeOutInterval = 90.0
    func retrievePublicPhotos(completion:@escaping(Photos?,NetworkControllerError?) -> Void) {
        networkRequest(urlString: AppConstants.BASE_URL+AppConstants.API_KEY+AppConstants.FORMAT+AppConstants.USER_ID, type: .GET, header: nil, encodingData: GetPhotoRequest(), completion: completion)
    }
}

extension mScriptsServiceController {
    
    private func networkRequest<T: Decodable, Q: Encodable>(urlString: String,type:ServiceType,header:[String:String]?,encodingData: Q?,completion: @escaping (T?, NetworkControllerError?) -> Void) {
        if !NetworkManager.isConnectedToNetwork() {
            completion(nil,.noNetworkError)
            return
        }
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async { completion(nil,.invalidRequest) }
            return
        }
        print("url \(url)")
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeOutInterval
        config.timeoutIntervalForResource = timeOutInterval
        if header != nil{
            config.httpAdditionalHeaders = header
        }
        let session = URLSession(configuration: config)
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        if let httpBody = encodingData {
            do {
                let jsonBody = try JSONEncoder().encode(httpBody)
                request.httpBody = jsonBody
            } catch {
                print("Unable to add http body to request \(error)")
            }
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = session.dataTask(with: url) { (responseData, urlResponse, responseError) in
            guard responseError == nil else {
                DispatchQueue.main.async {
                    completion(nil,.BadResponseError(responseError))
                }
                return
            }
            if let response = urlResponse {
//                print("decodableData \(String(data: responseData!, encoding: .utf8))")
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("statusCode \(statusCode)")
                if statusCode == 200 {
                    guard let decodableData = responseData else {
                        DispatchQueue.main.async {
                            completion(nil,.NoDataError)
                        }
                        return
                    }
                    do {
                        let dataReceived = try JSONDecoder().decode(T.self, from: decodableData)
                        DispatchQueue.main.async {
                            completion(dataReceived,nil)
                        }
                    } catch {
                        print("Data parse Error \(error)")
                        DispatchQueue.main.async { completion(nil,.dataParseError(error)) }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil,.Non200StatusCodeError(nil))
                    }
                }
            }
        }
        task.resume()
    }
}
