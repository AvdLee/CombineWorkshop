//
//  WorkshopStep.swift
//  CombineWorkshop
//
//  Created by Antoine van der Lee on 18/06/2019.
//  Copyright © 2019 SwiftLee. All rights reserved.
//

import Foundation

enum WorkshopStep: Int {
    case step1, step2, step3, step4, step5
}

protocol WorkshopStepContaining {
    func didFinish(_ step: WorkshopStep)
}

extension WorkshopStepContaining {
    func didFinish(_ step: WorkshopStep) {
        guard let nextStep = WorkshopStep(rawValue: step.rawValue + 1) else { return }
        UserDefaults.standard.currentStep = nextStep
    }
}

extension UserDefaults {
    var currentStep: WorkshopStep {
        get {
            return WorkshopStep(rawValue: integer(forKey: "current_workshop_step"))!
        }
        set {
            set(newValue, forKey: "current_workshop_step")
        }
    }
}
