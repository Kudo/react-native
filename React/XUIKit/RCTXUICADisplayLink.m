/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTXUICADisplayLink.h"

#define RCT_TIME_PER_FRAME 0.0166

@implementation RCTXUICADisplayLink

+ (RCTXUICADisplayLink *)displayLinkWithTarget:(id)target
                                selector:(SEL)sel
{
  return [self timerWithTimeInterval:RCT_TIME_PER_FRAME
                              target:target
                            selector:sel
                            userInfo:nil
                             repeats:YES];
}

- (void)addToRunLoop:(NSRunLoop *)runloop forMode:(NSRunLoopMode)mode
{
  [runloop addTimer:self forMode:mode];
}

- (CFTimeInterval)timestamp
{
  return self.fireDate.timeIntervalSince1970;
}

- (CFTimeInterval)duration
{
  return self.timeInterval;
}

- (BOOL)isPaused
{
  return NO;
}

- (void)setPaused:(BOOL)paused
{
  // TODO(kudo):
}
@end
