//
//  ContentView.swift
//  RaspBLE
//
//  Created by webmaster on 2020/07/12.
//  Copyright © 2020 SERVERNOTE.NET. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var bluetooth = Bluetooth()
    @State private var editText = ""
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 5) {
                HStack() {
                    Spacer()
                    Button(action: {
                        self.bluetooth.buttonPushed()
                    })
                    {
                        Text(self.bluetooth.buttonText)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1))
                    }
                    Spacer()
                }
                Text(self.bluetooth.stateText)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                if self.bluetooth.CONNECTED {
                    VStack(alignment: .leading, spacing: 5) {
                        TextField("送信文字列", text: $editText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .font(.body)
                        HStack() {
                            Spacer()
                            Button(action: {
                                self.bluetooth.writeString(text:self.editText)
                            })
                            {
                                Text("送信する")
                                    .padding()
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.red, lineWidth: 1))
                            }
                            Spacer()
                        }
                        Text(self.bluetooth.resultText)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                Image(uiImage: self.bluetooth.resultImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 80, alignment: .top)
            }
            .onAppear{
                //使用許可リクエスト等
            }
        }.padding(.vertical)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
