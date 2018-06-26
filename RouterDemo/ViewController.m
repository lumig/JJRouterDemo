//
//  ViewController.m
//  RouterDemo
//
//  Created by luming on 2018/6/25.
//  Copyright © 2018年 luming. All rights reserved.
//

#import "ViewController.h"
#import "JJWebviewVCModuleProtocol.h"
#import "JJRouter.h"
#import "JJLoginProtocol.h"
#import "JJLoginProvider.h"

#import "CTMediator+ModuleLogin.h"
#import "CTMediator+ModuleWebView.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initSubview];
}

- (void)initSubview
{
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];

    
    _titles = @[@"1 protocol跳转Web",@"2 protocol跳转登录",@"3 openUrl跳转web",@"4 openUrl跳转登录",@"5 target-action跳转web",@"6 target-action跳转登录"];
    
    [self.view addSubview:self.tableView];
    
}


#pragma mark  - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
       
        case 0:
        {
            id<JJWebviewVCModuleProtocol> provider = [JJProtocolManager moduleProviderForProtocol:@protocol(JJWebviewVCModuleProtocol)];
            UIViewController *vc =[provider viewControllerWithInfo:@{
                                                                     @"WebUrlString":@"http://www.baidu.com",
                                                                     @"Name":@"小一",
                                                                     } needNew:YES callback:^(id info) {

            }];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
        case 1:
        {
            id<JJLoginProtocol> provider = [JJProtocolManager moduleProviderForProtocol:@protocol(JJLoginProtocol)];
            UIViewController *vc =[provider viewControllerWithInfo:nil needNew:YES callback:^(id info) {
                
            }];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }break;
        case 2:
        {//openurl跳转web
            Action *action = [Action new];
            action.type = JJ_WebView;
            Params *params = [[Params alloc] init];
            //            params.pageID = JJ_LOGIN;
            action.params = params;
            NSDictionary *parms = @{Jump_Key_Action:action, Jump_Key_Param : @{WebUrlString:@"http://www.baidu.com",Name:@"小二"}, Jump_Key_Callback:[JJFunc callback:^(id  _Nullable object) {
                NSLog(@"%@",object);
            }]};
            //            ActionJump(parms);
            
            [JJRouter openURL:@"router://JJActionService/showWebVC" arg: parms error:nil completion:parms[Jump_Key_Callback]];
            
        }
            break;
        case 3:
        {//openurl跳转登录
            Action *action = [Action new];
            action.type = JUMP_INNER_NEW_PAGE;
            Params *params = [[Params alloc] init];
            params.pageID = JJ_LOGIN;
            action.params = params;
            NSDictionary *parms = @{Jump_Key_Action:action, Jump_Key_Param : @"", Jump_Key_Callback:[JJFunc callback:^(id  _Nullable object) {
                NSLog(@"%@",object);
            }]};
            ActionJump(parms);
            
        }
            break;

        case 4:{//target-action webview
            UIViewController *vc = [[CTMediator sharedInstance] push_viewControllerForWebView];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{//target-action 登录
            UIViewController *vc = [[CTMediator sharedInstance] push_viewControllerForLogin];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
        {

        }
            break;
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    if (_titles.count > indexPath.row) {
        cell.textLabel.text = _titles[indexPath.row];
    }
    
    return cell;
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
