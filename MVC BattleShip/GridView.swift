//
//  GridView.swift
//  MVC BattleShip
//
//  Created by Christopher REECE on 3/5/15.
//  Copyright (c) 2015 Christopher Reece. All rights reserved.
//

import UIKit

class GridView: UIView, TileDelegate {
    
    private var _grid: (width: Int, height: Int) = (10, 10)
    private var _tileTouched: (x: Int, y: Int) = (1, 1)
    private var _lastTileTouched: (x: Int, y: Int) = (5,5)
    private var _hidden: Bool = false
    private var _ships: [[OceanSquare]] = [[]]
   // private var _lastValue: OceanSquare = .water
    private var _squareSize: (width: CGFloat, height: CGFloat) = (10, 10)
    
    var tileTouched: (x: Int, y: Int) {
        get { return _tileTouched }
        set { _tileTouched = newValue;
            updateTileAt(newValue, with: .highlighted, finalize: false);
            if _lastTileTouched.x == _tileTouched.x && _tileTouched.y == _lastTileTouched.y{
               return
            }
            updateTileAt(_lastTileTouched, with: .water, finalize: false);
            _lastTileTouched = newValue }
        
        }
    
        
    func updateTileAt(index: (x: Int, y: Int), with tileType: OceanSquare, finalize: Bool)
    {
        // need to update subview as well
        (subviews[index.x * 10 + index.y] as! Tile).tileType = tileType
        if finalize == true {
            (subviews[index.x * 10 + index.y] as! Tile).finalizeTileState()
        }
    }

    func tileTypeAt(index: (x: Int, y: Int)) -> OceanSquare
    {
        return  (subviews[index.x * 10 + index.y] as! Tile).tileType
    }
    
    func updateTile(index: (x: Int, y: Int))
    {
        tileTouched = index
    }

    init(frame: CGRect, grid: [[OceanSquare]], hidden: Bool, numberOfTiles: (width: Int, height: Int))
    {
        _grid = numberOfTiles
        super.init(frame: frame)
        _squareSize = (bounds.size.width * 0.1, bounds.size.height * 0.1)
        _hidden = hidden
         // fill out grid
        if hidden == true {
            layoutHiddenTiles(with: grid)
        } else {
            userInteractionEnabled = false
            layoutVisibleTiles(with:grid)
        }
    
        
    }
    
    init(grid: [[OceanSquare]], hidden: Bool, numberOfTiles: (width: Int, height: Int), frame: CGRect)
    {
        
        super.init(frame: frame)
        _squareSize = (bounds.size.width * 0.1, bounds.size.height * 0.1)
        _grid = numberOfTiles
        _ships = grid

        
    
       //  fill out grid
        if hidden == true {
            layoutHiddenTiles(with:grid)
        } else {
            userInteractionEnabled = false
            layoutVisibleTiles(with:grid)
        }
        
        
    }
    
    private func layoutHiddenTiles(with grid:[[OceanSquare]])
    {

        for i in 0..<grid.count {
            
            for j in 0..<grid[i].count {
                // check for square and draw accordingly
                let tileFrame = CGRectMake(CGFloat(i) * _squareSize.width, CGFloat(j) * _squareSize.height, _squareSize.width, _squareSize.height)
                var tile = Tile(frame: tileFrame, delegate: self)
                tile.tileType = grid[i][j]
                tile.index = (i, j)
                addSubview(tile)
            }
        }

    }
    
    private func layoutVisibleTiles(with grid:[[OceanSquare]])
    {
        userInteractionEnabled = false
        for i in 0..<grid.count {
            
            for j in 0..<grid[i].count {
                // check for square and draw accordingly
                let tileFrame = CGRectMake(CGFloat(i) * _squareSize.width, CGFloat(j) * _squareSize.height, _squareSize.width, _squareSize.height)
                var tile = Tile(frame: tileFrame, delegate: self)
                tile.tileType = grid[i][j]
                tile.index = (i, j)
                addSubview(tile)
            }
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        _grid = (10,10)
        super.init(frame: frame)
    }
}