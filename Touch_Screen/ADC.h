

static void ADC0_init (void)
{
	DDRC &= (1 << DDC5);
    ADMUX = (1 << REFS0)|(1 << MUX0)|(1 << MUX2 )|(1 << ADLAR);
	ADCSRA = (1 << ADEN)|(1 << ADPS0)|(1 << ADPS1)|(1 << ADPS2);
	

    
}

static uint8_t read_ADC(void)
{
    ADCSRA |= (1 << ADSC);
    loop_until_bit_is_clear(ADCSRA, ADSC);
    return ADCH;
}