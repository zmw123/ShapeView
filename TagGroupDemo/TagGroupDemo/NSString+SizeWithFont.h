//
//  NSString+SizeWithFont.h
//  TagGroupDemo
//
//  Created by chanli on 16/3/3.
//  Copyright © 2016年 Beijing ChunFengShiLi Technology Co., Ltd. All rights
//  reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (SizeWithFont)

+ (CGFloat)widthWithAttributes:(NSDictionary<NSString *, id> *)attrs
                          text:(NSString *)string;

+ (CGFloat)maxestWidthWithStringArray:(NSArray *)array;

@end
