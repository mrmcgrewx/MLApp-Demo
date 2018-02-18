//
//  ModuleFactoryImp.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/8/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

final class ModuleFactoryImp: HomeModuleFactory, EntryModuleFactory {
    
    var networkDispatcher: NetworkDispatcher?
    
    //MARK: Home Views
    func makeHomeScreenOutput(with userinfo: UserInfo) -> HomeView {
        let controller = HomeController.controllerFromStoryboard(.home)
        controller.userInfo = userinfo
        return controller
    }
    
    func makeCameraScreenOutput(with userinfo: UserInfo) -> CameraView {
        let controller = CameraController.controllerFromStoryboard(.home)
        controller.userInfo = userinfo
        controller.dataService = DataService(with: networkDispatcher!)
        return controller
    }
    
    func makeReviewScreenOutput() -> ReviewTableView {
        let controller = ReviewTableController.controllerFromStoryboard(.home)
        return controller
    }
    
    //MARK: Login Views
    func makeLoginScreenOutput() -> LoginView {
        let controller = LoginController.controllerFromStoryboard(.login)
        controller.entryService = EntryService(with: networkDispatcher!)
        return controller
    }
}
