import UIKit

extension ViewControllerDetail{

    //レイアウト定義 --------------------------------------------------------------------------------
    func setup(){
        //制約の設定の準備
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        postalCode.translatesAutoresizingMaskIntoConstraints = false
        address.translatesAutoresizingMaskIntoConstraints = false
        teleHeader.translatesAutoresizingMaskIntoConstraints = false
        teleTableView.translatesAutoresizingMaskIntoConstraints = false
        mailHeader.translatesAutoresizingMaskIntoConstraints = false
        mailTableView.translatesAutoresizingMaskIntoConstraints = false
        //制約の設定
        constraints = [
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            
            name.topAnchor.constraint(equalTo: scrollcontent.topAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: scrollcontent.leadingAnchor, constant: 10),
            name.widthAnchor.constraint(equalToConstant: scrollcontent.bounds.width - 20),
            name.heightAnchor.constraint(equalToConstant: 40),
                        
            postalCode.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10),
            postalCode.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            postalCode.widthAnchor.constraint(equalToConstant: 150),
            postalCode.heightAnchor.constraint(equalToConstant: 40),
            
            address.topAnchor.constraint(equalTo: postalCode.bottomAnchor, constant: 10),
            address.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            address.widthAnchor.constraint(equalToConstant: scrollcontent.bounds.width - 20),
            address.heightAnchor.constraint(equalToConstant: 90),
            
            teleHeader.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 10),
            teleHeader.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            teleHeader.widthAnchor.constraint(equalToConstant: scrollcontent.bounds.width),
            teleHeader.heightAnchor.constraint(equalToConstant: 40),

            mailHeader.topAnchor.constraint(equalTo: teleTableView.bottomAnchor, constant: 10),
            mailHeader.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            mailHeader.widthAnchor.constraint(equalToConstant: scrollcontent.bounds.width),
            mailHeader.heightAnchor.constraint(equalToConstant: 40),
                        
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    //制約の設定・電話番号テーブル
    func setUpTelephone(){
        constraintHight1 = [
             teleTableView.topAnchor.constraint(equalTo: teleHeader.bottomAnchor, constant: 5),
             teleTableView.leadingAnchor.constraint(equalTo: name.leadingAnchor),
             teleTableView.widthAnchor.constraint(equalToConstant: scrollcontent.bounds.width - 20),
             teleTableView.heightAnchor.constraint(equalToConstant:CGFloat(
                telephoneList.count) * 40),
            ]
        
        NSLayoutConstraint.activate(constraintHight1)
    }
    func setUpMail(){
        constraintHight2 = [
            mailTableView.topAnchor.constraint(equalTo: mailHeader.bottomAnchor, constant: 5),
            mailTableView.leadingAnchor.constraint(equalTo: name.leadingAnchor),
            mailTableView.widthAnchor.constraint(equalToConstant: scrollcontent.bounds.width - 20),
            mailTableView.heightAnchor.constraint(equalToConstant: CGFloat(
                mailList.count) * 40),
        ]
        NSLayoutConstraint.activate(constraintHight2)
    }

}
