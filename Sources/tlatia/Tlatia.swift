//
// Created by Carlos Torres on 11/12/19.
//

import CryptoSwift

class Encoder {
  private let tlatiaCode = "TLATIA_ENCODED_"
  private let key: Key

  init? (withKey key: Key) {
    self.key = key
  }

  private func generateCipher(_ key: Key, _ iv: String) -> Cipher? {
    do {
      return try AES(
        key: key.key,
        blockMode: CBC(iv: iv.asArray))
    } catch {
      return nil
    }
  }

  func encrypt(_ value: String) throws -> String {
    let iv = String.random(length: AES.blockSize)
    if let cipher = generateCipher(key, iv) {
      if let encryptedValue = try value.encryptToBase64(cipher: cipher) {
        return "\(tlatiaCode)\(iv)\n\(encryptedValue)\n"
      }
    }
    throw EncryptionError.encryptionError
  }

  func decrypt(_ value: String) throws -> String {
    let chunks = value.split { $0.isNewline }
    guard chunks.count == 2 else {
      throw EncryptionError.badEncryptionFormat
    }

    let header = String(chunks[0])
    let body = String(chunks[1])
    guard header.starts(with: tlatiaCode) else {
      throw EncryptionError.notEncryptedByTlatia
    }

    let header_chunks = header.split(separator: "_")
    let iv = String(header_chunks[2])
    guard iv.count == AES.blockSize else {
      throw EncryptionError.badEncryptionFormat
    }

    if let cipher = generateCipher(key, String(iv)) {
      return try body.decryptBase64ToString(cipher: cipher)
    }
    throw EncryptionError.encryptionError
  }
}