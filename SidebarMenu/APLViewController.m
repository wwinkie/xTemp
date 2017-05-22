/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 Main view controller for the application.
 */

#import "APLViewController.h"
#import "SWRevealViewController.h"

@interface APLViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>



@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *memberButton;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *photoLibrary;
@property (nonatomic, weak) NSString *nosOverlay;

@end


#pragma mark -

@implementation APLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.memberButton setTarget: self.revealViewController];
        [self.memberButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
   
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
 }
- (IBAction)showPhotoLibrary:(id)sender {
    NSLog(@"press Photo");
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
        
}
- (IBAction)takePhoto:(id)sender {
    NSLog(@"press Camera");
       UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    picker.cameraOverlayView = [self setSettingsOverlay];
    [picker.cameraOverlayView setHidden:false];
   [self presentViewController:picker animated:YES completion:NULL];
}


- (void)drawRect:(CGRect)rect {
   }
-(UIView *)setSettingsOverlay
{
   UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 380)];
  
   [view setBackgroundColor:[UIColor clearColor]];
//   self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"overlayL1"]];
    
    
    
   
   // UIImageView *FrameImg = [[UIImageView alloc] initWithFrame:CGRectMake(280,40,720,520)];
  //  [FrameImg setImage:[UIImage imageNamed:@"images.png"]];
    UIImageView *FrameImg2 = [[UIImageView alloc] initWithFrame:CGRectMake(5,140,600,280)];
    [FrameImg2 setImage:[UIImage imageNamed:@"overlayL1.png"]];
  //  UIImageView *FrameImg3 = [[UIImageView alloc] initWithFrame:CGRectMake(280,560,720,200)];
  //  [FrameImg3 setImage:[UIImage imageNamed:@"images.png"]];
    UILabel *scanningLabel = [[UILabel alloc] initWithFrame:CGRectMake(360, 60, 280, 32)];
    scanningLabel.backgroundColor = [UIColor clearColor];
    scanningLabel.font = [UIFont fontWithName:@"Courier" size: 32.0];
    scanningLabel.textColor = [UIColor greenColor];
    scanningLabel.text = @"Invoice";
  //  [view addSubview:scanningLabel];
    scanningLabel = [[UILabel alloc] initWithFrame:CGRectMake(280, 60, 280, 32)];
    scanningLabel.backgroundColor = [UIColor clearColor];
    scanningLabel.font = [UIFont fontWithName:@"Courier" size: 32.0];
    scanningLabel.textColor = [UIColor redColor];
    scanningLabel.text = @"VISA";
  //  [view addSubview:scanningLabel];
    scanningLabel = [[UILabel alloc] initWithFrame:CGRectMake(320, 580, 280, 32)];
    scanningLabel.backgroundColor = [UIColor clearColor];
    scanningLabel.font = [UIFont fontWithName:@"Courier" size: 32.0];
    scanningLabel.textColor = [UIColor yellowColor];
    scanningLabel.text = @"Price Tag";
    
   [view addSubview:FrameImg2];
 //   [view addSubview:FrameImg3];
 //   [view addSubview:scanningLabel];
 //   [view addSubview:FrameImg];
    return  view;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"save photo");

    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    //info[UIImagePickerControllerEditedImage];
    [picker.cameraOverlayView setHidden:true];
    [self.imageView setHidden:false];
    
    self.imageView.image = chosenImage;
    UIImageWriteToSavedPhotosAlbum(chosenImage,
                                   self,
                                   @selector(image:finishedSavingWithError:contextInfo:),
                                   nil);
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
   
    
}


-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    [self uploadImage:image filename:@"uploads.jpg"   folder:@"eex-17-0023"];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void) uploadImage:(UIImage *) image filename:(NSString *) filename   folder:(NSString *) caseId
{
    //  prodNam = txtProdName.text;
    NSInteger xd;
    UIImage * img;
    img = image;
    xd = 0;
    
    NSData *imageData = UIImageJPEGRepresentation(img,0.5);     //change Image to NSData
    
    // imageData = UIImagePNGRepresentation(img);
    
  // NSData *imageData = UIImageJPEGRepresentation(yourImage,.3);        NSString * filenames = filename;
        NSString *urlString = @"http://dx2.equal10.com/lol/uploadResult.php?team=T021-234&race=eex-17-0023";
        NSLog(@"folder %@ %@", filename, caseId);
        NSLog(@"IMAGE folder %f %f", img.size.height, img.size.width);
       if (img.size.width > img.size.height){
            xd = 1;
        } else {
            xd = 0;
        }
        
    
        
        if (imageData != nil)
        {
            NSString *filenames = [NSString stringWithFormat:@"SelfieName"];      //set name here
            
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:urlString]];
            [request setHTTPMethod:@"POST"];
            
            NSString *boundary = @"---------------------------14737809831466499882746641449";
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[filenames dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            //I use a method called randomStringWithLength: to create a unique name for the file, so when all the aapps are sending files to the server, none of them will have the same name:
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@.jpg\"\r\n",caseId] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [request setHTTPBody:body];
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            NSLog(@"Response : %@",returnString);
            
            
                       /*
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            //I chose to run my code async so the app could continue doing stuff while the image was sent to the server.
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
             {
                 
                 NSData *returnData = data;
                 NSLog(@"data recieved! %@", response);
                 
                 //Do what you want with your return data.
                 
             }];
            */
        
       }
    }
@end

