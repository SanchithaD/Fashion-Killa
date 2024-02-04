

import SwiftUI

struct CardsStackView<Model>: View where Model: TextImageProviding & Hashable {
  let models: [Model]
  let onRemove: (_ model: Model, _ isLiked: Bool) -> Void

  var body: some View {
    GeometryReader { proxy in
      ZStack {
        ForEach(
          Array(models.enumerated()),
          id: \.element
        ) { index, item in
          if (models.count - 3)...models.count ~= index {
            CardView(
              model: item
            ) { model, isLiked in
              withAnimation(.spring()) {
                onRemove(model, isLiked)
              }
            }
            .frame(
              width: cardWidth(in: proxy, index: index),
              height: Constants.cardHeight
            )
            .offset(x: 0, y: cardOffset(in: proxy, index: index))
          }
        }
      }
      .frame(width: proxy.size.width, alignment: .center)
    }
    .frame(height: Constants.cardHeight + 16.0)
    .transition(.scale)
    .padding(.horizontal)
  }

  private func cardWidth(in geometry: GeometryProxy, index: Int) -> CGFloat? {
    let offset = cardOffset(in: geometry, index: index)

    let addedValue: CGFloat
    if geometry.size.width > 1536 {
      addedValue = 700
    } else if geometry.size.width > 1024 {
      addedValue = 400
    } else if geometry.size.width > 512 {
      addedValue = 100
    } else {
      addedValue = 0
    }

    let result = geometry.size.width - offset - addedValue

    if result <= 0 {
      return nil
    } else {
      return result
    }
  }

  private func cardOffset(in geometry: GeometryProxy, index: Int) -> CGFloat {
    CGFloat(models.count - 1 - index) * 12
  }
}

private enum Constants {
  static let cardHeight: CGFloat = 380
}

struct CardsStackView_Previews: PreviewProvider {
  static var previews: some View {
    CardsStackView(
      models: [Shirt.black]
    ) { _, _ in }
  }
}
