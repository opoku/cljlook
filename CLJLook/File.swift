//
//  File.swift
//  CLJLook
//
//  Created by Osei Poku on 3/2/15.
//  Copyright (c) 2015 OPKoder. All rights reserved.
//

import Foundation
import QuickLook
import CoreFoundation

func highlight () {
    highlight_run("")
}


class File : NSObject {
    func generate_preview (preview: QLPreviewRequestRef, url: CFURLRef, contentTypeUTI: CFStringRef, options: CFDictionaryRef) -> OSStatus {
        if let content = String(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: nil){
            let formatted = highlight_run(content)
            QLPreviewRequestSetDataRepresentation(preview, formatted.dataUsingEncoding(NSUTF8StringEncoding), kUTTypeHTML, nil)
        }
        return noErr;
    }
}
