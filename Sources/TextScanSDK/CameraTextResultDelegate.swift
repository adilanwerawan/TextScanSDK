//
//  File.swift
//  
//
//  Created by MacBook on 31/03/2022.
//

import Foundation

public protocol CameraTextResultDelegate {
    func getResultFromCamera(_ request: VNRequest?, _ error: Error?)
}
