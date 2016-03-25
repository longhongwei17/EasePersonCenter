//
//  HeadView.h
//  EasePersonCenter
//
//  Created by appleDeveloper on 16/3/25.
//  Copyright © 2016年 appleDeveloper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadView : UIView

+ (instancetype)headView;

@property (weak, nonatomic) UIScrollView *scrollView;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSArray *desc;


@end
