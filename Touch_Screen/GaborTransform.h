/*void init_ComplexExp();
void init_GaborWindow();
void init_Data();
void DFT();
void GaborTransform();
void GaborTransformData(float H[]);
*/

#define array_size 43

////////////Everything below this line should go into GaborTransform.c when ready and that I understand cmake files. 

#include <avr/pgmspace.h>
#include <UTFTGLUE.h>  
#include "ADC.h"
#include <math.h>
#include "Memory.h"
//#define PI M_PI
#define exp M_E
#define BAUD  9600
#define clock_speed  16000000
#include <util/delay.h>
#define UBRRX  ((clock_speed/16/BAUD) -1)
 


int Q = 1;
int N = array_size;
float X[array_size][2];
//float G[array_size];

//float MagSf[array_size][array_size];
//float Mfft[array_size];



void init_Data(){
//data where n is the time index
	for (int n = 0; n < N; ++n)
	{
		X[n][0] = 2.5*sin(2.0*2*PI*n/N) + 10.0* pow(exp,-1*pow((n-N/4),2)) ;//+ 9.0*cos(16*PI*PI*n/N);
		X[n][1] = 2.5*sin(16*2*PI*n/N) + 7.0* pow(exp,-1*pow((n-7*N/8),2)) ;//+ 9.0*cos(16*PI*PI*n/N);
		//X[n] = 5.0 + sinh(2.0*n/N);
		//X[n] = 5.0 + 3.0*cos(4*PI*n/N + 12.0*cos(4*PI*n/N));
	}
}

/*void DFT(float X[array_size][2]){
	for (int j = 0; j < N; ++j){
		X[j][!Q] = read_ADC()*0.01953125;
		float Sum[] = {0.0,0.0};
	
		for (int i = 0; i < N; ++i)
			{
				Sum[0] = X[i][Q]*C[i][j] + Sum[0];
				Sum[1] = X[i][Q]*S[i][j] + Sum[1];
	 	 
			}
				//Rfft[j] = Sum[0];
				//Ifft[j] = Sum[1];
			Mfft[j] = 2*sqrt(pow(Sum[0],2) + pow(Sum[1],2))/N;
		}
	Mfft[0] = Mfft[0]/2;
}*/

/*// n is the time index
// l is the frequency index
// m is the center of the time window
//pow(exp,-1*pow((n-m),2)) // Gabor window
	for (int m = 0; m < N; ++m)
	{
		X[m][!Q] = read_ADC()*0.01953125;
		for (int l = 0; l < N; ++l)
			{	double Sum[] = {0.0,0.0};

			for (int n = 0; n < N; ++n)
				{
				//X[n] is limited by the ammount of SRAM I have
				// integrating the real part
				Sum[0] = X[n][Q]*pow(exp,-1*pow((n-m),2))*C[n][l] + Sum[0];
				// integrating the imaginary part
				Sum[1] = X[n][Q]*pow(exp,-1*pow((n-m),2))*S[n][l] + Sum[1];
 	 
				}
			// The divide by N here is the dt of the integral
			// This can be as big as I want it to be if I don't store it and just write it to the display.
			//MagSf[m][l] = 2*sqrt(pow(Sum[0],2) + pow(Sum[1],2))/N;
			uint8_t d = 40*sqrt(pow(Sum[0],2) + pow(Sum[1],2))/N;
			

			}
			//MagSf[m][0] = MagSf[m][0]/2; 
	}
}*/
