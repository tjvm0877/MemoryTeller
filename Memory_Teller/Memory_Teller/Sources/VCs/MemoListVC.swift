//
//  MemoListVC.swift
//  Memory_Teller
//
//  Created by Hyun on 2022/02/28.
//

import UIKit

class MemoListVC: UITableViewController {

    // 앱 델리게이트 객체의 참조 정보를 읽어온다.
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // 사이드 바 오픈 기능을 위임할 델리게이트
    var delegate: RevealVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let btnSideBar = UIBarButtonItem(
            image: UIImage(named: "sidemenu.png"),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(moveSide)
            )
        
        self.navigationItem.leftBarButtonItem = btnSideBar
        
        // 화면 끝에서 다른 쪽으로 패닝하는 제스처 정의
        let dragLeft = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(moveSide)
        )
        dragLeft.edges = UIRectEdge.left // 시작 모서리는 왼쪽
        self.view.addGestureRecognizer(dragLeft) // 뷰의 제스처 객체를 등록
        
        // 화면 스와이프 제스처 정의 (사이드 메뉴 닫기용)
        let dragRight = UISwipeGestureRecognizer(
            target: self,
            action: #selector(moveSide))
        dragRight.direction = .left // 왼쪽 방향
        self.view.addGestureRecognizer(dragRight) // 뷰에 제스처 객체를 등록
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    @objc func moveSide(_ sender: Any) {
        if sender is UIScreenEdgePanGestureRecognizer {
            self.delegate?.openSideBar(nil)
        } else if sender is UISwipeGestureRecognizer {
            self.delegate?.closeSideBar(nil)
        } else if sender is UIBarButtonItem {
            if self.delegate?.isSideBarShowing == false {
                self.delegate?.openSideBar(nil)
            } else {
                self.delegate?.closeSideBar(nil)
            }
        }
    }
    
    // 셀의 갯수 결정
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.appDelegate.memoList.count
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // memolist 배열 데이터에서 주어진 행에 맞는 데이터를 꺼낸다.
        let row = self.appDelegate.memoList[indexPath.row]
        
        // 이미지 속성이 비어 있을 경우 "memoCell", 아니면 "memoCellWithImage"
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"
        
        // 재사용 큐로부터 프로토타입 셀의 인스턴스를 전달받는다.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
        
        // memoCell의 내용을 구성한다.
        cell.subject?.text = row.title
        cell.contents?.text = row.contents
        cell.img?.image = row.image
        
        // Date 타입의 날짜를 yyyy-MM-dd HH:mm:ss 포멧에 맞게 변경
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdate?.text = formatter.string(from: row.regDate!)
        
        // cell 객체를 리턴
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.appDelegate.memoList[indexPath.row]
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? MemoReadVC else {
            return
        }
        
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
