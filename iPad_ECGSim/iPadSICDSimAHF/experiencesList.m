//
//  experiencesList.m
//  iPadSICDSimAHF
//
//  Created by Alexis Herrera Febles on 21/08/14.
//  Copyright (c) 2014 Alexis Herrera Febles. All rights reserved.
//

#import "experiencesList.h"

@implementation experiencesList

@synthesize experiences=_experiences;

-(id) init{
    self = [super init];
    
    _experiences= [[NSMutableArray alloc] init];
    [self inicializarExperiencias];

    return self;
}



- (void) inicializarExperiencias{

    // Experiencia 1
    experience* experience1 = [[experience alloc] init];
    
    experience1.nombre =       @"The patient screening process, setup and induction";
    experience1.description =  @"In this experience you are going to practice the screening process. You will also setup the S-ICD after its implantation and will perform and induction test";
    experience1.areasAprendizaje = @"screening, S-ICD Setup, induction test";
    experience1.totalPuntos = [NSNumber numberWithInt:100];
    
    [self insertarExperience:experience1];
    
    
    
    // Experiencia 2
    experience* experience2 = [[experience alloc] init];
    
    experience2.nombre =       @"A patient that got a shock";
    experience2.description =  @"This patient attended the hospital for a follow-up because yesterday he got a shock. You will interrogate the device and analyse what happaned";
    experience2.areasAprendizaje = @"S-ICD follow-up, episode interpretation";
    experience2.totalPuntos = [NSNumber numberWithInt:150];
    
    [self insertarExperience:experience2];
    
    
    
    // Experiencia 3
    experience* experience3 = [[experience alloc] init];
    
    experience3.nombre =       @"Patient that changes its QRS morphology";
    experience3.description =  @"In this case we have a patient that some time after the implantation of the S-ICD suffered a changed if its QRS morpholy. Due to this, the patient got an inappropriate shock. You will learn how to solved this issue re-setting up the S-ICD";
    experience3.areasAprendizaje = @"inappropriate shock, S-ICD setup";
    experience3.totalPuntos = [NSNumber numberWithInt:200];
    
    [self insertarExperience:experience3];
    
    
    
    // Experiencia 4
    experience* experience4 = [[experience alloc] init];
    
    experience4.nombre =       @"Patient with big T-wave";
    experience4.description =  @"You will experience the efficacy of the new T-wave discriminator algorithm included in the last software upgrade SMR8";
    experience4.areasAprendizaje = @"inappropriate shock, T-wave discrimination, SMR8";
    experience4.totalPuntos = [NSNumber numberWithInt:200];
    
    [self insertarExperience:experience4];
    
}



- (void) insertarExperience:(experience*)experiencia{
    [_experiences addObject:experiencia];
}

@end
