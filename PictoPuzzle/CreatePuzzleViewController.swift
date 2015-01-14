//
//  CreatePuzzleViewController.swift
//  PictoPuzzle
//
//  Created by Anny Ni on 11/30/14.
//  Copyright (c) 2014 Anny Ni. All rights reserved.
//

import UIKit
import Foundation

protocol CreatePuzzleDelegate {
    func addPuzzle(picture: UIImage, name: String, size: Int)
}

class CreatePuzzleViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {


    var delegate : CreatePuzzleDelegate!;
    @IBOutlet var puzzleImageView: UIImageView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var sizeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.puzzleImageView.image == nil) {
            self.puzzleImageView.image = UIImage(named: "puppy.jpg")
        }
        self.puzzleImageView.layer.masksToBounds = true

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func deselect(sender: AnyObject) {
        nameTextField.resignFirstResponder()
        sizeTextField.resignFirstResponder()
    }

    @IBAction func selectImageButton(sender: AnyObject) {
        var actionSheet: UIActionSheet = UIActionSheet(title: "Photo Picker", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Photo Library", "Take Photo")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        //user selected cancel
        if(buttonIndex == 0) {
            return
        }
        
        var imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        // default to selecting photo from photo library
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        // if the user selected camera and the camera is available
        if(buttonIndex == 2 && UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        }
        
        //Show the image picker
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image: UIImage = info[UIImagePickerControllerEditedImage] as UIImage
        dismissViewControllerAnimated(true, completion: nil)
        self.puzzleImageView.image = image
    }
    
    
    @IBAction func doneButton(sender: AnyObject) {
        var name : String? = nameTextField.text
        var size : Int? = sizeTextField.text.toInt()
        if (name == nil) {
            name = "Puzzle"
        }
        if (size == nil) {
            size = 4
        }
        var img : UIImage? = self.puzzleImageView.image
        if (img != nil && name != nil && size != nil) {
            delegate.addPuzzle(img!, name: name!, size: size!)
        }
        
        

        self.navigationController!.popViewControllerAnimated(true)
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
