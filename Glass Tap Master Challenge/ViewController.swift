//
//  ViewController.swift
//  Glass Tap Master Challenge
//
//  Created by Joseph Donahue on 3/14/16.
//  Copyright © 2016 Joseph Donahue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    internal var step = 0
    internal var objects = [GameObject]()
    
    @IBOutlet weak var points: UILabel!
    
    internal var objectTemplates = [GameObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.blackColor()
        
        initializeObjectTemplates()
        
        let timer = NSTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        //var i = 1
        //while i <= 100{
        //    update()
        //    i += 1
        //}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    internal func initializeObjectTemplates(){
        objectTemplates.append(GameObject(passed_x: 0,
            passed_y: 0,
            passed_max: 25,
            passed_min: 25,
            passed_points: 100,
            passed_img: "BeerGlass1",
            passedLengthOfTimeOnScreen: 5,
            passedBottomChance: 1,
            passedTopChance: 50,
            passedId: 0))
        objectTemplates.append(GameObject(passed_x: 0,
            passed_y: 0,
            passed_max: 25,
            passed_min: 25,
            passed_points: 300,
            passed_img: "BeerGlass2",
            passedLengthOfTimeOnScreen: 2,
            passedBottomChance: 51,
            passedTopChance: 100,
            passedId: 0))
        
    }
    
    func selectObjectTemplate() -> GameObject {
        let rand = Random.within(1...100)
        return objectTemplates.filter(){
            let isAbove = $0.bottomChance <= rand
            let isBelow = $0.topChance >= rand
            
            return isAbove && isBelow
            }[0]
    }
    
    func populateObjectTemplate(obj: GameObject, step: Int) -> GameObject {
        let widthBoundary = Float(self.view.frame.width - 20)
        let heightBoundary = Float(self.view.frame.height - 20)
        
        let placex = CGFloat(Random.within(20.0...widthBoundary))
        obj.x = placex
        
        let placey = CGFloat(Random.within(50.0...heightBoundary))
        obj.y = placey
        
        obj.expiration = obj.lengthOfTimeOnScreen + step
        obj.id = step
        
        obj.button = populateObjectButton(obj)
        
        return obj
    }
    
    func populateObjectButton(obj: GameObject) -> UIButton {
        let button = UIButton(type: UIButtonType.Custom)
        let image = UIImage(named: obj.img)
        
        button.setBackgroundImage(image, forState: UIControlState.Normal)
        button.frame = CGRectMake(obj.x, obj.y, obj.minSize, obj.minSize)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(ViewController.objectTapped(_:)), forControlEvents: .TouchUpInside)
        button.tag = obj.id
        
        self.view.addSubview(button)
        
        return button
    }
    
    // ToDo: Refactor this function. It's getting way over complicated
    internal func update(){
        step += 1
        
        removeExpiredButtons()
        
        objects.append(populateObjectTemplate(selectObjectTemplate(), step: step))
        
        print("There are \(objects.count) items and the first item has an id of \(objects[0].id)")
    }
    
    
    
    internal func removeExpiredButtons(){
        let current = step
        let expirations = objects.filter({$0.expiration <= current})
        for expiration in expirations{
            expiration.button.removeFromSuperview()
        }
        
    }
    
    internal func objectTapped(sender: AnyObject) {
        let button = sender as? UIButton
        let id = button!.tag
        let index = objects.indexOf({$0.id == id})
        
        let pointsValue = Int(points.text!)
        points.text = String(pointsValue! + objects[index!].points)
        
        button!.removeFromSuperview()
    }
    
    
}

struct Random {
    static func within<B: protocol<Comparable, ForwardIndexType>>(range: ClosedInterval<B>) -> B {
        let inclusiveDistance = range.start.distanceTo(range.end).successor()
        let randomAdvance = B.Distance(arc4random_uniform(UInt32(inclusiveDistance.toIntMax())).toIntMax())
        return range.start.advancedBy(randomAdvance)
    }
    
    static func within(range: ClosedInterval<Float>) -> Float {
        return (range.end - range.start) * Float(Float(arc4random()) / Float(UInt32.max)) + range.start
    }
    
    static func within(range: ClosedInterval<Double>) -> Double {
        return (range.end - range.start) * Double(Double(arc4random()) / Double(UInt32.max)) + range.start
    }
    
    static func generate() -> Int {
        return Random.within(0...1)
    }
    
    static func generate() -> Bool {
        return Random.generate() == 0
    }
    
    static func generate() -> Float {
        return Random.within(0.0...1.0)
    }
    
    static func generate() -> Double {
        return Random.within(0.0...1.0)
    }
}

class GameObject {
    var x: CGFloat
    var y: CGFloat
    var maxSize: CGFloat
    var minSize: CGFloat
    var points: Int
    var img: String
    var button: UIButton
    var lengthOfTimeOnScreen: Int
    var expiration: Int
    var bottomChance: Int
    var topChance: Int
    var id: Int
    
    init(passed_x: CGFloat,
         passed_y: CGFloat,
         passed_max: CGFloat,
         passed_min: CGFloat,
         passed_points: Int,
         passed_img: String,
         passedLengthOfTimeOnScreen: Int,
         passedBottomChance: Int,
         passedTopChance: Int,
         passedId: Int){
        x = passed_x
        y = passed_y
        maxSize = passed_max
        minSize = passed_min
        points = passed_points
        img = passed_img
        button = UIButton()
        lengthOfTimeOnScreen = passedLengthOfTimeOnScreen
        expiration = 0
        bottomChance = passedBottomChance
        topChance = passedTopChance
        id = passedId
    }
}



