//
//  StepThreeViewController.swift
//  CombineWorkshop
//
//  Created by Antoine van der Lee on 16/06/2019.
//  Copyright © 2019 SwiftLee. All rights reserved.
//

import UIKit
import Combine

/*
 STEP 3:
 A classic sign up form!

 Validation rules are as followed:
 - Username should not exist yet in the `registeredUsernames` array
 - Username should be 4 characters or more
 - Password should be 8 characters or more
 - Password inputs should match
 - Password should not exist in the `weakPasswords` array
 */

final class StepThreeViewController: UIViewController {

    private let registeredUsernames = ["Jan", "Paul", "Vadim", "Kamil", "Joshua", "Antoine", "Kateryna", "Sommer", "Peter", "Benedikt", "Donny", "Andrzej"]
    private let weakPasswords = ["password", "00000000", "mobiconf2019"]

    @IBOutlet private weak var nextButton: UIButton!
    private var validationSubscriber: AnyCancellable?

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordConfirmTextField: UITextField!

    var username: String = ""
    var password: String = ""
    var passwordAgain: String = ""

    var validatedPassword: AnyPublisher<String?, Never> {
        fatalError("This needs to be implemented")
        // Password and password again should match
        // Password should be 8 characters or more
        // Password should not exists in the weakPasswords array
        // Use `.eraseToAnyPublisher()` in the end
    }

    var validatedUsername: AnyPublisher<String?, Never> {
        fatalError("This needs to be implemented")
        // Username should not exist yet in the `registeredUsernames` array
        // Username should be 4 characters or more
    }

    var validatedCredentials: AnyPublisher<(String, String)?, Never> {
        fatalError("This needs to be implemented")
        // Bring the validation of password and username together
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Uncomment this and implement
//        self.validationSubscriber = self.validatedCredentials
    }

    private func usernameAvailable(_ username: String, completion: (_ available: Bool) -> Void) {
        let usernameAvailable = !registeredUsernames.contains(username)
        completion(usernameAvailable)
    }

    @IBAction func usernameChanged(_ sender: UITextField) {
        username = sender.text ?? ""
    }

    @IBAction func passwordChanged(_ sender: UITextField) {
        password = sender.text ?? ""
    }

    @IBAction func passwordAgainChanged(_ sender: UITextField) {
        passwordAgain = sender.text ?? ""
    }

}

extension StepThreeViewController: WorkshopStepContaining {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        didFinish(.step3)
    }
}
