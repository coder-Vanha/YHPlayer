//
//  YHPlayerFullScreenController.m
//  YHPlayerExample
//
//  Created by wanyehua on 2016/7/22.
//  Copyright © 2016年 万叶华. All rights reserved.
//

#import "YHPlayerFullScreenController.h"

@interface YHPlayerFullScreenController ()

@end

@implementation YHPlayerFullScreenController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return YES;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//
//    return YES;
//}

@end
