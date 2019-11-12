//
// Created by Carlos Torres on 11/12/19.
//

import CryptoSwift

struct Key {
  let keyLength = 32
  let password: String
  let salt: String
  let keyDerivation: PKCS5.PBKDF2

  var key: [UInt8] {
    do {
      return try self.keyDerivation.calculate()
    } catch {
      return []
    }
  }

  init? (withPassword password: String) {
    self.password = password
    self.salt = String.random(length: self.keyLength)
    do {
      self.keyDerivation = try PKCS5.PBKDF2(
        password: Array(self.password.utf8),
        salt: Array(self.salt.utf8),
        keyLength: self.keyLength)
    } catch {
      return nil
    }
  }
}
