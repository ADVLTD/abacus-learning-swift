import Foundation

enum Constants: String {
    
    // Userdefaults key name constants
    case nearAccountName = "nearAccountName"
    case nearPublicKey = "nearPublicKey"
    case nearPrivateKey = "nearPrivateKey"
    
    // Url constants
    case getDataFromURL = "//http://34.66.148.111/near-rest-dev/"
    case getBalanceURL = "http://34.66.148.111/near-rest-dev/balance/"
    case getAccountActivityURL = "https://helper.testnet.near.org/account/"
    case createUserURL = "http://34.66.148.111/near-rest-dev/create_user"
    case signInUserURL = "http://34.66.148.111/near-rest-dev/user_details"
    case transactionStatusURL = "https://archival-rpc.testnet.near.org"
    case viewUserWatchHistoryURL = "http://34.66.148.111/near-rest-dev/view"
    case saveVideoDetailsAndSendTokenURL = "http://34.66.148.111/near-rest-dev/call"
    case viewActivityURL = "https://explorer.testnet.near.org/transactions/"
    case generateLinkDropURL = "http://34.66.148.111/near-rest-dev/generate-drop"
    case rewardUserURL = "http://34.66.148.111/near-rest-dev/reward"
}


enum CustomErrors: LocalizedError {
    case lowBalanceError
    case dataParsingError
    
    var errorDescription: String? {
        switch self {
        case .lowBalanceError:
            return "Master Account has low balance!"
        case .dataParsingError:
            return "Error in Parsing the JSON Data!"
        }
    }
}
