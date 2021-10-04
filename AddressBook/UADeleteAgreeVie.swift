import UIKit
//セルの削除確認ビュー
class UADeleteAgreeView: UIView {
    override func draw(_ rect: CGRect) {
        let font = UIFont.systemFont(ofSize: 20)
        let aString = NSAttributedString(string: "Delete",
                                         attributes: [.font:font,
                                                      .foregroundColor : UIColor.white])
        let x = rect.size.width / 2 - aString.size().width / 2
        let y = rect.size.height / 2 - aString.size().height / 2
        aString.draw(at: CGPoint(x: x, y: y))
    }
}
