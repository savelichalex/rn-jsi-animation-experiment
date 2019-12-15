//
//  JSITest.mm
//  BasicJSI
//
//  Created by Алексей Савельев on 14.12.2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "JSITest.h"
#import <React/RCTBridge+Private.h>

using namespace facebook;

@implementation JSITest

RCT_EXPORT_MODULE();

- (instancetype)init
{
  self = [super init];
  if (self) {
    // For whatever reason we need init here
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(jsLoaded:)
        name:RCTJavaScriptDidLoadNotification
      object:nil];
  }
  return self;
}

@synthesize bridge = _bridge;

- (void)jsLoaded:(NSNotification *)notification {
  RCTCxxBridge *cxxBridge = (RCTCxxBridge *)_bridge;
  
  if (cxxBridge.runtime == nullptr) {
    return;
  }
  
  jsi::Runtime &rt = *(jsi::Runtime *)cxxBridge.runtime;
  
  rt.global().getPropertyAsFunction(rt, "test").call(rt);
}

@end
