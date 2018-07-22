//
//  YHPlayerFailedView.h
//  YHPlayerExample
//
//  Created by wanyehua on 2016/7/22.
//  Copyright © 2016年 万叶华. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YHPlayerFailedViewDelegate;
@interface YHPlayerFailedView : UIView
@property (nonatomic, weak) id<YHPlayerFailedViewDelegate> delegate;
@end

@protocol YHPlayerFailedViewDelegate <NSObject>
@optional
- (void)failedViewDidReplay:(YHPlayerFailedView *)failedView;
@end
