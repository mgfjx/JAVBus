//
//  AddressSettingController.m
//  JAVBus
//
//  Created by mgfjx on 2018/12/23.
//  Copyright © 2018 mgfjx. All rights reserved.
//

#import "AddressSettingController.h"
#import "AddressCell.h"

@interface AddressSettingController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView ;
@property (nonatomic, strong) NSArray *dataArray ;

@end

@implementation AddressSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"地址设置";
    
    [self initViews];
    NSArray *ips = [GlobalTool shareInstance].ips ;
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *ip in ips) {
        AddressModel *model = [AddressModel new];
        model.ipAddress = ip;
        NSString *baseUrl = [GlobalTool shareInstance].baseUrl;
        model.selected = [ip isEqualToString:baseUrl];
        model.type = AddressTypeFailed;
        [array addObject:model];
    }
    
    self.dataArray = [array copy];
    [self testIp];
    [self createBarButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createBarButton {
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addHTTPIP)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"address_refresh"] style:UIBarButtonItemStylePlain target:self action:@selector(testIp)];
    self.navigationItem.rightBarButtonItems = @[item, item2];
    
}

- (void)addHTTPIP {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加域名地址" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        UITextField *tf = alertController.textFields.firstObject;
        NSString *ip = tf.text;
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
        [array addObject:ip];
        [GlobalTool shareInstance].ips = [array copy];
        self.dataArray = [GlobalTool shareInstance].ips;
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    }];
    // 在输入文字前，我们要冻结“确定”按钮
    okAction.enabled = NO;
    [alertController addAction:okAction];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入域名";
        // 是否安全输入
        textField.secureTextEntry = NO;
        // 添加一个通知，改变okAction的状态
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *tf = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        // 设置okAction的状态，是否可点击
        okAction.enabled = tf.text.length > 0;
    }
}

- (void)initViews {
    UITableView *table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    
    [self.view addSubview:table];
    self.tableView = table;
    table.tableFooterView = [UIView new];
    
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kNavigationBarHeight);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [table registerNib:[UINib nibWithNibName:NSStringFromClass([AddressCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([AddressCell class])];
}

- (void)testIp {
    for (AddressModel *model in self.dataArray) {
        model.type = AddressTypeLoading;
        [self.tableView reloadData];
        [HTMLTOJSONMANAGER testIp:model.ipAddress callback:^(NSArray *array) {
            if (array.count > 0) {
                model.type = AddressTypeSuccess;
            }else {
                model.type = AddressTypeFailed;
            }
            [self.tableView reloadData];
        }];
    }
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellReuse = NSStringFromClass([AddressCell class]);
    AddressCell *cell = (AddressCell *)[tableView dequeueReusableCellWithIdentifier:cellReuse];
    
    AddressModel *model = self.dataArray[indexPath.row];
    cell.model = model ;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    for (AddressModel *model in self.dataArray) {
        model.selected = NO;
    }
    
    AddressModel *currentModel = self.dataArray[indexPath.row];
    currentModel.selected = YES;
    [GlobalTool shareInstance].baseUrl = currentModel.ipAddress;
    [tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

@end


@implementation AddressModel


@end
