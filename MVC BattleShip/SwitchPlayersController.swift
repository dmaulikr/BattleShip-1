//
//  SwitchPlayersController.swift
//  MVC BattleShip
//
//  Created by Christopher REECE on 3/9/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

class SwitchPlayersController: UIViewController
{

    var playerTurn: Player = Player.player1
    
    override func viewDidLoad() {
        
        view.backgroundColor = UIColor.blueColor()

        var labelFrame: CGRect = view.bounds
        
        var changePlayerLabel = UILabel()
        (changePlayerLabel.frame, labelFrame) = labelFrame.rectsByDividing(view.bounds.size.height / 2.0, fromEdge: CGRectEdge.MinYEdge)
        changePlayerLabel.text = "Hand game to \(playerTurn.name)"
        changePlayerLabel.textColor = UIColor.whiteColor()
        changePlayerLabel.textAlignment = NSTextAlignment.Center
        
        var dismissButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        (dismissButton.frame, labelFrame) = labelFrame.rectsByDividing(labelFrame.size.height / 2.0, fromEdge: CGRectEdge.MinYEdge)
        dismissButton.frame = labelFrame
        dismissButton.setTitle("DISMISS", forState: UIControlState.Normal)
        dismissButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        dismissButton.backgroundColor = UIColor.blackColor()
        dismissButton.addTarget(self, action: "dismiss:", forControlEvents: UIControlEvents.TouchDown)
        
        view.addSubview(changePlayerLabel)
        view.addSubview(dismissButton)
        
    }
    
    func dismiss(sender: UIButton)
    {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
}
