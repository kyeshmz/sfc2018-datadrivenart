int sr_input;
void setup()
{
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(14, OUTPUT);
  pinMode(15, OUTPUT);
  pinMode(16, OUTPUT);
  pinMode(17, OUTPUT);
  pinMode(18, OUTPUT);
  pinMode(19, OUTPUT);
  Serial.begin(9600);
}
void loop()
{
  if (Serial.available() > 0)
  {
     sr_input = Serial.read();
     Serial.write(sr_input);
  
     if(sr_input == B00010000)  //0x10:IO7
     {
       digitalWrite(2, LOW);
     }
     if(sr_input == B00010001)  //0x11
     {
       digitalWrite(2, HIGH);
     }
     if(sr_input == B00010010)  //0x12:IO6
     {
       digitalWrite(3, LOW);
     }
     if(sr_input == B00010011)  //0x13
     {
       digitalWrite(3, HIGH);
     }
     if(sr_input == B00010100)  //0x14:IO5
     {
       digitalWrite(4, LOW);
     }
     if(sr_input == B00010101)  //0x15
     {
       digitalWrite(4, HIGH);
     }
     if(sr_input == B00010110)  //0x16:IO4
     {
       digitalWrite(5, LOW);
     }
     if(sr_input == B00010111)  //0x17
     {
       digitalWrite(5, HIGH);
     }
     if(sr_input == B00011000)  //0x18:IO3
     {
       digitalWrite(6, LOW);
     }
     if(sr_input == B00011001)  //0x19
     {
       digitalWrite(6, HIGH);
     }
     if(sr_input == B00011010)  //0x1A:IO2
     {
       digitalWrite(7, LOW);
     }
     if(sr_input == B00011011)  //0x1B
     {
       digitalWrite(7, HIGH);
     }
     if(sr_input == B00011100)  //0x1C:IO1
     {
       digitalWrite(8, LOW);
     }
     if(sr_input == B00011101)  //0x1D
     {
       digitalWrite(8, HIGH);
     }
     if(sr_input == B00011110)  //0x1E:IO0
     {
       digitalWrite(9, LOW);
     }
     if(sr_input == B00011111)  //0x1F
     {
       digitalWrite(9, HIGH);
     }
     if(sr_input == B00100000)  //0x20OI0
     {
       digitalWrite(10, LOW);
     }
     if(sr_input == B00100001)  //0x21
     {
       digitalWrite(10, HIGH);
     }
     if(sr_input == B00100010)  //0x22:OI1
     {
       digitalWrite(11, LOW);
     }
     if(sr_input == B00100011)  //0x23
     {
       digitalWrite(11, HIGH);
     }
     if(sr_input == B00100100)  //0x24:OI2
     {
       digitalWrite(19, LOW);
     }
     if(sr_input == B00100101)  //0x25
     {
       digitalWrite(19, HIGH);
     }
     if(sr_input == B00100110)  //0x26:OI3
     {
       digitalWrite(18, LOW);
     }
     if(sr_input == B00100111)  //0x27
     {
       digitalWrite(18, HIGH);
     }
     if(sr_input == B00101000)  //0x28:OI4
     {
       digitalWrite(17, LOW);
     }
     if(sr_input == B00101001)  //0x29
     {
       digitalWrite(17, HIGH);
     }
     if(sr_input == B00101010)  //0x2A:OI5
     {
       digitalWrite(16, LOW);
     }
     if(sr_input == B00101011)  //0x2B
     {
       digitalWrite(16, HIGH);
     }
     if(sr_input == B00101100)  //0x2C:OI6
     {
       digitalWrite(15, LOW);
     }
     if(sr_input == B00101101)  //0x2D
     {
       digitalWrite(15, HIGH);
     }
     if(sr_input == B00101110)  //0x2E:OI7
     {
       digitalWrite(14, LOW);
     }
     if(sr_input == B00101111) //0x2F
     {
       digitalWrite(14, HIGH);
     }
  }
}

