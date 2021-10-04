import UIKit

extension ViewControllerDetail{
    func setupNavigation(){
        //ナビゲーションバーの定義
        updateBarButtonItem = UIBarButtonItem(title: "キャンセル" , style: .done, target: self,
                                                     action: #selector(cancelBarButtonTapped(_:)))
        self.navigationItem.leftBarButtonItems = [updateBarButtonItem]
        
        updateBarButtonItem = UIBarButtonItem(title: "更新", style: .done, target: self,
                                                    action: #selector(updateBarButtonTapped(_:)))
        updateBarButtonItem.isEnabled = false
        self.navigationItem.rightBarButtonItems = [updateBarButtonItem]
    }
    //キャンセルボタン
    @objc func cancelBarButtonTapped(_: UIButton){
        if !self.isModified(){
            print("変更なし")
            //前画面に戻る by Navigation Controller
            self.navigationController?.popViewController(animated: true)
            return
        }
        let alert = UIAlertController(title: "",
                                      message: "変更を破棄してもよろしいですか",
                                      preferredStyle:  UIAlertController.Style.alert)
        let keeptAction = UIAlertAction(title: "編集を続ける", style: UIAlertAction.Style.default,
        handler:{(action) -> Void in
        })
        let cancelAction = UIAlertAction(title: "変更を破棄する", style: UIAlertAction.Style.destructive ,
        handler:{(action) -> Void in
            //前画面に戻る
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(cancelAction)
        alert.addAction(keeptAction)
        self.present(alert, animated: true, completion: nil)
    }
    //レコード更新
    @objc private func updateBarButtonTapped(_: UIButton){
        if self.isModified(){
            //変更あり
            var member = Members.Record()
            if let text = name.text{
                member.name = text
            }
            if let text = postalCode.text{
                member.postalCode = text
            }
            member.address = address.text
            member.telephoneList = telephoneList
            member.mailList = mailList
            members.list[memberIndex]  = member
        }
        updateBarButtonItem.isEnabled = false
    }
    //変更チェック
    func isModified()->Bool{
        //テーブルビューのデータソースの更新
        self.tableUpdateData()
        //チェック
        if name.text != members.list[memberIndex].name{
            return true
        }
        if postalCode.text != members.list[memberIndex].postalCode {
            return true
        }
        if address.text != members.list[memberIndex].address {
            return true
        }
        
        if members.list[memberIndex].telephoneList.count != telephoneList.count {
            return true
        }else{
            for i in 0 ..< telephoneList.count{
                let indexPath = IndexPath(row: i, section: 0)
                if let cell = teleTableView.cellForRow(at: indexPath) as? UATableViewCell,
                   let text = cell.field.text{
                    if members.list[memberIndex].telephoneList[i] != text{
                        return true
                    }
                }
            }
        }
        if members.list[memberIndex].mailList.count != mailList.count {
            return true
        }else{
            for i in 0 ..< mailList.count{
                let indexPath = IndexPath(row: i, section: 0)
                if let cell = mailTableView.cellForRow(at: indexPath) as? UATableViewCell,
                   let text = cell.field.text{
                    if members.list[memberIndex].mailList[i] != text{
                        return true
                    }
                }
            }
        }
        return false
    }
    //テキストビュー（住所）のテキストに変更があった（UITextViewDelegate）
    func textViewDidChange(_ textView: UITextView) {
        if isModified(){
             updateBarButtonItem.isEnabled = true
        }else{
             updateBarButtonItem.isEnabled = false
        }
    }
    //テキストフィールドに文字が入力された
    @objc func checkChange(_ textField: UITextField){
        //新規入力用ガイダンス（Phone, Email）の削除
        if textField.tag == fieldOfTableCellTag{
            if let cls = addedClousure{
                cls()
                addedClousure = nil
            }
        }
        if isModified(){
             updateBarButtonItem.isEnabled = true
        }else{
             updateBarButtonItem.isEnabled = false
        }
    }
}

