import UIKit

class RSA {
   
   //Singleton object for the RSA class.
   static let shared = RSA()
   //Tuple named Keypair to return public and private key at the same time.
   typealias KeyPair = (publicKey: SecKey, privateKey: SecKey)
   
   //Function for generating public and private keys.
   func generateKeys() -> KeyPair? {
      let privateKeyTag = "com.adv.nmde1".data(using: .utf8)!
      //Variables to store both the public and private keys.
      var publicKey, privateKey: SecKey?
      var item: CFTypeRef?
      
      let getQuery: [String: Any] = [
         kSecClass as String: kSecClassKey,
         kSecAttrApplicationTag as String: privateKeyTag,
         kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
         kSecReturnRef as String: true
      ]
      
      let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
      if status == errSecSuccess {
         privateKey = item as! SecKey
         publicKey = SecKeyCopyPublicKey(privateKey!)
         return KeyPair(publicKey: publicKey!, privateKey: privateKey!)
      } else {
         let privateKeyParams: [String: Any] = [
            kSecAttrCanDecrypt as String: true,
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: privateKeyTag
         ]
         let attributes = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 4096,
            kSecPrivateKeyAttrs as String: privateKeyParams
         ] as CFDictionary
         //Generating both the public and private keys via the SecGeneratePair APIs.
         SecKeyGeneratePair(attributes, &publicKey, &privateKey)
         return KeyPair(publicKey: publicKey!, privateKey: privateKey!)
      }
      return nil
   }
   
   //Function for Encrypting String.
   func encrypt(string: String, publicKey: String) -> String? {
      var error: Unmanaged<CFError>? = nil
      
      //      let keyString = publicKey.replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----\r\n", with: "").replacingOccurrences(of: "\r\n-----END PUBLIC KEY-----", with: "").replacingOccurrences(of: "\r\n", with: "")
      
      let keyString = publicKey.replacingOccurrences(of: "-----BEGIN PUBLIC KEY-----\n", with: "").replacingOccurrences(of: "\n-----END PUBLIC KEY-----", with: "").replacingOccurrences(of: "\n", with: "")
      
      guard let keyData = Data(base64Encoded: keyString) else {
         print("Error in converting public key from string to data.")
         return nil
      }
      
      var attributes: CFDictionary {
         return [
            kSecAttrKeyType         : kSecAttrKeyTypeRSA,
            kSecAttrKeyClass        : kSecAttrKeyClassPublic,
            kSecAttrKeySizeInBits   : 4096,
            kSecReturnPersistentRef : kCFBooleanTrue
         ] as CFDictionary
      }
      
      guard let publicKeySec = SecKeyCreateWithData(keyData as CFData, attributes, &error) else {
         print(error.debugDescription)
         return nil
      }
      
      guard let stringData = string.data(using: .utf8) else {
         print("Error converting string to data")
         return nil
      }
      
      guard let encryptData = SecKeyCreateEncryptedData(publicKeySec, SecKeyAlgorithm.rsaEncryptionPKCS1, stringData as CFData, nil) else {
         print("Error encrypting data.")
         return nil
      }
      
      let data: Data = encryptData as Data
      return data.base64EncodedString()
   }
   
   //Function for Decrypting encrypted string.
   func decrypt(encryptedString: String, privateKey: SecKey) -> String? {
      guard let data = Data(base64Encoded: encryptedString, options: []) else {
         print("Bad message to decrypt")
         return nil
      }
      guard let decryptData = SecKeyCreateDecryptedData(privateKey, SecKeyAlgorithm.rsaEncryptionPKCS1, data as CFData, nil) else {
         print("Decryption Error")
         return nil
      }
      let decryptedData = decryptData as Data
      
      
      guard let decryptedString = String(data: decryptedData, encoding: .utf8) else {
         print("Error retrieving string")
         return nil
      }
      return decryptedString
   }
   
   //Function for appending the prefix and suffix to the public key.
   func appendPrefixSuffixTo(_ string: String, prefix: String, suffix: String) -> String {
      return "\(prefix)\(string)\(suffix)"
   }
}
