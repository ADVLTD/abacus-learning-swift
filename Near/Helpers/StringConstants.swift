import Foundation

enum Constants: String {
   
   // Userdefaults key name constants
   case nearAccountName = "nearAccountName"
   case nearPublicKey = "nearPublicKey"
   case nearPrivateKey = "nearPrivateKey"
   
   // Url constants
   case getAccountActivityURL = "https://helper.testnet.near.org/account/"
   case createUserURL = "http://34.66.148.111/near-rest-dev/create_user"
   case transactionStatusURL = "https://archival-rpc.testnet.near.org"
   case viewUserWatchHistoryURL = "http://34.66.148.111/near-rest-dev/view"
   case saveVideoDetailsAndSendTokenURL = "http://34.66.148.111/near-rest-dev/call"
   case viewActivityURL = "https://explorer.testnet.near.org/transactions/"
   case generateLinkDropURL = "http://34.66.148.111/near-rest-dev/generate-drop"
   case rewardUserURL = "http://34.66.148.111/near-rest-dev/reward"
   case getPublicKey = "http://34.66.148.111/near-rest-dev/server_public_key"
   case signInUserURL = "http://34.66.148.111/near-rest-dev/user_details"
   case getDataFromURL = "//http://34.66.148.111/near-rest-dev/"
   case getBalanceURL = "http://34.66.148.111/near-rest-dev/balance/"
   
   
   //    case signInUserURL = "http://localhost:3000/user_details"
   //    case getAccountActivityURL = "https://helper.testnet.near.org/account/"
   //    case createUserURL = "http://localhost:3000/create_user"
   //    case transactionStatusURL = "https://archival-rpc.testnet.near.org"
   //    case viewUserWatchHistoryURL = "http://localhost:3000/view"
   //    case saveVideoDetailsAndSendTokenURL = "http://localhost:3000/call"
   //    case viewActivityURL = "https://explorer.testnet.near.org/transactions/"
   //    case generateLinkDropURL = "http://localhost:3000/generate-drop"
   //    case rewardUserURL = "http://localhost:3000/reward"
   //    case getPublicKey = "http://localhost:3000/server_public_key"
   //    case getDataFromURL = "http://localhost:3000/"
   //    case getBalanceURL = "http://localhost:3000/balance/"
   
   
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
