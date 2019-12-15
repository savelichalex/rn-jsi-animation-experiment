//
//  JSIAnimatedView.h
//  BasicJSI
//
//  Created by Алексей Савельев on 14.12.2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <React/RCTView.h>
#import <React/RCTBridge+Private.h>
#import <React-jsi/jsi/jsi.h>

NS_ASSUME_NONNULL_BEGIN

@interface JSIAnimatedView : RCTView

- (instancetype)initWithBridge:(RCTCxxBridge *)bridge;

@end

NS_ASSUME_NONNULL_END
