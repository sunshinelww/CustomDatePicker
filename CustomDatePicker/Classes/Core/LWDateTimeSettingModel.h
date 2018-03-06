//
//  DateTimeSettingModel.h
//  CustomDatePicker
//
//  Created by sunshinelww on 2018/3/5.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LWDatePickerDateFormatType) {
    LWDatePickerDateFormatTypeYY,    // 2017
    LWDatePickerDateFormatTypeYM,    // 2017-01
    LWDatePickerDateFormatTypeYMD,   // 2017-01-01
    LWDatePickerDateFormatTypeYMDHM, // 2017-01-01 12:00
    LWDatePickerDateFormatTypeMDHM,  // 01-01 12:00
};

/**
 * 日期控件设置模型
 **/
@interface LWDateTimeSettingModel : NSObject

@property (nonatomic, assign) LWDatePickerDateFormatType dateType;
@property (nonatomic, strong) NSDate *startDate; //最早时间
@property (nonatomic, strong) NSDate *endDate; //最晚时间
@property (nonatomic, strong) NSDate *defaultDate; //默认选中时间

@property (nonatomic, assign) NSInteger interval; //时间粒度，只针对时间
@property (nonatomic, strong) NSNumber *timeAllowedEarlist; //每天限制的最早时间
@property (nonatomic, strong) NSNumber *timeAllowedLatest; //每天限制的最晚时间

@end
