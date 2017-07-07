//
//  DetailView.m
//  DEMO
//
//  Created by Mr.Zhang on 2017/7/5.
//  Copyright © 2017年 Mr.Zhang. All rights reserved.
//

#import "DetailView.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface DetailView()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@end

@implementation DetailView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 100, 200, 300)];
        table.delegate = self;
        table.dataSource = self;
        table.bounces = YES;
        [self addSubview:table];
        
        [table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"zjCell"];
    }    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"zjCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"我是第%ld行",(long)indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableView被点击");
}

@end
