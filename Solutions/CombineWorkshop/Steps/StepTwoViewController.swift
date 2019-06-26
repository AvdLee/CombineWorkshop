//
//  StepTwoViewController.swift
//  CombineWorkshop
//
//  Created by Antoine van der Lee on 16/06/2019.
//  Copyright © 2019 SwiftLee. All rights reserved.
//

import UIKit
import Combine

/*
 STEP 2:
 Link the nextButton.isEnabled to the three switches isOn values.
 When all switches are set to `true`, the nextButton should be enabled as well.
 */

final class StepTwoViewController: UIViewController {

    @IBOutlet private weak var nextButton: UIButton!
    private var switchesSubscriber: AnyCancellable?
    
    @Published private var switchOneValue: Bool = false
    @Published private var switchTwoValue: Bool = false
    @Published private var switchThreeValue: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        switchesSubscriber = Publishers.CombineLatest3($switchOneValue, $switchTwoValue, $switchThreeValue, transform: { $0 && $1 && $2 })
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: nextButton)
    }

    @IBAction func switchedOne(_ sender: UISwitch) {
        switchOneValue = sender.isOn
    }

    @IBAction func switchedTwo(_ sender: UISwitch) {
        switchTwoValue = sender.isOn
    }

    @IBAction func switchedThree(_ sender: UISwitch) {
        switchThreeValue = sender.isOn
    }
}

extension StepTwoViewController: WorkshopStepContaining {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        didFinish(.step2)
    }
}
