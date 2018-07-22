//
//  YHPlayer.h
//  YHPlayerExample
//
//  Created by wanyehua on 2016/7/22.
//  Copyright © 2016年 万叶华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "YHPlayerModel.h"

@protocol YHPlayerDelegate;
@interface YHPlayer : UIView
@property (nonatomic, weak) id<YHPlayerDelegate> delegate;
/**
 对象方法创建对象
 
 @param frame      约束
 @param controller 所在的控制器
 @return           对象
 */
- (instancetype)initWithFrame:(CGRect)frame currentVC:(UIViewController *)controller;

/**
 设置要播放的视频列表和要播放的视频
 
 @param playerModels 存储视频model的数组
 @param videoId     当前要播放的视频id
 */
- (void)setplayerModels:(NSArray<YHPlayerModel *> *)playerModels VideoId:(NSString *)videoId;

/**
 设置覆盖的图片
 
 @param imageUrl 覆盖的图片url
 */
- (void)setCoverImage:(NSString *)imageUrl;

/**
 点击目录要播放的视频id
 
 @param videoId 要不放的视频id
 */
- (void)playerModelWithVideoId:(NSString *)videoId;

/**
 暂停
 */
- (void)pause;

/**
 停止
 */
- (void)stop;

@end
@protocol YHPlayerDelegate <NSObject>

// 是否可以播放
- (BOOL)playerViewShouldPlay;

@optional
// 播放结束
- (void)playerView:(YHPlayer *)playView didPlayEndVideo:(YHPlayerModel *)playerModel index:(NSInteger)index;
// 开始播放
- (void)playerView:(YHPlayer *)playView didPlayerModel:(YHPlayerModel *)playerModel index:(NSInteger)index;
// 播放中
- (void)playerView:(YHPlayer *)playView didPlayerModel:(YHPlayerModel *)playerModel playTime:(NSTimeInterval)playTime;
@end
