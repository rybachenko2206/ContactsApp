//
//  NetworkService.swift
//  ContactsTestApp
//
//  Created by Roman Rybachenko on 16.05.2022.
//

import Foundation

// SwiftyJSON was added just for convenient print response json to log
import SwiftyJSON
import CoreData

typealias GetContactsCompletion = (Result<GetContactsResponse, AppError>) -> Void

protocol PNetworkService {
    func getContacts(completion: @escaping GetContactsCompletion)
}

class NetworkService: PNetworkService {
    private let context: NSManagedObjectContext
    
    private lazy var jsonDecoder: JSONDecoder = {
        guard let decoder = JSONDecoder(context: context) else {
            fatalError("Can not create Decoder with context")
        }
        return decoder
    }()
    
    init(with context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public funcs
    func getContacts(completion: @escaping GetContactsCompletion) {
        request(with: .getContactsList, completion: completion)
    }
    
    // MARK: - Private funcs
    private func request<D: Decodable>(with method: APIMethod, completion: @escaping (Result<D, AppError>) -> Void) {
        guard let urlRequest = method.urlRequest else {
            completion(.failure(AppError.defaultError))
            return
        }
        
        pl("request.url = \n\(urlRequest.url?.absoluteString ?? ".. is nil")")
        
        URLSession
            .shared
            .dataTask(with: urlRequest,
                      completionHandler: { [weak self] data, response, error in
                        guard let self = self else { return }
                        
                        guard self.isResponseValid(response),
                            error == nil,
                            let responseData = data
                            else {
                                self.handleFailure(with: data,
                                                    response: response,
                                                    error: error,
                                                    completion: completion)
                                return
                        }
                        
                        let json = JSON(responseData)
                        pl("\nrequest \(method) response: \n\(json)\n")
                        
                        if let serverError = try? JSONDecoder().decode(ServerError.self, from: responseData) {
                            self.executeInMainThread(with: .failure(AppError(serverError: serverError)),
                                                     completion: completion)
                        } else {
                            do {
                                let decodedResponse = try self.jsonDecoder.decode(D.self, from: responseData)
                                self.executeInMainThread(with: .success(decodedResponse), completion: completion)
                            } catch let err {
                                var message: String?
                                if let decodingError = err as? DecodingError {
                                    pl("Decoding error: \n\(decodingError)")
                                    message = decodingError.localizedDescription
                                }
                                self.executeInMainThread(with: .failure(.parseResponseModel(message)), completion: completion)
                            }
                        }
                        
            })
            .resume()
    }
    
    private func executeInMainThread<D: Decodable>(with result: Result<D, AppError>, completion:  @escaping (Result<D, AppError>) -> Void) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
    private func isResponseValid(_ response: URLResponse?) -> Bool {
        guard let httpResponse = response as? HTTPURLResponse,
            200..<300 ~= httpResponse.statusCode
            else { return false }
        return true
    }
    
    private func handleFailure<D: Decodable>(with data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<D, AppError>) -> Void) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        if let errorData = data  {
            do {
                let serverErr = try JSONDecoder().decode(ServerError.self, from: errorData)
                let apiError = AppError(serverError: serverErr)
                executeInMainThread(with: .failure(apiError), completion: completion)
            } catch let decodeError {
                if let stCode = statusCode {
                    let apiError = AppError(error: error, statusCode: stCode)
                    executeInMainThread(with: .failure(apiError), completion: completion)
                } else {
                    pl("decode response error: \n\(decodeError.localizedDescription)")
                    executeInMainThread(with: .failure(AppError.defaultError), completion: completion)
                }
            }
        } else if let error = error {
            pl("received error = \n\(error)")
            let apiError = AppError(error: error, statusCode: statusCode)
            executeInMainThread(with: .failure(apiError), completion: completion)
        } else {
            let apiError = AppError(error: error, statusCode: statusCode)
            executeInMainThread(with: .failure(apiError), completion: completion)
        }
    }
}
