//
//  UIImageView+Cache.m
//  Made
//
//  Created by 杨涛 on 2018/10/18.
//  Copyright © 2018年 North. All rights reserved.
//

#import "UIImageView+Cache.h"

#import <YYKit.h>

@implementation UIImageView (Cache)

- (void)loadImageWithURL:(NSString *)URL
             placeholder:(NSString *)placeholder{
    
    [self loadImageWithURL:URL placeholder:placeholder size:self.bounds.size];
    
}

- (void)loadImageWithURL:(NSString *)URL
             placeholder:(NSString *)placeholder
                    size:(CGSize)size{
    
    [self loadImageWithURL:URL placeholder:placeholder size:size radius:CGFLOAT_MIN];
    
}

- (void)loadImageWithURL:(NSString *)URL
             placeholder:(NSString *)placeholder
                  radius:(CGFloat)radius{
    
    [self loadImageWithURL:URL placeholder:placeholder size:self.bounds.size radius:radius];
}

- (void)loadImageWithURL:(NSString *)URL
             placeholder:(NSString *)placeholder
                    size:(CGSize)size
                  radius:(CGFloat)radius{
    
    [self loadImageWithURL:URL placeholder:placeholder size:size cachePath:^NSString *(CGSize viewSize, NSString *append) {
        
        CachePathBlock block = [ImageHandle defaultPathBlock];
        NSString *newPath = block(viewSize,append);
        if(radius>CGFLOAT_MIN) newPath = [NSString stringWithFormat:@"%.2f/%@",radius,newPath];
        
        return newPath;
        
    } handle:^UIImage *(CGSize viewSize, UIImage *image) {
        
        ImageHandleBlock block = [ImageHandle defaltHandleBlock];
        UIImage *newImage = block(viewSize,image);
        
        @autoreleasepool {
            
             #warning 这里用的是YYKit里面处理图片圆角的分类 如果你不用刻意用你习惯的
            newImage = [newImage imageByRoundCornerRadius:radius *[UIScreen mainScreen].scale];
        }
        
        
        return newImage;
        
    }];
    
    
}

- (void)loadImageWithURL:(NSString *)URL
             placeholder:(NSString *)placeholder
               cachePath:(CachePathBlock)pathBlock
                  handle:(ImageHandleBlock)handleBlock{
    
    [self loadImageWithURL:URL placeholder:placeholder size:self.bounds.size cachePath:pathBlock handle:handleBlock];
    
}


- (void)loadImageWithURL:(NSString *)URL
             placeholder:(NSString *)placeholder
                    size:(CGSize)size
               cachePath:(CachePathBlock)pathBlock
                  handle:(ImageHandleBlock)handleBlock{

   //如果URL为空
    if(URL.length<=0){
        
        [self loadPlaceholder:placeholder size:size cachePath:pathBlock handle:handleBlock];
        
        return;
    }
    
    
    if(!pathBlock) pathBlock = [ImageHandle defaultPathBlock];
    if(!handleBlock) handleBlock = [ImageHandle defaltHandleBlock];
    
    NSString *catchPath = pathBlock(size,URL);
    
    
    
    //如果有缓存处理过后的图片
    if([ImageHandle containsImageForKey:catchPath]){
        
        [ImageHandle getImageForKey:catchPath result:^(UIImage *image) {
            
            [self displayImage:image];
            
        }];
        
        return;
    }
    
    
    //如果有缓存原图
    if([ImageHandle containsImageForKey:URL]){
        
        [ImageHandle getImageForKey:URL result:^(UIImage *image) {
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                UIImage *newImage = handleBlock(size,image);
                
                [ImageHandle cacheImage:newImage ForKey:catchPath];
                
                [self displayImage:newImage];
                
            });

        }];
        
        return;
        
    }
    
     [self loadPlaceholder:placeholder size:size cachePath:pathBlock handle:handleBlock];
    
    //下载图片
    [ImageHandle downloadImageForKey:URL result:^(UIImage *image) {
       
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            
            if(!image){
                
                [self loadPlaceholder:placeholder size:size cachePath:pathBlock handle:handleBlock];
                return ;
                
            }
            
            //缓存原图
            [ImageHandle cacheImage:image ForKey:URL];
            
            
            //处理图片
            UIImage *newImage = handleBlock(size,image);
            
            
            //缓存处理过后的图片
            [ImageHandle cacheImage:newImage ForKey:catchPath];
            
            //显示
            [self displayImage:newImage];
            
        });
    }];

}


- (void)loadPlaceholder:(NSString *)placeholder{
    
    [self loadPlaceholder:placeholder size:self.bounds.size];
    
}

- (void)loadPlaceholder:(NSString *)placeholder
                  size:(CGSize)size
                {
    
    [self loadPlaceholder:placeholder size:size cachePath:nil handle:nil];
    
}
- (void)loadPlaceholder:(NSString *)placeholder
                  size:(CGSize)size
             cachePath:(CachePathBlock)pathBlock
                handle:(ImageHandleBlock)handleBlock{
    
    
    //没有设置占位图
    if(placeholder.length<=0) return;
    
    if(!pathBlock) pathBlock = [ImageHandle defaultPathBlock];
    if(!handleBlock) handleBlock = [ImageHandle defaltHandleBlock];
    
    NSString *catchPath = pathBlock(size,placeholder);

    //如果有缓存处理过后的图片
    if([ImageHandle containsImageForKey:catchPath]){
        
        [ImageHandle getImageForKey:catchPath result:^(UIImage *image) {
            
            [self displayImage:image];
            
        }];
        
        return;
    }
    
    //处理图片
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *image = [UIImage imageNamed:placeholder];
        
        UIImage *newImage = handleBlock(size,image);
        
        [ImageHandle cacheImage:newImage ForKey:catchPath];
        
        [self displayImage:newImage];

    });

}
- (void)displayImage:(UIImage *)image{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.image =image;
        CATransition *transition = [CATransition animation];
        transition.duration = 0.15;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        transition.type = kCATransitionFade;
        [self.layer addAnimation:transition forKey:@"contents"];
        
    });
    
}
@end
