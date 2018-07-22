//
//  YHPlayerConst.h
//  YHPlayerExample
//
//  Created by wanyehua on 2016/7/10.
//  Copyright © 2016年 万叶华. All rights reserved.
//

#ifndef YHPlayerConst_h
#define YHPlayerConst_h
#import <Masonry.h>


// 图片路径
#define YHPlayer_SrcName(file)               [@"YHPlayer.bundle" stringByAppendingPathComponent:file]

#define YHPlayer_FrameworkSrcName(file)      [@"Frameworks/YHPlayer.framework/YHPlayer.bundle" stringByAppendingPathComponent:file]

#define YHPlayer_Image(file)                 [UIImage imageNamed:YHPlayer_SrcName(file)] ? :[UIImage imageNamed:YHPlayer_FrameworkSrcName(file)]

//屏幕宽 高
#define Screen_Width       [UIScreen mainScreen].bounds.size.width
#define Screen_Height      [UIScreen mainScreen].bounds.size.height

//颜色
#define Color_RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0  alpha:1.0]
#define Color_RGB_Alpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0  alpha:(a)]
#define Color_Random           [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1.0]

//#define kHalfWidth self.frame.size.width * 0.5
//#define kHalfHeight self.frame.size.height * 0.5


static void *PlayViewCMTimeValue = &PlayViewCMTimeValue;

static void *PlayViewStatusObservationContext = &PlayViewStatusObservationContext;

#endif /* YHPlayerConst_h */
