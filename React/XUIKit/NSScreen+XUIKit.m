/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "NSScreen+XUIKit.h"

@implementation NSScreen (XUIKit)

- (CGFloat)scale
{
  return self.backingScaleFactor;
}

- (CGRect)bounds
{
  return self.frame;
}

@end
