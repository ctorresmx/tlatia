//
// Created by Carlos Torres on 11/12/19.
//

import Foundation

func encrypt(file: String, withPassword password: String, toFile outputPath: String) throws {
  let body = try String(contentsOfFile: file)

  if let key = Key.init(withPassword: password) {
    if let encoder = Encoder(withKey: key) {
      let base64Encoded = try encoder.encrypt(body)
      try base64Encoded.write(to: URL(fileURLWithPath: outputPath), atomically: true, encoding: String.Encoding.utf8)
    }
  }
}

func decrypt(file: String, withPassword password: String, toFile outputPath: String) throws {
  let body = try String(contentsOfFile: file)

  if let key = Key.init(withPassword: password) {
    if let encoder = Encoder(withKey: key) {
      let decodedBody = try encoder.decrypt(body)
      try decodedBody.write(to: URL(fileURLWithPath: outputPath), atomically: true, encoding: String.Encoding.utf8)
    }
  }
}

enum Operation: String {
  case encrypt;
  case decrypt;
}

guard CommandLine.argc == 4 else {
  print("Usage: tlatia OPERATION INPUT OUTPUT")
  exit(EXIT_FAILURE)
}

let operationString = CommandLine.arguments[1]
let inputFilePath = CommandLine.arguments[2]
let outputFilePath = CommandLine.arguments[3]

guard FileManager.default.fileExists(atPath: inputFilePath) else {
  print("No such input file")
  exit(EXIT_FAILURE)
}

func getPasswordEncryption() throws -> String {
  let password = String(cString: getpass("Enter the password: "))
  let passwordRetry = String(cString: getpass("Enter the password again: "))

  guard password != "" || passwordRetry != "" else {
    print("Passwords can't be empty")
    exit(EXIT_FAILURE)
  }

  guard password == passwordRetry else {
    print("Passwords don't match")
    exit(EXIT_FAILURE)
  }

  return password
}

func getPasswordDecryption() throws -> String {
  let password = String(cString: getpass("Enter the password: "))

  guard password != "" else {
    print("Passwords can't be empty")
    exit(EXIT_FAILURE)
  }

  return password
}

if let operation = Operation(rawValue: operationString) {
  switch operation {
  case .encrypt:
    let password = try getPasswordEncryption()
    try encrypt(file: inputFilePath, withPassword: password, toFile: outputFilePath)
  case .decrypt:
    let password = try getPasswordDecryption()
    try decrypt(file: inputFilePath, withPassword: password, toFile: outputFilePath)
  }

  exit(EXIT_SUCCESS)
}

print("There's no such operation \"\(operationString)\"")
exit(EXIT_FAILURE)