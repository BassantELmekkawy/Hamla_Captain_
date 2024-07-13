//
//  OnboardingManager.swift
//  Hamla_iOS_Captain
//
//  Created by Bassant on 21/04/2024.
//

import Foundation

class OnboardingManager {
    static func isFirstLaunch() -> Bool {
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
        return isFirstLaunch
    }

    static func setFirstLaunch() {
        UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
    }
}
