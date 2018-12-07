/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTXUILabel.h"

@implementation RCTXUILabel

- (BOOL)isEditable
{
  return NO;
}

- (NSString *)text
{
  return self.stringValue;
}

- (void)setText:(NSString *)text
{
  self.stringValue = text;
}

- (NSTextAlignment)textAlignment
{
  return self.alignment;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
  self.alignment = textAlignment;
}

- (NSInteger)numberOfLines
{
  return self.maximumNumberOfLines;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines
{
  self.maximumNumberOfLines = numberOfLines;
}

@end
