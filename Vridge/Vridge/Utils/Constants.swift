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

// type
let REF_VEGAN = DB_REF.child("vegan")
let REF_LACTO = DB_REF.child("lacto")
let REF_OVO = DB_REF.child("ovo")
let REF_LACTO_OVO = DB_REF.child("lacto-ovo")
let REF_PESCO = DB_REF.child("pesco")
let REF_POLLO = DB_REF.child("pollo")
let REF_FRUITARIAN = DB_REF.child("fruitarian")
let REF_FLEXITARIAN = DB_REF.child("flexitarian")


// Strings
let reportMessage = "신고가 정상적으로 반영되었습니다\n신속히 처리하도록 하겠습니다"
let noTitle = ""
