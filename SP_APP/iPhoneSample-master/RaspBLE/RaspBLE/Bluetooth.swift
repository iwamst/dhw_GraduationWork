//
//  Bluetooth.swift
//  RaspBLE
//
//  Created by webmaster on 2020/07/12.
//  Copyright © 2020 SERVERNOTE.NET. All rights reserved.
//

import Foundation
import Combine
import CoreBluetooth
import UIKit

enum Bluestate : Int {
    case
    POWERED_ON,
    POWERED_OFF,
    SCANNING,
    SCAN_TIMEOUT,
    DISCOVER_PERIPHERAL,
    CONNECTING,
    CONNECT_TIMEOUT,
    CONNECT_ERROR,
    CONNECT_CLOSE,
    CONNECT_OK
}

final class Bluetooth: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate, ReplyStreamDelegate {

    @Published var state:Bluestate = .POWERED_OFF
    @Published var buttonText:String = "検索できません"
    @Published var stateText:String = "Bluetoothが使用できません"
    @Published var resultText:String = ""
    @Published var resultImage = UIImage(systemName: "photo")!
    @Published var CONNECTED:Bool = false
    
    let SERVICE_UUID_STR = "54f06857-695e-47e4-aea8-c78184ad6c75"
    let CHARACT_UUID_STR = "30a5f1bb-61dc-45f0-9c52-2218d080fa77"
    var SERVICE_UUID:CBUUID!
    var CHARACT_UUID:CBUUID!
    var CENTRAL:CBCentralManager?
    var SCAN_TIMER:Timer?
    var PERIPHERAL:CBPeripheral?
    var CONNECT_TIMER:Timer?
    var CHARACTERISTICS:CBCharacteristic?
    var MAX_WRITELEN:Int!
    var REPLY_STREAM:ReplyStream!

    //メンバ変数初期化 NSObject
    override init() {
        super.init()
        SERVICE_UUID = CBUUID( string:SERVICE_UUID_STR )
        CHARACT_UUID = CBUUID( string:CHARACT_UUID_STR )
        CENTRAL = CBCentralManager( delegate:self,queue:nil )
        SCAN_TIMER = nil
        PERIPHERAL = nil
        CONNECT_TIMER = nil
        CHARACTERISTICS = nil
        MAX_WRITELEN = 0
        REPLY_STREAM = ReplyStream()
        REPLY_STREAM.DELEGATE = self
    }
    
    //状態テキストの更新
    func updateLabels(){
        switch self.state {
        case .POWERED_OFF:
            self.buttonText = "検索できません"
            self.stateText = "Bluetoothが使用できません"
        break
        case .POWERED_ON:
            self.buttonText = "検索する"
            self.stateText = "機器を検索してください"
        break
        case .SCANNING:
            self.buttonText = "検索キャンセル"
            self.stateText = "RaspberryPiを検索しています..."
        break
        case .SCAN_TIMEOUT:
            self.buttonText = "検索する"
            self.stateText = "RaspberryPiが見つかりませんでした"
        break
        case .DISCOVER_PERIPHERAL:
            self.buttonText = "接続する"
        break
        case .CONNECTING:
            self.buttonText = "接続キャンセル"
            self.stateText += "\n" + "接続中..."
        break
        case .CONNECT_TIMEOUT:
            self.buttonText = "検索する"
            self.stateText += "タイムアウトしました"
        break
        case .CONNECT_ERROR, .CONNECT_CLOSE:
            self.buttonText = "検索する"
        break
        case .CONNECT_OK:
            self.buttonText = "切断する"
        break
        }
    }
    
    //ボタンアクション
    func buttonPushed(){
        switch self.state {
        case .POWERED_OFF:
        break
        case .POWERED_ON, .SCAN_TIMEOUT, .CONNECT_TIMEOUT, .CONNECT_ERROR, .CONNECT_CLOSE:
            startScan()
        break
        case .SCANNING:
            stopScan()
            self.state = .POWERED_ON
            updateLabels()
        break
        case .DISCOVER_PERIPHERAL:
            connectPeripheral()
        break
        case .CONNECTING:
            disconnectPeripheral()
            self.state = .CONNECT_CLOSE
            self.stateText += "キャンセルしました"
            updateLabels()
        case .CONNECT_OK:
            disconnectPeripheral()
            self.state = .CONNECT_CLOSE
            self.stateText += "\n接続を切断しました"
            updateLabels()
        break
        }
    }
    
    // status update
    func centralManagerDidUpdateState( _ central:CBCentralManager ) {
        print("centralManagerDidUpdateState.state=\(central.state.rawValue)")
        //central.state is .poweredOff,.poweredOn,.resetting,.unauthorized,.unknown,.unsupported
        if central.state == .poweredOn {
            self.state = .POWERED_ON
        }
        else{
            self.state = .POWERED_OFF
            stopScan()
        }
        updateLabels()
    }
    
    func startScan(){
        stopScan()
        self.state = .SCANNING
        updateLabels()
        SCAN_TIMER = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(scanTimeout), userInfo: nil, repeats: false)
        CENTRAL?.scanForPeripherals( withServices:[SERVICE_UUID],options:nil )
        //CENTRAL?.scanForPeripherals( withServices:nil,options:nil )
    }
    
    func stopScan(){
        disconnectPeripheral()
        SCAN_TIMER?.invalidate()
        SCAN_TIMER = nil
        CENTRAL?.stopScan()
    }
    
    @objc func scanTimeout() {
        stopScan()
        self.state = .SCAN_TIMEOUT
        updateLabels()
    }
    
    // discover peripheral
    func centralManager( _ central:CBCentralManager,didDiscover peripheral:CBPeripheral,
                         advertisementData:[String:Any],rssi RSSI:NSNumber ) {
        print("didDiscover")
        stopScan()
        PERIPHERAL = peripheral
        //for (key, value) in advertisementData {
        //    print (key)
        //}
        self.stateText = "以下のRaspberryPiが見つかりました\n" + peripheral.name! + "(" + peripheral.identifier.uuidString + ")"
        self.state = .DISCOVER_PERIPHERAL
        updateLabels()
    }
    
    func connectPeripheral() {
        if CONNECT_TIMER != nil || CONNECTED || PERIPHERAL == nil {
            return
        }
        self.state = .CONNECTING
        updateLabels()
        CONNECT_TIMER = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(connectTimeout), userInfo: nil, repeats: false)
        CENTRAL?.connect( PERIPHERAL!,options:nil )
    }

    func disconnectPeripheral() {
        CONNECT_TIMER?.invalidate()
        CONNECT_TIMER = nil
        if PERIPHERAL != nil {
            CENTRAL?.cancelPeripheralConnection( PERIPHERAL! )
            PERIPHERAL = nil
        }
        CHARACTERISTICS = nil
        CONNECTED = false
    }
    
    @objc func connectTimeout() {
        disconnectPeripheral()
        self.state = .CONNECT_TIMEOUT
        updateLabels()
    }
    
    // connect peripheral OK
    func centralManager( _ central:CBCentralManager,didConnect peripheral:CBPeripheral ) {
        print("didConnect")
        CONNECT_TIMER?.invalidate()
        CONNECT_TIMER = nil
        peripheral.delegate = self
        peripheral.discoverServices( [SERVICE_UUID] )
    }
    
    // connect peripheral NG
    func centralManager( _ central:CBCentralManager,didFailToConnect peripheral:CBPeripheral,error:Error? ) {
        print("didFailToConnect")
        self.stateText += "エラー発生"
        if let e = error{
            self.stateText += "\n" + e.localizedDescription
        }
        self.state = .CONNECT_ERROR
        disconnectPeripheral()
        updateLabels()
    }
    
    // disconnect peripheral RESULT
    func centralManager( _ central:CBCentralManager,didDisconnectPeripheral peripheral:CBPeripheral,error:Error? ) {
        print("didDisconnectPeripheral")
        if error != nil {
            self.stateText += "\n" + error.debugDescription
        }
        var gonotify:Bool = false
        if( PERIPHERAL != nil ){
            gonotify = true
        }
        disconnectPeripheral()
        if gonotify {
            self.state = .CONNECT_CLOSE
            self.stateText += "\n" + "接続が切断されました"
            updateLabels()
        }
    }
    
    // discover services
    func peripheral( _ peripheral:CBPeripheral,didDiscoverServices error:Error? ) {
        print("didDiscoverServices")
        if error != nil {
            self.stateText += "エラー発生"
            self.stateText += "\n" + error.debugDescription
            self.state = .CONNECT_ERROR
            disconnectPeripheral()
            updateLabels()
            return
        }
        if peripheral.services == nil || peripheral.services?.first == nil {
            self.stateText += "エラー発生"
            self.stateText += "\n" + "ble error empty peripheral.services"
            self.state = .CONNECT_ERROR
            disconnectPeripheral()
            updateLabels()
            return
        }
        peripheral.discoverCharacteristics( [CHARACT_UUID],for:(peripheral.services?.first)! )
    }
    
    // discover characteristics
    func peripheral( _ peripheral:CBPeripheral,didDiscoverCharacteristicsFor service:CBService,error:Error? ) {
        print("didDiscoverCharacteristicsFor")
        if error != nil {
            self.stateText += "エラー発生"
            self.stateText += "\n" + error.debugDescription
            self.state = .CONNECT_ERROR
            disconnectPeripheral()
            updateLabels()
            return
        }
        if service.characteristics == nil || service.characteristics?.first == nil {
            self.stateText += "エラー発生"
            self.stateText += "\n" + "ble error empty service.characteristics"
            self.state = .CONNECT_ERROR
            disconnectPeripheral()
            updateLabels()
            return
        }
        CHARACTERISTICS = service.characteristics?.first
        MAX_WRITELEN = peripheral.maximumWriteValueLength( for:CBCharacteristicWriteType.withResponse )
        print("MAX_WRITELEN="+String(MAX_WRITELEN))
        peripheral.setNotifyValue( true,for:(service.characteristics?.first)! )
        self.stateText += "接続しました"
        self.stateText += "\n" + "エディットテキストで入力可能です"
        self.state = .CONNECT_OK
        self.resultText = ""
        CONNECTED = true
        updateLabels()
    }
    
    //文字列送信 httpから始まる場合画像URLと見なす
    func writeString(text:String){
        if !CONNECTED || text.isEmpty {
            return
        }
        var code:String = "T"
        let tops:String = String(text.prefix(4))
        if tops == "http" {
            code = "U"
        }
        let data = text.data( using:String.Encoding.utf8,allowLossyConversion:true )
        let head:String = String( format:"%@%07d",code,data!.count )
        let dstr:String = head + "" + text
        write(data:dstr.data( using:String.Encoding.utf8,allowLossyConversion:true )!)
    }
    
    // データ送信 MAX_WRITELENごとに分割して大きなデータも送信可能
    func write(data:Data) {
        if !CONNECTED {
            return
        }
        var remain:Int = data.count
        var index:Int = 0
        var wlen:Int = 0
        while remain > 0 {
            wlen = MAX_WRITELEN
            if wlen > remain {
                wlen = remain
            }
            PERIPHERAL?.writeValue( data.subdata( in:index..<index+wlen ),
                for:CHARACTERISTICS!,type:CBCharacteristicWriteType.withResponse )
            remain -= wlen
            index += wlen
        }
    }

    // write value result
    func peripheral( _ peripheral:CBPeripheral,didWriteValueFor characteristic:CBCharacteristic,error:Error? ){
        print("didWriteValueFor")
        if let e = error {
            self.resultText += e.localizedDescription + "\n"
        }
    }
    
    // read or update value result
    func peripheral( _ peripheral:CBPeripheral,didUpdateValueFor characteristic:CBCharacteristic,error:Error? ){
        print("didUpdateValueFor")
        if( characteristic.value!.count <= 0 ){
            return
        }
        if error != nil {
            self.resultText += error.debugDescription + "\n"
            return
        }
        REPLY_STREAM.append(data:characteristic.value)
        if peripheral.state == .connected { peripheral.readValue( for:characteristic ) }
    }
    
    func replyDataCompleted(_ reply:ReplyData) {
        if !reply.TEXT.isEmpty {
            self.resultText += reply.TEXT + "\n"
        }
        if reply.DATA != nil {
            self.resultImage = UIImage(data: reply.DATA!)!
        }
    }
}
