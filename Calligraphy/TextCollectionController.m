//
//  TextCollectionController.m
//  Calligraphy
//
//  Created by QiMENG on 15/5/21.
//  Copyright (c) 2015年 QiMENG. All rights reserved.
//

#import "TextCollectionController.h"
#import "Service.h"
#import <UIImageView+WebCache.h>
@interface TextCollectionController ()

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation TextCollectionController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
//    self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = _searchStr;

    _dataArray = [NSMutableArray array];
    

    [SVProgressHUD showWithStatus:@"正在加载..."];
    [Service SearchText:_searchStr parameters:nil withBlock:^(NSArray *posts, NSError *error) {
        _dataArray = [NSMutableArray arrayWithArray:posts];
        [self.collectionView reloadData];
        [SVProgressHUD dismiss];
    }];
    
    if (![UserData iAPClear]) {
//        int a = arc4random()%10;
//        if (a>4) {
            [YouMiNewSpot showYouMiSpotAction:^(BOOL flag){
            }];
//        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return _dataArray.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    DataItem * item = _dataArray[section];
    return item.subArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell

    DataItem * item = _dataArray[indexPath.section];
    
    DataItem * sutItem = item.subArray[indexPath.row];
    
//    UILabel * titleLabel = (UILabel *)[cell viewWithTag:100];
//    titleLabel.text = sutItem.title;
    UIImageView * imageView = (UIImageView *)[cell viewWithTag:111];
    
    @autoreleasepool {
        [imageView sd_setImageWithURL:[NSURL URLWithString:sutItem.imgurlstr] placeholderImage:nil];
    }
    
//    cell.backgroundColor = [UIColor colorWithRed:(1-(10 * indexPath.row) / 255.0) green:(1-(20 * indexPath.row)/255.0) blue:(1-(30 * indexPath.row)/255.0) alpha:1.0f];
    
    cell.layer.borderColor = [UIColor blackColor].CGColor ;
    cell.layer.borderWidth = 1;
    cell.layer.masksToBounds = YES;
    
    return cell;
}



#pragma mark <UICollectionViewDelegate>
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        UILabel * titleLable = (UILabel *)[headerView viewWithTag:100];
        
        if (!titleLable) {
            titleLable = [[UILabel alloc]initWithFrame:headerView.bounds];
            [headerView addSubview:titleLable];
            titleLable.numberOfLines = 1;
        }
        
        DataItem * item = _dataArray[indexPath.section];
        
        
        
        titleLable.text = item.typestr;
        
        reusableview = headerView;
        
    }
    return reusableview;
    
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,10, 10, 10);
}
@end
