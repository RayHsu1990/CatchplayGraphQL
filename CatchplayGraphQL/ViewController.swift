//
//  ViewController.swift
//  CatchplayGraphQL
//
//  Created by Ray Hsu on 2022/7/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func triggered(_ sender: UIButton) {
//        let req = GetUsersRequest(queryKeys: [.id])
//        let req = GetUserInfoRequest(queryKeys: [.id, .todos(keys: [.id, .description])], id: "123")
//        let req = GetTodosRequest(queryKeys: [.id, .description, .done])
        let req = MutationTodoRequest(queryKeys: [.id, .done], id: "123", description: nil, done: true)
        
        URLSeesionRequestLoader().load(req) { result in
            print(result)
        }

    }

}

