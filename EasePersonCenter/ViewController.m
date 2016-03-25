//
//  ViewController.m
//  EasePersonCenter
//
//  Created by appleDeveloper on 16/3/25.
//  Copyright © 2016年 appleDeveloper. All rights reserved.
//

#import "ViewController.h"
#import "HeadView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static const CGFloat heightHeader = 130.f;
static NSString * const cellIdentfier = @"cellIdentfier";
@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)initUI
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentfier];
    self.tableView.contentInset = UIEdgeInsetsMake(heightHeader , 0, 0, 0);
    
    [HeadView headView].scrollView = self.tableView;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
        for (NSInteger index = 0; index < 20; index ++) {
            [_dataList addObject:@(index).stringValue];
        }
    }
    return _dataList;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentfier forIndexPath:indexPath];
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
