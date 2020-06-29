//
//  APPExtension.swift
//  APPSwift
//
//  Created by 峰 on 2020/6/29.
//  Copyright © 2020 north_feng. All rights reserved.
//

import Foundation

extension String {
    
    //MARK: ************************* 截取字符串 *************************
    ///字符串截取
    func string_subscript(range:ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start...end])
    }
    
}
