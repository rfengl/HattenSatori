//
//  ImageDrawer.swift
//  HattenSatori
//
//  Created by Re Foong Lim on 05/04/2018.
//  Copyright © 2018 Silvertech Solution. All rights reserved.
//

import Foundation
import UIKit

class ImageDrawer: UIImageView {
    var delegate: ImageDrawerDelegate?
    var points = [CGPoint]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }
    
    var isPause = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            if isPause {
                if let layers = self.layer.sublayers {
                    for item in layers {
                        if let item = item as? CAShapeLayer {
                            if item.path?.contains(position) == true {
                                print("Hit shapeLayer")
                            }
                        }
                    }
                }
            }else {
                points.append(getActualPoint(point: position, imageView: self))
                
                delegate?.pointAdded(sender: self, index: points.count - 1)
                
                self.drawPolygon()
            }
        }
    }
    
    func drawPolygon() {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let shape = CAShapeLayer()
        self.layer.addSublayer(shape)
        shape.opacity = 0.5
        shape.lineWidth = 2
        shape.lineJoin = kCALineJoinMiter
        shape.strokeColor = UIColor(hue: 0.786, saturation: 0.79, brightness: 0.53, alpha: 1.0).cgColor
        shape.fillColor = UIColor(hue: 0.786, saturation: 0.15, brightness: 0.89, alpha: 1.0).cgColor
        
        let path = UIBezierPath()
        for point in points {
            let actualPoint = getResizePoint(point: CGPoint(x: point.x, y: point.y), imageView: self)
            if points.index(of: point) == 0 {
                path.move(to: actualPoint)
            } else {
                path.addLine(to: actualPoint)
            }
        }
        
        path.close()
        shape.path = path.cgPath
    }
    
    func undo() {
        points.remove(at: points.count - 1)
        drawPolygon()
    }
    
    func clear() {
        points = []
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    func setPath(path: String?) {
        points = []
        if path.hasValue {
            for text in path!.components(separatedBy: ";") {
                let xy = text.components(separatedBy: ":")
                if let x: Double = Convert(xy[0]).to() {
                    if let y: Double = Convert(xy[1]).to() {
                        points.append(CGPoint(x: x, y: y))
                    }
                }
            }
        }
        self.drawPolygon()
    }
    
    func getPath() -> String {
        let arr = NSMutableArray()
        
        for point in points {
            arr.add("\(point.x):\(point.y)")
        }
        
        return arr.componentsJoined(by: ";")
    }
    
    func getResizePoint(point: CGPoint, imageView: UIImageView) -> CGPoint {
        var imageRelativeOrigin = CGPoint.zero
        var imageRelativeSize = imageView.frame.size;
        
        let imageSize = imageView.image!.size
        if imageView.contentMode == .scaleAspectFit {
            if imageSize.width/imageSize.height > imageView.frame.size.width/imageView.frame.size.height {
                imageRelativeSize = CGSize(width: imageView.frame.size.width, height: imageView.frame.size.width*(imageSize.height/imageSize.width))
                let verticalOffset = (imageView.frame.size.height-imageRelativeSize.height)*0.5
                imageRelativeOrigin = CGPoint(x: 0, y: verticalOffset);
            }
            else
            {
                imageRelativeSize = CGSize(width: imageView.frame.size.height*(imageSize.width/imageSize.height), height: imageView.frame.size.height);
                let horizontalOffset = (imageView.frame.size.width-imageRelativeSize.width)*0.5
                imageRelativeOrigin = CGPoint(x:horizontalOffset, y:0);
            }
        }
        else
        {
            // TODO: add other content modes
        }
        
        let actualImagePoint = CGPoint(x: point.x*(imageRelativeSize.width/imageSize.width), y: point.y*(imageRelativeSize.height/imageSize.height));
        let relativeImagePoint = CGPoint(x:actualImagePoint.x+imageRelativeOrigin.x, y:actualImagePoint.y+imageRelativeOrigin.y)
        return relativeImagePoint
    }
    
    func getActualPoint(point: CGPoint, imageView: UIImageView) -> CGPoint
    {
        // find the relative image position on the view
        var imageRelativeOrigin = CGPoint.zero
        var imageRelativeSize = imageView.frame.size;
        
        let imageSize = imageView.image!.size
        if imageView.contentMode == .scaleAspectFit {
            // we expect one of the origin coordinates has a positive offset
            // compare the ratio
            if imageSize.width/imageSize.height > imageView.frame.size.width/imageView.frame.size.height {
                // in this case the image width is the same as the view width but height is smaller
                imageRelativeSize = CGSize(width: imageView.frame.size.width, height: imageView.frame.size.width*(imageSize.height/imageSize.width))
                let verticalOffset = (imageView.frame.size.height-imageRelativeSize.height)*0.5 // this is the visible image offset
                imageRelativeOrigin = CGPoint(x: 0, y: verticalOffset);
            }
            else
            {
                // in this case the image height is the same as the view height but widh is smaller
                imageRelativeSize = CGSize(width: imageView.frame.size.height*(imageSize.width/imageSize.height), height: imageView.frame.size.height);
                let horizontalOffset = (imageView.frame.size.width-imageRelativeSize.width)*0.5 // this is the visible image offset
                imageRelativeOrigin = CGPoint(x:horizontalOffset, y:0);
            }
        }
        else
        {
            // TODO: add other content modes
        }
        
        let relativeImagePoint = CGPoint(x:point.x-imageRelativeOrigin.x, y:point.y-imageRelativeOrigin.y); // note these can now be off the image bounds
        // resize to image coordinate system
        
        let actualImagePoint = CGPoint(x: round(relativeImagePoint.x*(imageSize.width/imageRelativeSize.width)), y: round(relativeImagePoint.y*(imageSize.height/imageRelativeSize.height)))
        return actualImagePoint
    }
}

protocol ImageDrawerDelegate {
    func pointAdded(sender: Any, index: Int)
}
