//
//  Highlight.cpp
//  CLJLook
//
//  Created by Osei Poku on 3/2/15.
//  Copyright (c) 2015 OPKoder. All rights reserved.
//

#include "codegenerator.h"
#import "Highlight.h"
#import <Foundation/Foundation.h>
#ifdef __cplusplus
extern "C"
{
    using namespace highlight;
#endif
    
CFStringRef highlight_run (CFStringRef input, CFBundleRef bundle) {
    CodeGenerator *gen = CodeGenerator::getInstance(OutputType::HTML);
    gen->setIncludeStyle(true);
    gen->setHTMLInlineCSS(true);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:@{@"theme":@"darkblue",@"font":@"Consolas"}];
    NSString *currentFont = [defaults stringForKey:@"font"];
    gen->setBaseFont([currentFont UTF8String]);
    NSString *currentTheme = [defaults stringForKey:@"theme"];
    CFURLRef langPath = CFBundleCopyResourceURL(bundle, CFSTR("clojure"), CFSTR("lang"), CFSTR("highlight/langDefs/"));
    CFURLRef themePath = CFBundleCopyResourceURL(bundle, (__bridge CFStringRef)currentTheme, CFSTR("theme"), CFSTR("highlight/themes/"));
    if (!gen->initTheme(CFStringGetCStringPtr(CFURLCopyFileSystemPath(themePath, kCFURLPOSIXPathStyle), kCFStringEncodingUTF8))) {
        NSLog(@"Couldn't load the theme %@", currentTheme);
        return input;
    }
    NSLog(@"Loaded %@ theme", currentTheme);
    [defaults setObject:currentFont forKey:@"font"];
    [defaults setObject:currentTheme forKey:@"theme"];
    LoadResult res = gen->loadLanguage(CFStringGetCStringPtr(CFURLCopyFileSystemPath(langPath, kCFURLPOSIXPathStyle), kCFStringEncodingUTF8));
    if (res != LoadResult::LOAD_OK) {
        NSLog(@"Couldn't load language");
        return input;
    }

    CFRelease(langPath);
    CFRelease(themePath);
    NSString *s = (__bridge NSString*)input;
    string inputStr = string(s.UTF8String);
    const string& result = gen->generateString(inputStr);
    return CFStringCreateWithCString(NULL, result.c_str(), kCFStringEncodingUTF8);
}
#ifdef __cplusplus
}
#endif
