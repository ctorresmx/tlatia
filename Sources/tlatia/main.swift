let password = "asasdasdasdasd"
let body = "testing string"

if let key = Key.init(withPassword: password) {
  if let encoder = Encoder(withKey: key) {

    let base64Encoded = try encoder.encrypt(body)
    print(base64Encoded)

    let base64Decoded = try encoder.decrypt(base64Encoded)
    print(base64Decoded)
  }
}