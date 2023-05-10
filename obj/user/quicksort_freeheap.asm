
obj/user/quicksort_freeheap:     file format elf32-i386


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
  800031:	e8 b4 05 00 00       	call   8005ea <libmain>
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
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 ec 1e 00 00       	call   801f3a <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 fe 1e 00 00       	call   801f53 <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

		//	sys_disable_interrupt();

		readline("Enter the number of elements: ", Line);
  80005d:	83 ec 08             	sub    $0x8,%esp
  800060:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	68 a0 38 80 00       	push   $0x8038a0
  80006c:	e8 eb 0f 00 00       	call   80105c <readline>
  800071:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 3b 15 00 00       	call   8015c2 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 70 1a 00 00       	call   801b0c <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 c0 38 80 00       	push   $0x8038c0
  8000aa:	e8 2b 09 00 00       	call   8009da <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 e3 38 80 00       	push   $0x8038e3
  8000ba:	e8 1b 09 00 00       	call   8009da <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 f1 38 80 00       	push   $0x8038f1
  8000ca:	e8 0b 09 00 00       	call   8009da <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 00 39 80 00       	push   $0x803900
  8000da:	e8 fb 08 00 00       	call   8009da <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 10 39 80 00       	push   $0x803910
  8000ea:	e8 eb 08 00 00       	call   8009da <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000f2:	e8 9b 04 00 00       	call   800592 <getchar>
  8000f7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000fa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 43 04 00 00       	call   80054a <cputchar>
  800107:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 0a                	push   $0xa
  80010f:	e8 36 04 00 00       	call   80054a <cputchar>
  800114:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800117:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  80011b:	74 0c                	je     800129 <_main+0xf1>
  80011d:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800121:	74 06                	je     800129 <_main+0xf1>
  800123:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  800127:	75 b9                	jne    8000e2 <_main+0xaa>
		//sys_enable_interrupt();
		int  i ;
		switch (Chose)
  800129:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012d:	83 f8 62             	cmp    $0x62,%eax
  800130:	74 1d                	je     80014f <_main+0x117>
  800132:	83 f8 63             	cmp    $0x63,%eax
  800135:	74 2b                	je     800162 <_main+0x12a>
  800137:	83 f8 61             	cmp    $0x61,%eax
  80013a:	75 39                	jne    800175 <_main+0x13d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	ff 75 e8             	pushl  -0x18(%ebp)
  800145:	e8 c8 02 00 00       	call   800412 <InitializeAscending>
  80014a:	83 c4 10             	add    $0x10,%esp
			break ;
  80014d:	eb 37                	jmp    800186 <_main+0x14e>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 ec             	pushl  -0x14(%ebp)
  800155:	ff 75 e8             	pushl  -0x18(%ebp)
  800158:	e8 e6 02 00 00       	call   800443 <InitializeDescending>
  80015d:	83 c4 10             	add    $0x10,%esp
			break ;
  800160:	eb 24                	jmp    800186 <_main+0x14e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 75 ec             	pushl  -0x14(%ebp)
  800168:	ff 75 e8             	pushl  -0x18(%ebp)
  80016b:	e8 08 03 00 00       	call   800478 <InitializeSemiRandom>
  800170:	83 c4 10             	add    $0x10,%esp
			break ;
  800173:	eb 11                	jmp    800186 <_main+0x14e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 f5 02 00 00       	call   800478 <InitializeSemiRandom>
  800183:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	ff 75 e8             	pushl  -0x18(%ebp)
  80018f:	e8 c3 00 00 00       	call   800257 <QuickSort>
  800194:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 ec             	pushl  -0x14(%ebp)
  80019d:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a0:	e8 c3 01 00 00       	call   800368 <CheckSorted>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001af:	75 14                	jne    8001c5 <_main+0x18d>
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	68 1c 39 80 00       	push   $0x80391c
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 3e 39 80 00       	push   $0x80393e
  8001c0:	e8 61 05 00 00       	call   800726 <_panic>
		else
		{ 
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 58 39 80 00       	push   $0x803958
  8001cd:	e8 08 08 00 00       	call   8009da <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 8c 39 80 00       	push   $0x80398c
  8001dd:	e8 f8 07 00 00       	call   8009da <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 c0 39 80 00       	push   $0x8039c0
  8001ed:	e8 e8 07 00 00       	call   8009da <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 f2 39 80 00       	push   $0x8039f2
  8001fd:	e8 d8 07 00 00       	call   8009da <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_disable_interrupt();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 08 3a 80 00       	push   $0x803a08
  80020d:	e8 c8 07 00 00       	call   8009da <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800215:	e8 78 03 00 00       	call   800592 <getchar>
  80021a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80021d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 20 03 00 00       	call   80054a <cputchar>
  80022a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 0a                	push   $0xa
  800232:	e8 13 03 00 00       	call   80054a <cputchar>
  800237:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	6a 0a                	push   $0xa
  80023f:	e8 06 03 00 00       	call   80054a <cputchar>
  800244:	83 c4 10             	add    $0x10,%esp
		//sys_enable_interrupt();

	} while (Chose == 'y');
  800247:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  80024b:	0f 84 f8 fd ff ff    	je     800049 <_main+0x11>

}
  800251:	90                   	nop
  800252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	48                   	dec    %eax
  800261:	50                   	push   %eax
  800262:	6a 00                	push   $0x0
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 06 00 00 00       	call   800275 <QSort>
  80026f:	83 c4 10             	add    $0x10,%esp
}
  800272:	90                   	nop
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80027b:	8b 45 10             	mov    0x10(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	0f 8d de 00 00 00    	jge    800365 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	40                   	inc    %eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80028e:	8b 45 14             	mov    0x14(%ebp),%eax
  800291:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800294:	e9 80 00 00 00       	jmp    800319 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800299:	ff 45 f4             	incl   -0xc(%ebp)
  80029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029f:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a2:	7f 2b                	jg     8002cf <QSort+0x5a>
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	01 c8                	add    %ecx,%eax
  8002c4:	8b 00                	mov    (%eax),%eax
  8002c6:	39 c2                	cmp    %eax,%edx
  8002c8:	7d cf                	jge    800299 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002ca:	eb 03                	jmp    8002cf <QSort+0x5a>
  8002cc:	ff 4d f0             	decl   -0x10(%ebp)
  8002cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d5:	7e 26                	jle    8002fd <QSort+0x88>
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 d0                	add    %edx,%eax
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	39 c2                	cmp    %eax,%edx
  8002fb:	7e cf                	jle    8002cc <QSort+0x57>

		if (i <= j)
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800303:	7f 14                	jg     800319 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 f0             	pushl  -0x10(%ebp)
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 a9 00 00 00       	call   8003bf <Swap>
  800316:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80031c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031f:	0f 8e 77 ff ff ff    	jle    80029c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 f0             	pushl  -0x10(%ebp)
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	e8 89 00 00 00       	call   8003bf <Swap>
  800336:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	48                   	dec    %eax
  80033d:	50                   	push   %eax
  80033e:	ff 75 10             	pushl  0x10(%ebp)
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 29 ff ff ff       	call   800275 <QSort>
  80034c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80034f:	ff 75 14             	pushl  0x14(%ebp)
  800352:	ff 75 f4             	pushl  -0xc(%ebp)
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	e8 15 ff ff ff       	call   800275 <QSort>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb 01                	jmp    800366 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800365:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80036e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800375:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80037c:	eb 33                	jmp    8003b1 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80037e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800392:	40                   	inc    %eax
  800393:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	7e 09                	jle    8003ae <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003ac:	eb 0c                	jmp    8003ba <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ae:	ff 45 f8             	incl   -0x8(%ebp)
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b4:	48                   	dec    %eax
  8003b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003b8:	7f c4                	jg     80037e <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c2                	add    %eax,%edx
  80040a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040d:	89 02                	mov    %eax,(%edx)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80041f:	eb 17                	jmp    800438 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800421:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 c2                	add    %eax,%edx
  800430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800433:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	ff 45 fc             	incl   -0x4(%ebp)
  800438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043e:	7c e1                	jl     800421 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800450:	eb 1b                	jmp    80046d <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800467:	48                   	dec    %eax
  800468:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046a:	ff 45 fc             	incl   -0x4(%ebp)
  80046d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	7c dd                	jl     800452 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800486:	f7 e9                	imul   %ecx
  800488:	c1 f9 1f             	sar    $0x1f,%ecx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	29 c8                	sub    %ecx,%eax
  80048f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800492:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800499:	eb 1e                	jmp    8004b9 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ae:	99                   	cltd   
  8004af:	f7 7d f8             	idivl  -0x8(%ebp)
  8004b2:	89 d0                	mov    %edx,%eax
  8004b4:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b6:	ff 45 fc             	incl   -0x4(%ebp)
  8004b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004bf:	7c da                	jl     80049b <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004c1:	90                   	nop
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004ca:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004d8:	eb 42                	jmp    80051c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004dd:	99                   	cltd   
  8004de:	f7 7d f0             	idivl  -0x10(%ebp)
  8004e1:	89 d0                	mov    %edx,%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	75 10                	jne    8004f7 <PrintElements+0x33>
			cprintf("\n");
  8004e7:	83 ec 0c             	sub    $0xc,%esp
  8004ea:	68 26 3a 80 00       	push   $0x803a26
  8004ef:	e8 e6 04 00 00       	call   8009da <cprintf>
  8004f4:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8004f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	50                   	push   %eax
  80050c:	68 28 3a 80 00       	push   $0x803a28
  800511:	e8 c4 04 00 00       	call   8009da <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800519:	ff 45 f4             	incl   -0xc(%ebp)
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	48                   	dec    %eax
  800520:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800523:	7f b5                	jg     8004da <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800528:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	01 d0                	add    %edx,%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	50                   	push   %eax
  80053a:	68 2d 3a 80 00       	push   $0x803a2d
  80053f:	e8 96 04 00 00       	call   8009da <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800556:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80055a:	83 ec 0c             	sub    $0xc,%esp
  80055d:	50                   	push   %eax
  80055e:	e8 f8 1a 00 00       	call   80205b <sys_cputc>
  800563:	83 c4 10             	add    $0x10,%esp
}
  800566:	90                   	nop
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80056f:	e8 b3 1a 00 00       	call   802027 <sys_disable_interrupt>
	char c = ch;
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80057a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80057e:	83 ec 0c             	sub    $0xc,%esp
  800581:	50                   	push   %eax
  800582:	e8 d4 1a 00 00       	call   80205b <sys_cputc>
  800587:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80058a:	e8 b2 1a 00 00       	call   802041 <sys_enable_interrupt>
}
  80058f:	90                   	nop
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <getchar>:

int
getchar(void)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800598:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80059f:	eb 08                	jmp    8005a9 <getchar+0x17>
	{
		c = sys_cgetc();
  8005a1:	e8 fc 18 00 00       	call   801ea2 <sys_cgetc>
  8005a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005ad:	74 f2                	je     8005a1 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005b2:	c9                   	leave  
  8005b3:	c3                   	ret    

008005b4 <atomic_getchar>:

int
atomic_getchar(void)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005ba:	e8 68 1a 00 00       	call   802027 <sys_disable_interrupt>
	int c=0;
  8005bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005c6:	eb 08                	jmp    8005d0 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005c8:	e8 d5 18 00 00       	call   801ea2 <sys_cgetc>
  8005cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8005d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005d4:	74 f2                	je     8005c8 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8005d6:	e8 66 1a 00 00       	call   802041 <sys_enable_interrupt>
	return c;
  8005db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <iscons>:

int iscons(int fdnum)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005e8:	5d                   	pop    %ebp
  8005e9:	c3                   	ret    

008005ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005f0:	e8 25 1c 00 00       	call   80221a <sys_getenvindex>
  8005f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	c1 e0 03             	shl    $0x3,%eax
  800600:	01 d0                	add    %edx,%eax
  800602:	01 c0                	add    %eax,%eax
  800604:	01 d0                	add    %edx,%eax
  800606:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060d:	01 d0                	add    %edx,%eax
  80060f:	c1 e0 04             	shl    $0x4,%eax
  800612:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800617:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80061c:	a1 24 50 80 00       	mov    0x805024,%eax
  800621:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800627:	84 c0                	test   %al,%al
  800629:	74 0f                	je     80063a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80062b:	a1 24 50 80 00       	mov    0x805024,%eax
  800630:	05 5c 05 00 00       	add    $0x55c,%eax
  800635:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80063a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80063e:	7e 0a                	jle    80064a <libmain+0x60>
		binaryname = argv[0];
  800640:	8b 45 0c             	mov    0xc(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	ff 75 08             	pushl  0x8(%ebp)
  800653:	e8 e0 f9 ff ff       	call   800038 <_main>
  800658:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80065b:	e8 c7 19 00 00       	call   802027 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800660:	83 ec 0c             	sub    $0xc,%esp
  800663:	68 4c 3a 80 00       	push   $0x803a4c
  800668:	e8 6d 03 00 00       	call   8009da <cprintf>
  80066d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800670:	a1 24 50 80 00       	mov    0x805024,%eax
  800675:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80067b:	a1 24 50 80 00       	mov    0x805024,%eax
  800680:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	68 74 3a 80 00       	push   $0x803a74
  800690:	e8 45 03 00 00       	call   8009da <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800698:	a1 24 50 80 00       	mov    0x805024,%eax
  80069d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006a3:	a1 24 50 80 00       	mov    0x805024,%eax
  8006a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006ae:	a1 24 50 80 00       	mov    0x805024,%eax
  8006b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b9:	51                   	push   %ecx
  8006ba:	52                   	push   %edx
  8006bb:	50                   	push   %eax
  8006bc:	68 9c 3a 80 00       	push   $0x803a9c
  8006c1:	e8 14 03 00 00       	call   8009da <cprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	50                   	push   %eax
  8006d8:	68 f4 3a 80 00       	push   $0x803af4
  8006dd:	e8 f8 02 00 00       	call   8009da <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	68 4c 3a 80 00       	push   $0x803a4c
  8006ed:	e8 e8 02 00 00       	call   8009da <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006f5:	e8 47 19 00 00       	call   802041 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006fa:	e8 19 00 00 00       	call   800718 <exit>
}
  8006ff:	90                   	nop
  800700:	c9                   	leave  
  800701:	c3                   	ret    

00800702 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800708:	83 ec 0c             	sub    $0xc,%esp
  80070b:	6a 00                	push   $0x0
  80070d:	e8 d4 1a 00 00       	call   8021e6 <sys_destroy_env>
  800712:	83 c4 10             	add    $0x10,%esp
}
  800715:	90                   	nop
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <exit>:

void
exit(void)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80071e:	e8 29 1b 00 00       	call   80224c <sys_exit_env>
}
  800723:	90                   	nop
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80072c:	8d 45 10             	lea    0x10(%ebp),%eax
  80072f:	83 c0 04             	add    $0x4,%eax
  800732:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800735:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80073a:	85 c0                	test   %eax,%eax
  80073c:	74 16                	je     800754 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80073e:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	50                   	push   %eax
  800747:	68 08 3b 80 00       	push   $0x803b08
  80074c:	e8 89 02 00 00       	call   8009da <cprintf>
  800751:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800754:	a1 00 50 80 00       	mov    0x805000,%eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	50                   	push   %eax
  800760:	68 0d 3b 80 00       	push   $0x803b0d
  800765:	e8 70 02 00 00       	call   8009da <cprintf>
  80076a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80076d:	8b 45 10             	mov    0x10(%ebp),%eax
  800770:	83 ec 08             	sub    $0x8,%esp
  800773:	ff 75 f4             	pushl  -0xc(%ebp)
  800776:	50                   	push   %eax
  800777:	e8 f3 01 00 00       	call   80096f <vcprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	6a 00                	push   $0x0
  800784:	68 29 3b 80 00       	push   $0x803b29
  800789:	e8 e1 01 00 00       	call   80096f <vcprintf>
  80078e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800791:	e8 82 ff ff ff       	call   800718 <exit>

	// should not return here
	while (1) ;
  800796:	eb fe                	jmp    800796 <_panic+0x70>

00800798 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80079e:	a1 24 50 80 00       	mov    0x805024,%eax
  8007a3:	8b 50 74             	mov    0x74(%eax),%edx
  8007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a9:	39 c2                	cmp    %eax,%edx
  8007ab:	74 14                	je     8007c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007ad:	83 ec 04             	sub    $0x4,%esp
  8007b0:	68 2c 3b 80 00       	push   $0x803b2c
  8007b5:	6a 26                	push   $0x26
  8007b7:	68 78 3b 80 00       	push   $0x803b78
  8007bc:	e8 65 ff ff ff       	call   800726 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007cf:	e9 c2 00 00 00       	jmp    800896 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	01 d0                	add    %edx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	75 08                	jne    8007f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007ec:	e9 a2 00 00 00       	jmp    800893 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ff:	eb 69                	jmp    80086a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800801:	a1 24 50 80 00       	mov    0x805024,%eax
  800806:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80080c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80080f:	89 d0                	mov    %edx,%eax
  800811:	01 c0                	add    %eax,%eax
  800813:	01 d0                	add    %edx,%eax
  800815:	c1 e0 03             	shl    $0x3,%eax
  800818:	01 c8                	add    %ecx,%eax
  80081a:	8a 40 04             	mov    0x4(%eax),%al
  80081d:	84 c0                	test   %al,%al
  80081f:	75 46                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80082c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082f:	89 d0                	mov    %edx,%eax
  800831:	01 c0                	add    %eax,%eax
  800833:	01 d0                	add    %edx,%eax
  800835:	c1 e0 03             	shl    $0x3,%eax
  800838:	01 c8                	add    %ecx,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80083f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800842:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800847:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	75 09                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80085e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800865:	eb 12                	jmp    800879 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800867:	ff 45 e8             	incl   -0x18(%ebp)
  80086a:	a1 24 50 80 00       	mov    0x805024,%eax
  80086f:	8b 50 74             	mov    0x74(%eax),%edx
  800872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	77 88                	ja     800801 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800879:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80087d:	75 14                	jne    800893 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	68 84 3b 80 00       	push   $0x803b84
  800887:	6a 3a                	push   $0x3a
  800889:	68 78 3b 80 00       	push   $0x803b78
  80088e:	e8 93 fe ff ff       	call   800726 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800893:	ff 45 f0             	incl   -0x10(%ebp)
  800896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800899:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80089c:	0f 8c 32 ff ff ff    	jl     8007d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008b0:	eb 26                	jmp    8008d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c0:	89 d0                	mov    %edx,%eax
  8008c2:	01 c0                	add    %eax,%eax
  8008c4:	01 d0                	add    %edx,%eax
  8008c6:	c1 e0 03             	shl    $0x3,%eax
  8008c9:	01 c8                	add    %ecx,%eax
  8008cb:	8a 40 04             	mov    0x4(%eax),%al
  8008ce:	3c 01                	cmp    $0x1,%al
  8008d0:	75 03                	jne    8008d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d5:	ff 45 e0             	incl   -0x20(%ebp)
  8008d8:	a1 24 50 80 00       	mov    0x805024,%eax
  8008dd:	8b 50 74             	mov    0x74(%eax),%edx
  8008e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e3:	39 c2                	cmp    %eax,%edx
  8008e5:	77 cb                	ja     8008b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008ed:	74 14                	je     800903 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	68 d8 3b 80 00       	push   $0x803bd8
  8008f7:	6a 44                	push   $0x44
  8008f9:	68 78 3b 80 00       	push   $0x803b78
  8008fe:	e8 23 fe ff ff       	call   800726 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800903:	90                   	nop
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80090c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 48 01             	lea    0x1(%eax),%ecx
  800914:	8b 55 0c             	mov    0xc(%ebp),%edx
  800917:	89 0a                	mov    %ecx,(%edx)
  800919:	8b 55 08             	mov    0x8(%ebp),%edx
  80091c:	88 d1                	mov    %dl,%cl
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800921:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80092f:	75 2c                	jne    80095d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800931:	a0 28 50 80 00       	mov    0x805028,%al
  800936:	0f b6 c0             	movzbl %al,%eax
  800939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093c:	8b 12                	mov    (%edx),%edx
  80093e:	89 d1                	mov    %edx,%ecx
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	83 c2 08             	add    $0x8,%edx
  800946:	83 ec 04             	sub    $0x4,%esp
  800949:	50                   	push   %eax
  80094a:	51                   	push   %ecx
  80094b:	52                   	push   %edx
  80094c:	e8 28 15 00 00       	call   801e79 <sys_cputs>
  800951:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	8d 50 01             	lea    0x1(%eax),%edx
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	89 50 04             	mov    %edx,0x4(%eax)
}
  80096c:	90                   	nop
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800978:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80097f:	00 00 00 
	b.cnt = 0;
  800982:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800989:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	ff 75 08             	pushl  0x8(%ebp)
  800992:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800998:	50                   	push   %eax
  800999:	68 06 09 80 00       	push   $0x800906
  80099e:	e8 11 02 00 00       	call   800bb4 <vprintfmt>
  8009a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009a6:	a0 28 50 80 00       	mov    0x805028,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009b4:	83 ec 04             	sub    $0x4,%esp
  8009b7:	50                   	push   %eax
  8009b8:	52                   	push   %edx
  8009b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009bf:	83 c0 08             	add    $0x8,%eax
  8009c2:	50                   	push   %eax
  8009c3:	e8 b1 14 00 00       	call   801e79 <sys_cputs>
  8009c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009cb:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  8009d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <cprintf>:

int cprintf(const char *fmt, ...) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009e0:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  8009e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f6:	50                   	push   %eax
  8009f7:	e8 73 ff ff ff       	call   80096f <vcprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a0d:	e8 15 16 00 00       	call   802027 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a12:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a21:	50                   	push   %eax
  800a22:	e8 48 ff ff ff       	call   80096f <vcprintf>
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a2d:	e8 0f 16 00 00       	call   802041 <sys_enable_interrupt>
	return cnt;
  800a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	53                   	push   %ebx
  800a3b:	83 ec 14             	sub    $0x14,%esp
  800a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a4a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a52:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a55:	77 55                	ja     800aac <printnum+0x75>
  800a57:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a5a:	72 05                	jb     800a61 <printnum+0x2a>
  800a5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a5f:	77 4b                	ja     800aac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a61:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a64:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a67:	8b 45 18             	mov    0x18(%ebp),%eax
  800a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6f:	52                   	push   %edx
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	e8 b8 2b 00 00       	call   803634 <__udivdi3>
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	83 ec 04             	sub    $0x4,%esp
  800a82:	ff 75 20             	pushl  0x20(%ebp)
  800a85:	53                   	push   %ebx
  800a86:	ff 75 18             	pushl  0x18(%ebp)
  800a89:	52                   	push   %edx
  800a8a:	50                   	push   %eax
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 a1 ff ff ff       	call   800a37 <printnum>
  800a96:	83 c4 20             	add    $0x20,%esp
  800a99:	eb 1a                	jmp    800ab5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	ff 75 20             	pushl  0x20(%ebp)
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aac:	ff 4d 1c             	decl   0x1c(%ebp)
  800aaf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ab3:	7f e6                	jg     800a9b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ab5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac3:	53                   	push   %ebx
  800ac4:	51                   	push   %ecx
  800ac5:	52                   	push   %edx
  800ac6:	50                   	push   %eax
  800ac7:	e8 78 2c 00 00       	call   803744 <__umoddi3>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	05 54 3e 80 00       	add    $0x803e54,%eax
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	0f be c0             	movsbl %al,%eax
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	50                   	push   %eax
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	ff d0                	call   *%eax
  800ae5:	83 c4 10             	add    $0x10,%esp
}
  800ae8:	90                   	nop
  800ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800af1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800af5:	7e 1c                	jle    800b13 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8b 00                	mov    (%eax),%eax
  800afc:	8d 50 08             	lea    0x8(%eax),%edx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	89 10                	mov    %edx,(%eax)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	83 e8 08             	sub    $0x8,%eax
  800b0c:	8b 50 04             	mov    0x4(%eax),%edx
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	eb 40                	jmp    800b53 <getuint+0x65>
	else if (lflag)
  800b13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b17:	74 1e                	je     800b37 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 04             	lea    0x4(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 04             	sub    $0x4,%eax
  800b2e:	8b 00                	mov    (%eax),%eax
  800b30:	ba 00 00 00 00       	mov    $0x0,%edx
  800b35:	eb 1c                	jmp    800b53 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	8d 50 04             	lea    0x4(%eax),%edx
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	89 10                	mov    %edx,(%eax)
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	8b 00                	mov    (%eax),%eax
  800b49:	83 e8 04             	sub    $0x4,%eax
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b58:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b5c:	7e 1c                	jle    800b7a <getint+0x25>
		return va_arg(*ap, long long);
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	8d 50 08             	lea    0x8(%eax),%edx
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	89 10                	mov    %edx,(%eax)
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	83 e8 08             	sub    $0x8,%eax
  800b73:	8b 50 04             	mov    0x4(%eax),%edx
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	eb 38                	jmp    800bb2 <getint+0x5d>
	else if (lflag)
  800b7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7e:	74 1a                	je     800b9a <getint+0x45>
		return va_arg(*ap, long);
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	8d 50 04             	lea    0x4(%eax),%edx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 10                	mov    %edx,(%eax)
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	83 e8 04             	sub    $0x4,%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	99                   	cltd   
  800b98:	eb 18                	jmp    800bb2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	8d 50 04             	lea    0x4(%eax),%edx
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 10                	mov    %edx,(%eax)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 00                	mov    (%eax),%eax
  800bac:	83 e8 04             	sub    $0x4,%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	99                   	cltd   
}
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbc:	eb 17                	jmp    800bd5 <vprintfmt+0x21>
			if (ch == '\0')
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	0f 84 af 03 00 00    	je     800f75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	53                   	push   %ebx
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	ff d0                	call   *%eax
  800bd2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	8d 50 01             	lea    0x1(%eax),%edx
  800bdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	0f b6 d8             	movzbl %al,%ebx
  800be3:	83 fb 25             	cmp    $0x25,%ebx
  800be6:	75 d6                	jne    800bbe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bf3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c19:	83 f8 55             	cmp    $0x55,%eax
  800c1c:	0f 87 2b 03 00 00    	ja     800f4d <vprintfmt+0x399>
  800c22:	8b 04 85 78 3e 80 00 	mov    0x803e78(,%eax,4),%eax
  800c29:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c2f:	eb d7                	jmp    800c08 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c35:	eb d1                	jmp    800c08 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c41:	89 d0                	mov    %edx,%eax
  800c43:	c1 e0 02             	shl    $0x2,%eax
  800c46:	01 d0                	add    %edx,%eax
  800c48:	01 c0                	add    %eax,%eax
  800c4a:	01 d8                	add    %ebx,%eax
  800c4c:	83 e8 30             	sub    $0x30,%eax
  800c4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c5a:	83 fb 2f             	cmp    $0x2f,%ebx
  800c5d:	7e 3e                	jle    800c9d <vprintfmt+0xe9>
  800c5f:	83 fb 39             	cmp    $0x39,%ebx
  800c62:	7f 39                	jg     800c9d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c64:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c67:	eb d5                	jmp    800c3e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax
  800c7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c7d:	eb 1f                	jmp    800c9e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c83:	79 83                	jns    800c08 <vprintfmt+0x54>
				width = 0;
  800c85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c8c:	e9 77 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c91:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c98:	e9 6b ff ff ff       	jmp    800c08 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c9d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca2:	0f 89 60 ff ff ff    	jns    800c08 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cb5:	e9 4e ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cbd:	e9 46 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc5:	83 c0 04             	add    $0x4,%eax
  800cc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cce:	83 e8 04             	sub    $0x4,%eax
  800cd1:	8b 00                	mov    (%eax),%eax
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	50                   	push   %eax
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	ff d0                	call   *%eax
  800cdf:	83 c4 10             	add    $0x10,%esp
			break;
  800ce2:	e9 89 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 c0 04             	add    $0x4,%eax
  800ced:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf3:	83 e8 04             	sub    $0x4,%eax
  800cf6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf8:	85 db                	test   %ebx,%ebx
  800cfa:	79 02                	jns    800cfe <vprintfmt+0x14a>
				err = -err;
  800cfc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cfe:	83 fb 64             	cmp    $0x64,%ebx
  800d01:	7f 0b                	jg     800d0e <vprintfmt+0x15a>
  800d03:	8b 34 9d c0 3c 80 00 	mov    0x803cc0(,%ebx,4),%esi
  800d0a:	85 f6                	test   %esi,%esi
  800d0c:	75 19                	jne    800d27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d0e:	53                   	push   %ebx
  800d0f:	68 65 3e 80 00       	push   $0x803e65
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 5e 02 00 00       	call   800f7d <printfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d22:	e9 49 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d27:	56                   	push   %esi
  800d28:	68 6e 3e 80 00       	push   $0x803e6e
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	ff 75 08             	pushl  0x8(%ebp)
  800d33:	e8 45 02 00 00       	call   800f7d <printfmt>
  800d38:	83 c4 10             	add    $0x10,%esp
			break;
  800d3b:	e9 30 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 c0 04             	add    $0x4,%eax
  800d46:	89 45 14             	mov    %eax,0x14(%ebp)
  800d49:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4c:	83 e8 04             	sub    $0x4,%eax
  800d4f:	8b 30                	mov    (%eax),%esi
  800d51:	85 f6                	test   %esi,%esi
  800d53:	75 05                	jne    800d5a <vprintfmt+0x1a6>
				p = "(null)";
  800d55:	be 71 3e 80 00       	mov    $0x803e71,%esi
			if (width > 0 && padc != '-')
  800d5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d5e:	7e 6d                	jle    800dcd <vprintfmt+0x219>
  800d60:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d64:	74 67                	je     800dcd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	50                   	push   %eax
  800d6d:	56                   	push   %esi
  800d6e:	e8 12 05 00 00       	call   801285 <strnlen>
  800d73:	83 c4 10             	add    $0x10,%esp
  800d76:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d79:	eb 16                	jmp    800d91 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d7b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 0c             	pushl  0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	ff d0                	call   *%eax
  800d8b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800d91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d95:	7f e4                	jg     800d7b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d97:	eb 34                	jmp    800dcd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d99:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d9d:	74 1c                	je     800dbb <vprintfmt+0x207>
  800d9f:	83 fb 1f             	cmp    $0x1f,%ebx
  800da2:	7e 05                	jle    800da9 <vprintfmt+0x1f5>
  800da4:	83 fb 7e             	cmp    $0x7e,%ebx
  800da7:	7e 12                	jle    800dbb <vprintfmt+0x207>
					putch('?', putdat);
  800da9:	83 ec 08             	sub    $0x8,%esp
  800dac:	ff 75 0c             	pushl  0xc(%ebp)
  800daf:	6a 3f                	push   $0x3f
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	ff d0                	call   *%eax
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	eb 0f                	jmp    800dca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	53                   	push   %ebx
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	ff d0                	call   *%eax
  800dc7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	ff 4d e4             	decl   -0x1c(%ebp)
  800dcd:	89 f0                	mov    %esi,%eax
  800dcf:	8d 70 01             	lea    0x1(%eax),%esi
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f be d8             	movsbl %al,%ebx
  800dd7:	85 db                	test   %ebx,%ebx
  800dd9:	74 24                	je     800dff <vprintfmt+0x24b>
  800ddb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ddf:	78 b8                	js     800d99 <vprintfmt+0x1e5>
  800de1:	ff 4d e0             	decl   -0x20(%ebp)
  800de4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de8:	79 af                	jns    800d99 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dea:	eb 13                	jmp    800dff <vprintfmt+0x24b>
				putch(' ', putdat);
  800dec:	83 ec 08             	sub    $0x8,%esp
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	6a 20                	push   $0x20
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	ff d0                	call   *%eax
  800df9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dfc:	ff 4d e4             	decl   -0x1c(%ebp)
  800dff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e03:	7f e7                	jg     800dec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e05:	e9 66 01 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e0a:	83 ec 08             	sub    $0x8,%esp
  800e0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800e10:	8d 45 14             	lea    0x14(%ebp),%eax
  800e13:	50                   	push   %eax
  800e14:	e8 3c fd ff ff       	call   800b55 <getint>
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e28:	85 d2                	test   %edx,%edx
  800e2a:	79 23                	jns    800e4f <vprintfmt+0x29b>
				putch('-', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 2d                	push   $0x2d
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e42:	f7 d8                	neg    %eax
  800e44:	83 d2 00             	adc    $0x0,%edx
  800e47:	f7 da                	neg    %edx
  800e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e56:	e9 bc 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800e61:	8d 45 14             	lea    0x14(%ebp),%eax
  800e64:	50                   	push   %eax
  800e65:	e8 84 fc ff ff       	call   800aee <getuint>
  800e6a:	83 c4 10             	add    $0x10,%esp
  800e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e7a:	e9 98 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 58                	push   $0x58
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e8f:	83 ec 08             	sub    $0x8,%esp
  800e92:	ff 75 0c             	pushl  0xc(%ebp)
  800e95:	6a 58                	push   $0x58
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	ff d0                	call   *%eax
  800e9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	6a 58                	push   $0x58
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 bc 00 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eb4:	83 ec 08             	sub    $0x8,%esp
  800eb7:	ff 75 0c             	pushl  0xc(%ebp)
  800eba:	6a 30                	push   $0x30
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	ff d0                	call   *%eax
  800ec1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	ff 75 0c             	pushl  0xc(%ebp)
  800eca:	6a 78                	push   $0x78
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	ff d0                	call   *%eax
  800ed1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ed4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed7:	83 c0 04             	add    $0x4,%eax
  800eda:	89 45 14             	mov    %eax,0x14(%ebp)
  800edd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee0:	83 e8 04             	sub    $0x4,%eax
  800ee3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ef6:	eb 1f                	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef8:	83 ec 08             	sub    $0x8,%esp
  800efb:	ff 75 e8             	pushl  -0x18(%ebp)
  800efe:	8d 45 14             	lea    0x14(%ebp),%eax
  800f01:	50                   	push   %eax
  800f02:	e8 e7 fb ff ff       	call   800aee <getuint>
  800f07:	83 c4 10             	add    $0x10,%esp
  800f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f1e:	83 ec 04             	sub    $0x4,%esp
  800f21:	52                   	push   %edx
  800f22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f25:	50                   	push   %eax
  800f26:	ff 75 f4             	pushl  -0xc(%ebp)
  800f29:	ff 75 f0             	pushl  -0x10(%ebp)
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	ff 75 08             	pushl  0x8(%ebp)
  800f32:	e8 00 fb ff ff       	call   800a37 <printnum>
  800f37:	83 c4 20             	add    $0x20,%esp
			break;
  800f3a:	eb 34                	jmp    800f70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f3c:	83 ec 08             	sub    $0x8,%esp
  800f3f:	ff 75 0c             	pushl  0xc(%ebp)
  800f42:	53                   	push   %ebx
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	ff d0                	call   *%eax
  800f48:	83 c4 10             	add    $0x10,%esp
			break;
  800f4b:	eb 23                	jmp    800f70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	6a 25                	push   $0x25
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	ff d0                	call   *%eax
  800f5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f5d:	ff 4d 10             	decl   0x10(%ebp)
  800f60:	eb 03                	jmp    800f65 <vprintfmt+0x3b1>
  800f62:	ff 4d 10             	decl   0x10(%ebp)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	48                   	dec    %eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	3c 25                	cmp    $0x25,%al
  800f6d:	75 f3                	jne    800f62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f6f:	90                   	nop
		}
	}
  800f70:	e9 47 fc ff ff       	jmp    800bbc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    

00800f7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f83:	8d 45 10             	lea    0x10(%ebp),%eax
  800f86:	83 c0 04             	add    $0x4,%eax
  800f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	50                   	push   %eax
  800f93:	ff 75 0c             	pushl  0xc(%ebp)
  800f96:	ff 75 08             	pushl  0x8(%ebp)
  800f99:	e8 16 fc ff ff       	call   800bb4 <vprintfmt>
  800f9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fa1:	90                   	nop
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	8b 40 08             	mov    0x8(%eax),%eax
  800fad:	8d 50 01             	lea    0x1(%eax),%edx
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8b 10                	mov    (%eax),%edx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8b 40 04             	mov    0x4(%eax),%eax
  800fc1:	39 c2                	cmp    %eax,%edx
  800fc3:	73 12                	jae    800fd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	8b 00                	mov    (%eax),%eax
  800fca:	8d 48 01             	lea    0x1(%eax),%ecx
  800fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd0:	89 0a                	mov    %ecx,(%edx)
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	88 10                	mov    %dl,(%eax)
}
  800fd7:	90                   	nop
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	01 d0                	add    %edx,%eax
  800ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ffb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fff:	74 06                	je     801007 <vsnprintf+0x2d>
  801001:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801005:	7f 07                	jg     80100e <vsnprintf+0x34>
		return -E_INVAL;
  801007:	b8 03 00 00 00       	mov    $0x3,%eax
  80100c:	eb 20                	jmp    80102e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80100e:	ff 75 14             	pushl  0x14(%ebp)
  801011:	ff 75 10             	pushl  0x10(%ebp)
  801014:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801017:	50                   	push   %eax
  801018:	68 a4 0f 80 00       	push   $0x800fa4
  80101d:	e8 92 fb ff ff       	call   800bb4 <vprintfmt>
  801022:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801028:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80102b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801036:	8d 45 10             	lea    0x10(%ebp),%eax
  801039:	83 c0 04             	add    $0x4,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	ff 75 f4             	pushl  -0xc(%ebp)
  801045:	50                   	push   %eax
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	ff 75 08             	pushl  0x8(%ebp)
  80104c:	e8 89 ff ff ff       	call   800fda <vsnprintf>
  801051:	83 c4 10             	add    $0x10,%esp
  801054:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801057:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801066:	74 13                	je     80107b <readline+0x1f>
		cprintf("%s", prompt);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 08             	pushl  0x8(%ebp)
  80106e:	68 d0 3f 80 00       	push   $0x803fd0
  801073:	e8 62 f9 ff ff       	call   8009da <cprintf>
  801078:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80107b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	6a 00                	push   $0x0
  801087:	e8 54 f5 ff ff       	call   8005e0 <iscons>
  80108c:	83 c4 10             	add    $0x10,%esp
  80108f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801092:	e8 fb f4 ff ff       	call   800592 <getchar>
  801097:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80109a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80109e:	79 22                	jns    8010c2 <readline+0x66>
			if (c != -E_EOF)
  8010a0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010a4:	0f 84 ad 00 00 00    	je     801157 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8010b0:	68 d3 3f 80 00       	push   $0x803fd3
  8010b5:	e8 20 f9 ff ff       	call   8009da <cprintf>
  8010ba:	83 c4 10             	add    $0x10,%esp
			return;
  8010bd:	e9 95 00 00 00       	jmp    801157 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010c2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010c6:	7e 34                	jle    8010fc <readline+0xa0>
  8010c8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010cf:	7f 2b                	jg     8010fc <readline+0xa0>
			if (echoing)
  8010d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010d5:	74 0e                	je     8010e5 <readline+0x89>
				cputchar(c);
  8010d7:	83 ec 0c             	sub    $0xc,%esp
  8010da:	ff 75 ec             	pushl  -0x14(%ebp)
  8010dd:	e8 68 f4 ff ff       	call   80054a <cputchar>
  8010e2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8010e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	88 10                	mov    %dl,(%eax)
  8010fa:	eb 56                	jmp    801152 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8010fc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801100:	75 1f                	jne    801121 <readline+0xc5>
  801102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801106:	7e 19                	jle    801121 <readline+0xc5>
			if (echoing)
  801108:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80110c:	74 0e                	je     80111c <readline+0xc0>
				cputchar(c);
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	ff 75 ec             	pushl  -0x14(%ebp)
  801114:	e8 31 f4 ff ff       	call   80054a <cputchar>
  801119:	83 c4 10             	add    $0x10,%esp

			i--;
  80111c:	ff 4d f4             	decl   -0xc(%ebp)
  80111f:	eb 31                	jmp    801152 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801121:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801125:	74 0a                	je     801131 <readline+0xd5>
  801127:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80112b:	0f 85 61 ff ff ff    	jne    801092 <readline+0x36>
			if (echoing)
  801131:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801135:	74 0e                	je     801145 <readline+0xe9>
				cputchar(c);
  801137:	83 ec 0c             	sub    $0xc,%esp
  80113a:	ff 75 ec             	pushl  -0x14(%ebp)
  80113d:	e8 08 f4 ff ff       	call   80054a <cputchar>
  801142:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801145:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801150:	eb 06                	jmp    801158 <readline+0xfc>
		}
	}
  801152:	e9 3b ff ff ff       	jmp    801092 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801157:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801160:	e8 c2 0e 00 00       	call   802027 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	74 13                	je     80117e <atomic_readline+0x24>
		cprintf("%s", prompt);
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	ff 75 08             	pushl  0x8(%ebp)
  801171:	68 d0 3f 80 00       	push   $0x803fd0
  801176:	e8 5f f8 ff ff       	call   8009da <cprintf>
  80117b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80117e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801185:	83 ec 0c             	sub    $0xc,%esp
  801188:	6a 00                	push   $0x0
  80118a:	e8 51 f4 ff ff       	call   8005e0 <iscons>
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801195:	e8 f8 f3 ff ff       	call   800592 <getchar>
  80119a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80119d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011a1:	79 23                	jns    8011c6 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011a3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011a7:	74 13                	je     8011bc <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011a9:	83 ec 08             	sub    $0x8,%esp
  8011ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8011af:	68 d3 3f 80 00       	push   $0x803fd3
  8011b4:	e8 21 f8 ff ff       	call   8009da <cprintf>
  8011b9:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011bc:	e8 80 0e 00 00       	call   802041 <sys_enable_interrupt>
			return;
  8011c1:	e9 9a 00 00 00       	jmp    801260 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011c6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011ca:	7e 34                	jle    801200 <atomic_readline+0xa6>
  8011cc:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011d3:	7f 2b                	jg     801200 <atomic_readline+0xa6>
			if (echoing)
  8011d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011d9:	74 0e                	je     8011e9 <atomic_readline+0x8f>
				cputchar(c);
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e1:	e8 64 f3 ff ff       	call   80054a <cputchar>
  8011e6:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ec:	8d 50 01             	lea    0x1(%eax),%edx
  8011ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011f2:	89 c2                	mov    %eax,%edx
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	01 d0                	add    %edx,%eax
  8011f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011fc:	88 10                	mov    %dl,(%eax)
  8011fe:	eb 5b                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801200:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801204:	75 1f                	jne    801225 <atomic_readline+0xcb>
  801206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80120a:	7e 19                	jle    801225 <atomic_readline+0xcb>
			if (echoing)
  80120c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801210:	74 0e                	je     801220 <atomic_readline+0xc6>
				cputchar(c);
  801212:	83 ec 0c             	sub    $0xc,%esp
  801215:	ff 75 ec             	pushl  -0x14(%ebp)
  801218:	e8 2d f3 ff ff       	call   80054a <cputchar>
  80121d:	83 c4 10             	add    $0x10,%esp
			i--;
  801220:	ff 4d f4             	decl   -0xc(%ebp)
  801223:	eb 36                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801225:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801229:	74 0a                	je     801235 <atomic_readline+0xdb>
  80122b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80122f:	0f 85 60 ff ff ff    	jne    801195 <atomic_readline+0x3b>
			if (echoing)
  801235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801239:	74 0e                	je     801249 <atomic_readline+0xef>
				cputchar(c);
  80123b:	83 ec 0c             	sub    $0xc,%esp
  80123e:	ff 75 ec             	pushl  -0x14(%ebp)
  801241:	e8 04 f3 ff ff       	call   80054a <cputchar>
  801246:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801249:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	01 d0                	add    %edx,%eax
  801251:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801254:	e8 e8 0d 00 00       	call   802041 <sys_enable_interrupt>
			return;
  801259:	eb 05                	jmp    801260 <atomic_readline+0x106>
		}
	}
  80125b:	e9 35 ff ff ff       	jmp    801195 <atomic_readline+0x3b>
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126f:	eb 06                	jmp    801277 <strlen+0x15>
		n++;
  801271:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801274:	ff 45 08             	incl   0x8(%ebp)
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	84 c0                	test   %al,%al
  80127e:	75 f1                	jne    801271 <strlen+0xf>
		n++;
	return n;
  801280:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80128b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801292:	eb 09                	jmp    80129d <strnlen+0x18>
		n++;
  801294:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801297:	ff 45 08             	incl   0x8(%ebp)
  80129a:	ff 4d 0c             	decl   0xc(%ebp)
  80129d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a1:	74 09                	je     8012ac <strnlen+0x27>
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 e8                	jne    801294 <strnlen+0xf>
		n++;
	return n;
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012bd:	90                   	nop
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012d0:	8a 12                	mov    (%edx),%dl
  8012d2:	88 10                	mov    %dl,(%eax)
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 e4                	jne    8012be <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f2:	eb 1f                	jmp    801313 <strncpy+0x34>
		*dst++ = *src;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	8a 12                	mov    (%edx),%dl
  801302:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	84 c0                	test   %al,%al
  80130b:	74 03                	je     801310 <strncpy+0x31>
			src++;
  80130d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801310:	ff 45 fc             	incl   -0x4(%ebp)
  801313:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801316:	3b 45 10             	cmp    0x10(%ebp),%eax
  801319:	72 d9                	jb     8012f4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80132c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801330:	74 30                	je     801362 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801332:	eb 16                	jmp    80134a <strlcpy+0x2a>
			*dst++ = *src++;
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8d 50 01             	lea    0x1(%eax),%edx
  80133a:	89 55 08             	mov    %edx,0x8(%ebp)
  80133d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801340:	8d 4a 01             	lea    0x1(%edx),%ecx
  801343:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801346:	8a 12                	mov    (%edx),%dl
  801348:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80134a:	ff 4d 10             	decl   0x10(%ebp)
  80134d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801351:	74 09                	je     80135c <strlcpy+0x3c>
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	75 d8                	jne    801334 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801362:	8b 55 08             	mov    0x8(%ebp),%edx
  801365:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801368:	29 c2                	sub    %eax,%edx
  80136a:	89 d0                	mov    %edx,%eax
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801371:	eb 06                	jmp    801379 <strcmp+0xb>
		p++, q++;
  801373:	ff 45 08             	incl   0x8(%ebp)
  801376:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	84 c0                	test   %al,%al
  801380:	74 0e                	je     801390 <strcmp+0x22>
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 10                	mov    (%eax),%dl
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	38 c2                	cmp    %al,%dl
  80138e:	74 e3                	je     801373 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	0f b6 d0             	movzbl %al,%edx
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f b6 c0             	movzbl %al,%eax
  8013a0:	29 c2                	sub    %eax,%edx
  8013a2:	89 d0                	mov    %edx,%eax
}
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013a9:	eb 09                	jmp    8013b4 <strncmp+0xe>
		n--, p++, q++;
  8013ab:	ff 4d 10             	decl   0x10(%ebp)
  8013ae:	ff 45 08             	incl   0x8(%ebp)
  8013b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b8:	74 17                	je     8013d1 <strncmp+0x2b>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	84 c0                	test   %al,%al
  8013c1:	74 0e                	je     8013d1 <strncmp+0x2b>
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 10                	mov    (%eax),%dl
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	38 c2                	cmp    %al,%dl
  8013cf:	74 da                	je     8013ab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d5:	75 07                	jne    8013de <strncmp+0x38>
		return 0;
  8013d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dc:	eb 14                	jmp    8013f2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8a 00                	mov    (%eax),%al
  8013e3:	0f b6 d0             	movzbl %al,%edx
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	0f b6 c0             	movzbl %al,%eax
  8013ee:	29 c2                	sub    %eax,%edx
  8013f0:	89 d0                	mov    %edx,%eax
}
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801400:	eb 12                	jmp    801414 <strchr+0x20>
		if (*s == c)
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80140a:	75 05                	jne    801411 <strchr+0x1d>
			return (char *) s;
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	eb 11                	jmp    801422 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801411:	ff 45 08             	incl   0x8(%ebp)
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	75 e5                	jne    801402 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80141d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 04             	sub    $0x4,%esp
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801430:	eb 0d                	jmp    80143f <strfind+0x1b>
		if (*s == c)
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80143a:	74 0e                	je     80144a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80143c:	ff 45 08             	incl   0x8(%ebp)
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	84 c0                	test   %al,%al
  801446:	75 ea                	jne    801432 <strfind+0xe>
  801448:	eb 01                	jmp    80144b <strfind+0x27>
		if (*s == c)
			break;
  80144a:	90                   	nop
	return (char *) s;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80145c:	8b 45 10             	mov    0x10(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801462:	eb 0e                	jmp    801472 <memset+0x22>
		*p++ = c;
  801464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801467:	8d 50 01             	lea    0x1(%eax),%edx
  80146a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801470:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801472:	ff 4d f8             	decl   -0x8(%ebp)
  801475:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801479:	79 e9                	jns    801464 <memset+0x14>
		*p++ = c;

	return v;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801486:	8b 45 0c             	mov    0xc(%ebp),%eax
  801489:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801492:	eb 16                	jmp    8014aa <memcpy+0x2a>
		*d++ = *s++;
  801494:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801497:	8d 50 01             	lea    0x1(%eax),%edx
  80149a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014a6:	8a 12                	mov    (%edx),%dl
  8014a8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	75 dd                	jne    801494 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014d4:	73 50                	jae    801526 <memmove+0x6a>
  8014d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014e1:	76 43                	jbe    801526 <memmove+0x6a>
		s += n;
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014ef:	eb 10                	jmp    801501 <memmove+0x45>
			*--d = *--s;
  8014f1:	ff 4d f8             	decl   -0x8(%ebp)
  8014f4:	ff 4d fc             	decl   -0x4(%ebp)
  8014f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fa:	8a 10                	mov    (%eax),%dl
  8014fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ff:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801501:	8b 45 10             	mov    0x10(%ebp),%eax
  801504:	8d 50 ff             	lea    -0x1(%eax),%edx
  801507:	89 55 10             	mov    %edx,0x10(%ebp)
  80150a:	85 c0                	test   %eax,%eax
  80150c:	75 e3                	jne    8014f1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80150e:	eb 23                	jmp    801533 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801510:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801513:	8d 50 01             	lea    0x1(%eax),%edx
  801516:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801519:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801522:	8a 12                	mov    (%edx),%dl
  801524:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801526:	8b 45 10             	mov    0x10(%ebp),%eax
  801529:	8d 50 ff             	lea    -0x1(%eax),%edx
  80152c:	89 55 10             	mov    %edx,0x10(%ebp)
  80152f:	85 c0                	test   %eax,%eax
  801531:	75 dd                	jne    801510 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80154a:	eb 2a                	jmp    801576 <memcmp+0x3e>
		if (*s1 != *s2)
  80154c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 16                	je     801570 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80155a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	0f b6 d0             	movzbl %al,%edx
  801562:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	0f b6 c0             	movzbl %al,%eax
  80156a:	29 c2                	sub    %eax,%edx
  80156c:	89 d0                	mov    %edx,%eax
  80156e:	eb 18                	jmp    801588 <memcmp+0x50>
		s1++, s2++;
  801570:	ff 45 fc             	incl   -0x4(%ebp)
  801573:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	8d 50 ff             	lea    -0x1(%eax),%edx
  80157c:	89 55 10             	mov    %edx,0x10(%ebp)
  80157f:	85 c0                	test   %eax,%eax
  801581:	75 c9                	jne    80154c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801583:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801590:	8b 55 08             	mov    0x8(%ebp),%edx
  801593:	8b 45 10             	mov    0x10(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80159b:	eb 15                	jmp    8015b2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	0f b6 d0             	movzbl %al,%edx
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	0f b6 c0             	movzbl %al,%eax
  8015ab:	39 c2                	cmp    %eax,%edx
  8015ad:	74 0d                	je     8015bc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015b8:	72 e3                	jb     80159d <memfind+0x13>
  8015ba:	eb 01                	jmp    8015bd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015bc:	90                   	nop
	return (void *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d6:	eb 03                	jmp    8015db <strtol+0x19>
		s++;
  8015d8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 20                	cmp    $0x20,%al
  8015e2:	74 f4                	je     8015d8 <strtol+0x16>
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	3c 09                	cmp    $0x9,%al
  8015eb:	74 eb                	je     8015d8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8a 00                	mov    (%eax),%al
  8015f2:	3c 2b                	cmp    $0x2b,%al
  8015f4:	75 05                	jne    8015fb <strtol+0x39>
		s++;
  8015f6:	ff 45 08             	incl   0x8(%ebp)
  8015f9:	eb 13                	jmp    80160e <strtol+0x4c>
	else if (*s == '-')
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8a 00                	mov    (%eax),%al
  801600:	3c 2d                	cmp    $0x2d,%al
  801602:	75 0a                	jne    80160e <strtol+0x4c>
		s++, neg = 1;
  801604:	ff 45 08             	incl   0x8(%ebp)
  801607:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80160e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801612:	74 06                	je     80161a <strtol+0x58>
  801614:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801618:	75 20                	jne    80163a <strtol+0x78>
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 30                	cmp    $0x30,%al
  801621:	75 17                	jne    80163a <strtol+0x78>
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	40                   	inc    %eax
  801627:	8a 00                	mov    (%eax),%al
  801629:	3c 78                	cmp    $0x78,%al
  80162b:	75 0d                	jne    80163a <strtol+0x78>
		s += 2, base = 16;
  80162d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801631:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801638:	eb 28                	jmp    801662 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80163a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163e:	75 15                	jne    801655 <strtol+0x93>
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	8a 00                	mov    (%eax),%al
  801645:	3c 30                	cmp    $0x30,%al
  801647:	75 0c                	jne    801655 <strtol+0x93>
		s++, base = 8;
  801649:	ff 45 08             	incl   0x8(%ebp)
  80164c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801653:	eb 0d                	jmp    801662 <strtol+0xa0>
	else if (base == 0)
  801655:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801659:	75 07                	jne    801662 <strtol+0xa0>
		base = 10;
  80165b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	3c 2f                	cmp    $0x2f,%al
  801669:	7e 19                	jle    801684 <strtol+0xc2>
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	3c 39                	cmp    $0x39,%al
  801672:	7f 10                	jg     801684 <strtol+0xc2>
			dig = *s - '0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	0f be c0             	movsbl %al,%eax
  80167c:	83 e8 30             	sub    $0x30,%eax
  80167f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801682:	eb 42                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	3c 60                	cmp    $0x60,%al
  80168b:	7e 19                	jle    8016a6 <strtol+0xe4>
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	3c 7a                	cmp    $0x7a,%al
  801694:	7f 10                	jg     8016a6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	0f be c0             	movsbl %al,%eax
  80169e:	83 e8 57             	sub    $0x57,%eax
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a4:	eb 20                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	3c 40                	cmp    $0x40,%al
  8016ad:	7e 39                	jle    8016e8 <strtol+0x126>
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	3c 5a                	cmp    $0x5a,%al
  8016b6:	7f 30                	jg     8016e8 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8a 00                	mov    (%eax),%al
  8016bd:	0f be c0             	movsbl %al,%eax
  8016c0:	83 e8 37             	sub    $0x37,%eax
  8016c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016cc:	7d 19                	jge    8016e7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016d8:	89 c2                	mov    %eax,%edx
  8016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016e2:	e9 7b ff ff ff       	jmp    801662 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016e7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ec:	74 08                	je     8016f6 <strtol+0x134>
		*endptr = (char *) s;
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016fa:	74 07                	je     801703 <strtol+0x141>
  8016fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ff:	f7 d8                	neg    %eax
  801701:	eb 03                	jmp    801706 <strtol+0x144>
  801703:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <ltostr>:

void
ltostr(long value, char *str)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80170e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801715:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80171c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801720:	79 13                	jns    801735 <ltostr+0x2d>
	{
		neg = 1;
  801722:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80172f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801732:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80173d:	99                   	cltd   
  80173e:	f7 f9                	idiv   %ecx
  801740:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801743:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801746:	8d 50 01             	lea    0x1(%eax),%edx
  801749:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80174c:	89 c2                	mov    %eax,%edx
  80174e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801751:	01 d0                	add    %edx,%eax
  801753:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801756:	83 c2 30             	add    $0x30,%edx
  801759:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80175b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80175e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801763:	f7 e9                	imul   %ecx
  801765:	c1 fa 02             	sar    $0x2,%edx
  801768:	89 c8                	mov    %ecx,%eax
  80176a:	c1 f8 1f             	sar    $0x1f,%eax
  80176d:	29 c2                	sub    %eax,%edx
  80176f:	89 d0                	mov    %edx,%eax
  801771:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801774:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801777:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80177c:	f7 e9                	imul   %ecx
  80177e:	c1 fa 02             	sar    $0x2,%edx
  801781:	89 c8                	mov    %ecx,%eax
  801783:	c1 f8 1f             	sar    $0x1f,%eax
  801786:	29 c2                	sub    %eax,%edx
  801788:	89 d0                	mov    %edx,%eax
  80178a:	c1 e0 02             	shl    $0x2,%eax
  80178d:	01 d0                	add    %edx,%eax
  80178f:	01 c0                	add    %eax,%eax
  801791:	29 c1                	sub    %eax,%ecx
  801793:	89 ca                	mov    %ecx,%edx
  801795:	85 d2                	test   %edx,%edx
  801797:	75 9c                	jne    801735 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801799:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a3:	48                   	dec    %eax
  8017a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017ab:	74 3d                	je     8017ea <ltostr+0xe2>
		start = 1 ;
  8017ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017b4:	eb 34                	jmp    8017ea <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	01 c2                	add    %eax,%edx
  8017cb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	01 c8                	add    %ecx,%eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	01 c2                	add    %eax,%edx
  8017df:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017e2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017e4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017e7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017f0:	7c c4                	jl     8017b6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017fd:	90                   	nop
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801806:	ff 75 08             	pushl  0x8(%ebp)
  801809:	e8 54 fa ff ff       	call   801262 <strlen>
  80180e:	83 c4 04             	add    $0x4,%esp
  801811:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	e8 46 fa ff ff       	call   801262 <strlen>
  80181c:	83 c4 04             	add    $0x4,%esp
  80181f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801822:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801829:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801830:	eb 17                	jmp    801849 <strcconcat+0x49>
		final[s] = str1[s] ;
  801832:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801835:	8b 45 10             	mov    0x10(%ebp),%eax
  801838:	01 c2                	add    %eax,%edx
  80183a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	01 c8                	add    %ecx,%eax
  801842:	8a 00                	mov    (%eax),%al
  801844:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801846:	ff 45 fc             	incl   -0x4(%ebp)
  801849:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80184f:	7c e1                	jl     801832 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801851:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801858:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80185f:	eb 1f                	jmp    801880 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801861:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801864:	8d 50 01             	lea    0x1(%eax),%edx
  801867:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80186a:	89 c2                	mov    %eax,%edx
  80186c:	8b 45 10             	mov    0x10(%ebp),%eax
  80186f:	01 c2                	add    %eax,%edx
  801871:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801874:	8b 45 0c             	mov    0xc(%ebp),%eax
  801877:	01 c8                	add    %ecx,%eax
  801879:	8a 00                	mov    (%eax),%al
  80187b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80187d:	ff 45 f8             	incl   -0x8(%ebp)
  801880:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801883:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801886:	7c d9                	jl     801861 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801888:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188b:	8b 45 10             	mov    0x10(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	c6 00 00             	movb   $0x0,(%eax)
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801899:	8b 45 14             	mov    0x14(%ebp),%eax
  80189c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a5:	8b 00                	mov    (%eax),%eax
  8018a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018b9:	eb 0c                	jmp    8018c7 <strsplit+0x31>
			*string++ = 0;
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018c4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	84 c0                	test   %al,%al
  8018ce:	74 18                	je     8018e8 <strsplit+0x52>
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	0f be c0             	movsbl %al,%eax
  8018d8:	50                   	push   %eax
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	e8 13 fb ff ff       	call   8013f4 <strchr>
  8018e1:	83 c4 08             	add    $0x8,%esp
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	75 d3                	jne    8018bb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	8a 00                	mov    (%eax),%al
  8018ed:	84 c0                	test   %al,%al
  8018ef:	74 5a                	je     80194b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f4:	8b 00                	mov    (%eax),%eax
  8018f6:	83 f8 0f             	cmp    $0xf,%eax
  8018f9:	75 07                	jne    801902 <strsplit+0x6c>
		{
			return 0;
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801900:	eb 66                	jmp    801968 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801902:	8b 45 14             	mov    0x14(%ebp),%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	8d 48 01             	lea    0x1(%eax),%ecx
  80190a:	8b 55 14             	mov    0x14(%ebp),%edx
  80190d:	89 0a                	mov    %ecx,(%edx)
  80190f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801916:	8b 45 10             	mov    0x10(%ebp),%eax
  801919:	01 c2                	add    %eax,%edx
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801920:	eb 03                	jmp    801925 <strsplit+0x8f>
			string++;
  801922:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	8a 00                	mov    (%eax),%al
  80192a:	84 c0                	test   %al,%al
  80192c:	74 8b                	je     8018b9 <strsplit+0x23>
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f be c0             	movsbl %al,%eax
  801936:	50                   	push   %eax
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	e8 b5 fa ff ff       	call   8013f4 <strchr>
  80193f:	83 c4 08             	add    $0x8,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	74 dc                	je     801922 <strsplit+0x8c>
			string++;
	}
  801946:	e9 6e ff ff ff       	jmp    8018b9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80194b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80194c:	8b 45 14             	mov    0x14(%ebp),%eax
  80194f:	8b 00                	mov    (%eax),%eax
  801951:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801958:	8b 45 10             	mov    0x10(%ebp),%eax
  80195b:	01 d0                	add    %edx,%eax
  80195d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801963:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801970:	a1 04 50 80 00       	mov    0x805004,%eax
  801975:	85 c0                	test   %eax,%eax
  801977:	74 1f                	je     801998 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801979:	e8 1d 00 00 00       	call   80199b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	68 e4 3f 80 00       	push   $0x803fe4
  801986:	e8 4f f0 ff ff       	call   8009da <cprintf>
  80198b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80198e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801995:	00 00 00 
	}
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8019a1:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8019a8:	00 00 00 
  8019ab:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8019b2:	00 00 00 
  8019b5:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019bc:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  8019bf:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8019c6:	00 00 00 
  8019c9:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8019d0:	00 00 00 
  8019d3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8019da:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  8019dd:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019e4:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  8019e7:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8019ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019f6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019fb:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801a00:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801a07:	a1 20 51 80 00       	mov    0x805120,%eax
  801a0c:	c1 e0 04             	shl    $0x4,%eax
  801a0f:	89 c2                	mov    %eax,%edx
  801a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a14:	01 d0                	add    %edx,%eax
  801a16:	48                   	dec    %eax
  801a17:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801a1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a22:	f7 75 f0             	divl   -0x10(%ebp)
  801a25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a28:	29 d0                	sub    %edx,%eax
  801a2a:	89 c2                	mov    %eax,%edx
  801a2c:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801a33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a3b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a40:	83 ec 04             	sub    $0x4,%esp
  801a43:	6a 06                	push   $0x6
  801a45:	52                   	push   %edx
  801a46:	50                   	push   %eax
  801a47:	e8 71 05 00 00       	call   801fbd <sys_allocate_chunk>
  801a4c:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a4f:	a1 20 51 80 00       	mov    0x805120,%eax
  801a54:	83 ec 0c             	sub    $0xc,%esp
  801a57:	50                   	push   %eax
  801a58:	e8 e6 0b 00 00       	call   802643 <initialize_MemBlocksList>
  801a5d:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801a60:	a1 48 51 80 00       	mov    0x805148,%eax
  801a65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801a68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a6c:	75 14                	jne    801a82 <initialize_dyn_block_system+0xe7>
  801a6e:	83 ec 04             	sub    $0x4,%esp
  801a71:	68 09 40 80 00       	push   $0x804009
  801a76:	6a 2b                	push   $0x2b
  801a78:	68 27 40 80 00       	push   $0x804027
  801a7d:	e8 a4 ec ff ff       	call   800726 <_panic>
  801a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a85:	8b 00                	mov    (%eax),%eax
  801a87:	85 c0                	test   %eax,%eax
  801a89:	74 10                	je     801a9b <initialize_dyn_block_system+0x100>
  801a8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a8e:	8b 00                	mov    (%eax),%eax
  801a90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a93:	8b 52 04             	mov    0x4(%edx),%edx
  801a96:	89 50 04             	mov    %edx,0x4(%eax)
  801a99:	eb 0b                	jmp    801aa6 <initialize_dyn_block_system+0x10b>
  801a9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a9e:	8b 40 04             	mov    0x4(%eax),%eax
  801aa1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801aa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aa9:	8b 40 04             	mov    0x4(%eax),%eax
  801aac:	85 c0                	test   %eax,%eax
  801aae:	74 0f                	je     801abf <initialize_dyn_block_system+0x124>
  801ab0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ab3:	8b 40 04             	mov    0x4(%eax),%eax
  801ab6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ab9:	8b 12                	mov    (%edx),%edx
  801abb:	89 10                	mov    %edx,(%eax)
  801abd:	eb 0a                	jmp    801ac9 <initialize_dyn_block_system+0x12e>
  801abf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ac2:	8b 00                	mov    (%eax),%eax
  801ac4:	a3 48 51 80 00       	mov    %eax,0x805148
  801ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801acc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ad5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801adc:	a1 54 51 80 00       	mov    0x805154,%eax
  801ae1:	48                   	dec    %eax
  801ae2:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801ae7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aea:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801af1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801af4:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801afb:	83 ec 0c             	sub    $0xc,%esp
  801afe:	ff 75 e4             	pushl  -0x1c(%ebp)
  801b01:	e8 d2 13 00 00       	call   802ed8 <insert_sorted_with_merge_freeList>
  801b06:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801b09:	90                   	nop
  801b0a:	c9                   	leave  
  801b0b:	c3                   	ret    

00801b0c <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b0c:	55                   	push   %ebp
  801b0d:	89 e5                	mov    %esp,%ebp
  801b0f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b12:	e8 53 fe ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801b17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b1b:	75 07                	jne    801b24 <malloc+0x18>
  801b1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801b22:	eb 61                	jmp    801b85 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801b24:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b31:	01 d0                	add    %edx,%eax
  801b33:	48                   	dec    %eax
  801b34:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b3a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3f:	f7 75 f4             	divl   -0xc(%ebp)
  801b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b45:	29 d0                	sub    %edx,%eax
  801b47:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b4a:	e8 3c 08 00 00       	call   80238b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	74 2d                	je     801b80 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801b53:	83 ec 0c             	sub    $0xc,%esp
  801b56:	ff 75 08             	pushl  0x8(%ebp)
  801b59:	e8 3e 0f 00 00       	call   802a9c <alloc_block_FF>
  801b5e:	83 c4 10             	add    $0x10,%esp
  801b61:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801b64:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b68:	74 16                	je     801b80 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801b6a:	83 ec 0c             	sub    $0xc,%esp
  801b6d:	ff 75 ec             	pushl  -0x14(%ebp)
  801b70:	e8 48 0c 00 00       	call   8027bd <insert_sorted_allocList>
  801b75:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b7b:	8b 40 08             	mov    0x8(%eax),%eax
  801b7e:	eb 05                	jmp    801b85 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801b80:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
  801b8a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b9b:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	83 ec 08             	sub    $0x8,%esp
  801ba4:	50                   	push   %eax
  801ba5:	68 40 50 80 00       	push   $0x805040
  801baa:	e8 71 0b 00 00       	call   802720 <find_block>
  801baf:	83 c4 10             	add    $0x10,%esp
  801bb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb8:	8b 50 0c             	mov    0xc(%eax),%edx
  801bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbe:	83 ec 08             	sub    $0x8,%esp
  801bc1:	52                   	push   %edx
  801bc2:	50                   	push   %eax
  801bc3:	e8 bd 03 00 00       	call   801f85 <sys_free_user_mem>
  801bc8:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801bcb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bcf:	75 14                	jne    801be5 <free+0x5e>
  801bd1:	83 ec 04             	sub    $0x4,%esp
  801bd4:	68 09 40 80 00       	push   $0x804009
  801bd9:	6a 71                	push   $0x71
  801bdb:	68 27 40 80 00       	push   $0x804027
  801be0:	e8 41 eb ff ff       	call   800726 <_panic>
  801be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be8:	8b 00                	mov    (%eax),%eax
  801bea:	85 c0                	test   %eax,%eax
  801bec:	74 10                	je     801bfe <free+0x77>
  801bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf1:	8b 00                	mov    (%eax),%eax
  801bf3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bf6:	8b 52 04             	mov    0x4(%edx),%edx
  801bf9:	89 50 04             	mov    %edx,0x4(%eax)
  801bfc:	eb 0b                	jmp    801c09 <free+0x82>
  801bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c01:	8b 40 04             	mov    0x4(%eax),%eax
  801c04:	a3 44 50 80 00       	mov    %eax,0x805044
  801c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0c:	8b 40 04             	mov    0x4(%eax),%eax
  801c0f:	85 c0                	test   %eax,%eax
  801c11:	74 0f                	je     801c22 <free+0x9b>
  801c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c16:	8b 40 04             	mov    0x4(%eax),%eax
  801c19:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c1c:	8b 12                	mov    (%edx),%edx
  801c1e:	89 10                	mov    %edx,(%eax)
  801c20:	eb 0a                	jmp    801c2c <free+0xa5>
  801c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c25:	8b 00                	mov    (%eax),%eax
  801c27:	a3 40 50 80 00       	mov    %eax,0x805040
  801c2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c3f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c44:	48                   	dec    %eax
  801c45:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801c4a:	83 ec 0c             	sub    $0xc,%esp
  801c4d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c50:	e8 83 12 00 00       	call   802ed8 <insert_sorted_with_merge_freeList>
  801c55:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801c58:	90                   	nop
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	83 ec 28             	sub    $0x28,%esp
  801c61:	8b 45 10             	mov    0x10(%ebp),%eax
  801c64:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c67:	e8 fe fc ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801c6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c70:	75 0a                	jne    801c7c <smalloc+0x21>
  801c72:	b8 00 00 00 00       	mov    $0x0,%eax
  801c77:	e9 86 00 00 00       	jmp    801d02 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801c7c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c89:	01 d0                	add    %edx,%eax
  801c8b:	48                   	dec    %eax
  801c8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c92:	ba 00 00 00 00       	mov    $0x0,%edx
  801c97:	f7 75 f4             	divl   -0xc(%ebp)
  801c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9d:	29 d0                	sub    %edx,%eax
  801c9f:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ca2:	e8 e4 06 00 00       	call   80238b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ca7:	85 c0                	test   %eax,%eax
  801ca9:	74 52                	je     801cfd <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801cab:	83 ec 0c             	sub    $0xc,%esp
  801cae:	ff 75 0c             	pushl  0xc(%ebp)
  801cb1:	e8 e6 0d 00 00       	call   802a9c <alloc_block_FF>
  801cb6:	83 c4 10             	add    $0x10,%esp
  801cb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801cbc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cc0:	75 07                	jne    801cc9 <smalloc+0x6e>
			return NULL ;
  801cc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc7:	eb 39                	jmp    801d02 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ccc:	8b 40 08             	mov    0x8(%eax),%eax
  801ccf:	89 c2                	mov    %eax,%edx
  801cd1:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801cd5:	52                   	push   %edx
  801cd6:	50                   	push   %eax
  801cd7:	ff 75 0c             	pushl  0xc(%ebp)
  801cda:	ff 75 08             	pushl  0x8(%ebp)
  801cdd:	e8 2e 04 00 00       	call   802110 <sys_createSharedObject>
  801ce2:	83 c4 10             	add    $0x10,%esp
  801ce5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801ce8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801cec:	79 07                	jns    801cf5 <smalloc+0x9a>
			return (void*)NULL ;
  801cee:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf3:	eb 0d                	jmp    801d02 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801cf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf8:	8b 40 08             	mov    0x8(%eax),%eax
  801cfb:	eb 05                	jmp    801d02 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801cfd:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d0a:	e8 5b fc ff ff       	call   80196a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801d0f:	83 ec 08             	sub    $0x8,%esp
  801d12:	ff 75 0c             	pushl  0xc(%ebp)
  801d15:	ff 75 08             	pushl  0x8(%ebp)
  801d18:	e8 1d 04 00 00       	call   80213a <sys_getSizeOfSharedObject>
  801d1d:	83 c4 10             	add    $0x10,%esp
  801d20:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801d23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d27:	75 0a                	jne    801d33 <sget+0x2f>
			return NULL ;
  801d29:	b8 00 00 00 00       	mov    $0x0,%eax
  801d2e:	e9 83 00 00 00       	jmp    801db6 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801d33:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d40:	01 d0                	add    %edx,%eax
  801d42:	48                   	dec    %eax
  801d43:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d49:	ba 00 00 00 00       	mov    $0x0,%edx
  801d4e:	f7 75 f0             	divl   -0x10(%ebp)
  801d51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d54:	29 d0                	sub    %edx,%eax
  801d56:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d59:	e8 2d 06 00 00       	call   80238b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	74 4f                	je     801db1 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d65:	83 ec 0c             	sub    $0xc,%esp
  801d68:	50                   	push   %eax
  801d69:	e8 2e 0d 00 00       	call   802a9c <alloc_block_FF>
  801d6e:	83 c4 10             	add    $0x10,%esp
  801d71:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801d74:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d78:	75 07                	jne    801d81 <sget+0x7d>
					return (void*)NULL ;
  801d7a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7f:	eb 35                	jmp    801db6 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801d81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d84:	8b 40 08             	mov    0x8(%eax),%eax
  801d87:	83 ec 04             	sub    $0x4,%esp
  801d8a:	50                   	push   %eax
  801d8b:	ff 75 0c             	pushl  0xc(%ebp)
  801d8e:	ff 75 08             	pushl  0x8(%ebp)
  801d91:	e8 c1 03 00 00       	call   802157 <sys_getSharedObject>
  801d96:	83 c4 10             	add    $0x10,%esp
  801d99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801d9c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801da0:	79 07                	jns    801da9 <sget+0xa5>
				return (void*)NULL ;
  801da2:	b8 00 00 00 00       	mov    $0x0,%eax
  801da7:	eb 0d                	jmp    801db6 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801da9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dac:	8b 40 08             	mov    0x8(%eax),%eax
  801daf:	eb 05                	jmp    801db6 <sget+0xb2>


		}
	return (void*)NULL ;
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dbe:	e8 a7 fb ff ff       	call   80196a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801dc3:	83 ec 04             	sub    $0x4,%esp
  801dc6:	68 34 40 80 00       	push   $0x804034
  801dcb:	68 f9 00 00 00       	push   $0xf9
  801dd0:	68 27 40 80 00       	push   $0x804027
  801dd5:	e8 4c e9 ff ff       	call   800726 <_panic>

00801dda <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
  801ddd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801de0:	83 ec 04             	sub    $0x4,%esp
  801de3:	68 5c 40 80 00       	push   $0x80405c
  801de8:	68 0d 01 00 00       	push   $0x10d
  801ded:	68 27 40 80 00       	push   $0x804027
  801df2:	e8 2f e9 ff ff       	call   800726 <_panic>

00801df7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dfd:	83 ec 04             	sub    $0x4,%esp
  801e00:	68 80 40 80 00       	push   $0x804080
  801e05:	68 18 01 00 00       	push   $0x118
  801e0a:	68 27 40 80 00       	push   $0x804027
  801e0f:	e8 12 e9 ff ff       	call   800726 <_panic>

00801e14 <shrink>:

}
void shrink(uint32 newSize)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e1a:	83 ec 04             	sub    $0x4,%esp
  801e1d:	68 80 40 80 00       	push   $0x804080
  801e22:	68 1d 01 00 00       	push   $0x11d
  801e27:	68 27 40 80 00       	push   $0x804027
  801e2c:	e8 f5 e8 ff ff       	call   800726 <_panic>

00801e31 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e37:	83 ec 04             	sub    $0x4,%esp
  801e3a:	68 80 40 80 00       	push   $0x804080
  801e3f:	68 22 01 00 00       	push   $0x122
  801e44:	68 27 40 80 00       	push   $0x804027
  801e49:	e8 d8 e8 ff ff       	call   800726 <_panic>

00801e4e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	57                   	push   %edi
  801e52:	56                   	push   %esi
  801e53:	53                   	push   %ebx
  801e54:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e60:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e63:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e66:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e69:	cd 30                	int    $0x30
  801e6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	5b                   	pop    %ebx
  801e75:	5e                   	pop    %esi
  801e76:	5f                   	pop    %edi
  801e77:	5d                   	pop    %ebp
  801e78:	c3                   	ret    

00801e79 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	83 ec 04             	sub    $0x4,%esp
  801e7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e82:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e85:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	52                   	push   %edx
  801e91:	ff 75 0c             	pushl  0xc(%ebp)
  801e94:	50                   	push   %eax
  801e95:	6a 00                	push   $0x0
  801e97:	e8 b2 ff ff ff       	call   801e4e <syscall>
  801e9c:	83 c4 18             	add    $0x18,%esp
}
  801e9f:	90                   	nop
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 01                	push   $0x1
  801eb1:	e8 98 ff ff ff       	call   801e4e <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ebe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	52                   	push   %edx
  801ecb:	50                   	push   %eax
  801ecc:	6a 05                	push   $0x5
  801ece:	e8 7b ff ff ff       	call   801e4e <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
}
  801ed6:	c9                   	leave  
  801ed7:	c3                   	ret    

00801ed8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801ed8:	55                   	push   %ebp
  801ed9:	89 e5                	mov    %esp,%ebp
  801edb:	56                   	push   %esi
  801edc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801edd:	8b 75 18             	mov    0x18(%ebp),%esi
  801ee0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eec:	56                   	push   %esi
  801eed:	53                   	push   %ebx
  801eee:	51                   	push   %ecx
  801eef:	52                   	push   %edx
  801ef0:	50                   	push   %eax
  801ef1:	6a 06                	push   $0x6
  801ef3:	e8 56 ff ff ff       	call   801e4e <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
}
  801efb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801efe:	5b                   	pop    %ebx
  801eff:	5e                   	pop    %esi
  801f00:	5d                   	pop    %ebp
  801f01:	c3                   	ret    

00801f02 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801f05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	52                   	push   %edx
  801f12:	50                   	push   %eax
  801f13:	6a 07                	push   $0x7
  801f15:	e8 34 ff ff ff       	call   801e4e <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
}
  801f1d:	c9                   	leave  
  801f1e:	c3                   	ret    

00801f1f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	ff 75 0c             	pushl  0xc(%ebp)
  801f2b:	ff 75 08             	pushl  0x8(%ebp)
  801f2e:	6a 08                	push   $0x8
  801f30:	e8 19 ff ff ff       	call   801e4e <syscall>
  801f35:	83 c4 18             	add    $0x18,%esp
}
  801f38:	c9                   	leave  
  801f39:	c3                   	ret    

00801f3a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f3a:	55                   	push   %ebp
  801f3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 00                	push   $0x0
  801f47:	6a 09                	push   $0x9
  801f49:	e8 00 ff ff ff       	call   801e4e <syscall>
  801f4e:	83 c4 18             	add    $0x18,%esp
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 0a                	push   $0xa
  801f62:	e8 e7 fe ff ff       	call   801e4e <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 0b                	push   $0xb
  801f7b:	e8 ce fe ff ff       	call   801e4e <syscall>
  801f80:	83 c4 18             	add    $0x18,%esp
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	ff 75 0c             	pushl  0xc(%ebp)
  801f91:	ff 75 08             	pushl  0x8(%ebp)
  801f94:	6a 0f                	push   $0xf
  801f96:	e8 b3 fe ff ff       	call   801e4e <syscall>
  801f9b:	83 c4 18             	add    $0x18,%esp
	return;
  801f9e:	90                   	nop
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	ff 75 0c             	pushl  0xc(%ebp)
  801fad:	ff 75 08             	pushl  0x8(%ebp)
  801fb0:	6a 10                	push   $0x10
  801fb2:	e8 97 fe ff ff       	call   801e4e <syscall>
  801fb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801fba:	90                   	nop
}
  801fbb:	c9                   	leave  
  801fbc:	c3                   	ret    

00801fbd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801fbd:	55                   	push   %ebp
  801fbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fc0:	6a 00                	push   $0x0
  801fc2:	6a 00                	push   $0x0
  801fc4:	ff 75 10             	pushl  0x10(%ebp)
  801fc7:	ff 75 0c             	pushl  0xc(%ebp)
  801fca:	ff 75 08             	pushl  0x8(%ebp)
  801fcd:	6a 11                	push   $0x11
  801fcf:	e8 7a fe ff ff       	call   801e4e <syscall>
  801fd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fd7:	90                   	nop
}
  801fd8:	c9                   	leave  
  801fd9:	c3                   	ret    

00801fda <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fda:	55                   	push   %ebp
  801fdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 0c                	push   $0xc
  801fe9:	e8 60 fe ff ff       	call   801e4e <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 00                	push   $0x0
  801ffc:	6a 00                	push   $0x0
  801ffe:	ff 75 08             	pushl  0x8(%ebp)
  802001:	6a 0d                	push   $0xd
  802003:	e8 46 fe ff ff       	call   801e4e <syscall>
  802008:	83 c4 18             	add    $0x18,%esp
}
  80200b:	c9                   	leave  
  80200c:	c3                   	ret    

0080200d <sys_scarce_memory>:

void sys_scarce_memory()
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 0e                	push   $0xe
  80201c:	e8 2d fe ff ff       	call   801e4e <syscall>
  802021:	83 c4 18             	add    $0x18,%esp
}
  802024:	90                   	nop
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 13                	push   $0x13
  802036:	e8 13 fe ff ff       	call   801e4e <syscall>
  80203b:	83 c4 18             	add    $0x18,%esp
}
  80203e:	90                   	nop
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 14                	push   $0x14
  802050:	e8 f9 fd ff ff       	call   801e4e <syscall>
  802055:	83 c4 18             	add    $0x18,%esp
}
  802058:	90                   	nop
  802059:	c9                   	leave  
  80205a:	c3                   	ret    

0080205b <sys_cputc>:


void
sys_cputc(const char c)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	83 ec 04             	sub    $0x4,%esp
  802061:	8b 45 08             	mov    0x8(%ebp),%eax
  802064:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802067:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	50                   	push   %eax
  802074:	6a 15                	push   $0x15
  802076:	e8 d3 fd ff ff       	call   801e4e <syscall>
  80207b:	83 c4 18             	add    $0x18,%esp
}
  80207e:	90                   	nop
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 16                	push   $0x16
  802090:	e8 b9 fd ff ff       	call   801e4e <syscall>
  802095:	83 c4 18             	add    $0x18,%esp
}
  802098:	90                   	nop
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	ff 75 0c             	pushl  0xc(%ebp)
  8020aa:	50                   	push   %eax
  8020ab:	6a 17                	push   $0x17
  8020ad:	e8 9c fd ff ff       	call   801e4e <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	52                   	push   %edx
  8020c7:	50                   	push   %eax
  8020c8:	6a 1a                	push   $0x1a
  8020ca:	e8 7f fd ff ff       	call   801e4e <syscall>
  8020cf:	83 c4 18             	add    $0x18,%esp
}
  8020d2:	c9                   	leave  
  8020d3:	c3                   	ret    

008020d4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020d4:	55                   	push   %ebp
  8020d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	52                   	push   %edx
  8020e4:	50                   	push   %eax
  8020e5:	6a 18                	push   $0x18
  8020e7:	e8 62 fd ff ff       	call   801e4e <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	90                   	nop
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	52                   	push   %edx
  802102:	50                   	push   %eax
  802103:	6a 19                	push   $0x19
  802105:	e8 44 fd ff ff       	call   801e4e <syscall>
  80210a:	83 c4 18             	add    $0x18,%esp
}
  80210d:	90                   	nop
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	83 ec 04             	sub    $0x4,%esp
  802116:	8b 45 10             	mov    0x10(%ebp),%eax
  802119:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80211c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80211f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802123:	8b 45 08             	mov    0x8(%ebp),%eax
  802126:	6a 00                	push   $0x0
  802128:	51                   	push   %ecx
  802129:	52                   	push   %edx
  80212a:	ff 75 0c             	pushl  0xc(%ebp)
  80212d:	50                   	push   %eax
  80212e:	6a 1b                	push   $0x1b
  802130:	e8 19 fd ff ff       	call   801e4e <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80213d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	6a 00                	push   $0x0
  802149:	52                   	push   %edx
  80214a:	50                   	push   %eax
  80214b:	6a 1c                	push   $0x1c
  80214d:	e8 fc fc ff ff       	call   801e4e <syscall>
  802152:	83 c4 18             	add    $0x18,%esp
}
  802155:	c9                   	leave  
  802156:	c3                   	ret    

00802157 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802157:	55                   	push   %ebp
  802158:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80215a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80215d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	51                   	push   %ecx
  802168:	52                   	push   %edx
  802169:	50                   	push   %eax
  80216a:	6a 1d                	push   $0x1d
  80216c:	e8 dd fc ff ff       	call   801e4e <syscall>
  802171:	83 c4 18             	add    $0x18,%esp
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802179:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	52                   	push   %edx
  802186:	50                   	push   %eax
  802187:	6a 1e                	push   $0x1e
  802189:	e8 c0 fc ff ff       	call   801e4e <syscall>
  80218e:	83 c4 18             	add    $0x18,%esp
}
  802191:	c9                   	leave  
  802192:	c3                   	ret    

00802193 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 00                	push   $0x0
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 1f                	push   $0x1f
  8021a2:	e8 a7 fc ff ff       	call   801e4e <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	6a 00                	push   $0x0
  8021b4:	ff 75 14             	pushl  0x14(%ebp)
  8021b7:	ff 75 10             	pushl  0x10(%ebp)
  8021ba:	ff 75 0c             	pushl  0xc(%ebp)
  8021bd:	50                   	push   %eax
  8021be:	6a 20                	push   $0x20
  8021c0:	e8 89 fc ff ff       	call   801e4e <syscall>
  8021c5:	83 c4 18             	add    $0x18,%esp
}
  8021c8:	c9                   	leave  
  8021c9:	c3                   	ret    

008021ca <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	50                   	push   %eax
  8021d9:	6a 21                	push   $0x21
  8021db:	e8 6e fc ff ff       	call   801e4e <syscall>
  8021e0:	83 c4 18             	add    $0x18,%esp
}
  8021e3:	90                   	nop
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	50                   	push   %eax
  8021f5:	6a 22                	push   $0x22
  8021f7:	e8 52 fc ff ff       	call   801e4e <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 02                	push   $0x2
  802210:	e8 39 fc ff ff       	call   801e4e <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 03                	push   $0x3
  802229:	e8 20 fc ff ff       	call   801e4e <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 04                	push   $0x4
  802242:	e8 07 fc ff ff       	call   801e4e <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_exit_env>:


void sys_exit_env(void)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 23                	push   $0x23
  80225b:	e8 ee fb ff ff       	call   801e4e <syscall>
  802260:	83 c4 18             	add    $0x18,%esp
}
  802263:	90                   	nop
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80226c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80226f:	8d 50 04             	lea    0x4(%eax),%edx
  802272:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	52                   	push   %edx
  80227c:	50                   	push   %eax
  80227d:	6a 24                	push   $0x24
  80227f:	e8 ca fb ff ff       	call   801e4e <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
	return result;
  802287:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80228a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80228d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802290:	89 01                	mov    %eax,(%ecx)
  802292:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	c9                   	leave  
  802299:	c2 04 00             	ret    $0x4

0080229c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	ff 75 10             	pushl  0x10(%ebp)
  8022a6:	ff 75 0c             	pushl  0xc(%ebp)
  8022a9:	ff 75 08             	pushl  0x8(%ebp)
  8022ac:	6a 12                	push   $0x12
  8022ae:	e8 9b fb ff ff       	call   801e4e <syscall>
  8022b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8022b6:	90                   	nop
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 25                	push   $0x25
  8022c8:	e8 81 fb ff ff       	call   801e4e <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	83 ec 04             	sub    $0x4,%esp
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022de:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	50                   	push   %eax
  8022eb:	6a 26                	push   $0x26
  8022ed:	e8 5c fb ff ff       	call   801e4e <syscall>
  8022f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022f5:	90                   	nop
}
  8022f6:	c9                   	leave  
  8022f7:	c3                   	ret    

008022f8 <rsttst>:
void rsttst()
{
  8022f8:	55                   	push   %ebp
  8022f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 28                	push   $0x28
  802307:	e8 42 fb ff ff       	call   801e4e <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
	return ;
  80230f:	90                   	nop
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
  802315:	83 ec 04             	sub    $0x4,%esp
  802318:	8b 45 14             	mov    0x14(%ebp),%eax
  80231b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80231e:	8b 55 18             	mov    0x18(%ebp),%edx
  802321:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802325:	52                   	push   %edx
  802326:	50                   	push   %eax
  802327:	ff 75 10             	pushl  0x10(%ebp)
  80232a:	ff 75 0c             	pushl  0xc(%ebp)
  80232d:	ff 75 08             	pushl  0x8(%ebp)
  802330:	6a 27                	push   $0x27
  802332:	e8 17 fb ff ff       	call   801e4e <syscall>
  802337:	83 c4 18             	add    $0x18,%esp
	return ;
  80233a:	90                   	nop
}
  80233b:	c9                   	leave  
  80233c:	c3                   	ret    

0080233d <chktst>:
void chktst(uint32 n)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	ff 75 08             	pushl  0x8(%ebp)
  80234b:	6a 29                	push   $0x29
  80234d:	e8 fc fa ff ff       	call   801e4e <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
	return ;
  802355:	90                   	nop
}
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <inctst>:

void inctst()
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	6a 2a                	push   $0x2a
  802367:	e8 e2 fa ff ff       	call   801e4e <syscall>
  80236c:	83 c4 18             	add    $0x18,%esp
	return ;
  80236f:	90                   	nop
}
  802370:	c9                   	leave  
  802371:	c3                   	ret    

00802372 <gettst>:
uint32 gettst()
{
  802372:	55                   	push   %ebp
  802373:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 2b                	push   $0x2b
  802381:	e8 c8 fa ff ff       	call   801e4e <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
}
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	6a 00                	push   $0x0
  802397:	6a 00                	push   $0x0
  802399:	6a 00                	push   $0x0
  80239b:	6a 2c                	push   $0x2c
  80239d:	e8 ac fa ff ff       	call   801e4e <syscall>
  8023a2:	83 c4 18             	add    $0x18,%esp
  8023a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8023a8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8023ac:	75 07                	jne    8023b5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	eb 05                	jmp    8023ba <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8023b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 2c                	push   $0x2c
  8023ce:	e8 7b fa ff ff       	call   801e4e <syscall>
  8023d3:	83 c4 18             	add    $0x18,%esp
  8023d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023d9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023dd:	75 07                	jne    8023e6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023df:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e4:	eb 05                	jmp    8023eb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
  8023f0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 2c                	push   $0x2c
  8023ff:	e8 4a fa ff ff       	call   801e4e <syscall>
  802404:	83 c4 18             	add    $0x18,%esp
  802407:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80240a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80240e:	75 07                	jne    802417 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802410:	b8 01 00 00 00       	mov    $0x1,%eax
  802415:	eb 05                	jmp    80241c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802417:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80241c:	c9                   	leave  
  80241d:	c3                   	ret    

0080241e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 2c                	push   $0x2c
  802430:	e8 19 fa ff ff       	call   801e4e <syscall>
  802435:	83 c4 18             	add    $0x18,%esp
  802438:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80243b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80243f:	75 07                	jne    802448 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802441:	b8 01 00 00 00       	mov    $0x1,%eax
  802446:	eb 05                	jmp    80244d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802448:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	ff 75 08             	pushl  0x8(%ebp)
  80245d:	6a 2d                	push   $0x2d
  80245f:	e8 ea f9 ff ff       	call   801e4e <syscall>
  802464:	83 c4 18             	add    $0x18,%esp
	return ;
  802467:	90                   	nop
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
  80246d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80246e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802471:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802474:	8b 55 0c             	mov    0xc(%ebp),%edx
  802477:	8b 45 08             	mov    0x8(%ebp),%eax
  80247a:	6a 00                	push   $0x0
  80247c:	53                   	push   %ebx
  80247d:	51                   	push   %ecx
  80247e:	52                   	push   %edx
  80247f:	50                   	push   %eax
  802480:	6a 2e                	push   $0x2e
  802482:	e8 c7 f9 ff ff       	call   801e4e <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
}
  80248a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80248d:	c9                   	leave  
  80248e:	c3                   	ret    

0080248f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80248f:	55                   	push   %ebp
  802490:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802492:	8b 55 0c             	mov    0xc(%ebp),%edx
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	52                   	push   %edx
  80249f:	50                   	push   %eax
  8024a0:	6a 2f                	push   $0x2f
  8024a2:	e8 a7 f9 ff ff       	call   801e4e <syscall>
  8024a7:	83 c4 18             	add    $0x18,%esp
}
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
  8024af:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8024b2:	83 ec 0c             	sub    $0xc,%esp
  8024b5:	68 90 40 80 00       	push   $0x804090
  8024ba:	e8 1b e5 ff ff       	call   8009da <cprintf>
  8024bf:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024c9:	83 ec 0c             	sub    $0xc,%esp
  8024cc:	68 bc 40 80 00       	push   $0x8040bc
  8024d1:	e8 04 e5 ff ff       	call   8009da <cprintf>
  8024d6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024d9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024dd:	a1 38 51 80 00       	mov    0x805138,%eax
  8024e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e5:	eb 56                	jmp    80253d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024eb:	74 1c                	je     802509 <print_mem_block_lists+0x5d>
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 50 08             	mov    0x8(%eax),%edx
  8024f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f6:	8b 48 08             	mov    0x8(%eax),%ecx
  8024f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ff:	01 c8                	add    %ecx,%eax
  802501:	39 c2                	cmp    %eax,%edx
  802503:	73 04                	jae    802509 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802505:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 50 08             	mov    0x8(%eax),%edx
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	8b 40 0c             	mov    0xc(%eax),%eax
  802515:	01 c2                	add    %eax,%edx
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	8b 40 08             	mov    0x8(%eax),%eax
  80251d:	83 ec 04             	sub    $0x4,%esp
  802520:	52                   	push   %edx
  802521:	50                   	push   %eax
  802522:	68 d1 40 80 00       	push   $0x8040d1
  802527:	e8 ae e4 ff ff       	call   8009da <cprintf>
  80252c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802535:	a1 40 51 80 00       	mov    0x805140,%eax
  80253a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802541:	74 07                	je     80254a <print_mem_block_lists+0x9e>
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	eb 05                	jmp    80254f <print_mem_block_lists+0xa3>
  80254a:	b8 00 00 00 00       	mov    $0x0,%eax
  80254f:	a3 40 51 80 00       	mov    %eax,0x805140
  802554:	a1 40 51 80 00       	mov    0x805140,%eax
  802559:	85 c0                	test   %eax,%eax
  80255b:	75 8a                	jne    8024e7 <print_mem_block_lists+0x3b>
  80255d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802561:	75 84                	jne    8024e7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802563:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802567:	75 10                	jne    802579 <print_mem_block_lists+0xcd>
  802569:	83 ec 0c             	sub    $0xc,%esp
  80256c:	68 e0 40 80 00       	push   $0x8040e0
  802571:	e8 64 e4 ff ff       	call   8009da <cprintf>
  802576:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802579:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802580:	83 ec 0c             	sub    $0xc,%esp
  802583:	68 04 41 80 00       	push   $0x804104
  802588:	e8 4d e4 ff ff       	call   8009da <cprintf>
  80258d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802590:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802594:	a1 40 50 80 00       	mov    0x805040,%eax
  802599:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259c:	eb 56                	jmp    8025f4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80259e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025a2:	74 1c                	je     8025c0 <print_mem_block_lists+0x114>
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 50 08             	mov    0x8(%eax),%edx
  8025aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ad:	8b 48 08             	mov    0x8(%eax),%ecx
  8025b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b6:	01 c8                	add    %ecx,%eax
  8025b8:	39 c2                	cmp    %eax,%edx
  8025ba:	73 04                	jae    8025c0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8025bc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 50 08             	mov    0x8(%eax),%edx
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cc:	01 c2                	add    %eax,%edx
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 40 08             	mov    0x8(%eax),%eax
  8025d4:	83 ec 04             	sub    $0x4,%esp
  8025d7:	52                   	push   %edx
  8025d8:	50                   	push   %eax
  8025d9:	68 d1 40 80 00       	push   $0x8040d1
  8025de:	e8 f7 e3 ff ff       	call   8009da <cprintf>
  8025e3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025ec:	a1 48 50 80 00       	mov    0x805048,%eax
  8025f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f8:	74 07                	je     802601 <print_mem_block_lists+0x155>
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	eb 05                	jmp    802606 <print_mem_block_lists+0x15a>
  802601:	b8 00 00 00 00       	mov    $0x0,%eax
  802606:	a3 48 50 80 00       	mov    %eax,0x805048
  80260b:	a1 48 50 80 00       	mov    0x805048,%eax
  802610:	85 c0                	test   %eax,%eax
  802612:	75 8a                	jne    80259e <print_mem_block_lists+0xf2>
  802614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802618:	75 84                	jne    80259e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80261a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80261e:	75 10                	jne    802630 <print_mem_block_lists+0x184>
  802620:	83 ec 0c             	sub    $0xc,%esp
  802623:	68 1c 41 80 00       	push   $0x80411c
  802628:	e8 ad e3 ff ff       	call   8009da <cprintf>
  80262d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802630:	83 ec 0c             	sub    $0xc,%esp
  802633:	68 90 40 80 00       	push   $0x804090
  802638:	e8 9d e3 ff ff       	call   8009da <cprintf>
  80263d:	83 c4 10             	add    $0x10,%esp

}
  802640:	90                   	nop
  802641:	c9                   	leave  
  802642:	c3                   	ret    

00802643 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802643:	55                   	push   %ebp
  802644:	89 e5                	mov    %esp,%ebp
  802646:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802649:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802650:	00 00 00 
  802653:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80265a:	00 00 00 
  80265d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802664:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802667:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80266e:	e9 9e 00 00 00       	jmp    802711 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802673:	a1 50 50 80 00       	mov    0x805050,%eax
  802678:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267b:	c1 e2 04             	shl    $0x4,%edx
  80267e:	01 d0                	add    %edx,%eax
  802680:	85 c0                	test   %eax,%eax
  802682:	75 14                	jne    802698 <initialize_MemBlocksList+0x55>
  802684:	83 ec 04             	sub    $0x4,%esp
  802687:	68 44 41 80 00       	push   $0x804144
  80268c:	6a 43                	push   $0x43
  80268e:	68 67 41 80 00       	push   $0x804167
  802693:	e8 8e e0 ff ff       	call   800726 <_panic>
  802698:	a1 50 50 80 00       	mov    0x805050,%eax
  80269d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a0:	c1 e2 04             	shl    $0x4,%edx
  8026a3:	01 d0                	add    %edx,%eax
  8026a5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8026ab:	89 10                	mov    %edx,(%eax)
  8026ad:	8b 00                	mov    (%eax),%eax
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	74 18                	je     8026cb <initialize_MemBlocksList+0x88>
  8026b3:	a1 48 51 80 00       	mov    0x805148,%eax
  8026b8:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8026be:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026c1:	c1 e1 04             	shl    $0x4,%ecx
  8026c4:	01 ca                	add    %ecx,%edx
  8026c6:	89 50 04             	mov    %edx,0x4(%eax)
  8026c9:	eb 12                	jmp    8026dd <initialize_MemBlocksList+0x9a>
  8026cb:	a1 50 50 80 00       	mov    0x805050,%eax
  8026d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d3:	c1 e2 04             	shl    $0x4,%edx
  8026d6:	01 d0                	add    %edx,%eax
  8026d8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8026e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e5:	c1 e2 04             	shl    $0x4,%edx
  8026e8:	01 d0                	add    %edx,%eax
  8026ea:	a3 48 51 80 00       	mov    %eax,0x805148
  8026ef:	a1 50 50 80 00       	mov    0x805050,%eax
  8026f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f7:	c1 e2 04             	shl    $0x4,%edx
  8026fa:	01 d0                	add    %edx,%eax
  8026fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802703:	a1 54 51 80 00       	mov    0x805154,%eax
  802708:	40                   	inc    %eax
  802709:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80270e:	ff 45 f4             	incl   -0xc(%ebp)
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	3b 45 08             	cmp    0x8(%ebp),%eax
  802717:	0f 82 56 ff ff ff    	jb     802673 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  80271d:	90                   	nop
  80271e:	c9                   	leave  
  80271f:	c3                   	ret    

00802720 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
  802723:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802726:	a1 38 51 80 00       	mov    0x805138,%eax
  80272b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80272e:	eb 18                	jmp    802748 <find_block+0x28>
	{
		if (ele->sva==va)
  802730:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802733:	8b 40 08             	mov    0x8(%eax),%eax
  802736:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802739:	75 05                	jne    802740 <find_block+0x20>
			return ele;
  80273b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80273e:	eb 7b                	jmp    8027bb <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802740:	a1 40 51 80 00       	mov    0x805140,%eax
  802745:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802748:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80274c:	74 07                	je     802755 <find_block+0x35>
  80274e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	eb 05                	jmp    80275a <find_block+0x3a>
  802755:	b8 00 00 00 00       	mov    $0x0,%eax
  80275a:	a3 40 51 80 00       	mov    %eax,0x805140
  80275f:	a1 40 51 80 00       	mov    0x805140,%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	75 c8                	jne    802730 <find_block+0x10>
  802768:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80276c:	75 c2                	jne    802730 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80276e:	a1 40 50 80 00       	mov    0x805040,%eax
  802773:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802776:	eb 18                	jmp    802790 <find_block+0x70>
	{
		if (ele->sva==va)
  802778:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80277b:	8b 40 08             	mov    0x8(%eax),%eax
  80277e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802781:	75 05                	jne    802788 <find_block+0x68>
					return ele;
  802783:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802786:	eb 33                	jmp    8027bb <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802788:	a1 48 50 80 00       	mov    0x805048,%eax
  80278d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802790:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802794:	74 07                	je     80279d <find_block+0x7d>
  802796:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802799:	8b 00                	mov    (%eax),%eax
  80279b:	eb 05                	jmp    8027a2 <find_block+0x82>
  80279d:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a2:	a3 48 50 80 00       	mov    %eax,0x805048
  8027a7:	a1 48 50 80 00       	mov    0x805048,%eax
  8027ac:	85 c0                	test   %eax,%eax
  8027ae:	75 c8                	jne    802778 <find_block+0x58>
  8027b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027b4:	75 c2                	jne    802778 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8027bb:	c9                   	leave  
  8027bc:	c3                   	ret    

008027bd <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027bd:	55                   	push   %ebp
  8027be:	89 e5                	mov    %esp,%ebp
  8027c0:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  8027c3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027c8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  8027cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027cf:	75 62                	jne    802833 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8027d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027d5:	75 14                	jne    8027eb <insert_sorted_allocList+0x2e>
  8027d7:	83 ec 04             	sub    $0x4,%esp
  8027da:	68 44 41 80 00       	push   $0x804144
  8027df:	6a 69                	push   $0x69
  8027e1:	68 67 41 80 00       	push   $0x804167
  8027e6:	e8 3b df ff ff       	call   800726 <_panic>
  8027eb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f4:	89 10                	mov    %edx,(%eax)
  8027f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f9:	8b 00                	mov    (%eax),%eax
  8027fb:	85 c0                	test   %eax,%eax
  8027fd:	74 0d                	je     80280c <insert_sorted_allocList+0x4f>
  8027ff:	a1 40 50 80 00       	mov    0x805040,%eax
  802804:	8b 55 08             	mov    0x8(%ebp),%edx
  802807:	89 50 04             	mov    %edx,0x4(%eax)
  80280a:	eb 08                	jmp    802814 <insert_sorted_allocList+0x57>
  80280c:	8b 45 08             	mov    0x8(%ebp),%eax
  80280f:	a3 44 50 80 00       	mov    %eax,0x805044
  802814:	8b 45 08             	mov    0x8(%ebp),%eax
  802817:	a3 40 50 80 00       	mov    %eax,0x805040
  80281c:	8b 45 08             	mov    0x8(%ebp),%eax
  80281f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802826:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80282b:	40                   	inc    %eax
  80282c:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802831:	eb 72                	jmp    8028a5 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802833:	a1 40 50 80 00       	mov    0x805040,%eax
  802838:	8b 50 08             	mov    0x8(%eax),%edx
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	8b 40 08             	mov    0x8(%eax),%eax
  802841:	39 c2                	cmp    %eax,%edx
  802843:	76 60                	jbe    8028a5 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802845:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802849:	75 14                	jne    80285f <insert_sorted_allocList+0xa2>
  80284b:	83 ec 04             	sub    $0x4,%esp
  80284e:	68 44 41 80 00       	push   $0x804144
  802853:	6a 6d                	push   $0x6d
  802855:	68 67 41 80 00       	push   $0x804167
  80285a:	e8 c7 de ff ff       	call   800726 <_panic>
  80285f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802865:	8b 45 08             	mov    0x8(%ebp),%eax
  802868:	89 10                	mov    %edx,(%eax)
  80286a:	8b 45 08             	mov    0x8(%ebp),%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	85 c0                	test   %eax,%eax
  802871:	74 0d                	je     802880 <insert_sorted_allocList+0xc3>
  802873:	a1 40 50 80 00       	mov    0x805040,%eax
  802878:	8b 55 08             	mov    0x8(%ebp),%edx
  80287b:	89 50 04             	mov    %edx,0x4(%eax)
  80287e:	eb 08                	jmp    802888 <insert_sorted_allocList+0xcb>
  802880:	8b 45 08             	mov    0x8(%ebp),%eax
  802883:	a3 44 50 80 00       	mov    %eax,0x805044
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	a3 40 50 80 00       	mov    %eax,0x805040
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80289f:	40                   	inc    %eax
  8028a0:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8028a5:	a1 40 50 80 00       	mov    0x805040,%eax
  8028aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ad:	e9 b9 01 00 00       	jmp    802a6b <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	8b 50 08             	mov    0x8(%eax),%edx
  8028b8:	a1 40 50 80 00       	mov    0x805040,%eax
  8028bd:	8b 40 08             	mov    0x8(%eax),%eax
  8028c0:	39 c2                	cmp    %eax,%edx
  8028c2:	76 7c                	jbe    802940 <insert_sorted_allocList+0x183>
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	8b 50 08             	mov    0x8(%eax),%edx
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	8b 40 08             	mov    0x8(%eax),%eax
  8028d0:	39 c2                	cmp    %eax,%edx
  8028d2:	73 6c                	jae    802940 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  8028d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d8:	74 06                	je     8028e0 <insert_sorted_allocList+0x123>
  8028da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028de:	75 14                	jne    8028f4 <insert_sorted_allocList+0x137>
  8028e0:	83 ec 04             	sub    $0x4,%esp
  8028e3:	68 80 41 80 00       	push   $0x804180
  8028e8:	6a 75                	push   $0x75
  8028ea:	68 67 41 80 00       	push   $0x804167
  8028ef:	e8 32 de ff ff       	call   800726 <_panic>
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 50 04             	mov    0x4(%eax),%edx
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	89 50 04             	mov    %edx,0x4(%eax)
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802906:	89 10                	mov    %edx,(%eax)
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 40 04             	mov    0x4(%eax),%eax
  80290e:	85 c0                	test   %eax,%eax
  802910:	74 0d                	je     80291f <insert_sorted_allocList+0x162>
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 40 04             	mov    0x4(%eax),%eax
  802918:	8b 55 08             	mov    0x8(%ebp),%edx
  80291b:	89 10                	mov    %edx,(%eax)
  80291d:	eb 08                	jmp    802927 <insert_sorted_allocList+0x16a>
  80291f:	8b 45 08             	mov    0x8(%ebp),%eax
  802922:	a3 40 50 80 00       	mov    %eax,0x805040
  802927:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292a:	8b 55 08             	mov    0x8(%ebp),%edx
  80292d:	89 50 04             	mov    %edx,0x4(%eax)
  802930:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802935:	40                   	inc    %eax
  802936:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  80293b:	e9 59 01 00 00       	jmp    802a99 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	8b 50 08             	mov    0x8(%eax),%edx
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 40 08             	mov    0x8(%eax),%eax
  80294c:	39 c2                	cmp    %eax,%edx
  80294e:	0f 86 98 00 00 00    	jbe    8029ec <insert_sorted_allocList+0x22f>
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	8b 50 08             	mov    0x8(%eax),%edx
  80295a:	a1 44 50 80 00       	mov    0x805044,%eax
  80295f:	8b 40 08             	mov    0x8(%eax),%eax
  802962:	39 c2                	cmp    %eax,%edx
  802964:	0f 83 82 00 00 00    	jae    8029ec <insert_sorted_allocList+0x22f>
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	8b 50 08             	mov    0x8(%eax),%edx
  802970:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802973:	8b 00                	mov    (%eax),%eax
  802975:	8b 40 08             	mov    0x8(%eax),%eax
  802978:	39 c2                	cmp    %eax,%edx
  80297a:	73 70                	jae    8029ec <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80297c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802980:	74 06                	je     802988 <insert_sorted_allocList+0x1cb>
  802982:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802986:	75 14                	jne    80299c <insert_sorted_allocList+0x1df>
  802988:	83 ec 04             	sub    $0x4,%esp
  80298b:	68 b8 41 80 00       	push   $0x8041b8
  802990:	6a 7c                	push   $0x7c
  802992:	68 67 41 80 00       	push   $0x804167
  802997:	e8 8a dd ff ff       	call   800726 <_panic>
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 10                	mov    (%eax),%edx
  8029a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a4:	89 10                	mov    %edx,(%eax)
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	8b 00                	mov    (%eax),%eax
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	74 0b                	je     8029ba <insert_sorted_allocList+0x1fd>
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c0:	89 10                	mov    %edx,(%eax)
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029c8:	89 50 04             	mov    %edx,0x4(%eax)
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	8b 00                	mov    (%eax),%eax
  8029d0:	85 c0                	test   %eax,%eax
  8029d2:	75 08                	jne    8029dc <insert_sorted_allocList+0x21f>
  8029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d7:	a3 44 50 80 00       	mov    %eax,0x805044
  8029dc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029e1:	40                   	inc    %eax
  8029e2:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  8029e7:	e9 ad 00 00 00       	jmp    802a99 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8029ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ef:	8b 50 08             	mov    0x8(%eax),%edx
  8029f2:	a1 44 50 80 00       	mov    0x805044,%eax
  8029f7:	8b 40 08             	mov    0x8(%eax),%eax
  8029fa:	39 c2                	cmp    %eax,%edx
  8029fc:	76 65                	jbe    802a63 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8029fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a02:	75 17                	jne    802a1b <insert_sorted_allocList+0x25e>
  802a04:	83 ec 04             	sub    $0x4,%esp
  802a07:	68 ec 41 80 00       	push   $0x8041ec
  802a0c:	68 80 00 00 00       	push   $0x80
  802a11:	68 67 41 80 00       	push   $0x804167
  802a16:	e8 0b dd ff ff       	call   800726 <_panic>
  802a1b:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	89 50 04             	mov    %edx,0x4(%eax)
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	8b 40 04             	mov    0x4(%eax),%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	74 0c                	je     802a3d <insert_sorted_allocList+0x280>
  802a31:	a1 44 50 80 00       	mov    0x805044,%eax
  802a36:	8b 55 08             	mov    0x8(%ebp),%edx
  802a39:	89 10                	mov    %edx,(%eax)
  802a3b:	eb 08                	jmp    802a45 <insert_sorted_allocList+0x288>
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	a3 40 50 80 00       	mov    %eax,0x805040
  802a45:	8b 45 08             	mov    0x8(%ebp),%eax
  802a48:	a3 44 50 80 00       	mov    %eax,0x805044
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a56:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a5b:	40                   	inc    %eax
  802a5c:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802a61:	eb 36                	jmp    802a99 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802a63:	a1 48 50 80 00       	mov    0x805048,%eax
  802a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6f:	74 07                	je     802a78 <insert_sorted_allocList+0x2bb>
  802a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a74:	8b 00                	mov    (%eax),%eax
  802a76:	eb 05                	jmp    802a7d <insert_sorted_allocList+0x2c0>
  802a78:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7d:	a3 48 50 80 00       	mov    %eax,0x805048
  802a82:	a1 48 50 80 00       	mov    0x805048,%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	0f 85 23 fe ff ff    	jne    8028b2 <insert_sorted_allocList+0xf5>
  802a8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a93:	0f 85 19 fe ff ff    	jne    8028b2 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802a99:	90                   	nop
  802a9a:	c9                   	leave  
  802a9b:	c3                   	ret    

00802a9c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a9c:	55                   	push   %ebp
  802a9d:	89 e5                	mov    %esp,%ebp
  802a9f:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802aa2:	a1 38 51 80 00       	mov    0x805138,%eax
  802aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aaa:	e9 7c 01 00 00       	jmp    802c2b <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ab8:	0f 85 90 00 00 00    	jne    802b4e <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802ac4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac8:	75 17                	jne    802ae1 <alloc_block_FF+0x45>
  802aca:	83 ec 04             	sub    $0x4,%esp
  802acd:	68 0f 42 80 00       	push   $0x80420f
  802ad2:	68 ba 00 00 00       	push   $0xba
  802ad7:	68 67 41 80 00       	push   $0x804167
  802adc:	e8 45 dc ff ff       	call   800726 <_panic>
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 00                	mov    (%eax),%eax
  802ae6:	85 c0                	test   %eax,%eax
  802ae8:	74 10                	je     802afa <alloc_block_FF+0x5e>
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 00                	mov    (%eax),%eax
  802aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af2:	8b 52 04             	mov    0x4(%edx),%edx
  802af5:	89 50 04             	mov    %edx,0x4(%eax)
  802af8:	eb 0b                	jmp    802b05 <alloc_block_FF+0x69>
  802afa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afd:	8b 40 04             	mov    0x4(%eax),%eax
  802b00:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 40 04             	mov    0x4(%eax),%eax
  802b0b:	85 c0                	test   %eax,%eax
  802b0d:	74 0f                	je     802b1e <alloc_block_FF+0x82>
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 04             	mov    0x4(%eax),%eax
  802b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b18:	8b 12                	mov    (%edx),%edx
  802b1a:	89 10                	mov    %edx,(%eax)
  802b1c:	eb 0a                	jmp    802b28 <alloc_block_FF+0x8c>
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	a3 38 51 80 00       	mov    %eax,0x805138
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b3b:	a1 44 51 80 00       	mov    0x805144,%eax
  802b40:	48                   	dec    %eax
  802b41:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b49:	e9 10 01 00 00       	jmp    802c5e <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 40 0c             	mov    0xc(%eax),%eax
  802b54:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b57:	0f 86 c6 00 00 00    	jbe    802c23 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802b5d:	a1 48 51 80 00       	mov    0x805148,%eax
  802b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802b65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b69:	75 17                	jne    802b82 <alloc_block_FF+0xe6>
  802b6b:	83 ec 04             	sub    $0x4,%esp
  802b6e:	68 0f 42 80 00       	push   $0x80420f
  802b73:	68 c2 00 00 00       	push   $0xc2
  802b78:	68 67 41 80 00       	push   $0x804167
  802b7d:	e8 a4 db ff ff       	call   800726 <_panic>
  802b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	85 c0                	test   %eax,%eax
  802b89:	74 10                	je     802b9b <alloc_block_FF+0xff>
  802b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8e:	8b 00                	mov    (%eax),%eax
  802b90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b93:	8b 52 04             	mov    0x4(%edx),%edx
  802b96:	89 50 04             	mov    %edx,0x4(%eax)
  802b99:	eb 0b                	jmp    802ba6 <alloc_block_FF+0x10a>
  802b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ba1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba9:	8b 40 04             	mov    0x4(%eax),%eax
  802bac:	85 c0                	test   %eax,%eax
  802bae:	74 0f                	je     802bbf <alloc_block_FF+0x123>
  802bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb3:	8b 40 04             	mov    0x4(%eax),%eax
  802bb6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bb9:	8b 12                	mov    (%edx),%edx
  802bbb:	89 10                	mov    %edx,(%eax)
  802bbd:	eb 0a                	jmp    802bc9 <alloc_block_FF+0x12d>
  802bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc2:	8b 00                	mov    (%eax),%eax
  802bc4:	a3 48 51 80 00       	mov    %eax,0x805148
  802bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bdc:	a1 54 51 80 00       	mov    0x805154,%eax
  802be1:	48                   	dec    %eax
  802be2:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 50 08             	mov    0x8(%eax),%edx
  802bed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf0:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf9:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 40 0c             	mov    0xc(%eax),%eax
  802c02:	2b 45 08             	sub    0x8(%ebp),%eax
  802c05:	89 c2                	mov    %eax,%edx
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 50 08             	mov    0x8(%eax),%edx
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	01 c2                	add    %eax,%edx
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c21:	eb 3b                	jmp    802c5e <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802c23:	a1 40 51 80 00       	mov    0x805140,%eax
  802c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c2f:	74 07                	je     802c38 <alloc_block_FF+0x19c>
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	eb 05                	jmp    802c3d <alloc_block_FF+0x1a1>
  802c38:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3d:	a3 40 51 80 00       	mov    %eax,0x805140
  802c42:	a1 40 51 80 00       	mov    0x805140,%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	0f 85 60 fe ff ff    	jne    802aaf <alloc_block_FF+0x13>
  802c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c53:	0f 85 56 fe ff ff    	jne    802aaf <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802c59:	b8 00 00 00 00       	mov    $0x0,%eax
  802c5e:	c9                   	leave  
  802c5f:	c3                   	ret    

00802c60 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802c60:	55                   	push   %ebp
  802c61:	89 e5                	mov    %esp,%ebp
  802c63:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802c66:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802c6d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c75:	eb 3a                	jmp    802cb1 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c80:	72 27                	jb     802ca9 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802c82:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c86:	75 0b                	jne    802c93 <alloc_block_BF+0x33>
					best_size= element->size;
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c91:	eb 16                	jmp    802ca9 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 50 0c             	mov    0xc(%eax),%edx
  802c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9c:	39 c2                	cmp    %eax,%edx
  802c9e:	77 09                	ja     802ca9 <alloc_block_BF+0x49>
					best_size=element->size;
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802ca9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb5:	74 07                	je     802cbe <alloc_block_BF+0x5e>
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	8b 00                	mov    (%eax),%eax
  802cbc:	eb 05                	jmp    802cc3 <alloc_block_BF+0x63>
  802cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc3:	a3 40 51 80 00       	mov    %eax,0x805140
  802cc8:	a1 40 51 80 00       	mov    0x805140,%eax
  802ccd:	85 c0                	test   %eax,%eax
  802ccf:	75 a6                	jne    802c77 <alloc_block_BF+0x17>
  802cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd5:	75 a0                	jne    802c77 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802cd7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802cdb:	0f 84 d3 01 00 00    	je     802eb4 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802ce1:	a1 38 51 80 00       	mov    0x805138,%eax
  802ce6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce9:	e9 98 01 00 00       	jmp    802e86 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cf1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cf4:	0f 86 da 00 00 00    	jbe    802dd4 <alloc_block_BF+0x174>
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	8b 50 0c             	mov    0xc(%eax),%edx
  802d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d03:	39 c2                	cmp    %eax,%edx
  802d05:	0f 85 c9 00 00 00    	jne    802dd4 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802d0b:	a1 48 51 80 00       	mov    0x805148,%eax
  802d10:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802d13:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d17:	75 17                	jne    802d30 <alloc_block_BF+0xd0>
  802d19:	83 ec 04             	sub    $0x4,%esp
  802d1c:	68 0f 42 80 00       	push   $0x80420f
  802d21:	68 ea 00 00 00       	push   $0xea
  802d26:	68 67 41 80 00       	push   $0x804167
  802d2b:	e8 f6 d9 ff ff       	call   800726 <_panic>
  802d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	85 c0                	test   %eax,%eax
  802d37:	74 10                	je     802d49 <alloc_block_BF+0xe9>
  802d39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d41:	8b 52 04             	mov    0x4(%edx),%edx
  802d44:	89 50 04             	mov    %edx,0x4(%eax)
  802d47:	eb 0b                	jmp    802d54 <alloc_block_BF+0xf4>
  802d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4c:	8b 40 04             	mov    0x4(%eax),%eax
  802d4f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d57:	8b 40 04             	mov    0x4(%eax),%eax
  802d5a:	85 c0                	test   %eax,%eax
  802d5c:	74 0f                	je     802d6d <alloc_block_BF+0x10d>
  802d5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d67:	8b 12                	mov    (%edx),%edx
  802d69:	89 10                	mov    %edx,(%eax)
  802d6b:	eb 0a                	jmp    802d77 <alloc_block_BF+0x117>
  802d6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d70:	8b 00                	mov    (%eax),%eax
  802d72:	a3 48 51 80 00       	mov    %eax,0x805148
  802d77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8a:	a1 54 51 80 00       	mov    0x805154,%eax
  802d8f:	48                   	dec    %eax
  802d90:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 50 08             	mov    0x8(%eax),%edx
  802d9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9e:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802da1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802da4:	8b 55 08             	mov    0x8(%ebp),%edx
  802da7:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	8b 40 0c             	mov    0xc(%eax),%eax
  802db0:	2b 45 08             	sub    0x8(%ebp),%eax
  802db3:	89 c2                	mov    %eax,%edx
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 50 08             	mov    0x8(%eax),%edx
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	01 c2                	add    %eax,%edx
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802dcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dcf:	e9 e5 00 00 00       	jmp    802eb9 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd7:	8b 50 0c             	mov    0xc(%eax),%edx
  802dda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ddd:	39 c2                	cmp    %eax,%edx
  802ddf:	0f 85 99 00 00 00    	jne    802e7e <alloc_block_BF+0x21e>
  802de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802deb:	0f 85 8d 00 00 00    	jne    802e7e <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802df7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfb:	75 17                	jne    802e14 <alloc_block_BF+0x1b4>
  802dfd:	83 ec 04             	sub    $0x4,%esp
  802e00:	68 0f 42 80 00       	push   $0x80420f
  802e05:	68 f7 00 00 00       	push   $0xf7
  802e0a:	68 67 41 80 00       	push   $0x804167
  802e0f:	e8 12 d9 ff ff       	call   800726 <_panic>
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 00                	mov    (%eax),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	74 10                	je     802e2d <alloc_block_BF+0x1cd>
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 00                	mov    (%eax),%eax
  802e22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e25:	8b 52 04             	mov    0x4(%edx),%edx
  802e28:	89 50 04             	mov    %edx,0x4(%eax)
  802e2b:	eb 0b                	jmp    802e38 <alloc_block_BF+0x1d8>
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	8b 40 04             	mov    0x4(%eax),%eax
  802e33:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 40 04             	mov    0x4(%eax),%eax
  802e3e:	85 c0                	test   %eax,%eax
  802e40:	74 0f                	je     802e51 <alloc_block_BF+0x1f1>
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 40 04             	mov    0x4(%eax),%eax
  802e48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4b:	8b 12                	mov    (%edx),%edx
  802e4d:	89 10                	mov    %edx,(%eax)
  802e4f:	eb 0a                	jmp    802e5b <alloc_block_BF+0x1fb>
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 00                	mov    (%eax),%eax
  802e56:	a3 38 51 80 00       	mov    %eax,0x805138
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e67:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e73:	48                   	dec    %eax
  802e74:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802e79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7c:	eb 3b                	jmp    802eb9 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802e7e:	a1 40 51 80 00       	mov    0x805140,%eax
  802e83:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8a:	74 07                	je     802e93 <alloc_block_BF+0x233>
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	8b 00                	mov    (%eax),%eax
  802e91:	eb 05                	jmp    802e98 <alloc_block_BF+0x238>
  802e93:	b8 00 00 00 00       	mov    $0x0,%eax
  802e98:	a3 40 51 80 00       	mov    %eax,0x805140
  802e9d:	a1 40 51 80 00       	mov    0x805140,%eax
  802ea2:	85 c0                	test   %eax,%eax
  802ea4:	0f 85 44 fe ff ff    	jne    802cee <alloc_block_BF+0x8e>
  802eaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eae:	0f 85 3a fe ff ff    	jne    802cee <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb9:	c9                   	leave  
  802eba:	c3                   	ret    

00802ebb <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802ebb:	55                   	push   %ebp
  802ebc:	89 e5                	mov    %esp,%ebp
  802ebe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802ec1:	83 ec 04             	sub    $0x4,%esp
  802ec4:	68 30 42 80 00       	push   $0x804230
  802ec9:	68 04 01 00 00       	push   $0x104
  802ece:	68 67 41 80 00       	push   $0x804167
  802ed3:	e8 4e d8 ff ff       	call   800726 <_panic>

00802ed8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802ed8:	55                   	push   %ebp
  802ed9:	89 e5                	mov    %esp,%ebp
  802edb:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802ede:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee3:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802ee6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802eeb:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802eee:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef3:	85 c0                	test   %eax,%eax
  802ef5:	75 68                	jne    802f5f <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802ef7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802efb:	75 17                	jne    802f14 <insert_sorted_with_merge_freeList+0x3c>
  802efd:	83 ec 04             	sub    $0x4,%esp
  802f00:	68 44 41 80 00       	push   $0x804144
  802f05:	68 14 01 00 00       	push   $0x114
  802f0a:	68 67 41 80 00       	push   $0x804167
  802f0f:	e8 12 d8 ff ff       	call   800726 <_panic>
  802f14:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1d:	89 10                	mov    %edx,(%eax)
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	8b 00                	mov    (%eax),%eax
  802f24:	85 c0                	test   %eax,%eax
  802f26:	74 0d                	je     802f35 <insert_sorted_with_merge_freeList+0x5d>
  802f28:	a1 38 51 80 00       	mov    0x805138,%eax
  802f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f30:	89 50 04             	mov    %edx,0x4(%eax)
  802f33:	eb 08                	jmp    802f3d <insert_sorted_with_merge_freeList+0x65>
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	a3 38 51 80 00       	mov    %eax,0x805138
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4f:	a1 44 51 80 00       	mov    0x805144,%eax
  802f54:	40                   	inc    %eax
  802f55:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802f5a:	e9 d2 06 00 00       	jmp    803631 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	8b 50 08             	mov    0x8(%eax),%edx
  802f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f68:	8b 40 08             	mov    0x8(%eax),%eax
  802f6b:	39 c2                	cmp    %eax,%edx
  802f6d:	0f 83 22 01 00 00    	jae    803095 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	8b 50 08             	mov    0x8(%eax),%edx
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7f:	01 c2                	add    %eax,%edx
  802f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f84:	8b 40 08             	mov    0x8(%eax),%eax
  802f87:	39 c2                	cmp    %eax,%edx
  802f89:	0f 85 9e 00 00 00    	jne    80302d <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	8b 50 08             	mov    0x8(%eax),%edx
  802f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f98:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802f9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9e:	8b 50 0c             	mov    0xc(%eax),%edx
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa7:	01 c2                	add    %eax,%edx
  802fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fac:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	8b 50 08             	mov    0x8(%eax),%edx
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802fc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc9:	75 17                	jne    802fe2 <insert_sorted_with_merge_freeList+0x10a>
  802fcb:	83 ec 04             	sub    $0x4,%esp
  802fce:	68 44 41 80 00       	push   $0x804144
  802fd3:	68 21 01 00 00       	push   $0x121
  802fd8:	68 67 41 80 00       	push   $0x804167
  802fdd:	e8 44 d7 ff ff       	call   800726 <_panic>
  802fe2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	89 10                	mov    %edx,(%eax)
  802fed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	85 c0                	test   %eax,%eax
  802ff4:	74 0d                	je     803003 <insert_sorted_with_merge_freeList+0x12b>
  802ff6:	a1 48 51 80 00       	mov    0x805148,%eax
  802ffb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ffe:	89 50 04             	mov    %edx,0x4(%eax)
  803001:	eb 08                	jmp    80300b <insert_sorted_with_merge_freeList+0x133>
  803003:	8b 45 08             	mov    0x8(%ebp),%eax
  803006:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	a3 48 51 80 00       	mov    %eax,0x805148
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301d:	a1 54 51 80 00       	mov    0x805154,%eax
  803022:	40                   	inc    %eax
  803023:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803028:	e9 04 06 00 00       	jmp    803631 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80302d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803031:	75 17                	jne    80304a <insert_sorted_with_merge_freeList+0x172>
  803033:	83 ec 04             	sub    $0x4,%esp
  803036:	68 44 41 80 00       	push   $0x804144
  80303b:	68 26 01 00 00       	push   $0x126
  803040:	68 67 41 80 00       	push   $0x804167
  803045:	e8 dc d6 ff ff       	call   800726 <_panic>
  80304a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	89 10                	mov    %edx,(%eax)
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	74 0d                	je     80306b <insert_sorted_with_merge_freeList+0x193>
  80305e:	a1 38 51 80 00       	mov    0x805138,%eax
  803063:	8b 55 08             	mov    0x8(%ebp),%edx
  803066:	89 50 04             	mov    %edx,0x4(%eax)
  803069:	eb 08                	jmp    803073 <insert_sorted_with_merge_freeList+0x19b>
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803073:	8b 45 08             	mov    0x8(%ebp),%eax
  803076:	a3 38 51 80 00       	mov    %eax,0x805138
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803085:	a1 44 51 80 00       	mov    0x805144,%eax
  80308a:	40                   	inc    %eax
  80308b:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803090:	e9 9c 05 00 00       	jmp    803631 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	8b 50 08             	mov    0x8(%eax),%edx
  80309b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309e:	8b 40 08             	mov    0x8(%eax),%eax
  8030a1:	39 c2                	cmp    %eax,%edx
  8030a3:	0f 86 16 01 00 00    	jbe    8031bf <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  8030a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ac:	8b 50 08             	mov    0x8(%eax),%edx
  8030af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b5:	01 c2                	add    %eax,%edx
  8030b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ba:	8b 40 08             	mov    0x8(%eax),%eax
  8030bd:	39 c2                	cmp    %eax,%edx
  8030bf:	0f 85 92 00 00 00    	jne    803157 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  8030c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d1:	01 c2                	add    %eax,%edx
  8030d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d6:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e6:	8b 50 08             	mov    0x8(%eax),%edx
  8030e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ec:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8030ef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f3:	75 17                	jne    80310c <insert_sorted_with_merge_freeList+0x234>
  8030f5:	83 ec 04             	sub    $0x4,%esp
  8030f8:	68 44 41 80 00       	push   $0x804144
  8030fd:	68 31 01 00 00       	push   $0x131
  803102:	68 67 41 80 00       	push   $0x804167
  803107:	e8 1a d6 ff ff       	call   800726 <_panic>
  80310c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	89 10                	mov    %edx,(%eax)
  803117:	8b 45 08             	mov    0x8(%ebp),%eax
  80311a:	8b 00                	mov    (%eax),%eax
  80311c:	85 c0                	test   %eax,%eax
  80311e:	74 0d                	je     80312d <insert_sorted_with_merge_freeList+0x255>
  803120:	a1 48 51 80 00       	mov    0x805148,%eax
  803125:	8b 55 08             	mov    0x8(%ebp),%edx
  803128:	89 50 04             	mov    %edx,0x4(%eax)
  80312b:	eb 08                	jmp    803135 <insert_sorted_with_merge_freeList+0x25d>
  80312d:	8b 45 08             	mov    0x8(%ebp),%eax
  803130:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803135:	8b 45 08             	mov    0x8(%ebp),%eax
  803138:	a3 48 51 80 00       	mov    %eax,0x805148
  80313d:	8b 45 08             	mov    0x8(%ebp),%eax
  803140:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803147:	a1 54 51 80 00       	mov    0x805154,%eax
  80314c:	40                   	inc    %eax
  80314d:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803152:	e9 da 04 00 00       	jmp    803631 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  803157:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80315b:	75 17                	jne    803174 <insert_sorted_with_merge_freeList+0x29c>
  80315d:	83 ec 04             	sub    $0x4,%esp
  803160:	68 ec 41 80 00       	push   $0x8041ec
  803165:	68 37 01 00 00       	push   $0x137
  80316a:	68 67 41 80 00       	push   $0x804167
  80316f:	e8 b2 d5 ff ff       	call   800726 <_panic>
  803174:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	89 50 04             	mov    %edx,0x4(%eax)
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	8b 40 04             	mov    0x4(%eax),%eax
  803186:	85 c0                	test   %eax,%eax
  803188:	74 0c                	je     803196 <insert_sorted_with_merge_freeList+0x2be>
  80318a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80318f:	8b 55 08             	mov    0x8(%ebp),%edx
  803192:	89 10                	mov    %edx,(%eax)
  803194:	eb 08                	jmp    80319e <insert_sorted_with_merge_freeList+0x2c6>
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	a3 38 51 80 00       	mov    %eax,0x805138
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031af:	a1 44 51 80 00       	mov    0x805144,%eax
  8031b4:	40                   	inc    %eax
  8031b5:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8031ba:	e9 72 04 00 00       	jmp    803631 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8031bf:	a1 38 51 80 00       	mov    0x805138,%eax
  8031c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031c7:	e9 35 04 00 00       	jmp    803601 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	8b 00                	mov    (%eax),%eax
  8031d1:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	8b 50 08             	mov    0x8(%eax),%edx
  8031da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dd:	8b 40 08             	mov    0x8(%eax),%eax
  8031e0:	39 c2                	cmp    %eax,%edx
  8031e2:	0f 86 11 04 00 00    	jbe    8035f9 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	8b 50 08             	mov    0x8(%eax),%edx
  8031ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f4:	01 c2                	add    %eax,%edx
  8031f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f9:	8b 40 08             	mov    0x8(%eax),%eax
  8031fc:	39 c2                	cmp    %eax,%edx
  8031fe:	0f 83 8b 00 00 00    	jae    80328f <insert_sorted_with_merge_freeList+0x3b7>
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	8b 50 08             	mov    0x8(%eax),%edx
  80320a:	8b 45 08             	mov    0x8(%ebp),%eax
  80320d:	8b 40 0c             	mov    0xc(%eax),%eax
  803210:	01 c2                	add    %eax,%edx
  803212:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803215:	8b 40 08             	mov    0x8(%eax),%eax
  803218:	39 c2                	cmp    %eax,%edx
  80321a:	73 73                	jae    80328f <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  80321c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803220:	74 06                	je     803228 <insert_sorted_with_merge_freeList+0x350>
  803222:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803226:	75 17                	jne    80323f <insert_sorted_with_merge_freeList+0x367>
  803228:	83 ec 04             	sub    $0x4,%esp
  80322b:	68 b8 41 80 00       	push   $0x8041b8
  803230:	68 48 01 00 00       	push   $0x148
  803235:	68 67 41 80 00       	push   $0x804167
  80323a:	e8 e7 d4 ff ff       	call   800726 <_panic>
  80323f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803242:	8b 10                	mov    (%eax),%edx
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	89 10                	mov    %edx,(%eax)
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	8b 00                	mov    (%eax),%eax
  80324e:	85 c0                	test   %eax,%eax
  803250:	74 0b                	je     80325d <insert_sorted_with_merge_freeList+0x385>
  803252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	8b 55 08             	mov    0x8(%ebp),%edx
  80325a:	89 50 04             	mov    %edx,0x4(%eax)
  80325d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803260:	8b 55 08             	mov    0x8(%ebp),%edx
  803263:	89 10                	mov    %edx,(%eax)
  803265:	8b 45 08             	mov    0x8(%ebp),%eax
  803268:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80326b:	89 50 04             	mov    %edx,0x4(%eax)
  80326e:	8b 45 08             	mov    0x8(%ebp),%eax
  803271:	8b 00                	mov    (%eax),%eax
  803273:	85 c0                	test   %eax,%eax
  803275:	75 08                	jne    80327f <insert_sorted_with_merge_freeList+0x3a7>
  803277:	8b 45 08             	mov    0x8(%ebp),%eax
  80327a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80327f:	a1 44 51 80 00       	mov    0x805144,%eax
  803284:	40                   	inc    %eax
  803285:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  80328a:	e9 a2 03 00 00       	jmp    803631 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	8b 50 08             	mov    0x8(%eax),%edx
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	8b 40 0c             	mov    0xc(%eax),%eax
  80329b:	01 c2                	add    %eax,%edx
  80329d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032a0:	8b 40 08             	mov    0x8(%eax),%eax
  8032a3:	39 c2                	cmp    %eax,%edx
  8032a5:	0f 83 ae 00 00 00    	jae    803359 <insert_sorted_with_merge_freeList+0x481>
  8032ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ae:	8b 50 08             	mov    0x8(%eax),%edx
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	8b 48 08             	mov    0x8(%eax),%ecx
  8032b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8032bd:	01 c8                	add    %ecx,%eax
  8032bf:	39 c2                	cmp    %eax,%edx
  8032c1:	0f 85 92 00 00 00    	jne    803359 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  8032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ca:	8b 50 0c             	mov    0xc(%eax),%edx
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d3:	01 c2                	add    %eax,%edx
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e8:	8b 50 08             	mov    0x8(%eax),%edx
  8032eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ee:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8032f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f5:	75 17                	jne    80330e <insert_sorted_with_merge_freeList+0x436>
  8032f7:	83 ec 04             	sub    $0x4,%esp
  8032fa:	68 44 41 80 00       	push   $0x804144
  8032ff:	68 51 01 00 00       	push   $0x151
  803304:	68 67 41 80 00       	push   $0x804167
  803309:	e8 18 d4 ff ff       	call   800726 <_panic>
  80330e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	89 10                	mov    %edx,(%eax)
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	8b 00                	mov    (%eax),%eax
  80331e:	85 c0                	test   %eax,%eax
  803320:	74 0d                	je     80332f <insert_sorted_with_merge_freeList+0x457>
  803322:	a1 48 51 80 00       	mov    0x805148,%eax
  803327:	8b 55 08             	mov    0x8(%ebp),%edx
  80332a:	89 50 04             	mov    %edx,0x4(%eax)
  80332d:	eb 08                	jmp    803337 <insert_sorted_with_merge_freeList+0x45f>
  80332f:	8b 45 08             	mov    0x8(%ebp),%eax
  803332:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	a3 48 51 80 00       	mov    %eax,0x805148
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803349:	a1 54 51 80 00       	mov    0x805154,%eax
  80334e:	40                   	inc    %eax
  80334f:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  803354:	e9 d8 02 00 00       	jmp    803631 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	8b 50 08             	mov    0x8(%eax),%edx
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	8b 40 0c             	mov    0xc(%eax),%eax
  803365:	01 c2                	add    %eax,%edx
  803367:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80336a:	8b 40 08             	mov    0x8(%eax),%eax
  80336d:	39 c2                	cmp    %eax,%edx
  80336f:	0f 85 ba 00 00 00    	jne    80342f <insert_sorted_with_merge_freeList+0x557>
  803375:	8b 45 08             	mov    0x8(%ebp),%eax
  803378:	8b 50 08             	mov    0x8(%eax),%edx
  80337b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337e:	8b 48 08             	mov    0x8(%eax),%ecx
  803381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803384:	8b 40 0c             	mov    0xc(%eax),%eax
  803387:	01 c8                	add    %ecx,%eax
  803389:	39 c2                	cmp    %eax,%edx
  80338b:	0f 86 9e 00 00 00    	jbe    80342f <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803391:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803394:	8b 50 0c             	mov    0xc(%eax),%edx
  803397:	8b 45 08             	mov    0x8(%ebp),%eax
  80339a:	8b 40 0c             	mov    0xc(%eax),%eax
  80339d:	01 c2                	add    %eax,%edx
  80339f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033a2:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	8b 50 08             	mov    0x8(%eax),%edx
  8033ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033ae:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	8b 50 08             	mov    0x8(%eax),%edx
  8033c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c4:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8033c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033cb:	75 17                	jne    8033e4 <insert_sorted_with_merge_freeList+0x50c>
  8033cd:	83 ec 04             	sub    $0x4,%esp
  8033d0:	68 44 41 80 00       	push   $0x804144
  8033d5:	68 5b 01 00 00       	push   $0x15b
  8033da:	68 67 41 80 00       	push   $0x804167
  8033df:	e8 42 d3 ff ff       	call   800726 <_panic>
  8033e4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ed:	89 10                	mov    %edx,(%eax)
  8033ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	85 c0                	test   %eax,%eax
  8033f6:	74 0d                	je     803405 <insert_sorted_with_merge_freeList+0x52d>
  8033f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8033fd:	8b 55 08             	mov    0x8(%ebp),%edx
  803400:	89 50 04             	mov    %edx,0x4(%eax)
  803403:	eb 08                	jmp    80340d <insert_sorted_with_merge_freeList+0x535>
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	a3 48 51 80 00       	mov    %eax,0x805148
  803415:	8b 45 08             	mov    0x8(%ebp),%eax
  803418:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80341f:	a1 54 51 80 00       	mov    0x805154,%eax
  803424:	40                   	inc    %eax
  803425:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  80342a:	e9 02 02 00 00       	jmp    803631 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	8b 50 08             	mov    0x8(%eax),%edx
  803435:	8b 45 08             	mov    0x8(%ebp),%eax
  803438:	8b 40 0c             	mov    0xc(%eax),%eax
  80343b:	01 c2                	add    %eax,%edx
  80343d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803440:	8b 40 08             	mov    0x8(%eax),%eax
  803443:	39 c2                	cmp    %eax,%edx
  803445:	0f 85 ae 01 00 00    	jne    8035f9 <insert_sorted_with_merge_freeList+0x721>
  80344b:	8b 45 08             	mov    0x8(%ebp),%eax
  80344e:	8b 50 08             	mov    0x8(%eax),%edx
  803451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803454:	8b 48 08             	mov    0x8(%eax),%ecx
  803457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345a:	8b 40 0c             	mov    0xc(%eax),%eax
  80345d:	01 c8                	add    %ecx,%eax
  80345f:	39 c2                	cmp    %eax,%edx
  803461:	0f 85 92 01 00 00    	jne    8035f9 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  803467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346a:	8b 50 0c             	mov    0xc(%eax),%edx
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	8b 40 0c             	mov    0xc(%eax),%eax
  803473:	01 c2                	add    %eax,%edx
  803475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803478:	8b 40 0c             	mov    0xc(%eax),%eax
  80347b:	01 c2                	add    %eax,%edx
  80347d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803480:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803483:	8b 45 08             	mov    0x8(%ebp),%eax
  803486:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	8b 50 08             	mov    0x8(%eax),%edx
  803493:	8b 45 08             	mov    0x8(%ebp),%eax
  803496:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8034a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034a6:	8b 50 08             	mov    0x8(%eax),%edx
  8034a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ac:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  8034af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034b3:	75 17                	jne    8034cc <insert_sorted_with_merge_freeList+0x5f4>
  8034b5:	83 ec 04             	sub    $0x4,%esp
  8034b8:	68 0f 42 80 00       	push   $0x80420f
  8034bd:	68 63 01 00 00       	push   $0x163
  8034c2:	68 67 41 80 00       	push   $0x804167
  8034c7:	e8 5a d2 ff ff       	call   800726 <_panic>
  8034cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034cf:	8b 00                	mov    (%eax),%eax
  8034d1:	85 c0                	test   %eax,%eax
  8034d3:	74 10                	je     8034e5 <insert_sorted_with_merge_freeList+0x60d>
  8034d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d8:	8b 00                	mov    (%eax),%eax
  8034da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034dd:	8b 52 04             	mov    0x4(%edx),%edx
  8034e0:	89 50 04             	mov    %edx,0x4(%eax)
  8034e3:	eb 0b                	jmp    8034f0 <insert_sorted_with_merge_freeList+0x618>
  8034e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e8:	8b 40 04             	mov    0x4(%eax),%eax
  8034eb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f3:	8b 40 04             	mov    0x4(%eax),%eax
  8034f6:	85 c0                	test   %eax,%eax
  8034f8:	74 0f                	je     803509 <insert_sorted_with_merge_freeList+0x631>
  8034fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034fd:	8b 40 04             	mov    0x4(%eax),%eax
  803500:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803503:	8b 12                	mov    (%edx),%edx
  803505:	89 10                	mov    %edx,(%eax)
  803507:	eb 0a                	jmp    803513 <insert_sorted_with_merge_freeList+0x63b>
  803509:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350c:	8b 00                	mov    (%eax),%eax
  80350e:	a3 38 51 80 00       	mov    %eax,0x805138
  803513:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803516:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80351c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803526:	a1 44 51 80 00       	mov    0x805144,%eax
  80352b:	48                   	dec    %eax
  80352c:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  803531:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803535:	75 17                	jne    80354e <insert_sorted_with_merge_freeList+0x676>
  803537:	83 ec 04             	sub    $0x4,%esp
  80353a:	68 44 41 80 00       	push   $0x804144
  80353f:	68 64 01 00 00       	push   $0x164
  803544:	68 67 41 80 00       	push   $0x804167
  803549:	e8 d8 d1 ff ff       	call   800726 <_panic>
  80354e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803554:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803557:	89 10                	mov    %edx,(%eax)
  803559:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355c:	8b 00                	mov    (%eax),%eax
  80355e:	85 c0                	test   %eax,%eax
  803560:	74 0d                	je     80356f <insert_sorted_with_merge_freeList+0x697>
  803562:	a1 48 51 80 00       	mov    0x805148,%eax
  803567:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80356a:	89 50 04             	mov    %edx,0x4(%eax)
  80356d:	eb 08                	jmp    803577 <insert_sorted_with_merge_freeList+0x69f>
  80356f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803572:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803577:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357a:	a3 48 51 80 00       	mov    %eax,0x805148
  80357f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803582:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803589:	a1 54 51 80 00       	mov    0x805154,%eax
  80358e:	40                   	inc    %eax
  80358f:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803594:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803598:	75 17                	jne    8035b1 <insert_sorted_with_merge_freeList+0x6d9>
  80359a:	83 ec 04             	sub    $0x4,%esp
  80359d:	68 44 41 80 00       	push   $0x804144
  8035a2:	68 65 01 00 00       	push   $0x165
  8035a7:	68 67 41 80 00       	push   $0x804167
  8035ac:	e8 75 d1 ff ff       	call   800726 <_panic>
  8035b1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ba:	89 10                	mov    %edx,(%eax)
  8035bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bf:	8b 00                	mov    (%eax),%eax
  8035c1:	85 c0                	test   %eax,%eax
  8035c3:	74 0d                	je     8035d2 <insert_sorted_with_merge_freeList+0x6fa>
  8035c5:	a1 48 51 80 00       	mov    0x805148,%eax
  8035ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8035cd:	89 50 04             	mov    %edx,0x4(%eax)
  8035d0:	eb 08                	jmp    8035da <insert_sorted_with_merge_freeList+0x702>
  8035d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035da:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dd:	a3 48 51 80 00       	mov    %eax,0x805148
  8035e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ec:	a1 54 51 80 00       	mov    0x805154,%eax
  8035f1:	40                   	inc    %eax
  8035f2:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8035f7:	eb 38                	jmp    803631 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8035f9:	a1 40 51 80 00       	mov    0x805140,%eax
  8035fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803601:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803605:	74 07                	je     80360e <insert_sorted_with_merge_freeList+0x736>
  803607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360a:	8b 00                	mov    (%eax),%eax
  80360c:	eb 05                	jmp    803613 <insert_sorted_with_merge_freeList+0x73b>
  80360e:	b8 00 00 00 00       	mov    $0x0,%eax
  803613:	a3 40 51 80 00       	mov    %eax,0x805140
  803618:	a1 40 51 80 00       	mov    0x805140,%eax
  80361d:	85 c0                	test   %eax,%eax
  80361f:	0f 85 a7 fb ff ff    	jne    8031cc <insert_sorted_with_merge_freeList+0x2f4>
  803625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803629:	0f 85 9d fb ff ff    	jne    8031cc <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80362f:	eb 00                	jmp    803631 <insert_sorted_with_merge_freeList+0x759>
  803631:	90                   	nop
  803632:	c9                   	leave  
  803633:	c3                   	ret    

00803634 <__udivdi3>:
  803634:	55                   	push   %ebp
  803635:	57                   	push   %edi
  803636:	56                   	push   %esi
  803637:	53                   	push   %ebx
  803638:	83 ec 1c             	sub    $0x1c,%esp
  80363b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80363f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803643:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803647:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80364b:	89 ca                	mov    %ecx,%edx
  80364d:	89 f8                	mov    %edi,%eax
  80364f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803653:	85 f6                	test   %esi,%esi
  803655:	75 2d                	jne    803684 <__udivdi3+0x50>
  803657:	39 cf                	cmp    %ecx,%edi
  803659:	77 65                	ja     8036c0 <__udivdi3+0x8c>
  80365b:	89 fd                	mov    %edi,%ebp
  80365d:	85 ff                	test   %edi,%edi
  80365f:	75 0b                	jne    80366c <__udivdi3+0x38>
  803661:	b8 01 00 00 00       	mov    $0x1,%eax
  803666:	31 d2                	xor    %edx,%edx
  803668:	f7 f7                	div    %edi
  80366a:	89 c5                	mov    %eax,%ebp
  80366c:	31 d2                	xor    %edx,%edx
  80366e:	89 c8                	mov    %ecx,%eax
  803670:	f7 f5                	div    %ebp
  803672:	89 c1                	mov    %eax,%ecx
  803674:	89 d8                	mov    %ebx,%eax
  803676:	f7 f5                	div    %ebp
  803678:	89 cf                	mov    %ecx,%edi
  80367a:	89 fa                	mov    %edi,%edx
  80367c:	83 c4 1c             	add    $0x1c,%esp
  80367f:	5b                   	pop    %ebx
  803680:	5e                   	pop    %esi
  803681:	5f                   	pop    %edi
  803682:	5d                   	pop    %ebp
  803683:	c3                   	ret    
  803684:	39 ce                	cmp    %ecx,%esi
  803686:	77 28                	ja     8036b0 <__udivdi3+0x7c>
  803688:	0f bd fe             	bsr    %esi,%edi
  80368b:	83 f7 1f             	xor    $0x1f,%edi
  80368e:	75 40                	jne    8036d0 <__udivdi3+0x9c>
  803690:	39 ce                	cmp    %ecx,%esi
  803692:	72 0a                	jb     80369e <__udivdi3+0x6a>
  803694:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803698:	0f 87 9e 00 00 00    	ja     80373c <__udivdi3+0x108>
  80369e:	b8 01 00 00 00       	mov    $0x1,%eax
  8036a3:	89 fa                	mov    %edi,%edx
  8036a5:	83 c4 1c             	add    $0x1c,%esp
  8036a8:	5b                   	pop    %ebx
  8036a9:	5e                   	pop    %esi
  8036aa:	5f                   	pop    %edi
  8036ab:	5d                   	pop    %ebp
  8036ac:	c3                   	ret    
  8036ad:	8d 76 00             	lea    0x0(%esi),%esi
  8036b0:	31 ff                	xor    %edi,%edi
  8036b2:	31 c0                	xor    %eax,%eax
  8036b4:	89 fa                	mov    %edi,%edx
  8036b6:	83 c4 1c             	add    $0x1c,%esp
  8036b9:	5b                   	pop    %ebx
  8036ba:	5e                   	pop    %esi
  8036bb:	5f                   	pop    %edi
  8036bc:	5d                   	pop    %ebp
  8036bd:	c3                   	ret    
  8036be:	66 90                	xchg   %ax,%ax
  8036c0:	89 d8                	mov    %ebx,%eax
  8036c2:	f7 f7                	div    %edi
  8036c4:	31 ff                	xor    %edi,%edi
  8036c6:	89 fa                	mov    %edi,%edx
  8036c8:	83 c4 1c             	add    $0x1c,%esp
  8036cb:	5b                   	pop    %ebx
  8036cc:	5e                   	pop    %esi
  8036cd:	5f                   	pop    %edi
  8036ce:	5d                   	pop    %ebp
  8036cf:	c3                   	ret    
  8036d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036d5:	89 eb                	mov    %ebp,%ebx
  8036d7:	29 fb                	sub    %edi,%ebx
  8036d9:	89 f9                	mov    %edi,%ecx
  8036db:	d3 e6                	shl    %cl,%esi
  8036dd:	89 c5                	mov    %eax,%ebp
  8036df:	88 d9                	mov    %bl,%cl
  8036e1:	d3 ed                	shr    %cl,%ebp
  8036e3:	89 e9                	mov    %ebp,%ecx
  8036e5:	09 f1                	or     %esi,%ecx
  8036e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036eb:	89 f9                	mov    %edi,%ecx
  8036ed:	d3 e0                	shl    %cl,%eax
  8036ef:	89 c5                	mov    %eax,%ebp
  8036f1:	89 d6                	mov    %edx,%esi
  8036f3:	88 d9                	mov    %bl,%cl
  8036f5:	d3 ee                	shr    %cl,%esi
  8036f7:	89 f9                	mov    %edi,%ecx
  8036f9:	d3 e2                	shl    %cl,%edx
  8036fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036ff:	88 d9                	mov    %bl,%cl
  803701:	d3 e8                	shr    %cl,%eax
  803703:	09 c2                	or     %eax,%edx
  803705:	89 d0                	mov    %edx,%eax
  803707:	89 f2                	mov    %esi,%edx
  803709:	f7 74 24 0c          	divl   0xc(%esp)
  80370d:	89 d6                	mov    %edx,%esi
  80370f:	89 c3                	mov    %eax,%ebx
  803711:	f7 e5                	mul    %ebp
  803713:	39 d6                	cmp    %edx,%esi
  803715:	72 19                	jb     803730 <__udivdi3+0xfc>
  803717:	74 0b                	je     803724 <__udivdi3+0xf0>
  803719:	89 d8                	mov    %ebx,%eax
  80371b:	31 ff                	xor    %edi,%edi
  80371d:	e9 58 ff ff ff       	jmp    80367a <__udivdi3+0x46>
  803722:	66 90                	xchg   %ax,%ax
  803724:	8b 54 24 08          	mov    0x8(%esp),%edx
  803728:	89 f9                	mov    %edi,%ecx
  80372a:	d3 e2                	shl    %cl,%edx
  80372c:	39 c2                	cmp    %eax,%edx
  80372e:	73 e9                	jae    803719 <__udivdi3+0xe5>
  803730:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803733:	31 ff                	xor    %edi,%edi
  803735:	e9 40 ff ff ff       	jmp    80367a <__udivdi3+0x46>
  80373a:	66 90                	xchg   %ax,%ax
  80373c:	31 c0                	xor    %eax,%eax
  80373e:	e9 37 ff ff ff       	jmp    80367a <__udivdi3+0x46>
  803743:	90                   	nop

00803744 <__umoddi3>:
  803744:	55                   	push   %ebp
  803745:	57                   	push   %edi
  803746:	56                   	push   %esi
  803747:	53                   	push   %ebx
  803748:	83 ec 1c             	sub    $0x1c,%esp
  80374b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80374f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803753:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803757:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80375b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80375f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803763:	89 f3                	mov    %esi,%ebx
  803765:	89 fa                	mov    %edi,%edx
  803767:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80376b:	89 34 24             	mov    %esi,(%esp)
  80376e:	85 c0                	test   %eax,%eax
  803770:	75 1a                	jne    80378c <__umoddi3+0x48>
  803772:	39 f7                	cmp    %esi,%edi
  803774:	0f 86 a2 00 00 00    	jbe    80381c <__umoddi3+0xd8>
  80377a:	89 c8                	mov    %ecx,%eax
  80377c:	89 f2                	mov    %esi,%edx
  80377e:	f7 f7                	div    %edi
  803780:	89 d0                	mov    %edx,%eax
  803782:	31 d2                	xor    %edx,%edx
  803784:	83 c4 1c             	add    $0x1c,%esp
  803787:	5b                   	pop    %ebx
  803788:	5e                   	pop    %esi
  803789:	5f                   	pop    %edi
  80378a:	5d                   	pop    %ebp
  80378b:	c3                   	ret    
  80378c:	39 f0                	cmp    %esi,%eax
  80378e:	0f 87 ac 00 00 00    	ja     803840 <__umoddi3+0xfc>
  803794:	0f bd e8             	bsr    %eax,%ebp
  803797:	83 f5 1f             	xor    $0x1f,%ebp
  80379a:	0f 84 ac 00 00 00    	je     80384c <__umoddi3+0x108>
  8037a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8037a5:	29 ef                	sub    %ebp,%edi
  8037a7:	89 fe                	mov    %edi,%esi
  8037a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8037ad:	89 e9                	mov    %ebp,%ecx
  8037af:	d3 e0                	shl    %cl,%eax
  8037b1:	89 d7                	mov    %edx,%edi
  8037b3:	89 f1                	mov    %esi,%ecx
  8037b5:	d3 ef                	shr    %cl,%edi
  8037b7:	09 c7                	or     %eax,%edi
  8037b9:	89 e9                	mov    %ebp,%ecx
  8037bb:	d3 e2                	shl    %cl,%edx
  8037bd:	89 14 24             	mov    %edx,(%esp)
  8037c0:	89 d8                	mov    %ebx,%eax
  8037c2:	d3 e0                	shl    %cl,%eax
  8037c4:	89 c2                	mov    %eax,%edx
  8037c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037ca:	d3 e0                	shl    %cl,%eax
  8037cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037d4:	89 f1                	mov    %esi,%ecx
  8037d6:	d3 e8                	shr    %cl,%eax
  8037d8:	09 d0                	or     %edx,%eax
  8037da:	d3 eb                	shr    %cl,%ebx
  8037dc:	89 da                	mov    %ebx,%edx
  8037de:	f7 f7                	div    %edi
  8037e0:	89 d3                	mov    %edx,%ebx
  8037e2:	f7 24 24             	mull   (%esp)
  8037e5:	89 c6                	mov    %eax,%esi
  8037e7:	89 d1                	mov    %edx,%ecx
  8037e9:	39 d3                	cmp    %edx,%ebx
  8037eb:	0f 82 87 00 00 00    	jb     803878 <__umoddi3+0x134>
  8037f1:	0f 84 91 00 00 00    	je     803888 <__umoddi3+0x144>
  8037f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037fb:	29 f2                	sub    %esi,%edx
  8037fd:	19 cb                	sbb    %ecx,%ebx
  8037ff:	89 d8                	mov    %ebx,%eax
  803801:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803805:	d3 e0                	shl    %cl,%eax
  803807:	89 e9                	mov    %ebp,%ecx
  803809:	d3 ea                	shr    %cl,%edx
  80380b:	09 d0                	or     %edx,%eax
  80380d:	89 e9                	mov    %ebp,%ecx
  80380f:	d3 eb                	shr    %cl,%ebx
  803811:	89 da                	mov    %ebx,%edx
  803813:	83 c4 1c             	add    $0x1c,%esp
  803816:	5b                   	pop    %ebx
  803817:	5e                   	pop    %esi
  803818:	5f                   	pop    %edi
  803819:	5d                   	pop    %ebp
  80381a:	c3                   	ret    
  80381b:	90                   	nop
  80381c:	89 fd                	mov    %edi,%ebp
  80381e:	85 ff                	test   %edi,%edi
  803820:	75 0b                	jne    80382d <__umoddi3+0xe9>
  803822:	b8 01 00 00 00       	mov    $0x1,%eax
  803827:	31 d2                	xor    %edx,%edx
  803829:	f7 f7                	div    %edi
  80382b:	89 c5                	mov    %eax,%ebp
  80382d:	89 f0                	mov    %esi,%eax
  80382f:	31 d2                	xor    %edx,%edx
  803831:	f7 f5                	div    %ebp
  803833:	89 c8                	mov    %ecx,%eax
  803835:	f7 f5                	div    %ebp
  803837:	89 d0                	mov    %edx,%eax
  803839:	e9 44 ff ff ff       	jmp    803782 <__umoddi3+0x3e>
  80383e:	66 90                	xchg   %ax,%ax
  803840:	89 c8                	mov    %ecx,%eax
  803842:	89 f2                	mov    %esi,%edx
  803844:	83 c4 1c             	add    $0x1c,%esp
  803847:	5b                   	pop    %ebx
  803848:	5e                   	pop    %esi
  803849:	5f                   	pop    %edi
  80384a:	5d                   	pop    %ebp
  80384b:	c3                   	ret    
  80384c:	3b 04 24             	cmp    (%esp),%eax
  80384f:	72 06                	jb     803857 <__umoddi3+0x113>
  803851:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803855:	77 0f                	ja     803866 <__umoddi3+0x122>
  803857:	89 f2                	mov    %esi,%edx
  803859:	29 f9                	sub    %edi,%ecx
  80385b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80385f:	89 14 24             	mov    %edx,(%esp)
  803862:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803866:	8b 44 24 04          	mov    0x4(%esp),%eax
  80386a:	8b 14 24             	mov    (%esp),%edx
  80386d:	83 c4 1c             	add    $0x1c,%esp
  803870:	5b                   	pop    %ebx
  803871:	5e                   	pop    %esi
  803872:	5f                   	pop    %edi
  803873:	5d                   	pop    %ebp
  803874:	c3                   	ret    
  803875:	8d 76 00             	lea    0x0(%esi),%esi
  803878:	2b 04 24             	sub    (%esp),%eax
  80387b:	19 fa                	sbb    %edi,%edx
  80387d:	89 d1                	mov    %edx,%ecx
  80387f:	89 c6                	mov    %eax,%esi
  803881:	e9 71 ff ff ff       	jmp    8037f7 <__umoddi3+0xb3>
  803886:	66 90                	xchg   %ax,%ax
  803888:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80388c:	72 ea                	jb     803878 <__umoddi3+0x134>
  80388e:	89 d9                	mov    %ebx,%ecx
  803890:	e9 62 ff ff ff       	jmp    8037f7 <__umoddi3+0xb3>
