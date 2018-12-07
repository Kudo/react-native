/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "NSImage+XUIKit.h"

@implementation NSImage (XUIKit)

- (CGImageRef)CGImage
{
  return [self CGImageForProposedRect:nil context:nil hints:nil];
}

+ (NSImage *)imageWithData:(NSData *)data
{
  return [[NSImage alloc] initWithData:data];
}

- (NSImage *)resizableImageWithCapInsets:(NSEdgeInsets)capInsets
{
  // Currently only support stretch resizing mode
  return [self resizableImageWithCapInsets:capInsets resizingMode:NSImageResizingModeStretch];
}

- (NSImage *)resizableImageWithCapInsets:(NSEdgeInsets)capInsets
                            resizingMode:(NSImageResizingMode)resizingMode
{
  NSImage* newImage = [self copy];
  newImage.capInsets = capInsets;
  newImage.resizingMode = resizingMode;
  return newImage;
}

@end
