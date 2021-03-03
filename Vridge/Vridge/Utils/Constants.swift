//
//  Constants.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/05.
//

import Foundation

import Firebase

// MARK: - Load amount

let POST_LOAD_AT_ONCE: Int = 10

// MARK: - DB/Storage

let STORAGE_REF = Storage.storage().reference()
let STORAGE_POST_IMAGES = STORAGE_REF.child("post_images")
let STORAGE_USER_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

let DB_REF = Database.database().reference()
let REF_POSTS = DB_REF.child("posts")
let REF_USER_POSTS = DB_REF.child("user-posts")
let REF_USERS = DB_REF.child("users")
let REF_USER_POINT = DB_REF.child("user-point")
let REF_USERNAMES = DB_REF.child("usernames")
let REF_POST_REPORT = DB_REF.child("post-report")
let REF_USER_REPORT = DB_REF.child("user-report")
let REF_VERSION = DB_REF.child("version")

let REF_NOTICE = DB_REF.child("notice")


// MARK: -  Strings

let reportMessage = "알려주셔서 감사해요.\n신고가 정상적으로 반영되었어요"
let noTitle = ""
let amendTitle = "수정하기"
let deleteButtonTitle = "삭제하기"
let deleteAlertTitle = "정말 삭제할까요?"
let deleteAlertMessage = "게시글을 삭제하면 이전으로 돌아갈 수 없어요"
let reportButtonTitle = "신고하기"
let reasonToReportTitle = "신고 사유 선택"
let sexualHarassTitle = "성적 수치심 유발"
let swearTitle = "욕설/비하"
let fraudTitle = "유출/사칭/사기"
let advertiseTitle = "상업적 광고 및 판매"
let nonsenseTitle = "채식과 관련 없음"

let minimumOnePhotoMsg = "최소 한 장 이상의 사진을 올려주세요"
let noPhotoChangeMsg = "사진은 수정할 수 없어요"
let leavePageTitle = "이 페이지를 벗어나실 건가요?"
let leavePageMsg = "지금까지 작성한 내용은 저장되지 않아요"
let pleaseLoginTitle = "회원가입 후 이용해주세요"
let pleaseLoginMsg = "가입하면 더 많은 서비스를\n이용할 수 있어요"
let keepBrowsing = "계속 둘러보기"
let signUp = "회원가입하기"


// answer
let no = "아니오"
let yes = "예"
let cancel = "취소"
let confirm = "확인"


// Lottie

let loadingAnimation = "poise_logo_colors"
let uploadAnimation = "upload_post"



// Colors

let allTextColor = "color_all_text"
let userRankBoxColor = "color_ranking_rankedUserBox"
let normalButtonColor = "color_all_button_normal"
let headerBackgroundColor = "color_all_headerBg"
let viewBackgroundColor = "color_all_viewBackground"
let borderColor = "color_posting_boxBg"


// Ad

//let adMobID = "ca-app-pub-3940256099942544/2934735716" // 테스트 광고
let adMobID = "ca-app-pub-6604345149511637/7837607709"

