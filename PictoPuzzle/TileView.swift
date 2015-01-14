//
//  TileView.swift
//  PictoPuzzle
//
//  Created by Anny Ni on 12/1/14.
//  Copyright (c) 2014 Anny Ni. All rights reserved.
//

import UIKit

class TileView: UIImageView {

    var model : PlayPuzzleViewController!
    var initialPos : Int!
    var currentPos : Int!
 
    func handleTap() {
        if (checkValid(currentPos, emptyPos: self.model.emptyTile)) {
            move(currentPos, emptyPos: self.model.emptyTile, speed: 0.5)
            
        }
    }
    
    func move(currPos: Int, emptyPos: Int, speed: NSTimeInterval) {
        let dx = CGFloat((self.model.emptyTile%self.model.size)-(currentPos%self.model.size)) * (self.model.gameContainer.bounds.width/CGFloat(self.model.size))
        let dy = CGFloat((self.model.emptyTile/self.model.size)-(currentPos/self.model.size)) * (self.model.gameContainer.bounds.height/CGFloat(self.model.size))
        
        let temp = currentPos
        self.currentPos = self.model.emptyTile
        self.model.emptyTile = temp
        
        UIView.animateWithDuration(speed, animations: {
            self.frame.offset(dx: dx, dy: dy)
            }, completion:nil
        )
        
        if (self.model.gameInit! && self.model.gameEnd==false) {
            self.model.numMoves! += 1
            self.model.movesLabel.text = String(self.model.numMoves!)
        }
        
        if (self.model.gameInit! && self.model.checkWin()) {
            self.model.doWin()
        }
    }
    
    func checkValid(currPos: Int, emptyPos : Int) -> Bool {
        let currRow = currPos/self.model.size
        let currCol = currPos%self.model.size
        let emptyRow = emptyPos/self.model.size
        let emptyCol = emptyPos%self.model.size
        
        if (currRow==emptyRow && abs(currCol-emptyCol)==1
            || currCol==emptyCol && abs(currRow-emptyRow)==1) {
            return true
        } else {
            return false
        }
    }

}
