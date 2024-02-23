//
//  HTFullScreenRightController.swift
//  Cartoon
//
//  Created by James on 2023/5/4.
//

import Foundation
import UIKit

// MARK: ---类-属性

class HTFullScreenRightController: HTFullScreenController {
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }

    deinit {
        print("HTFullScreenRightController deinit")
    }
}
