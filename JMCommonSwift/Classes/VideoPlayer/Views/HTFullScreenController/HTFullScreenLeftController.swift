//
//  HTFullScreenLeftController.swift
//  Cartoon
//
//  Created by James on 2023/5/4.
//

import Foundation
import UIKit

// MARK: ---类-属性

class HTFullScreenLeftController: HTFullScreenController {
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeLeft
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }

    deinit {
        print("HTFullScreenLeftController deinit")
    }
}
