//
//  findFriendViewController.m
//  naamee
//
//  Created by MAC on 26/01/19.
//  Copyright © 2019 Techmorale. All rights reserved.
//

#import "findFriendViewController.h"
#import "AsyncImageView.h"
#import "Helper.h"
#import "AFNetworking.h"
#import "otherUserProfileView.h"
@interface findFriendViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UISearchBar *searchBarr;
    int searchdone;
    UITableView *fTable;
    NSMutableArray *fList;
    NSMutableArray *arrSearchList;
    NSMutableArray *fList1;
}
@end

@implementation findFriendViewController
-(void)viewWillAppear:(BOOL)animated
{
    searchdone=0;
    arrSearchList = [[NSMutableArray alloc]init];
    fList1 = [[NSMutableArray alloc]init];
    [self getList];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=true;
    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self.view addSubview: navigationView];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nameBtn.frame = CGRectMake(self.view.frame.size.width/2-100, 24, 200, 40);
    nameBtn.backgroundColor=[UIColor clearColor];
    nameBtn.titleLabel.font=[UIFont fontWithName:@"Arial" size:16.0f];
    [nameBtn setTitle:[NSString stringWithFormat:@"%@",@"Find Friends"] forState:UIControlStateNormal];
    [nameBtn setTintColor:[UIColor whiteColor]];
    [navigationView addSubview:nameBtn];
    
    UIButton *backButton =[[UIButton alloc]initWithFrame:CGRectMake(20, 26, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    searchBarr = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, 40)];
    searchBarr.delegate = self;
    searchBarr.barTintColor = [UIColor whiteColor];
    searchBarr.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:searchBarr];
    
    
    [searchBarr becomeFirstResponder];
    
    fTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, self.view.frame.size.width, self.view.frame.size.height-115) style:UITableViewStylePlain];
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
-(void)getList
{
    
    [Helper showIndicatorWithText:@"Updating..." inView:self.view];
    


    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"getUserList",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"page"  :@"1"
                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        [Helper hideIndicatorFromView:self.view];
        NSLog(@"json userlist : %@",json);
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            self->fList=[[json valueForKey:@"UsersList"]mutableCopy];
//            if(self->searchdone == 1){
//                self->fList1 = [self->arrSearchList mutableCopy];
//            }else{
                self->fList1 = [self->fList mutableCopy];
//            }
            
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
#pragma mark -- Searchbar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        
        searchdone = 0;
        self->fList1 = [fList mutableCopy];
//       [self getList];
        [self->searchBarr endEditing:YES];
        
    }
    
    else {
        
       searchdone = 1;
        [arrSearchList removeAllObjects];
        [fList1 removeAllObjects];
        for (int i=0 ; i<= fList.count-1; i++) {
            NSLog(@"name :%@",[[fList objectAtIndex:i]valueForKey:@"username"]);
            NSLog(@"searchText :%@",searchText);
            NSRange range = [[[fList objectAtIndex:i]valueForKey:@"username"] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            NSLog(@"range :%lu",range.location);
            if (range.location != NSNotFound) {
                
                [arrSearchList addObject:[fList objectAtIndex:i]];
                
            }
            
        }
         fList1= [arrSearchList mutableCopy];
       
       
    }
    NSLog(@"fList1 :%d",fList1.count);
    [self->fTable reloadData];
   
   
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBarr resignFirstResponder];
    searchBarr.showsCancelButton=NO;
    searchBarr.text=@"";
    self->fList1 = [fList mutableCopy];
//    [self getList];
    searchdone = 0;
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBarr.showsCancelButton=NO;
    [searchBarr resignFirstResponder];
    searchBarr.text=@"";
    searchdone = 0;
    self->fList1 = [fList mutableCopy];
//    [self getList];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBarr.showsCancelButton=YES;
    searchBarr.returnKeyType=UIReturnKeySearch;
    
    return YES;
}
#pragma mark -- TableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(searchdone == 1){
//         NSLog(@"arrSearchList :%d",arrSearchList.count);
//        return arrSearchList.count;
//    }
    return fList1.count;
    
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
    userImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[[fList1 objectAtIndex:indexPath.row]valueForKey:@"profile_pic"]]];
    [cell addSubview:userImage];
    
    UILabel *namelbl = [[UILabel alloc]initWithFrame:CGRectMake(80, 15,200, 40)];
    namelbl.text = [[fList1 objectAtIndex:indexPath.row]valueForKey:@"username"];
    namelbl.font=[UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
    namelbl.backgroundColor = [UIColor clearColor];
    namelbl.textColor = [UIColor blackColor];
    namelbl.textAlignment = NSTextAlignmentLeft;
    [cell addSubview:namelbl];
    
    UIButton *folowBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    folowBtn.frame = CGRectMake(self.view.frame.size.width-100, 2.5, 90, 65);
    folowBtn.backgroundColor=[UIColor clearColor];
    folowBtn.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
    folowBtn.imageEdgeInsets = UIEdgeInsetsMake(0,42, 0, 0);
    folowBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -50, 0);
    [folowBtn addTarget:self action:@selector(follow_Action:) forControlEvents:UIControlEventTouchUpInside];
    folowBtn.tag=indexPath.row+1;
    if([[[fList1 objectAtIndex:indexPath.row]valueForKey:@"following_status"]intValue]==0 && [[[fList1 objectAtIndex:indexPath.row]valueForKey:@"they_follow_me"]intValue]==1)
    {
        UIImage *image2 = [[UIImage imageNamed:@"none_following"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [folowBtn setImage:image2 forState:UIControlStateNormal];
        [folowBtn setTitle:@"Follow Back" forState:UIControlStateNormal];
    }
    else if([[[fList1 objectAtIndex:indexPath.row]valueForKey:@"following_status"]intValue]==0 && [[[fList1 objectAtIndex:indexPath.row]valueForKey:@"they_follow_me"]intValue]==0)
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
//    NSMutableArray *fList1 = [[NSMutableArray alloc]init];
//    if(searchdone == 1){
//        fList1= [arrSearchList mutableCopy];
//    }else{
//        fList1= [fList mutableCopy];
//    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[[fList1 objectAtIndex:indexPath.row]valueForKey:@"id"] forKey:@"otherUserId"];
    [userDefaults synchronize];
    
    otherUserProfileView *smvc = [[otherUserProfileView alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
    
}
-(void)follow_Action:(UIButton*)btn
{
//    NSMutableArray *fList1 = [[NSMutableArray alloc]init];
//    if(searchdone == 1){
//        fList1= [arrSearchList mutableCopy];
//    }else{
//        fList1= [fList mutableCopy];
//    }
    int  followingOrNot = [[[fList1 objectAtIndex:btn.tag-1]valueForKey:@"following_status"]intValue];
    if(followingOrNot==0)
    {
        [Helper showIndicatorWithText:@"Please Wait..." inView:self.view];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{
                                 @"method"       : @"addFollowers",
                                 @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                                 @"toWhomFollow"       : [[fList1 objectAtIndex:btn.tag-1]valueForKey:@"id"],
                                 
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
        
                if(self->searchdone == 1){
                    NSDictionary *dic=[self->fList1 objectAtIndex:btn.tag-1];
                    NSMutableDictionary *details=[dic mutableCopy];
                    [details setObject:[NSNumber numberWithInteger:1] forKey:@"following_status"];
                    
                    [self->fList1 insertObject:details atIndex:btn.tag-1];
                    [self->fList1 removeObjectAtIndex:btn.tag];
                    self->arrSearchList = [self->fList1 mutableCopy];
                    [self-> fTable reloadData];
                    for(int i=0; i<self->fList.count;i++){
                        if([[[self->fList1 objectAtIndex:btn.tag-1]valueForKey:@"id"]intValue] == [[[self->fList objectAtIndex:i]valueForKey:@"id"]intValue] ){
                            NSDictionary *dic=[self->fList objectAtIndex:i];
                            NSMutableDictionary *details=[dic mutableCopy];
                            [details setObject:[NSNumber numberWithInteger:1] forKey:@"following_status"];
                            
                            [self->fList insertObject:details atIndex:i];
                            [self->fList removeObjectAtIndex:i+1];
//                             NSLog(@"fList : %@",[self->fList objectAtIndex:i]);
                        }
                    }
                }else{
                    
                    [self getList];
                }
                
//                [[self->fList1 objectAtIndex:btn.tag-1] setValue:[NSNumber numberWithInteger:1] forKey:@"following_status"];
////                [self getList];
//                [self->fTable reloadData];
                
            }
            else
            {
                NSDictionary *dic=[self->fList1 objectAtIndex:btn.tag-1];
                NSMutableDictionary *details=[dic mutableCopy];
                [details setObject:[NSNumber numberWithInteger:0] forKey:@"following_status"];
                
                [self->fList1 insertObject:details atIndex:btn.tag-1];
                [self->fList1 removeObjectAtIndex:btn.tag];
                
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
                                 @"toWhomFollow"       : [[fList1 objectAtIndex:btn.tag-1]valueForKey:@"id"],
                                 
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
//                 [[self->fList1 objectAtIndex:btn.tag-1] setObject:followingOrNot forKey:@"following_status"];
//                NSMutableDictionary *dict = [self->fList1 objectAtIndex:btn.tag-1];
//                NSLog(@"dict1: %@", [dict valueForKey:@"following_status"]);
                if(self->searchdone == 1){
                    NSDictionary *dic=[self->fList1 objectAtIndex:btn.tag-1];
                    NSMutableDictionary *details=[dic mutableCopy];
                    [details setObject:[NSNumber numberWithInteger:0] forKey:@"following_status"];
                    
                    [self->fList1 insertObject:details atIndex:btn.tag-1];
                    [self->fList1 removeObjectAtIndex:btn.tag];
                    self->arrSearchList = [self->fList1 mutableCopy];
                    [self-> fTable reloadData];
                    for(int i=0; i<self->fList.count;i++){
                        //                        NSLog(@"id1 : %d",[[[self->fList1 objectAtIndex:btn.tag-1]valueForKey:@"id"]intValue]);
                        //                        NSLog(@"id : %d",[[[self->fList objectAtIndex:i]valueForKey:@"id"]intValue]);
                        if([[[self->fList1 objectAtIndex:btn.tag-1]valueForKey:@"id"]intValue] == [[[self->fList objectAtIndex:i]valueForKey:@"id"]intValue] ){
                            NSDictionary *dic=[self->fList objectAtIndex:i];
                            NSMutableDictionary *details=[dic mutableCopy];
                            [details setObject:[NSNumber numberWithInteger:0] forKey:@"following_status"];
                            
                            [self->fList insertObject:details atIndex:i];
                            [self->fList removeObjectAtIndex:i+1];
                            //                             NSLog(@"fList : %@",[self->fList objectAtIndex:i]);
                        }
                    }
                }else{
                    [self getList];
                }
//                 [[self->fList1 objectAtIndex:btn.tag-1] setValue:[NSNumber numberWithInteger:0] forKey:@"following_status"];
//              [self->fTable reloadData];
//                [self getList];
                
            }
            else
            {
                NSDictionary *dic=[self->fList1 objectAtIndex:btn.tag-1];
                NSMutableDictionary *details=[dic mutableCopy];
                [details setObject:[NSNumber numberWithInteger:1] forKey:@"following_status"];
                
                [self->fList1 insertObject:details atIndex:btn.tag-1];
                [self->fList1 removeObjectAtIndex:btn.tag];
                
                [Helper showAlertViewWithTitle:OOPS message:[json valueForKey:@"message"]];
            }
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [Helper hideIndicatorFromView:self.view];
            
        }];
    }
}

@end
