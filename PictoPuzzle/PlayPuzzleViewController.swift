//
//  PlayPuzzleViewController.swift
//  PictoPuzzle
//
//  Created by Anny Ni on 11/30/14.
//  Copyright (c) 2014 Anny Ni. All rights reserved.
//

import UIKit

class PlayPuzzleViewController: UIViewController {

    @IBOutlet var gameContainer: UIView!
    @IBOutlet var movesLabel: UILabel!
    @IBOutlet var puzzleNameLabel: UILabel!
    
    var originalpic : UIImage!
    var scaledPic : UIImage!
    var size : Int!
    var picarray : [TileView] = []
    var emptyImg : TileView!
    var emptyTile : Int!
    var gameInit : Bool!
    var gameEnd : Bool!
    var numMoves : Int!
    
    var gallery : GalleryTableViewController!
 
    func getImageArray(pic: UIImage) -> [TileView] {
        let size = CGFloat(self.size)
        var images : [TileView] = []
        var imageSize : CGSize = pic.size
        
        let shiftW = gameContainer.bounds.width / size
        let shiftH = gameContainer.bounds.height / size

        let width = imageSize.width/size
        let height = imageSize.height/size
        var y: Int
        var x: Int
        
        for y = 0; y < self.size; ++y {
            for x = 0; x < self.size; ++x {
                if ((y == self.size-1) && (x == self.size-1)) {
                    let rect = CGRectMake(CGFloat(x) * width, CGFloat(y) * width, width, height)
                    let cImage = CGImageCreateWithImageInRect(pic.CGImage, rect)
                    emptyImg = TileView(image: UIImage(CGImage: cImage))
                    emptyImg.frame = CGRectMake(CGFloat(x)*shiftW, CGFloat(y)*shiftH, width, UIImage(CGImage: cImage).size.height)
                } else {
                    let rect = CGRectMake(CGFloat(x) * width, CGFloat(y) * width, width, height)
                    let cImage = CGImageCreateWithImageInRect(pic.CGImage, rect)
                    var dImage : TileView = TileView(image: UIImage(CGImage: cImage))
                    dImage.frame = CGRectMake(CGFloat(x)*shiftW, CGFloat(y)*shiftH, width, UIImage(CGImage: cImage).size.height)
                    dImage.initialPos = x+y*self.size
                    dImage.currentPos = dImage.initialPos
                    dImage.model = self
                    dImage.userInteractionEnabled = true
                    let recognizer = UITapGestureRecognizer(target: dImage, action: "handleTap")
                    dImage.addGestureRecognizer(recognizer)
                    
                    gameContainer.addSubview(dImage)
                    images.append(dImage)
                }
            }
        }
        return images
        
    }
    
    func scramble(images: [TileView]) {
        // 0 is left and then it goes clockwise
        var x: Int
        var y: Int
        var available : [Int] = []
        for x = 0; x < 200; ++x {
            available = []
            for y = 0; y < 4; ++y {
                if (checkScram(y)) {
                    available.append(y)
                }
            }
            
            let rand = available[Int(arc4random_uniform(UInt32(available.count)))]
            
            let speed = 1.5
            
            switch rand {
            case 0:
                for img in images {
                    if (img.currentPos == self.emptyTile - 1) {
                        img.move(img.currentPos, emptyPos: self.emptyTile, speed: speed)
                        break
                    }
                }
            case 1:
                for img in images {
                    if (img.currentPos == self.emptyTile - self.size) {
                        img.move(img.currentPos, emptyPos: self.emptyTile, speed: speed)
                        break
                    }
                }
            case 2:
                for img in images {
                    if (img.currentPos == self.emptyTile + 1) {
                        img.move(img.currentPos, emptyPos: self.emptyTile, speed: speed)
                        break
                    }
                }
            case 3:
                for img in images {
                    if (img.currentPos == self.emptyTile + self.size) {
                        img.move(img.currentPos, emptyPos: self.emptyTile, speed: speed)
                        break
                    }
                }
            default:
                break
            }
                
            
        }
    }
    
    func checkScram(ind : Int) -> Bool {
        switch ind {
        case 0:
            if(self.emptyTile%self.size != 0) {
                return true
            } else {
                return false
            }
        case 1:
            if(self.emptyTile/self.size != 0) {
                return true
            } else {
                return false
            }
        case 2:
            if(self.emptyTile%self.size != self.size-1) {
                return true
            } else {
                return false
            }
        case 3:
            if(self.emptyTile/self.size != self.size-1) {
                return true
            } else {
                return false
            }
        default:
            return false
        }
    }
    
    func checkWin() -> Bool {
        var flag : Int = 1
        for img in self.picarray {
            if (img.initialPos != img.currentPos) {
                flag = 0
            }
        }
        
        if (flag == 1) {
            self.gameEnd = true
            return true
        } else {
            return false
        }
    }
    
    func doWin () {
        self.gallery.updateMoves(self.numMoves, index: self.gallery.rowSel!)
        
        let size = CGFloat(self.size)
        var imageSize : CGSize = self.originalpic.size
        
        let width = imageSize.width
        let height = imageSize.height
        
        let rect = CGRectMake(0, 0, width, height)
        let cImage = CGImageCreateWithImageInRect(self.originalpic.CGImage, rect)
        var dImage : TileView = TileView(image: UIImage(CGImage: cImage))
        dImage.frame = CGRectMake(0, 0, width, UIImage(CGImage: cImage).size.height)
        dImage.initialPos = 0
        dImage.currentPos = dImage.initialPos
        dImage.model = self
        dImage.userInteractionEnabled = false
        
        self.gameContainer.addSubview(dImage)
        dImage.alpha = 0.0

        UIView.animateWithDuration(0.5, animations: {
            dImage.alpha = 1.0
            }, completion:nil
        )
        
    }
    
    func setImage(pic: UIImage) {
        self.originalpic = pic
    }
    
    func processImage() {
        let targetSize = CGSizeMake(gameContainer.bounds.width-2*CGFloat(self.size), gameContainer.bounds.width-CGFloat(self.size)*2)
        let hasAlpha = false
        let scale: CGFloat = 1.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, scale)
        originalpic.drawInRect(CGRect(origin: CGPointZero, size: targetSize))
        
        self.scaledPic = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let targetSize2 = CGSizeMake(gameContainer.bounds.width, gameContainer.bounds.width)
        
        UIGraphicsBeginImageContextWithOptions(targetSize2, false, scale)
        originalpic.drawInRect(CGRect(origin: CGPointZero, size: targetSize2))
        self.originalpic = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameInit = false
        self.gameEnd = false
        self.numMoves = 0
        self.puzzleNameLabel.text = self.gallery.puzzles[self.gallery.rowSel].name
        self.movesLabel.text = String(self.numMoves)
        self.size = self.gallery.puzzles[self.gallery.rowSel].size
        self.emptyTile = self.size*self.size - 1
        self.processImage()
        self.picarray = getImageArray(scaledPic)
        
        let tapRec = UITapGestureRecognizer(target:self, action: "fat")
        gameContainer.addGestureRecognizer(tapRec)
    }
    
    func fat() {
        print("hello")
    }

    override func viewDidAppear(animated: Bool) {
        self.scramble(self.picarray)
        self.gameInit = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
