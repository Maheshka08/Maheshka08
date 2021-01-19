//
//  OpenCVWrapper.h
//  Flyshot
//
//  Created by Artyom Lihach on 20/01/2019.
//  Copyright © 2019 Flyshot. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (instancetype)shared;

- (UIImage *)croppedImageFrom:(UIImage *)image;
- (NSString *)pHashFrom:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
