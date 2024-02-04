

import SwiftUI

struct ClothingRecommender: View {
  @StateObject private var viewModel: MainViewModel

  init() {
    _viewModel = StateObject(wrappedValue: MainViewModel())
  }

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading) {
          SectionTitleView(text: "Swipe to Like or Dislike")

            if viewModel.shirts.isEmpty {
            HStack {
              Spacer()

              VStack {
                Text("All Done!")
                  .multilineTextAlignment(.center)
                  .font(.callout)
                  .foregroundColor(.secondary)
                Button("Try Again") {
                  withAnimation {
                    viewModel.resetUserChoices()
                  }
                }
                .font(.headline)
                .buttonStyle(.borderedProminent)
              }

              Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 32)
          } else {
            CardsStackView(models: viewModel.shirts) { item, isLiked in
              withAnimation(.spring()) {
                viewModel.didRemove(item, isLiked: isLiked)
              }
            }
            .zIndex(1)
          }

          RecommendationsView(recommendations: viewModel.recommendations)
        }
      }
      .navigationTitle("Tshirtinder!")
      .task {
        await viewModel.loadAllShirts()
      }
    }
    .navigationViewStyle(.stack)
  }
}


