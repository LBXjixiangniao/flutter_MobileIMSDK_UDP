#import <Flutter/Flutter.h>
#import "ChatBaseEvent.h"
#import "ChatMessageEvent.h"
#import "MessageQoSEvent.h"
@interface FlutterMobileIMSDKPlugin : NSObject<FlutterPlugin,MessageQoSEvent,ChatMessageEvent,ChatBaseEvent>
@end
