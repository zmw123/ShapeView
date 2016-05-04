//
//  ViewController.m
//  TagGroupDemo
//
//  Created by chanli on 16/3/3.
//  Copyright © 2016年 Beijing ChunFengShiLi Technology Co., Ltd. All rights
//  reserved.
//

#import "MaxShapeView.h"
#import "ViewController.h"
#import "MaxLightingView.h"

@interface ViewController () <UIAlertViewDelegate>

@property(strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) MaxShapeView *pathShapeView;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // Do any additional setup after loading the view, typically from a nib.
  //    [self buildWebView];
  [self buildTag];
}

- (void)buildTag {
  self.imageView =
      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meinv.jpg"]];
  self.imageView.userInteractionEnabled = YES;

  self.imageView.frame = self.view.bounds;

  [self.view addSubview:self.imageView];
  self.view.backgroundColor = [UIColor whiteColor];

  CGPoint point = CGPointMake(100, 200);

  NSArray *tagGroup = @[ @"Moschino", @"裤子", @"¥2000" ];
//        tagGroup = @[ @"Moschino", @"裤子"];
      tagGroup  = @[ @"Moschino"];

  //添加path的UIView
  self.pathShapeView =
      [[MaxShapeView alloc] initWithFrame:CGRectZero
                                    point:point
                                 tagGroup:tagGroup
                                  tagType:kMaxTagGroupTypeDefault
                               superFrame:self.view.frame];
    
//    pathShapeView.backgroundColor = [UIColor grayColor];
    
  [self.view addSubview:self.pathShapeView];
    
    
    __weak typeof(self) weakSelf = self;
  self.pathShapeView.tapBlock = ^(MaxShapeView *shapeView, UILabel *tapLabel) {

      if (tapLabel)
      {
          UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择后标签个数" message:@"" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"0", @"1", @"2", @"3", nil];
          [alertView show];
      }
  };
    
    self.pathShapeView.longPressBlock = ^(MaxShapeView *shapeView){
        
        //长按
        NSLog(@"%s__%d", __func__, __LINE__);
    };
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //删除
        [self.pathShapeView removeFromSuperview];
    }
    else if (buttonIndex == 2)
    {
        self.pathShapeView.tagGroup = @[@"Moschino"];
    }
    else if (buttonIndex == 3)
    {
        self.pathShapeView.tagGroup = @[ @"Moschino", @"裤子"];
    }
    else if (buttonIndex == 4)
    {
        self.pathShapeView.tagGroup = @[ @"Moschino", @"裤子", @"¥2000"];
    }
    
    if (self.pathShapeView.tagGroup.count == 1)
    {
        self.pathShapeView.type = kMaxTagGroupOneTagTypeRight;
    } else if (self.pathShapeView.tagGroup.count == 2) {
        self.pathShapeView.type = kMaxTagGroupTwoTagTypeBrokenRight;
    } else if (self.pathShapeView.tagGroup.count == 3) {
        self.pathShapeView.type = kMaxTagGroupThreeTagTypeLeftBottom;
    }
    
    [self.pathShapeView drawLine];
}
@end
