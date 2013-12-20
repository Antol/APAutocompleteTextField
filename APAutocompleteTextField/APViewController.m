//
//  APViewController.m
//  APAutocompleteTextField
//
//  Created by Antol Peshkov on 13.12.13.
//  Copyright (c) 2013 brainSTrainer. All rights reserved.
//

#import "APViewController.h"
#import "APAutocompleteTextField.h"

@interface APViewController () <APAutocompleteTextFieldDelegate>
@end

@implementation APViewController {
    APAutocompleteTextField *_textField;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat centerX = self.view.bounds.size.width/2.f;
    CGFloat centerY = self.view.bounds.size.height/2.f;
    
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectZero];
    info.text = @"Input \'Soft Kitty\'";
    [info sizeToFit];
    info.center = CGPointMake(centerX, centerY/3.f);
    [self.view addSubview:info];
    
	_textField = [[APAutocompleteTextField alloc] initWithFrame:CGRectMake(0.f, 0.f, 310.f, 40.f)];
    _textField.delegate = self;
    [_textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    _textField.center = CGPointMake(centerX, centerY/2.f);
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_textField];
    
    UIButton *buttonChangeAllText = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 150.f, 40.f)];
    buttonChangeAllText.center = CGPointMake(centerX, centerY);
    buttonChangeAllText.backgroundColor = [UIColor lightGrayColor];
    [buttonChangeAllText setTitle:@"Change all" forState:UIControlStateNormal];
    [buttonChangeAllText addTarget:self action:@selector(touchUpInsideButtonChangeAllText:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonChangeAllText];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"=> return pressed");
    return YES;
}

- (void)textFieldEditingChanged:(UITextField *)textField
{
    NSLog(@"=> entered text: %@", textField.text);
}

- (void)touchUpInsideButtonChangeAllText:(UIButton *)button
{
    _textField.text = @"triam";
}

- (NSString *)autocompleteTextField:(APAutocompleteTextField *)textField complitedStringForOriginString:(NSString *)originString
{
    NSString *complitedString = @"Soft Kitty, Warm Kitty, little ball of fur";
    NSRange originStringRange = [complitedString rangeOfString:originString];
    
    if (originStringRange.location != 0) {
        complitedString = nil;
    }
    
    return complitedString;
}

@end
