//
//  Constants.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/05.
//

import Foundation

import Firebase


let STORAGE_REF = Storage.storage().reference()
let STORAGE_POST_IMAGES = STORAGE_REF.child("post_images")

let DB_REF = Database.database().reference()
let REF_POSTS = DB_REF.child("posts")
