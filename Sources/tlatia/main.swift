//
// Created by Carlos Torres on 11/12/19.
//

import Foundation
import ArgumentParser

public struct RuntimeError: Error, CustomStringConvertible {
  var message: String

  public init(_ message: String) {
    self.message = message
  }

  public var description: String {
    message
  }
}

struct Tlatia: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "A encryption/decryption utility",
    subcommands: [Encrypt.self, Decrypt.self]
  )
}

extension Tlatia {
  struct Encrypt: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Encrypts a file using password")

    @Argument(help: "The path to the file for encryption")
    var inputPath: String

    @Argument(help: "The path to the encrypted file")
    var outputPath: String

    func validate() throws {
      guard FileManager.default.fileExists(atPath: inputPath) else {
        throw RuntimeError("The input file does not exist.")
      }
    }

    func run() throws {
      let password = try getPasswordEncryption()
      let body = try String(contentsOfFile: inputPath)

      if let key = Key.init(withPassword: password) {
        if let encoder = Encoder(withKey: key) {
          let base64Encoded = try encoder.encrypt(body)
          try base64Encoded.write(to: URL(fileURLWithPath: outputPath), atomically: true, encoding: String.Encoding.utf8)
        }
      }
    }

    func getPasswordEncryption() throws -> String {
      let password = String(cString: getpass("Enter the password: "))
      let passwordRetry = String(cString: getpass("Enter the password again: "))

      guard password != "" || passwordRetry != "" else {
        throw RuntimeError("Passwords can't be empty")
      }

      guard password == passwordRetry else {
        throw RuntimeError("Passwords don't match")
      }

      return password
    }
  }

  struct Decrypt: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Decrypts a file using a password")

    @Argument(help: "The path to the file for encryption")
    var inputPath: String

    @Argument(help: "The path to the encrypted file")
    var outputPath: String

    func validate() throws {
      guard FileManager.default.fileExists(atPath: inputPath) else {
        throw RuntimeError("The input file does not exist.")
      }
    }

    func run() throws {
      let password = try getPasswordDecryption()
      let body = try String(contentsOfFile: inputPath)

      if let key = Key.init(withPassword: password) {
        if let encoder = Encoder(withKey: key) {
          let decodedBody = try encoder.decrypt(body)
          try decodedBody.write(to: URL(fileURLWithPath: outputPath), atomically: true, encoding: String.Encoding.utf8)
        }
      }
    }

    func getPasswordDecryption() throws -> String {
      let password = String(cString: getpass("Enter the password: "))

      guard password != "" else {
        throw RuntimeError("Passwords can't be empty")
      }

      return password
    }
  }
}

Tlatia.main()