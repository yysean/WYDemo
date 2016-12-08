//
//  WYNewsViewController.m
//  WYDemo
//
//  Created by 杨森 on 2016/12/8.
//  Copyright © 2016年 Sean. All rights reserved.
//

#import "WYNewsViewController.h"

@interface WYNewsViewController ()

@end

@implementation WYNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    
    UILabel *lab=[[UILabel alloc]initWithFrame:self.view.bounds];
    lab.font=[UIFont systemFontOfSize:30];
    lab.textAlignment=NSTextAlignmentCenter;
    lab.text=self.content;
    [self.view addSubview:lab];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
