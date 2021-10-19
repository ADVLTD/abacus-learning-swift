//
//  CreateAccountAPI.swift
//  Near
//
//  Created by Bhushan Mahajan on 19/10/21.
//

import Foundation

//Data model for the Json object returned from server after creating account.
struct CreateAccountModel: Codable {
    let accountName: String?
    let passPhrase: String?
    let privateKey: String?
    let publicKey: String?
    let text: String?
    let statusCode: Int?
    let error: String?
    let message: String?
}

struct SignInModel: Codable {
    let publicKey: String?
    let accountName: String?
    let privateKey: String?
    let success: Bool?
    let text: String?
}

class CreateAccountAPI {
    //Singleton Object for CreateAccountAPI
    static let shared = CreateAccountAPI()
    
    //Create User Function
    //This Function is called when the user want to create a account.
    
    func createUser(username: String, completion: @escaping (Result<CreateAccountModel, Error>) -> Void) {
        
        //Url for the rest api server for creating account
        guard let url = URL(string: Constants.createUserURL.rawValue) else { return }
        
        //Post Request with content type, body and the account name parameter.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Body
        let body: [String: Any] = [
            "name": username
        ]
        
        do {
            //Converting the body into JSON readable format by JSONSerializaion.
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch let error {
            completion(.failure(error))
        }
        
        // Hitting the rest api server with the request.
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(error as! Error))
                return
            }
            
            //Using the swift object that is in folder Model->NearAPIDataModel
            var success: CreateAccountModel?
            
            //Converting the response from the server into json readable format.
            if let data = data {
                do {
                    
                    //Decoding the json into a swift object and mapping it to a swift object for easier acces in code.
                    success = try JSONDecoder().decode(CreateAccountModel.self, from: data)
                    guard let json = success else { return }
                    
                    //Returning back the json as swift object.
                    completion(.success(json))
                } catch let error {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    //Sign In Function
    //This function is called when the user wants to sign in to his/her account.
    
    func signInUser(passPhrase: String, completion: @escaping (Result<SignInModel, Error>) -> Void) {
        
        //Url for the rest api server for signin to account.
        guard let url = URL(string: Constants.signInUserURL.rawValue
        ) else { return }
        
        //Post Request with content type, body and the account name parameter.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //Body
        let body: [String: Any] = [
            "seed_phrase": passPhrase
        ]
        
        do {
            //Converting the body into JSON readable format by JSONSerializaion.
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch let error {
            completion(.failure(error.localizedDescription as! Error))
        }
        
        // Hitting the rest api server with the request.
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(error as! Error))
                return
            }
            
            //Using the swift object that is in folder Model->NearAPIDataModel
            var success: SignInModel?
            
            //Converting the response from the server into json readable format.
            if let data = data {
                do {
                    
                    //Decoding the json into a swift object and mapping it to a swift object for easier acces in code.
                    success = try JSONDecoder().decode(SignInModel.self, from: data)
                    guard let json = success else { return }
                    //Returning back the json as swift object.
                    completion(.success(json))
                } catch let error {
                    completion(.failure(error as! Error))
                }
            }
        }.resume()
    }
    
    
}
