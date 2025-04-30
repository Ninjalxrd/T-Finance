//
//  RussianPhoneNumberTextField.swift
//  MoneyMind
//
//  Created by Павел on 30.04.2025.
//

import PhoneNumberKit

final class RussianPhoneNumberTextField: PhoneNumberTextField {
    override var defaultRegion: String {
        get { return "RU" }
        set {}
    }
}
