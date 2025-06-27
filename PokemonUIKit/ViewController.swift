//
//  ViewController.swift
//  PokemonUIKit
//
//  Created by Eduardo Cordeiro da Camara on 27/06/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let label = UILabel()
        label.text = "Pokemon App"
        label.textColor = .green
        self.view = label
        self.view.backgroundColor = .systemBackground
    }


}

