// *************************************************************************************
//                   SIMULADOR DE RITMOS CARDIACOS
//                         Arduino-iPad
// ------------------------------------------------------------------------------------- 
// Alexis Herrera Febles
// email:    alexishf@gmail.com / blog: www.alexishf.com
// twitter:  @AlexisHFebles
// -------------------------------------------------------------------------------------
// *************************************************************************************




// LIBRERIAS
// ********************************************************************

// Archivo con los vectores de muestras de los ritmos cardiacos
#include "ritmos.h"       
// Para poder comunicarnos con el conversor D/A usando el protocolo SPI
#include "SPI.h"          




// CONSTANTES
// ********************************************************************

// *** CONEXIONADO SPI (para el conversor D/A)
// Para ARDUINO MEGA:
#define SPI_CLOCK            52 //arduino   <->   SPI Slave Clock Input     -> SCK 
#define SPI_MOSI             51 //arduino   <->   SPI Master Out Slave In   -> SDI
#define SPI_MISO             50 //arduino   <->   SPI Master In Slave Out   -> SDO


// *** MAQUINAS DE ESTADO
// Para usar palabras en lugar de numeros
#define UNO       1
#define DOS       2
#define TRES      3
#define CUATRO    4

// Estados genericos de las 'maquinas de estados'
#define INIT      0 // Estado inicial
#define IDLE      1 // Estado ocupado
#define SENIAL    5 // Estado señal periodica no variable
#define IDLE_FA1  701
#define IDLE_FA2  711

// Estados: Ritmo Sinusal (RS)
#define P         10
#define PR_SEG    11
#define QRS       2
#define ST_SEG    13
#define T         14
#define postPVC_SEG 15
#define postPAC_SEG 16

// Estados: Fibrilacion Auricular (FV)
#define FV11      81
#define FV12      82
#define FV13      83
#define FV14      84
#define FV15      85


// *** TIPOS DE RITMO
#define ASISTOLIA 30 // Asistolia
#define SINUSAL1  47 // Sinusal segmentado
#define SINUSAL0  49 // Sinusal segmentado
#define SINUSAL   48 // Sinusal
#define TV1       50 // Taquicardia Ventricular 1
#define TV2       51 // Taquicardia Ventricular 2
#define TV3       52 // Taquicardia Ventricular 3
#define TV4       53 // Taquicardia Ventricular 4
#define TV5       54 // Taquicardia Ventricular 5
#define PVC       55 // Extrasistole Auricular
#define PAC       56 // Extrasistole Ventricular
#define ESCPV     57 // Ritmo de Escape Ventricular
#define AT        58 // Taquicardia Auricular
#define TORSADA1  60 // Torsada de Puntas
#define FA1       70 // Fibrilacion Auricular 1
#define FA2       71 // Fibrilacion Auricular 2
#define FV1       80 // Fibrilacion Ventricular 1
#define FV2       90 // Fibrilacion Ventricular 2


// *** CODIGOS COMANDO CAMBIO PARAMETRO
#define cRitmo 100          // Cambiar ritmo cardiaco
#define cIniciaArduino  50  // Inicializar Arduino
#define cFrecCardiaca  200  // Cambiar Frecuencia cardiaca
#define cIntervaloPR   201  // Cambiar Intervalo PR
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

// *** Nivel isolectrico ritmo sinusal
#define nivelIso  963

// ***Cantidad de bytes a leer en el buffer de lectura
#define lenghtBytesRX 5




// VARIABLES GLOBALES
// ********************************************************************

short ritmo;       // Tipo de ritmo actual
short ritmoPrevio; // tipo de ritmo previa (usada en PVC y PAC)


// *** Nº DE MUESTRAS DE LOS VECTORES DE SEÑALES
// La NSamples equivale a la duracion en ms, dado que cada muestra se entrega al conversor D/A cada 1ms
// Cada dato de la senial ocupa 2bytes, por eso hay que divider por 2
unsigned int NSamples_tv1 = sizeof(tv1_data) / 2;
unsigned int NSamples_tv2 = sizeof(tv2_data) / 2;
unsigned int NSamples_tv3 = sizeof(tv3_data) / 2;
unsigned int NSamples_fv1 = sizeof(fv1_data) / 2;
unsigned int NSamples_fv2 = sizeof(fv2_data) / 2;
unsigned int NSamples_p2 = sizeof(p2_data) / 2;
unsigned int NSamples_qrs2 = sizeof(qrs2_data) / 2;
unsigned int NSamples_t2 = sizeof(t2_data) / 2;
unsigned int NSamples_pvc = sizeof(pvc_data) / 2;

// Contadores (corren durante el estado)
unsigned int  QRSCount = 0;         // Contador(ms) QRS actual                          
unsigned int  IdleCount = 0;        // Contador(ms) Periodo IDLE actual
unsigned int  IdleCount_FA1 = 0;    //                         
unsigned int  IdleCount_FA2 = 0; 

// Duraciones en ms de los periods
unsigned long IdlePeriod;           // Desde el final de la P al inicio del QRS
unsigned int  IdlePeriod_FA1 = 100; //                             
unsigned int  IdlePeriod_FA2 = 100; //                             

// Estado inicial
unsigned int  State = INIT;

// Valor para recargar el Timer2
unsigned int  tcnt2;          

// *** Variable donde almaceno lo leido en pto serie
byte datoLeido;

// *** Bufer lectura
int rxBuffer[]={0,0,0,0,0};
int rxIndex =0;

// Comandos recibidos
int codigoComando; // Codigo comando
int valorComando;  // Valor asociado al comando

//ATENUADORES: Valor (0: no atenuacion, 1: max atenuacion)
// Valor positivo: atenua. Valor negativo: amplifica
float atenuadorP; //-0.8;
float atenuadorQRS;  // En este caso no debemos amplificar. Satura el D/A
float atenuadorT;//-0.9;
float atenuadorSenial; //afecta a toda la senialf
float atenuadorRS;
float atenuadorFA1 = 0.5;
float atenuadorFA2 = 0.5;
float atenuadorTV1 = 0.3;
float atenuadorTV2 = 1;
float atenuadorTV3 = 0.4;
float atenuadorFV1 = 0.15;
float atenuadorFV2 = 0.3;

int  delta; // Valor a restar para producir la atenuación
int  deltaRS; // Valor a restar para producir la atenuación total

// ***Parametros iniciales del Ritmo Sinusal (ms=)
unsigned int  PR_SEG_Count = 0;
unsigned long PR_SEG_Period; 
unsigned int  ST_SEG_Count = 0;
unsigned long ST_SEG_Period;
unsigned long IDLEpostPVC = 200;
unsigned long IDLEpostPAC = 200;
unsigned long IdlePeriodTA = 0;
unsigned long IdlePeriodEscV = 0;

unsigned long muestraEscalada=0; //

// Valor inical del aleatorizador
int randomSeeder = 5;






// FUNCION DE CONFIGURACION
// ****************************************
void setup()   { 

  // *** VELOCIDAD DEL PUERTO SERIE
  // NOTA: Configurar la misma velocidad en la ventana 'Monitor Serial" 
  Serial.begin(57600);
  Serial.println("Velocidad del puerto serie configurada");
  
  
  // *** PARAMETROS INICIALES
  
  // Ritmo inicial: Ritmo Sinusal(RS) a 60lpm
  ritmo=SINUSAL0;
  // Calculo de segmento PR
  PR_SEG_Period= 100-NSamples_p2;  // PR_SEG_Period = PRde100ms - NSamples_p2 (57); 
  // Calculo del segmento ST
  ST_SEG_Period= 200-NSamples_qrs2-NSamples_t2; //ST_SEG_Period = QTde200ms-NSamples_qrs2-NSamples_t2; 
  // Calculo del periodo Idle para tener ritmo inicial de 60lpm: Idle=(60000/HR)-PR-QT
  IdlePeriod = (60000/60)-100-200; 
  
  // Valores inicales para los atenuadores de ondas P, QRS, T y OndaCompleta
  atenuadorP= 0.5;
  atenuadorQRS= 0.1;
  atenuadorT= -0.8;
  atenuadorRS=1;

  delta = 0;
  deltaRS = 0;
   

  // *** CONFIGURACION DE PINES E/S

  // Configuro los ptos de salida (Soporte SPI D/A)
  // *** En Arduino Mega:
  pinMode(10, OUTPUT);                    // D/A (DAC) chip select (low para seleccionar chip) 
  pinMode(51, OUTPUT);                    // SDI data 
  pinMode(52, OUTPUT);                    // SCK clock


  // *** INICIALIZACION DEL INTERFAZ SPI

  SPI.begin();                            // Despertamos el bus SPI
  SPI.setDataMode(0);                     // Modo: CPHA=0, dato capturado en flanco de subida del reloj (low→high)
  SPI.setClockDivider(SPI_CLOCK_DIV64);   // Reloj del sistema / 64
  SPI.setBitOrder(MSBFIRST);              // Bit 7 sale primero


  // *** ACTIVACION DE GENERADOR DE NUMEROS ALEATORIOS (PARA LA 'FA')

  //Selecciono una entrada analógica no usada como fuente aleatoria
  randomSeed(analogRead(randomSeeder));
 
 
  // *** CONFIGURACION A BAJO NIVEL DE LOS CONTADORES
  // Microcontrolador ATMEL: ATMEGA328P 
  // http://www.atmel.com/devices/atmega328p.aspx
  // En primer lugar desactivamos la interrupcion de 'timer overflow' mientras lo configuramos
  TIMSK2 &= ~(1<<TOIE2);

  // Configuramos el timer2 en modo normal (contador puro, no PWM...)
  TCCR2A &= ~((1<<WGM21) | (1<<WGM20));
  TCCR2B &= ~(1<<WGM22);

  // Seleccionamos el reloj fuente: reloj I/O interno  
  ASSR &= ~(1<<AS2);

  // Desactivamos 'Compare Match A interrupt enable' (solo queremos overflow) 
  TIMSK2 &= ~(1<<OCIE2A);

  // Configuramos el escalado del reloj de CPU divido por 128  
  TCCR2B |= (1<<CS22)  | (1<<CS20); // Set bits
  TCCR2B &= ~(1<<CS21);             // Clear bit

  // Queremos un contador que expire cada 1ms, que es el tiempo cada cuanto sacamos una muestra
  // Cuando el contador expire, se llamara a la ISR (Interupt Service Routine)
  //
  // Necesitamos calcular un valor apropiado para cargar en el contador Timer 2
  // Cargamos el valor 131 en el registro del contador Timer 2 (tcnt2)
  // Los calculos son: (Frecuencia CPU) / (valor prescaler) = 125000 Hz = 8us.
  // (periodo deseado) / 8us = 125.
  // MAX(uint8) + 1 - 125 = 131;
  // 
  // Guardamos el valor globalmente para luego recargarlo en ISR
  tcnt2 = 131; 

  // Finalmente cargamos y activamos el timer 
  TCNT2 = tcnt2;
  TIMSK2 |= (1<<TOIE2);
} 





// BUCLE PRINCIPAL
// ****************************************
void loop() {
  

  // *** Lectura pto serie
  if (Serial.available() > 0) {
     
     rxBuffer[rxIndex++] = Serial.read();
     Serial.println("Datos leidos:");
     
     //Cuando recibimos 5 bytes, se completa el código del comando
     if(rxIndex==lenghtBytesRX){
       
       rxIndex=0;
       /*
       Serial.println(rxBuffer[0], DEC);
       Serial.println(rxBuffer[1], DEC);  
       Serial.println(rxBuffer[2], DEC);
       Serial.println(rxBuffer[3], DEC);
       Serial.println(rxBuffer[4], DEC);
       */
    
       
       // Decodificamos comando.
       // Byte 0:código comando. Bytes 1-4:valor
       // Paso los 4 bytes que contienen el valor a un entero
       codigoComando = rxBuffer[0];
       valorComando =   ( (int)rxBuffer[1] ) <<24; //Rotacion a izq de 24 bits 
       valorComando |=  ( (int)rxBuffer[2] ) <<16;
       valorComando |=  ( (int)rxBuffer[3] ) <<8;
       valorComando |=  rxBuffer[4];
       
       Serial.println("");
       Serial.println("Comando recibido...");
       //Serial.println(valorComando);
       //Serial.println(codigoComando);
       
       
       
       
       // Decodificacion del comando/valor recibido
       switch (codigoComando){
 
         case cIniciaArduino:
          Serial.print("#INICIALIZANDO ARDUINO: ");
           Serial.print(valorComando);
           Serial.println("  $"); //Envio senial fin de comando
           break;  
           
         case cRitmo:
           Serial.print("#CAMBIO TIPO DE RITMO CARDIACO: ");
           Serial.print(valorComando);
           //almaceno el ritmo previo al cambio si es distinto al que tenia 
           if(valorComando!=ritmo){
              ritmoPrevio=ritmo;        
           }
           ritmo = valorComando;
           State = INIT; //Inicializo el estado de las maquinas de estado
           Serial.println("  $"); //Envio senial fin de comando
           break;

         case cFrecCardiaca:
           Serial.print("#CAMBIO VALOR FREC. CARDIACA: ");
           Serial.print(valorComando);
           
           //FC = 60000/(PR+QT+Idle)
           //Idle = (60000/FC) - PR - QT
           IdlePeriod = (60000/valorComando)-(PR_SEG_Period+NSamples_p2)-(ST_SEG_Period+NSamples_qrs2+NSamples_t2);
           Serial.println("  $");
           break;
 
         case cIntervaloPR:
           Serial.print("#CAMBIO VALOR INTERV. PR: ");
           Serial.print(valorComando);
           //El segmento PR = Interv PR - ancho onda P
           PR_SEG_Period = valorComando-NSamples_p2;
           Serial.println("  $");
           break;
           
         case cIntervaloST:
           Serial.print("#CAMBIO VALOR INTERV. ST: ");
           Serial.print(valorComando);
           //El segmento ST = Interv QT - ancho onda QRS - ando onda T
           ST_SEG_Period = valorComando-NSamples_qrs2-NSamples_t2;           
           Serial.println("  $");
           break;

         case cAmplitudP:
           Serial.print("#CAMBIO VALOR AMPLITUD P: ");
           Serial.print(valorComando);
           //atenuadorP=map(valorComando, 0, 4, 1.0, -3.0);
           
           //return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
           atenuadorP=(valorComando-0)*(-1.0-1.0)/(8.0-0)+1.0;
           Serial.println("  $");
           Serial.print("Valor mapeado en Arduino: ");
           Serial.println(atenuadorP);
           break;
           
         case cAmplitudR:
           Serial.print("#CAMBIO VALOR AMPLITUD R: ");
           Serial.print(valorComando);
           atenuadorQRS = 1-(float(valorComando) / 10.0);
           //map(valorComando, 1, 10, -1.0, 1.0);
           Serial.println("  $");
           Serial.print("Valor mapeado en Arduino: ");
           Serial.println(atenuadorQRS);
           break;
  
         case cAmplitudT:
           Serial.print("#CAMBIO VALOR AMPLITUD T: ");
           Serial.print(valorComando);
           atenuadorT=map(valorComando, 0, 5, 1.0, -4.0);
           //Serial.println(atenuadorT);
           Serial.println("  $");
           Serial.print("Valor mapeado en Arduino: ");
           Serial.println(atenuadorT);
           break; 
           
         case cAmplitudRS:
           Serial.print("#CAMBIO VALOR AMP. RITMO SINUSAL: ");
           Serial.print(valorComando);
           //return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
           atenuadorRS=(valorComando-0)*(1.1-0)/(100.0-0)+0;
           Serial.println("  $");
           Serial.print("Valor mapeado en Arduino: ");
           Serial.println(atenuadorRS);
           break;        
               
         case cValorSenial:
           Serial.print("#CAMBIO VALOR SENIAL: ");
           Serial.print(valorComando);
           atenuadorSenial=map(valorComando, 1, 100, 100000, 10000);
           Serial.println("  $");
           Serial.print("Valor mapeado en Arduino: ");
           Serial.println(atenuadorSenial);
           break;        
         
         case cPausaTrasPVC:
           Serial.print("#CAMBIO VALOR PAUSA TRAS PVC: ");
           Serial.print(valorComando);
           IDLEpostPVC = valorComando;
           Serial.println("  $");
           break;
           
         case cCambioFrecTA:
           Serial.print("#CAMBIO VALOR FRECUENCIA DE LA TA: ");
           Serial.print(valorComando);
           //Asumimos segPR y segQT =0 en la TA
           IdlePeriodTA = (60000/valorComando)-NSamples_p2-NSamples_qrs2-NSamples_t2;
           Serial.println("  $");
           break;
  
          case cCambioFrecRV:
           Serial.print("#CAMBIO VALOR FRECUENCIA DE ESCAPE VENTRICULAR: ");
           Serial.print(valorComando);
           IdlePeriodEscV = (60000/valorComando)-NSamples_pvc;
           Serial.println("  $");
           break;  

           
         default:
           break;  
       } // end switch
       
       
     } // end if
     
  } // end if
    
}





// INTERRUPT SERVICE ROUTINE del contador Timer2
// Llamada cada 1.000 msec. (que es cuando se produce el overflow del contador)
// ********************************************************************************
ISR(TIMER2_OVF_vect) {
  
  // Recargamos el contador   
  TCNT2 = tcnt2;
  
  // *** Segun el ritmo seleccionado, usamos un maquina de estados y otra
  switch (ritmo){
    
    // Asistolia (sin ritmo)
    case ASISTOLIA:
      switch (State) {
          case INIT:
            // zero the QRS and IDLE counters
            QRSCount = 0;  
            // set next state to QRS  
            State = SENIAL;
            break;
            
          case SENIAL:
            DTOA_Send(p2_data[0]);
            break;
            
          default:
            break;
      }
      break;
      
      
    // Ritmo Sinusal
    case SINUSAL0:
      switch(State){
        
        case INIT:
             QRSCount = 0;
             IdleCount = 0;
             State = P;
             break;
             
        case P:
             delta=(p2_data[QRSCount]-nivelIso)*atenuadorP;
             muestraEscalada = (p2_data[QRSCount]-delta-nivelIso)*atenuadorRS+nivelIso;
             DTOA_Send(muestraEscalada);
             
             QRSCount++;
             if (QRSCount >= NSamples_p2) {
               QRSCount = 0;
               DTOA_Send(p2_data[0]);
               State = PR_SEG;
             }
             break;
             
        case PR_SEG:
             PR_SEG_Count++;
             if (PR_SEG_Count >= PR_SEG_Period) {
               PR_SEG_Count = 0;
               State = QRS;
               //digitalPot5k.setPosition(1,300);
             } 
             break;
             
        case QRS:
        

              
             delta=(qrs2_data[QRSCount]-nivelIso)*atenuadorQRS;
             muestraEscalada = (qrs2_data[QRSCount]-delta-nivelIso)*atenuadorRS+nivelIso;
             DTOA_Send(muestraEscalada);
             
             QRSCount++;
             if (QRSCount >= NSamples_qrs2) {
               QRSCount = 0;
               DTOA_Send(qrs2_data[0]);
               State = ST_SEG;
 
             }
             break;
             
        case ST_SEG:
             ST_SEG_Count++;
             if (ST_SEG_Count >= ST_SEG_Period) {
               ST_SEG_Count = 0;
               State = T;
             } 
             break;
             
        case T:
             delta=(t2_data[QRSCount]-nivelIso)*atenuadorT;  
             muestraEscalada = (t2_data[QRSCount]-delta-nivelIso)*atenuadorRS+nivelIso;
             DTOA_Send(muestraEscalada);
         
             QRSCount++;
             if (QRSCount >= NSamples_t2) {
               QRSCount = 0;
               DTOA_Send(t2_data[0]);
               State = IDLE;
             }
             break;
             
        case IDLE:
             IdleCount++;
             if (IdleCount >= IdlePeriod) {
                IdleCount = 0;
                State = P;
             } 
             break;   
      }
      break;
      
      
    // Fibrilacion Auricular 1  
    case FA1:
     switch(State){
        
        case INIT:
             QRSCount = 0;
             IdleCount = 0;
             State = QRS;
             ST_SEG_Period=10;
             break;

        case QRS:
             delta=(qrs2_data[QRSCount]-nivelIso)*atenuadorQRS;
             DTOA_Send((qrs2_data[QRSCount]-delta)*atenuadorFA1);
             QRSCount++;
             if (QRSCount >= NSamples_qrs2) {
               QRSCount = 0;
               DTOA_Send(qrs2_data[0]*atenuadorFA1);
               State = ST_SEG;
             }
             break;
             
        case ST_SEG:
             ST_SEG_Count++;
             if (ST_SEG_Count >= ST_SEG_Period) {
               ST_SEG_Count = 0;
               State = T;
             } 
             break;
             
        case T:
             DTOA_Send(t2_data[QRSCount]*atenuadorFA1);
             QRSCount++;
             if (QRSCount >= NSamples_t2) {
               QRSCount = 0;
               DTOA_Send(t2_data[0]*atenuadorFA1);
               IdlePeriod_FA1 = random(10,120);
               State = IDLE_FA1;
             }
             break;
             
        case IDLE_FA1:
             IdleCount_FA1++;
             if (IdleCount_FA1>= IdlePeriod_FA1) {
                IdleCount_FA1 = 0;
                State = QRS;
             } 
             break;   
      }
      break;


     // Fibrilacion Auricular 2
     case FA2:
      switch(State){
        
        case INIT:
             QRSCount = 0;
             IdleCount = 0;
             State = QRS;
             ST_SEG_Period=20;
             break;

        case QRS:
             delta=(qrs2_data[QRSCount]-nivelIso)*atenuadorQRS;
             DTOA_Send((qrs2_data[QRSCount]-delta)*atenuadorFA2);
             QRSCount++;
             if (QRSCount >= NSamples_qrs2) {
               QRSCount = 0;
               DTOA_Send(qrs2_data[0]*atenuadorFA2);
               State = ST_SEG;
             }
             break;
             
        case ST_SEG:
             ST_SEG_Count++;
             if (ST_SEG_Count >= ST_SEG_Period) {
               ST_SEG_Count = 0;
               State = T;
             } 
             break;
             
        case T:
             DTOA_Send(t2_data[QRSCount]*atenuadorFA2);
             QRSCount++;
             if (QRSCount >= NSamples_t2) {
               QRSCount = 0;
               DTOA_Send(t2_data[0]*atenuadorFA2);
               IdlePeriod_FA2 = random(50,160);
               State = IDLE_FA2;
             }
             break;
             
        case IDLE_FA2:
             IdleCount_FA2++;
             if (IdleCount_FA2>= IdlePeriod_FA2) {
                IdleCount_FA2 = 0;
                State = QRS;
             } 
             break;   
      }
      break;
      
      
   // Taquicardia Ventricular 1
    case TV1:
      switch (State) {
          case INIT:
            // zero the QRS and IDLE counters
            QRSCount = 0;  
            // set next state to QRS  
            State = SENIAL;
            break;
            
          case SENIAL:
            DTOA_Send(tv1_data[QRSCount]*atenuadorTV1);
            QRSCount++;
            if (QRSCount >= NSamples_tv1) {
              // start IDLE period and output first sample to DTOA
              QRSCount = 0;
              DTOA_Send(tv1_data[0]*atenuadorTV1);
            }
            break;
            
          default:
            break;
      }
      break;
    
    
      // Taquicardia Ventricular 2
      case TV2:
      switch (State) {
          case INIT:
            // zero the QRS and IDLE counters
            QRSCount = 0;  
            // set next state to QRS  
            State = SENIAL;
            break;
            
          case SENIAL:
            DTOA_Send(tv2_data[QRSCount]*atenuadorTV2);
            QRSCount++;
            if (QRSCount >= NSamples_tv2) {
              QRSCount = 0;
              DTOA_Send(tv2_data[0]*atenuadorTV2);
            }
            break;
            
          default:
            break;
      }
      break;
      
    
      case TV3:
      switch (State) {
          case INIT:
            // zero the QRS and IDLE counters
            QRSCount = 0;  
            // set next state to QRS  
            State = SENIAL;
            break;
            
          case SENIAL:
            DTOA_Send(tv3_data[QRSCount]*atenuadorTV3);
            QRSCount++;
            if (QRSCount >= NSamples_tv3) {
              QRSCount = 0;
              DTOA_Send(tv3_data[0]*atenuadorTV3);
            }
            break;
            
          default:
            break;
      }
      break;
    
      
      // Fibrilacion Ventricular 1
      case FV1:
        switch (State) {
          case INIT:
            // zero the QRS and IDLE counters
            QRSCount = 0;  
            // set next state to QRS  
            State = SENIAL;
            break;
          
          case SENIAL:
            // output the next sample in the QRS waveform to the D/A converter 
            DTOA_Send(fv1_data[QRSCount]*atenuadorFV1);
            // advance sample counter and check for end
            QRSCount++;
            if (QRSCount >= NSamples_fv1) {
              // start IDLE period and output first sample to DTOA
              QRSCount = 0;
              DTOA_Send(fv1_data[0]*atenuadorFV1);
            }
            break;
 
          default:
            break;
      }
      break;   
      
      
      // Fibrilacion Ventricular 2
      case FV2:
        switch (State) {
          case INIT:
            // zero the QRS and IDLE counters
            QRSCount = 0;  
            // set next state to QRS  
            State = SENIAL;
            break;
          
          case SENIAL:
            // output the next sample in the QRS waveform to the D/A converter 
            DTOA_Send(fv2_data[QRSCount]*atenuadorFV2);
            // advance sample counter and check for end
            QRSCount++;
            if (QRSCount >= NSamples_fv2) {
              // start IDLE period and output first sample to DTOA
              QRSCount = 0;
              DTOA_Send(fv2_data[0]*atenuadorFV2);
            }
            break;
 
          default:
            break;
      }
      break;
     
     
     // Extrasistole Ventricular
      case PVC:
      switch (State) {
          case INIT:
            // zero the QRS and IDLE counters
            IdleCount = 0;
            QRSCount = 0;  
            // set next state to QRS  
            State = SENIAL;
            break;
            
          case SENIAL:
            DTOA_Send(pvc_data[QRSCount]); //*atenuadorTV3);
            QRSCount++;
            if (QRSCount >= NSamples_pvc) {
              QRSCount = 0;
              DTOA_Send(pvc_data[0]);//*atenuadorTV3);
              State = postPVC_SEG;
            }
            break;
            
          case postPVC_SEG:
             IdleCount++;
             if (IdleCount >= IDLEpostPVC) {
                IdleCount = 0;
                State = INIT;
                ritmo = ritmoPrevio;
             } 
             break;   
            
          default:
            break;
      }
      break; 
      
      
      // Extrasistole Auricular
      case PAC:
       switch(State){
        case INIT:
             QRSCount = 0;
             IdleCount = 0;
             State = P;
             break;
             
        case P:
             DTOA_Send(p2_data[QRSCount]);
             QRSCount++;
             if (QRSCount >= NSamples_p2) {
               QRSCount = 0;
               DTOA_Send(p2_data[0]);
               State = QRS;
             }
             break;
             
        case QRS:    
             DTOA_Send(qrs2_data[QRSCount]);
             QRSCount++;
             if (QRSCount >= NSamples_qrs2) {
               QRSCount = 0;
               DTOA_Send(qrs2_data[0]);
               State = T;
             }
             break;
             
        case T:
             DTOA_Send(t2_data[QRSCount]);
             QRSCount++;
             if (QRSCount >= NSamples_t2) {
               QRSCount = 0;
               DTOA_Send(t2_data[0]);
               State = postPAC_SEG;
             }
             break;
             
        case postPAC_SEG:
             IdleCount++;
             if (IdleCount >= IDLEpostPAC) {
                IdleCount = 0;
                State = INIT;
                ritmo = ritmoPrevio;
             } 
             break;    
      }
      break; 
      
    
    // Taquicardia Auricular  
    case AT:
      switch(State){
        case INIT:
             QRSCount = 0;
             IdleCount = 0;
             State = P;
             break;
             
        case P:
             DTOA_Send(p2_data[QRSCount]);
             QRSCount++;
             if (QRSCount >= NSamples_p2) {
               QRSCount = 0;
               DTOA_Send(p2_data[0]);
               State = QRS;
             }
             break;
             

        case QRS: 
             muestraEscalada = (qrs2_data[QRSCount]-delta-nivelIso)*0.5+nivelIso;
             DTOA_Send(muestraEscalada);
             //DTOA_Send(qrs2_data[QRSCount]);
             
             QRSCount++;
             if (QRSCount >= NSamples_qrs2) {
               QRSCount = 0;
               DTOA_Send(qrs2_data[0]);
               State = T;
             }
             break;
             
        case T:
             DTOA_Send(t2_data[QRSCount]);
             QRSCount++;
             if (QRSCount >= NSamples_t2) {
               QRSCount = 0;
               DTOA_Send(t2_data[0]);
               State = IDLE;
             }
             break;
             
        case IDLE:
             IdleCount++;
             if (IdleCount >= IdlePeriodTA) {
                IdleCount = 0;
                State = P;
             } 
             break;   
      }
      break;
      
      
    // Ritmo de escape Ventricular        
    case ESCPV:
      switch(State){
        
        case INIT:
             QRSCount = 0;
             IdleCount = 0;
             State = SENIAL;
             break;
             
        case SENIAL:
            DTOA_Send(pvc_data[QRSCount]);
            QRSCount++;
            if (QRSCount >= NSamples_pvc) {
              QRSCount = 0;
              DTOA_Send(pvc_data[0]);
              State = IDLE;
            }
            break;
             
        case IDLE:
             IdleCount++;
             if (IdleCount >= IdlePeriodEscV) {
                IdleCount = 0;
                State = SENIAL;
             } 
             break;   
      }
      break;
      
  }//end switch SENIAL
}  





// Envio del valor (DtoAValue) al 'Microchip MCP4921 D/A converter ( 0 .. 4096 ) de 12 bits'
// Formato de la trama:
//            |--------|--------|--------|--------|--------------------------------------------------|
//            |  A/B   |   BUF  |  GA    | SHDN   | D11 D10 D09 D08 D07 D06 D05 D04 D03 D02 D01 D00  |
//            |        |        |        |        |                                                  |
//            |setting:|setting:|setting:|Setting:|            DtoAValue   (12 bits)                 |
//            |   0    |   0    |   1    |   1    |                                                  |
//            | DAC-A  |unbuffer|   1x   |power-on| ( 0 .. 4096  will output as 0 volts .. 5 volts ) |
//            |--------|--------|--------|--------|--------------------------------------------------|
//                15      14        13       12    11                                               0
//  To D/A    <======================================================================================
//
// ***************************************************************************************************
void  DTOA_Send(unsigned short DtoAValue) {
  
  byte            Data = 0;
  // Seleccion del chip D/A (low)
  digitalWrite(10, 0);   
  
  // Enviamos el byte de mayor peso primero 0011xxxx
  Data = highByte(DtoAValue);
  Data = 0b00001111 & Data;
  Data = 0b00110000 | Data;
  SPI.transfer(Data);
  
  // Luego elbyte de menor peso xxxxxxxx
  Data = lowByte(DtoAValue);
  SPI.transfer(Data);
 
  // Una vez terminada la transmision, deseleccionamos el chip D/A (high),
  // lo que hace que se actualice el D/A con el nuevo valor
  digitalWrite(10, 1);    
}





















