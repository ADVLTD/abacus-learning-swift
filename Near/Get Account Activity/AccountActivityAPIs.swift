//
//  AccountActivityAPIs.swift
//  Near
//
//  Created by Bhushan Mahajan on 19/10/21.
//

import Foundation

//Data model for the JSON object returned from server For Account Activity
struct AccountActivity: Codable {
    let block_hash: String?
    let block_timestamp: String?
    let hash: String?
    let action_index: Int?
    let signer_id: String?
    let receiver_id: String?
    let action_kind: String?
    let args: Args?
}

struct Args: Codable {
    let gas: Double?
    let deposit: String?
    let access_key: AccessKey?
    let public_key: String?
}

struct AccessKey: Codable {
    let nonce: Int?
    let permission: Permission?
}

struct Permission: Codable {
    let permission_kind: String?
}

//Data model for JSON object returned from server for Transaction Details
struct TransactionResponse: Decodable {
    var successfull: String?
    
    private enum StatusKeys: String, CodingKey {
        case successfull = "SuccessValue"
    }
    
    private enum ResultKeys: String, CodingKey {
        case status
    }
    
    private enum TransactionResponseKeys: String, CodingKey {
        case result
    }
    
    init(from decoder: Decoder) throws {
        if let transactionContainer = try? decoder.container(keyedBy: TransactionResponseKeys.self) {
            if let resultContainer = try? transactionContainer.nestedContainer(keyedBy: ResultKeys.self, forKey: .result) {
                if let statusContainer = try? resultContainer.nestedContainer(keyedBy: StatusKeys.self, forKey: .status) {
                    self.successfull = try statusContainer.decodeIfPresent(String.self, forKey: .successfull)
                }
            }
        }
    }
}

class AccountActivityAPIs {
    
    //Singleton Object for NearResrAPI
    static let shared = AccountActivityAPIs()
    
    //Get Account Balance Function
    //This Function is used to fetch the account balance for the current user.
    
    func getBalance(accountName: String, completion: @escaping (String) -> Void) {
        //URL for getting account balance from server
        let url = "\(Constants.getBalanceURL.rawValue)\(accountName)"
        //Hitting the API using URL
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil, let data = data else {
                print("Something went wrong \(String(describing: error?.localizedDescription))")
                return
            }
            //Converting the data recieved from API into String
            if let stringResponse = String(data: data, encoding: .utf8) {
                completion(stringResponse)
            }
        }.resume()
    }
    
    func getAccountActivity(accountName: String, completion: @escaping ([AccountActivity]) -> Void) {
        //URL for getting account activity from server
        let url = "\(Constants.getAccountActivityURL.rawValue)\(accountName)/activity?limit=10"
        //Hitting the API using URL
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard error == nil, let data = data else {
                print("Something went wrong \(String(describing: error?.localizedDescription))")
                return
            }
            var result: [AccountActivity]?
            do {
                //Decoding the data into array of AccountActivity objects
                result = try JSONDecoder().decode([AccountActivity].self, from: data)
            } catch {
                print("Error Converting data!!")
            }
            guard let json = result else {
                return
            }
            completion(json)
        }.resume()
    }
    
    //TransactionStatus Function
    //This function is called when the user wants to view his/her account transactions and recent activity.
    
    func transactionStatus(accountName: String, hash: String, completion: @escaping (Bool) -> Void) {
        
        //Url for the rest api server for getting the recent transaction details for account.
        guard let url = URL(string: Constants.transactionStatusURL.rawValue) else { return }
        
        //Post Request with content type, body and the accountName and hash parameter.
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        //Body
        let body: [String: Any] = [
            "jsonrpc":"2.0",
            "id":"dontcare",
            "method":"tx",
            "params": [hash, accountName]
        ]
        
        do {
            //Converting the body into JSON readable format by JSONSerializaion.
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch let error {
            print("Error occured while parsing the body! \(error.localizedDescription)")
        }
        
        // Hitting the rest api server with the request.
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Something went wrong!! \(String(describing: error?.localizedDescription))")
                return
            }
            
            //Converting the response from the server into json readable format.
            if let data = data {
                do {
                    
                    //Decoding and checking for successfull status of transaction.
                    let success = try? JSONDecoder().decode(TransactionResponse.self, from: data)
                    if let success = success {
                        if success.successfull == nil {
                            completion(false)
                        } else {
                            completion(true)
                        }
                    }
                } catch let error {
                    print("Error in parsing data!! \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
