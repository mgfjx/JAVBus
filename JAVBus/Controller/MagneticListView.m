//
//  MagneticListView.m
//  JAVBus
//
//  Created by mgfjx on 2020/3/15.
//  Copyright © 2020 mgfjx. All rights reserved.
//

#import "MagneticListView.h"
#import "MagneticItemCell.h"

#define kItemHeight 40

@interface MagneticListView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, strong) UIActivityIndicatorView *indicator ;

@end

@implementation MagneticListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews:frame];
    }
    return self;
}

- (void)initViews:(CGRect)frame {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"磁力鏈接";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = MHMediumFont(14);
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    [self addSubview:label];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self addSubview:indicator];
    self.indicator = indicator;
    [indicator startAnimating];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-10);
        make.centerY.equalTo(label.mas_centerY);
        make.width.height.mas_equalTo(25);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(kItemHeight);
    }];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self addSubview:table];
    self.tableView = table;
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(label.mas_bottom).offset(0);
    }];
    
}

- (void)setMagneticArray:(NSArray *)magneticArray {
    _magneticArray = magneticArray;
    [self.tableView reloadData];
    [self.indicator stopAnimating];
    
    CGRect frame = self.frame;
    frame.size.height = (magneticArray.count + 1)*kItemHeight;
    if (self.frameChangeCallback) {
        self.frameChangeCallback(frame);
    }
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.magneticArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellReuse = @"cell";
    MagneticItemCell *cell = (MagneticItemCell *)[tableView dequeueReusableCellWithIdentifier:cellReuse];
    
    if (!cell) {
        cell = [[MagneticItemCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellReuse];
    }
    
    MagneticModel *model = self.magneticArray[indexPath.row];
    cell.model = model;
    
    cell.backgroundColor = indexPath.row%2==0 ? [UIColor colorWithHexString:@"#f2f2f7"]:[UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kItemHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    MagneticModel *model = self.magneticArray[indexPath.row];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = model.link;
    
    [PublicDialogManager showText:@"已複製磁鏈" inView:self duration:1.0];
}

@end
