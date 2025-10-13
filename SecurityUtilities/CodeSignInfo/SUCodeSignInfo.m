//
//  SUCodeSignInfo.m
//  certificateUtility
//
//  Created by Danil Korotenko on 10/13/25.
//

#import "SUCodeSignInfo.h"

@interface SUCodeSignInfo ()

@property NSDictionary* signingInfoDictionary;

@end

@implementation SUCodeSignInfo

- (instancetype)initWithBinaryPath:(NSString *)aPath
{
    self = [super init];
    if (self)
    {
        NSURL *pathURL = [NSURL fileURLWithPath:aPath];

        SecStaticCodeRef staticCode = NULL;
        CFDictionaryRef cfSigningInfo = NULL;

        do
        {
            OSStatus staticCodeResult = SecStaticCodeCreateWithPath(
                (__bridge CFURLRef)pathURL,
                kSecCSDefaultFlags, &staticCode);

            if (staticCodeResult != noErr)
            {
                break;
            }

            if (staticCode == NULL)
            {
                break;
            }

            OSStatus copySigningInfoCode = SecCodeCopySigningInformation(staticCode,
                kSecCSSigningInformation, &cfSigningInfo);
            if (copySigningInfoCode != noErr)
            {
                break;
            }

            if (cfSigningInfo == NULL)
            {
                break;
            }

            self.signingInfoDictionary = CFBridgingRelease(cfSigningInfo);
        }
        while (false);

        if (staticCode != NULL)
        {
            CFRelease(staticCode);
        }

        if (self.signingInfoDictionary == nil)
        {
            return nil;
        }
    }
    return self;
}

- (NSString *)identifier
{
    return [self.signingInfoDictionary objectForKey:(NSString *)kSecCodeInfoIdentifier];
}

@end

/*
    do
    {

        CFStringRef cfTeamIdentifier = (CFStringRef)CFDictionaryGetValue(cfSigningInfo, kSecCodeInfoTeamIdentifier);
//        NSString * teamIdentifier = [[[NSString alloc] initWithString: (NSString *)cfTeamIdentifier] autorelease];

    } while (false);

*/
