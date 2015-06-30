//
//  Game.swift
//  MVC BattleShip
//
//  Created by Christopher REECE on 3/2/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

protocol GameDelegate: class {
    
    func playerWon(player: Player)
    func presentChangeView()
}

class Game
{
    // stuff to save
    private var _p1Grid: [[OceanSquare]] = [[]]
    private var _p1EnemyGrid: [[OceanSquare]] = [[]]
    private var _p2Grid: [[OceanSquare]] = [[]]
    private var _p2EnemyGrid: [[OceanSquare]] = [[]]
    
    private var _p1Ships: [ShipTitle: Ship] = [:]
    private var _p2Ships: [ShipTitle: Ship] = [:]
    private var _p1Score: Int = 0
    private var _p2Score: Int = 0
    private var _winningPlayer: Player?
    private var _playerWon: Bool = false
    
    // game state variables
    private var _playerTurn: Player = .player1
    private var _missilesFired: Int = 0
    var gameState: GameStates = .newGame
    
    
    weak var Delegate: GameDelegate?
    
    var playerWon: Player? {
        get { return _winningPlayer }
        set { if _playerWon == false {
                _winningPlayer = newValue!
                _playerWon = true
        } else {
            return
            }
        }
    }

    var playerTurn: Player {
        get { return _playerTurn }
        set { _playerTurn = newValue }
    }
    
    var missilesFired: Int {
        get {return _missilesFired }
        set { if _missilesFired >= 5 {
                _missilesFired = 0
                Delegate?.presentChangeView()
        } else {
                _missilesFired = newValue
            }}
    }
    
    func updateScore(#player: Player, score: Int) {
        switch player {
        case .player1:
            _p1Score += score
            if _p1Score >= 17 {
                Delegate?.playerWon(.player1)
                GameStore.sharedInstance.saveGames()

            }
        case .player2:
            _p2Score += score
            if _p2Score >= 17 {
                Delegate?.playerWon(.player2)
                GameStore.sharedInstance.saveGames()

            }
        }
    }
    
    func getScoreOf(#player: Player) -> Int {
        switch player {
        case .player1:
            return _p1Score
        case .player2:
            return _p2Score
        }
    }

   
    func updateEnemyTilefor(player: Player, at index: (x: Int, y: Int), with value: OceanSquare)
    {
        var enemyValue = OceanSquare.water
        
        if player == .player1 {
            if _p1Grid[index.x][index.y] != .water {
                enemyValue = _p1Grid[index.x][index.y]
            } else {
                enemyValue = value
            }
            _p1Grid[index.x][index.y] = value
            _p1EnemyGrid[index.x][index.y] = enemyValue
        } else {
            if _p2Grid[index.x][index.y] != .water {
                enemyValue = _p2Grid[index.x][index.y]
            } else {
                enemyValue = value
            }
            _p2Grid[index.x][index.y] = value
            _p2EnemyGrid[index.x][index.y] = enemyValue
        }
    }
    init()
    {
        // initialize with a bunch of ship objects for both players
        _p1Ships = createShips()
        _p2Ships = createShips()
        
        // initialize game grids
        gridMaker(10, columns: 10, player1: true)
        gridMaker(10, columns: 10, player1: false)
        
        // initialize enemy grids
        _p1EnemyGrid = waterGrid(10, y: 10)
        _p2EnemyGrid = waterGrid(10, y: 10)
        
        // place ships on grid
        distrubute()

    }
    
    func waterGrid(x: Int, y: Int) -> [[OceanSquare]]
    {
        var grid: [[OceanSquare]] = [[]]
        for i in 0..<x {
            
            var oceanSquares: [OceanSquare] = []
            for j in 0..<y {
                
                let tile = OceanSquare.water
                oceanSquares.append(tile)
            }
            if i == 0 {
                grid[0] = oceanSquares
            } else {
                grid.append(oceanSquares)
            }
            
        }
        
        return grid
    }
    
    func distrubute()
    {
        for key in _p1Ships.keys
        {
            switch key
            {
            case .patrol:
                _p1Ships[ShipTitle.patrol]?.startingPoint = place(_p1Ships[ShipTitle.patrol]!, player1Grid: true, value: .patrol)
                
            case .battleship:
                _p1Ships[ShipTitle.battleship]?.startingPoint = place(_p1Ships[ShipTitle.battleship]!, player1Grid: true, value: .battleship)

            case .submarine:
                _p1Ships[ShipTitle.submarine]?.startingPoint = place(_p1Ships[ShipTitle.submarine]!, player1Grid: true, value: .submarine)

            case .destroyer:
                _p1Ships[ShipTitle.destroyer]?.startingPoint = place(_p1Ships[ShipTitle.destroyer]!, player1Grid: true, value: .destroyer)

            case .carrier:
                _p1Ships[ShipTitle.carrier]?.startingPoint = place(_p1Ships[ShipTitle.carrier]!, player1Grid: true, value: .carrier)
                
            default:
                break//println("\(p1Ships[key])")r
            }
        }
    
        for key in _p2Ships.keys
        {
            switch key
            {
            case .patrol:
                _p2Ships[ShipTitle.patrol]?.startingPoint = place(_p1Ships[ShipTitle.patrol]!, player1Grid: false, value: .patrol)
                
            case .battleship:
                _p2Ships[ShipTitle.battleship]?.startingPoint = place(_p1Ships[ShipTitle.battleship]!, player1Grid: false, value: .battleship)
                
            case .submarine:
                _p2Ships[ShipTitle.submarine]?.startingPoint = place(_p1Ships[ShipTitle.submarine]!, player1Grid: false, value: .submarine)
                
            case .destroyer:
                _p2Ships[ShipTitle.destroyer]?.startingPoint = place(_p1Ships[ShipTitle.destroyer]!, player1Grid: false, value: .destroyer)
                
            case .carrier:
                _p2Ships[ShipTitle.carrier]?.startingPoint = place(_p1Ships[ShipTitle.carrier]!, player1Grid: false, value: .carrier)
                
            default:
                break//println("\(p1Ships[key])")r
            }
        }
    }

    func place(ship:Ship, player1Grid: Bool, value: OceanSquare) -> CGPoint
    {
        let length = CGFloat(ship.length)
        let isVertical: Bool =  ship.isVertical
        
        // points to check
        var randX = CGFloat(arc4random_uniform(10))
        var randY = CGFloat(arc4random_uniform(10))
        
        var randXOK: Bool = false
        var randYOK: Bool = false
        
        while randXOK == false && randYOK == false {
            // check if point is valid
            if isVertical {
                // check if inside grid
                

                // println("\(length)")
                if randY + length < CGFloat(10) {

                    // check if ships overlap
                    let shipExists = checkOceanSquareFor(CGPointMake(randX, randY), atLength: Int(length), isPlayer1Grid: player1Grid, isVertical: isVertical)
                    
                    if shipExists
                    {
                        randY = CGFloat(arc4random_uniform(10))
                        randX = CGFloat(arc4random_uniform(10))
                        
                    } else {
                        randYOK = true
            
                        // change squares
                        if player1Grid == true {
                            for i in 0..<Int(length) {
                               
                                _p1Grid[Int(randX)][Int(randY + CGFloat(i))] = value
                            }
                        } else {
                            for i in 0..<Int(length) {
                                
                                _p2Grid[Int(randX)][Int(randY + CGFloat(i))] = value
                            }
                        }
                    }
           
                } else {
                    randY = CGFloat(arc4random_uniform(10))
                   
                }
            } else {
               
                if randX + length < CGFloat(10)  {
                    
                    // check if insider grid
                    let shipExists = checkOceanSquareFor(CGPointMake(randX, randY), atLength: Int(length), isPlayer1Grid: player1Grid, isVertical: isVertical)
                    
                    if shipExists
                    {
                        randY = CGFloat(arc4random_uniform(10))
                        randX = CGFloat(arc4random_uniform(10))
                    } else {

                        randXOK = true
                        // change squares
                        if player1Grid {
                            for i in 0..<Int(length) {
                                
                                _p1Grid[Int(randX + CGFloat(i))][Int(randY)] = value
                            }
                        } else {
                            for i in 0..<Int(length) {
                                
                                _p2Grid[Int(randX + CGFloat(i))][Int(randY)] = value
                            }
                        }
                    }
                } else {
                    randX = CGFloat(arc4random_uniform(10))
                }
            }
        }
        
        // change ocean squares
        

        return CGPointMake(CGFloat(randX), CGFloat(randY))
        
    }
    
    
    func checkOceanSquareFor(point: CGPoint, atLength length: Int, isPlayer1Grid: Bool, isVertical: Bool) -> Bool
    {
        
        let pointY = Int(point.y)
        let pointX = Int(point.x)
        
            if isPlayer1Grid {
                // check for ship
                if isVertical {
                    // check for points along the vertical
                    for i in 0...length
                    {
                        
                        let square = _p1Grid[pointX][pointY + i]
                        if square != OceanSquare.water
                        {
                            return true
                        }
                    }
                } else {
                    // check for poitns along the horizontal
                    for i in 0...length {
                        
                        let square = _p1Grid[pointX + i][pointY]
                        if square != OceanSquare.water
                        {
                            return true
                        }
                    }
                }

            } else {
                // check for ship for player 2
                if isVertical {
                    // check for points along the vertical
                    for i in 0...length {
                        
                        let square = _p2Grid[pointX][pointY + i]
                        if square != OceanSquare.water
                        {
                            return true
                        }
                    }
                } else {
                    // check for poitns along the horizontal
                    for i in 0...length {
                        
                        let square = _p2Grid[pointX + i][pointY]
                        if square != OceanSquare.water {
                            
                            return true
                        }
                    }
                }
                
        }
        return false
    }
    
    // grid maker
    func gridMaker(rows: Int, columns: Int, player1: Bool)
    {
        let rows = 10
        let columns = 10
        
        for column in 0..<columns
        {
            var newRow: Array<OceanSquare> = []
            
            for row in 0..<rows
            {
                var square = OceanSquare.water
                newRow.append(square)
            }
            
            if column == 0 {
                if player1 == true
                {
                    _p1Grid[0] = newRow
                }
                else
                {
                    _p2Grid[0] = newRow
                }
            } else {
                if player1 == true
                {
                    _p1Grid.append(newRow)
                }
                else
                {
                    _p2Grid.append(newRow)
                }
            }
 
          
        }
    }
    
    // ship intializer function
    func createShips() -> [ShipTitle:Ship]
    {
        var randBool:Bool {
            
            if arc4random_uniform(2) % 2 == 0 {
                return true
            } else {
                return false
            }
        }
        var carrier = Ship(startPoint: CGPointZero, vertical: randBool, length: 5)
        var battleShip = Ship(startPoint: CGPointZero, vertical: randBool, length: 4)
        var submarine = Ship(startPoint: CGPointZero, vertical: randBool, length: 3)
        var destroyer = Ship(startPoint: CGPointZero, vertical: randBool, length: 3)
        var patrol = Ship(startPoint: CGPointZero, vertical: randBool, length: 2)
        
        let shipDictionary = [
            ShipTitle.carrier: carrier,
            ShipTitle.battleship: battleShip,
            ShipTitle.submarine: submarine,
            ShipTitle.destroyer: destroyer,
            ShipTitle.patrol: patrol]
        
        return shipDictionary
    }
    
    // update game state methods
    func playerChanged()
    {
        switch _playerTurn
        {
        case .player1:
            _playerTurn = .player2
        case .player2:
            _playerTurn = .player1
        }
    }
    
    // return a grid to build the view
    func gameGrids() -> (player1Grid: [[OceanSquare]], player2Grid: [[OceanSquare]], p1EnemyGrid: [[OceanSquare]], p2EnemyGrid: [[OceanSquare]])
    {
        return (_p1Grid, _p2Grid, _p1EnemyGrid, _p2EnemyGrid)
    }
    
    // saving data stuff
    func pushData() -> (p1Grid: [[OceanSquare]], p1EnemyGrid: [[OceanSquare]], p2Grid: [[OceanSquare]], p2EnemyGrid: [[OceanSquare]], p1Score: Int, p2Score: Int, winningPlayer: Player?, playerWon: Bool, playerTurn: Player, missilesFired: Int, gameState: GameStates)
    {
        
        return (_p1Grid, _p1EnemyGrid, _p2Grid, _p2EnemyGrid, _p1Score, _p2Score, _winningPlayer, _playerWon, _playerTurn, _missilesFired, gameState)

    }
    
    func pullData(p1Grid: [[OceanSquare]], p1EnemyGrid: [[OceanSquare]], p2Grid: [[OceanSquare]], p2EnemyGrid: [[OceanSquare]], p1Score: Int, p2Score: Int, winningPlayer: Player?, playerWon: Bool, playerTurn: Player, missilesFired: Int, gameState: GameStates)
    {
        _p1Grid = p1Grid
        _p1EnemyGrid = p1EnemyGrid
        _p1Score = p1Score
        _p2Grid = p2Grid
        _p2EnemyGrid = p2EnemyGrid
        _p2Score = p2Score
        _winningPlayer = winningPlayer
        _playerWon = playerWon
        _playerTurn = playerTurn
        _missilesFired = missilesFired
        self.gameState = gameState

    }
}






















