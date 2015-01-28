//
//  PDFViewControler.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 31/05/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "PDFViewControler.h"


#define kFII_LogPaths NO
#define kFII_SEC_BackgroundImage    @"SEC.gif"
//DIN A-4: 612x792 px = 215.9mmx279.4mm.   792x612 px: apaisado
#define ECGPageSize           CGSizeMake(792, 612)//CGSizeMake(842, 595)


//CGRectMake(x,y,w,h),'x'creen a la derecha, 'y' crecen hacia abajo
#define ECGPageBounds         CGRectMake(0, 0, 792, 612)//CGRectMake(0, 0, 842, 595)

#define kFII_SEC_HorizonatlInset    30.0f
#define kFII_SEC_VerticalOffset     30.0f
#define kFII_SEC_SmallFont          [UIFont systemFontOfSize:6.0f]
#define kFII_SEC_NormalFont         [UIFont systemFontOfSize:8.0f]
#define kFII_SEC_BoldFont           [UIFont boldSystemFontOfSize:10.0f]
#define kFII_SEC_SmallFontHeight    8.0f
#define kFII_SEC_NormalFontHeight   10.0f
#define kFII_SEC_BoldFontHeight     12.0f
#define kFII_SEC_CheckmarkSize      11.0f


#define kNombrePDFGenerado          @"ECG.pdf"
#define kSTEPPING                   3 //incremento entre linea y linea del grid
#define kAnchoLinea1Grid            0.8
#define kAnchoLinea2Grid            0.1

#define kStudentName                @"Alexis Herrera"
#define gridFont                    [UIFont systemFontOfSize:12.0]
#define gridFontColor               [UIColor blackColor].CGColor

#define kAnchoGrid                  751
#define kAltoGrid                   106
#define kPosXGrid1                  20
#define kPosYGrid1                  70
#define kPosYGrid1Recorded          40
#define kSeparacionGrid             140
#define kSeparacionGridRecorded     120
#define kDeltaPosECG                540
#define kDeltaPosECGGrabado         540

#define kAnchoLineaECG              1
#define kColorLineaECG              [UIColor blackColor].CGColor
#define kDeltaXlineaECG             1.155
//Numero de ptos que caben en un trozo de ECG de 10 segundos
#define kPtosLineaECGaDibujar       648
#define klineasPorPagina            4


@interface PDFViewControler (){
  //Numero de puntos del electro a representar en cada tira
  int numeroPtosECG;
}
@end



@implementation PDFViewControler

@synthesize dataModel=_dataModel;
@synthesize tipoPDF=_tipoPDF;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [self generarPdfconNombre:kNombrePDFGenerado];
    [self showPDFFile:kNombrePDFGenerado];
    [super viewDidLoad];
}


- (void) generarPdfconNombre:(NSString*)nombreArchivo{
    NSString* fileName = nombreArchivo;
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    // Create the PDF context using the default page size of 612 x 792.
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(ECGPageBounds ,nil); //(CGRectMake(0, 0, 612, 792), nil);
    
    // Get the graphics context.
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    CGContextSetTextMatrix(currentContext, CGAffineTransformIdentity);

    //Ahora puedo empezar a dibujar:
    //-------------------------------------------------
    //Dibujamos el pdf para screening
    if ([self.tipoPDF isEqualToString:@"Screening"] ){
        [self imprimeConfECGinContext:currentContext];
        [self dibujaGridScreeningInContext:currentContext];
        [self dibujaSenialesScreeningInContext:currentContext];
    
    //Dibjujamos el pdf con la señal capturada
    } else if ([self.tipoPDF isEqualToString:@"recordedECG"] ){
        if(self.dataModel.senialCapturada.count>0)
            [self dibujaGridECGgrabadoInContext:currentContext];
            [self dibujaSenialGrabadaInContext:currentContext];
    }
    //---------------------------------------------------
    
    // Close the PDF context and write the contents out.
    UIGraphicsEndPDFContext();
}


// PROVISIONAL: Asumo 25mm/s y 10mm/mV
- (void) imprimeConfECGinContext:(CGContextRef)currentContext{
    NSString* titulo = @"ECG speed: 25mm/s,    ECG gain: 10mm/mV ";
    [self pdfDrawText:titulo
               inRect:CGRectMake(20, 530, 300, 50)
             withFont:gridFont
                color:gridFontColor];
}

- (void) dibujaGridScreeningInContext:(CGContextRef)currentContext{
    [self dibujarCuadriculaTitulada:@"Lead I - Alternate"
                             EnPosx:kPosXGrid1
                              yPosY:kPosYGrid1
                             deAlto:kAltoGrid
                            deAncho:kAnchoGrid
                     empiezaSegundo:0];
    
    [self dibujarCuadriculaTitulada:@"Lead II - Secundary"
                             EnPosx:kPosXGrid1
                              yPosY:kPosYGrid1+kSeparacionGrid
                             deAlto:kAltoGrid
                            deAncho:kAnchoGrid
                     empiezaSegundo:0];
    
    [self dibujarCuadriculaTitulada:@"Lead III - Primary"
                             EnPosx:kPosXGrid1
                              yPosY:kPosYGrid1+kSeparacionGrid*2
                             deAlto:kAltoGrid
                            deAncho:kAnchoGrid
                     empiezaSegundo:0];
}
- (void) dibujaSenialesScreeningInContext:(CGContextRef)currentContext{
    //Dibujo ECG. Ojo! Las coordenadas Y estan invertidas
    //Desplaza el eje de coordenadas x,y al pie de la página
    CGContextTranslateCTM(currentContext, 0, 612);
    //Invierto/escalo el eje y (-1.0)
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    
    [self dibujarElectro:@"Lead I" posX:kPosXGrid1 posY:kDeltaPosECG-kPosYGrid1];
    [self dibujarElectro:@"Lead II" posX:kPosXGrid1 posY:kDeltaPosECG-kPosYGrid1-kSeparacionGrid];
    [self dibujarElectro:@"Lead III" posX:kPosXGrid1 posY:kDeltaPosECG-kPosYGrid1-kSeparacionGrid*2];
}
- (void)dibujarElectro:(NSString *)titulo posX:(int)posX posY:(int)posY{
    float xMuestra =posX;
    int ptosDibujados=0;
    int i=0;
    

    
    while (ptosDibujados<=kPtosLineaECGaDibujar){
        float muestra1 =[[self.dataModel.senialMutable objectAtIndex:i] floatValue];
        float muestra2 =[[self.dataModel.senialMutable objectAtIndex:i+1] floatValue];
        NSNumber *point1;
        NSNumber *point2;
        
        if ([titulo isEqualToString:@"Lead I"]){
            point1 = [NSNumber numberWithFloat: [self.dataModel dameMuestra:muestra1 enVector:2]];
            point2 = [NSNumber numberWithFloat: [self.dataModel dameMuestra:muestra2 enVector:2]];
        }else if([titulo isEqualToString:@"Lead II"]){
            point1 = [NSNumber numberWithFloat: [self.dataModel dameMuestra:muestra1 enVector:1]];
            point2 = [NSNumber numberWithFloat: [self.dataModel dameMuestra:muestra2 enVector:1]];
        }else if([titulo isEqualToString:@"Lead III"]){
            point1 = [NSNumber numberWithFloat: [self.dataModel dameMuestra:muestra1 enVector:0]];
            point2 = [NSNumber numberWithFloat: [self.dataModel dameMuestra:muestra2 enVector:0]];
        }
        muestra1 = [point1 floatValue];
        muestra2 = [point2 floatValue];
        
        
        //Mapeo el rango de valores de la señal
        //return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
        muestra1=(muestra1-600)*(40-0)/(2500-600)+0;
        muestra2=(muestra2-600)*(40-0)/(2500-600)+0;
        
        
        [self pdfDrawLinefromPoint:CGPointMake(xMuestra, posY+muestra1)
                           toPoint:CGPointMake(xMuestra+kDeltaXlineaECG,posY+ muestra2)
                         withWidth:kAnchoLineaECG
                             color:kColorLineaECG];
        
        xMuestra=xMuestra+kDeltaXlineaECG;
        ptosDibujados++;
        i++;
        if (i==self.dataModel.senialMutable.count-1){
            i=0;
        }
    }
}

//Dibuja cabecero con Nombre del estudiante, fecha y hora
- (void)dibujaEncabezado{
    //Fecha y nombre de estuiante
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd/MMM/yyyy, HH:mm"];
    NSDate *now = [[NSDate alloc] init];
    NSString *dateString = [format stringFromDate:now];
    //Dibujo el título del gráfico
    //CGRect CGRectMake (CGFloat x,CGFloat y,CGFloat width,CGFloat height);
    [self pdfDrawText:@"ECG recorded by: "  inRect:CGRectMake(15, 10, 200, 40) withFont:gridFont color:gridFontColor];
    [self pdfDrawText:kStudentName  inRect:CGRectMake(140, 10, 200, 40) withFont:gridFont color:gridFontColor];
    [self pdfDrawText:dateString    inRect:CGRectMake(650, 10, 200, 40) withFont:gridFont color:gridFontColor];
}
- (void) dibujaGridECGgrabadoInContext:(CGContextRef)currentContext{
    
    [self dibujaEncabezado];
    
    [self dibujarCuadriculaTitulada:@""
                             EnPosx:kPosXGrid1
                              yPosY:kPosYGrid1Recorded
                             deAlto:kAltoGrid
                            deAncho:kAnchoGrid
                     empiezaSegundo:0];
    
    [self dibujarCuadriculaTitulada:@""
                             EnPosx:kPosXGrid1
                              yPosY:kPosYGrid1Recorded+kSeparacionGridRecorded
                             deAlto:kAltoGrid
                            deAncho:kAnchoGrid
                     empiezaSegundo:10];
    
    [self dibujarCuadriculaTitulada:@""
                             EnPosx:kPosXGrid1
                              yPosY:kPosYGrid1Recorded+kSeparacionGridRecorded*2
                             deAlto:kAltoGrid
                            deAncho:kAnchoGrid
                     empiezaSegundo:20];
    
    [self dibujarCuadriculaTitulada:@""
                             EnPosx:kPosXGrid1
                              yPosY:kPosYGrid1Recorded+kSeparacionGridRecorded*3
                             deAlto:kAltoGrid
                            deAncho:kAnchoGrid
                     empiezaSegundo:30];
}
- (void) dibujaSenialGrabadaInContext:(CGContextRef)currentContext{
    //Desplaza el eje de coordenadas x,y al pie de la página
    CGContextTranslateCTM(currentContext, 0, 612);
    //Invierto/escalo el eje y (-1.0)
    CGContextScaleCTM(currentContext, 1.0, -1.0);
    [self dibujarECGGrabado:@"ECGGrabado" posX:kPosXGrid1 posY:kDeltaPosECG-kPosYGrid1Recorded enContexto:currentContext];
}
- (void)dibujarECGGrabado:(NSString *)titulo posX:(int)posX posY:(int)posY enContexto:(CGContextRef)currentContext{
    float xMuestra =posX;
    float yMuestra = posY;
    int ptosDibujados=0;
    int i=0;
    int nLinea=1;
    
    while (i<self.dataModel.senialCapturada.count-1){
        float muestra1 =[[self.dataModel.senialCapturada objectAtIndex:i] floatValue];
        float muestra2 =[[self.dataModel.senialCapturada objectAtIndex:i+1] floatValue];
        
        //Mapeo el rango de valores de la señal
        //return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
        muestra1=(muestra1-600)*(30-0)/(2500-600)+0;
        muestra2=(muestra2-600)*(30-0)/(2500-600)+0;
        
        
        [self pdfDrawLinefromPoint:CGPointMake(xMuestra, yMuestra+muestra1)
                           toPoint:CGPointMake(xMuestra+kDeltaXlineaECG,yMuestra+ muestra2)
                         withWidth:kAnchoLineaECG
                             color:kColorLineaECG];
        
        xMuestra=xMuestra+kDeltaXlineaECG;
        ptosDibujados++;
        i++;
        
        //Si llego al final de la 'linea' muevo posX al ppio
        if (ptosDibujados==kPtosLineaECGaDibujar){
            //Retorno de carro, vuelvo a 'x' inicial
            xMuestra =posX;
            //Avanzo línea, incremento posY
            yMuestra = kDeltaPosECGGrabado-kPosYGrid1Recorded-kSeparacionGridRecorded*nLinea;
            nLinea++;
            ptosDibujados=0;
            //se he llegado al max lineas de ECG por página, creo una nueva
            if (nLinea>klineasPorPagina){
                //Creo pagina nueva
                [self pdfNewPageWithBounds:ECGPageBounds];
                [self dibujaGridECGgrabadoInContext:currentContext];
                CGContextTranslateCTM(currentContext, 0, 612);
                //Invierto/escalo el eje y (-1.0)
                CGContextScaleCTM(currentContext, 1.0, -1.0);
                
                //Reseteo la línea. Vuelvo a empezar en linea1
                nLinea =1;
                //reseteo la posicion de la 'y'
                yMuestra=posY;
            }
        }
    }
}


- (void) dibujarCuadriculaTitulada:(NSString*)titulo EnPosx: (int)posX yPosY:(int)posY deAlto:(int)alto deAncho:(int)ancho empiezaSegundo:(int)segundoInicial{
    // Drawing constants
    CGColorRef primaryGridColor   = [UIColor redColor].CGColor;
    CGColorRef secondaryGridColor = [UIColor redColor].CGColor;
    
    int lineaNx = 0;
    int lineaNy = 0;
    
    //Dibujo el título del gráfico
    //CGRect CGRectMake (CGFloat x,CGFloat y,CGFloat width,CGFloat height);
    [self pdfDrawText:titulo
               inRect:CGRectMake(posX, posY-17, 150, 40)
             withFont:gridFont
                color:gridFontColor];
    
    // Draw the grid
    
    //Lineas verticales
    for (int x=posX; x<(posX+ancho); x=x+kSTEPPING)
    {
        //Dibjujo linea secundaria (gruesa) cada 5 lineas finas
        if (remainder(lineaNx,5) == 0) //reminder: calcula el resto de la division lineaNx/5
        {
            [self pdfDrawLinefromPoint:CGPointMake(x, posY)
                               toPoint:CGPointMake(x, (posY+alto))
                             withWidth:kAnchoLinea1Grid
                                 color:secondaryGridColor];
            /* 
            // ***TEST
            [self pdfDrawText:[NSString stringWithFormat:@"%d", x]
                       inRect:CGRectMake(x, 0, 40, 40)
                     withFont:gridFont
                        color:gridFontColor];
             */
            //Cada 25 lineas finas (1 segundo). Pongo etiqueta (numero de segundos)
            if (remainder(lineaNx,25) == 0){
                [self pdfDrawText:[@(lineaNx/25+segundoInicial) stringValue]
                           inRect:CGRectMake(x, posY+alto, 150, 40)
                         withFont:gridFont
                            color:primaryGridColor];
            }
        }
        else
        {
            [self pdfDrawLinefromPoint:CGPointMake(x, posY)
                               toPoint:CGPointMake(x, (posY+alto))
                             withWidth:kAnchoLinea2Grid
                                 color:primaryGridColor];
        }
        lineaNx++;
    }
    
    //Lineas horizontales
    for (int y=posY; y<(posY+alto); y=y+kSTEPPING)
    {
        if (remainder(lineaNy,5) == 0)
        {
            [self pdfDrawLinefromPoint:CGPointMake(posX, y)
                               toPoint:CGPointMake((posX+ancho), y)
                             withWidth:kAnchoLinea1Grid
                                 color:secondaryGridColor];
            /*
            // ***TEST
            [self pdfDrawText:[NSString stringWithFormat:@"%d", y]
                       inRect:CGRectMake(0, y, 40, 40)
                     withFont:gridFont
                        color:gridFontColor];
             */
        }
        else
        {
            
            [self pdfDrawLinefromPoint:CGPointMake(posX, y)
                               toPoint:CGPointMake((posX+ancho), y)
                             withWidth:kAnchoLinea2Grid
                                 color:primaryGridColor];
        }
        lineaNy++;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
// Return the full path for a file taking into account if it's read only (saveFlag=NO, the path
// point to the app bundle) or read-write (saveFlag=YES, the path points to the Documents Directory).
- (NSString *)pathForFile:(NSString*)file withExtension:(NSString*)extension isForSave:(BOOL)saveFlag
{
    // Get the app's Document Directory
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Create the path to the file
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", file, extension];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    // If we want to save or the file already exists, return the path.
    // Otherwise, return the file in the app's bundle.
    if (saveFlag || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath])
    {
        if (kFII_LogPaths)
        {
            //NSArray *pathComponents = [documentsPath pathComponents];
            
        }
        return documentsPath;
    }
    else
    {
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:file ofType:extension];
        if (kFII_LogPaths)
        {
          //  NSArray *pathComponents = [documentsPath pathComponents];
        }
        return bundlePath;
    }
}

- (void)pdfNewFormwithBounds:(CGRect)bounds inPath:(NSString *)path
{
    NSMutableDictionary *documentInfo = [[NSMutableDictionary alloc] init];
    [documentInfo setValue:@"Screening" forKey:(NSString*)kCGPDFContextCreator];
    [documentInfo setValue:@"Screening de prueba" forKey:(NSString*)kCGPDFContextTitle];
    [documentInfo setValue:@"Esto es un screening" forKey:(NSString*)kCGPDFContextSubject];
    UIGraphicsBeginPDFContextToFile(path, bounds, documentInfo);
}

// Adds a new page to the current PDF with custom bounds.
- (void)pdfNewPageWithBounds:(CGRect)bounds
{
    UIGraphicsBeginPDFPageWithInfo(bounds, nil);
}


// Draws text in the current PDF page within a custom rectangle with custom font and color.
- (void)pdfDrawText:(NSString*)text inRect:(CGRect)rect
           withFont:(UIFont*)font color:(CGColorRef)color
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(currentContext, color);

    [text drawInRect:rect withFont:font lineBreakMode:UILineBreakModeWordWrap
           alignment:UITextAlignmentLeft];
    

}

// Draws a line in the current PDF page
- (void)pdfDrawLinefromPoint:(CGPoint)from toPoint:(CGPoint)to
                   withWidth:(CGFloat)width color:(CGColorRef)color
{
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, width);
    CGContextSetStrokeColorWithColor(currentContext, color);
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, from.x, from.y);
    CGContextAddLineToPoint(currentContext, to.x, to.y);
    CGContextClosePath(currentContext);
    CGContextDrawPath(currentContext, kCGPathFillStroke);
}




// Draws a grid of horizontal and vertical lines in the current PDF page with custom stepping.
- (void)pdfDrawGridWithPageSize:(CGSize)pageSize stepping:(int)stepping
{
    // Drawing constants
    float primaryGridWidth        = 0.1;
    float secondaryGridWidth      = 0.5;
    //UIFont     *gridFont          = [UIFont systemFontOfSize:12.0];
    //CGColorRef gridFontColor      = [UIColor blackColor].CGColor;
    CGColorRef primaryGridColor   = [UIColor redColor].CGColor;
    //CGColorRef secondaryGridColor = [UIColor blueColor].CGColor;
    CGColorRef secondaryGridColor = [UIColor redColor].CGColor;

    
    //Dibjujo linea secundaria (gruesa) cada x lineas finas
    int lineaSecCada = 5;
    
    // Draw the grid
    for (int x=0; x<pageSize.width; x=x+stepping)
    {
        if (remainder(x, stepping*lineaSecCada) == 0) //reminder: calcula el resto de la division x/100
        {
            [self pdfDrawLinefromPoint:CGPointMake(x, 0)
                               toPoint:CGPointMake(x, pageSize.height)
                             withWidth:secondaryGridWidth
                                 color:secondaryGridColor];
            
            [self pdfDrawText:[NSString stringWithFormat:@"%d", x]
                       inRect:CGRectMake(x, 0, 40, 40)
                     withFont:gridFont
                        color:gridFontColor];
        }
        else
        {
            [self pdfDrawLinefromPoint:CGPointMake(x, 0)
                               toPoint:CGPointMake(x, pageSize.height)
                             withWidth:primaryGridWidth
                                 color:primaryGridColor];
        }
    }
    for (int y=0; y<pageSize.height; y=y+stepping)
    {
        if (remainder(y, stepping*lineaSecCada) == 0)
        {
            [self pdfDrawLinefromPoint:CGPointMake(0, y)
                               toPoint:CGPointMake(pageSize.width, y)
                             withWidth:secondaryGridWidth
                                 color:secondaryGridColor];
            
            [self pdfDrawText:[NSString stringWithFormat:@"%d", y]
                       inRect:CGRectMake(0, y, 40, 40)
                     withFont:gridFont
                        color:gridFontColor];
        }
        else
        {
            
            [self pdfDrawLinefromPoint:CGPointMake(0, y)
                               toPoint:CGPointMake(pageSize.width, y)
                             withWidth:primaryGridWidth
                                 color:primaryGridColor];
        }
    }
    
}


- (void) tryPrintPdf:(NSString*)path1
{
    //NSString* fileName = @"Invoice.PDF";
    NSString* fileName = path1;

    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    NSData *myData = [NSData dataWithContentsOfFile:pdfFileName];
    
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    
    if ( pic && [UIPrintInteractionController canPrintData: myData] ) {
        pic.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = [path lastPathComponent];
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        pic.printingItem = myData;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            }
        };
        
        [pic presentAnimated:YES completionHandler:completionHandler];
    }
}


-(void)showPDFFile: (NSString*)nombreArchivo
{
    NSString* fileName = nombreArchivo;
    
    NSArray *arrayPaths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory,
                                        NSUserDomainMask,
                                        YES);
    NSString *path = [arrayPaths objectAtIndex:0];
    NSString* pdfFileName = [path stringByAppendingPathComponent:fileName];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, 1024, 768)];
    
    NSURL *url = [NSURL fileURLWithPath:pdfFileName];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    [webView setScalesPageToFit:YES];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

- (IBAction)buttonBarPrintPressed:(id)sender {
    [self tryPrintPdf:kNombrePDFGenerado];
}

- (IBAction)imprimirPushed:(id)sender {
    [self tryPrintPdf:kNombrePDFGenerado];
}


- (IBAction)backPushed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
