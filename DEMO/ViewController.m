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

@property (nonatomic,strong)  UIScrollView           *scrollView;
@property (nonatomic,strong)  UIPanGestureRecognizer *pan;
@property (nonatomic,strong ) NSMutableArray         *subViewsArray;
@property (nonatomic,strong ) DetailView             *detailView;
@property (nonatomic,strong ) UIView                 *showView;          //正在显示的视图
@property (nonatomic,strong ) NSMutableArray         *modelArray;        //所有房间数组
@property (nonatomic,assign ) NSInteger              index;              //当前房间位置
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollerView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    scrollerView.delegate = self;
    scrollerView.bounces = NO;
    scrollerView.pagingEnabled = YES;
    scrollerView.showsVerticalScrollIndicator = NO;
    scrollerView.showsHorizontalScrollIndicator = NO;
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
    
    [self setUpImageWith:self.index showCenterImage:YES];
}

-(void)setUpImageWith:(NSInteger )index showCenterImage:(BOOL)show
{
    for (NSInteger i = 0; i < self.subViewsArray.count; i ++) {
        UIImageView *imageView = self.subViewsArray[i];
        imageView.userInteractionEnabled = YES;
        NSInteger currentIndex;
        if (i==0) {
            currentIndex = index==0 ? self.modelArray.count-1 : index -1;
        }else if (i==1){
            currentIndex = index;
        }else{
            currentIndex = index==self.modelArray.count-1 ? 0 : index + 1;
        }
        
        //获取model
//        HotModel *model = self.modelArray[currentIndex];
        
        //切屏之后不重新加载showView的图片
        if (show || i != 1) {
             imageView.image = [UIImage imageNamed:((int)(arc4random() % 2) + 1) == 1 ? @"12.jpg" : @"13.jpg"];
         }
    }
    
    //主需要将播放视图展示在i==1的界面即可
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
    NSInteger index  = scrollView.contentOffset.y / SCREEN_HEIGHT;
    
    if (index==1) return;
    
    for (NSInteger i = 0; i < self.subViewsArray.count; i ++ ) {
        UIView *subView = self.subViewsArray[i];
        if (index == i) {
            self.showView = subView;
            continue;
        }
        [subView removeFromSuperview];
    }
    [self.subViewsArray removeAllObjects];
    
    self.index = scrollView.contentOffset.y/SCREEN_HEIGHT <1 ? --self.index :++self.index;
    if (self.index<0) {
        self.index = self.modelArray.count - 1;
    }else if (self.index>=self.modelArray.count){
        self.index = 0;
    }
    
    for (NSInteger i = 0; i < 3; i ++ ) {
        if (i == 1) {
            self.showView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.subViewsArray addObject: self.showView];
        }else{
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
            [self generateDimImage:imageView];
            CGFloat imageY = CGRectGetHeight(self.view.bounds)*i;
            imageView.frame = CGRectMake(0, imageY, SCREEN_WIDTH , SCREEN_HEIGHT);
            [scrollView addSubview:imageView];
            [self.subViewsArray addObject:imageView];
        }
    }
    scrollView.contentOffset = CGPointMake(0, SCREEN_HEIGHT);
    

    //删除以前添加的控件
    
    
    //重新添加控件
    [self setUpImageWith:self.index showCenterImage:NO];
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
-(NSMutableArray *)modelArray{
    
    if (!_modelArray) {
        
        _modelArray = [NSMutableArray arrayWithObjects:@"12.jpg",@"13.jpg",@"14.jpg", nil];
    }
    
    return _modelArray;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
