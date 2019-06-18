//
//  StepThreeViewController.swift
//  CombineWorkshop
//
//  Created by Antoine van der Lee on 16/06/2019.
//  Copyright © 2019 SwiftLee. All rights reserved.
//

import UIKit
import Combine

final class StepThreeViewController: UIViewController {

    @IBOutlet private weak var nextButton: UIButton!
    private var switchesSubscriber: AnyCancellable?

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordConfirmTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

//        switchesSubscriber = Publishers.CombineLatest3($switchOneValue, $switchTwoValue, $switchThreeValue, transform: { $0 && $1 && $2 })
//            .receive(on: RunLoop.main)
//            .assign(to: \.isEnabled, on: nextButton)
    }

}

extension StepThreeViewController: WorkshopStepContaining {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        didFinish(.step3)
    }
}
