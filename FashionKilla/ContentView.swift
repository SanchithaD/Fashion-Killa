//
//  ContentView.swift
//  FashionKilla
//
//  Created by Sanchitha Dinesh on 2/2/24.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        ZStack {
            ARViewContainer()
                .edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                    LazyVGrid(columns: [.init(.adaptive(minimum: 100, maximum: .infinity), spacing: 3)]) {
                        ForEach(1..<4) { ix in
                            Button (action: {
                                print("")
                                
                            }) {
                                Image("Shirt \(ix)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .clipShape(.circle)
                            }
                        }
                    }
                    .padding(.top, 500)
                }
            }
            
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
