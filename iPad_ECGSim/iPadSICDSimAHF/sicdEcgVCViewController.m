//
//  sicdEcgVCViewController.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 28/05/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "sicdEcgVCViewController.h"
#import "PDFViewControler.h"

#define kFII_LogPaths NO
#define kFII_SEC_BackgroundImage    @"SEC.gif"
#define kFII_SEC_PageSize           CGSizeMake(595, 842)
#define kFII_SEC_PageBounds         CGRectMake(0, 0, 595, 842)
#define kFII_SEC_HorizonatlInset    30.0f
#define kFII_SEC_VerticalOffset     30.0f
#define kFII_SEC_SmallFont          [UIFont systemFontOfSize:6.0f]
#define kFII_SEC_NormalFont         [UIFont systemFontOfSize:8.0f]
#define kFII_SEC_BoldFont           [UIFont boldSystemFontOfSize:10.0f]
#define kFII_SEC_SmallFontHeight    8.0f
#define kFII_SEC_NormalFontHeight   10.0f
#define kFII_SEC_BoldFontHeight     12.0f
#define kFII_SEC_CheckmarkSize      11.0f

@interface sicdEcgVCViewController ()

@end

@implementation sicdEcgVCViewController

@synthesize senialMutable;
@synthesize timer;
@synthesize dataModel;

@synthesize grafico1;
@synthesize dataForPlot1;
@synthesize plot1;
@synthesize grafico2;
@synthesize dataForPlot2;
@synthesize plot2;
@synthesize grafico3;
@synthesize dataForPlot3;
@synthesize plot3;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    factorEcg1 =1;
    factorEcg1 =2;
    factorEcg1 =3;
    
    //Obtengo la senial desde el modelo de datos
    self.senialMutable=dataModel.senialMutable;

    
    //Inicialización del temporizador. TESTs
    timer = [[Timer alloc] init];
    
    
    timerDispatchStatus=1;
    int resolucion = [[dataModel.opciones objectForKey: @"ResolucionSenial"] intValue];
    VELOCIDAD_ECG = (0.001*resolucion)*0.3;

    //Dibuja el ECG depués de 'VELOCIDAD_ECG * NSEC_PER_SEC' segundos
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, VELOCIDAD_ECG * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self pointReceived];
    });
    
    
    longitudSenial = [senialMutable count];

    plot1 = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    dataForPlot1 = [NSMutableArray arrayWithCapacity:200];
    [self inicializaGrafico:grafico1 conPlot:plot1 eID:@"Vector Primario"];

    plot2 = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    dataForPlot2 = [NSMutableArray arrayWithCapacity:200];
    [self inicializaGrafico:grafico2 conPlot:plot2 eID:@"Vector Secundario"];

    plot3 = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    dataForPlot3 = [NSMutableArray arrayWithCapacity:200];
    [self inicializaGrafico:grafico3 conPlot:plot3 eID:@"Vector Alternativo"];
}


- (void)inicializaGrafico:(CPTGraphHostingView *)grafico conPlot:(CPTXYGraph *)elPlot eID:(NSString *)nombre{
    CPTGraphHostingView *grafo = grafico;
    //NSMutableArray *dataForPlot = datosGrafica;
    CPTXYGraph *plot = elPlot;
    
    // Create graph from theme
    //plot = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [plot applyTheme:theme];
    grafo.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    grafo.hostedGraph = plot;
	
    //plot.title = @"Vector Primario";
    plot.paddingLeft = 10.0;
	plot.paddingTop = 10.0;
	plot.paddingRight = 10.0;
	plot.paddingBottom = 10.0;
    
    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)plot.defaultPlotSpace;
    //plotSpace.allowsUserInteraction = YES;
    plotSpace.allowsUserInteraction = NO;
    int numMuestrasGraf = [[dataModel.opciones objectForKey:@"NumeroMuestrasGrafico"] intValue];
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(numMuestrasGraf)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(5000)];
    
    // Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)plot.axisSet;
    
   
    CPTXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPTDecimalFromString(@"2");//(@"5"); //Resolucion rejilla
    x.minorTicksPerInterval = 0.5f;;
    x.minorTickLength = 5.0f;
    x.majorTickLength = 5.0f;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromString(@"400"); //Resolucion rejilla
    axisSet.yAxis.minorTicksPerInterval = 0.5f;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 5.0f;
   
     
    //Estilo de las lineas de la rejilla
    CPTMutableLineStyle *majorGridLineStyle = [CPTMutableLineStyle lineStyle];
    majorGridLineStyle.lineWidth = 0.5f;
    majorGridLineStyle.lineColor = [CPTColor lightGrayColor];
    x.majorGridLineStyle = majorGridLineStyle;
    y.majorGridLineStyle = majorGridLineStyle;
    
	// Create a green plot area
	CPTScatterPlot *line = [[CPTScatterPlot alloc] init];
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.miterLimit = 1.0f;
	lineStyle.lineWidth = 3.0f;
	//lineStyle.lineColor = [CPTColor greenColor];
    lineStyle.lineColor = [CPTColor blueColor];
    line.dataLineStyle = lineStyle;
    //line.identifier = @"Green Plot";
    line.identifier = nombre;
    line.dataSource = self;
	[plot addPlot:line];
    
	// Add plot symbols
	CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPTColor blackColor];
    //----------------------------------------------------------------------------------
}



/*
- (IBAction)backPushed:(id)sender {
    timerDispatchStatus=0;
    [self dismissViewControllerAnimated:YES completion:nil];
}
 */
//Se ejecuta cuando la vista desaparece
- (void)viewWillDisappear:(BOOL)animated{
    timerDispatchStatus=0;
}




- (IBAction)capturaEcgPushed:(id)sender {
    
    /*
    NSString *pdfPath  = [self pathForFile:@"test" withExtension:@"pdf" isForSave:YES];
    
    // Create the PDF form
    [self pdfNewFormwithBounds:kFII_SEC_PageBounds inPath:pdfPath];
    
    // Create the first (and only) page
    [self pdfNewPageWithBounds:kFII_SEC_PageBounds];
    
    // The grid helps to position the different elements
    [self pdfDrawGridWithPageSize:kFII_SEC_PageSize stepping:10];
    
    // Close the PDF
    UIGraphicsEndPDFContext();

    
    // Return an array with all the paths
    //NSArray *paths = [NSArray arrayWithObjects:pdfPath, @"", nil];
    //NSString *fileName = [path lastPathComponent];
    NSArray *paths = [NSArray arrayWithObjects:pdfPath, nil];
     */
}


#pragma mark - CPTPlotDataSource Methods

//-(void)pointReceived:(NSNumber *)point{
-(void)pointReceived{
    
    
    if (timerDispatchStatus==1){
    
      /*
     //TEST. Para medir lo que tardo entre dibujar muestra y muestra
     if (test==0){
     [timer startTimer];
     test=1;
     }else{
     [timer stopTimer];
     NSLog(@"Total time was: %lf milliseconds", [timer timeElapsedInMilliseconds]);
     test=0;
     }
     */
    
    //indice que recorre la senial: indiceGrafica DIV senial (resto de la division)
    //RESOLUCIÓN indica cada cuanto cojo una muestra de la senial
    indiceMuestra = (indiceGrafica+offsetIndice)% longitudSenial;
    float muestra = ([[senialMutable objectAtIndex: indiceMuestra] floatValue]);
    
    //NSNumber *point = (NSNumber *)[senialMutable objectAtIndex: indiceMuestra] ;
    NSNumber *point1 = [NSNumber numberWithFloat: [self.dataModel dameMuestra:muestra enVector:0]];
    NSNumber *point2 = [NSNumber numberWithFloat: [self.dataModel dameMuestra:muestra enVector:1]];
    NSNumber *point3 = [NSNumber numberWithFloat: [self.dataModel dameMuestra:muestra enVector:2]];
        
    CPTPlot *thisPlot1 = [self.plot1 plotWithIdentifier:@"Vector Primario"];
    CPTPlot *thisPlot2 = [self.plot2 plotWithIdentifier:@"Vector Secundario"];
    CPTPlot *thisPlot3 = [self.plot3 plotWithIdentifier:@"Vector Alternativo"];
    
    //longitud del vector de datos
    int lenghtDatos = self.dataForPlot1.count;
    int numMuestrasGraf = [[dataModel.opciones objectForKey:@"NumeroMuestrasGrafico"] intValue];

    //Se estamos en el primer barrido, vas generando el vector 'dataForPlot' (NSmuttable array)
    if (lenghtDatos<=(numMuestrasGraf)){
        [self.dataForPlot1 addObject:point1];
        [thisPlot1 insertDataAtIndex:self.dataForPlot1.count-1 numberOfRecords:1];
        
        [self.dataForPlot2 addObject:point2];
        [thisPlot2 insertDataAtIndex:self.dataForPlot2.count-1 numberOfRecords:1];
        
        [self.dataForPlot3 addObject:point3];
        [thisPlot3 insertDataAtIndex:self.dataForPlot3.count-1 numberOfRecords:1];

    }
    //Reemplazo la muestra en el vector con los datos
    [self.dataForPlot1 replaceObjectAtIndex:indiceGrafica withObject:point1];
    [self.dataForPlot2 replaceObjectAtIndex:indiceGrafica withObject:point2];
    [self.dataForPlot3 replaceObjectAtIndex:indiceGrafica withObject:point3];
    
    //Rango, empezando en el indice actual, longitud de muestras: 1
    NSRange rango = NSMakeRange (indiceGrafica, 1);
    //Reemplazo la muestra en el grafico: la elimino e inserto la nueva en su lugar
    [thisPlot1 deleteDataInIndexRange:rango];
    [thisPlot1 insertDataAtIndex:indiceGrafica numberOfRecords:1];
    
    [thisPlot2 deleteDataInIndexRange:rango];
    [thisPlot2 insertDataAtIndex:indiceGrafica numberOfRecords:1];

    [thisPlot3 deleteDataInIndexRange:rango];
    [thisPlot3 insertDataAtIndex:indiceGrafica numberOfRecords:1];
  
    //Incremento indice que apunta a donde va la siguiente muestra en el grafico
    indiceGrafica++;
    //Si he llegado al final del grafico, reseteo el indice para un nuevo barrido
        
    if (indiceGrafica==(numMuestrasGraf)){
        offsetIndice= (offsetIndice + indiceGrafica) % longitudSenial;
        indiceGrafica=0;
    }
    
    //Vuelvo a cargar el TIMER
    //Vuelo a cargar el timer. LA DIVISIÓN POR 2 DE LA VELOCIDAD ES UN OFFSET PARA DAR MAS VELOCIDAD...
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, VELOCIDAD_ECG * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self pointReceived];
    });
        
    }
}

/*
-(NSArray *)numbersForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange;
-(double *)doublesForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange;
-(CPTNumericData *)dataForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndexRange:(NSRange)indexRange;
*/
 
//Metodo del protocolo <CPTPlotDataSource>
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [dataForPlot1 count];
}

//Metodo del protocolo <CPTPlotDataSource>. Se llama dos veces para dibujar cada punto
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    CPTPlot *grafico = plot;
    NSString *idPlot = [plot identifier];
    //si la llamada es para obtener el valor de 'x', devolvemos el índice
    if (fieldEnum == CPTScatterPlotFieldX) {
        return [NSNumber numberWithInteger:index];
    }
    //si la llamada es para obtener el valor de 'y', llamamos a la func que nos lo buscará en el vector dataForPlot
    else {
        if ([idPlot isEqual:@"Vector Primario"]){
            return [self.dataForPlot1 objectAtIndex:index];
        }else if([idPlot isEqual:@"Vector Secundario"]){
            return [self.dataForPlot2 objectAtIndex:index];
        }else if([idPlot isEqual:@"Vector Alternativo"]){
            return [self.dataForPlot3 objectAtIndex:index];
        }else{
            return [self.dataForPlot1 objectAtIndex:index];
        }
    }
}




- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"generadorPdf"])
    {
        PDFViewControler *VC = (PDFViewControler*)[segue destinationViewController];
        //Paso el modelo de datos
        VC.dataModel = self.dataModel;
        VC.tipoPDF = @"Screening";
    }
}


@end
