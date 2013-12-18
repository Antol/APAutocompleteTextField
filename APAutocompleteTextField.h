//
//  APAutocompleteTextField.h
//  APAutocompleteTextField
//
//  Created by Antol Peshkov on 13.12.13.
//  Copyright (c) 2013 brainSTrainer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APAutocompleteTextField;

@protocol APAutocompleteTextFieldDelegate <UITextFieldDelegate>
- (NSString *)autocompleteTextField:(APAutocompleteTextField *)textField complitedStringForOriginString:(NSString *)originString;
@end

#pragma mark -

@interface APAutocompleteTextField : UITextField

@property(nonatomic,assign) id<APAutocompleteTextFieldDelegate> delegate;

@property (nonatomic, readonly) BOOL autocomplited;
@property (nonatomic, strong) UIColor *selectionColor;

- (void)applyCompletion;
- (void)removeCompletion;

@end
