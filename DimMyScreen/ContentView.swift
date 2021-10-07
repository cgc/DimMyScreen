//
//  ContentView.swift
//  DimMyScreen
//
//  Created by Carlos Correa on 10/5/21.
//

import SwiftUI

struct ContentView: View {
    @State private var brightness: Double = 1
    var action: ((Double) -> Void)?
    var body: some View {
        VStack {
            Slider(
                value: Binding<Double>(
                    get: {
                        brightness
                    },
                    set: {
                        brightness = $0
                        action?($0)
                    }
                ),
                in: 0...1
            )
            Text("Brightness \(Int(brightness*100), specifier: "%d")%")
        }.padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
