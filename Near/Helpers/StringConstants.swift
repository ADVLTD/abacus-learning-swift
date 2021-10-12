//
//  StringConstants.swift
//  Near
//
//  Created by Bhushan Mahajan on 04/10/21.
//

import Foundation

enum Constants: String {
    
    // Userdefaults key name constants
    case nearAccountName = "nearAccountName"
    case nearPublicKey = "nearPublicKey"
    case nearPrivateKey = "nearPrivateKey"
    case nearLinkDropAArray = "linkDropArray"
    
    // Url constants
    case getDataFromURL = "http://localhost:3000/"
    case getBalanceURL = "http://localhost:3000/balance/"
    case getAccountActivityURL = "https://helper.testnet.near.org/account/"
    case createUserURL = "http://localhost:3000/create_user"
    case signInUserURL = "http://localhost:3000/user_details"
    case transactionStatusURL = "https://archival-rpc.testnet.near.org"
    case viewUserWatchHistoryURL = "http://localhost:3000/view"
    case saveVideoDetailsAndSendTokenURL = "http://localhost:3000/call"
    case viewActivityURL = "https://explorer.testnet.near.org/transactions/"
    case generateLinkDropURL = "http://localhost:3000/generate-drop"
}
