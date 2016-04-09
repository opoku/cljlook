@import CoreFoundation;
@import Cocoa;
@import QuickLook;
@import CoreServices;
@import WebKit;
#import "Highlight.h"


OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options);
void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview);

/* -----------------------------------------------------------------------------
   Generate a preview for file

   This function's job is to create preview for designated file
   ----------------------------------------------------------------------------- */

OSStatus GeneratePreviewForURL(void *thisInterface, QLPreviewRequestRef preview, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options)
{
    @autoreleasepool {
        NSString *input = [[NSString alloc] initWithContentsOfURL:(__bridge NSURL * _Nonnull)(url) encoding:NSUTF8StringEncoding error:nil];
        if (input) {
            CFBundleRef bundle = QLPreviewRequestGetGeneratorBundle(preview);
            NSString* _html = (__bridge NSString *)(highlight_run((__bridge CFStringRef)(input), bundle));
            NSRect _rect = NSMakeRect(0.0, 0.0, 600.0, 800.0);
            NSSize maxSize = NSMakeSize(800, 600);
//            float _scale = 5 * maxSize.height / 800.0;
            NSSize _scaleSize = NSMakeSize(1, 1);
            CGSize _thumbSize = NSSizeToCGSize((CGSize) { maxSize.width * (600.0/800.0), maxSize.height});

            dispatch_sync(dispatch_get_main_queue(), ^{
                // Create the webview to display the thumbnail
                WebView *_webView = [[WebView alloc] initWithFrame:_rect];
                [_webView scaleUnitSquareToSize:_scaleSize];
                [_webView.mainFrame.frameView setAllowsScrolling:NO];
                [_webView.mainFrame loadHTMLString:_html baseURL:nil];

                while([_webView isLoading]) CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true);
                [_webView display];

                // Draw the webview in the correct context
                CGContextRef _context = QLPreviewRequestCreateContext(preview, _thumbSize, false, NULL);
                if (_context) {
                    NSGraphicsContext* _graphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)_context flipped:_webView.isFlipped];
                    [_webView displayRectIgnoringOpacity:_webView.bounds inContext:_graphicsContext];
                    QLPreviewRequestFlushContext(preview, _context);
                    CFRelease(_context);
                }
            });
        }
    }
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
