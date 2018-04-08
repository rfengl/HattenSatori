//
//  ViewController.swift
//  HattenSatori
//
//  Created by Re Foong Lim on 05/04/2018.
//  Copyright © 2018 Silvertech Solution. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CustomPickerDelegate, ImageDrawerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgPhoto: ImageDrawer!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var pointNumber: CustomPicker!
    
    @IBOutlet weak var imgDisplay: ImageDrawer!
    
    
    @IBOutlet weak var pointX: CustomDecimalField!
    @IBOutlet weak var pointY: CustomDecimalField!
    
    @IBOutlet weak var txtPath: UITextField!
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
        
        ImageManager.downloadImage(mUrl: "https://scstylecaster.files.wordpress.com/2016/12/beauty-blogger-flat-lay.png", imageView: imgPhoto)
        
        ImageManager.downloadImage(mUrl: "https://scstylecaster.files.wordpress.com/2016/12/beauty-blogger-flat-lay.png", imageView: imgDisplay)
        
        pointX.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        pointY.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        imgPhoto.delegate = self
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        applyToPoint(textField)
    }
    
    func getPickOption(_ picker: CustomPicker) -> NSArray {
        let arr = NSMutableArray()
        if self.imgPhoto.points
            .count > 0 {
            for index in 1...self.imgPhoto.points.count {
                arr.add(index)
            }
        }
        return arr
    }
    
    func pointAdded(sender: Any, index: Int) {
        selectedPointIndex = index
        let point = self.imgPhoto.points[selectedPointIndex!]
        pointX.text = "\(point.x)"
        pointY.text = "\(point.y)"
        pointNumber.text = "\(index + 1)"
        
        self.txtPath.text = self.imgPhoto.getPath()
    }
    
    var selectedPointIndex: Int?
    func didSelectRow(_ picker: CustomPicker) {
        if let index: Int = Convert(picker.text).to() {
            pointAdded(sender: picker, index: index - 1)
        }
    }
    
    @IBAction func applyToPoint(_ sender: Any) {
        if let index = selectedPointIndex {
            if let x: Double = Convert(pointX.text).to() {
                if let y: Double = Convert(pointY.text).to(){
                    self.imgPhoto.points[index] = CGPoint(x: x, y: y)
                    self.imgPhoto.drawPolygon()
                    self.txtPath.text = self.imgPhoto.getPath()
                }
            }
        }
    }
    
    @IBAction func setPath(_ sender: Any) {
        self.imgPhoto.setPath(path: txtPath.text)
        self.imgDisplay.setPath(path: txtPath.text)
    }
    
    @IBAction func pause(_ sender: Any) {
        self.imgPhoto.isPause = !self.imgPhoto.isPause
        (sender as! UIButton).setTitle(self.imgPhoto.isPause ? "Continue" : "Pause", for: .normal)
    }
    
    @IBAction func undoDraw(_ sender: Any) {
        imgPhoto.undo()
        self.txtPath.text = self.imgPhoto.getPath()
    }
    
    @IBAction func clearDraw(_ sender: Any) {
        imgPhoto.clear()
        self.txtPath.text = self.imgPhoto.getPath()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

