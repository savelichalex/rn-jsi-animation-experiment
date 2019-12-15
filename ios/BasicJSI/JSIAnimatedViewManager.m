//
//  JSIAnimatedViewManager.m
//  BasicJSI
//
//  Created by Алексей Савельев on 14.12.2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "JSIAnimatedView.h"
#import "JSIAnimatedViewManager.h"

@implementation JSIAnimatedViewManager

RCT_EXPORT_MODULE(JSIAnimatedViewM);

@synthesize bridge = _bridge;

- (UIView *)view {
  return [[JSIAnimatedView alloc] initWithBridge:self.bridge];
}

@end
