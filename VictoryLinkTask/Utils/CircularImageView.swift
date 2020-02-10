
//
//  File.swift
//  Tourista
//
//  Created by MINA AZIR on 1/21/19.
//  Copyright © 2019 Abanoub Osama. All rights reserved.
//


import UIKit

class CircularImageView: UIImageView {
    
    override func didMoveToWindow() {
        
        let size = frame.size.width
        self.layer.cornerRadius = size / 2
        clipsToBounds = true
        
        super.didMoveToWindow()
    }
}

