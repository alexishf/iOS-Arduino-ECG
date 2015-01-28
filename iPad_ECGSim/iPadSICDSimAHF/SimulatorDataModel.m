//
//  OptionsClass.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 08/06/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "SimulatorDataModel.h"

@implementation SimulatorDataModel{
   
    
}

//Propiedades (son publicas)
@synthesize opciones = _opciones;
@synthesize seniales = _seniales;

@synthesize senialMutable=_senialMutable;
@synthesize senialCapturada=_senialCapturada;

//Metodos
- (id) init
{
    if (self = [super init])
    {
        self.senialMutable = [[NSMutableArray alloc] init];
        self.senialCapturada = [[NSMutableArray alloc] init];
        self.opciones = [[NSMutableDictionary alloc] init];
        self.seniales = [[NSMutableDictionary alloc] init];
        
        [self loadOptionsData];
        [self loadSenialesData];
    }
    return self;
}


-(void)loadSenialesData{
    //offset: valor que se suma a la senial para correcta visualizacion en el ECG en pantalla
    //escala: valor por el que se multiplica la senial para correcta visualizacion en el ECG en pantalla
    int   offsetP   = 0;
    float escalaP   = 1;
    int   offsetQRS = 0;
    float escalaQRS = 1;
    int   offsetT   = 0;
    float escalaT   = 1;

    int   offsetTV1 = 3800;
    float escalaTV1 = 1;
    int   offsetTV2 = 1500;
    float escalaTV2 = 1;
    int   offsetTV3 = 0;
    float escalaTV3 = 1;
    
    int   offsetFV1 = -500;
    float escalaFV1 = 0.3;
    int   offsetFV2 = -500;
    float escalaFV2 = 0.4;

    int   offsetRafaga = 0;
    float escalaRafaga = 1;

    int   offsetPostShockPacing = 0;
    float escalaPostShockPacing = 0.9;

    int   offsetShockStd = 0;
    float escalaShockStd = 0.9;

    int   offsetPVC = 0;
    float escalaPVC = 1;
    
    int   offsetPAC = 0;
    float escalaPAC = 1;

    int idleAfterPVC = [[self.opciones objectForKey:@"PausaTrasPVC"] intValue];
    int idleAfterPAC = [[self.opciones objectForKey:@"PausaTrasPAC"] intValue];
    
    int resolucion = [[self.opciones objectForKey:@"ResolucionSenial"] intValue];

    
    //ASISTOLIA
    senial *senialAsistolia = [[senial alloc] init];
    int longAsistolia=100;
    int nivelIsoelectrico = p2_data[0];
    for(int i=0;i<longAsistolia;i++)             [senialAsistolia.senialOriginal addObject:@(nivelIsoelectrico)];
    for(int i=0;i<longAsistolia;i=i+resolucion)  [senialAsistolia.senialaMostrar addObject:@(nivelIsoelectrico)];
    [self.seniales setObject:senialAsistolia forKey:@"ASISTOLIA"];
    
    //ONDA P
    senial *senialP = [[senial alloc] init];
    int longP=sizeof(p2_data)/sizeof(p2_data[0]);
    for(int i=0;i<longP;i++)             [senialP.senialOriginal addObject:@(p2_data[i])];
    for(int i=0;i<longP;i=i+resolucion)  [senialP.senialaMostrar addObject:@(p2_data[i]*escalaP-offsetP)];
    [self.seniales setObject:senialP forKey:@"P"];
    //ONDA QRS
    senial *senialQRS = [[senial alloc] init];
    int longQRS=sizeof(qrs2_data)/sizeof(qrs2_data[0]);
    for(int i=0;i<longQRS;i++)             [senialQRS.senialOriginal addObject:@(qrs2_data[i])];
    for(int i=0;i<longQRS;i=i+resolucion)  [senialQRS.senialaMostrar addObject:@(qrs2_data[i]*escalaQRS-offsetQRS)];
    [self.seniales setObject:senialQRS forKey:@"QRS"];
    //ONDA T
    senial *senialT = [[senial alloc] init];
    int longT=sizeof(t2_data)/sizeof(t2_data[0]);
    for(int i=0;i<longT;i++)             [senialT.senialOriginal addObject:@(t2_data[i])];
    for(int i=0;i<longT;i=i+resolucion)  [senialT.senialaMostrar addObject:@(t2_data[i]*escalaT-offsetT)];
    [self.seniales setObject:senialT forKey:@"T"];

    //TV1
    senial *senialTV1 = [[senial alloc] init];
    int longTV1=sizeof(tv1_data)/sizeof(tv1_data[0]);
    for(int i=0;i<longTV1;i++)             [senialTV1.senialOriginal addObject:@(tv1_data[i])];
    for(int i=0;i<longTV1;i=i+resolucion)  [senialTV1.senialaMostrar addObject:@(tv1_data[i]*escalaTV1-offsetTV1)];
    [self.seniales setObject:senialTV1 forKey:@"TV1"];

    //TV2
    senial *senialTV2 = [[senial alloc] init];
    int longTV2=sizeof(tv2_data)/sizeof(tv2_data[0]);
    for(int i=0;i<longTV2;i++)             [senialTV2.senialOriginal addObject:@(tv2_data[i])];
    for(int i=0;i<longTV2;i=i+resolucion)  [senialTV2.senialaMostrar addObject:@(tv2_data[i]*escalaTV2-offsetTV2)];
    [self.seniales setObject:senialTV2 forKey:@"TV2"];
    
    //TV3
    senial *senialTV3 = [[senial alloc] init];
    int longTV3=sizeof(tv3_data)/sizeof(tv3_data[0]);
    for(int i=0;i<longTV3;i++)             [senialTV3.senialOriginal addObject:@(tv3_data[i])];
    for(int i=0;i<longTV3;i=i+resolucion)  [senialTV3.senialaMostrar addObject:@(tv3_data[i]*escalaTV3-offsetTV3)];
    [self.seniales setObject:senialTV3 forKey:@"TV3"];
    
    //FV1
    senial *senialFV1 = [[senial alloc] init];
    int longFV1=sizeof(fv1_data)/sizeof(fv1_data[0]);
    for(int i=0;i<longFV1;i++)             [senialFV1.senialOriginal addObject:@(fv1_data[i])];
    for(int i=0;i<longFV1;i=i+resolucion)  [senialFV1.senialaMostrar addObject:@(fv1_data[i]*escalaFV1-offsetFV1)];
    [self.seniales setObject:senialFV1 forKey:@"FV1"];
    
    //FV2
    senial *senialFV2 = [[senial alloc] init];
    int longFV2=sizeof(fv2_data)/sizeof(fv2_data[0]);
    for(int i=0;i<longFV2;i++)             [senialFV2.senialOriginal addObject:@(fv2_data[i])];
    for(int i=0;i<longFV2;i=i+resolucion)  [senialFV2.senialaMostrar addObject:@(fv2_data[i]*escalaFV2-offsetFV2)];
    [self.seniales setObject:senialFV2 forKey:@"FV2"];
    
    //PVC
    senial *senialPVC = [[senial alloc] init];
    int longPVC=sizeof(pvc_data)/sizeof(pvc_data[0]);
    for(int i=0;i<longPVC;i++)             [senialPVC.senialOriginal addObject:@(pvc_data[i])];
    for(int i=0;i<longPVC;i=i+resolucion)  [senialPVC.senialaMostrar addObject:@(pvc_data[i]*escalaPVC-offsetPVC)];
    for(int i=0;i<idleAfterPVC;i++)             [senialPVC.senialOriginal addObject:@(nivelIsoelectrico)];
    for(int i=0;i<idleAfterPVC;i=i+resolucion)  [senialPVC.senialaMostrar addObject:@(nivelIsoelectrico)];
    [self.seniales setObject:senialPVC forKey:@"PVC"];

    //PAC. Lo compongo con P+QRS+T+IDLE (PR=ST=0)
    senial *senialPAC = [[senial alloc] init];
    for(int i=0;i<longP;i++)             [senialPAC.senialOriginal addObject:@(p2_data[i])];
    for(int i=0;i<longP;i=i+resolucion)  [senialPAC.senialaMostrar addObject:@(p2_data[i]*escalaPAC-offsetPAC)];
    for(int i=0;i<longQRS;i++)           [senialPAC.senialOriginal addObject:@(qrs2_data[i])];
    for(int i=0;i<longQRS;i=i+resolucion)[senialPAC.senialaMostrar addObject:@(qrs2_data[i]*escalaPAC-offsetPAC)];
    for(int i=0;i<longT;i++)             [senialPAC.senialOriginal addObject:@(t2_data[i])];
    for(int i=0;i<longT;i=i+resolucion)  [senialPAC.senialaMostrar addObject:@(t2_data[i]*escalaPAC-offsetPAC)];
    for(int i=0;i<idleAfterPAC;i++)             [senialPAC.senialOriginal addObject:@(nivelIsoelectrico)];
    for(int i=0;i<idleAfterPAC;i=i+resolucion)  [senialPAC.senialaMostrar addObject:@(nivelIsoelectrico)];
    [self.seniales setObject:senialPAC forKey:@"PAC"];
    
    //SENAÑES GENERADAS TRAS RESPUESTA DEL S-ICD
    //----------------------------------------------------
    //Rafaga
    senial *senialRafaga = [[senial alloc] init];
    int longRafaga=sizeof(rafaga_data)/sizeof(rafaga_data[0]);
    for(int i=0;i<longRafaga;i++)             [senialRafaga.senialOriginal addObject:@(rafaga_data[i])];
    for(int i=0;i<longRafaga;i=i+resolucion)  [senialRafaga.senialaMostrar addObject:@(rafaga_data[i]*escalaRafaga-offsetRafaga)];
    [self.seniales setObject:senialRafaga forKey:@"Rafaga"];
    
    //postShockPacing
    senial *senialPostShockPacing = [[senial alloc] init];
    int longPostShockPacing=sizeof(postShockPacing_data)/sizeof(postShockPacing_data[0]);
    for(int i=0;i<longPostShockPacing;i++)    [senialPostShockPacing.senialOriginal addObject:@(postShockPacing_data[i])];
    for(int i=0;i<longPostShockPacing;i=i+resolucion)  [senialPostShockPacing.senialaMostrar addObject:@(postShockPacing_data[i]*escalaPostShockPacing-offsetPostShockPacing)];
    [self.seniales setObject:senialPostShockPacing forKey:@"PostShockPacing"];
    
    //shockstd
    senial *senialShockStd = [[senial alloc] init];
    int longShockStd=sizeof(shockstd_data)/sizeof(shockstd_data[0]);
    for(int i=0;i<longShockStd;i++)             [senialShockStd.senialOriginal addObject:@(shockstd_data[i])];
    for(int i=0;i<longShockStd;i=i+resolucion)  [senialShockStd.senialaMostrar addObject:@(shockstd_data[i]*escalaShockStd-offsetShockStd)];
    [self.seniales setObject:senialShockStd forKey:@"ShockStd"];
    //---------------------------------------------------
}



-(void)loadOptionsData{
    
    //RESOLUCION DE LA SENIAL EN LA APP
    [self.opciones setObject:@"15"  forKey:@"ResolucionSenial"];
    [self.opciones setObject:@"210" forKey:@"NumeroMuestrasGrafico"];
    
    //NIVEL ISOLECTRICO DEL ECG. TOMO COMO REFERENCIA LA PRIMERA MUESTRA DE LA ONDA P
    [self.opciones setObject:@(p2_data[0]) forKey:@"NivelIsoelectrico"];
    
    //TIPO DE RITMO
    [self.opciones setObject:@"30" forKey:@"RitmoInicial"]; //ASISTOLIA:30
    [self.opciones setObject:@"30" forKey:@"RitmoPrevio"];   //ASITOLIA:30
    [self.opciones setObject:@"30" forKey:@"RitmoActual"];   //ASITOLIA:30
    
    //HR
    [self.opciones setObject:@"50"  forKey:@"HRmin"];
    [self.opciones setObject:@"200" forKey:@"HRmax"];
    [self.opciones setObject:@"60"  forKey:@"HRini"];
    [self.opciones setObject:@"60"  forKey:@"HRact"];
    
    //PR
    [self.opciones setObject:@"100" forKey:@"PRmin"];
    [self.opciones setObject:@"300" forKey:@"PRmax"];
    [self.opciones setObject:@"100" forKey:@"PRini"];
    [self.opciones setObject:@"100" forKey:@"PRact"];
    
    //QT
    [self.opciones setObject:@"200" forKey:@"QTmin"];
    [self.opciones setObject:@"500" forKey:@"QTmax"];
    [self.opciones setObject:@"200" forKey:@"QTini"];
    [self.opciones setObject:@"200" forKey:@"QTact"];
    
    //P AMPLITUDE
    [self.opciones setObject:@"0" forKey:@"Pmin"];
    [self.opciones setObject:@"8" forKey:@"Pmax"];
    [self.opciones setObject:@"3" forKey:@"Pini"];
    [self.opciones setObject:@"3" forKey:@"Pact"];
    //Mapeado 'P' en Arduino: iPad[0,8], Arduino[1,-1]
    //atenuadorP=(atenuadorP-0)*(-1.0-1.0)/(8.0-0)+1.0;
    [self.opciones setObject:@"1"  forKey:@"PminAtArd"];
    [self.opciones setObject:@"-1" forKey:@"PmaxAtArd"];

    //QRS AMPLITUDE
    [self.opciones setObject:@"0" forKey:@"QRSmin"];
    [self.opciones setObject:@"8" forKey:@"QRSmax"];
    [self.opciones setObject:@"5" forKey:@"QRSini"];
    [self.opciones setObject:@"5" forKey:@"QRSact"];
    //atenuadorQRS = 1-atenuadorQRS/10.0; //MAPEO
    [self.opciones setObject:@"10" forKey:@"QRSAtArd"];
    
    //T AMPLITUDE
    [self.opciones setObject:@"0" forKey:@"Tmin"];
    [self.opciones setObject:@"5" forKey:@"Tmax"];
    [self.opciones setObject:@"1" forKey:@"Tini"];
    [self.opciones setObject:@"1" forKey:@"Tact"];
    //Mapeado 'T' en Arduino: iPad[0,5], Arduino[1,-4]
    //atenuadorT=(atenuadorT-0)*(-4.0-1.0)/(5.0-0)+1.0;
    [self.opciones setObject:@"1"  forKey:@"TminAtArd"];
    [self.opciones setObject:@"-4" forKey:@"TmaxAtArd"];
    
    //SENIAL SINUAL, AMPLITUD TOTAL
    //Mapeado 'Onda Sinusal' en Arduino: iPad[0,100], Arduino[0,1.2]
    [self.opciones setObject:@"0"   forKey:@"SenialMin"];
    [self.opciones setObject:@"100" forKey:@"SenialMax"];
    [self.opciones setObject:@"85"  forKey:@"SenialIni"];
    [self.opciones setObject:@"85"  forKey:@"SenialAct"];
    

    //FA1: rapida
    [self.opciones setObject:@"8"    forKey:@"numeroLatidosFA1"];
    [self.opciones setObject:@"50"   forKey:@"segmentoTRminimoFA1"]; //En ms
    [self.opciones setObject:@"150"  forKey:@"segmentoTRmaximoFA1"]; //En ms

    //FA2: lenta
    [self.opciones setObject:@"5"    forKey:@"numeroLatidosFA2"];
    [self.opciones setObject:@"100"  forKey:@"segmentoTRminimoFA2"]; //En ms
    [self.opciones setObject:@"300"  forKey:@"segmentoTRmaximoFA2"]; //En ms
    
    
    [self.opciones setObject:@"300"  forKey:@"PausaTrasPVC"]; //En ms
    [self.opciones setObject:@"100"  forKey:@"PausaTrasPAC"]; //En ms
    [self.opciones setObject:@"200"  forKey:@"FrecuenciaTA"]; //En ms
    [self.opciones setObject:@"40"   forKey:@"FrecuenciaEscapeV"]; //En ms
    
    //VectorPrimario:0, VectorSecundario:1, VectorAlternativo:2
    [self.opciones setObject:@"0"   forKey:@"VectorEnPantalla"];

    [self.opciones setObject:@"1"   forKey:@"FiltroVectorPrimario"];
    [self.opciones setObject:@"15"   forKey:@"ParamFiltroVectorPrimario"];
    [self.opciones setObject:@"1"   forKey:@"FiltroVectorSecundario"];
    [self.opciones setObject:@"15"   forKey:@"ParamFiltroVectorSecundario"];
    [self.opciones setObject:@"1"   forKey:@"FiltroVectorAlternativo"];
    [self.opciones setObject:@"10"   forKey:@"ParamFiltroVectorAlternativo"];

    //Amplitud onda R Vector Secundario (algo en el Primario)
    //Cambio el valor del potenciómetro0 digital de 5k
    [self.opciones setObject:@"0"   forKey:@"AmpRCanalSecMin"];
    [self.opciones setObject:@"15"  forKey:@"AmpRCanalSecMax"];
    [self.opciones setObject:@"15"  forKey:@"AmpRCanalSecAct"];
    //Amplitud onda R Vector Alternativo (algo en el Primario)
    //Cambio el valor del potenciómetro1 digital de 5k
    [self.opciones setObject:@"0"   forKey:@"AmpRCanalAltMin"];
    [self.opciones setObject:@"10"  forKey:@"AmpRCanalAltMax"];
    [self.opciones setObject:@"10"  forKey:@"AmpRCanalAltAct"];

    
    
    //Grabación de la señal
    [self.opciones setObject:@"10"   forKey:@"segundosAgrabarIni"];
    [self.opciones setObject:@"120"   forKey:@"segundosAgrabarMax"];
    
    //Valores que afectan a la barra de herramientas con iconos de estado
    [self.opciones setObject:@"FALSE"   forKey:@"cableSerieConectado"];
    [self.opciones setObject:@"FALSE"   forKey:@"hardwareInicializado"];

}



- (NSMutableArray *) generaSenial:(int)ritmo{
    
        int resolucion = [[self.opciones objectForKey:@"ResolucionSenial"] intValue];

        int nLatidos=0; //Numero de latidos en el ciclo FA
        float atenuadorQRS;
        float atenuadorT;
        int trMax; //Intervalo max tr(de la T a la R) para FA
        int trMin; //Intervalo min tr(de la T a la R) para FA
        senial *laSenial  = [[senial alloc] init];

        int HR = [[self.opciones objectForKey:@"HRact"] intValue];
        int PR = [[self.opciones objectForKey:@"PRact"] intValue];
        int QT = [[self.opciones objectForKey:@"QTact"] intValue];
    
        int longP=sizeof(p2_data)/sizeof(p2_data[0]);
        int longQRS=sizeof(qrs2_data)/sizeof(qrs2_data[0]);
        int longT=sizeof(t2_data)/sizeof(t2_data[0]);
        int longPVC=sizeof(pvc_data)/sizeof(pvc_data[0]);
        int longSegmentoST=(QT-longQRS-longT)/resolucion;
        int longSegmentoPR=(PR-longP)/resolucion;
        int longSegmentoTP=( (60000/HR)-PR-QT )/resolucion;

    
        //FA1: FA rápida
        int TRminFA1 =      [[self.opciones objectForKey:@"segmentoTRminimoFA1"] intValue];
        int TRmaxFA1 =      [[self.opciones objectForKey:@"segmentoTRmaximoFA1"] intValue];
        int nLatidosFA1 =   [[self.opciones objectForKey:@"numeroLatidosFA1"] intValue];
        //FA2: FA lenta
        int TRminFA2 =      [[self.opciones objectForKey:@"segmentoTRminimoFA2"] intValue];
        int TRmaxFA2 =      [[self.opciones objectForKey:@"segmentoTRmaximoFA2"] intValue];
        int nLatidosFA2 =   [[self.opciones objectForKey:@"numeroLatidosFA2"] intValue];
    
        int FrecAT = [[self.opciones objectForKey:@"FrecuenciaTA"] intValue];
        //Calculo segmento TP. asumo segmento PR=0; segmento ST=0 para la taqui auricular
        int LongSegTPenAT=( (60000/FrecAT)-longP-longQRS-longT )/resolucion;

        //Defino la frecuencia del ritmo de escape
        int FrecEscV = [[self.opciones objectForKey:@"FrecuenciaEscapeV"] intValue];
        //Calculo el segmento TP
        //asumo segmento PR=0; segmento ST=0 para la taqui auricular
        int LongSegTPenEscV=( (60000/FrecEscV)-longPVC )/resolucion;

        NSString *ritmoActual= [self.opciones objectForKey:@"RitmoActual"];
    
        float atenuadorP = [[self.opciones objectForKey:@"Pact"] floatValue];
        //MAPEO: return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
        atenuadorP=(atenuadorP-0)*(-1.0-1.0)/(8.0-0)+1.0;
    
        int nivelIsoelectrico = [[self.opciones objectForKey:@"NivelIsoelectrico"] intValue];
      //--------------------------------------------------------------------------------

    
        //Elimino todo los elementos del vector senial para insertar la nueva senial
        [self.senialMutable removeAllObjects];
        switch (ritmo)
        {
            case ASISTOLIA:
                laSenial = [self.seniales objectForKey:@"ASISTOLIA"];
                [self.senialMutable addObjectsFromArray:laSenial.senialaMostrar];
                [self.opciones setObject:@"30" forKey:@"RitmoActual"];
                //longitudSenial = [senialMutable count];
                break;
                
            case FA1:
            case FA2:
                atenuadorQRS = 0;
                atenuadorT = 0;
                
                //FA Rapida
                if (ritmo==FA1){
                    trMax=TRmaxFA1;
                    trMin=TRminFA1;
                    nLatidos=nLatidosFA1;
                    [self.opciones setObject:@"70" forKey:@"RitmoActual"];
                }
                //FA lenta
                else if(ritmo==FA2){
                    trMax=TRmaxFA2;
                    trMin=TRminFA2;
                    nLatidos=nLatidosFA2;
                    [self.opciones setObject:@"71" forKey:@"RitmoActual"];
                }
                
                for (int j=1; j<=nLatidos;j++){
                    //Utilizo el nivel isoelectrico como referencia
                    int valor = nivelIsoelectrico;
                    //QRS
                    laSenial = [self.seniales objectForKey:@"QRS"];
                    for(int i=0;i<laSenial.senialaMostrar.count;i++){
                        int valor = [[laSenial.senialaMostrar objectAtIndex: i] intValue];
                        int delta2 = (valor-nivelIsoelectrico)*atenuadorQRS;
                        [self.senialMutable addObject: [NSNumber numberWithInt: (valor-delta2)]];
                    }
                    //SEGMENTO ST
                    for(int i=0;i<longSegmentoST;i++){
                        [self.senialMutable addObject: [NSNumber numberWithInt:nivelIsoelectrico] ];
                        //sumo valor aleatorio (200max sobre valor muestra) para generar P caoticas
                        int deltaFA = valor + arc4random() % ((valor+200)-valor+1); //aleat entre 1 y 200
                        [self.senialMutable addObject: [NSNumber numberWithInt:deltaFA] ];
                    }
                    //ONDA T
                    laSenial = [self.seniales objectForKey:@"T"];
                    for(int i=0;i<laSenial.senialaMostrar.count;i++){
                        int valor = [[laSenial.senialaMostrar objectAtIndex: i] intValue];
                        int delta2 = (valor-nivelIsoelectrico)*atenuadorT;
                        [self.senialMutable addObject: [NSNumber numberWithInt: (valor-delta2)]];
                    }
                    //SEGMENTO TR
                    // Valor TR aprox para 60lpm(con los anchos P/R/T que tenemos): 462ms
                    //Numero aleatorio entre trMin y trMax
                    int trRandom =  trMin/resolucion + arc4random() % (trMax/resolucion-trMin/resolucion+1);
                    for(int i=0;i<trRandom;i++){
                        //sumo valor aleatorio (200max sobre valor muestra) para generar P caoticas
                        int deltaFA = valor + arc4random() % ((valor+200)-valor+1); //aleat entre 1 y 200
                        [self.senialMutable addObject: [NSNumber numberWithInt:deltaFA] ];
                    }
                }
                break;
                
                
                
            case SINUSAL0:
                //ONDA P
                laSenial = [self.seniales objectForKey:@"P"];
                for(int i=0;i<laSenial.senialaMostrar.count;i++){
                    int valor = [[laSenial.senialaMostrar objectAtIndex: i] intValue];
                    int delta2 = (valor-nivelIsoelectrico)*atenuadorP;
                    [self.senialMutable addObject: [NSNumber numberWithInt: (valor-delta2)]];
                }
                
                //SEGMENTO PR
                for(int i=0;i<longSegmentoPR;i++)
                    [self.senialMutable addObject: [NSNumber numberWithInt:nivelIsoelectrico] ];
                
                //QRS
                laSenial = [self.seniales objectForKey:@"QRS"];
                atenuadorQRS = [[self.opciones objectForKey:@"QRSact"] intValue];
                atenuadorQRS = 1-atenuadorQRS/10.0; //MAPEO
                for(int i=0;i<laSenial.senialaMostrar.count;i++){
                    int valor = [[laSenial.senialaMostrar objectAtIndex: i] intValue];
                    int delta2 = (valor-nivelIsoelectrico)*atenuadorQRS;
                    [self.senialMutable addObject: [NSNumber numberWithInt: (valor-delta2)]];
                }
                
                //SEGMENTO ST
                for(int i=0;i<longSegmentoST;i++)
                    [self.senialMutable addObject: [NSNumber numberWithInt:nivelIsoelectrico] ];
                
                //ONDA T
                laSenial = [self.seniales objectForKey:@"T"];
                atenuadorT = [[self.opciones objectForKey:@"Tact"] floatValue];
                //MAPEO: return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
                //int: 0,5. out:1,-4
                atenuadorT=(atenuadorT-0)*(-4.0-1.0)/(5.0-0)+1.0;
                for(int i=0;i<laSenial.senialaMostrar.count;i++){
                    int valor = [[laSenial.senialaMostrar objectAtIndex: i] intValue];
                    int delta2 = (valor-nivelIsoelectrico)*atenuadorT;
                    [self.senialMutable addObject: [NSNumber numberWithInt: (valor-delta2)]];
                }
                
                //SEGMENTO TP
                for(int i=0;i<longSegmentoTP;i++)
                    [self.senialMutable addObject: [NSNumber numberWithInt:nivelIsoelectrico] ];
                
                //reescalamos la senial acorde al valor de amplitud seleccionado
                //MAPEO: [0,100],[0,2.0]
                float senialAct = [[self.opciones objectForKey:@"SenialAct"] floatValue];
                float atenuadorSenial= (senialAct-0)*(2.0-0.0)/(100-0)+0;
                for(int i=0; i<self.senialMutable.count; i++){
                    float muestra = [[self.senialMutable objectAtIndex:i] floatValue];
                    muestra = (muestra-nivelIsoelectrico)*atenuadorSenial+nivelIsoelectrico;
                    [self.senialMutable replaceObjectAtIndex:i withObject: [NSNumber numberWithInt:muestra]  ];
                }
                //ritmoActual=SINUSAL0;
                [self.opciones setObject:@"49" forKey:@"RitmoActual"];
                break;
                
            case AT: //58
                atenuadorP=0;
                
                //ONDA P
                laSenial = [self.seniales objectForKey:@"P"];
                for(int i=0;i<laSenial.senialaMostrar.count;i++){
                    int valor = [[laSenial.senialaMostrar objectAtIndex: i] intValue];
                    int delta2 = (valor-nivelIsoelectrico)*atenuadorP;
                    [self.senialMutable addObject: [NSNumber numberWithInt: (valor-delta2)]];
                }
                
                //SEGMENTO PR=0
                
                //QRS
                laSenial = [self.seniales objectForKey:@"QRS"];
                atenuadorQRS = 0.3;
                for(int i=0;i<laSenial.senialaMostrar.count;i++){
                    int valor = [[laSenial.senialaMostrar objectAtIndex: i] intValue];
                    int delta2 = (valor-nivelIsoelectrico)*atenuadorQRS;
                    [self.senialMutable addObject: [NSNumber numberWithInt: (valor-delta2)]];
                }
                
                //SEGMENTO ST=0
                
                //ONDA T
                laSenial = [self.seniales objectForKey:@"T"];
                atenuadorT = 0;
                for(int i=0;i<laSenial.senialaMostrar.count;i++){
                    int valor = [[laSenial.senialaMostrar objectAtIndex: i] intValue];
                    int delta2 = (valor-nivelIsoelectrico)*atenuadorT;
                    [self.senialMutable addObject: [NSNumber numberWithInt: (valor-delta2)]];
                }
                
                //SEGMENTO TP de la TA
                for(int i=0;i<LongSegTPenAT;i++)
                    [self.senialMutable addObject: [NSNumber numberWithInt:nivelIsoelectrico] ];
                
                [self.opciones setObject:@"58" forKey:@"RitmoActual"];
                break;
                
            case ESCPV: //57
                laSenial = [self.seniales objectForKey:@"PVC"];
                [self.senialMutable addObjectsFromArray:laSenial.senialaMostrar];
                
                //SEGMENTO TP de la TA
                for(int i=0;i<LongSegTPenEscV;i++)
                    [self.senialMutable addObject: [laSenial.senialaMostrar objectAtIndex: 0] ];
                
                [self.opciones setObject:@"57" forKey:@"RitmoActual"];
                break;
                
            case TV1:
                laSenial = [self.seniales objectForKey:@"TV1"];
                [self.senialMutable addObjectsFromArray:laSenial.senialaMostrar];
                [self.opciones setObject:@"50" forKey:@"RitmoActual"];
                break;
                
            case TV2:
                laSenial = [self.seniales objectForKey:@"TV2"];
                [self.senialMutable addObjectsFromArray:laSenial.senialaMostrar];
                [self.opciones setObject:@"51" forKey:@"RitmoActual"];
                break;
                
            case TV3:
                laSenial = [self.seniales objectForKey:@"TV3"];
                [self.senialMutable addObjectsFromArray:laSenial.senialaMostrar];
                [self.opciones setObject:@"52" forKey:@"RitmoActual"];
                break;
                
            case FV1:
                laSenial = [self.seniales objectForKey:@"FV1"];
                [self.senialMutable addObjectsFromArray:laSenial.senialaMostrar];
                [self.opciones setObject:@"80" forKey:@"RitmoActual"];
                break;
                
            case FV2:
                laSenial = [self.seniales objectForKey:@"FV2"];
                [self.senialMutable addObjectsFromArray:laSenial.senialaMostrar];
                [self.opciones setObject:@"90" forKey:@"RitmoActual"];
                break;
                
            case PVC:
                laSenial = [self.seniales objectForKey:@"PVC"];
                [self.senialMutable addObjectsFromArray:laSenial.senialaMostrar];
                if ([ritmoActual intValue]!=PVC){
                    [self.opciones setObject:ritmoActual forKey:@"RitmoPrevio"];
                }
                [self.opciones setObject:@"55" forKey:@"RitmoActual"];
                break;
                
            case PAC:
                laSenial = [self.seniales objectForKey:@"PAC"];
                [self.senialMutable addObjectsFromArray:laSenial.senialaMostrar];
                if ([ritmoActual intValue]!=PAC){
                    [self.opciones setObject:ritmoActual forKey:@"RitmoPrevio"];
                }
                [self.opciones setObject:@"56" forKey:@"RitmoActual"];
                break;
            
            //Señales generadas como respuesta del S-ICD
            case RAFAGA:
                laSenial = [self.seniales objectForKey:@"Rafaga"];
                [self.senialMutable addObjectsFromArray:laSenial.senialaMostrar];
                [self.opciones setObject:@"45" forKey:@"RitmoActual"];
                break;
                
            case POSTSHOCKP:
                laSenial = [self.seniales objectForKey:@"PostShockPacing"];
                [self.senialMutable addObjectsFromArray:laSenial.senialaMostrar];
                [self.opciones setObject:@"46" forKey:@"RitmoActual"];
                break;
                
            case SHOCKSTD:
                laSenial = [self.seniales objectForKey:@"ShockStd"];
                [self.senialMutable addObjectsFromArray:laSenial.senialaMostrar];
                [self.opciones setObject:@"47" forKey:@"RitmoActual"];
                break;
        }
    
    //Senial Vector Primario
    //NSMutableArray *p=[self generaSenialVectorPrimario:self.senialMutable conFiltro:1];
    //Senial Vector Secundario
    
    //Senial Vector Alternativo
    
    
    //Senial "maestra"
    return self.senialMutable;
}


- (float) dameMuestra:(float)muestra  enVector: (int)vector{
    int tipoDeFiltro;
    float parametroFiltro;
    float valor,inMax, inMin;
    
    // Solo aplico los filtros de 'vectroes' cuando estamos en ritmo sinusal
    // Si no lo estamos, retornamos sin mas...
    int ritmo = [[self.opciones objectForKey:@"RitmoActual"] intValue];
    if (ritmo!=SINUSAL0){
        return muestra;
    }
    
    
    
    switch (vector) {
        //0: Primario
        case 0:
            tipoDeFiltro = [[self.opciones objectForKey:@"FiltroVectorPrimario"] intValue];
            
            //parametroFiltro = [[self.opciones objectForKey:@"ParamFiltroVectorPrimario"] intValue];
            // Calculo parámetro como un valor multiplicador
            // Mapeo (AmpRCanalSecMax,AmpRCanalSecMin) a (1,0.5)
            valor = [[self.opciones objectForKey:@"AmpRCanalSecAct"] intValue];
            inMax = [[self.opciones objectForKey:@"AmpRCanalSecMax"] intValue];
            inMin = [[self.opciones objectForKey:@"AmpRCanalSecMin"] intValue];
            //return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
            
            //***TENGO QUE GENERAR UN VALOR PARAMETRO COMINACION DEL VEC PRIM Y SEC
            parametroFiltro = (valor-inMin)*(1-0.5)/(inMax-inMin) + 0.5;
            
            return [self filtraMuestra:muestra tipoFiltro:tipoDeFiltro paramFiltro:parametroFiltro];
            break;
            
        //1: Secundario
        case 1:
            tipoDeFiltro = [[self.opciones objectForKey:@"FiltroVectorSecundario"] intValue];
            //parametroFiltro = [[self.opciones objectForKey:@"ParamFiltroVectorSecundario"] intValue];
            //parametroFiltro = [[self.opciones objectForKey:@"ParamFiltroVectorPrimario"] intValue];
            // Calculo parámetro como un valor multiplicador
            // Mapeo (AmpRCanalSecMax,AmpRCanalSecMin) a (1,0.5)
            valor = [[self.opciones objectForKey:@"AmpRCanalSecAct"] intValue];
            inMax = [[self.opciones objectForKey:@"AmpRCanalSecMax"] intValue];
            inMin = [[self.opciones objectForKey:@"AmpRCanalSecMin"] intValue];
            //return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
            parametroFiltro = (valor-inMin)*(1-0.5)/(inMax-inMin) + 0.5;
            
            return [self filtraMuestra:muestra tipoFiltro:tipoDeFiltro paramFiltro:parametroFiltro];
            break;
        
        //2: Alternativo
        case 2:
            tipoDeFiltro = [[self.opciones objectForKey:@"FiltroVectorAlternativo"] intValue];
            //parametroFiltro = [[self.opciones objectForKey:@"ParamFiltroVectorAlternativo"] intValue];
            // Mapeo (AmpRCanalSecMax,AmpRCanalSecMin) a (1,0.1)
            valor = [[self.opciones objectForKey:@"AmpRCanalAltAct"] intValue];
            inMax = [[self.opciones objectForKey:@"AmpRCanalAltMax"] intValue];
            inMin = [[self.opciones objectForKey:@"AmpRCanalAltMin"] intValue];
            //return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
            parametroFiltro = (valor-inMin)*(1-0.1)/(inMax-inMin) + 0.1;

            return [self filtraMuestra:muestra tipoFiltro:tipoDeFiltro paramFiltro:parametroFiltro];
            break;
        break;
        default:
            return muestra;
            break;
    }
}

- (float) filtraMuestra: (float)muestra tipoFiltro:(int)tipo paramFiltro:(float)parametro{
    int valorMax1 = 1800;
    int outMax1 = 700;
    int outMin1 =  0;

    int cteFiltro2=2300;
    float Multiplicador=1.5;

    int ritmoActual = [[self.opciones objectForKey:@"RitmoActual"] integerValue];
    
    int ritmoConQRS=0;
    
    //Miro si el ritmo incorpora un QRS o no
    if ( (ritmoActual==49)|| (ritmoActual==70) || (ritmoActual==71) || (ritmoActual==56) || (ritmoActual==58) ){
        ritmoConQRS=1;
    }

    
    switch (tipo) {
        //0: No hace nada
        case 0:
            return muestra;
            break;
            
            
        // 1: Recorta la señal a partir de un valor máximo
        //    Valor max definido en
        case 1:
    
            //Si el ritmo incorpora un QRS, escalo los valores por encima de un maximo
            if (ritmoConQRS){
                if(muestra>valorMax1){
                    muestra=muestra*parametro;
                    return muestra;
                }
            //Si no incorpora QRS, simplemente mapeo la señal a un rango de valores más estrecho
            //asumo, in_max=2000, out_min=0
            }else{
                //MAPEO: return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
                muestra=(muestra-0)*(outMax1-outMin1)/(2000-0)+outMin1;
                return muestra;
            }
            break;
            
            
        //2: (muestra^2)/cte
        case 2:
            muestra=muestra*muestra/cteFiltro2;
            return muestra;
            break;
            
            
        //3: multiplica por una cte.
        case 3:
            muestra=muestra*Multiplicador;
            return muestra;
            break;
            
            
        default:
            return muestra;
            break;
    }
    return muestra;
}

-(void)registraMuestra:(NSNumber *)muestra{
    [self.senialCapturada addObject: muestra];
}

- (void) borraSenialCapturada{
    [self.senialCapturada removeAllObjects];
}


- (void) imprimeOpcionesEnConsola{
    NSLog(@"Opciones:  - %@", self.opciones);
}

@end
