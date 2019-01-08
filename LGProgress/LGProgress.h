//
//  LGProgress.h
//  LGProgress_Master
//
//  Created by 郭佳良 on 2019/1/8.
//  Copyright © 2019年 Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGProgress : UIView
@property (nonatomic, assign) CGFloat progressEnd;
@property (nonatomic, strong) UIColor *pauseColor;
@property (nonatomic, strong) UIColor *drawColor;
@property (nonatomic, strong) UIColor *lastColor;
@property (nonatomic, strong) NSMutableArray *stopPoints;
@property (nonatomic, strong) NSMutableArray *stopEnds;
@property (nonatomic, strong) NSMutableArray *nowArray;
@property (nonatomic, strong) NSMutableArray *pauseArray;
@property (nonatomic, strong) NSMutableArray *allArray;

//开始
- (void)drawBegan;
//绘制中
- (void)drawMoved;
//暂停
- (void)drawPause;
//结束
- (void)drawEnded;
//删除上一段
- (void)drawDelete;
@end
