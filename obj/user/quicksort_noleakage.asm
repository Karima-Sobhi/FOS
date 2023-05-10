
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 0e 06 00 00       	call   800644 <libmain>
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
  800041:	e8 3b 20 00 00       	call   802081 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 39 80 00       	push   $0x803900
  80004e:	e8 e1 09 00 00       	call   800a34 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 39 80 00       	push   $0x803902
  80005e:	e8 d1 09 00 00       	call   800a34 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 1b 39 80 00       	push   $0x80391b
  80006e:	e8 c1 09 00 00       	call   800a34 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 39 80 00       	push   $0x803902
  80007e:	e8 b1 09 00 00       	call   800a34 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 39 80 00       	push   $0x803900
  80008e:	e8 a1 09 00 00       	call   800a34 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 34 39 80 00       	push   $0x803934
  8000a5:	e8 0c 10 00 00       	call   8010b6 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 5c 15 00 00       	call   80161c <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 91 1a 00 00       	call   801b66 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 54 39 80 00       	push   $0x803954
  8000e3:	e8 4c 09 00 00       	call   800a34 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 76 39 80 00       	push   $0x803976
  8000f3:	e8 3c 09 00 00       	call   800a34 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 84 39 80 00       	push   $0x803984
  800103:	e8 2c 09 00 00       	call   800a34 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 93 39 80 00       	push   $0x803993
  800113:	e8 1c 09 00 00       	call   800a34 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 a3 39 80 00       	push   $0x8039a3
  800123:	e8 0c 09 00 00       	call   800a34 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 bc 04 00 00       	call   8005ec <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
			cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 64 04 00 00       	call   8005a4 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 57 04 00 00       	call   8005a4 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d ef 61          	cmpb   $0x61,-0x11(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d ef 62          	cmpb   $0x62,-0x11(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d ef 63          	cmpb   $0x63,-0x11(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 34 1f 00 00       	call   80209b <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
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
  80017d:	ff 75 f4             	pushl  -0xc(%ebp)
  800180:	ff 75 f0             	pushl  -0x10(%ebp)
  800183:	e8 e4 02 00 00       	call   80046c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f4             	pushl  -0xc(%ebp)
  800193:	ff 75 f0             	pushl  -0x10(%ebp)
  800196:	e8 02 03 00 00       	call   80049d <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 24 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bc:	e8 11 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8001cd:	e8 df 00 00 00       	call   8002b1 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 a7 1e 00 00       	call   802081 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 ac 39 80 00       	push   $0x8039ac
  8001e2:	e8 4d 08 00 00       	call   800a34 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 ac 1e 00 00       	call   80209b <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f8:	e8 c5 01 00 00       	call   8003c2 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 e0 39 80 00       	push   $0x8039e0
  800211:	6a 49                	push   $0x49
  800213:	68 02 3a 80 00       	push   $0x803a02
  800218:	e8 63 05 00 00       	call   800780 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 5f 1e 00 00       	call   802081 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 20 3a 80 00       	push   $0x803a20
  80022a:	e8 05 08 00 00       	call   800a34 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 54 3a 80 00       	push   $0x803a54
  80023a:	e8 f5 07 00 00       	call   800a34 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 88 3a 80 00       	push   $0x803a88
  80024a:	e8 e5 07 00 00       	call   800a34 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 44 1e 00 00       	call   80209b <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 7f 19 00 00       	call   801be1 <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 17 1e 00 00       	call   802081 <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 ba 3a 80 00       	push   $0x803aba
  800272:	e8 bd 07 00 00       	call   800a34 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80027a:	e8 6d 03 00 00       	call   8005ec <getchar>
  80027f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800282:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 15 03 00 00       	call   8005a4 <cputchar>
  80028f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 0a                	push   $0xa
  800297:	e8 08 03 00 00       	call   8005a4 <cputchar>
  80029c:	83 c4 10             	add    $0x10,%esp

		sys_enable_interrupt();
  80029f:	e8 f7 1d 00 00       	call   80209b <sys_enable_interrupt>

	} while (Chose == 'y');
  8002a4:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  8002a8:	0f 84 93 fd ff ff    	je     800041 <_main+0x9>

}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	48                   	dec    %eax
  8002bb:	50                   	push   %eax
  8002bc:	6a 00                	push   $0x0
  8002be:	ff 75 0c             	pushl  0xc(%ebp)
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	e8 06 00 00 00       	call   8002cf <QSort>
  8002c9:	83 c4 10             	add    $0x10,%esp
}
  8002cc:	90                   	nop
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d8:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002db:	0f 8d de 00 00 00    	jge    8003bf <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e4:	40                   	inc    %eax
  8002e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ee:	e9 80 00 00 00       	jmp    800373 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002f3:	ff 45 f4             	incl   -0xc(%ebp)
  8002f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fc:	7f 2b                	jg     800329 <QSort+0x5a>
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800312:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 c8                	add    %ecx,%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	39 c2                	cmp    %eax,%edx
  800322:	7d cf                	jge    8002f3 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800324:	eb 03                	jmp    800329 <QSort+0x5a>
  800326:	ff 4d f0             	decl   -0x10(%ebp)
  800329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80032f:	7e 26                	jle    800357 <QSort+0x88>
  800331:	8b 45 10             	mov    0x10(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 c8                	add    %ecx,%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	39 c2                	cmp    %eax,%edx
  800355:	7e cf                	jle    800326 <QSort+0x57>

		if (i <= j)
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80035d:	7f 14                	jg     800373 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	ff 75 f4             	pushl  -0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 a9 00 00 00       	call   800419 <Swap>
  800370:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800379:	0f 8e 77 ff ff ff    	jle    8002f6 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 f0             	pushl  -0x10(%ebp)
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	e8 89 00 00 00       	call   800419 <Swap>
  800390:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800396:	48                   	dec    %eax
  800397:	50                   	push   %eax
  800398:	ff 75 10             	pushl  0x10(%ebp)
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 29 ff ff ff       	call   8002cf <QSort>
  8003a6:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003a9:	ff 75 14             	pushl  0x14(%ebp)
  8003ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	e8 15 ff ff ff       	call   8002cf <QSort>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb 01                	jmp    8003c0 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003bf:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003c8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003d6:	eb 33                	jmp    80040b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	8b 10                	mov    (%eax),%edx
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	40                   	inc    %eax
  8003ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	7e 09                	jle    800408 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800406:	eb 0c                	jmp    800414 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800408:	ff 45 f8             	incl   -0x8(%ebp)
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	48                   	dec    %eax
  80040f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800412:	7f c4                	jg     8003d8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800414:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
  800436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	01 c2                	add    %eax,%edx
  800442:	8b 45 10             	mov    0x10(%ebp),%eax
  800445:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	01 c2                	add    %eax,%edx
  800464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800467:	89 02                	mov    %eax,(%edx)
}
  800469:	90                   	nop
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800479:	eb 17                	jmp    800492 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80047b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c2                	add    %eax,%edx
  80048a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80048f:	ff 45 fc             	incl   -0x4(%ebp)
  800492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800495:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800498:	7c e1                	jl     80047b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004aa:	eb 1b                	jmp    8004c7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	01 c2                	add    %eax,%edx
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c4:	ff 45 fc             	incl   -0x4(%ebp)
  8004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cd:	7c dd                	jl     8004ac <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004db:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004e0:	f7 e9                	imul   %ecx
  8004e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	29 c8                	sub    %ecx,%eax
  8004e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004f3:	eb 1e                	jmp    800513 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800508:	99                   	cltd   
  800509:	f7 7d f8             	idivl  -0x8(%ebp)
  80050c:	89 d0                	mov    %edx,%eax
  80050e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800510:	ff 45 fc             	incl   -0x4(%ebp)
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800519:	7c da                	jl     8004f5 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800524:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800532:	eb 42                	jmp    800576 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	99                   	cltd   
  800538:	f7 7d f0             	idivl  -0x10(%ebp)
  80053b:	89 d0                	mov    %edx,%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	75 10                	jne    800551 <PrintElements+0x33>
			cprintf("\n");
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	68 00 39 80 00       	push   $0x803900
  800549:	e8 e6 04 00 00       	call   800a34 <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	01 d0                	add    %edx,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	50                   	push   %eax
  800566:	68 d8 3a 80 00       	push   $0x803ad8
  80056b:	e8 c4 04 00 00       	call   800a34 <cprintf>
  800570:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800573:	ff 45 f4             	incl   -0xc(%ebp)
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	48                   	dec    %eax
  80057a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80057d:	7f b5                	jg     800534 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80057f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800582:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	50                   	push   %eax
  800594:	68 dd 3a 80 00       	push   $0x803add
  800599:	e8 96 04 00 00       	call   800a34 <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp

}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005b0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	50                   	push   %eax
  8005b8:	e8 f8 1a 00 00       	call   8020b5 <sys_cputc>
  8005bd:	83 c4 10             	add    $0x10,%esp
}
  8005c0:	90                   	nop
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c9:	e8 b3 1a 00 00       	call   802081 <sys_disable_interrupt>
	char c = ch;
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	e8 d4 1a 00 00       	call   8020b5 <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 b2 1a 00 00       	call   80209b <sys_enable_interrupt>
}
  8005e9:	90                   	nop
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <getchar>:

int
getchar(void)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005f9:	eb 08                	jmp    800603 <getchar+0x17>
	{
		c = sys_cgetc();
  8005fb:	e8 fc 18 00 00       	call   801efc <sys_cgetc>
  800600:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800607:	74 f2                	je     8005fb <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800609:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <atomic_getchar>:

int
atomic_getchar(void)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800614:	e8 68 1a 00 00       	call   802081 <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 d5 18 00 00       	call   801efc <sys_cgetc>
  800627:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80062a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80062e:	74 f2                	je     800622 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800630:	e8 66 1a 00 00       	call   80209b <sys_enable_interrupt>
	return c;
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <iscons>:

int iscons(int fdnum)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80063d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800642:	5d                   	pop    %ebp
  800643:	c3                   	ret    

00800644 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80064a:	e8 25 1c 00 00       	call   802274 <sys_getenvindex>
  80064f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	c1 e0 03             	shl    $0x3,%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	01 c0                	add    %eax,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	01 d0                	add    %edx,%eax
  800669:	c1 e0 04             	shl    $0x4,%eax
  80066c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800671:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800676:	a1 24 50 80 00       	mov    0x805024,%eax
  80067b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800681:	84 c0                	test   %al,%al
  800683:	74 0f                	je     800694 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800685:	a1 24 50 80 00       	mov    0x805024,%eax
  80068a:	05 5c 05 00 00       	add    $0x55c,%eax
  80068f:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800694:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800698:	7e 0a                	jle    8006a4 <libmain+0x60>
		binaryname = argv[0];
  80069a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	ff 75 0c             	pushl  0xc(%ebp)
  8006aa:	ff 75 08             	pushl  0x8(%ebp)
  8006ad:	e8 86 f9 ff ff       	call   800038 <_main>
  8006b2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006b5:	e8 c7 19 00 00       	call   802081 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	68 fc 3a 80 00       	push   $0x803afc
  8006c2:	e8 6d 03 00 00       	call   800a34 <cprintf>
  8006c7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006ca:	a1 24 50 80 00       	mov    0x805024,%eax
  8006cf:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8006da:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006e0:	83 ec 04             	sub    $0x4,%esp
  8006e3:	52                   	push   %edx
  8006e4:	50                   	push   %eax
  8006e5:	68 24 3b 80 00       	push   $0x803b24
  8006ea:	e8 45 03 00 00       	call   800a34 <cprintf>
  8006ef:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006f2:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f7:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006fd:	a1 24 50 80 00       	mov    0x805024,%eax
  800702:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800708:	a1 24 50 80 00       	mov    0x805024,%eax
  80070d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800713:	51                   	push   %ecx
  800714:	52                   	push   %edx
  800715:	50                   	push   %eax
  800716:	68 4c 3b 80 00       	push   $0x803b4c
  80071b:	e8 14 03 00 00       	call   800a34 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800723:	a1 24 50 80 00       	mov    0x805024,%eax
  800728:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	50                   	push   %eax
  800732:	68 a4 3b 80 00       	push   $0x803ba4
  800737:	e8 f8 02 00 00       	call   800a34 <cprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80073f:	83 ec 0c             	sub    $0xc,%esp
  800742:	68 fc 3a 80 00       	push   $0x803afc
  800747:	e8 e8 02 00 00       	call   800a34 <cprintf>
  80074c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80074f:	e8 47 19 00 00       	call   80209b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800754:	e8 19 00 00 00       	call   800772 <exit>
}
  800759:	90                   	nop
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	6a 00                	push   $0x0
  800767:	e8 d4 1a 00 00       	call   802240 <sys_destroy_env>
  80076c:	83 c4 10             	add    $0x10,%esp
}
  80076f:	90                   	nop
  800770:	c9                   	leave  
  800771:	c3                   	ret    

00800772 <exit>:

void
exit(void)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800778:	e8 29 1b 00 00       	call   8022a6 <sys_exit_env>
}
  80077d:	90                   	nop
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800786:	8d 45 10             	lea    0x10(%ebp),%eax
  800789:	83 c0 04             	add    $0x4,%eax
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80078f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	74 16                	je     8007ae <_panic+0x2e>
		cprintf("%s: ", argv0);
  800798:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	50                   	push   %eax
  8007a1:	68 b8 3b 80 00       	push   $0x803bb8
  8007a6:	e8 89 02 00 00       	call   800a34 <cprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ae:	a1 00 50 80 00       	mov    0x805000,%eax
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	68 bd 3b 80 00       	push   $0x803bbd
  8007bf:	e8 70 02 00 00       	call   800a34 <cprintf>
  8007c4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d0:	50                   	push   %eax
  8007d1:	e8 f3 01 00 00       	call   8009c9 <vcprintf>
  8007d6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	6a 00                	push   $0x0
  8007de:	68 d9 3b 80 00       	push   $0x803bd9
  8007e3:	e8 e1 01 00 00       	call   8009c9 <vcprintf>
  8007e8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007eb:	e8 82 ff ff ff       	call   800772 <exit>

	// should not return here
	while (1) ;
  8007f0:	eb fe                	jmp    8007f0 <_panic+0x70>

008007f2 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	8b 50 74             	mov    0x74(%eax),%edx
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	39 c2                	cmp    %eax,%edx
  800805:	74 14                	je     80081b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800807:	83 ec 04             	sub    $0x4,%esp
  80080a:	68 dc 3b 80 00       	push   $0x803bdc
  80080f:	6a 26                	push   $0x26
  800811:	68 28 3c 80 00       	push   $0x803c28
  800816:	e8 65 ff ff ff       	call   800780 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80081b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800822:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800829:	e9 c2 00 00 00       	jmp    8008f0 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80082e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800831:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	01 d0                	add    %edx,%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	85 c0                	test   %eax,%eax
  800841:	75 08                	jne    80084b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800843:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800846:	e9 a2 00 00 00       	jmp    8008ed <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80084b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800859:	eb 69                	jmp    8008c4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80085b:	a1 24 50 80 00       	mov    0x805024,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	84 c0                	test   %al,%al
  800879:	75 46                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800886:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	01 c0                	add    %eax,%eax
  80088d:	01 d0                	add    %edx,%eax
  80088f:	c1 e0 03             	shl    $0x3,%eax
  800892:	01 c8                	add    %ecx,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800899:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80089c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	01 c8                	add    %ecx,%eax
  8008b2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b4:	39 c2                	cmp    %eax,%edx
  8008b6:	75 09                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008b8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008bf:	eb 12                	jmp    8008d3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008c1:	ff 45 e8             	incl   -0x18(%ebp)
  8008c4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008c9:	8b 50 74             	mov    0x74(%eax),%edx
  8008cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	77 88                	ja     80085b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008d7:	75 14                	jne    8008ed <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008d9:	83 ec 04             	sub    $0x4,%esp
  8008dc:	68 34 3c 80 00       	push   $0x803c34
  8008e1:	6a 3a                	push   $0x3a
  8008e3:	68 28 3c 80 00       	push   $0x803c28
  8008e8:	e8 93 fe ff ff       	call   800780 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008ed:	ff 45 f0             	incl   -0x10(%ebp)
  8008f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f6:	0f 8c 32 ff ff ff    	jl     80082e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800903:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80090a:	eb 26                	jmp    800932 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80090c:	a1 24 50 80 00       	mov    0x805024,%eax
  800911:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800917:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091a:	89 d0                	mov    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d0                	add    %edx,%eax
  800920:	c1 e0 03             	shl    $0x3,%eax
  800923:	01 c8                	add    %ecx,%eax
  800925:	8a 40 04             	mov    0x4(%eax),%al
  800928:	3c 01                	cmp    $0x1,%al
  80092a:	75 03                	jne    80092f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80092c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80092f:	ff 45 e0             	incl   -0x20(%ebp)
  800932:	a1 24 50 80 00       	mov    0x805024,%eax
  800937:	8b 50 74             	mov    0x74(%eax),%edx
  80093a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80093d:	39 c2                	cmp    %eax,%edx
  80093f:	77 cb                	ja     80090c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800944:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800947:	74 14                	je     80095d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800949:	83 ec 04             	sub    $0x4,%esp
  80094c:	68 88 3c 80 00       	push   $0x803c88
  800951:	6a 44                	push   $0x44
  800953:	68 28 3c 80 00       	push   $0x803c28
  800958:	e8 23 fe ff ff       	call   800780 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80095d:	90                   	nop
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 d1                	mov    %dl,%cl
  800978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80097f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	3d ff 00 00 00       	cmp    $0xff,%eax
  800989:	75 2c                	jne    8009b7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80098b:	a0 28 50 80 00       	mov    0x805028,%al
  800990:	0f b6 c0             	movzbl %al,%eax
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	8b 12                	mov    (%edx),%edx
  800998:	89 d1                	mov    %edx,%ecx
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099d:	83 c2 08             	add    $0x8,%edx
  8009a0:	83 ec 04             	sub    $0x4,%esp
  8009a3:	50                   	push   %eax
  8009a4:	51                   	push   %ecx
  8009a5:	52                   	push   %edx
  8009a6:	e8 28 15 00 00       	call   801ed3 <sys_cputs>
  8009ab:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	8b 40 04             	mov    0x4(%eax),%eax
  8009bd:	8d 50 01             	lea    0x1(%eax),%edx
  8009c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009c6:	90                   	nop
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009d9:	00 00 00 
	b.cnt = 0;
  8009dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009e3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	ff 75 08             	pushl  0x8(%ebp)
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	68 60 09 80 00       	push   $0x800960
  8009f8:	e8 11 02 00 00       	call   800c0e <vprintfmt>
  8009fd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a00:	a0 28 50 80 00       	mov    0x805028,%al
  800a05:	0f b6 c0             	movzbl %al,%eax
  800a08:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a0e:	83 ec 04             	sub    $0x4,%esp
  800a11:	50                   	push   %eax
  800a12:	52                   	push   %edx
  800a13:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a19:	83 c0 08             	add    $0x8,%eax
  800a1c:	50                   	push   %eax
  800a1d:	e8 b1 14 00 00       	call   801ed3 <sys_cputs>
  800a22:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a25:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a2c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a3a:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a41:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a50:	50                   	push   %eax
  800a51:	e8 73 ff ff ff       	call   8009c9 <vcprintf>
  800a56:	83 c4 10             	add    $0x10,%esp
  800a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a67:	e8 15 16 00 00       	call   802081 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a6c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7b:	50                   	push   %eax
  800a7c:	e8 48 ff ff ff       	call   8009c9 <vcprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a87:	e8 0f 16 00 00       	call   80209b <sys_enable_interrupt>
	return cnt;
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	53                   	push   %ebx
  800a95:	83 ec 14             	sub    $0x14,%esp
  800a98:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800aa4:	8b 45 18             	mov    0x18(%ebp),%eax
  800aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aaf:	77 55                	ja     800b06 <printnum+0x75>
  800ab1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ab4:	72 05                	jb     800abb <printnum+0x2a>
  800ab6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ab9:	77 4b                	ja     800b06 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800abb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800abe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ac1:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac9:	52                   	push   %edx
  800aca:	50                   	push   %eax
  800acb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ace:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad1:	e8 ba 2b 00 00       	call   803690 <__udivdi3>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	ff 75 20             	pushl  0x20(%ebp)
  800adf:	53                   	push   %ebx
  800ae0:	ff 75 18             	pushl  0x18(%ebp)
  800ae3:	52                   	push   %edx
  800ae4:	50                   	push   %eax
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	ff 75 08             	pushl  0x8(%ebp)
  800aeb:	e8 a1 ff ff ff       	call   800a91 <printnum>
  800af0:	83 c4 20             	add    $0x20,%esp
  800af3:	eb 1a                	jmp    800b0f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	ff 75 20             	pushl  0x20(%ebp)
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b06:	ff 4d 1c             	decl   0x1c(%ebp)
  800b09:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b0d:	7f e6                	jg     800af5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b0f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1d:	53                   	push   %ebx
  800b1e:	51                   	push   %ecx
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	e8 7a 2c 00 00       	call   8037a0 <__umoddi3>
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	05 f4 3e 80 00       	add    $0x803ef4,%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f be c0             	movsbl %al,%eax
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	50                   	push   %eax
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
}
  800b42:	90                   	nop
  800b43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b4b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b4f:	7e 1c                	jle    800b6d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 50 08             	lea    0x8(%eax),%edx
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	89 10                	mov    %edx,(%eax)
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	83 e8 08             	sub    $0x8,%eax
  800b66:	8b 50 04             	mov    0x4(%eax),%edx
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	eb 40                	jmp    800bad <getuint+0x65>
	else if (lflag)
  800b6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b71:	74 1e                	je     800b91 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	8d 50 04             	lea    0x4(%eax),%edx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	89 10                	mov    %edx,(%eax)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	83 e8 04             	sub    $0x4,%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	eb 1c                	jmp    800bad <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 04             	lea    0x4(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 04             	sub    $0x4,%eax
  800ba6:	8b 00                	mov    (%eax),%eax
  800ba8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bb6:	7e 1c                	jle    800bd4 <getint+0x25>
		return va_arg(*ap, long long);
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	8d 50 08             	lea    0x8(%eax),%edx
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 10                	mov    %edx,(%eax)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	83 e8 08             	sub    $0x8,%eax
  800bcd:	8b 50 04             	mov    0x4(%eax),%edx
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	eb 38                	jmp    800c0c <getint+0x5d>
	else if (lflag)
  800bd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd8:	74 1a                	je     800bf4 <getint+0x45>
		return va_arg(*ap, long);
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	8d 50 04             	lea    0x4(%eax),%edx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	89 10                	mov    %edx,(%eax)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 00                	mov    (%eax),%eax
  800bec:	83 e8 04             	sub    $0x4,%eax
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	99                   	cltd   
  800bf2:	eb 18                	jmp    800c0c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 04             	lea    0x4(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 04             	sub    $0x4,%eax
  800c09:	8b 00                	mov    (%eax),%eax
  800c0b:	99                   	cltd   
}
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
  800c13:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c16:	eb 17                	jmp    800c2f <vprintfmt+0x21>
			if (ch == '\0')
  800c18:	85 db                	test   %ebx,%ebx
  800c1a:	0f 84 af 03 00 00    	je     800fcf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	53                   	push   %ebx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 10             	mov    %edx,0x10(%ebp)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f b6 d8             	movzbl %al,%ebx
  800c3d:	83 fb 25             	cmp    $0x25,%ebx
  800c40:	75 d6                	jne    800c18 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c42:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c46:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c4d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c5b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	8d 50 01             	lea    0x1(%eax),%edx
  800c68:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	0f b6 d8             	movzbl %al,%ebx
  800c70:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c73:	83 f8 55             	cmp    $0x55,%eax
  800c76:	0f 87 2b 03 00 00    	ja     800fa7 <vprintfmt+0x399>
  800c7c:	8b 04 85 18 3f 80 00 	mov    0x803f18(,%eax,4),%eax
  800c83:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c85:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c89:	eb d7                	jmp    800c62 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c8b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c8f:	eb d1                	jmp    800c62 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c9b:	89 d0                	mov    %edx,%eax
  800c9d:	c1 e0 02             	shl    $0x2,%eax
  800ca0:	01 d0                	add    %edx,%eax
  800ca2:	01 c0                	add    %eax,%eax
  800ca4:	01 d8                	add    %ebx,%eax
  800ca6:	83 e8 30             	sub    $0x30,%eax
  800ca9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cb4:	83 fb 2f             	cmp    $0x2f,%ebx
  800cb7:	7e 3e                	jle    800cf7 <vprintfmt+0xe9>
  800cb9:	83 fb 39             	cmp    $0x39,%ebx
  800cbc:	7f 39                	jg     800cf7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cbe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cc1:	eb d5                	jmp    800c98 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 c0 04             	add    $0x4,%eax
  800cc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	83 e8 04             	sub    $0x4,%eax
  800cd2:	8b 00                	mov    (%eax),%eax
  800cd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cd7:	eb 1f                	jmp    800cf8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cdd:	79 83                	jns    800c62 <vprintfmt+0x54>
				width = 0;
  800cdf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ce6:	e9 77 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ceb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cf2:	e9 6b ff ff ff       	jmp    800c62 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cf7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cf8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cfc:	0f 89 60 ff ff ff    	jns    800c62 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d08:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d0f:	e9 4e ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d14:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d17:	e9 46 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1f:	83 c0 04             	add    $0x4,%eax
  800d22:	89 45 14             	mov    %eax,0x14(%ebp)
  800d25:	8b 45 14             	mov    0x14(%ebp),%eax
  800d28:	83 e8 04             	sub    $0x4,%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	83 ec 08             	sub    $0x8,%esp
  800d30:	ff 75 0c             	pushl  0xc(%ebp)
  800d33:	50                   	push   %eax
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	ff d0                	call   *%eax
  800d39:	83 c4 10             	add    $0x10,%esp
			break;
  800d3c:	e9 89 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 c0 04             	add    $0x4,%eax
  800d47:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4d:	83 e8 04             	sub    $0x4,%eax
  800d50:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d52:	85 db                	test   %ebx,%ebx
  800d54:	79 02                	jns    800d58 <vprintfmt+0x14a>
				err = -err;
  800d56:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d58:	83 fb 64             	cmp    $0x64,%ebx
  800d5b:	7f 0b                	jg     800d68 <vprintfmt+0x15a>
  800d5d:	8b 34 9d 60 3d 80 00 	mov    0x803d60(,%ebx,4),%esi
  800d64:	85 f6                	test   %esi,%esi
  800d66:	75 19                	jne    800d81 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d68:	53                   	push   %ebx
  800d69:	68 05 3f 80 00       	push   $0x803f05
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	ff 75 08             	pushl  0x8(%ebp)
  800d74:	e8 5e 02 00 00       	call   800fd7 <printfmt>
  800d79:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d7c:	e9 49 02 00 00       	jmp    800fca <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d81:	56                   	push   %esi
  800d82:	68 0e 3f 80 00       	push   $0x803f0e
  800d87:	ff 75 0c             	pushl  0xc(%ebp)
  800d8a:	ff 75 08             	pushl  0x8(%ebp)
  800d8d:	e8 45 02 00 00       	call   800fd7 <printfmt>
  800d92:	83 c4 10             	add    $0x10,%esp
			break;
  800d95:	e9 30 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	83 c0 04             	add    $0x4,%eax
  800da0:	89 45 14             	mov    %eax,0x14(%ebp)
  800da3:	8b 45 14             	mov    0x14(%ebp),%eax
  800da6:	83 e8 04             	sub    $0x4,%eax
  800da9:	8b 30                	mov    (%eax),%esi
  800dab:	85 f6                	test   %esi,%esi
  800dad:	75 05                	jne    800db4 <vprintfmt+0x1a6>
				p = "(null)";
  800daf:	be 11 3f 80 00       	mov    $0x803f11,%esi
			if (width > 0 && padc != '-')
  800db4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db8:	7e 6d                	jle    800e27 <vprintfmt+0x219>
  800dba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dbe:	74 67                	je     800e27 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dc3:	83 ec 08             	sub    $0x8,%esp
  800dc6:	50                   	push   %eax
  800dc7:	56                   	push   %esi
  800dc8:	e8 12 05 00 00       	call   8012df <strnlen>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dd3:	eb 16                	jmp    800deb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dd5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dd9:	83 ec 08             	sub    $0x8,%esp
  800ddc:	ff 75 0c             	pushl  0xc(%ebp)
  800ddf:	50                   	push   %eax
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	ff d0                	call   *%eax
  800de5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800de8:	ff 4d e4             	decl   -0x1c(%ebp)
  800deb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800def:	7f e4                	jg     800dd5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df1:	eb 34                	jmp    800e27 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800df3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800df7:	74 1c                	je     800e15 <vprintfmt+0x207>
  800df9:	83 fb 1f             	cmp    $0x1f,%ebx
  800dfc:	7e 05                	jle    800e03 <vprintfmt+0x1f5>
  800dfe:	83 fb 7e             	cmp    $0x7e,%ebx
  800e01:	7e 12                	jle    800e15 <vprintfmt+0x207>
					putch('?', putdat);
  800e03:	83 ec 08             	sub    $0x8,%esp
  800e06:	ff 75 0c             	pushl  0xc(%ebp)
  800e09:	6a 3f                	push   $0x3f
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	ff d0                	call   *%eax
  800e10:	83 c4 10             	add    $0x10,%esp
  800e13:	eb 0f                	jmp    800e24 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	53                   	push   %ebx
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	89 f0                	mov    %esi,%eax
  800e29:	8d 70 01             	lea    0x1(%eax),%esi
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f be d8             	movsbl %al,%ebx
  800e31:	85 db                	test   %ebx,%ebx
  800e33:	74 24                	je     800e59 <vprintfmt+0x24b>
  800e35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e39:	78 b8                	js     800df3 <vprintfmt+0x1e5>
  800e3b:	ff 4d e0             	decl   -0x20(%ebp)
  800e3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e42:	79 af                	jns    800df3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e44:	eb 13                	jmp    800e59 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e46:	83 ec 08             	sub    $0x8,%esp
  800e49:	ff 75 0c             	pushl  0xc(%ebp)
  800e4c:	6a 20                	push   $0x20
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	ff d0                	call   *%eax
  800e53:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e56:	ff 4d e4             	decl   -0x1c(%ebp)
  800e59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5d:	7f e7                	jg     800e46 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e5f:	e9 66 01 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e64:	83 ec 08             	sub    $0x8,%esp
  800e67:	ff 75 e8             	pushl  -0x18(%ebp)
  800e6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e6d:	50                   	push   %eax
  800e6e:	e8 3c fd ff ff       	call   800baf <getint>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e82:	85 d2                	test   %edx,%edx
  800e84:	79 23                	jns    800ea9 <vprintfmt+0x29b>
				putch('-', putdat);
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 0c             	pushl  0xc(%ebp)
  800e8c:	6a 2d                	push   $0x2d
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	ff d0                	call   *%eax
  800e93:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9c:	f7 d8                	neg    %eax
  800e9e:	83 d2 00             	adc    $0x0,%edx
  800ea1:	f7 da                	neg    %edx
  800ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ea9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eb0:	e9 bc 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	ff 75 e8             	pushl  -0x18(%ebp)
  800ebb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebe:	50                   	push   %eax
  800ebf:	e8 84 fc ff ff       	call   800b48 <getuint>
  800ec4:	83 c4 10             	add    $0x10,%esp
  800ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ecd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ed4:	e9 98 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	6a 58                	push   $0x58
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	ff d0                	call   *%eax
  800ee6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ee9:	83 ec 08             	sub    $0x8,%esp
  800eec:	ff 75 0c             	pushl  0xc(%ebp)
  800eef:	6a 58                	push   $0x58
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	ff d0                	call   *%eax
  800ef6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ef9:	83 ec 08             	sub    $0x8,%esp
  800efc:	ff 75 0c             	pushl  0xc(%ebp)
  800eff:	6a 58                	push   $0x58
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	ff d0                	call   *%eax
  800f06:	83 c4 10             	add    $0x10,%esp
			break;
  800f09:	e9 bc 00 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 0c             	pushl  0xc(%ebp)
  800f14:	6a 30                	push   $0x30
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	ff d0                	call   *%eax
  800f1b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 0c             	pushl  0xc(%ebp)
  800f24:	6a 78                	push   $0x78
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	ff d0                	call   *%eax
  800f2b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	83 c0 04             	add    $0x4,%eax
  800f34:	89 45 14             	mov    %eax,0x14(%ebp)
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	83 e8 04             	sub    $0x4,%eax
  800f3d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f49:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f50:	eb 1f                	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	ff 75 e8             	pushl  -0x18(%ebp)
  800f58:	8d 45 14             	lea    0x14(%ebp),%eax
  800f5b:	50                   	push   %eax
  800f5c:	e8 e7 fb ff ff       	call   800b48 <getuint>
  800f61:	83 c4 10             	add    $0x10,%esp
  800f64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f71:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f78:	83 ec 04             	sub    $0x4,%esp
  800f7b:	52                   	push   %edx
  800f7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f7f:	50                   	push   %eax
  800f80:	ff 75 f4             	pushl  -0xc(%ebp)
  800f83:	ff 75 f0             	pushl  -0x10(%ebp)
  800f86:	ff 75 0c             	pushl  0xc(%ebp)
  800f89:	ff 75 08             	pushl  0x8(%ebp)
  800f8c:	e8 00 fb ff ff       	call   800a91 <printnum>
  800f91:	83 c4 20             	add    $0x20,%esp
			break;
  800f94:	eb 34                	jmp    800fca <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			break;
  800fa5:	eb 23                	jmp    800fca <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	6a 25                	push   $0x25
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	ff d0                	call   *%eax
  800fb4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fb7:	ff 4d 10             	decl   0x10(%ebp)
  800fba:	eb 03                	jmp    800fbf <vprintfmt+0x3b1>
  800fbc:	ff 4d 10             	decl   0x10(%ebp)
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	48                   	dec    %eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 25                	cmp    $0x25,%al
  800fc7:	75 f3                	jne    800fbc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fc9:	90                   	nop
		}
	}
  800fca:	e9 47 fc ff ff       	jmp    800c16 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fcf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fd3:	5b                   	pop    %ebx
  800fd4:	5e                   	pop    %esi
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    

00800fd7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fdd:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe0:	83 c0 04             	add    $0x4,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fec:	50                   	push   %eax
  800fed:	ff 75 0c             	pushl  0xc(%ebp)
  800ff0:	ff 75 08             	pushl  0x8(%ebp)
  800ff3:	e8 16 fc ff ff       	call   800c0e <vprintfmt>
  800ff8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	8b 40 08             	mov    0x8(%eax),%eax
  801007:	8d 50 01             	lea    0x1(%eax),%edx
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	8b 10                	mov    (%eax),%edx
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	8b 40 04             	mov    0x4(%eax),%eax
  80101b:	39 c2                	cmp    %eax,%edx
  80101d:	73 12                	jae    801031 <sprintputch+0x33>
		*b->buf++ = ch;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	8b 00                	mov    (%eax),%eax
  801024:	8d 48 01             	lea    0x1(%eax),%ecx
  801027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102a:	89 0a                	mov    %ecx,(%edx)
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	88 10                	mov    %dl,(%eax)
}
  801031:	90                   	nop
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	8d 50 ff             	lea    -0x1(%eax),%edx
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801055:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801059:	74 06                	je     801061 <vsnprintf+0x2d>
  80105b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80105f:	7f 07                	jg     801068 <vsnprintf+0x34>
		return -E_INVAL;
  801061:	b8 03 00 00 00       	mov    $0x3,%eax
  801066:	eb 20                	jmp    801088 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801068:	ff 75 14             	pushl  0x14(%ebp)
  80106b:	ff 75 10             	pushl  0x10(%ebp)
  80106e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801071:	50                   	push   %eax
  801072:	68 fe 0f 80 00       	push   $0x800ffe
  801077:	e8 92 fb ff ff       	call   800c0e <vprintfmt>
  80107c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80107f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801082:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801085:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801090:	8d 45 10             	lea    0x10(%ebp),%eax
  801093:	83 c0 04             	add    $0x4,%eax
  801096:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	ff 75 f4             	pushl  -0xc(%ebp)
  80109f:	50                   	push   %eax
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	e8 89 ff ff ff       	call   801034 <vsnprintf>
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c0:	74 13                	je     8010d5 <readline+0x1f>
		cprintf("%s", prompt);
  8010c2:	83 ec 08             	sub    $0x8,%esp
  8010c5:	ff 75 08             	pushl  0x8(%ebp)
  8010c8:	68 70 40 80 00       	push   $0x804070
  8010cd:	e8 62 f9 ff ff       	call   800a34 <cprintf>
  8010d2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010dc:	83 ec 0c             	sub    $0xc,%esp
  8010df:	6a 00                	push   $0x0
  8010e1:	e8 54 f5 ff ff       	call   80063a <iscons>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010ec:	e8 fb f4 ff ff       	call   8005ec <getchar>
  8010f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010f8:	79 22                	jns    80111c <readline+0x66>
			if (c != -E_EOF)
  8010fa:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010fe:	0f 84 ad 00 00 00    	je     8011b1 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	ff 75 ec             	pushl  -0x14(%ebp)
  80110a:	68 73 40 80 00       	push   $0x804073
  80110f:	e8 20 f9 ff ff       	call   800a34 <cprintf>
  801114:	83 c4 10             	add    $0x10,%esp
			return;
  801117:	e9 95 00 00 00       	jmp    8011b1 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80111c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801120:	7e 34                	jle    801156 <readline+0xa0>
  801122:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801129:	7f 2b                	jg     801156 <readline+0xa0>
			if (echoing)
  80112b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80112f:	74 0e                	je     80113f <readline+0x89>
				cputchar(c);
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	ff 75 ec             	pushl  -0x14(%ebp)
  801137:	e8 68 f4 ff ff       	call   8005a4 <cputchar>
  80113c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80113f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801142:	8d 50 01             	lea    0x1(%eax),%edx
  801145:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801148:	89 c2                	mov    %eax,%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801152:	88 10                	mov    %dl,(%eax)
  801154:	eb 56                	jmp    8011ac <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801156:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80115a:	75 1f                	jne    80117b <readline+0xc5>
  80115c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801160:	7e 19                	jle    80117b <readline+0xc5>
			if (echoing)
  801162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801166:	74 0e                	je     801176 <readline+0xc0>
				cputchar(c);
  801168:	83 ec 0c             	sub    $0xc,%esp
  80116b:	ff 75 ec             	pushl  -0x14(%ebp)
  80116e:	e8 31 f4 ff ff       	call   8005a4 <cputchar>
  801173:	83 c4 10             	add    $0x10,%esp

			i--;
  801176:	ff 4d f4             	decl   -0xc(%ebp)
  801179:	eb 31                	jmp    8011ac <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80117b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80117f:	74 0a                	je     80118b <readline+0xd5>
  801181:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801185:	0f 85 61 ff ff ff    	jne    8010ec <readline+0x36>
			if (echoing)
  80118b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80118f:	74 0e                	je     80119f <readline+0xe9>
				cputchar(c);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	ff 75 ec             	pushl  -0x14(%ebp)
  801197:	e8 08 f4 ff ff       	call   8005a4 <cputchar>
  80119c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011aa:	eb 06                	jmp    8011b2 <readline+0xfc>
		}
	}
  8011ac:	e9 3b ff ff ff       	jmp    8010ec <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011b1:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011ba:	e8 c2 0e 00 00       	call   802081 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	74 13                	je     8011d8 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	68 70 40 80 00       	push   $0x804070
  8011d0:	e8 5f f8 ff ff       	call   800a34 <cprintf>
  8011d5:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	6a 00                	push   $0x0
  8011e4:	e8 51 f4 ff ff       	call   80063a <iscons>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011ef:	e8 f8 f3 ff ff       	call   8005ec <getchar>
  8011f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011fb:	79 23                	jns    801220 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011fd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801201:	74 13                	je     801216 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	ff 75 ec             	pushl  -0x14(%ebp)
  801209:	68 73 40 80 00       	push   $0x804073
  80120e:	e8 21 f8 ff ff       	call   800a34 <cprintf>
  801213:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801216:	e8 80 0e 00 00       	call   80209b <sys_enable_interrupt>
			return;
  80121b:	e9 9a 00 00 00       	jmp    8012ba <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801220:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801224:	7e 34                	jle    80125a <atomic_readline+0xa6>
  801226:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80122d:	7f 2b                	jg     80125a <atomic_readline+0xa6>
			if (echoing)
  80122f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801233:	74 0e                	je     801243 <atomic_readline+0x8f>
				cputchar(c);
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	ff 75 ec             	pushl  -0x14(%ebp)
  80123b:	e8 64 f3 ff ff       	call   8005a4 <cputchar>
  801240:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801246:	8d 50 01             	lea    0x1(%eax),%edx
  801249:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80124c:	89 c2                	mov    %eax,%edx
  80124e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801251:	01 d0                	add    %edx,%eax
  801253:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801256:	88 10                	mov    %dl,(%eax)
  801258:	eb 5b                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80125a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80125e:	75 1f                	jne    80127f <atomic_readline+0xcb>
  801260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801264:	7e 19                	jle    80127f <atomic_readline+0xcb>
			if (echoing)
  801266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126a:	74 0e                	je     80127a <atomic_readline+0xc6>
				cputchar(c);
  80126c:	83 ec 0c             	sub    $0xc,%esp
  80126f:	ff 75 ec             	pushl  -0x14(%ebp)
  801272:	e8 2d f3 ff ff       	call   8005a4 <cputchar>
  801277:	83 c4 10             	add    $0x10,%esp
			i--;
  80127a:	ff 4d f4             	decl   -0xc(%ebp)
  80127d:	eb 36                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80127f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801283:	74 0a                	je     80128f <atomic_readline+0xdb>
  801285:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801289:	0f 85 60 ff ff ff    	jne    8011ef <atomic_readline+0x3b>
			if (echoing)
  80128f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801293:	74 0e                	je     8012a3 <atomic_readline+0xef>
				cputchar(c);
  801295:	83 ec 0c             	sub    $0xc,%esp
  801298:	ff 75 ec             	pushl  -0x14(%ebp)
  80129b:	e8 04 f3 ff ff       	call   8005a4 <cputchar>
  8012a0:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	01 d0                	add    %edx,%eax
  8012ab:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012ae:	e8 e8 0d 00 00       	call   80209b <sys_enable_interrupt>
			return;
  8012b3:	eb 05                	jmp    8012ba <atomic_readline+0x106>
		}
	}
  8012b5:	e9 35 ff ff ff       	jmp    8011ef <atomic_readline+0x3b>
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c9:	eb 06                	jmp    8012d1 <strlen+0x15>
		n++;
  8012cb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ce:	ff 45 08             	incl   0x8(%ebp)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 f1                	jne    8012cb <strlen+0xf>
		n++;
	return n;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ec:	eb 09                	jmp    8012f7 <strnlen+0x18>
		n++;
  8012ee:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f1:	ff 45 08             	incl   0x8(%ebp)
  8012f4:	ff 4d 0c             	decl   0xc(%ebp)
  8012f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012fb:	74 09                	je     801306 <strnlen+0x27>
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	84 c0                	test   %al,%al
  801304:	75 e8                	jne    8012ee <strnlen+0xf>
		n++;
	return n;
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801317:	90                   	nop
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8d 50 01             	lea    0x1(%eax),%edx
  80131e:	89 55 08             	mov    %edx,0x8(%ebp)
  801321:	8b 55 0c             	mov    0xc(%ebp),%edx
  801324:	8d 4a 01             	lea    0x1(%edx),%ecx
  801327:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80132a:	8a 12                	mov    (%edx),%dl
  80132c:	88 10                	mov    %dl,(%eax)
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	75 e4                	jne    801318 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801334:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80134c:	eb 1f                	jmp    80136d <strncpy+0x34>
		*dst++ = *src;
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 08             	mov    %edx,0x8(%ebp)
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8a 12                	mov    (%edx),%dl
  80135c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 03                	je     80136a <strncpy+0x31>
			src++;
  801367:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80136a:	ff 45 fc             	incl   -0x4(%ebp)
  80136d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801370:	3b 45 10             	cmp    0x10(%ebp),%eax
  801373:	72 d9                	jb     80134e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138a:	74 30                	je     8013bc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80138c:	eb 16                	jmp    8013a4 <strlcpy+0x2a>
			*dst++ = *src++;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8d 50 01             	lea    0x1(%eax),%edx
  801394:	89 55 08             	mov    %edx,0x8(%ebp)
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80139d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013a0:	8a 12                	mov    (%edx),%dl
  8013a2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013a4:	ff 4d 10             	decl   0x10(%ebp)
  8013a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ab:	74 09                	je     8013b6 <strlcpy+0x3c>
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	75 d8                	jne    80138e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c2:	29 c2                	sub    %eax,%edx
  8013c4:	89 d0                	mov    %edx,%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013cb:	eb 06                	jmp    8013d3 <strcmp+0xb>
		p++, q++;
  8013cd:	ff 45 08             	incl   0x8(%ebp)
  8013d0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	84 c0                	test   %al,%al
  8013da:	74 0e                	je     8013ea <strcmp+0x22>
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 e3                	je     8013cd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
}
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801403:	eb 09                	jmp    80140e <strncmp+0xe>
		n--, p++, q++;
  801405:	ff 4d 10             	decl   0x10(%ebp)
  801408:	ff 45 08             	incl   0x8(%ebp)
  80140b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80140e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801412:	74 17                	je     80142b <strncmp+0x2b>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	74 0e                	je     80142b <strncmp+0x2b>
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 10                	mov    (%eax),%dl
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	38 c2                	cmp    %al,%dl
  801429:	74 da                	je     801405 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80142b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142f:	75 07                	jne    801438 <strncmp+0x38>
		return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	eb 14                	jmp    80144c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	0f b6 d0             	movzbl %al,%edx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	0f b6 c0             	movzbl %al,%eax
  801448:	29 c2                	sub    %eax,%edx
  80144a:	89 d0                	mov    %edx,%eax
}
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80145a:	eb 12                	jmp    80146e <strchr+0x20>
		if (*s == c)
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801464:	75 05                	jne    80146b <strchr+0x1d>
			return (char *) s;
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	eb 11                	jmp    80147c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80146b:	ff 45 08             	incl   0x8(%ebp)
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	84 c0                	test   %al,%al
  801475:	75 e5                	jne    80145c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	8b 45 0c             	mov    0xc(%ebp),%eax
  801487:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80148a:	eb 0d                	jmp    801499 <strfind+0x1b>
		if (*s == c)
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801494:	74 0e                	je     8014a4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801496:	ff 45 08             	incl   0x8(%ebp)
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	84 c0                	test   %al,%al
  8014a0:	75 ea                	jne    80148c <strfind+0xe>
  8014a2:	eb 01                	jmp    8014a5 <strfind+0x27>
		if (*s == c)
			break;
  8014a4:	90                   	nop
	return (char *) s;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014bc:	eb 0e                	jmp    8014cc <memset+0x22>
		*p++ = c;
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8d 50 01             	lea    0x1(%eax),%edx
  8014c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ca:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014cc:	ff 4d f8             	decl   -0x8(%ebp)
  8014cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014d3:	79 e9                	jns    8014be <memset+0x14>
		*p++ = c;

	return v;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014ec:	eb 16                	jmp    801504 <memcpy+0x2a>
		*d++ = *s++;
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	8d 50 01             	lea    0x1(%eax),%edx
  8014f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014fd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801500:	8a 12                	mov    (%edx),%dl
  801502:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801504:	8b 45 10             	mov    0x10(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	89 55 10             	mov    %edx,0x10(%ebp)
  80150d:	85 c0                	test   %eax,%eax
  80150f:	75 dd                	jne    8014ee <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80152e:	73 50                	jae    801580 <memmove+0x6a>
  801530:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153b:	76 43                	jbe    801580 <memmove+0x6a>
		s += n;
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801543:	8b 45 10             	mov    0x10(%ebp),%eax
  801546:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801549:	eb 10                	jmp    80155b <memmove+0x45>
			*--d = *--s;
  80154b:	ff 4d f8             	decl   -0x8(%ebp)
  80154e:	ff 4d fc             	decl   -0x4(%ebp)
  801551:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801554:	8a 10                	mov    (%eax),%dl
  801556:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801559:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80155b:	8b 45 10             	mov    0x10(%ebp),%eax
  80155e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801561:	89 55 10             	mov    %edx,0x10(%ebp)
  801564:	85 c0                	test   %eax,%eax
  801566:	75 e3                	jne    80154b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801568:	eb 23                	jmp    80158d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80156a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156d:	8d 50 01             	lea    0x1(%eax),%edx
  801570:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801573:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801576:	8d 4a 01             	lea    0x1(%edx),%ecx
  801579:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801580:	8b 45 10             	mov    0x10(%ebp),%eax
  801583:	8d 50 ff             	lea    -0x1(%eax),%edx
  801586:	89 55 10             	mov    %edx,0x10(%ebp)
  801589:	85 c0                	test   %eax,%eax
  80158b:	75 dd                	jne    80156a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015a4:	eb 2a                	jmp    8015d0 <memcmp+0x3e>
		if (*s1 != *s2)
  8015a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a9:	8a 10                	mov    (%eax),%dl
  8015ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	38 c2                	cmp    %al,%dl
  8015b2:	74 16                	je     8015ca <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	0f b6 d0             	movzbl %al,%edx
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	0f b6 c0             	movzbl %al,%eax
  8015c4:	29 c2                	sub    %eax,%edx
  8015c6:	89 d0                	mov    %edx,%eax
  8015c8:	eb 18                	jmp    8015e2 <memcmp+0x50>
		s1++, s2++;
  8015ca:	ff 45 fc             	incl   -0x4(%ebp)
  8015cd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	75 c9                	jne    8015a6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f0:	01 d0                	add    %edx,%eax
  8015f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015f5:	eb 15                	jmp    80160c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	0f b6 d0             	movzbl %al,%edx
  8015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801602:	0f b6 c0             	movzbl %al,%eax
  801605:	39 c2                	cmp    %eax,%edx
  801607:	74 0d                	je     801616 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801609:	ff 45 08             	incl   0x8(%ebp)
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801612:	72 e3                	jb     8015f7 <memfind+0x13>
  801614:	eb 01                	jmp    801617 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801616:	90                   	nop
	return (void *) s;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801622:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801629:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801630:	eb 03                	jmp    801635 <strtol+0x19>
		s++;
  801632:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	3c 20                	cmp    $0x20,%al
  80163c:	74 f4                	je     801632 <strtol+0x16>
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	3c 09                	cmp    $0x9,%al
  801645:	74 eb                	je     801632 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	3c 2b                	cmp    $0x2b,%al
  80164e:	75 05                	jne    801655 <strtol+0x39>
		s++;
  801650:	ff 45 08             	incl   0x8(%ebp)
  801653:	eb 13                	jmp    801668 <strtol+0x4c>
	else if (*s == '-')
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	3c 2d                	cmp    $0x2d,%al
  80165c:	75 0a                	jne    801668 <strtol+0x4c>
		s++, neg = 1;
  80165e:	ff 45 08             	incl   0x8(%ebp)
  801661:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801668:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166c:	74 06                	je     801674 <strtol+0x58>
  80166e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801672:	75 20                	jne    801694 <strtol+0x78>
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	3c 30                	cmp    $0x30,%al
  80167b:	75 17                	jne    801694 <strtol+0x78>
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	40                   	inc    %eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3c 78                	cmp    $0x78,%al
  801685:	75 0d                	jne    801694 <strtol+0x78>
		s += 2, base = 16;
  801687:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80168b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801692:	eb 28                	jmp    8016bc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801694:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801698:	75 15                	jne    8016af <strtol+0x93>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	3c 30                	cmp    $0x30,%al
  8016a1:	75 0c                	jne    8016af <strtol+0x93>
		s++, base = 8;
  8016a3:	ff 45 08             	incl   0x8(%ebp)
  8016a6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016ad:	eb 0d                	jmp    8016bc <strtol+0xa0>
	else if (base == 0)
  8016af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b3:	75 07                	jne    8016bc <strtol+0xa0>
		base = 10;
  8016b5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8a 00                	mov    (%eax),%al
  8016c1:	3c 2f                	cmp    $0x2f,%al
  8016c3:	7e 19                	jle    8016de <strtol+0xc2>
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8a 00                	mov    (%eax),%al
  8016ca:	3c 39                	cmp    $0x39,%al
  8016cc:	7f 10                	jg     8016de <strtol+0xc2>
			dig = *s - '0';
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8a 00                	mov    (%eax),%al
  8016d3:	0f be c0             	movsbl %al,%eax
  8016d6:	83 e8 30             	sub    $0x30,%eax
  8016d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016dc:	eb 42                	jmp    801720 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	3c 60                	cmp    $0x60,%al
  8016e5:	7e 19                	jle    801700 <strtol+0xe4>
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	3c 7a                	cmp    $0x7a,%al
  8016ee:	7f 10                	jg     801700 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8a 00                	mov    (%eax),%al
  8016f5:	0f be c0             	movsbl %al,%eax
  8016f8:	83 e8 57             	sub    $0x57,%eax
  8016fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fe:	eb 20                	jmp    801720 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	3c 40                	cmp    $0x40,%al
  801707:	7e 39                	jle    801742 <strtol+0x126>
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	3c 5a                	cmp    $0x5a,%al
  801710:	7f 30                	jg     801742 <strtol+0x126>
			dig = *s - 'A' + 10;
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	8a 00                	mov    (%eax),%al
  801717:	0f be c0             	movsbl %al,%eax
  80171a:	83 e8 37             	sub    $0x37,%eax
  80171d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801723:	3b 45 10             	cmp    0x10(%ebp),%eax
  801726:	7d 19                	jge    801741 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801728:	ff 45 08             	incl   0x8(%ebp)
  80172b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801732:	89 c2                	mov    %eax,%edx
  801734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80173c:	e9 7b ff ff ff       	jmp    8016bc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801741:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801742:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801746:	74 08                	je     801750 <strtol+0x134>
		*endptr = (char *) s;
  801748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174b:	8b 55 08             	mov    0x8(%ebp),%edx
  80174e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801750:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801754:	74 07                	je     80175d <strtol+0x141>
  801756:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801759:	f7 d8                	neg    %eax
  80175b:	eb 03                	jmp    801760 <strtol+0x144>
  80175d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <ltostr>:

void
ltostr(long value, char *str)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80176f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801776:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80177a:	79 13                	jns    80178f <ltostr+0x2d>
	{
		neg = 1;
  80177c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801789:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80178c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801797:	99                   	cltd   
  801798:	f7 f9                	idiv   %ecx
  80179a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80179d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a0:	8d 50 01             	lea    0x1(%eax),%edx
  8017a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017a6:	89 c2                	mov    %eax,%edx
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	01 d0                	add    %edx,%eax
  8017ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017b0:	83 c2 30             	add    $0x30,%edx
  8017b3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017bd:	f7 e9                	imul   %ecx
  8017bf:	c1 fa 02             	sar    $0x2,%edx
  8017c2:	89 c8                	mov    %ecx,%eax
  8017c4:	c1 f8 1f             	sar    $0x1f,%eax
  8017c7:	29 c2                	sub    %eax,%edx
  8017c9:	89 d0                	mov    %edx,%eax
  8017cb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017d6:	f7 e9                	imul   %ecx
  8017d8:	c1 fa 02             	sar    $0x2,%edx
  8017db:	89 c8                	mov    %ecx,%eax
  8017dd:	c1 f8 1f             	sar    $0x1f,%eax
  8017e0:	29 c2                	sub    %eax,%edx
  8017e2:	89 d0                	mov    %edx,%eax
  8017e4:	c1 e0 02             	shl    $0x2,%eax
  8017e7:	01 d0                	add    %edx,%eax
  8017e9:	01 c0                	add    %eax,%eax
  8017eb:	29 c1                	sub    %eax,%ecx
  8017ed:	89 ca                	mov    %ecx,%edx
  8017ef:	85 d2                	test   %edx,%edx
  8017f1:	75 9c                	jne    80178f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fd:	48                   	dec    %eax
  8017fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801801:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801805:	74 3d                	je     801844 <ltostr+0xe2>
		start = 1 ;
  801807:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80180e:	eb 34                	jmp    801844 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801810:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801813:	8b 45 0c             	mov    0xc(%ebp),%eax
  801816:	01 d0                	add    %edx,%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80181d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801820:	8b 45 0c             	mov    0xc(%ebp),%eax
  801823:	01 c2                	add    %eax,%edx
  801825:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	01 c8                	add    %ecx,%eax
  80182d:	8a 00                	mov    (%eax),%al
  80182f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801831:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801834:	8b 45 0c             	mov    0xc(%ebp),%eax
  801837:	01 c2                	add    %eax,%edx
  801839:	8a 45 eb             	mov    -0x15(%ebp),%al
  80183c:	88 02                	mov    %al,(%edx)
		start++ ;
  80183e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801841:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801847:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184a:	7c c4                	jl     801810 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80184c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80184f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801852:	01 d0                	add    %edx,%eax
  801854:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801857:	90                   	nop
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	e8 54 fa ff ff       	call   8012bc <strlen>
  801868:	83 c4 04             	add    $0x4,%esp
  80186b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	e8 46 fa ff ff       	call   8012bc <strlen>
  801876:	83 c4 04             	add    $0x4,%esp
  801879:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80187c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801883:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80188a:	eb 17                	jmp    8018a3 <strcconcat+0x49>
		final[s] = str1[s] ;
  80188c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	01 c2                	add    %eax,%edx
  801894:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	01 c8                	add    %ecx,%eax
  80189c:	8a 00                	mov    (%eax),%al
  80189e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018a0:	ff 45 fc             	incl   -0x4(%ebp)
  8018a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018a9:	7c e1                	jl     80188c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018b9:	eb 1f                	jmp    8018da <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018c4:	89 c2                	mov    %eax,%edx
  8018c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c9:	01 c2                	add    %eax,%edx
  8018cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d1:	01 c8                	add    %ecx,%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018d7:	ff 45 f8             	incl   -0x8(%ebp)
  8018da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018e0:	7c d9                	jl     8018bb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 d0                	add    %edx,%eax
  8018ea:	c6 00 00             	movb   $0x0,(%eax)
}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801908:	8b 45 10             	mov    0x10(%ebp),%eax
  80190b:	01 d0                	add    %edx,%eax
  80190d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801913:	eb 0c                	jmp    801921 <strsplit+0x31>
			*string++ = 0;
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8d 50 01             	lea    0x1(%eax),%edx
  80191b:	89 55 08             	mov    %edx,0x8(%ebp)
  80191e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8a 00                	mov    (%eax),%al
  801926:	84 c0                	test   %al,%al
  801928:	74 18                	je     801942 <strsplit+0x52>
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	8a 00                	mov    (%eax),%al
  80192f:	0f be c0             	movsbl %al,%eax
  801932:	50                   	push   %eax
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	e8 13 fb ff ff       	call   80144e <strchr>
  80193b:	83 c4 08             	add    $0x8,%esp
  80193e:	85 c0                	test   %eax,%eax
  801940:	75 d3                	jne    801915 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	8a 00                	mov    (%eax),%al
  801947:	84 c0                	test   %al,%al
  801949:	74 5a                	je     8019a5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80194b:	8b 45 14             	mov    0x14(%ebp),%eax
  80194e:	8b 00                	mov    (%eax),%eax
  801950:	83 f8 0f             	cmp    $0xf,%eax
  801953:	75 07                	jne    80195c <strsplit+0x6c>
		{
			return 0;
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
  80195a:	eb 66                	jmp    8019c2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	8d 48 01             	lea    0x1(%eax),%ecx
  801964:	8b 55 14             	mov    0x14(%ebp),%edx
  801967:	89 0a                	mov    %ecx,(%edx)
  801969:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801970:	8b 45 10             	mov    0x10(%ebp),%eax
  801973:	01 c2                	add    %eax,%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197a:	eb 03                	jmp    80197f <strsplit+0x8f>
			string++;
  80197c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	84 c0                	test   %al,%al
  801986:	74 8b                	je     801913 <strsplit+0x23>
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	8a 00                	mov    (%eax),%al
  80198d:	0f be c0             	movsbl %al,%eax
  801990:	50                   	push   %eax
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	e8 b5 fa ff ff       	call   80144e <strchr>
  801999:	83 c4 08             	add    $0x8,%esp
  80199c:	85 c0                	test   %eax,%eax
  80199e:	74 dc                	je     80197c <strsplit+0x8c>
			string++;
	}
  8019a0:	e9 6e ff ff ff       	jmp    801913 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019a5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a9:	8b 00                	mov    (%eax),%eax
  8019ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b5:	01 d0                	add    %edx,%eax
  8019b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019ca:	a1 04 50 80 00       	mov    0x805004,%eax
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	74 1f                	je     8019f2 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019d3:	e8 1d 00 00 00       	call   8019f5 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019d8:	83 ec 0c             	sub    $0xc,%esp
  8019db:	68 84 40 80 00       	push   $0x804084
  8019e0:	e8 4f f0 ff ff       	call   800a34 <cprintf>
  8019e5:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019e8:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8019ef:	00 00 00 
	}
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8019fb:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a02:	00 00 00 
  801a05:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a0c:	00 00 00 
  801a0f:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a16:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801a19:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a20:	00 00 00 
  801a23:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a2a:	00 00 00 
  801a2d:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a34:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801a37:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801a3e:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801a41:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a50:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a55:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801a5a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a61:	a1 20 51 80 00       	mov    0x805120,%eax
  801a66:	c1 e0 04             	shl    $0x4,%eax
  801a69:	89 c2                	mov    %eax,%edx
  801a6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6e:	01 d0                	add    %edx,%eax
  801a70:	48                   	dec    %eax
  801a71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a77:	ba 00 00 00 00       	mov    $0x0,%edx
  801a7c:	f7 75 f0             	divl   -0x10(%ebp)
  801a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a82:	29 d0                	sub    %edx,%eax
  801a84:	89 c2                	mov    %eax,%edx
  801a86:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801a8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a95:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a9a:	83 ec 04             	sub    $0x4,%esp
  801a9d:	6a 06                	push   $0x6
  801a9f:	52                   	push   %edx
  801aa0:	50                   	push   %eax
  801aa1:	e8 71 05 00 00       	call   802017 <sys_allocate_chunk>
  801aa6:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801aa9:	a1 20 51 80 00       	mov    0x805120,%eax
  801aae:	83 ec 0c             	sub    $0xc,%esp
  801ab1:	50                   	push   %eax
  801ab2:	e8 e6 0b 00 00       	call   80269d <initialize_MemBlocksList>
  801ab7:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801aba:	a1 48 51 80 00       	mov    0x805148,%eax
  801abf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801ac2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ac6:	75 14                	jne    801adc <initialize_dyn_block_system+0xe7>
  801ac8:	83 ec 04             	sub    $0x4,%esp
  801acb:	68 a9 40 80 00       	push   $0x8040a9
  801ad0:	6a 2b                	push   $0x2b
  801ad2:	68 c7 40 80 00       	push   $0x8040c7
  801ad7:	e8 a4 ec ff ff       	call   800780 <_panic>
  801adc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801adf:	8b 00                	mov    (%eax),%eax
  801ae1:	85 c0                	test   %eax,%eax
  801ae3:	74 10                	je     801af5 <initialize_dyn_block_system+0x100>
  801ae5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ae8:	8b 00                	mov    (%eax),%eax
  801aea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801aed:	8b 52 04             	mov    0x4(%edx),%edx
  801af0:	89 50 04             	mov    %edx,0x4(%eax)
  801af3:	eb 0b                	jmp    801b00 <initialize_dyn_block_system+0x10b>
  801af5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801af8:	8b 40 04             	mov    0x4(%eax),%eax
  801afb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b03:	8b 40 04             	mov    0x4(%eax),%eax
  801b06:	85 c0                	test   %eax,%eax
  801b08:	74 0f                	je     801b19 <initialize_dyn_block_system+0x124>
  801b0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b0d:	8b 40 04             	mov    0x4(%eax),%eax
  801b10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b13:	8b 12                	mov    (%edx),%edx
  801b15:	89 10                	mov    %edx,(%eax)
  801b17:	eb 0a                	jmp    801b23 <initialize_dyn_block_system+0x12e>
  801b19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b1c:	8b 00                	mov    (%eax),%eax
  801b1e:	a3 48 51 80 00       	mov    %eax,0x805148
  801b23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b36:	a1 54 51 80 00       	mov    0x805154,%eax
  801b3b:	48                   	dec    %eax
  801b3c:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801b41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b44:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801b4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b4e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801b55:	83 ec 0c             	sub    $0xc,%esp
  801b58:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b5b:	e8 d2 13 00 00       	call   802f32 <insert_sorted_with_merge_freeList>
  801b60:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801b63:	90                   	nop
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b6c:	e8 53 fe ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b75:	75 07                	jne    801b7e <malloc+0x18>
  801b77:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7c:	eb 61                	jmp    801bdf <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801b7e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b85:	8b 55 08             	mov    0x8(%ebp),%edx
  801b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8b:	01 d0                	add    %edx,%eax
  801b8d:	48                   	dec    %eax
  801b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b94:	ba 00 00 00 00       	mov    $0x0,%edx
  801b99:	f7 75 f4             	divl   -0xc(%ebp)
  801b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9f:	29 d0                	sub    %edx,%eax
  801ba1:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ba4:	e8 3c 08 00 00       	call   8023e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	74 2d                	je     801bda <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801bad:	83 ec 0c             	sub    $0xc,%esp
  801bb0:	ff 75 08             	pushl  0x8(%ebp)
  801bb3:	e8 3e 0f 00 00       	call   802af6 <alloc_block_FF>
  801bb8:	83 c4 10             	add    $0x10,%esp
  801bbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801bbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bc2:	74 16                	je     801bda <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801bc4:	83 ec 0c             	sub    $0xc,%esp
  801bc7:	ff 75 ec             	pushl  -0x14(%ebp)
  801bca:	e8 48 0c 00 00       	call   802817 <insert_sorted_allocList>
  801bcf:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801bd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd5:	8b 40 08             	mov    0x8(%eax),%eax
  801bd8:	eb 05                	jmp    801bdf <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801bda:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bf5:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	50                   	push   %eax
  801bff:	68 40 50 80 00       	push   $0x805040
  801c04:	e8 71 0b 00 00       	call   80277a <find_block>
  801c09:	83 c4 10             	add    $0x10,%esp
  801c0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c12:	8b 50 0c             	mov    0xc(%eax),%edx
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	83 ec 08             	sub    $0x8,%esp
  801c1b:	52                   	push   %edx
  801c1c:	50                   	push   %eax
  801c1d:	e8 bd 03 00 00       	call   801fdf <sys_free_user_mem>
  801c22:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801c25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c29:	75 14                	jne    801c3f <free+0x5e>
  801c2b:	83 ec 04             	sub    $0x4,%esp
  801c2e:	68 a9 40 80 00       	push   $0x8040a9
  801c33:	6a 71                	push   $0x71
  801c35:	68 c7 40 80 00       	push   $0x8040c7
  801c3a:	e8 41 eb ff ff       	call   800780 <_panic>
  801c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c42:	8b 00                	mov    (%eax),%eax
  801c44:	85 c0                	test   %eax,%eax
  801c46:	74 10                	je     801c58 <free+0x77>
  801c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c4b:	8b 00                	mov    (%eax),%eax
  801c4d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c50:	8b 52 04             	mov    0x4(%edx),%edx
  801c53:	89 50 04             	mov    %edx,0x4(%eax)
  801c56:	eb 0b                	jmp    801c63 <free+0x82>
  801c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5b:	8b 40 04             	mov    0x4(%eax),%eax
  801c5e:	a3 44 50 80 00       	mov    %eax,0x805044
  801c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c66:	8b 40 04             	mov    0x4(%eax),%eax
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	74 0f                	je     801c7c <free+0x9b>
  801c6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c70:	8b 40 04             	mov    0x4(%eax),%eax
  801c73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c76:	8b 12                	mov    (%edx),%edx
  801c78:	89 10                	mov    %edx,(%eax)
  801c7a:	eb 0a                	jmp    801c86 <free+0xa5>
  801c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7f:	8b 00                	mov    (%eax),%eax
  801c81:	a3 40 50 80 00       	mov    %eax,0x805040
  801c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c99:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c9e:	48                   	dec    %eax
  801c9f:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801ca4:	83 ec 0c             	sub    $0xc,%esp
  801ca7:	ff 75 f0             	pushl  -0x10(%ebp)
  801caa:	e8 83 12 00 00       	call   802f32 <insert_sorted_with_merge_freeList>
  801caf:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801cb2:	90                   	nop
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 28             	sub    $0x28,%esp
  801cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbe:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cc1:	e8 fe fc ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cc6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cca:	75 0a                	jne    801cd6 <smalloc+0x21>
  801ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd1:	e9 86 00 00 00       	jmp    801d5c <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801cd6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce3:	01 d0                	add    %edx,%eax
  801ce5:	48                   	dec    %eax
  801ce6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cec:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf1:	f7 75 f4             	divl   -0xc(%ebp)
  801cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf7:	29 d0                	sub    %edx,%eax
  801cf9:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801cfc:	e8 e4 06 00 00       	call   8023e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d01:	85 c0                	test   %eax,%eax
  801d03:	74 52                	je     801d57 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801d05:	83 ec 0c             	sub    $0xc,%esp
  801d08:	ff 75 0c             	pushl  0xc(%ebp)
  801d0b:	e8 e6 0d 00 00       	call   802af6 <alloc_block_FF>
  801d10:	83 c4 10             	add    $0x10,%esp
  801d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801d16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d1a:	75 07                	jne    801d23 <smalloc+0x6e>
			return NULL ;
  801d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d21:	eb 39                	jmp    801d5c <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801d23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d26:	8b 40 08             	mov    0x8(%eax),%eax
  801d29:	89 c2                	mov    %eax,%edx
  801d2b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801d2f:	52                   	push   %edx
  801d30:	50                   	push   %eax
  801d31:	ff 75 0c             	pushl  0xc(%ebp)
  801d34:	ff 75 08             	pushl  0x8(%ebp)
  801d37:	e8 2e 04 00 00       	call   80216a <sys_createSharedObject>
  801d3c:	83 c4 10             	add    $0x10,%esp
  801d3f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801d42:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d46:	79 07                	jns    801d4f <smalloc+0x9a>
			return (void*)NULL ;
  801d48:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4d:	eb 0d                	jmp    801d5c <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d52:	8b 40 08             	mov    0x8(%eax),%eax
  801d55:	eb 05                	jmp    801d5c <smalloc+0xa7>
		}
		return (void*)NULL ;
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d64:	e8 5b fc ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d69:	83 ec 08             	sub    $0x8,%esp
  801d6c:	ff 75 0c             	pushl  0xc(%ebp)
  801d6f:	ff 75 08             	pushl  0x8(%ebp)
  801d72:	e8 1d 04 00 00       	call   802194 <sys_getSizeOfSharedObject>
  801d77:	83 c4 10             	add    $0x10,%esp
  801d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801d7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d81:	75 0a                	jne    801d8d <sget+0x2f>
			return NULL ;
  801d83:	b8 00 00 00 00       	mov    $0x0,%eax
  801d88:	e9 83 00 00 00       	jmp    801e10 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801d8d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9a:	01 d0                	add    %edx,%eax
  801d9c:	48                   	dec    %eax
  801d9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801da0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801da3:	ba 00 00 00 00       	mov    $0x0,%edx
  801da8:	f7 75 f0             	divl   -0x10(%ebp)
  801dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dae:	29 d0                	sub    %edx,%eax
  801db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801db3:	e8 2d 06 00 00       	call   8023e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801db8:	85 c0                	test   %eax,%eax
  801dba:	74 4f                	je     801e0b <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbf:	83 ec 0c             	sub    $0xc,%esp
  801dc2:	50                   	push   %eax
  801dc3:	e8 2e 0d 00 00       	call   802af6 <alloc_block_FF>
  801dc8:	83 c4 10             	add    $0x10,%esp
  801dcb:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801dce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801dd2:	75 07                	jne    801ddb <sget+0x7d>
					return (void*)NULL ;
  801dd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801dd9:	eb 35                	jmp    801e10 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801ddb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dde:	8b 40 08             	mov    0x8(%eax),%eax
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	50                   	push   %eax
  801de5:	ff 75 0c             	pushl  0xc(%ebp)
  801de8:	ff 75 08             	pushl  0x8(%ebp)
  801deb:	e8 c1 03 00 00       	call   8021b1 <sys_getSharedObject>
  801df0:	83 c4 10             	add    $0x10,%esp
  801df3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801df6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801dfa:	79 07                	jns    801e03 <sget+0xa5>
				return (void*)NULL ;
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801e01:	eb 0d                	jmp    801e10 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801e03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e06:	8b 40 08             	mov    0x8(%eax),%eax
  801e09:	eb 05                	jmp    801e10 <sget+0xb2>


		}
	return (void*)NULL ;
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e18:	e8 a7 fb ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e1d:	83 ec 04             	sub    $0x4,%esp
  801e20:	68 d4 40 80 00       	push   $0x8040d4
  801e25:	68 f9 00 00 00       	push   $0xf9
  801e2a:	68 c7 40 80 00       	push   $0x8040c7
  801e2f:	e8 4c e9 ff ff       	call   800780 <_panic>

00801e34 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	68 fc 40 80 00       	push   $0x8040fc
  801e42:	68 0d 01 00 00       	push   $0x10d
  801e47:	68 c7 40 80 00       	push   $0x8040c7
  801e4c:	e8 2f e9 ff ff       	call   800780 <_panic>

00801e51 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e57:	83 ec 04             	sub    $0x4,%esp
  801e5a:	68 20 41 80 00       	push   $0x804120
  801e5f:	68 18 01 00 00       	push   $0x118
  801e64:	68 c7 40 80 00       	push   $0x8040c7
  801e69:	e8 12 e9 ff ff       	call   800780 <_panic>

00801e6e <shrink>:

}
void shrink(uint32 newSize)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e74:	83 ec 04             	sub    $0x4,%esp
  801e77:	68 20 41 80 00       	push   $0x804120
  801e7c:	68 1d 01 00 00       	push   $0x11d
  801e81:	68 c7 40 80 00       	push   $0x8040c7
  801e86:	e8 f5 e8 ff ff       	call   800780 <_panic>

00801e8b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e91:	83 ec 04             	sub    $0x4,%esp
  801e94:	68 20 41 80 00       	push   $0x804120
  801e99:	68 22 01 00 00       	push   $0x122
  801e9e:	68 c7 40 80 00       	push   $0x8040c7
  801ea3:	e8 d8 e8 ff ff       	call   800780 <_panic>

00801ea8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	57                   	push   %edi
  801eac:	56                   	push   %esi
  801ead:	53                   	push   %ebx
  801eae:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ebd:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ec0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ec3:	cd 30                	int    $0x30
  801ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ecb:	83 c4 10             	add    $0x10,%esp
  801ece:	5b                   	pop    %ebx
  801ecf:	5e                   	pop    %esi
  801ed0:	5f                   	pop    %edi
  801ed1:	5d                   	pop    %ebp
  801ed2:	c3                   	ret    

00801ed3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	83 ec 04             	sub    $0x4,%esp
  801ed9:	8b 45 10             	mov    0x10(%ebp),%eax
  801edc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801edf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee6:	6a 00                	push   $0x0
  801ee8:	6a 00                	push   $0x0
  801eea:	52                   	push   %edx
  801eeb:	ff 75 0c             	pushl  0xc(%ebp)
  801eee:	50                   	push   %eax
  801eef:	6a 00                	push   $0x0
  801ef1:	e8 b2 ff ff ff       	call   801ea8 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	90                   	nop
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_cgetc>:

int
sys_cgetc(void)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 01                	push   $0x1
  801f0b:	e8 98 ff ff ff       	call   801ea8 <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f18:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	52                   	push   %edx
  801f25:	50                   	push   %eax
  801f26:	6a 05                	push   $0x5
  801f28:	e8 7b ff ff ff       	call   801ea8 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	c9                   	leave  
  801f31:	c3                   	ret    

00801f32 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	56                   	push   %esi
  801f36:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f37:	8b 75 18             	mov    0x18(%ebp),%esi
  801f3a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	56                   	push   %esi
  801f47:	53                   	push   %ebx
  801f48:	51                   	push   %ecx
  801f49:	52                   	push   %edx
  801f4a:	50                   	push   %eax
  801f4b:	6a 06                	push   $0x6
  801f4d:	e8 56 ff ff ff       	call   801ea8 <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
}
  801f55:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f58:	5b                   	pop    %ebx
  801f59:	5e                   	pop    %esi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    

00801f5c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	52                   	push   %edx
  801f6c:	50                   	push   %eax
  801f6d:	6a 07                	push   $0x7
  801f6f:	e8 34 ff ff ff       	call   801ea8 <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
}
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	ff 75 0c             	pushl  0xc(%ebp)
  801f85:	ff 75 08             	pushl  0x8(%ebp)
  801f88:	6a 08                	push   $0x8
  801f8a:	e8 19 ff ff ff       	call   801ea8 <syscall>
  801f8f:	83 c4 18             	add    $0x18,%esp
}
  801f92:	c9                   	leave  
  801f93:	c3                   	ret    

00801f94 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 09                	push   $0x9
  801fa3:	e8 00 ff ff ff       	call   801ea8 <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
}
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	6a 00                	push   $0x0
  801fba:	6a 0a                	push   $0xa
  801fbc:	e8 e7 fe ff ff       	call   801ea8 <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	c9                   	leave  
  801fc5:	c3                   	ret    

00801fc6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801fc6:	55                   	push   %ebp
  801fc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 0b                	push   $0xb
  801fd5:	e8 ce fe ff ff       	call   801ea8 <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
}
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	ff 75 0c             	pushl  0xc(%ebp)
  801feb:	ff 75 08             	pushl  0x8(%ebp)
  801fee:	6a 0f                	push   $0xf
  801ff0:	e8 b3 fe ff ff       	call   801ea8 <syscall>
  801ff5:	83 c4 18             	add    $0x18,%esp
	return;
  801ff8:	90                   	nop
}
  801ff9:	c9                   	leave  
  801ffa:	c3                   	ret    

00801ffb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ffb:	55                   	push   %ebp
  801ffc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	ff 75 0c             	pushl  0xc(%ebp)
  802007:	ff 75 08             	pushl  0x8(%ebp)
  80200a:	6a 10                	push   $0x10
  80200c:	e8 97 fe ff ff       	call   801ea8 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
	return ;
  802014:	90                   	nop
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	ff 75 10             	pushl  0x10(%ebp)
  802021:	ff 75 0c             	pushl  0xc(%ebp)
  802024:	ff 75 08             	pushl  0x8(%ebp)
  802027:	6a 11                	push   $0x11
  802029:	e8 7a fe ff ff       	call   801ea8 <syscall>
  80202e:	83 c4 18             	add    $0x18,%esp
	return ;
  802031:	90                   	nop
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 0c                	push   $0xc
  802043:	e8 60 fe ff ff       	call   801ea8 <syscall>
  802048:	83 c4 18             	add    $0x18,%esp
}
  80204b:	c9                   	leave  
  80204c:	c3                   	ret    

0080204d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	ff 75 08             	pushl  0x8(%ebp)
  80205b:	6a 0d                	push   $0xd
  80205d:	e8 46 fe ff ff       	call   801ea8 <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 0e                	push   $0xe
  802076:	e8 2d fe ff ff       	call   801ea8 <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	90                   	nop
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 13                	push   $0x13
  802090:	e8 13 fe ff ff       	call   801ea8 <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
}
  802098:	90                   	nop
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 14                	push   $0x14
  8020aa:	e8 f9 fd ff ff       	call   801ea8 <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
}
  8020b2:	90                   	nop
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 04             	sub    $0x4,%esp
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8020c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	50                   	push   %eax
  8020ce:	6a 15                	push   $0x15
  8020d0:	e8 d3 fd ff ff       	call   801ea8 <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	90                   	nop
  8020d9:	c9                   	leave  
  8020da:	c3                   	ret    

008020db <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8020db:	55                   	push   %ebp
  8020dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 16                	push   $0x16
  8020ea:	e8 b9 fd ff ff       	call   801ea8 <syscall>
  8020ef:	83 c4 18             	add    $0x18,%esp
}
  8020f2:	90                   	nop
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	ff 75 0c             	pushl  0xc(%ebp)
  802104:	50                   	push   %eax
  802105:	6a 17                	push   $0x17
  802107:	e8 9c fd ff ff       	call   801ea8 <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802114:	8b 55 0c             	mov    0xc(%ebp),%edx
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	52                   	push   %edx
  802121:	50                   	push   %eax
  802122:	6a 1a                	push   $0x1a
  802124:	e8 7f fd ff ff       	call   801ea8 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802131:	8b 55 0c             	mov    0xc(%ebp),%edx
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	52                   	push   %edx
  80213e:	50                   	push   %eax
  80213f:	6a 18                	push   $0x18
  802141:	e8 62 fd ff ff       	call   801ea8 <syscall>
  802146:	83 c4 18             	add    $0x18,%esp
}
  802149:	90                   	nop
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80214f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	52                   	push   %edx
  80215c:	50                   	push   %eax
  80215d:	6a 19                	push   $0x19
  80215f:	e8 44 fd ff ff       	call   801ea8 <syscall>
  802164:	83 c4 18             	add    $0x18,%esp
}
  802167:	90                   	nop
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 04             	sub    $0x4,%esp
  802170:	8b 45 10             	mov    0x10(%ebp),%eax
  802173:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802176:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802179:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	6a 00                	push   $0x0
  802182:	51                   	push   %ecx
  802183:	52                   	push   %edx
  802184:	ff 75 0c             	pushl  0xc(%ebp)
  802187:	50                   	push   %eax
  802188:	6a 1b                	push   $0x1b
  80218a:	e8 19 fd ff ff       	call   801ea8 <syscall>
  80218f:	83 c4 18             	add    $0x18,%esp
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802197:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	52                   	push   %edx
  8021a4:	50                   	push   %eax
  8021a5:	6a 1c                	push   $0x1c
  8021a7:	e8 fc fc ff ff       	call   801ea8 <syscall>
  8021ac:	83 c4 18             	add    $0x18,%esp
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8021b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	51                   	push   %ecx
  8021c2:	52                   	push   %edx
  8021c3:	50                   	push   %eax
  8021c4:	6a 1d                	push   $0x1d
  8021c6:	e8 dd fc ff ff       	call   801ea8 <syscall>
  8021cb:	83 c4 18             	add    $0x18,%esp
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8021d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	52                   	push   %edx
  8021e0:	50                   	push   %eax
  8021e1:	6a 1e                	push   $0x1e
  8021e3:	e8 c0 fc ff ff       	call   801ea8 <syscall>
  8021e8:	83 c4 18             	add    $0x18,%esp
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	6a 1f                	push   $0x1f
  8021fc:	e8 a7 fc ff ff       	call   801ea8 <syscall>
  802201:	83 c4 18             	add    $0x18,%esp
}
  802204:	c9                   	leave  
  802205:	c3                   	ret    

00802206 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802206:	55                   	push   %ebp
  802207:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	6a 00                	push   $0x0
  80220e:	ff 75 14             	pushl  0x14(%ebp)
  802211:	ff 75 10             	pushl  0x10(%ebp)
  802214:	ff 75 0c             	pushl  0xc(%ebp)
  802217:	50                   	push   %eax
  802218:	6a 20                	push   $0x20
  80221a:	e8 89 fc ff ff       	call   801ea8 <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	6a 00                	push   $0x0
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	50                   	push   %eax
  802233:	6a 21                	push   $0x21
  802235:	e8 6e fc ff ff       	call   801ea8 <syscall>
  80223a:	83 c4 18             	add    $0x18,%esp
}
  80223d:	90                   	nop
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	50                   	push   %eax
  80224f:	6a 22                	push   $0x22
  802251:	e8 52 fc ff ff       	call   801ea8 <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
}
  802259:	c9                   	leave  
  80225a:	c3                   	ret    

0080225b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	6a 02                	push   $0x2
  80226a:	e8 39 fc ff ff       	call   801ea8 <syscall>
  80226f:	83 c4 18             	add    $0x18,%esp
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 03                	push   $0x3
  802283:	e8 20 fc ff ff       	call   801ea8 <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 04                	push   $0x4
  80229c:	e8 07 fc ff ff       	call   801ea8 <syscall>
  8022a1:	83 c4 18             	add    $0x18,%esp
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <sys_exit_env>:


void sys_exit_env(void)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 23                	push   $0x23
  8022b5:	e8 ee fb ff ff       	call   801ea8 <syscall>
  8022ba:	83 c4 18             	add    $0x18,%esp
}
  8022bd:	90                   	nop
  8022be:	c9                   	leave  
  8022bf:	c3                   	ret    

008022c0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022c6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022c9:	8d 50 04             	lea    0x4(%eax),%edx
  8022cc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	52                   	push   %edx
  8022d6:	50                   	push   %eax
  8022d7:	6a 24                	push   $0x24
  8022d9:	e8 ca fb ff ff       	call   801ea8 <syscall>
  8022de:	83 c4 18             	add    $0x18,%esp
	return result;
  8022e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8022e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8022ea:	89 01                	mov    %eax,(%ecx)
  8022ec:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	c9                   	leave  
  8022f3:	c2 04 00             	ret    $0x4

008022f6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	ff 75 10             	pushl  0x10(%ebp)
  802300:	ff 75 0c             	pushl  0xc(%ebp)
  802303:	ff 75 08             	pushl  0x8(%ebp)
  802306:	6a 12                	push   $0x12
  802308:	e8 9b fb ff ff       	call   801ea8 <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
	return ;
  802310:	90                   	nop
}
  802311:	c9                   	leave  
  802312:	c3                   	ret    

00802313 <sys_rcr2>:
uint32 sys_rcr2()
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 25                	push   $0x25
  802322:	e8 81 fb ff ff       	call   801ea8 <syscall>
  802327:	83 c4 18             	add    $0x18,%esp
}
  80232a:	c9                   	leave  
  80232b:	c3                   	ret    

0080232c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	83 ec 04             	sub    $0x4,%esp
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802338:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	50                   	push   %eax
  802345:	6a 26                	push   $0x26
  802347:	e8 5c fb ff ff       	call   801ea8 <syscall>
  80234c:	83 c4 18             	add    $0x18,%esp
	return ;
  80234f:	90                   	nop
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <rsttst>:
void rsttst()
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 28                	push   $0x28
  802361:	e8 42 fb ff ff       	call   801ea8 <syscall>
  802366:	83 c4 18             	add    $0x18,%esp
	return ;
  802369:	90                   	nop
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	83 ec 04             	sub    $0x4,%esp
  802372:	8b 45 14             	mov    0x14(%ebp),%eax
  802375:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802378:	8b 55 18             	mov    0x18(%ebp),%edx
  80237b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80237f:	52                   	push   %edx
  802380:	50                   	push   %eax
  802381:	ff 75 10             	pushl  0x10(%ebp)
  802384:	ff 75 0c             	pushl  0xc(%ebp)
  802387:	ff 75 08             	pushl  0x8(%ebp)
  80238a:	6a 27                	push   $0x27
  80238c:	e8 17 fb ff ff       	call   801ea8 <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
	return ;
  802394:	90                   	nop
}
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <chktst>:
void chktst(uint32 n)
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 00                	push   $0x0
  8023a0:	6a 00                	push   $0x0
  8023a2:	ff 75 08             	pushl  0x8(%ebp)
  8023a5:	6a 29                	push   $0x29
  8023a7:	e8 fc fa ff ff       	call   801ea8 <syscall>
  8023ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8023af:	90                   	nop
}
  8023b0:	c9                   	leave  
  8023b1:	c3                   	ret    

008023b2 <inctst>:

void inctst()
{
  8023b2:	55                   	push   %ebp
  8023b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 2a                	push   $0x2a
  8023c1:	e8 e2 fa ff ff       	call   801ea8 <syscall>
  8023c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023c9:	90                   	nop
}
  8023ca:	c9                   	leave  
  8023cb:	c3                   	ret    

008023cc <gettst>:
uint32 gettst()
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023cf:	6a 00                	push   $0x0
  8023d1:	6a 00                	push   $0x0
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 2b                	push   $0x2b
  8023db:	e8 c8 fa ff ff       	call   801ea8 <syscall>
  8023e0:	83 c4 18             	add    $0x18,%esp
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8023e5:	55                   	push   %ebp
  8023e6:	89 e5                	mov    %esp,%ebp
  8023e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 2c                	push   $0x2c
  8023f7:	e8 ac fa ff ff       	call   801ea8 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
  8023ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802402:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802406:	75 07                	jne    80240f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802408:	b8 01 00 00 00       	mov    $0x1,%eax
  80240d:	eb 05                	jmp    802414 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
  802419:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80241c:	6a 00                	push   $0x0
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 2c                	push   $0x2c
  802428:	e8 7b fa ff ff       	call   801ea8 <syscall>
  80242d:	83 c4 18             	add    $0x18,%esp
  802430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802433:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802437:	75 07                	jne    802440 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802439:	b8 01 00 00 00       	mov    $0x1,%eax
  80243e:	eb 05                	jmp    802445 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802440:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802445:	c9                   	leave  
  802446:	c3                   	ret    

00802447 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802447:	55                   	push   %ebp
  802448:	89 e5                	mov    %esp,%ebp
  80244a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 00                	push   $0x0
  802455:	6a 00                	push   $0x0
  802457:	6a 2c                	push   $0x2c
  802459:	e8 4a fa ff ff       	call   801ea8 <syscall>
  80245e:	83 c4 18             	add    $0x18,%esp
  802461:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802464:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802468:	75 07                	jne    802471 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80246a:	b8 01 00 00 00       	mov    $0x1,%eax
  80246f:	eb 05                	jmp    802476 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802471:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802476:	c9                   	leave  
  802477:	c3                   	ret    

00802478 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802478:	55                   	push   %ebp
  802479:	89 e5                	mov    %esp,%ebp
  80247b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80247e:	6a 00                	push   $0x0
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 2c                	push   $0x2c
  80248a:	e8 19 fa ff ff       	call   801ea8 <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
  802492:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802495:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802499:	75 07                	jne    8024a2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80249b:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a0:	eb 05                	jmp    8024a7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a7:	c9                   	leave  
  8024a8:	c3                   	ret    

008024a9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	ff 75 08             	pushl  0x8(%ebp)
  8024b7:	6a 2d                	push   $0x2d
  8024b9:	e8 ea f9 ff ff       	call   801ea8 <syscall>
  8024be:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c1:	90                   	nop
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d4:	6a 00                	push   $0x0
  8024d6:	53                   	push   %ebx
  8024d7:	51                   	push   %ecx
  8024d8:	52                   	push   %edx
  8024d9:	50                   	push   %eax
  8024da:	6a 2e                	push   $0x2e
  8024dc:	e8 c7 f9 ff ff       	call   801ea8 <syscall>
  8024e1:	83 c4 18             	add    $0x18,%esp
}
  8024e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8024ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	52                   	push   %edx
  8024f9:	50                   	push   %eax
  8024fa:	6a 2f                	push   $0x2f
  8024fc:	e8 a7 f9 ff ff       	call   801ea8 <syscall>
  802501:	83 c4 18             	add    $0x18,%esp
}
  802504:	c9                   	leave  
  802505:	c3                   	ret    

00802506 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802506:	55                   	push   %ebp
  802507:	89 e5                	mov    %esp,%ebp
  802509:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80250c:	83 ec 0c             	sub    $0xc,%esp
  80250f:	68 30 41 80 00       	push   $0x804130
  802514:	e8 1b e5 ff ff       	call   800a34 <cprintf>
  802519:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80251c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802523:	83 ec 0c             	sub    $0xc,%esp
  802526:	68 5c 41 80 00       	push   $0x80415c
  80252b:	e8 04 e5 ff ff       	call   800a34 <cprintf>
  802530:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802533:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802537:	a1 38 51 80 00       	mov    0x805138,%eax
  80253c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253f:	eb 56                	jmp    802597 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802541:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802545:	74 1c                	je     802563 <print_mem_block_lists+0x5d>
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 50 08             	mov    0x8(%eax),%edx
  80254d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802550:	8b 48 08             	mov    0x8(%eax),%ecx
  802553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802556:	8b 40 0c             	mov    0xc(%eax),%eax
  802559:	01 c8                	add    %ecx,%eax
  80255b:	39 c2                	cmp    %eax,%edx
  80255d:	73 04                	jae    802563 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80255f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 50 08             	mov    0x8(%eax),%edx
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 40 0c             	mov    0xc(%eax),%eax
  80256f:	01 c2                	add    %eax,%edx
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 40 08             	mov    0x8(%eax),%eax
  802577:	83 ec 04             	sub    $0x4,%esp
  80257a:	52                   	push   %edx
  80257b:	50                   	push   %eax
  80257c:	68 71 41 80 00       	push   $0x804171
  802581:	e8 ae e4 ff ff       	call   800a34 <cprintf>
  802586:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80258f:	a1 40 51 80 00       	mov    0x805140,%eax
  802594:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259b:	74 07                	je     8025a4 <print_mem_block_lists+0x9e>
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 00                	mov    (%eax),%eax
  8025a2:	eb 05                	jmp    8025a9 <print_mem_block_lists+0xa3>
  8025a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a9:	a3 40 51 80 00       	mov    %eax,0x805140
  8025ae:	a1 40 51 80 00       	mov    0x805140,%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	75 8a                	jne    802541 <print_mem_block_lists+0x3b>
  8025b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bb:	75 84                	jne    802541 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8025bd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025c1:	75 10                	jne    8025d3 <print_mem_block_lists+0xcd>
  8025c3:	83 ec 0c             	sub    $0xc,%esp
  8025c6:	68 80 41 80 00       	push   $0x804180
  8025cb:	e8 64 e4 ff ff       	call   800a34 <cprintf>
  8025d0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8025d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8025da:	83 ec 0c             	sub    $0xc,%esp
  8025dd:	68 a4 41 80 00       	push   $0x8041a4
  8025e2:	e8 4d e4 ff ff       	call   800a34 <cprintf>
  8025e7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8025ea:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025ee:	a1 40 50 80 00       	mov    0x805040,%eax
  8025f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f6:	eb 56                	jmp    80264e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025fc:	74 1c                	je     80261a <print_mem_block_lists+0x114>
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 50 08             	mov    0x8(%eax),%edx
  802604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802607:	8b 48 08             	mov    0x8(%eax),%ecx
  80260a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260d:	8b 40 0c             	mov    0xc(%eax),%eax
  802610:	01 c8                	add    %ecx,%eax
  802612:	39 c2                	cmp    %eax,%edx
  802614:	73 04                	jae    80261a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802616:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 50 08             	mov    0x8(%eax),%edx
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 40 0c             	mov    0xc(%eax),%eax
  802626:	01 c2                	add    %eax,%edx
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 40 08             	mov    0x8(%eax),%eax
  80262e:	83 ec 04             	sub    $0x4,%esp
  802631:	52                   	push   %edx
  802632:	50                   	push   %eax
  802633:	68 71 41 80 00       	push   $0x804171
  802638:	e8 f7 e3 ff ff       	call   800a34 <cprintf>
  80263d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802646:	a1 48 50 80 00       	mov    0x805048,%eax
  80264b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802652:	74 07                	je     80265b <print_mem_block_lists+0x155>
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 00                	mov    (%eax),%eax
  802659:	eb 05                	jmp    802660 <print_mem_block_lists+0x15a>
  80265b:	b8 00 00 00 00       	mov    $0x0,%eax
  802660:	a3 48 50 80 00       	mov    %eax,0x805048
  802665:	a1 48 50 80 00       	mov    0x805048,%eax
  80266a:	85 c0                	test   %eax,%eax
  80266c:	75 8a                	jne    8025f8 <print_mem_block_lists+0xf2>
  80266e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802672:	75 84                	jne    8025f8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802674:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802678:	75 10                	jne    80268a <print_mem_block_lists+0x184>
  80267a:	83 ec 0c             	sub    $0xc,%esp
  80267d:	68 bc 41 80 00       	push   $0x8041bc
  802682:	e8 ad e3 ff ff       	call   800a34 <cprintf>
  802687:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80268a:	83 ec 0c             	sub    $0xc,%esp
  80268d:	68 30 41 80 00       	push   $0x804130
  802692:	e8 9d e3 ff ff       	call   800a34 <cprintf>
  802697:	83 c4 10             	add    $0x10,%esp

}
  80269a:	90                   	nop
  80269b:	c9                   	leave  
  80269c:	c3                   	ret    

0080269d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80269d:	55                   	push   %ebp
  80269e:	89 e5                	mov    %esp,%ebp
  8026a0:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8026a3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026aa:	00 00 00 
  8026ad:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8026b4:	00 00 00 
  8026b7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8026be:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8026c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8026c8:	e9 9e 00 00 00       	jmp    80276b <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8026cd:	a1 50 50 80 00       	mov    0x805050,%eax
  8026d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d5:	c1 e2 04             	shl    $0x4,%edx
  8026d8:	01 d0                	add    %edx,%eax
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	75 14                	jne    8026f2 <initialize_MemBlocksList+0x55>
  8026de:	83 ec 04             	sub    $0x4,%esp
  8026e1:	68 e4 41 80 00       	push   $0x8041e4
  8026e6:	6a 43                	push   $0x43
  8026e8:	68 07 42 80 00       	push   $0x804207
  8026ed:	e8 8e e0 ff ff       	call   800780 <_panic>
  8026f2:	a1 50 50 80 00       	mov    0x805050,%eax
  8026f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026fa:	c1 e2 04             	shl    $0x4,%edx
  8026fd:	01 d0                	add    %edx,%eax
  8026ff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802705:	89 10                	mov    %edx,(%eax)
  802707:	8b 00                	mov    (%eax),%eax
  802709:	85 c0                	test   %eax,%eax
  80270b:	74 18                	je     802725 <initialize_MemBlocksList+0x88>
  80270d:	a1 48 51 80 00       	mov    0x805148,%eax
  802712:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802718:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80271b:	c1 e1 04             	shl    $0x4,%ecx
  80271e:	01 ca                	add    %ecx,%edx
  802720:	89 50 04             	mov    %edx,0x4(%eax)
  802723:	eb 12                	jmp    802737 <initialize_MemBlocksList+0x9a>
  802725:	a1 50 50 80 00       	mov    0x805050,%eax
  80272a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80272d:	c1 e2 04             	shl    $0x4,%edx
  802730:	01 d0                	add    %edx,%eax
  802732:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802737:	a1 50 50 80 00       	mov    0x805050,%eax
  80273c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273f:	c1 e2 04             	shl    $0x4,%edx
  802742:	01 d0                	add    %edx,%eax
  802744:	a3 48 51 80 00       	mov    %eax,0x805148
  802749:	a1 50 50 80 00       	mov    0x805050,%eax
  80274e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802751:	c1 e2 04             	shl    $0x4,%edx
  802754:	01 d0                	add    %edx,%eax
  802756:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275d:	a1 54 51 80 00       	mov    0x805154,%eax
  802762:	40                   	inc    %eax
  802763:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802768:	ff 45 f4             	incl   -0xc(%ebp)
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802771:	0f 82 56 ff ff ff    	jb     8026cd <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802777:	90                   	nop
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802780:	a1 38 51 80 00       	mov    0x805138,%eax
  802785:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802788:	eb 18                	jmp    8027a2 <find_block+0x28>
	{
		if (ele->sva==va)
  80278a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80278d:	8b 40 08             	mov    0x8(%eax),%eax
  802790:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802793:	75 05                	jne    80279a <find_block+0x20>
			return ele;
  802795:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802798:	eb 7b                	jmp    802815 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80279a:	a1 40 51 80 00       	mov    0x805140,%eax
  80279f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027a6:	74 07                	je     8027af <find_block+0x35>
  8027a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	eb 05                	jmp    8027b4 <find_block+0x3a>
  8027af:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b4:	a3 40 51 80 00       	mov    %eax,0x805140
  8027b9:	a1 40 51 80 00       	mov    0x805140,%eax
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	75 c8                	jne    80278a <find_block+0x10>
  8027c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027c6:	75 c2                	jne    80278a <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8027c8:	a1 40 50 80 00       	mov    0x805040,%eax
  8027cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027d0:	eb 18                	jmp    8027ea <find_block+0x70>
	{
		if (ele->sva==va)
  8027d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027d5:	8b 40 08             	mov    0x8(%eax),%eax
  8027d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027db:	75 05                	jne    8027e2 <find_block+0x68>
					return ele;
  8027dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027e0:	eb 33                	jmp    802815 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8027e2:	a1 48 50 80 00       	mov    0x805048,%eax
  8027e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8027ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027ee:	74 07                	je     8027f7 <find_block+0x7d>
  8027f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	eb 05                	jmp    8027fc <find_block+0x82>
  8027f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fc:	a3 48 50 80 00       	mov    %eax,0x805048
  802801:	a1 48 50 80 00       	mov    0x805048,%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	75 c8                	jne    8027d2 <find_block+0x58>
  80280a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80280e:	75 c2                	jne    8027d2 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802810:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802815:	c9                   	leave  
  802816:	c3                   	ret    

00802817 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802817:	55                   	push   %ebp
  802818:	89 e5                	mov    %esp,%ebp
  80281a:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  80281d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802822:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802825:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802829:	75 62                	jne    80288d <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80282b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80282f:	75 14                	jne    802845 <insert_sorted_allocList+0x2e>
  802831:	83 ec 04             	sub    $0x4,%esp
  802834:	68 e4 41 80 00       	push   $0x8041e4
  802839:	6a 69                	push   $0x69
  80283b:	68 07 42 80 00       	push   $0x804207
  802840:	e8 3b df ff ff       	call   800780 <_panic>
  802845:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	89 10                	mov    %edx,(%eax)
  802850:	8b 45 08             	mov    0x8(%ebp),%eax
  802853:	8b 00                	mov    (%eax),%eax
  802855:	85 c0                	test   %eax,%eax
  802857:	74 0d                	je     802866 <insert_sorted_allocList+0x4f>
  802859:	a1 40 50 80 00       	mov    0x805040,%eax
  80285e:	8b 55 08             	mov    0x8(%ebp),%edx
  802861:	89 50 04             	mov    %edx,0x4(%eax)
  802864:	eb 08                	jmp    80286e <insert_sorted_allocList+0x57>
  802866:	8b 45 08             	mov    0x8(%ebp),%eax
  802869:	a3 44 50 80 00       	mov    %eax,0x805044
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	a3 40 50 80 00       	mov    %eax,0x805040
  802876:	8b 45 08             	mov    0x8(%ebp),%eax
  802879:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802880:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802885:	40                   	inc    %eax
  802886:	a3 4c 50 80 00       	mov    %eax,0x80504c
  80288b:	eb 72                	jmp    8028ff <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  80288d:	a1 40 50 80 00       	mov    0x805040,%eax
  802892:	8b 50 08             	mov    0x8(%eax),%edx
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	8b 40 08             	mov    0x8(%eax),%eax
  80289b:	39 c2                	cmp    %eax,%edx
  80289d:	76 60                	jbe    8028ff <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80289f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028a3:	75 14                	jne    8028b9 <insert_sorted_allocList+0xa2>
  8028a5:	83 ec 04             	sub    $0x4,%esp
  8028a8:	68 e4 41 80 00       	push   $0x8041e4
  8028ad:	6a 6d                	push   $0x6d
  8028af:	68 07 42 80 00       	push   $0x804207
  8028b4:	e8 c7 de ff ff       	call   800780 <_panic>
  8028b9:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	89 10                	mov    %edx,(%eax)
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	8b 00                	mov    (%eax),%eax
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	74 0d                	je     8028da <insert_sorted_allocList+0xc3>
  8028cd:	a1 40 50 80 00       	mov    0x805040,%eax
  8028d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d5:	89 50 04             	mov    %edx,0x4(%eax)
  8028d8:	eb 08                	jmp    8028e2 <insert_sorted_allocList+0xcb>
  8028da:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dd:	a3 44 50 80 00       	mov    %eax,0x805044
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	a3 40 50 80 00       	mov    %eax,0x805040
  8028ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028f9:	40                   	inc    %eax
  8028fa:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8028ff:	a1 40 50 80 00       	mov    0x805040,%eax
  802904:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802907:	e9 b9 01 00 00       	jmp    802ac5 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	8b 50 08             	mov    0x8(%eax),%edx
  802912:	a1 40 50 80 00       	mov    0x805040,%eax
  802917:	8b 40 08             	mov    0x8(%eax),%eax
  80291a:	39 c2                	cmp    %eax,%edx
  80291c:	76 7c                	jbe    80299a <insert_sorted_allocList+0x183>
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	8b 50 08             	mov    0x8(%eax),%edx
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	8b 40 08             	mov    0x8(%eax),%eax
  80292a:	39 c2                	cmp    %eax,%edx
  80292c:	73 6c                	jae    80299a <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80292e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802932:	74 06                	je     80293a <insert_sorted_allocList+0x123>
  802934:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802938:	75 14                	jne    80294e <insert_sorted_allocList+0x137>
  80293a:	83 ec 04             	sub    $0x4,%esp
  80293d:	68 20 42 80 00       	push   $0x804220
  802942:	6a 75                	push   $0x75
  802944:	68 07 42 80 00       	push   $0x804207
  802949:	e8 32 de ff ff       	call   800780 <_panic>
  80294e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802951:	8b 50 04             	mov    0x4(%eax),%edx
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	89 50 04             	mov    %edx,0x4(%eax)
  80295a:	8b 45 08             	mov    0x8(%ebp),%eax
  80295d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802960:	89 10                	mov    %edx,(%eax)
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 40 04             	mov    0x4(%eax),%eax
  802968:	85 c0                	test   %eax,%eax
  80296a:	74 0d                	je     802979 <insert_sorted_allocList+0x162>
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 40 04             	mov    0x4(%eax),%eax
  802972:	8b 55 08             	mov    0x8(%ebp),%edx
  802975:	89 10                	mov    %edx,(%eax)
  802977:	eb 08                	jmp    802981 <insert_sorted_allocList+0x16a>
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	a3 40 50 80 00       	mov    %eax,0x805040
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 55 08             	mov    0x8(%ebp),%edx
  802987:	89 50 04             	mov    %edx,0x4(%eax)
  80298a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80298f:	40                   	inc    %eax
  802990:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802995:	e9 59 01 00 00       	jmp    802af3 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	8b 50 08             	mov    0x8(%eax),%edx
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	8b 40 08             	mov    0x8(%eax),%eax
  8029a6:	39 c2                	cmp    %eax,%edx
  8029a8:	0f 86 98 00 00 00    	jbe    802a46 <insert_sorted_allocList+0x22f>
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	8b 50 08             	mov    0x8(%eax),%edx
  8029b4:	a1 44 50 80 00       	mov    0x805044,%eax
  8029b9:	8b 40 08             	mov    0x8(%eax),%eax
  8029bc:	39 c2                	cmp    %eax,%edx
  8029be:	0f 83 82 00 00 00    	jae    802a46 <insert_sorted_allocList+0x22f>
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 00                	mov    (%eax),%eax
  8029cf:	8b 40 08             	mov    0x8(%eax),%eax
  8029d2:	39 c2                	cmp    %eax,%edx
  8029d4:	73 70                	jae    802a46 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8029d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029da:	74 06                	je     8029e2 <insert_sorted_allocList+0x1cb>
  8029dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029e0:	75 14                	jne    8029f6 <insert_sorted_allocList+0x1df>
  8029e2:	83 ec 04             	sub    $0x4,%esp
  8029e5:	68 58 42 80 00       	push   $0x804258
  8029ea:	6a 7c                	push   $0x7c
  8029ec:	68 07 42 80 00       	push   $0x804207
  8029f1:	e8 8a dd ff ff       	call   800780 <_panic>
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 10                	mov    (%eax),%edx
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	89 10                	mov    %edx,(%eax)
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	8b 00                	mov    (%eax),%eax
  802a05:	85 c0                	test   %eax,%eax
  802a07:	74 0b                	je     802a14 <insert_sorted_allocList+0x1fd>
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a11:	89 50 04             	mov    %edx,0x4(%eax)
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1a:	89 10                	mov    %edx,(%eax)
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a22:	89 50 04             	mov    %edx,0x4(%eax)
  802a25:	8b 45 08             	mov    0x8(%ebp),%eax
  802a28:	8b 00                	mov    (%eax),%eax
  802a2a:	85 c0                	test   %eax,%eax
  802a2c:	75 08                	jne    802a36 <insert_sorted_allocList+0x21f>
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	a3 44 50 80 00       	mov    %eax,0x805044
  802a36:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a3b:	40                   	inc    %eax
  802a3c:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802a41:	e9 ad 00 00 00       	jmp    802af3 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	8b 50 08             	mov    0x8(%eax),%edx
  802a4c:	a1 44 50 80 00       	mov    0x805044,%eax
  802a51:	8b 40 08             	mov    0x8(%eax),%eax
  802a54:	39 c2                	cmp    %eax,%edx
  802a56:	76 65                	jbe    802abd <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802a58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a5c:	75 17                	jne    802a75 <insert_sorted_allocList+0x25e>
  802a5e:	83 ec 04             	sub    $0x4,%esp
  802a61:	68 8c 42 80 00       	push   $0x80428c
  802a66:	68 80 00 00 00       	push   $0x80
  802a6b:	68 07 42 80 00       	push   $0x804207
  802a70:	e8 0b dd ff ff       	call   800780 <_panic>
  802a75:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7e:	89 50 04             	mov    %edx,0x4(%eax)
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	8b 40 04             	mov    0x4(%eax),%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	74 0c                	je     802a97 <insert_sorted_allocList+0x280>
  802a8b:	a1 44 50 80 00       	mov    0x805044,%eax
  802a90:	8b 55 08             	mov    0x8(%ebp),%edx
  802a93:	89 10                	mov    %edx,(%eax)
  802a95:	eb 08                	jmp    802a9f <insert_sorted_allocList+0x288>
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	a3 40 50 80 00       	mov    %eax,0x805040
  802a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa2:	a3 44 50 80 00       	mov    %eax,0x805044
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ab5:	40                   	inc    %eax
  802ab6:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802abb:	eb 36                	jmp    802af3 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802abd:	a1 48 50 80 00       	mov    0x805048,%eax
  802ac2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac9:	74 07                	je     802ad2 <insert_sorted_allocList+0x2bb>
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	eb 05                	jmp    802ad7 <insert_sorted_allocList+0x2c0>
  802ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ad7:	a3 48 50 80 00       	mov    %eax,0x805048
  802adc:	a1 48 50 80 00       	mov    0x805048,%eax
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	0f 85 23 fe ff ff    	jne    80290c <insert_sorted_allocList+0xf5>
  802ae9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aed:	0f 85 19 fe ff ff    	jne    80290c <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802af3:	90                   	nop
  802af4:	c9                   	leave  
  802af5:	c3                   	ret    

00802af6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802af6:	55                   	push   %ebp
  802af7:	89 e5                	mov    %esp,%ebp
  802af9:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802afc:	a1 38 51 80 00       	mov    0x805138,%eax
  802b01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b04:	e9 7c 01 00 00       	jmp    802c85 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b12:	0f 85 90 00 00 00    	jne    802ba8 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802b1e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b22:	75 17                	jne    802b3b <alloc_block_FF+0x45>
  802b24:	83 ec 04             	sub    $0x4,%esp
  802b27:	68 af 42 80 00       	push   $0x8042af
  802b2c:	68 ba 00 00 00       	push   $0xba
  802b31:	68 07 42 80 00       	push   $0x804207
  802b36:	e8 45 dc ff ff       	call   800780 <_panic>
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	85 c0                	test   %eax,%eax
  802b42:	74 10                	je     802b54 <alloc_block_FF+0x5e>
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 00                	mov    (%eax),%eax
  802b49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b4c:	8b 52 04             	mov    0x4(%edx),%edx
  802b4f:	89 50 04             	mov    %edx,0x4(%eax)
  802b52:	eb 0b                	jmp    802b5f <alloc_block_FF+0x69>
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 40 04             	mov    0x4(%eax),%eax
  802b5a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 40 04             	mov    0x4(%eax),%eax
  802b65:	85 c0                	test   %eax,%eax
  802b67:	74 0f                	je     802b78 <alloc_block_FF+0x82>
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 40 04             	mov    0x4(%eax),%eax
  802b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b72:	8b 12                	mov    (%edx),%edx
  802b74:	89 10                	mov    %edx,(%eax)
  802b76:	eb 0a                	jmp    802b82 <alloc_block_FF+0x8c>
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 00                	mov    (%eax),%eax
  802b7d:	a3 38 51 80 00       	mov    %eax,0x805138
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b95:	a1 44 51 80 00       	mov    0x805144,%eax
  802b9a:	48                   	dec    %eax
  802b9b:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba3:	e9 10 01 00 00       	jmp    802cb8 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	8b 40 0c             	mov    0xc(%eax),%eax
  802bae:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb1:	0f 86 c6 00 00 00    	jbe    802c7d <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802bb7:	a1 48 51 80 00       	mov    0x805148,%eax
  802bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802bbf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802bc3:	75 17                	jne    802bdc <alloc_block_FF+0xe6>
  802bc5:	83 ec 04             	sub    $0x4,%esp
  802bc8:	68 af 42 80 00       	push   $0x8042af
  802bcd:	68 c2 00 00 00       	push   $0xc2
  802bd2:	68 07 42 80 00       	push   $0x804207
  802bd7:	e8 a4 db ff ff       	call   800780 <_panic>
  802bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	85 c0                	test   %eax,%eax
  802be3:	74 10                	je     802bf5 <alloc_block_FF+0xff>
  802be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be8:	8b 00                	mov    (%eax),%eax
  802bea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bed:	8b 52 04             	mov    0x4(%edx),%edx
  802bf0:	89 50 04             	mov    %edx,0x4(%eax)
  802bf3:	eb 0b                	jmp    802c00 <alloc_block_FF+0x10a>
  802bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf8:	8b 40 04             	mov    0x4(%eax),%eax
  802bfb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c03:	8b 40 04             	mov    0x4(%eax),%eax
  802c06:	85 c0                	test   %eax,%eax
  802c08:	74 0f                	je     802c19 <alloc_block_FF+0x123>
  802c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c0d:	8b 40 04             	mov    0x4(%eax),%eax
  802c10:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c13:	8b 12                	mov    (%edx),%edx
  802c15:	89 10                	mov    %edx,(%eax)
  802c17:	eb 0a                	jmp    802c23 <alloc_block_FF+0x12d>
  802c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1c:	8b 00                	mov    (%eax),%eax
  802c1e:	a3 48 51 80 00       	mov    %eax,0x805148
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c36:	a1 54 51 80 00       	mov    0x805154,%eax
  802c3b:	48                   	dec    %eax
  802c3c:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 50 08             	mov    0x8(%eax),%edx
  802c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4a:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c50:	8b 55 08             	mov    0x8(%ebp),%edx
  802c53:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5c:	2b 45 08             	sub    0x8(%ebp),%eax
  802c5f:	89 c2                	mov    %eax,%edx
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	8b 50 08             	mov    0x8(%eax),%edx
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	01 c2                	add    %eax,%edx
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7b:	eb 3b                	jmp    802cb8 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802c7d:	a1 40 51 80 00       	mov    0x805140,%eax
  802c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c89:	74 07                	je     802c92 <alloc_block_FF+0x19c>
  802c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8e:	8b 00                	mov    (%eax),%eax
  802c90:	eb 05                	jmp    802c97 <alloc_block_FF+0x1a1>
  802c92:	b8 00 00 00 00       	mov    $0x0,%eax
  802c97:	a3 40 51 80 00       	mov    %eax,0x805140
  802c9c:	a1 40 51 80 00       	mov    0x805140,%eax
  802ca1:	85 c0                	test   %eax,%eax
  802ca3:	0f 85 60 fe ff ff    	jne    802b09 <alloc_block_FF+0x13>
  802ca9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cad:	0f 85 56 fe ff ff    	jne    802b09 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802cb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cb8:	c9                   	leave  
  802cb9:	c3                   	ret    

00802cba <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802cba:	55                   	push   %ebp
  802cbb:	89 e5                	mov    %esp,%ebp
  802cbd:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802cc0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802cc7:	a1 38 51 80 00       	mov    0x805138,%eax
  802ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ccf:	eb 3a                	jmp    802d0b <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cda:	72 27                	jb     802d03 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802cdc:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802ce0:	75 0b                	jne    802ced <alloc_block_BF+0x33>
					best_size= element->size;
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802ceb:	eb 16                	jmp    802d03 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 50 0c             	mov    0xc(%eax),%edx
  802cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf6:	39 c2                	cmp    %eax,%edx
  802cf8:	77 09                	ja     802d03 <alloc_block_BF+0x49>
					best_size=element->size;
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	8b 40 0c             	mov    0xc(%eax),%eax
  802d00:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802d03:	a1 40 51 80 00       	mov    0x805140,%eax
  802d08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0f:	74 07                	je     802d18 <alloc_block_BF+0x5e>
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	8b 00                	mov    (%eax),%eax
  802d16:	eb 05                	jmp    802d1d <alloc_block_BF+0x63>
  802d18:	b8 00 00 00 00       	mov    $0x0,%eax
  802d1d:	a3 40 51 80 00       	mov    %eax,0x805140
  802d22:	a1 40 51 80 00       	mov    0x805140,%eax
  802d27:	85 c0                	test   %eax,%eax
  802d29:	75 a6                	jne    802cd1 <alloc_block_BF+0x17>
  802d2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2f:	75 a0                	jne    802cd1 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802d31:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802d35:	0f 84 d3 01 00 00    	je     802f0e <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802d3b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d43:	e9 98 01 00 00       	jmp    802ee0 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802d48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d4e:	0f 86 da 00 00 00    	jbe    802e2e <alloc_block_BF+0x174>
  802d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d57:	8b 50 0c             	mov    0xc(%eax),%edx
  802d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5d:	39 c2                	cmp    %eax,%edx
  802d5f:	0f 85 c9 00 00 00    	jne    802e2e <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802d65:	a1 48 51 80 00       	mov    0x805148,%eax
  802d6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802d6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d71:	75 17                	jne    802d8a <alloc_block_BF+0xd0>
  802d73:	83 ec 04             	sub    $0x4,%esp
  802d76:	68 af 42 80 00       	push   $0x8042af
  802d7b:	68 ea 00 00 00       	push   $0xea
  802d80:	68 07 42 80 00       	push   $0x804207
  802d85:	e8 f6 d9 ff ff       	call   800780 <_panic>
  802d8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8d:	8b 00                	mov    (%eax),%eax
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	74 10                	je     802da3 <alloc_block_BF+0xe9>
  802d93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d96:	8b 00                	mov    (%eax),%eax
  802d98:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d9b:	8b 52 04             	mov    0x4(%edx),%edx
  802d9e:	89 50 04             	mov    %edx,0x4(%eax)
  802da1:	eb 0b                	jmp    802dae <alloc_block_BF+0xf4>
  802da3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da6:	8b 40 04             	mov    0x4(%eax),%eax
  802da9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db1:	8b 40 04             	mov    0x4(%eax),%eax
  802db4:	85 c0                	test   %eax,%eax
  802db6:	74 0f                	je     802dc7 <alloc_block_BF+0x10d>
  802db8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbb:	8b 40 04             	mov    0x4(%eax),%eax
  802dbe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dc1:	8b 12                	mov    (%edx),%edx
  802dc3:	89 10                	mov    %edx,(%eax)
  802dc5:	eb 0a                	jmp    802dd1 <alloc_block_BF+0x117>
  802dc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dca:	8b 00                	mov    (%eax),%eax
  802dcc:	a3 48 51 80 00       	mov    %eax,0x805148
  802dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de4:	a1 54 51 80 00       	mov    0x805154,%eax
  802de9:	48                   	dec    %eax
  802dea:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	8b 50 08             	mov    0x8(%eax),%edx
  802df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df8:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  802e01:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0a:	2b 45 08             	sub    0x8(%ebp),%eax
  802e0d:	89 c2                	mov    %eax,%edx
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e12:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	8b 50 08             	mov    0x8(%eax),%edx
  802e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1e:	01 c2                	add    %eax,%edx
  802e20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e23:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802e26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e29:	e9 e5 00 00 00       	jmp    802f13 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 50 0c             	mov    0xc(%eax),%edx
  802e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e37:	39 c2                	cmp    %eax,%edx
  802e39:	0f 85 99 00 00 00    	jne    802ed8 <alloc_block_BF+0x21e>
  802e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e42:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e45:	0f 85 8d 00 00 00    	jne    802ed8 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802e51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e55:	75 17                	jne    802e6e <alloc_block_BF+0x1b4>
  802e57:	83 ec 04             	sub    $0x4,%esp
  802e5a:	68 af 42 80 00       	push   $0x8042af
  802e5f:	68 f7 00 00 00       	push   $0xf7
  802e64:	68 07 42 80 00       	push   $0x804207
  802e69:	e8 12 d9 ff ff       	call   800780 <_panic>
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	8b 00                	mov    (%eax),%eax
  802e73:	85 c0                	test   %eax,%eax
  802e75:	74 10                	je     802e87 <alloc_block_BF+0x1cd>
  802e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7f:	8b 52 04             	mov    0x4(%edx),%edx
  802e82:	89 50 04             	mov    %edx,0x4(%eax)
  802e85:	eb 0b                	jmp    802e92 <alloc_block_BF+0x1d8>
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 40 04             	mov    0x4(%eax),%eax
  802e8d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 40 04             	mov    0x4(%eax),%eax
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	74 0f                	je     802eab <alloc_block_BF+0x1f1>
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ea2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea5:	8b 12                	mov    (%edx),%edx
  802ea7:	89 10                	mov    %edx,(%eax)
  802ea9:	eb 0a                	jmp    802eb5 <alloc_block_BF+0x1fb>
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 00                	mov    (%eax),%eax
  802eb0:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec8:	a1 44 51 80 00       	mov    0x805144,%eax
  802ecd:	48                   	dec    %eax
  802ece:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802ed3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed6:	eb 3b                	jmp    802f13 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802ed8:	a1 40 51 80 00       	mov    0x805140,%eax
  802edd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee4:	74 07                	je     802eed <alloc_block_BF+0x233>
  802ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee9:	8b 00                	mov    (%eax),%eax
  802eeb:	eb 05                	jmp    802ef2 <alloc_block_BF+0x238>
  802eed:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef2:	a3 40 51 80 00       	mov    %eax,0x805140
  802ef7:	a1 40 51 80 00       	mov    0x805140,%eax
  802efc:	85 c0                	test   %eax,%eax
  802efe:	0f 85 44 fe ff ff    	jne    802d48 <alloc_block_BF+0x8e>
  802f04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f08:	0f 85 3a fe ff ff    	jne    802d48 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802f0e:	b8 00 00 00 00       	mov    $0x0,%eax
  802f13:	c9                   	leave  
  802f14:	c3                   	ret    

00802f15 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802f15:	55                   	push   %ebp
  802f16:	89 e5                	mov    %esp,%ebp
  802f18:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802f1b:	83 ec 04             	sub    $0x4,%esp
  802f1e:	68 d0 42 80 00       	push   $0x8042d0
  802f23:	68 04 01 00 00       	push   $0x104
  802f28:	68 07 42 80 00       	push   $0x804207
  802f2d:	e8 4e d8 ff ff       	call   800780 <_panic>

00802f32 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802f32:	55                   	push   %ebp
  802f33:	89 e5                	mov    %esp,%ebp
  802f35:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802f38:	a1 38 51 80 00       	mov    0x805138,%eax
  802f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802f40:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f45:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802f48:	a1 38 51 80 00       	mov    0x805138,%eax
  802f4d:	85 c0                	test   %eax,%eax
  802f4f:	75 68                	jne    802fb9 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802f51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f55:	75 17                	jne    802f6e <insert_sorted_with_merge_freeList+0x3c>
  802f57:	83 ec 04             	sub    $0x4,%esp
  802f5a:	68 e4 41 80 00       	push   $0x8041e4
  802f5f:	68 14 01 00 00       	push   $0x114
  802f64:	68 07 42 80 00       	push   $0x804207
  802f69:	e8 12 d8 ff ff       	call   800780 <_panic>
  802f6e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	89 10                	mov    %edx,(%eax)
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	85 c0                	test   %eax,%eax
  802f80:	74 0d                	je     802f8f <insert_sorted_with_merge_freeList+0x5d>
  802f82:	a1 38 51 80 00       	mov    0x805138,%eax
  802f87:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8a:	89 50 04             	mov    %edx,0x4(%eax)
  802f8d:	eb 08                	jmp    802f97 <insert_sorted_with_merge_freeList+0x65>
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	a3 38 51 80 00       	mov    %eax,0x805138
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa9:	a1 44 51 80 00       	mov    0x805144,%eax
  802fae:	40                   	inc    %eax
  802faf:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802fb4:	e9 d2 06 00 00       	jmp    80368b <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	8b 50 08             	mov    0x8(%eax),%edx
  802fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc2:	8b 40 08             	mov    0x8(%eax),%eax
  802fc5:	39 c2                	cmp    %eax,%edx
  802fc7:	0f 83 22 01 00 00    	jae    8030ef <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd0:	8b 50 08             	mov    0x8(%eax),%edx
  802fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fd9:	01 c2                	add    %eax,%edx
  802fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fde:	8b 40 08             	mov    0x8(%eax),%eax
  802fe1:	39 c2                	cmp    %eax,%edx
  802fe3:	0f 85 9e 00 00 00    	jne    803087 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	8b 50 08             	mov    0x8(%eax),%edx
  802fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff2:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff8:	8b 50 0c             	mov    0xc(%eax),%edx
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	8b 40 0c             	mov    0xc(%eax),%eax
  803001:	01 c2                	add    %eax,%edx
  803003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803006:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	8b 50 08             	mov    0x8(%eax),%edx
  803019:	8b 45 08             	mov    0x8(%ebp),%eax
  80301c:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80301f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803023:	75 17                	jne    80303c <insert_sorted_with_merge_freeList+0x10a>
  803025:	83 ec 04             	sub    $0x4,%esp
  803028:	68 e4 41 80 00       	push   $0x8041e4
  80302d:	68 21 01 00 00       	push   $0x121
  803032:	68 07 42 80 00       	push   $0x804207
  803037:	e8 44 d7 ff ff       	call   800780 <_panic>
  80303c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	89 10                	mov    %edx,(%eax)
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	8b 00                	mov    (%eax),%eax
  80304c:	85 c0                	test   %eax,%eax
  80304e:	74 0d                	je     80305d <insert_sorted_with_merge_freeList+0x12b>
  803050:	a1 48 51 80 00       	mov    0x805148,%eax
  803055:	8b 55 08             	mov    0x8(%ebp),%edx
  803058:	89 50 04             	mov    %edx,0x4(%eax)
  80305b:	eb 08                	jmp    803065 <insert_sorted_with_merge_freeList+0x133>
  80305d:	8b 45 08             	mov    0x8(%ebp),%eax
  803060:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	a3 48 51 80 00       	mov    %eax,0x805148
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803077:	a1 54 51 80 00       	mov    0x805154,%eax
  80307c:	40                   	inc    %eax
  80307d:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803082:	e9 04 06 00 00       	jmp    80368b <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803087:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80308b:	75 17                	jne    8030a4 <insert_sorted_with_merge_freeList+0x172>
  80308d:	83 ec 04             	sub    $0x4,%esp
  803090:	68 e4 41 80 00       	push   $0x8041e4
  803095:	68 26 01 00 00       	push   $0x126
  80309a:	68 07 42 80 00       	push   $0x804207
  80309f:	e8 dc d6 ff ff       	call   800780 <_panic>
  8030a4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	89 10                	mov    %edx,(%eax)
  8030af:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b2:	8b 00                	mov    (%eax),%eax
  8030b4:	85 c0                	test   %eax,%eax
  8030b6:	74 0d                	je     8030c5 <insert_sorted_with_merge_freeList+0x193>
  8030b8:	a1 38 51 80 00       	mov    0x805138,%eax
  8030bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c0:	89 50 04             	mov    %edx,0x4(%eax)
  8030c3:	eb 08                	jmp    8030cd <insert_sorted_with_merge_freeList+0x19b>
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	a3 38 51 80 00       	mov    %eax,0x805138
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030df:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e4:	40                   	inc    %eax
  8030e5:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8030ea:	e9 9c 05 00 00       	jmp    80368b <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	8b 50 08             	mov    0x8(%eax),%edx
  8030f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f8:	8b 40 08             	mov    0x8(%eax),%eax
  8030fb:	39 c2                	cmp    %eax,%edx
  8030fd:	0f 86 16 01 00 00    	jbe    803219 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803106:	8b 50 08             	mov    0x8(%eax),%edx
  803109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310c:	8b 40 0c             	mov    0xc(%eax),%eax
  80310f:	01 c2                	add    %eax,%edx
  803111:	8b 45 08             	mov    0x8(%ebp),%eax
  803114:	8b 40 08             	mov    0x8(%eax),%eax
  803117:	39 c2                	cmp    %eax,%edx
  803119:	0f 85 92 00 00 00    	jne    8031b1 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  80311f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803122:	8b 50 0c             	mov    0xc(%eax),%edx
  803125:	8b 45 08             	mov    0x8(%ebp),%eax
  803128:	8b 40 0c             	mov    0xc(%eax),%eax
  80312b:	01 c2                	add    %eax,%edx
  80312d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803130:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  803133:	8b 45 08             	mov    0x8(%ebp),%eax
  803136:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	8b 50 08             	mov    0x8(%eax),%edx
  803143:	8b 45 08             	mov    0x8(%ebp),%eax
  803146:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803149:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80314d:	75 17                	jne    803166 <insert_sorted_with_merge_freeList+0x234>
  80314f:	83 ec 04             	sub    $0x4,%esp
  803152:	68 e4 41 80 00       	push   $0x8041e4
  803157:	68 31 01 00 00       	push   $0x131
  80315c:	68 07 42 80 00       	push   $0x804207
  803161:	e8 1a d6 ff ff       	call   800780 <_panic>
  803166:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80316c:	8b 45 08             	mov    0x8(%ebp),%eax
  80316f:	89 10                	mov    %edx,(%eax)
  803171:	8b 45 08             	mov    0x8(%ebp),%eax
  803174:	8b 00                	mov    (%eax),%eax
  803176:	85 c0                	test   %eax,%eax
  803178:	74 0d                	je     803187 <insert_sorted_with_merge_freeList+0x255>
  80317a:	a1 48 51 80 00       	mov    0x805148,%eax
  80317f:	8b 55 08             	mov    0x8(%ebp),%edx
  803182:	89 50 04             	mov    %edx,0x4(%eax)
  803185:	eb 08                	jmp    80318f <insert_sorted_with_merge_freeList+0x25d>
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	a3 48 51 80 00       	mov    %eax,0x805148
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a1:	a1 54 51 80 00       	mov    0x805154,%eax
  8031a6:	40                   	inc    %eax
  8031a7:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8031ac:	e9 da 04 00 00       	jmp    80368b <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  8031b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b5:	75 17                	jne    8031ce <insert_sorted_with_merge_freeList+0x29c>
  8031b7:	83 ec 04             	sub    $0x4,%esp
  8031ba:	68 8c 42 80 00       	push   $0x80428c
  8031bf:	68 37 01 00 00       	push   $0x137
  8031c4:	68 07 42 80 00       	push   $0x804207
  8031c9:	e8 b2 d5 ff ff       	call   800780 <_panic>
  8031ce:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	89 50 04             	mov    %edx,0x4(%eax)
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	8b 40 04             	mov    0x4(%eax),%eax
  8031e0:	85 c0                	test   %eax,%eax
  8031e2:	74 0c                	je     8031f0 <insert_sorted_with_merge_freeList+0x2be>
  8031e4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ec:	89 10                	mov    %edx,(%eax)
  8031ee:	eb 08                	jmp    8031f8 <insert_sorted_with_merge_freeList+0x2c6>
  8031f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f3:	a3 38 51 80 00       	mov    %eax,0x805138
  8031f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803209:	a1 44 51 80 00       	mov    0x805144,%eax
  80320e:	40                   	inc    %eax
  80320f:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803214:	e9 72 04 00 00       	jmp    80368b <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803219:	a1 38 51 80 00       	mov    0x805138,%eax
  80321e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803221:	e9 35 04 00 00       	jmp    80365b <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  803226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803229:	8b 00                	mov    (%eax),%eax
  80322b:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  80322e:	8b 45 08             	mov    0x8(%ebp),%eax
  803231:	8b 50 08             	mov    0x8(%eax),%edx
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	8b 40 08             	mov    0x8(%eax),%eax
  80323a:	39 c2                	cmp    %eax,%edx
  80323c:	0f 86 11 04 00 00    	jbe    803653 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803242:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803245:	8b 50 08             	mov    0x8(%eax),%edx
  803248:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324b:	8b 40 0c             	mov    0xc(%eax),%eax
  80324e:	01 c2                	add    %eax,%edx
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	8b 40 08             	mov    0x8(%eax),%eax
  803256:	39 c2                	cmp    %eax,%edx
  803258:	0f 83 8b 00 00 00    	jae    8032e9 <insert_sorted_with_merge_freeList+0x3b7>
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	8b 50 08             	mov    0x8(%eax),%edx
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	8b 40 0c             	mov    0xc(%eax),%eax
  80326a:	01 c2                	add    %eax,%edx
  80326c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80326f:	8b 40 08             	mov    0x8(%eax),%eax
  803272:	39 c2                	cmp    %eax,%edx
  803274:	73 73                	jae    8032e9 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  803276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327a:	74 06                	je     803282 <insert_sorted_with_merge_freeList+0x350>
  80327c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803280:	75 17                	jne    803299 <insert_sorted_with_merge_freeList+0x367>
  803282:	83 ec 04             	sub    $0x4,%esp
  803285:	68 58 42 80 00       	push   $0x804258
  80328a:	68 48 01 00 00       	push   $0x148
  80328f:	68 07 42 80 00       	push   $0x804207
  803294:	e8 e7 d4 ff ff       	call   800780 <_panic>
  803299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329c:	8b 10                	mov    (%eax),%edx
  80329e:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a1:	89 10                	mov    %edx,(%eax)
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	8b 00                	mov    (%eax),%eax
  8032a8:	85 c0                	test   %eax,%eax
  8032aa:	74 0b                	je     8032b7 <insert_sorted_with_merge_freeList+0x385>
  8032ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032af:	8b 00                	mov    (%eax),%eax
  8032b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b4:	89 50 04             	mov    %edx,0x4(%eax)
  8032b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bd:	89 10                	mov    %edx,(%eax)
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032c5:	89 50 04             	mov    %edx,0x4(%eax)
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	8b 00                	mov    (%eax),%eax
  8032cd:	85 c0                	test   %eax,%eax
  8032cf:	75 08                	jne    8032d9 <insert_sorted_with_merge_freeList+0x3a7>
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032d9:	a1 44 51 80 00       	mov    0x805144,%eax
  8032de:	40                   	inc    %eax
  8032df:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  8032e4:	e9 a2 03 00 00       	jmp    80368b <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	8b 50 08             	mov    0x8(%eax),%edx
  8032ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032f5:	01 c2                	add    %eax,%edx
  8032f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032fa:	8b 40 08             	mov    0x8(%eax),%eax
  8032fd:	39 c2                	cmp    %eax,%edx
  8032ff:	0f 83 ae 00 00 00    	jae    8033b3 <insert_sorted_with_merge_freeList+0x481>
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	8b 50 08             	mov    0x8(%eax),%edx
  80330b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330e:	8b 48 08             	mov    0x8(%eax),%ecx
  803311:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803314:	8b 40 0c             	mov    0xc(%eax),%eax
  803317:	01 c8                	add    %ecx,%eax
  803319:	39 c2                	cmp    %eax,%edx
  80331b:	0f 85 92 00 00 00    	jne    8033b3 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  803321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803324:	8b 50 0c             	mov    0xc(%eax),%edx
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	8b 40 0c             	mov    0xc(%eax),%eax
  80332d:	01 c2                	add    %eax,%edx
  80332f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803332:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803335:	8b 45 08             	mov    0x8(%ebp),%eax
  803338:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	8b 50 08             	mov    0x8(%eax),%edx
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80334b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80334f:	75 17                	jne    803368 <insert_sorted_with_merge_freeList+0x436>
  803351:	83 ec 04             	sub    $0x4,%esp
  803354:	68 e4 41 80 00       	push   $0x8041e4
  803359:	68 51 01 00 00       	push   $0x151
  80335e:	68 07 42 80 00       	push   $0x804207
  803363:	e8 18 d4 ff ff       	call   800780 <_panic>
  803368:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80336e:	8b 45 08             	mov    0x8(%ebp),%eax
  803371:	89 10                	mov    %edx,(%eax)
  803373:	8b 45 08             	mov    0x8(%ebp),%eax
  803376:	8b 00                	mov    (%eax),%eax
  803378:	85 c0                	test   %eax,%eax
  80337a:	74 0d                	je     803389 <insert_sorted_with_merge_freeList+0x457>
  80337c:	a1 48 51 80 00       	mov    0x805148,%eax
  803381:	8b 55 08             	mov    0x8(%ebp),%edx
  803384:	89 50 04             	mov    %edx,0x4(%eax)
  803387:	eb 08                	jmp    803391 <insert_sorted_with_merge_freeList+0x45f>
  803389:	8b 45 08             	mov    0x8(%ebp),%eax
  80338c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803391:	8b 45 08             	mov    0x8(%ebp),%eax
  803394:	a3 48 51 80 00       	mov    %eax,0x805148
  803399:	8b 45 08             	mov    0x8(%ebp),%eax
  80339c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a3:	a1 54 51 80 00       	mov    0x805154,%eax
  8033a8:	40                   	inc    %eax
  8033a9:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  8033ae:	e9 d8 02 00 00       	jmp    80368b <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  8033b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b6:	8b 50 08             	mov    0x8(%eax),%edx
  8033b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033bf:	01 c2                	add    %eax,%edx
  8033c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c4:	8b 40 08             	mov    0x8(%eax),%eax
  8033c7:	39 c2                	cmp    %eax,%edx
  8033c9:	0f 85 ba 00 00 00    	jne    803489 <insert_sorted_with_merge_freeList+0x557>
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	8b 50 08             	mov    0x8(%eax),%edx
  8033d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d8:	8b 48 08             	mov    0x8(%eax),%ecx
  8033db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033de:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e1:	01 c8                	add    %ecx,%eax
  8033e3:	39 c2                	cmp    %eax,%edx
  8033e5:	0f 86 9e 00 00 00    	jbe    803489 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  8033eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ee:	8b 50 0c             	mov    0xc(%eax),%edx
  8033f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f7:	01 c2                	add    %eax,%edx
  8033f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033fc:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	8b 50 08             	mov    0x8(%eax),%edx
  803405:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803408:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  80340b:	8b 45 08             	mov    0x8(%ebp),%eax
  80340e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803415:	8b 45 08             	mov    0x8(%ebp),%eax
  803418:	8b 50 08             	mov    0x8(%eax),%edx
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803421:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803425:	75 17                	jne    80343e <insert_sorted_with_merge_freeList+0x50c>
  803427:	83 ec 04             	sub    $0x4,%esp
  80342a:	68 e4 41 80 00       	push   $0x8041e4
  80342f:	68 5b 01 00 00       	push   $0x15b
  803434:	68 07 42 80 00       	push   $0x804207
  803439:	e8 42 d3 ff ff       	call   800780 <_panic>
  80343e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803444:	8b 45 08             	mov    0x8(%ebp),%eax
  803447:	89 10                	mov    %edx,(%eax)
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	8b 00                	mov    (%eax),%eax
  80344e:	85 c0                	test   %eax,%eax
  803450:	74 0d                	je     80345f <insert_sorted_with_merge_freeList+0x52d>
  803452:	a1 48 51 80 00       	mov    0x805148,%eax
  803457:	8b 55 08             	mov    0x8(%ebp),%edx
  80345a:	89 50 04             	mov    %edx,0x4(%eax)
  80345d:	eb 08                	jmp    803467 <insert_sorted_with_merge_freeList+0x535>
  80345f:	8b 45 08             	mov    0x8(%ebp),%eax
  803462:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803467:	8b 45 08             	mov    0x8(%ebp),%eax
  80346a:	a3 48 51 80 00       	mov    %eax,0x805148
  80346f:	8b 45 08             	mov    0x8(%ebp),%eax
  803472:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803479:	a1 54 51 80 00       	mov    0x805154,%eax
  80347e:	40                   	inc    %eax
  80347f:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803484:	e9 02 02 00 00       	jmp    80368b <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	8b 50 08             	mov    0x8(%eax),%edx
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	8b 40 0c             	mov    0xc(%eax),%eax
  803495:	01 c2                	add    %eax,%edx
  803497:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349a:	8b 40 08             	mov    0x8(%eax),%eax
  80349d:	39 c2                	cmp    %eax,%edx
  80349f:	0f 85 ae 01 00 00    	jne    803653 <insert_sorted_with_merge_freeList+0x721>
  8034a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a8:	8b 50 08             	mov    0x8(%eax),%edx
  8034ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ae:	8b 48 08             	mov    0x8(%eax),%ecx
  8034b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b7:	01 c8                	add    %ecx,%eax
  8034b9:	39 c2                	cmp    %eax,%edx
  8034bb:	0f 85 92 01 00 00    	jne    803653 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  8034c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8034c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8034cd:	01 c2                	add    %eax,%edx
  8034cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d5:	01 c2                	add    %eax,%edx
  8034d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034da:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  8034dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8034e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ea:	8b 50 08             	mov    0x8(%eax),%edx
  8034ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f0:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  8034f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8034fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803500:	8b 50 08             	mov    0x8(%eax),%edx
  803503:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803506:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803509:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80350d:	75 17                	jne    803526 <insert_sorted_with_merge_freeList+0x5f4>
  80350f:	83 ec 04             	sub    $0x4,%esp
  803512:	68 af 42 80 00       	push   $0x8042af
  803517:	68 63 01 00 00       	push   $0x163
  80351c:	68 07 42 80 00       	push   $0x804207
  803521:	e8 5a d2 ff ff       	call   800780 <_panic>
  803526:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803529:	8b 00                	mov    (%eax),%eax
  80352b:	85 c0                	test   %eax,%eax
  80352d:	74 10                	je     80353f <insert_sorted_with_merge_freeList+0x60d>
  80352f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803532:	8b 00                	mov    (%eax),%eax
  803534:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803537:	8b 52 04             	mov    0x4(%edx),%edx
  80353a:	89 50 04             	mov    %edx,0x4(%eax)
  80353d:	eb 0b                	jmp    80354a <insert_sorted_with_merge_freeList+0x618>
  80353f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803542:	8b 40 04             	mov    0x4(%eax),%eax
  803545:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80354a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80354d:	8b 40 04             	mov    0x4(%eax),%eax
  803550:	85 c0                	test   %eax,%eax
  803552:	74 0f                	je     803563 <insert_sorted_with_merge_freeList+0x631>
  803554:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803557:	8b 40 04             	mov    0x4(%eax),%eax
  80355a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80355d:	8b 12                	mov    (%edx),%edx
  80355f:	89 10                	mov    %edx,(%eax)
  803561:	eb 0a                	jmp    80356d <insert_sorted_with_merge_freeList+0x63b>
  803563:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803566:	8b 00                	mov    (%eax),%eax
  803568:	a3 38 51 80 00       	mov    %eax,0x805138
  80356d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803570:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803576:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803579:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803580:	a1 44 51 80 00       	mov    0x805144,%eax
  803585:	48                   	dec    %eax
  803586:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  80358b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80358f:	75 17                	jne    8035a8 <insert_sorted_with_merge_freeList+0x676>
  803591:	83 ec 04             	sub    $0x4,%esp
  803594:	68 e4 41 80 00       	push   $0x8041e4
  803599:	68 64 01 00 00       	push   $0x164
  80359e:	68 07 42 80 00       	push   $0x804207
  8035a3:	e8 d8 d1 ff ff       	call   800780 <_panic>
  8035a8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b1:	89 10                	mov    %edx,(%eax)
  8035b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b6:	8b 00                	mov    (%eax),%eax
  8035b8:	85 c0                	test   %eax,%eax
  8035ba:	74 0d                	je     8035c9 <insert_sorted_with_merge_freeList+0x697>
  8035bc:	a1 48 51 80 00       	mov    0x805148,%eax
  8035c1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8035c4:	89 50 04             	mov    %edx,0x4(%eax)
  8035c7:	eb 08                	jmp    8035d1 <insert_sorted_with_merge_freeList+0x69f>
  8035c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035cc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035d4:	a3 48 51 80 00       	mov    %eax,0x805148
  8035d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035e3:	a1 54 51 80 00       	mov    0x805154,%eax
  8035e8:	40                   	inc    %eax
  8035e9:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8035ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035f2:	75 17                	jne    80360b <insert_sorted_with_merge_freeList+0x6d9>
  8035f4:	83 ec 04             	sub    $0x4,%esp
  8035f7:	68 e4 41 80 00       	push   $0x8041e4
  8035fc:	68 65 01 00 00       	push   $0x165
  803601:	68 07 42 80 00       	push   $0x804207
  803606:	e8 75 d1 ff ff       	call   800780 <_panic>
  80360b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803611:	8b 45 08             	mov    0x8(%ebp),%eax
  803614:	89 10                	mov    %edx,(%eax)
  803616:	8b 45 08             	mov    0x8(%ebp),%eax
  803619:	8b 00                	mov    (%eax),%eax
  80361b:	85 c0                	test   %eax,%eax
  80361d:	74 0d                	je     80362c <insert_sorted_with_merge_freeList+0x6fa>
  80361f:	a1 48 51 80 00       	mov    0x805148,%eax
  803624:	8b 55 08             	mov    0x8(%ebp),%edx
  803627:	89 50 04             	mov    %edx,0x4(%eax)
  80362a:	eb 08                	jmp    803634 <insert_sorted_with_merge_freeList+0x702>
  80362c:	8b 45 08             	mov    0x8(%ebp),%eax
  80362f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803634:	8b 45 08             	mov    0x8(%ebp),%eax
  803637:	a3 48 51 80 00       	mov    %eax,0x805148
  80363c:	8b 45 08             	mov    0x8(%ebp),%eax
  80363f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803646:	a1 54 51 80 00       	mov    0x805154,%eax
  80364b:	40                   	inc    %eax
  80364c:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803651:	eb 38                	jmp    80368b <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803653:	a1 40 51 80 00       	mov    0x805140,%eax
  803658:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80365b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80365f:	74 07                	je     803668 <insert_sorted_with_merge_freeList+0x736>
  803661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803664:	8b 00                	mov    (%eax),%eax
  803666:	eb 05                	jmp    80366d <insert_sorted_with_merge_freeList+0x73b>
  803668:	b8 00 00 00 00       	mov    $0x0,%eax
  80366d:	a3 40 51 80 00       	mov    %eax,0x805140
  803672:	a1 40 51 80 00       	mov    0x805140,%eax
  803677:	85 c0                	test   %eax,%eax
  803679:	0f 85 a7 fb ff ff    	jne    803226 <insert_sorted_with_merge_freeList+0x2f4>
  80367f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803683:	0f 85 9d fb ff ff    	jne    803226 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  803689:	eb 00                	jmp    80368b <insert_sorted_with_merge_freeList+0x759>
  80368b:	90                   	nop
  80368c:	c9                   	leave  
  80368d:	c3                   	ret    
  80368e:	66 90                	xchg   %ax,%ax

00803690 <__udivdi3>:
  803690:	55                   	push   %ebp
  803691:	57                   	push   %edi
  803692:	56                   	push   %esi
  803693:	53                   	push   %ebx
  803694:	83 ec 1c             	sub    $0x1c,%esp
  803697:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80369b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80369f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036a7:	89 ca                	mov    %ecx,%edx
  8036a9:	89 f8                	mov    %edi,%eax
  8036ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036af:	85 f6                	test   %esi,%esi
  8036b1:	75 2d                	jne    8036e0 <__udivdi3+0x50>
  8036b3:	39 cf                	cmp    %ecx,%edi
  8036b5:	77 65                	ja     80371c <__udivdi3+0x8c>
  8036b7:	89 fd                	mov    %edi,%ebp
  8036b9:	85 ff                	test   %edi,%edi
  8036bb:	75 0b                	jne    8036c8 <__udivdi3+0x38>
  8036bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8036c2:	31 d2                	xor    %edx,%edx
  8036c4:	f7 f7                	div    %edi
  8036c6:	89 c5                	mov    %eax,%ebp
  8036c8:	31 d2                	xor    %edx,%edx
  8036ca:	89 c8                	mov    %ecx,%eax
  8036cc:	f7 f5                	div    %ebp
  8036ce:	89 c1                	mov    %eax,%ecx
  8036d0:	89 d8                	mov    %ebx,%eax
  8036d2:	f7 f5                	div    %ebp
  8036d4:	89 cf                	mov    %ecx,%edi
  8036d6:	89 fa                	mov    %edi,%edx
  8036d8:	83 c4 1c             	add    $0x1c,%esp
  8036db:	5b                   	pop    %ebx
  8036dc:	5e                   	pop    %esi
  8036dd:	5f                   	pop    %edi
  8036de:	5d                   	pop    %ebp
  8036df:	c3                   	ret    
  8036e0:	39 ce                	cmp    %ecx,%esi
  8036e2:	77 28                	ja     80370c <__udivdi3+0x7c>
  8036e4:	0f bd fe             	bsr    %esi,%edi
  8036e7:	83 f7 1f             	xor    $0x1f,%edi
  8036ea:	75 40                	jne    80372c <__udivdi3+0x9c>
  8036ec:	39 ce                	cmp    %ecx,%esi
  8036ee:	72 0a                	jb     8036fa <__udivdi3+0x6a>
  8036f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8036f4:	0f 87 9e 00 00 00    	ja     803798 <__udivdi3+0x108>
  8036fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8036ff:	89 fa                	mov    %edi,%edx
  803701:	83 c4 1c             	add    $0x1c,%esp
  803704:	5b                   	pop    %ebx
  803705:	5e                   	pop    %esi
  803706:	5f                   	pop    %edi
  803707:	5d                   	pop    %ebp
  803708:	c3                   	ret    
  803709:	8d 76 00             	lea    0x0(%esi),%esi
  80370c:	31 ff                	xor    %edi,%edi
  80370e:	31 c0                	xor    %eax,%eax
  803710:	89 fa                	mov    %edi,%edx
  803712:	83 c4 1c             	add    $0x1c,%esp
  803715:	5b                   	pop    %ebx
  803716:	5e                   	pop    %esi
  803717:	5f                   	pop    %edi
  803718:	5d                   	pop    %ebp
  803719:	c3                   	ret    
  80371a:	66 90                	xchg   %ax,%ax
  80371c:	89 d8                	mov    %ebx,%eax
  80371e:	f7 f7                	div    %edi
  803720:	31 ff                	xor    %edi,%edi
  803722:	89 fa                	mov    %edi,%edx
  803724:	83 c4 1c             	add    $0x1c,%esp
  803727:	5b                   	pop    %ebx
  803728:	5e                   	pop    %esi
  803729:	5f                   	pop    %edi
  80372a:	5d                   	pop    %ebp
  80372b:	c3                   	ret    
  80372c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803731:	89 eb                	mov    %ebp,%ebx
  803733:	29 fb                	sub    %edi,%ebx
  803735:	89 f9                	mov    %edi,%ecx
  803737:	d3 e6                	shl    %cl,%esi
  803739:	89 c5                	mov    %eax,%ebp
  80373b:	88 d9                	mov    %bl,%cl
  80373d:	d3 ed                	shr    %cl,%ebp
  80373f:	89 e9                	mov    %ebp,%ecx
  803741:	09 f1                	or     %esi,%ecx
  803743:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803747:	89 f9                	mov    %edi,%ecx
  803749:	d3 e0                	shl    %cl,%eax
  80374b:	89 c5                	mov    %eax,%ebp
  80374d:	89 d6                	mov    %edx,%esi
  80374f:	88 d9                	mov    %bl,%cl
  803751:	d3 ee                	shr    %cl,%esi
  803753:	89 f9                	mov    %edi,%ecx
  803755:	d3 e2                	shl    %cl,%edx
  803757:	8b 44 24 08          	mov    0x8(%esp),%eax
  80375b:	88 d9                	mov    %bl,%cl
  80375d:	d3 e8                	shr    %cl,%eax
  80375f:	09 c2                	or     %eax,%edx
  803761:	89 d0                	mov    %edx,%eax
  803763:	89 f2                	mov    %esi,%edx
  803765:	f7 74 24 0c          	divl   0xc(%esp)
  803769:	89 d6                	mov    %edx,%esi
  80376b:	89 c3                	mov    %eax,%ebx
  80376d:	f7 e5                	mul    %ebp
  80376f:	39 d6                	cmp    %edx,%esi
  803771:	72 19                	jb     80378c <__udivdi3+0xfc>
  803773:	74 0b                	je     803780 <__udivdi3+0xf0>
  803775:	89 d8                	mov    %ebx,%eax
  803777:	31 ff                	xor    %edi,%edi
  803779:	e9 58 ff ff ff       	jmp    8036d6 <__udivdi3+0x46>
  80377e:	66 90                	xchg   %ax,%ax
  803780:	8b 54 24 08          	mov    0x8(%esp),%edx
  803784:	89 f9                	mov    %edi,%ecx
  803786:	d3 e2                	shl    %cl,%edx
  803788:	39 c2                	cmp    %eax,%edx
  80378a:	73 e9                	jae    803775 <__udivdi3+0xe5>
  80378c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80378f:	31 ff                	xor    %edi,%edi
  803791:	e9 40 ff ff ff       	jmp    8036d6 <__udivdi3+0x46>
  803796:	66 90                	xchg   %ax,%ax
  803798:	31 c0                	xor    %eax,%eax
  80379a:	e9 37 ff ff ff       	jmp    8036d6 <__udivdi3+0x46>
  80379f:	90                   	nop

008037a0 <__umoddi3>:
  8037a0:	55                   	push   %ebp
  8037a1:	57                   	push   %edi
  8037a2:	56                   	push   %esi
  8037a3:	53                   	push   %ebx
  8037a4:	83 ec 1c             	sub    $0x1c,%esp
  8037a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037bf:	89 f3                	mov    %esi,%ebx
  8037c1:	89 fa                	mov    %edi,%edx
  8037c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037c7:	89 34 24             	mov    %esi,(%esp)
  8037ca:	85 c0                	test   %eax,%eax
  8037cc:	75 1a                	jne    8037e8 <__umoddi3+0x48>
  8037ce:	39 f7                	cmp    %esi,%edi
  8037d0:	0f 86 a2 00 00 00    	jbe    803878 <__umoddi3+0xd8>
  8037d6:	89 c8                	mov    %ecx,%eax
  8037d8:	89 f2                	mov    %esi,%edx
  8037da:	f7 f7                	div    %edi
  8037dc:	89 d0                	mov    %edx,%eax
  8037de:	31 d2                	xor    %edx,%edx
  8037e0:	83 c4 1c             	add    $0x1c,%esp
  8037e3:	5b                   	pop    %ebx
  8037e4:	5e                   	pop    %esi
  8037e5:	5f                   	pop    %edi
  8037e6:	5d                   	pop    %ebp
  8037e7:	c3                   	ret    
  8037e8:	39 f0                	cmp    %esi,%eax
  8037ea:	0f 87 ac 00 00 00    	ja     80389c <__umoddi3+0xfc>
  8037f0:	0f bd e8             	bsr    %eax,%ebp
  8037f3:	83 f5 1f             	xor    $0x1f,%ebp
  8037f6:	0f 84 ac 00 00 00    	je     8038a8 <__umoddi3+0x108>
  8037fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803801:	29 ef                	sub    %ebp,%edi
  803803:	89 fe                	mov    %edi,%esi
  803805:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803809:	89 e9                	mov    %ebp,%ecx
  80380b:	d3 e0                	shl    %cl,%eax
  80380d:	89 d7                	mov    %edx,%edi
  80380f:	89 f1                	mov    %esi,%ecx
  803811:	d3 ef                	shr    %cl,%edi
  803813:	09 c7                	or     %eax,%edi
  803815:	89 e9                	mov    %ebp,%ecx
  803817:	d3 e2                	shl    %cl,%edx
  803819:	89 14 24             	mov    %edx,(%esp)
  80381c:	89 d8                	mov    %ebx,%eax
  80381e:	d3 e0                	shl    %cl,%eax
  803820:	89 c2                	mov    %eax,%edx
  803822:	8b 44 24 08          	mov    0x8(%esp),%eax
  803826:	d3 e0                	shl    %cl,%eax
  803828:	89 44 24 04          	mov    %eax,0x4(%esp)
  80382c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803830:	89 f1                	mov    %esi,%ecx
  803832:	d3 e8                	shr    %cl,%eax
  803834:	09 d0                	or     %edx,%eax
  803836:	d3 eb                	shr    %cl,%ebx
  803838:	89 da                	mov    %ebx,%edx
  80383a:	f7 f7                	div    %edi
  80383c:	89 d3                	mov    %edx,%ebx
  80383e:	f7 24 24             	mull   (%esp)
  803841:	89 c6                	mov    %eax,%esi
  803843:	89 d1                	mov    %edx,%ecx
  803845:	39 d3                	cmp    %edx,%ebx
  803847:	0f 82 87 00 00 00    	jb     8038d4 <__umoddi3+0x134>
  80384d:	0f 84 91 00 00 00    	je     8038e4 <__umoddi3+0x144>
  803853:	8b 54 24 04          	mov    0x4(%esp),%edx
  803857:	29 f2                	sub    %esi,%edx
  803859:	19 cb                	sbb    %ecx,%ebx
  80385b:	89 d8                	mov    %ebx,%eax
  80385d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803861:	d3 e0                	shl    %cl,%eax
  803863:	89 e9                	mov    %ebp,%ecx
  803865:	d3 ea                	shr    %cl,%edx
  803867:	09 d0                	or     %edx,%eax
  803869:	89 e9                	mov    %ebp,%ecx
  80386b:	d3 eb                	shr    %cl,%ebx
  80386d:	89 da                	mov    %ebx,%edx
  80386f:	83 c4 1c             	add    $0x1c,%esp
  803872:	5b                   	pop    %ebx
  803873:	5e                   	pop    %esi
  803874:	5f                   	pop    %edi
  803875:	5d                   	pop    %ebp
  803876:	c3                   	ret    
  803877:	90                   	nop
  803878:	89 fd                	mov    %edi,%ebp
  80387a:	85 ff                	test   %edi,%edi
  80387c:	75 0b                	jne    803889 <__umoddi3+0xe9>
  80387e:	b8 01 00 00 00       	mov    $0x1,%eax
  803883:	31 d2                	xor    %edx,%edx
  803885:	f7 f7                	div    %edi
  803887:	89 c5                	mov    %eax,%ebp
  803889:	89 f0                	mov    %esi,%eax
  80388b:	31 d2                	xor    %edx,%edx
  80388d:	f7 f5                	div    %ebp
  80388f:	89 c8                	mov    %ecx,%eax
  803891:	f7 f5                	div    %ebp
  803893:	89 d0                	mov    %edx,%eax
  803895:	e9 44 ff ff ff       	jmp    8037de <__umoddi3+0x3e>
  80389a:	66 90                	xchg   %ax,%ax
  80389c:	89 c8                	mov    %ecx,%eax
  80389e:	89 f2                	mov    %esi,%edx
  8038a0:	83 c4 1c             	add    $0x1c,%esp
  8038a3:	5b                   	pop    %ebx
  8038a4:	5e                   	pop    %esi
  8038a5:	5f                   	pop    %edi
  8038a6:	5d                   	pop    %ebp
  8038a7:	c3                   	ret    
  8038a8:	3b 04 24             	cmp    (%esp),%eax
  8038ab:	72 06                	jb     8038b3 <__umoddi3+0x113>
  8038ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038b1:	77 0f                	ja     8038c2 <__umoddi3+0x122>
  8038b3:	89 f2                	mov    %esi,%edx
  8038b5:	29 f9                	sub    %edi,%ecx
  8038b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038bb:	89 14 24             	mov    %edx,(%esp)
  8038be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038c6:	8b 14 24             	mov    (%esp),%edx
  8038c9:	83 c4 1c             	add    $0x1c,%esp
  8038cc:	5b                   	pop    %ebx
  8038cd:	5e                   	pop    %esi
  8038ce:	5f                   	pop    %edi
  8038cf:	5d                   	pop    %ebp
  8038d0:	c3                   	ret    
  8038d1:	8d 76 00             	lea    0x0(%esi),%esi
  8038d4:	2b 04 24             	sub    (%esp),%eax
  8038d7:	19 fa                	sbb    %edi,%edx
  8038d9:	89 d1                	mov    %edx,%ecx
  8038db:	89 c6                	mov    %eax,%esi
  8038dd:	e9 71 ff ff ff       	jmp    803853 <__umoddi3+0xb3>
  8038e2:	66 90                	xchg   %ax,%ax
  8038e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8038e8:	72 ea                	jb     8038d4 <__umoddi3+0x134>
  8038ea:	89 d9                	mov    %ebx,%ecx
  8038ec:	e9 62 ff ff ff       	jmp    803853 <__umoddi3+0xb3>
