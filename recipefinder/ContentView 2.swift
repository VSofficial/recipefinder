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
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack() {
        //@State var isChecked:Bool = true
            VStack(spacing:30) {
                Text("Your Pantry")
                
                
                //            HStack {
                //                Text("Veggies")
                //                    .font(Font.largeTitle)
                //                    .foregroundColor(.yellow)
                //
                //                Spacer()
                //
                //                Text("3 selected")
                //
                //            }
                
                //            ForEach(0..<3) { i in
                //                HStack {
                //                    Image(systemName: "cup.and.saucer.fill")
                //                        .font(Font.largeTitle)
                //                        .foregroundColor(.brown)
                //                    VStack {
                //                        Text("Carrot")
                //                        Text("Gajar")
                //                    }
                //
                //                    Spacer()
                //
                //                  CheckboxView(isChecked: $checked)
                //                }
                //            }
                
                List {
                    
                    
                    
                    Section(
                        header:
                            Text("Veggies")
                            .font(Font.largeTitle)
                            .foregroundColor(.orange)
                        
                    ) {
                        
                        
                        ForEach(ingredients.veggies, id: \.self) { item in
                            HStack() {
                                Image(systemName: "carrot.fill")
                                    .font(Font.largeTitle)
                                    .foregroundColor(.orange.opacity(0.8))
                                VStack {
                                    Text(item)
                                    Text("Gajar")
                                    
                                    
                                }
                                
                                
                                Spacer()
                                
                                CheckboxView(isChecked: $checked)
                            }
                            .listRowBackground(Color(.white))
                            .padding(.vertical, 4)
                            
                        }
                        
                    }
                    
                    Section(header:
                                Text("Fruits")
                        .font(Font.largeTitle)
                        .foregroundColor(.orange)
                    ) {
                        ForEach(ingredients.fruits, id: \.self) { item in
                            HStack {
                                Image(systemName: "cup.and.saucer.fill")
                                    .font(Font.largeTitle)
                                    .foregroundColor(.brown)
                                VStack {
                                    Text(item)
                                    Text("Gajar")
                                }
                                
                                Spacer()
                                
                                CheckboxView(isChecked: $checked)
                            }
                            .listRowBackground(Color(.white))
                            .padding(.vertical, 4)
                            // .padding(.leading, 0)
                            
                        }
                        
                    }
                    
                    Section(header:
                                Text("Spices")
                        .font(Font.largeTitle)
                        .foregroundColor(.orange)
                    ) {
                        ForEach(ingredients.spices, id: \.self) { item in
                            HStack {
                                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                    .font(Font.largeTitle)
                                    .foregroundColor(.yellow)
                                VStack {
                                    Text(item)
                                    Text("Gajar")
                                }
                                
                                Spacer()
                                
                                CheckboxView(isChecked: $checked)
                            }
                            .listRowBackground(Color(.white))
                            .padding(.vertical, 4)
                            // .padding(.leading, 0)
                            
                        }
                        
                    }
                    
                }
                
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                //.background(Color.white)
                //.padding(EdgeInsets(top: 0, leading: -35, bottom: 0, trailing: -35))
                
                Spacer()
                
               NavigationLink("Open Detail", destination: ContentView3())
                
//                    Button(action: {
//                        NavigationLink(destination: ContentView3()) { }
//                    })
//                    
//                    {
//                        Text("Match 12 Recipes")
//                            .frame(width: 200, height: 40, alignment: .center)
//                            .font(.system(size: 20, weight: .semibold, design: .default))
//                            .foregroundStyle(Color.white)
//                        
//                    }
//                  
//                    
//                    .foregroundStyle(Color.black)
//                    .background(Color.orange)
//                    .buttonStyle(.bordered)
//                    .clipShape(.capsule)
             //   }
              
          }
          
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
