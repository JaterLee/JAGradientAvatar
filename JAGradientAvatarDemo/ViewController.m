//
//  ViewController.m
//  JAGradientAvatarDemo
//
//  Created by jater on 2021/1/29.
//

#import "ViewController.h"
#import <SDWebImage/SDWebImage.h>
#import "BXMagicBorderAvatarView.h"

@interface ViewController ()<BXMagicBorderProtocol, BXMagicAvatarAnimationProtocol>

@end

CGFloat luxColorComponentFrom(NSString *string, NSUInteger start, NSUInteger length) {
    NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];

    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0f;
}

UIColor *luxColorWithHexString(NSString *hexString) {
    CGFloat alpha, red, blue, green;
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = luxColorComponentFrom(colorString, 0, 1);
            green = luxColorComponentFrom(colorString, 1, 1);
            blue  = luxColorComponentFrom(colorString, 2, 1);
            break;

        case 4: // #ARGB
            alpha = luxColorComponentFrom(colorString, 0, 1);
            red   = luxColorComponentFrom(colorString, 1, 1);
            green = luxColorComponentFrom(colorString, 2, 1);
            blue  = luxColorComponentFrom(colorString, 3, 1);
            break;

        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = luxColorComponentFrom(colorString, 0, 2);
            green = luxColorComponentFrom(colorString, 2, 2);
            blue  = luxColorComponentFrom(colorString, 4, 2);
            break;

        case 8: // #AARRGGBB
            alpha = luxColorComponentFrom(colorString, 0, 2);
            red   = luxColorComponentFrom(colorString, 2, 2);
            green = luxColorComponentFrom(colorString, 4, 2);
            blue  = luxColorComponentFrom(colorString, 6, 2);
            break;

        default:
            return nil;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@implementation ViewController {
    BXMagicBorderAvatarView *_magicAvatarView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i<(arc4random()%50+1) ; i++) {
        BXMagicBorderAvatarView *aView = [[BXMagicBorderAvatarView alloc] initWithFrame:CGRectZero];
        CGFloat arcWH = arc4random()%64+30;
        aView.bounds = CGRectMake(0, 0, arcWH, arcWH);
        aView.center = CGPointMake(arc4random()%((int)(CGRectGetWidth(self.view.bounds))-80) + 40, arc4random()%((int)(CGRectGetHeight(self.view.bounds)/2)-80) + 80+88);
        aView.borderDelegate = self;
        aView.avatarAnimationDelegate = self;
        [self.view addSubview:aView];
    }
}

#pragma mark - BXMagicBorderProtocol

- (NSArray<UIColor *> *)colorsForMagicBorderView:(BXMagicBorderAvatarView *)borderView {
    return @[UIColor.yellowColor, UIColor.redColor];//@[luxColorWithHexString(@"#FF5DF0"), luxColorWithHexString(@"E806FF")];
}

- (CGFloat)borderWidthForMagicBorderView:(BXMagicBorderAvatarView *)borderView {
    return 1.75;
}

#pragma mark - BXMagicAvatarAnimationProtocol

- (CGFloat)configAnimationDurationInAvatarView:(BXMagicBorderAvatarView *)avatarView {
    return 2;
}

- (CGFloat)configAnimationScaleInAvatarView:(BXMagicBorderAvatarView *)avatarView {
    return 2;//64/CGRectGetWidth(avatarView.bounds);
}


- (IBAction)start:(id)sender {
//    [_magicAvatarView startAnimation];
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BXMagicBorderAvatarView class]]) {
            BXMagicBorderAvatarView *temp = (BXMagicBorderAvatarView *)obj;
            [temp startAnimation];
        }
    }];
}

- (IBAction)stop:(id)sender {
//    [_magicAvatarView stopAnimation];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BXMagicBorderAvatarView class]]) {
            BXMagicBorderAvatarView *temp = (BXMagicBorderAvatarView *)obj;
            [temp stopAnimation];
        }
    }];
}

- (IBAction)process:(UISlider *)sender {
//    NSLog(@"%@", @(sender.value));
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[BXMagicBorderAvatarView class]]) {
            BXMagicBorderAvatarView *temp = (BXMagicBorderAvatarView *)obj;
            [temp processAnimationWithPercent:sender.value];
        }
    }];
    
}

@end
