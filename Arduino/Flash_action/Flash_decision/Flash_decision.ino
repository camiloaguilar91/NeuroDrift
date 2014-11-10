int start_led = 13;
int led1 = 12;
int led2 = 11;
int random_num;

void setup() {
  // initialize serial:
  Serial.begin(9600);
  pinMode(start_led, OUTPUT);
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);       
}

void loop() {
  // print the string when a newline arrives:
 // digitalWrite(start_led, HIGH);   // turn the LED on (HIGH is the voltage level)
 // delay(500);               // wait for a second
//  digitalWrite(start_led, LOW);    // turn the LED off by making the voltage LOW
//  delay(2000);               // wait for a second
  random_num = random(0,100);
  if (random_num > 49)
  {
    digitalWrite(led1, HIGH);   // turn the LED on (HIGH is the voltage level)
    Serial.println(1); 
    delay(500);               // wait for a second
    digitalWrite(led1, LOW);    // turn the LED off by making the voltage LOW
    delay(9500);               // wait for a second
  }
  else
  {
    digitalWrite(led2, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(500);               // wait for a second
    digitalWrite(led2, LOW);    // turn the LED off by making the voltage LOW
    delay(9500);               // wait for a second
  }
}
