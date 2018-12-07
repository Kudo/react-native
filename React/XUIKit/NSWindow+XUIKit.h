/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <AppKit/AppKit.h>

#import "RCTXUIView.h"

extern const NSWindowLevel UIWindowLevelNormal;
extern const NSWindowLevel UIWindowLevelStatusBar;
extern const NSWindowLevel UIWindowLevelAlert;

@interface NSWindow (XUIKit)

- (void)addSubview:(RCTXUIView *)view;

@property(nonatomic) NSWindowLevel windowLevel;
@property(nullable, nonatomic, strong) NSViewController *rootViewController;

// From UIView

@property(readonly, nonatomic) CGRect bounds;
@property(nonatomic) CGRect frame;
@property(nonatomic, getter=isHidden) BOOL hidden;

- (instancetype)initWithFrame:(CGRect)frame;

@end
