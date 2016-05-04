//
//  MaxLightingView.m
//  TagGroupDemo
//
//  Created by chanli on 16/5/3.
//  Copyright © 2016年 Beijing ChunFengShiLi Technology Co., Ltd. All rights
//  reserved.
//

#import "MaxLightingView.h"
#import "NSTimer+Addition.h"

#define kWidthCircle 8

#define kTransformScle 2

#define UIColorRGBA(r, g, b, a)                                                \
  [UIColor colorWithRed:(r) / 255.0                                            \
                  green:(g) / 255.0                                            \
                   blue:(b) / 255.0                                            \
                  alpha:(a)]

@interface MaxLightingView () {
  NSTimer *timerAnimation;
  UIView *viewSpread;
  UIView *viewTapDot;
  UIImageView *viewTapDotImageView;
}

@end

@implementation MaxLightingView

- (id)initWithFrame:(CGRect)frame animationRepeats:(BOOL)repeats {

  if (self = [super initWithFrame:frame]) {

    timerAnimation = [NSTimer
        scheduledTimerWithTimeInterval:3
                                target:self
                              selector:@selector(animationTimerDidFired)
                              userInfo:nil
                               repeats:repeats];

    [self setup];
  }

  return self;
}


- (void)setCenterPoint:(CGPoint)centerPoint {

  _centerPoint = centerPoint;
  [self setFrame:CGRectMake(centerPoint.x - kWidthCircle / 2,
                            centerPoint.y - kWidthCircle / 2, kWidthCircle,
                            kWidthCircle)];
    
    [self setup];
    
}

- (void)setup {

  viewSpread = [self getViewSpread];
  viewSpread.layer.cornerRadius = viewSpread.frame.size.width / 2;
  viewSpread.layer.masksToBounds = YES;
  [self addSubview:viewSpread];
  viewTapDotImageView = [self getViewTapDotImageView];
  [self addSubview:viewTapDotImageView];
  viewSpread.center = viewTapDotImageView.center;
  [timerAnimation resumeTimer];
}

#pragma - mark init

- (UIView *)getViewSpread {
  UIView *view = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, kWidthCircle / 3, kWidthCircle / 3)];
  view.backgroundColor = UIColorRGBA(255, 255, 255, 1);
  view.userInteractionEnabled = NO;
  view.center = self.center;
  return view;
}

- (UIView *)getViewTapDot {
  UIView *view = [UIView new];
  view.backgroundColor = UIColorRGBA(255, 255, 255, 1); //主题颜色;
  view.userInteractionEnabled = NO;
  view.center = self.center;
  return view;
}

- (UIImageView *)getViewTapDotImageView {
  UIImageView *getViewTapDotImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(0, 0, kWidthCircle, kWidthCircle)];
  //     getViewTapDotImageView.center = self.center;

  getViewTapDotImageView.contentMode = UIViewContentModeScaleAspectFit;
  getViewTapDotImageView.image = [UIImage imageNamed:@"camera_color_other"];
  getViewTapDotImageView.userInteractionEnabled = NO;
  return getViewTapDotImageView;
}
#pragma - mark 监听
/**
 *  播放动画
 */
- (void)animationTimerDidFired {
  [UIView animateWithDuration:1
      animations:^{
        viewTapDot.transform = CGAffineTransformMakeScale(1.3 * kTransformScle,
                                                          1.3 * kTransformScle);
      }
      completion:^(BOOL finished) {
        [UIView animateWithDuration:1
            animations:^{
              viewTapDot.transform = CGAffineTransformIdentity;
            }
            completion:^(BOOL finished) {
              viewSpread.alpha = 1;
              [UIView animateWithDuration:1
                  animations:^{
                    viewSpread.alpha = 0;
                    viewSpread.transform = CGAffineTransformMakeScale(
                        kWidthCircle / 2 * kTransformScle,
                        kWidthCircle / 2 * kTransformScle);
                  }
                  completion:^(BOOL finished) {
                    viewSpread.transform = CGAffineTransformIdentity;
                  }];
            }];

      }];
}

@end
