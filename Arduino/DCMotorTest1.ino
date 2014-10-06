/*
Edited by Cesar Becerril
For use with the Adafruit Motor Shield v2 
---->	http://www.adafruit.com/products/1438
HC-SR04:
VCC = 5V
GND = GND
Echo = Pin7
Trig = Pin8
*/

#include <Wire.h>
#include <Ultrasonic.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_PWMServoDriver.h"

Ultrasonic ultrasonic(5,6);
//#define echoPin 7
//#define trigPin 8
//#define LEDPin 13

// Create the motor shield object with the default I2C address
Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 
// Or, create it with a different I2C address (say for stacking)
// Adafruit_MotorShield AFMS = Adafruit_MotorShield(0x61); 

// Select which 'port' M1, M2, M3 or M4. In this case, M1
Adafruit_DCMotor *M1 = AFMS.getMotor(1);
Adafruit_DCMotor *M2 = AFMS.getMotor(2);
//Adafruit_DCMotor *M3 = AFMS.getMotor(3);
//Adafruit_DCMotor *M4 = AFMS.getMotor(4);

void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("Adafruit Motorshield v2 - DC Motor test!");
  
  pinMode(4, OUTPUT);
  pinMode(7, INPUT);
//  pinMode(LEDPin, OUTPUT);
  AFMS.begin();  // create with the default frequency 1.6KHz
  //AFMS.begin(1000);  // OR with a different frequency, say 1KHz
  
  // Set the speed to start, from 0 (off) to 255 (max speed)
  M1->setSpeed(150);
  M1->run(FORWARD);
  // turn on motor
  M1->run(RELEASE);
}

void loop() {
  uint8_t i;
  int duration, distance, pos=0,x;

  digitalWrite(8,LOW);
  delay(2);
  digitalWrite(8,HIGH);
  delay(10);
  digitalWrite(8,LOW);
  Serial.print(ultrasonic.Ranging(CM));
  Serial.println(" cm");
  if(ultrasonic.Ranging(CM) <= 20 && ultrasonic.Ranging(CM) >=10){
    Serial.print("Motor ON");
    M1->run(FORWARD);
    M2->run(FORWARD);
    for (i=0; i<255; i++) {
      M1->setSpeed(i);  
      M2->setSpeed(i);  
      delay(10);
    }
    for (i=255; i!=0; i--) {
      M1->setSpeed(i); 
      M2->setSpeed(i);   
      delay(10);
    }
  }
  else{
    Serial.print("Motor OFF");
    M1->setSpeed(0);  
    M2->setSpeed(0);  
    delay(10);
  }
/*    
  Serial.print(" tick ");
  Serial.print(ultrasonic.Ranging(CM));
  Serial.println(" cm");
  delay(10);
  M1->run(FORWARD);
  M2->run(FORWARD);
  for (i=0; i<255; i++) {
    M1->setSpeed(i);  
    M2->setSpeed(i);  
    delay(10);
  }
  for (i=255; i!=0; i--) {
    M1->setSpeed(i); 
    M2->setSpeed(i);   
    delay(10);
  }
  
  Serial.print(" tock ");

  M1->run(BACKWARD);
  M2->run(BACKWARD);
  for (i=0; i<255; i++) {
    M1->setSpeed(i);  
    M2->setSpeed(i);  
    delay(10);
  }
  for (i=255; i!=0; i--) {
    M1->setSpeed(i);  
    M2->setSpeed(i);  
    delay(10);
  }

  Serial.print(" tech ");
  M1->run(RELEASE);
  M2->run(RELEASE);
  delay(1000);*/
}
