//
//  GalleryTableViewController.swift
//  PictoPuzzle
//
//  Created by Anny Ni on 11/30/14.
//  Copyright (c) 2014 Anny Ni. All rights reserved.
//

import UIKit

struct Puzzle {
    var original : UIImage
    var name : String
    var moves : String
    var size : Int
    
}

class GalleryTableViewController: UITableViewController, CreatePuzzleDelegate {

    var puzzles : [Puzzle] = []
    var rowSel : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rowSel = 0
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.puzzles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Configure the cell...
        
        var cell : GalleryTableViewCell
        var dq : AnyObject? = tableView.dequeueReusableCellWithIdentifier("puzzleCell")
        if (dq != nil) {
            cell = dq! as GalleryTableViewCell
        } else {
            cell = GalleryTableViewCell()
        }
        
        var puzzle = self.puzzles[indexPath.row]
        
        cell.galleryPuzzleView.image = puzzle.original
        cell.bestMovesLabel.text = puzzle.moves
        cell.puzzleNameLabel.text = puzzle.name
        
        return cell
    }
    
    
    // ADD PUZZLE DELEGATE
    func addPuzzle(picture: UIImage, name: String, size: Int) {
        self.puzzles.append(Puzzle(original: picture, name: name, moves: "none yet", size: size))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case "createPuzzleSegue":
            if var destViewController = segue.destinationViewController as? CreatePuzzleViewController {
                destViewController.delegate = self
            }
        case "playPuzzleSegue":
            if var destViewController = segue.destinationViewController as? PlayPuzzleViewController {
                if var cell = sender as? GalleryTableViewCell {
                    destViewController.setImage(cell.galleryPuzzleView.image!)
                    destViewController.gallery = self
                }
            }
        default:
            break
        }
    }
    
    override func tableView(UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.rowSel = indexPath.row
    }
    
    func updateMoves(moves: Int, index: Int) {
        if (self.puzzles[index].moves == "none yet" ||
            self.puzzles[index].moves.toInt()! > moves) {
            self.puzzles[index].moves = String(moves)
            self.tableView.reloadData()
        }
    }

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
