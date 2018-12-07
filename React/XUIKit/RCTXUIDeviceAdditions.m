/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */


#import "RCTXUIDeviceAdditions.h"

@implementation UIDevice

+ (UIDevice *)currentDevice
{
  static UIDevice *instance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[UIDevice alloc] init];
  });
  return instance;
}

- (NSString *)name
{
  return [NSHost currentHost].name;
}

@end
