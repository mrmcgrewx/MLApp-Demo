//
//  SubmitDataOperation.swift
//  MLApp
//
//  Created by Kyle McGrew on 2/16/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

class SubmitDataOperation: Operation {
    var userInfo: UserInfo
    var data: [String:Any]
    
    init(data: [String:Any], userInfo: UserInfo) {
        self.data = data
        self.userInfo = userInfo
    }
    
    var request: Request {
        return DataRequests.submitData(data: data, user: userInfo)
    }
    
    func execute(in dispatcher: Dispatcher, completion: @escaping (Result<[String:Any]>) -> Void) {
        do {
            try dispatcher.execute(request) { response in
                switch response {
                case .data(let data):
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
                        completion(Result.data(json))
                    }
                    catch {
                        completion(.error(error))
                    }
                case .error(_, let error):
                    completion(Result.error(error))
                }
            }
        }
        catch {
            completion(Result.error(error))
        }
    }
}
