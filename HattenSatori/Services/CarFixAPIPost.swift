//
//  CarFixAPIPost.swift
//  CarfixIphone
//
//  Created by Re Foong Lim on 19/11/2016.
//  Copyright © 2016 Oneworks Sdn Bhd. All rights reserved.
//

import Foundation
import UIKit

class CarFixAPIPost: BaseAPIPost
{
    override func getWebBaseURL() -> String {
        return "\(super.getWebBaseURL())/Core/Mobile"
    }
    
    private func getUID() -> String {
        let profile = HattenInfo().profile
        if HattenInfo.password.hasValue && profile.loginID.hasValue {
            let uid: String = "\(HattenInfo.password!);\(profile.loginID!)"
            return uid
        } else {
            return ""
        }
    }
    
    override func post<T : BaseAPIResponse>(method: String, parameters: [String : Any]?, onSuccess: @escaping (T?) -> Void) {
        super.post(method: method, parameters: parameters, onBuildRequest: { req in
            var request = req
            request.setValue(self.getUID(), forHTTPHeaderField: "UID")
            return request
        }, onSuccess: onSuccess)
    }
    
    func checkUser(onSuccess: @escaping (CheckUserResponse?) -> Void) {
        self.post(method: "CheckUser", parameters: nil, onSuccess: onSuccess)
    }
    
    func checkVersion(ver: String, onSuccess: @escaping (CheckVersionResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(ver, forKey: "ver")
        self.post(method: "CheckVersion", parameters: parameters, onSuccess: onSuccess)
    }
    
    func uploadImages(folder: String, key: String?, images: [String: UIImage], onSuccess: @escaping (UploadResponse?) -> Void) {
        var parameters = [String: Any]()
        parameters.updateValue(folder, forKey: "folder")
        if let val = key {
            parameters.updateValue(val, forKey: "key")
        }
        postFile(method: "UploadImages", parameters: parameters, images: images, onSuccess: onSuccess)
    }
    
    func postFile<T>(method: String, parameters: [String : Any]?, images: [String : UIImage], onSuccess: @escaping (T?) -> Void) where T : BaseAPIResponse {
        postFile(method: method, parameters: parameters, images: images, onBuildRequest: { req in
            var request = req
            request.setValue(self.getUID(), forHTTPHeaderField: "UID")
            return request
        }, onSuccess: onSuccess)
    }
}
