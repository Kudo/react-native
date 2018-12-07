/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "NSWindow+XUIKit.h"

const NSWindowLevel UIWindowLevelNormal = NSNormalWindowLevel;
const NSWindowLevel UIWindowLevelStatusBar = NSStatusWindowLevel;
const NSWindowLevel UIWindowLevelAlert = NSPopUpMenuWindowLevel;

@implementation NSWindow (XUIKit)

- (void)addSubview:(RCTXUIView *)view
{
  [self.contentView addSubview:view];
}

- (NSWindowLevel)windowLevel
{
  return self.level;
}

- (void)setWindowLevel:(NSWindowLevel)windowLevel
{
  self.level = windowLevel;
}

- (NSViewController *)rootViewController
{
  return self.contentViewController;
}

- (void)setRootViewController:(NSViewController *)rootViewController
{
  self.contentViewController = rootViewController;
}

- (CGRect)bounds
{
  return self.contentView.bounds;
}

- (CGRect)frame
{
  return self.frame;
}

- (void)setFrame:(CGRect)frame
{
  [self setFrame:frame display:YES];
}

- (BOOL)isHidden
{
  return self.contentView.hidden;
}

- (void)setHidden:(BOOL)hidden
{
  self.contentView.hidden = hidden;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  return [self.contentView initWithFrame:frame];
}
@end
