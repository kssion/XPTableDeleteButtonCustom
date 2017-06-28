//
//  UITableView+Extension.m
//  CTools
//
//  Created by Chance on 15/7/13.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "UITableView+Extension.h"

@implementation UITableView (Extension)

- (void)scrollToBottomInSection:(NSInteger)section atScrollPosition:(UITableViewScrollPosition)position {
    NSInteger sectionCount = [self numberOfSections];
    NSInteger rowCount = [self numberOfRowsInSection:section];
    if (section > 0 && section < sectionCount && rowCount > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowCount-1 inSection:section];
        [self scrollToRowAtIndexPath:indexPath atScrollPosition:position animated:YES];
    }
}

- (void)selectRow:(NSInteger)row inSection:(NSInteger)section {
    if (self.isEditing) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)selectAllRow {
    NSInteger sectionCount = [self numberOfSections];
    for (int section = 0; section < sectionCount; ++section) {
        NSInteger rowCount = [self numberOfRowsInSection:section];
        for (int row = 0; row < rowCount; ++row) {
            [self selectRow:row inSection:section];
        }
    }
}

- (void)selectAllRowInSection:(NSInteger)section {
    NSInteger rows = [self numberOfRowsInSection:section];
    for (int row = 0; row < rows; ++row) {
        [self selectRow:row inSection:section];
    }
}

- (void)deselectRow:(NSInteger)row inSection:(NSInteger)section {
    if (self.isEditing) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        [self deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)deselectAllRow {
    NSInteger sectionCount = [self numberOfSections];
    for (int section = 0; section < sectionCount; ++section) {
        NSInteger rowCount = [self numberOfRowsInSection:section];
        for (int row = 0; row < rowCount; ++row) {
            [self deselectRow:row inSection:section];
        }
    }
}

- (void)deselectAllRowInSection:(NSInteger)section {
    NSInteger rows = [self numberOfRowsInSection:section];
    for (int row = 0; row < rows; ++row) {
        [self deselectRow:row inSection:section];
    }
}


- (void)registerNibName:(NSString *)nibName
{
    UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
    [self registerNib:nib forCellReuseIdentifier:nibName];
}

- (void)registerNibName:(NSString *)nibName forCellReuseIdentifier:(NSString *)identifier
{
    UINib *nib = [UINib nibWithNibName:nibName bundle:[NSBundle mainBundle]];
    [self registerNib:nib forCellReuseIdentifier:identifier];
}

- (void)registerClassName:(NSString *)className
{
    [self registerClass:NSClassFromString(className) forCellReuseIdentifier:className];
}

- (void)registerClassName:(NSString *)className forCellReuseIdentifier:(NSString *)identifier
{
    [self registerClass:NSClassFromString(className) forCellReuseIdentifier:identifier];
}

@end
