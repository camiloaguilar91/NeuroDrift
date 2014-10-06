int input = 0; 

void setup(){
 Serial.begin(9600); 
 pinMode(input, INPUT);
}


void loop()
{
  int array[500];
  int i = 0;
  for(i=0; i<500; i++){ 
    array[i] = (analogRead(input));
    delay(1); 
  }
  for(i=0; i<500; i++) 
    Serial.println(array[i]);
    
    
  
}
