//
//  otherFollowingListView.m
//  naamee
//
//  Created by MAC on 17/01/19.
//  Copyright © 2019 Techmorale. All rights reserved.
//

#import "otherFollowingListView.h"
#import "AsyncImageView.h"
#import "Helper.h"
#import "AFNetworking.h"
#import "otherUserProfileView.h"

@interface otherFollowingListView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *fTable;
    NSMutableArray *fList;
}
@end

@implementation otherFollowingListView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backView];
    
    self.navigationController.navigationBarHidden=true;
    
    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self.view addSubview: navigationView];
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIButton *backButton =[[UIButton alloc]initWithFrame:CGRectMake(20, 30, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    UILabel *namelbl = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-125, 30, 250, 30)];
    namelbl.text = @"Followings";
    namelbl.font=[UIFont fontWithName:@"Arial-BoldMT" size:18.0f];
    namelbl.backgroundColor = [UIColor clearColor];
    namelbl.textColor = [UIColor whiteColor];
    namelbl.textAlignment = NSTextAlignmentCenter;
    [navigationView addSubview:namelbl];
    
    
    fTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-50) style:UITableViewStylePlain];
    fTable.delegate = self;
    fTable.dataSource = self;
    fTable.tag=0;
    fTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    fTable.backgroundColor = [UIColor clearColor];
    fTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:fTable];
    
    
    
    [self getList];
    
}
-(void)getList
{
    
    [Helper showIndicatorWithText:@"Updating..." inView:self.view];
    
    
    
  
AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"otherUserfollowing",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"otheruserid"  :[[NSUserDefaults standardUserDefaults]valueForKey:@"otherUserIdd"]
                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        NSLog(@"JSON: %@", [json valueForKey:@"myfollowers"]);
        [Helper hideIndicatorFromView:self.view];
        
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            self->fList=[[json valueForKey:@"myfollowers"]mutableCopy];
            [self->fTable reloadData];
            
        }
        else
        {
            [Helper showAlertViewWithTitle:OOPS message:[json valueForKey:@"message"]];
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- TableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fList.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    for (UIView *v in cell.contentView.subviews)
    {
        [v removeFromSuperview];
    }
    
    AsyncImageView *userImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
    userImage.layer.borderWidth=0.5;
    userImage.layer.cornerRadius=30;
    userImage.layer.borderColor=[UIColor lightGrayColor].CGColor;
    userImage.clipsToBounds=YES;
    userImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[[fList objectAtIndex:indexPath.row]valueForKey:@"profile_pic"]]];
    [cell addSubview:userImage];
    
    UILabel *namelbl = [[UILabel alloc]initWithFrame:CGRectMake(80, 15,200, 40)];
    namelbl.text = [[fList objectAtIndex:indexPath.row]valueForKey:@"username"];
    namelbl.font=[UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
    namelbl.backgroundColor = [UIColor clearColor];
    namelbl.textColor = [UIColor blackColor];
    namelbl.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:namelbl];
    
    UIButton *folowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    folowBtn.frame = CGRectMake(self.view.frame.size.width-100, 2.5, 90, 65);
    folowBtn.backgroundColor=[UIColor clearColor];
    folowBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
    folowBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 47, 0, 0);
    folowBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -50, 0);
    [folowBtn addTarget:self action:@selector(follow_Action:) forControlEvents:UIControlEventTouchUpInside];
    folowBtn.tag=indexPath.row+1;
    if([[[fList objectAtIndex:indexPath.row]valueForKey:@"iamfollowing"]intValue]==0)
    {
        UIImage *image2 = [[UIImage imageNamed:@"none_following"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [folowBtn setImage:image2 forState:UIControlStateNormal];
        [folowBtn setTitle:@"Follow" forState:UIControlStateNormal];
    }
    else
    {
        UIImage *image2 = [[UIImage imageNamed:@"another_following"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [folowBtn setImage:image2 forState:UIControlStateNormal];
        [folowBtn setTitle:@"Unfollow" forState:UIControlStateNormal];
    }
    [cell addSubview:folowBtn];
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 69, self.view.frame.size.width, 1)];
    v.backgroundColor=[UIColor lightGrayColor];
    v.alpha=0.4;
    [cell addSubview:v];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[[fList objectAtIndex:indexPath.row]valueForKey:@"follower"] forKey:@"otherUserId"];
    [userDefaults synchronize];
    
    otherUserProfileView *smvc = [[otherUserProfileView alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
    
}
-(void)follow_Action:(UIButton*)btn
{
    
    int  followingOrNot = [[[fList objectAtIndex:btn.tag-1]valueForKey:@"iamfollowing"]intValue];
    if(followingOrNot==0)
    {
        [Helper showIndicatorWithText:@"Please Wait..." inView:self.view];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{
                                 @"method"       : @"addFollowers",
                                 @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                 @"toWhomFollow"       : [[fList objectAtIndex:btn.tag-1]valueForKey:@"follower"],
                                 
                                 };
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = nil;
        [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:nil];
            [Helper hideIndicatorFromView:self.view];
            if ([[json objectForKey:@"success"]integerValue]==1)
            {
                
                UIImage *image2 = [[UIImage imageNamed:@"another_following"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [btn setImage:image2 forState:UIControlStateNormal];
                [btn setTitle:@"Unfollow" forState:UIControlStateNormal];
                
                [self getList];
                
            }
            else
            {
                [Helper showAlertViewWithTitle:OOPS message:[json valueForKey:@"message"]];
            }
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [Helper hideIndicatorFromView:self.view];
            
        }];
    }
    else
    {
        [Helper showIndicatorWithText:@"Please Wait..." inView:self.view];
        
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{
                                 @"method"       : @"unFollowUser",
                                 @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                 @"toWhomFollow"       : [[fList objectAtIndex:btn.tag-1]valueForKey:@"follower"],
                                 
                                 };
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = nil;
        [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:nil];
            [Helper hideIndicatorFromView:self.view];
            if ([[json objectForKey:@"success"]integerValue]==1)
            {
                UIImage *image2 = [[UIImage imageNamed:@"none_following"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
                [btn setImage:image2 forState:UIControlStateNormal];
                [btn setTitle:@"Follow" forState:UIControlStateNormal];
                [self getList];
                
            }
            else
            {
                [Helper showAlertViewWithTitle:OOPS message:[json valueForKey:@"message"]];
            }
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [Helper hideIndicatorFromView:self.view];
            
        }];
    }
}

@end
