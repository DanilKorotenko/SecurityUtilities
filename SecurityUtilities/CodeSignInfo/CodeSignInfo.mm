//
//  CodeSignInfo.m
//  certificateUtility
//
//  Created by Danil Korotenko on 10/9/25.
//

#import <Foundation/Foundation.h>

#import "CodeSignInfo.h"
#import "SUCodeSignInfo.h"

const char *GetSafeUTF8String(NSString *aString)
{
    return aString == nil ? "" : (([aString UTF8String] == NULL) ? "" : [aString UTF8String]);
}

CodeSignInfoRef CodeSignInfoCreateWithBinaryPath(const char *aBinaryPath)
{
    SUCodeSignInfo *codeSignInfo = [[SUCodeSignInfo alloc] initWithBinaryPath:
        [NSString stringWithUTF8String:aBinaryPath]];

    void *csi = (__bridge_retained void *)(codeSignInfo);

    CodeSignInfoRef result = (CodeSignInfoRef)malloc(sizeof(CodeSignInfo));
    result->_codeSignInfo = csi;

    return result;
}

void CodeSignInfoReleaseAndMakeNull(CodeSignInfoRef *aCodeSignInfo)
{
    SUCodeSignInfo *csi = (__bridge_transfer SUCodeSignInfo *) (*aCodeSignInfo)->_codeSignInfo;
    csi = nil;
    free(*aCodeSignInfo);
    *aCodeSignInfo = NULL;
}

const char *CodeSignInfoGetIdentifier(CodeSignInfoRef aCodeSignInfo)
{
    const char *result = NULL;

    @autoreleasepool
    {
        SUCodeSignInfo *codeSignInfo = (__bridge SUCodeSignInfo *)aCodeSignInfo->_codeSignInfo;
        result = GetSafeUTF8String(codeSignInfo.identifier);
    }

    return result;
}
