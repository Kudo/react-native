/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTXUIActivityIndicatorView.h"

@implementation RCTXUIActivityIndicatorView {
  BOOL _animating;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.style = NSProgressIndicatorStyleSpinning;
  }
  return self;
}

- (void)startAnimating
{
  [self startAnimation:nil];
  _animating = YES;
}

- (void)stopAnimating
{
  [self stopAnimation:nil];
  _animating = NO;
}

- (BOOL)isAnimating
{
  return _animating;
}

@end
