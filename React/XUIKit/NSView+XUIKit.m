/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "NSView+XUIKit.h"

@implementation NSView (XUIKit)

- (BOOL)isDescendantOfView:(NSView *)view
{
  return [self isDescendantOf:view];
}

- (CGAffineTransform)transform
{
  return self.layer.affineTransform;
}

- (void)setTransform:(CGAffineTransform)transform
{
  self.layer.affineTransform = transform;
}
@end
