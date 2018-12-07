/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTXUITableViewCell.h"

@implementation RCTXUITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
  if ((self = [super init])) {
    self.identifier = reuseIdentifier;
  }
  return self;
}

- (RCTXUILabel *)textLabel
{
  return self.textField;
}

@end
