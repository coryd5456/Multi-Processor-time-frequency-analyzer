#include <UTFTGLUE.h> 
#include <avr/io.h>
#include <avr/interrupt.h>
#include "GaborTransform.h"
//#include "header/UART.h"
//#include <util/delay.h>
//char val[8];

//use GLUE class and constructor
UTFTGLUE myGLCD(0,A2,A1,A3,A4,A0); //all dummy args
uint8_t K = 8;
void setup() {
  // put your setup code here, to run once:
    //randomSeed(analogRead(0));
    //Serial.begin(9600);

   ADC0_init();
   init_Data();
   //usart_init();
  /*for (int i = 0; i < array_size; ++i)
{
  // X[i][Q]= read_ADC()*0.01953125;
    X[i][Q] = X[i][0];
}*/
// Setup the LCD
  myGLCD.InitLCD();
  myGLCD.clrScr();
}

void loop() {
  // put your main code here, to run repeatedly:
  //int buf[318];
  int x, x2;
  int y, y2;
  int r;
// n is the time index
// l is the frequency index
// m is the center of the time window
    for (int m = 0; m < N; ++m)
  {
    //X[m][!Q] = read_ADC()*0.01953125;
    for (int l = 0; l < N/2 +1; ++l)
      { double Sum[] = {0.0,0.0};

      for (int n = 0; n < N; ++n)
        {
        //X[n] is limited by the ammount of SRAM I have
        // integrating the real part
        Sum[0] = X[n][Q]*pow(exp,-1*pow((n-m)/K,2))*pgm_read_float(&C[n][l]) + Sum[0];
        // integrating the imaginary part
        Sum[1] = X[n][Q]*pow(exp,-1*pow((n-m)/K,2))*pgm_read_float(&S[n][l]) + Sum[1];
   
        }
      // The divide by N here is the dt of the integral
      // This can be as big as I want it to be if I don't store it and just write it to the display.
      //MagSf[m][l] = 2*sqrt(pow(Sum[0],2) + pow(Sum[1],2))/N;
       uint8_t  d = 300*sqrt(pow(Sum[0],2) + pow(Sum[1],2))/N;
       myGLCD.setColor(32 +d, d,255 - d);
       //myGLCD.drawPixel(m+40,l);
       //myGLCD.fillRect(x1,y1,x2,y2); fills diagonally
       myGLCD.fillRect(7*m +10,7*l +43,7*m+16,7*l +49);
       //myGLCD.fillRect(2*m + 2*N*w,2*l,2*m+1 +2*N*w,2*l+1);
      }
      //MagSf[m][0] = MagSf[m][0]/2; 
  }
  Q = ~Q;
  
  /*for (int i=0; i<240; i++)
  {
    for(int j=0; j<240; j++){
    //myGLCD.drawPixel(x,y);
    //myGLCD.drawPixel(R,G,B);(0-255)
    //y=119+(sin(((i*1.1)*3.14)/180)*(90-(80*w / 100)));
    myGLCD.setColor(d,0,0b01111010);
    myGLCD.drawPixel(j+40,i);
    }
  }*/
}
