//
//  ViewController.m
//  DEMO
//
//  Created by Mr.Zhang on 2017/7/5.
//  Copyright © 2017年 Mr.Zhang. All rights reserved.
//

#import "ViewController.h"
#import "DetailView.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
@interface ViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic,strong) NSMutableArray* subViewsArray;
@property (nonatomic,strong) DetailView *detailView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollerView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollerView.delegate = self;
    scrollerView.bounces = NO;
    scrollerView.pagingEnabled = YES;
    self.scrollView = scrollerView;
    [self.view addSubview:_scrollView];
    
    for (NSInteger i = 0; i < 3; i ++ ){
        
        UIImageView *imageView = [[UIImageView alloc]init];
        [self generateDimImage:imageView];
        [scrollerView addSubview:imageView];
        CGFloat imageY = CGRectGetHeight(self.view.bounds)*i;
        imageView.frame = CGRectMake(0, imageY,SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.subViewsArray addObject:imageView];
    }
    scrollerView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 3);
    scrollerView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
    
    [self setUpImageWith];
}

-(void)setUpImageWith
{
    for (NSInteger i = 0; i < self.subViewsArray.count; i ++) {
        UIImageView *imageView = self.subViewsArray[i];
        imageView.userInteractionEnabled = YES;
        imageView.image = [UIImage imageNamed:((int)(arc4random() % 2) + 1) == 1 ? @"loading_bg.png" : @"swipe_bg.jpg"];
    }
    
    UIView *currentView = self.subViewsArray[1];
    
    
    self.detailView = [[DetailView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, 0, SCREEN_WIDTH * 2, SCREEN_HEIGHT)];
    self.detailView.rootScrollView = self.scrollView;
    [currentView addSubview:self.detailView];
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    self.pan.delegate = self;
    [currentView addGestureRecognizer:self.pan];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"_UITableViewCellSeparatorView"]) {
        self.scrollView.scrollEnabled = NO;
        return NO;
    }
    self.scrollView.scrollEnabled = YES;
    return  YES;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGFloat detalX = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self.view].x;
    CGFloat velocityX= [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:self.view].x;
    
    CGFloat detaly = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:self.view].y;
    CGFloat velocityy= [(UIPanGestureRecognizer*)gestureRecognizer velocityInView:self.view].y;
    
    if (fabs(velocityX)-fabs(detalX)>fabs(velocityy)-fabs(detaly)) {
        _scrollView.scrollEnabled=NO;
        return YES;
    }
    _scrollView.scrollEnabled=YES;
    return NO;
}
- (void)panAction:(UIPanGestureRecognizer*)panGesture {
    
    
    CGFloat detalX = [panGesture translationInView:self.view].x;
    CGFloat velocityX= [panGesture velocityInView:self.view].x;
    __block CGRect tempFrame = self.detailView.frame;
    
    tempFrame.origin.x += detalX;
    tempFrame.origin.x = tempFrame.origin.x >= -SCREEN_WIDTH ? tempFrame.origin.x : -SCREEN_WIDTH;
    tempFrame.origin.x = tempFrame.origin.x <= 0 ? tempFrame.origin.x : 0;
    
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        if (velocityX > 0) {
            [UIView animateWithDuration:0.2 animations:^{
                tempFrame.origin.x = 0;
                self.detailView.frame = tempFrame;
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [UIView animateWithDuration:0.2 animations:^{
                tempFrame.origin.x = -SCREEN_WIDTH;
                self.detailView.frame = tempFrame;
            } completion:^(BOOL finished) {
                
                
            }];
        }
        
    }
    self.detailView.frame = tempFrame;
    [panGesture setTranslation:CGPointZero inView:self.detailView];
    
    
    
}
#pragma mark UIScrollViewDelegate 此处解决了scrollerview的循环引用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
}

#pragma mark - 生成磨玻璃图片
-(void)generateDimImage:(UIImageView *)imageView{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [imageView addSubview:effectView];
}
-(NSMutableArray *)subViewsArray{
    
    if (!_subViewsArray) {
        
        _subViewsArray = [NSMutableArray array];
    }
    
    return _subViewsArray;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
