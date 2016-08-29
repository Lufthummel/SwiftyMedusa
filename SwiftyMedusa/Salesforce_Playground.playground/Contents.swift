//: Playground - for testing SF authentication & rest requests
import UIKit
import XCPlayground
import WebKit
import Foundation




//Salesforce credentials -  will be deleted after session :-)
let consumerKey = "3MVG9xOCXq4ID1uFuYvTJhxH5YFcbPl5OW.wzPUD6AotC.l7Lj1cYKDaKnZGN24RY.rsFXhMCGl9wkf4iTshy"
let consumerSecret = "4015431462162252575"
let redirectUri = "https://minaxsoft-developer-edition.na17.force.com"
let username = "dave%40minaxsoft.de"
let pw = "****"
let securityToken = "DpjyNlNvV3V4Ze1rJ1oG8ZsW"
let pws = pw + securityToken

let myInstanceCode = "https://login.salesforce.com/services/oauth2/authorize"
let myInstanceToken = "https://minaxsoft-developer-edition.na17.force.com/services/oauth2/token"

// some additional post parameter
let code = "code"
//let grantType = "authorization_code"
let grantType = "password"

let oauthPwString = "grant_type=\(grantType)&client_id=\(consumerKey)&client_secret=\(consumerSecret)&username=\(username)&password=\(pws)&format=json"
let oauthAuthString = "response_type=\(code)&client_id=\(consumerKey)&redirect_uri=\(redirectUri)"
let oauthPostString = "response_type=\(code)&grant_type=\(grantType)&client_id=\(consumerKey)&client_secret=\(consumerSecret)&redirect_uri=\(redirectUri)"
// -------------------------------------------------------------------------------"

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true //async stuff


let posturl = myInstanceCode + "?" + oauthAuthString

print (posturl)

let frame = CGRect(x: 0, y: 0, width: 800, height:800)
let web = WKWebView(frame: frame)


if let oauthPage = NSURL(string: posturl) {
    
    var rq = NSMutableURLRequest(URL: oauthPage)
    
    rq.HTTPMethod = "POST"
    rq.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    web.loadRequest(rq)
    
    XCPlaygroundPage.currentPage.liveView = web
    
}




//username - password flow -> for demonstration only!!!
/*
 let pwurl = myInstanceToken
 if let oauthPWPage = NSURL(string: pwurl) {
 
    var rq = NSMutableURLRequest(URL: oauthPWPage)
    
    rq.HTTPMethod = "POST"
    rq.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    rq.HTTPBody = oauthPwString.dataUsingEncoding(NSUTF8StringEncoding)
    let task = NSURLSession.sharedSession().dataTaskWithRequest(rq) { data, response, error in
        let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        let responseString = response?.description
        let errorString = error?.description
        print("\n responseString = \(responseString) \n")
        print("dataString = \(dataString) \n")
        print("errorString = \(errorString)")
    }
    task.resume()
    

 }
 
*/
 

