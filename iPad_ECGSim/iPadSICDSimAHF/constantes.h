//
//  constantes.h
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 05/07/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#ifndef iPadSICDSimAHF_constantes_h
#define iPadSICDSimAHF_constantes_h

#define fileNameSavedScripts @"scriptsSaved.data"

#define LongComando 5

#define BUFFER_LEN 1024
#define START_STR @"Start"
#define STOP_STR  @"Stop"
#define CONNECTED_STR @"Connected"
#define NOT_CONNECTED_STR @"Not Connected"
#define TEST_DATA_LEN 256

//Tipos de ritmos
//Comando 100, seguido del valor del ritmo
#define ASISTOLIA 30
#define SINUSAL0  49
#define TV1       50
#define TV2       51
#define TV3       52
#define TV4       53
#define TV5       54
#define PVC       55
#define PAC       56
#define ESCPV     57
#define AT        58
#define TORSADA1  60
#define FA1       70
#define FA2       71
#define FV1       80
#define FV2       90

//Codigos comando para cambiar parametro
#define cRitmo 100
#define cIniciaArduino  50
#define cFrecCardiaca  200
#define cIntervaloPR   201
#define cIntervaloST   202
#define cAmplitudP     204
#define cAmplitudR     205
#define cAmplitudT     206
#define cAmplitudRS    207
#define cValorSenial   208
#define cPausaTrasPVC  209
#define cCambioFrecTA  210
#define cCambioFrecRV  211
#define cPausaTrasPAC  212
#define cRenSECprim    213
#define cRenALTprim    214

//Ritmos generados solo en iPad
#define RAFAGA       45
#define POSTSHOCKP   46
#define SHOCKSTD     47


#endif
