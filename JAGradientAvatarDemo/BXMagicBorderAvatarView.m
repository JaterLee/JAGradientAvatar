//
//  BXMagicBorderAvatarView.m
//  JAGradientAvatarDemo
//
//  Created by jater on 2021/1/29.
//

#import "BXMagicBorderAvatarView.h"
#import <SDWebImage/SDWebImage.h>

@interface BXMagicBorderAvatarView ()

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIView *avatarBgView;
@property (nonatomic, strong) CAGradientLayer *gl;

@end

static NSString *const kScaleAnimationKey = @"kScaleAnimationKey";
static NSString *const kOpacityAnimationKey = @"kOpacityAnimationKey";

@implementation BXMagicBorderAvatarView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero]) {
        [self drawUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self drawUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat self_W = CGRectGetWidth(self.bounds);
    CGFloat avatarWH = self_W-self.borderLineWidth*2;
    _avatarImageView.bounds = CGRectMake(0, 0, avatarWH, avatarWH);
    _avatarImageView.center = CGPointMake(self_W/2, self_W/2);
    _avatarImageView.layer.cornerRadius = avatarWH/2;
    
    _avatarBgView.bounds = self.bounds;
    _avatarBgView.center = _avatarImageView.center;
    
    _gl.frame = _avatarBgView.bounds;
    CAShapeLayer *sl = [self shapeLayer];
    _gl.mask = sl;
}

- (void)drawUI {
    _avatarBgView = [[UIView alloc] init];
    [self insertSubview:_avatarBgView atIndex:0];
    _avatarBgView.center = _avatarImageView.center;
    
    _gl = [self bgGradientLayer];
    [_avatarBgView.layer addSublayer:_gl];
    
    _avatarImageView = [[UIImageView alloc] init];
    _avatarImageView.layer.masksToBounds = YES;
    [self addSubview:_avatarImageView];
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:@"https://avatars.githubusercontent.com/u/13514877?s=460&u=bf68b191d3304d3a5ebcc3d0610e85a72218ded8&v=4"] placeholderImage:nil];
}

- (CAGradientLayer *)bgGradientLayer {
    CAGradientLayer *bgGradientLayer = [CAGradientLayer layer];
    bgGradientLayer.colors = self.borderColors;
    bgGradientLayer.locations = @[@0, @1];
    bgGradientLayer.startPoint = CGPointMake(0, 0);
    bgGradientLayer.endPoint = CGPointMake(1, 1);
    bgGradientLayer.frame = _avatarBgView.bounds;
    bgGradientLayer.opacity = 0;
    return bgGradientLayer;
}

- (CAShapeLayer *)shapeLayer {
    CAShapeLayer *sl = [CAShapeLayer layer];
    sl.frame = _avatarBgView.bounds;
    UIBezierPath *bp = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(_avatarBgView.frame)/2, CGRectGetHeight(_avatarBgView.frame)/2) radius:CGRectGetWidth(_avatarBgView.frame)/2-self.borderLineWidth/2 startAngle:0 endAngle:M_PI*2 clockwise:NO];
    sl.path = bp.CGPath;
    sl.strokeColor = UIColor.yellowColor.CGColor;
    sl.lineWidth = self.borderLineWidth;
    sl.fillColor = UIColor.clearColor.CGColor;
    return sl;
}


#pragma mark - Public Methods

- (void)startAnimation {
    CAKeyframeAnimation *keyAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    keyAni.values = @[@1, @(self.aniScale), @1];
    keyAni.duration = self.aniDuration;
    keyAni.repeatCount = 1;
    
    [self.layer addAnimation:keyAni forKey:kScaleAnimationKey];
    
    CAKeyframeAnimation *sizeAni = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    sizeAni.values = @[@0, @1, @0];
    
    NSMutableArray *times = @[].mutableCopy;
    for (int i = 0; i < sizeAni.values.count; i++) {
        CAMediaTimingFunction *timeFunc = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
        [times addObject:timeFunc];
    }
    sizeAni.timingFunctions = times;
    sizeAni.duration = self.aniDuration;
    sizeAni.repeatCount = 1;
    _gl.colors = self.borderColors;
    [_gl addAnimation:sizeAni forKey:kOpacityAnimationKey];

}

- (void)stopAnimation {
    [self.layer removeAllAnimations];
    [_gl removeAllAnimations];
}

- (void)processAnimationWithPercent:(CGFloat)precent {
    if (![self.layer animationForKey:kScaleAnimationKey]) {
        self.layer.speed = 0;
        _gl.speed = 0;
        [self startAnimation];
    }
    self.layer.timeOffset = precent*self.aniDuration;
    _gl.timeOffset = precent*self.aniDuration;
}

#pragma mark - Setter and Getter

- (CGFloat)borderLineWidth {
    if (self.borderDelegate && [self.borderDelegate respondsToSelector:@selector(borderWidthForMagicBorderView:)]) {
        return [self.borderDelegate borderWidthForMagicBorderView:self];
    }
    return 0;
}

- (NSArray *)borderColors {
    if (self.borderDelegate && [self.borderDelegate respondsToSelector:@selector(colorsForMagicBorderView:)]) {
        NSArray<UIColor *> *temp = [self.borderDelegate colorsForMagicBorderView:self];
        NSMutableArray *containerTemp = @[].mutableCopy;
        [temp enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [containerTemp addObject:(id)obj.CGColor];
        }];
        return containerTemp;
    }
    return nil;
}

- (CGFloat)aniDuration {
    if (self.avatarAnimationDelegate && [self.avatarAnimationDelegate respondsToSelector:@selector(configAnimationDurationInAvatarView:)]) {
        return [self.avatarAnimationDelegate configAnimationDurationInAvatarView:self];
    }
    return 2;
}

- (CGFloat)aniScale {
    if (self.avatarAnimationDelegate && [self.avatarAnimationDelegate respondsToSelector:@selector(configAnimationScaleInAvatarView:)]) {
        return [self.avatarAnimationDelegate configAnimationScaleInAvatarView:self];
    }
    return 1.5f;
}

@end

