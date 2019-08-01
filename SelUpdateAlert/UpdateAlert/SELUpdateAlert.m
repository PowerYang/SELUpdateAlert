//
//  SELUpdateAlert.m
//  test
//
//  Created by GTO on 2018/8/27.
//  Copyright © 2018年 GTO. All rights reserved.
//

#import "SELUpdateAlert.h"
#import "SELUpdateAlertConst.h"
//#define DEFAULT_MAX_HEIGHT SCREEN_HEIGHT/2

#define DEFAULT_MAX_HEIGHT 378

@interface SELUpdateAlert()


/** 版本号 */
@property (nonatomic, copy) NSString *version;
/** 版本更新内容 */
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *isMustUpdate; // 0  1

@end

@implementation SELUpdateAlert

/**
 添加版本更新提示
 
 @param version 版本号
 @param descriptions 版本更新内容（数组）
 
 descriptions 格式如 @[@"1.xxxxxx",@"2.xxxxxx"]
 */
+ (void)showUpdateAlertWithVersion:(NSString *)version Descriptions:(NSArray *)descriptions
{
    if (!descriptions || descriptions.count == 0) {
        return;
    }
    
    //数组转换字符串，动态添加换行符\n
    NSString *description = @"";
    for (NSInteger i = 0;  i < descriptions.count; ++i) {
        id desc = descriptions[i];
        if (![desc isKindOfClass:[NSString class]]) {
            return;
        }
        description = [description stringByAppendingString:desc];
        if (i != descriptions.count-1) {
            description = [description stringByAppendingString:@"\n"];
        }
    }
    NSLog(@"====%@",description);
    SELUpdateAlert *updateAlert = [[SELUpdateAlert alloc]initVersion:version description:description isMustUpdate:NO];
    [[UIApplication sharedApplication].delegate.window addSubview:updateAlert];
}

/**
 添加版本更新提示
 
 @param version 版本号
 @param description 版本更新内容（字符串）
 
 description 格式如 @"1.xxxxxx\n2.xxxxxx"
 */
+ (void)showUpdateAlertWithVersion:(NSString *)version Description:(NSString *)description updateType:(BOOL)type
{
    
    SELUpdateAlert *updateAlert = [[SELUpdateAlert alloc]initVersion:version description:description isMustUpdate:type];
    [[UIApplication sharedApplication].delegate.window addSubview:updateAlert];
    
}

- (instancetype)initVersion:(NSString *)version description:(NSString *)description  isMustUpdate:(BOOL)isMustUpdate
{
    self = [super init];
    if (self) {
        self.version = version;
        self.desc = description;
        if (isMustUpdate) {
            self.isMustUpdate = @"1";
        }else{
            self.isMustUpdate = @"0";
        }
        
        [self _setupUI];
    }
    return self;
}

- (void)_setupUI
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3/1.0];
    
    //获取更新内容高度
    //    CGFloat descHeight = [self _sizeofString:self.desc font:[UIFont systemFontOfSize:SELDescriptionFont] maxSize:CGSizeMake(self.frame.size.width - Ratio(80) - Ratio(56), 1000)].height;
    
    //设置内容固定高度
    CGFloat descHeight = 130;
    //bgView实际高度
    CGFloat realHeight = descHeight + Ratio(260);
    //bgView最大高度
    CGFloat maxHeight = DEFAULT_MAX_HEIGHT;
    //更新内容可否滑动显示
    BOOL scrollEnabled = NO;
    if (realHeight > DEFAULT_MAX_HEIGHT) {
        scrollEnabled = YES;
    }
    //bgView固定高度= 内容高度 + 260
    maxHeight = realHeight ;
    
    //backgroundView
    UIView *bgView = [[UIView alloc]init];
    bgView.layer.cornerRadius = 5;
    bgView.center = self.center;
    bgView.bounds = CGRectMake(0, 0, self.frame.size.width - 100, maxHeight+Ratio(18));
    [self addSubview:bgView];
    
    //添加更新提示
    UIView *updateView = [[UIView alloc]init];
    [updateView setFrame:CGRectMake(Ratio(20), Ratio(18), bgView.frame.size.width - Ratio(40), maxHeight - 15)];
    updateView.backgroundColor = [UIColor clearColor];
    updateView.layer.masksToBounds = YES;
    updateView.layer.cornerRadius = 4.0f;
    [bgView addSubview:updateView];
    
    //背景白
    UILabel *bgLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, Ratio(0) , updateView.frame.size.width, updateView.frame.size.height - 20)];
    bgLabel.backgroundColor = [UIColor whiteColor];
    [updateView addSubview:bgLabel];
    
    //设置背景白，左下右下圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bgLabel.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(7, 7)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];        maskLayer.frame = bgLabel.bounds;
    maskLayer.path = maskPath.CGPath;
    bgLabel.layer.mask  = maskLayer;
    
    
    NSInteger imgHight = 118;
    if (SCREEN_HEIGHT <= 667) {
        //iPhone6以前的机型
        imgHight = 118;
    }
    
    
    //顶部背景图片
    UIButton *topBg = [UIButton buttonWithType:UIButtonTypeSystem];
    topBg.bounds = CGRectMake(0, Ratio(-5), updateView.frame.size.width, Ratio(130));
    topBg.frame = CGRectMake(updateView.frame.origin.x, Ratio(-5), updateView.frame.size.width, Ratio(imgHight));
    [topBg setImage:[[UIImage imageNamed:@"down-up"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [bgView addSubview:topBg];
    
    
    //版本号
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, Ratio(20) , updateView.frame.size.width, Ratio(28))];
    versionLabel.font = [UIFont boldSystemFontOfSize:20];
    versionLabel.textAlignment = NSTextAlignmentLeft;
    versionLabel.text = [NSString stringWithFormat:@"发现新版本"];
    versionLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:versionLabel];
    
    
    UILabel *versionNum = [[UILabel alloc]initWithFrame:CGRectMake(30, Ratio(40) , updateView.frame.size.width, Ratio(28))];
    versionNum.font = [UIFont boldSystemFontOfSize:13];
    versionNum.textAlignment = NSTextAlignmentLeft;
    versionNum.text = [NSString stringWithFormat:@"V%@",self.version];
    versionNum.textColor = [UIColor whiteColor];
    [bgView addSubview:versionNum];
    
    //更新标题
    UILabel *desctitle = [[UILabel alloc]initWithFrame:CGRectMake(18,  imgHight - 10, updateView.frame.size.width, Ratio(28))];
    desctitle.font = [UIFont boldSystemFontOfSize:15];
    desctitle.textAlignment = NSTextAlignmentLeft;
    desctitle.text = [NSString stringWithFormat:@"更新内容"];
    desctitle.textColor = [UIColor blackColor];
    [updateView addSubview:desctitle];
    
    //更新内容
    UITextView *descTextView = [[UITextView alloc]init];
    descTextView.font = [UIFont systemFontOfSize:SELDescriptionFont];
    descTextView.textContainer.lineFragmentPadding = 0;
    descTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    descTextView.text = self.desc;
    descTextView.font = [UIFont systemFontOfSize:12];
    descTextView.textColor = [UIColor darkGrayColor];
    //    descTextView.backgroundColor = [UIColor redColor];
    descTextView.editable = NO;
    descTextView.selectable = NO;
    descTextView.scrollEnabled = scrollEnabled;
    descTextView.showsVerticalScrollIndicator = scrollEnabled;
    descTextView.showsHorizontalScrollIndicator = NO;
    [updateView addSubview:descTextView];
    //更新内容
    [descTextView setFrame:CGRectMake(Ratio(18), Ratio(10) + CGRectGetMaxY(desctitle.frame), updateView.frame.size.width - Ratio(36), 130)];
    
    
    if (scrollEnabled) {
        //若显示滑动条，提示可以有滑动条
        [descTextView flashScrollIndicators];
    }
    
    //更新按钮
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    updateButton.backgroundColor = SELColor(51, 133, 255);
    updateButton.frame = CGRectMake(Ratio(28),Ratio(20) + CGRectGetMaxY(descTextView.frame), updateView.frame.size.width - Ratio(56), Ratio(40));
    updateButton.clipsToBounds = YES;
    updateButton.layer.cornerRadius = 20.0f;
    [updateButton addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
    [updateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, updateView.frame.size.width - Ratio(56), Ratio(40));
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.0),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[[UIColor colorWithRed:254.0/255.0 green:121.0/255.0 blue:95.0/255.0 alpha:1.0] CGColor],(id)[[UIColor colorWithRed:251.0/255.0 green:132.0/255.0 blue:53.0/255.0 alpha:1.0] CGColor]]];//渐变数组
    [updateButton.layer addSublayer:gradientLayer];
    [updateButton setTitle:@"立即升级" forState:UIControlStateNormal];
    [updateView addSubview:updateButton];
    
    
    //取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.center = CGPointMake(CGRectGetMidX(updateView.frame), CGRectGetMaxY(updateView.frame));
    cancelButton.bounds = CGRectMake(0, 0, Ratio(36), Ratio(36));
    [cancelButton setImage:[[UIImage imageNamed:@"close_update"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.isMustUpdate integerValue] == 1) {
        
    }else{
        [bgView addSubview:cancelButton];
    }
    
    
    NSLog(@"整体宽度：%.f",updateView.frame.size.width);
    
    //显示更新
    [self showWithAlert:bgView];
}

/** 更新按钮点击事件 跳转AppStore更新 */
- (void)updateVersion{
    [self removeFromSuperview];
    NSString *str ;
    if ([((NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"usefulUrl"]) containsString:@"plist"]) {
        str = [[NSUserDefaults standardUserDefaults]  objectForKey:@"usefulUrl"];
    } else {
        str = [NSString stringWithFormat:@"http://itunes.apple.com/cn/app/id%@", APP_ID];
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

/** 取消按钮点击事件 */
- (void)cancelAction{
    //    if ([[[NSUserDefaults standardUserDefaults]  objectForKey:@"IsMustUpdate"] boolValue]) return exit(0);
    [self dismissAlert];
}

/**
 添加Alert入场动画
 @param alert 添加动画的View
 */
- (void)showWithAlert:(UIView*)alert{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = SELAnimationTimeInterval;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [alert.layer addAnimation:animation forKey:nil];
}


/** 添加Alert出场动画 */
- (void)dismissAlert{
    
    [UIView animateWithDuration:SELAnimationTimeInterval animations:^{
        self.transform = (CGAffineTransformMakeScale(1.5, 1.5));
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    } ];
    
}

/**
 计算字符串高度
 @param string 字符串
 @param font 字体大小
 @param maxSize 最大Size
 @return 计算得到的Size
 */
- (CGSize)_sizeofString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize
{
    return [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
}




@end
