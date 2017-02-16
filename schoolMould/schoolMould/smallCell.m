//
//  smallCell.m
//  liangqing
//
//  Created by Macbook 13.3 on 2017/2/8.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import "smallCell.h"
#import "configHead.h"
#import "Hbutton.h"

#import "UIButton+WebCache.h"
#import "UIImage+MultiFormat.h"

typedef void(^myblock)(NSDictionary *);

@interface smallCell ()
@property (nonatomic,copy)myblock block;
@property (nonatomic,strong)NSDictionary *params;
@end

@implementation smallCell

+(instancetype)cellWithIndexPath:(NSIndexPath *)indexpath Dic:(NSDictionary *)param UITableView:(UITableView *)tableView returnblock:(void(^)(CGFloat))returnblock andbtnBlock:(void(^)(NSDictionary *))myblock{
    
    NSString *const str = @"smallCell";
    smallCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    cell.block = myblock;
    if (!cell) {
        cell = [[smallCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    [cell resetView];
    returnblock([cell creatViewWithParams:param]);
    return cell;
}


- (void)resetView{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
    
}
- (CGFloat)fontsize{
    CGFloat a;
    if (isiPhone6or6s) {
        return 14;
    }
    if (isiPhone5or5sor5c) {
        return 13;
    }
    if (isiPhone6plusor6splus) {
        return 15;
    }
    
    return a;
}
- (CGFloat)itemHeight:(NSInteger)num{
    
    CGFloat height;
    if (num<=3) {
        height = SCREENWIDTH/3;
    }else if(num<=4){
        
        height = SCREENWIDTH/4;
    }else{
        height = SCREENWIDTH/4;
    }
    return height;
}
- (NSInteger)LineNum:(NSInteger)a{

    if (a<4) {
        return a;
    }else
        return 4;
}
- (NSInteger)lastNum:(NSInteger)a{
    
    NSInteger last = a%4;

    if (last==0&&a!=0){
        last = 4;
    }
    return last;
}

- (CGFloat)creatViewWithParams:(NSDictionary *)param{
    
    
    NSArray *arr   = param[@"list"];
    
    
    CGFloat length = [self itemHeight:arr.count];
    NSInteger last = [self lastNum:arr.count];
    NSInteger lnum = [self LineNum:arr.count];
    NSInteger hnum = arr.count/5+1;
    CGFloat topmargin;
    if ((![param[@"title"]isEqualToString:@""])&&param[@"title"]){
        topmargin = 35;
    }else
        topmargin = 0;
    for (int i = 0; i<hnum; i++) {
        for (int j = 0; j<lnum; j++) {
            if ((i ==hnum-1)&&j>=last) {
                continue;
            }
            
            
            Hbutton *btn = [Hbutton buttonWithType:UIButtonTypeCustom];
            btn.frame    = CGRectMake(j*length, i*length+topmargin, length, length);
            [btn sd_setImageWithURL:[NSURL URLWithString:arr[i*4+j][@"icon"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"loading"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                UIImage *scaleimg = [self scaleToSize:image size:CGSizeMake(40, 40)];
                [btn setImage:scaleimg forState:UIControlStateNormal];
            }];
            /*
            UIImage *image = [UIImage sd_imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:arr[i*4+j][@"icon"]]]];
            UIImage *scaleimg = [self scaleToSize:image size:CGSizeMake(50, 50)];
            
            [btn setImage:scaleimg forState:UIControlStateNormal];
             */
            btn.params = arr[i*4+j];
            [btn setTitle:arr[i*4+j][@"name"] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:[self fontsize]];
            [btn addTarget:self action:@selector(ClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
            
        }
    }
    
    if ((![param[@"title"]isEqualToString:@""])&&param[@"title"]) {
        UILabel *baseLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, length+40, 30)];
        baseLable.font     = [UIFont systemFontOfSize:[self fontsize]+2];
        baseLable.textColor= [UIColor blackColor];
        baseLable.text     = param[@"title"];
        
        UIView *lineView   = [[UIView alloc] initWithFrame:CGRectMake(10, 35, SCREENWIDTH-20, 1)];
        lineView.backgroundColor = UIColorFromRGB(0x0f2f3f5);
        [self.contentView addSubview:lineView];
        
        [self.contentView addSubview:baseLable];
        return length*hnum+35;
    }else
        return length*hnum;
    
    
    
    

}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
- (void)ClickAction:(Hbutton *)btn{

    _block?_block(btn.params):nil;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
