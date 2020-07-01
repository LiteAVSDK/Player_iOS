//
//  MainTableViewCell.h
//  RTMPiOSDemo
//
//  Created by rushanting on 2017/5/3.
//  Copyright © 2017年 tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CellInfoType) {
    CellInfoTypeEntry,
    CellInfoTypeAction
};

@interface CellInfo : NSObject
@property (readonly, nonatomic) CellInfoType type;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, copy) NSString* iconName;
@property BOOL isUnFold;
@property NSArray<CellInfo *> *subCells;

+ (instancetype)cellInfoWithTitle:(NSString *)title
              controllerClassName:(NSString *)className;

+ (instancetype)cellInfoWithTitle:(NSString *)title
          controllerCreationBlock:(UIViewController *(^)(void))creator;

+ (instancetype)cellInfoWithTitle:(NSString *)title
                      actionBlock:(void (^)(void))action;

- (nullable UIViewController *)createEntryController;
- (void)performAction;
@end



@interface MainTableViewCell : UITableViewCell

@property (nonatomic) CellInfo *cellData;
@property (nonatomic) BOOL highLight;

@end

NS_ASSUME_NONNULL_END
