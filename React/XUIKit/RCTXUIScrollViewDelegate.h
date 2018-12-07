/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <AppKit/AppKit.h>

@protocol UIScrollViewDelegate <NSObject>
@optional
- (void)scrollViewDidEndScrollingAnimation:(NSScrollView *)scrollView;
- (void)scrollViewDidScroll:(NSScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(NSScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(NSScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewWillBeginDecelerating:(NSScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(NSScrollView *)scrollView;
- (NSView *)viewForZoomingInScrollView:(NSScrollView *)scrollView;
- (void)scrollViewWillBeginZooming:(NSScrollView *)scrollView withView:(NSView *)view;
- (void)scrollViewDidEndZooming:(NSScrollView *)scrollView withView:(NSView *)view atScale:(float)scale;
- (void)scrollViewDidZoom:(NSScrollView *)scrollView;
- (BOOL)scrollViewShouldScrollToTop:(NSScrollView *)scrollView;
- (void)scrollViewWillEndDragging:(NSScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset;
@end
