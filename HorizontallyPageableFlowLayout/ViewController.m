//
//  ViewController.m
//  HorizontallyPageableFlowLayout
//
//  Created by 车 on 2018/1/16.
//  Copyright © 2018年 车. All rights reserved.
//

#import "ViewController.h"
#import "HorizontallyPageableFlowLayout.h"
#import "CollectionViewLabelCell.h"

#define kMaxRowCount         2.f
#define kItemCountPerRow     4.f
static const CGFloat kMaxRowCount = 2.f;
static const CGFloat kItemCountPerRow = 4.f;

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) HorizontallyPageableFlowLayout *layout;

@end


@implementation ViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.addButton];
    [self.view addSubview:self.deleteButton];
    [self.view addSubview:self.collectionView];
    
    [self reloadCollectionView];
}


#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger itemCount;
    if (self.dataArray.count == 0) {
        itemCount = 0;
    } else if (self.dataArray.count / (kMaxRowCount * kItemCountPerRow) > 1) {
        // 超过一页
        itemCount = kMaxRowCount * kItemCountPerRow * ceilf(self.dataArray.count / (kMaxRowCount * kItemCountPerRow));
    } else {
        itemCount = ceilf(self.dataArray.count / kItemCountPerRow) * kItemCountPerRow;
    }
    return itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[CollectionViewLabelCell description] forIndexPath:indexPath];
    
    if (indexPath.item < self.dataArray.count) {
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.labelTitle.text = self.dataArray[indexPath.item];
        cell.labelTitle.textColor = [UIColor grayColor];
    }else{
        cell.backgroundColor = [UIColor clearColor];
        cell.labelTitle.text = @"";
    }
    return cell;
}


#pragma mark - Method

- (void)clickButton:(UIButton *)button {
    if (button.tag == 100) {
        // +
        if (self.dataArray.count) {
            NSString *title = self.dataArray.lastObject;
            NSInteger addNumber = title.integerValue + 1;
            [self.dataArray addObject:[NSString stringWithFormat:@"%ld", addNumber]];
        } else {
            [self.dataArray addObject:@"0"];
        }
        
    } else {
        // -
        if (self.dataArray.count) {
            [self.dataArray removeLastObject];
        } else {
            return;
        }
    }
    
    [self reloadCollectionView];
}

- (void)reloadCollectionView {
    NSInteger rowCount;
    if (self.dataArray.count == 0) {
        rowCount = 0;
    } else if (self.dataArray.count / (kMaxRowCount * kItemCountPerRow) > 1) {
        rowCount = kMaxRowCount;
    } else {
        rowCount = ceil(self.dataArray.count / kItemCountPerRow);
    }
    
    CGFloat collectionViewHeight = rowCount * CGRectGetWidth(self.view.frame) / kItemCountPerRow;
    self.collectionView.frame = CGRectMake(0, 120, CGRectGetWidth(self.view.frame), collectionViewHeight);
    
    [self.collectionView reloadData];
}


#pragma mark - Lazyloading

- (UIButton *)addButton {
    if (_addButton == nil) {
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 64, 50, 50)];
        _addButton.tag = 100;
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _addButton.backgroundColor = [UIColor lightGrayColor];
        [_addButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIButton *)deleteButton {
    if (_deleteButton == nil) {
        _deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 50 - 40, 64, 50, 50)];
        _deleteButton.tag = 101;
        [_deleteButton setTitle:@"-" forState:UIControlStateNormal];
        [_deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _deleteButton.backgroundColor = [UIColor lightGrayColor];
        [_deleteButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        CGRect frame = CGRectMake(0, 120, CGRectGetWidth(self.view.frame), CGRectGetWidth(self.view.frame) / kItemCountPerRow * kMaxRowCount);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerNib:[UINib nibWithNibName:[CollectionViewLabelCell description] bundle:nil] forCellWithReuseIdentifier:[CollectionViewLabelCell description]];
        _collectionView.backgroundColor = [UIColor cyanColor];
    }
    return _collectionView;
}

- (HorizontallyPageableFlowLayout *)layout {
    if (_layout == nil) {
        _layout = [[HorizontallyPageableFlowLayout alloc] initWithItemCountPerRow:kItemCountPerRow maxRowCount:kMaxRowCount];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame) / kItemCountPerRow, CGRectGetWidth(self.view.frame) / kItemCountPerRow);
    }
    return _layout;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            [_dataArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _dataArray;
}

@end
