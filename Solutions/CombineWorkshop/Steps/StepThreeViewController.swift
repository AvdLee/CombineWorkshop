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
    private var usernameTextFieldColorSubscriber: AnyCancellable?
    private var passwordTextFieldColorSubscriber: AnyCancellable?
    private var passwordAgainTextFieldColorSubscriber: AnyCancellable?

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordConfirmTextField: UITextField!

    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordAgain: String = ""

    var validatedPassword: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest($password, $passwordAgain)
            .map { password, passwordAgain -> Bool in
                guard password == passwordAgain, password.count >= 8 else { return false }
                guard !self.weakPasswords.contains(password) else { return false }
                return true
            }
            .eraseToAnyPublisher()
    }

    var validatedUsername: AnyPublisher<Bool, Never> {
        return $username
            .flatMap { username in
                return Future { promise in
                    self.usernameAvailable(username) { available in
                        promise(.success(available ? username : nil))
                    }
                }
            }
            .map({ username -> Bool in
                guard let username = username else { return false }
                return username.count >= 4
            })
            .eraseToAnyPublisher()
    }

    var validatedCredentials: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(validatedUsername, validatedPassword)
            .map { username, password -> Bool in
                return username && password
            }
            .eraseToAnyPublisher()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        validationSubscriber = validatedCredentials
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: nextButton)

        usernameTextFieldColorSubscriber = validatedUsername.assignValidationColor(to: usernameTextField)
        passwordTextFieldColorSubscriber = validatedPassword.assignValidationColor(to: passwordTextField)
        passwordAgainTextFieldColorSubscriber = validatedPassword.assignValidationColor(to: passwordConfirmTextField)

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

extension AnyPublisher where Output == Bool, Failure == Never {
    func assignValidationColor(to textField: UITextField) -> AnyCancellable {
        return map({ (value) -> UIColor in
                return value ? .green : .red
            })
            .map { $0.withAlphaComponent(0.2) }
            .assign(to: \.backgroundColor, on: textField)
    }
}
