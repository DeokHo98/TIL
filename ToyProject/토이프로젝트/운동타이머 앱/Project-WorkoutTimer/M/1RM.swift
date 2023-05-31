//
//  1RM.swift
//  Project-WorkoutTimer
//
//  Created by 정덕호 on 2022/02/06.
//

import Foundation
import SwiftUI

struct OneRM {
     func calculator(weight: Double, reps: Double) -> Double {
        let result = weight * (36.0 / (37.0 - reps))
        return result
    }
    
    //전체값 X 퍼센트 ÷ 100
     func percent(rm: Int, num: Double) -> Double {
        switch rm {
        case 0:
            return num
        case 1:
            return num * 95.0 / 100.0
        case 2:
            return num * 93.0 / 100.0
        case 3:
            return num * 90.0 / 100.0
        case 4:
            return num * 87.0 / 100.0
        case 5:
            return num * 85.0 / 100.0
        case 6:
            return num * 83.0 / 100.0
        case 7:
            return num * 80.0 / 100.0
        case 8:
            return num * 77.0 / 100.0
        case 9:
            return num * 75.0 / 100.0
        case 10:
            return num * 73.0 / 100.0
        case 11:
            return num * 70.0 / 100.0
        default:
            return 0
        }
    }
}
