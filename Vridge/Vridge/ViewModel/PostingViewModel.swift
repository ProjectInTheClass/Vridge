//
//  PostingViewModel.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/14.
//

import UIKit

enum PostingConfiguration {
    case post
    case amend(Post)
}

struct PostingViewModel {
    let captionLabel: String
    let timestamp: Date
    let images: [String]
    
    init(config: PostingConfiguration) {
        switch config {
        case .post:
            captionLabel = ""
            timestamp = Date()
            images = []
        case .amend(let post):
            captionLabel = post.caption
            timestamp = post.timestamp
            images = post.images
        }
    }
}
