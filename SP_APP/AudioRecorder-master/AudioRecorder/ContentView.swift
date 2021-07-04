//
//  ContentView.swift
//  AudioRecorder
//
//  Created by kerubito on 2020/08/06.
//  Copyright © 2020 kerubito. All rights reserved.
//

import SwiftUI

import Foundation

// メイン画面View
@available(iOS 14.0, *)
struct ContentView: View {
    //AudioRecorderクラス
    let audioRecorder: AudioRecorder = AudioRecorder()
    public let bStatus=0;
        
    @State var isPushed = false //メインボタン押下フラグ
    @State var btnText = "Rec"
    @State var btnTxt = "Rec" //メインボタン文字
    @State var btnTxt2 = "登録したメモを再生" //録音再生ボタン文字
    @State var sendMode=false
    @State var endRec=false
    @State var btnStatus=0 //録音ボタンのステータス管理
    @State var isAnimation = false
    @State var sendComp = false //送信完了フラグ
    @State var memoExist=false
    @State var memoPlay=false //録音再生中
    
    
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
                    .frame(width: 95.0, height: 95.0, alignment: .top)//リサイズ
                    .offset(y:-60)//表示位置をずらす
                    .padding(.bottom,100)
                
                //メインボタン
                Button(action: {
                    //タップされたときの処理を記述
                    self.isPushed.toggle()
                    if btnStatus==0 {
                        btnTxt="STOP"
                        self.audioRecorder.record()
                        btnStatus=1
                        print("録音開始=======")
                        print(btnStatus)
                        print(endRec)
                    }else if btnStatus==1 {
                        self.audioRecorder.recordStop2()
                        // n秒後に処理
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                            endRec = false
                            sendComp=true
                        }
                        endRec=true
                        btnStatus=0
                        btnTxt="REC"
                        print("録音終了=======")
                        print(btnStatus)
                        print(endRec)
                    }else if btnStatus==2{
                        return
                    }
                }) {
                    //メインボタンデザイン
                    if !isPushed{
                        Text(btnTxt)
                            .font(.system(size: 24,weight: .light))
                            .frame(width: 200, height: 200)
                            .background(Color.mainGreen)
                            //                    .foregroundColor(Color(mainGreen))
                            .foregroundColor(Color.mainWhite)
                            // .background(Color(.white))
                            .cornerRadius(100)
                            .clipShape(RoundedRectangle(cornerRadius: 100, style: .continuous))
                            .foregroundColor(.pink)//エッジの色
                            .shadow(color:Color(#colorLiteral(red: 0.1368236313, green: 0.2121668782, blue: 0.2042053676, alpha: 1)),radius: 7,x:3,y:3)
                            .shadow(color:Color(#colorLiteral(red: 0.4745862431, green: 0.7359217166, blue: 0.7083064331, alpha: 1)),radius: 7,x:-3,y:-3)
                    }else{
                        Text(btnTxt)
                            .font(.system(size: 24,weight: .light))
                            .frame(width: 200, height: 200)
                            .background(Color.tapedGreen)
                            //                    .foregroundColor(Color(mainGreen))
                            .foregroundColor(Color.mainWhite)
                            // .background(Color(.white))
                            .cornerRadius(100)
                            .clipShape(RoundedRectangle(cornerRadius: 100, style: .continuous))
                            .foregroundColor(.pink)//エッジの色
                            .shadow(color:Color(#colorLiteral(red: 0.1368236313, green: 0.2121668782, blue: 0.2042053676, alpha: 1)),radius: 7,x:-3,y:-3)
                            .shadow(color:Color(#colorLiteral(red: 0.4745862431, green: 0.7359217166, blue: 0.7083064331, alpha: 1)),radius: 7,x:3,y:3)
                        
                    }
                  
                    
                }.padding(.bottom, 120.0)
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
                    self.memoPlay.toggle()
                    if memoPlay{
                        self.audioRecorder.play()
                        print("再生=======")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            memoPlay = false
                        }
                    }else{
                        self.audioRecorder.playStop()
                        print("停止=======")
                    }
                }){
                    if memoPlay{
                        Text(btnTxt2)
                            .font(.system(size: 20,weight: .light))
                            .frame(width: 300, height: 48)
                            .background(Color.mainWhite)
                            //                    .foregroundColor(Color(mainGreen))
                            .foregroundColor(Color.mainGreen)
                            // .background(Color(.white))
                            .cornerRadius(95)
                            .shadow(color:Color(#colorLiteral(red: 0.1368236313, green: 0.2121668782, blue: 0.2042053676, alpha: 1)),radius: 6,x:-3,y:-2)
                            .shadow(color:Color(#colorLiteral(red: 0.4745862431, green: 0.7359217166, blue: 0.7083064331, alpha: 1)),radius: 6,x:3,y:2)
                    }else{
                        Text(btnTxt2)
                            .font(.system(size: 20,weight: .light))
                            .frame(width: 300, height: 48)
                            .background(Color.mainWhite)
                            //                    .foregroundColor(Color(mainGreen))
                            .foregroundColor(Color.mainGreen)
                            // .background(Color(.white))
                            .cornerRadius(95)
                            .shadow(color:Color(#colorLiteral(red: 0.1368236313, green: 0.2121668782, blue: 0.2042053676, alpha: 1)),radius: 6,x:3,y:2)
                            .shadow(color:Color(#colorLiteral(red: 0.4745862431, green: 0.7359217166, blue: 0.7083064331, alpha: 1)),radius: 6,x:-3,y:-2)
                    }
                 
                }
                .padding(.bottom, 20.0)
                
//                HStack{
//                    Button("再生開始") {
//                        self.audioRecorder.play()
//                    }
//                    .padding()
//                    Button("再生停止") {
//                        self.audioRecorder.playStop()
//                    }.padding()
//
//                }
                
            }//VStack
            
            //録音中エフェクト
            if isPushed{
                Circle()
                    .trim(from: 0, to: 0.25)
                    .stroke(Color.mainWhite, style: StrokeStyle(lineWidth: 3, lineCap: .round,dash: [0.3, 8],dashPhase: 4))
                    .frame(width: 290, height: 290)
                    .rotationEffect(Angle(degrees: self.isAnimation ? 360 : 0))
                    .onAppear() {
                        withAnimation(
                            Animation
//                                .easeOut(duration: 1.5)
                                .linear(duration: 1.5)
                                .repeatForever(autoreverses: false)) {
                            self.isAnimation.toggle()
                        }
                    }
                    //.offset(y:20)
                
                Circle()
                    .trim(from: 0.5, to: 0.75)
                    .stroke(Color.mainWhite, style: StrokeStyle(lineWidth: 3, lineCap: .round,dash: [0.3, 8],dashPhase: 4))
                    .frame(width: 290, height: 290)
                    .rotationEffect(Angle(degrees: self.isAnimation ? 360 : 0))
                    .onAppear() {
                        withAnimation(
                            Animation
//                                .easeInOut(duration: 1)
                                .linear(duration: 1.5)
                                .repeatForever(autoreverses: false)) {
                            //  self.isAnimation.toggle()
                        }
                    }
                   // .offset(y:20)
                
            }
            
            // 録音後 送信中
            // ポップアップ手作りメソッド
            if endRec {
                
                PopupView(isPresent: $endRec,isPresent2: $sendComp)
                Circle()
                    .trim(from: 0, to: 0.7)
                    .stroke(AngularGradient(gradient: Gradient(colors: [.mainGreen,.mainWhite]), center: .center), style: StrokeStyle(lineWidth: 7, lineCap: .round,dash: [0.4, 12],dashPhase: 9))
                    .frame(width: 60, height: 60)
                    .rotationEffect(Angle(degrees: self.isAnimation ? 360 : -90))
                    .onAppear() {
                        withAnimation(
                            Animation
                                .easeInOut(duration: 1.9)
                                .repeatForever(autoreverses: false)) {
                            self.isAnimation.toggle()
                        }
                    }
                    .offset(y:20)
                
            }
            
        }//Zstack
        
        // 登録完了
        // アラートポップアップ
        .alert(isPresented:$sendComp){
            Alert(title: Text("Success"),
                  message: Text("音声メモを登録しました").foregroundColor(.red),
                  dismissButton: .default(Text("OK")))
        }
    }//var body: some View
    
}//struct ContentView: View

// 色の定義
extension Color {
    static let mainGreen = Color("MainGreen")
    static let mainWhite = Color("MainWhite")
    static let tapedGreen = Color("TapedGreen")
    static let stBeige = Color("STBeige")
    static let stNavy = Color("STNavy")
    static let stPink = Color("STPink")
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        if #available(iOS 14.0, *) {
            ContentView()
        } else {
            // Fallback on earlier versions
        }
    }
}

struct PopupView: View {
    @Binding var isPresent: Bool
    @Binding var isPresent2: Bool
        var body: some View {
        
        VStack(spacing: 20) {
            
            Text("Sending...")
                .foregroundColor(Color.stNavy)
                .font(Font.system(size: 18).bold())
                .padding(.bottom, 30.0)
                .offset(y:-20)
            //
            //            Image("icon")
            //                .resizable()
            //                .frame(width: 80, height: 80)
            
            Text("")
                .font(Font.system(size: 18))
            
        }
        .frame(width: 280, height:150,alignment: .center)
        .padding(25)
        .background(Color.mainWhite)
        .cornerRadius(15)
        
    }
    
}

struct ProgressConfig {
    static func backgroundColor() -> Color {
        return Color(UIColor(red: 245/255,
                             green: 245/255,
                             blue: 245/255,
                             alpha: 1.0))
    }
    
    static func foregroundColor() -> Color {
        return Color.black
    }
}
