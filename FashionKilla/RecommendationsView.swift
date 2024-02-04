
import SwiftUI

struct RecommendationsView<Model>: View where Model: TextImageProviding & Hashable & Identifiable {
  let recommendations: [Model]

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      SectionTitleView(text: "Recommendations")

      if !recommendations.isEmpty {
        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(alignment: .center, spacing: 12.0) {
            ForEach(recommendations) { item in
              SmallCardView(model: item)
            }
          }
          .padding(.horizontal)
        }
      } else {
        HStack {
          Spacer()

          VStack {
            Image(systemName: "tshirt.fill")
              .imageScale(.large)
              .font(.title3)
            Text("Nothing yet!")
              .multilineTextAlignment(.center)
              .font(.callout)
          }
          .foregroundColor(.secondary)

          Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 32)
      }
    }
  }
}

struct RecommendationsView_Previews: PreviewProvider {
  static var previews: some View {
    RecommendationsView(
      recommendations: [Shirt.black]
    )
    .previewLayout(.fixed(width: 400.0, height: 220.0))
  }
}
