//
//  CommentTableViewCell.swift
//  InterstShare
//
//  Created by Ryosuke Fukuda on 7/21/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    
    // MARK: - Public API
    var comment: Comment! {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var likeButton: DesignableButton!
    
    // MARK: - Private
    
    private var currentUserDidLike: Bool = false
    
    private func updateUI()
    {
        
        userNameLabel?.text = comment.user.fullName
        createdAtLabel?.text = comment.createdAt
        commentTextLabel.text = comment.commentText

        likeButton.setTitle("👻 \(comment.numberOfLikes) Likes", forState: .Normal)
        
//        configureButtonAppearance()
    }
    
    private func configureButtonAppearance()
    {
        likeButton.cornerRadius = 3.0
        likeButton.borderWidth = 2.0
        likeButton.borderColor = UIColor.lightGrayColor()
        
    }
    
    @IBAction func likeButtonClicked(sender: DesignableButton)
    {
        comment.userDidLike = !comment.userDidLike
        if comment.userDidLike {
            comment.numberOfLikes++
        } else {
            comment.numberOfLikes--
        }
        likeButton.setTitle("👻 \(comment.numberOfLikes) Likes", forState: .Normal)
        
        currentUserDidLike = comment.userDidLike
        
        changeLikeButtonColor()
        
        // animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
    }
    
    private func changeLikeButtonColor()
    {
        if currentUserDidLike {
            likeButton.borderColor = UIColor.redColor()
            likeButton.tintColor = UIColor.redColor()
        } else {
            likeButton.borderColor = UIColor.lightGrayColor()
            likeButton.tintColor = UIColor.lightGrayColor()
        }
        
    }
    
    
}
