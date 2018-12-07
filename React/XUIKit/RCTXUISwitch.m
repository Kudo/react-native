/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTXUISwitch.h"

@implementation RCTXUISwitch

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    [self setButtonType:NSSwitchButton];
    self.title = @"";
    self.controlSize = NSControlSizeRegular;
    self.stringValue = @"";
  }
  return self;
}

- (BOOL)isOn
{
  return self.state == NSControlStateValueOn;
}

- (void)setOn:(BOOL)on
{
  [self setOn:on animated:NO];
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
  // |animated| is not supported
  self.state = on ? NSControlStateValueOn : NSControlStateValueOff;
}

@end
