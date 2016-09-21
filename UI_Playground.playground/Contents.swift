//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true



let view = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
view.backgroundColor = UIColor.gray

// lets add a button

let button = UIButton(type: UIButtonType.system)
button.setTitle("Playground is awesome", for: .normal)
button.sizeToFit()
button.center = CGPoint(x: 100, y: 25)
button.tintColor = UIColor.black
button.backgroundColor = UIColor.white
view.addSubview(button)


// a slider
let pos = CGPoint(x: 60, y: 60)
let slider = UISlider()
slider.center = pos

view.addSubview(slider)


// lets do some real cool stuff here...

let circle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
circle.center = view.center
circle.layer.cornerRadius = 25.0

let startingColor = UIColor(red: (253.0/255.0), green: (159.0/255.0), blue: (47.0/255.0), alpha: 1.0)
circle.backgroundColor = startingColor

view.addSubview(circle);

let rectangle = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
rectangle.center = view.center
rectangle.layer.cornerRadius = 5.0

rectangle.backgroundColor = UIColor.white

view.addSubview(rectangle)


//-------------------->>>>>>>>>>>>>>>>>>>>>>

//how about a cool animation???

UIView.animate(withDuration: 1.0, animations: { () -> Void in
    let endingColor = UIColor(red: (255.0/255.0), green: (61.0/255.0), blue: (24.0/255.0), alpha: 1.0)
    circle.backgroundColor = endingColor
    
    let scaleTransform = CGAffineTransform(scaleX: 5.0,y: 5.0)
    
    circle.transform = scaleTransform
    
    let rotationTransform = CGAffineTransform(rotationAngle: 3.14)
    
    rectangle.transform = rotationTransform
})



PlaygroundPage.current.liveView = view

