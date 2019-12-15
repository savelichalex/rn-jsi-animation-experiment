//
//  JSIAnimatedView.m
//  BasicJSI
//
//  Created by Алексей Савельев on 14.12.2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "JSIAnimatedView.h"

#import <stdlib.h>

using namespace facebook;

@implementation JSIAnimatedView {
  UIViewPropertyAnimator *animator;
  UIPanGestureRecognizer *recognizer;
  BOOL isOpen;
  CGFloat initialY;
  RCTCxxBridge *bridge;
  jsi::Object *rec;
}

- (instancetype)initWithBridge:(RCTCxxBridge *)bridge
{
  self = [super init];
  if (self) {
    animator = [[UIViewPropertyAnimator alloc] initWithDuration:0.3 curve:UIViewAnimationCurveEaseInOut animations:nil];
    recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [self addGestureRecognizer:recognizer];
    isOpen = false;
    initialY = 0;
    self->bridge = bridge;
  }
  return self;
}

- (void)didMoveToSuperview {
  initialY = self.frame.origin.y;
  [self setupJSView];
  [self setupJSAnimator];
  rec = [self initRecognizer];
}

- (void)setupJSView {
  RCTCxxBridge *cxxBridge = (RCTCxxBridge *)self->bridge;
  
  if (cxxBridge.runtime == nullptr) {
    return;
  }
  
  jsi::Runtime &rt = *(jsi::Runtime *)cxxBridge.runtime;
  
  jsi::Object view = rt.global().getPropertyAsObject(rt, "view");
  
  JSIAnimatedView *_this = self;
  // --------------------------
  auto setTranslationImpl = [_this](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) {
    auto tr = args[0].asObject(rt);
    [_this setTransform:CGAffineTransformMakeTranslation(tr.getProperty(rt, "x").asNumber(), tr.getProperty(rt, "y").asNumber())];
    return nullptr;
  };
  
  view.setProperty(
                   rt,
                   "setTranslation",
                   jsi::Function::createFromHostFunction(
                                                         rt,
                                                         jsi::PropNameID::forAscii(rt, "setTranslation"),
                                                         1,
                                                         setTranslationImpl));
  
  // --------------------------
  auto layoutIfNeededImpl = [_this](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) {
    [_this layoutIfNeeded];
    return nullptr;
  };
  
  view.setProperty(
                   rt,
                   "layoutIfNeeded",
                   jsi::Function::createFromHostFunction(
                                                         rt,
                                                         jsi::PropNameID::forAscii(rt, "layoutIfNeeded"),
                                                         0,
                                                         layoutIfNeededImpl));
}

- (void)setupJSAnimator {
  RCTCxxBridge *cxxBridge = (RCTCxxBridge *)self->bridge;
  
  if (cxxBridge.runtime == nullptr) {
    return;
  }
  
  jsi::Runtime &rt = *(jsi::Runtime *)cxxBridge.runtime;
  
  // rt.global().getPropertyAsFunction(rt, "test").call(rt);
  
  jsi::Object animator = rt.global().getPropertyAsObject(rt, "animator");
  
  JSIAnimatedView *_this = self;
  // --------------------------
  auto pauseAnimationImpl = [_this](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) {
    [_this->animator pauseAnimation];
    return nullptr;
  };
  
  animator.setProperty(
                       rt,
                       "pauseAnimation",
                       jsi::Function::createFromHostFunction(
                                                             rt,
                                                             jsi::PropNameID::forAscii(rt, "pauseAnimation"),
                                                             0,
                                                             pauseAnimationImpl));
  
  // --------------------------
  auto startAnimationImpl = [_this](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) {
    [_this->animator startAnimation];
    return nullptr;
  };
  
  animator.setProperty(
                       rt,
                       "startAnimation",
                       jsi::Function::createFromHostFunction(
                                                             rt,
                                                             jsi::PropNameID::forAscii(rt, "startAnimation"),
                                                             0,
                                                             startAnimationImpl));
  
  // --------------------------
  auto stopAnimationImpl = [_this](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) {
    [_this->animator stopAnimation:args[0].getBool()];
    return nullptr;
  };
  
  animator.setProperty(
                       rt,
                       "stopAnimation",
                       jsi::Function::createFromHostFunction(
                                                             rt,
                                                             jsi::PropNameID::forAscii(rt, "stopAnimation"),
                                                             1,
                                                             stopAnimationImpl));
  
  // --------------------------
  auto setFractionCompleteImpl = [_this](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) {
    NSLog(@"fraction: %f", args[0].getNumber());
    _this->animator.fractionComplete = args[0].getNumber();
    return nullptr;
  };
  
  animator.setProperty(
                       rt,
                       "setFractionComplete",
                       jsi::Function::createFromHostFunction(
                                                             rt,
                                                             jsi::PropNameID::forAscii(rt, "setFractionComplete"),
                                                             1,
                                                             setFractionCompleteImpl));
  
  // --------------------------
  auto continueAnimationImpl = [_this](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) {
    [_this->animator continueAnimationWithTimingParameters:nil durationFactor:0];
    return nullptr;
  };
  
  animator.setProperty(
                       rt,
                       "continueAnimation",
                       jsi::Function::createFromHostFunction(
                                                             rt,
                                                             jsi::PropNameID::forAscii(rt, "continueAnimation"),
                                                             0,
                                                             continueAnimationImpl));
  
  // --------------------------
  auto addAnimationsImpl = [_this](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) {
    auto fn = std::make_shared<jsi::Function>(args[0].asObject(rt).asFunction(rt));
    [_this->animator addAnimations:^{
      fn->call(rt);
    }];
    return nullptr;
  };
  
  animator.setProperty(
                       rt,
                       "addAnimations",
                       jsi::Function::createFromHostFunction(
                                                             rt,
                                                             jsi::PropNameID::forAscii(rt, "addAnimations"),
                                                             1,
                                                             addAnimationsImpl));
  
  // --------------------------
  auto addCompletionImpl = [_this](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) {
    auto fn = std::make_shared<jsi::Function>(args[0].asObject(rt).asFunction(rt));
    [_this->animator addCompletion:^(UIViewAnimatingPosition finalPosition) {
      fn->call(rt);
    }];
    return nullptr;
  };
  
  animator.setProperty(
                       rt,
                       "addCompletion",
                       jsi::Function::createFromHostFunction(
                                                             rt,
                                                             jsi::PropNameID::forAscii(rt, "addCompletion"),
                                                             1,
                                                             addCompletionImpl));
  
  return;
}

- (jsi::Object *)initRecognizer {
  RCTCxxBridge *cxxBridge = (RCTCxxBridge *)self->bridge;
  jsi::Runtime &rt = *(jsi::Runtime *)cxxBridge.runtime;
  
  jsi::Object *r = new jsi::Object(rt);
  
  JSIAnimatedView *_this = self;
  auto getTranslationInSuperiewImpl = [_this](jsi::Runtime& rt, const jsi::Value& thisVal, const jsi::Value* args, size_t count) {
    CGPoint translation = [_this->recognizer translationInView:_this.superview];
    jsi::Object result = jsi::Object(rt);
    result.setProperty(rt, "x", translation.x);
    result.setProperty(rt, "y", translation.y);
    return result;
  };
  
  r->setProperty(rt, "getTranslationInSuperiew", jsi::Function::createFromHostFunction(
                                                                                       rt,
                                                                                       jsi::PropNameID::forAscii(rt, "getTranslationInSuperiew"),
                                                                                       0,
                                                                                       getTranslationInSuperiewImpl));
  
  return r;
}

- (void)onPan:(UIPanGestureRecognizer *)recognizer {
  RCTCxxBridge *cxxBridge = (RCTCxxBridge *)self->bridge;
  
  if (cxxBridge.runtime == nullptr) {
    return;
  }
  
  jsi::Runtime &rt = *(jsi::Runtime *)cxxBridge.runtime;
  
  const char *state = "";
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    state = "UIGestureRecognizerStateBegan";
  } else if (recognizer.state == UIGestureRecognizerStateChanged) {
    state = "UIGestureRecognizerStateChanged";
  } else if (recognizer.state == UIGestureRecognizerStateEnded) {
    state = "UIGestureRecognizerStateEnded";
  }
  
  rec->setProperty(rt, "state", jsi::String::createFromAscii(rt, state));
  
  jsi::Function onPanJSImpl = rt.global().getPropertyAsFunction(rt, "onPan");
  onPanJSImpl.call(rt, *rec);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
