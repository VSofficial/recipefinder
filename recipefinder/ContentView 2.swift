//
//  ContentView.swift
//  recipefinder
//
//  Created by Varun Sharma on 07/03/26.
//

import SwiftUI


struct ContentView2: View {
    
   // var isChecked:Bool = false
    @State private var checked = false
    

    var body: some View {
        
        //@State var isChecked:Bool = true
        VStack(spacing:30) {
            Text("Your Pantry")
            
            
            HStack {
                Text("Veggies")
                    .font(Font.largeTitle)
                    .foregroundColor(.yellow)
                
                Spacer()
                
                Text("3 selected")
                
            }
          
            ForEach(0..<3) { i in
                HStack {
                    Image(systemName: "cup.and.saucer.fill")
                        .font(Font.largeTitle)
                        .foregroundColor(.brown)
                    VStack {
                        Text("Carrot")
                        Text("Gajar")
                    }
                    
                    Spacer()
                    
                  CheckboxView(isChecked: $checked)
                }
            }
            
            Spacer()
            
            Button(
                action: {
                   // Text("Match 12 Recipes")
                }
            ) {
                Text("Match 12 Recipes")
                    .frame(width: 200, height: 40, alignment: .center)
                    .font(.system(size: 20, weight: .semibold, design: .default))
                    .foregroundStyle(Color.white)
                
            }
            
            .foregroundStyle(Color.black)
            .background(Color.orange)
            .buttonStyle(.bordered)
            .clipShape(.capsule)
            
          
        }
        .padding()
    }
}

#Preview {
    ContentView2()
}


struct CheckboxView: View {

    @Binding var isChecked: Bool

    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundStyle(Color.orange)
                    .font(Font.system(size: 30))
                    
            }
        }
    }
}
