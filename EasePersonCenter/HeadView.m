//
//  HeadView.m
//  EasePersonCenter
//
//  Created by appleDeveloper on 16/3/25.
//  Copyright © 2016年 appleDeveloper. All rights reserved.
//

#import "HeadView.h"

#define DeviceSize [[UIScreen mainScreen] bounds].size

@interface HeadView ()<UIScrollViewDelegate>
{
    CGRect orginTitleFrame;
    CGRect orginDescFrame;
}

@property (nonatomic, strong) UIImageView *backImgView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic) CGFloat offsetY ;

@end

static const CGFloat navBarHeight = 64.f;
static const CGFloat heightHeader = 130.f;

@implementation HeadView

+ (instancetype)headView
{
   return [[HeadView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width , heightHeader)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self initUI];
}

#pragma mark - UI

- (void)initUI
{
    self.backImgView = [UIImageView new];
    self.backImgView.frame = self.bounds;
    self.backImgView.image = [UIImage imageNamed:@"todaynews_header_bg_day"];
    self.backImgView.contentMode = UIViewContentModeCenter;
    [self addSubview:self.backImgView];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.descLabel];
}


#pragma mark - setter getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:30.f];
        _titleLabel.frame = CGRectMake(0, 0, DeviceSize.width, 30);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"24小时新闻";
        _titleLabel.center = CGPointMake(self.center.x, self.center.y);
        orginTitleFrame = _titleLabel.frame;
    }
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [UILabel new];
        _descLabel.font = [UIFont systemFontOfSize:14.f];
        _descLabel.frame = CGRectMake(0, 0, DeviceSize.width, 15);
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.textColor = [UIColor whiteColor];
        _descLabel.backgroundColor = [UIColor clearColor];
        _descLabel.text = @"24小时新闻24小时新闻24小时新闻";
        _descLabel.center = CGPointMake(self.center.x, self.center.y + 45);
        orginDescFrame = _descLabel.frame;
    }
    return _descLabel;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    if (_scrollView.superview) {
        self.offsetY = - self.bounds.size.height;
        [[_scrollView superview] insertSubview:self aboveSubview:_scrollView];
    }
    _scrollView.delegate = self;
    _scrollView.scrollIndicatorInsets = _scrollView.contentInset;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    __weak typeof(self) weakSelf = self;
    if (scrollView == self.scrollView) {
        CGPoint offset = scrollView.contentOffset;
        if (offset.y > self.offsetY ) {
            
            CGFloat minOffset = offset.y - self.offsetY;
            if (minOffset > -self.offsetY - navBarHeight) {
                minOffset = -self.offsetY - navBarHeight;
            }
        
            [self animationFrame:CGRectMake(0, -minOffset, DeviceSize.width, - self.offsetY)completion:^{
                [weakSelf updateCurrentOffsetY:minOffset];
            }];
        }else{
            //回归 原位  或者 还下拉了
            //头部 没下来接着拉下来
            
            CGFloat minY = CGRectGetMinY(self.frame);
            if (minY<0) {
                [self animationFrame:CGRectMake(0, 0, DeviceSize.width, - self.offsetY) completion:^{
                    [weakSelf resumeSubView];
                }];
                
            }
        }
    }
}

- (void)animationFrame:(CGRect) frame completion:(void(^)(void))completion
{
    [UIView animateWithDuration:1./60. animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        completion?completion():0;
    }];
}
// 最大的 OffsetY 130 - 64
- (void)updateCurrentOffsetY:(CGFloat)offsetY
{
    CGFloat hiddenY = 40.f; // desc 滑动消失的距离
    CGFloat alpha = 1- offsetY/hiddenY;
    if (alpha< 0.f) {
        alpha = 0.f;
    }
    self.descLabel.alpha = alpha;
    
    if (offsetY < 30.f) { // 前面滑动不处理 titleLabel
        return;
    }
    
    /**
     *  @brief 让滑动 动画时间更长66 对应 0.8 所以 scaleTitleOffsetY为（66-30）/0.2
     */
    CGFloat scaleTitleOffsetY = 120.f; // desc 滑动消失的距离
    CGFloat scale = 1 - (offsetY - 30)/scaleTitleOffsetY;
    if (scale < 0.8) {
        scale = 0.8;
    }

    CGAffineTransform transfrom = CGAffineTransformMakeScale(scale, scale);
    transfrom.ty = (1 - scale) * 200.f;
    self.titleLabel.transform = transfrom;
}

- (void)resumeSubView
{
    self.titleLabel.transform = CGAffineTransformIdentity;
    self.titleLabel.frame = orginTitleFrame;
    self.titleLabel.font = [UIFont systemFontOfSize:25.f];
    
    self.descLabel.frame = orginDescFrame;
    self.descLabel.alpha = 1.f;
}

@end
