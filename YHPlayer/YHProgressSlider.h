//
//  YHProgressSlider.h
//  YHPlayerExample
//
//  Created by wanyehua on 2016/7/22.
//  Copyright © 2016年 万叶华. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, YHSliderDirection) {
    YHSliderDirectionHorizonal = 0,
    YHSliderDirectionVertical  = 1
};
@interface YHProgressSlider : UIControl
// 最小值
@property (nonatomic, assign) CGFloat minValue;
// 最大值
@property (nonatomic, assign) CGFloat maxValue;
// 滑动值
@property (nonatomic, assign) CGFloat value;
// 滑动百分比
@property (nonatomic, assign) CGFloat sliderPercent;
// 缓冲的百分比
@property (nonatomic, assign) CGFloat progressPercent;
// 是否正在滑动  如果在滑动的是偶外面监听的回调不应该设置sliderPercent progressPercent 避免绘制混乱
@property (nonatomic, assign) BOOL isSliding;
// 方向
@property (nonatomic, assign) YHSliderDirection direction;
- (instancetype)initWithFrame:(CGRect)frame direction:(YHSliderDirection)direction;
@end
