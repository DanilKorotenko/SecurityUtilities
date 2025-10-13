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

@property(readonly) NSString *identifier;

@end

NS_ASSUME_NONNULL_END
