//
//  ExtraView.swift
//  TastyImitationKeyboard
//
//  Created by Alexei Baboulevitch on 10/5/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

import UIKit

class ExtraView: UIView {
    
    var globalColors: GlobalColors.Type?
    var darkMode: Bool {
        didSet {
            if oldValue != darkMode {
                updateAppearance()
            }
        }
    }
    
    override var hidden : Bool {
        didSet {
            self.btn1.hidden = hidden
            self.btn2.hidden = hidden
            self.btn3.hidden = hidden
            self.btn4.hidden = hidden
            
            updateAppearance()
        }
    }
    
    var solidColorMode: Bool
	
	var btn1 : UIButton = UIButton()
	var btn2 : UIButton = UIButton()
	var btn3 : UIButton = UIButton()
	var btn4 : UIButton = UIButton()
	
    required init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        self.globalColors = globalColors
        self.darkMode = darkMode
        self.solidColorMode = solidColorMode
        
        super.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.globalColors = nil
        self.darkMode = false
        self.solidColorMode = false
        
        super.init(coder: aDecoder)
    }
    
    func updateAppearance() {

    }
    
}
