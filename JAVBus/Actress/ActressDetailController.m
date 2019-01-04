//
//  ActressDetailController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/16.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "ActressDetailController.h"

@interface ActressDetailController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIView *detailView ;
@property (nonatomic, strong) ActressModel *detailModel ;

@end

@implementation ActressDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.name;
//    self.collectionView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData:(BOOL)refresh {
    
    if (refresh) {
        self.page = 1;;
    }else{
        self.page ++;
    }
    
    [HTMLTOJSONMANAGER parseActressDetailUrl:self.model.link page:self.page callback:^(NSArray *array, ActressModel *model) {
        [self.collectionView stopHeaderRefreshing];
        [self.collectionView stopFooterRefreshing];
        
        model.link = self.model.link;
        self.detailModel = model;
        if (array.count == 0 || !model) {
            return ;
        }
        
        NSMutableArray *arr ;
        if (refresh) {
            arr = [NSMutableArray array];
        }else{
            arr = [NSMutableArray arrayWithArray:self.dataArray];
        }
        [arr addObjectsFromArray:array];
        self.dataArray = [arr copy];
        [self.collectionView reloadData];
        [self createActorView];
        [self createBarbutton];
    }];
    
}

- (void)createBarbutton {
    
    BOOL isExsit = [DBMANAGER isActressExsit:self.model];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(collectionActress:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"collection_unselected"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"collection_selected"] forState:UIControlStateSelected];
    button.selected = isExsit;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)collectionActress:(UIButton *)sender {
    if (sender.selected) {
        [DBMANAGER deleteActress:self.detailModel];
    }else{
        [DBMANAGER insertActress:self.detailModel];
    }
    sender.selected = !sender.selected;
}

- (void)createActorView {
    
    [self.detailView removeFromSuperview];
    
    CGFloat height = 400;
    CGFloat offset = MainWidth*0.05;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight - height + 30, MainWidth, height)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.0];
    bgView.centerX = MainWidth/2;
    [self.view addSubview:bgView];
    self.detailView = bgView;
    
    UIButton *controlBtn;
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 30, 30);
        [button addTarget:self action:@selector(showActorDetailView:) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"arrow"] forState:UIControlStateHighlighted];
        
        [bgView addSubview:button];
        controlBtn = button;
        button.y = bgView.height - button.height;
        button.centerX = bgView.width/2;
    }
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, offset, bgView.width - 2*offset, controlBtn.y - 2*offset)];
    containerView.centerX = bgView.width/2;
    containerView.backgroundColor = [UIColor whiteColor];
    containerView.layer.cornerRadius = containerView.height/8.0;
    containerView.layer.borderColor = [UIColor colorWithHexString:@"#eeeeee"].CGColor;
    containerView.layer.borderWidth = 0.5;
    [bgView addSubview:containerView];
    containerView.layer.shadowOpacity = 1.0;
    containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    containerView.layer.shadowOffset = CGSizeMake(0, 0);
    containerView.layer.shadowRadius = 10;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:containerView.bounds];
    scrollView.contentSize = CGSizeMake(containerView.width, containerView.height+1);
    scrollView.delegate = self;
    [containerView addSubview:scrollView];
    
    UIImageView *avatarImgView;
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, offset, 90, 90)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.avatarUrl] placeholderImage:MovieListPlaceHolder];
        imageView.centerX = containerView.width/2;
        [scrollView addSubview:imageView];
        avatarImgView = imageView;
    }
    
    {
        CGFloat labelHeight = (containerView.height - CGRectGetMaxY(avatarImgView.frame))/self.detailModel.infoArray.count;
        for (int i = 0; i < self.detailModel.infoArray.count; i++) {
            NSString *text = self.detailModel.infoArray[i];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(avatarImgView.frame) + i*labelHeight, 150, labelHeight)];
            label.text = text;
            label.font = [UIFont systemFontOfSize:14];
            [scrollView addSubview:label];
            [label sizeToFit];
            label.x = avatarImgView.centerX - 60;
        }
    }
    
}

- (void)showActorDetailView:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    CGFloat yOffset = 0;
    if (self.detailView.y < kNavigationBarHeight) {
        yOffset = kNavigationBarHeight;
    }else{
        yOffset = - (self.detailView.height - 30 ) + kNavigationBarHeight;
    }
    
    [UIView animateWithDuration:0.25 delay:0. usingSpringWithDamping:0.4 initialSpringVelocity:0. options:UIViewAnimationOptionCurveLinear animations:^{
        self.detailView.y = yOffset;
    } completion:^(BOOL finished) {
        
    }];
    
    CGFloat angle = 0.0;
    if (sender.selected) {
        angle = M_PI;
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:0.f];
    animation.toValue = [NSNumber numberWithFloat: angle];
    animation.duration = 0.25;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [sender.layer addAnimation:animation forKey:nil];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView != self.collectionView) {
        if (scrollView.contentOffset.y > 40) {
            for (UIView *subView in self.detailView.subviews) {
                if ([subView isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)subView;
                    [self showActorDetailView:btn];
                    break;
                }
            }
        }
    }
}

@end







