//
//  MaxLightingView.h
//  TagGroupDemo
//
//  Created by chanli on 16/5/3.
//  Copyright © 2016年 Beijing ChunFengShiLi Technology Co., Ltd. All rights
//  reserved.
//

#import <UIKit/UIKit.h>

@interface MaxLightingView : UIView

/**
 *  初始化 闪烁
 *
 *  @param frame frame
 *  @param times 闪烁次数 1 一直闪烁，0，闪烁一次
 *
 *  @return MaxLightingView
 */
- (id)initWithFrame:(CGRect)frame animationRepeats:(BOOL)repeats;

@property(assign, nonatomic) CGPoint centerPoint;

@end
