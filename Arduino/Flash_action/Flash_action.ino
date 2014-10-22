int led = 13;

void setup() {
  // initialize serial:
  Serial.begin(9600);
  pinMode(led, OUTPUT);     
}

void loop() {
  // print the string when a newline arrives:
  digitalWrite(led, HIGH);   // turn the LED on (HIGH is the voltage level)
  Serial.println(1); 
  delay(500);               // wait for a second
  digitalWrite(led, LOW);    // turn the LED off by making the voltage LOW
  delay(10000);               // wait for a second
}
