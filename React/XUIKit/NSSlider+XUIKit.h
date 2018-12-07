/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <AppKit/AppKit.h>

#import "NSControl+XUIKit.h"

@interface NSSlider (XUIKit)

- (void)setMinimumTrackImage:(NSImage *)image forState:(UIControlState)state;
- (void)setMaximumTrackImage:(NSImage *)image forState:(UIControlState)state;
- (void)setThumbImage:(NSImage *)image forState:(UIControlState)state;
- (NSImage *)thumbImageForState:(UIControlState)state;

@property(nonatomic) float value;
@property(nonatomic) float minimumValue;
@property(nonatomic) float maximumValue;

@end
