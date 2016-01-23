//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Timur Ridjanovic on 1/22/16.
//  Copyright © 2016 Timur Ridjanovic. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    var filePathUrl: NSURL?
    var title: String?
    
    init(filePathUrl: NSURL, title: String) {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}
