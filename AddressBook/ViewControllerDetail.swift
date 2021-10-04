import UIKit
//グローバル変数
let teleTableViewTag: Int = 1   //電話番号テーブル
let mailTableViewTag: Int = 2   //メールアドレステーブル

let fieldOfItemTag: Int = 100
let fieldOfTableCellTag: Int = 200


//クラス定義
class ViewControllerDetail: UIViewController,
    UITextFieldDelegate, UITextViewDelegate,
    UITableViewDataSource, UITableViewDelegate,
    UATableViewCellDelegate
{
    let members = Members.sharedInstance    //名簿・シングルトンクラス
    var memberIndex: Int = 0                //対象レコードインデックス
    //var member: Members.Record!            //対象レコード
    var telephoneList = [String]()
    var mailList = [String]()
    
    var cancelBarButtonItem: UIBarButtonItem!
    var updateBarButtonItem: UIBarButtonItem!
    
    var addedClousure: (()-> Void)? = nil   //クロージャ宣言
    
    let scrollView = UIScrollView()         //スクロールビュー
    let scrollcontent = UIView()            //スクロールビューのコンテントビュー
    //項目フィールド
    let name = UITextField()            //名前
    let postalCode = UITextField()      //郵便番号
    let address = UITextView()          //住所
    let teleHeader = UILabel()          //電話番号テーブル見出し
    let teleTableView = UITableView()   //電話番号テーブル
    let mailHeader = UILabel()          //メールアドレステーブル見出し
    let mailTableView = UITableView()   //メールアドレステーブル
    let confirmView = UAConfirmView()   //テーブルの行の削除確認時、応答を受け付けるビュー
    
    var selectedYpos: CGFloat = 0           //テキストフィールドまたはテキストビューのYポジション
    var selectedFieldHeight: CGFloat = 0    //テキストフィールドまたはテキストビュー高さ
    var savedOffsetY: CGFloat = 0           //テキストフィールドまたはテキストビューのYポジション退避
    //制約の定義
    var constraints = [NSLayoutConstraint]()
    var constraintHight1 = [NSLayoutConstraint]()
    var constraintHight2 = [NSLayoutConstraint]()
    
    //ビューロード時
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.displayGrid()     //for test 格子の表示
        
        self.setupNavigation()
        name.addTarget(self, action: #selector(self.checkChange(_:)), for: UIControl.Event.editingChanged)
        postalCode.addTarget(self, action: #selector(self.checkChange(_:)), for: UIControl.Event.editingChanged)

        //名簿レコード
        //member = members.list[memberIndex]
        //キーボードが開いたときの通知を監視
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        //スクロールビューの中のコンテントビュー
        scrollcontent.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width,
                                               height: self.view.frame.height * 1.5)
        scrollcontent.backgroundColor = UIColor.white
        //スクロールビュー
        scrollView.backgroundColor = UIColor.clear
        //名前の設定
        name.backgroundColor = UIColor.white
        name.delegate = self
        name.text = members.list[memberIndex].name
        name.tag = fieldOfItemTag
        //郵便番号の設定
        postalCode.backgroundColor = UIColor.white
        postalCode.delegate = self
        postalCode.text = members.list[memberIndex].postalCode
        postalCode.tag = fieldOfItemTag
        //住所の設定
        address.backgroundColor = UIColor.white
        address.delegate = self
        address.text = members.list[memberIndex].address
        address.font = UIFont.systemFont(ofSize: 17)
        //電話番号
        telephoneList = members.list[memberIndex].telephoneList
        //メールアドレス
        mailList = members.list[memberIndex].mailList
        //テキストビュー（住所）を入力するキーボードを閉じるボタン
        let addrToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                              width: UIScreen.main.bounds.width, height: 30))
        let addrUpdateBtn = UIBarButtonItem(barButtonSystemItem: .done,
                                            target: self,
                                            action: #selector(addressUpdate(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        addrToolbar.items = [spacer, addrUpdateBtn]
        address.inputAccessoryView = addrToolbar
        //電話番号テーブル
        teleHeader.backgroundColor = UIColor.lightGray
        teleHeader.text = " 電話番号"
        teleTableView.backgroundColor = UIColor.clear
        teleTableView.allowsSelection = false
        teleTableView.tag = teleTableViewTag
        teleTableView.dataSource = self
        teleTableView.delegate = self
        teleTableView.register(UATableViewCell.self, forCellReuseIdentifier: "myCell")
        //メールアドレステーブル
        mailHeader.backgroundColor = UIColor.lightGray
        mailHeader.text = " メールアドレス"
        mailTableView.backgroundColor = UIColor.clear
        mailTableView.allowsSelection = false
        mailTableView.tag = mailTableViewTag
        mailTableView.dataSource = self
        mailTableView.delegate = self
        mailTableView.register(UATableViewCell.self, forCellReuseIdentifier: "myCell")
        //各項目のビューへの追加
        scrollcontent.addSubview(name)
        scrollcontent.addSubview(postalCode)
        scrollcontent.addSubview(address)
        scrollcontent.addSubview(teleHeader)
        scrollcontent.addSubview(teleTableView)
        scrollcontent.addSubview(mailHeader)
        scrollcontent.addSubview(mailTableView)
        scrollView.addSubview(scrollcontent)
        self.view.addSubview(scrollView)
        scrollView.contentSize = scrollcontent.bounds.size
        scrollcontent.addSubview(confirmView)
        //Auto Layout制約の設定
        self.setup()
        self.setUpTelephone()
        self.setUpMail()
    }
    //キーボードが開く（action）
    //キーボードが入力フィールドを隠す場合、フィールドが見えるところまでビューを上方にスクロールする
    @objc func keyboardWillShow(_ notification : Notification?) -> Void {
        if let info = notification?.userInfo {
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            //キーボードのframeを取得
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                //入力フィールドのY点とキーボードの表示位置の比較
                if selectedYpos + selectedFieldHeight > kbFrame.origin.y{
                    //スクロール値の計算
                    let moving = (selectedYpos - kbFrame.origin.y)  //差分
                               + selectedFieldHeight
                               + scrollView.contentOffset.y         
                               + 2
                    //スクロールビューのスクロール
                    scrollView.setContentOffset(CGPoint(x:0, y: moving),animated: false)
                }
            }
        }
    }
    //テキストビュー（住所）入力用のキーボードを閉じるボタン（action）
    @objc private func addressUpdate( _: UIButton){
        address.endEditing(true)
        //これを契機にキーボードが閉じる
    }
    //テーブルビューのデータソース＆デリゲート
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == teleTableViewTag{
            return telephoneList.count
        }else{
            return mailList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCell") as? UATableViewCell {
            //カスタムセルオブジェクトの取得
            cell.tag = tableView.tag    //電話番号 or メールアドレス
            cell.index = indexPath.row  //行インデックス
            cell.delegate = self        //UATableViewCellDelegate
            cell.field.delegate = self  //UITextFieldDelegate
            cell.field.addTarget(self, action: #selector(self.checkChange(_:)),
                                 for: UIControl.Event.editingChanged)
            if tableView.tag == teleTableViewTag{
                cell.field.text = telephoneList[indexPath.row]
                if indexPath.row == telephoneList.count-1{
                    cell.kind = 1   //追加・最終行
                }else{
                    cell.kind = 0   //既存
                }
            }else{
                cell.field.text = mailList[indexPath.row]
                if indexPath.row == mailList.count-1{
                    cell.kind = 1   //追加・最終行
                }else{
                    cell.kind = 0   //既存
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    //テーブルビューセルの追加（UATableViewCellDelegate）
    func addCell(tag: Int){
        self.tableUpdateData()
        if tag == teleTableViewTag{
            //最後の入力フィールド
            let i = telephoneList.count-1
            telephoneList[i] = "Phone"
            //追加フィールド
            telephoneList.append("")
            teleTableView.reloadData()
            //最後の入力フィールドの先頭にカーソルを持ってくる
            let indexPath = IndexPath(row: i, section: 0)
            let cell = teleTableView.cellForRow(at: indexPath) as? UATableViewCell
            cell?.field.becomeFirstResponder()
            if let newPosition = cell?.field.beginningOfDocument{
                cell?.field.selectedTextRange = cell?.field.textRange(from: newPosition, to: newPosition)
                addedClousure = {cell?.field.text = ""}
            }
            //レイアウト再構成・テーブルビューの高さが変わるため
            NSLayoutConstraint.deactivate(constraintHight1)
            self.setUpTelephone()
        }else{
            //最後の入力フィールド
            let i = mailList.count-1
            mailList[i] = "Email"
            //追加フィールド
            mailList.append("")
            mailTableView.reloadData()
            //最後の入力フィールドの先頭にカーソルを持ってくる
            let indexPath = IndexPath(row: i, section: 0)
            let cell = mailTableView.cellForRow(at: indexPath) as? UATableViewCell
            cell?.field.becomeFirstResponder()
            if let newPosition = cell?.field.beginningOfDocument{
                cell?.field.selectedTextRange = cell?.field.textRange(from: newPosition, to: newPosition)
                addedClousure = {cell?.field.text = ""}
            }
            //レイアウトの再構成・・テーブルビューの高さが変わるため
            NSLayoutConstraint.deactivate(constraintHight2)
            self.setUpMail()
        }
    }
    //テーブルビューセルの削除の準備（UATableViewCellDelegate）
    func deletePrepare(_ sender: UATableViewCell) {
        let tag = sender.tag
        let index = sender.index
        confirmView.frame = scrollcontent.frame  //削除の応答を受け付けるビュー
        //クロージャの実装
        confirmView.clousure = {(point: CGPoint) in
            //削除合意ビューの位置とサイズを求める
            let deleteViewPoint = sender.convert(sender.deleteAgree.frame.origin,
                                                 to: self.scrollcontent)
            let rect = CGRect(origin: deleteViewPoint, size: sender.deleteAgree.frame.size)
            if rect.contains(point){
                //削除合意ビューをタッチされていたらセルの削除を実行する
                self.deleteCell(tag: tag, index: index)
                //削除されるセルに対してこれが必要だが釈然としない
                //でもこれをしないと、削除後に繰り上がったセルに削除確認のレイアウトが引き継がれてしまう。
                sender.resetLayout()
            }else{
                sender.resetLayout()
            }
            self.confirmView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        }
    }
    //テーブルビューセルの削除
    func deleteCell(tag: Int, index: Int){
        self.tableUpdateData()
        if tag == teleTableViewTag{
            telephoneList.remove(at: index)
            teleTableView.reloadData()
            NSLayoutConstraint.deactivate(constraintHight1)
            self.setUpTelephone()
        }else{
            mailList.remove(at: index)
            mailTableView.reloadData()
            NSLayoutConstraint.deactivate(constraintHight2)
            self.setUpMail()
        }
    }
    //テキストフィールドの編集開始（UITextFieldDelegate）
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        //スクロールビューの現在オフセットY点を保存
        savedOffsetY = scrollView.contentOffset.y
        //self.viewを基準とした編集開始時のテキストフィールドのY点を取得
        if textField.tag == fieldOfItemTag{
            //スクロールビューの上のテキストフィールドのY点
            selectedYpos = textField.frame.origin.y + scrollView.frame.origin.y - scrollView.contentOffset.y
            selectedFieldHeight = textField.frame.height
        }else if textField.tag == fieldOfTableCellTag{
            //スクロールビューの上のテーブルビューの中のテキストフィールドのY点
            if let cell = textField.superview as? UATableViewCell{
                if cell.tag == teleTableViewTag{
                    selectedYpos = cell.frame.origin.y + teleTableView.frame.origin.y + scrollView.frame.origin.y
                                - scrollView.contentOffset.y
                }else{
                    selectedYpos = cell.frame.origin.y + mailTableView.frame.origin.y + scrollView.frame.origin.y
                                - scrollView.contentOffset.y
                }
                selectedFieldHeight = textField.frame.height
            }
        }
        return true
    }
    //テキストフィールドの編集終了（UITextFieldDelegate）
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //ファーストレスポンダーの解放 -> キーボードが閉じる
        textField.resignFirstResponder()
        scrollView.contentOffset.y = savedOffsetY //スクロール位置を戻す
        return true
    }

    //テキストビューの編集開始（UITextViewDelegate）
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool{
        //スクロールビューの現在オフセットY点を保存
        savedOffsetY = scrollView.contentOffset.y
        //self.viewを基準とした編集開始時のテキストフィールドのY点を取得
        selectedYpos = textView.frame.origin.y + scrollView.frame.origin.y - scrollView.contentOffset.y
        selectedFieldHeight = textView.frame.height
        return true
    }
    //テキストビューの編集終了（UITextViewDelegate）
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        //スクロール位置を戻す
        scrollView.contentOffset.y = savedOffsetY
        return true
    }

    //電話番号またはメールアドレスを更新する
    func tableUpdateData(){
        for i in 0 ..< telephoneList.count{
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = teleTableView.cellForRow(at: indexPath) as? UATableViewCell,
               let text = cell.field.text{
                telephoneList[i] = text
            }
        }
        for i in 0 ..< mailList.count{
            let indexPath = IndexPath(row: i, section: 0)
            if let cell = mailTableView.cellForRow(at: indexPath) as? UATableViewCell,
               let text = cell.field.text{
                mailList[i] = text
            }
        }
    }
    /*
    //テキストフィールドに文字が入力された（UITextFieldDelegate）
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        //新規入力用ガイダンス（Phone, Email）の削除
        if textField.tag == fieldOfTableCellTag{
            if let cls = addedClousure{
                cls()
                addedClousure = nil
            }
        }
        return true
    }
    */
}

