//
//  editProfileView.m
//  naamee
//
//  Created by mac on 18/12/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "editProfileView.h"
#import "AsyncImageView.h"
#import "Helper.h"
#import "AFNetworking.h"
#import "changeUsernameViewController.h"
#import <RSKImageCropper/RSKImageCropper.h>

//#import "ImageCropView.h"
//#import "TOCropViewController.h"

@interface editProfileView ()<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate>//,TOCropViewControllerDelegate>
{
    NSDictionary *myProfile;
    AsyncImageView *userImage,*wallImage;
    UITextView *bio;
    UILabel *namelbl;
    UIImageView *imgv;
    
    UITextField *name;
    UITextField *username;
    UITextField *email;
    UITextField *phoneNo,*userwebsite;
    UIScrollView *scrv;
    UIView *popView;

    int changeCoverOrImage,viewYourAction;
    UIImage *coverImg,*profileImg;
    UIView *popView1;
}
@property (nonatomic, assign) CGRect croppedFrame;
@property (nonatomic, assign) NSInteger angle;
@end

@implementation editProfileView

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=true;
    viewYourAction=0;
    self.view.backgroundColor= [UIColor whiteColor];
    self.navigationController.navigationBarHidden=true;
    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor=[UIColor blackColor];
    [self.view addSubview: navigationView];
    
    namelbl = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-125, 30, 250, 30)];
    namelbl.text = @"EDIT PROFILE";
    namelbl.font=[UIFont fontWithName:@"Arial-BoldMT" size:18.0f];
    namelbl.backgroundColor = [UIColor clearColor];
    namelbl.textColor = [UIColor whiteColor];
    namelbl.textAlignment = NSTextAlignmentCenter;
    [navigationView addSubview:namelbl];
    
    UIButton *backButton =[[UIButton alloc]initWithFrame:CGRectMake(20, 30, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backButton];
    
    UIButton *doneButton =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-80, 30, 80, 30)];
    [doneButton setTitle:@"Update" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(updateProfile) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:doneButton];
    
    
    myProfile=[[[NSUserDefaults standardUserDefaults]valueForKey:@"myProfile"]mutableCopy];
    NSDictionary *dict=[[myProfile objectForKey:@"userDetails"]objectAtIndex:0];

    scrv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    scrv.backgroundColor=[UIColor whiteColor];
    
    
    wallImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    wallImage.clipsToBounds=YES;
    wallImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[dict valueForKey:@"coverPic"]]];
    wallImage.contentMode=UIViewContentModeScaleAspectFill;

    [scrv addSubview:wallImage];
    
    
    userImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(wallImage.frame.size.width/2-50, 0, 100, 100)];
    userImage.clipsToBounds=YES;
    userImage.layer.cornerRadius=50;
    userImage.layer.borderWidth=0.1;
    userImage.contentMode=UIViewContentModeScaleAspectFit;
    userImage.imageURL=[NSURL URLWithString:[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@",[dict valueForKey:@"profile_pic"]]];
    [scrv addSubview:userImage];
    
    
    UIButton *changeImage =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, userImage.frame.size.height+userImage.frame.origin.y, 100, 20)];
    changeImage.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:10.0f];
    [changeImage setTitle:@"Change Image" forState:UIControlStateNormal];
    [changeImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeImage addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    [scrv addSubview:changeImage];
    
    UIButton *changeCover =[[UIButton alloc]initWithFrame:CGRectMake(0, 80, 100, 20)];
    changeCover.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:10.0f];
    [changeCover setTitle:@"Change Cover" forState:UIControlStateNormal];
    [changeCover setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeCover addTarget:self action:@selector(changeCover) forControlEvents:UIControlEventTouchUpInside];
    [scrv addSubview:changeCover];
    
    
    
    
    
    UILabel *lblName = [[UILabel alloc]initWithFrame:CGRectMake(10, wallImage.frame.size.height+wallImage.frame.origin.y+65, 250, 20)];
    lblName.text = @"Name";
    lblName.font=[UIFont fontWithName:@"Arial" size:12.0f];
    lblName.textColor = [UIColor lightGrayColor];
    lblName.textAlignment = NSTextAlignmentLeft;
    [scrv addSubview:lblName];
    
    name = [[UITextField alloc] initWithFrame:CGRectMake(10, wallImage.frame.size.height+wallImage.frame.origin.y+90, self.view.frame.size.width-20, 30)];
    name.delegate=self;
    name.tag=1;
    name.layer.borderColor=[UIColor clearColor].CGColor;
    name.layer.borderWidth=0.5;
    name.placeholder=@"Name";
    name.font= [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
    name.text=[dict valueForKey:@"fullname"];
    [scrv addSubview:name];
    
    UIView *v=[[UIView alloc]initWithFrame:CGRectMake(10, wallImage.frame.size.height+wallImage.frame.origin.y+120, self.view.frame.size.width-20, 1)];
    v.backgroundColor=[UIColor lightGrayColor];
    v.alpha=0.5;
    [scrv addSubview:v];
    
    UILabel *lblusername = [[UILabel alloc]initWithFrame:CGRectMake(10, name.frame.size.height+name.frame.origin.y+5, 250, 20)];
    lblusername.text = @"User Name";
    lblusername.font=[UIFont fontWithName:@"Arial" size:12.0f];
    lblusername.textColor = [UIColor lightGrayColor];
    lblusername.textAlignment = NSTextAlignmentLeft;
    [scrv addSubview:lblusername];
    
    username = [[UITextField alloc] initWithFrame:CGRectMake(10, name.frame.size.height+name.frame.origin.y+30, self.view.frame.size.width-20, 30)];
    username.delegate=self;
    username.tag=2;
    username.layer.borderColor=[UIColor clearColor].CGColor;
    username.layer.borderWidth=0.5;
    username.font= [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
    username.placeholder=@"User Name";
    username.text=[dict valueForKey:@"username"];
    [scrv addSubview:username];
    username.userInteractionEnabled=false;
    username.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];

    
    UIButton *changeUsername =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-140, name.frame.size.height+name.frame.origin.y+30, 120, 30)];
    changeUsername.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:13.0f];
    [changeUsername setTitle:@"Change Username" forState:UIControlStateNormal];
    [changeUsername setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changeUsername addTarget:self action:@selector(changeusernameScreen) forControlEvents:UIControlEventTouchUpInside];
    [scrv addSubview:changeUsername];
    

    
    
    
    UIView *v1=[[UIView alloc]initWithFrame:CGRectMake(10, name.frame.size.height+name.frame.origin.y+60, self.view.frame.size.width-20, 1)];
    v1.backgroundColor=[UIColor lightGrayColor];
    v1.alpha=0.5;
    [scrv addSubview:v1];
    
    UILabel *lblemail = [[UILabel alloc]initWithFrame:CGRectMake(10, username.frame.size.height+username.frame.origin.y+5, 250, 20)];
    lblemail.text = @"Email";
    lblemail.font=[UIFont fontWithName:@"Arial" size:12.0f];
    lblemail.textColor = [UIColor lightGrayColor];
    lblemail.textAlignment = NSTextAlignmentLeft;
    [scrv addSubview:lblemail];
    
    email = [[UITextField alloc] initWithFrame:CGRectMake(10, username.frame.size.height+username.frame.origin.y+30, self.view.frame.size.width-20, 30)];
    email.delegate=self;
    email.tag=3;
    email.layer.borderColor=[UIColor clearColor].CGColor;
    email.layer.borderWidth=0.5;
    email.font= [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
    email.text=[dict valueForKey:@"email"];
    email.placeholder=@"Email";
    [scrv addSubview:email];
    
    UIView *v2=[[UIView alloc]initWithFrame:CGRectMake(10, username.frame.size.height+username.frame.origin.y+60, self.view.frame.size.width-20, 1)];
    v2.backgroundColor=[UIColor lightGrayColor];
    v2.alpha=0.5;
    [scrv addSubview:v2];
    
    UILabel *lblphoneNo = [[UILabel alloc]initWithFrame:CGRectMake(10, email.frame.size.height+email.frame.origin.y+5, 250, 20)];
    lblphoneNo.text = @"Phone No.";
    lblphoneNo.font=[UIFont fontWithName:@"Arial" size:12.0f];
    lblphoneNo.textColor = [UIColor lightGrayColor];
    lblphoneNo.textAlignment = NSTextAlignmentLeft;
    [scrv addSubview:lblphoneNo];
    
    phoneNo = [[UITextField alloc] initWithFrame:CGRectMake(10, email.frame.size.height+email.frame.origin.y+30, self.view.frame.size.width-20, 30)];
    phoneNo.delegate=self;
    phoneNo.tag=4;
    phoneNo.layer.borderColor=[UIColor clearColor].CGColor;
    phoneNo.layer.borderWidth=0.5;
    phoneNo.font= [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
    phoneNo.text=[dict valueForKey:@"phone"];
    phoneNo.placeholder=@"Phone No.";
    [scrv addSubview:phoneNo];
    
    UIView *v3=[[UIView alloc]initWithFrame:CGRectMake(10, email.frame.size.height+email.frame.origin.y+60, self.view.frame.size.width-20, 1)];
    v3.backgroundColor=[UIColor lightGrayColor];
    v3.alpha=0.5;
    [scrv addSubview:v3];
    
    UILabel *lbluserwebsite = [[UILabel alloc]initWithFrame:CGRectMake(10, phoneNo.frame.size.height+phoneNo.frame.origin.y+5, 250, 20)];
    lbluserwebsite.text = @"Website";
    lbluserwebsite.font=[UIFont fontWithName:@"Arial" size:12.0f];
    lbluserwebsite.textColor = [UIColor lightGrayColor];
    lbluserwebsite.textAlignment = NSTextAlignmentLeft;
    [scrv addSubview:lbluserwebsite];
    
    userwebsite = [[UITextField alloc] initWithFrame:CGRectMake(10, phoneNo.frame.size.height+phoneNo.frame.origin.y+30, self.view.frame.size.width-20, 30)];
    userwebsite.delegate=self;
    userwebsite.tag=5;
    userwebsite.layer.borderColor=[UIColor clearColor].CGColor;
    userwebsite.layer.borderWidth=0.5;
    userwebsite.font= [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
    userwebsite.text=[dict valueForKey:@"website"];
    userwebsite.placeholder=@"Website";
    [scrv addSubview:userwebsite];
    
    UIView *v4=[[UIView alloc]initWithFrame:CGRectMake(10, phoneNo.frame.size.height+phoneNo.frame.origin.y+60, self.view.frame.size.width-20, 1)];
    v4.backgroundColor=[UIColor lightGrayColor];
    v4.alpha=0.5;
    [scrv addSubview:v4];
    
    
    UILabel *lblprofiletype = [[UILabel alloc]initWithFrame:CGRectMake(10, userwebsite.frame.size.height+userwebsite.frame.origin.y+5, 250, 20)];
    lblprofiletype.text = @"Profile Type";
    lblprofiletype.font=[UIFont fontWithName:@"Arial" size:12.0f];
    lblprofiletype.textColor = [UIColor lightGrayColor];
    lblprofiletype.textAlignment = NSTextAlignmentLeft;
    [scrv addSubview:lblprofiletype];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Public", @"Private", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(10, userwebsite.frame.size.height+userwebsite.frame.origin.y+30, self.view.frame.size.width-20, 30);
    [segmentedControl addTarget:self action:@selector(MySegmentControlAction:) forControlEvents: UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = 0;
    [scrv addSubview:segmentedControl];
    
    
    
    UILabel *lblbio = [[UILabel alloc]initWithFrame:CGRectMake(10, segmentedControl.frame.size.height+segmentedControl.frame.origin.y+5, 250, 20)];
    lblbio.text = @"bio";
    lblbio.font=[UIFont fontWithName:@"Arial" size:12.0f];
    lblbio.textColor = [UIColor lightGrayColor];
    lblbio.textAlignment = NSTextAlignmentLeft;
    [scrv addSubview:lblbio];
    
    bio = [[UITextView alloc] initWithFrame:CGRectMake(10, segmentedControl.frame.size.height+segmentedControl.frame.origin.y+30, self.view.frame.size.width-20, 80)];
    bio.delegate=self;
    bio.tag=6;
    bio.layer.borderColor=[UIColor clearColor].CGColor;
    bio.layer.borderWidth=0.5;
    bio.font= [UIFont fontWithName:@"Arial-BoldMT" size:16.0f];
    if(![[dict valueForKey:@"description"] isEqualToString:@""])
    {
    NSData *data = [NSData dataWithBytes: [[dict valueForKey:@"description"] UTF8String] length:strlen([[dict valueForKey:@"description"] UTF8String])];
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    bio.text=msg;
    }
    if([[dict valueForKey:@"description"] isEqualToString:@""])
    bio.text=@"bio";
    [scrv addSubview:bio];
    
    UIView *v5=[[UIView alloc]initWithFrame:CGRectMake(10, bio.frame.size.height+bio.frame.origin.y+10, self.view.frame.size.width-20, 1)];
    v5.backgroundColor=[UIColor lightGrayColor];
    v5.alpha=0.5;
    [scrv addSubview:v5];
    
    
    scrv.contentSize=CGSizeMake(0, bio.frame.size.height+bio.frame.origin.y+24);
    [self.view addSubview:scrv];
    
}
- (void)MySegmentControlAction:(UISegmentedControl *)segment
{
    if(segment.selectedSegmentIndex == 0)
    {
        viewYourAction=0;
    }
    else
    {
        viewYourAction=1;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [scrv setContentOffset:CGPointMake(0, 320) animated:YES];

    if ([textView.text isEqualToString:@"bio"])
    {
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return textView.text.length + (text.length - range.length) <= 150;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [scrv setContentOffset:CGPointMake(0, 0) animated:YES];

    if ([textView.text isEqualToString:@""]) {
        textView.text = @"bio";
    }
    [textView resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.view endEditing:YES];
    [scrv endEditing:YES];
    [bio resignFirstResponder];
    [name resignFirstResponder];
    [username resignFirstResponder];
    [userwebsite resignFirstResponder];
    [email resignFirstResponder];
    [phoneNo resignFirstResponder];

}
-(void)changeImage
{
    changeCoverOrImage=1;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title" message:@"Alert Message" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        // Enter code here
    }];
    UIAlertAction *actioncamera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = false;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    UIAlertAction *actiongallary = [UIAlertAction actionWithTitle:@"Gallary" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = false;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    [alert addAction:actioncamera];
    [alert addAction:actiongallary];

    [alert addAction:defaultAction];

    [self presentViewController:alert animated:YES completion:nil];
    
    
    
}
-(void)changeCover
{
    changeCoverOrImage=0;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Title" message:@"Alert Message" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        // Enter code here
    }];
    UIAlertAction *actioncamera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = false;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    UIAlertAction *actiongallary = [UIAlertAction actionWithTitle:@"Gallary" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = false;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
        
    }];
    [alert addAction:actioncamera];
    [alert addAction:actiongallary];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
    
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag==1)
    {
        [scrv setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
    else  if(textField.tag==2)
    {
        [scrv setContentOffset:CGPointMake(0, 90) animated:YES];
        
    }
    else  if(textField.tag==3)
    {
        [scrv setContentOffset:CGPointMake(0, 120) animated:YES];
        
    }
    else  if(textField.tag==4)
    {
        [scrv setContentOffset:CGPointMake(0, 150) animated:YES];
    }
    else  if(textField.tag==5)
    {
        [scrv setContentOffset:CGPointMake(0, 180) animated:YES];
    }
    else  if(textField.tag==6)
    {
        [scrv setContentOffset:CGPointMake(0, 250) animated:YES];
    }
    else
    {
        [scrv setContentOffset:CGPointMake(0, 250) animated:YES];
        
    }
    return YES;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if(changeCoverOrImage)
    {
        UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
           RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image];
           imageCropVC.delegate = self;
           [self.navigationController pushViewController:imageCropVC animated:YES];
    }
    else
    {

        //coverImg=[info valueForKey:UIImagePickerControllerOriginalImage];
        
        popView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        popView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self.view addSubview:popView];
        
        
        UIScrollView *zoomscrv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        zoomscrv.backgroundColor=[UIColor whiteColor];
        zoomscrv.contentSize=CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+self.view.frame.size.height);
//        zoomscrv.minimumZoomScale=.5;
//        zoomscrv.maximumZoomScale=2.0;
//        zoomscrv.delegate=self;
        imgv=[[UIImageView alloc]initWithFrame:CGRectMake(0, zoomscrv.frame.size.height-((zoomscrv.frame.size.height)/2), self.view.frame.size.width, self.view.frame.size.height)];
        imgv.image=[info valueForKey:UIImagePickerControllerOriginalImage];
        imgv.contentMode=UIViewContentModeScaleAspectFit;
        [zoomscrv addSubview:imgv];
        
        [popView addSubview:zoomscrv];
        
        
        popView1=[[UIView alloc]initWithFrame:CGRectMake(0, (self.view.frame.size.height/2)-50, self.view.frame.size.width, 60)];
        popView1.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [popView addSubview:popView1];
        popView1.userInteractionEnabled=false;
        
        
        UIButton *changeImage =[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-110, 40, 100, 30)];
        changeImage.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:13.0f];
        [changeImage setTitle:@"Crop Image" forState:UIControlStateNormal];
        [changeImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [changeImage addTarget:self action:@selector(changeImageScreen1) forControlEvents:UIControlEventTouchUpInside];
        changeImage.backgroundColor=[UIColor greenColor];
        [popView addSubview:changeImage];
        
        UIButton *changeImage1 =[[UIButton alloc]initWithFrame:CGRectMake(10, 40, 100, 30)];
        changeImage1.titleLabel.font=[UIFont fontWithName:@"Arial-BoldMT" size:13.0f];
        [changeImage1 setTitle:@"Cancel" forState:UIControlStateNormal];
        [changeImage1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [changeImage1 addTarget:self action:@selector(cancelImageScreen) forControlEvents:UIControlEventTouchUpInside];
        changeImage.backgroundColor=[UIColor redColor];
        [popView addSubview:changeImage1];
        zoomscrv.contentOffset=CGPointMake(0, self.view.frame.size.height/2);
        
        //wallImage.image=[info valueForKey:UIImagePickerControllerOriginalImage];

    }
    [picker dismissViewControllerAnimated:YES completion:nil];

//    [picker dismissViewControllerAnimated:YES completion:nil];
}

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//- (void)ImageCropViewControllerSuccess:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage{
//    coverImg = croppedImage;
//    wallImage.image = croppedImage;
//    //CGRect cropArea = controller.cropArea;
//    [[self navigationController] popViewControllerAnimated:YES];
//}
//
//- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller{
//    wallImage.image = coverImg;
//    [[self navigationController] popViewControllerAnimated:YES];


// Crop image has been canceled.
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

// The original image has been cropped. Additionally provides a rotation angle used to produce image.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
                  rotationAngle:(CGFloat)rotationAngle
{
    userImage.image= croppedImage;

    [self.navigationController popViewControllerAnimated:YES];
}

// The original image will be cropped.
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                  willCropImage:(UIImage *)originalImage
{
    // Use when `applyMaskToCroppedImage` set to YES.
    //[SVProgressHUD show];
}
-(void)updateProfile
{

    [self updateNowUsernameExist];
//
//    NSDictionary *dict=[[myProfile objectForKey:@"userDetails"]objectAtIndex:0];
//
//    if(![username.text isEqualToString:[dict valueForKey:[dict valueForKey:@"username"]]])
//    {
//
//
//    [Helper showIndicatorWithText:@"Checking Username..." inView:self.view];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSDictionary *params = @{
//                             @"method"       : @"checkUsername",
//                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
//                             @"username"     :username.text
//                             };
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = nil;
//    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
//                                                             options:kNilOptions
//                                                               error:nil];
//        NSLog(@"JSON: %@", json);
//        [Helper hideIndicatorFromView:self.view];
//
//        if ([[json objectForKey:@"success"]integerValue]==1)
//        {
//            [self updateNowUsernameExist];
//        }
//        else
//        {
//
//            [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
//
//        }
//
//
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        [Helper hideIndicatorFromView:self.view];
//
//    }];
//    }
//    else
//    {
//        [self updateNowUsernameExist];
//    }
//   //

    
   
}
-(void)updateNowUsernameExist
{
    
    int isimageUplaod=0;
    int isCoverUpload=0;
    if(profileImg)
        isimageUplaod=1;
    if(coverImg)
        isCoverUpload=1;
    
    [Helper showIndicatorWithText:@"Updating..." inView:self.view];
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://naamee.com/api/webservices/index.php" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",@"editProfile"] dataUsingEncoding:NSUTF8StringEncoding] name:@"method"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]] dataUsingEncoding:NSUTF8StringEncoding] name:@"userid"];
        
        [formData appendPartWithFormData:[self->name.text dataUsingEncoding:NSUTF8StringEncoding] name:@"name"];
        
        [formData appendPartWithFormData:[self->phoneNo.text dataUsingEncoding:NSUTF8StringEncoding] name:@"phoneNo"];
        
        [formData appendPartWithFormData:[self->username.text dataUsingEncoding:NSUTF8StringEncoding] name:@"userName"];
        
        [formData appendPartWithFormData:[self->email.text dataUsingEncoding:NSUTF8StringEncoding] name:@"emailid"];
        
        [formData appendPartWithFormData:[self->userwebsite.text dataUsingEncoding:NSUTF8StringEncoding] name:@"website"];
        
        if ([self->bio.text isEqualToString:@"bio"])
        {
            [formData appendPartWithFormData:[@"" dataUsingEncoding:NSUTF8StringEncoding] name:@"description"];
        }
        else
        {
            NSString *uniText = [NSString stringWithUTF8String:[self->bio.text UTF8String]];
            NSData *msgData = [uniText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
            NSString *goodMsg = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
            [formData appendPartWithFormData:[goodMsg dataUsingEncoding:NSUTF8StringEncoding] name:@"description"];
        }
        
        
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",self->viewYourAction] dataUsingEncoding:NSUTF8StringEncoding] name:@"viewYourAction"];
        
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",isimageUplaod] dataUsingEncoding:NSUTF8StringEncoding] name:@"isimageUplaod"];
        
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",isCoverUpload] dataUsingEncoding:NSUTF8StringEncoding] name:@"isCoverUpload"];
        
        
        if(isimageUplaod)
        {
            NSData *imageData = UIImageJPEGRepresentation(self->userImage.image,0.2);
            [formData appendPartWithFileData:imageData name:@"imageUplaod" fileName:@"testimage.jpeg" mimeType:@"image/jpeg"];
        }
        if(isCoverUpload)
        {
            NSData *imageData1 = UIImageJPEGRepresentation(self->wallImage.image,0.2);
            [formData appendPartWithFileData:imageData1 name:@"CoverUpload" fileName:@"testimage1.jpeg" mimeType:@"image/jpeg"];
        }
        
        
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPResponseSerializer *serializer = [[AFHTTPResponseSerializer alloc] init];
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"application/x-www-form-urlencoded"];
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    
    manager.responseSerializer = serializer;
    
    
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          // [progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:kNilOptions error:nil];
                          NSLog(@"%@",jsonResponse);
                          [Helper hideIndicatorFromView:self.view];
                          
                          if([[jsonResponse valueForKey:@"success"]intValue]==1)
                          {
                              UIAlertController * alert = [UIAlertController alertControllerWithTitle:[jsonResponse valueForKey:@"message"] message:@"" preferredStyle:UIAlertControllerStyleAlert];
                              
                              UIAlertAction* noButton = [UIAlertAction
                                                         actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //Handle no, thanks button
                                                         }];
                              [alert addAction:noButton];
                              [self presentViewController:alert animated:YES completion:nil];
                          }
                      }
                  }];
    
    [uploadTask resume];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag==2)
    {
        NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]];
        
        if (lowercaseCharRange.location != NSNotFound) {
            textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                     withString:[string lowercaseString]];
            return NO;
        }
    }
    return YES;
}
#pragma mark - Gesture Recognizer -
//- (void)didTapImageView
//{
//    // When tapping the image view, restore the image to the previous cropping state
//    TOCropViewController *cropController = [[TOCropViewController alloc] initWithCroppingStyle:self.croppingStyle image:self.image];
//    cropController.delegate = self;
//    CGRect viewFrame = [self.view convertRect:self.imageView.frame toView:self.navigationController.view];
//    [cropController presentAnimatedFromParentViewController:self
//                                                  fromImage:self.imageView.image
//                                                   fromView:nil
//                                                  fromFrame:viewFrame
//                                                      angle:self.angle
//                                               toImageFrame:self.croppedFrame
//                                                      setup:^{ self.imageView.hidden = YES; }
//                                                 completion:nil];
//}

//#pragma mark - Cropper Delegate -
//- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
//{
//    self.croppedFrame = cropRect;
//    self.angle = angle;
//    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
//}
//
//- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
//{
//    self.croppedFrame = cropRect;
//    self.angle = angle;
//    [self updateImageViewWithImage:image fromCropViewController:cropViewController];
//}
//
//- (void)updateImageViewWithImage:(UIImage *)image fromCropViewController:(TOCropViewController *)cropViewController
//{
////    self.imageView.image = image;
////    [self layoutImageView];
////
////    self.navigationItem.rightBarButtonItem.enabled = YES;
//
// //   if (cropViewController.croppingStyle != TOCropViewCroppingStyleCircular) {
////        self.imageView.hidden = YES;
////        [cropViewController dismissAnimatedFromParentViewController:self
////                                                   withCroppedImage:image
////                                                             toView:self.imageView
////                                                            toFrame:CGRectZero
////                                                              setup:^{ [self layoutImageView]; }
////                                                         completion:
////         ^{
////             self.imageView.hidden = NO;
////         }];
////    }
////    else {
////        self.imageView.hidden = NO;
//        [cropViewController dismissViewControllerAnimated:YES completion:nil];
//    //}
//}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imgv;
    
}
- (UIImage *) captureScreen {
    CGRect rect = CGRectMake(30, (self.view.frame.size.height/2)-(self.view.frame.size.width-60)/2, self.view.frame.size.width-60, self.view.frame.size.width-60);
    UIGraphicsBeginImageContext(self.view.frame.size);
    popView1.backgroundColor=[UIColor clearColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [popView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    
    return cropped;
//    UIGraphicsBeginImageContext(rect.size);
//    //popView1.backgroundColor=[UIColor clearColor];
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [popView.layer renderInContext:context];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
}
- (UIImage *) captureScreen1 {
    CGRect rect = CGRectMake(0, (self.view.frame.size.height/2)-50, self.view.frame.size.width, 60);
    UIGraphicsBeginImageContext(self.view.frame.size);
    popView1.backgroundColor=[UIColor clearColor];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [popView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    
    return cropped;
    //    UIGraphicsBeginImageContext(rect.size);
    //    //popView1.backgroundColor=[UIColor clearColor];
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    [popView.layer renderInContext:context];
    //    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    //    return img;
}
-(void)changeImageScreen
{
   userImage.image= [self captureScreen];
    [popView removeFromSuperview];
}
-(void)cancelImageScreen
{
    [popView removeFromSuperview];
}
-(void)changeImageScreen1
{
    wallImage.image= [self captureScreen1];
    coverImg=wallImage.image;
    [popView removeFromSuperview];
}
-(void)changeusernameScreen
{
    changeUsernameViewController *cuvc=[[changeUsernameViewController alloc]init];
    [self.navigationController pushViewController:cuvc animated:YES];
}
@end
