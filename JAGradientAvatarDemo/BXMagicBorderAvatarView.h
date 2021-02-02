//
//  BXMagicBorderAvatarView.h
//  JAGradientAvatarDemo
//
//  Created by jater on 2021/1/29.
//

#import <UIKit/UIKit.h>
@class BXMagicBorderAvatarView;

NS_ASSUME_NONNULL_BEGIN

/**
 边框配置
 */
@protocol BXMagicBorderProtocol <NSObject>

@required

@optional

- (NSArray<UIColor *> *)colorsForMagicBorderView:(BXMagicBorderAvatarView *)borderView;

- (CGFloat)borderWidthForMagicBorderView:(BXMagicBorderAvatarView *)borderView;

@end

/**
 动画配置
 */
@protocol BXMagicAvatarAnimationProtocol <NSObject>

@required

@optional

- (CGFloat)configAnimationDurationInAvatarView:(BXMagicBorderAvatarView *)avatarView;

- (CGFloat)configAnimationScaleInAvatarView:(BXMagicBorderAvatarView *)avatarView;

@end

@interface BXMagicBorderAvatarView : UIView<BXMagicBorderProtocol, BXMagicAvatarAnimationProtocol>

@property (nonatomic, weak) id<BXMagicBorderProtocol> borderDelegate;
@property (nonatomic, weak) id<BXMagicAvatarAnimationProtocol> avatarAnimationDelegate;

@property (nonatomic, copy) NSString *linkString;

- (void)startAnimation;

- (void)stopAnimation;

- (void)processAnimationWithPercent:(CGFloat)precent;
 
@end

NS_ASSUME_NONNULL_END
