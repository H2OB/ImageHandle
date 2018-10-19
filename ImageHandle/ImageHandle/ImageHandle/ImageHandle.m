//
//  ImageHandle.m
//  Made
//
//  Created by 杨涛 on 2018/10/19.
//  Copyright © 2018年 North. All rights reserved.
//

#import "ImageHandle.h"

#import <YYKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImageCoder.h>



@implementation ImageHandle
/**
 缓存是否包含图片
 
 @param key 缓存路径
 @return 有缓存返回YES
 */
+ (BOOL)containsImageForKey:(NSString *)key{
    
#warning 下面方法二选一
    
     return [[YYImageCache sharedCache] containsImageForKey:key]; // YYKit
    
     return [[SDImageCache sharedImageCache] diskImageDataExistsWithKey:key]; //SDWebImage
    
   
    
}

/**
 根据可以获取图片
 
 @param image 需要缓存的图片
 @param key 缓存路径
 */
+ (void)cacheImage:(UIImage *)image ForKey:(NSString *)key{
    
    #warning 下面方法二选一
    
    [[YYImageCache sharedCache] setImage:image forKey:key];
    
    [[SDImageCache sharedImageCache]  storeImage:image forKey:key completion:nil];
    
}

/**
 获取图片
 
 @param key 缓存路径
 @param result 如果image不为空有图片
 */
+ (void)getImageForKey:(NSString *)key result:(void(^)(UIImage *  image))result{
    
    #warning 下面方法二选一
    
    [[YYImageCache sharedCache] getImageForKey:key withType:YYImageCacheTypeAll withBlock:^(UIImage * _Nullable image, YYImageCacheType type) {
        result(image);
    }];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
       UIImage *image =   [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
        
        result(image);
        
    });


    
   
    
    
    
}

/**
 下载图片
 
 @param key 缓存路径
 @param result 如果image不为空有图片
 */

+ (void)downloadImageForKey:(NSString *)key result:(void(^)(UIImage *  image))result{
    
    #warning 下面方法二选一
    
    [[YYWebImageManager sharedManager] requestImageWithURL:[NSURL URLWithString:key] options:YYWebImageOptionAllowBackgroundTask progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        result(image);
        
    }];
    
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:key] options:SDWebImageDownloaderContinueInBackground progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
       
        result(image);
        
    }];
    
 
}

+ (CachePathBlock)defaultPathBlock{
    
    return ^NSString *(CGSize viewSize,NSString *append) {
        
        NSString *newPath = @"";
        //如果size存在
        if(!CGSizeEqualToSize(viewSize, CGSizeZero))
            newPath =  [newPath stringByAppendingFormat:@"%.2f-%.2f",viewSize.width,viewSize.height];
        
        newPath = [newPath stringByAppendingFormat:@"/%@",append];
        
        return newPath;
    };
    
}
+ (ImageHandleBlock)defaltHandleBlock{
    
    return ^UIImage*(CGSize viewSize,UIImage *image){
        
        //********处理方式的核心是 取图片中心的位置  然后缩放到imageView尺寸的 [UIScreen mainScreen].scale 倍
        
        
        //屏幕缩放比例
        CGFloat screenScale = [UIScreen mainScreen].scale;
        
        //图片的处理过后的宽高
        CGSize newSize = CGSizeMake(viewSize.width *screenScale, viewSize.height *screenScale);
        
        //对下载图片经过处理 处理原理就是 判断宽高比 取中间的最合适的位置 然后在缩放
        
        CGSize imgSize = image.size;
        CGFloat scale = 1;
        if(imgSize.width/newSize.width <=imgSize.height/newSize.height) scale =imgSize.width/newSize.width;
        else scale = imgSize.height/newSize.height;
        
        CGSize  clipSize = CGSizeMake(newSize.width *scale, newSize.height *scale);
        
        UIImage *newImage = nil;
        
        @autoreleasepool {
            
            #warning 这里用的是YYKit里面处理图片的分类 如果你不用刻意用你习惯的
            //对图片进行处理
            
            newImage = [image imageByResizeToSize:clipSize contentMode:UIViewContentModeScaleAspectFill]; //先取出适合尺寸的图片
            
            newImage = [newImage imageByResizeToSize:newSize]; //缩放图片
            
            newImage = [newImage imageByDecoded]; //解码图片(YYKit自带)

        }
        
        
        return newImage;
        
        
    };
    
}

@end
