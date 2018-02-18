//
//  CameraView.swift
//  BareBone
//
//  Created by Kyle McGrew on 2/14/18.
//  Copyright © 2018 Kyle McGrew. All rights reserved.
//

import Foundation

protocol CameraView: NSObjectProtocol, Presentable {
    var onCameraComplete: (() -> Void)? { get set }
}
