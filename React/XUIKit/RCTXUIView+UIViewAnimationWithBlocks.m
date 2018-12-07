//
//  Taken from https://github.com/BigZaphod/Chameleon/blob/master/UIKit/Classes/UIViewAnimationGroup.m

#import "RCTXUIView+UIViewAnimationWithBlocks.h"
#import <QuartzCore/QuartzCore.h>

static NSMutableSet *runningAnimationGroups = nil;

static CAMediaTimingFunction *CAMediaTimingFunctionFromUIViewAnimationCurve(UIViewAnimationCurve curve)
{
  switch (curve) {
    case UIViewAnimationCurveEaseInOut:	return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    case UIViewAnimationCurveEaseIn:	return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    case UIViewAnimationCurveEaseOut:	return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    case UIViewAnimationCurveLinear:	return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
  }
  return nil;
}


BOOL UIViewAnimationOptionIsSet(UIViewAnimationOptions options, UIViewAnimationOptions option)
{
  return ((options & option) == option);
}

static inline UIViewAnimationOptions UIViewAnimationOptionCurve(UIViewAnimationOptions options)
{
  return (options & (UIViewAnimationOptionCurveEaseInOut
                     | UIViewAnimationOptionCurveEaseIn
                     | UIViewAnimationOptionCurveEaseOut
                     | UIViewAnimationOptionCurveLinear));
}


static inline UIViewAnimationOptions UIViewAnimationOptionTransition(UIViewAnimationOptions options)
{
  return (options & (UIViewAnimationOptionTransitionNone
                     | UIViewAnimationOptionTransitionFlipFromLeft
                     | UIViewAnimationOptionTransitionFlipFromRight
                     | UIViewAnimationOptionTransitionCurlUp
                     | UIViewAnimationOptionTransitionCurlDown
                     | UIViewAnimationOptionTransitionCrossDissolve
                     | UIViewAnimationOptionTransitionFlipFromTop
                     | UIViewAnimationOptionTransitionFlipFromBottom));
}


@implementation UIViewAnimationGroup
{
  NSUInteger _waitingAnimations;
  BOOL _didStart;
  CFTimeInterval _animationBeginTime;
  RCTXUIView *_transitionView;
  BOOL _transitionShouldCache;
  NSMutableSet *_animatingViews;
}

- (id)initWithAnimationOptions:(UIViewAnimationOptions)options
{
  if ((self=[super init])) {
    _waitingAnimations = 1;
    _animationBeginTime = CACurrentMediaTime();
    _animatingViews = [NSMutableSet setWithCapacity:2];

    self.duration = 200;

    self.repeatCount = UIViewAnimationOptionIsSet(options, UIViewAnimationOptionRepeat)? FLT_MAX : 0;
    self.allowUserInteraction = UIViewAnimationOptionIsSet(options, UIViewAnimationOptionAllowUserInteraction);
    self.repeatAutoreverses = UIViewAnimationOptionIsSet(options, UIViewAnimationOptionAutoreverse);
    self.beginsFromCurrentState = UIViewAnimationOptionIsSet(options, UIViewAnimationOptionBeginFromCurrentState);

    const UIViewAnimationOptions animationCurve = UIViewAnimationOptionCurve(options);
    if (animationCurve == UIViewAnimationOptionCurveEaseIn) {
      self.curve = UIViewAnimationCurveEaseIn;
    } else if (animationCurve == UIViewAnimationOptionCurveEaseOut) {
      self.curve = UIViewAnimationCurveEaseOut;
    } else if (animationCurve == UIViewAnimationOptionCurveLinear) {
      self.curve = UIViewAnimationCurveLinear;
    } else {
      self.curve = UIViewAnimationCurveEaseInOut;
    }

    const UIViewAnimationOptions animationTransition = UIViewAnimationOptionTransition(options);
    if (animationTransition == UIViewAnimationOptionTransitionFlipFromLeft) {
      self.transition = UIViewAnimationGroupTransitionFlipFromLeft;
    } else if (animationTransition == UIViewAnimationOptionTransitionFlipFromRight) {
      self.transition = UIViewAnimationGroupTransitionFlipFromRight;
    } else if (animationTransition == UIViewAnimationOptionTransitionCurlUp) {
      self.transition = UIViewAnimationGroupTransitionCurlUp;
    } else if (animationTransition == UIViewAnimationOptionTransitionCurlDown) {
      self.transition = UIViewAnimationGroupTransitionCurlDown;
    } else if (animationTransition == UIViewAnimationOptionTransitionCrossDissolve) {
      self.transition = UIViewAnimationGroupTransitionCrossDissolve;
    } else if (animationTransition == UIViewAnimationOptionTransitionFlipFromTop) {
      self.transition = UIViewAnimationGroupTransitionFlipFromTop;
    } else if (animationTransition == UIViewAnimationOptionTransitionFlipFromBottom) {
      self.transition = UIViewAnimationGroupTransitionFlipFromBottom;
    } else {
      self.transition = UIViewAnimationGroupTransitionNone;
    }
  }
  return self;
}

- (void)notifyAnimationsDidStartIfNeeded
{
  if (!_didStart) {
    _didStart = YES;

    @synchronized(runningAnimationGroups) {
      [runningAnimationGroups addObject:self];
    }

    if ([self.delegate respondsToSelector:self.willStartSelector]) {
      typedef void(*WillStartMethod)(id, SEL, NSString *, void *);
      WillStartMethod method = (WillStartMethod)[self.delegate methodForSelector:self.willStartSelector];
      method(self.delegate, self.willStartSelector, self.name, self.context);
    }
  }
}

- (void)animationDidStart:(CAAnimation *)theAnimation
{
  NSAssert([NSThread isMainThread], @"expecting this to be on the main thread");

  [self notifyAnimationsDidStartIfNeeded];
}

- (void)notifyAnimationsDidStopIfNeededUsingStatus:(BOOL)animationsDidFinish
{
  if (_waitingAnimations == 0) {
    if ([self.delegate respondsToSelector:self.didStopSelector]) {
      NSNumber *finishedArgument = [NSNumber numberWithBool:animationsDidFinish];
      typedef void(*DidFinishMethod)(id, SEL, NSString *, NSNumber *, void *);
      DidFinishMethod method = (DidFinishMethod)[self.delegate methodForSelector:self.didStopSelector];
      method(self.delegate, self.didStopSelector, self.name, finishedArgument, self.context);
    }

    if (self.completionBlock) {
      self.completionBlock(animationsDidFinish);
    }

    @synchronized(runningAnimationGroups) {
      [_animatingViews removeAllObjects];
      [runningAnimationGroups removeObject:self];
    }
  }
}

- (void)setTransitionView:(RCTXUIView *)view shouldCache:(BOOL)cache
{
  _transitionView = view;
  _transitionShouldCache = cache;
}

- (void)animationDidStop:(__unused CAAnimation *)theAnimation finished:(BOOL)flag
{
  NSAssert([NSThread isMainThread], @"expecting this to be on the main thread");

  _waitingAnimations--;
  [self notifyAnimationsDidStopIfNeededUsingStatus:flag];}

- (CAAnimation *)addAnimation:(CAAnimation *)animation
{
  animation.timingFunction = CAMediaTimingFunctionFromUIViewAnimationCurve(self.curve);
  animation.duration = self.duration;
  animation.beginTime = _animationBeginTime + self.delay;
  animation.repeatCount = self.repeatCount;
  animation.autoreverses = self.repeatAutoreverses;
  animation.fillMode = kCAFillModeBackwards;
  animation.delegate = self;
  animation.removedOnCompletion = YES;
  _waitingAnimations++;
  return animation;
}

- (id)actionForView:(RCTXUIView *)view forKey:(NSString *)keyPath
{
  @synchronized(runningAnimationGroups) {
    [_animatingViews addObject:view];
  }

  if (_transitionView && self.transition != UIViewAnimationGroupTransitionNone) {
    return nil;
  } else {
    CALayer *layer = view.layer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = self.beginsFromCurrentState? [layer.presentationLayer valueForKey:keyPath] : [layer valueForKey:keyPath];
    return [self addAnimation:animation];
  }
}

- (void)commit
{
  if (_transitionView && self.transition != UIViewAnimationGroupTransitionNone) {
    CATransition *trans = [CATransition animation];

    switch (self.transition) {
      case UIViewAnimationGroupTransitionFlipFromLeft:
        trans.type = kCATransitionPush;
        trans.subtype = kCATransitionFromLeft;
        break;

      case UIViewAnimationGroupTransitionFlipFromRight:
        trans.type = kCATransitionPush;
        trans.subtype = kCATransitionFromRight;
        break;

      case UIViewAnimationGroupTransitionFlipFromTop:
        trans.type = kCATransitionPush;
        trans.subtype = kCATransitionFromTop;
        break;

      case UIViewAnimationGroupTransitionFlipFromBottom:
        trans.type = kCATransitionPush;
        trans.subtype = kCATransitionFromBottom;
        break;

      case UIViewAnimationGroupTransitionCurlUp:
        trans.type = kCATransitionReveal;
        trans.subtype = kCATransitionFromTop;
        break;

      case UIViewAnimationGroupTransitionCurlDown:
        trans.type = kCATransitionReveal;
        trans.subtype = kCATransitionFromBottom;
        break;

      case UIViewAnimationGroupTransitionCrossDissolve:
      default:
        trans.type = kCATransitionFade;
        break;
    }

    [_animatingViews addObject:_transitionView];
    [_transitionView.layer addAnimation:[self addAnimation:trans] forKey:kCATransition];
  }

  _waitingAnimations--;
  [self notifyAnimationsDidStopIfNeededUsingStatus:YES];
}

@end


static NSMutableArray *_animationGroups;
static BOOL _animationsEnabled = YES;

@implementation RCTXUIViewBlockAnimationDelegate
@synthesize completion=_completion, ignoreInteractionEvents=_ignoreInteractionEvents;


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished
{
  if (_completion) {
    _completion([finished boolValue]);
  }

  if (_ignoreInteractionEvents) {

  }
}

@end

@implementation RCTXUIView (UIViewAnimationWithBlocks)

+ (void)animateWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
  if (!_animationGroups) {
    _animationGroups = [[NSMutableArray alloc] init];
  }
  [self _beginAnimationsWithOptions:options | UIViewAnimationOptionTransitionNone];
  [self setAnimationDuration:duration];
  [self setAnimationDelay:delay];
  [self _setAnimationCompletionBlock:completion];

  animations();

  [self commitAnimations];
}

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
  [self animateWithDuration:duration
                      delay:0
                    options:UIViewAnimationOptionCurveEaseInOut
                 animations:animations
                 completion:completion];
}

+ (void)animateWithDuration:(NSTimeInterval)duration animations:(void (^)(void))animations
{
  [self animateWithDuration:duration animations:animations completion:NULL];
}

+ (void)animateWithDuration:(NSTimeInterval)duration
                      delay:(NSTimeInterval)delay
     usingSpringWithDamping:(CGFloat)dampingRatio
      initialSpringVelocity:(CGFloat)velocity
                    options:(UIViewAnimationOptions)options
                 animations:(void (^)(void))animations
                 completion:(void (^ __nullable)(BOOL finished))completion
{
  // |dampingRatio| and |velocity| not supported
  // TODO(kudo): CASpringAnimation
  [self animateWithDuration:duration
                      delay:delay
                    options:options
                 animations:animations
                 completion:completion];
}

//+ (void)beginAnimations:(NSString *)animationID context:(void *)context
//{
//    [_animationGroups addObject:[UIViewAnimationGroup animationGroupWithName:animationID context:context]];
//}

+ (void)commitAnimations
{
  if ([_animationGroups count] > 0) {
    [[_animationGroups lastObject] commit];
    [_animationGroups removeLastObject];
  }
}

+ (void)setAnimationBeginsFromCurrentState:(BOOL)beginFromCurrentState
{
  [[_animationGroups lastObject] setBeginsFromCurrentState:beginFromCurrentState];
}

+ (void)setAnimationCurve:(UIViewAnimationCurve)curve
{
  [[_animationGroups lastObject] setCurve:curve];
}

+ (void)setAnimationDelay:(NSTimeInterval)delay
{
  [[_animationGroups lastObject] setDelay:delay];
}

+ (void)setAnimationDelegate:(id)delegate
{
  [[_animationGroups lastObject] setDelegate:delegate];
}

+ (void)setAnimationDidStopSelector:(SEL)selector
{
  [[_animationGroups lastObject] setDidStopSelector:selector];
}

+ (void)setAnimationDuration:(NSTimeInterval)duration
{
  [[_animationGroups lastObject] setDuration:duration];
}

+ (void)setAnimationRepeatAutoreverses:(BOOL)repeatAutoreverses
{
  [[_animationGroups lastObject] setRepeatAutoreverses:repeatAutoreverses];
}

+ (void)setAnimationRepeatCount:(float)repeatCount
{
  [[_animationGroups lastObject] setRepeatCount:repeatCount];
}

+ (void)setAnimationWillStartSelector:(SEL)selector
{
  [[_animationGroups lastObject] setAnimationWillStartSelector:selector];
}

+ (void)_setAnimationTransitionView:(RCTXUIView *)view
{
  [[_animationGroups lastObject] setTransitionView:view shouldCache:NO];
}

+ (void)_setAnimationCompletionBlock:(void (^)(BOOL finished))completion
{
  [(UIViewAnimationGroup *)[_animationGroups lastObject] setCompletionBlock:completion];
}

+ (void)_beginAnimationsWithOptions:(UIViewAnimationOptions)options
{
  UIViewAnimationGroup *group = [[UIViewAnimationGroup alloc] initWithAnimationOptions:options];
  [_animationGroups addObject:group];
}

+ (void)transitionWithView:(RCTXUIView *)view duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options animations:(void (^)(void))animations completion:(void (^)(BOOL finished))completion
{
  [self _beginAnimationsWithOptions:options];
  [self setAnimationDuration:duration];
  [self _setAnimationCompletionBlock:completion];
  [self _setAnimationTransitionView:view];

  if (animations) {
    animations();
  }

  [self commitAnimations];
}

+ (void)transitionFromView:(RCTXUIView *)fromView toView:(RCTXUIView *)toView duration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion
{
  [self transitionWithView:fromView.superview
                  duration:duration
                   options:options
                animations:^{
                  if (UIViewAnimationOptionIsSet(options, UIViewAnimationOptionShowHideTransitionViews)) {
                    fromView.hidden = YES;
                    toView.hidden = NO;
                  } else {
                    [fromView.superview addSubview:toView];
                    [fromView removeFromSuperview];
                  }
                }
                completion:completion];
}

+ (void)setAnimationTransition:(UIViewAnimationTransition)transition forView:(RCTXUIView *)view cache:(BOOL)cache
{
  [self _setAnimationTransitionView:view];

  switch (transition) {
    case UIViewAnimationTransitionNone:
      [[_animationGroups lastObject] setTransition:UIViewAnimationGroupTransitionNone];
      break;

    case UIViewAnimationTransitionFlipFromLeft:
      [[_animationGroups lastObject] setTransition:UIViewAnimationGroupTransitionFlipFromLeft];
      break;

    case UIViewAnimationTransitionFlipFromRight:
      [[_animationGroups lastObject] setTransition:UIViewAnimationGroupTransitionFlipFromRight];
      break;

    case UIViewAnimationTransitionCurlUp:
      [[_animationGroups lastObject] setTransition:UIViewAnimationGroupTransitionCurlUp];
      break;

    case UIViewAnimationTransitionCurlDown:
      [[_animationGroups lastObject] setTransition:UIViewAnimationGroupTransitionCurlDown];
      break;
  }
}

- (id)actionForLayer:(CALayer *)theLayer forKey:(NSString *)event
{
  if (_animationsEnabled && [_animationGroups lastObject] && theLayer == _layer) {
    return [[_animationGroups lastObject] actionForView:self forKey:event] ?: (id)[NSNull null];
  } else {
    return [NSNull null];
  }
}


+ (BOOL)areAnimationsEnabled
{
  return _animationsEnabled;
}

+ (void)setAnimationsEnabled:(BOOL)enabled
{
  _animationsEnabled = enabled;
}

@end
