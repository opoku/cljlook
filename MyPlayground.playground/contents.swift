//: Playground - noun: a place where people can play

//import Cocoa
//import WebKit
//import XCPlayground
//
//var str = "Hello, playground!"
//
//var err: NSErrorPointer = nil
//var path = NSBundle.mainBundle().pathForResource("core.clj", ofType: "html")
//var contents = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: err)! as String
//
//
//var rect = NSMakeRect(0, 0, 600, 800)
//var webview = WebView(frame: rect)
//var scale = CGFloat(5.0)
//var size = NSMakeSize(scale, scale)
//webview.scaleUnitSquareToSize(size)
//
//webview.mainFrame.frameView.allowsScrolling = false
//webview.mainFrame.loadHTMLString(contents, baseURL: NSURL(string: ""))
//webview.bounds
//webview.bounds = NSMakeRect(0,((rect.size.height/scale)*2),rect.size.width/scale,rect.size.height/scale)
//
//XCPShowView("webview", webview)
//
//XCPSharedDataDirectoryPath

import Foundation

var fmt = NSDateFormatter()
fmt.dateFormat = "HH:mm.ss"
var date = NSDate(timeIntervalSinceReferenceDate: 60.0*60*24*365*14.51)
var interval = 60.0*60*25
var date2 = date.dateByAddingTimeInterval(interval)
var now = NSDate()

var timeLeft = date2.timeIntervalSinceDate(now)
var cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
var zeroComp = NSDateComponents()
zeroComp.hour = 0
zeroComp.minute = 0
zeroComp.second = 0
var zeroDate = cal.dateFromComponents(zeroComp)!
var d = NSDate(timeInterval: timeLeft, sinceDate: zeroDate)
fmt.stringFromDate(d)

var ff = NSDateFormatter()
ff.dateStyle = NSDateFormatterStyle.FullStyle
ff.timeStyle = NSDateFormatterStyle.FullStyle
ff.dateFormat
min(1,2)

NSStreamEvent.HasBytesAvailable.rawValue
NSStreamEvent.HasSpaceAvailable.rawValue
NSStreamEvent.OpenCompleted.rawValue
NSStreamEvent.ErrorOccurred.rawValue
NSStreamEvent.EndEncountered.rawValue

IN_LOOPBACKNET
inet_addr("127.0.0.1")
INADDR_NONE
in6addr_loopback

SIGUSR2
UInt(SIGUSR2)

class S {
    let name: String
    init (name: String) {
        self.name = name
    }
}

var s = S(name:"One")

var ptr = UnsafeMutablePointer<S>.alloc(1)
ptr.initialize(s)
ptr

var s1 = ptr.memory
s1.name
Array
NSDate.dateByAddingTimeInterval(1)