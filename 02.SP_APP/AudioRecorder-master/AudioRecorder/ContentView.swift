//
//  ContentView.swift
//  AudioRecorder
//
//  Created by kerubito on 2020/08/06.
//  Copyright © 2020 kerubito. All rights reserved.
//

import SwiftUI

import Foundation

import UIKit

//class ViewController: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // 背景色設定
//        //        view.backgroundColor = UIColor.init(red: 81/255, green: 125/255, blue: 120/255, alpha: 100/100)
//    }
//}

struct ContentView: View {
    //AudioRecorderクラス
    let audioRecorder: AudioRecorder = AudioRecorder()
    public let bStatus=0;
    
    /// グラデーションの定義
    let gradient = LinearGradient(
        gradient: Gradient(colors: [.pink, .purple]),
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
    
    
    @State var isPushed = false //ボタン押下フラグ
    @State var text = "ボタンをタップしてください。"
    @State var btnText = "Rec"
    @State var btnTxt = "Rec"
    @State var sendMode=false
    @State var isSucceeded=false
    @State var btnStatus=0 //録音ボタンのステータス管理
    
    @State var isAnimation = false
    
    //0408add
    let recMode: Bool=true
    
    var body: some View {
        
        ZStack {
            
            Color.mainGreen
                .edgesIgnoringSafeArea(.all)
            
            /// グラデーション、偶奇規則使用する
            //            samplePath()
            //                .fill(gradient, style: FillStyle(eoFill: true))
            //                .frame(width:300, height: 275)
            
            //
            VStack {
                Image("SayTagロゴ確定版_文字入り_W")
                    .resizable()//リサイズ可能
                    .frame(width: 90.0, height: 90.0, alignment: .top)//リサイズ
                    .offset(y:-105)//表示位置をずらす
                
                //
                //                Rectangle()
                //                    .fill(Color(red: 0.9, green: 0.0, blue: 0.1, opacity: 1.0))
                //                                .frame(width: 50, height: 50, alignment: .center)
                //                                .rotationEffect(.degrees(45.0))
                
                
                Button(action: {
                    //タップされたときの処理を記述
                    self.isPushed.toggle()
                    if btnStatus==0 {
                        btnTxt="STOP"
                        self.audioRecorder.record()
                        btnStatus=1
                        print("録音開始=======")
                        print(btnStatus)
                        print(sendMode)
                    }else if btnStatus==1 {
                        self.audioRecorder.recordStop2()
                        sendMode=true
                        btnStatus=0
                        btnTxt="REC"
                        print("録音終了=======")
                        print(btnStatus)
                        print(sendMode)
                    }else if btnStatus==2{
                        return
                    }
                }) {
                    //ボタンを表すView並びを記述
                    if !isPushed{
                        Text(btnTxt)
                            .font(.system(size: 24,weight: .light))
                            .frame(width: 190, height: 190)
                            .background(Color.mainGreen)
                            //                    .foregroundColor(Color(mainGreen))
                            .foregroundColor(Color.mainWhite)
                            // .background(Color(.white))
                            .cornerRadius(95)
                            .clipShape(RoundedRectangle(cornerRadius: 90, style: .continuous))
                            .foregroundColor(.pink)//エッジの色
                            .shadow(color:Color(#colorLiteral(red: 0.1368236313, green: 0.2121668782, blue: 0.2042053676, alpha: 1)),radius: 9,x:3,y:3)
                            .shadow(color:Color(#colorLiteral(red: 0.4745862431, green: 0.7359217166, blue: 0.7083064331, alpha: 1)),radius: 9,x:-3,y:-3)
                        
                    }else{
                        Text(btnTxt)
                            .font(.system(size: 24,weight: .light))
                            .frame(width: 190, height: 190)
                            .background(Color.tapedGreen)
                            //                    .foregroundColor(Color(mainGreen))
                            .foregroundColor(Color.mainWhite)
                            // .background(Color(.white))
                            .cornerRadius(95)
                            .clipShape(RoundedRectangle(cornerRadius: 90, style: .continuous))
                            .foregroundColor(.pink)//エッジの色
                            .shadow(color:Color(#colorLiteral(red: 0.1368236313, green: 0.2121668782, blue: 0.2042053676, alpha: 1)),radius: 9,x:-3,y:-3)
                            .shadow(color:Color(#colorLiteral(red: 0.4745862431, green: 0.7359217166, blue: 0.7083064331, alpha: 1)),radius: 9,x:3,y:3)
                        
                    }
                    //                    Text(btnTxt)
                    //                        .font(.system(size: 24,weight: .light))
                    //                        .frame(width: 190, height: 190)
                    //                        .background(isPushed ? Color.tapedGreen:Color.mainGreen)
                    //                        //                    .foregroundColor(Color(mainGreen))
                    //                        .foregroundColor(Color.mainWhite)
                    //                        // .background(Color(.white))
                    //                        .cornerRadius(95)
                    //                        .clipShape(RoundedRectangle(cornerRadius: 90, style: .continuous))
                    //                        .foregroundColor(.pink)//エッジの色
                    //                        .shadow(color:Color(#colorLiteral(red: 0.1368236313, green: 0.2121668782, blue: 0.2042053676, alpha: 1)),radius: 9,x:3,y:3)
                    //                        .shadow(color:Color(#colorLiteral(red: 0.4745862431, green: 0.7359217166, blue: 0.7083064331, alpha: 1)),radius: 9,x:-3,y:-3)
                    //.animation(.spring())//アニメーションエフェクト
                    
                    
                }.padding(.bottom, 90.0)
                //.padding(.top, 120.0)
                //                //
                //                Button("Rec") {
                //
                //                    if(btnStatus==0){
                //                        self.audioRecorder.record()
                //                        btnStatus = 1
                //                        self.text = "Recording..."
                //                        //   .font(.system(size:30))
                //
                //                    }else if(btnStatus==1){
                //                        btnStatus = 2
                //                        _=self.audioRecorder.recordStop()
                //                        self.text="Stop Recording"
                //                        //self.text = ""
                //                    }else if(btnStatus==2){
                //                        btnStatus = 0
                //                        // btnText="Rec"
                //                        self.text = "Rec"
                //                    }
                //                }
                //                .padding(.bottom, 20.0)
                //
                //                Button("録音停止") {
                //                    //self.audioRecorder.recordStop2()
                //                    _ = self.audioRecorder.recordStop()
                //                    self.text = "Stop Recording"
                //                }
                //                .padding(.bottom, 10.0)
                
                Button(action: {
                    self.audioRecorder.play()
                    print("再生=======")
                }){
                    Text("お腹すいた")
                        .font(.system(size: 20,weight: .light))
                        .frame(width: 300, height: 48)
                        .background(Color.mainWhite)
                        //                    .foregroundColor(Color(mainGreen))
                        .foregroundColor(Color.mainGreen)
                        // .background(Color(.white))
                        .cornerRadius(95)
                }                .padding(.bottom, 20.0)
                
                Button("再生開始") {
                    self.audioRecorder.play()
                    self.text = "Stop Recording"
                }
                .padding(.bottom, 20.0)
                Button("再生停止") {
                    self.audioRecorder.playStop()
                }.padding()
              
            }//VStack
            if sendMode {
                //                    ポップアップ手作りメソッド
                //   isSucceeded=true
                PopupView(isPresent: $sendMode)
            }
            if isPushed{
                //処理中のエフェクト
                Circle()
                    .trim(from: 0, to: 0.33)
                    .stroke(AngularGradient(gradient: Gradient(colors: [.mainWhite, .mainGreen]), center: .center), style: StrokeStyle(lineWidth: 8, lineCap: .round,dash: [0.1, 4],
                                                                                                                                       dashPhase: 4))
                    .frame(width: 200, height: 200)
                    .rotationEffect(Angle(degrees: self.isAnimation ? 360 : 0))
                    .onAppear() {
                        withAnimation(
                            Animation
                                .linear(duration: 1.2)
                                .repeatForever(autoreverses: false)) {
                            self.isAnimation.toggle()
                        }
                    }
                    .offset(y:-75)
                
            }
            
            
        }//Zstack
        // アラートポップアップ
        .alert(isPresented:$isSucceeded){
            Alert(title: Text("Success"),
                  message: Text("音声メモを登録しました"),
                  dismissButton: .default(Text("OK")))
        }
        //
        //        // アラートポップアップ
        //        .alert(isPresented:$sendMode){
        //                    Alert(title: Text("Success"),
        //                          message: Text("音声メモを登録しました"),
        //                          dismissButton: .default(Text("OK")))
        //                }
    }//var body: some View
    
    
    // サンプル図形
    func samplePath() -> Path {
        var path = Path()
        path.addEllipse(in: CGRect(x: 50, y: 0, width: 200, height: 200))
        path.addEllipse(in: CGRect(x: 0, y: 75, width: 200, height: 200))
        path.addEllipse(in: CGRect(x: 100, y: 75, width: 200, height: 200))
        return path
    }
    
}//struct ContentView: View

extension Color {
    static let mainGreen = Color("MainGreen")
    static let mainWhite = Color("MainWhite")
    static let tapedGreen = Color("TapedGreen")
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        //button_1()
        
    }
}

struct PopupView: View {
    @Binding var isPresent: Bool
    var body: some View {
        VStack(spacing: 12) {
            Text("Success!")
                .font(Font.system(size: 18).bold())
            //
            //            Image("icon")
            //                .resizable()
            //                .frame(width: 80, height: 80)
            
            Text("音声メモを登録しました")
                .font(Font.system(size: 18))
            
            Button(action: {
                withAnimation {
                    isPresent = false
                }
            }, label: {
                Text("Close")
            })
        }
        .frame(width: 280, alignment: .center)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        
        
    }
}
