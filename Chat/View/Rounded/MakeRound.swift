//
//  MakeRound.swift
//  Chat
//
//  Created by lobna on 12/25/18.
//  Copyright © 2018 lobna. All rights reserved.
//

import UIKit

@IBDesignable
class MakeRound: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
