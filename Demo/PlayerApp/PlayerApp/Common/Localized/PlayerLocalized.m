//  Copyright © 2023 Tencent. All rights reserved.
//

#import "PlayerLocalized.h"

NSString * PlayerLocalized(NSString *key) {
    NSBundle *bundle = [NSBundle mainBundle];
    return [bundle localizedStringForKey:key value:@"" table:@"PlayerLocalized"];
}
