

import SwiftUI

struct SmallCardView<Model>: View where Model: TextImageProviding {
  let model: Model

  var body: some View {
    VStack(alignment: .center, spacing: 0) {
      Group {
        if let image = model.image {
          Image(uiImage: image)
            .resizable()
        } else {
          Color(uiColor: .systemFill)
        }
      }
      .aspectRatio(contentMode: .fit)
      .frame(
        width: 150,
        height: 120,
        alignment: .center
      )
      .clipped()

      Text(model.title)
        .font(.headline)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
        .padding(8)
        .frame(
          width: 150,
          alignment: .center
        )
    }
    .background(Color(uiColor: .tertiarySystemBackground))
    .cornerRadius(12.0)
    .shadow(radius: 1)
    .padding(4)
  }
}

struct SmallCardView_Previews: PreviewProvider {
  static var previews: some View {
    SmallCardView(model: Shirt.black)
      .previewLayout(.sizeThatFits)
  }
}
