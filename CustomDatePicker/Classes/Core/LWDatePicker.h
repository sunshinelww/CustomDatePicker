//
//  LWDatePicker.h
//  CustomDatePicker
//
//  Created by sunshinelww on 2018/3/5.
//

#import <UIKit/UIKit.h>
#import "LWDateTimeSettingModel.h"

@interface LWDatePicker : UIView

- (instancetype)initWithDateSettingModel:(LWDateTimeSettingModel *)settingModel;

- (CGFloat)viewHeight;

@end
