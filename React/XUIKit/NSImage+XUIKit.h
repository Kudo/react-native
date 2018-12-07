/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <AppKit/AppKit.h>

typedef NS_ENUM(NSInteger, UIImageResizingMode) {
  UIImageResizingModeTile = NSImageResizingModeTile,
  UIImageResizingModeStretch = NSImageResizingModeStretch,
};

@interface NSImage (XUIKit)

@property(nonatomic, readonly) CGImageRef CGImage;

+ (NSImage *)imageWithData:(NSData *)data;

- (NSImage *)resizableImageWithCapInsets:(NSEdgeInsets)capInsets;

- (NSImage *)resizableImageWithCapInsets:(NSEdgeInsets)capInsets
                            resizingMode:(NSImageResizingMode)resizingMode;

@end
