//
//  GameStructs.swift
//  MVC BattleShip
//
//  Created by Christopher REECE on 3/2/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

struct Ship: Printable
{
    var startingPoint: CGPoint = CGPointZero
    var isVertical: Bool = false
    private var _length: Int = 0
    var length: Int! {
        get {
            return _length
        }
    }
    
    init(startPoint: CGPoint, vertical: Bool, length: Int)
    {
        startingPoint = startPoint
        isVertical = vertical
        _length = length
    }
    
    var description: String
    {
        return "starting Point: \(startingPoint) \n is vertical: \(isVertical) \n length: \(length)"
    }
}

//struct OceanSquare: Printable
//{
//    var hit = false
//    var containShip = false
//    
//    var description: String
//    {
//        if hit == true && containShip == false
//        {
//            return "Miss"
//        }
//        else if hit == true && containShip == true
//        {
//            return "Boomshakalaka"
//        }
//        else
//        {
//            return "It's just ocean water"
//        }
//         
//        
//    }
//}

enum OceanSquare: Int, Printable
{
    case patrol = 1
    case destroyer, submarine, battleship, carrier, hit, fired, highlighted, water
    
    var name: String {
        let names = [
        "patrol",
        "destroyer",
        "submarine",
        "battleship",
        "carrier",
        "hit",
        "fired",
        "highlighted",
        "water"]
        
        return names[rawValue - 1]
    }
    
    var description: String
    {
        return name
    }
}

enum ShipTitle: Int
{
    case patrol = 1
    case destroyer, submarine, battleship, carrier
    
    var name: String {
        let names = [
            "patrol",
            "destroyer",
            "submarine",
            "battleship",
            "carrier"]
        
        return names[rawValue - 1]
    }
}

enum Player: Int
{
    case player1 = 0
    case player2
    
    var name: String {
        let names = [
            "player1",
            "player2"]
        
        return names[rawValue]
    }
}

enum GameStates: Int
{
    case inProgress = 0;
    case finished
    case newGame
    
    var name: String {
        let names = [
        "in progress",
        "finished",
        "new game"]
        return names[rawValue]
    }
}

struct StrobeCounter
{
   
    static var count: Int = 0
  
}



