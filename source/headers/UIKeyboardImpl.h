@interface UIKeyboardImpl : UIView {
}
+(UIKeyboardImpl*)sharedInstance;
+(UIKeyboardImpl*)activeInstance;

-(id)delegate;
-(void)handleDelete;
-(void)handleStringInput:(id)input fromVariantKey:(BOOL)variantKey;
-(BOOL)isShifted;
-(void)addInputString:(id)arg1;

@end
