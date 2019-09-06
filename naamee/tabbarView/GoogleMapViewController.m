//
//  GoogleMapViewController.m
//  naamee
//
//  Created by zennaxx technology on 03/04/19.
//  Copyright © 2019 Techmorale. All rights reserved.
//

#import "GoogleMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface GoogleMapViewController (){
    GMSMapView *mapView;
   
}

@end

@implementation GoogleMapViewController

//- (void)loadView {
//    // Create a GMSCameraPosition that tells the map to display the
//    // coordinate -33.86,151.20 at zoom level 6.
//
//
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=true;
    
    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor=[UIColor blackColor];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(20, 24, 30, 30);
    backButton.backgroundColor=[UIColor clearColor];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [backButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [backButton setTintColor:[UIColor whiteColor]];
    [navigationView addSubview:backButton];
    
    UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nameBtn.frame = CGRectMake(self.view.frame.size.width/2-100, 20, 200, 44);
    nameBtn.backgroundColor=[UIColor clearColor];
    [nameBtn setTitle:@"NAAMEE" forState:UIControlStateNormal];
    [nameBtn setTintColor:[UIColor whiteColor]];
    //[nameBtn.titleLabel setFont:[UIFont fontWithName:@"Chalkduster" size:15.0f]];
    [navigationView addSubview:nameBtn];
     [self.view addSubview: navigationView];
    CLLocationDegrees latitude = 0.0;
    CLLocationDegrees longitude = 0.0;
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"mapLat"] != nil && [[NSUserDefaults standardUserDefaults] objectForKey:@"mapLong"] != nil){
        
       NSString *l = [[NSUserDefaults standardUserDefaults] objectForKey:@"mapLat"];
        
        latitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mapLat"] doubleValue];
        longitude = [[[NSUserDefaults standardUserDefaults] objectForKey:@"mapLong"] doubleValue];
       
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:6];
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) camera:camera];
    mapView.myLocationEnabled = YES;
    [self.view addSubview: mapView];
    
    //    self.view = mapView;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude,longitude);
    marker.title = @"";
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"address"] != nil){
        marker.title = [[NSUserDefaults standardUserDefaults] objectForKey:@"address"];
    }
    
    marker.map = mapView;
    // Do any additional setup after loading the view.
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
