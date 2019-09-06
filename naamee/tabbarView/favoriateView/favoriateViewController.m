//
//  favoriateViewController.m
//  naamee
//
//  Created by mac on 26/09/18.
//  Copyright © 2018 Techmorale. All rights reserved.
//

#import "favoriateViewController.h"
#import "Constants.h"
#import "Helper.h"
#import "AsyncImageView.h"
#import "AFNetworking.h"
#import "otherImageView.h"
#import "imageViewController.h"
@interface favoriateViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    NSMutableArray *allPosts,*allPosts1;
    UICollectionView *imageScrollView,*imageScrollView1;
    UIButton *nameBtn;
       UIButton *trendiBtn,*popolarbtn;
     UIView *selectionViewShown;
    int selectedShareMethod;
    UIScrollView *scrv;
    BOOL *isTrendingTab;
}
@end

@implementation favoriateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBarHidden=true;
    
    UIView *navigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navigationView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    [self.view addSubview: navigationView];
    self.view.backgroundColor=[UIColor whiteColor];
    
    nameBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    nameBtn.frame = CGRectMake(self.view.frame.size.width/2-100, 20, 200, 44);
    nameBtn.backgroundColor=[UIColor clearColor];
    [nameBtn setTitle:@"TRENDING" forState:UIControlStateNormal];
    [nameBtn setTintColor:[UIColor whiteColor]];
    [navigationView addSubview:nameBtn];
    
    isTrendingTab = true;
    
    
    trendiBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    trendiBtn.frame = CGRectMake(0, 64, self.view.frame.size.width/2, 50);
    trendiBtn.backgroundColor=[UIColor colorWithRed:90/255.0 green:162/255.0 blue:209/255.0 alpha:1.0];
    [trendiBtn setTitle:@"TRENDING" forState:UIControlStateNormal];
    [trendiBtn setTintColor:[UIColor whiteColor]];
    [trendiBtn addTarget:self action:@selector(followers_action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:trendiBtn];
    
    
    popolarbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    popolarbtn.frame = CGRectMake(self.view.frame.size.width/2, 64, self.view.frame.size.width/2, 50);
    popolarbtn.backgroundColor=[UIColor colorWithRed:90/255.0 green:162/255.0 blue:209/255.0 alpha:1.0];
    [popolarbtn setTitle:@"POPULAR" forState:UIControlStateNormal];
    [popolarbtn setTintColor:[UIColor lightGrayColor]];
    [popolarbtn addTarget:self action:@selector(you_action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:popolarbtn];
    
    selectionViewShown=[[UIView alloc]initWithFrame:CGRectMake(10, 105, self.view.frame.size.width/2-20, 5)];
    selectionViewShown.backgroundColor=[UIColor clearColor];
    [self.view addSubview:selectionViewShown];
    
    
    UIView *greenv=[[UIView alloc]initWithFrame:CGRectMake(10, 0, self.view.frame.size.width/2-20, 5)];
    greenv.backgroundColor=[UIColor greenColor];
    [selectionViewShown addSubview:greenv];
    
    scrv=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, self.view.frame.size.height-130-40)];
    scrv.contentSize=CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height-130-40);
    [self.view addSubview:scrv];
    scrv.pagingEnabled=true;
    scrv.showsHorizontalScrollIndicator=false;
    scrv.delegate=self;
    

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
   
    if(scrv.contentOffset.x<self.view.frame.size.width-100)
    {
        self->isTrendingTab = true;
        [nameBtn setTitle:@"TRENDING" forState:UIControlStateNormal];
        self->imageScrollView.hidden=false;
        self->imageScrollView1.hidden=true;
        CGRect f = selectionViewShown.frame;
        f.origin.x = 10;
        selectionViewShown.frame = f;
        [trendiBtn setTintColor:[UIColor whiteColor]];
        [popolarbtn setTintColor:[UIColor lightGrayColor]];
        
    }
    else
    {
        self->isTrendingTab = false;
        self->imageScrollView.hidden=true;
        self->imageScrollView1.hidden=false;
        [popolarbtn setTintColor:[UIColor whiteColor]];
        [trendiBtn setTintColor:[UIColor lightGrayColor]];
        [nameBtn setTitle:@"POPULAR" forState:UIControlStateNormal];

        selectedShareMethod=1;
        CGRect f = selectionViewShown.frame;
        f.origin.x = self.view.frame.size.width/2;
        selectionViewShown.frame = f;
    }
}
-(void)followers_action
{
    self->isTrendingTab = true;
//    if(allPosts.count == 0){
//        [Helper showAlertViewWithTitle:OOPS message:@"No Post Found"];
//    }
    [scrv setContentOffset:CGPointMake(0, 0)];
    [nameBtn setTitle:@"TRENDING" forState:UIControlStateNormal];
    self->imageScrollView.hidden=false;
    self->imageScrollView1.hidden=true;
    selectedShareMethod=0;
    CGRect f = selectionViewShown.frame;
    f.origin.x = 10;
    selectionViewShown.frame = f;
    [trendiBtn setTintColor:[UIColor whiteColor]];
    [popolarbtn setTintColor:[UIColor lightGrayColor]];
    
}
-(void)you_action
{
    self->isTrendingTab = false;
//    if(allPosts1.count == 0){
//        [Helper showAlertViewWithTitle:OOPS message:@"No Post Found"];
//    }
    [scrv setContentOffset:CGPointMake(self.view.frame.size.width, 0)];
    [popolarbtn setTintColor:[UIColor whiteColor]];
    [trendiBtn setTintColor:[UIColor lightGrayColor]];
    [nameBtn setTitle:@"POPULAR" forState:UIControlStateNormal];
    self->imageScrollView.hidden=true;
    self->imageScrollView1.hidden=false;
    selectedShareMethod=1;
    CGRect f = selectionViewShown.frame;
    f.origin.x = self.view.frame.size.width/2;
    selectionViewShown.frame = f;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.tabBar setHidden:false];
    
    [Helper showIndicatorWithText:@"Updating..." inView:self.view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"trendi",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"device"       :[NSString stringWithFormat:@"%0.0f", self.view.frame.size.width],
                             };
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = nil;
    [manager POST:@"http://naamee.com/api/webservices/index.php?format=json" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:nil];
        NSLog(@"JSON trendi: %@", json);
        [Helper hideIndicatorFromView:self.view];
        [self getPopularpost];
        if ([[json objectForKey:@"success"]integerValue]==1)
        {
            self->allPosts=[[json objectForKey:@"hashTagDetail"]mutableCopy];
            if(self->allPosts.count>0)
            {
                if(self->imageScrollView)
                {
                    
                }
                else
                {
                UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
                [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
                    layout.minimumInteritemSpacing = 0;
                    layout.minimumLineSpacing = 0;
                self->imageScrollView=[[UICollectionView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self->scrv.frame.size.height) collectionViewLayout:layout];
                self->imageScrollView.tag=1;
                    
                [self->imageScrollView setCollectionViewLayout:layout];
                [self->imageScrollView setDataSource:self];
                [self->imageScrollView setDelegate:self];
                self->imageScrollView.pagingEnabled=false;
                [self->imageScrollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
                [self->imageScrollView setBackgroundColor:[UIColor clearColor]];
                self->imageScrollView.showsVerticalScrollIndicator=false;
                self->imageScrollView.showsHorizontalScrollIndicator=false;
                [self->scrv addSubview:self->imageScrollView];
                }
            [self->imageScrollView reloadData];
            }
        }
        else
        {
            if(self->isTrendingTab){
                [Helper showAlertViewWithTitle:OOPS message:@"No Post Found"];
            }
//
            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
    
    
}
-(void)getPopularpost
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{
                             @"method"       : @"popularPost",
                             @"userid"       : [[NSUserDefaults standardUserDefaults]valueForKey:@"userid"],
                             @"device"       :[NSString stringWithFormat:@"%0.0f", self.view.frame.size.width],
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
            self->allPosts1=[[json objectForKey:@"popularpost"]mutableCopy];
            if(self->allPosts1.count>0)
            {
                if(self->imageScrollView1)
                {
                    
                }
                else
                {
                UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
                [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
                
                self->imageScrollView1=[[UICollectionView alloc]initWithFrame:CGRectMake(self.view.frame.size.width,0, self.view.frame.size.width, self->scrv.frame.size.height ) collectionViewLayout:layout];
                    layout.minimumInteritemSpacing = 0;
                    layout.minimumLineSpacing = 0;
                [self->imageScrollView1 setCollectionViewLayout:layout];
                [self->imageScrollView1 setDataSource:self];
                [self->imageScrollView1 setDelegate:self];
                self->imageScrollView1.pagingEnabled=false;
                self->imageScrollView1.tag=2;
                [self->imageScrollView1 registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
                [self->imageScrollView1 setBackgroundColor:[UIColor clearColor]];
                self->imageScrollView1.showsVerticalScrollIndicator=false;
                self->imageScrollView1.showsHorizontalScrollIndicator=false;
                [self->scrv addSubview:self->imageScrollView1];
                }
                [self->imageScrollView1 reloadData];
            }
        }
        else
        {
            
//            [Helper showAlertViewWithTitle:OOPS message:[json objectForKey:@"message"]];
            
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [Helper hideIndicatorFromView:self.view];
        
    }];
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView.tag==1)
    return [self->allPosts count];
    else
        return [self->allPosts1 count];

    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    
    for(UIView *view in cell.subviews)
    {
        for(UIView *subView in view.subviews)
        {
            [subView removeFromSuperview];
        }
        [view removeFromSuperview];
    }
    
    AsyncImageView *postImage=[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3-2, self.view.frame.size.width/3-2)];
    postImage.userInteractionEnabled=YES;
    NSString *url;
    if(collectionView.tag==1)
    {
    url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [[self->allPosts objectAtIndex:indexPath.row]valueForKey:@"postImage"]];
    }
    else
    {
        url=[NSString stringWithFormat:@"http://naamee.com/api/webservices/images/%@", [[self->allPosts1 objectAtIndex:indexPath.row]valueForKey:@"postImage"]];
    }
    postImage.imageURL=[NSURL URLWithString:url];
    postImage.contentMode=UIViewContentModeScaleAspectFill;
    postImage.clipsToBounds = true;
    [cell addSubview:postImage];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(self.view.frame.size.width/3-2,self.view.frame.size.width/3-2+4);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic;
    if(collectionView.tag==1)
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"TRENDING" forKey:@"exploreWord"];
        dic=[self->allPosts objectAtIndex:indexPath.row];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults]setValue:@"POPULAR" forKey:@"exploreWord"];
        dic=[self->allPosts1 objectAtIndex:indexPath.row];
    }
    
    [[NSUserDefaults standardUserDefaults]setValue:dic forKey:@"explore"];
    otherImageView *smvc = [[otherImageView alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
    
    /*if([[dic valueForKey:@"user_id"] isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"]])
    {
        [[NSUserDefaults standardUserDefaults]setValue:dic forKey:@"details"];
        imageViewController *smvc = [[imageViewController alloc]init];
        [self.navigationController pushViewController:smvc animated:YES];

    }
    else
    {
    [[NSUserDefaults standardUserDefaults]setValue:dic forKey:@"explore"];
    otherImageView *smvc = [[otherImageView alloc]init];
    [self.navigationController pushViewController:smvc animated:YES];
    }*/
}

@end
