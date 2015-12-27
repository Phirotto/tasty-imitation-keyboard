//
//  LanguageDefinition.swift
//  TastyImitationKeyboard
//
//  Created by Simon Corston-Oliver on 7/11/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import Foundation

// The housekeeping information that defines a language:
// the name of the language, the characters required to type that language etc.
//
// Note that the language information says nothing about keyboard layout and doesn't attempt an exhaustive listing of the kbds that
// could be used to type the language. We can determine programmatically elsewhere if a kbd contains all the necessary chars.
public class LanguageDefinition {

    // The ISO 639-1 language code.
    // REVIEW What to do about languages that don't have an ISO 639-1 code?
    private let _langCode : String

    // Name of the language in English
    private let _englishName : String

    // Name of the language in that language's native script
    private let _nativeName : String

    // Chars that a keyboard must contain for you to be able to type this language
    private let _requiredChars : [String]

    // The name of the JSON keyboard definition file for the default keyboard for this language
    private let _defaultKbd : String

    init(langCode: String,
        englishName: String, nativeName: String, requiredChars: [String], defaultKbd: String)
    {
        self._langCode = langCode
        self._englishName = englishName
        self._nativeName = nativeName
        self._requiredChars = requiredChars
        self._defaultKbd = defaultKbd

    }

    var LangCode : String {
        get {
            return self._langCode
        }
    }

    var EnglishName : String {
        get {
            return self._englishName
        }
    }

    var NativeName : String {
        get {
            return self._nativeName
        }
    }

    var RequiredChars : [String] {
        get {
            return self._requiredChars
        }
    }

    var DefaultKbdName : String {
        get {
            return self._defaultKbd
        }
    }

    var DescriptiveName : String {
        get {
            return EnglishName + "/" + NativeName
        }
    }

    // Default English language definition to be used in case of an emergency
    // e.g. failing to load language definitions from the JSON language definition file.
    class private func EnglishLanguageDefinition() -> LanguageDefinition {
        return LanguageDefinition(
            langCode: "EN",
            englishName: "English",
            nativeName: "English",
            requiredChars: [
                "a", "b", "c", "d",
                "e", "f", "g", "h",
                "i", "j", "k", "l",
                "m", "n", "o", "p",
                "q", "r", "s", "t",
                "u", "v", "w", "x",
                "y", "z", "'",
                "A", "B", "C", "D",
                "E", "F", "G", "H",
                "I", "J", "K", "L",
                "M", "N", "O", "P",
                "Q", "R", "S", "T",
                "U", "V", "W", "X",
                "Y", "Z"
            ],
            defaultKbd: "EnglishQWERTY")
    }


}

// class var not yet supported so make it global
private var _Singleton: LanguageDefinitions? = nil

// Define the set of languages currently supported
public class LanguageDefinitions {
    public var definitions : [LanguageDefinition]


    class private func extractLanguageDefinitions(allDefinitions: NSDictionary) -> [LanguageDefinition]
    {
        guard let languages = allDefinitions["languages"] as? NSArray else {
            NSLog("Could not find 'pages' array in root")
            return [LanguageDefinition.EnglishLanguageDefinition()]
        }

        var definitions : [LanguageDefinition] = []

        for language in languages {

            if let languageProperties = language["language"] as? NSDictionary {

                
                if let englishName = languageProperties["englishName"] as? String,
                    let nativeName = languageProperties["nativeName"] as? String,
                    let defaultKbd = languageProperties["defaultKbd"] as? String,
                    let requiredChars = languageProperties["requiredCharacters"] as? [String],
                    let langCode = languageProperties["langCode"] as? String {

                        definitions.append(
                            LanguageDefinition(
                                langCode: langCode,
                                englishName: englishName,
                                nativeName: nativeName,
                                requiredChars: requiredChars,
                                defaultKbd: defaultKbd))
                }
            }


        }

        return definitions.count == 0 ? [LanguageDefinition.EnglishLanguageDefinition()] : definitions
    }

    init(jsonFileName : String)
    {
        if let languageDefinitions = loadJSON("LanguageDefinitions")
        {
            definitions = LanguageDefinitions.extractLanguageDefinitions(languageDefinitions)

        }
        else {
            definitions = [ LanguageDefinition.EnglishLanguageDefinition() ]
        }
    }

    func LanguageNames() -> [String]
    {
        var names : [String] = []

        for languageDefinition in definitions {
            names.append(languageDefinition.DescriptiveName)
        }

        return names
    }

    func KeyboardFileForLanguageCode(langCode: String) -> String? {
        for lang in self.definitions {
            if lang.LangCode == langCode {
                return lang.DefaultKbdName
            }
        }

        return nil
    }

    class func Singleton() -> LanguageDefinitions {
        if _Singleton == nil {
            _Singleton = LanguageDefinitions(jsonFileName: "LanguageDefinitions")
        }

        return _Singleton!
    }
}