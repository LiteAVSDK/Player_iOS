//
//  SuperEncrypt.h
//  SuperPlayer
//
//  Created by annidyfeng on 2019/3/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SuperEncrypt : NSObject


- (NSString *)getPublicKey;

- (NSString *)decrypt:(NSString *)encryptedString;
- (NSString *)encrypt:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
