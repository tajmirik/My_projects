/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
Project :Password
Version :0.0
Date    : 3/16/2024
Chip type               : ATmega32

AVR Core Clock frequency: 8.000000 MHz
*******************************************************/

#include <mega32.h>
#include <delay.h>
#include <alcd.h>
#define Y1   PINC.4
#define Y2   PINC.5
#define Y3   PINC.6
#define Y4   PINC.7

// Alphanumeric LCD functions
void lcd_blink();
// Declare your global variables here
enum menu_state
{
    password,
    password_correct,
    password_wrong
}state;
unsigned char keypad[4][4]={{'7','8','9','/'},//1
                            {'4','5','6','*'},//2
                            {'1','2','3','-'},//3
                            {'c','0','=','+'}};//4
unsigned char keypad_x[4]={0x0e,0x0d,0x0b,0x07};
void main(void)
{

/////////////////// Declare your local variables here
unsigned char keypad_counter=0,temp_char,pass_indic=0,pass_counter=0,pass_str[5];
///////////////////Start of MCU pin init:
DDRB=0XFF;
DDRC=0X0f;
PORTC=0X0f;

///////////////////End of MCU pin init

///////////////////LCD initial:
lcd_init(16);
lcd_blink();
state=password;
while (1)
      {
      temp_char=1;
      // Place your code here
      ///////////////////////////Keypad:////////////////////////////////////////
      for (keypad_counter=0;keypad_counter<4;keypad_counter++)
        {
        PORTC=keypad_x[keypad_counter];

        if (Y1==0|Y2==0|Y3==0|Y4==0)
            {
            if (Y1==0)
                {
                temp_char=keypad[keypad_counter][0];

                }//for>>if>>if Y1
            if (Y2==0)
                {
                temp_char=keypad[keypad_counter][1];
                //lcd_putchar(temp_char);
                }//for>>if>>if Y1
            if (Y3==0)
                {
                temp_char=keypad[keypad_counter][2];
                //lcd_putchar(temp_char);
                }//for>>if>>if Y1
            if (Y4==0)
                {
                temp_char=keypad[keypad_counter][3];
                //lcd_putchar(temp_char);
                }//for>>if>>if Y's
            break;
            }//if
        }//for
      //if you have pressed any buttom then it's equal to tempchar
      ///////////////////////////End of Keypad/////////////////////////////////

///////////////////////////////decision making unit:///////////////////////////
      switch (state)
        {
        case password:
            {
             if (pass_indic==0)
                {
                lcd_clear();
                lcd_puts("Password: ");
                delay_ms(1);
                lcd_blink();
                pass_indic=1;
                }
             if (temp_char!=1)
                {
                *(pass_str+pass_counter)=temp_char;
                lcd_putchar('*');
                pass_counter++;

                };
             if (pass_counter==4)
                {
                pass_counter=0;
                 if (pass_str[0]=='1'&&pass_str[1]=='4'&&pass_str[2]=='0'&&pass_str[3]=='2')
                    {
                    state=password_correct;
                    }
                 else
                     {
                     state=password_wrong;
                     }
                }
            break;
            }
        case password_correct:
            {
            lcd_clear();
            delay_ms(1);
            lcd_puts("Correct");
            delay_ms(1000);
            state=password;
            pass_indic=0;
            break;
            }
        case password_wrong:
            {
            lcd_clear();
            lcd_puts("Fuck off ");
            PORTB|=(1<<0);
            state=password;
            pass_indic=0;
            break;
            }

        }//switch
      delay_ms(225);
      }//while
}//main



void lcd_blink()
{
PORTA=0B00000100;
PORTA=0B00000000;
PORTA=0B11110100;
PORTA=0B11110000;

}