//
//  CWSpectrumView.m
//  CubeWare
//
//  Created by zhuguoqiang on 17/2/22.
//  Copyright © 2017年 shixinyun. All rights reserved.
//

#import "CWSpectrumView.h"
#import "CubeWareHeader.h"

@interface CWSpectrumView ()
{
    CADisplayLink *_displayLink;
}

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSMutableArray * levelArray;
@property (nonatomic, strong) NSMutableArray * itemArray;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) CGFloat itemWidth;

@end

@implementation CWSpectrumView

- (id)init
{
    if(self = [super init]) {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.itemArray = [NSMutableArray new];
    
    self.numberOfItems = 18;//偶数
   
    self.itemColor = [UIColor colorWithRed:241/255.f green:60/255.f blue:57/255.f alpha:1.0];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.text = @"";
    [self.timeLabel setTextColor:UIColorFromRGB(0x333333)];
    [self.timeLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.timeLabel];
    
    self.levelArray = [[NSMutableArray alloc]init];
    for(int i = 0 ; i < self.numberOfItems/2 ; i++){
        [self.levelArray addObject:@(1)];
    }
}

-(void)setItemLevelCallback:(void (^)(void))itemLevelCallback
{
    _itemLevelCallback = itemLevelCallback;
}

- (BOOL)startUpdateMeter
{
    NSLog(@"startUpdateMeter");
    if (_itemLevelCallback) {
        CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:_itemLevelCallback selector:@selector(invoke)];
        displaylink.frameInterval = 6;
        [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        
        if (_displayLink) {
            [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            _displayLink = nil;
        }
        _displayLink = displaylink;
        
        for(int i=0; i < self.numberOfItems; i++)
        {
            CAShapeLayer *itemline = [CAShapeLayer layer];
            itemline.lineCap       = kCALineCapButt;
            itemline.lineJoin      = kCALineJoinRound;
            itemline.strokeColor   = [[UIColor clearColor] CGColor];
            itemline.fillColor     = [[UIColor clearColor] CGColor];
            [itemline setLineWidth:self.itemWidth * 0.3 / self.numberOfItems];
            itemline.strokeColor   = [self.itemColor CGColor];
            
            [self.layer addSublayer:itemline];
            [self.itemArray addObject:itemline];
        }
        return YES;
    }
    return NO;
}

- (void)stopUpdateMeter
{
    NSLog(@"stopUpdateMeter");
    //[_displayLink invalidate];
    if (_displayLink) {
        [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink = nil;
    }
}

- (void)setLevel:(CGFloat)level
{
    //NSLog(@"level = %f", level);
    level = (level+37.5)*3.2;
    if( level < 0 ) level = 0;

    [self.levelArray removeObjectAtIndex:self.numberOfItems/2-1];
    [self.levelArray insertObject:@((level / 6) < 1 ? 1 : level / 6) atIndex:0];
    
    [self updateItems];
}

- (void)setText:(NSString *)text{
    self.timeLabel.text = text;
}

- (void)updateItems
{
    UIGraphicsBeginImageContext(self.frame.size);
    
    int x = self.itemWidth * 0.6 / self.numberOfItems;
    int z = self.itemWidth * 0.4 / self.numberOfItems;
    int y = self.itemWidth * 0.7 - z;
    
    for(int i=0; i < (self.numberOfItems / 2); i++) {
        
        UIBezierPath *itemLinePath = [UIBezierPath bezierPath];
        
        y += x;
        
        NSNumber *levelNum = [self.levelArray objectAtIndex:i];
        CGFloat offset = ([levelNum intValue] + 1) * z / 2;
        
        offset = offset > 5 ? 5 : offset;
        
        [itemLinePath moveToPoint:CGPointMake(y, self.itemHeight/2 + offset)];
        
        [itemLinePath addLineToPoint:CGPointMake(y, self.itemHeight/2 - offset)];
        
        CAShapeLayer *itemLine = [self.itemArray objectAtIndex:i];
        itemLine.path = [itemLinePath CGPath];
    }

    y = self.itemWidth*0.3 + z;
    
    for(int i = (int)self.numberOfItems / 2; i < self.numberOfItems; i++) {
        
        UIBezierPath *itemLinePath = [UIBezierPath bezierPath];
        
        y -= x;
        
        NSNumber *levelNum = [self.levelArray objectAtIndex:i-self.numberOfItems/2];
        CGFloat offset = ([levelNum intValue] + 1) * z / 2;
        offset = offset > 5 ? 5 : offset;

        [itemLinePath moveToPoint:CGPointMake(y, self.itemHeight / 2 + offset)];
        
        [itemLinePath addLineToPoint:CGPointMake(y, self.itemHeight / 2 - offset)];
        
        CAShapeLayer *itemLine = [self.itemArray objectAtIndex:i];
        itemLine.path = [itemLinePath CGPath];
    }
    UIGraphicsEndImageContext();
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.itemHeight = CGRectGetHeight(self.bounds);
    self.itemWidth  = CGRectGetWidth(self.bounds);
    
    [_timeLabel setFrame:CGRectMake(self.itemWidth*0.3, 0, self.itemWidth*0.4, self.itemHeight)];
}

@end
