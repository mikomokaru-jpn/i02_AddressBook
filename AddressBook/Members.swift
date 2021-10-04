import UIKit
//名簿
class Members: NSObject {
    //構造体
    struct Record {
        var id: Int = 0
        var name: String = ""
        var postalCode: String = ""
        var address: String = ""
        var telephoneList:[String] = [String]()
        var mailList:[String] = [String]()
    }
    //名簿リスト・シングルトンクラス
    var list = [Record]()
    static let sharedInstance: Members = {
        return Members.init()
    }()
    //既存レコードの更新
    func update(_ record: Record){
        for i in 0 ..< list.count{
            if list[i].id == record.id{
                list[i].name = record.name
                list[i].postalCode = record.postalCode
                list[i].address = record.address
                list[i].telephoneList = record.telephoneList
                list[i].mailList = record.mailList
                return
            }
        }
    }
    //イニシャライザ
    private override init() {
        var record: Record
        record = Record( id:1,
                            name: "足立区役所",
                            postalCode: "120-8510",
                            address: "東京都足立区中央本町\n１丁目１７−１",
                            telephoneList: ["0338805111", "09012345678", "0120123456", ""],
                            mailList: ["voice@city.adachi.tokyo.jp", "mikomokaru@sakura.ne.jp", ""]
                            )
        list.append(record)
        record = Record( id:2,
                            name: "荒川区役所",
                            postalCode: "116-8501",
                            address: "東京都荒川区荒川２丁目２−３",
                            telephoneList: ["0338023111", ""],
                            mailList: [""])
        list.append(record)
        record = Record( id:3,
                            name: "板橋区役所",
                            postalCode: "173-8501",
                            address: "東京都板橋区板橋２丁目６６−１",
                            telephoneList: ["0339641111", ""],
                            mailList: [""])
        list.append(record)
        record = Record( id:4,
                            name: "江戸川区役所",
                            postalCode: "132-8501",
                            address: "東京都江戸川区中央一丁目4番1号",
                            telephoneList: ["0336521151", ""],
                            mailList: [""])
        list.append(record)
        record = Record( id:5,
                            name: "太田区役所",
                            postalCode: "144-8621",
                            address: "東京都大田区蒲田五丁目13番14号",
                            telephoneList: ["0357441111", ""],
                            mailList: [""])
        list.append(record)
    }
}
