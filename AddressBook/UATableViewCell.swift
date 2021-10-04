
import UIKit
//プロトコル宣言
protocol UATableViewCellDelegate: class {
    func addCell(tag: Int)
    func deletePrepare(_ sender: UATableViewCell)
}
class UATableViewCell: UITableViewCell {
    var selectedCell = false
    var button = UIButton()         //ボタン
    var field = UITextField()       //テキストフィールド
    var deleteAgree = UADeleteAgreeView()   //削除合意ビュー
    var index: Int = 0
    weak var delegate: UATableViewCellDelegate? = nil
    var kind: Int = 0{             //既存(0) or 追加(1)
        didSet{
            if kind == 0 {
                //既存
                button.setImage(UIImage(systemName: "minus.square"), for: .normal)
                field.isEnabled = true
            }else{
                //追加
                button.setImage(UIImage(systemName: "plus.square"), for: .normal)
                field.isEnabled = false
            }
        }
    }
    var constraints1 = [NSLayoutConstraint]()
    var constraints2 = [NSLayoutConstraint]()
    //イニシャライザ
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //ボタンの作成
        button.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action:  #selector(buttonTapped(_:)), for: .touchUpInside)
        self.addSubview(button)
        //テキストフィールドの作成
        field.font = UIFont.systemFont(ofSize: 18)
        field.textAlignment = .left
        field.backgroundColor = UIColor.white
        field.tag = fieldOfTableCellTag
        self.addSubview(field)
        //削除ビューの作成
        deleteAgree.backgroundColor = UIColor.red
        self.addSubview(deleteAgree)
        //制約の設定の準備
        button.translatesAutoresizingMaskIntoConstraints = false
        field.translatesAutoresizingMaskIntoConstraints = false
        deleteAgree.translatesAutoresizingMaskIntoConstraints = false
        //制約の設定
        constraints1 = [
            //
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            field.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 10),
            field.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            field.topAnchor.constraint(equalTo: self.topAnchor),
            field.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            deleteAgree.leadingAnchor.constraint(equalTo: field.trailingAnchor),
            deleteAgree.widthAnchor.constraint(equalToConstant: 0),
            deleteAgree.topAnchor.constraint(equalTo: self.topAnchor),
            deleteAgree.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        constraints2 = [
            //削除確認パターン・セルの左スライド
            button.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -100),
            button.widthAnchor.constraint(equalToConstant: 40),
            button.topAnchor.constraint(equalTo: self.topAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor),

            field.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 10),
            field.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -100),
            field.topAnchor.constraint(equalTo: self.topAnchor),
            field.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            deleteAgree.leadingAnchor.constraint(equalTo: field.trailingAnchor),
            deleteAgree.widthAnchor.constraint(equalToConstant: 100),
            deleteAgree.topAnchor.constraint(equalTo: self.topAnchor),
            deleteAgree.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints1)   //基本パターン
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //テーブルビューのボタンをタップした
    @objc private func buttonTapped(_ btn: UIButton){
        if kind == 0{ //既存
            selectedCell = true
            //レイアウトの変更・削除確認ビューの表示
            NSLayoutConstraint.deactivate(constraints1)
            NSLayoutConstraint.activate(constraints2)
            delegate?.deletePrepare(self)
            deleteAgree.setNeedsDisplay()
        }else{ //追加
            delegate?.addCell(tag: tag)
        }
    }
    //レイアウトを元に戻す
    func resetLayout(){
        if selectedCell{
            NSLayoutConstraint.deactivate(constraints2)
            NSLayoutConstraint.activate(constraints1)
            selectedCell = false
        }
    }

    
}
