//
//  imageViewController.m
//  naamee
//
//  Created by mac on 13/12/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "imageViewController.h"
#import "Constants.h"
#import "Helper.h"
#import "AsyncImageView.h"
#import "AFNetworking.h"
#import "editPostFilterView.h"
@interface imageViewController ()<UIActionSheetDelegate, UIAlertViewDelegate>
{
    
}
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) NSDictionary *details;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (strong, nonatomic) IBOutlet AsyncImageView *fullImage;

- (IBAction)back:(id)sender;
- (IBAction)moreOptions:(id)sender;
@end

@implementation imageViewController
@synthesize imageName, fullImage;
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
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
    
    _details=[[[NSUserDefaults standardUserDefaults]valueForKey:@"details"]mutableCopy];
    
    UIButton *backButton =[[UIButton alloc]initWithFrame:CGRectMake(20, 30, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    UIButton *menuBtn =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, 30, 30, 30)];
    [menuBtn setImage:[UIImage imageNamed:@"more_menu"] forState:UIControlStateNormal];
    [menuBtn addTarget:self action:@selector(moreOptions:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:menuBtn];
    
    fullImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width)];
    fullImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [_details objectForKey:@"postImage"]]];
    [self.view addSubview:fullImage];

    
}
#pragma mark -- Action Button

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)moreOptions:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit", @"Share", @"Delete", nil];
    sheet.tag=1;
    [sheet showInView:self.view];
}

#pragma mark -- ActionSheet Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1)
    {
        if (buttonIndex==0)
        {
            //edit
            
            editPostFilterView *smvc = [[editPostFilterView alloc]init];
            [[NSUserDefaults standardUserDefaults]setValue:_details forKey:@"postDdetails"];
            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(fullImage.image) forKey:@"currentImage"];
            [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"isCommenting"];
            [self.navigationController pushViewController:smvc animated:YES];
            
//            FiltersViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"filter"];
//            controller.details=_details;
//            controller.capturedImage = fullImage.image;
//            [self.navigationController pushViewController:controller animated:YES];
        }
        else if (buttonIndex==1)
        {
            //share
            NSArray *objectsToShare = @[fullImage.image];
            
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
            
            NSArray *excludeActivities = @[UIActivityTypePrint,
                                           UIActivityTypeSaveToCameraRoll,
                                           UIActivityTypeAddToReadingList];
            
            activityVC.excludedActivityTypes = excludeActivities;
            //if iPhone
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [self presentViewController:activityVC animated:YES completion:nil];
            }
            //if iPad
            else {
                // Change Rect to position Popover
                activityVC.popoverPresentationController.sourceView = _menuBtn;
            }
        }
        else if (buttonIndex==2)
        {
            //delete
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Are you really want to delete this post?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
            alert.tag=1;
            [alert show];
        }
    }
}

#pragma mark -- AlertView Delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1)
    {
        if (buttonIndex==1)
        {
            [Helper showIndicatorWithText:@"Loading..." inView:self.view];
            [self deletePostByPostID:[_details objectForKey:@"postid"]];
        }
    }
}

#pragma mark -- Notification Methods

-(void)deletePost:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteMyPost" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)deletePostByPostID:(NSString *)postID
{
    [Helper showIndicatorWithText:@"Deleting Post..." inView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"deletePost",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"postid"         :postID
                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        NSLog(@"JSON: %@", json);
        [Helper hideIndicatorFromView:self.view];
        
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteMyPost" object:self->_details];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            
            [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
    
    
}
-(void)activityHideIndicator
{
    [Helper hideIndicatorFromView:self.view];
}


@end
