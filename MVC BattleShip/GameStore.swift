//
//  GameStore.swift
//  MVC BattleShip
//
//  Created by Christopher REECE on 3/2/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import Foundation

/* notes 

    define http client object
    involves telling it which url you are communicating with
    use this client object to make request

    everythign after the question mark in a url are quary params
    node.js

    afnetworking tuts
    internship

    cs job board
    get on linked in
    cs job fairs
    golden saxx 
    cs department news letter
    2420 - data structures 

*/
class GameStore
{
    // properties
    private var _GameList = [Game]()
    
    // declare threadsafe singleton
    class var sharedInstance: GameStore
    {
        struct Static
        {
            static var instance: GameStore?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)
        {
            Static.instance = GameStore()
        }
        
        return Static.instance!
    }

    // GameStore primary functions and pseudo code
    
    // access Game
    func gameAtIndex(index: Int) -> Game
    {
        return _GameList[index]
    }
    
    // add Game
    func newGame()
    {
        let game = Game()
        _GameList.append(game)
        saveGames()

    }
    
    // remove Game
    func deleteGameAtIndex(index: Int)
    {
        _GameList.removeAtIndex(index)
        saveGames()
    }

    func gameCount() -> Int
    {
       return _GameList.count
       
    }
    
    // Object persistance yeah! XOXOX
    // ~/Library/Developer/CoreSimulator
    func saveGames()
    {
        // write
        let documentsDirectory: String? = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true)?[0] as! String?
        let filePath: String? = documentsDirectory?.stringByAppendingPathComponent("file.txt")
        
        
        /*
        
        */
        // top level container
        var topLevelContainer = NSMutableArray()
        
        for game in _GameList
        {
            let gameData = game.pushData()
            
            // change grids to grids full of rawValues
            let p1EnemyGrid = convertGridToNSNumber(gameData.p1EnemyGrid)
            let p1Grid = convertGridToNSNumber(gameData.p1Grid)
            let p2EnemyGrid = convertGridToNSNumber(gameData.p2EnemyGrid)
            let p2Grid = convertGridToNSNumber(gameData.p2Grid)
            
            var object = NSMutableDictionary()
            object["gameState"] = (gameData.gameState.rawValue as NSNumber)
            object["missilesFired"] = gameData.missilesFired
            object["p1EnemyGrid"] = p1EnemyGrid
            object["p1Grid"] = p1Grid
            object["p1Score"] = (gameData.p1Score as NSNumber)
            object["p2EnemyGrid"] = p2EnemyGrid
            object["p2Grid"] = p2Grid
            object["p2Score"] = (gameData.p2Score as NSNumber)
            object["playerTurn"] = (gameData.playerTurn.rawValue as NSNumber)
            object["playerWon"] = (gameData.playerWon.boolValue as NSNumber)
            if let winningPlayer: Int = gameData.winningPlayer?.rawValue {
                object["winningPlayer"] = NSNumber(integer: winningPlayer)
                println("value of winning Player: \(winningPlayer)")
            } else {
                object["winningPlayer"] = (-1 as NSNumber)
                println("game does not exist")
            }
            topLevelContainer.addObject(object)
            print("saved \n")
            
        }
        
        if NSJSONSerialization.isValidJSONObject(topLevelContainer) {
            println("is a valid json object")
            let json = NSJSONSerialization.dataWithJSONObject(topLevelContainer, options: nil, error: nil)
            json!.writeToFile(filePath!, atomically: true)
        } else {
            println("boo")
        }
        
    }
    
    func loadGames()
    {
        // read
        var error: NSError?
        let documentsDirectory: String? = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true)?[0] as! String?
        let filePath: String? = documentsDirectory?.stringByAppendingPathComponent("file.txt")
       

       
           
        let jsonData = NSData(contentsOfFile: filePath!)
            
        if jsonData != nil {
                let gameData = NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers, error:&error) as! NSArray
                println("games were loaded")
            for data in gameData
                {
                    let gameState = GameStates(rawValue: (data["gameState"] as! Int))
                    let missilesFired = (data["missilesFired"] as! Int)
                    let tmpP1EnemyGrid = (data["p1EnemyGrid"] as! NSArray)
                    let tmpP1Grid = (data["p1Grid"] as! NSArray)
                    let tmpP2EnemyGrid = (data["p2EnemyGrid"] as! NSArray)
                    let tmpP2Grid = (data["p2Grid"] as! NSArray)
                    let p2Score = (data["p2Score"] as! Int)
                    let p1Score = (data["p1Score"] as! Int)
                    let playerTurn = Player(rawValue: (data["playerTurn"] as! Int))
                    let playerWon = (data["playerWon"] as! Bool)
                    var winningPlayer: Player?

                    if (data["winningPlayer"] as! Int) == -1 {
                        winningPlayer = nil
                    } else {
                        winningPlayer = Player(rawValue: (data["winningPlayer"] as! Int))
                    }
                    

                    
                    // convert grids back to OceanSquareGrids
                    let p1EnemyGrid = convertGridToOceanSquare(tmpP1EnemyGrid)
                    let p1Grid = convertGridToOceanSquare(tmpP1Grid)
                    let p2EnemyGrid = convertGridToOceanSquare(tmpP2EnemyGrid)
                    let p2Grid = convertGridToOceanSquare(tmpP2Grid)
                    
                    
                    let game = Game()
                    game.pullData(p1Grid, p1EnemyGrid: p1EnemyGrid, p2Grid: p2Grid, p2EnemyGrid: p2EnemyGrid, p1Score: p1Score, p2Score: p2Score, winningPlayer: winningPlayer, playerWon: playerWon, playerTurn: playerTurn!, missilesFired: missilesFired, gameState: gameState!)
                    _GameList.append(game)
                    println("added Game")
            }
            
        } else {
            println("json object was not found")
            return
        }
       
    }

    
    func convertGridToNSNumber(grid: [[OceanSquare]]) -> NSMutableArray
    {
        var newGrid = NSMutableArray()
        
        for i in 0..<grid.count {
            
            var newRow = NSMutableArray()
            for j in 0..<grid.count {

                let intValue = grid[i][j].rawValue
                let changedNumber = NSNumber(integer: intValue)
                newRow.addObject(changedNumber)
                
            }
            newGrid.addObject(newRow)
        }
        
        return newGrid
    }
    
    func convertGridToOceanSquare(grid: NSArray) -> [[OceanSquare]]
    {
       var newGrid = [[OceanSquare]]()
        
        for i in 0..<grid.count {
            
            var newRow = [OceanSquare]()
            for j in 0..<grid.count {
                
                let square = OceanSquare(rawValue: (grid[i][j] as! Int))
                newRow.append(square!)
            }
            newGrid.append(newRow)
        }
        
        return newGrid
    }
}






















