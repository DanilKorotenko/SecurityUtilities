//
//  SUCodeSignInfo.h
//  certificateUtility
//
//  Created by Danil Korotenko on 10/13/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SUCodeSignInfo : NSObject

- (instancetype)initWithBinaryPath:(NSString *)aPath;
- (instancetype)initWithPid:(int)aPid;

@property(readonly) NSString *identifier;
@property(readonly) NSString *companyName;

@end

NS_ASSUME_NONNULL_END
