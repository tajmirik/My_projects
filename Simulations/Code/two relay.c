#include <delay.h>
#include <mega32.h>
#include <alcd.h>
#define menu_page 1
#define relay_page 2
#define status_page 3
#define menu_key PINB.0
#define select_key PINB.1
#define status_key PINB.2
#define En_relay_1 PORTC.0
#define En_relay_2 PORTC.1
#define En_relay_3 PORTC.2
#define En_relay_4 PORTC.3
#define Read_relay_1 PINC.0
#define Read_relay_2 PINC.1
#define Read_relay_3 PINC.2
#define Read_relay_4 PINC.3
/////////////////////////////////////////////////
//just making change to check the git
//Functions
void lcd_start();
// Declare your global variables here
// for a comoon cathode sement:
//
unsigned char segment[]={0x3f,0x06,0x5b,0x4f, //0     1    2     3
                         0x66,0x6d,0x7d,0x07, //4     5   6      7
                            0x7f,0x4f,0X40};  //8   9     -

void main(void)
{
//////////////////////////////////////////////////////////////
// Declare your local variables here
unsigned char page_state,rly_pick=0;

//////////////////////////////////////////////////////////////
// Input/Output Ports initialization

DDRB=0XF8;
PORTB=0X07;
DDRC=0X0F;
PORTC=0X00;
DDRD=0XFF;
PORTD=segment[10];

///////////////////////////////////////////////////////////
lcd_start();

/////////////////////////////////////////////////////////////
page_state=menu_page;
while (1)
    {
    // Place your code here
/////////////////////////////////////////////////////////////////////////////////////////////////
    //Menu Key function:
    if (menu_key==0)
        {
        if (page_state==menu_page)
            {
            rly_pick++;
            rly_pick=rly_pick==5 ? 1 :rly_pick;
            }
        switch (page_state)
            {
            case relay_page:
                page_state=menu_page;


            case menu_page:
                {
                PORTD=segment[10];
                switch (rly_pick)
                    {
                    case 1:
                        lcd_clear();
                        lcd_puts("Relay-1 <=");
                        lcd_gotoxy(0,1);
                        lcd_puts("Relay-2 ");
                        break;
                    case 2:
                        lcd_clear();
                        lcd_puts("Relay-1 ");
                        lcd_gotoxy(0,1);
                        lcd_puts("Relay-2 <=");
                        break;
                    case 3:
                        lcd_clear();
                        lcd_puts("Relay-3 <=");
                        lcd_gotoxy(0,1);
                        lcd_puts("Relay-4 ");
                        break;
                    case 4:
                        lcd_clear();
                        lcd_puts("Relay-3 ");
                        lcd_gotoxy(0,1);
                        lcd_puts("Relay-4 <=");
                        break;
                    }

                break;
                }//Case menu page

            }
        }//If menu key

    //////////////////////////////////////////////////////////////////////////////////////////////
    //Select Key funtion:
    if (select_key==0)
        {
        switch (page_state)
            {
            case menu_page:
                switch (rly_pick)
                    {

                    case 1:
                        lcd_clear();
                        lcd_puts("Relay-1 is:");
                        if (Read_relay_1==1) lcd_puts("ON");
                        if (Read_relay_1==0) lcd_puts("OFF");
                        PORTD=segment[rly_pick];
                        break;
                    case 2:
                        lcd_clear();
                        lcd_puts("Relay-2 is:");
                        if (Read_relay_2==1) lcd_puts("ON");
                        if (Read_relay_2==0) lcd_puts("OFF");
                        PORTD=segment[rly_pick];
                        break;
                    case 3:
                        lcd_clear();
                        lcd_puts("Relay-3 is:");
                        if (Read_relay_3==1) lcd_puts("ON");
                        if (Read_relay_3==0) lcd_puts("OFF");
                        PORTD=segment[rly_pick];
                        break;
                    case 4:
                        lcd_clear();
                        lcd_puts("Relay-4 is:");
                        if (Read_relay_4==1) lcd_puts("ON");
                        if (Read_relay_4==0) lcd_puts("OFF");
                        PORTD=segment[rly_pick];
                        break;
                    }
                page_state=relay_page;
                break;
            case relay_page:
                switch (rly_pick)
                    {
                    case 1:
                        En_relay_1=~(En_relay_1);
                        lcd_clear();
                        lcd_puts("Relay-1 is:");
                        if (Read_relay_1==1) lcd_puts("ON");
                        if (Read_relay_1==0) lcd_puts("OFF");
                        //PORTD=segment[rly_pick];

                        break;
                    case 2:
                        En_relay_2=~(En_relay_2);
                        lcd_clear();
                        lcd_puts("Relay-2 is:");
                        if (Read_relay_2==1) lcd_puts("ON");
                        if (Read_relay_2==0) lcd_puts("OFF");
                        //PORTD=segment[rly_pick];
                        break;
                    case 3:
                        En_relay_3=~(En_relay_3);
                        lcd_clear();
                        lcd_puts("Relay-3 is:");
                        if (Read_relay_3==1) lcd_puts("ON");
                        if (Read_relay_3==0) lcd_puts("OFF");
                        //PORTD=segment[rly_pick];
                        break;
                    case 4:
                        En_relay_4=~(En_relay_4);
                        lcd_clear();
                        lcd_puts("Relay-4 is:");
                        if (Read_relay_4==1) lcd_puts("ON");
                        if (Read_relay_4==0) lcd_puts("OFF");
                        //PORTD=segment[rly_pick];
                        break;
                    }
            }
        }
    if (status_key==0)
        {
        lcd_clear();
        lcd_puts(" R1  R2  R3  R4  ");
        lcd_gotoxy(1,1);
        if (Read_relay_1==1) lcd_puts("ON");
        if (Read_relay_1==0) lcd_puts("OFF");
        lcd_gotoxy(5,1);
        if (Read_relay_2==1) lcd_puts("ON");
        if (Read_relay_2==0) lcd_puts("OFF");
        lcd_gotoxy(9,1);
        if (Read_relay_3==1) lcd_puts("ON");
        if (Read_relay_3==0) lcd_puts("OFF");
        lcd_gotoxy(13,1);
        if (Read_relay_4==1) lcd_puts("ON");
        if (Read_relay_4==0) lcd_puts("OFF");
        }
    delay_ms(225);
    }//While
}

void lcd_start()
{
    lcd_init(16);
    lcd_gotoxy(1,1);
    lcd_puts("Kamyab Tajmiri");
    delay_ms(1000);
    lcd_clear();
    lcd_puts("Are you Ready?");
    delay_ms(1000);
    lcd_clear();
    lcd_puts("if y just press menu");

}