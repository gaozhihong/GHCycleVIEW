//
//  GHCycleView.h
//  GHCycleView
//
//  Created by gaozhihong on 2018/3/29.
//  Copyright © 2018年 gaozhihong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  GHCycleViewClickDelegate <NSObject>
@optional
-(void)ghCycleViewDidClick:(id)obj;
@end
@interface GHCycleView : UIView
 /** initCycleView */
-(instancetype)initCycleView:(CGRect)frame imgUrls:(NSArray*)imgUrls;
-(void)removeTimer;
@property(nonatomic,copy)void(^cellSeclectedBlock)(void);
 /** cycleView click delegate*/ 
@property(nonatomic,weak) id <GHCycleViewClickDelegate> cycleViewDelegate;
@end


/**
  cycleVewCell
*/
@interface  GHCycleViewCell:UICollectionViewCell
 /** imageView */
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong) NSString *imgUrl;
 /** tagLabel */ 
@property(nonatomic,strong)UILabel *taglable;
@property(nonatomic,strong)NSNumber *number;
@end
