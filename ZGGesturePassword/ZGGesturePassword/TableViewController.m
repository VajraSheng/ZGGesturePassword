//
//  TableViewController.m
//  ZGGesturePassword
//
//  Created by 盛振国 on 15/7/14.
//  Copyright (c) 2015年 盛振国. All rights reserved.
//

#import "TableViewController.h"
#import "ZGLockViewController.h"

@interface TableViewController ()


@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.title = @"管理手势密码";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [ZGLockViewController hasPassword] ? 4 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterAtIndexPath:(NSIndexPath *)indexPath
{
    return 5.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"手势密码";
        UISwitch *allowGesturePwdSwitch = [[UISwitch alloc] init];
        [allowGesturePwdSwitch setOn:[ZGLockViewController hasPassword] animated:YES];
        [allowGesturePwdSwitch addTarget:self action:@selector(changeAllowGesturePwdState:) forControlEvents:UIControlEventValueChanged];
        cell.accessoryView = allowGesturePwdSwitch;
    }else if (indexPath.section == 1) {
        cell.textLabel.text = @"显示验证时手势痕迹";
        UISwitch *allowLineSwitch = [[UISwitch alloc] init];
        [allowLineSwitch addTarget:self action:@selector(changeAllowLineState:) forControlEvents:UIControlEventValueChanged];
        [allowLineSwitch setOn:[ZGLockViewController allowShowLineTrail] animated:YES];
        cell.accessoryView = allowLineSwitch;
    }else if (indexPath.section == 2) {
        cell.textLabel.text = @"修改手势密码";
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.textLabel.text = @"验证手势密码";
        //如果不设置accessoryView为nil，在从无密码到有密码之后此行将显示 第二行 的开关view
        cell.accessoryView = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        [ZGLockViewController showModifyPwdViewControllerOnVC:self
                                                 successBlock:^(ZGLockViewController *lockVC, NSString *password) {
                                                     [lockVC dismiss:0];
                                                 }];
    }
    if (indexPath.section == 3) {
        [ZGLockViewController showVerifyPwdViewControllerOnVC:self
                                               forgetPwdBlock:^{}
                                                 successBlock:^(ZGLockViewController *lockVC, NSString *pwd) {
                                                     [lockVC dismiss:0];
                                                 }];
    }
}

//是否开启手势密码
- (void)changeAllowGesturePwdState:(UISwitch *)allowGesturePwdSwitch
{
    if (allowGesturePwdSwitch.on) {
        [ZGLockViewController showSetPwdViewControllerOnVC:self successBlock:^(ZGLockViewController *lockVC, NSString *password) {
            [lockVC dismiss:0.5f];
        }];
    }else{
        [ZGLockViewController showClosePwdViewControllerOnVC:self];
    }
}

//是否显示验证手势痕迹
- (void)changeAllowLineState:(UISwitch *)allowLineSwitch
{
    if (allowLineSwitch.on) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kZGAllowVerifyLineTrail];
    }else
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kZGAllowVerifyLineTrail];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
