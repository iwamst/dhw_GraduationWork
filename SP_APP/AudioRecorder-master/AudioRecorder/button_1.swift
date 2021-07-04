//
//  button_1.swift
//  AudioRecorder
//
//  Created by  Masato Iwanaga on 2021/04/06.
//  Copyright © 2021 kerubito. All rights reserved.
//

import SwiftUI

struct button_1: View {
    var body: some View {
        VStack{
        Text("Button_1")
            .font(.system(size: 20,weight: .semibold,design: .rounded))
            .frame(width: 110, height: 110, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(
                ZStack {
//                    Color(#colorLiteral(red: 0.7608050108, green: 0.8164883852, blue: 0.9259157777, alpha: 1))
                    Color(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))

                    RoundedRectangle(cornerRadius: 60, style: .continuous)
                        .foregroundColor(.blue)//エッジの色
                        .blur(radius: 4)
                        .offset(x: -8, y: -8)

                    RoundedRectangle(cornerRadius: 60, style: .continuous)
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)), Color.white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            )
                        .padding(2)
                        .blur(radius: 2)
                    
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 60, style: .continuous))
            .shadow(color:Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)),radius: 8,x:5,y:5)
            .shadow(color:Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)),radius: 8,x:-5,y:-5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(#colorLiteral(red: 0.3175554276, green: 0.4902245402, blue: 0.4705265164, alpha: 1)))
        .edgesIgnoringSafeArea(.all)
    }
}

struct button_1_Previews: PreviewProvider {
    static var previews: some View {
        button_1()
    }
}
