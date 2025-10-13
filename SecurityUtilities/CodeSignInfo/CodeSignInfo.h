//
//  CodeSignInfo.h
//  certificateUtility
//
//  Created by Danil Korotenko on 10/9/25.
//

#pragma once

#ifdef __cplusplus
  extern "C" {
#endif

typedef struct
{
    void *_codeSignInfo;
} CodeSignInfo;

typedef CodeSignInfo* CodeSignInfoRef;

CodeSignInfoRef CodeSignInfoCreateWithBinaryPath(const char *aBinaryPath);

void CodeSignInfoReleaseAndMakeNull(CodeSignInfoRef *aCodeSignInfo);

#pragma mark -

const char *CodeSignInfoGetIdentifier(CodeSignInfoRef aCodeSignInfo);

#ifdef __cplusplus
  }
#endif
