//
//  HomeScreen.swift
//  Coog Path
//
//  Created by Minh Nguyen on 10/20/23.
//

import SwiftUI
import MapKit

struct HomeScreen: View {
    @State private var fromLocation: String = ""
    @State private var toLocation: String = ""
    @State private var hiddenButton: Bool = true
    
    var body: some View {
        VStack {
            //Title
            HStack {
                Text("Coog Path")
                    .font(.largeTitle)
                    .bold()
                Spacer()
            }
            Spacer()
            
            //From stack
            VStack {
                HStack{
                    Text("From")
                        .bold()
                        .font(.system(size:20))
                    Spacer()
                }
                TextField(
                    "Your Current Location",
                    text: $fromLocation
                )
                .textFieldStyle(.roundedBorder)
                
            }
            
            //Going to stack
            VStack{
                HStack{
                    Text("Going to")
                        .bold()
                        .font(.system(size:20))
                    Spacer()
                }
                
                TextField(
                    "Search building",
                    text: $toLocation
                )
                .textFieldStyle(.roundedBorder)
            }
            .padding(.bottom)
            Spacer()
            
            //Map stack
            VStack{
                Map()
                    .clipShape(.rect(cornerRadius: 16))
            }
            
            Spacer()
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                Text("Go Coog")
                    .font(.title2)
                    .bold()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                    .padding(.horizontal,20)
                    .foregroundStyle(.white)
             
            })
            .background(RoundedRectangle(cornerRadius: 16).fill(Color("MainColor")))
            Spacer()
        }
        .padding()
    }
}

#Preview {
    HomeScreen()
}
