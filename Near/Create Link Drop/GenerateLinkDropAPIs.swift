import Foundation

//Data model for JSON object returned from server for Genrating LinkDrop
struct GenerateLinkDrop: Codable {
   let success: Bool?
   let newKeyPair: NewKeyPair?
}
struct NewKeyPair: Codable {
   let publicKey: PublicKey?
   let secretKey: String?
   let public_key: String?
   let amount: String?
   let ts: Double?
}
struct PublicKey: Codable {
   let keyType: Int?
   let data: Dictionary<String, Int>?
}


class GenerateLinkDropAPIs {
   //Singleton Object for GenerateLinkDropAPIs
   static let shared = GenerateLinkDropAPIs()
   
   //Generate Link Drop Function
   //This function is used to generate linkdrop in the app.
   func generateLinkDrop(accountName: String, amount: String, privateKey: String, completion: @escaping (Result<GenerateLinkDrop, Error>) -> Void) {
      //Url for the rest api server for generating link drop.
      guard let url = URL(string: Constants.generateLinkDropURL.rawValue) else { return }
      
      var pbError:Unmanaged<CFError>?
      guard let keyPair = RSA.shared.generateKeys() else { return }
      guard let pbData = SecKeyCopyExternalRepresentation((keyPair.publicKey), &pbError) as Data? else {
         print("error: ", pbError!.takeRetainedValue() as Error)
         return
      }
      let strPublicKey = RSA.shared.appendPrefixSuffixTo(pbData.base64EncodedString(options: .lineLength64Characters), prefix: "-----BEGIN RSA PUBLIC KEY-----\n", suffix: "\n-----END RSA PUBLIC KEY-----")
      
      //Post Request with content type, body and the account name parameter.
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      //request.setValue("true", forHTTPHeaderField: "x-encrypt-data")
      
      var payload: [String: String] = [
         "account_id": accountName,
         "private_key": privateKey,
         "contract": "testnet",
         "amount": amount
      ]
      
      let jsonData = try! JSONSerialization.data(withJSONObject: payload, options: [])
      let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)! as String
      
      CreateAccountAPI.shared.getPublicKey { response in
         guard let publicKey = response.publicKey else { return }
         guard let encryptedPayload = RSA.shared.encrypt(string: jsonString, publicKey: publicKey) else { return }
         
         //Body
         let body: [String: Any] = [
            "encryptedData": encryptedPayload,
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
            //Converting the response from the server into json readable format.
            if let data = data {
               do {
                  let success = try JSONDecoder().decode(GenerateLinkDrop.self, from: data)
                  //Returning back the json as swift object.
                  completion(.success(success))
               } catch let error {
                  completion(.failure(error as! Error))
               }
            }
         }.resume()
      }
   }
   
   //Reclaim Near Function
   //This function is used to reclaim the near tokens used for generating link drop.
   
   func reclaimNear(accountName: String, secretKey: String, completion: @escaping (Bool) -> Void) {
      //Url for reclaiming near tokens used for generating link drop.
      guard let url = URL(string: Constants.saveVideoDetailsAndSendTokenURL.rawValue) else { return }
      //Post Request with content type, body and the accountName and videoID parameter.
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      
      var payload: [String: Any] = [
         "account_id":"testnet",
         "private_key":"ed25519:\(secretKey)",
         "contract":"testnet",
         "method":"claim",
         "params": ["account_id": accountName]
      ]
      
      let jsonData = try! JSONSerialization.data(withJSONObject: payload, options: [])
      let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)! as String
      
      CreateAccountAPI.shared.getPublicKey { response in
         guard let publicKey = response.publicKey else { return }
         guard let encryptedPayload = RSA.shared.encrypt(string: jsonString, publicKey: publicKey) else { return }
         
         //Body
         let body: [String: Any] = [
            "encryptedData": encryptedPayload
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
                  //Decoding the json and checking for successfull value.
                  let success = try? JSONDecoder().decode(RewardUser.self, from: data)
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
}
