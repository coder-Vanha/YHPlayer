//
//  YHPlayerBottomView.h
//  YHPlayerExample
//
//  Created by wanyehua on 2016/7/22.
//  Copyright © 2016年 万叶华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHProgressSlider.h"

@protocol YHPlayerBottomViewDelegate;
@interface YHPlayerBottomView : UIView
@property (nonatomic, weak) id<YHPlayerBottomViewDelegate> delegate;
@property (nonatomic, strong) UIButton * playSwitch;
@property (nonatomic, strong) UIButton * fullScreen;
@property (nonatomic, strong) UILabel * currentTimeLabel;
@property (nonatomic, strong) UILabel * totleTimeLabel;
@property (nonatomic, strong) YHProgressSlider * slider;
- (void)exitFullScreen;
@end

@protocol YHPlayerBottomViewDelegate <NSObject>
@optional
- (void)bottomView:(YHPlayerBottomView *)bottomView playSwitch:(BOOL)isPlay;
- (void)bottomView:(YHPlayerBottomView *)bottomView fullScreen:(BOOL)isFull;
@end
