//
//  OceanSquare.swift
//  MVC BattleShip
//
//  Created by Christopher REECE on 3/3/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

protocol TileDelegate: class {
    
    func updateTile(index: (x: Int, y: Int))
}

class Tile: UIView {
    private var _isShip = false
    private var _isHit = false
    private var _isWater = true
    private var _tileType = OceanSquare.water
    private var _privColor: UIColor = UIColor.redColor()
    private var _color: UIColor {
        get { return _privColor }
        set { _privColor = newValue; setNeedsDisplay() }
    }
    
    private var _updated: Bool = false
    
    var tileType: OceanSquare {
        get { return _tileType }
        set { if _updated == false {
                _tileType = newValue; refresh()
            } else {
                return
            }
        }
    }
    
    weak var Delegate: TileDelegate?
    private var _index: (x: Int, y: Int) = (0, 0)
    
    var index: (x: Int, y: Int) {
        get { return _index }
        set { _index = newValue }
    }
    func finalizeTileState() {
        _updated = true
        userInteractionEnabled = false
    }
    
    func refresh() {
        
        switch tileType {
        case .water:
            _color = UIColor.blueColor()
        case .hit:
            _color = UIColor.redColor()
        case .patrol:
            _color = UIColor.yellowColor()
        case .battleship:
            _color = UIColor.greenColor()
        case .submarine:
            _color = UIColor.orangeColor()
        case .destroyer:
            _color = UIColor.magentaColor()
        case .carrier:
            _color = UIColor.purpleColor()
        case .highlighted:
            _color = UIColor.brownColor()
        case .fired:
            _color = UIColor.blueColor()
        default:
            _color = UIColor.blueColor()
        }

    }
    
    init(frame: CGRect, delegate: TileDelegate) {
        super.init(frame: frame)
        Delegate = delegate
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let tile = CGRectMake(bounds.origin.x + 1, bounds.origin.y + 1, bounds.size.width - 2, bounds.size.height - 2)
    
        if tileType.rawValue == OceanSquare.fired.rawValue {
            
            CGContextAddRect(context, tile)
            CGContextSetFillColorWithColor(context, _color.CGColor)
            CGContextFillRect(context, tile)
        
            let path = UIBezierPath(arcCenter: CGPointMake(bounds.midX, bounds.midY), radius: bounds.width / 2.5, startAngle: 0.0, endAngle: CGFloat(M_PI * 2), clockwise: false)
            UIColor.whiteColor().setStroke()
            path.lineWidth = 2
            path.stroke()
            
            let path1 = UIBezierPath(arcCenter: CGPointMake(bounds.midX, bounds.midY), radius: bounds.width / 5, startAngle: 0.0, endAngle: CGFloat(M_PI * 2), clockwise: false)
            UIColor.whiteColor().setStroke()
            path1.lineWidth = 2
            path1.stroke()
        } else {
            CGContextAddRect(context, tile)
            CGContextSetFillColorWithColor(context, _color.CGColor)
            CGContextFillRect(context, tile)
        }
 

    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
         Delegate?.updateTile(_index)
    }

}















