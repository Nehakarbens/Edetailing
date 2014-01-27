


#import "UIImage+Resizing.h"

#define max(a,b) (a>b?a:b);


@implementation UIImage (Resizing)

/**
 * Creates a resized, autoreleased copy of the image, with the given dimensions.
 * @return an autoreleased, resized copy of the image
 */
- (UIImage*) resizedImageWithSize:(CGSize)inSize
{
	UIImage *newImage = nil;
	CGSize imageSize = self.size;
	if (CGSizeEqualToSize(imageSize, inSize) == NO) {
		CGFloat targetWidth = inSize.width;
		CGFloat targetHeight = inSize.height;
		
		float imageAspectRatio = imageSize.width / imageSize.height;
        
		float frameAspectRatio = targetWidth / targetHeight;
		
		if(frameAspectRatio > imageAspectRatio){
			targetWidth = round(targetHeight * imageAspectRatio);
		}
		else if(frameAspectRatio < imageAspectRatio){
			targetHeight = round(targetWidth / imageAspectRatio);
		}
        
		UIGraphicsBeginImageContext(inSize);
		
		[self drawInRect:CGRectMake(0.0f, 0.0f, targetWidth, targetHeight)];
		
		// An autoreleased image
		newImage = UIGraphicsGetImageFromCurrentImageContext();
		
		UIGraphicsEndImageContext();
	}else {
		newImage = self;
	}
	return newImage;
}

-(UIImage *)gtm_image:(UIImage* )inputImage ByResizingToSize:(CGSize)targetSize
  preserveAspectRatio:(BOOL)preserveAspectRatio
			trimToFit:(BOOL)trimToFit 
{
	
	CGSize imageSize = inputImage.size;//[self size];
	if (imageSize.height < 1 || imageSize.width < 1) {
		return nil;
	}
	if (targetSize.height < 1 || targetSize.width < 1) {
		return nil;
	}
	CGFloat aspectRatio = imageSize.width / imageSize.height;
	CGFloat targetAspectRatio = targetSize.width / targetSize.height;
	CGRect projectTo = CGRectZero;
	if (preserveAspectRatio) {
		if (trimToFit) {
			// Scale and clip image so that the aspect ratio is preserved and the
			// target size is filled.
			if (targetAspectRatio < aspectRatio) {
				// clip the x-axis.
				projectTo.size.width = targetSize.height/aspectRatio;
				projectTo.size.height = targetSize.height;
				projectTo.origin.x = (targetSize.width - projectTo.size.width) / 2;
				projectTo.origin.y = 0;
			} else {
				// clip the y-axis.
				projectTo.size.width = targetSize.width;
				projectTo.size.height = targetSize.width / aspectRatio;
				projectTo.origin.x = 0;
				projectTo.origin.y = (targetSize.height - projectTo.size.height) / 2;
			}
		} else {
			/*
			 // Scale image to ensure it fits inside the specified targetSize.
			 if (targetAspectRatio < aspectRatio) {
			 // target is less wide than the original.
			 projectTo.size.width = targetSize.width;
			 projectTo.size.height = projectTo.size.width / aspectRatio;
			 targetSize = projectTo.size;
			 } else {
			 // target is wider than the original.
			 projectTo.size.height = targetSize.height;
			 projectTo.size.width = projectTo.size.height * aspectRatio;
			 targetSize = projectTo.size;
			 }
			 
			 */
			float hfactor = inputImage.size.width / targetSize.width;
			float vfactor = inputImage.size.height / targetSize.height;
			
			////////NSLog(@"hFactor : %f   vFactor:%f",hfactor,vfactor);
			
			float factor = max(hfactor, vfactor);
			
			// Divide the size by the greater of the vertical or horizontal shrinkage factor
			float newWidth = inputImage.size.width / factor;
			float newHeight = inputImage.size.height / factor;
			////////NSLog(@"newWidth : %f   newHeight:%f",newWidth,newHeight);
			// Then figure out if you need to offset it to center vertically or horizontally
			float leftOffset = (targetSize.width - newWidth) / 2;
			float topOffset = (targetSize.height - newHeight) / 2;
			
			CGRect newRect = CGRectMake(leftOffset, topOffset, newWidth, newHeight);
			projectTo = newRect;
		} // if (clip)
	} else {
		// Don't preserve the aspect ratio.
		projectTo.size = targetSize;
	}
	
	projectTo = CGRectIntegral(projectTo);
	// There's no CGSizeIntegral, so we fake our own.
	CGRect integralRect = CGRectZero;
	integralRect.size = targetSize;
	targetSize = CGRectIntegral(integralRect).size;
	
	// Resize photo. Use UIImage drawing methods because they respect
	// UIImageOrientation as opposed to CGContextDrawImage().
	UIGraphicsBeginImageContext(targetSize);
	[inputImage drawInRect:projectTo];
	UIImage* resizedPhoto = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resizedPhoto;
}


- (CGSize)resizedImageSizeForSize:(CGSize)inSize;
{
	CGSize imageSize = self.size;
	CGSize newSize = inSize;
	if (CGSizeEqualToSize(imageSize, inSize) == NO) {
		CGFloat targetWidth = inSize.width;
		CGFloat targetHeight = inSize.height;
		
		float imageAspectRatio = imageSize.width / imageSize.height;
		
		float frameAspectRatio = targetWidth / targetHeight;
		
		if(frameAspectRatio > imageAspectRatio){
			newSize.width = targetHeight * imageAspectRatio;
		}
		else if(frameAspectRatio < imageAspectRatio){ 
			newSize.height = targetWidth / imageAspectRatio;
		}
	}
	return newSize;
}

@end