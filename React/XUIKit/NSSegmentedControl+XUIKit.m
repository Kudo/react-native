/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "NSSegmentedControl+XUIKit.h"

@implementation NSSegmentedControl (XUIKit)

- (NSInteger)selectedSegmentIndex
{
  return self.selectedSegment;
}

- (void)setSelectedSegmentIndex:(NSInteger)value
{
  self.selectedSegment = value;
}

- (NSUInteger)numberOfSegments
{
  return self.segmentCount;
}

@end
