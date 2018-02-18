//
//  DataService.swift
//  MLApp
//
//  Created by Kyle McGrew on 2/16/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

final class DataService {
    private var dispatcher: NetworkDispatcher
    
    init(with dispatcher: NetworkDispatcher) {
        self.dispatcher = dispatcher
    }
    
    func submitData(_ data: [String:Any], with userInfo: UserInfo, completion: @escaping (Result<[String:Any]>) -> Void) {
        let operation = SubmitDataOperation(data: data, userInfo: userInfo)
        operation.execute(in: dispatcher) { result in DispatchQueue.main.async { completion(result) } }
    }
}
