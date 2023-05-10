
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 8f 07 00 00       	call   8007c5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

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
  800041:	e8 bc 21 00 00       	call   802202 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 80 3a 80 00       	push   $0x803a80
  80004e:	e8 62 0b 00 00       	call   800bb5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 82 3a 80 00       	push   $0x803a82
  80005e:	e8 52 0b 00 00       	call   800bb5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 98 3a 80 00       	push   $0x803a98
  80006e:	e8 42 0b 00 00       	call   800bb5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 82 3a 80 00       	push   $0x803a82
  80007e:	e8 32 0b 00 00       	call   800bb5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 80 3a 80 00       	push   $0x803a80
  80008e:	e8 22 0b 00 00       	call   800bb5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 b0 3a 80 00       	push   $0x803ab0
  8000a5:	e8 8d 11 00 00       	call   801237 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 dd 16 00 00       	call   80179d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 12 1c 00 00       	call   801ce7 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 d0 3a 80 00       	push   $0x803ad0
  8000e3:	e8 cd 0a 00 00       	call   800bb5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 f2 3a 80 00       	push   $0x803af2
  8000f3:	e8 bd 0a 00 00       	call   800bb5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 00 3b 80 00       	push   $0x803b00
  800103:	e8 ad 0a 00 00       	call   800bb5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 0f 3b 80 00       	push   $0x803b0f
  800113:	e8 9d 0a 00 00       	call   800bb5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 1f 3b 80 00       	push   $0x803b1f
  800123:	e8 8d 0a 00 00       	call   800bb5 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 3d 06 00 00       	call   80076d <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 e5 05 00 00       	call   800725 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 d8 05 00 00       	call   800725 <cputchar>
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
  800162:	e8 b5 20 00 00       	call   80221c <sys_enable_interrupt>

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
  800183:	e8 f4 01 00 00       	call   80037c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 12 02 00 00       	call   8003ad <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 34 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 21 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 e0 02 00 00       	call   8004b4 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 26 20 00 00       	call   802202 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 28 3b 80 00       	push   $0x803b28
  8001e4:	e8 cc 09 00 00       	call   800bb5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 2b 20 00 00       	call   80221c <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 d3 00 00 00       	call   8002d2 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 5c 3b 80 00       	push   $0x803b5c
  800213:	6a 4a                	push   $0x4a
  800215:	68 7e 3b 80 00       	push   $0x803b7e
  80021a:	e8 e2 06 00 00       	call   800901 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 de 1f 00 00       	call   802202 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 9c 3b 80 00       	push   $0x803b9c
  80022c:	e8 84 09 00 00       	call   800bb5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 d0 3b 80 00       	push   $0x803bd0
  80023c:	e8 74 09 00 00       	call   800bb5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 04 3c 80 00       	push   $0x803c04
  80024c:	e8 64 09 00 00       	call   800bb5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 c3 1f 00 00       	call   80221c <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 fe 1a 00 00       	call   801d62 <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 96 1f 00 00       	call   802202 <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 36 3c 80 00       	push   $0x803c36
  80027a:	e8 36 09 00 00       	call   800bb5 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800282:	e8 e6 04 00 00       	call   80076d <getchar>
  800287:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80028a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 8e 04 00 00       	call   800725 <cputchar>
  800297:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	6a 0a                	push   $0xa
  80029f:	e8 81 04 00 00       	call   800725 <cputchar>
  8002a4:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	6a 0a                	push   $0xa
  8002ac:	e8 74 04 00 00       	call   800725 <cputchar>
  8002b1:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b8:	74 06                	je     8002c0 <_main+0x288>
  8002ba:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002be:	75 b2                	jne    800272 <_main+0x23a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002c0:	e8 57 1f 00 00       	call   80221c <sys_enable_interrupt>

	} while (Chose == 'y');
  8002c5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c9:	0f 84 72 fd ff ff    	je     800041 <_main+0x9>

}
  8002cf:	90                   	nop
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002e6:	eb 33                	jmp    80031b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8b 10                	mov    (%eax),%edx
  8002f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002fc:	40                   	inc    %eax
  8002fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	01 c8                	add    %ecx,%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	39 c2                	cmp    %eax,%edx
  80030d:	7e 09                	jle    800318 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80030f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800316:	eb 0c                	jmp    800324 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800318:	ff 45 f8             	incl   -0x8(%ebp)
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	48                   	dec    %eax
  80031f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800322:	7f c4                	jg     8002e8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800324:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	01 d0                	add    %edx,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	01 c2                	add    %eax,%edx
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	01 c8                	add    %ecx,%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800365:	8b 45 10             	mov    0x10(%ebp),%eax
  800368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	01 c2                	add    %eax,%edx
  800374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800377:	89 02                	mov    %eax,(%edx)
}
  800379:	90                   	nop
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800389:	eb 17                	jmp    8003a2 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80038b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 c2                	add    %eax,%edx
  80039a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80039f:	ff 45 fc             	incl   -0x4(%ebp)
  8003a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003a8:	7c e1                	jl     80038b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003aa:	90                   	nop
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ba:	eb 1b                	jmp    8003d7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	01 c2                	add    %eax,%edx
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003d1:	48                   	dec    %eax
  8003d2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003d4:	ff 45 fc             	incl   -0x4(%ebp)
  8003d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003dd:	7c dd                	jl     8003bc <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003df:	90                   	nop
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003f0:	f7 e9                	imul   %ecx
  8003f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	29 c8                	sub    %ecx,%eax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800403:	eb 1e                	jmp    800423 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	99                   	cltd   
  800419:	f7 7d f8             	idivl  -0x8(%ebp)
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 fc             	incl   -0x4(%ebp)
  800423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	7c da                	jl     800405 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
			//cprintf("i=%d\n",i);
	}

}
  80042b:	90                   	nop
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800434:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800442:	eb 42                	jmp    800486 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800447:	99                   	cltd   
  800448:	f7 7d f0             	idivl  -0x10(%ebp)
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 10                	jne    800461 <PrintElements+0x33>
			cprintf("\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 80 3a 80 00       	push   $0x803a80
  800459:	e8 57 07 00 00       	call   800bb5 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	50                   	push   %eax
  800476:	68 54 3c 80 00       	push   $0x803c54
  80047b:	e8 35 07 00 00       	call   800bb5 <cprintf>
  800480:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800483:	ff 45 f4             	incl   -0xc(%ebp)
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	48                   	dec    %eax
  80048a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80048d:	7f b5                	jg     800444 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	01 d0                	add    %edx,%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 59 3c 80 00       	push   $0x803c59
  8004a9:	e8 07 07 00 00       	call   800bb5 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp

}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c0:	7d 54                	jge    800516 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	89 c2                	mov    %eax,%edx
  8004cc:	c1 ea 1f             	shr    $0x1f,%edx
  8004cf:	01 d0                	add    %edx,%eax
  8004d1:	d1 f8                	sar    %eax
  8004d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 cd ff ff ff       	call   8004b4 <MSort>
  8004e7:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ed:	40                   	inc    %eax
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	ff 75 10             	pushl  0x10(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	e8 b7 ff ff ff       	call   8004b4 <MSort>
  8004fd:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800500:	ff 75 10             	pushl  0x10(%ebp)
  800503:	ff 75 f4             	pushl  -0xc(%ebp)
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	e8 08 00 00 00       	call   800519 <Merge>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	eb 01                	jmp    800517 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800516:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80051f:	8b 45 10             	mov    0x10(%ebp),%eax
  800522:	2b 45 0c             	sub    0xc(%ebp),%eax
  800525:	40                   	inc    %eax
  800526:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	2b 45 10             	sub    0x10(%ebp),%eax
  80052f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	c1 e0 02             	shl    $0x2,%eax
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	50                   	push   %eax
  80054a:	e8 98 17 00 00       	call   801ce7 <malloc>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  800555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800558:	c1 e0 02             	shl    $0x2,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 83 17 00 00       	call   801ce7 <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800571:	eb 2f                	jmp    8005a2 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800576:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800580:	01 c2                	add    %eax,%edx
  800582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80058f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80059f:	ff 45 ec             	incl   -0x14(%ebp)
  8005a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005a8:	7c c9                	jl     800573 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b1:	eb 2a                	jmp    8005dd <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c0:	01 c2                	add    %eax,%edx
  8005c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 c8                	add    %ecx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e3:	7c ce                	jl     8005b3 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005eb:	e9 0a 01 00 00       	jmp    8006fa <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005f6:	0f 8d 95 00 00 00    	jge    800691 <Merge+0x178>
  8005fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800602:	0f 8d 89 00 00 00    	jge    800691 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800612:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800615:	01 d0                	add    %edx,%eax
  800617:	8b 10                	mov    (%eax),%edx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800626:	01 c8                	add    %ecx,%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	7d 33                	jge    800661 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80062e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800631:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800646:	8d 50 01             	lea    0x1(%eax),%edx
  800649:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80064c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800653:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80065c:	e9 96 00 00 00       	jmp    8006f7 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800664:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800669:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800679:	8d 50 01             	lea    0x1(%eax),%edx
  80067c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80067f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80068f:	eb 66                	jmp    8006f7 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800694:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800697:	7d 30                	jge    8006c9 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b1:	8d 50 01             	lea    0x1(%eax),%edx
  8006b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c1:	01 d0                	add    %edx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 01                	mov    %eax,(%ecx)
  8006c7:	eb 2e                	jmp    8006f7 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006cc:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8d 50 01             	lea    0x1(%eax),%edx
  8006e4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f1:	01 d0                	add    %edx,%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006f7:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800700:	0f 8e ea fe ff ff    	jle    8005f0 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d8             	pushl  -0x28(%ebp)
  80070c:	e8 51 16 00 00       	call   801d62 <free>
  800711:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071a:	e8 43 16 00 00       	call   801d62 <free>
  80071f:	83 c4 10             	add    $0x10,%esp

}
  800722:	90                   	nop
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800731:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	50                   	push   %eax
  800739:	e8 f8 1a 00 00       	call   802236 <sys_cputc>
  80073e:	83 c4 10             	add    $0x10,%esp
}
  800741:	90                   	nop
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80074a:	e8 b3 1a 00 00       	call   802202 <sys_disable_interrupt>
	char c = ch;
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800755:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	50                   	push   %eax
  80075d:	e8 d4 1a 00 00       	call   802236 <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 b2 1a 00 00       	call   80221c <sys_enable_interrupt>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <getchar>:

int
getchar(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80077a:	eb 08                	jmp    800784 <getchar+0x17>
	{
		c = sys_cgetc();
  80077c:	e8 fc 18 00 00       	call   80207d <sys_cgetc>
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800788:	74 f2                	je     80077c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <atomic_getchar>:

int
atomic_getchar(void)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800795:	e8 68 1a 00 00       	call   802202 <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 d5 18 00 00       	call   80207d <sys_cgetc>
  8007a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007af:	74 f2                	je     8007a3 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007b1:	e8 66 1a 00 00       	call   80221c <sys_enable_interrupt>
	return c;
  8007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <iscons>:

int iscons(int fdnum)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007cb:	e8 25 1c 00 00       	call   8023f5 <sys_getenvindex>
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d6:	89 d0                	mov    %edx,%eax
  8007d8:	c1 e0 03             	shl    $0x3,%eax
  8007db:	01 d0                	add    %edx,%eax
  8007dd:	01 c0                	add    %eax,%eax
  8007df:	01 d0                	add    %edx,%eax
  8007e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	c1 e0 04             	shl    $0x4,%eax
  8007ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007f2:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800802:	84 c0                	test   %al,%al
  800804:	74 0f                	je     800815 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800806:	a1 24 50 80 00       	mov    0x805024,%eax
  80080b:	05 5c 05 00 00       	add    $0x55c,%eax
  800810:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800815:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800819:	7e 0a                	jle    800825 <libmain+0x60>
		binaryname = argv[0];
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	e8 05 f8 ff ff       	call   800038 <_main>
  800833:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800836:	e8 c7 19 00 00       	call   802202 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80083b:	83 ec 0c             	sub    $0xc,%esp
  80083e:	68 78 3c 80 00       	push   $0x803c78
  800843:	e8 6d 03 00 00       	call   800bb5 <cprintf>
  800848:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80084b:	a1 24 50 80 00       	mov    0x805024,%eax
  800850:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800861:	83 ec 04             	sub    $0x4,%esp
  800864:	52                   	push   %edx
  800865:	50                   	push   %eax
  800866:	68 a0 3c 80 00       	push   $0x803ca0
  80086b:	e8 45 03 00 00       	call   800bb5 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800873:	a1 24 50 80 00       	mov    0x805024,%eax
  800878:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	68 c8 3c 80 00       	push   $0x803cc8
  80089c:	e8 14 03 00 00       	call   800bb5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a9:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 20 3d 80 00       	push   $0x803d20
  8008b8:	e8 f8 02 00 00       	call   800bb5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 78 3c 80 00       	push   $0x803c78
  8008c8:	e8 e8 02 00 00       	call   800bb5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008d0:	e8 47 19 00 00       	call   80221c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008d5:	e8 19 00 00 00       	call   8008f3 <exit>
}
  8008da:	90                   	nop
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008e3:	83 ec 0c             	sub    $0xc,%esp
  8008e6:	6a 00                	push   $0x0
  8008e8:	e8 d4 1a 00 00       	call   8023c1 <sys_destroy_env>
  8008ed:	83 c4 10             	add    $0x10,%esp
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <exit>:

void
exit(void)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008f9:	e8 29 1b 00 00       	call   802427 <sys_exit_env>
}
  8008fe:	90                   	nop
  8008ff:	c9                   	leave  
  800900:	c3                   	ret    

00800901 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800907:	8d 45 10             	lea    0x10(%ebp),%eax
  80090a:	83 c0 04             	add    $0x4,%eax
  80090d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800910:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800915:	85 c0                	test   %eax,%eax
  800917:	74 16                	je     80092f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800919:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	50                   	push   %eax
  800922:	68 34 3d 80 00       	push   $0x803d34
  800927:	e8 89 02 00 00       	call   800bb5 <cprintf>
  80092c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80092f:	a1 00 50 80 00       	mov    0x805000,%eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	50                   	push   %eax
  80093b:	68 39 3d 80 00       	push   $0x803d39
  800940:	e8 70 02 00 00       	call   800bb5 <cprintf>
  800945:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 f4             	pushl  -0xc(%ebp)
  800951:	50                   	push   %eax
  800952:	e8 f3 01 00 00       	call   800b4a <vcprintf>
  800957:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	6a 00                	push   $0x0
  80095f:	68 55 3d 80 00       	push   $0x803d55
  800964:	e8 e1 01 00 00       	call   800b4a <vcprintf>
  800969:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80096c:	e8 82 ff ff ff       	call   8008f3 <exit>

	// should not return here
	while (1) ;
  800971:	eb fe                	jmp    800971 <_panic+0x70>

00800973 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800979:	a1 24 50 80 00       	mov    0x805024,%eax
  80097e:	8b 50 74             	mov    0x74(%eax),%edx
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	39 c2                	cmp    %eax,%edx
  800986:	74 14                	je     80099c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 58 3d 80 00       	push   $0x803d58
  800990:	6a 26                	push   $0x26
  800992:	68 a4 3d 80 00       	push   $0x803da4
  800997:	e8 65 ff ff ff       	call   800901 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80099c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009aa:	e9 c2 00 00 00       	jmp    800a71 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	01 d0                	add    %edx,%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	85 c0                	test   %eax,%eax
  8009c2:	75 08                	jne    8009cc <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009c4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009c7:	e9 a2 00 00 00       	jmp    800a6e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009da:	eb 69                	jmp    800a45 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8009e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ea:	89 d0                	mov    %edx,%eax
  8009ec:	01 c0                	add    %eax,%eax
  8009ee:	01 d0                	add    %edx,%eax
  8009f0:	c1 e0 03             	shl    $0x3,%eax
  8009f3:	01 c8                	add    %ecx,%eax
  8009f5:	8a 40 04             	mov    0x4(%eax),%al
  8009f8:	84 c0                	test   %al,%al
  8009fa:	75 46                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009fc:	a1 24 50 80 00       	mov    0x805024,%eax
  800a01:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	01 c0                	add    %eax,%eax
  800a0e:	01 d0                	add    %edx,%eax
  800a10:	c1 e0 03             	shl    $0x3,%eax
  800a13:	01 c8                	add    %ecx,%eax
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a22:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a27:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	01 c8                	add    %ecx,%eax
  800a33:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a35:	39 c2                	cmp    %eax,%edx
  800a37:	75 09                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a39:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a40:	eb 12                	jmp    800a54 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a42:	ff 45 e8             	incl   -0x18(%ebp)
  800a45:	a1 24 50 80 00       	mov    0x805024,%eax
  800a4a:	8b 50 74             	mov    0x74(%eax),%edx
  800a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a50:	39 c2                	cmp    %eax,%edx
  800a52:	77 88                	ja     8009dc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a58:	75 14                	jne    800a6e <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a5a:	83 ec 04             	sub    $0x4,%esp
  800a5d:	68 b0 3d 80 00       	push   $0x803db0
  800a62:	6a 3a                	push   $0x3a
  800a64:	68 a4 3d 80 00       	push   $0x803da4
  800a69:	e8 93 fe ff ff       	call   800901 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a6e:	ff 45 f0             	incl   -0x10(%ebp)
  800a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a74:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a77:	0f 8c 32 ff ff ff    	jl     8009af <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a8b:	eb 26                	jmp    800ab3 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a8d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a92:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a9b:	89 d0                	mov    %edx,%eax
  800a9d:	01 c0                	add    %eax,%eax
  800a9f:	01 d0                	add    %edx,%eax
  800aa1:	c1 e0 03             	shl    $0x3,%eax
  800aa4:	01 c8                	add    %ecx,%eax
  800aa6:	8a 40 04             	mov    0x4(%eax),%al
  800aa9:	3c 01                	cmp    $0x1,%al
  800aab:	75 03                	jne    800ab0 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800aad:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ab0:	ff 45 e0             	incl   -0x20(%ebp)
  800ab3:	a1 24 50 80 00       	mov    0x805024,%eax
  800ab8:	8b 50 74             	mov    0x74(%eax),%edx
  800abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800abe:	39 c2                	cmp    %eax,%edx
  800ac0:	77 cb                	ja     800a8d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ac8:	74 14                	je     800ade <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aca:	83 ec 04             	sub    $0x4,%esp
  800acd:	68 04 3e 80 00       	push   $0x803e04
  800ad2:	6a 44                	push   $0x44
  800ad4:	68 a4 3d 80 00       	push   $0x803da4
  800ad9:	e8 23 fe ff ff       	call   800901 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ade:	90                   	nop
  800adf:	c9                   	leave  
  800ae0:	c3                   	ret    

00800ae1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	8d 48 01             	lea    0x1(%eax),%ecx
  800aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af2:	89 0a                	mov    %ecx,(%edx)
  800af4:	8b 55 08             	mov    0x8(%ebp),%edx
  800af7:	88 d1                	mov    %dl,%cl
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b0a:	75 2c                	jne    800b38 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b0c:	a0 28 50 80 00       	mov    0x805028,%al
  800b11:	0f b6 c0             	movzbl %al,%eax
  800b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b17:	8b 12                	mov    (%edx),%edx
  800b19:	89 d1                	mov    %edx,%ecx
  800b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1e:	83 c2 08             	add    $0x8,%edx
  800b21:	83 ec 04             	sub    $0x4,%esp
  800b24:	50                   	push   %eax
  800b25:	51                   	push   %ecx
  800b26:	52                   	push   %edx
  800b27:	e8 28 15 00 00       	call   802054 <sys_cputs>
  800b2c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8b 40 04             	mov    0x4(%eax),%eax
  800b3e:	8d 50 01             	lea    0x1(%eax),%edx
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b47:	90                   	nop
  800b48:	c9                   	leave  
  800b49:	c3                   	ret    

00800b4a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b53:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b5a:	00 00 00 
	b.cnt = 0;
  800b5d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b64:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	ff 75 08             	pushl  0x8(%ebp)
  800b6d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 e1 0a 80 00       	push   $0x800ae1
  800b79:	e8 11 02 00 00       	call   800d8f <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b81:	a0 28 50 80 00       	mov    0x805028,%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	50                   	push   %eax
  800b93:	52                   	push   %edx
  800b94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b9a:	83 c0 08             	add    $0x8,%eax
  800b9d:	50                   	push   %eax
  800b9e:	e8 b1 14 00 00       	call   802054 <sys_cputs>
  800ba3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ba6:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bbb:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bc2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	e8 73 ff ff ff       	call   800b4a <vcprintf>
  800bd7:	83 c4 10             	add    $0x10,%esp
  800bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800be8:	e8 15 16 00 00       	call   802202 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bed:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	e8 48 ff ff ff       	call   800b4a <vcprintf>
  800c02:	83 c4 10             	add    $0x10,%esp
  800c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c08:	e8 0f 16 00 00       	call   80221c <sys_enable_interrupt>
	return cnt;
  800c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	53                   	push   %ebx
  800c16:	83 ec 14             	sub    $0x14,%esp
  800c19:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c25:	8b 45 18             	mov    0x18(%ebp),%eax
  800c28:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c30:	77 55                	ja     800c87 <printnum+0x75>
  800c32:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c35:	72 05                	jb     800c3c <printnum+0x2a>
  800c37:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c3a:	77 4b                	ja     800c87 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c3c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c3f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c42:	8b 45 18             	mov    0x18(%ebp),%eax
  800c45:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4a:	52                   	push   %edx
  800c4b:	50                   	push   %eax
  800c4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800c52:	e8 b9 2b 00 00       	call   803810 <__udivdi3>
  800c57:	83 c4 10             	add    $0x10,%esp
  800c5a:	83 ec 04             	sub    $0x4,%esp
  800c5d:	ff 75 20             	pushl  0x20(%ebp)
  800c60:	53                   	push   %ebx
  800c61:	ff 75 18             	pushl  0x18(%ebp)
  800c64:	52                   	push   %edx
  800c65:	50                   	push   %eax
  800c66:	ff 75 0c             	pushl  0xc(%ebp)
  800c69:	ff 75 08             	pushl  0x8(%ebp)
  800c6c:	e8 a1 ff ff ff       	call   800c12 <printnum>
  800c71:	83 c4 20             	add    $0x20,%esp
  800c74:	eb 1a                	jmp    800c90 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 20             	pushl  0x20(%ebp)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	ff d0                	call   *%eax
  800c84:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c87:	ff 4d 1c             	decl   0x1c(%ebp)
  800c8a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c8e:	7f e6                	jg     800c76 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c90:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9e:	53                   	push   %ebx
  800c9f:	51                   	push   %ecx
  800ca0:	52                   	push   %edx
  800ca1:	50                   	push   %eax
  800ca2:	e8 79 2c 00 00       	call   803920 <__umoddi3>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	05 74 40 80 00       	add    $0x804074,%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be c0             	movsbl %al,%eax
  800cb4:	83 ec 08             	sub    $0x8,%esp
  800cb7:	ff 75 0c             	pushl  0xc(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
}
  800cc3:	90                   	nop
  800cc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd0:	7e 1c                	jle    800cee <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8b 00                	mov    (%eax),%eax
  800cd7:	8d 50 08             	lea    0x8(%eax),%edx
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 10                	mov    %edx,(%eax)
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8b 00                	mov    (%eax),%eax
  800ce4:	83 e8 08             	sub    $0x8,%eax
  800ce7:	8b 50 04             	mov    0x4(%eax),%edx
  800cea:	8b 00                	mov    (%eax),%eax
  800cec:	eb 40                	jmp    800d2e <getuint+0x65>
	else if (lflag)
  800cee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf2:	74 1e                	je     800d12 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8b 00                	mov    (%eax),%eax
  800cf9:	8d 50 04             	lea    0x4(%eax),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 10                	mov    %edx,(%eax)
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 e8 04             	sub    $0x4,%eax
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	eb 1c                	jmp    800d2e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8b 00                	mov    (%eax),%eax
  800d17:	8d 50 04             	lea    0x4(%eax),%edx
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 10                	mov    %edx,(%eax)
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	83 e8 04             	sub    $0x4,%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d33:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d37:	7e 1c                	jle    800d55 <getint+0x25>
		return va_arg(*ap, long long);
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	8d 50 08             	lea    0x8(%eax),%edx
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	89 10                	mov    %edx,(%eax)
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	83 e8 08             	sub    $0x8,%eax
  800d4e:	8b 50 04             	mov    0x4(%eax),%edx
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	eb 38                	jmp    800d8d <getint+0x5d>
	else if (lflag)
  800d55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d59:	74 1a                	je     800d75 <getint+0x45>
		return va_arg(*ap, long);
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8b 00                	mov    (%eax),%eax
  800d60:	8d 50 04             	lea    0x4(%eax),%edx
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	89 10                	mov    %edx,(%eax)
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8b 00                	mov    (%eax),%eax
  800d6d:	83 e8 04             	sub    $0x4,%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	99                   	cltd   
  800d73:	eb 18                	jmp    800d8d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 50 04             	lea    0x4(%eax),%edx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	89 10                	mov    %edx,(%eax)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8b 00                	mov    (%eax),%eax
  800d87:	83 e8 04             	sub    $0x4,%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	99                   	cltd   
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d97:	eb 17                	jmp    800db0 <vprintfmt+0x21>
			if (ch == '\0')
  800d99:	85 db                	test   %ebx,%ebx
  800d9b:	0f 84 af 03 00 00    	je     801150 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	53                   	push   %ebx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	ff d0                	call   *%eax
  800dad:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	8d 50 01             	lea    0x1(%eax),%edx
  800db6:	89 55 10             	mov    %edx,0x10(%ebp)
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	0f b6 d8             	movzbl %al,%ebx
  800dbe:	83 fb 25             	cmp    $0x25,%ebx
  800dc1:	75 d6                	jne    800d99 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dc3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dc7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dd5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ddc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	8d 50 01             	lea    0x1(%eax),%edx
  800de9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	0f b6 d8             	movzbl %al,%ebx
  800df1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800df4:	83 f8 55             	cmp    $0x55,%eax
  800df7:	0f 87 2b 03 00 00    	ja     801128 <vprintfmt+0x399>
  800dfd:	8b 04 85 98 40 80 00 	mov    0x804098(,%eax,4),%eax
  800e04:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e06:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e0a:	eb d7                	jmp    800de3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e0c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e10:	eb d1                	jmp    800de3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e1c:	89 d0                	mov    %edx,%eax
  800e1e:	c1 e0 02             	shl    $0x2,%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d8                	add    %ebx,%eax
  800e27:	83 e8 30             	sub    $0x30,%eax
  800e2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e35:	83 fb 2f             	cmp    $0x2f,%ebx
  800e38:	7e 3e                	jle    800e78 <vprintfmt+0xe9>
  800e3a:	83 fb 39             	cmp    $0x39,%ebx
  800e3d:	7f 39                	jg     800e78 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e3f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e42:	eb d5                	jmp    800e19 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e44:	8b 45 14             	mov    0x14(%ebp),%eax
  800e47:	83 c0 04             	add    $0x4,%eax
  800e4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e50:	83 e8 04             	sub    $0x4,%eax
  800e53:	8b 00                	mov    (%eax),%eax
  800e55:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e58:	eb 1f                	jmp    800e79 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5e:	79 83                	jns    800de3 <vprintfmt+0x54>
				width = 0;
  800e60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e67:	e9 77 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e6c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e73:	e9 6b ff ff ff       	jmp    800de3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e78:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7d:	0f 89 60 ff ff ff    	jns    800de3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e90:	e9 4e ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e95:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e98:	e9 46 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea0:	83 c0 04             	add    $0x4,%eax
  800ea3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea9:	83 e8 04             	sub    $0x4,%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	ff 75 0c             	pushl  0xc(%ebp)
  800eb4:	50                   	push   %eax
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	ff d0                	call   *%eax
  800eba:	83 c4 10             	add    $0x10,%esp
			break;
  800ebd:	e9 89 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ec2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec5:	83 c0 04             	add    $0x4,%eax
  800ec8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ecb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ece:	83 e8 04             	sub    $0x4,%eax
  800ed1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ed3:	85 db                	test   %ebx,%ebx
  800ed5:	79 02                	jns    800ed9 <vprintfmt+0x14a>
				err = -err;
  800ed7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ed9:	83 fb 64             	cmp    $0x64,%ebx
  800edc:	7f 0b                	jg     800ee9 <vprintfmt+0x15a>
  800ede:	8b 34 9d e0 3e 80 00 	mov    0x803ee0(,%ebx,4),%esi
  800ee5:	85 f6                	test   %esi,%esi
  800ee7:	75 19                	jne    800f02 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee9:	53                   	push   %ebx
  800eea:	68 85 40 80 00       	push   $0x804085
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	ff 75 08             	pushl  0x8(%ebp)
  800ef5:	e8 5e 02 00 00       	call   801158 <printfmt>
  800efa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800efd:	e9 49 02 00 00       	jmp    80114b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f02:	56                   	push   %esi
  800f03:	68 8e 40 80 00       	push   $0x80408e
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	ff 75 08             	pushl  0x8(%ebp)
  800f0e:	e8 45 02 00 00       	call   801158 <printfmt>
  800f13:	83 c4 10             	add    $0x10,%esp
			break;
  800f16:	e9 30 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1e:	83 c0 04             	add    $0x4,%eax
  800f21:	89 45 14             	mov    %eax,0x14(%ebp)
  800f24:	8b 45 14             	mov    0x14(%ebp),%eax
  800f27:	83 e8 04             	sub    $0x4,%eax
  800f2a:	8b 30                	mov    (%eax),%esi
  800f2c:	85 f6                	test   %esi,%esi
  800f2e:	75 05                	jne    800f35 <vprintfmt+0x1a6>
				p = "(null)";
  800f30:	be 91 40 80 00       	mov    $0x804091,%esi
			if (width > 0 && padc != '-')
  800f35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f39:	7e 6d                	jle    800fa8 <vprintfmt+0x219>
  800f3b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f3f:	74 67                	je     800fa8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	83 ec 08             	sub    $0x8,%esp
  800f47:	50                   	push   %eax
  800f48:	56                   	push   %esi
  800f49:	e8 12 05 00 00       	call   801460 <strnlen>
  800f4e:	83 c4 10             	add    $0x10,%esp
  800f51:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f54:	eb 16                	jmp    800f6c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f56:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	50                   	push   %eax
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	ff d0                	call   *%eax
  800f66:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f69:	ff 4d e4             	decl   -0x1c(%ebp)
  800f6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f70:	7f e4                	jg     800f56 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f72:	eb 34                	jmp    800fa8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f78:	74 1c                	je     800f96 <vprintfmt+0x207>
  800f7a:	83 fb 1f             	cmp    $0x1f,%ebx
  800f7d:	7e 05                	jle    800f84 <vprintfmt+0x1f5>
  800f7f:	83 fb 7e             	cmp    $0x7e,%ebx
  800f82:	7e 12                	jle    800f96 <vprintfmt+0x207>
					putch('?', putdat);
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	6a 3f                	push   $0x3f
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	ff d0                	call   *%eax
  800f91:	83 c4 10             	add    $0x10,%esp
  800f94:	eb 0f                	jmp    800fa5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800fa8:	89 f0                	mov    %esi,%eax
  800faa:	8d 70 01             	lea    0x1(%eax),%esi
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f be d8             	movsbl %al,%ebx
  800fb2:	85 db                	test   %ebx,%ebx
  800fb4:	74 24                	je     800fda <vprintfmt+0x24b>
  800fb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fba:	78 b8                	js     800f74 <vprintfmt+0x1e5>
  800fbc:	ff 4d e0             	decl   -0x20(%ebp)
  800fbf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc3:	79 af                	jns    800f74 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc5:	eb 13                	jmp    800fda <vprintfmt+0x24b>
				putch(' ', putdat);
  800fc7:	83 ec 08             	sub    $0x8,%esp
  800fca:	ff 75 0c             	pushl  0xc(%ebp)
  800fcd:	6a 20                	push   $0x20
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	ff d0                	call   *%eax
  800fd4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd7:	ff 4d e4             	decl   -0x1c(%ebp)
  800fda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fde:	7f e7                	jg     800fc7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fe0:	e9 66 01 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	ff 75 e8             	pushl  -0x18(%ebp)
  800feb:	8d 45 14             	lea    0x14(%ebp),%eax
  800fee:	50                   	push   %eax
  800fef:	e8 3c fd ff ff       	call   800d30 <getint>
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801000:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801003:	85 d2                	test   %edx,%edx
  801005:	79 23                	jns    80102a <vprintfmt+0x29b>
				putch('-', putdat);
  801007:	83 ec 08             	sub    $0x8,%esp
  80100a:	ff 75 0c             	pushl  0xc(%ebp)
  80100d:	6a 2d                	push   $0x2d
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	ff d0                	call   *%eax
  801014:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101d:	f7 d8                	neg    %eax
  80101f:	83 d2 00             	adc    $0x0,%edx
  801022:	f7 da                	neg    %edx
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80102a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801031:	e9 bc 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801036:	83 ec 08             	sub    $0x8,%esp
  801039:	ff 75 e8             	pushl  -0x18(%ebp)
  80103c:	8d 45 14             	lea    0x14(%ebp),%eax
  80103f:	50                   	push   %eax
  801040:	e8 84 fc ff ff       	call   800cc9 <getuint>
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80104e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801055:	e9 98 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	6a 58                	push   $0x58
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	ff d0                	call   *%eax
  801067:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	ff 75 0c             	pushl  0xc(%ebp)
  801070:	6a 58                	push   $0x58
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	ff d0                	call   *%eax
  801077:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	6a 58                	push   $0x58
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	ff d0                	call   *%eax
  801087:	83 c4 10             	add    $0x10,%esp
			break;
  80108a:	e9 bc 00 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80108f:	83 ec 08             	sub    $0x8,%esp
  801092:	ff 75 0c             	pushl  0xc(%ebp)
  801095:	6a 30                	push   $0x30
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	ff d0                	call   *%eax
  80109c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80109f:	83 ec 08             	sub    $0x8,%esp
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	6a 78                	push   $0x78
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	ff d0                	call   *%eax
  8010ac:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010af:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b2:	83 c0 04             	add    $0x4,%eax
  8010b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bb:	83 e8 04             	sub    $0x4,%eax
  8010be:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010ca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010d1:	eb 1f                	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8010d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8010dc:	50                   	push   %eax
  8010dd:	e8 e7 fb ff ff       	call   800cc9 <getuint>
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010eb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010f2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	52                   	push   %edx
  8010fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801100:	50                   	push   %eax
  801101:	ff 75 f4             	pushl  -0xc(%ebp)
  801104:	ff 75 f0             	pushl  -0x10(%ebp)
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	ff 75 08             	pushl  0x8(%ebp)
  80110d:	e8 00 fb ff ff       	call   800c12 <printnum>
  801112:	83 c4 20             	add    $0x20,%esp
			break;
  801115:	eb 34                	jmp    80114b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	53                   	push   %ebx
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	ff d0                	call   *%eax
  801123:	83 c4 10             	add    $0x10,%esp
			break;
  801126:	eb 23                	jmp    80114b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	ff 75 0c             	pushl  0xc(%ebp)
  80112e:	6a 25                	push   $0x25
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	ff d0                	call   *%eax
  801135:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801138:	ff 4d 10             	decl   0x10(%ebp)
  80113b:	eb 03                	jmp    801140 <vprintfmt+0x3b1>
  80113d:	ff 4d 10             	decl   0x10(%ebp)
  801140:	8b 45 10             	mov    0x10(%ebp),%eax
  801143:	48                   	dec    %eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 25                	cmp    $0x25,%al
  801148:	75 f3                	jne    80113d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80114a:	90                   	nop
		}
	}
  80114b:	e9 47 fc ff ff       	jmp    800d97 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801150:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801151:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801154:	5b                   	pop    %ebx
  801155:	5e                   	pop    %esi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    

00801158 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80115e:	8d 45 10             	lea    0x10(%ebp),%eax
  801161:	83 c0 04             	add    $0x4,%eax
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801167:	8b 45 10             	mov    0x10(%ebp),%eax
  80116a:	ff 75 f4             	pushl  -0xc(%ebp)
  80116d:	50                   	push   %eax
  80116e:	ff 75 0c             	pushl  0xc(%ebp)
  801171:	ff 75 08             	pushl  0x8(%ebp)
  801174:	e8 16 fc ff ff       	call   800d8f <vprintfmt>
  801179:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80117c:	90                   	nop
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	8b 40 08             	mov    0x8(%eax),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 10                	mov    (%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	8b 40 04             	mov    0x4(%eax),%eax
  80119c:	39 c2                	cmp    %eax,%edx
  80119e:	73 12                	jae    8011b2 <sprintputch+0x33>
		*b->buf++ = ch;
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	8b 00                	mov    (%eax),%eax
  8011a5:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ab:	89 0a                	mov    %ecx,(%edx)
  8011ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b0:	88 10                	mov    %dl,(%eax)
}
  8011b2:	90                   	nop
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    

008011b5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011da:	74 06                	je     8011e2 <vsnprintf+0x2d>
  8011dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e0:	7f 07                	jg     8011e9 <vsnprintf+0x34>
		return -E_INVAL;
  8011e2:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e7:	eb 20                	jmp    801209 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011e9:	ff 75 14             	pushl  0x14(%ebp)
  8011ec:	ff 75 10             	pushl  0x10(%ebp)
  8011ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011f2:	50                   	push   %eax
  8011f3:	68 7f 11 80 00       	push   $0x80117f
  8011f8:	e8 92 fb ff ff       	call   800d8f <vprintfmt>
  8011fd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801206:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801211:	8d 45 10             	lea    0x10(%ebp),%eax
  801214:	83 c0 04             	add    $0x4,%eax
  801217:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	ff 75 f4             	pushl  -0xc(%ebp)
  801220:	50                   	push   %eax
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	ff 75 08             	pushl  0x8(%ebp)
  801227:	e8 89 ff ff ff       	call   8011b5 <vsnprintf>
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80123d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801241:	74 13                	je     801256 <readline+0x1f>
		cprintf("%s", prompt);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 08             	pushl  0x8(%ebp)
  801249:	68 f0 41 80 00       	push   $0x8041f0
  80124e:	e8 62 f9 ff ff       	call   800bb5 <cprintf>
  801253:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80125d:	83 ec 0c             	sub    $0xc,%esp
  801260:	6a 00                	push   $0x0
  801262:	e8 54 f5 ff ff       	call   8007bb <iscons>
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80126d:	e8 fb f4 ff ff       	call   80076d <getchar>
  801272:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801275:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801279:	79 22                	jns    80129d <readline+0x66>
			if (c != -E_EOF)
  80127b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80127f:	0f 84 ad 00 00 00    	je     801332 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	68 f3 41 80 00       	push   $0x8041f3
  801290:	e8 20 f9 ff ff       	call   800bb5 <cprintf>
  801295:	83 c4 10             	add    $0x10,%esp
			return;
  801298:	e9 95 00 00 00       	jmp    801332 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80129d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012a1:	7e 34                	jle    8012d7 <readline+0xa0>
  8012a3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012aa:	7f 2b                	jg     8012d7 <readline+0xa0>
			if (echoing)
  8012ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b0:	74 0e                	je     8012c0 <readline+0x89>
				cputchar(c);
  8012b2:	83 ec 0c             	sub    $0xc,%esp
  8012b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b8:	e8 68 f4 ff ff       	call   800725 <cputchar>
  8012bd:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8012c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c3:	8d 50 01             	lea    0x1(%eax),%edx
  8012c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012c9:	89 c2                	mov    %eax,%edx
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d3:	88 10                	mov    %dl,(%eax)
  8012d5:	eb 56                	jmp    80132d <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012d7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012db:	75 1f                	jne    8012fc <readline+0xc5>
  8012dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012e1:	7e 19                	jle    8012fc <readline+0xc5>
			if (echoing)
  8012e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e7:	74 0e                	je     8012f7 <readline+0xc0>
				cputchar(c);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ef:	e8 31 f4 ff ff       	call   800725 <cputchar>
  8012f4:	83 c4 10             	add    $0x10,%esp

			i--;
  8012f7:	ff 4d f4             	decl   -0xc(%ebp)
  8012fa:	eb 31                	jmp    80132d <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012fc:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801300:	74 0a                	je     80130c <readline+0xd5>
  801302:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801306:	0f 85 61 ff ff ff    	jne    80126d <readline+0x36>
			if (echoing)
  80130c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801310:	74 0e                	je     801320 <readline+0xe9>
				cputchar(c);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	ff 75 ec             	pushl  -0x14(%ebp)
  801318:	e8 08 f4 ff ff       	call   800725 <cputchar>
  80131d:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 d0                	add    %edx,%eax
  801328:	c6 00 00             	movb   $0x0,(%eax)
			return;
  80132b:	eb 06                	jmp    801333 <readline+0xfc>
		}
	}
  80132d:	e9 3b ff ff ff       	jmp    80126d <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801332:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80133b:	e8 c2 0e 00 00       	call   802202 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801344:	74 13                	je     801359 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	68 f0 41 80 00       	push   $0x8041f0
  801351:	e8 5f f8 ff ff       	call   800bb5 <cprintf>
  801356:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801359:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	6a 00                	push   $0x0
  801365:	e8 51 f4 ff ff       	call   8007bb <iscons>
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801370:	e8 f8 f3 ff ff       	call   80076d <getchar>
  801375:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801378:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80137c:	79 23                	jns    8013a1 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80137e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801382:	74 13                	je     801397 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801384:	83 ec 08             	sub    $0x8,%esp
  801387:	ff 75 ec             	pushl  -0x14(%ebp)
  80138a:	68 f3 41 80 00       	push   $0x8041f3
  80138f:	e8 21 f8 ff ff       	call   800bb5 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801397:	e8 80 0e 00 00       	call   80221c <sys_enable_interrupt>
			return;
  80139c:	e9 9a 00 00 00       	jmp    80143b <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013a1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013a5:	7e 34                	jle    8013db <atomic_readline+0xa6>
  8013a7:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013ae:	7f 2b                	jg     8013db <atomic_readline+0xa6>
			if (echoing)
  8013b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b4:	74 0e                	je     8013c4 <atomic_readline+0x8f>
				cputchar(c);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8013bc:	e8 64 f3 ff ff       	call   800725 <cputchar>
  8013c1:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013cd:	89 c2                	mov    %eax,%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d7:	88 10                	mov    %dl,(%eax)
  8013d9:	eb 5b                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013db:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013df:	75 1f                	jne    801400 <atomic_readline+0xcb>
  8013e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013e5:	7e 19                	jle    801400 <atomic_readline+0xcb>
			if (echoing)
  8013e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013eb:	74 0e                	je     8013fb <atomic_readline+0xc6>
				cputchar(c);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f3:	e8 2d f3 ff ff       	call   800725 <cputchar>
  8013f8:	83 c4 10             	add    $0x10,%esp
			i--;
  8013fb:	ff 4d f4             	decl   -0xc(%ebp)
  8013fe:	eb 36                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801400:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801404:	74 0a                	je     801410 <atomic_readline+0xdb>
  801406:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80140a:	0f 85 60 ff ff ff    	jne    801370 <atomic_readline+0x3b>
			if (echoing)
  801410:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801414:	74 0e                	je     801424 <atomic_readline+0xef>
				cputchar(c);
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	ff 75 ec             	pushl  -0x14(%ebp)
  80141c:	e8 04 f3 ff ff       	call   800725 <cputchar>
  801421:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	01 d0                	add    %edx,%eax
  80142c:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  80142f:	e8 e8 0d 00 00       	call   80221c <sys_enable_interrupt>
			return;
  801434:	eb 05                	jmp    80143b <atomic_readline+0x106>
		}
	}
  801436:	e9 35 ff ff ff       	jmp    801370 <atomic_readline+0x3b>
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801443:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144a:	eb 06                	jmp    801452 <strlen+0x15>
		n++;
  80144c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80144f:	ff 45 08             	incl   0x8(%ebp)
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	84 c0                	test   %al,%al
  801459:	75 f1                	jne    80144c <strlen+0xf>
		n++;
	return n;
  80145b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801466:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80146d:	eb 09                	jmp    801478 <strnlen+0x18>
		n++;
  80146f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801472:	ff 45 08             	incl   0x8(%ebp)
  801475:	ff 4d 0c             	decl   0xc(%ebp)
  801478:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80147c:	74 09                	je     801487 <strnlen+0x27>
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	84 c0                	test   %al,%al
  801485:	75 e8                	jne    80146f <strnlen+0xf>
		n++;
	return n;
  801487:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801498:	90                   	nop
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8d 50 01             	lea    0x1(%eax),%edx
  80149f:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014ab:	8a 12                	mov    (%edx),%dl
  8014ad:	88 10                	mov    %dl,(%eax)
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	84 c0                	test   %al,%al
  8014b3:	75 e4                	jne    801499 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014cd:	eb 1f                	jmp    8014ee <strncpy+0x34>
		*dst++ = *src;
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	8a 12                	mov    (%edx),%dl
  8014dd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	84 c0                	test   %al,%al
  8014e6:	74 03                	je     8014eb <strncpy+0x31>
			src++;
  8014e8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014eb:	ff 45 fc             	incl   -0x4(%ebp)
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f4:	72 d9                	jb     8014cf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801507:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150b:	74 30                	je     80153d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80150d:	eb 16                	jmp    801525 <strlcpy+0x2a>
			*dst++ = *src++;
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8d 50 01             	lea    0x1(%eax),%edx
  801515:	89 55 08             	mov    %edx,0x8(%ebp)
  801518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801521:	8a 12                	mov    (%edx),%dl
  801523:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801525:	ff 4d 10             	decl   0x10(%ebp)
  801528:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152c:	74 09                	je     801537 <strlcpy+0x3c>
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	75 d8                	jne    80150f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80153d:	8b 55 08             	mov    0x8(%ebp),%edx
  801540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801543:	29 c2                	sub    %eax,%edx
  801545:	89 d0                	mov    %edx,%eax
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80154c:	eb 06                	jmp    801554 <strcmp+0xb>
		p++, q++;
  80154e:	ff 45 08             	incl   0x8(%ebp)
  801551:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	84 c0                	test   %al,%al
  80155b:	74 0e                	je     80156b <strcmp+0x22>
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 10                	mov    (%eax),%dl
  801562:	8b 45 0c             	mov    0xc(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	38 c2                	cmp    %al,%dl
  801569:	74 e3                	je     80154e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f b6 d0             	movzbl %al,%edx
  801573:	8b 45 0c             	mov    0xc(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	0f b6 c0             	movzbl %al,%eax
  80157b:	29 c2                	sub    %eax,%edx
  80157d:	89 d0                	mov    %edx,%eax
}
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    

00801581 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801584:	eb 09                	jmp    80158f <strncmp+0xe>
		n--, p++, q++;
  801586:	ff 4d 10             	decl   0x10(%ebp)
  801589:	ff 45 08             	incl   0x8(%ebp)
  80158c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80158f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801593:	74 17                	je     8015ac <strncmp+0x2b>
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8a 00                	mov    (%eax),%al
  80159a:	84 c0                	test   %al,%al
  80159c:	74 0e                	je     8015ac <strncmp+0x2b>
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	8a 10                	mov    (%eax),%dl
  8015a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a6:	8a 00                	mov    (%eax),%al
  8015a8:	38 c2                	cmp    %al,%dl
  8015aa:	74 da                	je     801586 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b0:	75 07                	jne    8015b9 <strncmp+0x38>
		return 0;
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b7:	eb 14                	jmp    8015cd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	0f b6 d0             	movzbl %al,%edx
  8015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c4:	8a 00                	mov    (%eax),%al
  8015c6:	0f b6 c0             	movzbl %al,%eax
  8015c9:	29 c2                	sub    %eax,%edx
  8015cb:	89 d0                	mov    %edx,%eax
}
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015db:	eb 12                	jmp    8015ef <strchr+0x20>
		if (*s == c)
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	8a 00                	mov    (%eax),%al
  8015e2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015e5:	75 05                	jne    8015ec <strchr+0x1d>
			return (char *) s;
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	eb 11                	jmp    8015fd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015ec:	ff 45 08             	incl   0x8(%ebp)
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	8a 00                	mov    (%eax),%al
  8015f4:	84 c0                	test   %al,%al
  8015f6:	75 e5                	jne    8015dd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80160b:	eb 0d                	jmp    80161a <strfind+0x1b>
		if (*s == c)
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801615:	74 0e                	je     801625 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	84 c0                	test   %al,%al
  801621:	75 ea                	jne    80160d <strfind+0xe>
  801623:	eb 01                	jmp    801626 <strfind+0x27>
		if (*s == c)
			break;
  801625:	90                   	nop
	return (char *) s;
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801637:	8b 45 10             	mov    0x10(%ebp),%eax
  80163a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80163d:	eb 0e                	jmp    80164d <memset+0x22>
		*p++ = c;
  80163f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801642:	8d 50 01             	lea    0x1(%eax),%edx
  801645:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80164d:	ff 4d f8             	decl   -0x8(%ebp)
  801650:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801654:	79 e9                	jns    80163f <memset+0x14>
		*p++ = c;

	return v;
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801661:	8b 45 0c             	mov    0xc(%ebp),%eax
  801664:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80166d:	eb 16                	jmp    801685 <memcpy+0x2a>
		*d++ = *s++;
  80166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801672:	8d 50 01             	lea    0x1(%eax),%edx
  801675:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801678:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801681:	8a 12                	mov    (%edx),%dl
  801683:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801685:	8b 45 10             	mov    0x10(%ebp),%eax
  801688:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168b:	89 55 10             	mov    %edx,0x10(%ebp)
  80168e:	85 c0                	test   %eax,%eax
  801690:	75 dd                	jne    80166f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80169d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016af:	73 50                	jae    801701 <memmove+0x6a>
  8016b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b7:	01 d0                	add    %edx,%eax
  8016b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016bc:	76 43                	jbe    801701 <memmove+0x6a>
		s += n;
  8016be:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016ca:	eb 10                	jmp    8016dc <memmove+0x45>
			*--d = *--s;
  8016cc:	ff 4d f8             	decl   -0x8(%ebp)
  8016cf:	ff 4d fc             	decl   -0x4(%ebp)
  8016d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d5:	8a 10                	mov    (%eax),%dl
  8016d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016da:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	75 e3                	jne    8016cc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016e9:	eb 23                	jmp    80170e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8d 50 01             	lea    0x1(%eax),%edx
  8016f1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016fa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016fd:	8a 12                	mov    (%edx),%dl
  8016ff:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	8d 50 ff             	lea    -0x1(%eax),%edx
  801707:	89 55 10             	mov    %edx,0x10(%ebp)
  80170a:	85 c0                	test   %eax,%eax
  80170c:	75 dd                	jne    8016eb <memmove+0x54>
			*d++ = *s++;

	return dst;
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80171f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801722:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801725:	eb 2a                	jmp    801751 <memcmp+0x3e>
		if (*s1 != *s2)
  801727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172a:	8a 10                	mov    (%eax),%dl
  80172c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	38 c2                	cmp    %al,%dl
  801733:	74 16                	je     80174b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801738:	8a 00                	mov    (%eax),%al
  80173a:	0f b6 d0             	movzbl %al,%edx
  80173d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	0f b6 c0             	movzbl %al,%eax
  801745:	29 c2                	sub    %eax,%edx
  801747:	89 d0                	mov    %edx,%eax
  801749:	eb 18                	jmp    801763 <memcmp+0x50>
		s1++, s2++;
  80174b:	ff 45 fc             	incl   -0x4(%ebp)
  80174e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801751:	8b 45 10             	mov    0x10(%ebp),%eax
  801754:	8d 50 ff             	lea    -0x1(%eax),%edx
  801757:	89 55 10             	mov    %edx,0x10(%ebp)
  80175a:	85 c0                	test   %eax,%eax
  80175c:	75 c9                	jne    801727 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80176b:	8b 55 08             	mov    0x8(%ebp),%edx
  80176e:	8b 45 10             	mov    0x10(%ebp),%eax
  801771:	01 d0                	add    %edx,%eax
  801773:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801776:	eb 15                	jmp    80178d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	0f b6 d0             	movzbl %al,%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	0f b6 c0             	movzbl %al,%eax
  801786:	39 c2                	cmp    %eax,%edx
  801788:	74 0d                	je     801797 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80178a:	ff 45 08             	incl   0x8(%ebp)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801793:	72 e3                	jb     801778 <memfind+0x13>
  801795:	eb 01                	jmp    801798 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801797:	90                   	nop
	return (void *) s;
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b1:	eb 03                	jmp    8017b6 <strtol+0x19>
		s++;
  8017b3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	3c 20                	cmp    $0x20,%al
  8017bd:	74 f4                	je     8017b3 <strtol+0x16>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	3c 09                	cmp    $0x9,%al
  8017c6:	74 eb                	je     8017b3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	3c 2b                	cmp    $0x2b,%al
  8017cf:	75 05                	jne    8017d6 <strtol+0x39>
		s++;
  8017d1:	ff 45 08             	incl   0x8(%ebp)
  8017d4:	eb 13                	jmp    8017e9 <strtol+0x4c>
	else if (*s == '-')
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	3c 2d                	cmp    $0x2d,%al
  8017dd:	75 0a                	jne    8017e9 <strtol+0x4c>
		s++, neg = 1;
  8017df:	ff 45 08             	incl   0x8(%ebp)
  8017e2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ed:	74 06                	je     8017f5 <strtol+0x58>
  8017ef:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017f3:	75 20                	jne    801815 <strtol+0x78>
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	3c 30                	cmp    $0x30,%al
  8017fc:	75 17                	jne    801815 <strtol+0x78>
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	40                   	inc    %eax
  801802:	8a 00                	mov    (%eax),%al
  801804:	3c 78                	cmp    $0x78,%al
  801806:	75 0d                	jne    801815 <strtol+0x78>
		s += 2, base = 16;
  801808:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80180c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801813:	eb 28                	jmp    80183d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801815:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801819:	75 15                	jne    801830 <strtol+0x93>
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	8a 00                	mov    (%eax),%al
  801820:	3c 30                	cmp    $0x30,%al
  801822:	75 0c                	jne    801830 <strtol+0x93>
		s++, base = 8;
  801824:	ff 45 08             	incl   0x8(%ebp)
  801827:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80182e:	eb 0d                	jmp    80183d <strtol+0xa0>
	else if (base == 0)
  801830:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801834:	75 07                	jne    80183d <strtol+0xa0>
		base = 10;
  801836:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	3c 2f                	cmp    $0x2f,%al
  801844:	7e 19                	jle    80185f <strtol+0xc2>
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	3c 39                	cmp    $0x39,%al
  80184d:	7f 10                	jg     80185f <strtol+0xc2>
			dig = *s - '0';
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	8a 00                	mov    (%eax),%al
  801854:	0f be c0             	movsbl %al,%eax
  801857:	83 e8 30             	sub    $0x30,%eax
  80185a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185d:	eb 42                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	3c 60                	cmp    $0x60,%al
  801866:	7e 19                	jle    801881 <strtol+0xe4>
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	3c 7a                	cmp    $0x7a,%al
  80186f:	7f 10                	jg     801881 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	8a 00                	mov    (%eax),%al
  801876:	0f be c0             	movsbl %al,%eax
  801879:	83 e8 57             	sub    $0x57,%eax
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80187f:	eb 20                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	3c 40                	cmp    $0x40,%al
  801888:	7e 39                	jle    8018c3 <strtol+0x126>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 00                	mov    (%eax),%al
  80188f:	3c 5a                	cmp    $0x5a,%al
  801891:	7f 30                	jg     8018c3 <strtol+0x126>
			dig = *s - 'A' + 10;
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	8a 00                	mov    (%eax),%al
  801898:	0f be c0             	movsbl %al,%eax
  80189b:	83 e8 37             	sub    $0x37,%eax
  80189e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018a7:	7d 19                	jge    8018c2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018a9:	ff 45 08             	incl   0x8(%ebp)
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018b3:	89 c2                	mov    %eax,%edx
  8018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b8:	01 d0                	add    %edx,%eax
  8018ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018bd:	e9 7b ff ff ff       	jmp    80183d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018c2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018c7:	74 08                	je     8018d1 <strtol+0x134>
		*endptr = (char *) s;
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d5:	74 07                	je     8018de <strtol+0x141>
  8018d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018da:	f7 d8                	neg    %eax
  8018dc:	eb 03                	jmp    8018e1 <strtol+0x144>
  8018de:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <ltostr>:

void
ltostr(long value, char *str)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018fb:	79 13                	jns    801910 <ltostr+0x2d>
	{
		neg = 1;
  8018fd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80190a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80190d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801918:	99                   	cltd   
  801919:	f7 f9                	idiv   %ecx
  80191b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80191e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801921:	8d 50 01             	lea    0x1(%eax),%edx
  801924:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801927:	89 c2                	mov    %eax,%edx
  801929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192c:	01 d0                	add    %edx,%eax
  80192e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801931:	83 c2 30             	add    $0x30,%edx
  801934:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801936:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801939:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80193e:	f7 e9                	imul   %ecx
  801940:	c1 fa 02             	sar    $0x2,%edx
  801943:	89 c8                	mov    %ecx,%eax
  801945:	c1 f8 1f             	sar    $0x1f,%eax
  801948:	29 c2                	sub    %eax,%edx
  80194a:	89 d0                	mov    %edx,%eax
  80194c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80194f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801952:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801957:	f7 e9                	imul   %ecx
  801959:	c1 fa 02             	sar    $0x2,%edx
  80195c:	89 c8                	mov    %ecx,%eax
  80195e:	c1 f8 1f             	sar    $0x1f,%eax
  801961:	29 c2                	sub    %eax,%edx
  801963:	89 d0                	mov    %edx,%eax
  801965:	c1 e0 02             	shl    $0x2,%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	01 c0                	add    %eax,%eax
  80196c:	29 c1                	sub    %eax,%ecx
  80196e:	89 ca                	mov    %ecx,%edx
  801970:	85 d2                	test   %edx,%edx
  801972:	75 9c                	jne    801910 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801974:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	48                   	dec    %eax
  80197f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801982:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801986:	74 3d                	je     8019c5 <ltostr+0xe2>
		start = 1 ;
  801988:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80198f:	eb 34                	jmp    8019c5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801994:	8b 45 0c             	mov    0xc(%ebp),%eax
  801997:	01 d0                	add    %edx,%eax
  801999:	8a 00                	mov    (%eax),%al
  80199b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80199e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	01 c2                	add    %eax,%edx
  8019a6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ac:	01 c8                	add    %ecx,%eax
  8019ae:	8a 00                	mov    (%eax),%al
  8019b0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b8:	01 c2                	add    %eax,%edx
  8019ba:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019bd:	88 02                	mov    %al,(%edx)
		start++ ;
  8019bf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019c2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019cb:	7c c4                	jl     801991 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d3:	01 d0                	add    %edx,%eax
  8019d5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	e8 54 fa ff ff       	call   80143d <strlen>
  8019e9:	83 c4 04             	add    $0x4,%esp
  8019ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	e8 46 fa ff ff       	call   80143d <strlen>
  8019f7:	83 c4 04             	add    $0x4,%esp
  8019fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a0b:	eb 17                	jmp    801a24 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a10:	8b 45 10             	mov    0x10(%ebp),%eax
  801a13:	01 c2                	add    %eax,%edx
  801a15:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	01 c8                	add    %ecx,%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a21:	ff 45 fc             	incl   -0x4(%ebp)
  801a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a2a:	7c e1                	jl     801a0d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a2c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a3a:	eb 1f                	jmp    801a5b <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a3f:	8d 50 01             	lea    0x1(%eax),%edx
  801a42:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a45:	89 c2                	mov    %eax,%edx
  801a47:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4a:	01 c2                	add    %eax,%edx
  801a4c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a52:	01 c8                	add    %ecx,%eax
  801a54:	8a 00                	mov    (%eax),%al
  801a56:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a58:	ff 45 f8             	incl   -0x8(%ebp)
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a61:	7c d9                	jl     801a3c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a66:	8b 45 10             	mov    0x10(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	c6 00 00             	movb   $0x0,(%eax)
}
  801a6e:	90                   	nop
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a74:	8b 45 14             	mov    0x14(%ebp),%eax
  801a77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a80:	8b 00                	mov    (%eax),%eax
  801a82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a94:	eb 0c                	jmp    801aa2 <strsplit+0x31>
			*string++ = 0;
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	8d 50 01             	lea    0x1(%eax),%edx
  801a9c:	89 55 08             	mov    %edx,0x8(%ebp)
  801a9f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	84 c0                	test   %al,%al
  801aa9:	74 18                	je     801ac3 <strsplit+0x52>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	0f be c0             	movsbl %al,%eax
  801ab3:	50                   	push   %eax
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	e8 13 fb ff ff       	call   8015cf <strchr>
  801abc:	83 c4 08             	add    $0x8,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	75 d3                	jne    801a96 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	8a 00                	mov    (%eax),%al
  801ac8:	84 c0                	test   %al,%al
  801aca:	74 5a                	je     801b26 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801acc:	8b 45 14             	mov    0x14(%ebp),%eax
  801acf:	8b 00                	mov    (%eax),%eax
  801ad1:	83 f8 0f             	cmp    $0xf,%eax
  801ad4:	75 07                	jne    801add <strsplit+0x6c>
		{
			return 0;
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  801adb:	eb 66                	jmp    801b43 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801add:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae0:	8b 00                	mov    (%eax),%eax
  801ae2:	8d 48 01             	lea    0x1(%eax),%ecx
  801ae5:	8b 55 14             	mov    0x14(%ebp),%edx
  801ae8:	89 0a                	mov    %ecx,(%edx)
  801aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	01 c2                	add    %eax,%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801afb:	eb 03                	jmp    801b00 <strsplit+0x8f>
			string++;
  801afd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	8a 00                	mov    (%eax),%al
  801b05:	84 c0                	test   %al,%al
  801b07:	74 8b                	je     801a94 <strsplit+0x23>
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	8a 00                	mov    (%eax),%al
  801b0e:	0f be c0             	movsbl %al,%eax
  801b11:	50                   	push   %eax
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	e8 b5 fa ff ff       	call   8015cf <strchr>
  801b1a:	83 c4 08             	add    $0x8,%esp
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	74 dc                	je     801afd <strsplit+0x8c>
			string++;
	}
  801b21:	e9 6e ff ff ff       	jmp    801a94 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b26:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b27:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2a:	8b 00                	mov    (%eax),%eax
  801b2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b33:	8b 45 10             	mov    0x10(%ebp),%eax
  801b36:	01 d0                	add    %edx,%eax
  801b38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b3e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b4b:	a1 04 50 80 00       	mov    0x805004,%eax
  801b50:	85 c0                	test   %eax,%eax
  801b52:	74 1f                	je     801b73 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b54:	e8 1d 00 00 00       	call   801b76 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	68 04 42 80 00       	push   $0x804204
  801b61:	e8 4f f0 ff ff       	call   800bb5 <cprintf>
  801b66:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b69:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b70:	00 00 00 
	}
}
  801b73:	90                   	nop
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801b7c:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b83:	00 00 00 
  801b86:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b8d:	00 00 00 
  801b90:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b97:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801b9a:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801ba1:	00 00 00 
  801ba4:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801bab:	00 00 00 
  801bae:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801bb5:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801bb8:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801bbf:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801bc2:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bcc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd1:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bd6:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801bdb:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801be2:	a1 20 51 80 00       	mov    0x805120,%eax
  801be7:	c1 e0 04             	shl    $0x4,%eax
  801bea:	89 c2                	mov    %eax,%edx
  801bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bef:	01 d0                	add    %edx,%eax
  801bf1:	48                   	dec    %eax
  801bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bf8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bfd:	f7 75 f0             	divl   -0x10(%ebp)
  801c00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c03:	29 d0                	sub    %edx,%eax
  801c05:	89 c2                	mov    %eax,%edx
  801c07:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801c0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c16:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c1b:	83 ec 04             	sub    $0x4,%esp
  801c1e:	6a 06                	push   $0x6
  801c20:	52                   	push   %edx
  801c21:	50                   	push   %eax
  801c22:	e8 71 05 00 00       	call   802198 <sys_allocate_chunk>
  801c27:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c2a:	a1 20 51 80 00       	mov    0x805120,%eax
  801c2f:	83 ec 0c             	sub    $0xc,%esp
  801c32:	50                   	push   %eax
  801c33:	e8 e6 0b 00 00       	call   80281e <initialize_MemBlocksList>
  801c38:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801c3b:	a1 48 51 80 00       	mov    0x805148,%eax
  801c40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801c43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c47:	75 14                	jne    801c5d <initialize_dyn_block_system+0xe7>
  801c49:	83 ec 04             	sub    $0x4,%esp
  801c4c:	68 29 42 80 00       	push   $0x804229
  801c51:	6a 2b                	push   $0x2b
  801c53:	68 47 42 80 00       	push   $0x804247
  801c58:	e8 a4 ec ff ff       	call   800901 <_panic>
  801c5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c60:	8b 00                	mov    (%eax),%eax
  801c62:	85 c0                	test   %eax,%eax
  801c64:	74 10                	je     801c76 <initialize_dyn_block_system+0x100>
  801c66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c69:	8b 00                	mov    (%eax),%eax
  801c6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c6e:	8b 52 04             	mov    0x4(%edx),%edx
  801c71:	89 50 04             	mov    %edx,0x4(%eax)
  801c74:	eb 0b                	jmp    801c81 <initialize_dyn_block_system+0x10b>
  801c76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c79:	8b 40 04             	mov    0x4(%eax),%eax
  801c7c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c84:	8b 40 04             	mov    0x4(%eax),%eax
  801c87:	85 c0                	test   %eax,%eax
  801c89:	74 0f                	je     801c9a <initialize_dyn_block_system+0x124>
  801c8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c8e:	8b 40 04             	mov    0x4(%eax),%eax
  801c91:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c94:	8b 12                	mov    (%edx),%edx
  801c96:	89 10                	mov    %edx,(%eax)
  801c98:	eb 0a                	jmp    801ca4 <initialize_dyn_block_system+0x12e>
  801c9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c9d:	8b 00                	mov    (%eax),%eax
  801c9f:	a3 48 51 80 00       	mov    %eax,0x805148
  801ca4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ca7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cb7:	a1 54 51 80 00       	mov    0x805154,%eax
  801cbc:	48                   	dec    %eax
  801cbd:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cc5:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801ccc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ccf:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801cd6:	83 ec 0c             	sub    $0xc,%esp
  801cd9:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cdc:	e8 d2 13 00 00       	call   8030b3 <insert_sorted_with_merge_freeList>
  801ce1:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801ce4:	90                   	nop
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ced:	e8 53 fe ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cf6:	75 07                	jne    801cff <malloc+0x18>
  801cf8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cfd:	eb 61                	jmp    801d60 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801cff:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d06:	8b 55 08             	mov    0x8(%ebp),%edx
  801d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0c:	01 d0                	add    %edx,%eax
  801d0e:	48                   	dec    %eax
  801d0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d15:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1a:	f7 75 f4             	divl   -0xc(%ebp)
  801d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d20:	29 d0                	sub    %edx,%eax
  801d22:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d25:	e8 3c 08 00 00       	call   802566 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	74 2d                	je     801d5b <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801d2e:	83 ec 0c             	sub    $0xc,%esp
  801d31:	ff 75 08             	pushl  0x8(%ebp)
  801d34:	e8 3e 0f 00 00       	call   802c77 <alloc_block_FF>
  801d39:	83 c4 10             	add    $0x10,%esp
  801d3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801d3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d43:	74 16                	je     801d5b <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801d45:	83 ec 0c             	sub    $0xc,%esp
  801d48:	ff 75 ec             	pushl  -0x14(%ebp)
  801d4b:	e8 48 0c 00 00       	call   802998 <insert_sorted_allocList>
  801d50:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801d53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d56:	8b 40 08             	mov    0x8(%eax),%eax
  801d59:	eb 05                	jmp    801d60 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801d5b:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801d68:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d71:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d76:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801d79:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7c:	83 ec 08             	sub    $0x8,%esp
  801d7f:	50                   	push   %eax
  801d80:	68 40 50 80 00       	push   $0x805040
  801d85:	e8 71 0b 00 00       	call   8028fb <find_block>
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d93:	8b 50 0c             	mov    0xc(%eax),%edx
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	83 ec 08             	sub    $0x8,%esp
  801d9c:	52                   	push   %edx
  801d9d:	50                   	push   %eax
  801d9e:	e8 bd 03 00 00       	call   802160 <sys_free_user_mem>
  801da3:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801da6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801daa:	75 14                	jne    801dc0 <free+0x5e>
  801dac:	83 ec 04             	sub    $0x4,%esp
  801daf:	68 29 42 80 00       	push   $0x804229
  801db4:	6a 71                	push   $0x71
  801db6:	68 47 42 80 00       	push   $0x804247
  801dbb:	e8 41 eb ff ff       	call   800901 <_panic>
  801dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc3:	8b 00                	mov    (%eax),%eax
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	74 10                	je     801dd9 <free+0x77>
  801dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dcc:	8b 00                	mov    (%eax),%eax
  801dce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dd1:	8b 52 04             	mov    0x4(%edx),%edx
  801dd4:	89 50 04             	mov    %edx,0x4(%eax)
  801dd7:	eb 0b                	jmp    801de4 <free+0x82>
  801dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ddc:	8b 40 04             	mov    0x4(%eax),%eax
  801ddf:	a3 44 50 80 00       	mov    %eax,0x805044
  801de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de7:	8b 40 04             	mov    0x4(%eax),%eax
  801dea:	85 c0                	test   %eax,%eax
  801dec:	74 0f                	je     801dfd <free+0x9b>
  801dee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df1:	8b 40 04             	mov    0x4(%eax),%eax
  801df4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801df7:	8b 12                	mov    (%edx),%edx
  801df9:	89 10                	mov    %edx,(%eax)
  801dfb:	eb 0a                	jmp    801e07 <free+0xa5>
  801dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e00:	8b 00                	mov    (%eax),%eax
  801e02:	a3 40 50 80 00       	mov    %eax,0x805040
  801e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e0a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e1a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e1f:	48                   	dec    %eax
  801e20:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801e25:	83 ec 0c             	sub    $0xc,%esp
  801e28:	ff 75 f0             	pushl  -0x10(%ebp)
  801e2b:	e8 83 12 00 00       	call   8030b3 <insert_sorted_with_merge_freeList>
  801e30:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801e33:	90                   	nop
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 28             	sub    $0x28,%esp
  801e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3f:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e42:	e8 fe fc ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e4b:	75 0a                	jne    801e57 <smalloc+0x21>
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e52:	e9 86 00 00 00       	jmp    801edd <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801e57:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e64:	01 d0                	add    %edx,%eax
  801e66:	48                   	dec    %eax
  801e67:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e72:	f7 75 f4             	divl   -0xc(%ebp)
  801e75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e78:	29 d0                	sub    %edx,%eax
  801e7a:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e7d:	e8 e4 06 00 00       	call   802566 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e82:	85 c0                	test   %eax,%eax
  801e84:	74 52                	je     801ed8 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801e86:	83 ec 0c             	sub    $0xc,%esp
  801e89:	ff 75 0c             	pushl  0xc(%ebp)
  801e8c:	e8 e6 0d 00 00       	call   802c77 <alloc_block_FF>
  801e91:	83 c4 10             	add    $0x10,%esp
  801e94:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801e97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e9b:	75 07                	jne    801ea4 <smalloc+0x6e>
			return NULL ;
  801e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea2:	eb 39                	jmp    801edd <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801ea4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea7:	8b 40 08             	mov    0x8(%eax),%eax
  801eaa:	89 c2                	mov    %eax,%edx
  801eac:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801eb0:	52                   	push   %edx
  801eb1:	50                   	push   %eax
  801eb2:	ff 75 0c             	pushl  0xc(%ebp)
  801eb5:	ff 75 08             	pushl  0x8(%ebp)
  801eb8:	e8 2e 04 00 00       	call   8022eb <sys_createSharedObject>
  801ebd:	83 c4 10             	add    $0x10,%esp
  801ec0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801ec3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ec7:	79 07                	jns    801ed0 <smalloc+0x9a>
			return (void*)NULL ;
  801ec9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ece:	eb 0d                	jmp    801edd <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801ed0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ed3:	8b 40 08             	mov    0x8(%eax),%eax
  801ed6:	eb 05                	jmp    801edd <smalloc+0xa7>
		}
		return (void*)NULL ;
  801ed8:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ee5:	e8 5b fc ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801eea:	83 ec 08             	sub    $0x8,%esp
  801eed:	ff 75 0c             	pushl  0xc(%ebp)
  801ef0:	ff 75 08             	pushl  0x8(%ebp)
  801ef3:	e8 1d 04 00 00       	call   802315 <sys_getSizeOfSharedObject>
  801ef8:	83 c4 10             	add    $0x10,%esp
  801efb:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801efe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f02:	75 0a                	jne    801f0e <sget+0x2f>
			return NULL ;
  801f04:	b8 00 00 00 00       	mov    $0x0,%eax
  801f09:	e9 83 00 00 00       	jmp    801f91 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801f0e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1b:	01 d0                	add    %edx,%eax
  801f1d:	48                   	dec    %eax
  801f1e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f24:	ba 00 00 00 00       	mov    $0x0,%edx
  801f29:	f7 75 f0             	divl   -0x10(%ebp)
  801f2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2f:	29 d0                	sub    %edx,%eax
  801f31:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f34:	e8 2d 06 00 00       	call   802566 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f39:	85 c0                	test   %eax,%eax
  801f3b:	74 4f                	je     801f8c <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f40:	83 ec 0c             	sub    $0xc,%esp
  801f43:	50                   	push   %eax
  801f44:	e8 2e 0d 00 00       	call   802c77 <alloc_block_FF>
  801f49:	83 c4 10             	add    $0x10,%esp
  801f4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801f4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f53:	75 07                	jne    801f5c <sget+0x7d>
					return (void*)NULL ;
  801f55:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5a:	eb 35                	jmp    801f91 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801f5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f5f:	8b 40 08             	mov    0x8(%eax),%eax
  801f62:	83 ec 04             	sub    $0x4,%esp
  801f65:	50                   	push   %eax
  801f66:	ff 75 0c             	pushl  0xc(%ebp)
  801f69:	ff 75 08             	pushl  0x8(%ebp)
  801f6c:	e8 c1 03 00 00       	call   802332 <sys_getSharedObject>
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801f77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f7b:	79 07                	jns    801f84 <sget+0xa5>
				return (void*)NULL ;
  801f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f82:	eb 0d                	jmp    801f91 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801f84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f87:	8b 40 08             	mov    0x8(%eax),%eax
  801f8a:	eb 05                	jmp    801f91 <sget+0xb2>


		}
	return (void*)NULL ;
  801f8c:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
  801f96:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f99:	e8 a7 fb ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f9e:	83 ec 04             	sub    $0x4,%esp
  801fa1:	68 54 42 80 00       	push   $0x804254
  801fa6:	68 f9 00 00 00       	push   $0xf9
  801fab:	68 47 42 80 00       	push   $0x804247
  801fb0:	e8 4c e9 ff ff       	call   800901 <_panic>

00801fb5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	68 7c 42 80 00       	push   $0x80427c
  801fc3:	68 0d 01 00 00       	push   $0x10d
  801fc8:	68 47 42 80 00       	push   $0x804247
  801fcd:	e8 2f e9 ff ff       	call   800901 <_panic>

00801fd2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fd8:	83 ec 04             	sub    $0x4,%esp
  801fdb:	68 a0 42 80 00       	push   $0x8042a0
  801fe0:	68 18 01 00 00       	push   $0x118
  801fe5:	68 47 42 80 00       	push   $0x804247
  801fea:	e8 12 e9 ff ff       	call   800901 <_panic>

00801fef <shrink>:

}
void shrink(uint32 newSize)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
  801ff2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ff5:	83 ec 04             	sub    $0x4,%esp
  801ff8:	68 a0 42 80 00       	push   $0x8042a0
  801ffd:	68 1d 01 00 00       	push   $0x11d
  802002:	68 47 42 80 00       	push   $0x804247
  802007:	e8 f5 e8 ff ff       	call   800901 <_panic>

0080200c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802012:	83 ec 04             	sub    $0x4,%esp
  802015:	68 a0 42 80 00       	push   $0x8042a0
  80201a:	68 22 01 00 00       	push   $0x122
  80201f:	68 47 42 80 00       	push   $0x804247
  802024:	e8 d8 e8 ff ff       	call   800901 <_panic>

00802029 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	57                   	push   %edi
  80202d:	56                   	push   %esi
  80202e:	53                   	push   %ebx
  80202f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802032:	8b 45 08             	mov    0x8(%ebp),%eax
  802035:	8b 55 0c             	mov    0xc(%ebp),%edx
  802038:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80203b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80203e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802041:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802044:	cd 30                	int    $0x30
  802046:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802049:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80204c:	83 c4 10             	add    $0x10,%esp
  80204f:	5b                   	pop    %ebx
  802050:	5e                   	pop    %esi
  802051:	5f                   	pop    %edi
  802052:	5d                   	pop    %ebp
  802053:	c3                   	ret    

00802054 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	8b 45 10             	mov    0x10(%ebp),%eax
  80205d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802060:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802064:	8b 45 08             	mov    0x8(%ebp),%eax
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	52                   	push   %edx
  80206c:	ff 75 0c             	pushl  0xc(%ebp)
  80206f:	50                   	push   %eax
  802070:	6a 00                	push   $0x0
  802072:	e8 b2 ff ff ff       	call   802029 <syscall>
  802077:	83 c4 18             	add    $0x18,%esp
}
  80207a:	90                   	nop
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <sys_cgetc>:

int
sys_cgetc(void)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 01                	push   $0x1
  80208c:	e8 98 ff ff ff       	call   802029 <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802099:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	6a 00                	push   $0x0
  8020a1:	6a 00                	push   $0x0
  8020a3:	6a 00                	push   $0x0
  8020a5:	52                   	push   %edx
  8020a6:	50                   	push   %eax
  8020a7:	6a 05                	push   $0x5
  8020a9:	e8 7b ff ff ff       	call   802029 <syscall>
  8020ae:	83 c4 18             	add    $0x18,%esp
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8020b8:	8b 75 18             	mov    0x18(%ebp),%esi
  8020bb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020be:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c7:	56                   	push   %esi
  8020c8:	53                   	push   %ebx
  8020c9:	51                   	push   %ecx
  8020ca:	52                   	push   %edx
  8020cb:	50                   	push   %eax
  8020cc:	6a 06                	push   $0x6
  8020ce:	e8 56 ff ff ff       	call   802029 <syscall>
  8020d3:	83 c4 18             	add    $0x18,%esp
}
  8020d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020d9:	5b                   	pop    %ebx
  8020da:	5e                   	pop    %esi
  8020db:	5d                   	pop    %ebp
  8020dc:	c3                   	ret    

008020dd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	52                   	push   %edx
  8020ed:	50                   	push   %eax
  8020ee:	6a 07                	push   $0x7
  8020f0:	e8 34 ff ff ff       	call   802029 <syscall>
  8020f5:	83 c4 18             	add    $0x18,%esp
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	ff 75 0c             	pushl  0xc(%ebp)
  802106:	ff 75 08             	pushl  0x8(%ebp)
  802109:	6a 08                	push   $0x8
  80210b:	e8 19 ff ff ff       	call   802029 <syscall>
  802110:	83 c4 18             	add    $0x18,%esp
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 09                	push   $0x9
  802124:	e8 00 ff ff ff       	call   802029 <syscall>
  802129:	83 c4 18             	add    $0x18,%esp
}
  80212c:	c9                   	leave  
  80212d:	c3                   	ret    

0080212e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	6a 0a                	push   $0xa
  80213d:	e8 e7 fe ff ff       	call   802029 <syscall>
  802142:	83 c4 18             	add    $0x18,%esp
}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 0b                	push   $0xb
  802156:	e8 ce fe ff ff       	call   802029 <syscall>
  80215b:	83 c4 18             	add    $0x18,%esp
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	ff 75 0c             	pushl  0xc(%ebp)
  80216c:	ff 75 08             	pushl  0x8(%ebp)
  80216f:	6a 0f                	push   $0xf
  802171:	e8 b3 fe ff ff       	call   802029 <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
	return;
  802179:	90                   	nop
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80217f:	6a 00                	push   $0x0
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	ff 75 0c             	pushl  0xc(%ebp)
  802188:	ff 75 08             	pushl  0x8(%ebp)
  80218b:	6a 10                	push   $0x10
  80218d:	e8 97 fe ff ff       	call   802029 <syscall>
  802192:	83 c4 18             	add    $0x18,%esp
	return ;
  802195:	90                   	nop
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	ff 75 10             	pushl  0x10(%ebp)
  8021a2:	ff 75 0c             	pushl  0xc(%ebp)
  8021a5:	ff 75 08             	pushl  0x8(%ebp)
  8021a8:	6a 11                	push   $0x11
  8021aa:	e8 7a fe ff ff       	call   802029 <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
	return ;
  8021b2:	90                   	nop
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 0c                	push   $0xc
  8021c4:	e8 60 fe ff ff       	call   802029 <syscall>
  8021c9:	83 c4 18             	add    $0x18,%esp
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	ff 75 08             	pushl  0x8(%ebp)
  8021dc:	6a 0d                	push   $0xd
  8021de:	e8 46 fe ff ff       	call   802029 <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 0e                	push   $0xe
  8021f7:	e8 2d fe ff ff       	call   802029 <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
}
  8021ff:	90                   	nop
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 13                	push   $0x13
  802211:	e8 13 fe ff ff       	call   802029 <syscall>
  802216:	83 c4 18             	add    $0x18,%esp
}
  802219:	90                   	nop
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80221f:	6a 00                	push   $0x0
  802221:	6a 00                	push   $0x0
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	6a 14                	push   $0x14
  80222b:	e8 f9 fd ff ff       	call   802029 <syscall>
  802230:	83 c4 18             	add    $0x18,%esp
}
  802233:	90                   	nop
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <sys_cputc>:


void
sys_cputc(const char c)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	83 ec 04             	sub    $0x4,%esp
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802242:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	50                   	push   %eax
  80224f:	6a 15                	push   $0x15
  802251:	e8 d3 fd ff ff       	call   802029 <syscall>
  802256:	83 c4 18             	add    $0x18,%esp
}
  802259:	90                   	nop
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	6a 16                	push   $0x16
  80226b:	e8 b9 fd ff ff       	call   802029 <syscall>
  802270:	83 c4 18             	add    $0x18,%esp
}
  802273:	90                   	nop
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	ff 75 0c             	pushl  0xc(%ebp)
  802285:	50                   	push   %eax
  802286:	6a 17                	push   $0x17
  802288:	e8 9c fd ff ff       	call   802029 <syscall>
  80228d:	83 c4 18             	add    $0x18,%esp
}
  802290:	c9                   	leave  
  802291:	c3                   	ret    

00802292 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802292:	55                   	push   %ebp
  802293:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802295:	8b 55 0c             	mov    0xc(%ebp),%edx
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	52                   	push   %edx
  8022a2:	50                   	push   %eax
  8022a3:	6a 1a                	push   $0x1a
  8022a5:	e8 7f fd ff ff       	call   802029 <syscall>
  8022aa:	83 c4 18             	add    $0x18,%esp
}
  8022ad:	c9                   	leave  
  8022ae:	c3                   	ret    

008022af <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022af:	55                   	push   %ebp
  8022b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	52                   	push   %edx
  8022bf:	50                   	push   %eax
  8022c0:	6a 18                	push   $0x18
  8022c2:	e8 62 fd ff ff       	call   802029 <syscall>
  8022c7:	83 c4 18             	add    $0x18,%esp
}
  8022ca:	90                   	nop
  8022cb:	c9                   	leave  
  8022cc:	c3                   	ret    

008022cd <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022cd:	55                   	push   %ebp
  8022ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	52                   	push   %edx
  8022dd:	50                   	push   %eax
  8022de:	6a 19                	push   $0x19
  8022e0:	e8 44 fd ff ff       	call   802029 <syscall>
  8022e5:	83 c4 18             	add    $0x18,%esp
}
  8022e8:	90                   	nop
  8022e9:	c9                   	leave  
  8022ea:	c3                   	ret    

008022eb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
  8022ee:	83 ec 04             	sub    $0x4,%esp
  8022f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8022f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022f7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022fa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	6a 00                	push   $0x0
  802303:	51                   	push   %ecx
  802304:	52                   	push   %edx
  802305:	ff 75 0c             	pushl  0xc(%ebp)
  802308:	50                   	push   %eax
  802309:	6a 1b                	push   $0x1b
  80230b:	e8 19 fd ff ff       	call   802029 <syscall>
  802310:	83 c4 18             	add    $0x18,%esp
}
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802318:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	52                   	push   %edx
  802325:	50                   	push   %eax
  802326:	6a 1c                	push   $0x1c
  802328:	e8 fc fc ff ff       	call   802029 <syscall>
  80232d:	83 c4 18             	add    $0x18,%esp
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802335:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802338:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	51                   	push   %ecx
  802343:	52                   	push   %edx
  802344:	50                   	push   %eax
  802345:	6a 1d                	push   $0x1d
  802347:	e8 dd fc ff ff       	call   802029 <syscall>
  80234c:	83 c4 18             	add    $0x18,%esp
}
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802354:	8b 55 0c             	mov    0xc(%ebp),%edx
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	52                   	push   %edx
  802361:	50                   	push   %eax
  802362:	6a 1e                	push   $0x1e
  802364:	e8 c0 fc ff ff       	call   802029 <syscall>
  802369:	83 c4 18             	add    $0x18,%esp
}
  80236c:	c9                   	leave  
  80236d:	c3                   	ret    

0080236e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 1f                	push   $0x1f
  80237d:	e8 a7 fc ff ff       	call   802029 <syscall>
  802382:	83 c4 18             	add    $0x18,%esp
}
  802385:	c9                   	leave  
  802386:	c3                   	ret    

00802387 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802387:	55                   	push   %ebp
  802388:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	6a 00                	push   $0x0
  80238f:	ff 75 14             	pushl  0x14(%ebp)
  802392:	ff 75 10             	pushl  0x10(%ebp)
  802395:	ff 75 0c             	pushl  0xc(%ebp)
  802398:	50                   	push   %eax
  802399:	6a 20                	push   $0x20
  80239b:	e8 89 fc ff ff       	call   802029 <syscall>
  8023a0:	83 c4 18             	add    $0x18,%esp
}
  8023a3:	c9                   	leave  
  8023a4:	c3                   	ret    

008023a5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8023a5:	55                   	push   %ebp
  8023a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	50                   	push   %eax
  8023b4:	6a 21                	push   $0x21
  8023b6:	e8 6e fc ff ff       	call   802029 <syscall>
  8023bb:	83 c4 18             	add    $0x18,%esp
}
  8023be:	90                   	nop
  8023bf:	c9                   	leave  
  8023c0:	c3                   	ret    

008023c1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8023c1:	55                   	push   %ebp
  8023c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	6a 00                	push   $0x0
  8023cf:	50                   	push   %eax
  8023d0:	6a 22                	push   $0x22
  8023d2:	e8 52 fc ff ff       	call   802029 <syscall>
  8023d7:	83 c4 18             	add    $0x18,%esp
}
  8023da:	c9                   	leave  
  8023db:	c3                   	ret    

008023dc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023dc:	55                   	push   %ebp
  8023dd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 02                	push   $0x2
  8023eb:	e8 39 fc ff ff       	call   802029 <syscall>
  8023f0:	83 c4 18             	add    $0x18,%esp
}
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 00                	push   $0x0
  8023fc:	6a 00                	push   $0x0
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	6a 03                	push   $0x3
  802404:	e8 20 fc ff ff       	call   802029 <syscall>
  802409:	83 c4 18             	add    $0x18,%esp
}
  80240c:	c9                   	leave  
  80240d:	c3                   	ret    

0080240e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80240e:	55                   	push   %ebp
  80240f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 04                	push   $0x4
  80241d:	e8 07 fc ff ff       	call   802029 <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_exit_env>:


void sys_exit_env(void)
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 23                	push   $0x23
  802436:	e8 ee fb ff ff       	call   802029 <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
}
  80243e:	90                   	nop
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802447:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80244a:	8d 50 04             	lea    0x4(%eax),%edx
  80244d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	52                   	push   %edx
  802457:	50                   	push   %eax
  802458:	6a 24                	push   $0x24
  80245a:	e8 ca fb ff ff       	call   802029 <syscall>
  80245f:	83 c4 18             	add    $0x18,%esp
	return result;
  802462:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802465:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802468:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80246b:	89 01                	mov    %eax,(%ecx)
  80246d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	c9                   	leave  
  802474:	c2 04 00             	ret    $0x4

00802477 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802477:	55                   	push   %ebp
  802478:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	ff 75 10             	pushl  0x10(%ebp)
  802481:	ff 75 0c             	pushl  0xc(%ebp)
  802484:	ff 75 08             	pushl  0x8(%ebp)
  802487:	6a 12                	push   $0x12
  802489:	e8 9b fb ff ff       	call   802029 <syscall>
  80248e:	83 c4 18             	add    $0x18,%esp
	return ;
  802491:	90                   	nop
}
  802492:	c9                   	leave  
  802493:	c3                   	ret    

00802494 <sys_rcr2>:
uint32 sys_rcr2()
{
  802494:	55                   	push   %ebp
  802495:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 25                	push   $0x25
  8024a3:	e8 81 fb ff ff       	call   802029 <syscall>
  8024a8:	83 c4 18             	add    $0x18,%esp
}
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8024b9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	6a 00                	push   $0x0
  8024c3:	6a 00                	push   $0x0
  8024c5:	50                   	push   %eax
  8024c6:	6a 26                	push   $0x26
  8024c8:	e8 5c fb ff ff       	call   802029 <syscall>
  8024cd:	83 c4 18             	add    $0x18,%esp
	return ;
  8024d0:	90                   	nop
}
  8024d1:	c9                   	leave  
  8024d2:	c3                   	ret    

008024d3 <rsttst>:
void rsttst()
{
  8024d3:	55                   	push   %ebp
  8024d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 28                	push   $0x28
  8024e2:	e8 42 fb ff ff       	call   802029 <syscall>
  8024e7:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ea:	90                   	nop
}
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	83 ec 04             	sub    $0x4,%esp
  8024f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8024f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024f9:	8b 55 18             	mov    0x18(%ebp),%edx
  8024fc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802500:	52                   	push   %edx
  802501:	50                   	push   %eax
  802502:	ff 75 10             	pushl  0x10(%ebp)
  802505:	ff 75 0c             	pushl  0xc(%ebp)
  802508:	ff 75 08             	pushl  0x8(%ebp)
  80250b:	6a 27                	push   $0x27
  80250d:	e8 17 fb ff ff       	call   802029 <syscall>
  802512:	83 c4 18             	add    $0x18,%esp
	return ;
  802515:	90                   	nop
}
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <chktst>:
void chktst(uint32 n)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	6a 00                	push   $0x0
  802523:	ff 75 08             	pushl  0x8(%ebp)
  802526:	6a 29                	push   $0x29
  802528:	e8 fc fa ff ff       	call   802029 <syscall>
  80252d:	83 c4 18             	add    $0x18,%esp
	return ;
  802530:	90                   	nop
}
  802531:	c9                   	leave  
  802532:	c3                   	ret    

00802533 <inctst>:

void inctst()
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	6a 2a                	push   $0x2a
  802542:	e8 e2 fa ff ff       	call   802029 <syscall>
  802547:	83 c4 18             	add    $0x18,%esp
	return ;
  80254a:	90                   	nop
}
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    

0080254d <gettst>:
uint32 gettst()
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 2b                	push   $0x2b
  80255c:	e8 c8 fa ff ff       	call   802029 <syscall>
  802561:	83 c4 18             	add    $0x18,%esp
}
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
  802569:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 2c                	push   $0x2c
  802578:	e8 ac fa ff ff       	call   802029 <syscall>
  80257d:	83 c4 18             	add    $0x18,%esp
  802580:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802583:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802587:	75 07                	jne    802590 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802589:	b8 01 00 00 00       	mov    $0x1,%eax
  80258e:	eb 05                	jmp    802595 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802590:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
  80259a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 00                	push   $0x0
  8025a7:	6a 2c                	push   $0x2c
  8025a9:	e8 7b fa ff ff       	call   802029 <syscall>
  8025ae:	83 c4 18             	add    $0x18,%esp
  8025b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8025b4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8025b8:	75 07                	jne    8025c1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8025ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bf:	eb 05                	jmp    8025c6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8025c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c6:	c9                   	leave  
  8025c7:	c3                   	ret    

008025c8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8025c8:	55                   	push   %ebp
  8025c9:	89 e5                	mov    %esp,%ebp
  8025cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ce:	6a 00                	push   $0x0
  8025d0:	6a 00                	push   $0x0
  8025d2:	6a 00                	push   $0x0
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 2c                	push   $0x2c
  8025da:	e8 4a fa ff ff       	call   802029 <syscall>
  8025df:	83 c4 18             	add    $0x18,%esp
  8025e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025e5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025e9:	75 07                	jne    8025f2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f0:	eb 05                	jmp    8025f7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
  8025fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	6a 2c                	push   $0x2c
  80260b:	e8 19 fa ff ff       	call   802029 <syscall>
  802610:	83 c4 18             	add    $0x18,%esp
  802613:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802616:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80261a:	75 07                	jne    802623 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80261c:	b8 01 00 00 00       	mov    $0x1,%eax
  802621:	eb 05                	jmp    802628 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802623:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802628:	c9                   	leave  
  802629:	c3                   	ret    

0080262a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80262a:	55                   	push   %ebp
  80262b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80262d:	6a 00                	push   $0x0
  80262f:	6a 00                	push   $0x0
  802631:	6a 00                	push   $0x0
  802633:	6a 00                	push   $0x0
  802635:	ff 75 08             	pushl  0x8(%ebp)
  802638:	6a 2d                	push   $0x2d
  80263a:	e8 ea f9 ff ff       	call   802029 <syscall>
  80263f:	83 c4 18             	add    $0x18,%esp
	return ;
  802642:	90                   	nop
}
  802643:	c9                   	leave  
  802644:	c3                   	ret    

00802645 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802645:	55                   	push   %ebp
  802646:	89 e5                	mov    %esp,%ebp
  802648:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802649:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80264c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80264f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	6a 00                	push   $0x0
  802657:	53                   	push   %ebx
  802658:	51                   	push   %ecx
  802659:	52                   	push   %edx
  80265a:	50                   	push   %eax
  80265b:	6a 2e                	push   $0x2e
  80265d:	e8 c7 f9 ff ff       	call   802029 <syscall>
  802662:	83 c4 18             	add    $0x18,%esp
}
  802665:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802668:	c9                   	leave  
  802669:	c3                   	ret    

0080266a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80266d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802670:	8b 45 08             	mov    0x8(%ebp),%eax
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	52                   	push   %edx
  80267a:	50                   	push   %eax
  80267b:	6a 2f                	push   $0x2f
  80267d:	e8 a7 f9 ff ff       	call   802029 <syscall>
  802682:	83 c4 18             	add    $0x18,%esp
}
  802685:	c9                   	leave  
  802686:	c3                   	ret    

00802687 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802687:	55                   	push   %ebp
  802688:	89 e5                	mov    %esp,%ebp
  80268a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80268d:	83 ec 0c             	sub    $0xc,%esp
  802690:	68 b0 42 80 00       	push   $0x8042b0
  802695:	e8 1b e5 ff ff       	call   800bb5 <cprintf>
  80269a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80269d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8026a4:	83 ec 0c             	sub    $0xc,%esp
  8026a7:	68 dc 42 80 00       	push   $0x8042dc
  8026ac:	e8 04 e5 ff ff       	call   800bb5 <cprintf>
  8026b1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8026b4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026b8:	a1 38 51 80 00       	mov    0x805138,%eax
  8026bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026c0:	eb 56                	jmp    802718 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026c6:	74 1c                	je     8026e4 <print_mem_block_lists+0x5d>
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 50 08             	mov    0x8(%eax),%edx
  8026ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d1:	8b 48 08             	mov    0x8(%eax),%ecx
  8026d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026da:	01 c8                	add    %ecx,%eax
  8026dc:	39 c2                	cmp    %eax,%edx
  8026de:	73 04                	jae    8026e4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026e0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	8b 50 08             	mov    0x8(%eax),%edx
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f0:	01 c2                	add    %eax,%edx
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 40 08             	mov    0x8(%eax),%eax
  8026f8:	83 ec 04             	sub    $0x4,%esp
  8026fb:	52                   	push   %edx
  8026fc:	50                   	push   %eax
  8026fd:	68 f1 42 80 00       	push   $0x8042f1
  802702:	e8 ae e4 ff ff       	call   800bb5 <cprintf>
  802707:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80270a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802710:	a1 40 51 80 00       	mov    0x805140,%eax
  802715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271c:	74 07                	je     802725 <print_mem_block_lists+0x9e>
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 00                	mov    (%eax),%eax
  802723:	eb 05                	jmp    80272a <print_mem_block_lists+0xa3>
  802725:	b8 00 00 00 00       	mov    $0x0,%eax
  80272a:	a3 40 51 80 00       	mov    %eax,0x805140
  80272f:	a1 40 51 80 00       	mov    0x805140,%eax
  802734:	85 c0                	test   %eax,%eax
  802736:	75 8a                	jne    8026c2 <print_mem_block_lists+0x3b>
  802738:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273c:	75 84                	jne    8026c2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80273e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802742:	75 10                	jne    802754 <print_mem_block_lists+0xcd>
  802744:	83 ec 0c             	sub    $0xc,%esp
  802747:	68 00 43 80 00       	push   $0x804300
  80274c:	e8 64 e4 ff ff       	call   800bb5 <cprintf>
  802751:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802754:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80275b:	83 ec 0c             	sub    $0xc,%esp
  80275e:	68 24 43 80 00       	push   $0x804324
  802763:	e8 4d e4 ff ff       	call   800bb5 <cprintf>
  802768:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80276b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80276f:	a1 40 50 80 00       	mov    0x805040,%eax
  802774:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802777:	eb 56                	jmp    8027cf <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802779:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80277d:	74 1c                	je     80279b <print_mem_block_lists+0x114>
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 50 08             	mov    0x8(%eax),%edx
  802785:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802788:	8b 48 08             	mov    0x8(%eax),%ecx
  80278b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278e:	8b 40 0c             	mov    0xc(%eax),%eax
  802791:	01 c8                	add    %ecx,%eax
  802793:	39 c2                	cmp    %eax,%edx
  802795:	73 04                	jae    80279b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802797:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 50 08             	mov    0x8(%eax),%edx
  8027a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a7:	01 c2                	add    %eax,%edx
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	8b 40 08             	mov    0x8(%eax),%eax
  8027af:	83 ec 04             	sub    $0x4,%esp
  8027b2:	52                   	push   %edx
  8027b3:	50                   	push   %eax
  8027b4:	68 f1 42 80 00       	push   $0x8042f1
  8027b9:	e8 f7 e3 ff ff       	call   800bb5 <cprintf>
  8027be:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027c7:	a1 48 50 80 00       	mov    0x805048,%eax
  8027cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d3:	74 07                	je     8027dc <print_mem_block_lists+0x155>
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 00                	mov    (%eax),%eax
  8027da:	eb 05                	jmp    8027e1 <print_mem_block_lists+0x15a>
  8027dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e1:	a3 48 50 80 00       	mov    %eax,0x805048
  8027e6:	a1 48 50 80 00       	mov    0x805048,%eax
  8027eb:	85 c0                	test   %eax,%eax
  8027ed:	75 8a                	jne    802779 <print_mem_block_lists+0xf2>
  8027ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f3:	75 84                	jne    802779 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027f5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027f9:	75 10                	jne    80280b <print_mem_block_lists+0x184>
  8027fb:	83 ec 0c             	sub    $0xc,%esp
  8027fe:	68 3c 43 80 00       	push   $0x80433c
  802803:	e8 ad e3 ff ff       	call   800bb5 <cprintf>
  802808:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80280b:	83 ec 0c             	sub    $0xc,%esp
  80280e:	68 b0 42 80 00       	push   $0x8042b0
  802813:	e8 9d e3 ff ff       	call   800bb5 <cprintf>
  802818:	83 c4 10             	add    $0x10,%esp

}
  80281b:	90                   	nop
  80281c:	c9                   	leave  
  80281d:	c3                   	ret    

0080281e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80281e:	55                   	push   %ebp
  80281f:	89 e5                	mov    %esp,%ebp
  802821:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802824:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80282b:	00 00 00 
  80282e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802835:	00 00 00 
  802838:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80283f:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802842:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802849:	e9 9e 00 00 00       	jmp    8028ec <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  80284e:	a1 50 50 80 00       	mov    0x805050,%eax
  802853:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802856:	c1 e2 04             	shl    $0x4,%edx
  802859:	01 d0                	add    %edx,%eax
  80285b:	85 c0                	test   %eax,%eax
  80285d:	75 14                	jne    802873 <initialize_MemBlocksList+0x55>
  80285f:	83 ec 04             	sub    $0x4,%esp
  802862:	68 64 43 80 00       	push   $0x804364
  802867:	6a 43                	push   $0x43
  802869:	68 87 43 80 00       	push   $0x804387
  80286e:	e8 8e e0 ff ff       	call   800901 <_panic>
  802873:	a1 50 50 80 00       	mov    0x805050,%eax
  802878:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287b:	c1 e2 04             	shl    $0x4,%edx
  80287e:	01 d0                	add    %edx,%eax
  802880:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802886:	89 10                	mov    %edx,(%eax)
  802888:	8b 00                	mov    (%eax),%eax
  80288a:	85 c0                	test   %eax,%eax
  80288c:	74 18                	je     8028a6 <initialize_MemBlocksList+0x88>
  80288e:	a1 48 51 80 00       	mov    0x805148,%eax
  802893:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802899:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80289c:	c1 e1 04             	shl    $0x4,%ecx
  80289f:	01 ca                	add    %ecx,%edx
  8028a1:	89 50 04             	mov    %edx,0x4(%eax)
  8028a4:	eb 12                	jmp    8028b8 <initialize_MemBlocksList+0x9a>
  8028a6:	a1 50 50 80 00       	mov    0x805050,%eax
  8028ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ae:	c1 e2 04             	shl    $0x4,%edx
  8028b1:	01 d0                	add    %edx,%eax
  8028b3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028b8:	a1 50 50 80 00       	mov    0x805050,%eax
  8028bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c0:	c1 e2 04             	shl    $0x4,%edx
  8028c3:	01 d0                	add    %edx,%eax
  8028c5:	a3 48 51 80 00       	mov    %eax,0x805148
  8028ca:	a1 50 50 80 00       	mov    0x805050,%eax
  8028cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d2:	c1 e2 04             	shl    $0x4,%edx
  8028d5:	01 d0                	add    %edx,%eax
  8028d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028de:	a1 54 51 80 00       	mov    0x805154,%eax
  8028e3:	40                   	inc    %eax
  8028e4:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8028e9:	ff 45 f4             	incl   -0xc(%ebp)
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f2:	0f 82 56 ff ff ff    	jb     80284e <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8028f8:	90                   	nop
  8028f9:	c9                   	leave  
  8028fa:	c3                   	ret    

008028fb <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8028fb:	55                   	push   %ebp
  8028fc:	89 e5                	mov    %esp,%ebp
  8028fe:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802901:	a1 38 51 80 00       	mov    0x805138,%eax
  802906:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802909:	eb 18                	jmp    802923 <find_block+0x28>
	{
		if (ele->sva==va)
  80290b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80290e:	8b 40 08             	mov    0x8(%eax),%eax
  802911:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802914:	75 05                	jne    80291b <find_block+0x20>
			return ele;
  802916:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802919:	eb 7b                	jmp    802996 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80291b:	a1 40 51 80 00       	mov    0x805140,%eax
  802920:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802923:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802927:	74 07                	je     802930 <find_block+0x35>
  802929:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80292c:	8b 00                	mov    (%eax),%eax
  80292e:	eb 05                	jmp    802935 <find_block+0x3a>
  802930:	b8 00 00 00 00       	mov    $0x0,%eax
  802935:	a3 40 51 80 00       	mov    %eax,0x805140
  80293a:	a1 40 51 80 00       	mov    0x805140,%eax
  80293f:	85 c0                	test   %eax,%eax
  802941:	75 c8                	jne    80290b <find_block+0x10>
  802943:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802947:	75 c2                	jne    80290b <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802949:	a1 40 50 80 00       	mov    0x805040,%eax
  80294e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802951:	eb 18                	jmp    80296b <find_block+0x70>
	{
		if (ele->sva==va)
  802953:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802956:	8b 40 08             	mov    0x8(%eax),%eax
  802959:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80295c:	75 05                	jne    802963 <find_block+0x68>
					return ele;
  80295e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802961:	eb 33                	jmp    802996 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802963:	a1 48 50 80 00       	mov    0x805048,%eax
  802968:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80296b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80296f:	74 07                	je     802978 <find_block+0x7d>
  802971:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802974:	8b 00                	mov    (%eax),%eax
  802976:	eb 05                	jmp    80297d <find_block+0x82>
  802978:	b8 00 00 00 00       	mov    $0x0,%eax
  80297d:	a3 48 50 80 00       	mov    %eax,0x805048
  802982:	a1 48 50 80 00       	mov    0x805048,%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	75 c8                	jne    802953 <find_block+0x58>
  80298b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80298f:	75 c2                	jne    802953 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802991:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802996:	c9                   	leave  
  802997:	c3                   	ret    

00802998 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802998:	55                   	push   %ebp
  802999:	89 e5                	mov    %esp,%ebp
  80299b:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  80299e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029a3:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  8029a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029aa:	75 62                	jne    802a0e <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8029ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b0:	75 14                	jne    8029c6 <insert_sorted_allocList+0x2e>
  8029b2:	83 ec 04             	sub    $0x4,%esp
  8029b5:	68 64 43 80 00       	push   $0x804364
  8029ba:	6a 69                	push   $0x69
  8029bc:	68 87 43 80 00       	push   $0x804387
  8029c1:	e8 3b df ff ff       	call   800901 <_panic>
  8029c6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	89 10                	mov    %edx,(%eax)
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	8b 00                	mov    (%eax),%eax
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	74 0d                	je     8029e7 <insert_sorted_allocList+0x4f>
  8029da:	a1 40 50 80 00       	mov    0x805040,%eax
  8029df:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e2:	89 50 04             	mov    %edx,0x4(%eax)
  8029e5:	eb 08                	jmp    8029ef <insert_sorted_allocList+0x57>
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	a3 44 50 80 00       	mov    %eax,0x805044
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	a3 40 50 80 00       	mov    %eax,0x805040
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a01:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a06:	40                   	inc    %eax
  802a07:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802a0c:	eb 72                	jmp    802a80 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802a0e:	a1 40 50 80 00       	mov    0x805040,%eax
  802a13:	8b 50 08             	mov    0x8(%eax),%edx
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	8b 40 08             	mov    0x8(%eax),%eax
  802a1c:	39 c2                	cmp    %eax,%edx
  802a1e:	76 60                	jbe    802a80 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802a20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a24:	75 14                	jne    802a3a <insert_sorted_allocList+0xa2>
  802a26:	83 ec 04             	sub    $0x4,%esp
  802a29:	68 64 43 80 00       	push   $0x804364
  802a2e:	6a 6d                	push   $0x6d
  802a30:	68 87 43 80 00       	push   $0x804387
  802a35:	e8 c7 de ff ff       	call   800901 <_panic>
  802a3a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	89 10                	mov    %edx,(%eax)
  802a45:	8b 45 08             	mov    0x8(%ebp),%eax
  802a48:	8b 00                	mov    (%eax),%eax
  802a4a:	85 c0                	test   %eax,%eax
  802a4c:	74 0d                	je     802a5b <insert_sorted_allocList+0xc3>
  802a4e:	a1 40 50 80 00       	mov    0x805040,%eax
  802a53:	8b 55 08             	mov    0x8(%ebp),%edx
  802a56:	89 50 04             	mov    %edx,0x4(%eax)
  802a59:	eb 08                	jmp    802a63 <insert_sorted_allocList+0xcb>
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	a3 44 50 80 00       	mov    %eax,0x805044
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	a3 40 50 80 00       	mov    %eax,0x805040
  802a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a75:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a7a:	40                   	inc    %eax
  802a7b:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802a80:	a1 40 50 80 00       	mov    0x805040,%eax
  802a85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a88:	e9 b9 01 00 00       	jmp    802c46 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	8b 50 08             	mov    0x8(%eax),%edx
  802a93:	a1 40 50 80 00       	mov    0x805040,%eax
  802a98:	8b 40 08             	mov    0x8(%eax),%eax
  802a9b:	39 c2                	cmp    %eax,%edx
  802a9d:	76 7c                	jbe    802b1b <insert_sorted_allocList+0x183>
  802a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa2:	8b 50 08             	mov    0x8(%eax),%edx
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 40 08             	mov    0x8(%eax),%eax
  802aab:	39 c2                	cmp    %eax,%edx
  802aad:	73 6c                	jae    802b1b <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802aaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab3:	74 06                	je     802abb <insert_sorted_allocList+0x123>
  802ab5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab9:	75 14                	jne    802acf <insert_sorted_allocList+0x137>
  802abb:	83 ec 04             	sub    $0x4,%esp
  802abe:	68 a0 43 80 00       	push   $0x8043a0
  802ac3:	6a 75                	push   $0x75
  802ac5:	68 87 43 80 00       	push   $0x804387
  802aca:	e8 32 de ff ff       	call   800901 <_panic>
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 50 04             	mov    0x4(%eax),%edx
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	89 50 04             	mov    %edx,0x4(%eax)
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae1:	89 10                	mov    %edx,(%eax)
  802ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae6:	8b 40 04             	mov    0x4(%eax),%eax
  802ae9:	85 c0                	test   %eax,%eax
  802aeb:	74 0d                	je     802afa <insert_sorted_allocList+0x162>
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	8b 40 04             	mov    0x4(%eax),%eax
  802af3:	8b 55 08             	mov    0x8(%ebp),%edx
  802af6:	89 10                	mov    %edx,(%eax)
  802af8:	eb 08                	jmp    802b02 <insert_sorted_allocList+0x16a>
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	a3 40 50 80 00       	mov    %eax,0x805040
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 55 08             	mov    0x8(%ebp),%edx
  802b08:	89 50 04             	mov    %edx,0x4(%eax)
  802b0b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b10:	40                   	inc    %eax
  802b11:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802b16:	e9 59 01 00 00       	jmp    802c74 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	8b 50 08             	mov    0x8(%eax),%edx
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 40 08             	mov    0x8(%eax),%eax
  802b27:	39 c2                	cmp    %eax,%edx
  802b29:	0f 86 98 00 00 00    	jbe    802bc7 <insert_sorted_allocList+0x22f>
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	8b 50 08             	mov    0x8(%eax),%edx
  802b35:	a1 44 50 80 00       	mov    0x805044,%eax
  802b3a:	8b 40 08             	mov    0x8(%eax),%eax
  802b3d:	39 c2                	cmp    %eax,%edx
  802b3f:	0f 83 82 00 00 00    	jae    802bc7 <insert_sorted_allocList+0x22f>
  802b45:	8b 45 08             	mov    0x8(%ebp),%eax
  802b48:	8b 50 08             	mov    0x8(%eax),%edx
  802b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4e:	8b 00                	mov    (%eax),%eax
  802b50:	8b 40 08             	mov    0x8(%eax),%eax
  802b53:	39 c2                	cmp    %eax,%edx
  802b55:	73 70                	jae    802bc7 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802b57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b5b:	74 06                	je     802b63 <insert_sorted_allocList+0x1cb>
  802b5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b61:	75 14                	jne    802b77 <insert_sorted_allocList+0x1df>
  802b63:	83 ec 04             	sub    $0x4,%esp
  802b66:	68 d8 43 80 00       	push   $0x8043d8
  802b6b:	6a 7c                	push   $0x7c
  802b6d:	68 87 43 80 00       	push   $0x804387
  802b72:	e8 8a dd ff ff       	call   800901 <_panic>
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	8b 10                	mov    (%eax),%edx
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	89 10                	mov    %edx,(%eax)
  802b81:	8b 45 08             	mov    0x8(%ebp),%eax
  802b84:	8b 00                	mov    (%eax),%eax
  802b86:	85 c0                	test   %eax,%eax
  802b88:	74 0b                	je     802b95 <insert_sorted_allocList+0x1fd>
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 00                	mov    (%eax),%eax
  802b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b92:	89 50 04             	mov    %edx,0x4(%eax)
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9b:	89 10                	mov    %edx,(%eax)
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ba3:	89 50 04             	mov    %edx,0x4(%eax)
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	75 08                	jne    802bb7 <insert_sorted_allocList+0x21f>
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	a3 44 50 80 00       	mov    %eax,0x805044
  802bb7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bbc:	40                   	inc    %eax
  802bbd:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802bc2:	e9 ad 00 00 00       	jmp    802c74 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bca:	8b 50 08             	mov    0x8(%eax),%edx
  802bcd:	a1 44 50 80 00       	mov    0x805044,%eax
  802bd2:	8b 40 08             	mov    0x8(%eax),%eax
  802bd5:	39 c2                	cmp    %eax,%edx
  802bd7:	76 65                	jbe    802c3e <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802bd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bdd:	75 17                	jne    802bf6 <insert_sorted_allocList+0x25e>
  802bdf:	83 ec 04             	sub    $0x4,%esp
  802be2:	68 0c 44 80 00       	push   $0x80440c
  802be7:	68 80 00 00 00       	push   $0x80
  802bec:	68 87 43 80 00       	push   $0x804387
  802bf1:	e8 0b dd ff ff       	call   800901 <_panic>
  802bf6:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bff:	89 50 04             	mov    %edx,0x4(%eax)
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	8b 40 04             	mov    0x4(%eax),%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	74 0c                	je     802c18 <insert_sorted_allocList+0x280>
  802c0c:	a1 44 50 80 00       	mov    0x805044,%eax
  802c11:	8b 55 08             	mov    0x8(%ebp),%edx
  802c14:	89 10                	mov    %edx,(%eax)
  802c16:	eb 08                	jmp    802c20 <insert_sorted_allocList+0x288>
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	a3 40 50 80 00       	mov    %eax,0x805040
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	a3 44 50 80 00       	mov    %eax,0x805044
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c31:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c36:	40                   	inc    %eax
  802c37:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802c3c:	eb 36                	jmp    802c74 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802c3e:	a1 48 50 80 00       	mov    0x805048,%eax
  802c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4a:	74 07                	je     802c53 <insert_sorted_allocList+0x2bb>
  802c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4f:	8b 00                	mov    (%eax),%eax
  802c51:	eb 05                	jmp    802c58 <insert_sorted_allocList+0x2c0>
  802c53:	b8 00 00 00 00       	mov    $0x0,%eax
  802c58:	a3 48 50 80 00       	mov    %eax,0x805048
  802c5d:	a1 48 50 80 00       	mov    0x805048,%eax
  802c62:	85 c0                	test   %eax,%eax
  802c64:	0f 85 23 fe ff ff    	jne    802a8d <insert_sorted_allocList+0xf5>
  802c6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6e:	0f 85 19 fe ff ff    	jne    802a8d <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802c74:	90                   	nop
  802c75:	c9                   	leave  
  802c76:	c3                   	ret    

00802c77 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c77:	55                   	push   %ebp
  802c78:	89 e5                	mov    %esp,%ebp
  802c7a:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802c7d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c85:	e9 7c 01 00 00       	jmp    802e06 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c90:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c93:	0f 85 90 00 00 00    	jne    802d29 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802c9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca3:	75 17                	jne    802cbc <alloc_block_FF+0x45>
  802ca5:	83 ec 04             	sub    $0x4,%esp
  802ca8:	68 2f 44 80 00       	push   $0x80442f
  802cad:	68 ba 00 00 00       	push   $0xba
  802cb2:	68 87 43 80 00       	push   $0x804387
  802cb7:	e8 45 dc ff ff       	call   800901 <_panic>
  802cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbf:	8b 00                	mov    (%eax),%eax
  802cc1:	85 c0                	test   %eax,%eax
  802cc3:	74 10                	je     802cd5 <alloc_block_FF+0x5e>
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 00                	mov    (%eax),%eax
  802cca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccd:	8b 52 04             	mov    0x4(%edx),%edx
  802cd0:	89 50 04             	mov    %edx,0x4(%eax)
  802cd3:	eb 0b                	jmp    802ce0 <alloc_block_FF+0x69>
  802cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd8:	8b 40 04             	mov    0x4(%eax),%eax
  802cdb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 40 04             	mov    0x4(%eax),%eax
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	74 0f                	je     802cf9 <alloc_block_FF+0x82>
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 40 04             	mov    0x4(%eax),%eax
  802cf0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf3:	8b 12                	mov    (%edx),%edx
  802cf5:	89 10                	mov    %edx,(%eax)
  802cf7:	eb 0a                	jmp    802d03 <alloc_block_FF+0x8c>
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 00                	mov    (%eax),%eax
  802cfe:	a3 38 51 80 00       	mov    %eax,0x805138
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d16:	a1 44 51 80 00       	mov    0x805144,%eax
  802d1b:	48                   	dec    %eax
  802d1c:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d24:	e9 10 01 00 00       	jmp    802e39 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d32:	0f 86 c6 00 00 00    	jbe    802dfe <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802d38:	a1 48 51 80 00       	mov    0x805148,%eax
  802d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802d40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d44:	75 17                	jne    802d5d <alloc_block_FF+0xe6>
  802d46:	83 ec 04             	sub    $0x4,%esp
  802d49:	68 2f 44 80 00       	push   $0x80442f
  802d4e:	68 c2 00 00 00       	push   $0xc2
  802d53:	68 87 43 80 00       	push   $0x804387
  802d58:	e8 a4 db ff ff       	call   800901 <_panic>
  802d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	85 c0                	test   %eax,%eax
  802d64:	74 10                	je     802d76 <alloc_block_FF+0xff>
  802d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d69:	8b 00                	mov    (%eax),%eax
  802d6b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d6e:	8b 52 04             	mov    0x4(%edx),%edx
  802d71:	89 50 04             	mov    %edx,0x4(%eax)
  802d74:	eb 0b                	jmp    802d81 <alloc_block_FF+0x10a>
  802d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d79:	8b 40 04             	mov    0x4(%eax),%eax
  802d7c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d84:	8b 40 04             	mov    0x4(%eax),%eax
  802d87:	85 c0                	test   %eax,%eax
  802d89:	74 0f                	je     802d9a <alloc_block_FF+0x123>
  802d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8e:	8b 40 04             	mov    0x4(%eax),%eax
  802d91:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d94:	8b 12                	mov    (%edx),%edx
  802d96:	89 10                	mov    %edx,(%eax)
  802d98:	eb 0a                	jmp    802da4 <alloc_block_FF+0x12d>
  802d9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d9d:	8b 00                	mov    (%eax),%eax
  802d9f:	a3 48 51 80 00       	mov    %eax,0x805148
  802da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802db0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db7:	a1 54 51 80 00       	mov    0x805154,%eax
  802dbc:	48                   	dec    %eax
  802dbd:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	8b 50 08             	mov    0x8(%eax),%edx
  802dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dcb:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd4:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddd:	2b 45 08             	sub    0x8(%ebp),%eax
  802de0:	89 c2                	mov    %eax,%edx
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	8b 50 08             	mov    0x8(%eax),%edx
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	01 c2                	add    %eax,%edx
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dfc:	eb 3b                	jmp    802e39 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802dfe:	a1 40 51 80 00       	mov    0x805140,%eax
  802e03:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0a:	74 07                	je     802e13 <alloc_block_FF+0x19c>
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 00                	mov    (%eax),%eax
  802e11:	eb 05                	jmp    802e18 <alloc_block_FF+0x1a1>
  802e13:	b8 00 00 00 00       	mov    $0x0,%eax
  802e18:	a3 40 51 80 00       	mov    %eax,0x805140
  802e1d:	a1 40 51 80 00       	mov    0x805140,%eax
  802e22:	85 c0                	test   %eax,%eax
  802e24:	0f 85 60 fe ff ff    	jne    802c8a <alloc_block_FF+0x13>
  802e2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2e:	0f 85 56 fe ff ff    	jne    802c8a <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802e34:	b8 00 00 00 00       	mov    $0x0,%eax
  802e39:	c9                   	leave  
  802e3a:	c3                   	ret    

00802e3b <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802e3b:	55                   	push   %ebp
  802e3c:	89 e5                	mov    %esp,%ebp
  802e3e:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802e41:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802e48:	a1 38 51 80 00       	mov    0x805138,%eax
  802e4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e50:	eb 3a                	jmp    802e8c <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 40 0c             	mov    0xc(%eax),%eax
  802e58:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e5b:	72 27                	jb     802e84 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802e5d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802e61:	75 0b                	jne    802e6e <alloc_block_BF+0x33>
					best_size= element->size;
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 40 0c             	mov    0xc(%eax),%eax
  802e69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e6c:	eb 16                	jmp    802e84 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	8b 50 0c             	mov    0xc(%eax),%edx
  802e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e77:	39 c2                	cmp    %eax,%edx
  802e79:	77 09                	ja     802e84 <alloc_block_BF+0x49>
					best_size=element->size;
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e81:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802e84:	a1 40 51 80 00       	mov    0x805140,%eax
  802e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e90:	74 07                	je     802e99 <alloc_block_BF+0x5e>
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 00                	mov    (%eax),%eax
  802e97:	eb 05                	jmp    802e9e <alloc_block_BF+0x63>
  802e99:	b8 00 00 00 00       	mov    $0x0,%eax
  802e9e:	a3 40 51 80 00       	mov    %eax,0x805140
  802ea3:	a1 40 51 80 00       	mov    0x805140,%eax
  802ea8:	85 c0                	test   %eax,%eax
  802eaa:	75 a6                	jne    802e52 <alloc_block_BF+0x17>
  802eac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb0:	75 a0                	jne    802e52 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802eb2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802eb6:	0f 84 d3 01 00 00    	je     80308f <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802ebc:	a1 38 51 80 00       	mov    0x805138,%eax
  802ec1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ec4:	e9 98 01 00 00       	jmp    803061 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ecc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ecf:	0f 86 da 00 00 00    	jbe    802faf <alloc_block_BF+0x174>
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 50 0c             	mov    0xc(%eax),%edx
  802edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ede:	39 c2                	cmp    %eax,%edx
  802ee0:	0f 85 c9 00 00 00    	jne    802faf <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802ee6:	a1 48 51 80 00       	mov    0x805148,%eax
  802eeb:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802eee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ef2:	75 17                	jne    802f0b <alloc_block_BF+0xd0>
  802ef4:	83 ec 04             	sub    $0x4,%esp
  802ef7:	68 2f 44 80 00       	push   $0x80442f
  802efc:	68 ea 00 00 00       	push   $0xea
  802f01:	68 87 43 80 00       	push   $0x804387
  802f06:	e8 f6 d9 ff ff       	call   800901 <_panic>
  802f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f0e:	8b 00                	mov    (%eax),%eax
  802f10:	85 c0                	test   %eax,%eax
  802f12:	74 10                	je     802f24 <alloc_block_BF+0xe9>
  802f14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f17:	8b 00                	mov    (%eax),%eax
  802f19:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f1c:	8b 52 04             	mov    0x4(%edx),%edx
  802f1f:	89 50 04             	mov    %edx,0x4(%eax)
  802f22:	eb 0b                	jmp    802f2f <alloc_block_BF+0xf4>
  802f24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f27:	8b 40 04             	mov    0x4(%eax),%eax
  802f2a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f32:	8b 40 04             	mov    0x4(%eax),%eax
  802f35:	85 c0                	test   %eax,%eax
  802f37:	74 0f                	je     802f48 <alloc_block_BF+0x10d>
  802f39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f3c:	8b 40 04             	mov    0x4(%eax),%eax
  802f3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f42:	8b 12                	mov    (%edx),%edx
  802f44:	89 10                	mov    %edx,(%eax)
  802f46:	eb 0a                	jmp    802f52 <alloc_block_BF+0x117>
  802f48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4b:	8b 00                	mov    (%eax),%eax
  802f4d:	a3 48 51 80 00       	mov    %eax,0x805148
  802f52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f65:	a1 54 51 80 00       	mov    0x805154,%eax
  802f6a:	48                   	dec    %eax
  802f6b:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 50 08             	mov    0x8(%eax),%edx
  802f76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f79:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f82:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8b:	2b 45 08             	sub    0x8(%ebp),%eax
  802f8e:	89 c2                	mov    %eax,%edx
  802f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f93:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	8b 50 08             	mov    0x8(%eax),%edx
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	01 c2                	add    %eax,%edx
  802fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa4:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faa:	e9 e5 00 00 00       	jmp    803094 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb8:	39 c2                	cmp    %eax,%edx
  802fba:	0f 85 99 00 00 00    	jne    803059 <alloc_block_BF+0x21e>
  802fc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fc3:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fc6:	0f 85 8d 00 00 00    	jne    803059 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802fd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd6:	75 17                	jne    802fef <alloc_block_BF+0x1b4>
  802fd8:	83 ec 04             	sub    $0x4,%esp
  802fdb:	68 2f 44 80 00       	push   $0x80442f
  802fe0:	68 f7 00 00 00       	push   $0xf7
  802fe5:	68 87 43 80 00       	push   $0x804387
  802fea:	e8 12 d9 ff ff       	call   800901 <_panic>
  802fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	85 c0                	test   %eax,%eax
  802ff6:	74 10                	je     803008 <alloc_block_BF+0x1cd>
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	8b 00                	mov    (%eax),%eax
  802ffd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803000:	8b 52 04             	mov    0x4(%edx),%edx
  803003:	89 50 04             	mov    %edx,0x4(%eax)
  803006:	eb 0b                	jmp    803013 <alloc_block_BF+0x1d8>
  803008:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300b:	8b 40 04             	mov    0x4(%eax),%eax
  80300e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	8b 40 04             	mov    0x4(%eax),%eax
  803019:	85 c0                	test   %eax,%eax
  80301b:	74 0f                	je     80302c <alloc_block_BF+0x1f1>
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	8b 40 04             	mov    0x4(%eax),%eax
  803023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803026:	8b 12                	mov    (%edx),%edx
  803028:	89 10                	mov    %edx,(%eax)
  80302a:	eb 0a                	jmp    803036 <alloc_block_BF+0x1fb>
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	8b 00                	mov    (%eax),%eax
  803031:	a3 38 51 80 00       	mov    %eax,0x805138
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803049:	a1 44 51 80 00       	mov    0x805144,%eax
  80304e:	48                   	dec    %eax
  80304f:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  803054:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803057:	eb 3b                	jmp    803094 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  803059:	a1 40 51 80 00       	mov    0x805140,%eax
  80305e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803061:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803065:	74 07                	je     80306e <alloc_block_BF+0x233>
  803067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306a:	8b 00                	mov    (%eax),%eax
  80306c:	eb 05                	jmp    803073 <alloc_block_BF+0x238>
  80306e:	b8 00 00 00 00       	mov    $0x0,%eax
  803073:	a3 40 51 80 00       	mov    %eax,0x805140
  803078:	a1 40 51 80 00       	mov    0x805140,%eax
  80307d:	85 c0                	test   %eax,%eax
  80307f:	0f 85 44 fe ff ff    	jne    802ec9 <alloc_block_BF+0x8e>
  803085:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803089:	0f 85 3a fe ff ff    	jne    802ec9 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80308f:	b8 00 00 00 00       	mov    $0x0,%eax
  803094:	c9                   	leave  
  803095:	c3                   	ret    

00803096 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803096:	55                   	push   %ebp
  803097:	89 e5                	mov    %esp,%ebp
  803099:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80309c:	83 ec 04             	sub    $0x4,%esp
  80309f:	68 50 44 80 00       	push   $0x804450
  8030a4:	68 04 01 00 00       	push   $0x104
  8030a9:	68 87 43 80 00       	push   $0x804387
  8030ae:	e8 4e d8 ff ff       	call   800901 <_panic>

008030b3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  8030b3:	55                   	push   %ebp
  8030b4:	89 e5                	mov    %esp,%ebp
  8030b6:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  8030b9:	a1 38 51 80 00       	mov    0x805138,%eax
  8030be:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  8030c1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030c6:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  8030c9:	a1 38 51 80 00       	mov    0x805138,%eax
  8030ce:	85 c0                	test   %eax,%eax
  8030d0:	75 68                	jne    80313a <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8030d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d6:	75 17                	jne    8030ef <insert_sorted_with_merge_freeList+0x3c>
  8030d8:	83 ec 04             	sub    $0x4,%esp
  8030db:	68 64 43 80 00       	push   $0x804364
  8030e0:	68 14 01 00 00       	push   $0x114
  8030e5:	68 87 43 80 00       	push   $0x804387
  8030ea:	e8 12 d8 ff ff       	call   800901 <_panic>
  8030ef:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	89 10                	mov    %edx,(%eax)
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	8b 00                	mov    (%eax),%eax
  8030ff:	85 c0                	test   %eax,%eax
  803101:	74 0d                	je     803110 <insert_sorted_with_merge_freeList+0x5d>
  803103:	a1 38 51 80 00       	mov    0x805138,%eax
  803108:	8b 55 08             	mov    0x8(%ebp),%edx
  80310b:	89 50 04             	mov    %edx,0x4(%eax)
  80310e:	eb 08                	jmp    803118 <insert_sorted_with_merge_freeList+0x65>
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	a3 38 51 80 00       	mov    %eax,0x805138
  803120:	8b 45 08             	mov    0x8(%ebp),%eax
  803123:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80312a:	a1 44 51 80 00       	mov    0x805144,%eax
  80312f:	40                   	inc    %eax
  803130:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803135:	e9 d2 06 00 00       	jmp    80380c <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  80313a:	8b 45 08             	mov    0x8(%ebp),%eax
  80313d:	8b 50 08             	mov    0x8(%eax),%edx
  803140:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803143:	8b 40 08             	mov    0x8(%eax),%eax
  803146:	39 c2                	cmp    %eax,%edx
  803148:	0f 83 22 01 00 00    	jae    803270 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  80314e:	8b 45 08             	mov    0x8(%ebp),%eax
  803151:	8b 50 08             	mov    0x8(%eax),%edx
  803154:	8b 45 08             	mov    0x8(%ebp),%eax
  803157:	8b 40 0c             	mov    0xc(%eax),%eax
  80315a:	01 c2                	add    %eax,%edx
  80315c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315f:	8b 40 08             	mov    0x8(%eax),%eax
  803162:	39 c2                	cmp    %eax,%edx
  803164:	0f 85 9e 00 00 00    	jne    803208 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	8b 50 08             	mov    0x8(%eax),%edx
  803170:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803173:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803179:	8b 50 0c             	mov    0xc(%eax),%edx
  80317c:	8b 45 08             	mov    0x8(%ebp),%eax
  80317f:	8b 40 0c             	mov    0xc(%eax),%eax
  803182:	01 c2                	add    %eax,%edx
  803184:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803187:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803194:	8b 45 08             	mov    0x8(%ebp),%eax
  803197:	8b 50 08             	mov    0x8(%eax),%edx
  80319a:	8b 45 08             	mov    0x8(%ebp),%eax
  80319d:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8031a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a4:	75 17                	jne    8031bd <insert_sorted_with_merge_freeList+0x10a>
  8031a6:	83 ec 04             	sub    $0x4,%esp
  8031a9:	68 64 43 80 00       	push   $0x804364
  8031ae:	68 21 01 00 00       	push   $0x121
  8031b3:	68 87 43 80 00       	push   $0x804387
  8031b8:	e8 44 d7 ff ff       	call   800901 <_panic>
  8031bd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c6:	89 10                	mov    %edx,(%eax)
  8031c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cb:	8b 00                	mov    (%eax),%eax
  8031cd:	85 c0                	test   %eax,%eax
  8031cf:	74 0d                	je     8031de <insert_sorted_with_merge_freeList+0x12b>
  8031d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8031d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d9:	89 50 04             	mov    %edx,0x4(%eax)
  8031dc:	eb 08                	jmp    8031e6 <insert_sorted_with_merge_freeList+0x133>
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8031fd:	40                   	inc    %eax
  8031fe:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803203:	e9 04 06 00 00       	jmp    80380c <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803208:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80320c:	75 17                	jne    803225 <insert_sorted_with_merge_freeList+0x172>
  80320e:	83 ec 04             	sub    $0x4,%esp
  803211:	68 64 43 80 00       	push   $0x804364
  803216:	68 26 01 00 00       	push   $0x126
  80321b:	68 87 43 80 00       	push   $0x804387
  803220:	e8 dc d6 ff ff       	call   800901 <_panic>
  803225:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80322b:	8b 45 08             	mov    0x8(%ebp),%eax
  80322e:	89 10                	mov    %edx,(%eax)
  803230:	8b 45 08             	mov    0x8(%ebp),%eax
  803233:	8b 00                	mov    (%eax),%eax
  803235:	85 c0                	test   %eax,%eax
  803237:	74 0d                	je     803246 <insert_sorted_with_merge_freeList+0x193>
  803239:	a1 38 51 80 00       	mov    0x805138,%eax
  80323e:	8b 55 08             	mov    0x8(%ebp),%edx
  803241:	89 50 04             	mov    %edx,0x4(%eax)
  803244:	eb 08                	jmp    80324e <insert_sorted_with_merge_freeList+0x19b>
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80324e:	8b 45 08             	mov    0x8(%ebp),%eax
  803251:	a3 38 51 80 00       	mov    %eax,0x805138
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803260:	a1 44 51 80 00       	mov    0x805144,%eax
  803265:	40                   	inc    %eax
  803266:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  80326b:	e9 9c 05 00 00       	jmp    80380c <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	8b 50 08             	mov    0x8(%eax),%edx
  803276:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803279:	8b 40 08             	mov    0x8(%eax),%eax
  80327c:	39 c2                	cmp    %eax,%edx
  80327e:	0f 86 16 01 00 00    	jbe    80339a <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803284:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803287:	8b 50 08             	mov    0x8(%eax),%edx
  80328a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80328d:	8b 40 0c             	mov    0xc(%eax),%eax
  803290:	01 c2                	add    %eax,%edx
  803292:	8b 45 08             	mov    0x8(%ebp),%eax
  803295:	8b 40 08             	mov    0x8(%eax),%eax
  803298:	39 c2                	cmp    %eax,%edx
  80329a:	0f 85 92 00 00 00    	jne    803332 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  8032a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ac:	01 c2                	add    %eax,%edx
  8032ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8032b1:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  8032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032be:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c1:	8b 50 08             	mov    0x8(%eax),%edx
  8032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c7:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8032ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ce:	75 17                	jne    8032e7 <insert_sorted_with_merge_freeList+0x234>
  8032d0:	83 ec 04             	sub    $0x4,%esp
  8032d3:	68 64 43 80 00       	push   $0x804364
  8032d8:	68 31 01 00 00       	push   $0x131
  8032dd:	68 87 43 80 00       	push   $0x804387
  8032e2:	e8 1a d6 ff ff       	call   800901 <_panic>
  8032e7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f0:	89 10                	mov    %edx,(%eax)
  8032f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f5:	8b 00                	mov    (%eax),%eax
  8032f7:	85 c0                	test   %eax,%eax
  8032f9:	74 0d                	je     803308 <insert_sorted_with_merge_freeList+0x255>
  8032fb:	a1 48 51 80 00       	mov    0x805148,%eax
  803300:	8b 55 08             	mov    0x8(%ebp),%edx
  803303:	89 50 04             	mov    %edx,0x4(%eax)
  803306:	eb 08                	jmp    803310 <insert_sorted_with_merge_freeList+0x25d>
  803308:	8b 45 08             	mov    0x8(%ebp),%eax
  80330b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803310:	8b 45 08             	mov    0x8(%ebp),%eax
  803313:	a3 48 51 80 00       	mov    %eax,0x805148
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803322:	a1 54 51 80 00       	mov    0x805154,%eax
  803327:	40                   	inc    %eax
  803328:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  80332d:	e9 da 04 00 00       	jmp    80380c <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  803332:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803336:	75 17                	jne    80334f <insert_sorted_with_merge_freeList+0x29c>
  803338:	83 ec 04             	sub    $0x4,%esp
  80333b:	68 0c 44 80 00       	push   $0x80440c
  803340:	68 37 01 00 00       	push   $0x137
  803345:	68 87 43 80 00       	push   $0x804387
  80334a:	e8 b2 d5 ff ff       	call   800901 <_panic>
  80334f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803355:	8b 45 08             	mov    0x8(%ebp),%eax
  803358:	89 50 04             	mov    %edx,0x4(%eax)
  80335b:	8b 45 08             	mov    0x8(%ebp),%eax
  80335e:	8b 40 04             	mov    0x4(%eax),%eax
  803361:	85 c0                	test   %eax,%eax
  803363:	74 0c                	je     803371 <insert_sorted_with_merge_freeList+0x2be>
  803365:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80336a:	8b 55 08             	mov    0x8(%ebp),%edx
  80336d:	89 10                	mov    %edx,(%eax)
  80336f:	eb 08                	jmp    803379 <insert_sorted_with_merge_freeList+0x2c6>
  803371:	8b 45 08             	mov    0x8(%ebp),%eax
  803374:	a3 38 51 80 00       	mov    %eax,0x805138
  803379:	8b 45 08             	mov    0x8(%ebp),%eax
  80337c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80338a:	a1 44 51 80 00       	mov    0x805144,%eax
  80338f:	40                   	inc    %eax
  803390:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803395:	e9 72 04 00 00       	jmp    80380c <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80339a:	a1 38 51 80 00       	mov    0x805138,%eax
  80339f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033a2:	e9 35 04 00 00       	jmp    8037dc <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  8033a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033aa:	8b 00                	mov    (%eax),%eax
  8033ac:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	8b 50 08             	mov    0x8(%eax),%edx
  8033b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b8:	8b 40 08             	mov    0x8(%eax),%eax
  8033bb:	39 c2                	cmp    %eax,%edx
  8033bd:	0f 86 11 04 00 00    	jbe    8037d4 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  8033c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c6:	8b 50 08             	mov    0x8(%eax),%edx
  8033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8033cf:	01 c2                	add    %eax,%edx
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	8b 40 08             	mov    0x8(%eax),%eax
  8033d7:	39 c2                	cmp    %eax,%edx
  8033d9:	0f 83 8b 00 00 00    	jae    80346a <insert_sorted_with_merge_freeList+0x3b7>
  8033df:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e2:	8b 50 08             	mov    0x8(%eax),%edx
  8033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8033eb:	01 c2                	add    %eax,%edx
  8033ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033f0:	8b 40 08             	mov    0x8(%eax),%eax
  8033f3:	39 c2                	cmp    %eax,%edx
  8033f5:	73 73                	jae    80346a <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  8033f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033fb:	74 06                	je     803403 <insert_sorted_with_merge_freeList+0x350>
  8033fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803401:	75 17                	jne    80341a <insert_sorted_with_merge_freeList+0x367>
  803403:	83 ec 04             	sub    $0x4,%esp
  803406:	68 d8 43 80 00       	push   $0x8043d8
  80340b:	68 48 01 00 00       	push   $0x148
  803410:	68 87 43 80 00       	push   $0x804387
  803415:	e8 e7 d4 ff ff       	call   800901 <_panic>
  80341a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341d:	8b 10                	mov    (%eax),%edx
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	89 10                	mov    %edx,(%eax)
  803424:	8b 45 08             	mov    0x8(%ebp),%eax
  803427:	8b 00                	mov    (%eax),%eax
  803429:	85 c0                	test   %eax,%eax
  80342b:	74 0b                	je     803438 <insert_sorted_with_merge_freeList+0x385>
  80342d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803430:	8b 00                	mov    (%eax),%eax
  803432:	8b 55 08             	mov    0x8(%ebp),%edx
  803435:	89 50 04             	mov    %edx,0x4(%eax)
  803438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343b:	8b 55 08             	mov    0x8(%ebp),%edx
  80343e:	89 10                	mov    %edx,(%eax)
  803440:	8b 45 08             	mov    0x8(%ebp),%eax
  803443:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803446:	89 50 04             	mov    %edx,0x4(%eax)
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	8b 00                	mov    (%eax),%eax
  80344e:	85 c0                	test   %eax,%eax
  803450:	75 08                	jne    80345a <insert_sorted_with_merge_freeList+0x3a7>
  803452:	8b 45 08             	mov    0x8(%ebp),%eax
  803455:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80345a:	a1 44 51 80 00       	mov    0x805144,%eax
  80345f:	40                   	inc    %eax
  803460:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  803465:	e9 a2 03 00 00       	jmp    80380c <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80346a:	8b 45 08             	mov    0x8(%ebp),%eax
  80346d:	8b 50 08             	mov    0x8(%eax),%edx
  803470:	8b 45 08             	mov    0x8(%ebp),%eax
  803473:	8b 40 0c             	mov    0xc(%eax),%eax
  803476:	01 c2                	add    %eax,%edx
  803478:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347b:	8b 40 08             	mov    0x8(%eax),%eax
  80347e:	39 c2                	cmp    %eax,%edx
  803480:	0f 83 ae 00 00 00    	jae    803534 <insert_sorted_with_merge_freeList+0x481>
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	8b 50 08             	mov    0x8(%eax),%edx
  80348c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348f:	8b 48 08             	mov    0x8(%eax),%ecx
  803492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803495:	8b 40 0c             	mov    0xc(%eax),%eax
  803498:	01 c8                	add    %ecx,%eax
  80349a:	39 c2                	cmp    %eax,%edx
  80349c:	0f 85 92 00 00 00    	jne    803534 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  8034a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a5:	8b 50 0c             	mov    0xc(%eax),%edx
  8034a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ae:	01 c2                	add    %eax,%edx
  8034b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b3:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	8b 50 08             	mov    0x8(%eax),%edx
  8034c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c9:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8034cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d0:	75 17                	jne    8034e9 <insert_sorted_with_merge_freeList+0x436>
  8034d2:	83 ec 04             	sub    $0x4,%esp
  8034d5:	68 64 43 80 00       	push   $0x804364
  8034da:	68 51 01 00 00       	push   $0x151
  8034df:	68 87 43 80 00       	push   $0x804387
  8034e4:	e8 18 d4 ff ff       	call   800901 <_panic>
  8034e9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f2:	89 10                	mov    %edx,(%eax)
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	8b 00                	mov    (%eax),%eax
  8034f9:	85 c0                	test   %eax,%eax
  8034fb:	74 0d                	je     80350a <insert_sorted_with_merge_freeList+0x457>
  8034fd:	a1 48 51 80 00       	mov    0x805148,%eax
  803502:	8b 55 08             	mov    0x8(%ebp),%edx
  803505:	89 50 04             	mov    %edx,0x4(%eax)
  803508:	eb 08                	jmp    803512 <insert_sorted_with_merge_freeList+0x45f>
  80350a:	8b 45 08             	mov    0x8(%ebp),%eax
  80350d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803512:	8b 45 08             	mov    0x8(%ebp),%eax
  803515:	a3 48 51 80 00       	mov    %eax,0x805148
  80351a:	8b 45 08             	mov    0x8(%ebp),%eax
  80351d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803524:	a1 54 51 80 00       	mov    0x805154,%eax
  803529:	40                   	inc    %eax
  80352a:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  80352f:	e9 d8 02 00 00       	jmp    80380c <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  803534:	8b 45 08             	mov    0x8(%ebp),%eax
  803537:	8b 50 08             	mov    0x8(%eax),%edx
  80353a:	8b 45 08             	mov    0x8(%ebp),%eax
  80353d:	8b 40 0c             	mov    0xc(%eax),%eax
  803540:	01 c2                	add    %eax,%edx
  803542:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803545:	8b 40 08             	mov    0x8(%eax),%eax
  803548:	39 c2                	cmp    %eax,%edx
  80354a:	0f 85 ba 00 00 00    	jne    80360a <insert_sorted_with_merge_freeList+0x557>
  803550:	8b 45 08             	mov    0x8(%ebp),%eax
  803553:	8b 50 08             	mov    0x8(%eax),%edx
  803556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803559:	8b 48 08             	mov    0x8(%eax),%ecx
  80355c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355f:	8b 40 0c             	mov    0xc(%eax),%eax
  803562:	01 c8                	add    %ecx,%eax
  803564:	39 c2                	cmp    %eax,%edx
  803566:	0f 86 9e 00 00 00    	jbe    80360a <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  80356c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80356f:	8b 50 0c             	mov    0xc(%eax),%edx
  803572:	8b 45 08             	mov    0x8(%ebp),%eax
  803575:	8b 40 0c             	mov    0xc(%eax),%eax
  803578:	01 c2                	add    %eax,%edx
  80357a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80357d:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803580:	8b 45 08             	mov    0x8(%ebp),%eax
  803583:	8b 50 08             	mov    0x8(%eax),%edx
  803586:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803589:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  80358c:	8b 45 08             	mov    0x8(%ebp),%eax
  80358f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803596:	8b 45 08             	mov    0x8(%ebp),%eax
  803599:	8b 50 08             	mov    0x8(%eax),%edx
  80359c:	8b 45 08             	mov    0x8(%ebp),%eax
  80359f:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8035a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035a6:	75 17                	jne    8035bf <insert_sorted_with_merge_freeList+0x50c>
  8035a8:	83 ec 04             	sub    $0x4,%esp
  8035ab:	68 64 43 80 00       	push   $0x804364
  8035b0:	68 5b 01 00 00       	push   $0x15b
  8035b5:	68 87 43 80 00       	push   $0x804387
  8035ba:	e8 42 d3 ff ff       	call   800901 <_panic>
  8035bf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c8:	89 10                	mov    %edx,(%eax)
  8035ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cd:	8b 00                	mov    (%eax),%eax
  8035cf:	85 c0                	test   %eax,%eax
  8035d1:	74 0d                	je     8035e0 <insert_sorted_with_merge_freeList+0x52d>
  8035d3:	a1 48 51 80 00       	mov    0x805148,%eax
  8035d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8035db:	89 50 04             	mov    %edx,0x4(%eax)
  8035de:	eb 08                	jmp    8035e8 <insert_sorted_with_merge_freeList+0x535>
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8035f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8035ff:	40                   	inc    %eax
  803600:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803605:	e9 02 02 00 00       	jmp    80380c <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80360a:	8b 45 08             	mov    0x8(%ebp),%eax
  80360d:	8b 50 08             	mov    0x8(%eax),%edx
  803610:	8b 45 08             	mov    0x8(%ebp),%eax
  803613:	8b 40 0c             	mov    0xc(%eax),%eax
  803616:	01 c2                	add    %eax,%edx
  803618:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361b:	8b 40 08             	mov    0x8(%eax),%eax
  80361e:	39 c2                	cmp    %eax,%edx
  803620:	0f 85 ae 01 00 00    	jne    8037d4 <insert_sorted_with_merge_freeList+0x721>
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	8b 50 08             	mov    0x8(%eax),%edx
  80362c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80362f:	8b 48 08             	mov    0x8(%eax),%ecx
  803632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803635:	8b 40 0c             	mov    0xc(%eax),%eax
  803638:	01 c8                	add    %ecx,%eax
  80363a:	39 c2                	cmp    %eax,%edx
  80363c:	0f 85 92 01 00 00    	jne    8037d4 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  803642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803645:	8b 50 0c             	mov    0xc(%eax),%edx
  803648:	8b 45 08             	mov    0x8(%ebp),%eax
  80364b:	8b 40 0c             	mov    0xc(%eax),%eax
  80364e:	01 c2                	add    %eax,%edx
  803650:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803653:	8b 40 0c             	mov    0xc(%eax),%eax
  803656:	01 c2                	add    %eax,%edx
  803658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365b:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  80365e:	8b 45 08             	mov    0x8(%ebp),%eax
  803661:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803668:	8b 45 08             	mov    0x8(%ebp),%eax
  80366b:	8b 50 08             	mov    0x8(%eax),%edx
  80366e:	8b 45 08             	mov    0x8(%ebp),%eax
  803671:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803674:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803677:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80367e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803681:	8b 50 08             	mov    0x8(%eax),%edx
  803684:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803687:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  80368a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80368e:	75 17                	jne    8036a7 <insert_sorted_with_merge_freeList+0x5f4>
  803690:	83 ec 04             	sub    $0x4,%esp
  803693:	68 2f 44 80 00       	push   $0x80442f
  803698:	68 63 01 00 00       	push   $0x163
  80369d:	68 87 43 80 00       	push   $0x804387
  8036a2:	e8 5a d2 ff ff       	call   800901 <_panic>
  8036a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036aa:	8b 00                	mov    (%eax),%eax
  8036ac:	85 c0                	test   %eax,%eax
  8036ae:	74 10                	je     8036c0 <insert_sorted_with_merge_freeList+0x60d>
  8036b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036b3:	8b 00                	mov    (%eax),%eax
  8036b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036b8:	8b 52 04             	mov    0x4(%edx),%edx
  8036bb:	89 50 04             	mov    %edx,0x4(%eax)
  8036be:	eb 0b                	jmp    8036cb <insert_sorted_with_merge_freeList+0x618>
  8036c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c3:	8b 40 04             	mov    0x4(%eax),%eax
  8036c6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ce:	8b 40 04             	mov    0x4(%eax),%eax
  8036d1:	85 c0                	test   %eax,%eax
  8036d3:	74 0f                	je     8036e4 <insert_sorted_with_merge_freeList+0x631>
  8036d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d8:	8b 40 04             	mov    0x4(%eax),%eax
  8036db:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036de:	8b 12                	mov    (%edx),%edx
  8036e0:	89 10                	mov    %edx,(%eax)
  8036e2:	eb 0a                	jmp    8036ee <insert_sorted_with_merge_freeList+0x63b>
  8036e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e7:	8b 00                	mov    (%eax),%eax
  8036e9:	a3 38 51 80 00       	mov    %eax,0x805138
  8036ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803701:	a1 44 51 80 00       	mov    0x805144,%eax
  803706:	48                   	dec    %eax
  803707:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  80370c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803710:	75 17                	jne    803729 <insert_sorted_with_merge_freeList+0x676>
  803712:	83 ec 04             	sub    $0x4,%esp
  803715:	68 64 43 80 00       	push   $0x804364
  80371a:	68 64 01 00 00       	push   $0x164
  80371f:	68 87 43 80 00       	push   $0x804387
  803724:	e8 d8 d1 ff ff       	call   800901 <_panic>
  803729:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80372f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803732:	89 10                	mov    %edx,(%eax)
  803734:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803737:	8b 00                	mov    (%eax),%eax
  803739:	85 c0                	test   %eax,%eax
  80373b:	74 0d                	je     80374a <insert_sorted_with_merge_freeList+0x697>
  80373d:	a1 48 51 80 00       	mov    0x805148,%eax
  803742:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803745:	89 50 04             	mov    %edx,0x4(%eax)
  803748:	eb 08                	jmp    803752 <insert_sorted_with_merge_freeList+0x69f>
  80374a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803755:	a3 48 51 80 00       	mov    %eax,0x805148
  80375a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80375d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803764:	a1 54 51 80 00       	mov    0x805154,%eax
  803769:	40                   	inc    %eax
  80376a:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80376f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803773:	75 17                	jne    80378c <insert_sorted_with_merge_freeList+0x6d9>
  803775:	83 ec 04             	sub    $0x4,%esp
  803778:	68 64 43 80 00       	push   $0x804364
  80377d:	68 65 01 00 00       	push   $0x165
  803782:	68 87 43 80 00       	push   $0x804387
  803787:	e8 75 d1 ff ff       	call   800901 <_panic>
  80378c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803792:	8b 45 08             	mov    0x8(%ebp),%eax
  803795:	89 10                	mov    %edx,(%eax)
  803797:	8b 45 08             	mov    0x8(%ebp),%eax
  80379a:	8b 00                	mov    (%eax),%eax
  80379c:	85 c0                	test   %eax,%eax
  80379e:	74 0d                	je     8037ad <insert_sorted_with_merge_freeList+0x6fa>
  8037a0:	a1 48 51 80 00       	mov    0x805148,%eax
  8037a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8037a8:	89 50 04             	mov    %edx,0x4(%eax)
  8037ab:	eb 08                	jmp    8037b5 <insert_sorted_with_merge_freeList+0x702>
  8037ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b8:	a3 48 51 80 00       	mov    %eax,0x805148
  8037bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037c7:	a1 54 51 80 00       	mov    0x805154,%eax
  8037cc:	40                   	inc    %eax
  8037cd:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8037d2:	eb 38                	jmp    80380c <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8037d4:	a1 40 51 80 00       	mov    0x805140,%eax
  8037d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037e0:	74 07                	je     8037e9 <insert_sorted_with_merge_freeList+0x736>
  8037e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e5:	8b 00                	mov    (%eax),%eax
  8037e7:	eb 05                	jmp    8037ee <insert_sorted_with_merge_freeList+0x73b>
  8037e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037ee:	a3 40 51 80 00       	mov    %eax,0x805140
  8037f3:	a1 40 51 80 00       	mov    0x805140,%eax
  8037f8:	85 c0                	test   %eax,%eax
  8037fa:	0f 85 a7 fb ff ff    	jne    8033a7 <insert_sorted_with_merge_freeList+0x2f4>
  803800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803804:	0f 85 9d fb ff ff    	jne    8033a7 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80380a:	eb 00                	jmp    80380c <insert_sorted_with_merge_freeList+0x759>
  80380c:	90                   	nop
  80380d:	c9                   	leave  
  80380e:	c3                   	ret    
  80380f:	90                   	nop

00803810 <__udivdi3>:
  803810:	55                   	push   %ebp
  803811:	57                   	push   %edi
  803812:	56                   	push   %esi
  803813:	53                   	push   %ebx
  803814:	83 ec 1c             	sub    $0x1c,%esp
  803817:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80381b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80381f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803823:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803827:	89 ca                	mov    %ecx,%edx
  803829:	89 f8                	mov    %edi,%eax
  80382b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80382f:	85 f6                	test   %esi,%esi
  803831:	75 2d                	jne    803860 <__udivdi3+0x50>
  803833:	39 cf                	cmp    %ecx,%edi
  803835:	77 65                	ja     80389c <__udivdi3+0x8c>
  803837:	89 fd                	mov    %edi,%ebp
  803839:	85 ff                	test   %edi,%edi
  80383b:	75 0b                	jne    803848 <__udivdi3+0x38>
  80383d:	b8 01 00 00 00       	mov    $0x1,%eax
  803842:	31 d2                	xor    %edx,%edx
  803844:	f7 f7                	div    %edi
  803846:	89 c5                	mov    %eax,%ebp
  803848:	31 d2                	xor    %edx,%edx
  80384a:	89 c8                	mov    %ecx,%eax
  80384c:	f7 f5                	div    %ebp
  80384e:	89 c1                	mov    %eax,%ecx
  803850:	89 d8                	mov    %ebx,%eax
  803852:	f7 f5                	div    %ebp
  803854:	89 cf                	mov    %ecx,%edi
  803856:	89 fa                	mov    %edi,%edx
  803858:	83 c4 1c             	add    $0x1c,%esp
  80385b:	5b                   	pop    %ebx
  80385c:	5e                   	pop    %esi
  80385d:	5f                   	pop    %edi
  80385e:	5d                   	pop    %ebp
  80385f:	c3                   	ret    
  803860:	39 ce                	cmp    %ecx,%esi
  803862:	77 28                	ja     80388c <__udivdi3+0x7c>
  803864:	0f bd fe             	bsr    %esi,%edi
  803867:	83 f7 1f             	xor    $0x1f,%edi
  80386a:	75 40                	jne    8038ac <__udivdi3+0x9c>
  80386c:	39 ce                	cmp    %ecx,%esi
  80386e:	72 0a                	jb     80387a <__udivdi3+0x6a>
  803870:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803874:	0f 87 9e 00 00 00    	ja     803918 <__udivdi3+0x108>
  80387a:	b8 01 00 00 00       	mov    $0x1,%eax
  80387f:	89 fa                	mov    %edi,%edx
  803881:	83 c4 1c             	add    $0x1c,%esp
  803884:	5b                   	pop    %ebx
  803885:	5e                   	pop    %esi
  803886:	5f                   	pop    %edi
  803887:	5d                   	pop    %ebp
  803888:	c3                   	ret    
  803889:	8d 76 00             	lea    0x0(%esi),%esi
  80388c:	31 ff                	xor    %edi,%edi
  80388e:	31 c0                	xor    %eax,%eax
  803890:	89 fa                	mov    %edi,%edx
  803892:	83 c4 1c             	add    $0x1c,%esp
  803895:	5b                   	pop    %ebx
  803896:	5e                   	pop    %esi
  803897:	5f                   	pop    %edi
  803898:	5d                   	pop    %ebp
  803899:	c3                   	ret    
  80389a:	66 90                	xchg   %ax,%ax
  80389c:	89 d8                	mov    %ebx,%eax
  80389e:	f7 f7                	div    %edi
  8038a0:	31 ff                	xor    %edi,%edi
  8038a2:	89 fa                	mov    %edi,%edx
  8038a4:	83 c4 1c             	add    $0x1c,%esp
  8038a7:	5b                   	pop    %ebx
  8038a8:	5e                   	pop    %esi
  8038a9:	5f                   	pop    %edi
  8038aa:	5d                   	pop    %ebp
  8038ab:	c3                   	ret    
  8038ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038b1:	89 eb                	mov    %ebp,%ebx
  8038b3:	29 fb                	sub    %edi,%ebx
  8038b5:	89 f9                	mov    %edi,%ecx
  8038b7:	d3 e6                	shl    %cl,%esi
  8038b9:	89 c5                	mov    %eax,%ebp
  8038bb:	88 d9                	mov    %bl,%cl
  8038bd:	d3 ed                	shr    %cl,%ebp
  8038bf:	89 e9                	mov    %ebp,%ecx
  8038c1:	09 f1                	or     %esi,%ecx
  8038c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8038c7:	89 f9                	mov    %edi,%ecx
  8038c9:	d3 e0                	shl    %cl,%eax
  8038cb:	89 c5                	mov    %eax,%ebp
  8038cd:	89 d6                	mov    %edx,%esi
  8038cf:	88 d9                	mov    %bl,%cl
  8038d1:	d3 ee                	shr    %cl,%esi
  8038d3:	89 f9                	mov    %edi,%ecx
  8038d5:	d3 e2                	shl    %cl,%edx
  8038d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038db:	88 d9                	mov    %bl,%cl
  8038dd:	d3 e8                	shr    %cl,%eax
  8038df:	09 c2                	or     %eax,%edx
  8038e1:	89 d0                	mov    %edx,%eax
  8038e3:	89 f2                	mov    %esi,%edx
  8038e5:	f7 74 24 0c          	divl   0xc(%esp)
  8038e9:	89 d6                	mov    %edx,%esi
  8038eb:	89 c3                	mov    %eax,%ebx
  8038ed:	f7 e5                	mul    %ebp
  8038ef:	39 d6                	cmp    %edx,%esi
  8038f1:	72 19                	jb     80390c <__udivdi3+0xfc>
  8038f3:	74 0b                	je     803900 <__udivdi3+0xf0>
  8038f5:	89 d8                	mov    %ebx,%eax
  8038f7:	31 ff                	xor    %edi,%edi
  8038f9:	e9 58 ff ff ff       	jmp    803856 <__udivdi3+0x46>
  8038fe:	66 90                	xchg   %ax,%ax
  803900:	8b 54 24 08          	mov    0x8(%esp),%edx
  803904:	89 f9                	mov    %edi,%ecx
  803906:	d3 e2                	shl    %cl,%edx
  803908:	39 c2                	cmp    %eax,%edx
  80390a:	73 e9                	jae    8038f5 <__udivdi3+0xe5>
  80390c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80390f:	31 ff                	xor    %edi,%edi
  803911:	e9 40 ff ff ff       	jmp    803856 <__udivdi3+0x46>
  803916:	66 90                	xchg   %ax,%ax
  803918:	31 c0                	xor    %eax,%eax
  80391a:	e9 37 ff ff ff       	jmp    803856 <__udivdi3+0x46>
  80391f:	90                   	nop

00803920 <__umoddi3>:
  803920:	55                   	push   %ebp
  803921:	57                   	push   %edi
  803922:	56                   	push   %esi
  803923:	53                   	push   %ebx
  803924:	83 ec 1c             	sub    $0x1c,%esp
  803927:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80392b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80392f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803933:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803937:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80393b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80393f:	89 f3                	mov    %esi,%ebx
  803941:	89 fa                	mov    %edi,%edx
  803943:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803947:	89 34 24             	mov    %esi,(%esp)
  80394a:	85 c0                	test   %eax,%eax
  80394c:	75 1a                	jne    803968 <__umoddi3+0x48>
  80394e:	39 f7                	cmp    %esi,%edi
  803950:	0f 86 a2 00 00 00    	jbe    8039f8 <__umoddi3+0xd8>
  803956:	89 c8                	mov    %ecx,%eax
  803958:	89 f2                	mov    %esi,%edx
  80395a:	f7 f7                	div    %edi
  80395c:	89 d0                	mov    %edx,%eax
  80395e:	31 d2                	xor    %edx,%edx
  803960:	83 c4 1c             	add    $0x1c,%esp
  803963:	5b                   	pop    %ebx
  803964:	5e                   	pop    %esi
  803965:	5f                   	pop    %edi
  803966:	5d                   	pop    %ebp
  803967:	c3                   	ret    
  803968:	39 f0                	cmp    %esi,%eax
  80396a:	0f 87 ac 00 00 00    	ja     803a1c <__umoddi3+0xfc>
  803970:	0f bd e8             	bsr    %eax,%ebp
  803973:	83 f5 1f             	xor    $0x1f,%ebp
  803976:	0f 84 ac 00 00 00    	je     803a28 <__umoddi3+0x108>
  80397c:	bf 20 00 00 00       	mov    $0x20,%edi
  803981:	29 ef                	sub    %ebp,%edi
  803983:	89 fe                	mov    %edi,%esi
  803985:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803989:	89 e9                	mov    %ebp,%ecx
  80398b:	d3 e0                	shl    %cl,%eax
  80398d:	89 d7                	mov    %edx,%edi
  80398f:	89 f1                	mov    %esi,%ecx
  803991:	d3 ef                	shr    %cl,%edi
  803993:	09 c7                	or     %eax,%edi
  803995:	89 e9                	mov    %ebp,%ecx
  803997:	d3 e2                	shl    %cl,%edx
  803999:	89 14 24             	mov    %edx,(%esp)
  80399c:	89 d8                	mov    %ebx,%eax
  80399e:	d3 e0                	shl    %cl,%eax
  8039a0:	89 c2                	mov    %eax,%edx
  8039a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039a6:	d3 e0                	shl    %cl,%eax
  8039a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039b0:	89 f1                	mov    %esi,%ecx
  8039b2:	d3 e8                	shr    %cl,%eax
  8039b4:	09 d0                	or     %edx,%eax
  8039b6:	d3 eb                	shr    %cl,%ebx
  8039b8:	89 da                	mov    %ebx,%edx
  8039ba:	f7 f7                	div    %edi
  8039bc:	89 d3                	mov    %edx,%ebx
  8039be:	f7 24 24             	mull   (%esp)
  8039c1:	89 c6                	mov    %eax,%esi
  8039c3:	89 d1                	mov    %edx,%ecx
  8039c5:	39 d3                	cmp    %edx,%ebx
  8039c7:	0f 82 87 00 00 00    	jb     803a54 <__umoddi3+0x134>
  8039cd:	0f 84 91 00 00 00    	je     803a64 <__umoddi3+0x144>
  8039d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039d7:	29 f2                	sub    %esi,%edx
  8039d9:	19 cb                	sbb    %ecx,%ebx
  8039db:	89 d8                	mov    %ebx,%eax
  8039dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039e1:	d3 e0                	shl    %cl,%eax
  8039e3:	89 e9                	mov    %ebp,%ecx
  8039e5:	d3 ea                	shr    %cl,%edx
  8039e7:	09 d0                	or     %edx,%eax
  8039e9:	89 e9                	mov    %ebp,%ecx
  8039eb:	d3 eb                	shr    %cl,%ebx
  8039ed:	89 da                	mov    %ebx,%edx
  8039ef:	83 c4 1c             	add    $0x1c,%esp
  8039f2:	5b                   	pop    %ebx
  8039f3:	5e                   	pop    %esi
  8039f4:	5f                   	pop    %edi
  8039f5:	5d                   	pop    %ebp
  8039f6:	c3                   	ret    
  8039f7:	90                   	nop
  8039f8:	89 fd                	mov    %edi,%ebp
  8039fa:	85 ff                	test   %edi,%edi
  8039fc:	75 0b                	jne    803a09 <__umoddi3+0xe9>
  8039fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803a03:	31 d2                	xor    %edx,%edx
  803a05:	f7 f7                	div    %edi
  803a07:	89 c5                	mov    %eax,%ebp
  803a09:	89 f0                	mov    %esi,%eax
  803a0b:	31 d2                	xor    %edx,%edx
  803a0d:	f7 f5                	div    %ebp
  803a0f:	89 c8                	mov    %ecx,%eax
  803a11:	f7 f5                	div    %ebp
  803a13:	89 d0                	mov    %edx,%eax
  803a15:	e9 44 ff ff ff       	jmp    80395e <__umoddi3+0x3e>
  803a1a:	66 90                	xchg   %ax,%ax
  803a1c:	89 c8                	mov    %ecx,%eax
  803a1e:	89 f2                	mov    %esi,%edx
  803a20:	83 c4 1c             	add    $0x1c,%esp
  803a23:	5b                   	pop    %ebx
  803a24:	5e                   	pop    %esi
  803a25:	5f                   	pop    %edi
  803a26:	5d                   	pop    %ebp
  803a27:	c3                   	ret    
  803a28:	3b 04 24             	cmp    (%esp),%eax
  803a2b:	72 06                	jb     803a33 <__umoddi3+0x113>
  803a2d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a31:	77 0f                	ja     803a42 <__umoddi3+0x122>
  803a33:	89 f2                	mov    %esi,%edx
  803a35:	29 f9                	sub    %edi,%ecx
  803a37:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a3b:	89 14 24             	mov    %edx,(%esp)
  803a3e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a42:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a46:	8b 14 24             	mov    (%esp),%edx
  803a49:	83 c4 1c             	add    $0x1c,%esp
  803a4c:	5b                   	pop    %ebx
  803a4d:	5e                   	pop    %esi
  803a4e:	5f                   	pop    %edi
  803a4f:	5d                   	pop    %ebp
  803a50:	c3                   	ret    
  803a51:	8d 76 00             	lea    0x0(%esi),%esi
  803a54:	2b 04 24             	sub    (%esp),%eax
  803a57:	19 fa                	sbb    %edi,%edx
  803a59:	89 d1                	mov    %edx,%ecx
  803a5b:	89 c6                	mov    %eax,%esi
  803a5d:	e9 71 ff ff ff       	jmp    8039d3 <__umoddi3+0xb3>
  803a62:	66 90                	xchg   %ax,%ax
  803a64:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a68:	72 ea                	jb     803a54 <__umoddi3+0x134>
  803a6a:	89 d9                	mov    %ebx,%ecx
  803a6c:	e9 62 ff ff ff       	jmp    8039d3 <__umoddi3+0xb3>
