//
//  DXNestCollectionViewController.m
//  DXNestCollectionDemo
//
//  Created by 邓星 on 2020/3/11.
//  Copyright © 2020 邓星. All rights reserved.
//

#import "DXNestCollectionViewController.h"
#import "DXNestCollectionTitleCell.h"
#import "DXNestCollectionVCCell.h"

@interface DXNestCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <DXNestCollectionViewControllerDelegate> delegate;
@property (nonatomic, strong) UICollectionView *titleCollectionView;//tag: 101
@property (nonatomic, strong) UICollectionView *controllerCollectionView;//tag: 102
@property (nonatomic, copy) NSArray *titleStringArray;
@property (nonatomic, copy) NSArray *controllerArray;
@property (nonatomic, strong) DXNestCollectionTitleCell *selectTitleCell;
@property (nonatomic, strong) NSIndexPath *selectIndex;
@property (nonatomic, strong) UIView *selectLine;
@property (nonatomic, strong) UIView *selectLineBackView;
@property (nonatomic, strong) UIColor *titleColorSelect;
@property (nonatomic, strong) UIColor *titleColorNormal;
@property (nonatomic, strong) UIFont *titleFontNormal;
@property (nonatomic, strong) UIFont *titleFontSelect;

@property (nonatomic, strong) NSMutableArray *titleJuestWidths;

@end

static NSString *titleCollectionViewIdentifier = @"titleCollectionViewIdentifier";
static NSString *controllerCollectionViewIdentifier = @"controllerCollectionViewIdentifier";

@implementation DXNestCollectionViewController

+ (DXNestCollectionViewController *)creatNestControllerWithDelegate:(id)delegate {
    DXNestCollectionViewController *nestController = [[DXNestCollectionViewController alloc] init];
    nestController.delegate = delegate;
    nestController.contentScroller = YES;
    return nestController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleCollectionView];
    if (_titleRightView) {
        [self.view addSubview:_titleRightView];
    }
    [self.titleCollectionView addSubview:self.selectLineBackView];
    [self.titleCollectionView addSubview:self.selectLine];
    [self.view addSubview:self.controllerCollectionView];
    [self.view setNeedsUpdateConstraints];
    [self reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)updateViewConstraints {
    [_titleCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view);
        if (!_titleRightView) {
            make.right.equalTo(self.view);
        } else {
            make.right.equalTo(_titleRightView.mas_left).offset(-_titleRightViewSpace);
        }
        make.height.mas_equalTo(_titleCollectionSize.height > 0 ? _titleCollectionSize.height : 60);
    }];
    
    [_titleRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleCollectionView);
        make.right.equalTo(self.view).offset(- _titleRightViewSpace);
        make.size.mas_equalTo(_titleRightViewSize);
    }];
    
    [_controllerCollectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_titleCollectionView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(_contentCollectionSize.width > 0 ? _contentCollectionSize.width : [[UIScreen mainScreen] bounds].size.width, _contentCollectionSize.height > 0 ? _contentCollectionSize.height : 300));
    }];
    
    [_selectLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        float width = _selectLineSize.width > 0 ? _selectLineSize.width : 80;
        float offsetW = (_titleCollectionSize.width - width ) / 2;
        if (_autoJuestTitleWidth && _titleJuestWidths.count) {
            width = [_titleJuestWidths[_selectIndex.item] floatValue] - _titleSpace;
            offsetW = _titleSpace / 2;
        }
        float height = _selectLineSize.height > 0 ? _selectLineSize.height : 3;
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
        make.top.equalTo(_titleCollectionView).offset((_titleCollectionSize.height > 0 ? _titleCollectionSize.height : 60) - height);
        if (!_selectIndex) {
            make.left.equalTo(self.view).offset(offsetW);
        } else {
            float x = 0;
            UICollectionViewCell *cell = [_titleCollectionView cellForItemAtIndexPath:_selectIndex];
            if (!cell) {
                if (_autoJuestTitleWidth) {
                    for (int i = 0; i < _selectIndex.item; i++) {
                        if (_titleJuestWidths.count > i ) {
                            x += [_titleJuestWidths[i] floatValue];
                        }
                    }
                } else {
                    x = _selectIndex.item * width;
                }
            } else {
                x = cell.frame.origin.x;
            }
            make.left.mas_equalTo(_titleCollectionView).offset(x + offsetW);
        }
    }];
    
    [_selectLineBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        float height = _selectLineSize.height > 0 ? _selectLineSize.height : 3;
        if (height / 2 < 1.0 ) {
            make.height.mas_equalTo(1.0);
            make.top.equalTo(_selectLine).offset(height - 1.0);
        } else {
            make.height.mas_equalTo(height / 2.0);
            make.top.equalTo(_selectLine).offset(height / 2.0);
        }
        make.left.right.equalTo(self.view);
    }];
    
    [super updateViewConstraints];
}

#pragma mark - collectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleStringArray.count <= self.controllerArray.count ? self.titleStringArray.count : self.controllerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 101) {
        DXNestCollectionTitleCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:titleCollectionViewIdentifier forIndexPath:indexPath];
        cell.titleColorNormal = _titleColorNormal;
        cell.titleColorSelect = _titleColorSelect;
        cell.titleFontNormal = _titleFontNormal;
        cell.titleFontSelect = _titleFontSelect;
        cell.promptTagColor = _titlePromptColor;
        if ([[self.titleStringArray lastObject] isKindOfClass:[NSString class]]) {
            cell.titleLabel.text = self.titleStringArray[indexPath.item];
            cell.titleLabel.hidden = NO;
            cell.contentLabel.hidden = YES;
        } else if ([[self.titleStringArray lastObject] isKindOfClass:[NSDictionary class]]) {
            cell.contentLabel.textLabel.text = self.titleStringArray[indexPath.item][@"text"];
            cell.contentLabel.countLabel.text = self.titleStringArray[indexPath.item][@"count"];
            cell.titleLabel.hidden = YES;
            cell.contentLabel.hidden = NO;
        }
        if (!_selectIndex) {
            self.selectIndex = indexPath;
            [self moveSelectLine];
        }
        
        if (!_selectIndex || [_selectIndex isEqual:indexPath]) {
            self.selectIndex = indexPath;
            [cell didSelectCell];
            _selectTitleCell = cell;
        } else {
            [cell didUnSelectCell];
        }
        
        if (_titlePromptTagArray.count > indexPath.item ) {
            cell.ifNeedShowPrompt = [_titlePromptTagArray[indexPath.item] boolValue];
        }
        return cell;
    } else {
        DXNestCollectionVCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:controllerCollectionViewIdentifier forIndexPath:indexPath];
        UIViewController *vc = self.controllerArray[indexPath.item];
        cell.showView = vc.view;
        return cell;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 101) {
        [self refreshSelectTitleCollectionViewWithIndexPath:indexPath];
        [_controllerCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self moveSelectLine];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 102) {
        float offSizeX = scrollView.contentOffset.x;
        float index = offSizeX / (_contentCollectionSize.width > 0 ? _contentCollectionSize.width : [[UIScreen mainScreen] bounds].size.width);
        if (index - (int)index > 0.9) {
            index = (int)index + 1;
        }
        NSIndexPath *indexPaht = [NSIndexPath indexPathForItem:index inSection:0];
        [self refreshSelectTitleCollectionViewWithIndexPath:indexPaht];
        [self moveSelectLine];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 102) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(nestCollectViewController:didDisAppearViewController:formIndex:)]) {
            UIViewController *vc = self.controllerArray[indexPath.item];
            [self.delegate nestCollectViewController:self didDisAppearViewController:vc formIndex:indexPath.item];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 102) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(nestCollectViewController:willDisAppearViewController:formIndex:)]) {
            UIViewController *vc = self.controllerArray[indexPath.item];
            [self.delegate nestCollectViewController:self willDisAppearViewController:vc formIndex:indexPath.item];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (101 == collectionView.tag) {
        if (_autoJuestTitleWidth) {
            float width = [_titleJuestWidths[indexPath.item] floatValue];
            return CGSizeMake(width, _titleCollectionSize.height > 0 ? _titleCollectionSize.height : 60);
        } else {
            return CGSizeMake(_titleCollectionSize.width > 0 ? _titleCollectionSize.width : 80, _titleCollectionSize.height > 0 ? _titleCollectionSize.height : 60);
        }
    } else {
        return CGSizeMake(_contentCollectionSize.width > 0 ? _contentCollectionSize.width : [[UIScreen mainScreen] bounds].size.width, _contentCollectionSize.height > 0 ? _contentCollectionSize.height : 300);
    }
    
}

#pragma mark -

- (void)changeContentToIndex:(NSInteger)index {
    [self refreshSelectTitleCollectionViewWithIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    [_controllerCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    [self moveSelectLine];
}

- (void)refreshSelectTitleCollectionViewWithIndexPath:(NSIndexPath *)indexPath {
    [_selectTitleCell didUnSelectCell];
    self.selectIndex = indexPath;
    DXNestCollectionTitleCell *newCell = (DXNestCollectionTitleCell *)[_titleCollectionView cellForItemAtIndexPath:indexPath];
    [newCell didSelectCell];
    _selectTitleCell = newCell;
    [_titleCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (void)moveSelectLine {
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - soucre
- (void)reloadData {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_titleCollectionView || !_controllerCollectionView) {
            return;
        }
        _titleStringArray = nil;
        _controllerArray = nil;
        [self.titleCollectionView reloadData];
        [self.controllerCollectionView reloadData];
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraintsIfNeeded];
    });
}

#pragma  mark - set&get
- (UICollectionView *)titleCollectionView {
    if (!_titleCollectionView) {
        NSArray *lessArray = nil;
        if (self.titleStringArray.count < self.controllerArray.count) {
            lessArray = _titleStringArray;
        } else {
            lessArray = _controllerArray;
        }
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _titleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _titleCollectionView.tag = 101;
        _titleCollectionView.bounces = NO;
        _titleCollectionView.showsHorizontalScrollIndicator = NO;
        _titleCollectionView.dataSource = self;
        _titleCollectionView.delegate = self;
        _titleCollectionView.backgroundColor = [UIColor whiteColor];
        [_titleCollectionView registerClass:[DXNestCollectionTitleCell class] forCellWithReuseIdentifier:titleCollectionViewIdentifier];
    }
    return _titleCollectionView;
}

- (UICollectionView *)controllerCollectionView {
    if (!_controllerCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _controllerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _controllerCollectionView.tag = 102;
        _controllerCollectionView.bounces = NO;
        _controllerCollectionView.showsHorizontalScrollIndicator = NO;
        _controllerCollectionView.dataSource = self;
        _controllerCollectionView.delegate = self;
        _controllerCollectionView.pagingEnabled = YES;
        _controllerCollectionView.scrollEnabled = _contentScroller;
        _controllerCollectionView.backgroundColor = [UIColor whiteColor];
        [_controllerCollectionView registerClass:[DXNestCollectionVCCell class] forCellWithReuseIdentifier:controllerCollectionViewIdentifier];
    }
    return _controllerCollectionView;
}

- (NSArray *)titleStringArray {
    if (!_titleStringArray && self.delegate && [self.delegate respondsToSelector:@selector(nestCollectTitleStringsInController:)]) {
        _titleStringArray = [self.delegate nestCollectTitleStringsInController:self];
        if ((_titleStringArray.count > _autoHiddenRightViewNum && _titleRightView && _autoHiddenRightView) || (!_autoHiddenRightView && _titleRightView)) {
            _titleRightView.hidden = NO;
        } else if (_titleRightView && _autoHiddenRightView && _titleStringArray.count <= _autoHiddenRightViewNum) {
            _titleRightView.hidden = YES;
        }
        UILabel *label = [[UILabel alloc] init];
        if (_autoJuestTitleWidth) {
            _titleJuestWidths = [NSMutableArray array];
            for (NSString *str in _titleStringArray) {
                label.text = str;
                label.font = _titleFontNormal;
                float wid = [label sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
                _titleSpace = _titleSpace > 0 ? _titleSpace : 10;
                [_titleJuestWidths addObject:[NSNumber numberWithFloat:wid + _titleSpace]];

            }
        }
    }
    return _titleStringArray;
}

- (NSArray *)controllerArray {
    if (!_controllerArray && self.delegate && [self.delegate respondsToSelector:@selector(nestCollectControllersInController:)]) {
        _controllerArray = [self.delegate nestCollectControllersInController:self];
        for (UIViewController *viewCotroller in _controllerArray) {
            [self addChildViewController:viewCotroller];
        }
    }
    return _controllerArray;
}

- (UIView *)selectLine {
    if (!_selectLine) {
        _selectLine = [[UIView alloc] init];
        _selectLine.backgroundColor = [UIColor redColor];
    }
    return _selectLine;
}

- (UIView *)selectLineBackView {
    if (!_selectLineBackView) {
        _selectLineBackView = [[UIView alloc] init];
        _selectLineBackView.backgroundColor = [UIColor lightGrayColor];
        _selectLineBackView.hidden = YES;
    }
    return _selectLineBackView;
}

- (void)setSelectLineColor:(UIColor *)selectLineColor {
    _selectLineColor = selectLineColor;
    self.selectLine.backgroundColor = _selectLineColor;
}

- (void)setSelectBackLineColor:(UIColor *)selectBackLineColor {
    _selectBackLineColor = selectBackLineColor;
    self.selectLineBackView.backgroundColor = _selectBackLineColor;
}

- (void)setShowSelectLine:(BOOL)showSelectLine {
    _showSelectLine = showSelectLine;
    self.selectLine.hidden = !_showSelectLine;
}

- (void)setShowSelectBackLine:(BOOL)showSelectBackLine {
    _showSelectBackLine = showSelectBackLine;
    self.selectLineBackView.hidden = !_showSelectBackLine;
}

- (void)setTitleBackColor:(UIColor *)titleBackColor {
    _titleBackColor = titleBackColor;
    self.titleCollectionView.backgroundColor = _titleBackColor;
}

- (void)setTitleTextColor:(UIColor *)color forState:(DXNestState)state {
    switch (state) {
        case DXNestStateNormol:
            _titleColorNormal = color;
            break;
        case DXNestStateSelect:
            _titleColorSelect = color;
            break;
        default:
            break;
    }
}

- (void)setTitleTextFont:(UIFont *)font forState:(DXNestState)state {
    switch (state) {
        case DXNestStateNormol:
            _titleFontNormal = font;
            break;
        case DXNestStateSelect:
            _titleFontSelect = font;
            break;
        default:
            break;
    }
}

- (NSInteger)currentIndex {
    return _selectIndex.item;
}

- (void)setSelectIndex:(NSIndexPath *)selectIndex {
    if (![_selectIndex isEqual:selectIndex]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(nestCollectViewController:willAppearViewController:formIndex:)]) {
            UIViewController *vc = self.controllerArray[selectIndex.item];
            [self.delegate nestCollectViewController:self willAppearViewController:vc formIndex:selectIndex.item];
        }
    }
    _selectIndex = selectIndex;
}

//- (void)setTitlePromptTagArray:(NSArray *)titlePromptTagArray {
//    _titlePromptTagArray = titlePromptTagArray;
////    [self.titleCollectionView reloadData];
//}


- (void)reloadSelectIndexAndData {
    _selectIndex = nil;
    self.titleCollectionView.contentOffset = CGPointMake(0, 0);
    self.controllerCollectionView.contentOffset = CGPointMake(0, 0);
    [self reloadData];
}

- (void)setTitleRightView:(UIView *)titleRightView {
    _titleRightView = titleRightView;
    if (!_titleRightViewSpace) {
        _titleRightViewSpace = 10;
    }
}

- (void)gotoLastIndex {
    dispatch_async(dispatch_get_main_queue(), ^{
        _selectIndex = [NSIndexPath indexPathForItem:self.titleStringArray.count - 1 inSection:0];
        [self.titleCollectionView selectItemAtIndexPath:_selectIndex animated:YES scrollPosition:UICollectionViewScrollPositionRight];
        [self.controllerCollectionView selectItemAtIndexPath:_selectIndex animated:YES scrollPosition:UICollectionViewScrollPositionRight];
        [self.view setNeedsUpdateConstraints];
        [self.view updateConstraintsIfNeeded];
        [self.view layoutIfNeeded];
    });
}

@end
