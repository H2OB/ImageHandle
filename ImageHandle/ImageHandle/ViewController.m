//
//  ViewController.m
//  ImageHandle
//
//  Created by 杨涛 on 2018/10/19.
//  Copyright © 2018年 North. All rights reserved.
//

#import "ViewController.h"

#import "UIImageView+Cache.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
    
    NSString *URL = @"http://cdn.jrmaster.com/make-assets/image/1050911252061081602.jpg";
    //头像
    
    [self.imageView1 loadImageWithURL:URL placeholder:@"默认图片" radius:self.imageView1.bounds.size.width/2.0];
    
    
    [self.imageView2 loadImageWithURL:URL placeholder:@"默认图片" radius:10];
    
    
    [self.imageView3 loadImageWithURL:URL placeholder:@"默认图片"];
    
    
}


@end
