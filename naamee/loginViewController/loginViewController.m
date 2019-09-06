//
//  loginViewController.m
//  naamee
//
//  Created by mac on 25/09/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "loginViewController.h"
#import "forgotPasswordViewController.h"
#import "tabbarViewController.h"
#import "Helper.h"
#import "AFNetworking.h"
#import "locationSearchViewController.h"


@interface loginViewController ()<UITextFieldDelegate>
{
    UITextField *passwordfeild,*userNamefeild;
}
@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
//    locationSearchViewController *fpvc=[[locationSearchViewController alloc]init];
//    [self.navigationController pushViewController:fpvc animated:true];
    
    
    UIImageView *backgroundImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backgroundImage.image=[UIImage imageNamed:@"bg-login"];;
    [self.view addSubview:backgroundImage];
    
    
    UIButton *crossBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [crossBtn setBackgroundImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [crossBtn addTarget:self action:@selector(crossAction:) forControlEvents:UIControlEventTouchUpInside];
    crossBtn.frame = CGRectMake(self.view.frame.size.width-55, 30, 35, 35);
    [self.view addSubview:crossBtn];
    
    
    UIImageView *logoimage=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-100, 70, 200, 65)];
    logoimage.image=[UIImage imageNamed:@"logo"];
    [self.view addSubview:logoimage];
    
    
    UIView *feildBackView=[[UIView alloc]initWithFrame:CGRectMake(30, 180, self.view.frame.size.width-60, 100)];
    feildBackView.backgroundColor=[UIColor whiteColor];
    feildBackView.layer.cornerRadius=4.0;
    [self.view addSubview:feildBackView];
    
    
    UIView *sepView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, feildBackView.frame.size.width, 1)];
    sepView.backgroundColor=[UIColor lightGrayColor];
    [feildBackView addSubview:sepView];
    
    
    UIImageView *nlogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 12.5, 25, 25)];
    nlogo.image=[UIImage imageNamed:@"n-logo"];
    [feildBackView addSubview:nlogo];
    
    
    UIImageView *locklogo=[[UIImageView alloc]initWithFrame:CGRectMake(10, 50+12.5, 25, 25)];
    locklogo.image=[UIImage imageNamed:@"lock"];
    [feildBackView addSubview:locklogo];
    
    
    userNamefeild = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 200, 45)];
    userNamefeild.delegate=self;
    userNamefeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNamefeild.keyboardType=UIKeyboardTypeEmailAddress;
    userNamefeild.placeholder=@"Email";
    [userNamefeild addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [feildBackView addSubview:userNamefeild];
    
    
    passwordfeild = [[UITextField alloc] initWithFrame:CGRectMake(50, 55, 200, 45)];
    passwordfeild.delegate=self;
    passwordfeild.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordfeild.placeholder=@"Password";
    passwordfeild.secureTextEntry=true;
    [feildBackView addSubview:passwordfeild];
    
    
    UIButton *namelogin = [UIButton buttonWithType:UIButtonTypeCustom];
    namelogin.backgroundColor=[UIColor colorWithRed:90/255.0 green:162/255.0 blue:209/255.0 alpha:1.0];
    namelogin.layer.cornerRadius=3;
    [namelogin setTitle:@"Log In" forState:UIControlStateNormal];
    [namelogin addTarget:self action:@selector(Login:) forControlEvents:UIControlEventTouchUpInside];
    namelogin.frame = CGRectMake(30, 320, self.view.frame.size.width-60, 50);
    [self.view addSubview:namelogin];
    
    
    UIButton *forgotPassButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgotPassButton setTitle:@"Forgot your password?" forState:UIControlStateNormal];
    [forgotPassButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgotPassButton addTarget:self action:@selector(forgotPass:) forControlEvents:UIControlEventTouchUpInside];
    forgotPassButton.frame = CGRectMake(30, 380, self.view.frame.size.width-60, 50);
    [self.view addSubview:forgotPassButton];
    
//    userNamefeild.text=@"prajapati.shailesh8@gmail.com";
//    passwordfeild.text=@"123";//@"admin";//@;//@"bcc22966";
    // Do any additional setup after loading the view.
}
- (void)textFieldDidChange:(UITextField*)textField {
    textField.text = [textField.text lowercaseString];
}
-(void)crossAction:(UIButton*)btn
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Login:(id)sender
{
    
    
    
    if (userNamefeild.text.length==0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Username" message:@"Please enter username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else if (passwordfeild.text.length==0)
    {
        [[[UIAlertView alloc]initWithTitle:@"Password" message:@"Please enter password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else if ([Helper isInternetConnected]==NO)
    {
        [[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Please check your internet connection!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else
    {

        
        
        [userNamefeild resignFirstResponder];
        [passwordfeild resignFirstResponder];
       
        [Helper showIndicatorWithText:@"Login..." inView:self.view];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSDictionary *params = @{@"method"      : @"userLogin",
                                 @"email"       : userNamefeild.text,
                                 @"password"    : passwordfeild.text,
                                 @"deviceType"  : @"0",
                                 @"deviceToken" : @"123456789",

                                 };
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = nil;
        [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                 options:kNilOptions
                                                                   error:nil];
            NSLog(@"JSON: %@", json);
            [Helper hideIndicatorFromView:self.view];

            if ([[json objectForKey:@"code"]integerValue]==1)
            {
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setObject:[json objectForKey:@"uid"] forKey:@"userid"];
                [userDefaults synchronize];
                
                tabbarViewController *fpvc=[[tabbarViewController alloc]init];
                [[[UIApplication sharedApplication] delegate] window].rootViewController=fpvc;
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
    
   

}
- (IBAction)forgotPass:(id)sender
{
    forgotPasswordViewController *fpvc=[[forgotPasswordViewController alloc]init];
    [self.navigationController pushViewController:fpvc animated:true];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

@end
