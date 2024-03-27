
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x3:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x4F,0x40
_0x0:
	.DB  0x52,0x65,0x6C,0x61,0x79,0x2D,0x31,0x20
	.DB  0x3C,0x3D,0x0,0x52,0x65,0x6C,0x61,0x79
	.DB  0x2D,0x32,0x20,0x0,0x52,0x65,0x6C,0x61
	.DB  0x79,0x2D,0x31,0x20,0x0,0x52,0x65,0x6C
	.DB  0x61,0x79,0x2D,0x32,0x20,0x3C,0x3D,0x0
	.DB  0x52,0x65,0x6C,0x61,0x79,0x2D,0x33,0x20
	.DB  0x3C,0x3D,0x0,0x52,0x65,0x6C,0x61,0x79
	.DB  0x2D,0x34,0x20,0x0,0x52,0x65,0x6C,0x61
	.DB  0x79,0x2D,0x33,0x20,0x0,0x52,0x65,0x6C
	.DB  0x61,0x79,0x2D,0x34,0x20,0x3C,0x3D,0x0
	.DB  0x52,0x65,0x6C,0x61,0x79,0x2D,0x31,0x20
	.DB  0x69,0x73,0x3A,0x0,0x4F,0x4E,0x0,0x4F
	.DB  0x46,0x46,0x0,0x52,0x65,0x6C,0x61,0x79
	.DB  0x2D,0x32,0x20,0x69,0x73,0x3A,0x0,0x52
	.DB  0x65,0x6C,0x61,0x79,0x2D,0x33,0x20,0x69
	.DB  0x73,0x3A,0x0,0x52,0x65,0x6C,0x61,0x79
	.DB  0x2D,0x34,0x20,0x69,0x73,0x3A,0x0,0x20
	.DB  0x52,0x31,0x20,0x20,0x52,0x32,0x20,0x20
	.DB  0x52,0x33,0x20,0x20,0x52,0x34,0x20,0x20
	.DB  0x0,0x4B,0x61,0x6D,0x79,0x61,0x62,0x20
	.DB  0x54,0x61,0x6A,0x6D,0x69,0x72,0x69,0x0
	.DB  0x41,0x72,0x65,0x20,0x79,0x6F,0x75,0x20
	.DB  0x52,0x65,0x61,0x64,0x79,0x3F,0x0,0x69
	.DB  0x66,0x20,0x79,0x20,0x6A,0x75,0x73,0x74
	.DB  0x20,0x70,0x72,0x65,0x73,0x73,0x20,0x6D
	.DB  0x65,0x6E,0x75,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x0B
	.DW  _segment
	.DW  _0x3*2

	.DW  0x0B
	.DW  _0x16
	.DW  _0x0*2

	.DW  0x09
	.DW  _0x16+11
	.DW  _0x0*2+11

	.DW  0x09
	.DW  _0x16+20
	.DW  _0x0*2+20

	.DW  0x0B
	.DW  _0x16+29
	.DW  _0x0*2+29

	.DW  0x0B
	.DW  _0x16+40
	.DW  _0x0*2+40

	.DW  0x09
	.DW  _0x16+51
	.DW  _0x0*2+51

	.DW  0x09
	.DW  _0x16+60
	.DW  _0x0*2+60

	.DW  0x0B
	.DW  _0x16+69
	.DW  _0x0*2+69

	.DW  0x0C
	.DW  _0x16+80
	.DW  _0x0*2+80

	.DW  0x03
	.DW  _0x16+92
	.DW  _0x0*2+92

	.DW  0x04
	.DW  _0x16+95
	.DW  _0x0*2+95

	.DW  0x0C
	.DW  _0x16+99
	.DW  _0x0*2+99

	.DW  0x03
	.DW  _0x16+111
	.DW  _0x0*2+92

	.DW  0x04
	.DW  _0x16+114
	.DW  _0x0*2+95

	.DW  0x0C
	.DW  _0x16+118
	.DW  _0x0*2+111

	.DW  0x03
	.DW  _0x16+130
	.DW  _0x0*2+92

	.DW  0x04
	.DW  _0x16+133
	.DW  _0x0*2+95

	.DW  0x0C
	.DW  _0x16+137
	.DW  _0x0*2+123

	.DW  0x03
	.DW  _0x16+149
	.DW  _0x0*2+92

	.DW  0x04
	.DW  _0x16+152
	.DW  _0x0*2+95

	.DW  0x0C
	.DW  _0x16+156
	.DW  _0x0*2+80

	.DW  0x03
	.DW  _0x16+168
	.DW  _0x0*2+92

	.DW  0x04
	.DW  _0x16+171
	.DW  _0x0*2+95

	.DW  0x0C
	.DW  _0x16+175
	.DW  _0x0*2+99

	.DW  0x03
	.DW  _0x16+187
	.DW  _0x0*2+92

	.DW  0x04
	.DW  _0x16+190
	.DW  _0x0*2+95

	.DW  0x0C
	.DW  _0x16+194
	.DW  _0x0*2+111

	.DW  0x03
	.DW  _0x16+206
	.DW  _0x0*2+92

	.DW  0x04
	.DW  _0x16+209
	.DW  _0x0*2+95

	.DW  0x0C
	.DW  _0x16+213
	.DW  _0x0*2+123

	.DW  0x03
	.DW  _0x16+225
	.DW  _0x0*2+92

	.DW  0x04
	.DW  _0x16+228
	.DW  _0x0*2+95

	.DW  0x12
	.DW  _0x16+232
	.DW  _0x0*2+135

	.DW  0x03
	.DW  _0x16+250
	.DW  _0x0*2+92

	.DW  0x04
	.DW  _0x16+253
	.DW  _0x0*2+95

	.DW  0x03
	.DW  _0x16+257
	.DW  _0x0*2+92

	.DW  0x04
	.DW  _0x16+260
	.DW  _0x0*2+95

	.DW  0x03
	.DW  _0x16+264
	.DW  _0x0*2+92

	.DW  0x04
	.DW  _0x16+267
	.DW  _0x0*2+95

	.DW  0x03
	.DW  _0x16+271
	.DW  _0x0*2+92

	.DW  0x04
	.DW  _0x16+274
	.DW  _0x0*2+95

	.DW  0x0F
	.DW  _0x50
	.DW  _0x0*2+153

	.DW  0x0F
	.DW  _0x50+15
	.DW  _0x0*2+168

	.DW  0x15
	.DW  _0x50+30
	.DW  _0x0*2+183

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <delay.h>
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#define menu_page 1
;#define relay_page 2
;#define status_page 3
;#define menu_key PINB.0
;#define select_key PINB.1
;#define status_key PINB.2
;#define En_relay_1 PORTC.0
;#define En_relay_2 PORTC.1
;#define En_relay_3 PORTC.2
;#define En_relay_4 PORTC.3
;#define Read_relay_1 PINC.0
;#define Read_relay_2 PINC.1
;#define Read_relay_3 PINC.2
;#define Read_relay_4 PINC.3
;/////////////////////////////////////////////////
;//just making change to check the git
;//Functions
;void lcd_start();
;// Declare your global variables here
;// for a comoon cathode sement:
;//
;unsigned char segment[]={0x3f,0x06,0x5b,0x4f, //0     1    2     3
;                         0x66,0x6d,0x7d,0x07, //4     5   6      7
;                            0x7f,0x4f,0X40};  //8   9     -

	.DSEG
;
;void main(void)
; 0000 001E {

	.CSEG
_main:
; .FSTART _main
; 0000 001F //////////////////////////////////////////////////////////////
; 0000 0020 // Declare your local variables here
; 0000 0021 unsigned char page_state,rly_pick=0;
; 0000 0022 
; 0000 0023 //////////////////////////////////////////////////////////////
; 0000 0024 // Input/Output Ports initialization
; 0000 0025 
; 0000 0026 DDRB=0XF8;
;	page_state -> R17
;	rly_pick -> R16
	LDI  R16,0
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 0027 PORTB=0X07;
	LDI  R30,LOW(7)
	OUT  0x18,R30
; 0000 0028 DDRC=0X0F;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 0029 PORTC=0X00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 002A DDRD=0XFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 002B PORTD=segment[10];
	__GETB1MN _segment,10
	OUT  0x12,R30
; 0000 002C 
; 0000 002D ///////////////////////////////////////////////////////////
; 0000 002E lcd_start();
	RCALL _lcd_start
; 0000 002F 
; 0000 0030 /////////////////////////////////////////////////////////////
; 0000 0031 page_state=menu_page;
	LDI  R17,LOW(1)
; 0000 0032 while (1)
_0x4:
; 0000 0033     {
; 0000 0034     // Place your code here
; 0000 0035 /////////////////////////////////////////////////////////////////////////////////////////////////
; 0000 0036     //Menu Key function:
; 0000 0037     if (menu_key==0)
	SBIC 0x16,0
	RJMP _0x7
; 0000 0038         {
; 0000 0039         if (page_state==menu_page)
	CPI  R17,1
	BRNE _0x8
; 0000 003A             {
; 0000 003B             rly_pick++;
	SUBI R16,-1
; 0000 003C             rly_pick=rly_pick==5 ? 1 :rly_pick;
	CPI  R16,5
	BRNE _0x9
	LDI  R30,LOW(1)
	RJMP _0xA
_0x9:
	MOV  R30,R16
_0xA:
	MOV  R16,R30
; 0000 003D             }
; 0000 003E         switch (page_state)
_0x8:
	MOV  R30,R17
	LDI  R31,0
; 0000 003F             {
; 0000 0040             case relay_page:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xF
; 0000 0041                 page_state=menu_page;
	LDI  R17,LOW(1)
; 0000 0042 
; 0000 0043 
; 0000 0044             case menu_page:
	RJMP _0x10
_0xF:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xE
_0x10:
; 0000 0045                 {
; 0000 0046                 PORTD=segment[10];
	__GETB1MN _segment,10
	OUT  0x12,R30
; 0000 0047                 switch (rly_pick)
	RCALL SUBOPT_0x0
; 0000 0048                     {
; 0000 0049                     case 1:
	BRNE _0x15
; 0000 004A                         lcd_clear();
	RCALL _lcd_clear
; 0000 004B                         lcd_puts("Relay-1 <=");
	__POINTW2MN _0x16,0
	RCALL SUBOPT_0x1
; 0000 004C                         lcd_gotoxy(0,1);
; 0000 004D                         lcd_puts("Relay-2 ");
	__POINTW2MN _0x16,11
	RJMP _0x51
; 0000 004E                         break;
; 0000 004F                     case 2:
_0x15:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x17
; 0000 0050                         lcd_clear();
	RCALL _lcd_clear
; 0000 0051                         lcd_puts("Relay-1 ");
	__POINTW2MN _0x16,20
	RCALL SUBOPT_0x1
; 0000 0052                         lcd_gotoxy(0,1);
; 0000 0053                         lcd_puts("Relay-2 <=");
	__POINTW2MN _0x16,29
	RJMP _0x51
; 0000 0054                         break;
; 0000 0055                     case 3:
_0x17:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x18
; 0000 0056                         lcd_clear();
	RCALL _lcd_clear
; 0000 0057                         lcd_puts("Relay-3 <=");
	__POINTW2MN _0x16,40
	RCALL SUBOPT_0x1
; 0000 0058                         lcd_gotoxy(0,1);
; 0000 0059                         lcd_puts("Relay-4 ");
	__POINTW2MN _0x16,51
	RJMP _0x51
; 0000 005A                         break;
; 0000 005B                     case 4:
_0x18:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x14
; 0000 005C                         lcd_clear();
	RCALL _lcd_clear
; 0000 005D                         lcd_puts("Relay-3 ");
	__POINTW2MN _0x16,60
	RCALL SUBOPT_0x1
; 0000 005E                         lcd_gotoxy(0,1);
; 0000 005F                         lcd_puts("Relay-4 <=");
	__POINTW2MN _0x16,69
_0x51:
	RCALL _lcd_puts
; 0000 0060                         break;
; 0000 0061                     }
_0x14:
; 0000 0062 
; 0000 0063                 break;
; 0000 0064                 }//Case menu page
; 0000 0065 
; 0000 0066             }
_0xE:
; 0000 0067         }//If menu key
; 0000 0068 
; 0000 0069     //////////////////////////////////////////////////////////////////////////////////////////////
; 0000 006A     //Select Key funtion:
; 0000 006B     if (select_key==0)
_0x7:
	SBIC 0x16,1
	RJMP _0x1A
; 0000 006C         {
; 0000 006D         switch (page_state)
	MOV  R30,R17
	LDI  R31,0
; 0000 006E             {
; 0000 006F             case menu_page:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x1E
; 0000 0070                 switch (rly_pick)
	RCALL SUBOPT_0x0
; 0000 0071                     {
; 0000 0072 
; 0000 0073                     case 1:
	BRNE _0x22
; 0000 0074                         lcd_clear();
	RCALL _lcd_clear
; 0000 0075                         lcd_puts("Relay-1 is:");
	__POINTW2MN _0x16,80
	RCALL _lcd_puts
; 0000 0076                         if (Read_relay_1==1) lcd_puts("ON");
	SBIS 0x13,0
	RJMP _0x23
	__POINTW2MN _0x16,92
	RCALL _lcd_puts
; 0000 0077                         if (Read_relay_1==0) lcd_puts("OFF");
_0x23:
	SBIC 0x13,0
	RJMP _0x24
	__POINTW2MN _0x16,95
	RCALL _lcd_puts
; 0000 0078                         PORTD=segment[rly_pick];
_0x24:
	RJMP _0x52
; 0000 0079                         break;
; 0000 007A                     case 2:
_0x22:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x25
; 0000 007B                         lcd_clear();
	RCALL _lcd_clear
; 0000 007C                         lcd_puts("Relay-2 is:");
	__POINTW2MN _0x16,99
	RCALL _lcd_puts
; 0000 007D                         if (Read_relay_2==1) lcd_puts("ON");
	SBIS 0x13,1
	RJMP _0x26
	__POINTW2MN _0x16,111
	RCALL _lcd_puts
; 0000 007E                         if (Read_relay_2==0) lcd_puts("OFF");
_0x26:
	SBIC 0x13,1
	RJMP _0x27
	__POINTW2MN _0x16,114
	RCALL _lcd_puts
; 0000 007F                         PORTD=segment[rly_pick];
_0x27:
	RJMP _0x52
; 0000 0080                         break;
; 0000 0081                     case 3:
_0x25:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x28
; 0000 0082                         lcd_clear();
	RCALL _lcd_clear
; 0000 0083                         lcd_puts("Relay-3 is:");
	__POINTW2MN _0x16,118
	RCALL _lcd_puts
; 0000 0084                         if (Read_relay_3==1) lcd_puts("ON");
	SBIS 0x13,2
	RJMP _0x29
	__POINTW2MN _0x16,130
	RCALL _lcd_puts
; 0000 0085                         if (Read_relay_3==0) lcd_puts("OFF");
_0x29:
	SBIC 0x13,2
	RJMP _0x2A
	__POINTW2MN _0x16,133
	RCALL _lcd_puts
; 0000 0086                         PORTD=segment[rly_pick];
_0x2A:
	RJMP _0x52
; 0000 0087                         break;
; 0000 0088                     case 4:
_0x28:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x21
; 0000 0089                         lcd_clear();
	RCALL _lcd_clear
; 0000 008A                         lcd_puts("Relay-4 is:");
	__POINTW2MN _0x16,137
	RCALL _lcd_puts
; 0000 008B                         if (Read_relay_4==1) lcd_puts("ON");
	SBIS 0x13,3
	RJMP _0x2C
	__POINTW2MN _0x16,149
	RCALL _lcd_puts
; 0000 008C                         if (Read_relay_4==0) lcd_puts("OFF");
_0x2C:
	SBIC 0x13,3
	RJMP _0x2D
	__POINTW2MN _0x16,152
	RCALL _lcd_puts
; 0000 008D                         PORTD=segment[rly_pick];
_0x2D:
_0x52:
	MOV  R30,R16
	LDI  R31,0
	SUBI R30,LOW(-_segment)
	SBCI R31,HIGH(-_segment)
	LD   R30,Z
	OUT  0x12,R30
; 0000 008E                         break;
; 0000 008F                     }
_0x21:
; 0000 0090                 page_state=relay_page;
	LDI  R17,LOW(2)
; 0000 0091                 break;
	RJMP _0x1D
; 0000 0092             case relay_page:
_0x1E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x1D
; 0000 0093                 switch (rly_pick)
	RCALL SUBOPT_0x0
; 0000 0094                     {
; 0000 0095                     case 1:
	BRNE _0x32
; 0000 0096                         En_relay_1=~(En_relay_1);
	SBIS 0x15,0
	RJMP _0x33
	CBI  0x15,0
	RJMP _0x34
_0x33:
	SBI  0x15,0
_0x34:
; 0000 0097                         lcd_clear();
	RCALL _lcd_clear
; 0000 0098                         lcd_puts("Relay-1 is:");
	__POINTW2MN _0x16,156
	RCALL _lcd_puts
; 0000 0099                         if (Read_relay_1==1) lcd_puts("ON");
	SBIS 0x13,0
	RJMP _0x35
	__POINTW2MN _0x16,168
	RCALL _lcd_puts
; 0000 009A                         if (Read_relay_1==0) lcd_puts("OFF");
_0x35:
	SBIC 0x13,0
	RJMP _0x36
	__POINTW2MN _0x16,171
	RCALL _lcd_puts
; 0000 009B                         //PORTD=segment[rly_pick];
; 0000 009C 
; 0000 009D                         break;
_0x36:
	RJMP _0x31
; 0000 009E                     case 2:
_0x32:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x37
; 0000 009F                         En_relay_2=~(En_relay_2);
	SBIS 0x15,1
	RJMP _0x38
	CBI  0x15,1
	RJMP _0x39
_0x38:
	SBI  0x15,1
_0x39:
; 0000 00A0                         lcd_clear();
	RCALL _lcd_clear
; 0000 00A1                         lcd_puts("Relay-2 is:");
	__POINTW2MN _0x16,175
	RCALL _lcd_puts
; 0000 00A2                         if (Read_relay_2==1) lcd_puts("ON");
	SBIS 0x13,1
	RJMP _0x3A
	__POINTW2MN _0x16,187
	RCALL _lcd_puts
; 0000 00A3                         if (Read_relay_2==0) lcd_puts("OFF");
_0x3A:
	SBIC 0x13,1
	RJMP _0x3B
	__POINTW2MN _0x16,190
	RCALL _lcd_puts
; 0000 00A4                         //PORTD=segment[rly_pick];
; 0000 00A5                         break;
_0x3B:
	RJMP _0x31
; 0000 00A6                     case 3:
_0x37:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x3C
; 0000 00A7                         En_relay_3=~(En_relay_3);
	SBIS 0x15,2
	RJMP _0x3D
	CBI  0x15,2
	RJMP _0x3E
_0x3D:
	SBI  0x15,2
_0x3E:
; 0000 00A8                         lcd_clear();
	RCALL _lcd_clear
; 0000 00A9                         lcd_puts("Relay-3 is:");
	__POINTW2MN _0x16,194
	RCALL _lcd_puts
; 0000 00AA                         if (Read_relay_3==1) lcd_puts("ON");
	SBIS 0x13,2
	RJMP _0x3F
	__POINTW2MN _0x16,206
	RCALL _lcd_puts
; 0000 00AB                         if (Read_relay_3==0) lcd_puts("OFF");
_0x3F:
	SBIC 0x13,2
	RJMP _0x40
	__POINTW2MN _0x16,209
	RCALL _lcd_puts
; 0000 00AC                         //PORTD=segment[rly_pick];
; 0000 00AD                         break;
_0x40:
	RJMP _0x31
; 0000 00AE                     case 4:
_0x3C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x31
; 0000 00AF                         En_relay_4=~(En_relay_4);
	SBIS 0x15,3
	RJMP _0x42
	CBI  0x15,3
	RJMP _0x43
_0x42:
	SBI  0x15,3
_0x43:
; 0000 00B0                         lcd_clear();
	RCALL _lcd_clear
; 0000 00B1                         lcd_puts("Relay-4 is:");
	__POINTW2MN _0x16,213
	RCALL _lcd_puts
; 0000 00B2                         if (Read_relay_4==1) lcd_puts("ON");
	SBIS 0x13,3
	RJMP _0x44
	__POINTW2MN _0x16,225
	RCALL _lcd_puts
; 0000 00B3                         if (Read_relay_4==0) lcd_puts("OFF");
_0x44:
	SBIC 0x13,3
	RJMP _0x45
	__POINTW2MN _0x16,228
	RCALL _lcd_puts
; 0000 00B4                         //PORTD=segment[rly_pick];
; 0000 00B5                         break;
_0x45:
; 0000 00B6                     }
_0x31:
; 0000 00B7             }
_0x1D:
; 0000 00B8         }
; 0000 00B9     if (status_key==0)
_0x1A:
	SBIC 0x16,2
	RJMP _0x46
; 0000 00BA         {
; 0000 00BB         lcd_clear();
	RCALL _lcd_clear
; 0000 00BC         lcd_puts(" R1  R2  R3  R4  ");
	__POINTW2MN _0x16,232
	RCALL _lcd_puts
; 0000 00BD         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x2
; 0000 00BE         if (Read_relay_1==1) lcd_puts("ON");
	SBIS 0x13,0
	RJMP _0x47
	__POINTW2MN _0x16,250
	RCALL _lcd_puts
; 0000 00BF         if (Read_relay_1==0) lcd_puts("OFF");
_0x47:
	SBIC 0x13,0
	RJMP _0x48
	__POINTW2MN _0x16,253
	RCALL _lcd_puts
; 0000 00C0         lcd_gotoxy(5,1);
_0x48:
	LDI  R30,LOW(5)
	RCALL SUBOPT_0x2
; 0000 00C1         if (Read_relay_2==1) lcd_puts("ON");
	SBIS 0x13,1
	RJMP _0x49
	__POINTW2MN _0x16,257
	RCALL _lcd_puts
; 0000 00C2         if (Read_relay_2==0) lcd_puts("OFF");
_0x49:
	SBIC 0x13,1
	RJMP _0x4A
	__POINTW2MN _0x16,260
	RCALL _lcd_puts
; 0000 00C3         lcd_gotoxy(9,1);
_0x4A:
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x2
; 0000 00C4         if (Read_relay_3==1) lcd_puts("ON");
	SBIS 0x13,2
	RJMP _0x4B
	__POINTW2MN _0x16,264
	RCALL _lcd_puts
; 0000 00C5         if (Read_relay_3==0) lcd_puts("OFF");
_0x4B:
	SBIC 0x13,2
	RJMP _0x4C
	__POINTW2MN _0x16,267
	RCALL _lcd_puts
; 0000 00C6         lcd_gotoxy(13,1);
_0x4C:
	LDI  R30,LOW(13)
	RCALL SUBOPT_0x2
; 0000 00C7         if (Read_relay_4==1) lcd_puts("ON");
	SBIS 0x13,3
	RJMP _0x4D
	__POINTW2MN _0x16,271
	RCALL _lcd_puts
; 0000 00C8         if (Read_relay_4==0) lcd_puts("OFF");
_0x4D:
	SBIC 0x13,3
	RJMP _0x4E
	__POINTW2MN _0x16,274
	RCALL _lcd_puts
; 0000 00C9         }
_0x4E:
; 0000 00CA     delay_ms(225);
_0x46:
	LDI  R26,LOW(225)
	LDI  R27,0
	CALL _delay_ms
; 0000 00CB     }//While
	RJMP _0x4
; 0000 00CC }
_0x4F:
	RJMP _0x4F
; .FEND

	.DSEG
_0x16:
	.BYTE 0x116
;
;void lcd_start()
; 0000 00CF {

	.CSEG
_lcd_start:
; .FSTART _lcd_start
; 0000 00D0     lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 00D1     lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x2
; 0000 00D2     lcd_puts("Kamyab Tajmiri");
	__POINTW2MN _0x50,0
	RCALL SUBOPT_0x3
; 0000 00D3     delay_ms(1000);
; 0000 00D4     lcd_clear();
; 0000 00D5     lcd_puts("Are you Ready?");
	__POINTW2MN _0x50,15
	RCALL SUBOPT_0x3
; 0000 00D6     delay_ms(1000);
; 0000 00D7     lcd_clear();
; 0000 00D8     lcd_puts("if y just press menu");
	__POINTW2MN _0x50,30
	RCALL _lcd_puts
; 0000 00D9 
; 0000 00DA }
	RET
; .FEND

	.DSEG
_0x50:
	.BYTE 0x33
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2020001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2020001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x4
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x4
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	CP   R5,R7
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	MOV  R26,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2020001
_0x2000007:
_0x2000004:
	INC  R5
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2020001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
_segment:
	.BYTE 0xB
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	MOV  R30,R16
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1:
	RCALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	RCALL _lcd_puts
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
	RJMP _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
