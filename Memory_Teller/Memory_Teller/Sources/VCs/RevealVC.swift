//
//  RevealVC.swift
//  Memory_Teller
//
//  Created by Hyun on 2022/03/01.
//

import UIKit

class RevealVC: UIViewController {
    var contentVC: UIViewController? // 콘텐츠를 담당할 뷰 컨트롤러
    var sideVC: UIViewController? // 사이드 바 메뉴를 담당할 뷰 컨트롤러
    
    var isSideBarShowing = false // 현재 사이드 바가 열려 있는지 여부
    
    let SLIDE_TIME = 0.3 // 사이드 바가 열리고 닫히는 시간
    let SIDEBAR_WIDTH: CGFloat = 260 // 사이드 바가 열릴 너비
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    // 초기 화면 설정
    func setupView() {
        // 프론트 컨트롤러 객체를 메인 컨트롤러를 읽어옴
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_front") as? UINavigationController {
            
            // 읽어온 컨트롤러를 클래스 전체에서 참조할 수 있도록 contentVC 속성에 저장
            self.contentVC = vc
            
            // 메인 컨트롤러의 자식으로 등록
            self.addChild(vc)
            self.view.addSubview(vc.view)
            
            // 부모 뷰 컨트롤러가 바뀌었음을 알려줌
            vc.didMove(toParent: self)
            
            // 델리게이트 변수에 참조 정보를 넣어줌
            let frontVC = vc.viewControllers[0] as? MemoListVC
            frontVC?.delegate = self
        }
    }
    // 사이드 바의 뷰 읽기
    func getSideView() {
        guard self.sideVC == nil else {
            return
        }
        
        // 사이드 바 컨트롤러 객체를 읽어옴
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "sw_rear") else {
            return
        }
        
        // 다른 메소드에서도 참조할 수 있도록 sideVC 속성에 저장
        self.sideVC = vc
        
        // 읽어온 컨트롤러 객체를 컨테이너 뷰 컨트롤러에 연결
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        // 부모 뷰 컨트롤러가 바뀌었음을 알려줌
        vc.didMove(toParent: self)
        
        // contentVC를 제일 위로 올린다.
        self.view.bringSubviewToFront((self.contentVC?.view)!)
    }
    
    // 콘텐츠 뷰에 그림자 효과
    func setShadowEffect(shadow: Bool, offset: CGFloat) {
        if (shadow == true) { // 그림자 효과 설정
            self.contentVC?.view.layer.masksToBounds = false
            self.contentVC?.view.layer.cornerRadius = 10 // 그림자 모서리 둥글기
            self.contentVC?.view.layer.shadowOpacity = 0.8 // 그림자 투명도
            self.contentVC?.view.layer.shadowColor = UIColor.black.cgColor // 그림자 색깔
            self.contentVC?.view.layer.shadowOffset = CGSize(width: offset, height: offset) // 그림자 크기
        } else {
            self.contentVC?.view.layer.cornerRadius = 0.0;
            self.contentVC?.view.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }
    
    // 사이드 바 열기
    func openSideBar(_ complete: (() -> Void)?) {
        // 앞에서 정의한 메소드들을 실행
        self.getSideView() // 사이드 바 뷰를 읽어옴
        self.setShadowEffect(shadow: true, offset: -2) // 그림자 효과
        
        // 애니메이션 옵션
        let options = UIView.AnimationOptions([.curveEaseInOut, .beginFromCurrentState])
        
        // 애니메이션 실행
        UIView.animate(
            withDuration: TimeInterval(self.SLIDE_TIME),
            delay: TimeInterval(0),
            options: options,
            animations: {
                self.contentVC?.view.frame = CGRect(x: self.SIDEBAR_WIDTH, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            },
            completion: {
                if $0 == true {
                    self.isSideBarShowing = true // 열린 상태로 플래그를 변경
                    complete?()
                }
            }
        )
    }
    
    // 사이드 바 닫기
    func closeSideBar(_ complete: (() -> Void)?) {
        // 애니메이션 옵션
        let options = UIView.AnimationOptions([.curveEaseInOut, .beginFromCurrentState])
        
        // 애니메이션 실행
        UIView.animate(
            withDuration: TimeInterval(self.SLIDE_TIME),
            delay: TimeInterval(0),
            options: options,
            animations: {
                // 옆으로 밀려난 콘텐츠 뷰의 위치를 제자리로
                self.contentVC?.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            },
            completion: {
                if $0 == true {
                    // 사이드 바 뷰를 제거
                    self.sideVC?.view.removeFromSuperview()
                    self.sideVC = nil
                    // 닫힘 상태로 플래그 변경
                    self.isSideBarShowing = false
                    // 그림자 효과를 제거
                    self.setShadowEffect(shadow: false, offset: 0)
                    // 인자값으로 입력받은 완료 함수를 실행
                    complete?()
                }
            }
        )
    }
}
