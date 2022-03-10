//
//  SideBarVC.swift
//  Memory_Teller
//
//  Created by Hyun on 2022/03/01.
//

import UIKit

class SideBarVC: UITableViewController {
    let nameLbl = UILabel()
    let emailLbl = UILabel()
    let profileImage = UIImageView()
    
    // 메뉴 제목 배열
    let titles = [
        "새글 작성하기",
        "친구 새글",
        "달력으로 보기",
        "공지사항",
        "통계",
        "계정 관리"
    ]
    
    //  메뉴 아이콘 배열
    let icons = [
        UIImage(named: "icon01.png"),
        UIImage(named: "icon02.png"),
        UIImage(named: "icon03.png"),
        UIImage(named: "icon04.png"),
        UIImage(named: "icon05.png"),
        UIImage(named: "icon06.png")
    ]
    
    override func viewDidLoad() {
        // 테이블 뷰의 헤더 역할을 할 뷰를 정의한다.
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        headerView.backgroundColor = .brown
        
        // 이름 레이블 속성 정의, 헤더뷰에 추가
        self.nameLbl.frame = CGRect(x: 70, y: 15, width: 100, height: 30) // 위치, 크기를 정의
        self.nameLbl.text = "Hello?" // 기본 텍스트
        self.nameLbl.textColor = .white // 텍스트 색상
        self.nameLbl.font = UIFont.boldSystemFont(ofSize: 15) // 폰트 사이즈
        self.emailLbl.backgroundColor = .clear // 배경 색상
        headerView.addSubview(self.nameLbl) // 헤더뷰에 추가
        
        // 이메일 레이블의 속성을 정의, 헤더 뷰에 추가
        self.emailLbl.frame = CGRect(x: 70, y: 30, width: 100, height: 30) // 위치와 크기를 정의
        self.emailLbl.text = "tjvm12@gmail.com" // 기본 텍스트
        self.emailLbl.textColor = .white // 텍스트 색상
        self.emailLbl.font = UIFont.systemFont(ofSize: 11) // 폰트 사이즈
        self.emailLbl.backgroundColor = .clear // 배경 색상
        headerView.addSubview(self.emailLbl) // 헤더 뷰에 추가
        
        // 기본 이미지를 구현
        let defaultProfile = UIImage(named: "account.jpg")
        self.profileImage.image = defaultProfile // 이미지 등록
        self.profileImage.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        view.addSubview(self.profileImage) // 헤더 뷰에 추가
        
        // 추가) 프로필 이미지 둥글게 만들기
        self.profileImage.layer.cornerRadius = (self.profileImage.frame.width / 2) // 반원 형태로 라운딩
        self.profileImage.layer.borderWidth = 0 // 테두리 두계 0으로
        self.profileImage.layer.masksToBounds = true // 마스크 효과
        view.addSubview(self.profileImage)
        
        // 테이블 뷰의 헤더 뷰로 지정한다.
        self.tableView.tableHeaderView = headerView
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 재사용 큐로부터 테이블 셀을 꺼냄
        let id = "menucell" // 재사용 큐에 등록할 식별자
        let cell = tableView.dequeueReusableCell(withIdentifier: id) ?? UITableViewCell(style: .default, reuseIdentifier: id)
        
        // 타이틀과 이미지를 대입
        cell.textLabel?.text = self.titles[indexPath.row]
        cell.imageView?.image = self.icons[indexPath.row]
        
        // 폰트 설정
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return cell
    }
}
