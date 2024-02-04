

import UIKit.UIImage

struct Shirt: Codable {
  let title: String
  let imageName: String
  let color: Color
  let sleeve: Sleeve
  let design: Design
  let neck: Neck

  enum CodingKeys: String, CodingKey {
    case title
    case imageName = "image_name"
    case color, sleeve, design, neck
  }

  enum Color: String, Codable {
    case black
    case blue
    case red
    case white
  }

  enum Design: String, Codable {
    case nonPlain = "non-plain"
    case plain
  }

  enum Neck: String, Codable {
    case crew
    case polo
    case vneck
  }

  enum Sleeve: String, Codable {
    case long
    case none
    case short
  }
}

extension Shirt: Hashable, Identifiable, TextImageProviding {
  var id: String {
    imageName
  }
}

extension Shirt {
  var image: UIImage? {
    UIImage(named: imageName)
  }
}

extension Shirt {
  static var black: Shirt {
    Shirt(
      title: "Plain Polo Short-Sleeve Black",
      imageName: "black-short-plain-polo",
      color: .black,
      sleeve: .short,
      design: .plain,
      neck: .polo
    )
  }
}
