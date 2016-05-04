//
//  ShapeView.h
//  TagGroupDemo
//
//  Created by zmw on 16/5/4.
//  Copyright © 2016年 Beijing ChunFengShiLi Technology Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/**

 * * * * *
 --------------- width 50


 * * * * Hello
 *
 *
 *
 *
 *
 *
 *
 * * * * string
 --------------- height 100 width 40

 * * * * Hello
 *
 *
 *
 * * * Hello
 *
 *
 *
 * * * * Hello
 --------------- height 120 width 40 midWidth 30
 kMaxTagGroupTypeRight



  *
    *
      *
        *
          * * * Hello
  --------------- brokenLine 50 width 30

         * * * Hello
       *
     *
   *
  *
   *
     *
       *
         * * * Hello
--------------- brokenLine 50 width 30

         * * * Hello
       *
     *
   *
 * * * * * * * Hello
   *
     *
       *
         * * * Hello
 --------------- brokenLine 50 width 30 midWidth 70
 kMaxTagGroupTypeBrokenRight



 Hello * * * * *
 --------------- width 50

 Hello * * * *
             *
             *
             *
             *
             *
             *
             *
 Hello * * * *
 --------------- height 120 width 40

 Hello * * * *
             *
             *
             *
   Hello * * *
             *
             *
             *
 Hello * * * *
 --------------- height 120 width 40 midWidth 30
 kMaxTagGroupTypeLeft




                  *
                *
              *
            *
Hello * * *
 --------------- brokenLine 50 width 30

 * * * Hello
 *
 *
 *
 *
 *
 *
 *
 * * * Hello
 --------------- brokenLine 50 width 30

 * * * Hello
 *
 *
 *
 * * * * * * * Hello
 *
 *
 *
 * * * Hello
 --------------- brokenLine 50 width 30 midWidth 70

 kMaxTagGroupTypeBrokenLeft

           ************
          *
         *
        *
       * *
      *   *
 ****      ***********
 kMaxTagGroupTypeLeftBottom


 *********
          *
           *
            *
           * *
          *   *
**********     *********
  kMaxTagGroupTypeRightBottom,
 */

typedef enum : NSUInteger {
  kMaxTagGroupTypeDefault = 0,
    
  kMaxTagGroupOneTagTypeRight = 10,
  kMaxTagGroupOneTagTypeLeft,
  kMaxTagGroupOneTagTypeRightBottom,
  kMaxTagGroupOneTagTypeLeftBottom,
    
  kMaxTagGroupTwoTagTypeBrokenRight = 20,
  kMaxTagGroupTypeBrokenBrokenLeft,
  kMaxTagGroupTwoTagTypeRight,
  kMaxTagGroupTwoTagTypeLeft,

  kMaxTagGroupThreeTagTypeLeftBottom = 30,
  kMaxTagGroupThreeTagTypeLeftTop,
  kMaxTagGroupThreeTagTypeRightTop,
  kMaxTagGroupThreeTagTypeRightBottom,
  kMaxTagGroupThreeTagTypeBrokenRight,
  kMaxTagGroupThreeTagTypeBrokenLeft,
  kMaxTagGroupThreeTagTypeRight,
  kMaxTagGroupThreeTagTypeLeft,
} kMaxTagGroupType;

@interface MaxShapeView : UIView

@property(nonatomic, readonly) CAShapeLayer *shapeLayer;

@property(nonatomic, assign) BOOL reverse;
@property(nonatomic, assign) kMaxTagGroupType type;
@property(assign, nonatomic) CGPoint point;        //中心点
@property(strong, nonatomic) NSArray *tagGroup;    //标签数组
@property(strong, nonatomic) NSArray *oneTagGroup; //多的一侧的标签
@property(strong, nonatomic) NSArray *twoTagGroup; //少的一侧的标签

@property(strong, nonatomic) NSMutableArray *tagPointsArry; //点数组

@property(strong, nonatomic) NSMutableArray *animationGroup; //动画数组

@property(nonatomic, copy) void (^longPressBlock)(MaxShapeView *tagView);
@property(nonatomic, copy) void (^tapBlock)(MaxShapeView *tagView, UILabel *tapLabel);
@property(nonatomic, copy) void (^doubleTapBlock)(MaxShapeView *tagView);
@property(nonatomic, copy) void (^dragDoneBlock)(MaxShapeView *tagView);
@property(nonatomic, copy) void (^dragCancelBlock)(MaxShapeView *tagView);

- (id)initWithFrame:(CGRect)frame
              point:(CGPoint)point
           tagGroup:(NSArray *)tagGroup
            tagType:(kMaxTagGroupType)type
         superFrame:(CGRect)superFrame;

- (void)drawLine;

@end
