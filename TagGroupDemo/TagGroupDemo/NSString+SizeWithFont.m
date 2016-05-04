//
//  NSString+SizeWithFont.m
//  TagGroupDemo
//
//  Created by chanli on 16/3/3.
//  Copyright © 2016年 Beijing ChunFengShiLi Technology Co., Ltd. All rights
//  reserved.
//

#import "NSString+SizeWithFont.h"
#define kEdgeDistance 5

@implementation NSString (SizeWithFont)

+ (CGFloat)widthWithAttributes:(NSDictionary<NSString *, id> *)attrs
                          text:(NSString *)string {

  NSMutableDictionary *attrsDic =
      [NSMutableDictionary dictionaryWithDictionary:@{
        NSFontAttributeName : [UIFont systemFontOfSize:12],
        NSForegroundColorAttributeName : [UIColor redColor]
      }];
  if (attrs != nil) {
    attrsDic = [NSMutableDictionary dictionaryWithDictionary:attrs];
  }

  CGRect rect =
      [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 15)
                           options:NSStringDrawingUsesLineFragmentOrigin |
                                   NSStringDrawingUsesFontLeading
                        attributes:attrsDic
                           context:nil];
//6是小白点宽度
  return rect.size.width + 2 * kEdgeDistance + 6;
}

+ (CGFloat)maxestWidthWithStringArray:(NSArray *)array {

  __block CGFloat maxLength = 0;

  [array enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx,
                                      BOOL *_Nonnull stop) {

    CGFloat length = [NSString widthWithAttributes:nil text:obj];
    maxLength = maxLength > length ? maxLength : length;

  }];

  return maxLength;
}

@end
