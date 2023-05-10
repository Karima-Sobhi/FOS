
obj/user/quicksort_heap:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 1f 06 00 00       	call   800655 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 4c 20 00 00       	call   802092 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 39 80 00       	push   $0x803920
  80004e:	e8 f2 09 00 00       	call   800a45 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 39 80 00       	push   $0x803922
  80005e:	e8 e2 09 00 00       	call   800a45 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 3b 39 80 00       	push   $0x80393b
  80006e:	e8 d2 09 00 00       	call   800a45 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 39 80 00       	push   $0x803922
  80007e:	e8 c2 09 00 00       	call   800a45 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 39 80 00       	push   $0x803920
  80008e:	e8 b2 09 00 00       	call   800a45 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 54 39 80 00       	push   $0x803954
  8000a5:	e8 1d 10 00 00       	call   8010c7 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 6d 15 00 00       	call   80162d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 a2 1a 00 00       	call   801b77 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 74 39 80 00       	push   $0x803974
  8000e3:	e8 5d 09 00 00       	call   800a45 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 96 39 80 00       	push   $0x803996
  8000f3:	e8 4d 09 00 00       	call   800a45 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 a4 39 80 00       	push   $0x8039a4
  800103:	e8 3d 09 00 00       	call   800a45 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 b3 39 80 00       	push   $0x8039b3
  800113:	e8 2d 09 00 00       	call   800a45 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 c3 39 80 00       	push   $0x8039c3
  800123:	e8 1d 09 00 00       	call   800a45 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 cd 04 00 00       	call   8005fd <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 75 04 00 00       	call   8005b5 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 68 04 00 00       	call   8005b5 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 45 1f 00 00       	call   8020ac <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 b8 1e 00 00       	call   802092 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 cc 39 80 00       	push   $0x8039cc
  8001e2:	e8 5e 08 00 00       	call   800a45 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 bd 1e 00 00       	call   8020ac <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 00 3a 80 00       	push   $0x803a00
  800211:	6a 48                	push   $0x48
  800213:	68 22 3a 80 00       	push   $0x803a22
  800218:	e8 74 05 00 00       	call   800791 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 70 1e 00 00       	call   802092 <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 38 3a 80 00       	push   $0x803a38
  80022a:	e8 16 08 00 00       	call   800a45 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 6c 3a 80 00       	push   $0x803a6c
  80023a:	e8 06 08 00 00       	call   800a45 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 a0 3a 80 00       	push   $0x803aa0
  80024a:	e8 f6 07 00 00       	call   800a45 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 55 1e 00 00       	call   8020ac <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 36 1e 00 00       	call   802092 <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 d2 3a 80 00       	push   $0x803ad2
  80026a:	e8 d6 07 00 00       	call   800a45 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 86 03 00 00       	call   8005fd <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 2e 03 00 00       	call   8005b5 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 21 03 00 00       	call   8005b5 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 14 03 00 00       	call   8005b5 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
		}

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b0:	e8 f7 1d 00 00       	call   8020ac <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1e                	jmp    800524 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800519:	99                   	cltd   
  80051a:	f7 7d f8             	idivl  -0x8(%ebp)
  80051d:	89 d0                	mov    %edx,%eax
  80051f:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800521:	ff 45 fc             	incl   -0x4(%ebp)
  800524:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800527:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80052a:	7c da                	jl     800506 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80052c:	90                   	nop
  80052d:	c9                   	leave  
  80052e:	c3                   	ret    

0080052f <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800535:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80053c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800543:	eb 42                	jmp    800587 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800548:	99                   	cltd   
  800549:	f7 7d f0             	idivl  -0x10(%ebp)
  80054c:	89 d0                	mov    %edx,%eax
  80054e:	85 c0                	test   %eax,%eax
  800550:	75 10                	jne    800562 <PrintElements+0x33>
			cprintf("\n");
  800552:	83 ec 0c             	sub    $0xc,%esp
  800555:	68 20 39 80 00       	push   $0x803920
  80055a:	e8 e6 04 00 00       	call   800a45 <cprintf>
  80055f:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800565:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	50                   	push   %eax
  800577:	68 f0 3a 80 00       	push   $0x803af0
  80057c:	e8 c4 04 00 00       	call   800a45 <cprintf>
  800581:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800584:	ff 45 f4             	incl   -0xc(%ebp)
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	48                   	dec    %eax
  80058b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80058e:	7f b5                	jg     800545 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 d0                	add    %edx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	50                   	push   %eax
  8005a5:	68 f5 3a 80 00       	push   $0x803af5
  8005aa:	e8 96 04 00 00       	call   800a45 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp

}
  8005b2:	90                   	nop
  8005b3:	c9                   	leave  
  8005b4:	c3                   	ret    

008005b5 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005c1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005c5:	83 ec 0c             	sub    $0xc,%esp
  8005c8:	50                   	push   %eax
  8005c9:	e8 f8 1a 00 00       	call   8020c6 <sys_cputc>
  8005ce:	83 c4 10             	add    $0x10,%esp
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005da:	e8 b3 1a 00 00       	call   802092 <sys_disable_interrupt>
	char c = ch;
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005e5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e9:	83 ec 0c             	sub    $0xc,%esp
  8005ec:	50                   	push   %eax
  8005ed:	e8 d4 1a 00 00       	call   8020c6 <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 b2 1a 00 00       	call   8020ac <sys_enable_interrupt>
}
  8005fa:	90                   	nop
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <getchar>:

int
getchar(void)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800603:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80060a:	eb 08                	jmp    800614 <getchar+0x17>
	{
		c = sys_cgetc();
  80060c:	e8 fc 18 00 00       	call   801f0d <sys_cgetc>
  800611:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800618:	74 f2                	je     80060c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80061a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <atomic_getchar>:

int
atomic_getchar(void)
{
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800625:	e8 68 1a 00 00       	call   802092 <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 d5 18 00 00       	call   801f0d <sys_cgetc>
  800638:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80063b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80063f:	74 f2                	je     800633 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800641:	e8 66 1a 00 00       	call   8020ac <sys_enable_interrupt>
	return c;
  800646:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <iscons>:

int iscons(int fdnum)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80064e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800653:	5d                   	pop    %ebp
  800654:	c3                   	ret    

00800655 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80065b:	e8 25 1c 00 00       	call   802285 <sys_getenvindex>
  800660:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800666:	89 d0                	mov    %edx,%eax
  800668:	c1 e0 03             	shl    $0x3,%eax
  80066b:	01 d0                	add    %edx,%eax
  80066d:	01 c0                	add    %eax,%eax
  80066f:	01 d0                	add    %edx,%eax
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	01 d0                	add    %edx,%eax
  80067a:	c1 e0 04             	shl    $0x4,%eax
  80067d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800682:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800687:	a1 24 50 80 00       	mov    0x805024,%eax
  80068c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800692:	84 c0                	test   %al,%al
  800694:	74 0f                	je     8006a5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800696:	a1 24 50 80 00       	mov    0x805024,%eax
  80069b:	05 5c 05 00 00       	add    $0x55c,%eax
  8006a0:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006a9:	7e 0a                	jle    8006b5 <libmain+0x60>
		binaryname = argv[0];
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	ff 75 08             	pushl  0x8(%ebp)
  8006be:	e8 75 f9 ff ff       	call   800038 <_main>
  8006c3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006c6:	e8 c7 19 00 00       	call   802092 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	68 14 3b 80 00       	push   $0x803b14
  8006d3:	e8 6d 03 00 00       	call   800a45 <cprintf>
  8006d8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006db:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006e6:	a1 24 50 80 00       	mov    0x805024,%eax
  8006eb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006f1:	83 ec 04             	sub    $0x4,%esp
  8006f4:	52                   	push   %edx
  8006f5:	50                   	push   %eax
  8006f6:	68 3c 3b 80 00       	push   $0x803b3c
  8006fb:	e8 45 03 00 00       	call   800a45 <cprintf>
  800700:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800703:	a1 24 50 80 00       	mov    0x805024,%eax
  800708:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80070e:	a1 24 50 80 00       	mov    0x805024,%eax
  800713:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800719:	a1 24 50 80 00       	mov    0x805024,%eax
  80071e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800724:	51                   	push   %ecx
  800725:	52                   	push   %edx
  800726:	50                   	push   %eax
  800727:	68 64 3b 80 00       	push   $0x803b64
  80072c:	e8 14 03 00 00       	call   800a45 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800734:	a1 24 50 80 00       	mov    0x805024,%eax
  800739:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	68 bc 3b 80 00       	push   $0x803bbc
  800748:	e8 f8 02 00 00       	call   800a45 <cprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 14 3b 80 00       	push   $0x803b14
  800758:	e8 e8 02 00 00       	call   800a45 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800760:	e8 47 19 00 00       	call   8020ac <sys_enable_interrupt>

	// exit gracefully
	exit();
  800765:	e8 19 00 00 00       	call   800783 <exit>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800773:	83 ec 0c             	sub    $0xc,%esp
  800776:	6a 00                	push   $0x0
  800778:	e8 d4 1a 00 00       	call   802251 <sys_destroy_env>
  80077d:	83 c4 10             	add    $0x10,%esp
}
  800780:	90                   	nop
  800781:	c9                   	leave  
  800782:	c3                   	ret    

00800783 <exit>:

void
exit(void)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800789:	e8 29 1b 00 00       	call   8022b7 <sys_exit_env>
}
  80078e:	90                   	nop
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800797:	8d 45 10             	lea    0x10(%ebp),%eax
  80079a:	83 c0 04             	add    $0x4,%eax
  80079d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007a0:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007a5:	85 c0                	test   %eax,%eax
  8007a7:	74 16                	je     8007bf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	50                   	push   %eax
  8007b2:	68 d0 3b 80 00       	push   $0x803bd0
  8007b7:	e8 89 02 00 00       	call   800a45 <cprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007bf:	a1 00 50 80 00       	mov    0x805000,%eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	68 d5 3b 80 00       	push   $0x803bd5
  8007d0:	e8 70 02 00 00       	call   800a45 <cprintf>
  8007d5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e1:	50                   	push   %eax
  8007e2:	e8 f3 01 00 00       	call   8009da <vcprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	6a 00                	push   $0x0
  8007ef:	68 f1 3b 80 00       	push   $0x803bf1
  8007f4:	e8 e1 01 00 00       	call   8009da <vcprintf>
  8007f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007fc:	e8 82 ff ff ff       	call   800783 <exit>

	// should not return here
	while (1) ;
  800801:	eb fe                	jmp    800801 <_panic+0x70>

00800803 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800809:	a1 24 50 80 00       	mov    0x805024,%eax
  80080e:	8b 50 74             	mov    0x74(%eax),%edx
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	39 c2                	cmp    %eax,%edx
  800816:	74 14                	je     80082c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800818:	83 ec 04             	sub    $0x4,%esp
  80081b:	68 f4 3b 80 00       	push   $0x803bf4
  800820:	6a 26                	push   $0x26
  800822:	68 40 3c 80 00       	push   $0x803c40
  800827:	e8 65 ff ff ff       	call   800791 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80082c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800833:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80083a:	e9 c2 00 00 00       	jmp    800901 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	01 d0                	add    %edx,%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	85 c0                	test   %eax,%eax
  800852:	75 08                	jne    80085c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800854:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800857:	e9 a2 00 00 00       	jmp    8008fe <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80085c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800863:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80086a:	eb 69                	jmp    8008d5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80086c:	a1 24 50 80 00       	mov    0x805024,%eax
  800871:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800877:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087a:	89 d0                	mov    %edx,%eax
  80087c:	01 c0                	add    %eax,%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	c1 e0 03             	shl    $0x3,%eax
  800883:	01 c8                	add    %ecx,%eax
  800885:	8a 40 04             	mov    0x4(%eax),%al
  800888:	84 c0                	test   %al,%al
  80088a:	75 46                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088c:	a1 24 50 80 00       	mov    0x805024,%eax
  800891:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800897:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089a:	89 d0                	mov    %edx,%eax
  80089c:	01 c0                	add    %eax,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	c1 e0 03             	shl    $0x3,%eax
  8008a3:	01 c8                	add    %ecx,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	75 09                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008d0:	eb 12                	jmp    8008e4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d2:	ff 45 e8             	incl   -0x18(%ebp)
  8008d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8008da:	8b 50 74             	mov    0x74(%eax),%edx
  8008dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e0:	39 c2                	cmp    %eax,%edx
  8008e2:	77 88                	ja     80086c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008e8:	75 14                	jne    8008fe <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008ea:	83 ec 04             	sub    $0x4,%esp
  8008ed:	68 4c 3c 80 00       	push   $0x803c4c
  8008f2:	6a 3a                	push   $0x3a
  8008f4:	68 40 3c 80 00       	push   $0x803c40
  8008f9:	e8 93 fe ff ff       	call   800791 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008fe:	ff 45 f0             	incl   -0x10(%ebp)
  800901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800904:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800907:	0f 8c 32 ff ff ff    	jl     80083f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80090d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800914:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80091b:	eb 26                	jmp    800943 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80091d:	a1 24 50 80 00       	mov    0x805024,%eax
  800922:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800928:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092b:	89 d0                	mov    %edx,%eax
  80092d:	01 c0                	add    %eax,%eax
  80092f:	01 d0                	add    %edx,%eax
  800931:	c1 e0 03             	shl    $0x3,%eax
  800934:	01 c8                	add    %ecx,%eax
  800936:	8a 40 04             	mov    0x4(%eax),%al
  800939:	3c 01                	cmp    $0x1,%al
  80093b:	75 03                	jne    800940 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80093d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800940:	ff 45 e0             	incl   -0x20(%ebp)
  800943:	a1 24 50 80 00       	mov    0x805024,%eax
  800948:	8b 50 74             	mov    0x74(%eax),%edx
  80094b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094e:	39 c2                	cmp    %eax,%edx
  800950:	77 cb                	ja     80091d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800955:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800958:	74 14                	je     80096e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 a0 3c 80 00       	push   $0x803ca0
  800962:	6a 44                	push   $0x44
  800964:	68 40 3c 80 00       	push   $0x803c40
  800969:	e8 23 fe ff ff       	call   800791 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80096e:	90                   	nop
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	8d 48 01             	lea    0x1(%eax),%ecx
  80097f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800982:	89 0a                	mov    %ecx,(%edx)
  800984:	8b 55 08             	mov    0x8(%ebp),%edx
  800987:	88 d1                	mov    %dl,%cl
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	3d ff 00 00 00       	cmp    $0xff,%eax
  80099a:	75 2c                	jne    8009c8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80099c:	a0 28 50 80 00       	mov    0x805028,%al
  8009a1:	0f b6 c0             	movzbl %al,%eax
  8009a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a7:	8b 12                	mov    (%edx),%edx
  8009a9:	89 d1                	mov    %edx,%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	83 c2 08             	add    $0x8,%edx
  8009b1:	83 ec 04             	sub    $0x4,%esp
  8009b4:	50                   	push   %eax
  8009b5:	51                   	push   %ecx
  8009b6:	52                   	push   %edx
  8009b7:	e8 28 15 00 00       	call   801ee4 <sys_cputs>
  8009bc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cb:	8b 40 04             	mov    0x4(%eax),%eax
  8009ce:	8d 50 01             	lea    0x1(%eax),%edx
  8009d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009d7:	90                   	nop
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009ea:	00 00 00 
	b.cnt = 0;
  8009ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009f4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	ff 75 08             	pushl  0x8(%ebp)
  8009fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a03:	50                   	push   %eax
  800a04:	68 71 09 80 00       	push   $0x800971
  800a09:	e8 11 02 00 00       	call   800c1f <vprintfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a11:	a0 28 50 80 00       	mov    0x805028,%al
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a1f:	83 ec 04             	sub    $0x4,%esp
  800a22:	50                   	push   %eax
  800a23:	52                   	push   %edx
  800a24:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2a:	83 c0 08             	add    $0x8,%eax
  800a2d:	50                   	push   %eax
  800a2e:	e8 b1 14 00 00       	call   801ee4 <sys_cputs>
  800a33:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a36:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a3d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a43:	c9                   	leave  
  800a44:	c3                   	ret    

00800a45 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a4b:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a52:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a61:	50                   	push   %eax
  800a62:	e8 73 ff ff ff       	call   8009da <vcprintf>
  800a67:	83 c4 10             	add    $0x10,%esp
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a78:	e8 15 16 00 00       	call   802092 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 48 ff ff ff       	call   8009da <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a98:	e8 0f 16 00 00       	call   8020ac <sys_enable_interrupt>
	return cnt;
  800a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	53                   	push   %ebx
  800aa6:	83 ec 14             	sub    $0x14,%esp
  800aa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ab5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ab8:	ba 00 00 00 00       	mov    $0x0,%edx
  800abd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac0:	77 55                	ja     800b17 <printnum+0x75>
  800ac2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac5:	72 05                	jb     800acc <printnum+0x2a>
  800ac7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800aca:	77 4b                	ja     800b17 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800acc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800acf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ad2:	8b 45 18             	mov    0x18(%ebp),%eax
  800ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ada:	52                   	push   %edx
  800adb:	50                   	push   %eax
  800adc:	ff 75 f4             	pushl  -0xc(%ebp)
  800adf:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae2:	e8 b9 2b 00 00       	call   8036a0 <__udivdi3>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	ff 75 20             	pushl  0x20(%ebp)
  800af0:	53                   	push   %ebx
  800af1:	ff 75 18             	pushl  0x18(%ebp)
  800af4:	52                   	push   %edx
  800af5:	50                   	push   %eax
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	ff 75 08             	pushl  0x8(%ebp)
  800afc:	e8 a1 ff ff ff       	call   800aa2 <printnum>
  800b01:	83 c4 20             	add    $0x20,%esp
  800b04:	eb 1a                	jmp    800b20 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	ff 75 20             	pushl  0x20(%ebp)
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	ff d0                	call   *%eax
  800b14:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b17:	ff 4d 1c             	decl   0x1c(%ebp)
  800b1a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b1e:	7f e6                	jg     800b06 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b20:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b2e:	53                   	push   %ebx
  800b2f:	51                   	push   %ecx
  800b30:	52                   	push   %edx
  800b31:	50                   	push   %eax
  800b32:	e8 79 2c 00 00       	call   8037b0 <__umoddi3>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	05 14 3f 80 00       	add    $0x803f14,%eax
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	0f be c0             	movsbl %al,%eax
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	50                   	push   %eax
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	ff d0                	call   *%eax
  800b50:	83 c4 10             	add    $0x10,%esp
}
  800b53:	90                   	nop
  800b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b60:	7e 1c                	jle    800b7e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	8d 50 08             	lea    0x8(%eax),%edx
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	89 10                	mov    %edx,(%eax)
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	83 e8 08             	sub    $0x8,%eax
  800b77:	8b 50 04             	mov    0x4(%eax),%edx
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	eb 40                	jmp    800bbe <getuint+0x65>
	else if (lflag)
  800b7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b82:	74 1e                	je     800ba2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	8d 50 04             	lea    0x4(%eax),%edx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	89 10                	mov    %edx,(%eax)
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	83 e8 04             	sub    $0x4,%eax
  800b99:	8b 00                	mov    (%eax),%eax
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	eb 1c                	jmp    800bbe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	8d 50 04             	lea    0x4(%eax),%edx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	89 10                	mov    %edx,(%eax)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	83 e8 04             	sub    $0x4,%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bc3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bc7:	7e 1c                	jle    800be5 <getint+0x25>
		return va_arg(*ap, long long);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 00                	mov    (%eax),%eax
  800bce:	8d 50 08             	lea    0x8(%eax),%edx
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	89 10                	mov    %edx,(%eax)
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	83 e8 08             	sub    $0x8,%eax
  800bde:	8b 50 04             	mov    0x4(%eax),%edx
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	eb 38                	jmp    800c1d <getint+0x5d>
	else if (lflag)
  800be5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be9:	74 1a                	je     800c05 <getint+0x45>
		return va_arg(*ap, long);
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	8d 50 04             	lea    0x4(%eax),%edx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	89 10                	mov    %edx,(%eax)
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	83 e8 04             	sub    $0x4,%eax
  800c00:	8b 00                	mov    (%eax),%eax
  800c02:	99                   	cltd   
  800c03:	eb 18                	jmp    800c1d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8b 00                	mov    (%eax),%eax
  800c0a:	8d 50 04             	lea    0x4(%eax),%edx
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 10                	mov    %edx,(%eax)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8b 00                	mov    (%eax),%eax
  800c17:	83 e8 04             	sub    $0x4,%eax
  800c1a:	8b 00                	mov    (%eax),%eax
  800c1c:	99                   	cltd   
}
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c27:	eb 17                	jmp    800c40 <vprintfmt+0x21>
			if (ch == '\0')
  800c29:	85 db                	test   %ebx,%ebx
  800c2b:	0f 84 af 03 00 00    	je     800fe0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	53                   	push   %ebx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	ff d0                	call   *%eax
  800c3d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c40:	8b 45 10             	mov    0x10(%ebp),%eax
  800c43:	8d 50 01             	lea    0x1(%eax),%edx
  800c46:	89 55 10             	mov    %edx,0x10(%ebp)
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	0f b6 d8             	movzbl %al,%ebx
  800c4e:	83 fb 25             	cmp    $0x25,%ebx
  800c51:	75 d6                	jne    800c29 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c53:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c57:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c6c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c73:	8b 45 10             	mov    0x10(%ebp),%eax
  800c76:	8d 50 01             	lea    0x1(%eax),%edx
  800c79:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	0f b6 d8             	movzbl %al,%ebx
  800c81:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c84:	83 f8 55             	cmp    $0x55,%eax
  800c87:	0f 87 2b 03 00 00    	ja     800fb8 <vprintfmt+0x399>
  800c8d:	8b 04 85 38 3f 80 00 	mov    0x803f38(,%eax,4),%eax
  800c94:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c96:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c9a:	eb d7                	jmp    800c73 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c9c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ca0:	eb d1                	jmp    800c73 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ca9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	c1 e0 02             	shl    $0x2,%eax
  800cb1:	01 d0                	add    %edx,%eax
  800cb3:	01 c0                	add    %eax,%eax
  800cb5:	01 d8                	add    %ebx,%eax
  800cb7:	83 e8 30             	sub    $0x30,%eax
  800cba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cc5:	83 fb 2f             	cmp    $0x2f,%ebx
  800cc8:	7e 3e                	jle    800d08 <vprintfmt+0xe9>
  800cca:	83 fb 39             	cmp    $0x39,%ebx
  800ccd:	7f 39                	jg     800d08 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cd2:	eb d5                	jmp    800ca9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd7:	83 c0 04             	add    $0x4,%eax
  800cda:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	83 e8 04             	sub    $0x4,%eax
  800ce3:	8b 00                	mov    (%eax),%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ce8:	eb 1f                	jmp    800d09 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cee:	79 83                	jns    800c73 <vprintfmt+0x54>
				width = 0;
  800cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cf7:	e9 77 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cfc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d03:	e9 6b ff ff ff       	jmp    800c73 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d08:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0d:	0f 89 60 ff ff ff    	jns    800c73 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d20:	e9 4e ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d25:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d28:	e9 46 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d30:	83 c0 04             	add    $0x4,%eax
  800d33:	89 45 14             	mov    %eax,0x14(%ebp)
  800d36:	8b 45 14             	mov    0x14(%ebp),%eax
  800d39:	83 e8 04             	sub    $0x4,%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	50                   	push   %eax
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			break;
  800d4d:	e9 89 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d52:	8b 45 14             	mov    0x14(%ebp),%eax
  800d55:	83 c0 04             	add    $0x4,%eax
  800d58:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5e:	83 e8 04             	sub    $0x4,%eax
  800d61:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d63:	85 db                	test   %ebx,%ebx
  800d65:	79 02                	jns    800d69 <vprintfmt+0x14a>
				err = -err;
  800d67:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d69:	83 fb 64             	cmp    $0x64,%ebx
  800d6c:	7f 0b                	jg     800d79 <vprintfmt+0x15a>
  800d6e:	8b 34 9d 80 3d 80 00 	mov    0x803d80(,%ebx,4),%esi
  800d75:	85 f6                	test   %esi,%esi
  800d77:	75 19                	jne    800d92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d79:	53                   	push   %ebx
  800d7a:	68 25 3f 80 00       	push   $0x803f25
  800d7f:	ff 75 0c             	pushl  0xc(%ebp)
  800d82:	ff 75 08             	pushl  0x8(%ebp)
  800d85:	e8 5e 02 00 00       	call   800fe8 <printfmt>
  800d8a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d8d:	e9 49 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d92:	56                   	push   %esi
  800d93:	68 2e 3f 80 00       	push   $0x803f2e
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	ff 75 08             	pushl  0x8(%ebp)
  800d9e:	e8 45 02 00 00       	call   800fe8 <printfmt>
  800da3:	83 c4 10             	add    $0x10,%esp
			break;
  800da6:	e9 30 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dab:	8b 45 14             	mov    0x14(%ebp),%eax
  800dae:	83 c0 04             	add    $0x4,%eax
  800db1:	89 45 14             	mov    %eax,0x14(%ebp)
  800db4:	8b 45 14             	mov    0x14(%ebp),%eax
  800db7:	83 e8 04             	sub    $0x4,%eax
  800dba:	8b 30                	mov    (%eax),%esi
  800dbc:	85 f6                	test   %esi,%esi
  800dbe:	75 05                	jne    800dc5 <vprintfmt+0x1a6>
				p = "(null)";
  800dc0:	be 31 3f 80 00       	mov    $0x803f31,%esi
			if (width > 0 && padc != '-')
  800dc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc9:	7e 6d                	jle    800e38 <vprintfmt+0x219>
  800dcb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dcf:	74 67                	je     800e38 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dd4:	83 ec 08             	sub    $0x8,%esp
  800dd7:	50                   	push   %eax
  800dd8:	56                   	push   %esi
  800dd9:	e8 12 05 00 00       	call   8012f0 <strnlen>
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800de4:	eb 16                	jmp    800dfc <vprintfmt+0x1dd>
					putch(padc, putdat);
  800de6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	50                   	push   %eax
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	ff d0                	call   *%eax
  800df6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df9:	ff 4d e4             	decl   -0x1c(%ebp)
  800dfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e00:	7f e4                	jg     800de6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e02:	eb 34                	jmp    800e38 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e08:	74 1c                	je     800e26 <vprintfmt+0x207>
  800e0a:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0d:	7e 05                	jle    800e14 <vprintfmt+0x1f5>
  800e0f:	83 fb 7e             	cmp    $0x7e,%ebx
  800e12:	7e 12                	jle    800e26 <vprintfmt+0x207>
					putch('?', putdat);
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	6a 3f                	push   $0x3f
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
  800e24:	eb 0f                	jmp    800e35 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e26:	83 ec 08             	sub    $0x8,%esp
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	53                   	push   %ebx
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	ff d0                	call   *%eax
  800e32:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e35:	ff 4d e4             	decl   -0x1c(%ebp)
  800e38:	89 f0                	mov    %esi,%eax
  800e3a:	8d 70 01             	lea    0x1(%eax),%esi
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	0f be d8             	movsbl %al,%ebx
  800e42:	85 db                	test   %ebx,%ebx
  800e44:	74 24                	je     800e6a <vprintfmt+0x24b>
  800e46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e4a:	78 b8                	js     800e04 <vprintfmt+0x1e5>
  800e4c:	ff 4d e0             	decl   -0x20(%ebp)
  800e4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e53:	79 af                	jns    800e04 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e55:	eb 13                	jmp    800e6a <vprintfmt+0x24b>
				putch(' ', putdat);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	6a 20                	push   $0x20
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	ff d0                	call   *%eax
  800e64:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e67:	ff 4d e4             	decl   -0x1c(%ebp)
  800e6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6e:	7f e7                	jg     800e57 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e70:	e9 66 01 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e75:	83 ec 08             	sub    $0x8,%esp
  800e78:	ff 75 e8             	pushl  -0x18(%ebp)
  800e7b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e7e:	50                   	push   %eax
  800e7f:	e8 3c fd ff ff       	call   800bc0 <getint>
  800e84:	83 c4 10             	add    $0x10,%esp
  800e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e93:	85 d2                	test   %edx,%edx
  800e95:	79 23                	jns    800eba <vprintfmt+0x29b>
				putch('-', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 2d                	push   $0x2d
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ead:	f7 d8                	neg    %eax
  800eaf:	83 d2 00             	adc    $0x0,%edx
  800eb2:	f7 da                	neg    %edx
  800eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800eba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ec1:	e9 bc 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	ff 75 e8             	pushl  -0x18(%ebp)
  800ecc:	8d 45 14             	lea    0x14(%ebp),%eax
  800ecf:	50                   	push   %eax
  800ed0:	e8 84 fc ff ff       	call   800b59 <getuint>
  800ed5:	83 c4 10             	add    $0x10,%esp
  800ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ede:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ee5:	e9 98 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eea:	83 ec 08             	sub    $0x8,%esp
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	6a 58                	push   $0x58
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	ff d0                	call   *%eax
  800ef7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	ff 75 0c             	pushl  0xc(%ebp)
  800f00:	6a 58                	push   $0x58
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	ff d0                	call   *%eax
  800f07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	6a 58                	push   $0x58
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	ff d0                	call   *%eax
  800f17:	83 c4 10             	add    $0x10,%esp
			break;
  800f1a:	e9 bc 00 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	ff 75 0c             	pushl  0xc(%ebp)
  800f25:	6a 30                	push   $0x30
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	ff d0                	call   *%eax
  800f2c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f2f:	83 ec 08             	sub    $0x8,%esp
  800f32:	ff 75 0c             	pushl  0xc(%ebp)
  800f35:	6a 78                	push   $0x78
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f42:	83 c0 04             	add    $0x4,%eax
  800f45:	89 45 14             	mov    %eax,0x14(%ebp)
  800f48:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4b:	83 e8 04             	sub    $0x4,%eax
  800f4e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f61:	eb 1f                	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 e8             	pushl  -0x18(%ebp)
  800f69:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6c:	50                   	push   %eax
  800f6d:	e8 e7 fb ff ff       	call   800b59 <getuint>
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f82:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f89:	83 ec 04             	sub    $0x4,%esp
  800f8c:	52                   	push   %edx
  800f8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f90:	50                   	push   %eax
  800f91:	ff 75 f4             	pushl  -0xc(%ebp)
  800f94:	ff 75 f0             	pushl  -0x10(%ebp)
  800f97:	ff 75 0c             	pushl  0xc(%ebp)
  800f9a:	ff 75 08             	pushl  0x8(%ebp)
  800f9d:	e8 00 fb ff ff       	call   800aa2 <printnum>
  800fa2:	83 c4 20             	add    $0x20,%esp
			break;
  800fa5:	eb 34                	jmp    800fdb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	53                   	push   %ebx
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	ff d0                	call   *%eax
  800fb3:	83 c4 10             	add    $0x10,%esp
			break;
  800fb6:	eb 23                	jmp    800fdb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fb8:	83 ec 08             	sub    $0x8,%esp
  800fbb:	ff 75 0c             	pushl  0xc(%ebp)
  800fbe:	6a 25                	push   $0x25
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	ff d0                	call   *%eax
  800fc5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc8:	ff 4d 10             	decl   0x10(%ebp)
  800fcb:	eb 03                	jmp    800fd0 <vprintfmt+0x3b1>
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	48                   	dec    %eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 25                	cmp    $0x25,%al
  800fd8:	75 f3                	jne    800fcd <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fda:	90                   	nop
		}
	}
  800fdb:	e9 47 fc ff ff       	jmp    800c27 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fe0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fe1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fee:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff1:	83 c0 04             	add    $0x4,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	ff 75 08             	pushl  0x8(%ebp)
  801004:	e8 16 fc ff ff       	call   800c1f <vprintfmt>
  801009:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80100c:	90                   	nop
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801012:	8b 45 0c             	mov    0xc(%ebp),%eax
  801015:	8b 40 08             	mov    0x8(%eax),%eax
  801018:	8d 50 01             	lea    0x1(%eax),%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	8b 10                	mov    (%eax),%edx
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	8b 40 04             	mov    0x4(%eax),%eax
  80102c:	39 c2                	cmp    %eax,%edx
  80102e:	73 12                	jae    801042 <sprintputch+0x33>
		*b->buf++ = ch;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 00                	mov    (%eax),%eax
  801035:	8d 48 01             	lea    0x1(%eax),%ecx
  801038:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103b:	89 0a                	mov    %ecx,(%edx)
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	88 10                	mov    %dl,(%eax)
}
  801042:	90                   	nop
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8d 50 ff             	lea    -0x1(%eax),%edx
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	01 d0                	add    %edx,%eax
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801066:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106a:	74 06                	je     801072 <vsnprintf+0x2d>
  80106c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801070:	7f 07                	jg     801079 <vsnprintf+0x34>
		return -E_INVAL;
  801072:	b8 03 00 00 00       	mov    $0x3,%eax
  801077:	eb 20                	jmp    801099 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801079:	ff 75 14             	pushl  0x14(%ebp)
  80107c:	ff 75 10             	pushl  0x10(%ebp)
  80107f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801082:	50                   	push   %eax
  801083:	68 0f 10 80 00       	push   $0x80100f
  801088:	e8 92 fb ff ff       	call   800c1f <vprintfmt>
  80108d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801090:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801093:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801096:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b0:	50                   	push   %eax
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	e8 89 ff ff ff       	call   801045 <vsnprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
  8010bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d1:	74 13                	je     8010e6 <readline+0x1f>
		cprintf("%s", prompt);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 08             	pushl  0x8(%ebp)
  8010d9:	68 90 40 80 00       	push   $0x804090
  8010de:	e8 62 f9 ff ff       	call   800a45 <cprintf>
  8010e3:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010ed:	83 ec 0c             	sub    $0xc,%esp
  8010f0:	6a 00                	push   $0x0
  8010f2:	e8 54 f5 ff ff       	call   80064b <iscons>
  8010f7:	83 c4 10             	add    $0x10,%esp
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010fd:	e8 fb f4 ff ff       	call   8005fd <getchar>
  801102:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801105:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801109:	79 22                	jns    80112d <readline+0x66>
			if (c != -E_EOF)
  80110b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80110f:	0f 84 ad 00 00 00    	je     8011c2 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801115:	83 ec 08             	sub    $0x8,%esp
  801118:	ff 75 ec             	pushl  -0x14(%ebp)
  80111b:	68 93 40 80 00       	push   $0x804093
  801120:	e8 20 f9 ff ff       	call   800a45 <cprintf>
  801125:	83 c4 10             	add    $0x10,%esp
			return;
  801128:	e9 95 00 00 00       	jmp    8011c2 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80112d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801131:	7e 34                	jle    801167 <readline+0xa0>
  801133:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80113a:	7f 2b                	jg     801167 <readline+0xa0>
			if (echoing)
  80113c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801140:	74 0e                	je     801150 <readline+0x89>
				cputchar(c);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	ff 75 ec             	pushl  -0x14(%ebp)
  801148:	e8 68 f4 ff ff       	call   8005b5 <cputchar>
  80114d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801153:	8d 50 01             	lea    0x1(%eax),%edx
  801156:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801159:	89 c2                	mov    %eax,%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801163:	88 10                	mov    %dl,(%eax)
  801165:	eb 56                	jmp    8011bd <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801167:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80116b:	75 1f                	jne    80118c <readline+0xc5>
  80116d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801171:	7e 19                	jle    80118c <readline+0xc5>
			if (echoing)
  801173:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801177:	74 0e                	je     801187 <readline+0xc0>
				cputchar(c);
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	ff 75 ec             	pushl  -0x14(%ebp)
  80117f:	e8 31 f4 ff ff       	call   8005b5 <cputchar>
  801184:	83 c4 10             	add    $0x10,%esp

			i--;
  801187:	ff 4d f4             	decl   -0xc(%ebp)
  80118a:	eb 31                	jmp    8011bd <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80118c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801190:	74 0a                	je     80119c <readline+0xd5>
  801192:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801196:	0f 85 61 ff ff ff    	jne    8010fd <readline+0x36>
			if (echoing)
  80119c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011a0:	74 0e                	je     8011b0 <readline+0xe9>
				cputchar(c);
  8011a2:	83 ec 0c             	sub    $0xc,%esp
  8011a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8011a8:	e8 08 f4 ff ff       	call   8005b5 <cputchar>
  8011ad:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011bb:	eb 06                	jmp    8011c3 <readline+0xfc>
		}
	}
  8011bd:	e9 3b ff ff ff       	jmp    8010fd <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011c2:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011cb:	e8 c2 0e 00 00       	call   802092 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d4:	74 13                	je     8011e9 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	68 90 40 80 00       	push   $0x804090
  8011e1:	e8 5f f8 ff ff       	call   800a45 <cprintf>
  8011e6:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	6a 00                	push   $0x0
  8011f5:	e8 51 f4 ff ff       	call   80064b <iscons>
  8011fa:	83 c4 10             	add    $0x10,%esp
  8011fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801200:	e8 f8 f3 ff ff       	call   8005fd <getchar>
  801205:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801208:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80120c:	79 23                	jns    801231 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80120e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801212:	74 13                	je     801227 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801214:	83 ec 08             	sub    $0x8,%esp
  801217:	ff 75 ec             	pushl  -0x14(%ebp)
  80121a:	68 93 40 80 00       	push   $0x804093
  80121f:	e8 21 f8 ff ff       	call   800a45 <cprintf>
  801224:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801227:	e8 80 0e 00 00       	call   8020ac <sys_enable_interrupt>
			return;
  80122c:	e9 9a 00 00 00       	jmp    8012cb <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801231:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801235:	7e 34                	jle    80126b <atomic_readline+0xa6>
  801237:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80123e:	7f 2b                	jg     80126b <atomic_readline+0xa6>
			if (echoing)
  801240:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801244:	74 0e                	je     801254 <atomic_readline+0x8f>
				cputchar(c);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	ff 75 ec             	pushl  -0x14(%ebp)
  80124c:	e8 64 f3 ff ff       	call   8005b5 <cputchar>
  801251:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801257:	8d 50 01             	lea    0x1(%eax),%edx
  80125a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80125d:	89 c2                	mov    %eax,%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801267:	88 10                	mov    %dl,(%eax)
  801269:	eb 5b                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80126b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80126f:	75 1f                	jne    801290 <atomic_readline+0xcb>
  801271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801275:	7e 19                	jle    801290 <atomic_readline+0xcb>
			if (echoing)
  801277:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127b:	74 0e                	je     80128b <atomic_readline+0xc6>
				cputchar(c);
  80127d:	83 ec 0c             	sub    $0xc,%esp
  801280:	ff 75 ec             	pushl  -0x14(%ebp)
  801283:	e8 2d f3 ff ff       	call   8005b5 <cputchar>
  801288:	83 c4 10             	add    $0x10,%esp
			i--;
  80128b:	ff 4d f4             	decl   -0xc(%ebp)
  80128e:	eb 36                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801290:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801294:	74 0a                	je     8012a0 <atomic_readline+0xdb>
  801296:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80129a:	0f 85 60 ff ff ff    	jne    801200 <atomic_readline+0x3b>
			if (echoing)
  8012a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a4:	74 0e                	je     8012b4 <atomic_readline+0xef>
				cputchar(c);
  8012a6:	83 ec 0c             	sub    $0xc,%esp
  8012a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ac:	e8 04 f3 ff ff       	call   8005b5 <cputchar>
  8012b1:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012bf:	e8 e8 0d 00 00       	call   8020ac <sys_enable_interrupt>
			return;
  8012c4:	eb 05                	jmp    8012cb <atomic_readline+0x106>
		}
	}
  8012c6:	e9 35 ff ff ff       	jmp    801200 <atomic_readline+0x3b>
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012da:	eb 06                	jmp    8012e2 <strlen+0x15>
		n++;
  8012dc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012df:	ff 45 08             	incl   0x8(%ebp)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	75 f1                	jne    8012dc <strlen+0xf>
		n++;
	return n;
  8012eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fd:	eb 09                	jmp    801308 <strnlen+0x18>
		n++;
  8012ff:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801302:	ff 45 08             	incl   0x8(%ebp)
  801305:	ff 4d 0c             	decl   0xc(%ebp)
  801308:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130c:	74 09                	je     801317 <strnlen+0x27>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	75 e8                	jne    8012ff <strnlen+0xf>
		n++;
	return n;
  801317:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801328:	90                   	nop
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 08             	mov    %edx,0x8(%ebp)
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	8d 4a 01             	lea    0x1(%edx),%ecx
  801338:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80133b:	8a 12                	mov    (%edx),%dl
  80133d:	88 10                	mov    %dl,(%eax)
  80133f:	8a 00                	mov    (%eax),%al
  801341:	84 c0                	test   %al,%al
  801343:	75 e4                	jne    801329 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135d:	eb 1f                	jmp    80137e <strncpy+0x34>
		*dst++ = *src;
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8d 50 01             	lea    0x1(%eax),%edx
  801365:	89 55 08             	mov    %edx,0x8(%ebp)
  801368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136b:	8a 12                	mov    (%edx),%dl
  80136d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80136f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801372:	8a 00                	mov    (%eax),%al
  801374:	84 c0                	test   %al,%al
  801376:	74 03                	je     80137b <strncpy+0x31>
			src++;
  801378:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80137b:	ff 45 fc             	incl   -0x4(%ebp)
  80137e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801381:	3b 45 10             	cmp    0x10(%ebp),%eax
  801384:	72 d9                	jb     80135f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801397:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139b:	74 30                	je     8013cd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80139d:	eb 16                	jmp    8013b5 <strlcpy+0x2a>
			*dst++ = *src++;
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8d 50 01             	lea    0x1(%eax),%edx
  8013a5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013b1:	8a 12                	mov    (%edx),%dl
  8013b3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b5:	ff 4d 10             	decl   0x10(%ebp)
  8013b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013bc:	74 09                	je     8013c7 <strlcpy+0x3c>
  8013be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	84 c0                	test   %al,%al
  8013c5:	75 d8                	jne    80139f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d3:	29 c2                	sub    %eax,%edx
  8013d5:	89 d0                	mov    %edx,%eax
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013dc:	eb 06                	jmp    8013e4 <strcmp+0xb>
		p++, q++;
  8013de:	ff 45 08             	incl   0x8(%ebp)
  8013e1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	84 c0                	test   %al,%al
  8013eb:	74 0e                	je     8013fb <strcmp+0x22>
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 10                	mov    (%eax),%dl
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	38 c2                	cmp    %al,%dl
  8013f9:	74 e3                	je     8013de <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f b6 d0             	movzbl %al,%edx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	0f b6 c0             	movzbl %al,%eax
  80140b:	29 c2                	sub    %eax,%edx
  80140d:	89 d0                	mov    %edx,%eax
}
  80140f:	5d                   	pop    %ebp
  801410:	c3                   	ret    

00801411 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801414:	eb 09                	jmp    80141f <strncmp+0xe>
		n--, p++, q++;
  801416:	ff 4d 10             	decl   0x10(%ebp)
  801419:	ff 45 08             	incl   0x8(%ebp)
  80141c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80141f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801423:	74 17                	je     80143c <strncmp+0x2b>
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	84 c0                	test   %al,%al
  80142c:	74 0e                	je     80143c <strncmp+0x2b>
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8a 10                	mov    (%eax),%dl
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	38 c2                	cmp    %al,%dl
  80143a:	74 da                	je     801416 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80143c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801440:	75 07                	jne    801449 <strncmp+0x38>
		return 0;
  801442:	b8 00 00 00 00       	mov    $0x0,%eax
  801447:	eb 14                	jmp    80145d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	0f b6 d0             	movzbl %al,%edx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	0f b6 c0             	movzbl %al,%eax
  801459:	29 c2                	sub    %eax,%edx
  80145b:	89 d0                	mov    %edx,%eax
}
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    

0080145f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	8b 45 0c             	mov    0xc(%ebp),%eax
  801468:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80146b:	eb 12                	jmp    80147f <strchr+0x20>
		if (*s == c)
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801475:	75 05                	jne    80147c <strchr+0x1d>
			return (char *) s;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	eb 11                	jmp    80148d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80147c:	ff 45 08             	incl   0x8(%ebp)
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	84 c0                	test   %al,%al
  801486:	75 e5                	jne    80146d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
  801498:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80149b:	eb 0d                	jmp    8014aa <strfind+0x1b>
		if (*s == c)
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014a5:	74 0e                	je     8014b5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014a7:	ff 45 08             	incl   0x8(%ebp)
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	84 c0                	test   %al,%al
  8014b1:	75 ea                	jne    80149d <strfind+0xe>
  8014b3:	eb 01                	jmp    8014b6 <strfind+0x27>
		if (*s == c)
			break;
  8014b5:	90                   	nop
	return (char *) s;
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014cd:	eb 0e                	jmp    8014dd <memset+0x22>
		*p++ = c;
  8014cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014dd:	ff 4d f8             	decl   -0x8(%ebp)
  8014e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014e4:	79 e9                	jns    8014cf <memset+0x14>
		*p++ = c;

	return v;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014fd:	eb 16                	jmp    801515 <memcpy+0x2a>
		*d++ = *s++;
  8014ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801502:	8d 50 01             	lea    0x1(%eax),%edx
  801505:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801508:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80150e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801511:	8a 12                	mov    (%edx),%dl
  801513:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	8d 50 ff             	lea    -0x1(%eax),%edx
  80151b:	89 55 10             	mov    %edx,0x10(%ebp)
  80151e:	85 c0                	test   %eax,%eax
  801520:	75 dd                	jne    8014ff <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80152d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801530:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801539:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153f:	73 50                	jae    801591 <memmove+0x6a>
  801541:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801544:	8b 45 10             	mov    0x10(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80154c:	76 43                	jbe    801591 <memmove+0x6a>
		s += n;
  80154e:	8b 45 10             	mov    0x10(%ebp),%eax
  801551:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80155a:	eb 10                	jmp    80156c <memmove+0x45>
			*--d = *--s;
  80155c:	ff 4d f8             	decl   -0x8(%ebp)
  80155f:	ff 4d fc             	decl   -0x4(%ebp)
  801562:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801565:	8a 10                	mov    (%eax),%dl
  801567:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80156c:	8b 45 10             	mov    0x10(%ebp),%eax
  80156f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801572:	89 55 10             	mov    %edx,0x10(%ebp)
  801575:	85 c0                	test   %eax,%eax
  801577:	75 e3                	jne    80155c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801579:	eb 23                	jmp    80159e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80157b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157e:	8d 50 01             	lea    0x1(%eax),%edx
  801581:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801584:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801587:	8d 4a 01             	lea    0x1(%edx),%ecx
  80158a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80158d:	8a 12                	mov    (%edx),%dl
  80158f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801591:	8b 45 10             	mov    0x10(%ebp),%eax
  801594:	8d 50 ff             	lea    -0x1(%eax),%edx
  801597:	89 55 10             	mov    %edx,0x10(%ebp)
  80159a:	85 c0                	test   %eax,%eax
  80159c:	75 dd                	jne    80157b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015b5:	eb 2a                	jmp    8015e1 <memcmp+0x3e>
		if (*s1 != *s2)
  8015b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ba:	8a 10                	mov    (%eax),%dl
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	38 c2                	cmp    %al,%dl
  8015c3:	74 16                	je     8015db <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	0f b6 d0             	movzbl %al,%edx
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	0f b6 c0             	movzbl %al,%eax
  8015d5:	29 c2                	sub    %eax,%edx
  8015d7:	89 d0                	mov    %edx,%eax
  8015d9:	eb 18                	jmp    8015f3 <memcmp+0x50>
		s1++, s2++;
  8015db:	ff 45 fc             	incl   -0x4(%ebp)
  8015de:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	75 c9                	jne    8015b7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801601:	01 d0                	add    %edx,%eax
  801603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801606:	eb 15                	jmp    80161d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	0f b6 d0             	movzbl %al,%edx
  801610:	8b 45 0c             	mov    0xc(%ebp),%eax
  801613:	0f b6 c0             	movzbl %al,%eax
  801616:	39 c2                	cmp    %eax,%edx
  801618:	74 0d                	je     801627 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80161a:	ff 45 08             	incl   0x8(%ebp)
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801623:	72 e3                	jb     801608 <memfind+0x13>
  801625:	eb 01                	jmp    801628 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801627:	90                   	nop
	return (void *) s;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801633:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80163a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801641:	eb 03                	jmp    801646 <strtol+0x19>
		s++;
  801643:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	3c 20                	cmp    $0x20,%al
  80164d:	74 f4                	je     801643 <strtol+0x16>
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8a 00                	mov    (%eax),%al
  801654:	3c 09                	cmp    $0x9,%al
  801656:	74 eb                	je     801643 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	8a 00                	mov    (%eax),%al
  80165d:	3c 2b                	cmp    $0x2b,%al
  80165f:	75 05                	jne    801666 <strtol+0x39>
		s++;
  801661:	ff 45 08             	incl   0x8(%ebp)
  801664:	eb 13                	jmp    801679 <strtol+0x4c>
	else if (*s == '-')
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	8a 00                	mov    (%eax),%al
  80166b:	3c 2d                	cmp    $0x2d,%al
  80166d:	75 0a                	jne    801679 <strtol+0x4c>
		s++, neg = 1;
  80166f:	ff 45 08             	incl   0x8(%ebp)
  801672:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801679:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80167d:	74 06                	je     801685 <strtol+0x58>
  80167f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801683:	75 20                	jne    8016a5 <strtol+0x78>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	3c 30                	cmp    $0x30,%al
  80168c:	75 17                	jne    8016a5 <strtol+0x78>
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	40                   	inc    %eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 78                	cmp    $0x78,%al
  801696:	75 0d                	jne    8016a5 <strtol+0x78>
		s += 2, base = 16;
  801698:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80169c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016a3:	eb 28                	jmp    8016cd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a9:	75 15                	jne    8016c0 <strtol+0x93>
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	3c 30                	cmp    $0x30,%al
  8016b2:	75 0c                	jne    8016c0 <strtol+0x93>
		s++, base = 8;
  8016b4:	ff 45 08             	incl   0x8(%ebp)
  8016b7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016be:	eb 0d                	jmp    8016cd <strtol+0xa0>
	else if (base == 0)
  8016c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c4:	75 07                	jne    8016cd <strtol+0xa0>
		base = 10;
  8016c6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	3c 2f                	cmp    $0x2f,%al
  8016d4:	7e 19                	jle    8016ef <strtol+0xc2>
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 39                	cmp    $0x39,%al
  8016dd:	7f 10                	jg     8016ef <strtol+0xc2>
			dig = *s - '0';
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	0f be c0             	movsbl %al,%eax
  8016e7:	83 e8 30             	sub    $0x30,%eax
  8016ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ed:	eb 42                	jmp    801731 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	3c 60                	cmp    $0x60,%al
  8016f6:	7e 19                	jle    801711 <strtol+0xe4>
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8a 00                	mov    (%eax),%al
  8016fd:	3c 7a                	cmp    $0x7a,%al
  8016ff:	7f 10                	jg     801711 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	0f be c0             	movsbl %al,%eax
  801709:	83 e8 57             	sub    $0x57,%eax
  80170c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80170f:	eb 20                	jmp    801731 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8a 00                	mov    (%eax),%al
  801716:	3c 40                	cmp    $0x40,%al
  801718:	7e 39                	jle    801753 <strtol+0x126>
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3c 5a                	cmp    $0x5a,%al
  801721:	7f 30                	jg     801753 <strtol+0x126>
			dig = *s - 'A' + 10;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	0f be c0             	movsbl %al,%eax
  80172b:	83 e8 37             	sub    $0x37,%eax
  80172e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	3b 45 10             	cmp    0x10(%ebp),%eax
  801737:	7d 19                	jge    801752 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801739:	ff 45 08             	incl   0x8(%ebp)
  80173c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801743:	89 c2                	mov    %eax,%edx
  801745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80174d:	e9 7b ff ff ff       	jmp    8016cd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801752:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801753:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801757:	74 08                	je     801761 <strtol+0x134>
		*endptr = (char *) s;
  801759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175c:	8b 55 08             	mov    0x8(%ebp),%edx
  80175f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801761:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801765:	74 07                	je     80176e <strtol+0x141>
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	f7 d8                	neg    %eax
  80176c:	eb 03                	jmp    801771 <strtol+0x144>
  80176e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <ltostr>:

void
ltostr(long value, char *str)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801787:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80178b:	79 13                	jns    8017a0 <ltostr+0x2d>
	{
		neg = 1;
  80178d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80179a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80179d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017a8:	99                   	cltd   
  8017a9:	f7 f9                	idiv   %ecx
  8017ab:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b1:	8d 50 01             	lea    0x1(%eax),%edx
  8017b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017c1:	83 c2 30             	add    $0x30,%edx
  8017c4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017ce:	f7 e9                	imul   %ecx
  8017d0:	c1 fa 02             	sar    $0x2,%edx
  8017d3:	89 c8                	mov    %ecx,%eax
  8017d5:	c1 f8 1f             	sar    $0x1f,%eax
  8017d8:	29 c2                	sub    %eax,%edx
  8017da:	89 d0                	mov    %edx,%eax
  8017dc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017e7:	f7 e9                	imul   %ecx
  8017e9:	c1 fa 02             	sar    $0x2,%edx
  8017ec:	89 c8                	mov    %ecx,%eax
  8017ee:	c1 f8 1f             	sar    $0x1f,%eax
  8017f1:	29 c2                	sub    %eax,%edx
  8017f3:	89 d0                	mov    %edx,%eax
  8017f5:	c1 e0 02             	shl    $0x2,%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	01 c0                	add    %eax,%eax
  8017fc:	29 c1                	sub    %eax,%ecx
  8017fe:	89 ca                	mov    %ecx,%edx
  801800:	85 d2                	test   %edx,%edx
  801802:	75 9c                	jne    8017a0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180e:	48                   	dec    %eax
  80180f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801812:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801816:	74 3d                	je     801855 <ltostr+0xe2>
		start = 1 ;
  801818:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80181f:	eb 34                	jmp    801855 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	01 d0                	add    %edx,%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80182e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	01 c2                	add    %eax,%edx
  801836:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183c:	01 c8                	add    %ecx,%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801842:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801845:	8b 45 0c             	mov    0xc(%ebp),%eax
  801848:	01 c2                	add    %eax,%edx
  80184a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80184d:	88 02                	mov    %al,(%edx)
		start++ ;
  80184f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801852:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801858:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80185b:	7c c4                	jl     801821 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80185d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801860:	8b 45 0c             	mov    0xc(%ebp),%eax
  801863:	01 d0                	add    %edx,%eax
  801865:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801868:	90                   	nop
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	e8 54 fa ff ff       	call   8012cd <strlen>
  801879:	83 c4 04             	add    $0x4,%esp
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	e8 46 fa ff ff       	call   8012cd <strlen>
  801887:	83 c4 04             	add    $0x4,%esp
  80188a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80188d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801894:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80189b:	eb 17                	jmp    8018b4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80189d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a3:	01 c2                	add    %eax,%edx
  8018a5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	01 c8                	add    %ecx,%eax
  8018ad:	8a 00                	mov    (%eax),%al
  8018af:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018b1:	ff 45 fc             	incl   -0x4(%ebp)
  8018b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018ba:	7c e1                	jl     80189d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018ca:	eb 1f                	jmp    8018eb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	01 c2                	add    %eax,%edx
  8018dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	01 c8                	add    %ecx,%eax
  8018e4:	8a 00                	mov    (%eax),%al
  8018e6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018e8:	ff 45 f8             	incl   -0x8(%ebp)
  8018eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018f1:	7c d9                	jl     8018cc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	c6 00 00             	movb   $0x0,(%eax)
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801904:	8b 45 14             	mov    0x14(%ebp),%eax
  801907:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80190d:	8b 45 14             	mov    0x14(%ebp),%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801919:	8b 45 10             	mov    0x10(%ebp),%eax
  80191c:	01 d0                	add    %edx,%eax
  80191e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801924:	eb 0c                	jmp    801932 <strsplit+0x31>
			*string++ = 0;
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8d 50 01             	lea    0x1(%eax),%edx
  80192c:	89 55 08             	mov    %edx,0x8(%ebp)
  80192f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	84 c0                	test   %al,%al
  801939:	74 18                	je     801953 <strsplit+0x52>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8a 00                	mov    (%eax),%al
  801940:	0f be c0             	movsbl %al,%eax
  801943:	50                   	push   %eax
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	e8 13 fb ff ff       	call   80145f <strchr>
  80194c:	83 c4 08             	add    $0x8,%esp
  80194f:	85 c0                	test   %eax,%eax
  801951:	75 d3                	jne    801926 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8a 00                	mov    (%eax),%al
  801958:	84 c0                	test   %al,%al
  80195a:	74 5a                	je     8019b6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	83 f8 0f             	cmp    $0xf,%eax
  801964:	75 07                	jne    80196d <strsplit+0x6c>
		{
			return 0;
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	eb 66                	jmp    8019d3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80196d:	8b 45 14             	mov    0x14(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	8d 48 01             	lea    0x1(%eax),%ecx
  801975:	8b 55 14             	mov    0x14(%ebp),%edx
  801978:	89 0a                	mov    %ecx,(%edx)
  80197a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801981:	8b 45 10             	mov    0x10(%ebp),%eax
  801984:	01 c2                	add    %eax,%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80198b:	eb 03                	jmp    801990 <strsplit+0x8f>
			string++;
  80198d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8a 00                	mov    (%eax),%al
  801995:	84 c0                	test   %al,%al
  801997:	74 8b                	je     801924 <strsplit+0x23>
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f be c0             	movsbl %al,%eax
  8019a1:	50                   	push   %eax
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	e8 b5 fa ff ff       	call   80145f <strchr>
  8019aa:	83 c4 08             	add    $0x8,%esp
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	74 dc                	je     80198d <strsplit+0x8c>
			string++;
	}
  8019b1:	e9 6e ff ff ff       	jmp    801924 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019b6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	8b 00                	mov    (%eax),%eax
  8019bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c6:	01 d0                	add    %edx,%eax
  8019c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019db:	a1 04 50 80 00       	mov    0x805004,%eax
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	74 1f                	je     801a03 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019e4:	e8 1d 00 00 00       	call   801a06 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019e9:	83 ec 0c             	sub    $0xc,%esp
  8019ec:	68 a4 40 80 00       	push   $0x8040a4
  8019f1:	e8 4f f0 ff ff       	call   800a45 <cprintf>
  8019f6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019f9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a00:	00 00 00 
	}
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801a0c:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a13:	00 00 00 
  801a16:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a1d:	00 00 00 
  801a20:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a27:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801a2a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a31:	00 00 00 
  801a34:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a3b:	00 00 00 
  801a3e:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a45:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801a48:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801a4f:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801a52:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a61:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a66:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801a6b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a72:	a1 20 51 80 00       	mov    0x805120,%eax
  801a77:	c1 e0 04             	shl    $0x4,%eax
  801a7a:	89 c2                	mov    %eax,%edx
  801a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7f:	01 d0                	add    %edx,%eax
  801a81:	48                   	dec    %eax
  801a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a88:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8d:	f7 75 f0             	divl   -0x10(%ebp)
  801a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a93:	29 d0                	sub    %edx,%eax
  801a95:	89 c2                	mov    %eax,%edx
  801a97:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aa1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801aa6:	2d 00 10 00 00       	sub    $0x1000,%eax
  801aab:	83 ec 04             	sub    $0x4,%esp
  801aae:	6a 06                	push   $0x6
  801ab0:	52                   	push   %edx
  801ab1:	50                   	push   %eax
  801ab2:	e8 71 05 00 00       	call   802028 <sys_allocate_chunk>
  801ab7:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801aba:	a1 20 51 80 00       	mov    0x805120,%eax
  801abf:	83 ec 0c             	sub    $0xc,%esp
  801ac2:	50                   	push   %eax
  801ac3:	e8 e6 0b 00 00       	call   8026ae <initialize_MemBlocksList>
  801ac8:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801acb:	a1 48 51 80 00       	mov    0x805148,%eax
  801ad0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801ad3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ad7:	75 14                	jne    801aed <initialize_dyn_block_system+0xe7>
  801ad9:	83 ec 04             	sub    $0x4,%esp
  801adc:	68 c9 40 80 00       	push   $0x8040c9
  801ae1:	6a 2b                	push   $0x2b
  801ae3:	68 e7 40 80 00       	push   $0x8040e7
  801ae8:	e8 a4 ec ff ff       	call   800791 <_panic>
  801aed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801af0:	8b 00                	mov    (%eax),%eax
  801af2:	85 c0                	test   %eax,%eax
  801af4:	74 10                	je     801b06 <initialize_dyn_block_system+0x100>
  801af6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801af9:	8b 00                	mov    (%eax),%eax
  801afb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801afe:	8b 52 04             	mov    0x4(%edx),%edx
  801b01:	89 50 04             	mov    %edx,0x4(%eax)
  801b04:	eb 0b                	jmp    801b11 <initialize_dyn_block_system+0x10b>
  801b06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b09:	8b 40 04             	mov    0x4(%eax),%eax
  801b0c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b14:	8b 40 04             	mov    0x4(%eax),%eax
  801b17:	85 c0                	test   %eax,%eax
  801b19:	74 0f                	je     801b2a <initialize_dyn_block_system+0x124>
  801b1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b1e:	8b 40 04             	mov    0x4(%eax),%eax
  801b21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b24:	8b 12                	mov    (%edx),%edx
  801b26:	89 10                	mov    %edx,(%eax)
  801b28:	eb 0a                	jmp    801b34 <initialize_dyn_block_system+0x12e>
  801b2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b2d:	8b 00                	mov    (%eax),%eax
  801b2f:	a3 48 51 80 00       	mov    %eax,0x805148
  801b34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b47:	a1 54 51 80 00       	mov    0x805154,%eax
  801b4c:	48                   	dec    %eax
  801b4d:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801b52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b55:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801b5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b5f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801b66:	83 ec 0c             	sub    $0xc,%esp
  801b69:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b6c:	e8 d2 13 00 00       	call   802f43 <insert_sorted_with_merge_freeList>
  801b71:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801b74:	90                   	nop
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b7d:	e8 53 fe ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b86:	75 07                	jne    801b8f <malloc+0x18>
  801b88:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8d:	eb 61                	jmp    801bf0 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801b8f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b96:	8b 55 08             	mov    0x8(%ebp),%edx
  801b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9c:	01 d0                	add    %edx,%eax
  801b9e:	48                   	dec    %eax
  801b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  801baa:	f7 75 f4             	divl   -0xc(%ebp)
  801bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb0:	29 d0                	sub    %edx,%eax
  801bb2:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801bb5:	e8 3c 08 00 00       	call   8023f6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bba:	85 c0                	test   %eax,%eax
  801bbc:	74 2d                	je     801beb <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801bbe:	83 ec 0c             	sub    $0xc,%esp
  801bc1:	ff 75 08             	pushl  0x8(%ebp)
  801bc4:	e8 3e 0f 00 00       	call   802b07 <alloc_block_FF>
  801bc9:	83 c4 10             	add    $0x10,%esp
  801bcc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801bcf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bd3:	74 16                	je     801beb <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801bd5:	83 ec 0c             	sub    $0xc,%esp
  801bd8:	ff 75 ec             	pushl  -0x14(%ebp)
  801bdb:	e8 48 0c 00 00       	call   802828 <insert_sorted_allocList>
  801be0:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801be3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be6:	8b 40 08             	mov    0x8(%eax),%eax
  801be9:	eb 05                	jmp    801bf0 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801beb:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
  801bf5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c01:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c06:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	83 ec 08             	sub    $0x8,%esp
  801c0f:	50                   	push   %eax
  801c10:	68 40 50 80 00       	push   $0x805040
  801c15:	e8 71 0b 00 00       	call   80278b <find_block>
  801c1a:	83 c4 10             	add    $0x10,%esp
  801c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801c20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c23:	8b 50 0c             	mov    0xc(%eax),%edx
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	83 ec 08             	sub    $0x8,%esp
  801c2c:	52                   	push   %edx
  801c2d:	50                   	push   %eax
  801c2e:	e8 bd 03 00 00       	call   801ff0 <sys_free_user_mem>
  801c33:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801c36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c3a:	75 14                	jne    801c50 <free+0x5e>
  801c3c:	83 ec 04             	sub    $0x4,%esp
  801c3f:	68 c9 40 80 00       	push   $0x8040c9
  801c44:	6a 71                	push   $0x71
  801c46:	68 e7 40 80 00       	push   $0x8040e7
  801c4b:	e8 41 eb ff ff       	call   800791 <_panic>
  801c50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c53:	8b 00                	mov    (%eax),%eax
  801c55:	85 c0                	test   %eax,%eax
  801c57:	74 10                	je     801c69 <free+0x77>
  801c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5c:	8b 00                	mov    (%eax),%eax
  801c5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c61:	8b 52 04             	mov    0x4(%edx),%edx
  801c64:	89 50 04             	mov    %edx,0x4(%eax)
  801c67:	eb 0b                	jmp    801c74 <free+0x82>
  801c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6c:	8b 40 04             	mov    0x4(%eax),%eax
  801c6f:	a3 44 50 80 00       	mov    %eax,0x805044
  801c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c77:	8b 40 04             	mov    0x4(%eax),%eax
  801c7a:	85 c0                	test   %eax,%eax
  801c7c:	74 0f                	je     801c8d <free+0x9b>
  801c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c81:	8b 40 04             	mov    0x4(%eax),%eax
  801c84:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c87:	8b 12                	mov    (%edx),%edx
  801c89:	89 10                	mov    %edx,(%eax)
  801c8b:	eb 0a                	jmp    801c97 <free+0xa5>
  801c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c90:	8b 00                	mov    (%eax),%eax
  801c92:	a3 40 50 80 00       	mov    %eax,0x805040
  801c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ca0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801caa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801caf:	48                   	dec    %eax
  801cb0:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801cb5:	83 ec 0c             	sub    $0xc,%esp
  801cb8:	ff 75 f0             	pushl  -0x10(%ebp)
  801cbb:	e8 83 12 00 00       	call   802f43 <insert_sorted_with_merge_freeList>
  801cc0:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801cc3:	90                   	nop
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 28             	sub    $0x28,%esp
  801ccc:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccf:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cd2:	e8 fe fc ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cdb:	75 0a                	jne    801ce7 <smalloc+0x21>
  801cdd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ce2:	e9 86 00 00 00       	jmp    801d6d <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801ce7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801cee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cf4:	01 d0                	add    %edx,%eax
  801cf6:	48                   	dec    %eax
  801cf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  801d02:	f7 75 f4             	divl   -0xc(%ebp)
  801d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d08:	29 d0                	sub    %edx,%eax
  801d0a:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d0d:	e8 e4 06 00 00       	call   8023f6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d12:	85 c0                	test   %eax,%eax
  801d14:	74 52                	je     801d68 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801d16:	83 ec 0c             	sub    $0xc,%esp
  801d19:	ff 75 0c             	pushl  0xc(%ebp)
  801d1c:	e8 e6 0d 00 00       	call   802b07 <alloc_block_FF>
  801d21:	83 c4 10             	add    $0x10,%esp
  801d24:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801d27:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d2b:	75 07                	jne    801d34 <smalloc+0x6e>
			return NULL ;
  801d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d32:	eb 39                	jmp    801d6d <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d37:	8b 40 08             	mov    0x8(%eax),%eax
  801d3a:	89 c2                	mov    %eax,%edx
  801d3c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d40:	52                   	push   %edx
  801d41:	50                   	push   %eax
  801d42:	ff 75 0c             	pushl  0xc(%ebp)
  801d45:	ff 75 08             	pushl  0x8(%ebp)
  801d48:	e8 2e 04 00 00       	call   80217b <sys_createSharedObject>
  801d4d:	83 c4 10             	add    $0x10,%esp
  801d50:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801d53:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d57:	79 07                	jns    801d60 <smalloc+0x9a>
			return (void*)NULL ;
  801d59:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5e:	eb 0d                	jmp    801d6d <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d63:	8b 40 08             	mov    0x8(%eax),%eax
  801d66:	eb 05                	jmp    801d6d <smalloc+0xa7>
		}
		return (void*)NULL ;
  801d68:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d75:	e8 5b fc ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d7a:	83 ec 08             	sub    $0x8,%esp
  801d7d:	ff 75 0c             	pushl  0xc(%ebp)
  801d80:	ff 75 08             	pushl  0x8(%ebp)
  801d83:	e8 1d 04 00 00       	call   8021a5 <sys_getSizeOfSharedObject>
  801d88:	83 c4 10             	add    $0x10,%esp
  801d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801d8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d92:	75 0a                	jne    801d9e <sget+0x2f>
			return NULL ;
  801d94:	b8 00 00 00 00       	mov    $0x0,%eax
  801d99:	e9 83 00 00 00       	jmp    801e21 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801d9e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801da5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dab:	01 d0                	add    %edx,%eax
  801dad:	48                   	dec    %eax
  801dae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801db1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db4:	ba 00 00 00 00       	mov    $0x0,%edx
  801db9:	f7 75 f0             	divl   -0x10(%ebp)
  801dbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dbf:	29 d0                	sub    %edx,%eax
  801dc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801dc4:	e8 2d 06 00 00       	call   8023f6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dc9:	85 c0                	test   %eax,%eax
  801dcb:	74 4f                	je     801e1c <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd0:	83 ec 0c             	sub    $0xc,%esp
  801dd3:	50                   	push   %eax
  801dd4:	e8 2e 0d 00 00       	call   802b07 <alloc_block_FF>
  801dd9:	83 c4 10             	add    $0x10,%esp
  801ddc:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801ddf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801de3:	75 07                	jne    801dec <sget+0x7d>
					return (void*)NULL ;
  801de5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dea:	eb 35                	jmp    801e21 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801dec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801def:	8b 40 08             	mov    0x8(%eax),%eax
  801df2:	83 ec 04             	sub    $0x4,%esp
  801df5:	50                   	push   %eax
  801df6:	ff 75 0c             	pushl  0xc(%ebp)
  801df9:	ff 75 08             	pushl  0x8(%ebp)
  801dfc:	e8 c1 03 00 00       	call   8021c2 <sys_getSharedObject>
  801e01:	83 c4 10             	add    $0x10,%esp
  801e04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801e07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e0b:	79 07                	jns    801e14 <sget+0xa5>
				return (void*)NULL ;
  801e0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e12:	eb 0d                	jmp    801e21 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801e14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e17:	8b 40 08             	mov    0x8(%eax),%eax
  801e1a:	eb 05                	jmp    801e21 <sget+0xb2>


		}
	return (void*)NULL ;
  801e1c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e29:	e8 a7 fb ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e2e:	83 ec 04             	sub    $0x4,%esp
  801e31:	68 f4 40 80 00       	push   $0x8040f4
  801e36:	68 f9 00 00 00       	push   $0xf9
  801e3b:	68 e7 40 80 00       	push   $0x8040e7
  801e40:	e8 4c e9 ff ff       	call   800791 <_panic>

00801e45 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e4b:	83 ec 04             	sub    $0x4,%esp
  801e4e:	68 1c 41 80 00       	push   $0x80411c
  801e53:	68 0d 01 00 00       	push   $0x10d
  801e58:	68 e7 40 80 00       	push   $0x8040e7
  801e5d:	e8 2f e9 ff ff       	call   800791 <_panic>

00801e62 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e68:	83 ec 04             	sub    $0x4,%esp
  801e6b:	68 40 41 80 00       	push   $0x804140
  801e70:	68 18 01 00 00       	push   $0x118
  801e75:	68 e7 40 80 00       	push   $0x8040e7
  801e7a:	e8 12 e9 ff ff       	call   800791 <_panic>

00801e7f <shrink>:

}
void shrink(uint32 newSize)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e85:	83 ec 04             	sub    $0x4,%esp
  801e88:	68 40 41 80 00       	push   $0x804140
  801e8d:	68 1d 01 00 00       	push   $0x11d
  801e92:	68 e7 40 80 00       	push   $0x8040e7
  801e97:	e8 f5 e8 ff ff       	call   800791 <_panic>

00801e9c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ea2:	83 ec 04             	sub    $0x4,%esp
  801ea5:	68 40 41 80 00       	push   $0x804140
  801eaa:	68 22 01 00 00       	push   $0x122
  801eaf:	68 e7 40 80 00       	push   $0x8040e7
  801eb4:	e8 d8 e8 ff ff       	call   800791 <_panic>

00801eb9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	57                   	push   %edi
  801ebd:	56                   	push   %esi
  801ebe:	53                   	push   %ebx
  801ebf:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ecb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ece:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ed1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ed4:	cd 30                	int    $0x30
  801ed6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801edc:	83 c4 10             	add    $0x10,%esp
  801edf:	5b                   	pop    %ebx
  801ee0:	5e                   	pop    %esi
  801ee1:	5f                   	pop    %edi
  801ee2:	5d                   	pop    %ebp
  801ee3:	c3                   	ret    

00801ee4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	83 ec 04             	sub    $0x4,%esp
  801eea:	8b 45 10             	mov    0x10(%ebp),%eax
  801eed:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ef0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	52                   	push   %edx
  801efc:	ff 75 0c             	pushl  0xc(%ebp)
  801eff:	50                   	push   %eax
  801f00:	6a 00                	push   $0x0
  801f02:	e8 b2 ff ff ff       	call   801eb9 <syscall>
  801f07:	83 c4 18             	add    $0x18,%esp
}
  801f0a:	90                   	nop
  801f0b:	c9                   	leave  
  801f0c:	c3                   	ret    

00801f0d <sys_cgetc>:

int
sys_cgetc(void)
{
  801f0d:	55                   	push   %ebp
  801f0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 01                	push   $0x1
  801f1c:	e8 98 ff ff ff       	call   801eb9 <syscall>
  801f21:	83 c4 18             	add    $0x18,%esp
}
  801f24:	c9                   	leave  
  801f25:	c3                   	ret    

00801f26 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f26:	55                   	push   %ebp
  801f27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	52                   	push   %edx
  801f36:	50                   	push   %eax
  801f37:	6a 05                	push   $0x5
  801f39:	e8 7b ff ff ff       	call   801eb9 <syscall>
  801f3e:	83 c4 18             	add    $0x18,%esp
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	56                   	push   %esi
  801f47:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f48:	8b 75 18             	mov    0x18(%ebp),%esi
  801f4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	56                   	push   %esi
  801f58:	53                   	push   %ebx
  801f59:	51                   	push   %ecx
  801f5a:	52                   	push   %edx
  801f5b:	50                   	push   %eax
  801f5c:	6a 06                	push   $0x6
  801f5e:	e8 56 ff ff ff       	call   801eb9 <syscall>
  801f63:	83 c4 18             	add    $0x18,%esp
}
  801f66:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f69:	5b                   	pop    %ebx
  801f6a:	5e                   	pop    %esi
  801f6b:	5d                   	pop    %ebp
  801f6c:	c3                   	ret    

00801f6d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f70:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	52                   	push   %edx
  801f7d:	50                   	push   %eax
  801f7e:	6a 07                	push   $0x7
  801f80:	e8 34 ff ff ff       	call   801eb9 <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
}
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	ff 75 0c             	pushl  0xc(%ebp)
  801f96:	ff 75 08             	pushl  0x8(%ebp)
  801f99:	6a 08                	push   $0x8
  801f9b:	e8 19 ff ff ff       	call   801eb9 <syscall>
  801fa0:	83 c4 18             	add    $0x18,%esp
}
  801fa3:	c9                   	leave  
  801fa4:	c3                   	ret    

00801fa5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 09                	push   $0x9
  801fb4:	e8 00 ff ff ff       	call   801eb9 <syscall>
  801fb9:	83 c4 18             	add    $0x18,%esp
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 0a                	push   $0xa
  801fcd:	e8 e7 fe ff ff       	call   801eb9 <syscall>
  801fd2:	83 c4 18             	add    $0x18,%esp
}
  801fd5:	c9                   	leave  
  801fd6:	c3                   	ret    

00801fd7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fd7:	55                   	push   %ebp
  801fd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 00                	push   $0x0
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 0b                	push   $0xb
  801fe6:	e8 ce fe ff ff       	call   801eb9 <syscall>
  801feb:	83 c4 18             	add    $0x18,%esp
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	ff 75 0c             	pushl  0xc(%ebp)
  801ffc:	ff 75 08             	pushl  0x8(%ebp)
  801fff:	6a 0f                	push   $0xf
  802001:	e8 b3 fe ff ff       	call   801eb9 <syscall>
  802006:	83 c4 18             	add    $0x18,%esp
	return;
  802009:	90                   	nop
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	ff 75 0c             	pushl  0xc(%ebp)
  802018:	ff 75 08             	pushl  0x8(%ebp)
  80201b:	6a 10                	push   $0x10
  80201d:	e8 97 fe ff ff       	call   801eb9 <syscall>
  802022:	83 c4 18             	add    $0x18,%esp
	return ;
  802025:	90                   	nop
}
  802026:	c9                   	leave  
  802027:	c3                   	ret    

00802028 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802028:	55                   	push   %ebp
  802029:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80202b:	6a 00                	push   $0x0
  80202d:	6a 00                	push   $0x0
  80202f:	ff 75 10             	pushl  0x10(%ebp)
  802032:	ff 75 0c             	pushl  0xc(%ebp)
  802035:	ff 75 08             	pushl  0x8(%ebp)
  802038:	6a 11                	push   $0x11
  80203a:	e8 7a fe ff ff       	call   801eb9 <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
	return ;
  802042:	90                   	nop
}
  802043:	c9                   	leave  
  802044:	c3                   	ret    

00802045 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 0c                	push   $0xc
  802054:	e8 60 fe ff ff       	call   801eb9 <syscall>
  802059:	83 c4 18             	add    $0x18,%esp
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	ff 75 08             	pushl  0x8(%ebp)
  80206c:	6a 0d                	push   $0xd
  80206e:	e8 46 fe ff ff       	call   801eb9 <syscall>
  802073:	83 c4 18             	add    $0x18,%esp
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 0e                	push   $0xe
  802087:	e8 2d fe ff ff       	call   801eb9 <syscall>
  80208c:	83 c4 18             	add    $0x18,%esp
}
  80208f:	90                   	nop
  802090:	c9                   	leave  
  802091:	c3                   	ret    

00802092 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802092:	55                   	push   %ebp
  802093:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	6a 13                	push   $0x13
  8020a1:	e8 13 fe ff ff       	call   801eb9 <syscall>
  8020a6:	83 c4 18             	add    $0x18,%esp
}
  8020a9:	90                   	nop
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020af:	6a 00                	push   $0x0
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 14                	push   $0x14
  8020bb:	e8 f9 fd ff ff       	call   801eb9 <syscall>
  8020c0:	83 c4 18             	add    $0x18,%esp
}
  8020c3:	90                   	nop
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 04             	sub    $0x4,%esp
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	50                   	push   %eax
  8020df:	6a 15                	push   $0x15
  8020e1:	e8 d3 fd ff ff       	call   801eb9 <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	90                   	nop
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 16                	push   $0x16
  8020fb:	e8 b9 fd ff ff       	call   801eb9 <syscall>
  802100:	83 c4 18             	add    $0x18,%esp
}
  802103:	90                   	nop
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802109:	8b 45 08             	mov    0x8(%ebp),%eax
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	ff 75 0c             	pushl  0xc(%ebp)
  802115:	50                   	push   %eax
  802116:	6a 17                	push   $0x17
  802118:	e8 9c fd ff ff       	call   801eb9 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802125:	8b 55 0c             	mov    0xc(%ebp),%edx
  802128:	8b 45 08             	mov    0x8(%ebp),%eax
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	52                   	push   %edx
  802132:	50                   	push   %eax
  802133:	6a 1a                	push   $0x1a
  802135:	e8 7f fd ff ff       	call   801eb9 <syscall>
  80213a:	83 c4 18             	add    $0x18,%esp
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802142:	8b 55 0c             	mov    0xc(%ebp),%edx
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	52                   	push   %edx
  80214f:	50                   	push   %eax
  802150:	6a 18                	push   $0x18
  802152:	e8 62 fd ff ff       	call   801eb9 <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
}
  80215a:	90                   	nop
  80215b:	c9                   	leave  
  80215c:	c3                   	ret    

0080215d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80215d:	55                   	push   %ebp
  80215e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802160:	8b 55 0c             	mov    0xc(%ebp),%edx
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	52                   	push   %edx
  80216d:	50                   	push   %eax
  80216e:	6a 19                	push   $0x19
  802170:	e8 44 fd ff ff       	call   801eb9 <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
}
  802178:	90                   	nop
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	83 ec 04             	sub    $0x4,%esp
  802181:	8b 45 10             	mov    0x10(%ebp),%eax
  802184:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802187:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80218a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80218e:	8b 45 08             	mov    0x8(%ebp),%eax
  802191:	6a 00                	push   $0x0
  802193:	51                   	push   %ecx
  802194:	52                   	push   %edx
  802195:	ff 75 0c             	pushl  0xc(%ebp)
  802198:	50                   	push   %eax
  802199:	6a 1b                	push   $0x1b
  80219b:	e8 19 fd ff ff       	call   801eb9 <syscall>
  8021a0:	83 c4 18             	add    $0x18,%esp
}
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	52                   	push   %edx
  8021b5:	50                   	push   %eax
  8021b6:	6a 1c                	push   $0x1c
  8021b8:	e8 fc fc ff ff       	call   801eb9 <syscall>
  8021bd:	83 c4 18             	add    $0x18,%esp
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	51                   	push   %ecx
  8021d3:	52                   	push   %edx
  8021d4:	50                   	push   %eax
  8021d5:	6a 1d                	push   $0x1d
  8021d7:	e8 dd fc ff ff       	call   801eb9 <syscall>
  8021dc:	83 c4 18             	add    $0x18,%esp
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	52                   	push   %edx
  8021f1:	50                   	push   %eax
  8021f2:	6a 1e                	push   $0x1e
  8021f4:	e8 c0 fc ff ff       	call   801eb9 <syscall>
  8021f9:	83 c4 18             	add    $0x18,%esp
}
  8021fc:	c9                   	leave  
  8021fd:	c3                   	ret    

008021fe <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021fe:	55                   	push   %ebp
  8021ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 1f                	push   $0x1f
  80220d:	e8 a7 fc ff ff       	call   801eb9 <syscall>
  802212:	83 c4 18             	add    $0x18,%esp
}
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	6a 00                	push   $0x0
  80221f:	ff 75 14             	pushl  0x14(%ebp)
  802222:	ff 75 10             	pushl  0x10(%ebp)
  802225:	ff 75 0c             	pushl  0xc(%ebp)
  802228:	50                   	push   %eax
  802229:	6a 20                	push   $0x20
  80222b:	e8 89 fc ff ff       	call   801eb9 <syscall>
  802230:	83 c4 18             	add    $0x18,%esp
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802238:	8b 45 08             	mov    0x8(%ebp),%eax
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	50                   	push   %eax
  802244:	6a 21                	push   $0x21
  802246:	e8 6e fc ff ff       	call   801eb9 <syscall>
  80224b:	83 c4 18             	add    $0x18,%esp
}
  80224e:	90                   	nop
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

00802251 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	50                   	push   %eax
  802260:	6a 22                	push   $0x22
  802262:	e8 52 fc ff ff       	call   801eb9 <syscall>
  802267:	83 c4 18             	add    $0x18,%esp
}
  80226a:	c9                   	leave  
  80226b:	c3                   	ret    

0080226c <sys_getenvid>:

int32 sys_getenvid(void)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 02                	push   $0x2
  80227b:	e8 39 fc ff ff       	call   801eb9 <syscall>
  802280:	83 c4 18             	add    $0x18,%esp
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 03                	push   $0x3
  802294:	e8 20 fc ff ff       	call   801eb9 <syscall>
  802299:	83 c4 18             	add    $0x18,%esp
}
  80229c:	c9                   	leave  
  80229d:	c3                   	ret    

0080229e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 04                	push   $0x4
  8022ad:	e8 07 fc ff ff       	call   801eb9 <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
}
  8022b5:	c9                   	leave  
  8022b6:	c3                   	ret    

008022b7 <sys_exit_env>:


void sys_exit_env(void)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 23                	push   $0x23
  8022c6:	e8 ee fb ff ff       	call   801eb9 <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
}
  8022ce:	90                   	nop
  8022cf:	c9                   	leave  
  8022d0:	c3                   	ret    

008022d1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022d7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022da:	8d 50 04             	lea    0x4(%eax),%edx
  8022dd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	52                   	push   %edx
  8022e7:	50                   	push   %eax
  8022e8:	6a 24                	push   $0x24
  8022ea:	e8 ca fb ff ff       	call   801eb9 <syscall>
  8022ef:	83 c4 18             	add    $0x18,%esp
	return result;
  8022f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022fb:	89 01                	mov    %eax,(%ecx)
  8022fd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	c9                   	leave  
  802304:	c2 04 00             	ret    $0x4

00802307 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	ff 75 10             	pushl  0x10(%ebp)
  802311:	ff 75 0c             	pushl  0xc(%ebp)
  802314:	ff 75 08             	pushl  0x8(%ebp)
  802317:	6a 12                	push   $0x12
  802319:	e8 9b fb ff ff       	call   801eb9 <syscall>
  80231e:	83 c4 18             	add    $0x18,%esp
	return ;
  802321:	90                   	nop
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <sys_rcr2>:
uint32 sys_rcr2()
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	6a 25                	push   $0x25
  802333:	e8 81 fb ff ff       	call   801eb9 <syscall>
  802338:	83 c4 18             	add    $0x18,%esp
}
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
  802340:	83 ec 04             	sub    $0x4,%esp
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802349:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	50                   	push   %eax
  802356:	6a 26                	push   $0x26
  802358:	e8 5c fb ff ff       	call   801eb9 <syscall>
  80235d:	83 c4 18             	add    $0x18,%esp
	return ;
  802360:	90                   	nop
}
  802361:	c9                   	leave  
  802362:	c3                   	ret    

00802363 <rsttst>:
void rsttst()
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 28                	push   $0x28
  802372:	e8 42 fb ff ff       	call   801eb9 <syscall>
  802377:	83 c4 18             	add    $0x18,%esp
	return ;
  80237a:	90                   	nop
}
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
  802380:	83 ec 04             	sub    $0x4,%esp
  802383:	8b 45 14             	mov    0x14(%ebp),%eax
  802386:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802389:	8b 55 18             	mov    0x18(%ebp),%edx
  80238c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802390:	52                   	push   %edx
  802391:	50                   	push   %eax
  802392:	ff 75 10             	pushl  0x10(%ebp)
  802395:	ff 75 0c             	pushl  0xc(%ebp)
  802398:	ff 75 08             	pushl  0x8(%ebp)
  80239b:	6a 27                	push   $0x27
  80239d:	e8 17 fb ff ff       	call   801eb9 <syscall>
  8023a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8023a5:	90                   	nop
}
  8023a6:	c9                   	leave  
  8023a7:	c3                   	ret    

008023a8 <chktst>:
void chktst(uint32 n)
{
  8023a8:	55                   	push   %ebp
  8023a9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	ff 75 08             	pushl  0x8(%ebp)
  8023b6:	6a 29                	push   $0x29
  8023b8:	e8 fc fa ff ff       	call   801eb9 <syscall>
  8023bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c0:	90                   	nop
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <inctst>:

void inctst()
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 2a                	push   $0x2a
  8023d2:	e8 e2 fa ff ff       	call   801eb9 <syscall>
  8023d7:	83 c4 18             	add    $0x18,%esp
	return ;
  8023da:	90                   	nop
}
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    

008023dd <gettst>:
uint32 gettst()
{
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 00                	push   $0x0
  8023ea:	6a 2b                	push   $0x2b
  8023ec:	e8 c8 fa ff ff       	call   801eb9 <syscall>
  8023f1:	83 c4 18             	add    $0x18,%esp
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 2c                	push   $0x2c
  802408:	e8 ac fa ff ff       	call   801eb9 <syscall>
  80240d:	83 c4 18             	add    $0x18,%esp
  802410:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802413:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802417:	75 07                	jne    802420 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802419:	b8 01 00 00 00       	mov    $0x1,%eax
  80241e:	eb 05                	jmp    802425 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802420:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
  80242a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80242d:	6a 00                	push   $0x0
  80242f:	6a 00                	push   $0x0
  802431:	6a 00                	push   $0x0
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 2c                	push   $0x2c
  802439:	e8 7b fa ff ff       	call   801eb9 <syscall>
  80243e:	83 c4 18             	add    $0x18,%esp
  802441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802444:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802448:	75 07                	jne    802451 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80244a:	b8 01 00 00 00       	mov    $0x1,%eax
  80244f:	eb 05                	jmp    802456 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802451:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802456:	c9                   	leave  
  802457:	c3                   	ret    

00802458 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802458:	55                   	push   %ebp
  802459:	89 e5                	mov    %esp,%ebp
  80245b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 2c                	push   $0x2c
  80246a:	e8 4a fa ff ff       	call   801eb9 <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
  802472:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802475:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802479:	75 07                	jne    802482 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80247b:	b8 01 00 00 00       	mov    $0x1,%eax
  802480:	eb 05                	jmp    802487 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802482:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
  80248c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80248f:	6a 00                	push   $0x0
  802491:	6a 00                	push   $0x0
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 2c                	push   $0x2c
  80249b:	e8 19 fa ff ff       	call   801eb9 <syscall>
  8024a0:	83 c4 18             	add    $0x18,%esp
  8024a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024a6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024aa:	75 07                	jne    8024b3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024ac:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b1:	eb 05                	jmp    8024b8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b8:	c9                   	leave  
  8024b9:	c3                   	ret    

008024ba <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024ba:	55                   	push   %ebp
  8024bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	ff 75 08             	pushl  0x8(%ebp)
  8024c8:	6a 2d                	push   $0x2d
  8024ca:	e8 ea f9 ff ff       	call   801eb9 <syscall>
  8024cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d2:	90                   	nop
}
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
  8024d8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e5:	6a 00                	push   $0x0
  8024e7:	53                   	push   %ebx
  8024e8:	51                   	push   %ecx
  8024e9:	52                   	push   %edx
  8024ea:	50                   	push   %eax
  8024eb:	6a 2e                	push   $0x2e
  8024ed:	e8 c7 f9 ff ff       	call   801eb9 <syscall>
  8024f2:	83 c4 18             	add    $0x18,%esp
}
  8024f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802500:	8b 45 08             	mov    0x8(%ebp),%eax
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	52                   	push   %edx
  80250a:	50                   	push   %eax
  80250b:	6a 2f                	push   $0x2f
  80250d:	e8 a7 f9 ff ff       	call   801eb9 <syscall>
  802512:	83 c4 18             	add    $0x18,%esp
}
  802515:	c9                   	leave  
  802516:	c3                   	ret    

00802517 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802517:	55                   	push   %ebp
  802518:	89 e5                	mov    %esp,%ebp
  80251a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80251d:	83 ec 0c             	sub    $0xc,%esp
  802520:	68 50 41 80 00       	push   $0x804150
  802525:	e8 1b e5 ff ff       	call   800a45 <cprintf>
  80252a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80252d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802534:	83 ec 0c             	sub    $0xc,%esp
  802537:	68 7c 41 80 00       	push   $0x80417c
  80253c:	e8 04 e5 ff ff       	call   800a45 <cprintf>
  802541:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802544:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802548:	a1 38 51 80 00       	mov    0x805138,%eax
  80254d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802550:	eb 56                	jmp    8025a8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802552:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802556:	74 1c                	je     802574 <print_mem_block_lists+0x5d>
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 50 08             	mov    0x8(%eax),%edx
  80255e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802561:	8b 48 08             	mov    0x8(%eax),%ecx
  802564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802567:	8b 40 0c             	mov    0xc(%eax),%eax
  80256a:	01 c8                	add    %ecx,%eax
  80256c:	39 c2                	cmp    %eax,%edx
  80256e:	73 04                	jae    802574 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802570:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 50 08             	mov    0x8(%eax),%edx
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 40 0c             	mov    0xc(%eax),%eax
  802580:	01 c2                	add    %eax,%edx
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 40 08             	mov    0x8(%eax),%eax
  802588:	83 ec 04             	sub    $0x4,%esp
  80258b:	52                   	push   %edx
  80258c:	50                   	push   %eax
  80258d:	68 91 41 80 00       	push   $0x804191
  802592:	e8 ae e4 ff ff       	call   800a45 <cprintf>
  802597:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025a0:	a1 40 51 80 00       	mov    0x805140,%eax
  8025a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ac:	74 07                	je     8025b5 <print_mem_block_lists+0x9e>
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 00                	mov    (%eax),%eax
  8025b3:	eb 05                	jmp    8025ba <print_mem_block_lists+0xa3>
  8025b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ba:	a3 40 51 80 00       	mov    %eax,0x805140
  8025bf:	a1 40 51 80 00       	mov    0x805140,%eax
  8025c4:	85 c0                	test   %eax,%eax
  8025c6:	75 8a                	jne    802552 <print_mem_block_lists+0x3b>
  8025c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cc:	75 84                	jne    802552 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025ce:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025d2:	75 10                	jne    8025e4 <print_mem_block_lists+0xcd>
  8025d4:	83 ec 0c             	sub    $0xc,%esp
  8025d7:	68 a0 41 80 00       	push   $0x8041a0
  8025dc:	e8 64 e4 ff ff       	call   800a45 <cprintf>
  8025e1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025eb:	83 ec 0c             	sub    $0xc,%esp
  8025ee:	68 c4 41 80 00       	push   $0x8041c4
  8025f3:	e8 4d e4 ff ff       	call   800a45 <cprintf>
  8025f8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025fb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025ff:	a1 40 50 80 00       	mov    0x805040,%eax
  802604:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802607:	eb 56                	jmp    80265f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802609:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80260d:	74 1c                	je     80262b <print_mem_block_lists+0x114>
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 50 08             	mov    0x8(%eax),%edx
  802615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802618:	8b 48 08             	mov    0x8(%eax),%ecx
  80261b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261e:	8b 40 0c             	mov    0xc(%eax),%eax
  802621:	01 c8                	add    %ecx,%eax
  802623:	39 c2                	cmp    %eax,%edx
  802625:	73 04                	jae    80262b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802627:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	8b 50 08             	mov    0x8(%eax),%edx
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 40 0c             	mov    0xc(%eax),%eax
  802637:	01 c2                	add    %eax,%edx
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	8b 40 08             	mov    0x8(%eax),%eax
  80263f:	83 ec 04             	sub    $0x4,%esp
  802642:	52                   	push   %edx
  802643:	50                   	push   %eax
  802644:	68 91 41 80 00       	push   $0x804191
  802649:	e8 f7 e3 ff ff       	call   800a45 <cprintf>
  80264e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802657:	a1 48 50 80 00       	mov    0x805048,%eax
  80265c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802663:	74 07                	je     80266c <print_mem_block_lists+0x155>
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	8b 00                	mov    (%eax),%eax
  80266a:	eb 05                	jmp    802671 <print_mem_block_lists+0x15a>
  80266c:	b8 00 00 00 00       	mov    $0x0,%eax
  802671:	a3 48 50 80 00       	mov    %eax,0x805048
  802676:	a1 48 50 80 00       	mov    0x805048,%eax
  80267b:	85 c0                	test   %eax,%eax
  80267d:	75 8a                	jne    802609 <print_mem_block_lists+0xf2>
  80267f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802683:	75 84                	jne    802609 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802685:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802689:	75 10                	jne    80269b <print_mem_block_lists+0x184>
  80268b:	83 ec 0c             	sub    $0xc,%esp
  80268e:	68 dc 41 80 00       	push   $0x8041dc
  802693:	e8 ad e3 ff ff       	call   800a45 <cprintf>
  802698:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80269b:	83 ec 0c             	sub    $0xc,%esp
  80269e:	68 50 41 80 00       	push   $0x804150
  8026a3:	e8 9d e3 ff ff       	call   800a45 <cprintf>
  8026a8:	83 c4 10             	add    $0x10,%esp

}
  8026ab:	90                   	nop
  8026ac:	c9                   	leave  
  8026ad:	c3                   	ret    

008026ae <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026ae:	55                   	push   %ebp
  8026af:	89 e5                	mov    %esp,%ebp
  8026b1:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8026b4:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026bb:	00 00 00 
  8026be:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026c5:	00 00 00 
  8026c8:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026cf:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8026d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026d9:	e9 9e 00 00 00       	jmp    80277c <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8026de:	a1 50 50 80 00       	mov    0x805050,%eax
  8026e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e6:	c1 e2 04             	shl    $0x4,%edx
  8026e9:	01 d0                	add    %edx,%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	75 14                	jne    802703 <initialize_MemBlocksList+0x55>
  8026ef:	83 ec 04             	sub    $0x4,%esp
  8026f2:	68 04 42 80 00       	push   $0x804204
  8026f7:	6a 43                	push   $0x43
  8026f9:	68 27 42 80 00       	push   $0x804227
  8026fe:	e8 8e e0 ff ff       	call   800791 <_panic>
  802703:	a1 50 50 80 00       	mov    0x805050,%eax
  802708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80270b:	c1 e2 04             	shl    $0x4,%edx
  80270e:	01 d0                	add    %edx,%eax
  802710:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802716:	89 10                	mov    %edx,(%eax)
  802718:	8b 00                	mov    (%eax),%eax
  80271a:	85 c0                	test   %eax,%eax
  80271c:	74 18                	je     802736 <initialize_MemBlocksList+0x88>
  80271e:	a1 48 51 80 00       	mov    0x805148,%eax
  802723:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802729:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80272c:	c1 e1 04             	shl    $0x4,%ecx
  80272f:	01 ca                	add    %ecx,%edx
  802731:	89 50 04             	mov    %edx,0x4(%eax)
  802734:	eb 12                	jmp    802748 <initialize_MemBlocksList+0x9a>
  802736:	a1 50 50 80 00       	mov    0x805050,%eax
  80273b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273e:	c1 e2 04             	shl    $0x4,%edx
  802741:	01 d0                	add    %edx,%eax
  802743:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802748:	a1 50 50 80 00       	mov    0x805050,%eax
  80274d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802750:	c1 e2 04             	shl    $0x4,%edx
  802753:	01 d0                	add    %edx,%eax
  802755:	a3 48 51 80 00       	mov    %eax,0x805148
  80275a:	a1 50 50 80 00       	mov    0x805050,%eax
  80275f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802762:	c1 e2 04             	shl    $0x4,%edx
  802765:	01 d0                	add    %edx,%eax
  802767:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80276e:	a1 54 51 80 00       	mov    0x805154,%eax
  802773:	40                   	inc    %eax
  802774:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802779:	ff 45 f4             	incl   -0xc(%ebp)
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802782:	0f 82 56 ff ff ff    	jb     8026de <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802788:	90                   	nop
  802789:	c9                   	leave  
  80278a:	c3                   	ret    

0080278b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80278b:	55                   	push   %ebp
  80278c:	89 e5                	mov    %esp,%ebp
  80278e:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802791:	a1 38 51 80 00       	mov    0x805138,%eax
  802796:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802799:	eb 18                	jmp    8027b3 <find_block+0x28>
	{
		if (ele->sva==va)
  80279b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80279e:	8b 40 08             	mov    0x8(%eax),%eax
  8027a1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027a4:	75 05                	jne    8027ab <find_block+0x20>
			return ele;
  8027a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027a9:	eb 7b                	jmp    802826 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8027ab:	a1 40 51 80 00       	mov    0x805140,%eax
  8027b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027b7:	74 07                	je     8027c0 <find_block+0x35>
  8027b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027bc:	8b 00                	mov    (%eax),%eax
  8027be:	eb 05                	jmp    8027c5 <find_block+0x3a>
  8027c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8027c5:	a3 40 51 80 00       	mov    %eax,0x805140
  8027ca:	a1 40 51 80 00       	mov    0x805140,%eax
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	75 c8                	jne    80279b <find_block+0x10>
  8027d3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027d7:	75 c2                	jne    80279b <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8027d9:	a1 40 50 80 00       	mov    0x805040,%eax
  8027de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027e1:	eb 18                	jmp    8027fb <find_block+0x70>
	{
		if (ele->sva==va)
  8027e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027e6:	8b 40 08             	mov    0x8(%eax),%eax
  8027e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027ec:	75 05                	jne    8027f3 <find_block+0x68>
					return ele;
  8027ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027f1:	eb 33                	jmp    802826 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8027f3:	a1 48 50 80 00       	mov    0x805048,%eax
  8027f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027ff:	74 07                	je     802808 <find_block+0x7d>
  802801:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	eb 05                	jmp    80280d <find_block+0x82>
  802808:	b8 00 00 00 00       	mov    $0x0,%eax
  80280d:	a3 48 50 80 00       	mov    %eax,0x805048
  802812:	a1 48 50 80 00       	mov    0x805048,%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	75 c8                	jne    8027e3 <find_block+0x58>
  80281b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80281f:	75 c2                	jne    8027e3 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802821:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802826:	c9                   	leave  
  802827:	c3                   	ret    

00802828 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802828:	55                   	push   %ebp
  802829:	89 e5                	mov    %esp,%ebp
  80282b:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  80282e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802833:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802836:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80283a:	75 62                	jne    80289e <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80283c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802840:	75 14                	jne    802856 <insert_sorted_allocList+0x2e>
  802842:	83 ec 04             	sub    $0x4,%esp
  802845:	68 04 42 80 00       	push   $0x804204
  80284a:	6a 69                	push   $0x69
  80284c:	68 27 42 80 00       	push   $0x804227
  802851:	e8 3b df ff ff       	call   800791 <_panic>
  802856:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	89 10                	mov    %edx,(%eax)
  802861:	8b 45 08             	mov    0x8(%ebp),%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	85 c0                	test   %eax,%eax
  802868:	74 0d                	je     802877 <insert_sorted_allocList+0x4f>
  80286a:	a1 40 50 80 00       	mov    0x805040,%eax
  80286f:	8b 55 08             	mov    0x8(%ebp),%edx
  802872:	89 50 04             	mov    %edx,0x4(%eax)
  802875:	eb 08                	jmp    80287f <insert_sorted_allocList+0x57>
  802877:	8b 45 08             	mov    0x8(%ebp),%eax
  80287a:	a3 44 50 80 00       	mov    %eax,0x805044
  80287f:	8b 45 08             	mov    0x8(%ebp),%eax
  802882:	a3 40 50 80 00       	mov    %eax,0x805040
  802887:	8b 45 08             	mov    0x8(%ebp),%eax
  80288a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802891:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802896:	40                   	inc    %eax
  802897:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80289c:	eb 72                	jmp    802910 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  80289e:	a1 40 50 80 00       	mov    0x805040,%eax
  8028a3:	8b 50 08             	mov    0x8(%eax),%edx
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	8b 40 08             	mov    0x8(%eax),%eax
  8028ac:	39 c2                	cmp    %eax,%edx
  8028ae:	76 60                	jbe    802910 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8028b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b4:	75 14                	jne    8028ca <insert_sorted_allocList+0xa2>
  8028b6:	83 ec 04             	sub    $0x4,%esp
  8028b9:	68 04 42 80 00       	push   $0x804204
  8028be:	6a 6d                	push   $0x6d
  8028c0:	68 27 42 80 00       	push   $0x804227
  8028c5:	e8 c7 de ff ff       	call   800791 <_panic>
  8028ca:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d3:	89 10                	mov    %edx,(%eax)
  8028d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d8:	8b 00                	mov    (%eax),%eax
  8028da:	85 c0                	test   %eax,%eax
  8028dc:	74 0d                	je     8028eb <insert_sorted_allocList+0xc3>
  8028de:	a1 40 50 80 00       	mov    0x805040,%eax
  8028e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e6:	89 50 04             	mov    %edx,0x4(%eax)
  8028e9:	eb 08                	jmp    8028f3 <insert_sorted_allocList+0xcb>
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	a3 44 50 80 00       	mov    %eax,0x805044
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	a3 40 50 80 00       	mov    %eax,0x805040
  8028fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802905:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80290a:	40                   	inc    %eax
  80290b:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802910:	a1 40 50 80 00       	mov    0x805040,%eax
  802915:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802918:	e9 b9 01 00 00       	jmp    802ad6 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80291d:	8b 45 08             	mov    0x8(%ebp),%eax
  802920:	8b 50 08             	mov    0x8(%eax),%edx
  802923:	a1 40 50 80 00       	mov    0x805040,%eax
  802928:	8b 40 08             	mov    0x8(%eax),%eax
  80292b:	39 c2                	cmp    %eax,%edx
  80292d:	76 7c                	jbe    8029ab <insert_sorted_allocList+0x183>
  80292f:	8b 45 08             	mov    0x8(%ebp),%eax
  802932:	8b 50 08             	mov    0x8(%eax),%edx
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 40 08             	mov    0x8(%eax),%eax
  80293b:	39 c2                	cmp    %eax,%edx
  80293d:	73 6c                	jae    8029ab <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80293f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802943:	74 06                	je     80294b <insert_sorted_allocList+0x123>
  802945:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802949:	75 14                	jne    80295f <insert_sorted_allocList+0x137>
  80294b:	83 ec 04             	sub    $0x4,%esp
  80294e:	68 40 42 80 00       	push   $0x804240
  802953:	6a 75                	push   $0x75
  802955:	68 27 42 80 00       	push   $0x804227
  80295a:	e8 32 de ff ff       	call   800791 <_panic>
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	8b 50 04             	mov    0x4(%eax),%edx
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	89 50 04             	mov    %edx,0x4(%eax)
  80296b:	8b 45 08             	mov    0x8(%ebp),%eax
  80296e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802971:	89 10                	mov    %edx,(%eax)
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 40 04             	mov    0x4(%eax),%eax
  802979:	85 c0                	test   %eax,%eax
  80297b:	74 0d                	je     80298a <insert_sorted_allocList+0x162>
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 40 04             	mov    0x4(%eax),%eax
  802983:	8b 55 08             	mov    0x8(%ebp),%edx
  802986:	89 10                	mov    %edx,(%eax)
  802988:	eb 08                	jmp    802992 <insert_sorted_allocList+0x16a>
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	a3 40 50 80 00       	mov    %eax,0x805040
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 55 08             	mov    0x8(%ebp),%edx
  802998:	89 50 04             	mov    %edx,0x4(%eax)
  80299b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029a0:	40                   	inc    %eax
  8029a1:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  8029a6:	e9 59 01 00 00       	jmp    802b04 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	8b 50 08             	mov    0x8(%eax),%edx
  8029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b4:	8b 40 08             	mov    0x8(%eax),%eax
  8029b7:	39 c2                	cmp    %eax,%edx
  8029b9:	0f 86 98 00 00 00    	jbe    802a57 <insert_sorted_allocList+0x22f>
  8029bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c2:	8b 50 08             	mov    0x8(%eax),%edx
  8029c5:	a1 44 50 80 00       	mov    0x805044,%eax
  8029ca:	8b 40 08             	mov    0x8(%eax),%eax
  8029cd:	39 c2                	cmp    %eax,%edx
  8029cf:	0f 83 82 00 00 00    	jae    802a57 <insert_sorted_allocList+0x22f>
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	8b 50 08             	mov    0x8(%eax),%edx
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	8b 00                	mov    (%eax),%eax
  8029e0:	8b 40 08             	mov    0x8(%eax),%eax
  8029e3:	39 c2                	cmp    %eax,%edx
  8029e5:	73 70                	jae    802a57 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8029e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029eb:	74 06                	je     8029f3 <insert_sorted_allocList+0x1cb>
  8029ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f1:	75 14                	jne    802a07 <insert_sorted_allocList+0x1df>
  8029f3:	83 ec 04             	sub    $0x4,%esp
  8029f6:	68 78 42 80 00       	push   $0x804278
  8029fb:	6a 7c                	push   $0x7c
  8029fd:	68 27 42 80 00       	push   $0x804227
  802a02:	e8 8a dd ff ff       	call   800791 <_panic>
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 10                	mov    (%eax),%edx
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	89 10                	mov    %edx,(%eax)
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	8b 00                	mov    (%eax),%eax
  802a16:	85 c0                	test   %eax,%eax
  802a18:	74 0b                	je     802a25 <insert_sorted_allocList+0x1fd>
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 00                	mov    (%eax),%eax
  802a1f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a22:	89 50 04             	mov    %edx,0x4(%eax)
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2b:	89 10                	mov    %edx,(%eax)
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a33:	89 50 04             	mov    %edx,0x4(%eax)
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	8b 00                	mov    (%eax),%eax
  802a3b:	85 c0                	test   %eax,%eax
  802a3d:	75 08                	jne    802a47 <insert_sorted_allocList+0x21f>
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	a3 44 50 80 00       	mov    %eax,0x805044
  802a47:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a4c:	40                   	inc    %eax
  802a4d:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802a52:	e9 ad 00 00 00       	jmp    802b04 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802a57:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5a:	8b 50 08             	mov    0x8(%eax),%edx
  802a5d:	a1 44 50 80 00       	mov    0x805044,%eax
  802a62:	8b 40 08             	mov    0x8(%eax),%eax
  802a65:	39 c2                	cmp    %eax,%edx
  802a67:	76 65                	jbe    802ace <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802a69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a6d:	75 17                	jne    802a86 <insert_sorted_allocList+0x25e>
  802a6f:	83 ec 04             	sub    $0x4,%esp
  802a72:	68 ac 42 80 00       	push   $0x8042ac
  802a77:	68 80 00 00 00       	push   $0x80
  802a7c:	68 27 42 80 00       	push   $0x804227
  802a81:	e8 0b dd ff ff       	call   800791 <_panic>
  802a86:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8f:	89 50 04             	mov    %edx,0x4(%eax)
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	8b 40 04             	mov    0x4(%eax),%eax
  802a98:	85 c0                	test   %eax,%eax
  802a9a:	74 0c                	je     802aa8 <insert_sorted_allocList+0x280>
  802a9c:	a1 44 50 80 00       	mov    0x805044,%eax
  802aa1:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa4:	89 10                	mov    %edx,(%eax)
  802aa6:	eb 08                	jmp    802ab0 <insert_sorted_allocList+0x288>
  802aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aab:	a3 40 50 80 00       	mov    %eax,0x805040
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	a3 44 50 80 00       	mov    %eax,0x805044
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ac6:	40                   	inc    %eax
  802ac7:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802acc:	eb 36                	jmp    802b04 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802ace:	a1 48 50 80 00       	mov    0x805048,%eax
  802ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ada:	74 07                	je     802ae3 <insert_sorted_allocList+0x2bb>
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	eb 05                	jmp    802ae8 <insert_sorted_allocList+0x2c0>
  802ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae8:	a3 48 50 80 00       	mov    %eax,0x805048
  802aed:	a1 48 50 80 00       	mov    0x805048,%eax
  802af2:	85 c0                	test   %eax,%eax
  802af4:	0f 85 23 fe ff ff    	jne    80291d <insert_sorted_allocList+0xf5>
  802afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afe:	0f 85 19 fe ff ff    	jne    80291d <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802b04:	90                   	nop
  802b05:	c9                   	leave  
  802b06:	c3                   	ret    

00802b07 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b07:	55                   	push   %ebp
  802b08:	89 e5                	mov    %esp,%ebp
  802b0a:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802b0d:	a1 38 51 80 00       	mov    0x805138,%eax
  802b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b15:	e9 7c 01 00 00       	jmp    802c96 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b20:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b23:	0f 85 90 00 00 00    	jne    802bb9 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802b2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b33:	75 17                	jne    802b4c <alloc_block_FF+0x45>
  802b35:	83 ec 04             	sub    $0x4,%esp
  802b38:	68 cf 42 80 00       	push   $0x8042cf
  802b3d:	68 ba 00 00 00       	push   $0xba
  802b42:	68 27 42 80 00       	push   $0x804227
  802b47:	e8 45 dc ff ff       	call   800791 <_panic>
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	8b 00                	mov    (%eax),%eax
  802b51:	85 c0                	test   %eax,%eax
  802b53:	74 10                	je     802b65 <alloc_block_FF+0x5e>
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b5d:	8b 52 04             	mov    0x4(%edx),%edx
  802b60:	89 50 04             	mov    %edx,0x4(%eax)
  802b63:	eb 0b                	jmp    802b70 <alloc_block_FF+0x69>
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	8b 40 04             	mov    0x4(%eax),%eax
  802b6b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 40 04             	mov    0x4(%eax),%eax
  802b76:	85 c0                	test   %eax,%eax
  802b78:	74 0f                	je     802b89 <alloc_block_FF+0x82>
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	8b 40 04             	mov    0x4(%eax),%eax
  802b80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b83:	8b 12                	mov    (%edx),%edx
  802b85:	89 10                	mov    %edx,(%eax)
  802b87:	eb 0a                	jmp    802b93 <alloc_block_FF+0x8c>
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 00                	mov    (%eax),%eax
  802b8e:	a3 38 51 80 00       	mov    %eax,0x805138
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba6:	a1 44 51 80 00       	mov    0x805144,%eax
  802bab:	48                   	dec    %eax
  802bac:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802bb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb4:	e9 10 01 00 00       	jmp    802cc9 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc2:	0f 86 c6 00 00 00    	jbe    802c8e <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802bc8:	a1 48 51 80 00       	mov    0x805148,%eax
  802bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802bd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bd4:	75 17                	jne    802bed <alloc_block_FF+0xe6>
  802bd6:	83 ec 04             	sub    $0x4,%esp
  802bd9:	68 cf 42 80 00       	push   $0x8042cf
  802bde:	68 c2 00 00 00       	push   $0xc2
  802be3:	68 27 42 80 00       	push   $0x804227
  802be8:	e8 a4 db ff ff       	call   800791 <_panic>
  802bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf0:	8b 00                	mov    (%eax),%eax
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	74 10                	je     802c06 <alloc_block_FF+0xff>
  802bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bfe:	8b 52 04             	mov    0x4(%edx),%edx
  802c01:	89 50 04             	mov    %edx,0x4(%eax)
  802c04:	eb 0b                	jmp    802c11 <alloc_block_FF+0x10a>
  802c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c09:	8b 40 04             	mov    0x4(%eax),%eax
  802c0c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c14:	8b 40 04             	mov    0x4(%eax),%eax
  802c17:	85 c0                	test   %eax,%eax
  802c19:	74 0f                	je     802c2a <alloc_block_FF+0x123>
  802c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1e:	8b 40 04             	mov    0x4(%eax),%eax
  802c21:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c24:	8b 12                	mov    (%edx),%edx
  802c26:	89 10                	mov    %edx,(%eax)
  802c28:	eb 0a                	jmp    802c34 <alloc_block_FF+0x12d>
  802c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2d:	8b 00                	mov    (%eax),%eax
  802c2f:	a3 48 51 80 00       	mov    %eax,0x805148
  802c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c47:	a1 54 51 80 00       	mov    0x805154,%eax
  802c4c:	48                   	dec    %eax
  802c4d:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	8b 50 08             	mov    0x8(%eax),%edx
  802c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c5b:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c61:	8b 55 08             	mov    0x8(%ebp),%edx
  802c64:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6d:	2b 45 08             	sub    0x8(%ebp),%eax
  802c70:	89 c2                	mov    %eax,%edx
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7b:	8b 50 08             	mov    0x8(%eax),%edx
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	01 c2                	add    %eax,%edx
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802c89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c8c:	eb 3b                	jmp    802cc9 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802c8e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9a:	74 07                	je     802ca3 <alloc_block_FF+0x19c>
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 00                	mov    (%eax),%eax
  802ca1:	eb 05                	jmp    802ca8 <alloc_block_FF+0x1a1>
  802ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca8:	a3 40 51 80 00       	mov    %eax,0x805140
  802cad:	a1 40 51 80 00       	mov    0x805140,%eax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	0f 85 60 fe ff ff    	jne    802b1a <alloc_block_FF+0x13>
  802cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbe:	0f 85 56 fe ff ff    	jne    802b1a <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802cc4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc9:	c9                   	leave  
  802cca:	c3                   	ret    

00802ccb <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802ccb:	55                   	push   %ebp
  802ccc:	89 e5                	mov    %esp,%ebp
  802cce:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802cd1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802cd8:	a1 38 51 80 00       	mov    0x805138,%eax
  802cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce0:	eb 3a                	jmp    802d1c <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ceb:	72 27                	jb     802d14 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802ced:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802cf1:	75 0b                	jne    802cfe <alloc_block_BF+0x33>
					best_size= element->size;
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802cfc:	eb 16                	jmp    802d14 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d01:	8b 50 0c             	mov    0xc(%eax),%edx
  802d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d07:	39 c2                	cmp    %eax,%edx
  802d09:	77 09                	ja     802d14 <alloc_block_BF+0x49>
					best_size=element->size;
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d11:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802d14:	a1 40 51 80 00       	mov    0x805140,%eax
  802d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d20:	74 07                	je     802d29 <alloc_block_BF+0x5e>
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	eb 05                	jmp    802d2e <alloc_block_BF+0x63>
  802d29:	b8 00 00 00 00       	mov    $0x0,%eax
  802d2e:	a3 40 51 80 00       	mov    %eax,0x805140
  802d33:	a1 40 51 80 00       	mov    0x805140,%eax
  802d38:	85 c0                	test   %eax,%eax
  802d3a:	75 a6                	jne    802ce2 <alloc_block_BF+0x17>
  802d3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d40:	75 a0                	jne    802ce2 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802d42:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802d46:	0f 84 d3 01 00 00    	je     802f1f <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802d4c:	a1 38 51 80 00       	mov    0x805138,%eax
  802d51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d54:	e9 98 01 00 00       	jmp    802ef1 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d5f:	0f 86 da 00 00 00    	jbe    802e3f <alloc_block_BF+0x174>
  802d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d68:	8b 50 0c             	mov    0xc(%eax),%edx
  802d6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6e:	39 c2                	cmp    %eax,%edx
  802d70:	0f 85 c9 00 00 00    	jne    802e3f <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802d76:	a1 48 51 80 00       	mov    0x805148,%eax
  802d7b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802d7e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d82:	75 17                	jne    802d9b <alloc_block_BF+0xd0>
  802d84:	83 ec 04             	sub    $0x4,%esp
  802d87:	68 cf 42 80 00       	push   $0x8042cf
  802d8c:	68 ea 00 00 00       	push   $0xea
  802d91:	68 27 42 80 00       	push   $0x804227
  802d96:	e8 f6 d9 ff ff       	call   800791 <_panic>
  802d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9e:	8b 00                	mov    (%eax),%eax
  802da0:	85 c0                	test   %eax,%eax
  802da2:	74 10                	je     802db4 <alloc_block_BF+0xe9>
  802da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dac:	8b 52 04             	mov    0x4(%edx),%edx
  802daf:	89 50 04             	mov    %edx,0x4(%eax)
  802db2:	eb 0b                	jmp    802dbf <alloc_block_BF+0xf4>
  802db4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db7:	8b 40 04             	mov    0x4(%eax),%eax
  802dba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc2:	8b 40 04             	mov    0x4(%eax),%eax
  802dc5:	85 c0                	test   %eax,%eax
  802dc7:	74 0f                	je     802dd8 <alloc_block_BF+0x10d>
  802dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcc:	8b 40 04             	mov    0x4(%eax),%eax
  802dcf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dd2:	8b 12                	mov    (%edx),%edx
  802dd4:	89 10                	mov    %edx,(%eax)
  802dd6:	eb 0a                	jmp    802de2 <alloc_block_BF+0x117>
  802dd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddb:	8b 00                	mov    (%eax),%eax
  802ddd:	a3 48 51 80 00       	mov    %eax,0x805148
  802de2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802deb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df5:	a1 54 51 80 00       	mov    0x805154,%eax
  802dfa:	48                   	dec    %eax
  802dfb:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e03:	8b 50 08             	mov    0x8(%eax),%edx
  802e06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e09:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802e0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e12:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1b:	2b 45 08             	sub    0x8(%ebp),%eax
  802e1e:	89 c2                	mov    %eax,%edx
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 50 08             	mov    0x8(%eax),%edx
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	01 c2                	add    %eax,%edx
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3a:	e9 e5 00 00 00       	jmp    802f24 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	8b 50 0c             	mov    0xc(%eax),%edx
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	39 c2                	cmp    %eax,%edx
  802e4a:	0f 85 99 00 00 00    	jne    802ee9 <alloc_block_BF+0x21e>
  802e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e53:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e56:	0f 85 8d 00 00 00    	jne    802ee9 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802e62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e66:	75 17                	jne    802e7f <alloc_block_BF+0x1b4>
  802e68:	83 ec 04             	sub    $0x4,%esp
  802e6b:	68 cf 42 80 00       	push   $0x8042cf
  802e70:	68 f7 00 00 00       	push   $0xf7
  802e75:	68 27 42 80 00       	push   $0x804227
  802e7a:	e8 12 d9 ff ff       	call   800791 <_panic>
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 00                	mov    (%eax),%eax
  802e84:	85 c0                	test   %eax,%eax
  802e86:	74 10                	je     802e98 <alloc_block_BF+0x1cd>
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	8b 00                	mov    (%eax),%eax
  802e8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e90:	8b 52 04             	mov    0x4(%edx),%edx
  802e93:	89 50 04             	mov    %edx,0x4(%eax)
  802e96:	eb 0b                	jmp    802ea3 <alloc_block_BF+0x1d8>
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 40 04             	mov    0x4(%eax),%eax
  802e9e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea6:	8b 40 04             	mov    0x4(%eax),%eax
  802ea9:	85 c0                	test   %eax,%eax
  802eab:	74 0f                	je     802ebc <alloc_block_BF+0x1f1>
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 40 04             	mov    0x4(%eax),%eax
  802eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb6:	8b 12                	mov    (%edx),%edx
  802eb8:	89 10                	mov    %edx,(%eax)
  802eba:	eb 0a                	jmp    802ec6 <alloc_block_BF+0x1fb>
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 00                	mov    (%eax),%eax
  802ec1:	a3 38 51 80 00       	mov    %eax,0x805138
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed9:	a1 44 51 80 00       	mov    0x805144,%eax
  802ede:	48                   	dec    %eax
  802edf:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee7:	eb 3b                	jmp    802f24 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802ee9:	a1 40 51 80 00       	mov    0x805140,%eax
  802eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef5:	74 07                	je     802efe <alloc_block_BF+0x233>
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	8b 00                	mov    (%eax),%eax
  802efc:	eb 05                	jmp    802f03 <alloc_block_BF+0x238>
  802efe:	b8 00 00 00 00       	mov    $0x0,%eax
  802f03:	a3 40 51 80 00       	mov    %eax,0x805140
  802f08:	a1 40 51 80 00       	mov    0x805140,%eax
  802f0d:	85 c0                	test   %eax,%eax
  802f0f:	0f 85 44 fe ff ff    	jne    802d59 <alloc_block_BF+0x8e>
  802f15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f19:	0f 85 3a fe ff ff    	jne    802d59 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802f1f:	b8 00 00 00 00       	mov    $0x0,%eax
  802f24:	c9                   	leave  
  802f25:	c3                   	ret    

00802f26 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802f26:	55                   	push   %ebp
  802f27:	89 e5                	mov    %esp,%ebp
  802f29:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802f2c:	83 ec 04             	sub    $0x4,%esp
  802f2f:	68 f0 42 80 00       	push   $0x8042f0
  802f34:	68 04 01 00 00       	push   $0x104
  802f39:	68 27 42 80 00       	push   $0x804227
  802f3e:	e8 4e d8 ff ff       	call   800791 <_panic>

00802f43 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802f43:	55                   	push   %ebp
  802f44:	89 e5                	mov    %esp,%ebp
  802f46:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802f49:	a1 38 51 80 00       	mov    0x805138,%eax
  802f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802f51:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f56:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802f59:	a1 38 51 80 00       	mov    0x805138,%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	75 68                	jne    802fca <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802f62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f66:	75 17                	jne    802f7f <insert_sorted_with_merge_freeList+0x3c>
  802f68:	83 ec 04             	sub    $0x4,%esp
  802f6b:	68 04 42 80 00       	push   $0x804204
  802f70:	68 14 01 00 00       	push   $0x114
  802f75:	68 27 42 80 00       	push   $0x804227
  802f7a:	e8 12 d8 ff ff       	call   800791 <_panic>
  802f7f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	89 10                	mov    %edx,(%eax)
  802f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8d:	8b 00                	mov    (%eax),%eax
  802f8f:	85 c0                	test   %eax,%eax
  802f91:	74 0d                	je     802fa0 <insert_sorted_with_merge_freeList+0x5d>
  802f93:	a1 38 51 80 00       	mov    0x805138,%eax
  802f98:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9b:	89 50 04             	mov    %edx,0x4(%eax)
  802f9e:	eb 08                	jmp    802fa8 <insert_sorted_with_merge_freeList+0x65>
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	a3 38 51 80 00       	mov    %eax,0x805138
  802fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fba:	a1 44 51 80 00       	mov    0x805144,%eax
  802fbf:	40                   	inc    %eax
  802fc0:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802fc5:	e9 d2 06 00 00       	jmp    80369c <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	8b 50 08             	mov    0x8(%eax),%edx
  802fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd3:	8b 40 08             	mov    0x8(%eax),%eax
  802fd6:	39 c2                	cmp    %eax,%edx
  802fd8:	0f 83 22 01 00 00    	jae    803100 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	8b 50 08             	mov    0x8(%eax),%edx
  802fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fea:	01 c2                	add    %eax,%edx
  802fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fef:	8b 40 08             	mov    0x8(%eax),%eax
  802ff2:	39 c2                	cmp    %eax,%edx
  802ff4:	0f 85 9e 00 00 00    	jne    803098 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	8b 50 08             	mov    0x8(%eax),%edx
  803000:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803003:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803006:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803009:	8b 50 0c             	mov    0xc(%eax),%edx
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	8b 40 0c             	mov    0xc(%eax),%eax
  803012:	01 c2                	add    %eax,%edx
  803014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803017:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	8b 50 08             	mov    0x8(%eax),%edx
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803030:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803034:	75 17                	jne    80304d <insert_sorted_with_merge_freeList+0x10a>
  803036:	83 ec 04             	sub    $0x4,%esp
  803039:	68 04 42 80 00       	push   $0x804204
  80303e:	68 21 01 00 00       	push   $0x121
  803043:	68 27 42 80 00       	push   $0x804227
  803048:	e8 44 d7 ff ff       	call   800791 <_panic>
  80304d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	89 10                	mov    %edx,(%eax)
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	8b 00                	mov    (%eax),%eax
  80305d:	85 c0                	test   %eax,%eax
  80305f:	74 0d                	je     80306e <insert_sorted_with_merge_freeList+0x12b>
  803061:	a1 48 51 80 00       	mov    0x805148,%eax
  803066:	8b 55 08             	mov    0x8(%ebp),%edx
  803069:	89 50 04             	mov    %edx,0x4(%eax)
  80306c:	eb 08                	jmp    803076 <insert_sorted_with_merge_freeList+0x133>
  80306e:	8b 45 08             	mov    0x8(%ebp),%eax
  803071:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	a3 48 51 80 00       	mov    %eax,0x805148
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803088:	a1 54 51 80 00       	mov    0x805154,%eax
  80308d:	40                   	inc    %eax
  80308e:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803093:	e9 04 06 00 00       	jmp    80369c <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803098:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309c:	75 17                	jne    8030b5 <insert_sorted_with_merge_freeList+0x172>
  80309e:	83 ec 04             	sub    $0x4,%esp
  8030a1:	68 04 42 80 00       	push   $0x804204
  8030a6:	68 26 01 00 00       	push   $0x126
  8030ab:	68 27 42 80 00       	push   $0x804227
  8030b0:	e8 dc d6 ff ff       	call   800791 <_panic>
  8030b5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	89 10                	mov    %edx,(%eax)
  8030c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	85 c0                	test   %eax,%eax
  8030c7:	74 0d                	je     8030d6 <insert_sorted_with_merge_freeList+0x193>
  8030c9:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d1:	89 50 04             	mov    %edx,0x4(%eax)
  8030d4:	eb 08                	jmp    8030de <insert_sorted_with_merge_freeList+0x19b>
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	a3 38 51 80 00       	mov    %eax,0x805138
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f0:	a1 44 51 80 00       	mov    0x805144,%eax
  8030f5:	40                   	inc    %eax
  8030f6:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8030fb:	e9 9c 05 00 00       	jmp    80369c <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	8b 50 08             	mov    0x8(%eax),%edx
  803106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803109:	8b 40 08             	mov    0x8(%eax),%eax
  80310c:	39 c2                	cmp    %eax,%edx
  80310e:	0f 86 16 01 00 00    	jbe    80322a <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803114:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803117:	8b 50 08             	mov    0x8(%eax),%edx
  80311a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80311d:	8b 40 0c             	mov    0xc(%eax),%eax
  803120:	01 c2                	add    %eax,%edx
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	8b 40 08             	mov    0x8(%eax),%eax
  803128:	39 c2                	cmp    %eax,%edx
  80312a:	0f 85 92 00 00 00    	jne    8031c2 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  803130:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803133:	8b 50 0c             	mov    0xc(%eax),%edx
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	8b 40 0c             	mov    0xc(%eax),%eax
  80313c:	01 c2                	add    %eax,%edx
  80313e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803141:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  803144:	8b 45 08             	mov    0x8(%ebp),%eax
  803147:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	8b 50 08             	mov    0x8(%eax),%edx
  803154:	8b 45 08             	mov    0x8(%ebp),%eax
  803157:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80315a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80315e:	75 17                	jne    803177 <insert_sorted_with_merge_freeList+0x234>
  803160:	83 ec 04             	sub    $0x4,%esp
  803163:	68 04 42 80 00       	push   $0x804204
  803168:	68 31 01 00 00       	push   $0x131
  80316d:	68 27 42 80 00       	push   $0x804227
  803172:	e8 1a d6 ff ff       	call   800791 <_panic>
  803177:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	89 10                	mov    %edx,(%eax)
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	8b 00                	mov    (%eax),%eax
  803187:	85 c0                	test   %eax,%eax
  803189:	74 0d                	je     803198 <insert_sorted_with_merge_freeList+0x255>
  80318b:	a1 48 51 80 00       	mov    0x805148,%eax
  803190:	8b 55 08             	mov    0x8(%ebp),%edx
  803193:	89 50 04             	mov    %edx,0x4(%eax)
  803196:	eb 08                	jmp    8031a0 <insert_sorted_with_merge_freeList+0x25d>
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	a3 48 51 80 00       	mov    %eax,0x805148
  8031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b2:	a1 54 51 80 00       	mov    0x805154,%eax
  8031b7:	40                   	inc    %eax
  8031b8:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8031bd:	e9 da 04 00 00       	jmp    80369c <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  8031c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031c6:	75 17                	jne    8031df <insert_sorted_with_merge_freeList+0x29c>
  8031c8:	83 ec 04             	sub    $0x4,%esp
  8031cb:	68 ac 42 80 00       	push   $0x8042ac
  8031d0:	68 37 01 00 00       	push   $0x137
  8031d5:	68 27 42 80 00       	push   $0x804227
  8031da:	e8 b2 d5 ff ff       	call   800791 <_panic>
  8031df:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	89 50 04             	mov    %edx,0x4(%eax)
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	8b 40 04             	mov    0x4(%eax),%eax
  8031f1:	85 c0                	test   %eax,%eax
  8031f3:	74 0c                	je     803201 <insert_sorted_with_merge_freeList+0x2be>
  8031f5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8031fd:	89 10                	mov    %edx,(%eax)
  8031ff:	eb 08                	jmp    803209 <insert_sorted_with_merge_freeList+0x2c6>
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	a3 38 51 80 00       	mov    %eax,0x805138
  803209:	8b 45 08             	mov    0x8(%ebp),%eax
  80320c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80321a:	a1 44 51 80 00       	mov    0x805144,%eax
  80321f:	40                   	inc    %eax
  803220:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803225:	e9 72 04 00 00       	jmp    80369c <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80322a:	a1 38 51 80 00       	mov    0x805138,%eax
  80322f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803232:	e9 35 04 00 00       	jmp    80366c <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  803237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323a:	8b 00                	mov    (%eax),%eax
  80323c:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	8b 50 08             	mov    0x8(%eax),%edx
  803245:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803248:	8b 40 08             	mov    0x8(%eax),%eax
  80324b:	39 c2                	cmp    %eax,%edx
  80324d:	0f 86 11 04 00 00    	jbe    803664 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803256:	8b 50 08             	mov    0x8(%eax),%edx
  803259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325c:	8b 40 0c             	mov    0xc(%eax),%eax
  80325f:	01 c2                	add    %eax,%edx
  803261:	8b 45 08             	mov    0x8(%ebp),%eax
  803264:	8b 40 08             	mov    0x8(%eax),%eax
  803267:	39 c2                	cmp    %eax,%edx
  803269:	0f 83 8b 00 00 00    	jae    8032fa <insert_sorted_with_merge_freeList+0x3b7>
  80326f:	8b 45 08             	mov    0x8(%ebp),%eax
  803272:	8b 50 08             	mov    0x8(%eax),%edx
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	8b 40 0c             	mov    0xc(%eax),%eax
  80327b:	01 c2                	add    %eax,%edx
  80327d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803280:	8b 40 08             	mov    0x8(%eax),%eax
  803283:	39 c2                	cmp    %eax,%edx
  803285:	73 73                	jae    8032fa <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  803287:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80328b:	74 06                	je     803293 <insert_sorted_with_merge_freeList+0x350>
  80328d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803291:	75 17                	jne    8032aa <insert_sorted_with_merge_freeList+0x367>
  803293:	83 ec 04             	sub    $0x4,%esp
  803296:	68 78 42 80 00       	push   $0x804278
  80329b:	68 48 01 00 00       	push   $0x148
  8032a0:	68 27 42 80 00       	push   $0x804227
  8032a5:	e8 e7 d4 ff ff       	call   800791 <_panic>
  8032aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ad:	8b 10                	mov    (%eax),%edx
  8032af:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b2:	89 10                	mov    %edx,(%eax)
  8032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b7:	8b 00                	mov    (%eax),%eax
  8032b9:	85 c0                	test   %eax,%eax
  8032bb:	74 0b                	je     8032c8 <insert_sorted_with_merge_freeList+0x385>
  8032bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c0:	8b 00                	mov    (%eax),%eax
  8032c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c5:	89 50 04             	mov    %edx,0x4(%eax)
  8032c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ce:	89 10                	mov    %edx,(%eax)
  8032d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d6:	89 50 04             	mov    %edx,0x4(%eax)
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	8b 00                	mov    (%eax),%eax
  8032de:	85 c0                	test   %eax,%eax
  8032e0:	75 08                	jne    8032ea <insert_sorted_with_merge_freeList+0x3a7>
  8032e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8032ef:	40                   	inc    %eax
  8032f0:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  8032f5:	e9 a2 03 00 00       	jmp    80369c <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fd:	8b 50 08             	mov    0x8(%eax),%edx
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	8b 40 0c             	mov    0xc(%eax),%eax
  803306:	01 c2                	add    %eax,%edx
  803308:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80330b:	8b 40 08             	mov    0x8(%eax),%eax
  80330e:	39 c2                	cmp    %eax,%edx
  803310:	0f 83 ae 00 00 00    	jae    8033c4 <insert_sorted_with_merge_freeList+0x481>
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	8b 50 08             	mov    0x8(%eax),%edx
  80331c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331f:	8b 48 08             	mov    0x8(%eax),%ecx
  803322:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803325:	8b 40 0c             	mov    0xc(%eax),%eax
  803328:	01 c8                	add    %ecx,%eax
  80332a:	39 c2                	cmp    %eax,%edx
  80332c:	0f 85 92 00 00 00    	jne    8033c4 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  803332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803335:	8b 50 0c             	mov    0xc(%eax),%edx
  803338:	8b 45 08             	mov    0x8(%ebp),%eax
  80333b:	8b 40 0c             	mov    0xc(%eax),%eax
  80333e:	01 c2                	add    %eax,%edx
  803340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803343:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803346:	8b 45 08             	mov    0x8(%ebp),%eax
  803349:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803350:	8b 45 08             	mov    0x8(%ebp),%eax
  803353:	8b 50 08             	mov    0x8(%eax),%edx
  803356:	8b 45 08             	mov    0x8(%ebp),%eax
  803359:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80335c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803360:	75 17                	jne    803379 <insert_sorted_with_merge_freeList+0x436>
  803362:	83 ec 04             	sub    $0x4,%esp
  803365:	68 04 42 80 00       	push   $0x804204
  80336a:	68 51 01 00 00       	push   $0x151
  80336f:	68 27 42 80 00       	push   $0x804227
  803374:	e8 18 d4 ff ff       	call   800791 <_panic>
  803379:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	89 10                	mov    %edx,(%eax)
  803384:	8b 45 08             	mov    0x8(%ebp),%eax
  803387:	8b 00                	mov    (%eax),%eax
  803389:	85 c0                	test   %eax,%eax
  80338b:	74 0d                	je     80339a <insert_sorted_with_merge_freeList+0x457>
  80338d:	a1 48 51 80 00       	mov    0x805148,%eax
  803392:	8b 55 08             	mov    0x8(%ebp),%edx
  803395:	89 50 04             	mov    %edx,0x4(%eax)
  803398:	eb 08                	jmp    8033a2 <insert_sorted_with_merge_freeList+0x45f>
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8033b9:	40                   	inc    %eax
  8033ba:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  8033bf:	e9 d8 02 00 00       	jmp    80369c <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  8033c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c7:	8b 50 08             	mov    0x8(%eax),%edx
  8033ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d0:	01 c2                	add    %eax,%edx
  8033d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033d5:	8b 40 08             	mov    0x8(%eax),%eax
  8033d8:	39 c2                	cmp    %eax,%edx
  8033da:	0f 85 ba 00 00 00    	jne    80349a <insert_sorted_with_merge_freeList+0x557>
  8033e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e3:	8b 50 08             	mov    0x8(%eax),%edx
  8033e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e9:	8b 48 08             	mov    0x8(%eax),%ecx
  8033ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f2:	01 c8                	add    %ecx,%eax
  8033f4:	39 c2                	cmp    %eax,%edx
  8033f6:	0f 86 9e 00 00 00    	jbe    80349a <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  8033fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ff:	8b 50 0c             	mov    0xc(%eax),%edx
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	8b 40 0c             	mov    0xc(%eax),%eax
  803408:	01 c2                	add    %eax,%edx
  80340a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80340d:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803410:	8b 45 08             	mov    0x8(%ebp),%eax
  803413:	8b 50 08             	mov    0x8(%eax),%edx
  803416:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803419:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  80341c:	8b 45 08             	mov    0x8(%ebp),%eax
  80341f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803426:	8b 45 08             	mov    0x8(%ebp),%eax
  803429:	8b 50 08             	mov    0x8(%eax),%edx
  80342c:	8b 45 08             	mov    0x8(%ebp),%eax
  80342f:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803432:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803436:	75 17                	jne    80344f <insert_sorted_with_merge_freeList+0x50c>
  803438:	83 ec 04             	sub    $0x4,%esp
  80343b:	68 04 42 80 00       	push   $0x804204
  803440:	68 5b 01 00 00       	push   $0x15b
  803445:	68 27 42 80 00       	push   $0x804227
  80344a:	e8 42 d3 ff ff       	call   800791 <_panic>
  80344f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803455:	8b 45 08             	mov    0x8(%ebp),%eax
  803458:	89 10                	mov    %edx,(%eax)
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	8b 00                	mov    (%eax),%eax
  80345f:	85 c0                	test   %eax,%eax
  803461:	74 0d                	je     803470 <insert_sorted_with_merge_freeList+0x52d>
  803463:	a1 48 51 80 00       	mov    0x805148,%eax
  803468:	8b 55 08             	mov    0x8(%ebp),%edx
  80346b:	89 50 04             	mov    %edx,0x4(%eax)
  80346e:	eb 08                	jmp    803478 <insert_sorted_with_merge_freeList+0x535>
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803478:	8b 45 08             	mov    0x8(%ebp),%eax
  80347b:	a3 48 51 80 00       	mov    %eax,0x805148
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80348a:	a1 54 51 80 00       	mov    0x805154,%eax
  80348f:	40                   	inc    %eax
  803490:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803495:	e9 02 02 00 00       	jmp    80369c <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80349a:	8b 45 08             	mov    0x8(%ebp),%eax
  80349d:	8b 50 08             	mov    0x8(%eax),%edx
  8034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8034a6:	01 c2                	add    %eax,%edx
  8034a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ab:	8b 40 08             	mov    0x8(%eax),%eax
  8034ae:	39 c2                	cmp    %eax,%edx
  8034b0:	0f 85 ae 01 00 00    	jne    803664 <insert_sorted_with_merge_freeList+0x721>
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	8b 50 08             	mov    0x8(%eax),%edx
  8034bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bf:	8b 48 08             	mov    0x8(%eax),%ecx
  8034c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8034c8:	01 c8                	add    %ecx,%eax
  8034ca:	39 c2                	cmp    %eax,%edx
  8034cc:	0f 85 92 01 00 00    	jne    803664 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  8034d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8034d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034db:	8b 40 0c             	mov    0xc(%eax),%eax
  8034de:	01 c2                	add    %eax,%edx
  8034e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e6:	01 c2                	add    %eax,%edx
  8034e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034eb:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	8b 50 08             	mov    0x8(%eax),%edx
  8034fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803501:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803504:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803507:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80350e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803511:	8b 50 08             	mov    0x8(%eax),%edx
  803514:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803517:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  80351a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80351e:	75 17                	jne    803537 <insert_sorted_with_merge_freeList+0x5f4>
  803520:	83 ec 04             	sub    $0x4,%esp
  803523:	68 cf 42 80 00       	push   $0x8042cf
  803528:	68 63 01 00 00       	push   $0x163
  80352d:	68 27 42 80 00       	push   $0x804227
  803532:	e8 5a d2 ff ff       	call   800791 <_panic>
  803537:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353a:	8b 00                	mov    (%eax),%eax
  80353c:	85 c0                	test   %eax,%eax
  80353e:	74 10                	je     803550 <insert_sorted_with_merge_freeList+0x60d>
  803540:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803543:	8b 00                	mov    (%eax),%eax
  803545:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803548:	8b 52 04             	mov    0x4(%edx),%edx
  80354b:	89 50 04             	mov    %edx,0x4(%eax)
  80354e:	eb 0b                	jmp    80355b <insert_sorted_with_merge_freeList+0x618>
  803550:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803553:	8b 40 04             	mov    0x4(%eax),%eax
  803556:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80355b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355e:	8b 40 04             	mov    0x4(%eax),%eax
  803561:	85 c0                	test   %eax,%eax
  803563:	74 0f                	je     803574 <insert_sorted_with_merge_freeList+0x631>
  803565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803568:	8b 40 04             	mov    0x4(%eax),%eax
  80356b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80356e:	8b 12                	mov    (%edx),%edx
  803570:	89 10                	mov    %edx,(%eax)
  803572:	eb 0a                	jmp    80357e <insert_sorted_with_merge_freeList+0x63b>
  803574:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803577:	8b 00                	mov    (%eax),%eax
  803579:	a3 38 51 80 00       	mov    %eax,0x805138
  80357e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803581:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803587:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80358a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803591:	a1 44 51 80 00       	mov    0x805144,%eax
  803596:	48                   	dec    %eax
  803597:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  80359c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8035a0:	75 17                	jne    8035b9 <insert_sorted_with_merge_freeList+0x676>
  8035a2:	83 ec 04             	sub    $0x4,%esp
  8035a5:	68 04 42 80 00       	push   $0x804204
  8035aa:	68 64 01 00 00       	push   $0x164
  8035af:	68 27 42 80 00       	push   $0x804227
  8035b4:	e8 d8 d1 ff ff       	call   800791 <_panic>
  8035b9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c2:	89 10                	mov    %edx,(%eax)
  8035c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035c7:	8b 00                	mov    (%eax),%eax
  8035c9:	85 c0                	test   %eax,%eax
  8035cb:	74 0d                	je     8035da <insert_sorted_with_merge_freeList+0x697>
  8035cd:	a1 48 51 80 00       	mov    0x805148,%eax
  8035d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035d5:	89 50 04             	mov    %edx,0x4(%eax)
  8035d8:	eb 08                	jmp    8035e2 <insert_sorted_with_merge_freeList+0x69f>
  8035da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035dd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e5:	a3 48 51 80 00       	mov    %eax,0x805148
  8035ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f4:	a1 54 51 80 00       	mov    0x805154,%eax
  8035f9:	40                   	inc    %eax
  8035fa:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8035ff:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803603:	75 17                	jne    80361c <insert_sorted_with_merge_freeList+0x6d9>
  803605:	83 ec 04             	sub    $0x4,%esp
  803608:	68 04 42 80 00       	push   $0x804204
  80360d:	68 65 01 00 00       	push   $0x165
  803612:	68 27 42 80 00       	push   $0x804227
  803617:	e8 75 d1 ff ff       	call   800791 <_panic>
  80361c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803622:	8b 45 08             	mov    0x8(%ebp),%eax
  803625:	89 10                	mov    %edx,(%eax)
  803627:	8b 45 08             	mov    0x8(%ebp),%eax
  80362a:	8b 00                	mov    (%eax),%eax
  80362c:	85 c0                	test   %eax,%eax
  80362e:	74 0d                	je     80363d <insert_sorted_with_merge_freeList+0x6fa>
  803630:	a1 48 51 80 00       	mov    0x805148,%eax
  803635:	8b 55 08             	mov    0x8(%ebp),%edx
  803638:	89 50 04             	mov    %edx,0x4(%eax)
  80363b:	eb 08                	jmp    803645 <insert_sorted_with_merge_freeList+0x702>
  80363d:	8b 45 08             	mov    0x8(%ebp),%eax
  803640:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803645:	8b 45 08             	mov    0x8(%ebp),%eax
  803648:	a3 48 51 80 00       	mov    %eax,0x805148
  80364d:	8b 45 08             	mov    0x8(%ebp),%eax
  803650:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803657:	a1 54 51 80 00       	mov    0x805154,%eax
  80365c:	40                   	inc    %eax
  80365d:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803662:	eb 38                	jmp    80369c <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803664:	a1 40 51 80 00       	mov    0x805140,%eax
  803669:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80366c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803670:	74 07                	je     803679 <insert_sorted_with_merge_freeList+0x736>
  803672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803675:	8b 00                	mov    (%eax),%eax
  803677:	eb 05                	jmp    80367e <insert_sorted_with_merge_freeList+0x73b>
  803679:	b8 00 00 00 00       	mov    $0x0,%eax
  80367e:	a3 40 51 80 00       	mov    %eax,0x805140
  803683:	a1 40 51 80 00       	mov    0x805140,%eax
  803688:	85 c0                	test   %eax,%eax
  80368a:	0f 85 a7 fb ff ff    	jne    803237 <insert_sorted_with_merge_freeList+0x2f4>
  803690:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803694:	0f 85 9d fb ff ff    	jne    803237 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80369a:	eb 00                	jmp    80369c <insert_sorted_with_merge_freeList+0x759>
  80369c:	90                   	nop
  80369d:	c9                   	leave  
  80369e:	c3                   	ret    
  80369f:	90                   	nop

008036a0 <__udivdi3>:
  8036a0:	55                   	push   %ebp
  8036a1:	57                   	push   %edi
  8036a2:	56                   	push   %esi
  8036a3:	53                   	push   %ebx
  8036a4:	83 ec 1c             	sub    $0x1c,%esp
  8036a7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036ab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036b7:	89 ca                	mov    %ecx,%edx
  8036b9:	89 f8                	mov    %edi,%eax
  8036bb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036bf:	85 f6                	test   %esi,%esi
  8036c1:	75 2d                	jne    8036f0 <__udivdi3+0x50>
  8036c3:	39 cf                	cmp    %ecx,%edi
  8036c5:	77 65                	ja     80372c <__udivdi3+0x8c>
  8036c7:	89 fd                	mov    %edi,%ebp
  8036c9:	85 ff                	test   %edi,%edi
  8036cb:	75 0b                	jne    8036d8 <__udivdi3+0x38>
  8036cd:	b8 01 00 00 00       	mov    $0x1,%eax
  8036d2:	31 d2                	xor    %edx,%edx
  8036d4:	f7 f7                	div    %edi
  8036d6:	89 c5                	mov    %eax,%ebp
  8036d8:	31 d2                	xor    %edx,%edx
  8036da:	89 c8                	mov    %ecx,%eax
  8036dc:	f7 f5                	div    %ebp
  8036de:	89 c1                	mov    %eax,%ecx
  8036e0:	89 d8                	mov    %ebx,%eax
  8036e2:	f7 f5                	div    %ebp
  8036e4:	89 cf                	mov    %ecx,%edi
  8036e6:	89 fa                	mov    %edi,%edx
  8036e8:	83 c4 1c             	add    $0x1c,%esp
  8036eb:	5b                   	pop    %ebx
  8036ec:	5e                   	pop    %esi
  8036ed:	5f                   	pop    %edi
  8036ee:	5d                   	pop    %ebp
  8036ef:	c3                   	ret    
  8036f0:	39 ce                	cmp    %ecx,%esi
  8036f2:	77 28                	ja     80371c <__udivdi3+0x7c>
  8036f4:	0f bd fe             	bsr    %esi,%edi
  8036f7:	83 f7 1f             	xor    $0x1f,%edi
  8036fa:	75 40                	jne    80373c <__udivdi3+0x9c>
  8036fc:	39 ce                	cmp    %ecx,%esi
  8036fe:	72 0a                	jb     80370a <__udivdi3+0x6a>
  803700:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803704:	0f 87 9e 00 00 00    	ja     8037a8 <__udivdi3+0x108>
  80370a:	b8 01 00 00 00       	mov    $0x1,%eax
  80370f:	89 fa                	mov    %edi,%edx
  803711:	83 c4 1c             	add    $0x1c,%esp
  803714:	5b                   	pop    %ebx
  803715:	5e                   	pop    %esi
  803716:	5f                   	pop    %edi
  803717:	5d                   	pop    %ebp
  803718:	c3                   	ret    
  803719:	8d 76 00             	lea    0x0(%esi),%esi
  80371c:	31 ff                	xor    %edi,%edi
  80371e:	31 c0                	xor    %eax,%eax
  803720:	89 fa                	mov    %edi,%edx
  803722:	83 c4 1c             	add    $0x1c,%esp
  803725:	5b                   	pop    %ebx
  803726:	5e                   	pop    %esi
  803727:	5f                   	pop    %edi
  803728:	5d                   	pop    %ebp
  803729:	c3                   	ret    
  80372a:	66 90                	xchg   %ax,%ax
  80372c:	89 d8                	mov    %ebx,%eax
  80372e:	f7 f7                	div    %edi
  803730:	31 ff                	xor    %edi,%edi
  803732:	89 fa                	mov    %edi,%edx
  803734:	83 c4 1c             	add    $0x1c,%esp
  803737:	5b                   	pop    %ebx
  803738:	5e                   	pop    %esi
  803739:	5f                   	pop    %edi
  80373a:	5d                   	pop    %ebp
  80373b:	c3                   	ret    
  80373c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803741:	89 eb                	mov    %ebp,%ebx
  803743:	29 fb                	sub    %edi,%ebx
  803745:	89 f9                	mov    %edi,%ecx
  803747:	d3 e6                	shl    %cl,%esi
  803749:	89 c5                	mov    %eax,%ebp
  80374b:	88 d9                	mov    %bl,%cl
  80374d:	d3 ed                	shr    %cl,%ebp
  80374f:	89 e9                	mov    %ebp,%ecx
  803751:	09 f1                	or     %esi,%ecx
  803753:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803757:	89 f9                	mov    %edi,%ecx
  803759:	d3 e0                	shl    %cl,%eax
  80375b:	89 c5                	mov    %eax,%ebp
  80375d:	89 d6                	mov    %edx,%esi
  80375f:	88 d9                	mov    %bl,%cl
  803761:	d3 ee                	shr    %cl,%esi
  803763:	89 f9                	mov    %edi,%ecx
  803765:	d3 e2                	shl    %cl,%edx
  803767:	8b 44 24 08          	mov    0x8(%esp),%eax
  80376b:	88 d9                	mov    %bl,%cl
  80376d:	d3 e8                	shr    %cl,%eax
  80376f:	09 c2                	or     %eax,%edx
  803771:	89 d0                	mov    %edx,%eax
  803773:	89 f2                	mov    %esi,%edx
  803775:	f7 74 24 0c          	divl   0xc(%esp)
  803779:	89 d6                	mov    %edx,%esi
  80377b:	89 c3                	mov    %eax,%ebx
  80377d:	f7 e5                	mul    %ebp
  80377f:	39 d6                	cmp    %edx,%esi
  803781:	72 19                	jb     80379c <__udivdi3+0xfc>
  803783:	74 0b                	je     803790 <__udivdi3+0xf0>
  803785:	89 d8                	mov    %ebx,%eax
  803787:	31 ff                	xor    %edi,%edi
  803789:	e9 58 ff ff ff       	jmp    8036e6 <__udivdi3+0x46>
  80378e:	66 90                	xchg   %ax,%ax
  803790:	8b 54 24 08          	mov    0x8(%esp),%edx
  803794:	89 f9                	mov    %edi,%ecx
  803796:	d3 e2                	shl    %cl,%edx
  803798:	39 c2                	cmp    %eax,%edx
  80379a:	73 e9                	jae    803785 <__udivdi3+0xe5>
  80379c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80379f:	31 ff                	xor    %edi,%edi
  8037a1:	e9 40 ff ff ff       	jmp    8036e6 <__udivdi3+0x46>
  8037a6:	66 90                	xchg   %ax,%ax
  8037a8:	31 c0                	xor    %eax,%eax
  8037aa:	e9 37 ff ff ff       	jmp    8036e6 <__udivdi3+0x46>
  8037af:	90                   	nop

008037b0 <__umoddi3>:
  8037b0:	55                   	push   %ebp
  8037b1:	57                   	push   %edi
  8037b2:	56                   	push   %esi
  8037b3:	53                   	push   %ebx
  8037b4:	83 ec 1c             	sub    $0x1c,%esp
  8037b7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037bb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037c3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037cb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037cf:	89 f3                	mov    %esi,%ebx
  8037d1:	89 fa                	mov    %edi,%edx
  8037d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037d7:	89 34 24             	mov    %esi,(%esp)
  8037da:	85 c0                	test   %eax,%eax
  8037dc:	75 1a                	jne    8037f8 <__umoddi3+0x48>
  8037de:	39 f7                	cmp    %esi,%edi
  8037e0:	0f 86 a2 00 00 00    	jbe    803888 <__umoddi3+0xd8>
  8037e6:	89 c8                	mov    %ecx,%eax
  8037e8:	89 f2                	mov    %esi,%edx
  8037ea:	f7 f7                	div    %edi
  8037ec:	89 d0                	mov    %edx,%eax
  8037ee:	31 d2                	xor    %edx,%edx
  8037f0:	83 c4 1c             	add    $0x1c,%esp
  8037f3:	5b                   	pop    %ebx
  8037f4:	5e                   	pop    %esi
  8037f5:	5f                   	pop    %edi
  8037f6:	5d                   	pop    %ebp
  8037f7:	c3                   	ret    
  8037f8:	39 f0                	cmp    %esi,%eax
  8037fa:	0f 87 ac 00 00 00    	ja     8038ac <__umoddi3+0xfc>
  803800:	0f bd e8             	bsr    %eax,%ebp
  803803:	83 f5 1f             	xor    $0x1f,%ebp
  803806:	0f 84 ac 00 00 00    	je     8038b8 <__umoddi3+0x108>
  80380c:	bf 20 00 00 00       	mov    $0x20,%edi
  803811:	29 ef                	sub    %ebp,%edi
  803813:	89 fe                	mov    %edi,%esi
  803815:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803819:	89 e9                	mov    %ebp,%ecx
  80381b:	d3 e0                	shl    %cl,%eax
  80381d:	89 d7                	mov    %edx,%edi
  80381f:	89 f1                	mov    %esi,%ecx
  803821:	d3 ef                	shr    %cl,%edi
  803823:	09 c7                	or     %eax,%edi
  803825:	89 e9                	mov    %ebp,%ecx
  803827:	d3 e2                	shl    %cl,%edx
  803829:	89 14 24             	mov    %edx,(%esp)
  80382c:	89 d8                	mov    %ebx,%eax
  80382e:	d3 e0                	shl    %cl,%eax
  803830:	89 c2                	mov    %eax,%edx
  803832:	8b 44 24 08          	mov    0x8(%esp),%eax
  803836:	d3 e0                	shl    %cl,%eax
  803838:	89 44 24 04          	mov    %eax,0x4(%esp)
  80383c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803840:	89 f1                	mov    %esi,%ecx
  803842:	d3 e8                	shr    %cl,%eax
  803844:	09 d0                	or     %edx,%eax
  803846:	d3 eb                	shr    %cl,%ebx
  803848:	89 da                	mov    %ebx,%edx
  80384a:	f7 f7                	div    %edi
  80384c:	89 d3                	mov    %edx,%ebx
  80384e:	f7 24 24             	mull   (%esp)
  803851:	89 c6                	mov    %eax,%esi
  803853:	89 d1                	mov    %edx,%ecx
  803855:	39 d3                	cmp    %edx,%ebx
  803857:	0f 82 87 00 00 00    	jb     8038e4 <__umoddi3+0x134>
  80385d:	0f 84 91 00 00 00    	je     8038f4 <__umoddi3+0x144>
  803863:	8b 54 24 04          	mov    0x4(%esp),%edx
  803867:	29 f2                	sub    %esi,%edx
  803869:	19 cb                	sbb    %ecx,%ebx
  80386b:	89 d8                	mov    %ebx,%eax
  80386d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803871:	d3 e0                	shl    %cl,%eax
  803873:	89 e9                	mov    %ebp,%ecx
  803875:	d3 ea                	shr    %cl,%edx
  803877:	09 d0                	or     %edx,%eax
  803879:	89 e9                	mov    %ebp,%ecx
  80387b:	d3 eb                	shr    %cl,%ebx
  80387d:	89 da                	mov    %ebx,%edx
  80387f:	83 c4 1c             	add    $0x1c,%esp
  803882:	5b                   	pop    %ebx
  803883:	5e                   	pop    %esi
  803884:	5f                   	pop    %edi
  803885:	5d                   	pop    %ebp
  803886:	c3                   	ret    
  803887:	90                   	nop
  803888:	89 fd                	mov    %edi,%ebp
  80388a:	85 ff                	test   %edi,%edi
  80388c:	75 0b                	jne    803899 <__umoddi3+0xe9>
  80388e:	b8 01 00 00 00       	mov    $0x1,%eax
  803893:	31 d2                	xor    %edx,%edx
  803895:	f7 f7                	div    %edi
  803897:	89 c5                	mov    %eax,%ebp
  803899:	89 f0                	mov    %esi,%eax
  80389b:	31 d2                	xor    %edx,%edx
  80389d:	f7 f5                	div    %ebp
  80389f:	89 c8                	mov    %ecx,%eax
  8038a1:	f7 f5                	div    %ebp
  8038a3:	89 d0                	mov    %edx,%eax
  8038a5:	e9 44 ff ff ff       	jmp    8037ee <__umoddi3+0x3e>
  8038aa:	66 90                	xchg   %ax,%ax
  8038ac:	89 c8                	mov    %ecx,%eax
  8038ae:	89 f2                	mov    %esi,%edx
  8038b0:	83 c4 1c             	add    $0x1c,%esp
  8038b3:	5b                   	pop    %ebx
  8038b4:	5e                   	pop    %esi
  8038b5:	5f                   	pop    %edi
  8038b6:	5d                   	pop    %ebp
  8038b7:	c3                   	ret    
  8038b8:	3b 04 24             	cmp    (%esp),%eax
  8038bb:	72 06                	jb     8038c3 <__umoddi3+0x113>
  8038bd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038c1:	77 0f                	ja     8038d2 <__umoddi3+0x122>
  8038c3:	89 f2                	mov    %esi,%edx
  8038c5:	29 f9                	sub    %edi,%ecx
  8038c7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038cb:	89 14 24             	mov    %edx,(%esp)
  8038ce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038d2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038d6:	8b 14 24             	mov    (%esp),%edx
  8038d9:	83 c4 1c             	add    $0x1c,%esp
  8038dc:	5b                   	pop    %ebx
  8038dd:	5e                   	pop    %esi
  8038de:	5f                   	pop    %edi
  8038df:	5d                   	pop    %ebp
  8038e0:	c3                   	ret    
  8038e1:	8d 76 00             	lea    0x0(%esi),%esi
  8038e4:	2b 04 24             	sub    (%esp),%eax
  8038e7:	19 fa                	sbb    %edi,%edx
  8038e9:	89 d1                	mov    %edx,%ecx
  8038eb:	89 c6                	mov    %eax,%esi
  8038ed:	e9 71 ff ff ff       	jmp    803863 <__umoddi3+0xb3>
  8038f2:	66 90                	xchg   %ax,%ax
  8038f4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038f8:	72 ea                	jb     8038e4 <__umoddi3+0x134>
  8038fa:	89 d9                	mov    %ebx,%ecx
  8038fc:	e9 62 ff ff ff       	jmp    803863 <__umoddi3+0xb3>
