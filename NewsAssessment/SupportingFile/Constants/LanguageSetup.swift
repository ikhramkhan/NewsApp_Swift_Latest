////
////  LanguageSetup.swift
////  NewsAssessment
////
////  Created by Mohamed Ikhram Khan on 05/06/2022.
////
//
//import Foundation
//import UIKit
//
//class LanguageDetails: UIView {
//
//    var language: String!
//    var bundle: Bundle!
//    let LANGUAGE_KEY: String = "LANGUAGE_KEY"
//
//    override init() {
//        super.init()
//
//        // user preferred languages. this is the default app language(device language - first launch app language)!
//        language = Bundle.main.preferredLocalizations[0]
//
//        // the language stored in UserDefaults have the priority over the device language.
//        language = Common.valueForKey(key: LANGUAGE_KEY, default_value: language as AnyObject) as! String
//
//        // init the bundle object that contains the localization files based on language
//        bundle = Bundle(path: Bundle.main.path(forResource: language == "ar" ? language : "Base", ofType: "lproj")!)
//
//        // bars direction
//        if isArabic() {
//            UIView.appearance().semanticContentAttribute = .forceRightToLeft
//        } else {
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//        }
//    }
//
//    // check if current language is arabic
//    func isArabic () -> Bool {
//        return language == "ar"
//    }
//
//    // returns app language direction.
//    func rtl () -> Bool {
//        return Locale.characterDirection(forLanguage: language) == Locale.LanguageDirection.rightToLeft
//    }
//
//    // switches language. if its ar change it to en and vise-versa
//    func changeLanguage()
//    {
//        var changeTo: String
//        // check current language to switch to the other.
//        if language == "ar" {
//            changeTo = "en"
//        } else {
//            changeTo = "ar"
//        }
//
//        // change language
//        changeLanguageTo(lang: changeTo)
//
//        Log.info("Language changed to: \(language)")
//    }
//
//    // change language to a specfic one.
//    func changeLanguageTo(lang: String) {
//        language = lang
//
//        // set language to user defaults
//        Common.setValue(value: language as AnyObject, key: LANGUAGE_KEY)
//
//        // set prefered languages for the app.
//        UserDefaults.standard.set([lang], forKey: "AppleLanguages")
//        UserDefaults.standard.synchronize()
//
//        // re-set the bundle object based on the new langauge
//        bundle = Bundle(path: Bundle.main.path(forResource: language == "ar" ? language : "Base", ofType: "lproj")!)
//
//        // app direction
//        if isArabic() {
//            UIView.appearance().semanticContentAttribute = .forceRightToLeft
//        } else {
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//        }
//
//        Log.info("Language changed to: \(language)")
//    }
//
//    // get local string
//    func getLocale() -> NSLocale {
//        if rtl() {
//            return NSLocale(localeIdentifier: "ar_JO")
//        } else {
//            return NSLocale(localeIdentifier: "en_US")
//        }
//    }
//
//    // get localized string based on app langauge.
//    func LocalString(key: String) -> String {
//        let localizedString: String? = NSLocalizedString(key, bundle: bundle, value: key, comment: "")
////        Log.ver("Localized string '\(localizedString ?? "not found")' for key '\(key)'")
//        return localizedString ?? key
//    }
//
//    // get localized string for specific language
//    func LocalString(key: String, lan: String) -> String {
//        let bundl:Bundle! = Bundle(path: Bundle.main.path(forResource: lan == "ar" ? lan : "Base", ofType: "lproj")!)
//        return NSLocalizedString(key, bundle: bundl, value: key, comment: "")
//    }
//}
