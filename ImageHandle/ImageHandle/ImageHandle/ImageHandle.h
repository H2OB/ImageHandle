//
//  ImageHandle.h
//  Made
//
//  Created by 杨涛 on 2018/10/19.
//  Copyright © 2018年 North. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NSString * (^CachePathBlock)(CGSize viewSize,NSString *append);

typedef UIImage * (^ImageHandleBlock)(CGSize viewSize,UIImage *image);



@interface ImageHandle : NSObject
/**
 缓存是否包含图片
 
 @param key 缓存路径
 @return 有缓存返回YES
 */
+ (BOOL)containsImageForKey:(NSString *)key;

/**
 根据可以获取图片
 
 @param image 需要缓存的图片
 @param key 缓存路径
 */
+ (void)cacheImage:(UIImage *)image ForKey:(NSString *)key;

/**
 获取图片
 
 @param key 缓存路径
 @param result 如果image不为空有图片
 */
+ (void)getImageForKey:(NSString *)key result:(void(^)(UIImage *  image))result;

/**
 下载图片
 
 @param key 缓存路径
 @param result 如果image不为空有图片
 */

+ (void)downloadImageForKey:(NSString *)key result:(void(^)(UIImage *  image))result;


/**
 图片缓存路径设置

 @return 处理块
 */
+ (CachePathBlock)defaultPathBlock;

/**
 图片处理块 圆角描边 缩放 等

 @return 处理快
 */
+ (ImageHandleBlock)defaltHandleBlock;

@end


