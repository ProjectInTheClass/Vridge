//
//  WorkToDo.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/11/12.
//

import Foundation


/*
 
 ###### EditProfile cell pre-selected 완료!!
 ###### 현재 rejoining user 적용 완료 -> test needed.
 
 
 
 상황별 로그인 정리.
 
 홈, 혹은 마이페이지에서 Bulletin을 통해 로그인을 하는 경우 -> 유저네임, 타입, 사진을 정하는 페이지를 모달 .fullScreen으로 올려줌.
 그 외 맨 첫 로그인 페이지, 혹은 마이페이지의 로그인을 눌러서 로그인 하는 경우 -> 유저네임, 타입, 사진 정하는 페이지로 푸쉬로 이동함.
 
 이 두 상황을 위해 user Login API에 각각 bulletin: Bool? = false를 넣어주고,
 Bulletin을 통해 로그인 한다 => true 값 전달,
 아니라면 파라미터를 생략하여 false 값을 전달.
 
 if bulletin == false => if문을 사용하여 프로필 세팅 뷰를 모달로 올려줄지 푸쉬를 할지 결정 가능.
 

 ex user rejoining API에도 똑같이 적용을 해야함 ==> 유저네임이 있는지 없는지로 구분을 해야할 듯?
 
 
 
 
 // 앱을 열었을 시 == > HomeView Will appear 시에 유저네임이 없거나 타입이 없다? -> Edit profile에서 설정을 안하고 끈 것이기 때문에
    EditProfileViewController를 .full 화면으로 모달을 띄워서 모든 정보를 기입하도록 유도해야만 한다!!
 
 
 
 2020. 12. 29..
 
 애플로그인은 차후로 미루고, 일단 이메일 로그인으로 가는걸로 해보즈아...
 
 --ing...
 
 2020. 12. 31..
 
 비밀번호 찾기 버튼이 왜 안눌리는지 모르겠음...
 
 --done
 
 2021. 1. 2..
 
 이제 이메일&비밀번호 로그인 활성화 시킴...
 세부 사항 조율이 필요함 e.g: 이미 사용중인 메일주소입니다. 등의 알림 레이블 만들기.
 && create user API 추가 시키기. 굿.
 
 --done
 
 2021. 1. 4..
 
 // if 유저네임이 없을 때 = SelectTypeViewController로 push.
 
 --done
 
 
 2021. 1. 5..
 
 이제 로그인 & 회원가입 페이지 UI와 기능 구현 완료한 듯!
 오늘 안에 Bletin board에서 화면 넘김을 구현해보자!
 
 
 2021. 1. 17..
 
 둘러보기에서 글쓰기 버튼 누를 때 애플로그인 뜨는 버그 없애고
 회원가입에서 비밀번호 입력시 Strong 어쩌고 뜨는거 없애기.
 
 
 2021. 3. 24..
 
 2.0 버전 준비
  1) 메뉴 이름, 가격, 평점(?)
  2) ...
 */
