//
//  ViewController.m
//  GHCycleView
//
//  Created by gaozhihong on 2018/3/29.
//  Copyright © 2018年 gaozhihong. All rights reserved.
//

#import "ViewController.h"
#import "GHCycleView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self addCycleView];
}

-(void)addCycleView{
    NSString *img1 = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2594089665,909055408&fm=27&gp=0.jpg";
     NSString *img2 = @"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1867179929,3390550130&fm=27&gp=0.jpg";
     NSString *img3 = @"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1065809084,3734501613&fm=27&gp=0.jpg";
     NSString *img4 = @"https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1429229132,522416372&fm=27&gp=0.jpg";
    NSString *img5 = @"https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3394122166,3873974970&fm=27&gp=0.jpg";

    NSArray *imgUrls = @[img1,img2,img3,img4,img5];
    GHCycleView *cycleView = [[GHCycleView alloc] initCycleView:CGRectMake(0, 0, self.view.bounds.size.width, 200) imgUrls:imgUrls];
    cycleView.backgroundColor  =[UIColor whiteColor];
    [self.view addSubview:cycleView];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
