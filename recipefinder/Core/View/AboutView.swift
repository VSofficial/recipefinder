//
//  AboutView.swift
//  recipefinder
//
//  Created by Varun Sharma on 04/08/26.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack() {
            List() {
                
                    HStack(spacing:20) {
                        Image(systemName: "sailboat.fill")
                        Text("Buy Premium")
                    }
                    .listRowBackground(Color.yellow.opacity(0.05))
                    HStack(spacing:20) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Share App")
                    }
                    .listRowBackground(Color.yellow.opacity(0.05))
                    HStack(spacing:20) {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                    .listRowBackground(Color.yellow.opacity(0.05))
                    HStack(spacing:20) {
                        Image(systemName: "figure.martial.arts")
                        Text("About Developer")
                    }
                
                .listRowBackground(Color.yellow.opacity(0.05))
            }
           
            .foregroundStyle(Color(.red).opacity(0.8))
            .fontWeight(.semibold)
            .font(Font.system(size: 22))
            .scrollContentBackground(.hidden)
            
            .background(Color.yellow.opacity(0.15))
        }
        
       
    }
        
    
}
    

#Preview {
    AboutView()
   
        
}
