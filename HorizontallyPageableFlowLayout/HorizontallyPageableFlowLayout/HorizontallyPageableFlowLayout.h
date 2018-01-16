//
//  HorizontallyPageableFlowLayout.h
//  HorizontallyPageableFlowLayout
//
//  Created by 车 on 2018/1/16.
//  Copyright © 2018年 车. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontallyPageableFlowLayout : UICollectionViewFlowLayout

- (instancetype)initWithItemCountPerRow:(NSInteger)itemCountPerRow
                            maxRowCount:(NSInteger)maxRowCount;

@end
