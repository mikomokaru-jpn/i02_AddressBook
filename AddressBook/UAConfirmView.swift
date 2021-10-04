import UIKit
//テーブルセルの削除確認時、応答を受け付けるビュー
class UAConfirmView: UIView {
    //クロージャ
    var clousure: ((CGPoint)-> Void)? = nil
    //タッチ開始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //最初にタッチした点
        let location = touch.location(in: self)
        if let cls = clousure{
            //クロージャの実行・削除の応答を受け付ける
            //func deletePreper in ViewControllerDetail にて定義
            cls(location)
            clousure = nil  //クロージャの消去
        }
    }
}
