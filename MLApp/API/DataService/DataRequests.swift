//
//  DataRequests.swift
//  MLApp
//
//  Created by Kyle McGrew on 2/16/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

public enum DataRequests: Request {
   
    
    case submitData(data: [String:Any], user: UserInfo)
    
    public var method: HttpMethod {
        return .post
    }
    
    public var headers: [String : Any]? {
        switch self {
        case .submitData(_, let info):
            return ["Authorization" : "\(info.token)"]
        }
    }
    
    public var path: String {
        switch self {
        case .submitData(_,_):
            return "data/submit"
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .submitData(let data, _):
            return .body(data)
        }
    }
}
