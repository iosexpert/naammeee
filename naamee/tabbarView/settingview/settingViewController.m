//
//  settingViewController.m
//  naamee
//
//  Created by MAC on 18/01/19.
//  Copyright © 2019 Techmorale. All rights reserved.
//

#import "settingViewController.h"
#import "ViewController.h"
#import "findFriendViewController.h"
@interface settingViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray *settingArr;
}
@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    settingArr=[[NSArray alloc]initWithObjects:@"Find Friends",@"Logout", nil];
    self.navigationController.navigationBarHidden=true;
    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self.view addSubview: navigationView];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nameBtn.frame = CGRectMake(self.view.frame.size.width/2-100, 24, 200, 40);
    nameBtn.backgroundColor=[UIColor clearColor];
    nameBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:16.0f];
    [nameBtn setTitle:[NSString stringWithFormat:@"%@",@"Settings"] forState:UIControlStateNormal];
    [nameBtn setTintColor:[UIColor whiteColor]];
    [navigationView addSubview:nameBtn];
    
    UIButton *backButton =[[UIButton alloc]initWithFrame:CGRectMake(20, 26, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
   UITableView *fTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-50) style:UITableViewStylePlain];
    fTable.delegate = self;
    fTable.dataSource = self;
    fTable.tag=0;
    fTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    fTable.backgroundColor = [UIColor clearColor];
    fTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:fTable];
    
}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- TableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return settingArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    for (UIView *v in cell.contentView.subviews)
    {
        [v removeFromSuperview];
    }
    UILabel *namelbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 5,280, 40)];
    namelbl.text = [settingArr objectAtIndex:indexPath.row];
    namelbl.font=[UIFont fontWithName:@"Arial" size:18.0f];
    namelbl.backgroundColor = [UIColor clearColor];
    namelbl.textColor = [UIColor blackColor];
    namelbl.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:namelbl];
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
    v.backgroundColor=[UIColor lightGrayColor];
    v.alpha=0.4;
    [cell addSubview:v];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        
        findFriendViewController *smvc = [[findFriendViewController alloc]init];
        [self.navigationController pushViewController:smvc animated:YES];
        
        
    }
    else
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@"" forKey:@"userid"];
        [userDefaults synchronize];
        ViewController *fpvc=[[ViewController alloc]init];
        UINavigationController *navControl=[[UINavigationController alloc]initWithRootViewController:fpvc];
        [[[UIApplication sharedApplication] delegate] window].rootViewController=navControl;
        
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
@end
