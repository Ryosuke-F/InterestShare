//
//  interest2TableViewCell.swift
//  InterstShare
//
//  Created by Ryosuke Fukuda on 7/19/15.
//  Copyright (c) 2015 Ryochan. All rights reserved.
//

import UIKit

protocol Interest2TableViewCellDelegate {
    
    func commentButtonClicked2(post: Post)
}

class interest2TableViewCell: UITableViewCell {
    
    //MARK: - Public API
    var post: Post! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: Interest2TableViewCellDelegate!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var likeButton: DesignableButton!
    @IBOutlet weak var commentButton: DesignableButton!
    
    private var currentUserDidLike: Bool = false
    
    
    private func updateUI() {
        
        userProfileImageView.image = post.user.profileImage
        userNameLabel.text = post.user.fullName
        createdAtLabel.text = post.createdAt
        postImageView?.image = post.postImage
        postTextLabel.text = post.postText
        
        //rounded post image view, user profile image
        postImageView?.layer.cornerRadius = 5.0
        postImageView?.layer.masksToBounds = true
        
        userProfileImageView?.layer.cornerRadius = userProfileImageView.bounds.width/2
        userProfileImageView?.layer.masksToBounds = true
        
        likeButton.setTitle("📷 \(post.numberOfLikes) Likes", forState: .Normal)
        
        configureButtonAppearance()
    }
    
    private func configureButtonAppearance() {
        
        likeButton.cornerRadius = 3.0
        likeButton.borderWidth = 2.0
        likeButton.borderColor = UIColor.lightGrayColor()
        
        commentButton.cornerRadius = 3.0
        commentButton.borderWidth = 2.0
        commentButton.borderColor = UIColor.lightGrayColor()
        
    }
    
    @IBAction func likeButtonClicked(sender: DesignableButton) {
        
        post.userDidLike = !post.userDidLike
        if post.userDidLike {
            post.numberOfLikes++
        } else {
            post.numberOfLikes--
        }
        
        self.likeButton.setTitle("📷 \(post.numberOfLikes) Likes", forState: .Normal)
        
        currentUserDidLike = post.userDidLike
        changeLikeButtonColor()
        
        // animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
        
        
    }
    
    private func changeLikeButtonColor() {
        
        if currentUserDidLike {
            
            likeButton.borderColor = UIColor.redColor()
            likeButton.tintColor = UIColor.redColor()
        } else {
            
            likeButton.borderColor = UIColor.lightGrayColor()
            likeButton.tintColor = UIColor.lightGrayColor()
        }
    }

    @IBAction func commentButtonClicked(sender: DesignableButton) {
        
        // animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
        
        delegate?.commentButtonClicked2(post)
    }
    
}
