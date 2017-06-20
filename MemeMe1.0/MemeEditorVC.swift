//
//  MemeEditorViewController.swift
//  MemeMe1.0
//
//  Created by Michael Alexander on 5/17/17.
//  Copyright © 2017 Michael Alexander. All rights reserved.
//

import UIKit

class MemeEditorVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    var memedImage:UIImage?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        // if camera is unavailable, disable camera button
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //if photo has not been selected, disable share button
        if(imagePickerView.image == nil){
           
            shareButton.isEnabled = false
        }else{
            shareButton.isEnabled = true
        }
        
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureText(topText, defaultText: "TOP")
        configureText(bottomText, defaultText: "BOTTOM")
        
    }

    @IBAction func chooseImagePressed(_ sender: UIButton) {
    
        switch sender.tag {
        case 0: pickAnImageFrom(.camera)
        case 1: pickAnImageFrom(.photoLibrary)
        default: break
            
        }
     }
    
    @IBAction func shareMeme(_ sender: Any) {
        
         memedImage = generateMemedImage()
 
        //launch activity view with memedImage
         let activityVC = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
        
        //saves meme image
        activityVC.completionWithItemsHandler = {
            activity, completed, items, error in
            if completed{
                self.save()
                self.dismiss(animated: true, completion: nil)
            
            }else if ((error) != nil){
                print("Unable to save meme: ", error!)
            }
        }
        
        present(activityVC, animated: true, completion: nil)
    }
    
    //resets fields
    @IBAction func cancelPressed(_ sender: Any) {
        
        if(imagePickerView.image == nil){
            
            dismiss(animated: true, completion: nil)
               
        }else{}
        
        topText.text = "TOP"
        imagePickerView.image = nil
        bottomText.text = "BOTTOM"
        
        shareButton.isEnabled = false
        
    }

    //launches camera for image selection
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //clears default text
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if (textField.text == "BOTTOM" || textField.text == "TOP"){
            textField.text?.removeAll()
        }
        
  }
    
    // dismisses the keyboard when users hits return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //shifts the view up from bottom text field to be visible
    func keyboardWillShow(notification: NSNotification){
    
        if bottomText.isFirstResponder{
        view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
    }
    
    //shifts view down once done editing bottom text field
    func keyboardWillHide(notification: NSNotification){
    
        if bottomText.isFirstResponder{
        view.frame.origin.y = 0
        }
    }
    
    //helper function for keyboardWillShow
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    func subscribeToKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    
    //create a meme object and add it to the memes array
    func save() {
 
        //update the meme
        let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: memedImage!)
        
        //add to memes array in app delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }

    func generateMemedImage() -> UIImage {
        
        // hide toolbar temporarily to render image
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
 
        toolBar.isHidden = false
        
        return memedImage
    }
    
    // sets textfields delegate and atrributes
    func configureText(_ textField: UITextField, defaultText: String) {
        
        //custom meme text
        let memeTextAttributes:[String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
            NSStrokeWidthAttributeName: -3.0]
        
            textField.delegate = self
            textField.defaultTextAttributes = memeTextAttributes
            textField.text = defaultText
            textField.textAlignment = .center
            textField.backgroundColor = .clear
        
    }
    
    // launches either camera or gallery source type depending on button pressed
    func pickAnImageFrom(_ source: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
}

