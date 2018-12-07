/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "NSGestureRecognizer+XUIKit.h"

@implementation NSGestureRecognizer (XUIKit)

- (void)addTarget:(id)target action:(SEL)action
{
  self.target = target;
  self.action = action;
}

@end
