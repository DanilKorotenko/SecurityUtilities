// *=================================================================
// * GTB Technologies Proprietary
// * Copyright 2024 GTB Technologies, Inc.
// * UNPUBLISHED WORK
// * This software is the confidential and proprietary information of
// * GTB Technologies, Inc. ("Proprietary Information"). Any use,
// * reproduction, distribution or disclosure of the software or
// * Proprietary Information, in whole or in part, must comply with
// * the terms of the license agreement, nondisclosure agreement
// * or contract entered into with GTB Technologies, Inc. providing
// * access to this software.
// * @author Danil Korotenko<___EMAIL___>
// *==================================================================
//

#import "CertificateUtilities.h"

#import <Foundation/Foundation.h>

#import "../AuthorizationUtilities/AUAuthorization.h"
#import "../IdentityUtilities/IUIdentity.h"

#import "SUKeychain.h"

#include <vector>

bool isCertificateInSystemKeychain(const std::string &aDerPath, std::string &errorDescription)
{
    @autoreleasepool
    {
        NSString *derPath = [NSString stringWithUTF8String:aDerPath.c_str()];
        if (!derPath)
        {
            errorDescription = "isCertificateInSystemKeychain: No path";
            return false;
        }

        SUKeychain *keychain = [SUKeychain systemKeychain];
        if (!keychain)
        {
            errorDescription = "No system keychain";
            return false;
        }

        NSString *internalErrorDescription = nil;

        do
        {
            SUCeritifcate *certificate = [[SUCeritifcate alloc] initWithPath:derPath];
            if (!certificate)
            {
                internalErrorDescription = [NSString stringWithFormat:
                    @"Cannot read certificate: %@", derPath];
                break;
            }

            if (![keychain containsCertificate:certificate])
            {
                internalErrorDescription = [NSString stringWithFormat:
                    @"Certificate not in system keychain: %@", certificate.name];
                break;
            }
        }
        while (false);

        if (internalErrorDescription)
        {
            errorDescription = std::string([internalErrorDescription UTF8String]);
        }
        return internalErrorDescription == nil;
    }
}

bool isCertificateInSystemKeychainAndAdminTrusted(const std::string &aHash, std::string &errorDescription)
{
    @autoreleasepool
    {
        NSString *internalErrorDescription = nil;

        SUKeychain *systemKeychain = [SUKeychain systemKeychain];

        do
        {
            NSString *sha1 = [[NSString alloc] initWithUTF8String:aHash.c_str()];
            SUCeritifcate *certificate = [systemKeychain findCertificateBySHA1:sha1];
            if (!certificate)
            {
                internalErrorDescription = [NSString stringWithFormat:@"Certificate not found: %@", sha1];
                break;
            }

            if (!certificate.isAdminTrusted)
            {
                internalErrorDescription = [NSString stringWithFormat:@"certificate not admin trusted: %@",
                    certificate.name];
                break;
            }
        } while (false);

        if (internalErrorDescription)
        {
            errorDescription = std::string([internalErrorDescription UTF8String]);
        }
        return internalErrorDescription == nil;
    }
}

bool addCertificateToCommonKeychain(const std::string &aDerPath, std::string &errorDescription)
{
    @autoreleasepool
    {
        NSString *derPath = [NSString stringWithUTF8String:aDerPath.c_str()];
        if (!derPath)
        {
            errorDescription = "isCertificateInSystemKeychain: No path";
            return false;
        }

        SUKeychain *keychain = [SUKeychain commonKeychain];
        if (!keychain)
        {
            errorDescription = "No common keychain";
            return false;
        }

        NSString *internalErrorDescription = nil;

        do
        {
            SUCeritifcate *certificate = [[SUCeritifcate alloc] initWithPath:derPath];
            if (!certificate)
            {
                internalErrorDescription = [NSString stringWithFormat:
                    @"Cannot read certificate: %@", derPath];
                break;
            }

            OSStatus err = noErr;
            if (![keychain containsCertificate:certificate])
            {
                err = [keychain addCertificate:certificate];
                if (err != noErr)
                {
                    internalErrorDescription = [NSString stringWithFormat:
                        @"Add certificate To common Keychain failure. Error: %d", err];
                    break;
                }
            }
        }
        while (false);

        if (internalErrorDescription)
        {
            errorDescription = std::string([internalErrorDescription UTF8String]);
        }
        return internalErrorDescription == nil;
    }
}

// certificate must be already in keychain
bool checkCertificates(const std::vector<std::string> &aHashes, std::string &errorDescription)
{
    @autoreleasepool
    {
        NSString *internalErrorDescription = nil;

        NSMutableArray *hashes = [NSMutableArray array];
        for (std::string sha1Item: aHashes)
        {
            NSString *sha1 = [[NSString alloc] initWithUTF8String:sha1Item.c_str()];
            if (sha1)
            {
                [hashes addObject:sha1];
            }
        }

        SUKeychain *commonKeychain = [SUKeychain commonKeychain];
        [commonKeychain checkCertificates:hashes  errorDescription:&internalErrorDescription];

        if (internalErrorDescription)
        {
            errorDescription = std::string([internalErrorDescription UTF8String]);
        }
        return internalErrorDescription == nil;
    }
}

// certificate must be already in keychain
bool deleteCertificates(const std::vector<std::string> &aHashes, std::string &errorDescription)
{
    @autoreleasepool
    {
        NSString *internalErrorDescription = nil;

        SUKeychain *commonKeychain = [SUKeychain commonKeychain];

        for (std::string sha1Item: aHashes)
        {
            NSString *sha1 = [[NSString alloc] initWithUTF8String:sha1Item.c_str()];
            SUCeritifcate *certificate = [commonKeychain findCertificateBySHA1:sha1];
            if (certificate)
            {
                OSStatus status = [SUKeychain deleteCertificate:certificate];
                if (status != noErr)
                {
                    internalErrorDescription = [NSString stringWithFormat:@"Error on delete certificate: %d", status];
                    break;
                }
            }
        }

        if (internalErrorDescription)
        {
            errorDescription = std::string([internalErrorDescription UTF8String]);
        }
        return internalErrorDescription == nil;
    }
}
