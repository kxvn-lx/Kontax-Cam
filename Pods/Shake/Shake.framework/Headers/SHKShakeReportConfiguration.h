//
// Created by Manuel Vrhovac on 25/05/2020.
// Copyright © 2020 Shake Technologies, Inc. All rights reserved.
//

/// Used to configure an individual report before submitting it, ex. leave out some data or display a toast on success
NS_SWIFT_NAME(ShakeReportConfiguration)
@interface SHKShakeReportConfiguration : NSObject

@property (nonatomic, assign) BOOL includesBlackBoxData;
@property (nonatomic, assign) BOOL includesActivityHistoryData;
@property (nonatomic, assign) BOOL includesScreenshotImage;
@property (nonatomic, assign) BOOL showsToastMessageOnSend;

/// Configures a report with all the data included
-(nonnull instancetype)init;

/// Configures a report with BlackBox and Activity History included
-(nonnull instancetype)initWithIncludesScreenshotImage:(BOOL)includesScreenshotImage
                               showsToastMessageOnSend:(BOOL)showsToastMessageOnSend;

/// Configures a report with only specific data included
-(nonnull instancetype)initWithIncludesBlackBoxData:(BOOL)includesBlackBoxData
                        includesActivityHistoryData:(BOOL)includesActivityHistoryData
                            includesScreenshotImage:(BOOL)includesScreenshotImage
                            showsToastMessageOnSend:(BOOL)showsToastMessageOnSend;

@end
