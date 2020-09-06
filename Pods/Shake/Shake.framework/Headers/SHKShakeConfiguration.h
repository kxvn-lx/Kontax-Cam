//
// Created by Manuel Vrhovac on 23/05/2020.
// Copyright © 2020 Shake Technologies, Inc. All rights reserved.
//

/// Used to enable or disable specific features or invocation methods
NS_SWIFT_NAME(ShakeConfiguration)
@interface SHKShakeConfiguration : NSObject

/// Creates and displays a UI button that invokes Shake on tap. Button floats above all elements.
@property (nonatomic) BOOL isFloatingReportButtonShown;

/// Shake will be automatically invoked when user shakes their device
@property (nonatomic) BOOL isInvokedByShakeDeviceEvent;

/// Shake will be automatically invoked when user takes a screenshot
@property (nonatomic) BOOL isInvokedByScreenshot;

/// Shake will record certain events on device like CPU, RAM, Orientation to help you easily spot correlations
@property (nonatomic) BOOL isBlackBoxEnabled;

/// Shake will record certain events on device like User tap events, network events, view controllers and app state changes.
@property (nonatomic) BOOL isActivityHistoryEnabled;

/// There will be a button on Shake report window leading to the "Inspect Report" screen
@property (nonatomic, assign) BOOL isInspectScreenEnabled;

- (instancetype)init
__attribute__((unavailable("Access 'Shake.configuration' directly instead.")));

@end
