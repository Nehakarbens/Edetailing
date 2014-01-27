

@interface UIImage (Resizing)

- (UIImage*) resizedImageWithSize:(CGSize)inSize;
- (CGSize)resizedImageSizeForSize:(CGSize)inSize;
-(UIImage *)gtm_image:(UIImage* )inputImage ByResizingToSize:(CGSize)targetSize
preserveAspectRatio:(BOOL)preserveAspectRatio
            trimToFit:(BOOL)trimToFit;
@end