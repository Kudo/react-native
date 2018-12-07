/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "NSSlider+XUIKit.h"

@implementation NSSlider (XUIKit)

- (void)setMinimumTrackImage:(NSImage *)image forState:(UIControlState)state
{
  // Not supported
}

- (void)setMaximumTrackImage:(NSImage *)image forState:(UIControlState)state
{
  // Not supported
}

- (void)setThumbImage:(NSImage *)image forState:(UIControlState)state
{
  // Not supported
}

- (NSImage *)thumbImageForState:(UIControlState)state
{
  // Not supported
  return nil;
}

- (float)value
{
  return self.floatValue;
}

- (void)setValue:(float)value
{
  self.floatValue = value;
}

- (float)minimumValue
{
  return self.minValue;
}

- (void)setMinimumValue:(float)value
{
  self.minValue = value;
}

- (float)maximumValue
{
  return self.maxValue;
}

- (void)setMaximumValue:(float)value
{
  self.maxValue = value;
}

@end
