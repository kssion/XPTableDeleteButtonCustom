//
//  DPCardViewController.m
//  XPTableDeleteButtonCustom
//
//  Created by Chance on 2017/6/26.
//  Copyright © 2017年 Chance. All rights reserved.
//

#import "DPCardViewController.h"
#import "DPCardCell.h"

@interface DPCardViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation DPCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    [self initUI];
}

- (void)initData {
    _dataArray = @[@"", @"", @"", @"", @"", @"", @""];
    
}

- (void)initUI {
    self.title = @"我的卡";
    
    [self.tableView registerNibName:@"DPCardCell"];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
}


#pragma mark - table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView dequeueReusableCellWithIdentifier:@"DPCardCell"];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    for (UIView * sv in cell.subviews) {
        NSLog(@"%@", sv);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(DPCardCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell loadModel:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
