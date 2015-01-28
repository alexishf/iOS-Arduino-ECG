//
//  monitorEcgVC.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 03/08/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "monitorEcgVC.h"

@interface monitorEcgVC (){
    float VELOCIDAD_ECG;//Tiempo en segundo de escritura en la grafica
    int vectorEnPantalla; //Indica cual de los tres vectores ha de mostrarse
    int longitudSenial;
    int indiceGrafica;
    int delta;
    int test;
    int offsetIndice;
    int indiceMuestra;
    int contadorPVC;
    int contadorPAC;
    int trRandom;
    bool grabando;
    NSMutableArray *senialMutable;
}
@end



@implementation monitorEcgVC

@synthesize dataModel;
@synthesize plot1;
@synthesize dataForPlot1;
@synthesize graficoECG;


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
}

- (void) inicializaECG {
    indiceGrafica=0;
    delta=0;
    test=0;
    offsetIndice=0;
    indiceMuestra=0;
    contadorPVC=0;
    contadorPAC=0;
    
    senialMutable= [[NSMutableArray alloc] init];
    //Esta es la senial por defecto
    senialMutable= [self.dataModel generaSenial:ASISTOLIA];

    //Indica cual de los tres vectores ha de mostrarse al iniciar la app
    vectorEnPantalla=[[dataModel.opciones objectForKey:@"VectorEnPantalla"] intValue];
    
    int OffsetAcelerador = 1;
    int resolucion = [[dataModel.opciones objectForKey:@"ResolucionSenial"] intValue];
    
    plot1 = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    dataForPlot1 = [NSMutableArray arrayWithCapacity:200];
    [self inicializaGrafico:graficoECG conPlot:plot1];
    
    //Frecuencia de refresco del grafico
    //----------------------
    VELOCIDAD_ECG = (0.001*resolucion)*OffsetAcelerador;
    //Dibuja el ECG depués de 'VELOCIDAD_ECG * NSEC_PER_SEC' segundos
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, VELOCIDAD_ECG * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self pointReceived];
    });
}

- (void) setSenialForECG:(NSMutableArray *)signal{
    senialMutable=signal;
}


// Actualiza el estado de 'grabacion', que nos dice si hemos de registrar o no
// el ECG
- (void) recordingECGstatus:(BOOL)status{
    grabando=status;
}


#pragma mark - CPTPlotDataSource Methods
//--------------------------------------------------------------------
- (void)inicializaGrafico:(CPTGraphHostingView *)grafico conPlot:(CPTXYGraph *)elPlot{
    int numMuestrasGraf = [[dataModel.opciones objectForKey:@"NumeroMuestrasGrafico"] intValue];
    CPTGraphHostingView *grafo = grafico;
    //NSMutableArray *dataForPlot = datosGrafica;
    CPTXYGraph *plot = elPlot;
    
    // Create graph from theme
    //plot = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [plot applyTheme:theme];
    grafo.collapsesLayers = NO; // Setting to YES reduces GPU memory usage, but can slow drawing/scrolling
    grafo.hostedGraph = plot;
	
    plot.paddingLeft = 10.0;
	plot.paddingTop = 10.0;
	plot.paddingRight = 10.0;
	plot.paddingBottom = 10.0;
    
    // Setup plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)plot.defaultPlotSpace;
    //plotSpace.allowsUserInteraction = YES;
    plotSpace.allowsUserInteraction = NO;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(numMuestrasGraf)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0) length:CPTDecimalFromFloat(5000)];
    
    // Axes
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)plot.axisSet;
    
    CPTXYAxis *x = axisSet.xAxis;
    x.majorIntervalLength = CPTDecimalFromString(@"2"); //Resolucion rejilla
    x.minorTicksPerInterval = 0.5f;//4;
    x.minorTickLength = 5.0f;
    x.majorTickLength = 5.0f;//7.0f;
    
    CPTXYAxis *y = axisSet.yAxis;
    y.majorIntervalLength = CPTDecimalFromString(@"380"); //Resolucion rejilla
    axisSet.yAxis.minorTicksPerInterval = 0.5f;//2;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 5.0f;//7.0f;
    
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
    line.identifier = @"Green Plot";
    line.dataSource = self;
	[plot addPlot:line];
    
	// Add plot symbols
	CPTMutableLineStyle *symbolLineStyle = [CPTMutableLineStyle lineStyle];
	symbolLineStyle.lineColor = [CPTColor blackColor];
    
	CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.duration = 1.0f;
	fadeInAnimation.removedOnCompletion = NO;
	fadeInAnimation.fillMode = kCAFillModeForwards;
	fadeInAnimation.toValue = [NSNumber numberWithFloat:1.0];
    //----------------------------------------------------------------------------------
}

//-(void)pointReceived:(NSNumber *)point{
-(void)pointReceived{
    
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
    
    int numMuestrasGraf = [[dataModel.opciones objectForKey:@"NumeroMuestrasGrafico"] intValue];
    int ritmoActual =     [[dataModel.opciones objectForKey:@"RitmoActual"] intValue];
    int ritmoPrevio =     [[dataModel.opciones objectForKey:@"RitmoPrevio"] intValue];
    
    
    //indice que recorre la senial: indiceGrafica DIV senial (resto de la division)
    //RESOLUCIÓN indica cada cuanto cojo una muestra de la senial
    indiceMuestra = (indiceGrafica+offsetIndice)% [senialMutable count];//longitudSenial;
    
    NSNumber *point;
    //Si el ritom actual es PVC or PAC
    if (ritmoActual==55){
        point = (NSNumber *)[senialMutable objectAtIndex: contadorPVC];
        contadorPVC++;
        if(contadorPVC==[senialMutable count]){
            senialMutable = [dataModel generaSenial:ritmoPrevio];
            //[self sendCommand:100 withValue:ritmoPrevio];
            //Este offset hace que tras el PVC comience un RS (comenzando con la P)
            offsetIndice = [senialMutable count]-indiceGrafica%[senialMutable count];
            contadorPVC=0;
        }
    }else if(ritmoActual==56){
        point = (NSNumber *)[senialMutable objectAtIndex: contadorPAC];
        contadorPAC++;
        if(contadorPAC==[senialMutable count]){
            senialMutable = [dataModel generaSenial:ritmoPrevio];
            //[self sendCommand:100 withValue:ritmoPrevio];
            //Este offset hace que tras el PAC comience un RS (comenzando con la P)
            offsetIndice = [senialMutable count]-indiceGrafica%[senialMutable count];
            contadorPAC=0;
        }
    }
    else{
        point = (NSNumber *)[senialMutable objectAtIndex: indiceMuestra];
    }
    
    //Indica cual de los tres vectores ha de mostrarse al iniciar la app
    vectorEnPantalla=[[dataModel.opciones objectForKey:@"VectorEnPantalla"] intValue];

    //Transformo el punto según el vector seleccionado
    point = [NSNumber numberWithFloat: [self.dataModel dameMuestra:[point floatValue] enVector:vectorEnPantalla]];
    
    //Grabo el punto si hemos dado a RECORD
    if (grabando==YES){
        [self.dataModel registraMuestra:point];
    }
    
    //NSNumber *point = (NSNumber *)[senialMutable objectAtIndex: indiceMuestra] ;
    
    CPTPlot *thisPlot = [self.plot1 plotWithIdentifier:@"Green Plot"];
    
    //longitud del vector de datos
    int lenghtDatos = self.dataForPlot1.count;
    
    //Se estamos en el primer barrido, vas generando el vector 'dataForPlot' (NSmuttable array)
    if (lenghtDatos<=numMuestrasGraf){
        [self.dataForPlot1 addObject:point];
        [thisPlot insertDataAtIndex:self.dataForPlot1.count-1 numberOfRecords:1];
    }
    //Reemplazo la muestra en el vector con los datos
    [self.dataForPlot1 replaceObjectAtIndex:indiceGrafica withObject:point];
    //Rango, empezando en el indice actual, longitud de muestras: 1
    NSRange rango = NSMakeRange (indiceGrafica, 1);
    //Reemplazo la muestra en el grafico: la elimino e inserto la nueva en su lugar
    [thisPlot deleteDataInIndexRange:rango];
    [thisPlot insertDataAtIndex:indiceGrafica numberOfRecords:1];
    
    //Incremento indice que apunta a donde va la siguiente muestra en el grafico
    indiceGrafica++;
    //Si he llegado al final del grafico, reseteo el indice para un nuevo barrido
    if (indiceGrafica==numMuestrasGraf){
        offsetIndice= (offsetIndice + indiceGrafica) % [senialMutable count];//longitudSenial;
        indiceGrafica=0;
    }
    
    //Vuelvo a cargar el TIMER
    //Vuelo a cargar el timer. LA DIVISIÓN POR 2 DE LA VELOCIDAD ES UN OFFSET PARA DAR MAS VELOCIDAD...
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, VELOCIDAD_ECG * NSEC_PER_SEC), dispatch_get_main_queue(), ^{[self pointReceived];});
}

//Metodo del protocolo <CPTPlotDataSource>
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    return [dataForPlot1 count];
}

//Metodo del protocolo <CPTPlotDataSource>. Se llama dos veces para dibujar cada punto
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    
    //si la llamada es para obtener el valor de 'x', devolvemos el índice
    if (fieldEnum == CPTScatterPlotFieldX) {
        return [NSNumber numberWithInteger:index];
    }
    //si la llamada es para obtener el valor de 'y', llamamos a la func que nos lo buscará en el vector dataForPlot
    else {
        return [self.dataForPlot1 objectAtIndex:index];
    }
}


@end
