/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTXUITableView.h"

@implementation RCTXUITableView

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{

}

- (__kindof RCTXUITableView *)dequeueReusableCellWithIdentifier:(NSString *)identifier
                                                   forIndexPath:(NSIndexPath *)indexPath
{
  return [self makeViewWithIdentifier:identifier owner:self];
}

@end
