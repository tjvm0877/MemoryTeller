//
//  MemoFormVC.swift
//  Memory_Teller
//
//  Created by Hyun on 2022/02/28.
//

import UIKit

class MemoFormVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    var subject: String!
    
    @IBOutlet weak var contents: UITextView!
    @IBOutlet weak var preview: UIImageView!
    
    // 저장 버튼을 클릭했을 때 호출되는 메소드
    @IBAction func save(_ sender: Any) {
        // 내용을 입력하지 않았을 경우, 경고한다.
        guard self.contents.text?.isEmpty == false else {
            let alert = UIAlertController(title: nil, message: "내용을 입력해주세요!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        // MemoData 객체를 생성하고, 데이터를 담는다.
        let data = MemoData()
        
        data.title = self.subject
        data.contents = self.contents.text
        data.image = self.preview.image
        data.regDate = Date()
        
        // 앱 델리게이트 객체를 읽어온 다음, memolist 배열에 MemoData 객체를 추가한다.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memoList.append(data)
        
        // 작성폼 화면을 종료, 이전화면으로 돌아간다.
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    // 카메라 버튼을 클릭했을 때 호출되는 메소드
    @IBAction func pick(_ sender: Any) {
        // 이미지 피커 인스턴스 생성
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        // 이미지 피커 화면을 표시
        self.present(picker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contents.delegate = self
    }
    
    // 사용자가 이미지를 선택하면 자동으로 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 선택된 이미지를 미리보기에 출력
        self.preview.image = info[.editedImage] as? UIImage
        
        // 이미지 피커 컨트롤러를 닫는다.
        picker.dismiss(animated: true)
    }
    
    // 사용자가 텍스트 뷰에 뭔가를 입력하면 자동으로 호출되는 메소드
    func textViewDidChange(_ textView: UITextView) {
        // 내용의 최대 15자리 까지 읽어 subject 변수에 저장
        let contents = textView.text as NSString
        let length = ( (contents.length > 15) ? 15 : contents.length)
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        
        // 내비게이션 타이틀에 표시
        self.navigationItem.title = self.subject
    }
}

