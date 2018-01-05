//
//  NSString+Extension.m
//  LLModularizationDemo
//
//  Created by 李林 on 1/5/18.
//  Copyright © 2018 lee. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (CGSize)sizeWithFont:(UIFont *)font inSize:(CGSize)size {
    return [self sizeWithFont:font inSize:size lineSpacing:0];
}

- (CGSize)sizeWithFont:(UIFont *)font inSize:(CGSize)size lineSpacing:(CGFloat)space{
    CGSize s = CGSizeZero;
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = space;
    NSDictionary * attributes = @{NSFontAttributeName : font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    s = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |
         NSStringDrawingUsesFontLeading
                        attributes:attributes
                           context:nil].size;
    
    return s;
}

@end
