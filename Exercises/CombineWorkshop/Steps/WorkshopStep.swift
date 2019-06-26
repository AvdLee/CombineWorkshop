//
//  WorkshopStep.swift
//  CombineWorkshop
//
//  Created by Antoine van der Lee on 18/06/2019.
//  Copyright © 2019 SwiftLee. All rights reserved.
//

import Foundation
import UIKit

enum WorkshopStep: Int, CaseIterable {
    case step1, step2, step3, step4, step5

    var viewController: UIViewController.Type? {
        switch self {
        case .step1:
            return StepOneViewController.self
        case .step2:
            return StepTwoViewController.self
        case .step3:
            return StepThreeViewController.self
        case .step4:
            return StepFourViewController.self
        default:
            return nil
        }
    }
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
            set(newValue.rawValue, forKey: "current_workshop_step")
        }
    }
}
