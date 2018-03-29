//
//  GHCycleView.m
//  GHCycleView
//
//  Created by gaozhihong on 2018/3/29.
//  Copyright © 2018年 gaozhihong. All rights reserved.
//

#import "GHCycleView.h"
#import "UIImageView+WebCache.h"

@interface  GHCycleView() <UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
@property(nonatomic,strong)NSArray *imgUrls;
 /** collectionView */
@property(nonatomic,strong)UICollectionView *collectonView;
  /** pageControl */
@property(nonatomic,strong)UIPageControl *pageControl;
 /** flowLayout */
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
 /** timer*/
@property(nonatomic,strong)NSTimer *timer;
@end
 /** reuserIdentifier */
static NSString *reuserIdentifier = @"reuserIdentifier";
@implementation GHCycleView


-(instancetype)initCycleView:(CGRect)frame imgUrls:(NSArray *)imgUrls{
    self = [super initWithFrame:frame];
    self.imgUrls = imgUrls;
    [self setupCollectionView];
    [self setupPageControl];
    [self addTimer];
    return self;
}
-(void)setupCollectionView{
    _collectonView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:self.flowLayout];
    _collectonView.backgroundColor =[UIColor whiteColor];
    _collectonView.pagingEnabled = YES;
    _collectonView.delegate = self;
    _collectonView.dataSource = self;
    _collectonView.bounces = YES;
    _collectonView.showsHorizontalScrollIndicator = YES;
    [self addSubview:_collectonView];
    [_collectonView registerClass:[GHCycleViewCell class] forCellWithReuseIdentifier:reuserIdentifier];
}
-(void)setupPageControl{
    [self addSubview:self.pageControl];
}

-(void)addTimer {
    if (self.timer) return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
         self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    });
   
}
-(void)removeTimer{
    [self.timer invalidate];
    self.timer  = nil;
}
#define KSectionCount 3
#pragma mark  -- updateTimer
-(void)updateTimer{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger currentIndex = _collectonView.contentOffset.x/_collectonView.bounds.size.width;
        currentIndex ++;
//        NSLog(@"curIndex == %lu",currentIndex);
        [_collectonView setContentOffset:CGPointMake(currentIndex *_collectonView.bounds.size.width, 0) animated:YES];
    });
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return KSectionCount;
};

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imgUrls.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GHCycleViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:reuserIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[GHCycleViewCell alloc] init];
    }
//    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1.0];
    NSString *url = [NSString stringWithFormat:@"%@",self.imgUrls[indexPath.row]];
    cell.imgUrl = url;
    cell.number = [NSNumber numberWithInteger:indexPath.row];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellSeclectedBlock) {
        self.cellSeclectedBlock();
    }
     // delegate
    if ([self.cycleViewDelegate respondsToSelector:@selector(ghCycleViewDidClick:)]) {
        [self.cycleViewDelegate ghCycleViewDidClick:[NSNumber numberWithInteger:indexPath.row]];
    }
}
#pragma  mark   -- collectonViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger currentPage =(NSInteger)(scrollView.contentOffset.x /scrollView.bounds.size.width + 0.5) % self.imgUrls.count;
    self.pageControl.currentPage = currentPage;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = (NSInteger)scrollView.contentOffset.x /scrollView.bounds.size.width;
    if (index == 0) {
        index = self.imgUrls.count;
        float offsetX = index *scrollView.bounds.size.width;
        [scrollView setContentOffset:CGPointMake(offsetX, 0)];
    }else if (index == KSectionCount *self.imgUrls.count -1){
        index  = self.imgUrls.count-1;
        float offsetX = index *scrollView.bounds.size.width;
        [scrollView setContentOffset:CGPointMake(offsetX, 0)];
    }
    NSLog(@"%lu",index);
    [self addTimer];
   
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self scrollViewDidEndDecelerating:scrollView];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}



-(NSArray *)imgUrls{
    if (_imgUrls == nil) {
        _imgUrls = [NSArray array];
    }
    return _imgUrls;
}

-(UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}
-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        float pageControlW = 200;
        float pageControlH = 40;
        float pageControlX = (self.frame.size.width -pageControlW)/2.0;
        float pageControlY = self.frame.size.height -pageControlH-10;
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH)];
        _pageControl.numberOfPages = self.imgUrls.count;
        _pageControl.pageIndicatorTintColor  =[UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}


@end



/**
  ## cycleViewcell
 */
@implementation GHCycleViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubViews];
    }
    return self;
}
-(void)setupSubViews{
     // imageView
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.backgroundColor =[UIColor whiteColor];
    [self.contentView addSubview:self.imageView];
    float labW = 30;
    float labH = 20;
    float x = self.frame.size.width -labW -10;
     // tagLable
    self.taglable = [[UILabel alloc] initWithFrame:CGRectMake(x,20, labW, labH)];
    self.taglable.font = [UIFont systemFontOfSize:18];
    self.taglable.textAlignment = NSTextAlignmentCenter;
    self.taglable.textColor = [UIColor greenColor];
    [self.contentView addSubview:self.taglable];

}
-(void)setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
}
-(void)setNumber:(NSNumber *)number{
    _number = number;
    self.taglable.text = [NSString stringWithFormat:@"%@",number];
    
}

@end
