//
//  StatsView.swift
//  MVC BattleShip
//
//  Created by Christopher REECE on 3/13/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

class StatsView:UIView {
    
    // TODO: Add text to labels, change variable names to be more descriptive, create variables to hold player %
    var p1Label: UILabel = UILabel()
    var p1Percentage: Float = 0.0
    var p2Label: UILabel = UILabel()
    var p2Percentage: Float = 0.0
    var winner: UILabel = UILabel()
    
    var p1Progress: UIProgressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
    var p2Progress: UIProgressView = UIProgressView(progressViewStyle: UIProgressViewStyle.Default)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // layout subviews 
        var layoutFrame: CGRect = bounds
        backgroundColor = UIColor.clearColor()
        
        (winner.frame, layoutFrame) = layoutFrame.rectsByDividing(bounds.height / 2.0, fromEdge: CGRectEdge.MinYEdge)
        (p1Progress.frame, p2Progress.frame) = layoutFrame.rectsByDividing(layoutFrame.height / 2.0, fromEdge: CGRectEdge.MinYEdge)
        winner.textAlignment = NSTextAlignment.Center
        p1Progress.frame.size.width = bounds.width / 1.1
        p1Progress.frame.origin.x = bounds.width - bounds.width / 1.1
        p1Label.frame.origin.x = 0
        p1Label.frame.origin.y = p1Progress.frame.origin.y - 10
        p1Label.frame.size.height = 20
        p1Label.frame.size.width = bounds.width - bounds.width / 1.1
        
        p2Progress.frame.size.width = bounds.width / 1.1
        p2Progress.frame.origin.x = bounds.width - bounds.width / 1.1
        p2Label.frame.origin.x = 0
        p2Label.frame.origin.y = p2Progress.frame.origin.y - 10
        p2Label.frame.size.height = 20
        p2Label.frame.size.width = bounds.width - bounds.width / 1.1
        
        winner.text = "Winner: ???"
        p1Label.text = "P1: "
        p2Label.text = "P2: "
        winner.font = UIFont.systemFontOfSize(bounds.height / 3)
        p1Label.font = UIFont.systemFontOfSize(bounds.height / 3.5)
        p2Label.font = UIFont.systemFontOfSize(bounds.height / 3.5)
        winner.textColor = UIColor.yellowColor()
        p1Label.textColor = UIColor.yellowColor()
        p2Label.textColor = UIColor.yellowColor()

        addSubview(winner)
        addSubview(p1Progress)
        addSubview(p2Progress)
        addSubview(p1Label)
        addSubview(p2Label)
        
        //        var r: CGRect = bounds
        //        // the remainder rectangle
        //        // plug in the rectangle to be modified, and where the remainder should go
        //        (_redKnob.frame, r) = r.rectsByDividing(bounds.width / 2.0, fromEdge: CGRectEdge.MinXEdge)
        //        (_greenKnob.frame, _blueKnob.frame) = r.rectsByDividing(r.width / 2.0, fromEdge: CGRectEdge.MinYEdge)
    }

    func updatePercentageFor(#player: Player, numberOfHits: Int)
    {
        switch player {
        case .player1:
            p1Percentage = Float(numberOfHits) / 17
            p1Progress.progress = p1Percentage

        case .player2:
            p2Percentage = Float(numberOfHits) / 17
            p2Progress.progress = p2Percentage
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

