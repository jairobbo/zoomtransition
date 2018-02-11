//
//  DetailTableViewController.swift
//  Zoomtransition
//
//  Created by Jairo Bambang Oetomo on 04-02-18.
//  Copyright © 2018 Jairo Bambang Oetomo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: post!.imageFileName)
        titleLabel.text = post?.titleText
        titleLabel.textColor = post?.titleColor
        bodyLabel.text = post?.bodyText
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
    }
    
}
