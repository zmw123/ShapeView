//
//  ShapeView.m
//  TagGroupDemo
//
//  Created by zmw on 16/5/4.
//  Copyright © 2016年 Beijing ChunFengShiLi Technology Co., Ltd. All rights reserved.
//

#import "MaxLightingView.h"
#import "MaxShapeView.h"
#import "NSString+SizeWithFont.h"
//
#define kHeight50DPDistance 25
#define kHegiht60DPDistance 30

#define kSlash30DPLineWidth 15
#define kSlash40DPLineWidth 20
#define kSlash50DPLineWidth 25
#define kSlash70DPLineWidth 35

#define kLabelHeight 25
#define kTheLeftIndex 1
#define kLineValue 1

#define kWithePointWidth 6

#define kBaseTag 2000

#define ktagColor [UIColor whiteColor]

@interface MaxShapeView () {
    UILongPressGestureRecognizer *_longPressGestureRecognizer;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UITapGestureRecognizer *_label0TapGestureRecognizer;
    UITapGestureRecognizer *_label1TapGestureRecognizer;
    UITapGestureRecognizer *_label2TapGestureRecognizer;
    BOOL _isDragging;
    
    CAShapeLayer *_lineLayer0;
    CAShapeLayer *_linePoint0;
    CAShapeLayer *_lineLayer1;
    CAShapeLayer *_linePoint1;
    CAShapeLayer *_lineLayer2;
    CAShapeLayer *_linePoint2;
    
    UILabel *_lineLabel0;
    UILabel *_lineLabel1;
    UILabel *_lineLabel2;
    
    CGRect _superFrame;
}

@property(strong, nonatomic) MaxLightingView *lightingView;
@property(assign, nonatomic) CGPoint beginpoint;

@end

@implementation MaxShapeView

+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (MaxLightingView *)lightingView {
    
    if (!_lightingView)
    {
        _lightingView =
        [[MaxLightingView alloc] initWithFrame:CGRectZero animationRepeats:YES];
        
        [self addSubview:_lightingView];
    }
    return _lightingView;
}

- (id)initWithFrame:(CGRect)frame
              point:(CGPoint)point
           tagGroup:(NSArray *)tagGroup
            tagType:(kMaxTagGroupType)type
         superFrame:(CGRect)superFrame {
    if (self = [super initWithFrame:frame]) {
        _superFrame = superFrame;
        self.type = type;
        
        if (type == kMaxTagGroupTypeDefault) {
            
            if (tagGroup.count == 1) {
                self.type = kMaxTagGroupOneTagTypeRight;
            } else if (tagGroup.count == 2) {
                self.type = kMaxTagGroupTwoTagTypeBrokenRight;
            } else if (tagGroup.count == 3) {
                self.type = kMaxTagGroupThreeTagTypeLeftBottom;
            }
        }
        
        self.opaque = NO;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.reverse = NO;
        self.point = point;
        self.tagGroup = tagGroup;
        self.tagPointsArry = [NSMutableArray arrayWithCapacity:self.tagGroup.count];
        self.animationGroup =
        [NSMutableArray arrayWithCapacity:self.tagGroup.count];
        
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
        [_longPressGestureRecognizer addTarget:self
                                        action:@selector(gestureRecognizerHandle:)];
        [_longPressGestureRecognizer setAllowableMovement:0];
        [self addGestureRecognizer:_longPressGestureRecognizer];
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
        [_tapGestureRecognizer addTarget:self
                                  action:@selector(gestureRecognizerHandle:)];
        [self addGestureRecognizer:_tapGestureRecognizer];
        
        [self drawLine];
    }
    
    return self;
}

- (void)drawLine {
    if (self.tagGroup.count == 1) {
        [self drawLineOne];
    } else if (self.tagGroup.count == 2) {
        [self drawLineTwo];
    } else {
        [self drawLineThree];
    }
}

- (void)drawLineOne {
    
    CGPoint point = CGPointMake(0, kLabelHeight / 2);
    //添加 文字显示
    CGFloat lineWidth = [NSString widthWithAttributes:nil text:self.tagGroup[0]];
    NSMutableDictionary *tagPointsArry =
    [NSMutableDictionary dictionaryWithCapacity:self.tagGroup.count];
    
    if (self.type == kMaxTagGroupOneTagTypeRight) {
        
        point = CGPointMake(0, kLabelHeight / 2);
        
        self.frame = CGRectMake(self.point.x, self.point.y,
                                lineWidth + kSlash50DPLineWidth, kLabelHeight);
        
        NSMutableArray *lineBranch = [NSMutableArray
                                      arrayWithObjects:[NSValue valueWithCGPoint:point],
                                      [NSValue
                                       valueWithCGPoint:CGPointMake(
                                                                    point.x + kSlash50DPLineWidth,
                                                                    point.y)],
                                      nil];
        [tagPointsArry setObject:lineBranch forKey:@(0)];
    } else if (self.type == kMaxTagGroupOneTagTypeLeft) {
        
        point = CGPointMake(lineWidth + kSlash50DPLineWidth, kLabelHeight / 2);
        
        self.frame = CGRectMake(self.point.x - lineWidth, self.point.y,
                                lineWidth + kSlash50DPLineWidth, kLabelHeight);
        NSMutableArray *lineBranch = [NSMutableArray
                                      arrayWithObjects:[NSValue valueWithCGPoint:point],
                                      [NSValue
                                       valueWithCGPoint:CGPointMake(
                                                                    point.x - kSlash50DPLineWidth,
                                                                    point.y)],
                                      nil];
        [tagPointsArry setObject:lineBranch forKey:@(0)];
    } else if (self.type == kMaxTagGroupOneTagTypeLeftBottom) {
        self.frame = CGRectMake(
                                self.point.x - (kSlash50DPLineWidth + lineWidth + kSlash30DPLineWidth),
                                self.point.y, lineWidth + kSlash50DPLineWidth + kSlash30DPLineWidth,
                                kHeight50DPDistance + kLabelHeight / 2);
        
        point = CGPointMake(CGRectGetWidth(self.frame), 0);
        
        NSMutableArray *lineBranch = [NSMutableArray
                                      arrayWithObjects:[NSValue valueWithCGPoint:point],
                                      [NSValue
                                       valueWithCGPoint:CGPointMake(
                                                                    point.x - kSlash50DPLineWidth,
                                                                    point.y +
                                                                    kHeight50DPDistance)],
                                      [NSValue
                                       valueWithCGPoint:CGPointMake(
                                                                    point.x -
                                                                    kSlash50DPLineWidth -
                                                                    kSlash30DPLineWidth,
                                                                    point.y +
                                                                    kHeight50DPDistance)],
                                      nil];
        [tagPointsArry setObject:lineBranch forKey:@(0)];
    } else if (self.type == kMaxTagGroupOneTagTypeRightBottom) {
        self.frame =
        CGRectMake(self.point.x, self.point.y,
                   lineWidth + kSlash50DPLineWidth + kSlash30DPLineWidth,
                   kHeight50DPDistance + kLabelHeight / 2);
        point = CGPointMake(0, 0);
        NSMutableArray *lineBranch = [NSMutableArray
                                      arrayWithObjects:[NSValue valueWithCGPoint:point],
                                      [NSValue
                                       valueWithCGPoint:CGPointMake(
                                                                    point.x + kSlash50DPLineWidth,
                                                                    point.y +
                                                                    kHeight50DPDistance)],
                                      [NSValue
                                       valueWithCGPoint:CGPointMake(
                                                                    point.x +
                                                                    kSlash50DPLineWidth +
                                                                    kSlash30DPLineWidth,
                                                                    point.y +
                                                                    kHeight50DPDistance)],
                                      nil];
        [tagPointsArry setObject:lineBranch forKey:@(0)];
    }
    
    self.lightingView.frame = CGRectMake(0, 0, 30.f, 30.f);
    self.lightingView.centerPoint = point;
    
    if (self.frame.origin.x < 0) {
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width,
                                self.frame.size.height);
    }
    
    if (self.frame.origin.y < 0) {
        self.frame = CGRectMake(self.frame.origin.x, 0, self.frame.size.width,
                                self.frame.size.height);
    }
    if (CGRectGetMaxX(self.frame) > _superFrame.size.width) {
        self.frame = CGRectMake(_superFrame.size.width - self.frame.size.width,
                                self.frame.origin.y, self.frame.size.width,
                                self.frame.size.height);
    }
    
    if (CGRectGetMaxY(self.frame) > _superFrame.size.height) {
        self.frame = CGRectMake(self.frame.origin.x,
                                _superFrame.size.height - self.frame.size.height,
                                self.frame.size.width, self.frame.size.height);
    }
    
    [tagPointsArry enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key,
                                                       NSArray *_Nonnull points,
                                                       BOOL *_Nonnull stop) {
        
        NSInteger idx = [key integerValue];
        CGPoint lastPoint = [[points lastObject] CGPointValue];
        
        CAShapeLayer *lineLayer = nil;
        CAShapeLayer *linePoint = nil;
        UILabel *textlabel = nil;
        
        if (!_lineLayer0) {
            _lineLabel0 = [[UILabel alloc] init];
            _lineLayer0 = [CAShapeLayer layer];
            [self.layer addSublayer:_lineLayer0];
            [self addSubview:_lineLabel0];
            
            _label0TapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
            [_label0TapGestureRecognizer addTarget:self
                                            action:@selector(gestureRecognizerHandle:)];
            _lineLabel0.userInteractionEnabled = YES;
            [_lineLabel0 addGestureRecognizer:_label0TapGestureRecognizer];
            _linePoint0 = [self whiteLayer];
            [_lineLayer0 addSublayer:_linePoint0];
        }
        lineLayer = _lineLayer0;
        textlabel = _lineLabel0;
        linePoint = _linePoint0;
        {
            if (_lineLayer1) {
                [_lineLayer1 removeFromSuperlayer];
                _lineLayer1 = nil;
                [_linePoint1 removeFromSuperlayer];
                _linePoint1 = nil;
                [_lineLabel1 removeFromSuperview];
                _lineLabel1 = nil;
            }
            if (_lineLayer2) {
                [_lineLayer2 removeFromSuperlayer];
                _lineLayer2 = nil;
                [_linePoint2 removeFromSuperlayer];
                _linePoint2 = nil;
                [_lineLabel2 removeFromSuperview];
                _lineLabel2 = nil;
            }
        }
        
        //清空面板
        lineLayer.path = nil;
        textlabel.frame = CGRectZero;
        lineLayer.strokeColor = ktagColor.CGColor;
        textlabel.text = nil;
        textlabel.textColor = ktagColor;
        textlabel.textAlignment = NSTextAlignmentCenter;
        // 指定frame，只是为了设置宽度和高度
        // 设置居中显示
        // 设置填充颜色
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        // 设置线宽
        lineLayer.lineWidth = kLineValue;
        
        // 使用UIBezierPath创建路径
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        
        [points enumerateObjectsUsingBlock:^(NSValue *_Nonnull pointNumber,
                                             NSUInteger idx, BOOL *_Nonnull stop) {
            
            CGPoint point = pointNumber.CGPointValue;
            if (idx == 0) {
                [linePath moveToPoint:point];
            } else {
                [linePath addLineToPoint:point];
            }
            
        }];
        
        // 设置CAShapeLayer与UIBezierPath关联
        lineLayer.path = linePath.CGPath;
        
        //创建动画
        CABasicAnimation *animation = [CABasicAnimation
                                       animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
        animation.fromValue = @0.0;
        animation.toValue = @1.0;
        animation.delegate = self;
        animation.duration = 0.8;
        
        [lineLayer addAnimation:animation forKey:nil];
        
        linePoint.hidden = YES;
        linePoint.frame = CGRectMake(0, 0, 6.f, 6.f);
        NSValue *point = [points lastObject];
        linePoint.position = point.CGPointValue;
        
        //添加 文字显示
        switch (self.type) {
            case kMaxTagGroupOneTagTypeRight:
            case kMaxTagGroupOneTagTypeRightBottom: {
                [textlabel
                 setFrame:CGRectMake(lastPoint.x + kWithePointWidth, lastPoint.y - kLabelHeight / 2,
                                     lineWidth - kWithePointWidth, kLabelHeight)];
            } break;
            case kMaxTagGroupOneTagTypeLeft:
            case kMaxTagGroupOneTagTypeLeftBottom: {
                [textlabel setFrame:CGRectMake(lastPoint.x - lineWidth,
                                               lastPoint.y - kLabelHeight / 2, lineWidth - kWithePointWidth,
                                               kLabelHeight)];
            } break;
            default:
                break;
        }
        
        textlabel.text = self.tagGroup[idx];
        textlabel.font = [UIFont systemFontOfSize:13];
        textlabel.hidden = YES;
    }];
}

- (void)drawLineTwo {
    
    CGPoint point = CGPointMake(0, 0);
    //添加 文字显示
    CGFloat maxLength = [NSString maxestWidthWithStringArray:self.tagGroup];
    NSMutableDictionary *tagPointsArry =
    [NSMutableDictionary dictionaryWithCapacity:self.tagGroup.count];
    
    if (self.type == kMaxTagGroupTwoTagTypeBrokenRight) {
        //这里需要考虑右侧是不是在父视图外侧，这个时候要整体往左侧移动，但是可能存在左侧移除父视图的外部(要定义规则)
        
        self.frame = CGRectMake(
                                self.point.x, self.point.y - kHeight50DPDistance + kLabelHeight / 2,
                                kSlash50DPLineWidth + kSlash30DPLineWidth + maxLength,
                                2 * kHeight50DPDistance + kLabelHeight);
        
        point = CGPointMake(0, CGRectGetHeight(self.frame) / 2);
        for (int idx = 0; idx < self.tagGroup.count; idx++) {
            //      CGFloat lineWidth =
            //          [NSString widthWithAttributes:nil text:self.tagGroup[idx]];
            NSMutableArray *lineBranch;
            switch (idx) {
                case 0: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth,
                                                                        point.y - kHeight50DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth +
                                                                        kSlash30DPLineWidth,
                                                                        point.y - kHeight50DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(0)];
                } break;
                case 1: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth,
                                                                        point.y + kHeight50DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth +
                                                                        kSlash30DPLineWidth,
                                                                        point.y + kHeight50DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(1)];
                } break;
            }
        }
    } else if (self.type == kMaxTagGroupTypeBrokenBrokenLeft) {
        
        //这里要考虑左侧是不是在父视图的外侧，这个时候要整体往右侧移动，但是这个时候可能存在右侧在父视图的外部
        self.frame = CGRectMake(
                                self.point.x - maxLength - kSlash50DPLineWidth - kSlash30DPLineWidth,
                                self.point.y - kHeight50DPDistance - kLabelHeight / 2,
                                kSlash50DPLineWidth + kSlash30DPLineWidth + maxLength,
                                2 * kHeight50DPDistance + kLabelHeight);
        
        point = CGPointMake(CGRectGetWidth(self.frame),
                            CGRectGetHeight(self.frame) / 2);
        
        for (int idx = 0; idx < self.tagGroup.count; idx++) {
            NSMutableArray *lineBranch;
            switch (idx) {
                case 0: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth,
                                                                        point.y - kHeight50DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth -
                                                                        kSlash30DPLineWidth,
                                                                        point.y - kHeight50DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(0)];
                } break;
                case 1: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth,
                                                                        point.y + kHeight50DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth -
                                                                        kSlash30DPLineWidth,
                                                                        point.y + kHeight50DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(1)];
                } break;
            }
        }
    } else if (self.type == kMaxTagGroupTwoTagTypeRight) {
        //这里需要考虑右侧是不是在父视图外侧，这个时候要整体往左侧移动，但是可能存在左侧移除父视图的外部(要定义规则)
        
        self.frame = CGRectMake(self.point.x, self.point.y - kSlash40DPLineWidth +
                                kLabelHeight / 2,
                                kSlash40DPLineWidth + maxLength,
                                2 * kHeight50DPDistance + kLabelHeight);
        
        point = CGPointMake(0, CGRectGetHeight(self.frame) / 2);
        for (int idx = 0; idx < self.tagGroup.count; idx++) {
            //      CGFloat lineWidth =
            //          [NSString widthWithAttributes:nil text:self.tagGroup[idx]];
            NSMutableArray *lineBranch;
            switch (idx) {
                case 0: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:[NSValue valueWithCGPoint:point],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(
                                                                point.x,
                                                                point.y -
                                                                kHeight50DPDistance)],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(
                                                                point.x +
                                                                kSlash40DPLineWidth,
                                                                point.y -
                                                                kHeight50DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(0)];
                } break;
                case 1: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:[NSValue valueWithCGPoint:point],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(
                                                                point.x,
                                                                point.y +
                                                                kHeight50DPDistance)],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(
                                                                point.x +
                                                                kSlash40DPLineWidth,
                                                                point.y +
                                                                kHeight50DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(1)];
                } break;
            }
        }
    } else if (self.type == kMaxTagGroupTwoTagTypeLeft) {
        //这里需要考虑右侧是不是在父视图外侧，这个时候要整体往左侧移动，但是可能存在左侧移除父视图的外部(要定义规则)
        
        self.frame =
        CGRectMake(self.point.x - (kSlash40DPLineWidth + maxLength),
                   self.point.y - kHeight50DPDistance + kLabelHeight / 2,
                   kSlash40DPLineWidth + maxLength,
                   2 * kHeight50DPDistance + kLabelHeight);
        
        point = CGPointMake(CGRectGetWidth(self.frame),
                            CGRectGetHeight(self.frame) / 2);
        for (int idx = 0; idx < self.tagGroup.count; idx++) {
            
            NSMutableArray *lineBranch;
            switch (idx) {
                case 0: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:[NSValue valueWithCGPoint:point],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(
                                                                point.x,
                                                                point.y -
                                                                kHeight50DPDistance)],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(
                                                                point.x -
                                                                kSlash40DPLineWidth,
                                                                point.y -
                                                                kHeight50DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(0)];
                } break;
                case 1: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:[NSValue valueWithCGPoint:point],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(
                                                                point.x,
                                                                point.y +
                                                                kHeight50DPDistance)],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(
                                                                point.x -
                                                                kSlash40DPLineWidth,
                                                                point.y +
                                                                kHeight50DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(1)];
                } break;
            }
        }
    }
    
    self.lightingView.centerPoint = point;
    
    if (self.frame.origin.x < 0) {
        self.frame = CGRectMake(0, self.frame.origin.y, self.frame.size.width,
                                self.frame.size.height);
    }
    
    if (self.frame.origin.y < 0) {
        self.frame = CGRectMake(self.frame.origin.x, 0, self.frame.size.width,
                                self.frame.size.height);
    }
    if (CGRectGetMaxX(self.frame) > _superFrame.size.width) {
        self.frame = CGRectMake(_superFrame.size.width - self.frame.size.width,
                                self.frame.origin.y, self.frame.size.width,
                                self.frame.size.height);
    }
    
    if (CGRectGetMaxY(self.frame) > _superFrame.size.height) {
        self.frame = CGRectMake(self.frame.origin.x,
                                _superFrame.size.height - self.frame.size.height,
                                self.frame.size.width, self.frame.size.height);
    }
    
    [tagPointsArry enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key,
                                                       NSArray *_Nonnull points,
                                                       BOOL *_Nonnull stop) {
        
        NSInteger idx = [key integerValue];
        NSInteger currentTagIndex = 0;
        CGPoint lastPoint = [[points lastObject] CGPointValue];
        
        CAShapeLayer *lineLayer = nil;
        CAShapeLayer *linePoint = nil;
        UILabel *textlabel = nil;
        switch (idx) {
            case 0: {
                if (!_lineLayer0) {
                    _lineLabel0 = [[UILabel alloc] init];
                    _lineLayer0 = [CAShapeLayer layer];
                    [self.layer addSublayer:_lineLayer0];
                    [self addSubview:_lineLabel0];
                    
                    _label0TapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
                    [_label0TapGestureRecognizer addTarget:self
                                                    action:@selector(gestureRecognizerHandle:)];
                    _lineLabel0.userInteractionEnabled = YES;
                    [_lineLabel0 addGestureRecognizer:_label0TapGestureRecognizer];
                    _linePoint0 = [self whiteLayer];
                    [_lineLayer0 addSublayer:_linePoint0];
                }
                lineLayer = _lineLayer0;
                linePoint = _linePoint0;
                textlabel = _lineLabel0;
                currentTagIndex = 0;
            } break;
            case 1: {
                if (!_lineLayer1) {
                    _lineLabel1 = [[UILabel alloc] init];
                    _lineLayer1 = [CAShapeLayer layer];
                    [self.layer addSublayer:_lineLayer1];
                    [self addSubview:_lineLabel1];
                    
                    _label1TapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
                    [_label1TapGestureRecognizer addTarget:self
                                                    action:@selector(gestureRecognizerHandle:)];
                    _lineLabel1.userInteractionEnabled = YES;
                    [_lineLabel1 addGestureRecognizer:_label1TapGestureRecognizer];
                    
                    _linePoint1 = [self whiteLayer];
                    [_lineLayer1 addSublayer:_linePoint1];
                }
                lineLayer = _lineLayer1;
                linePoint = _linePoint1;
                textlabel = _lineLabel1;
                currentTagIndex = 1;
            } break;
            default:
                lineLayer = [CAShapeLayer layer];
                break;
        }
        
        //清空面板
        lineLayer.path = nil;
        textlabel.frame = CGRectZero;
        lineLayer.strokeColor = ktagColor.CGColor;
        textlabel.text = nil;
        textlabel.textColor = ktagColor;
        textlabel.textAlignment = NSTextAlignmentCenter;
        // 指定frame，只是为了设置宽度和高度
        // 设置居中显示
        // 设置填充颜色
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        // 设置线宽
        lineLayer.lineWidth = kLineValue;
        
        // 使用UIBezierPath创建路径
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        
        [points enumerateObjectsUsingBlock:^(NSValue *_Nonnull pointNumber,
                                             NSUInteger idx, BOOL *_Nonnull stop) {
            
            CGPoint point = pointNumber.CGPointValue;
            if (idx == 0) {
                [linePath moveToPoint:point];
            } else {
                [linePath addLineToPoint:point];
            }
            
        }];
        
        // 设置CAShapeLayer与UIBezierPath关联
        lineLayer.path = linePath.CGPath;
        
        //创建动画
        CABasicAnimation *animation = [CABasicAnimation
                                       animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
        animation.fromValue = @0.0;
        animation.toValue = @1.0;
        animation.delegate = self;
        animation.duration = 0.8;
        
        [lineLayer addAnimation:animation forKey:nil];
        
        linePoint.hidden = YES;
        linePoint.frame = CGRectMake(0, 0, 6.f, 6.f);
        NSValue *point = [points lastObject];
        linePoint.position = point.CGPointValue;
        
        CGFloat lineWidth =
        [NSString widthWithAttributes:nil text:self.tagGroup[currentTagIndex]];
        //添加 文字显示
        //添加 文字显示
        switch (self.type) {
            case kMaxTagGroupTwoTagTypeBrokenRight:
            case kMaxTagGroupTwoTagTypeRight: {
                [textlabel
                 setFrame:CGRectMake(lastPoint.x + kWithePointWidth, lastPoint.y - kLabelHeight / 2,
                                     lineWidth - kWithePointWidth, kLabelHeight)];
            } break;
            case kMaxTagGroupTypeBrokenBrokenLeft:
            case kMaxTagGroupTwoTagTypeLeft: {
                [textlabel setFrame:CGRectMake(lastPoint.x - lineWidth,
                                               lastPoint.y - kLabelHeight / 2, lineWidth - kWithePointWidth,
                                               kLabelHeight)];
            } break;
            default:
                break;
        }
        
        textlabel.text = self.tagGroup[currentTagIndex];
        textlabel.font = [UIFont systemFontOfSize:12];
        textlabel.hidden = YES;
    }];
}

- (void)drawLineThree {
    CGPoint point;
    //添加 文字显示
    
    CGFloat maxTotleMaxLength =
    [NSString maxestWidthWithStringArray:self.tagGroup];
    CGFloat maxSingleSideLength = [NSString
                                   maxestWidthWithStringArray:@[ self.tagGroup[0], self.tagGroup[1] ]];
    
    NSString *moneyString = [self.tagGroup lastObject];
    CGFloat moneyLength = [NSString maxestWidthWithStringArray:@[ moneyString ]];
    NSMutableDictionary *tagPointsArry =
    [NSMutableDictionary dictionaryWithCapacity:self.tagGroup.count];
    
    if (self.type == kMaxTagGroupThreeTagTypeLeftBottom) {
        //这里需要考虑右侧是不是在父视图外侧，这个时候要整体往左侧移动，但是可能存在左侧移除父视图的外部(要定义规则)
        
        self.frame =
        CGRectMake(self.point.x - (kSlash50DPLineWidth + kSlash30DPLineWidth +
                                   moneyLength),
                   self.point.y - kHegiht60DPDistance - kLabelHeight / 2,
                   2 * (kSlash50DPLineWidth + kSlash30DPLineWidth) +
                   moneyLength + maxSingleSideLength,
                   2 * kHegiht60DPDistance + kLabelHeight);
        
        point = CGPointMake(moneyLength + kSlash50DPLineWidth + kSlash30DPLineWidth,
                            CGRectGetHeight(self.frame) / 2);
        for (int idx = 0; idx < self.tagGroup.count; idx++) {
            
            NSMutableArray *lineBranch;
            switch (idx) {
                case 0: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth +
                                                                        kSlash30DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(0)];
                } break;
                case 1: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth +
                                                                        kSlash30DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(1)];
                } break;
                case 2: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth -
                                                                        kSlash30DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(2)];
                } break;
            }
        }
    } else if (self.type == kMaxTagGroupThreeTagTypeLeftTop) {
        //这里需要考虑右侧是不是在父视图外侧，这个时候要整体往左侧移动，但是可能存在左侧移除父视图的外部(要定义规则)
        
        self.frame =
        CGRectMake(self.point.x - (kSlash50DPLineWidth + kSlash30DPLineWidth +
                                   moneyLength),
                   self.point.y - kHegiht60DPDistance - kLabelHeight / 2,
                   2 * (kSlash50DPLineWidth + kSlash30DPLineWidth) +
                   moneyLength + maxSingleSideLength,
                   2 * kHegiht60DPDistance + kLabelHeight);
        
        point = CGPointMake(moneyLength + kSlash50DPLineWidth + kSlash30DPLineWidth,
                            CGRectGetHeight(self.frame) / 2);
        for (int idx = 0; idx < self.tagGroup.count; idx++) {
            
            NSMutableArray *lineBranch;
            switch (idx) {
                case 0: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth +
                                                                        kSlash30DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(0)];
                } break;
                case 1: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth +
                                                                        kSlash30DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(1)];
                } break;
                case 2: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth -
                                                                        kSlash30DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(2)];
                } break;
            }
        }
    } else if (self.type == kMaxTagGroupThreeTagTypeRightTop) {
        //这里需要考虑右侧是不是在父视图外侧，这个时候要整体往左侧移动，但是可能存在左侧移除父视图的外部(要定义规则)
        self.frame =
        CGRectMake(self.point.x - (kSlash50DPLineWidth + kSlash30DPLineWidth +
                                   maxSingleSideLength),
                   self.point.y - kHegiht60DPDistance - kLabelHeight / 2,
                   2 * (kSlash50DPLineWidth + kSlash30DPLineWidth) +
                   moneyLength + maxSingleSideLength,
                   2 * kHegiht60DPDistance + kLabelHeight);
        
        point = CGPointMake(maxSingleSideLength + kSlash50DPLineWidth +
                            kSlash30DPLineWidth,
                            CGRectGetHeight(self.frame) / 2);
        for (int idx = 0; idx < self.tagGroup.count; idx++) {
            
            NSMutableArray *lineBranch;
            switch (idx) {
                case 0: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth -
                                                                        kSlash30DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(0)];
                } break;
                case 1: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth -
                                                                        kSlash30DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(1)];
                } break;
                case 2: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth +
                                                                        kSlash30DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(2)];
                } break;
            }
        }
    } else if (self.type == kMaxTagGroupThreeTagTypeRightBottom) {
        //这里需要考虑右侧是不是在父视图外侧，这个时候要整体往左侧移动，但是可能存在左侧移除父视图的外部(要定义规则)
        
        self.frame =
        CGRectMake(self.point.x - (kSlash50DPLineWidth + kSlash30DPLineWidth +
                                   maxSingleSideLength),
                   self.point.y - kHegiht60DPDistance - kLabelHeight / 2,
                   2 * (kSlash50DPLineWidth + kSlash30DPLineWidth) +
                   moneyLength + maxSingleSideLength,
                   2 * kHegiht60DPDistance + kLabelHeight);
        
        point = CGPointMake(maxSingleSideLength + kSlash50DPLineWidth +
                            kSlash30DPLineWidth,
                            CGRectGetHeight(self.frame) / 2);
        for (int idx = 0; idx < self.tagGroup.count; idx++) {
            
            NSMutableArray *lineBranch;
            switch (idx) {
                case 0: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth -
                                                                        kSlash30DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(0)];
                } break;
                case 1: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x - kSlash50DPLineWidth -
                                                                        kSlash30DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(1)];
                } break;
                case 2: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(
                                                                        point.x + kSlash50DPLineWidth +
                                                                        kSlash30DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(2)];
                } break;
            }
        }
    } else if (self.type == kMaxTagGroupThreeTagTypeBrokenRight) {
        //这里需要考虑右侧是不是在父视图外侧，这个时候要整体往左侧移动，但是可能存在左侧移除父视图的外部(要定义规则)
        
        self.frame = CGRectMake(
                                self.point.x, self.point.y - kHegiht60DPDistance + kLabelHeight / 2,
                                kSlash50DPLineWidth + kSlash30DPLineWidth + maxTotleMaxLength,
                                2 * kHegiht60DPDistance + kLabelHeight);
        
        point = CGPointMake(0, CGRectGetHeight(self.frame) / 2);
        for (int idx = 0; idx < self.tagGroup.count; idx++) {
            
            NSMutableArray *lineBranch;
            switch (idx) {
                case 0: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(point.x + kSlash50DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(point.x + kSlash50DPLineWidth +
                                                                        kSlash30DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(0)];
                } break;
                case 1: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:[NSValue valueWithCGPoint:point],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(point.x +
                                                                kSlash70DPLineWidth,
                                                                point.y)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(1)];
                } break;
                case 2: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(point.x + kSlash50DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(point.x + kSlash50DPLineWidth +
                                                                        kSlash30DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(2)];
                } break;
            }
        }
    }
    else if (self.type == kMaxTagGroupThreeTagTypeBrokenLeft)
    {
        self.frame = CGRectMake(self.point.x -
                                (kSlash30DPLineWidth + maxTotleMaxLength + kSlash50DPLineWidth),
                                self.point.y - kHegiht60DPDistance - kLabelHeight / 2,
                                kSlash30DPLineWidth + maxTotleMaxLength + kSlash50DPLineWidth,
                                2 * kHegiht60DPDistance + kLabelHeight);
        
        point = CGPointMake(CGRectGetWidth(self.frame),
                            CGRectGetHeight(self.frame) / 2);
        for (int idx = 0; idx < self.tagGroup.count; idx++)
        {
            NSMutableArray *lineBranch;
            switch (idx) {
                case 0: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(point.x - kSlash50DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(point.x - kSlash50DPLineWidth -
                                                                        kSlash30DPLineWidth,
                                                                        point.y - kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(0)];
                } break;
                case 1: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:[NSValue valueWithCGPoint:point],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(point.x -
                                                                kSlash70DPLineWidth,
                                                                point.y)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(1)];
                } break;
                case 2: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:
                                  [NSValue valueWithCGPoint:point],
                                  [NSValue valueWithCGPoint:CGPointMake(point.x - kSlash50DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  [NSValue valueWithCGPoint:CGPointMake(point.x - kSlash50DPLineWidth -
                                                                        kSlash30DPLineWidth,
                                                                        point.y + kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(2)];
                } break;
            }
        }
    }
    else if (self.type == kMaxTagGroupThreeTagTypeRight)
    {
        //这里需要考虑右侧是不是在父视图外侧，这个时候要整体往左侧移动，但是可能存在左侧移除父视图的外部(要定义规则)
        
        self.frame = CGRectMake(self.point.x, self.point.y - kHegiht60DPDistance +
                                kLabelHeight / 2,
                                kSlash40DPLineWidth + maxTotleMaxLength,
                                2 * kHegiht60DPDistance + kLabelHeight);
        
        point = CGPointMake(0, CGRectGetHeight(self.frame) / 2);
        for (int idx = 0; idx < self.tagGroup.count; idx++)
        {
            NSMutableArray *lineBranch;
            switch (idx) {
                case 0: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:[NSValue valueWithCGPoint:point],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(point.x,
                                                                point.y -
                                                                kHegiht60DPDistance)],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(point.x +
                                                                kSlash40DPLineWidth,
                                                                point.y -
                                                                kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(0)];
                } break;
                case 1: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:[NSValue valueWithCGPoint:point],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(point.x +
                                                                kSlash40DPLineWidth,
                                                                point.y)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(1)];
                } break;
                case 2: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:[NSValue valueWithCGPoint:point],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(point.x,
                                                                point.y +
                                                                kHegiht60DPDistance)],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(point.x +
                                                                kSlash40DPLineWidth,
                                                                point.y +
                                                                kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(2)];
                } break;
            }
        }
    }
    else if (self.type == kMaxTagGroupThreeTagTypeLeft)
    {
        self.frame =
        CGRectMake(self.point.x - (kSlash40DPLineWidth + maxTotleMaxLength),
                   self.point.y - kHegiht60DPDistance - kLabelHeight / 2,
                   kSlash40DPLineWidth + maxTotleMaxLength,
                   2 * kHegiht60DPDistance + kLabelHeight);
        
        point = CGPointMake(CGRectGetWidth(self.frame),
                            CGRectGetHeight(self.frame) / 2);
        for (int idx = 0; idx < self.tagGroup.count; idx++)
        {
            NSMutableArray *lineBranch;
            switch (idx) {
                case 0: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:[NSValue valueWithCGPoint:point],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(point.x,
                                                                point.y -
                                                                kHegiht60DPDistance)],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(point.x -
                                                                kSlash40DPLineWidth,
                                                                point.y -
                                                                kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(0)];
                } break;
                case 1: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:[NSValue valueWithCGPoint:point],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(point.x -
                                                                kSlash40DPLineWidth,
                                                                point.y)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(1)];
                } break;
                case 2: {
                    lineBranch = [NSMutableArray
                                  arrayWithObjects:[NSValue valueWithCGPoint:point],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(point.x,
                                                                point.y +
                                                                kHegiht60DPDistance)],
                                  [NSValue
                                   valueWithCGPoint:CGPointMake(point.x -
                                                                kSlash40DPLineWidth,
                                                                point.y +
                                                                kHegiht60DPDistance)],
                                  nil];
                    [tagPointsArry setObject:lineBranch forKey:@(2)];
                } break;
            }
        }
    }
    
    self.lightingView.centerPoint = point;
    
    if (self.frame.origin.x < 0)
    {
        self.frame = CGRectMake(0,
                                self.frame.origin.y,
                                self.frame.size.width,
                                self.frame.size.height);
    }
    
    if (self.frame.origin.y < 0)
    {
        self.frame = CGRectMake(self.frame.origin.x,
                                0,
                                self.frame.size.width,
                                self.frame.size.height);
    }
    
    if (CGRectGetMaxX(self.frame) > _superFrame.size.width)
    {
        self.frame = CGRectMake(_superFrame.size.width - self.frame.size.width,
                                self.frame.origin.y,
                                self.frame.size.width,
                                self.frame.size.height);
    }
    
    if (CGRectGetMaxY(self.frame) > _superFrame.size.height)
    {
        self.frame = CGRectMake(self.frame.origin.x,
                                _superFrame.size.height - self.frame.size.height,
                                self.frame.size.width,
                                self.frame.size.height);
    }
    
    [tagPointsArry enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key,
                                                       NSArray *_Nonnull points,
                                                       BOOL *_Nonnull stop) {
        
        NSInteger idx = [key integerValue];
        CGPoint lastPoint = [[points lastObject] CGPointValue];
        NSInteger currentTagIndex = 0;
        
        CAShapeLayer *lineLayer = nil;
        CAShapeLayer *linePoint = nil;
        UILabel *textlabel = nil;
        switch (idx) {
            case 0: {
                if (!_lineLayer0)
                {
                    _lineLabel0 = [[UILabel alloc] init];
                    _lineLayer0 = [CAShapeLayer layer];
                    [self.layer addSublayer:_lineLayer0];
                    [self addSubview:_lineLabel0];
                    
                    _label0TapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
                    [_label0TapGestureRecognizer addTarget:self
                                                    action:@selector(gestureRecognizerHandle:)];
                    _lineLabel0.userInteractionEnabled = YES;
                    [_lineLabel0 addGestureRecognizer:_label0TapGestureRecognizer];
                    
                    _linePoint0 = [self whiteLayer];
                    [_lineLayer0 addSublayer:_linePoint0];
                }
                currentTagIndex = idx;
                lineLayer = _lineLayer0;
                linePoint = _linePoint0;
                textlabel = _lineLabel0;
            } break;
            case 1: {
                if (!_lineLayer1)
                {
                    _lineLabel1 = [[UILabel alloc] init];
                    _lineLayer1 = [CAShapeLayer layer];
                    [self.layer addSublayer:_lineLayer1];
                    [self addSubview:_lineLabel1];
                    
                    _label1TapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
                    [_label1TapGestureRecognizer addTarget:self
                                                    action:@selector(gestureRecognizerHandle:)];
                    _lineLabel1.userInteractionEnabled = YES;
                    [_lineLabel1 addGestureRecognizer:_label1TapGestureRecognizer];
                    
                    _linePoint1 = [self whiteLayer];
                    [_lineLayer1 addSublayer:_linePoint1];
                }
                currentTagIndex = idx;
                lineLayer = _lineLayer1;
                linePoint = _linePoint1;
                textlabel = _lineLabel1;
            } break;
            case 2: {
                if (!_lineLayer2)
                {
                    _lineLabel2 = [[UILabel alloc] init];
                    _lineLayer2 = [CAShapeLayer layer];
                    [self.layer addSublayer:_lineLayer2];
                    [self addSubview:_lineLabel2];
                    
                    _label2TapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
                    [_label2TapGestureRecognizer addTarget:self
                                                    action:@selector(gestureRecognizerHandle:)];
                    _lineLabel2.userInteractionEnabled = YES;
                    [_lineLabel2 addGestureRecognizer:_label2TapGestureRecognizer];
                    
                    _linePoint2 = [self whiteLayer];
                    [_lineLayer2 addSublayer:_linePoint2];
                }
                currentTagIndex = idx;
                lineLayer = _lineLayer2;
                linePoint = _linePoint2;
                textlabel = _lineLabel2;
            } break;
            default:
                lineLayer = [CAShapeLayer layer];
                break;
        }
        
        //清空面板
        lineLayer.path = nil;
        textlabel.frame = CGRectZero;
        lineLayer.strokeColor = ktagColor.CGColor;
        textlabel.text = nil;
        textlabel.textColor = ktagColor;
        textlabel.textAlignment = NSTextAlignmentCenter;
        // 指定frame，只是为了设置宽度和高度
        // 设置居中显示
        // 设置填充颜色
        lineLayer.fillColor = [UIColor clearColor].CGColor;
        // 设置线宽
        lineLayer.lineWidth = kLineValue;
        // 使用UIBezierPath创建路径
        UIBezierPath *linePath = [UIBezierPath bezierPath];
        
        [points enumerateObjectsUsingBlock:^(NSValue *_Nonnull pointNumber, NSUInteger idx, BOOL *_Nonnull stop) {
            
            CGPoint point = pointNumber.CGPointValue;
            if (idx == 0)
            {
                [linePath moveToPoint:point];
            }
            else
            {
                [linePath addLineToPoint:point];
            }
            
        }];
        
        // 设置CAShapeLayer与UIBezierPath关联
        lineLayer.path = linePath.CGPath;
        //创建动画
        CABasicAnimation *animation = [CABasicAnimation
                                       animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
        animation.fromValue = @0.0;
        animation.toValue = @1.0;
        animation.delegate = self;
        animation.duration = 0.8;
        
        [lineLayer addAnimation:animation forKey:nil];
        
        linePoint.hidden = YES;
        linePoint.frame = CGRectMake(0, 0, 6.f, 6.f);
        NSValue *point = [points lastObject];
        linePoint.position = point.CGPointValue;
        
        CGFloat lineWidth = [NSString widthWithAttributes:nil text:self.tagGroup[currentTagIndex]];
        
        //添加 文字显示
        switch (self.type) {
            case kMaxTagGroupThreeTagTypeRight:
            case kMaxTagGroupThreeTagTypeBrokenRight: {
                [textlabel
                 setFrame:CGRectMake(lastPoint.x + kWithePointWidth,
                                     lastPoint.y - kLabelHeight / 2,
                                     lineWidth - kWithePointWidth,
                                     kLabelHeight)];
            } break;
            case kMaxTagGroupThreeTagTypeLeft:
            case kMaxTagGroupThreeTagTypeBrokenLeft: {
                [textlabel setFrame:CGRectMake(lastPoint.x - lineWidth,
                                               lastPoint.y - kLabelHeight / 2,
                                               lineWidth - kWithePointWidth,
                                               kLabelHeight)];
            } break;
            case kMaxTagGroupThreeTagTypeRightTop:
            case kMaxTagGroupThreeTagTypeRightBottom: {
                if (currentTagIndex == 2)
                {
                    [textlabel setFrame:CGRectMake(lastPoint.x + kWithePointWidth,
                                                   lastPoint.y - kLabelHeight / 2,
                                                   lineWidth - kWithePointWidth,
                                                   kLabelHeight)];
                    
                }
                else
                {
                    [textlabel setFrame:CGRectMake(lastPoint.x - lineWidth,
                                                   lastPoint.y - kLabelHeight / 2,
                                                   lineWidth - kWithePointWidth,
                                                   kLabelHeight)];
                }
                
            } break;
            case kMaxTagGroupThreeTagTypeLeftTop:
            case kMaxTagGroupThreeTagTypeLeftBottom: {
                
                if (currentTagIndex != 2)
                {
                    [textlabel setFrame:CGRectMake(lastPoint.x + kWithePointWidth,
                                                   lastPoint.y - kLabelHeight / 2,
                                                   lineWidth - kWithePointWidth,
                                                   kLabelHeight)];
                    
                }
                else
                {
                    [textlabel setFrame:CGRectMake(lastPoint.x - lineWidth,
                                                   lastPoint.y - kLabelHeight / 2,
                                                   lineWidth - kWithePointWidth,
                                                   kLabelHeight)];
                }
                
            } break;
            default:{
                
            }break;
        }
        
        textlabel.text = self.tagGroup[idx];
        textlabel.font = [UIFont systemFontOfSize:12];
        textlabel.hidden = YES;
    }];
}

#pragma mark - CABasicAnimation delegate
- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    _lineLabel0.hidden = NO;
    _lineLabel1.hidden = NO;
    _lineLabel2.hidden = NO;
    
    _linePoint0.hidden = NO;
    _linePoint1.hidden = NO;
    _linePoint2.hidden = NO;
}

#pragma mark - Ges

- (void)gestureRecognizerHandle:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == _longPressGestureRecognizer)
    {
        if ([gestureRecognizer state] == UIGestureRecognizerStateBegan)
        {
            if (_longPressBlock)
            {
                _longPressBlock(self);
            }
        }
    }
    else if (gestureRecognizer == _tapGestureRecognizer)
    {
        if ([gestureRecognizer state] == UIGestureRecognizerStateEnded)
        {
            [self changeDirection];
        }
    }
    else if (gestureRecognizer == _label0TapGestureRecognizer)
    {
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            if (_tapGestureRecognizer)
            {
                if (_tapBlock)
                {
                    _tapBlock(self, _lineLabel0);
                }
            }
        }
    }
    else if (gestureRecognizer == _label1TapGestureRecognizer)
    {
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            if (_tapGestureRecognizer)
            {
                if (_tapBlock)
                {
                    _tapBlock(self, _lineLabel1);
                }
            }
        }
    }
    else if (gestureRecognizer == _label2TapGestureRecognizer)
    {
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
        {
            if (_tapGestureRecognizer)
            {
                if (_tapBlock)
                {
                    _tapBlock(self, _lineLabel2);
                }
            }
        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isDragging = NO;
    
    UITouch *touch = [touches anyObject];
    self.beginpoint = [touch locationInView:self];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isDragging = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self];
    CGRect frame = self.frame;
    
    CGFloat offsetX = currentLocation.x - self.beginpoint.x;
    CGFloat offsetY = currentLocation.y - self.beginpoint.y;
    frame.origin.x += offsetX;
    frame.origin.y += offsetY;
    
    self.point = CGPointMake(self.point.x + offsetX, self.point.y + offsetY);
    self.frame = frame;
    
    if (self.frame.origin.x < 0)
    {
        self.frame = CGRectMake(0,
                                self.frame.origin.y,
                                self.frame.size.width,
                                self.frame.size.height);
    }
    
    if (self.frame.origin.y < 0)
    {
        self.frame = CGRectMake(self.frame.origin.x,
                                0,
                                self.frame.size.width,
                                self.frame.size.height);
    }
    
    if (CGRectGetMaxX(self.frame) > _superFrame.size.width)
    {
        self.frame = CGRectMake(_superFrame.size.width - self.frame.size.width,
                                self.frame.origin.y,
                                self.frame.size.width,
                                self.frame.size.height);
    }
    
    if (CGRectGetMaxY(self.frame) > _superFrame.size.height)
    {
        self.frame = CGRectMake(self.frame.origin.x,
                                _superFrame.size.height - self.frame.size.height,
                                self.frame.size.width,
                                self.frame.size.height);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (_isDragging && _dragDoneBlock)
    {
        _dragDoneBlock(self);
    }
    _isDragging = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if (_dragCancelBlock)
    {
        _dragCancelBlock(self);
    }
}

- (CAShapeLayer *)whiteLayer
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 6.f, 6.f) cornerRadius:3.f];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor whiteColor].CGColor;
    return layer;
}

- (void)changeDirection
{
    kMaxTagGroupType value;
    if (self.tagGroup.count == 1)
    {
        value = self.type;
        if (value == kMaxTagGroupTypeDefault)
        {
            value = kMaxTagGroupOneTagTypeRight;
        }
        value++;
        if (value == kMaxTagGroupOneTagTypeLeftBottom+1)
        {
            value = kMaxTagGroupOneTagTypeRight;
        }
        self.type = value;
    }
    else if (self.tagGroup.count == 2)
    {
        value = self.type;
        if (value == kMaxTagGroupTypeDefault)
        {
            value = kMaxTagGroupTwoTagTypeBrokenRight;
        }
        value++;
        if (value == kMaxTagGroupTwoTagTypeLeft+1)
        {
            value = kMaxTagGroupTwoTagTypeBrokenRight;
        }
        self.type = value;
    }
    else if (self.tagGroup.count == 3)
    {
        value = self.type;
        if (value == kMaxTagGroupTypeDefault)
        {
            value = kMaxTagGroupThreeTagTypeLeftBottom;
        }
        value++;
        if (value == kMaxTagGroupThreeTagTypeLeft+1)
        {
            value = kMaxTagGroupThreeTagTypeLeftBottom;
        }
        self.type = value;
    }
    [self drawLine];
}
@end
