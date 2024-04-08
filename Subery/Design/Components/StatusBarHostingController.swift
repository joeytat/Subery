//
//  StatusBarHostingController.swift
//  Subery
//
//  Created by yu wang on 2023/5/4.
//

import SwiftUI

class StatusBarHostingController<Content>: UIHostingController<Content> where Content: View {
    private var lightStatusBar: Bool
    
    init(rootView: Content, lightStatusBar: Bool) {
        self.lightStatusBar = lightStatusBar
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return lightStatusBar ? .lightContent : .default
    }
}
