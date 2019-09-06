//
//  locationSearchViewController.m
//  naamee
//
//  Created by MAC on 10/02/19.
//  Copyright © 2019 Techmorale. All rights reserved.
//

#import "locationSearchViewController.h"
#import "Helper.h"
#import "AFNetworking.h"
#import <CoreLocation/CoreLocation.h>

@interface locationSearchViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>
{
    UISearchBar *searchBarr;
    int searchdone;
    NSArray *settingArr,*settingArrCopy,*settingArr1,*settingArrCopy1,*latArr,*latArrCopy,*longiArr,*longiArrCopy;
    UITableView *fTable;
    CLLocationManager *locationManager;
    UIActivityIndicatorView *spinner;
    
    double lat,lng;
}
@end

@implementation locationSearchViewController

- (void)viewDidLoad {
    searchdone=0;
    
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.delegate=self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    [locationManager startUpdatingLocation];
    [locationManager requestAlwaysAuthorization];
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self.tabBarController.tabBar setHidden:false];
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
   
    //set frame for activity indicator
    
    [spinner setHidden:true];
    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor=[UIColor blackColor];
   
    [self.view addSubview:navigationView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(10, 20, 30, 30);
    UIImage *imag=[[UIImage imageNamed:@"backArrow"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton setImage:imag forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back_Action) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
//    spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50, navigationView.frame.size.height-45, 30, 30)];
//
    spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-50, 17, 30, 30)];
    
    [navigationView addSubview:spinner];
    
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
//    [self nearLocationList];
}
-(void)back_Action
{
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"loc"];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"loclat"];
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"loclng"];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)nearLocationList{
        NSDictionary *paramss=@{
                                @"method"     :@"getLocation",
                                @"lat"        :[NSString stringWithFormat:@"%f",lat],
                                @"long"        :[NSString stringWithFormat:@"%f",lng],
                                };
        
        NSLog(@"nearLocationList Request: %@", paramss);
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = nil;
        [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:paramss progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:nil];
            NSLog(@"JSON nearLocationList: %@", json);
           
            if ([[json objectForKey:@"success"]integerValue]==1)
            {
                NSLog(@"Title%@",[[[json objectForKey:@"Location"]valueForKey:@"title"]mutableCopy]);
                NSLog(@"Small%@",[[[json objectForKey:@"Location"]valueForKey:@"small"]mutableCopy]);
            
                self->settingArr=[[[json objectForKey:@"Location"]valueForKey:@"title"]mutableCopy];
                self->settingArrCopy = [self->settingArr mutableCopy];
              
                self->settingArr1=[[[json objectForKey:@"Location"]valueForKey:@"small"]mutableCopy];
                self->settingArrCopy1 = [self->settingArr1 mutableCopy];
                
                self->latArr=[[[[json objectForKey:@"Location"]valueForKey:@"geocode"]valueForKey:@"lat"]mutableCopy];
                self->latArrCopy = [self->latArr mutableCopy];
                
                self->longiArr=[[[[json objectForKey:@"Location"]valueForKey:@"geocode"]valueForKey:@"lng"]mutableCopy];
                self->longiArrCopy = [self->longiArr mutableCopy];
                
                
                [self->fTable reloadData];

                
            }
            else
            {
                
            }
            
            
            
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            [Helper hideIndicatorFromView:self.view];
            
        }];
        
    
}

-(NSString *)convertToCommaSeparatedFromArray:(NSArray*)array{
    return [array componentsJoinedByString:@","];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"empty_search%lu", (unsigned long)searchBar.text.length );
    if(searchBar.text.length == 0){
        
        self->settingArr = [self->settingArrCopy mutableCopy];
        self->settingArr1 = [self->settingArrCopy1 mutableCopy];
        self->latArr = [self->latArrCopy mutableCopy];
        self->longiArr = [self->longiArrCopy mutableCopy];
        [self->fTable reloadData];
        return;
    
    }
    if(searchBar.text.length>=3)
    {
        if(searchdone==0 )
        {
            searchdone=1;
            NSDictionary *paramss=@{
                                    @"method"     :@"getLocationByString",
                                    @"address"    :searchBarr.text,
                                    @"lat"        :[NSString stringWithFormat:@"%f",lat],
                                    @"long"        :[NSString stringWithFormat:@"%f",lng],
                                    };
           
            NSLog(@"Request: %@", paramss);
//            [Helper showIndicatorWithText:@"" inView:self.view];
            [spinner setHidden:false];
            [spinner startAnimating];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = nil;
            [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:paramss progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:kNilOptions
                                                                       error:nil];
                NSLog(@"JSON textDidChange: %@", json);
//                [Helper hideIndicatorFromView:self.view];
                [self->spinner setHidden:true];
                [self->spinner stopAnimating];
                 self->searchdone=0;
                if ([[json objectForKey:@"success"]integerValue]==1)
                {
                    NSLog(@"title %@",[[json objectForKey:@"Location"]valueForKey:@"title"]);
                    NSLog(@"small %@",[[json objectForKey:@"Location"]valueForKey:@"small"]);
                    NSLog(@"geocode %@",[[json objectForKey:@"Location"]valueForKey:@"lat"]);
                    NSLog(@"geocode %@",[[json objectForKey:@"Location"]valueForKey:@"lat"]);
                    
                   /* self->settingArr=[[[json objectForKey:@"Location"]valueForKey:@"address"]mutableCopy];
                    self->settingArrCopy = [self->settingArr mutableCopy];
                    
                    self->latArr=[[[[json objectForKey:@"Location"]valueForKey:@"location"]valueForKey:@"lat"]mutableCopy];
                    self->latArrCopy = [self->latArr mutableCopy];
                    
                    self->longiArr=[[[[json objectForKey:@"Location"]valueForKey:@"location"]valueForKey:@"long"]mutableCopy];
                    self->longiArrCopy = [self->longiArr mutableCopy];*/
                    
                    self->settingArr=[[[json objectForKey:@"Location"]valueForKey:@"title"]mutableCopy];
                    //self->settingArrCopy = [self->settingArr mutableCopy];
                    self->settingArr1=[[[json objectForKey:@"Location"]valueForKey:@"small"]mutableCopy];
                    
                    
                    self->latArr=[[[[json objectForKey:@"Location"]valueForKey:@"geocode"]valueForKey:@"lat"]mutableCopy];
                  //  self->latArrCopy = [self->latArr mutableCopy];
                    
                    self->longiArr=[[[[json objectForKey:@"Location"]valueForKey:@"geocode"]valueForKey:@"lng"]mutableCopy];
                 //   self->longiArrCopy = [self->longiArr mutableCopy];
                    
                    
                    if ([[json objectForKey:@"message"]  isEqual: @"Location not found."]){
                        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self->fTable.bounds.size.width, self->fTable.bounds.size.height)];
                        noDataLabel.text             = @"Location not found.";
                        noDataLabel.textColor        = [UIColor blackColor];
                        noDataLabel.textAlignment    = NSTextAlignmentCenter;
                        self->fTable.backgroundView = noDataLabel;
                        self->fTable.separatorStyle = UITableViewCellSeparatorStyleNone;
                        //                        [self->fTable reloadData];
                    }
                    [self->fTable reloadData];
                   
                    
                }
                
                
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                
                [Helper hideIndicatorFromView:self.view];
                 self->searchdone=0;
            }];
            
        }
        
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBarr resignFirstResponder];
    if(searchBar.text.length == 0){
        self->settingArr = [self->settingArrCopy mutableCopy];
        self->settingArr1=[self->settingArrCopy1 mutableCopy];
        self->latArr = [self->latArrCopy mutableCopy];
        self->longiArr = [self->longiArrCopy mutableCopy];
        [self->fTable reloadData];
        return;
        
    }
    //if(searchBar.text.length>=3)
    //{
        if(searchdone==0 )
        {
        searchdone=1;
            NSDictionary *paramss=@{
                                    @"method"     :@"getLocationByString",
                                    @"address"    :searchBarr.text,
                                    @"lat"        :[NSString stringWithFormat:@"%f",lat],
                                    @"long"        :[NSString stringWithFormat:@"%f",lng],
                                    };
            
            
            NSLog(@"Request : %@", paramss);
//            [Helper showIndicatorWithText:@"" inView:self.view];
            [self->spinner setHidden:false];
            [self->spinner startAnimating];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = nil;
            [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:paramss progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                     options:kNilOptions
                                                                       error:nil];
                NSLog(@"JSON searchBarSearchButtonClicked: %@", json);
                [self->spinner setHidden:true];
                [self->spinner stopAnimating];
//                [Helper hideIndicatorFromView:self.view];
                self->searchdone=0;
                if ([[json objectForKey:@"success"]integerValue]==1)
                {
                    NSLog(@"title %@",[[json objectForKey:@"Location"]valueForKey:@"title"]);
                    NSLog(@"small %@",[[json objectForKey:@"Location"]valueForKey:@"small"]);
                    NSLog(@"geocode %@",[[json objectForKey:@"Location"]valueForKey:@"lat"]);
                    NSLog(@"geocode %@",[[json objectForKey:@"Location"]valueForKey:@"lat"]);
                
                   
                   /* self->settingArr=[[[json objectForKey:@"Location"]valueForKey:@"address"]mutableCopy];
                    self->settingArrCopy = [self->settingArr mutableCopy];
                    
                    self->latArr=[[[[json objectForKey:@"Location"]valueForKey:@"location"]valueForKey:@"lat"]mutableCopy];
                    self->latArrCopy = [self->latArr mutableCopy];
                    
                    self->longiArr=[[[[json objectForKey:@"Location"]valueForKey:@"location"]valueForKey:@"long"]mutableCopy];
                    self->longiArrCopy = [self->longiArr mutableCopy];*/
                    
                    self->settingArr=[[[json objectForKey:@"Location"]valueForKey:@"title"]mutableCopy];
                 //   self->settingArrCopy = [self->settingArr mutableCopy];
                   self->settingArr1=[[[json objectForKey:@"Location"]valueForKey:@"small"]mutableCopy];
                    
                    self->latArr=[[[[json objectForKey:@"Location"]valueForKey:@"geocode"]valueForKey:@"lat"]mutableCopy];
               //     self->latArrCopy = [self->latArr mutableCopy];
                    
                    self->longiArr=[[[[json objectForKey:@"Location"]valueForKey:@"geocode"]valueForKey:@"lng"]mutableCopy];
                 //   self->longiArrCopy = [self->longiArr mutableCopy];
                    
                    
                    if ([[json objectForKey:@"message"]  isEqual: @"Location not found."]){
                        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self->fTable.bounds.size.width, self->fTable.bounds.size.height)];
                        noDataLabel.text             = @"Location not found.";
                        noDataLabel.textColor        = [UIColor blackColor];
                        noDataLabel.textAlignment    = NSTextAlignmentCenter;
                        self->fTable.backgroundView = noDataLabel;
                        self->fTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//                        [self->fTable reloadData];
                    }
                    [self->fTable reloadData];
                    

                }
                else
                {
                    
                }
                
                
                
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
                self->searchdone=0;
                [Helper hideIndicatorFromView:self.view];
                
            }];
        
        }
        
    //}
    searchBarr.showsCancelButton=NO;
    //searchBarr.text=@"";
    
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBarr.showsCancelButton=NO;
    [searchBarr resignFirstResponder];
    searchBarr.text=@"";
    self->settingArr = [self->settingArrCopy mutableCopy];
    self->settingArr1 = [self->settingArrCopy1 mutableCopy];
    self->latArr = [self->latArrCopy mutableCopy];
    self->longiArr = [self->longiArrCopy mutableCopy];
    [self->fTable reloadData];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBarr.showsCancelButton=YES;
    searchBarr.returnKeyType=UIReturnKeySearch;
    
    return YES;
}

#pragma mark -- TableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (settingArr.count > 0)
    {
        tableView.backgroundView = nil;
    }
    else
    {
//        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height)];
//        noDataLabel.text             = @"Location not found.";
//        noDataLabel.textColor        = [UIColor blackColor];
//        noDataLabel.textAlignment    = NSTextAlignmentCenter;
//        tableView.backgroundView = noDataLabel;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }

    return settingArr.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    for (UIView *v in cell.contentView.subviews)
    {
        [v removeFromSuperview];
    }
    UILabel *namelbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 280, 20)];
    
    UILabel *namelbl1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, 280, 20)];
//    NSString *temp = [settingArr objectAtIndex:indexPath.row];
//    NSArray *items = [temp componentsSeparatedByString:@","];
//    namelbl.text = items.lastObject;
//    namelbl1.text = items.firstObject;

        namelbl.text = [settingArr objectAtIndex:indexPath.row];
        namelbl1.text = [settingArr1 objectAtIndex:indexPath.row];
    
    
    
    namelbl.font=[UIFont fontWithName:@"Arial" size:18.0f];
    namelbl1.font=[UIFont fontWithName:@"Arial" size:14.0f];
    namelbl.backgroundColor = [UIColor clearColor];
    namelbl.textColor = [UIColor blackColor];
    namelbl1.textColor = [UIColor lightGrayColor];
    namelbl.textAlignment = NSTextAlignmentLeft;
    namelbl1.textAlignment = NSTextAlignmentLeft;
    
    [cell addSubview:namelbl];
    [cell addSubview:namelbl1];
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(0, 49, self.view.frame.size.width, 1)];
    v.backgroundColor=[UIColor lightGrayColor];
    v.alpha=0.4;
    [cell addSubview:v];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults]setValue:settingArr[indexPath.row] forKey:@"loc"];
    [[NSUserDefaults standardUserDefaults]setValue:latArr[indexPath.row] forKey:@"loclat"];
    [[NSUserDefaults standardUserDefaults]setValue:longiArr[indexPath.row] forKey:@"loclng"];
    [self.navigationController popViewControllerAnimated:YES];

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
#pragma mark - Location Manager delegates

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError*)error {
    NSLog(@"Location manager error: %@", error.localizedDescription);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation * currentLocation = [locations lastObject];
    // myLocation= [locations lastObject];
    lat=currentLocation.coordinate.latitude;
    lng=currentLocation.coordinate.longitude;
    NSLog(@"Updated Lat %f",currentLocation.coordinate.longitude);
    NSLog(@"Updated Lang %f",currentLocation.coordinate.latitude);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",lat] forKey:@"lat"];
    [userDefaults setObject:[NSString stringWithFormat:@"%f",lng] forKey:@"long"];
    [userDefaults synchronize];
    
    [locationManager stopUpdatingLocation];
    if(self->settingArr.count == 0){
        [self nearLocationList];
    }
}
@end
