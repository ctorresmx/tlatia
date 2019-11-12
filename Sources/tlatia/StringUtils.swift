//
// Created by Carlos Torres on 11/12/19.
//

import Foundation

extension String {
  var asArray: [UInt8] {
    Array(self.utf8)
  }
}

extension String {
  static var chars: [Character] = {
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".map({$0})
  } ()

  static func random(length: Int) -> String {
    var randomString: [Character] = []

    for _ in 0..<length {
      randomString.append(chars[Int(arc4random_uniform(UInt32(chars.count)))])
    }

    return String(randomString)
  }
}