//
//  고민.swift
//  Instargram-Clone
//
//  Created by 정덕호 on 2022/04/05.
//





//1. 유저를 검색하는 부분에서 나를 제외한 유저만을 검색하기위해서는 어떻게 해야할까?
/*
 서치뷰컨트롤러를 초기화할때 현재 로그인한 유저의 데이터를 넘겨주고
 그 로그인한 유저의 userName과 fullName이 일치하는지를 확인
 let usersData = user.filter {
     $0.userName != currentUser.userName && $0.fullName != currentUser.fullName
 }
 이렇게 해줘서 일치하지 않는 Model만 걸러서 테이블뷰에 뿌려줘서 해결했다.
 */
