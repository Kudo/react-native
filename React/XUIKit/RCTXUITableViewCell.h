/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <AppKit/AppKit.h>

#import "RCTXUILabel.h"

typedef NS_ENUM(NSInteger, UITableViewCellStyle) {
  UITableViewCellStyleDefault,
  UITableViewCellStyleValue1,
  UITableViewCellStyleValue2,
  UITableViewCellStyleSubtitle
};

@interface RCTXUITableViewCell : NSTableCellView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;

@property(nonatomic, readonly, strong) RCTXUILabel *textLabel;

@end
