//
//  ViewController.m
//  example
//
//  Created by JaminZhou on 2019/6/6.
//  Copyright © 2019 JaminZhou. All rights reserved.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>
#import <flutter_boost/FlutterBoost.h>
#import <flutter_bridge/FlutterBridgePlugin.h>

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 16)];
}
    
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
        cell.textLabel.text = @"Flutter Page1";
        break;
        case 1:
        cell.textLabel.text = @"Flutter Page2";
        break;
        default:
        cell.textLabel.text = @"";
        break;
    }
    return cell;
}
    
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc;
    switch (indexPath.row) {
        case 0:
        vc = [FlutterBridgePlugin FLBFlutterViewContainer:@"flutter_page1" params:@{}];
        break;
        case 1:
        vc = [FlutterBridgePlugin FLBFlutterViewContainer:@"flutter_page2" params:@{}];
        break;
        default:
        return;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end
