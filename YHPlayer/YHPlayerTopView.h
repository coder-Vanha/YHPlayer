//
//  YHPlayerTopView.h
//  YHPlayerExample
//
//  Created by wanyehua on 2016/7/22.
//  Copyright © 2016年 万叶华. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YHPlayerTopViewDelegate;
@interface YHPlayerTopView : UIView
@property (nonatomic, weak) id<YHPlayerTopViewDelegate> delegate;
@property (nonatomic, copy) NSString *title;
- (void)showBackButton;
- (void)hideBackButton;
@end

@protocol YHPlayerTopViewDelegate <NSObject>
@optional
- (void)topViewDidExitFullScreen:(YHPlayerTopView *)topView;
@end
