//  Copyright © 2025 Tencent. All rights reserved.

#import "DRMPlayerControlCollectionCell.h"
#import "TXAppInstance.h"

@interface DRMPlayerControlCollectionCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) DRMPlayerControlViewModel *viewModel;

@end

@implementation DRMPlayerControlCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.clearColor;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

- (void)bindViewModel:(DRMPlayerControlViewModel *)viewModel {
    if ([self.viewModel isEqual:viewModel]) {
        return;
    }
    [self.viewModel removeObserver:self forKeyPath:NSStringFromSelector(@selector(imageName))];
    self.viewModel = viewModel;
    [self configObserver];
    [self refreshImage];
}

#pragma mark - KVO

- (void)configObserver {
    [self.viewModel addObserver:self
                     forKeyPath:NSStringFromSelector(@selector(imageName))
                        options:NSKeyValueObservingOptionNew
                        context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(imageName))]) {
        [self refreshImage];
    }
}

- (void)refreshImage {
    UIImage *image = [[TXAppInstance class] imageFromPlayerBundleNamed:self.viewModel.imageName];
    self.imageView.image = image;
}

#pragma mark - Initialize

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = UIColor.clearColor;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
