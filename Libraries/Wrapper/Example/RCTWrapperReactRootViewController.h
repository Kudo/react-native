// Copyright 2004-present Facebook. All Rights Reserved.

#import <React/RCTDefines.h>

@class RCTBridge;

NS_ASSUME_NONNULL_BEGIN

@interface RCTWrapperReactRootViewController : UIViewController

- (instancetype)initWithBridge:(RCTBridge *)bridge;

@end

NS_ASSUME_NONNULL_END
