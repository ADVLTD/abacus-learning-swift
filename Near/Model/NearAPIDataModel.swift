//
//  NearAPIDataModel.swift
//  Near
//
//  Created by Bhushan Mahajan on 24/09/21.
//

import Foundation

struct Data: Codable {
    let text: String
}

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

//Data model for the Json object returned from server after sigin in.

struct SignInModel: Codable {
    let publicKey: String?
    let accountName: String?
    let privateKey: String?
    let success: Bool?
    let text: String?
}

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

//Data model for JSON object returned from server for Saving Video Details and Sending Token to user Details

struct SaveVideoDetailsAndSendToken: Decodable {
    var successfull: String?
    
    private enum StatusKeys: String, CodingKey {
        case successfull = "SuccessValue"
    }
    
    private enum SaveUserVideoDetailsKeys: String, CodingKey {
        case status
    }
    
    init(from decoder: Decoder) throws {
        if let saveUserVideoContainer = try? decoder.container(keyedBy: SaveUserVideoDetailsKeys.self) {
            if let statusContainer = try? saveUserVideoContainer.nestedContainer(keyedBy: StatusKeys.self, forKey: .status) {
                self.successfull = try statusContainer.decodeIfPresent(String.self, forKey: .successfull)
            }
        }
    }
}
