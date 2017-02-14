//
//  smallCell.h
//  liangqing
//
//  Created by Macbook 13.3 on 2017/2/8.
//  Copyright © 2017年 方正泉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface smallCell : UITableViewCell
+(instancetype)cellWithIndexPath:(NSIndexPath *)indexpath Dic:(NSDictionary *)param UITableView:(UITableView *)tableView returnblock:(void(^)(CGFloat))returnblock andbtnBlock:(void(^)(NSDictionary *))myblock;
@end
