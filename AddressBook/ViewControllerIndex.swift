import UIKit
// 住所録一覧
class ViewControllerIndex: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let members = Members.sharedInstance    //名簿元データ
    let memberTableView = UITableView()     //名簿一覧テーブルビュー
    //ビューロード時
    override func viewDidLoad() {
        super.viewDidLoad()
        //名簿一覧テーブルビューの初期設定
        memberTableView.backgroundColor = UIColor.gray
        memberTableView.dataSource = self
        memberTableView.delegate = self
        //セルのカスタムクラスの登録
        memberTableView.register(UITableViewCell.self, forCellReuseIdentifier: "myCell")
        self.view.addSubview(memberTableView)
        self.setupLayout()
    }
    //テーブルビュー　データソース＆デリゲート
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50   //行の高さ
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.list.count   //レコード数
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")  {
            //セルの編集・名前
            let label = UILabel.init()
            label.text = members.list[indexPath.row].name
            label.font = UIFont.systemFont(ofSize: 20)
            cell.contentView.addSubview(label)
            //制約の設定
            label.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                label.topAnchor.constraint(equalTo: cell.topAnchor),
                label.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
                label.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 20),
                label.trailingAnchor.constraint(equalTo: cell.trailingAnchor),
            ]
            NSLayoutConstraint.activate(constraints)
            return cell
        }
        return UITableViewCell()
    }
    //行をタップする
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //表示画面へ移動・引数にテーブルの添え字を渡す
        performSegue(withIdentifier: "toDetail", sender: indexPath.row)
        //prepareが呼ばれる
    }
    //画面移動の前処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vcDetail = segue.destination as! ViewControllerDetail
        vcDetail.memberIndex = sender as! Int   //遷移先のビューコントローラのプロパティ
    }
    //レイアウト定義 --------------------------------------------------------------------------------
    private func setupLayout(){
        //制約の設定の準備
        memberTableView.translatesAutoresizingMaskIntoConstraints = false
        //制約の設定
        let constraints = [
            memberTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            memberTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            memberTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            memberTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
