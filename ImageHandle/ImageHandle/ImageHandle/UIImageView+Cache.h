//
//  UIImageView+Cache.h
//  Made
//
//  Created by 杨涛 on 2018/10/18.
//  Copyright © 2018年 North. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ImageHandle.h"

@interface UIImageView (Cache)


// 本分类用于加载适合imageView 尺寸的图片

// 最终处理后的图片不大于 imageView的size *[UIScreen mainScreen].scale

// 带size参数的方法 是用于加载图片的时候 可能imageView尺寸还不确定 如果确定了不用调用带size参数的方法

// 带 radius参数的方法 用于需要图片显示圆角的图片 不需要不用可以换其他不带radius参数的方法 或者传 CGFLOAT_MIN 都可以

//图片处理的核心是  imageView的尺寸与最终下载下来的图片尺寸比较 然后一定比例缩放 取中间部分


#pragma mark 加载图片

- (void)loadImageWithURL:(NSString *)URL
             placeholder:(NSString *)placeholder;

- (void)loadImageWithURL:(NSString *)URL
             placeholder:(NSString *)placeholder
                    size:(CGSize)size;

- (void)loadImageWithURL:(NSString *)URL
             placeholder:(NSString *)placeholder
                    radius:(CGFloat)radius;

- (void)loadImageWithURL:(NSString *)URL
             placeholder:(NSString *)placeholder
                    size:(CGSize)size
                  radius:(CGFloat)radius;

- (void)loadImageWithURL:(NSString *)URL
             placeholder:(NSString *)placeholder
               cachePath:(CachePathBlock)pathBlock
                  handle:(ImageHandleBlock)handleBlock;


- (void)loadImageWithURL:(NSString *)URL
             placeholder:(NSString *)placeholder
                    size:(CGSize)size
               cachePath:(CachePathBlock)pathBlock
                  handle:(ImageHandleBlock)handleBlock;

#pragma mark 设置下载前显示的图片

- (void)loadPlaceholder:(NSString *)placeholder;

- (void)loadPlaceholder:(NSString *)placeholder
                  size:(CGSize)size;

- (void)loadPlaceholder:(NSString *)placeholder
                  size:(CGSize)size
             cachePath:(CachePathBlock)pathBlock
                handle:(ImageHandleBlock)handleBlock;
@end


