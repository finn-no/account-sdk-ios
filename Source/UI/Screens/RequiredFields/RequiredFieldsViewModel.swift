//
// Copyright 2011 - 2020 Schibsted Products & Technology AS.
// Licensed under the terms of the MIT license. See LICENSE in the project root.
//

import Foundation
import UIKit

private extension NSMutableString {
    func replace(string target: String, with value: String) -> NSRange? {
        let range = self.range(of: target)
        if range.location != NSNotFound {
            replaceCharacters(in: range, with: value)
            return NSRange(location: range.location, length: value.count)
        }
        return nil
    }
}

///
class RequiredFieldsViewModel {
    let supportedRequiredFields: [SupportedRequiredField]
    let localizationBundle: Bundle
    let locale: Locale

    init(requiredFields: [RequiredField], localizationBundle: Bundle, locale: Locale) {
        supportedRequiredFields = SupportedRequiredField.from(requiredFields)
        self.localizationBundle = localizationBundle
        self.locale = locale
    }
}

extension RequiredFieldsViewModel {
    var done: String {
        return "GlobalString.done".localized(from: localizationBundle)
    }

    func titleForField(_ field: SupportedRequiredField) -> String {
        let localizedKey: String
        switch field {
        case .givenName:
            localizedKey = "RequiredField.givenName.title"
        case .familyName:
            localizedKey = "RequiredField.familyName.title"
        case .birthday:
            localizedKey = "RequiredField.birthday.title"
        }
        return localizedKey.localized(from: localizationBundle)
    }

    func requiredFieldID(at index: Int) -> String {
        return supportedRequiredFields[index].rawValue
    }

    func placeholderForField(_ field: SupportedRequiredField) -> String? {
        let localizedKey: String?
        switch field {
        case .birthday:
            localizedKey = "RequiredField.birthday.placeholder"
        case .givenName, .familyName:
            localizedKey = nil
        }
        return localizedKey?.localized(from: localizationBundle)
    }

    var proceed: String {
        return "RequiredFieldsScreenString.proceed".localized(from: localizationBundle)
    }

    var title: String {
        return "RequiredFieldsScreenString.title".localized(from: localizationBundle)
    }

    var subtext: NSAttributedString {
        let text = "RequiredFieldsScreenString.subtext".localized(from: localizationBundle)
        let link0 = "RequiredFieldsScreenString.subtext.link0".localized(from: localizationBundle)
        let link1 = "RequiredFieldsScreenString.subtext.link1".localized(from: localizationBundle)

        guard let controlYouPrivacyURL = self.controlYouPrivacyURL else {
            return NSAttributedString(string: text)
        }
        guard let dataAndYouURL = self.dataAndYouURL else {
            return NSAttributedString(string: text)
        }

        let mutableString = NSMutableString(string: text)
        guard let r1 = mutableString.replace(string: "$0", with: link0), let r2 = mutableString.replace(string: "$1", with: link1) else {
            return NSAttributedString(string: text)
        }

        let attributedString = NSMutableAttributedString(string: mutableString as String)
        attributedString.addAttribute(.link, value: controlYouPrivacyURL.absoluteString, range: r1)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: r1)

        attributedString.addAttribute(.link, value: dataAndYouURL.absoluteString, range: r2)
        attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: r2)

        return attributedString
    }

    var controlYouPrivacyURL: URL? {
        return URL(string: "https://info.privacy.schibsted.com/" + locale.gdprLanguageCode + "/S007")
    }

    var dataAndYouURL: URL? {
        return URL(string: "https://info.privacy.schibsted.com/" + locale.gdprLanguageCode + "/S012")
    }

    func string(for error: SupportedRequiredField.ValidationError) -> String {
        switch error {
        case .missing:
            return "RequiredField.error.missing".localized(from: localizationBundle)
        case .lessThanThree:
            return "RequiredField.error.lessThanThree".localized(from: localizationBundle)
        case .dateInvalid:
            return "RequiredField.error.birthdateInvalid".localized(from: localizationBundle)
        case .numberInvalid:
            return "RequiredField.error.numberInvalid".localized(from: localizationBundle)
        case .tooYoung:
            return "PasswordScreenString.ageLimit".localized(from: localizationBundle)
        }
    }
}
