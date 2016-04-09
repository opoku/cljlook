#include <CoreFoundation/CoreFoundation.h>
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
#include <Cocoa/Cocoa.h>
#include <WebKit/WebKit.h>
#import "Highlight.h"

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize);
void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail);

/* -----------------------------------------------------------------------------
    Generate a thumbnail for file

   This function's job is to create thumbnail for designated file as fast as possible
   ----------------------------------------------------------------------------- */

OSStatus GenerateThumbnailForURL(void *thisInterface, QLThumbnailRequestRef thumbnail, CFURLRef url, CFStringRef contentTypeUTI, CFDictionaryRef options, CGSize maxSize)
{
    // To complete your generator please implement the function GenerateThumbnailForURL in GenerateThumbnailForURL.c
    NSString *_content = [[NSString alloc] initWithContentsOfURL:(__bridge NSURL *)(url) encoding:NSUTF8StringEncoding error:nil];
    if (_content) {
        // Encapsulate the content of the .strings file in HTML
        CFBundleRef bundle = QLThumbnailRequestGetGeneratorBundle(thumbnail);
        NSString *_html = (__bridge NSString *)(highlight_run((__bridge CFStringRef)(_content), bundle));
        
        NSRect _rect = NSMakeRect(0.0, 0.0, 600.0, 800.0);
        float _scale = 5 * maxSize.height / 800.0;
        NSSize _scaleSize = NSMakeSize(_scale, _scale);
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
            CGContextRef _context = QLThumbnailRequestCreateContext(thumbnail, _thumbSize, false, NULL);
            if (_context) {
                NSGraphicsContext* _graphicsContext = [NSGraphicsContext graphicsContextWithGraphicsPort:(void *)_context flipped:_webView.isFlipped];
                [_webView displayRectIgnoringOpacity:_webView.bounds inContext:_graphicsContext];
                QLThumbnailRequestFlushContext(thumbnail, _context);
                CFRelease(_context);
            }
        });
    }
    return noErr;
}

void CancelThumbnailGeneration(void *thisInterface, QLThumbnailRequestRef thumbnail)
{
    // Implement only if supported
}
