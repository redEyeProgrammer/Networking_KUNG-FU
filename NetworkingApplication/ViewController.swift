//
//  ViewController.swift
//  NetworkingApplication
//
//  Created by redEyeProgrammer on 5/23/17.
//  Copyright © 2017 att. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //POSTUrlRequest()
        GETUrlRequest()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func GETUrlRequest(){
        //Using S.U.R.T
        let session = URLSession.shared
        let todosEndpoint = "https://jsonplaceholder.typicode.com/todos"
        guard let todoURL = URL(string: todosEndpoint) else {
            print("Error: Cannot create URL")
            return
        }
        
        let todoURLRequest = URLRequest(url: todoURL)
        //todoURLRequest.httpMethod = "GET"
        //Default HTTP Method is GET
        let task = session.dataTask(with: todoURLRequest) { (data, response, error) in
            
            guard  error == nil else {
                print("Error calling GET")
                return
            }
            
            guard let responseData = data else {
                print("Error retrieving Data")
                return
            }
            
            do {
                 let recievedData  = try JSONSerialization.jsonObject(with: responseData, options: [])
                    //print("Could not get JSON from responseData as dictionary")
                 
                print("The data recieved is \(recievedData)")
                
            } catch {
                print("Error: cannot create JSON from todo")
                return
            }
        }
        task.resume() 
 
    }
    
    
    func POSTUrlRequest()  {
        let todosEndpoint : String = "https://jsonplaceholder.typicode.com/todos"
        guard let todoURL = URL(string: todosEndpoint) else {
            print("Error: Cannot Create URL")
            return
        }
        var todosURLRequest = URLRequest (url: todoURL)
        todosURLRequest.httpMethod = "POST"
        
        
        let newTodo : [String : Any] = ["title": "My First todo", "completed": false, "userId": 1]
        
        let jsonTodo: Data
        do {
            jsonTodo = try JSONSerialization.data(withJSONObject: newTodo, options: [])
            todosURLRequest.httpBody = jsonTodo
        } catch {
            print("Error: cannot create JSON from todo")
            return
        }
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: todosURLRequest) { (data, response, error) in
            
            guard error == nil else {
                print("error calling POST on /todos/1")
                print(error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                guard let recievedTodo = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String : Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                    
                }
                print("The todo is: " + recievedTodo.description)
                guard let todoID = recievedTodo["id"] as? Int else {
                    print("Could not get todoID as int from JSON")
                    return
                }
                print("The ID is: \(todoID)")
                
            } catch {
                print("error parsing response from POST on /todos")
                return
                
            }
            
        }
        task.resume()
        
    }
    
    
}

