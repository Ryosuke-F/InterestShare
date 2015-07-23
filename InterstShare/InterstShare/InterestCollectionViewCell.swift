//
//  InterestCollectionViewCell.swift
//  InterstShare
//
//  Created by Ryosuke Fukuda on 7/18/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit

class InterestCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Public API
    var interest: Interest! {
        didSet {
            updateUI()
        }
    }
    
    //MARK: - Private
    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    
    private func updateUI() {
        
        interestTitleLabel?.text! = interest.title
        featuredImage?.image! = interest.featuredImage
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
        
    }
}
