//
//  GameView.swift
//  MVC BattleShip
//
//  Created by Christopher REECE on 3/7/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

class GameView: UIView {

 
    
    // holds two gridviews and a fire button
    var friendlyShips: GridView!
    var enemyShips: GridView!
    var fireButton: UIButton!
    var backButton: UIButton!
    private var _stats: StatsView!
    
    init(frame: CGRect, playerGrid: [[OceanSquare]], enemyGrid: [[OceanSquare]]) {
        super.init(frame: frame)
        
        _stats = StatsView(frame: CGRectMake(bounds.midX - bounds.size.width / 3, bounds.height / 27
            , bounds.size.width / 1.5, bounds.width / 8))
        var grid = CGRectMake(bounds.midX - bounds.size.width / 3, bounds.midY - bounds.size.height / 2.65, bounds.size.width / 1.5, bounds.size.width / 1.5)
        // create grid dimensions
        friendlyShips = GridView(frame: grid, grid: playerGrid, hidden: false, numberOfTiles: (10,10))
        friendlyShips.backgroundColor = UIColor.redColor()
        
        grid.origin.y = bounds.midY + 5
        enemyShips = GridView(frame: grid, grid: enemyGrid, hidden: true, numberOfTiles: (10,10))
        enemyShips.backgroundColor = UIColor.blueColor()
        addSubview(friendlyShips)
        addSubview(enemyShips)
        
        grid.size.height = 60
        grid.origin.y = bounds.size.height - 65
        // create fire button
        fireButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        fireButton.addTarget(superview, action: "boom:", forControlEvents: UIControlEvents.TouchDown)
        fireButton.backgroundColor = UIColor.grayColor()
        fireButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Application)
        fireButton.setTitle("BOOM!", forState: UIControlState.Normal)
        fireButton.frame = grid
        addSubview(fireButton)
        
        backButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        backButton.frame = CGRectMake(5, bounds.midY - bounds.size.height / 2.65 + 2, 44, 44)
        backButton.backgroundColor = UIColor.whiteColor()
        backButton.setTitle("BACK", forState: UIControlState.Normal)
        backButton.addTarget(superview, action: "dismissSelf:", forControlEvents: UIControlEvents.TouchDown)
        addSubview(backButton)
       
        addSubview(_stats)

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func updateStatsFor(#player: Player, hits: Int) {
        
        _stats.updatePercentageFor(player: player, numberOfHits: hits)
    }
    
    func updateWinner(player: String)
    {
        _stats.winner.text = "Winner: \(player)"
    }
    
}
