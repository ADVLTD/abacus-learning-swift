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

//Data model for the JSON object returned from the server after signing into account.
struct SignInModel: Codable {
   let publicKey: String?
   let accountName: String?
   let privateKey: String?
   let success: Bool?
}

//Data model for the JSON object returned from the server for the encrypted data
struct EncryptedData: Codable {
   let encryptedData: String?
}

//Data model for the JSON object returned from the server for the Server public key.
struct ServerPublicKey: Codable {
   let publicKey: String?
}


class CreateAccountAPI: NSObject {
   //Singleton Object for CreateAccountAPI
   static let shared = CreateAccountAPI()
   
   //Create User Function
   //This Function is called when the user want to create a account.
   func createUser(username: String, completion: @escaping (Result<CreateAccountModel, Error>) -> Void) {
      //Url for the rest api server for creating account
      guard let url = URL(string: Constants.createUserURL.rawValue) else { return }
      
      var pbError:Unmanaged<CFError>?
      guard let keyPair = RSA.shared.generateKeys() else { return }
      guard let pbData = SecKeyCopyExternalRepresentation((keyPair.publicKey), &pbError) as Data? else {
         print("error: ", pbError!.takeRetainedValue() as Error)
         return
      }
      let strPublicKey = RSA.shared.appendPrefixSuffixTo(pbData.base64EncodedString(options: .lineLength64Characters), prefix: "-----BEGIN RSA PUBLIC KEY-----\n", suffix: "\n-----END RSA PUBLIC KEY-----")
      
      //Post Request with content type, body and the account name parameter.
      var request =  URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.setValue("true", forHTTPHeaderField: "x-encrypt-data")
      
      var payload: [String:String] = [
         "name": username
      ]
      
      let jsonData = try! JSONSerialization.data(withJSONObject: payload, options: [])
      let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)! as String
      
      getPublicKey { response in
         guard let publicKey = response.publicKey else { return }
         guard let encryptedPayload = RSA.shared.encrypt(string: jsonString, publicKey: publicKey) else { return }
         //Body
         let body: [String: Any] = [
            "encryptedData": encryptedPayload,
            "publicKey": strPublicKey
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
            var success: EncryptedData?
            
            //Converting the response from the server into json readable format.
            if let data = data {
               do {
                  success = try JSONDecoder().decode(EncryptedData.self, from: data)
                  guard let encryptedData = success?.encryptedData else { return }
                  guard let decryptedData = RSA.shared.decrypt(encryptedString: encryptedData, privateKey: keyPair.privateKey) else { return }
                  guard let data = decryptedData.data(using: .utf8) else { return }
                  //Decoding the json into a swift object and mapping it to a swift object for easier acces in code.
                  let successfulDecryption = try JSONDecoder().decode(CreateAccountModel.self, from: data)
                  let json = successfulDecryption
                  //Returning back the json as swift object.
                  completion(.success(json))
               } catch let error {
                  completion(.failure(error))
               }
            }
         }.resume()
      }
   }
   
   //Sign In Function
   //This function is called when the user wants to sign in to his/her account.
   //NOTE:- THIS IS THE SAME FUNCTION USED TO "SIGNIN USER" IN THE "SIGNINCONTROLLER" PRESENT IN "SIGN IN" FOLDER.
   func signInUser(passPhrase: String, completion: @escaping (Result<SignInModel, Error>) -> Void) {
      
      //Url for the rest api server for signin to account.
      guard let url = URL(string: Constants.signInUserURL.rawValue) else { return }
      
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
      request.setValue("true", forHTTPHeaderField: "x-encrypt-data")
      
      var payload: [String:String] = [
         "seed_phrase": passPhrase
      ]
      
      let jsonData = try! JSONSerialization.data(withJSONObject: payload, options: [])
      let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)! as String
      
      getPublicKey { response in
         guard let publicKey = response.publicKey else { return }
         guard let encryptedPayload = RSA.shared.encrypt(string: jsonString, publicKey: publicKey) else { return }
         //Body
         let body: [String: Any] = [
            "encryptedData": encryptedPayload,
            "publicKey": strPublicKey
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
            var success: EncryptedData?
            
            //Converting the response from the server into json readable format.
            if let data = data {
               do {
                  //Decoding the server response that is encrypted Data.
                  success = try JSONDecoder().decode(EncryptedData.self, from: data)
                  guard let encryptedData = success?.encryptedData else { return }
                  guard let decryptedData = RSA.shared.decrypt(encryptedString: encryptedData, privateKey: keyPair.privateKey) else { return }
                  guard let data = decryptedData.data(using: .utf8) else { return }
                  //Decoding the json into a swift object and mapping it to a swift object for easier acces in code.
                  let successfulDecryption = try JSONDecoder().decode(SignInModel.self, from: data)
                  let json = successfulDecryption
                  //Returning back the json as swift object.
                  completion(.success(json))
               } catch let error {
                  completion(.failure(error as! Error))
               }
            }
         }.resume()
      }
   }
   
   //Get Server Public Key Function
   //This Function is used to fetch the public key for encryption of the data.
   func getPublicKey(completion: @escaping (ServerPublicKey) -> Void) {
      //URL for getting account balance from server
      let url = "\(Constants.getPublicKey.rawValue)"
      //Hitting the API using URL
      URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
         guard error == nil, let data = data else {
            print("Something went wrong \(String(describing: error?.localizedDescription))")
            return
         }
         var success: ServerPublicKey?
         //Converting the data recieved from API into String
         do {
            success = try JSONDecoder().decode(ServerPublicKey.self, from: data)
            guard let json = success else { return }
            //Returning back the json as swift object.
            completion(json)
         } catch {
            print("Error")
         }
      }.resume()
   }
}
