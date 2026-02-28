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

@synthesize companyName;

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

- (instancetype)initWithPid:(int)aPid
{
    self = [super init];
    if (self)
    {
        SecCodeRef code = NULL;
        CFDictionaryRef signingInfo = NULL;

        NSNumber *pidNumber = [NSNumber numberWithInt:aPid];
        NSDictionary *attributes = @{ (__bridge id)kSecGuestAttributePid : pidNumber };

        OSStatus status = SecCodeCopyGuestWithAttributes(NULL,
            (__bridge CFDictionaryRef)attributes, kSecCSDefaultFlags, &code);

        if (status == errSecSuccess && code != NULL)
        {
            if (SecCodeCopySigningInformation(code, kSecCSSigningInformation, &signingInfo) == errSecSuccess)
            {
                if (signingInfo != NULL)
                {
                    self.signingInfoDictionary = CFBridgingRelease(signingInfo);
                }
            }
        }

        if (code != NULL)
        {
            CFRelease(code);
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

+ (NSString *)extractCompanyFromCommonName:(NSString *)aCommonName
{
    static NSString * const devID = @"Developer ID Application: ";
    NSString *result = nil;

    NSRange rangeDev = [aCommonName rangeOfString:devID];

    if (rangeDev.location != NSNotFound)
    {
        NSRange rangeBr = [aCommonName rangeOfString:@")"];
        NSUInteger loc = rangeDev.location + rangeDev.length;
        NSUInteger len = (rangeBr.location + rangeBr.length) - devID.length;
        result = [aCommonName substringWithRange:NSMakeRange(loc, len)];
    }

    return result;
}

- (NSString *)companyName
{
    if (nil == companyName)
    {
        CFArrayRef certificates = (CFArrayRef)CFBridgingRetain([self.signingInfoDictionary
            objectForKey:(NSString *)kSecCodeInfoCertificates]);
        CFIndex certificatesCount = CFArrayGetCount(certificates);
        for (CFIndex i = 0; i < certificatesCount; i++)
        {
            SecCertificateRef certificate = (SecCertificateRef)CFArrayGetValueAtIndex(certificates, i);

            CFStringRef commonNameRef = NULL;
            SecCertificateCopyCommonName(certificate, &commonNameRef);
            if (commonNameRef != NULL)
            {
                NSString *commonName = (NSString *)CFBridgingRelease(commonNameRef);
                companyName = [[self class] extractCompanyFromCommonName:commonName];
                if (companyName != nil)
                {
                    break;
                }
            }
        }
    }
    return companyName;
}

@end
