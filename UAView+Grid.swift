
import UIKit

extension UIView{
    
    func displayGrid(){
        let w = self.frame.width
        let h = self.frame.height
        let layer = CAShapeLayer()
        let path = UIBezierPath.init()
        for i in stride(from: 0, to: w, by: 10){
            path.move(to: CGPoint(x: i, y: 0))
            path.addLine(to: CGPoint(x: i, y: h))
        }
        for j in stride(from: 0, to: h, by: 10){
            path.move(to: CGPoint(x: 0, y: j))
            path.addLine(to: CGPoint(x: w, y: j))
        }
        layer.path = path.cgPath
        layer.strokeColor = UIColor.gray.cgColor
        layer.lineWidth = 0.2
        self.layer.addSublayer(layer)
    
        
        let layer2 = CAShapeLayer()
        let path2 = UIBezierPath.init()
        for i in stride(from: 0, to: w, by: 50){
            path2.move(to: CGPoint(x: i, y: 0))
            path2.addLine(to: CGPoint(x: i, y: h))
        }
        for j in stride(from: 0, to: h, by: 50){
            path2.move(to: CGPoint(x: 0, y: j))
            path2.addLine(to: CGPoint(x: w, y: j))
        }
        layer2.path = path2.cgPath
        layer2.strokeColor = UIColor.gray.cgColor
        layer2.lineWidth = 1.0
        self.layer.addSublayer(layer2)
    }
}
