//
//  Constants.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/05.
//

import Foundation

import Firebase

let POST_LOAD_AT_ONCE = 10

let STORAGE_REF = Storage.storage().reference()
let STORAGE_POST_IMAGES = STORAGE_REF.child("post_images")
let STORAGE_USER_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_POSTS = DB_REF.child("posts")
let REF_USER_POSTS = DB_REF.child("user-posts")
let REF_USERS = DB_REF.child("users")
let REF_USER_POINT = DB_REF.child("user-point")
let REF_USERNAMES = DB_REF.child("usernames")

let reportMessage = "신고가 정상적으로 반영되었습니다\n신속히 처리하도록 하겠습니다"
let noTitle = ""
