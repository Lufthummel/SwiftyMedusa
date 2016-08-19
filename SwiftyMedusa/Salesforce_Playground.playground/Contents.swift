//: Playground - for testing SF authentication & rest requests
import UIKit
import XCPlayground
import WebKit
import PlaygroundSupport
import Foundation




//Salesforce credentials -  will be deleted after session :-)
let consumerKey = "3MVG9xOCXq4ID1uFuYvTJhxH5YFcbPl5OW.wzPUD6AotC.l7Lj1cYKDaKnZGN24RY.rsFXhMCGl9wkf4iTshy"
let consumerSecret = "4015431462162252575"
let redirectUri = "https://minaxsoft-developer-edition.na17.force.com"
let username = "dave%40minaxsoft.de"
let pw = "****"

let myInstanceCode = "https://login.salesforce.com/services/oauth2/authorize"
let myInstanceToken = "https://minaxsoft-developer-edition.na17.force.com/services/oauth2/token"

// some additional post parameter
let code = "code"
//let grantType = "authorization_code"
let grantType = "password"

let oauthPwString = "grant_type=\(grantType)&client_id=\(consumerKey)&client_secret=\(consumerSecret)&username=\(username)&password=\(pw)&format=json"
let oauthAuthString = "response_type=\(code)&client_id=\(consumerKey)&redirect_uri=\(redirectUri)"
let oauthPostString = "response_type=\(code)&grant_type=\(grantType)&client_id=\(consumerKey)&client_secret=\(consumerSecret)&redirect_uri=\(redirectUri)"
// -------------------------------------------------------------------------------"

PlaygroundPage.current.needsIndefiniteExecution = true //async stuff

print (oauthPostString)
print (oauthAuthString)
print (oauthPwString)

let posturl = myInstanceCode + "?" + oauthAuthString

print (posturl)

let frame = CGRect(x: 0, y: 0, width: 800, height:800)
let web = WKWebView(frame: frame)


if let oauthPage = URL(string: posturl) {
    
    var rq = URLRequest(url: oauthPage)
    
    rq.httpMethod = "POST"
    rq.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    
    
    
    
    web.load(rq)
    
    web.url
    PlaygroundPage.current.liveView = web
    web.url
}






/*
 if let url = URL(string:"https://itunes.apple.com/search?term=jack+johnson&limit=5") {
 
 
 let nsd = NSData(contentsOf: url)
 
 var datastring = NSString(data: nsd! as Data, encoding: String.Encoding.utf8.rawValue)
 
 print (datastring)
 }
 
 
 
 
 
 //let url2 = URL(string:"http://www.heise.de")
 
 if let loginPage = URL(string: "https://login.salesforce.com") {
 
 let rq = URLRequest(url: loginPage)
 print (rq)
 web.load(rq)
 PlaygroundPage.current.liveView = web
 
 }
 
 */
