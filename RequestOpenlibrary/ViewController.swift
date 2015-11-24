//
//  ViewController.swift
//  RequestOpenlibrary
//
//  Created by Aaron Marquez on 22/11/15.
//  Copyright © 2015 Aaron Marquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet var txtISBNSearch: UITextField!
    @IBOutlet var resultISBNSearch: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txtISBNSearch.delegate = self
        resultISBNSearch.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    
    func requestOpenlibrary(isbnText: String){
        let apiUrl = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbnText)"
        let url = NSURL(string: apiUrl)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            (data, response, error) -> Void in

            dispatch_async(dispatch_get_main_queue(), {
                if((response) != nil){
                   let valores = NSString(data: data!, encoding: NSUTF8StringEncoding)! as String
                    if valores.containsString(isbnText) {
                        self.resultISBNSearch.hidden = false
                        self.resultISBNSearch.text = valores
                    }else{
                        self.alert("No se econtraron resultados del ISBN introducido")
                    }
                }else{
                    self.alert("Error al obtener los datos, revisar conexión a Internet")
                }
            })
        })
        
        task.resume()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField.text != "" {
            requestOpenlibrary(textField.text!)
            textField.resignFirstResponder()
        }else{
            alert("Introduce un ISBN")
        }
        
        return true
    }
    
    
    func alert(message : String){
        let alertController = UIAlertController(title: "Openlibrary Alert", message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alertController.addAction(ok)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    
}

