//
//  Utilities.swift
//  TastyImitationKeyboard
//
//  Created by Alexei Baboulevitch on 10/22/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

import Foundation
import UIKit

var profile: ((id: String) -> Double?) = {
    var counterForName = Dictionary<String, Double>()
    var isOpen = Dictionary<String, Double>()
    
    return { (id: String) -> Double? in
        if let startTime = isOpen[id] {
            let diff = CACurrentMediaTime() - startTime
            if let currentCount = counterForName[id] {
                counterForName[id] = (currentCount + diff)
            }
            else {
                counterForName[id] = diff
            }
            
            isOpen[id] = nil
        }
        else {
            isOpen[id] = CACurrentMediaTime()
        }
        
        return counterForName[id]
    }
}()

// Remove trailing and leading white space.
// Treat nil as equivalent to the empty string.
func TrimWhiteSpace(x : String?) -> String {
    return x == nil ? "" : x!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
}

func characterIsPunctuation(character: Character) -> Bool {
    return character == "." || character == "!" || character == "?"
}

func characterIsNewline(character: Character) -> Bool {
    return character == "\n" || character == "\r"
}

func characterIsWhitespace(character: Character) -> Bool {
    // there are others, but who cares
    return character == " " || character == "\n" || character == "\r" || character == "\t"
}

func stringIsWhitespace(str: String?) -> Bool {
    return TrimWhiteSpace(str) == ""
}

func isInitCaps(string: String) -> Bool
{
    return string.characters.count > 0
        && ("A"..."Z").contains(string[string.startIndex])
}


func loadJSON(fileName : String) -> NSDictionary?
{
    if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")
    {
        if !NSFileManager().fileExistsAtPath(path) {
            NSLog("File does not exist at \(path)")
            return nil
        }

        if let jsonData = NSData(contentsOfFile: path)
        {
            do {
                let JSON = try NSJSONSerialization.JSONObjectWithData(jsonData, options:NSJSONReadingOptions(rawValue: 0))

                return JSON as? NSDictionary
            }
            catch let JSONError as NSError {
                NSLog("JSONError exception\n\(JSONError)")
                return nil
            }
            catch {
                NSLog("Some other error occurred")
                return nil
            }
        }
    }

    return nil
}

