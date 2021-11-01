import Foundation

//Data model for JSON object returned from server for Saving Video Details and Sending Token to user Details
struct RewardUser: Decodable {
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
struct RewardUserError: Decodable {
   var error: String?
}


class RewardUserAPIs {
   //Singleton Object for RewardUserAPIs
   static let shared = RewardUserAPIs()
   
   //Reward User Function
   //This function is used to reward user with NEAR for watching video once
   func rewardUser(accountName: String, privateKey: String, videoId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
      
      //Url for the rest api server for getting the watch history for the user.
      guard let url = URL(string: Constants.rewardUserURL.rawValue) else { return }
      
      //Post Request with content type, body and the accountName and hash parameter.
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      //Body
      let viewResourceParamObject: [String: Any] = [
         "method": "checkUserVideoWatchHistory",
         "params": ["mainAccount": accountName, "videoId": videoId]
      ]
      
      let writeResourceParamObject: [String: Any] = [
         "method": "saveUserVideoDetails",
         "params": ["mainAccount": accountName, "videoId": videoId]
      ]
      let body: [String: Any] = [
         "accountId":accountName,
         "viewResourceParamObject": viewResourceParamObject,
         "privateKey": privateKey,
         "rewardTokenAmount": "2",
         "writeResourceParamObject": writeResourceParamObject
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
         
         //Converting the response from the server into json readable format.
         if let data = data {
            //Checking server response for already watched video.
            let dataString = String(data: data, encoding: .utf8)
            if dataString == "\"User has already utilized the resource\"" {
               completion(.success(false))
            } else {
               do {
                  //Decoding the json and checking for successfull value.
                  if let jsonData = try? JSONDecoder().decode(RewardUser.self, from: data) {
                     if jsonData.successfull != nil {
                        
                        //If near is added to wallet this is true
                        completion(.success(true) )
                     }
                  } else if let jsonErrorData = try? JSONDecoder().decode(RewardUserError.self, from: data) {
                     
                     //Checking or error in server response.
                     if jsonErrorData.error != nil {
                        completion(.failure(CustomErrors.lowBalanceError))
                     }
                  }
               } catch let error {
                  completion(.failure(error))
               }
            }
         }
      }.resume()
   }
}
