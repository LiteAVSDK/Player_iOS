#import <Foundation/Foundation.h>

@protocol  TXLivePushListener <NSObject>

/**
 *
 *
 */
-(void) onPushEvent:(int)EvtID withParam:(NSDictionary*)param;

/**
 *
 *
 */
-(void) onNetStatus:(NSDictionary*) param;


@end
