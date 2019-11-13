//
// Created by Carlos Torres on 11/12/19.
//

import CryptoSwift

struct Key {
  let keyLength = 32
  let password: String
  let salt: String = "icGFEkNbIuNK1cz1qNq5kMV1jqkpvduX" 
  let keyDerivation: PKCS5.PBKDF2

  var key: [UInt8] {
    do {
      return try keyDerivation.calculate()
    } catch {
      return []
    }
  }

  init? (withPassword password: String) {
    self.password = password
    do {
      keyDerivation = try PKCS5.PBKDF2(
        password: Array(self.password.utf8),
        salt: Array(salt.utf8),
        keyLength: keyLength)
    } catch {
      return nil
    }
  }
}
