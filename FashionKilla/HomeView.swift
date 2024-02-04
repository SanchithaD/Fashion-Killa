//
//  HomeView.swift
//  FashionKilla
//
//  Created by Sanchitha Dinesh on 2/3/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                
                VStack {
                    Text("Fashion Killa")
                        .font(.system(size: 56.0))
                        .foregroundColor(.black)
                        .bold()
                        .padding()
                    
                    Spacer()
                        .frame(height: 100)
                    NavigationLink(destination: ContentView()) {
                        Text("Try on Clothes!")
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .padding()
                            .background(Color.purple.opacity(0.5))
                            .cornerRadius(10)
                            .shadow(color: Color.white, radius: 20)
                            .padding()
                    
                    }
                    NavigationLink(destination: ClothingRecommender()) {
                        Text("Clothing Recommender")
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .padding()
                            .background(Color.purple.opacity(0.5))
                            .cornerRadius(10)
                            .shadow(color: Color.white, radius: 20)
                            .padding()
                    
                    }
                }
                
            }.ignoresSafeArea()
            
        }
        .navigationTitle("Fashion Killa")
        .navigationBarHidden(false)
    }
}

#Preview {
    HomeView()
}
