//
//  ReplyStream.swift
//  RaspBLE
//
//  Created by webmaster on 2020/07/12.
//  Copyright © 2020 SERVERNOTE.NET. All rights reserved.
//

import Foundation

// Stream Data Format
// CODE(1byte text) + BODYSIZE(7byte zero filled text) + BODYDATA
// CODE is
// N=Notify only(empty body),
// T=Simple Text Data
// U=URL Text Data
// I=Image Binary Data

struct ReplyData {
    var CODE:String
    var TEXT:String
    var DATA:Data?
    init(code:String) {
        CODE = code
        TEXT = ""
        DATA = nil
    }
}

protocol ReplyStreamDelegate : class {
    func replyDataCompleted(_ reply:ReplyData)
}

class ReplyStream:NSObject {
    
    weak var DELEGATE:ReplyStreamDelegate?
    var STREAM_DATA:Data!
    var STREAM_INDEX:Int!
    var CONTENT_CODE:String!
    var CONTENT_SIZE:Int!
    var CONTENT_BODY:Data!

    override init() {
        super.init()
        DELEGATE = nil
        STREAM_DATA = Data()
        STREAM_INDEX = 0
        CONTENT_CODE = ""
        CONTENT_SIZE = (-1)
        CONTENT_BODY = Data()
    }
    
    func reset() {
        resetStream()
        resetContent()
    }
    
    func resetStream() {
        STREAM_DATA.removeAll(keepingCapacity:false)
        STREAM_INDEX = 0
    }
    
    func resetContent() {
        CONTENT_CODE = ""
        CONTENT_SIZE = (-1)
        CONTENT_BODY.removeAll(keepingCapacity:false)
    }
    
    func append(data:Data?) {
        if data == nil || data!.count <= 0 { return }
        STREAM_DATA.append(data!)
        var remain:Int = STREAM_DATA.count - STREAM_INDEX
        print("try for stream data remain \(remain)")
        while remain > 0 {
            if CONTENT_CODE == "" {
                print("read content code 1 byte from index \(STREAM_INDEX!)")
                let codebin:Data = STREAM_DATA.subdata( in:STREAM_INDEX..<STREAM_INDEX+1 )
                STREAM_INDEX = STREAM_INDEX + 1
                remain = remain - 1
                let codestr:String = String( data:codebin,encoding:.utf8 )!
                print("content code is \(codestr)")
                if codestr != "N" && codestr != "T" && codestr != "U" && codestr != "I" {
                    print("content code is unknown,continue")
                    continue
                }
                CONTENT_CODE = codestr
                continue
            }
            if CONTENT_SIZE < 0 {
                if remain < 7 {
                    print("not enough packet for read content size")
                    break
                }
                print("read content size 7 byte from index \(STREAM_INDEX!)")
                let sizebin:Data = STREAM_DATA.subdata( in:STREAM_INDEX..<STREAM_INDEX+7 )
                STREAM_INDEX = STREAM_INDEX + 7
                remain = remain - 7
                let sizestr:String = String( data:sizebin,encoding:.utf8 )!
                let sizeint:Int = Int(sizestr)!
                print( "contents size is \(sizeint)" )
                CONTENT_SIZE = sizeint
                if CONTENT_SIZE <= 0 { //Completed
                    print("zero content complete call delegate")
                    let reply:ReplyData = ReplyData(code:String(CONTENT_CODE))
                    resetContent() //読み込み完了
                    DELEGATE?.replyDataCompleted(reply)
                }
                continue
            }
            let remain_content:Int = CONTENT_SIZE - CONTENT_BODY.count
            var bytesforread:Int = remain
            if bytesforread >= remain_content { bytesforread = remain_content }
            print("read content body \(bytesforread) byte from index \(STREAM_INDEX!)")
            CONTENT_BODY.append(STREAM_DATA.subdata( in:STREAM_INDEX..<STREAM_INDEX+bytesforread ))
            remain = remain - bytesforread
            STREAM_INDEX = STREAM_INDEX + bytesforread
            if CONTENT_BODY.count >= CONTENT_SIZE { //Completed
                print("content body read complete call delegate")
                var reply:ReplyData = ReplyData(code:String(CONTENT_CODE))
                if CONTENT_CODE == "T" || CONTENT_CODE == "U" {
                    reply.TEXT = String( data:CONTENT_BODY,encoding:.utf8 )!
                    print("reply.TEXT=\(reply.TEXT)")
                }
                else if CONTENT_CODE == "I" {
                    reply.DATA = Data(CONTENT_BODY)
                    print("reply.DATA.count=\(reply.DATA!.count)")
                }
                resetContent() //読み込み完了
                DELEGATE?.replyDataCompleted(reply)
            }
        }
        //読んだところまでは捨ててOK
        print("before remove stream len=\(STREAM_DATA.count)")
        STREAM_DATA.removeSubrange(0..<STREAM_INDEX)
        print("after remove stream len=\(STREAM_DATA.count)")
        STREAM_INDEX = 0
    }
}

