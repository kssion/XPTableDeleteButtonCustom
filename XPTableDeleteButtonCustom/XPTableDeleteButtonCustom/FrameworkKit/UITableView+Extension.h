//
//  UITableView+Extension.h
//  CTools
//
//  Created by Chance on 15/7/13.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Extension)

- (void)scrollToBottomInSection:(NSInteger)section atScrollPosition:(UITableViewScrollPosition)position;

- (void)selectAllRow;/**< 选中TableView所有行*/
- (void)selectAllRowInSection:(NSInteger)section;/**< 选中TableView某区的所有行*/
- (void)selectRow:(NSInteger)row inSection:(NSInteger)section;/**< 选中TableView某区的某行*/

- (void)deselectAllRow;/**< 取消选中TableView所有行*/
- (void)deselectAllRowInSection:(NSInteger)section;/**< 取消选中TableView某区的所有行*/
- (void)deselectRow:(NSInteger)row inSection:(NSInteger)section;/**< 取消选中TableView某区的某行*/


- (void)registerNibName:(NSString *)nibName;
- (void)registerNibName:(NSString *)nibName forCellReuseIdentifier:(NSString *)identifier;
- (void)registerClassName:(NSString *)className;
- (void)registerClassName:(NSString *)className forCellReuseIdentifier:(NSString *)identifier;


@end
