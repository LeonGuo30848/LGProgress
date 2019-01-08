//
//  LGProgress.m
//  LGProgress_Master
//
//  Created by 郭佳良 on 2019/1/8.
//  Copyright © 2019年 Leon. All rights reserved.
//

#import "LGProgress.h"

#define Point self.bounds.size.width/2
#define lineWidth 4.0
#define HexRGB(rgbValue)            [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LGProgress ()
{
    
    CGContextRef context;
}

@end

@implementation LGProgress

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = HexRGB(0xD5D5D5);
        [self setNeedsDisplay];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [HexRGB(0xD5D5D5) CGColor]);
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
    if (self.allArray.count <= 0) {
        if (!self.nowArray || self.nowArray.count < 2)
        {
            return;
        }
    }
    //更新历史的进度
    CGFloat beginX = 0;
    CGFloat endWidth = 0;
    if (self.allArray.count > 0) {
        NSMutableArray *beginArray = self.allArray.firstObject;
        NSMutableArray *endArray = self.allArray.lastObject;
        beginX = [beginArray.firstObject floatValue];
        endWidth = [endArray.lastObject floatValue];
        CGContextSetStrokeColorWithColor(context, [self.drawColor CGColor]);
        CGContextMoveToPoint(context, rect.size.width * beginX, 0);
        CGContextAddLineToPoint(context, rect.size.width * endWidth, 0);
        CGContextAddLineToPoint(context, rect.size.width * endWidth, rect.size.height);
        CGContextAddLineToPoint(context, rect.size.width * beginX, rect.size.height);
        CGContextStrokePath(context);
    }
    // 本次
    if (self.nowArray.count >= 1) {
        for (int i = 0; i < self.nowArray.count-1; i++)
        {
            CGContextSetStrokeColorWithColor(context, [[UIColor greenColor] CGColor]);
            CGContextMoveToPoint(context, rect.size.width * [self.nowArray[i] floatValue], 0);
            CGContextAddLineToPoint(context, rect.size.width * [self.nowArray[i+1] floatValue], rect.size.height);
            CGContextStrokePath(context);
        }
    }
    // 暂停
    for (int j = 0; j < self.pauseArray.count; j++)
    {
        CGContextSetStrokeColorWithColor(context, [self.pauseColor CGColor]);
        CGContextMoveToPoint(context, rect.size.width * [self.pauseArray[j] floatValue], 0);
        CGContextAddLineToPoint(context, rect.size.width * [self.pauseArray[j] floatValue] + 1, rect.size.height);
        CGContextStrokePath(context);
    }
}

- (void)setProgressEnd:(CGFloat)progressEnd
{
    _progressEnd = progressEnd;
    [self setNeedsDisplay];
}

- (void)drawBegan
{
    self.nowArray = [NSMutableArray array];
    [self.nowArray addObject:@(self.progressEnd)];
}

- (void)drawMoved
{
    [self.nowArray addObject:@(self.progressEnd)];
    [self setNeedsDisplay];
}
-(void)drawPause{
    //记录每次暂停的每一段
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.nowArray];
    [self.allArray addObject:tempArray];
    [self.pauseArray addObject:@(self.progressEnd)];
    [self setNeedsDisplay];
}
- (void)drawEnded
{
    
    self.pauseArray  = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self drawMoved];
        [self setNeedsDisplay];
    });
    
}

- (void)drawDelete
{
    [self.pauseArray removeLastObject];
    [self.allArray removeLastObject];
    [self.nowArray removeAllObjects];
    if (self.allArray.count > 0) {
        [self.nowArray addObjectsFromArray:self.allArray.lastObject];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (UIColor *)drawColor
{
    if (!_drawColor)
    {
        _drawColor = [UIColor redColor];
    }
    return _drawColor;
}

- (NSMutableArray *)pauseArray
{
    if (!_pauseArray)
    {
        _pauseArray = [NSMutableArray array];
    }
    return _pauseArray;
}
-(NSMutableArray *)allArray
{
    if (!_allArray) {
        _allArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _allArray;
}
-(NSMutableArray *)stopPoints
{
    if (!_stopPoints) {
        _stopPoints = [NSMutableArray arrayWithCapacity:0];
    }
    return _stopPoints;
}
-(NSMutableArray *)stopEnds
{
    if (!_stopEnds) {
        _stopEnds = [NSMutableArray arrayWithCapacity:0];
    }
    return _stopEnds;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
