//
//  ContentView.swift
//  recipefinder
//
//  Created by Varun Sharma on 07/03/26.
//

import SwiftUI

struct ContentView3: View {
    var body: some View {
        VStack(spacing:30) {
        Text("Recipe Matches")
                .font(.title)
        
            
            HStack() {
                VStack {
                    Text("Strict Match Only")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .opacity(0.9)
                    
                        
                    Text("Using only items you have")
                        .font(.system(size: 14))
                        //.fontWeight(.semibold)
                        .opacity(0.8)
                    
                }
                Spacer()
            }
        
        
        Spacer()
            
        }
        .padding()
    }
}

#Preview {
    ContentView3()
}
