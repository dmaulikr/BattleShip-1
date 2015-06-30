//
//  GameController.swift
//  MVC BattleShip
//
//  Created by Christopher REECE on 3/7/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

class GameController: UIViewController, GameDelegate {

    // needs to switch between two sets of gameviews
    // updates game view grids
    private var _player1View: GameView?
    private var _player2View: GameView?
    var game: Game!
    var gameNumber: Int = 0

    override func viewDidLoad() {
    
        if game.gameState == .newGame {
            game.gameState = .inProgress
        }
        
        // initalize the game model object
        navigationItem.title = "Game #\(gameNumber)"
        game.Delegate = self
        let grids = game?.gameGrids()
      
        // initialize playerviews
        _player1View = GameView(frame: view.bounds, playerGrid: grids!.player1Grid, enemyGrid: grids!.p2EnemyGrid)
        _player2View = GameView(frame: view.bounds, playerGrid: grids!.player2Grid, enemyGrid: grids!.p1EnemyGrid)
        
        if game.playerTurn == .player1 {
             view = _player1View
        } else {
             view = _player2View
        }
        
        updatePlayerStats()
       
        navigationController?.modalPresentationStyle = UIModalPresentationStyle.FormSheet
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
  
        let tableView = presentingViewController
        
        if tableView == nil {
            return
        } else {
            ((tableView as! UINavigationController).viewControllers[0] as! UITableViewController).tableView.reloadData()
        }
        
        // save game data here for now

    }
    
    
    func boom(sender: UIButton)
    {
        GameStore.sharedInstance.saveGames()
        switch game.playerTurn {
        case .player1:
            
                let tileTouched = _player1View!.enemyShips.tileTouched
                
                let enemyOceanSquare = game.gameGrids().player2Grid[tileTouched.x][tileTouched.y]
                
                if enemyOceanSquare == OceanSquare.water {
                    _player1View!.enemyShips.updateTileAt(tileTouched, with: OceanSquare.fired, finalize: true)
                    game.updateEnemyTilefor(.player2, at: tileTouched, with: OceanSquare.fired)
                    _player2View!.friendlyShips.updateTileAt(tileTouched, with: OceanSquare.fired, finalize: true)
                    game.missilesFired += 1
                    
                } else if enemyOceanSquare != .fired {
                    _player1View!.enemyShips.updateTileAt(tileTouched, with: enemyOceanSquare, finalize: true)
                    game.updateEnemyTilefor(.player2, at: tileTouched, with: OceanSquare.hit)
                    _player2View!.friendlyShips.updateTileAt(tileTouched, with: OceanSquare.hit, finalize: true)
                    game.updateScore(player: .player1, score: 1)
                    updatePlayerStats()
                    setStrob(funcToCall:"hitStrobe:")
                    game.missilesFired += 1
                }
            
        case .player2:

                let tileTouched = _player2View!.enemyShips.tileTouched
                
                let enemyOceanSquare = game.gameGrids().player1Grid[tileTouched.x][tileTouched.y]
                
                if enemyOceanSquare == OceanSquare.water {
                    _player2View!.enemyShips.updateTileAt(tileTouched, with: OceanSquare.fired, finalize: true)
                    game.updateEnemyTilefor(.player1, at: tileTouched, with: OceanSquare.fired)
                    _player1View!.friendlyShips.updateTileAt(tileTouched, with: OceanSquare.fired, finalize: true)
                    game.missilesFired += 1
                    
                } else if enemyOceanSquare != .fired {
                    _player2View!.enemyShips.updateTileAt(tileTouched, with: enemyOceanSquare, finalize: true)
                    game.updateEnemyTilefor(.player1, at: tileTouched, with: OceanSquare.hit)
                    _player1View!.friendlyShips.updateTileAt(tileTouched, with: OceanSquare.hit, finalize: true)
                    game.updateScore(player: .player2, score: 1)
                    updatePlayerStats()
                    setStrob(funcToCall:"hitStrobe:")
                    game.missilesFired += 1
                }
            }
            
        }
    
    func presentChangeView()
    {
        game.missilesFired = 0
        game.playerChanged()
        
      
        let changeView = SwitchPlayersController(nibName: nil, bundle: nil)
        changeView.playerTurn = game.playerTurn
        presentViewController(changeView, animated: false, completion: nil)

        if game.playerTurn == .player1 {
            view = _player1View
        } else {
            view = _player2View
        }
    }
    func updatePlayerStats()
    {
        _player1View!.updateStatsFor(player: .player1, hits: game.getScoreOf(player: .player1))
        _player1View!.updateStatsFor(player: .player2, hits: game.getScoreOf(player: .player2))
        _player2View!.updateStatsFor(player: .player1, hits: game.getScoreOf(player: .player1))
        _player2View!.updateStatsFor(player: .player2, hits: game.getScoreOf(player: .player2))
    }
    
    func playerWon(player: Player)
    {
        
        _player2View!.updateWinner(player.name)
        _player1View!.updateWinner(player.name)
        setStrob(funcToCall:"endGameStrobe:")
        game.gameState = GameStates.finished
        game.playerWon = player
        
        let grids = game.gameGrids()
    }
    
    func setStrob(#funcToCall: String)
    {
        let sel = NSSelectorFromString(funcToCall)
        let myRunLoop = NSRunLoop.currentRunLoop()
        
        let animationTimer = NSTimer(timeInterval: 0.025, target: self, selector: sel, userInfo: nil, repeats: true)
        
        myRunLoop.addTimer(animationTimer, forMode: NSDefaultRunLoopMode)
    }

    func hitStrobe(sender: NSTimer)
    {
        if StrobeCounter.count >= 10 {
            sender.invalidate()
            StrobeCounter.count = 0
            view.backgroundColor = UIColor.blackColor()
            return
        }
        StrobeCounter.count += 1
        if StrobeCounter.count % 2 == 0 {
            view.backgroundColor = UIColor.redColor()
        } else {
            view.backgroundColor = UIColor.blackColor()
        }
    }
    
    func endGameStrobe(sender: NSTimer)
    {
        if StrobeCounter.count >= 49 {
            sender.invalidate()
            StrobeCounter.count = 0
            view.backgroundColor = UIColor.grayColor()
            return
        }
        
        StrobeCounter.count += 1
        if StrobeCounter.count % 2 == 0 {
            view.backgroundColor = UIColor.blueColor()
        } else {
            view.backgroundColor = UIColor.redColor()
        }
    }
    
    func dismissSelf(sender: UIButton)
    {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
