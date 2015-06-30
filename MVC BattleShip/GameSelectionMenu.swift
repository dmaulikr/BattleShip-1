//
//  GameSelectionMenu.swift
//  MVC BattleShip
//
//  Created by Christopher REECE on 3/15/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

class GameSelectionMenu: UITableViewController {
    
    override func viewDidLoad()
    {
      
        navigationItem.title = "BattleShip"
        
        let addGame = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newGame:")
        navigationItem.rightBarButtonItem = addGame
        navigationItem.leftBarButtonItem = editButtonItem()
        
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return GameStore.sharedInstance.gameCount()
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let gameIndex: Int = indexPath.row
        let game = GameStore.sharedInstance.gameAtIndex(gameIndex)
        
        
        var cell: UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell)) as! UITableViewCell?
        
        if cell == nil
        {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: NSStringFromClass(UITableViewCell))
        }
        
        var playerWon: String {
            if game.playerWon == nil {
                return "???"
            } else {
                return game.playerWon!.name
            }
        }
        
        cell.textLabel?.text = "Game #\(gameIndex)"
        cell.detailTextLabel?.text = "STATE: \(game.gameState.name)  TURN: \(game.playerTurn.name) WINNER: \(playerWon)"

        return cell
    }
    
    
    // Delagate methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let gameView = GameController()
        let michanGame = GameStore.sharedInstance.gameAtIndex(indexPath.row)
        gameView.game = michanGame
        gameView.gameNumber = indexPath.row
        
        
        self.presentViewController(gameView, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == .Delete {
            GameStore.sharedInstance.deleteGameAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.reloadData()
        }
    }

    // navigation controller methods
    func newGame(sender: UIBarButtonItem)
    {
        GameStore.sharedInstance.newGame()
        tableView.reloadData()
    }
}


