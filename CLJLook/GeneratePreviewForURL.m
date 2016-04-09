@import CoreFoundation;
@import Cocoa;
#include <CoreServices/CoreServices.h>
#include <QuickLook/QuickLook.h>
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
        CFBundleRef bundle = QLPreviewRequestGetGeneratorBundle(preview);
        CFStringRef formatted = highlight_run((__bridge CFStringRef)(input), bundle);
        CFDictionaryRef dict = CFDictionaryCreate(NULL, NULL, NULL, 0, NULL, NULL);
        CFDataRef data1 = CFStringCreateExternalRepresentation(NULL, formatted, kCFStringEncodingUTF8, 0);
        QLPreviewRequestSetDataRepresentation(preview, data1, kUTTypeHTML, dict);
        CFRelease(dict);
        CFRelease(data1);
    }
    return noErr;
}

void CancelPreviewGeneration(void *thisInterface, QLPreviewRequestRef preview)
{
    // Implement only if supported
}
