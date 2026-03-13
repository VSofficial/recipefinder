//
//  ContentView.swift
//  recipefinder
//
//  Created by Varun Sharma on 07/03/26.
//

import SwiftUI

struct ContentView3: View {
    
    @State private var isOn = false
    
    var body: some View {
        VStack() {
        Text("Recipe Matches")
                .font(.title)
        
            Spacer(minLength: 30)
            
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
                
                Toggle("", isOn: $isOn)
                    .tint(Color.orange)
                
                Spacer()
            }
            
            Divider()
            
            List {
                ForEach(recipes, id:\.self) { item in
                    HStack {
                        Image(systemName: "carrot.fill")
                            .font(Font.largeTitle)
                            .foregroundColor(.orange.opacity(0.8))
                        VStack {
                            Text(item.name)
                                .font(.system(size: 18))
                                
                            HStack() {
                                Text(item.description)
                                //Text("Easy")
                            }
                            
                        }
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(Font.title)
                            .foregroundColor(.green)
                    
                    
                        
                    }
                    .listRowBackground(Color(.systemGray6))
                    .padding(.vertical, 4)
                 
                }
                
            }
            .scrollContentBackground(.hidden)
            .background(Color.white)
          
        
        Spacer()
            
        }
        .padding()
    }
}

#Preview {
    ContentView3()
}
