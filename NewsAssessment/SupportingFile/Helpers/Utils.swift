//
//  Utils.swift
//  NewsAssessment
//
//  Created by Mohamed Ikhram Khan on 04/06/2022.
//

import Foundation
import UIKit

private var utils: Utils? = nil

class Utils: NSObject {
    
    class func singleInstanceUtils() -> Utils {
        if utils == nil {
            utils = Utils()
        }
        return utils ?? Utils()
    }

    // MARK: - Check Internet Availability
    class func isInternetAvailable() -> Bool {
        return ServiceManager.shared.isInternetAvailable
    }

}
