
obj/user/ef_mergesort_leakage:     file format elf32-i386


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
  800031:	e8 9a 07 00 00       	call   8007d0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_disable_interrupt();
  80004b:	e8 b7 1f 00 00       	call   802007 <sys_disable_interrupt>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 80 38 80 00       	push   $0x803880
  800058:	e8 63 0b 00 00       	call   800bc0 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 82 38 80 00       	push   $0x803882
  800068:	e8 53 0b 00 00       	call   800bc0 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 98 38 80 00       	push   $0x803898
  800078:	e8 43 0b 00 00       	call   800bc0 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 82 38 80 00       	push   $0x803882
  800088:	e8 33 0b 00 00       	call   800bc0 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 80 38 80 00       	push   $0x803880
  800098:	e8 23 0b 00 00       	call   800bc0 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 b0 38 80 00       	push   $0x8038b0
  8000a8:	e8 13 0b 00 00       	call   800bc0 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		int NumOfElements ;

		if (numOfRep == 1)
  8000b0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8000b4:	75 09                	jne    8000bf <_main+0x87>
			NumOfElements = 32;
  8000b6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  8000bd:	eb 0d                	jmp    8000cc <_main+0x94>
		else if (numOfRep == 2)
  8000bf:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8000c3:	75 07                	jne    8000cc <_main+0x94>
			NumOfElements = 32;
  8000c5:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)

		cprintf("%d\n", NumOfElements) ;
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d2:	68 cf 38 80 00       	push   $0x8038cf
  8000d7:	e8 e4 0a 00 00       	call   800bc0 <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	50                   	push   %eax
  8000e9:	e8 fe 19 00 00       	call   801aec <malloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 d4 38 80 00       	push   $0x8038d4
  8000fc:	e8 bf 0a 00 00       	call   800bc0 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 f6 38 80 00       	push   $0x8038f6
  80010c:	e8 af 0a 00 00       	call   800bc0 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 04 39 80 00       	push   $0x803904
  80011c:	e8 9f 0a 00 00       	call   800bc0 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 13 39 80 00       	push   $0x803913
  80012c:	e8 8f 0a 00 00       	call   800bc0 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 23 39 80 00       	push   $0x803923
  80013c:	e8 7f 0a 00 00       	call   800bc0 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  800144:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800148:	75 06                	jne    800150 <_main+0x118>
				Chose = 'a' ;
  80014a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  80014e:	eb 0a                	jmp    80015a <_main+0x122>
			else if (numOfRep == 2)
  800150:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800154:	75 04                	jne    80015a <_main+0x122>
				Chose = 'c' ;
  800156:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80015a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	50                   	push   %eax
  800162:	e8 c9 05 00 00       	call   800730 <cputchar>
  800167:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 0a                	push   $0xa
  80016f:	e8 bc 05 00 00       	call   800730 <cputchar>
  800174:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800177:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80017b:	74 0c                	je     800189 <_main+0x151>
  80017d:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800181:	74 06                	je     800189 <_main+0x151>
  800183:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800187:	75 ab                	jne    800134 <_main+0xfc>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800189:	e8 93 1e 00 00       	call   802021 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80018e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800192:	83 f8 62             	cmp    $0x62,%eax
  800195:	74 1d                	je     8001b4 <_main+0x17c>
  800197:	83 f8 63             	cmp    $0x63,%eax
  80019a:	74 2b                	je     8001c7 <_main+0x18f>
  80019c:	83 f8 61             	cmp    $0x61,%eax
  80019f:	75 39                	jne    8001da <_main+0x1a2>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 f4 01 00 00       	call   8003a3 <InitializeAscending>
  8001af:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b2:	eb 37                	jmp    8001eb <_main+0x1b3>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bd:	e8 12 02 00 00       	call   8003d4 <InitializeDescending>
  8001c2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c5:	eb 24                	jmp    8001eb <_main+0x1b3>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d0:	e8 34 02 00 00       	call   800409 <InitializeSemiRandom>
  8001d5:	83 c4 10             	add    $0x10,%esp
			break ;
  8001d8:	eb 11                	jmp    8001eb <_main+0x1b3>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e3:	e8 21 02 00 00       	call   800409 <InitializeSemiRandom>
  8001e8:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f1:	6a 01                	push   $0x1
  8001f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f6:	e8 e0 02 00 00       	call   8004db <MSort>
  8001fb:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001fe:	e8 04 1e 00 00       	call   802007 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 2c 39 80 00       	push   $0x80392c
  80020b:	e8 b0 09 00 00       	call   800bc0 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  800213:	e8 09 1e 00 00       	call   802021 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 ec             	pushl  -0x14(%ebp)
  80021e:	ff 75 e8             	pushl  -0x18(%ebp)
  800221:	e8 d3 00 00 00       	call   8002f9 <CheckSorted>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  80022c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800230:	75 14                	jne    800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 60 39 80 00       	push   $0x803960
  80023a:	6a 58                	push   $0x58
  80023c:	68 82 39 80 00       	push   $0x803982
  800241:	e8 c6 06 00 00       	call   80090c <_panic>
		else
		{
			sys_disable_interrupt();
  800246:	e8 bc 1d 00 00       	call   802007 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 a0 39 80 00       	push   $0x8039a0
  800253:	e8 68 09 00 00       	call   800bc0 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 d4 39 80 00       	push   $0x8039d4
  800263:	e8 58 09 00 00       	call   800bc0 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 08 3a 80 00       	push   $0x803a08
  800273:	e8 48 09 00 00       	call   800bc0 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80027b:	e8 a1 1d 00 00       	call   802021 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800280:	e8 82 1d 00 00       	call   802007 <sys_disable_interrupt>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 3a 3a 80 00       	push   $0x803a3a
  800293:	e8 28 09 00 00       	call   800bc0 <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  80029b:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80029f:	75 06                	jne    8002a7 <_main+0x26f>
				Chose = 'y' ;
  8002a1:	c6 45 f7 79          	movb   $0x79,-0x9(%ebp)
  8002a5:	eb 0a                	jmp    8002b1 <_main+0x279>
			else if (numOfRep == 2)
  8002a7:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ab:	75 04                	jne    8002b1 <_main+0x279>
				Chose = 'n' ;
  8002ad:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  8002b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 72 04 00 00       	call   800730 <cputchar>
  8002be:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 0a                	push   $0xa
  8002c6:	e8 65 04 00 00       	call   800730 <cputchar>
  8002cb:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 0a                	push   $0xa
  8002d3:	e8 58 04 00 00       	call   800730 <cputchar>
  8002d8:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  8002db:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002df:	74 06                	je     8002e7 <_main+0x2af>
  8002e1:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002e5:	75 a4                	jne    80028b <_main+0x253>
				Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_enable_interrupt();
  8002e7:	e8 35 1d 00 00       	call   802021 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002ec:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002f0:	0f 84 52 fd ff ff    	je     800048 <_main+0x10>
}
  8002f6:	90                   	nop
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

008002f9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800306:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80030d:	eb 33                	jmp    800342 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80030f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800323:	40                   	inc    %eax
  800324:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 c8                	add    %ecx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	39 c2                	cmp    %eax,%edx
  800334:	7e 09                	jle    80033f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800336:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80033d:	eb 0c                	jmp    80034b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80033f:	ff 45 f8             	incl   -0x8(%ebp)
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
  800345:	48                   	dec    %eax
  800346:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800349:	7f c4                	jg     80030f <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80034b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800356:	8b 45 0c             	mov    0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 00                	mov    (%eax),%eax
  800367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80036a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	01 c2                	add    %eax,%edx
  800379:	8b 45 10             	mov    0x10(%ebp),%eax
  80037c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	01 c8                	add    %ecx,%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80038c:	8b 45 10             	mov    0x10(%ebp),%eax
  80038f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	01 c2                	add    %eax,%edx
  80039b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039e:	89 02                	mov    %eax,(%edx)
}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 17                	jmp    8003c9 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c e1                	jl     8003b2 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e1:	eb 1b                	jmp    8003fe <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 c2                	add    %eax,%edx
  8003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f5:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003f8:	48                   	dec    %eax
  8003f9:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003fb:	ff 45 fc             	incl   -0x4(%ebp)
  8003fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800401:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800404:	7c dd                	jl     8003e3 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800406:	90                   	nop
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80040f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800412:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800417:	f7 e9                	imul   %ecx
  800419:	c1 f9 1f             	sar    $0x1f,%ecx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	29 c8                	sub    %ecx,%eax
  800420:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800423:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80042a:	eb 1e                	jmp    80044a <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80042c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80043c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043f:	99                   	cltd   
  800440:	f7 7d f8             	idivl  -0x8(%ebp)
  800443:	89 d0                	mov    %edx,%eax
  800445:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800447:	ff 45 fc             	incl   -0x4(%ebp)
  80044a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800450:	7c da                	jl     80042c <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800452:	90                   	nop
  800453:	c9                   	leave  
  800454:	c3                   	ret    

00800455 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800455:	55                   	push   %ebp
  800456:	89 e5                	mov    %esp,%ebp
  800458:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80045b:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800469:	eb 42                	jmp    8004ad <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80046b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046e:	99                   	cltd   
  80046f:	f7 7d f0             	idivl  -0x10(%ebp)
  800472:	89 d0                	mov    %edx,%eax
  800474:	85 c0                	test   %eax,%eax
  800476:	75 10                	jne    800488 <PrintElements+0x33>
			cprintf("\n");
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	68 80 38 80 00       	push   $0x803880
  800480:	e8 3b 07 00 00       	call   800bc0 <cprintf>
  800485:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	01 d0                	add    %edx,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	50                   	push   %eax
  80049d:	68 58 3a 80 00       	push   $0x803a58
  8004a2:	e8 19 07 00 00       	call   800bc0 <cprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004aa:	ff 45 f4             	incl   -0xc(%ebp)
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	48                   	dec    %eax
  8004b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004b4:	7f b5                	jg     80046b <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8004b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	01 d0                	add    %edx,%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	50                   	push   %eax
  8004cb:	68 cf 38 80 00       	push   $0x8038cf
  8004d0:	e8 eb 06 00 00       	call   800bc0 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

}
  8004d8:	90                   	nop
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <MSort>:


void MSort(int* A, int p, int r)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004e7:	7d 54                	jge    80053d <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	89 c2                	mov    %eax,%edx
  8004f3:	c1 ea 1f             	shr    $0x1f,%edx
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	d1 f8                	sar    %eax
  8004fa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	ff 75 f4             	pushl  -0xc(%ebp)
  800503:	ff 75 0c             	pushl  0xc(%ebp)
  800506:	ff 75 08             	pushl  0x8(%ebp)
  800509:	e8 cd ff ff ff       	call   8004db <MSort>
  80050e:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  800511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800514:	40                   	inc    %eax
  800515:	83 ec 04             	sub    $0x4,%esp
  800518:	ff 75 10             	pushl  0x10(%ebp)
  80051b:	50                   	push   %eax
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	e8 b7 ff ff ff       	call   8004db <MSort>
  800524:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800527:	ff 75 10             	pushl  0x10(%ebp)
  80052a:	ff 75 f4             	pushl  -0xc(%ebp)
  80052d:	ff 75 0c             	pushl  0xc(%ebp)
  800530:	ff 75 08             	pushl  0x8(%ebp)
  800533:	e8 08 00 00 00       	call   800540 <Merge>
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	eb 01                	jmp    80053e <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80053d:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800546:	8b 45 10             	mov    0x10(%ebp),%eax
  800549:	2b 45 0c             	sub    0xc(%ebp),%eax
  80054c:	40                   	inc    %eax
  80054d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	2b 45 10             	sub    0x10(%ebp),%eax
  800556:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800559:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056a:	c1 e0 02             	shl    $0x2,%eax
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	50                   	push   %eax
  800571:	e8 76 15 00 00       	call   801aec <malloc>
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80057c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80057f:	c1 e0 02             	shl    $0x2,%eax
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	50                   	push   %eax
  800586:	e8 61 15 00 00       	call   801aec <malloc>
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800598:	eb 2f                	jmp    8005c9 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  80059a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a7:	01 c2                	add    %eax,%edx
  8005a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005af:	01 c8                	add    %ecx,%eax
  8005b1:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	01 c8                	add    %ecx,%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005c6:	ff 45 ec             	incl   -0x14(%ebp)
  8005c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005cf:	7c c9                	jl     80059a <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005d8:	eb 2a                	jmp    800604 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005e7:	01 c2                	add    %eax,%edx
  8005e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ef:	01 c8                	add    %ecx,%eax
  8005f1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	01 c8                	add    %ecx,%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800601:	ff 45 e8             	incl   -0x18(%ebp)
  800604:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800607:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80060a:	7c ce                	jl     8005da <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800612:	e9 0a 01 00 00       	jmp    800721 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80061a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80061d:	0f 8d 95 00 00 00    	jge    8006b8 <Merge+0x178>
  800623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800626:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800629:	0f 8d 89 00 00 00    	jge    8006b8 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80062f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800632:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800639:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063c:	01 d0                	add    %edx,%eax
  80063e:	8b 10                	mov    (%eax),%edx
  800640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800643:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80064a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064d:	01 c8                	add    %ecx,%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	39 c2                	cmp    %eax,%edx
  800653:	7d 33                	jge    800688 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800658:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066d:	8d 50 01             	lea    0x1(%eax),%edx
  800670:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800673:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80067d:	01 d0                	add    %edx,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800683:	e9 96 00 00 00       	jmp    80071e <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068b:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80069d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a0:	8d 50 01             	lea    0x1(%eax),%edx
  8006a3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8006b6:	eb 66                	jmp    80071e <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8006b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006be:	7d 30                	jge    8006f0 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8006c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d8:	8d 50 01             	lea    0x1(%eax),%edx
  8006db:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 01                	mov    %eax,(%ecx)
  8006ee:	eb 2e                	jmp    80071e <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8d 50 01             	lea    0x1(%eax),%edx
  80070b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80070e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800715:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800718:	01 d0                	add    %edx,%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80071e:	ff 45 e4             	incl   -0x1c(%ebp)
  800721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800724:	3b 45 14             	cmp    0x14(%ebp),%eax
  800727:	0f 8e ea fe ff ff    	jle    800617 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  80072d:	90                   	nop
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80073c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 f2 18 00 00       	call   80203b <sys_cputc>
  800749:	83 c4 10             	add    $0x10,%esp
}
  80074c:	90                   	nop
  80074d:	c9                   	leave  
  80074e:	c3                   	ret    

0080074f <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800755:	e8 ad 18 00 00       	call   802007 <sys_disable_interrupt>
	char c = ch;
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800760:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800764:	83 ec 0c             	sub    $0xc,%esp
  800767:	50                   	push   %eax
  800768:	e8 ce 18 00 00       	call   80203b <sys_cputc>
  80076d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800770:	e8 ac 18 00 00       	call   802021 <sys_enable_interrupt>
}
  800775:	90                   	nop
  800776:	c9                   	leave  
  800777:	c3                   	ret    

00800778 <getchar>:

int
getchar(void)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80077e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800785:	eb 08                	jmp    80078f <getchar+0x17>
	{
		c = sys_cgetc();
  800787:	e8 f6 16 00 00       	call   801e82 <sys_cgetc>
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80078f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800793:	74 f2                	je     800787 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800795:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <atomic_getchar>:

int
atomic_getchar(void)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a0:	e8 62 18 00 00       	call   802007 <sys_disable_interrupt>
	int c=0;
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007ac:	eb 08                	jmp    8007b6 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007ae:	e8 cf 16 00 00       	call   801e82 <sys_cgetc>
  8007b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007ba:	74 f2                	je     8007ae <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007bc:	e8 60 18 00 00       	call   802021 <sys_enable_interrupt>
	return c;
  8007c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <iscons>:

int iscons(int fdnum)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007d6:	e8 1f 1a 00 00       	call   8021fa <sys_getenvindex>
  8007db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e1:	89 d0                	mov    %edx,%eax
  8007e3:	c1 e0 03             	shl    $0x3,%eax
  8007e6:	01 d0                	add    %edx,%eax
  8007e8:	01 c0                	add    %eax,%eax
  8007ea:	01 d0                	add    %edx,%eax
  8007ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007f3:	01 d0                	add    %edx,%eax
  8007f5:	c1 e0 04             	shl    $0x4,%eax
  8007f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007fd:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800802:	a1 24 50 80 00       	mov    0x805024,%eax
  800807:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80080d:	84 c0                	test   %al,%al
  80080f:	74 0f                	je     800820 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800811:	a1 24 50 80 00       	mov    0x805024,%eax
  800816:	05 5c 05 00 00       	add    $0x55c,%eax
  80081b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800820:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800824:	7e 0a                	jle    800830 <libmain+0x60>
		binaryname = argv[0];
  800826:	8b 45 0c             	mov    0xc(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 08             	pushl  0x8(%ebp)
  800839:	e8 fa f7 ff ff       	call   800038 <_main>
  80083e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800841:	e8 c1 17 00 00       	call   802007 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	68 78 3a 80 00       	push   $0x803a78
  80084e:	e8 6d 03 00 00       	call   800bc0 <cprintf>
  800853:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800861:	a1 24 50 80 00       	mov    0x805024,%eax
  800866:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	52                   	push   %edx
  800870:	50                   	push   %eax
  800871:	68 a0 3a 80 00       	push   $0x803aa0
  800876:	e8 45 03 00 00       	call   800bc0 <cprintf>
  80087b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800894:	a1 24 50 80 00       	mov    0x805024,%eax
  800899:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80089f:	51                   	push   %ecx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	68 c8 3a 80 00       	push   $0x803ac8
  8008a7:	e8 14 03 00 00       	call   800bc0 <cprintf>
  8008ac:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008af:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 20 3b 80 00       	push   $0x803b20
  8008c3:	e8 f8 02 00 00       	call   800bc0 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008cb:	83 ec 0c             	sub    $0xc,%esp
  8008ce:	68 78 3a 80 00       	push   $0x803a78
  8008d3:	e8 e8 02 00 00       	call   800bc0 <cprintf>
  8008d8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008db:	e8 41 17 00 00       	call   802021 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008e0:	e8 19 00 00 00       	call   8008fe <exit>
}
  8008e5:	90                   	nop
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008ee:	83 ec 0c             	sub    $0xc,%esp
  8008f1:	6a 00                	push   $0x0
  8008f3:	e8 ce 18 00 00       	call   8021c6 <sys_destroy_env>
  8008f8:	83 c4 10             	add    $0x10,%esp
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <exit>:

void
exit(void)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800904:	e8 23 19 00 00       	call   80222c <sys_exit_env>
}
  800909:	90                   	nop
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800912:	8d 45 10             	lea    0x10(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80091b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800920:	85 c0                	test   %eax,%eax
  800922:	74 16                	je     80093a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800924:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	50                   	push   %eax
  80092d:	68 34 3b 80 00       	push   $0x803b34
  800932:	e8 89 02 00 00       	call   800bc0 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80093a:	a1 00 50 80 00       	mov    0x805000,%eax
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	50                   	push   %eax
  800946:	68 39 3b 80 00       	push   $0x803b39
  80094b:	e8 70 02 00 00       	call   800bc0 <cprintf>
  800950:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800953:	8b 45 10             	mov    0x10(%ebp),%eax
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	50                   	push   %eax
  80095d:	e8 f3 01 00 00       	call   800b55 <vcprintf>
  800962:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	6a 00                	push   $0x0
  80096a:	68 55 3b 80 00       	push   $0x803b55
  80096f:	e8 e1 01 00 00       	call   800b55 <vcprintf>
  800974:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800977:	e8 82 ff ff ff       	call   8008fe <exit>

	// should not return here
	while (1) ;
  80097c:	eb fe                	jmp    80097c <_panic+0x70>

0080097e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800984:	a1 24 50 80 00       	mov    0x805024,%eax
  800989:	8b 50 74             	mov    0x74(%eax),%edx
  80098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098f:	39 c2                	cmp    %eax,%edx
  800991:	74 14                	je     8009a7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800993:	83 ec 04             	sub    $0x4,%esp
  800996:	68 58 3b 80 00       	push   $0x803b58
  80099b:	6a 26                	push   $0x26
  80099d:	68 a4 3b 80 00       	push   $0x803ba4
  8009a2:	e8 65 ff ff ff       	call   80090c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b5:	e9 c2 00 00 00       	jmp    800a7c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	75 08                	jne    8009d7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009cf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009d2:	e9 a2 00 00 00       	jmp    800a79 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009e5:	eb 69                	jmp    800a50 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009e7:	a1 24 50 80 00       	mov    0x805024,%eax
  8009ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f5:	89 d0                	mov    %edx,%eax
  8009f7:	01 c0                	add    %eax,%eax
  8009f9:	01 d0                	add    %edx,%eax
  8009fb:	c1 e0 03             	shl    $0x3,%eax
  8009fe:	01 c8                	add    %ecx,%eax
  800a00:	8a 40 04             	mov    0x4(%eax),%al
  800a03:	84 c0                	test   %al,%al
  800a05:	75 46                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a07:	a1 24 50 80 00       	mov    0x805024,%eax
  800a0c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a15:	89 d0                	mov    %edx,%eax
  800a17:	01 c0                	add    %eax,%eax
  800a19:	01 d0                	add    %edx,%eax
  800a1b:	c1 e0 03             	shl    $0x3,%eax
  800a1e:	01 c8                	add    %ecx,%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a2d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	01 c8                	add    %ecx,%eax
  800a3e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a40:	39 c2                	cmp    %eax,%edx
  800a42:	75 09                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a44:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a4b:	eb 12                	jmp    800a5f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4d:	ff 45 e8             	incl   -0x18(%ebp)
  800a50:	a1 24 50 80 00       	mov    0x805024,%eax
  800a55:	8b 50 74             	mov    0x74(%eax),%edx
  800a58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a5b:	39 c2                	cmp    %eax,%edx
  800a5d:	77 88                	ja     8009e7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a63:	75 14                	jne    800a79 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a65:	83 ec 04             	sub    $0x4,%esp
  800a68:	68 b0 3b 80 00       	push   $0x803bb0
  800a6d:	6a 3a                	push   $0x3a
  800a6f:	68 a4 3b 80 00       	push   $0x803ba4
  800a74:	e8 93 fe ff ff       	call   80090c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a79:	ff 45 f0             	incl   -0x10(%ebp)
  800a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a82:	0f 8c 32 ff ff ff    	jl     8009ba <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a96:	eb 26                	jmp    800abe <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a98:	a1 24 50 80 00       	mov    0x805024,%eax
  800a9d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	01 c0                	add    %eax,%eax
  800aaa:	01 d0                	add    %edx,%eax
  800aac:	c1 e0 03             	shl    $0x3,%eax
  800aaf:	01 c8                	add    %ecx,%eax
  800ab1:	8a 40 04             	mov    0x4(%eax),%al
  800ab4:	3c 01                	cmp    $0x1,%al
  800ab6:	75 03                	jne    800abb <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ab8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800abb:	ff 45 e0             	incl   -0x20(%ebp)
  800abe:	a1 24 50 80 00       	mov    0x805024,%eax
  800ac3:	8b 50 74             	mov    0x74(%eax),%edx
  800ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	77 cb                	ja     800a98 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ad3:	74 14                	je     800ae9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ad5:	83 ec 04             	sub    $0x4,%esp
  800ad8:	68 04 3c 80 00       	push   $0x803c04
  800add:	6a 44                	push   $0x44
  800adf:	68 a4 3b 80 00       	push   $0x803ba4
  800ae4:	e8 23 fe ff ff       	call   80090c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ae9:	90                   	nop
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 48 01             	lea    0x1(%eax),%ecx
  800afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afd:	89 0a                	mov    %ecx,(%edx)
  800aff:	8b 55 08             	mov    0x8(%ebp),%edx
  800b02:	88 d1                	mov    %dl,%cl
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b07:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8b 00                	mov    (%eax),%eax
  800b10:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b15:	75 2c                	jne    800b43 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b17:	a0 28 50 80 00       	mov    0x805028,%al
  800b1c:	0f b6 c0             	movzbl %al,%eax
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b22:	8b 12                	mov    (%edx),%edx
  800b24:	89 d1                	mov    %edx,%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	83 c2 08             	add    $0x8,%edx
  800b2c:	83 ec 04             	sub    $0x4,%esp
  800b2f:	50                   	push   %eax
  800b30:	51                   	push   %ecx
  800b31:	52                   	push   %edx
  800b32:	e8 22 13 00 00       	call   801e59 <sys_cputs>
  800b37:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8b 40 04             	mov    0x4(%eax),%eax
  800b49:	8d 50 01             	lea    0x1(%eax),%edx
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b52:	90                   	nop
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b5e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b65:	00 00 00 
	b.cnt = 0;
  800b68:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b6f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b7e:	50                   	push   %eax
  800b7f:	68 ec 0a 80 00       	push   $0x800aec
  800b84:	e8 11 02 00 00       	call   800d9a <vprintfmt>
  800b89:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b8c:	a0 28 50 80 00       	mov    0x805028,%al
  800b91:	0f b6 c0             	movzbl %al,%eax
  800b94:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b9a:	83 ec 04             	sub    $0x4,%esp
  800b9d:	50                   	push   %eax
  800b9e:	52                   	push   %edx
  800b9f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ba5:	83 c0 08             	add    $0x8,%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 ab 12 00 00       	call   801e59 <sys_cputs>
  800bae:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bb1:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bb8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bc6:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bcd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	e8 73 ff ff ff       	call   800b55 <vcprintf>
  800be2:	83 c4 10             	add    $0x10,%esp
  800be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bf3:	e8 0f 14 00 00       	call   802007 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bf8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 f4             	pushl  -0xc(%ebp)
  800c07:	50                   	push   %eax
  800c08:	e8 48 ff ff ff       	call   800b55 <vcprintf>
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c13:	e8 09 14 00 00       	call   802021 <sys_enable_interrupt>
	return cnt;
  800c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	53                   	push   %ebx
  800c21:	83 ec 14             	sub    $0x14,%esp
  800c24:	8b 45 10             	mov    0x10(%ebp),%eax
  800c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c30:	8b 45 18             	mov    0x18(%ebp),%eax
  800c33:	ba 00 00 00 00       	mov    $0x0,%edx
  800c38:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c3b:	77 55                	ja     800c92 <printnum+0x75>
  800c3d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c40:	72 05                	jb     800c47 <printnum+0x2a>
  800c42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c45:	77 4b                	ja     800c92 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c47:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c4a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c4d:	8b 45 18             	mov    0x18(%ebp),%eax
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	52                   	push   %edx
  800c56:	50                   	push   %eax
  800c57:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5a:	ff 75 f0             	pushl  -0x10(%ebp)
  800c5d:	e8 b2 29 00 00       	call   803614 <__udivdi3>
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	83 ec 04             	sub    $0x4,%esp
  800c68:	ff 75 20             	pushl  0x20(%ebp)
  800c6b:	53                   	push   %ebx
  800c6c:	ff 75 18             	pushl  0x18(%ebp)
  800c6f:	52                   	push   %edx
  800c70:	50                   	push   %eax
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	ff 75 08             	pushl  0x8(%ebp)
  800c77:	e8 a1 ff ff ff       	call   800c1d <printnum>
  800c7c:	83 c4 20             	add    $0x20,%esp
  800c7f:	eb 1a                	jmp    800c9b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c81:	83 ec 08             	sub    $0x8,%esp
  800c84:	ff 75 0c             	pushl  0xc(%ebp)
  800c87:	ff 75 20             	pushl  0x20(%ebp)
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	ff d0                	call   *%eax
  800c8f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c92:	ff 4d 1c             	decl   0x1c(%ebp)
  800c95:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c99:	7f e6                	jg     800c81 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c9b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca9:	53                   	push   %ebx
  800caa:	51                   	push   %ecx
  800cab:	52                   	push   %edx
  800cac:	50                   	push   %eax
  800cad:	e8 72 2a 00 00       	call   803724 <__umoddi3>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	05 74 3e 80 00       	add    $0x803e74,%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	0f be c0             	movsbl %al,%eax
  800cbf:	83 ec 08             	sub    $0x8,%esp
  800cc2:	ff 75 0c             	pushl  0xc(%ebp)
  800cc5:	50                   	push   %eax
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	ff d0                	call   *%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
}
  800cce:	90                   	nop
  800ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cdb:	7e 1c                	jle    800cf9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	8d 50 08             	lea    0x8(%eax),%edx
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 10                	mov    %edx,(%eax)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	83 e8 08             	sub    $0x8,%eax
  800cf2:	8b 50 04             	mov    0x4(%eax),%edx
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	eb 40                	jmp    800d39 <getuint+0x65>
	else if (lflag)
  800cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfd:	74 1e                	je     800d1d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	8d 50 04             	lea    0x4(%eax),%edx
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 10                	mov    %edx,(%eax)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	83 e8 04             	sub    $0x4,%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1b:	eb 1c                	jmp    800d39 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8b 00                	mov    (%eax),%eax
  800d22:	8d 50 04             	lea    0x4(%eax),%edx
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	89 10                	mov    %edx,(%eax)
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8b 00                	mov    (%eax),%eax
  800d2f:	83 e8 04             	sub    $0x4,%eax
  800d32:	8b 00                	mov    (%eax),%eax
  800d34:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d3e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d42:	7e 1c                	jle    800d60 <getint+0x25>
		return va_arg(*ap, long long);
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 00                	mov    (%eax),%eax
  800d49:	8d 50 08             	lea    0x8(%eax),%edx
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 10                	mov    %edx,(%eax)
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	83 e8 08             	sub    $0x8,%eax
  800d59:	8b 50 04             	mov    0x4(%eax),%edx
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	eb 38                	jmp    800d98 <getint+0x5d>
	else if (lflag)
  800d60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d64:	74 1a                	je     800d80 <getint+0x45>
		return va_arg(*ap, long);
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8b 00                	mov    (%eax),%eax
  800d6b:	8d 50 04             	lea    0x4(%eax),%edx
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	89 10                	mov    %edx,(%eax)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	83 e8 04             	sub    $0x4,%eax
  800d7b:	8b 00                	mov    (%eax),%eax
  800d7d:	99                   	cltd   
  800d7e:	eb 18                	jmp    800d98 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	8d 50 04             	lea    0x4(%eax),%edx
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 10                	mov    %edx,(%eax)
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8b 00                	mov    (%eax),%eax
  800d92:	83 e8 04             	sub    $0x4,%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	99                   	cltd   
}
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	eb 17                	jmp    800dbb <vprintfmt+0x21>
			if (ch == '\0')
  800da4:	85 db                	test   %ebx,%ebx
  800da6:	0f 84 af 03 00 00    	je     80115b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800dac:	83 ec 08             	sub    $0x8,%esp
  800daf:	ff 75 0c             	pushl  0xc(%ebp)
  800db2:	53                   	push   %ebx
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	ff d0                	call   *%eax
  800db8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbe:	8d 50 01             	lea    0x1(%eax),%edx
  800dc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	0f b6 d8             	movzbl %al,%ebx
  800dc9:	83 fb 25             	cmp    $0x25,%ebx
  800dcc:	75 d6                	jne    800da4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dce:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dd2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dd9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800de0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800de7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 10             	mov    %edx,0x10(%ebp)
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d8             	movzbl %al,%ebx
  800dfc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dff:	83 f8 55             	cmp    $0x55,%eax
  800e02:	0f 87 2b 03 00 00    	ja     801133 <vprintfmt+0x399>
  800e08:	8b 04 85 98 3e 80 00 	mov    0x803e98(,%eax,4),%eax
  800e0f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e11:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e15:	eb d7                	jmp    800dee <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e17:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e1b:	eb d1                	jmp    800dee <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e1d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e27:	89 d0                	mov    %edx,%eax
  800e29:	c1 e0 02             	shl    $0x2,%eax
  800e2c:	01 d0                	add    %edx,%eax
  800e2e:	01 c0                	add    %eax,%eax
  800e30:	01 d8                	add    %ebx,%eax
  800e32:	83 e8 30             	sub    $0x30,%eax
  800e35:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e40:	83 fb 2f             	cmp    $0x2f,%ebx
  800e43:	7e 3e                	jle    800e83 <vprintfmt+0xe9>
  800e45:	83 fb 39             	cmp    $0x39,%ebx
  800e48:	7f 39                	jg     800e83 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e4a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e4d:	eb d5                	jmp    800e24 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e52:	83 c0 04             	add    $0x4,%eax
  800e55:	89 45 14             	mov    %eax,0x14(%ebp)
  800e58:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5b:	83 e8 04             	sub    $0x4,%eax
  800e5e:	8b 00                	mov    (%eax),%eax
  800e60:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e63:	eb 1f                	jmp    800e84 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e69:	79 83                	jns    800dee <vprintfmt+0x54>
				width = 0;
  800e6b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e72:	e9 77 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e77:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e7e:	e9 6b ff ff ff       	jmp    800dee <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e83:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e88:	0f 89 60 ff ff ff    	jns    800dee <vprintfmt+0x54>
				width = precision, precision = -1;
  800e8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e94:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e9b:	e9 4e ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ea0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ea3:	e9 46 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ea8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eab:	83 c0 04             	add    $0x4,%eax
  800eae:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb4:	83 e8 04             	sub    $0x4,%eax
  800eb7:	8b 00                	mov    (%eax),%eax
  800eb9:	83 ec 08             	sub    $0x8,%esp
  800ebc:	ff 75 0c             	pushl  0xc(%ebp)
  800ebf:	50                   	push   %eax
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	ff d0                	call   *%eax
  800ec5:	83 c4 10             	add    $0x10,%esp
			break;
  800ec8:	e9 89 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ecd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed0:	83 c0 04             	add    $0x4,%eax
  800ed3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed9:	83 e8 04             	sub    $0x4,%eax
  800edc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ede:	85 db                	test   %ebx,%ebx
  800ee0:	79 02                	jns    800ee4 <vprintfmt+0x14a>
				err = -err;
  800ee2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ee4:	83 fb 64             	cmp    $0x64,%ebx
  800ee7:	7f 0b                	jg     800ef4 <vprintfmt+0x15a>
  800ee9:	8b 34 9d e0 3c 80 00 	mov    0x803ce0(,%ebx,4),%esi
  800ef0:	85 f6                	test   %esi,%esi
  800ef2:	75 19                	jne    800f0d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ef4:	53                   	push   %ebx
  800ef5:	68 85 3e 80 00       	push   $0x803e85
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 5e 02 00 00       	call   801163 <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f08:	e9 49 02 00 00       	jmp    801156 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f0d:	56                   	push   %esi
  800f0e:	68 8e 3e 80 00       	push   $0x803e8e
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	ff 75 08             	pushl  0x8(%ebp)
  800f19:	e8 45 02 00 00       	call   801163 <printfmt>
  800f1e:	83 c4 10             	add    $0x10,%esp
			break;
  800f21:	e9 30 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f26:	8b 45 14             	mov    0x14(%ebp),%eax
  800f29:	83 c0 04             	add    $0x4,%eax
  800f2c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f32:	83 e8 04             	sub    $0x4,%eax
  800f35:	8b 30                	mov    (%eax),%esi
  800f37:	85 f6                	test   %esi,%esi
  800f39:	75 05                	jne    800f40 <vprintfmt+0x1a6>
				p = "(null)";
  800f3b:	be 91 3e 80 00       	mov    $0x803e91,%esi
			if (width > 0 && padc != '-')
  800f40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f44:	7e 6d                	jle    800fb3 <vprintfmt+0x219>
  800f46:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f4a:	74 67                	je     800fb3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	50                   	push   %eax
  800f53:	56                   	push   %esi
  800f54:	e8 0c 03 00 00       	call   801265 <strnlen>
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f5f:	eb 16                	jmp    800f77 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f61:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 0c             	pushl  0xc(%ebp)
  800f6b:	50                   	push   %eax
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	ff d0                	call   *%eax
  800f71:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f74:	ff 4d e4             	decl   -0x1c(%ebp)
  800f77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7b:	7f e4                	jg     800f61 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7d:	eb 34                	jmp    800fb3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f83:	74 1c                	je     800fa1 <vprintfmt+0x207>
  800f85:	83 fb 1f             	cmp    $0x1f,%ebx
  800f88:	7e 05                	jle    800f8f <vprintfmt+0x1f5>
  800f8a:	83 fb 7e             	cmp    $0x7e,%ebx
  800f8d:	7e 12                	jle    800fa1 <vprintfmt+0x207>
					putch('?', putdat);
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	ff 75 0c             	pushl  0xc(%ebp)
  800f95:	6a 3f                	push   $0x3f
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	ff d0                	call   *%eax
  800f9c:	83 c4 10             	add    $0x10,%esp
  800f9f:	eb 0f                	jmp    800fb0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fa1:	83 ec 08             	sub    $0x8,%esp
  800fa4:	ff 75 0c             	pushl  0xc(%ebp)
  800fa7:	53                   	push   %ebx
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	ff d0                	call   *%eax
  800fad:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fb0:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb3:	89 f0                	mov    %esi,%eax
  800fb5:	8d 70 01             	lea    0x1(%eax),%esi
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	0f be d8             	movsbl %al,%ebx
  800fbd:	85 db                	test   %ebx,%ebx
  800fbf:	74 24                	je     800fe5 <vprintfmt+0x24b>
  800fc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc5:	78 b8                	js     800f7f <vprintfmt+0x1e5>
  800fc7:	ff 4d e0             	decl   -0x20(%ebp)
  800fca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fce:	79 af                	jns    800f7f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd0:	eb 13                	jmp    800fe5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	6a 20                	push   $0x20
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	ff d0                	call   *%eax
  800fdf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fe2:	ff 4d e4             	decl   -0x1c(%ebp)
  800fe5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe9:	7f e7                	jg     800fd2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800feb:	e9 66 01 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff9:	50                   	push   %eax
  800ffa:	e8 3c fd ff ff       	call   800d3b <getint>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801005:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100e:	85 d2                	test   %edx,%edx
  801010:	79 23                	jns    801035 <vprintfmt+0x29b>
				putch('-', putdat);
  801012:	83 ec 08             	sub    $0x8,%esp
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	6a 2d                	push   $0x2d
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	ff d0                	call   *%eax
  80101f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801028:	f7 d8                	neg    %eax
  80102a:	83 d2 00             	adc    $0x0,%edx
  80102d:	f7 da                	neg    %edx
  80102f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801032:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801035:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80103c:	e9 bc 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801041:	83 ec 08             	sub    $0x8,%esp
  801044:	ff 75 e8             	pushl  -0x18(%ebp)
  801047:	8d 45 14             	lea    0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	e8 84 fc ff ff       	call   800cd4 <getuint>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801056:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801059:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801060:	e9 98 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 58                	push   $0x58
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 58                	push   $0x58
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801085:	83 ec 08             	sub    $0x8,%esp
  801088:	ff 75 0c             	pushl  0xc(%ebp)
  80108b:	6a 58                	push   $0x58
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	ff d0                	call   *%eax
  801092:	83 c4 10             	add    $0x10,%esp
			break;
  801095:	e9 bc 00 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	6a 30                	push   $0x30
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	ff d0                	call   *%eax
  8010a7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 78                	push   $0x78
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bd:	83 c0 04             	add    $0x4,%eax
  8010c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8010c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c6:	83 e8 04             	sub    $0x4,%eax
  8010c9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010d5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010dc:	eb 1f                	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8010e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e7:	50                   	push   %eax
  8010e8:	e8 e7 fb ff ff       	call   800cd4 <getuint>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010f6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010fd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801104:	83 ec 04             	sub    $0x4,%esp
  801107:	52                   	push   %edx
  801108:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110b:	50                   	push   %eax
  80110c:	ff 75 f4             	pushl  -0xc(%ebp)
  80110f:	ff 75 f0             	pushl  -0x10(%ebp)
  801112:	ff 75 0c             	pushl  0xc(%ebp)
  801115:	ff 75 08             	pushl  0x8(%ebp)
  801118:	e8 00 fb ff ff       	call   800c1d <printnum>
  80111d:	83 c4 20             	add    $0x20,%esp
			break;
  801120:	eb 34                	jmp    801156 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	53                   	push   %ebx
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	ff d0                	call   *%eax
  80112e:	83 c4 10             	add    $0x10,%esp
			break;
  801131:	eb 23                	jmp    801156 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801133:	83 ec 08             	sub    $0x8,%esp
  801136:	ff 75 0c             	pushl  0xc(%ebp)
  801139:	6a 25                	push   $0x25
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	ff d0                	call   *%eax
  801140:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801143:	ff 4d 10             	decl   0x10(%ebp)
  801146:	eb 03                	jmp    80114b <vprintfmt+0x3b1>
  801148:	ff 4d 10             	decl   0x10(%ebp)
  80114b:	8b 45 10             	mov    0x10(%ebp),%eax
  80114e:	48                   	dec    %eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 25                	cmp    $0x25,%al
  801153:	75 f3                	jne    801148 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801155:	90                   	nop
		}
	}
  801156:	e9 47 fc ff ff       	jmp    800da2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80115b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80115c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80115f:	5b                   	pop    %ebx
  801160:	5e                   	pop    %esi
  801161:	5d                   	pop    %ebp
  801162:	c3                   	ret    

00801163 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801169:	8d 45 10             	lea    0x10(%ebp),%eax
  80116c:	83 c0 04             	add    $0x4,%eax
  80116f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801172:	8b 45 10             	mov    0x10(%ebp),%eax
  801175:	ff 75 f4             	pushl  -0xc(%ebp)
  801178:	50                   	push   %eax
  801179:	ff 75 0c             	pushl  0xc(%ebp)
  80117c:	ff 75 08             	pushl  0x8(%ebp)
  80117f:	e8 16 fc ff ff       	call   800d9a <vprintfmt>
  801184:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	8b 40 08             	mov    0x8(%eax),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80119c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119f:	8b 10                	mov    (%eax),%edx
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	8b 40 04             	mov    0x4(%eax),%eax
  8011a7:	39 c2                	cmp    %eax,%edx
  8011a9:	73 12                	jae    8011bd <sprintputch+0x33>
		*b->buf++ = ch;
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	8b 00                	mov    (%eax),%eax
  8011b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8011b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b6:	89 0a                	mov    %ecx,(%edx)
  8011b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bb:	88 10                	mov    %dl,(%eax)
}
  8011bd:	90                   	nop
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    

008011c0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e5:	74 06                	je     8011ed <vsnprintf+0x2d>
  8011e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011eb:	7f 07                	jg     8011f4 <vsnprintf+0x34>
		return -E_INVAL;
  8011ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8011f2:	eb 20                	jmp    801214 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011f4:	ff 75 14             	pushl  0x14(%ebp)
  8011f7:	ff 75 10             	pushl  0x10(%ebp)
  8011fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011fd:	50                   	push   %eax
  8011fe:	68 8a 11 80 00       	push   $0x80118a
  801203:	e8 92 fb ff ff       	call   800d9a <vprintfmt>
  801208:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80120b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80120e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801211:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80121c:	8d 45 10             	lea    0x10(%ebp),%eax
  80121f:	83 c0 04             	add    $0x4,%eax
  801222:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	ff 75 f4             	pushl  -0xc(%ebp)
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	e8 89 ff ff ff       	call   8011c0 <vsnprintf>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80123d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80124f:	eb 06                	jmp    801257 <strlen+0x15>
		n++;
  801251:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801254:	ff 45 08             	incl   0x8(%ebp)
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	84 c0                	test   %al,%al
  80125e:	75 f1                	jne    801251 <strlen+0xf>
		n++;
	return n;
  801260:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 09                	jmp    80127d <strnlen+0x18>
		n++;
  801274:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801277:	ff 45 08             	incl   0x8(%ebp)
  80127a:	ff 4d 0c             	decl   0xc(%ebp)
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	74 09                	je     80128c <strnlen+0x27>
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e8                	jne    801274 <strnlen+0xf>
		n++;
	return n;
  80128c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80129d:	90                   	nop
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8d 50 01             	lea    0x1(%eax),%edx
  8012a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012b0:	8a 12                	mov    (%edx),%dl
  8012b2:	88 10                	mov    %dl,(%eax)
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	84 c0                	test   %al,%al
  8012b8:	75 e4                	jne    80129e <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d2:	eb 1f                	jmp    8012f3 <strncpy+0x34>
		*dst++ = *src;
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8d 50 01             	lea    0x1(%eax),%edx
  8012da:	89 55 08             	mov    %edx,0x8(%ebp)
  8012dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e0:	8a 12                	mov    (%edx),%dl
  8012e2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	84 c0                	test   %al,%al
  8012eb:	74 03                	je     8012f0 <strncpy+0x31>
			src++;
  8012ed:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f0:	ff 45 fc             	incl   -0x4(%ebp)
  8012f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012f9:	72 d9                	jb     8012d4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80130c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801310:	74 30                	je     801342 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801312:	eb 16                	jmp    80132a <strlcpy+0x2a>
			*dst++ = *src++;
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8d 50 01             	lea    0x1(%eax),%edx
  80131a:	89 55 08             	mov    %edx,0x8(%ebp)
  80131d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801320:	8d 4a 01             	lea    0x1(%edx),%ecx
  801323:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801326:	8a 12                	mov    (%edx),%dl
  801328:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80132a:	ff 4d 10             	decl   0x10(%ebp)
  80132d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801331:	74 09                	je     80133c <strlcpy+0x3c>
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	84 c0                	test   %al,%al
  80133a:	75 d8                	jne    801314 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801342:	8b 55 08             	mov    0x8(%ebp),%edx
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801348:	29 c2                	sub    %eax,%edx
  80134a:	89 d0                	mov    %edx,%eax
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801351:	eb 06                	jmp    801359 <strcmp+0xb>
		p++, q++;
  801353:	ff 45 08             	incl   0x8(%ebp)
  801356:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 0e                	je     801370 <strcmp+0x22>
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 10                	mov    (%eax),%dl
  801367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	38 c2                	cmp    %al,%dl
  80136e:	74 e3                	je     801353 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f b6 d0             	movzbl %al,%edx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	0f b6 c0             	movzbl %al,%eax
  801380:	29 c2                	sub    %eax,%edx
  801382:	89 d0                	mov    %edx,%eax
}
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    

00801386 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801389:	eb 09                	jmp    801394 <strncmp+0xe>
		n--, p++, q++;
  80138b:	ff 4d 10             	decl   0x10(%ebp)
  80138e:	ff 45 08             	incl   0x8(%ebp)
  801391:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801394:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801398:	74 17                	je     8013b1 <strncmp+0x2b>
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8a 00                	mov    (%eax),%al
  80139f:	84 c0                	test   %al,%al
  8013a1:	74 0e                	je     8013b1 <strncmp+0x2b>
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8a 10                	mov    (%eax),%dl
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	38 c2                	cmp    %al,%dl
  8013af:	74 da                	je     80138b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	75 07                	jne    8013be <strncmp+0x38>
		return 0;
  8013b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bc:	eb 14                	jmp    8013d2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	0f b6 d0             	movzbl %al,%edx
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	0f b6 c0             	movzbl %al,%eax
  8013ce:	29 c2                	sub    %eax,%edx
  8013d0:	89 d0                	mov    %edx,%eax
}
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    

008013d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013e0:	eb 12                	jmp    8013f4 <strchr+0x20>
		if (*s == c)
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013ea:	75 05                	jne    8013f1 <strchr+0x1d>
			return (char *) s;
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	eb 11                	jmp    801402 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013f1:	ff 45 08             	incl   0x8(%ebp)
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	84 c0                	test   %al,%al
  8013fb:	75 e5                	jne    8013e2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 04             	sub    $0x4,%esp
  80140a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801410:	eb 0d                	jmp    80141f <strfind+0x1b>
		if (*s == c)
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80141a:	74 0e                	je     80142a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80141c:	ff 45 08             	incl   0x8(%ebp)
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	84 c0                	test   %al,%al
  801426:	75 ea                	jne    801412 <strfind+0xe>
  801428:	eb 01                	jmp    80142b <strfind+0x27>
		if (*s == c)
			break;
  80142a:	90                   	nop
	return (char *) s;
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80143c:	8b 45 10             	mov    0x10(%ebp),%eax
  80143f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801442:	eb 0e                	jmp    801452 <memset+0x22>
		*p++ = c;
  801444:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801447:	8d 50 01             	lea    0x1(%eax),%edx
  80144a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80144d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801450:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801452:	ff 4d f8             	decl   -0x8(%ebp)
  801455:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801459:	79 e9                	jns    801444 <memset+0x14>
		*p++ = c;

	return v;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801472:	eb 16                	jmp    80148a <memcpy+0x2a>
		*d++ = *s++;
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	8d 50 01             	lea    0x1(%eax),%edx
  80147a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80147d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801480:	8d 4a 01             	lea    0x1(%edx),%ecx
  801483:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801486:	8a 12                	mov    (%edx),%dl
  801488:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801490:	89 55 10             	mov    %edx,0x10(%ebp)
  801493:	85 c0                	test   %eax,%eax
  801495:	75 dd                	jne    801474 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014b4:	73 50                	jae    801506 <memmove+0x6a>
  8014b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014c1:	76 43                	jbe    801506 <memmove+0x6a>
		s += n;
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014cf:	eb 10                	jmp    8014e1 <memmove+0x45>
			*--d = *--s;
  8014d1:	ff 4d f8             	decl   -0x8(%ebp)
  8014d4:	ff 4d fc             	decl   -0x4(%ebp)
  8014d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014da:	8a 10                	mov    (%eax),%dl
  8014dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014df:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	75 e3                	jne    8014d1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014ee:	eb 23                	jmp    801513 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f3:	8d 50 01             	lea    0x1(%eax),%edx
  8014f6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ff:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801502:	8a 12                	mov    (%edx),%dl
  801504:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801506:	8b 45 10             	mov    0x10(%ebp),%eax
  801509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150c:	89 55 10             	mov    %edx,0x10(%ebp)
  80150f:	85 c0                	test   %eax,%eax
  801511:	75 dd                	jne    8014f0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80152a:	eb 2a                	jmp    801556 <memcmp+0x3e>
		if (*s1 != *s2)
  80152c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152f:	8a 10                	mov    (%eax),%dl
  801531:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	38 c2                	cmp    %al,%dl
  801538:	74 16                	je     801550 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80153a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	0f b6 d0             	movzbl %al,%edx
  801542:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	0f b6 c0             	movzbl %al,%eax
  80154a:	29 c2                	sub    %eax,%edx
  80154c:	89 d0                	mov    %edx,%eax
  80154e:	eb 18                	jmp    801568 <memcmp+0x50>
		s1++, s2++;
  801550:	ff 45 fc             	incl   -0x4(%ebp)
  801553:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801556:	8b 45 10             	mov    0x10(%ebp),%eax
  801559:	8d 50 ff             	lea    -0x1(%eax),%edx
  80155c:	89 55 10             	mov    %edx,0x10(%ebp)
  80155f:	85 c0                	test   %eax,%eax
  801561:	75 c9                	jne    80152c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801570:	8b 55 08             	mov    0x8(%ebp),%edx
  801573:	8b 45 10             	mov    0x10(%ebp),%eax
  801576:	01 d0                	add    %edx,%eax
  801578:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80157b:	eb 15                	jmp    801592 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	0f b6 d0             	movzbl %al,%edx
  801585:	8b 45 0c             	mov    0xc(%ebp),%eax
  801588:	0f b6 c0             	movzbl %al,%eax
  80158b:	39 c2                	cmp    %eax,%edx
  80158d:	74 0d                	je     80159c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80158f:	ff 45 08             	incl   0x8(%ebp)
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801598:	72 e3                	jb     80157d <memfind+0x13>
  80159a:	eb 01                	jmp    80159d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80159c:	90                   	nop
	return (void *) s;
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b6:	eb 03                	jmp    8015bb <strtol+0x19>
		s++;
  8015b8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3c 20                	cmp    $0x20,%al
  8015c2:	74 f4                	je     8015b8 <strtol+0x16>
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	3c 09                	cmp    $0x9,%al
  8015cb:	74 eb                	je     8015b8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	3c 2b                	cmp    $0x2b,%al
  8015d4:	75 05                	jne    8015db <strtol+0x39>
		s++;
  8015d6:	ff 45 08             	incl   0x8(%ebp)
  8015d9:	eb 13                	jmp    8015ee <strtol+0x4c>
	else if (*s == '-')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 2d                	cmp    $0x2d,%al
  8015e2:	75 0a                	jne    8015ee <strtol+0x4c>
		s++, neg = 1;
  8015e4:	ff 45 08             	incl   0x8(%ebp)
  8015e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f2:	74 06                	je     8015fa <strtol+0x58>
  8015f4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015f8:	75 20                	jne    80161a <strtol+0x78>
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	8a 00                	mov    (%eax),%al
  8015ff:	3c 30                	cmp    $0x30,%al
  801601:	75 17                	jne    80161a <strtol+0x78>
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	40                   	inc    %eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3c 78                	cmp    $0x78,%al
  80160b:	75 0d                	jne    80161a <strtol+0x78>
		s += 2, base = 16;
  80160d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801611:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801618:	eb 28                	jmp    801642 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80161a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80161e:	75 15                	jne    801635 <strtol+0x93>
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	8a 00                	mov    (%eax),%al
  801625:	3c 30                	cmp    $0x30,%al
  801627:	75 0c                	jne    801635 <strtol+0x93>
		s++, base = 8;
  801629:	ff 45 08             	incl   0x8(%ebp)
  80162c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801633:	eb 0d                	jmp    801642 <strtol+0xa0>
	else if (base == 0)
  801635:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801639:	75 07                	jne    801642 <strtol+0xa0>
		base = 10;
  80163b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8a 00                	mov    (%eax),%al
  801647:	3c 2f                	cmp    $0x2f,%al
  801649:	7e 19                	jle    801664 <strtol+0xc2>
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 39                	cmp    $0x39,%al
  801652:	7f 10                	jg     801664 <strtol+0xc2>
			dig = *s - '0';
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	0f be c0             	movsbl %al,%eax
  80165c:	83 e8 30             	sub    $0x30,%eax
  80165f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801662:	eb 42                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	8a 00                	mov    (%eax),%al
  801669:	3c 60                	cmp    $0x60,%al
  80166b:	7e 19                	jle    801686 <strtol+0xe4>
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 7a                	cmp    $0x7a,%al
  801674:	7f 10                	jg     801686 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	0f be c0             	movsbl %al,%eax
  80167e:	83 e8 57             	sub    $0x57,%eax
  801681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801684:	eb 20                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	3c 40                	cmp    $0x40,%al
  80168d:	7e 39                	jle    8016c8 <strtol+0x126>
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 5a                	cmp    $0x5a,%al
  801696:	7f 30                	jg     8016c8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f be c0             	movsbl %al,%eax
  8016a0:	83 e8 37             	sub    $0x37,%eax
  8016a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016ac:	7d 19                	jge    8016c7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ae:	ff 45 08             	incl   0x8(%ebp)
  8016b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016b8:	89 c2                	mov    %eax,%edx
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016c2:	e9 7b ff ff ff       	jmp    801642 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016c7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016cc:	74 08                	je     8016d6 <strtol+0x134>
		*endptr = (char *) s;
  8016ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016da:	74 07                	je     8016e3 <strtol+0x141>
  8016dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016df:	f7 d8                	neg    %eax
  8016e1:	eb 03                	jmp    8016e6 <strtol+0x144>
  8016e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <ltostr>:

void
ltostr(long value, char *str)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801700:	79 13                	jns    801715 <ltostr+0x2d>
	{
		neg = 1;
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80170f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801712:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80171d:	99                   	cltd   
  80171e:	f7 f9                	idiv   %ecx
  801720:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801723:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801726:	8d 50 01             	lea    0x1(%eax),%edx
  801729:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80172c:	89 c2                	mov    %eax,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801736:	83 c2 30             	add    $0x30,%edx
  801739:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801754:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801757:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80175c:	f7 e9                	imul   %ecx
  80175e:	c1 fa 02             	sar    $0x2,%edx
  801761:	89 c8                	mov    %ecx,%eax
  801763:	c1 f8 1f             	sar    $0x1f,%eax
  801766:	29 c2                	sub    %eax,%edx
  801768:	89 d0                	mov    %edx,%eax
  80176a:	c1 e0 02             	shl    $0x2,%eax
  80176d:	01 d0                	add    %edx,%eax
  80176f:	01 c0                	add    %eax,%eax
  801771:	29 c1                	sub    %eax,%ecx
  801773:	89 ca                	mov    %ecx,%edx
  801775:	85 d2                	test   %edx,%edx
  801777:	75 9c                	jne    801715 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801779:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801780:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801783:	48                   	dec    %eax
  801784:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801787:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80178b:	74 3d                	je     8017ca <ltostr+0xe2>
		start = 1 ;
  80178d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801794:	eb 34                	jmp    8017ca <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179c:	01 d0                	add    %edx,%eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b1:	01 c8                	add    %ecx,%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bd:	01 c2                	add    %eax,%edx
  8017bf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017c2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017c4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017c7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017d0:	7c c4                	jl     801796 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017dd:	90                   	nop
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017e6:	ff 75 08             	pushl  0x8(%ebp)
  8017e9:	e8 54 fa ff ff       	call   801242 <strlen>
  8017ee:	83 c4 04             	add    $0x4,%esp
  8017f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	e8 46 fa ff ff       	call   801242 <strlen>
  8017fc:	83 c4 04             	add    $0x4,%esp
  8017ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801802:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801810:	eb 17                	jmp    801829 <strcconcat+0x49>
		final[s] = str1[s] ;
  801812:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801815:	8b 45 10             	mov    0x10(%ebp),%eax
  801818:	01 c2                	add    %eax,%edx
  80181a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	01 c8                	add    %ecx,%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801826:	ff 45 fc             	incl   -0x4(%ebp)
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80182f:	7c e1                	jl     801812 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801831:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801838:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80183f:	eb 1f                	jmp    801860 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801841:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801844:	8d 50 01             	lea    0x1(%eax),%edx
  801847:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80184a:	89 c2                	mov    %eax,%edx
  80184c:	8b 45 10             	mov    0x10(%ebp),%eax
  80184f:	01 c2                	add    %eax,%edx
  801851:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801854:	8b 45 0c             	mov    0xc(%ebp),%eax
  801857:	01 c8                	add    %ecx,%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80185d:	ff 45 f8             	incl   -0x8(%ebp)
  801860:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801863:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801866:	7c d9                	jl     801841 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801868:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80186b:	8b 45 10             	mov    0x10(%ebp),%eax
  80186e:	01 d0                	add    %edx,%eax
  801870:	c6 00 00             	movb   $0x0,(%eax)
}
  801873:	90                   	nop
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801879:	8b 45 14             	mov    0x14(%ebp),%eax
  80187c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801882:	8b 45 14             	mov    0x14(%ebp),%eax
  801885:	8b 00                	mov    (%eax),%eax
  801887:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	01 d0                	add    %edx,%eax
  801893:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801899:	eb 0c                	jmp    8018a7 <strsplit+0x31>
			*string++ = 0;
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	8d 50 01             	lea    0x1(%eax),%edx
  8018a1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018a4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	8a 00                	mov    (%eax),%al
  8018ac:	84 c0                	test   %al,%al
  8018ae:	74 18                	je     8018c8 <strsplit+0x52>
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	8a 00                	mov    (%eax),%al
  8018b5:	0f be c0             	movsbl %al,%eax
  8018b8:	50                   	push   %eax
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	e8 13 fb ff ff       	call   8013d4 <strchr>
  8018c1:	83 c4 08             	add    $0x8,%esp
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	75 d3                	jne    80189b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8a 00                	mov    (%eax),%al
  8018cd:	84 c0                	test   %al,%al
  8018cf:	74 5a                	je     80192b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d4:	8b 00                	mov    (%eax),%eax
  8018d6:	83 f8 0f             	cmp    $0xf,%eax
  8018d9:	75 07                	jne    8018e2 <strsplit+0x6c>
		{
			return 0;
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e0:	eb 66                	jmp    801948 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8018ea:	8b 55 14             	mov    0x14(%ebp),%edx
  8018ed:	89 0a                	mov    %ecx,(%edx)
  8018ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 c2                	add    %eax,%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801900:	eb 03                	jmp    801905 <strsplit+0x8f>
			string++;
  801902:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	84 c0                	test   %al,%al
  80190c:	74 8b                	je     801899 <strsplit+0x23>
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	8a 00                	mov    (%eax),%al
  801913:	0f be c0             	movsbl %al,%eax
  801916:	50                   	push   %eax
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	e8 b5 fa ff ff       	call   8013d4 <strchr>
  80191f:	83 c4 08             	add    $0x8,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	74 dc                	je     801902 <strsplit+0x8c>
			string++;
	}
  801926:	e9 6e ff ff ff       	jmp    801899 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80192b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80192c:	8b 45 14             	mov    0x14(%ebp),%eax
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801938:	8b 45 10             	mov    0x10(%ebp),%eax
  80193b:	01 d0                	add    %edx,%eax
  80193d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801943:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801950:	a1 04 50 80 00       	mov    0x805004,%eax
  801955:	85 c0                	test   %eax,%eax
  801957:	74 1f                	je     801978 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801959:	e8 1d 00 00 00       	call   80197b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80195e:	83 ec 0c             	sub    $0xc,%esp
  801961:	68 f0 3f 80 00       	push   $0x803ff0
  801966:	e8 55 f2 ff ff       	call   800bc0 <cprintf>
  80196b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80196e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801975:	00 00 00 
	}
}
  801978:	90                   	nop
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801981:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801988:	00 00 00 
  80198b:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801992:	00 00 00 
  801995:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80199c:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  80199f:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8019a6:	00 00 00 
  8019a9:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8019b0:	00 00 00 
  8019b3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8019ba:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  8019bd:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019c4:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  8019c7:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8019ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019d6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019db:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8019e0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019e7:	a1 20 51 80 00       	mov    0x805120,%eax
  8019ec:	c1 e0 04             	shl    $0x4,%eax
  8019ef:	89 c2                	mov    %eax,%edx
  8019f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f4:	01 d0                	add    %edx,%eax
  8019f6:	48                   	dec    %eax
  8019f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801a02:	f7 75 f0             	divl   -0x10(%ebp)
  801a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a08:	29 d0                	sub    %edx,%eax
  801a0a:	89 c2                	mov    %eax,%edx
  801a0c:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801a13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a1b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a20:	83 ec 04             	sub    $0x4,%esp
  801a23:	6a 06                	push   $0x6
  801a25:	52                   	push   %edx
  801a26:	50                   	push   %eax
  801a27:	e8 71 05 00 00       	call   801f9d <sys_allocate_chunk>
  801a2c:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a2f:	a1 20 51 80 00       	mov    0x805120,%eax
  801a34:	83 ec 0c             	sub    $0xc,%esp
  801a37:	50                   	push   %eax
  801a38:	e8 e6 0b 00 00       	call   802623 <initialize_MemBlocksList>
  801a3d:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801a40:	a1 48 51 80 00       	mov    0x805148,%eax
  801a45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801a48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a4c:	75 14                	jne    801a62 <initialize_dyn_block_system+0xe7>
  801a4e:	83 ec 04             	sub    $0x4,%esp
  801a51:	68 15 40 80 00       	push   $0x804015
  801a56:	6a 2b                	push   $0x2b
  801a58:	68 33 40 80 00       	push   $0x804033
  801a5d:	e8 aa ee ff ff       	call   80090c <_panic>
  801a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a65:	8b 00                	mov    (%eax),%eax
  801a67:	85 c0                	test   %eax,%eax
  801a69:	74 10                	je     801a7b <initialize_dyn_block_system+0x100>
  801a6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a6e:	8b 00                	mov    (%eax),%eax
  801a70:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a73:	8b 52 04             	mov    0x4(%edx),%edx
  801a76:	89 50 04             	mov    %edx,0x4(%eax)
  801a79:	eb 0b                	jmp    801a86 <initialize_dyn_block_system+0x10b>
  801a7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a7e:	8b 40 04             	mov    0x4(%eax),%eax
  801a81:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a89:	8b 40 04             	mov    0x4(%eax),%eax
  801a8c:	85 c0                	test   %eax,%eax
  801a8e:	74 0f                	je     801a9f <initialize_dyn_block_system+0x124>
  801a90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a93:	8b 40 04             	mov    0x4(%eax),%eax
  801a96:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a99:	8b 12                	mov    (%edx),%edx
  801a9b:	89 10                	mov    %edx,(%eax)
  801a9d:	eb 0a                	jmp    801aa9 <initialize_dyn_block_system+0x12e>
  801a9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aa2:	8b 00                	mov    (%eax),%eax
  801aa4:	a3 48 51 80 00       	mov    %eax,0x805148
  801aa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ab5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801abc:	a1 54 51 80 00       	mov    0x805154,%eax
  801ac1:	48                   	dec    %eax
  801ac2:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801ac7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aca:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ad4:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801adb:	83 ec 0c             	sub    $0xc,%esp
  801ade:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ae1:	e8 d2 13 00 00       	call   802eb8 <insert_sorted_with_merge_freeList>
  801ae6:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801ae9:	90                   	nop
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801af2:	e8 53 fe ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801af7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801afb:	75 07                	jne    801b04 <malloc+0x18>
  801afd:	b8 00 00 00 00       	mov    $0x0,%eax
  801b02:	eb 61                	jmp    801b65 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801b04:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b0b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b11:	01 d0                	add    %edx,%eax
  801b13:	48                   	dec    %eax
  801b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b1f:	f7 75 f4             	divl   -0xc(%ebp)
  801b22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b25:	29 d0                	sub    %edx,%eax
  801b27:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b2a:	e8 3c 08 00 00       	call   80236b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	74 2d                	je     801b60 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801b33:	83 ec 0c             	sub    $0xc,%esp
  801b36:	ff 75 08             	pushl  0x8(%ebp)
  801b39:	e8 3e 0f 00 00       	call   802a7c <alloc_block_FF>
  801b3e:	83 c4 10             	add    $0x10,%esp
  801b41:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801b44:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b48:	74 16                	je     801b60 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801b4a:	83 ec 0c             	sub    $0xc,%esp
  801b4d:	ff 75 ec             	pushl  -0x14(%ebp)
  801b50:	e8 48 0c 00 00       	call   80279d <insert_sorted_allocList>
  801b55:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801b58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b5b:	8b 40 08             	mov    0x8(%eax),%eax
  801b5e:	eb 05                	jmp    801b65 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801b60:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b7b:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	83 ec 08             	sub    $0x8,%esp
  801b84:	50                   	push   %eax
  801b85:	68 40 50 80 00       	push   $0x805040
  801b8a:	e8 71 0b 00 00       	call   802700 <find_block>
  801b8f:	83 c4 10             	add    $0x10,%esp
  801b92:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b98:	8b 50 0c             	mov    0xc(%eax),%edx
  801b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9e:	83 ec 08             	sub    $0x8,%esp
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	e8 bd 03 00 00       	call   801f65 <sys_free_user_mem>
  801ba8:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801bab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801baf:	75 14                	jne    801bc5 <free+0x5e>
  801bb1:	83 ec 04             	sub    $0x4,%esp
  801bb4:	68 15 40 80 00       	push   $0x804015
  801bb9:	6a 71                	push   $0x71
  801bbb:	68 33 40 80 00       	push   $0x804033
  801bc0:	e8 47 ed ff ff       	call   80090c <_panic>
  801bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc8:	8b 00                	mov    (%eax),%eax
  801bca:	85 c0                	test   %eax,%eax
  801bcc:	74 10                	je     801bde <free+0x77>
  801bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd1:	8b 00                	mov    (%eax),%eax
  801bd3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bd6:	8b 52 04             	mov    0x4(%edx),%edx
  801bd9:	89 50 04             	mov    %edx,0x4(%eax)
  801bdc:	eb 0b                	jmp    801be9 <free+0x82>
  801bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be1:	8b 40 04             	mov    0x4(%eax),%eax
  801be4:	a3 44 50 80 00       	mov    %eax,0x805044
  801be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bec:	8b 40 04             	mov    0x4(%eax),%eax
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	74 0f                	je     801c02 <free+0x9b>
  801bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf6:	8b 40 04             	mov    0x4(%eax),%eax
  801bf9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bfc:	8b 12                	mov    (%edx),%edx
  801bfe:	89 10                	mov    %edx,(%eax)
  801c00:	eb 0a                	jmp    801c0c <free+0xa5>
  801c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c05:	8b 00                	mov    (%eax),%eax
  801c07:	a3 40 50 80 00       	mov    %eax,0x805040
  801c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c1f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c24:	48                   	dec    %eax
  801c25:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801c2a:	83 ec 0c             	sub    $0xc,%esp
  801c2d:	ff 75 f0             	pushl  -0x10(%ebp)
  801c30:	e8 83 12 00 00       	call   802eb8 <insert_sorted_with_merge_freeList>
  801c35:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801c38:	90                   	nop
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 28             	sub    $0x28,%esp
  801c41:	8b 45 10             	mov    0x10(%ebp),%eax
  801c44:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c47:	e8 fe fc ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801c4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c50:	75 0a                	jne    801c5c <smalloc+0x21>
  801c52:	b8 00 00 00 00       	mov    $0x0,%eax
  801c57:	e9 86 00 00 00       	jmp    801ce2 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801c5c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801c63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c69:	01 d0                	add    %edx,%eax
  801c6b:	48                   	dec    %eax
  801c6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c72:	ba 00 00 00 00       	mov    $0x0,%edx
  801c77:	f7 75 f4             	divl   -0xc(%ebp)
  801c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7d:	29 d0                	sub    %edx,%eax
  801c7f:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801c82:	e8 e4 06 00 00       	call   80236b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c87:	85 c0                	test   %eax,%eax
  801c89:	74 52                	je     801cdd <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801c8b:	83 ec 0c             	sub    $0xc,%esp
  801c8e:	ff 75 0c             	pushl  0xc(%ebp)
  801c91:	e8 e6 0d 00 00       	call   802a7c <alloc_block_FF>
  801c96:	83 c4 10             	add    $0x10,%esp
  801c99:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801c9c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801ca0:	75 07                	jne    801ca9 <smalloc+0x6e>
			return NULL ;
  801ca2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca7:	eb 39                	jmp    801ce2 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801ca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cac:	8b 40 08             	mov    0x8(%eax),%eax
  801caf:	89 c2                	mov    %eax,%edx
  801cb1:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801cb5:	52                   	push   %edx
  801cb6:	50                   	push   %eax
  801cb7:	ff 75 0c             	pushl  0xc(%ebp)
  801cba:	ff 75 08             	pushl  0x8(%ebp)
  801cbd:	e8 2e 04 00 00       	call   8020f0 <sys_createSharedObject>
  801cc2:	83 c4 10             	add    $0x10,%esp
  801cc5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801cc8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ccc:	79 07                	jns    801cd5 <smalloc+0x9a>
			return (void*)NULL ;
  801cce:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd3:	eb 0d                	jmp    801ce2 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cd8:	8b 40 08             	mov    0x8(%eax),%eax
  801cdb:	eb 05                	jmp    801ce2 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801cdd:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cea:	e8 5b fc ff ff       	call   80194a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801cef:	83 ec 08             	sub    $0x8,%esp
  801cf2:	ff 75 0c             	pushl  0xc(%ebp)
  801cf5:	ff 75 08             	pushl  0x8(%ebp)
  801cf8:	e8 1d 04 00 00       	call   80211a <sys_getSizeOfSharedObject>
  801cfd:	83 c4 10             	add    $0x10,%esp
  801d00:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801d03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d07:	75 0a                	jne    801d13 <sget+0x2f>
			return NULL ;
  801d09:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0e:	e9 83 00 00 00       	jmp    801d96 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801d13:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d20:	01 d0                	add    %edx,%eax
  801d22:	48                   	dec    %eax
  801d23:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d29:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2e:	f7 75 f0             	divl   -0x10(%ebp)
  801d31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d34:	29 d0                	sub    %edx,%eax
  801d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d39:	e8 2d 06 00 00       	call   80236b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	74 4f                	je     801d91 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d45:	83 ec 0c             	sub    $0xc,%esp
  801d48:	50                   	push   %eax
  801d49:	e8 2e 0d 00 00       	call   802a7c <alloc_block_FF>
  801d4e:	83 c4 10             	add    $0x10,%esp
  801d51:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801d54:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d58:	75 07                	jne    801d61 <sget+0x7d>
					return (void*)NULL ;
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801d5f:	eb 35                	jmp    801d96 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801d61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d64:	8b 40 08             	mov    0x8(%eax),%eax
  801d67:	83 ec 04             	sub    $0x4,%esp
  801d6a:	50                   	push   %eax
  801d6b:	ff 75 0c             	pushl  0xc(%ebp)
  801d6e:	ff 75 08             	pushl  0x8(%ebp)
  801d71:	e8 c1 03 00 00       	call   802137 <sys_getSharedObject>
  801d76:	83 c4 10             	add    $0x10,%esp
  801d79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801d7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d80:	79 07                	jns    801d89 <sget+0xa5>
				return (void*)NULL ;
  801d82:	b8 00 00 00 00       	mov    $0x0,%eax
  801d87:	eb 0d                	jmp    801d96 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801d89:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d8c:	8b 40 08             	mov    0x8(%eax),%eax
  801d8f:	eb 05                	jmp    801d96 <sget+0xb2>


		}
	return (void*)NULL ;
  801d91:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d9e:	e8 a7 fb ff ff       	call   80194a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801da3:	83 ec 04             	sub    $0x4,%esp
  801da6:	68 40 40 80 00       	push   $0x804040
  801dab:	68 f9 00 00 00       	push   $0xf9
  801db0:	68 33 40 80 00       	push   $0x804033
  801db5:	e8 52 eb ff ff       	call   80090c <_panic>

00801dba <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801dc0:	83 ec 04             	sub    $0x4,%esp
  801dc3:	68 68 40 80 00       	push   $0x804068
  801dc8:	68 0d 01 00 00       	push   $0x10d
  801dcd:	68 33 40 80 00       	push   $0x804033
  801dd2:	e8 35 eb ff ff       	call   80090c <_panic>

00801dd7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ddd:	83 ec 04             	sub    $0x4,%esp
  801de0:	68 8c 40 80 00       	push   $0x80408c
  801de5:	68 18 01 00 00       	push   $0x118
  801dea:	68 33 40 80 00       	push   $0x804033
  801def:	e8 18 eb ff ff       	call   80090c <_panic>

00801df4 <shrink>:

}
void shrink(uint32 newSize)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	68 8c 40 80 00       	push   $0x80408c
  801e02:	68 1d 01 00 00       	push   $0x11d
  801e07:	68 33 40 80 00       	push   $0x804033
  801e0c:	e8 fb ea ff ff       	call   80090c <_panic>

00801e11 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801e17:	83 ec 04             	sub    $0x4,%esp
  801e1a:	68 8c 40 80 00       	push   $0x80408c
  801e1f:	68 22 01 00 00       	push   $0x122
  801e24:	68 33 40 80 00       	push   $0x804033
  801e29:	e8 de ea ff ff       	call   80090c <_panic>

00801e2e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	57                   	push   %edi
  801e32:	56                   	push   %esi
  801e33:	53                   	push   %ebx
  801e34:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e40:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e43:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e46:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e49:	cd 30                	int    $0x30
  801e4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e51:	83 c4 10             	add    $0x10,%esp
  801e54:	5b                   	pop    %ebx
  801e55:	5e                   	pop    %esi
  801e56:	5f                   	pop    %edi
  801e57:	5d                   	pop    %ebp
  801e58:	c3                   	ret    

00801e59 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	83 ec 04             	sub    $0x4,%esp
  801e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e62:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e65:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e69:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	52                   	push   %edx
  801e71:	ff 75 0c             	pushl  0xc(%ebp)
  801e74:	50                   	push   %eax
  801e75:	6a 00                	push   $0x0
  801e77:	e8 b2 ff ff ff       	call   801e2e <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
}
  801e7f:	90                   	nop
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 01                	push   $0x1
  801e91:	e8 98 ff ff ff       	call   801e2e <syscall>
  801e96:	83 c4 18             	add    $0x18,%esp
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	52                   	push   %edx
  801eab:	50                   	push   %eax
  801eac:	6a 05                	push   $0x5
  801eae:	e8 7b ff ff ff       	call   801e2e <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
  801ebb:	56                   	push   %esi
  801ebc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ebd:	8b 75 18             	mov    0x18(%ebp),%esi
  801ec0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ec3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecc:	56                   	push   %esi
  801ecd:	53                   	push   %ebx
  801ece:	51                   	push   %ecx
  801ecf:	52                   	push   %edx
  801ed0:	50                   	push   %eax
  801ed1:	6a 06                	push   $0x6
  801ed3:	e8 56 ff ff ff       	call   801e2e <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
}
  801edb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ede:	5b                   	pop    %ebx
  801edf:	5e                   	pop    %esi
  801ee0:	5d                   	pop    %ebp
  801ee1:	c3                   	ret    

00801ee2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	52                   	push   %edx
  801ef2:	50                   	push   %eax
  801ef3:	6a 07                	push   $0x7
  801ef5:	e8 34 ff ff ff       	call   801e2e <syscall>
  801efa:	83 c4 18             	add    $0x18,%esp
}
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	ff 75 0c             	pushl  0xc(%ebp)
  801f0b:	ff 75 08             	pushl  0x8(%ebp)
  801f0e:	6a 08                	push   $0x8
  801f10:	e8 19 ff ff ff       	call   801e2e <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 09                	push   $0x9
  801f29:	e8 00 ff ff ff       	call   801e2e <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 0a                	push   $0xa
  801f42:	e8 e7 fe ff ff       	call   801e2e <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 0b                	push   $0xb
  801f5b:	e8 ce fe ff ff       	call   801e2e <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	ff 75 0c             	pushl  0xc(%ebp)
  801f71:	ff 75 08             	pushl  0x8(%ebp)
  801f74:	6a 0f                	push   $0xf
  801f76:	e8 b3 fe ff ff       	call   801e2e <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
	return;
  801f7e:	90                   	nop
}
  801f7f:	c9                   	leave  
  801f80:	c3                   	ret    

00801f81 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	ff 75 0c             	pushl  0xc(%ebp)
  801f8d:	ff 75 08             	pushl  0x8(%ebp)
  801f90:	6a 10                	push   $0x10
  801f92:	e8 97 fe ff ff       	call   801e2e <syscall>
  801f97:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9a:	90                   	nop
}
  801f9b:	c9                   	leave  
  801f9c:	c3                   	ret    

00801f9d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	ff 75 10             	pushl  0x10(%ebp)
  801fa7:	ff 75 0c             	pushl  0xc(%ebp)
  801faa:	ff 75 08             	pushl  0x8(%ebp)
  801fad:	6a 11                	push   $0x11
  801faf:	e8 7a fe ff ff       	call   801e2e <syscall>
  801fb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb7:	90                   	nop
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 0c                	push   $0xc
  801fc9:	e8 60 fe ff ff       	call   801e2e <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	ff 75 08             	pushl  0x8(%ebp)
  801fe1:	6a 0d                	push   $0xd
  801fe3:	e8 46 fe ff ff       	call   801e2e <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
}
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_scarce_memory>:

void sys_scarce_memory()
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	6a 00                	push   $0x0
  801ff6:	6a 00                	push   $0x0
  801ff8:	6a 00                	push   $0x0
  801ffa:	6a 0e                	push   $0xe
  801ffc:	e8 2d fe ff ff       	call   801e2e <syscall>
  802001:	83 c4 18             	add    $0x18,%esp
}
  802004:	90                   	nop
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	6a 00                	push   $0x0
  802014:	6a 13                	push   $0x13
  802016:	e8 13 fe ff ff       	call   801e2e <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
}
  80201e:	90                   	nop
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 00                	push   $0x0
  80202e:	6a 14                	push   $0x14
  802030:	e8 f9 fd ff ff       	call   801e2e <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
}
  802038:	90                   	nop
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_cputc>:


void
sys_cputc(const char c)
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
  80203e:	83 ec 04             	sub    $0x4,%esp
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802047:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	50                   	push   %eax
  802054:	6a 15                	push   $0x15
  802056:	e8 d3 fd ff ff       	call   801e2e <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
}
  80205e:	90                   	nop
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 16                	push   $0x16
  802070:	e8 b9 fd ff ff       	call   801e2e <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
}
  802078:	90                   	nop
  802079:	c9                   	leave  
  80207a:	c3                   	ret    

0080207b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80207b:	55                   	push   %ebp
  80207c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	ff 75 0c             	pushl  0xc(%ebp)
  80208a:	50                   	push   %eax
  80208b:	6a 17                	push   $0x17
  80208d:	e8 9c fd ff ff       	call   801e2e <syscall>
  802092:	83 c4 18             	add    $0x18,%esp
}
  802095:	c9                   	leave  
  802096:	c3                   	ret    

00802097 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802097:	55                   	push   %ebp
  802098:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80209a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209d:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	52                   	push   %edx
  8020a7:	50                   	push   %eax
  8020a8:	6a 1a                	push   $0x1a
  8020aa:	e8 7f fd ff ff       	call   801e2e <syscall>
  8020af:	83 c4 18             	add    $0x18,%esp
}
  8020b2:	c9                   	leave  
  8020b3:	c3                   	ret    

008020b4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020b4:	55                   	push   %ebp
  8020b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	52                   	push   %edx
  8020c4:	50                   	push   %eax
  8020c5:	6a 18                	push   $0x18
  8020c7:	e8 62 fd ff ff       	call   801e2e <syscall>
  8020cc:	83 c4 18             	add    $0x18,%esp
}
  8020cf:	90                   	nop
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	52                   	push   %edx
  8020e2:	50                   	push   %eax
  8020e3:	6a 19                	push   $0x19
  8020e5:	e8 44 fd ff ff       	call   801e2e <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	90                   	nop
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 04             	sub    $0x4,%esp
  8020f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020fc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020ff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	6a 00                	push   $0x0
  802108:	51                   	push   %ecx
  802109:	52                   	push   %edx
  80210a:	ff 75 0c             	pushl  0xc(%ebp)
  80210d:	50                   	push   %eax
  80210e:	6a 1b                	push   $0x1b
  802110:	e8 19 fd ff ff       	call   801e2e <syscall>
  802115:	83 c4 18             	add    $0x18,%esp
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80211d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	52                   	push   %edx
  80212a:	50                   	push   %eax
  80212b:	6a 1c                	push   $0x1c
  80212d:	e8 fc fc ff ff       	call   801e2e <syscall>
  802132:	83 c4 18             	add    $0x18,%esp
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80213a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80213d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802140:	8b 45 08             	mov    0x8(%ebp),%eax
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	51                   	push   %ecx
  802148:	52                   	push   %edx
  802149:	50                   	push   %eax
  80214a:	6a 1d                	push   $0x1d
  80214c:	e8 dd fc ff ff       	call   801e2e <syscall>
  802151:	83 c4 18             	add    $0x18,%esp
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802159:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	52                   	push   %edx
  802166:	50                   	push   %eax
  802167:	6a 1e                	push   $0x1e
  802169:	e8 c0 fc ff ff       	call   801e2e <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802176:	6a 00                	push   $0x0
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 1f                	push   $0x1f
  802182:	e8 a7 fc ff ff       	call   801e2e <syscall>
  802187:	83 c4 18             	add    $0x18,%esp
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	6a 00                	push   $0x0
  802194:	ff 75 14             	pushl  0x14(%ebp)
  802197:	ff 75 10             	pushl  0x10(%ebp)
  80219a:	ff 75 0c             	pushl  0xc(%ebp)
  80219d:	50                   	push   %eax
  80219e:	6a 20                	push   $0x20
  8021a0:	e8 89 fc ff ff       	call   801e2e <syscall>
  8021a5:	83 c4 18             	add    $0x18,%esp
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	50                   	push   %eax
  8021b9:	6a 21                	push   $0x21
  8021bb:	e8 6e fc ff ff       	call   801e2e <syscall>
  8021c0:	83 c4 18             	add    $0x18,%esp
}
  8021c3:	90                   	nop
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	50                   	push   %eax
  8021d5:	6a 22                	push   $0x22
  8021d7:	e8 52 fc ff ff       	call   801e2e <syscall>
  8021dc:	83 c4 18             	add    $0x18,%esp
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 02                	push   $0x2
  8021f0:	e8 39 fc ff ff       	call   801e2e <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 03                	push   $0x3
  802209:	e8 20 fc ff ff       	call   801e2e <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 04                	push   $0x4
  802222:	e8 07 fc ff ff       	call   801e2e <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <sys_exit_env>:


void sys_exit_env(void)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 23                	push   $0x23
  80223b:	e8 ee fb ff ff       	call   801e2e <syscall>
  802240:	83 c4 18             	add    $0x18,%esp
}
  802243:	90                   	nop
  802244:	c9                   	leave  
  802245:	c3                   	ret    

00802246 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80224c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80224f:	8d 50 04             	lea    0x4(%eax),%edx
  802252:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802255:	6a 00                	push   $0x0
  802257:	6a 00                	push   $0x0
  802259:	6a 00                	push   $0x0
  80225b:	52                   	push   %edx
  80225c:	50                   	push   %eax
  80225d:	6a 24                	push   $0x24
  80225f:	e8 ca fb ff ff       	call   801e2e <syscall>
  802264:	83 c4 18             	add    $0x18,%esp
	return result;
  802267:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80226a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80226d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802270:	89 01                	mov    %eax,(%ecx)
  802272:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	c9                   	leave  
  802279:	c2 04 00             	ret    $0x4

0080227c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80227c:	55                   	push   %ebp
  80227d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	ff 75 10             	pushl  0x10(%ebp)
  802286:	ff 75 0c             	pushl  0xc(%ebp)
  802289:	ff 75 08             	pushl  0x8(%ebp)
  80228c:	6a 12                	push   $0x12
  80228e:	e8 9b fb ff ff       	call   801e2e <syscall>
  802293:	83 c4 18             	add    $0x18,%esp
	return ;
  802296:	90                   	nop
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <sys_rcr2>:
uint32 sys_rcr2()
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 25                	push   $0x25
  8022a8:	e8 81 fb ff ff       	call   801e2e <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    

008022b2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
  8022b5:	83 ec 04             	sub    $0x4,%esp
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022be:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	50                   	push   %eax
  8022cb:	6a 26                	push   $0x26
  8022cd:	e8 5c fb ff ff       	call   801e2e <syscall>
  8022d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d5:	90                   	nop
}
  8022d6:	c9                   	leave  
  8022d7:	c3                   	ret    

008022d8 <rsttst>:
void rsttst()
{
  8022d8:	55                   	push   %ebp
  8022d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 00                	push   $0x0
  8022df:	6a 00                	push   $0x0
  8022e1:	6a 00                	push   $0x0
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 28                	push   $0x28
  8022e7:	e8 42 fb ff ff       	call   801e2e <syscall>
  8022ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ef:	90                   	nop
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
  8022f5:	83 ec 04             	sub    $0x4,%esp
  8022f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8022fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022fe:	8b 55 18             	mov    0x18(%ebp),%edx
  802301:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802305:	52                   	push   %edx
  802306:	50                   	push   %eax
  802307:	ff 75 10             	pushl  0x10(%ebp)
  80230a:	ff 75 0c             	pushl  0xc(%ebp)
  80230d:	ff 75 08             	pushl  0x8(%ebp)
  802310:	6a 27                	push   $0x27
  802312:	e8 17 fb ff ff       	call   801e2e <syscall>
  802317:	83 c4 18             	add    $0x18,%esp
	return ;
  80231a:	90                   	nop
}
  80231b:	c9                   	leave  
  80231c:	c3                   	ret    

0080231d <chktst>:
void chktst(uint32 n)
{
  80231d:	55                   	push   %ebp
  80231e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	ff 75 08             	pushl  0x8(%ebp)
  80232b:	6a 29                	push   $0x29
  80232d:	e8 fc fa ff ff       	call   801e2e <syscall>
  802332:	83 c4 18             	add    $0x18,%esp
	return ;
  802335:	90                   	nop
}
  802336:	c9                   	leave  
  802337:	c3                   	ret    

00802338 <inctst>:

void inctst()
{
  802338:	55                   	push   %ebp
  802339:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80233b:	6a 00                	push   $0x0
  80233d:	6a 00                	push   $0x0
  80233f:	6a 00                	push   $0x0
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 2a                	push   $0x2a
  802347:	e8 e2 fa ff ff       	call   801e2e <syscall>
  80234c:	83 c4 18             	add    $0x18,%esp
	return ;
  80234f:	90                   	nop
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <gettst>:
uint32 gettst()
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	6a 2b                	push   $0x2b
  802361:	e8 c8 fa ff ff       	call   801e2e <syscall>
  802366:	83 c4 18             	add    $0x18,%esp
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 2c                	push   $0x2c
  80237d:	e8 ac fa ff ff       	call   801e2e <syscall>
  802382:	83 c4 18             	add    $0x18,%esp
  802385:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802388:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80238c:	75 07                	jne    802395 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	eb 05                	jmp    80239a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802395:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
  80239f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023a2:	6a 00                	push   $0x0
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 2c                	push   $0x2c
  8023ae:	e8 7b fa ff ff       	call   801e2e <syscall>
  8023b3:	83 c4 18             	add    $0x18,%esp
  8023b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023b9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023bd:	75 07                	jne    8023c6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023bf:	b8 01 00 00 00       	mov    $0x1,%eax
  8023c4:	eb 05                	jmp    8023cb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023cb:	c9                   	leave  
  8023cc:	c3                   	ret    

008023cd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023cd:	55                   	push   %ebp
  8023ce:	89 e5                	mov    %esp,%ebp
  8023d0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023d3:	6a 00                	push   $0x0
  8023d5:	6a 00                	push   $0x0
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 2c                	push   $0x2c
  8023df:	e8 4a fa ff ff       	call   801e2e <syscall>
  8023e4:	83 c4 18             	add    $0x18,%esp
  8023e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023ea:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023ee:	75 07                	jne    8023f7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023f0:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f5:	eb 05                	jmp    8023fc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 2c                	push   $0x2c
  802410:	e8 19 fa ff ff       	call   801e2e <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
  802418:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80241b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80241f:	75 07                	jne    802428 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802421:	b8 01 00 00 00       	mov    $0x1,%eax
  802426:	eb 05                	jmp    80242d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802428:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	ff 75 08             	pushl  0x8(%ebp)
  80243d:	6a 2d                	push   $0x2d
  80243f:	e8 ea f9 ff ff       	call   801e2e <syscall>
  802444:	83 c4 18             	add    $0x18,%esp
	return ;
  802447:	90                   	nop
}
  802448:	c9                   	leave  
  802449:	c3                   	ret    

0080244a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80244a:	55                   	push   %ebp
  80244b:	89 e5                	mov    %esp,%ebp
  80244d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80244e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802451:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802454:	8b 55 0c             	mov    0xc(%ebp),%edx
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	6a 00                	push   $0x0
  80245c:	53                   	push   %ebx
  80245d:	51                   	push   %ecx
  80245e:	52                   	push   %edx
  80245f:	50                   	push   %eax
  802460:	6a 2e                	push   $0x2e
  802462:	e8 c7 f9 ff ff       	call   801e2e <syscall>
  802467:	83 c4 18             	add    $0x18,%esp
}
  80246a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80246d:	c9                   	leave  
  80246e:	c3                   	ret    

0080246f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802472:	8b 55 0c             	mov    0xc(%ebp),%edx
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	52                   	push   %edx
  80247f:	50                   	push   %eax
  802480:	6a 2f                	push   $0x2f
  802482:	e8 a7 f9 ff ff       	call   801e2e <syscall>
  802487:	83 c4 18             	add    $0x18,%esp
}
  80248a:	c9                   	leave  
  80248b:	c3                   	ret    

0080248c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802492:	83 ec 0c             	sub    $0xc,%esp
  802495:	68 9c 40 80 00       	push   $0x80409c
  80249a:	e8 21 e7 ff ff       	call   800bc0 <cprintf>
  80249f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8024a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8024a9:	83 ec 0c             	sub    $0xc,%esp
  8024ac:	68 c8 40 80 00       	push   $0x8040c8
  8024b1:	e8 0a e7 ff ff       	call   800bc0 <cprintf>
  8024b6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024b9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024bd:	a1 38 51 80 00       	mov    0x805138,%eax
  8024c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c5:	eb 56                	jmp    80251d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024cb:	74 1c                	je     8024e9 <print_mem_block_lists+0x5d>
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	8b 50 08             	mov    0x8(%eax),%edx
  8024d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d6:	8b 48 08             	mov    0x8(%eax),%ecx
  8024d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024df:	01 c8                	add    %ecx,%eax
  8024e1:	39 c2                	cmp    %eax,%edx
  8024e3:	73 04                	jae    8024e9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8024e5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	8b 50 08             	mov    0x8(%eax),%edx
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f5:	01 c2                	add    %eax,%edx
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	8b 40 08             	mov    0x8(%eax),%eax
  8024fd:	83 ec 04             	sub    $0x4,%esp
  802500:	52                   	push   %edx
  802501:	50                   	push   %eax
  802502:	68 dd 40 80 00       	push   $0x8040dd
  802507:	e8 b4 e6 ff ff       	call   800bc0 <cprintf>
  80250c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802515:	a1 40 51 80 00       	mov    0x805140,%eax
  80251a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80251d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802521:	74 07                	je     80252a <print_mem_block_lists+0x9e>
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 00                	mov    (%eax),%eax
  802528:	eb 05                	jmp    80252f <print_mem_block_lists+0xa3>
  80252a:	b8 00 00 00 00       	mov    $0x0,%eax
  80252f:	a3 40 51 80 00       	mov    %eax,0x805140
  802534:	a1 40 51 80 00       	mov    0x805140,%eax
  802539:	85 c0                	test   %eax,%eax
  80253b:	75 8a                	jne    8024c7 <print_mem_block_lists+0x3b>
  80253d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802541:	75 84                	jne    8024c7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802543:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802547:	75 10                	jne    802559 <print_mem_block_lists+0xcd>
  802549:	83 ec 0c             	sub    $0xc,%esp
  80254c:	68 ec 40 80 00       	push   $0x8040ec
  802551:	e8 6a e6 ff ff       	call   800bc0 <cprintf>
  802556:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802559:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802560:	83 ec 0c             	sub    $0xc,%esp
  802563:	68 10 41 80 00       	push   $0x804110
  802568:	e8 53 e6 ff ff       	call   800bc0 <cprintf>
  80256d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802570:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802574:	a1 40 50 80 00       	mov    0x805040,%eax
  802579:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257c:	eb 56                	jmp    8025d4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80257e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802582:	74 1c                	je     8025a0 <print_mem_block_lists+0x114>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 50 08             	mov    0x8(%eax),%edx
  80258a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80258d:	8b 48 08             	mov    0x8(%eax),%ecx
  802590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802593:	8b 40 0c             	mov    0xc(%eax),%eax
  802596:	01 c8                	add    %ecx,%eax
  802598:	39 c2                	cmp    %eax,%edx
  80259a:	73 04                	jae    8025a0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80259c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 50 08             	mov    0x8(%eax),%edx
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ac:	01 c2                	add    %eax,%edx
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 40 08             	mov    0x8(%eax),%eax
  8025b4:	83 ec 04             	sub    $0x4,%esp
  8025b7:	52                   	push   %edx
  8025b8:	50                   	push   %eax
  8025b9:	68 dd 40 80 00       	push   $0x8040dd
  8025be:	e8 fd e5 ff ff       	call   800bc0 <cprintf>
  8025c3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025cc:	a1 48 50 80 00       	mov    0x805048,%eax
  8025d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d8:	74 07                	je     8025e1 <print_mem_block_lists+0x155>
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	eb 05                	jmp    8025e6 <print_mem_block_lists+0x15a>
  8025e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e6:	a3 48 50 80 00       	mov    %eax,0x805048
  8025eb:	a1 48 50 80 00       	mov    0x805048,%eax
  8025f0:	85 c0                	test   %eax,%eax
  8025f2:	75 8a                	jne    80257e <print_mem_block_lists+0xf2>
  8025f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f8:	75 84                	jne    80257e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8025fa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025fe:	75 10                	jne    802610 <print_mem_block_lists+0x184>
  802600:	83 ec 0c             	sub    $0xc,%esp
  802603:	68 28 41 80 00       	push   $0x804128
  802608:	e8 b3 e5 ff ff       	call   800bc0 <cprintf>
  80260d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802610:	83 ec 0c             	sub    $0xc,%esp
  802613:	68 9c 40 80 00       	push   $0x80409c
  802618:	e8 a3 e5 ff ff       	call   800bc0 <cprintf>
  80261d:	83 c4 10             	add    $0x10,%esp

}
  802620:	90                   	nop
  802621:	c9                   	leave  
  802622:	c3                   	ret    

00802623 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802623:	55                   	push   %ebp
  802624:	89 e5                	mov    %esp,%ebp
  802626:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802629:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802630:	00 00 00 
  802633:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80263a:	00 00 00 
  80263d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802644:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802647:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80264e:	e9 9e 00 00 00       	jmp    8026f1 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802653:	a1 50 50 80 00       	mov    0x805050,%eax
  802658:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265b:	c1 e2 04             	shl    $0x4,%edx
  80265e:	01 d0                	add    %edx,%eax
  802660:	85 c0                	test   %eax,%eax
  802662:	75 14                	jne    802678 <initialize_MemBlocksList+0x55>
  802664:	83 ec 04             	sub    $0x4,%esp
  802667:	68 50 41 80 00       	push   $0x804150
  80266c:	6a 43                	push   $0x43
  80266e:	68 73 41 80 00       	push   $0x804173
  802673:	e8 94 e2 ff ff       	call   80090c <_panic>
  802678:	a1 50 50 80 00       	mov    0x805050,%eax
  80267d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802680:	c1 e2 04             	shl    $0x4,%edx
  802683:	01 d0                	add    %edx,%eax
  802685:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80268b:	89 10                	mov    %edx,(%eax)
  80268d:	8b 00                	mov    (%eax),%eax
  80268f:	85 c0                	test   %eax,%eax
  802691:	74 18                	je     8026ab <initialize_MemBlocksList+0x88>
  802693:	a1 48 51 80 00       	mov    0x805148,%eax
  802698:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80269e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8026a1:	c1 e1 04             	shl    $0x4,%ecx
  8026a4:	01 ca                	add    %ecx,%edx
  8026a6:	89 50 04             	mov    %edx,0x4(%eax)
  8026a9:	eb 12                	jmp    8026bd <initialize_MemBlocksList+0x9a>
  8026ab:	a1 50 50 80 00       	mov    0x805050,%eax
  8026b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026b3:	c1 e2 04             	shl    $0x4,%edx
  8026b6:	01 d0                	add    %edx,%eax
  8026b8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026bd:	a1 50 50 80 00       	mov    0x805050,%eax
  8026c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c5:	c1 e2 04             	shl    $0x4,%edx
  8026c8:	01 d0                	add    %edx,%eax
  8026ca:	a3 48 51 80 00       	mov    %eax,0x805148
  8026cf:	a1 50 50 80 00       	mov    0x805050,%eax
  8026d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d7:	c1 e2 04             	shl    $0x4,%edx
  8026da:	01 d0                	add    %edx,%eax
  8026dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e3:	a1 54 51 80 00       	mov    0x805154,%eax
  8026e8:	40                   	inc    %eax
  8026e9:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8026ee:	ff 45 f4             	incl   -0xc(%ebp)
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026f7:	0f 82 56 ff ff ff    	jb     802653 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8026fd:	90                   	nop
  8026fe:	c9                   	leave  
  8026ff:	c3                   	ret    

00802700 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802700:	55                   	push   %ebp
  802701:	89 e5                	mov    %esp,%ebp
  802703:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802706:	a1 38 51 80 00       	mov    0x805138,%eax
  80270b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80270e:	eb 18                	jmp    802728 <find_block+0x28>
	{
		if (ele->sva==va)
  802710:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802713:	8b 40 08             	mov    0x8(%eax),%eax
  802716:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802719:	75 05                	jne    802720 <find_block+0x20>
			return ele;
  80271b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80271e:	eb 7b                	jmp    80279b <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802720:	a1 40 51 80 00       	mov    0x805140,%eax
  802725:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802728:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80272c:	74 07                	je     802735 <find_block+0x35>
  80272e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802731:	8b 00                	mov    (%eax),%eax
  802733:	eb 05                	jmp    80273a <find_block+0x3a>
  802735:	b8 00 00 00 00       	mov    $0x0,%eax
  80273a:	a3 40 51 80 00       	mov    %eax,0x805140
  80273f:	a1 40 51 80 00       	mov    0x805140,%eax
  802744:	85 c0                	test   %eax,%eax
  802746:	75 c8                	jne    802710 <find_block+0x10>
  802748:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80274c:	75 c2                	jne    802710 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80274e:	a1 40 50 80 00       	mov    0x805040,%eax
  802753:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802756:	eb 18                	jmp    802770 <find_block+0x70>
	{
		if (ele->sva==va)
  802758:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80275b:	8b 40 08             	mov    0x8(%eax),%eax
  80275e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802761:	75 05                	jne    802768 <find_block+0x68>
					return ele;
  802763:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802766:	eb 33                	jmp    80279b <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802768:	a1 48 50 80 00       	mov    0x805048,%eax
  80276d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802770:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802774:	74 07                	je     80277d <find_block+0x7d>
  802776:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802779:	8b 00                	mov    (%eax),%eax
  80277b:	eb 05                	jmp    802782 <find_block+0x82>
  80277d:	b8 00 00 00 00       	mov    $0x0,%eax
  802782:	a3 48 50 80 00       	mov    %eax,0x805048
  802787:	a1 48 50 80 00       	mov    0x805048,%eax
  80278c:	85 c0                	test   %eax,%eax
  80278e:	75 c8                	jne    802758 <find_block+0x58>
  802790:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802794:	75 c2                	jne    802758 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802796:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80279b:	c9                   	leave  
  80279c:	c3                   	ret    

0080279d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80279d:	55                   	push   %ebp
  80279e:	89 e5                	mov    %esp,%ebp
  8027a0:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  8027a3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027a8:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  8027ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027af:	75 62                	jne    802813 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8027b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027b5:	75 14                	jne    8027cb <insert_sorted_allocList+0x2e>
  8027b7:	83 ec 04             	sub    $0x4,%esp
  8027ba:	68 50 41 80 00       	push   $0x804150
  8027bf:	6a 69                	push   $0x69
  8027c1:	68 73 41 80 00       	push   $0x804173
  8027c6:	e8 41 e1 ff ff       	call   80090c <_panic>
  8027cb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d4:	89 10                	mov    %edx,(%eax)
  8027d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d9:	8b 00                	mov    (%eax),%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	74 0d                	je     8027ec <insert_sorted_allocList+0x4f>
  8027df:	a1 40 50 80 00       	mov    0x805040,%eax
  8027e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e7:	89 50 04             	mov    %edx,0x4(%eax)
  8027ea:	eb 08                	jmp    8027f4 <insert_sorted_allocList+0x57>
  8027ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ef:	a3 44 50 80 00       	mov    %eax,0x805044
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	a3 40 50 80 00       	mov    %eax,0x805040
  8027fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802806:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80280b:	40                   	inc    %eax
  80280c:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802811:	eb 72                	jmp    802885 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802813:	a1 40 50 80 00       	mov    0x805040,%eax
  802818:	8b 50 08             	mov    0x8(%eax),%edx
  80281b:	8b 45 08             	mov    0x8(%ebp),%eax
  80281e:	8b 40 08             	mov    0x8(%eax),%eax
  802821:	39 c2                	cmp    %eax,%edx
  802823:	76 60                	jbe    802885 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802825:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802829:	75 14                	jne    80283f <insert_sorted_allocList+0xa2>
  80282b:	83 ec 04             	sub    $0x4,%esp
  80282e:	68 50 41 80 00       	push   $0x804150
  802833:	6a 6d                	push   $0x6d
  802835:	68 73 41 80 00       	push   $0x804173
  80283a:	e8 cd e0 ff ff       	call   80090c <_panic>
  80283f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802845:	8b 45 08             	mov    0x8(%ebp),%eax
  802848:	89 10                	mov    %edx,(%eax)
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	74 0d                	je     802860 <insert_sorted_allocList+0xc3>
  802853:	a1 40 50 80 00       	mov    0x805040,%eax
  802858:	8b 55 08             	mov    0x8(%ebp),%edx
  80285b:	89 50 04             	mov    %edx,0x4(%eax)
  80285e:	eb 08                	jmp    802868 <insert_sorted_allocList+0xcb>
  802860:	8b 45 08             	mov    0x8(%ebp),%eax
  802863:	a3 44 50 80 00       	mov    %eax,0x805044
  802868:	8b 45 08             	mov    0x8(%ebp),%eax
  80286b:	a3 40 50 80 00       	mov    %eax,0x805040
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80287f:	40                   	inc    %eax
  802880:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802885:	a1 40 50 80 00       	mov    0x805040,%eax
  80288a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80288d:	e9 b9 01 00 00       	jmp    802a4b <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802892:	8b 45 08             	mov    0x8(%ebp),%eax
  802895:	8b 50 08             	mov    0x8(%eax),%edx
  802898:	a1 40 50 80 00       	mov    0x805040,%eax
  80289d:	8b 40 08             	mov    0x8(%eax),%eax
  8028a0:	39 c2                	cmp    %eax,%edx
  8028a2:	76 7c                	jbe    802920 <insert_sorted_allocList+0x183>
  8028a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a7:	8b 50 08             	mov    0x8(%eax),%edx
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	8b 40 08             	mov    0x8(%eax),%eax
  8028b0:	39 c2                	cmp    %eax,%edx
  8028b2:	73 6c                	jae    802920 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  8028b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b8:	74 06                	je     8028c0 <insert_sorted_allocList+0x123>
  8028ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028be:	75 14                	jne    8028d4 <insert_sorted_allocList+0x137>
  8028c0:	83 ec 04             	sub    $0x4,%esp
  8028c3:	68 8c 41 80 00       	push   $0x80418c
  8028c8:	6a 75                	push   $0x75
  8028ca:	68 73 41 80 00       	push   $0x804173
  8028cf:	e8 38 e0 ff ff       	call   80090c <_panic>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 50 04             	mov    0x4(%eax),%edx
  8028da:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dd:	89 50 04             	mov    %edx,0x4(%eax)
  8028e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028e6:	89 10                	mov    %edx,(%eax)
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ee:	85 c0                	test   %eax,%eax
  8028f0:	74 0d                	je     8028ff <insert_sorted_allocList+0x162>
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	8b 40 04             	mov    0x4(%eax),%eax
  8028f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028fb:	89 10                	mov    %edx,(%eax)
  8028fd:	eb 08                	jmp    802907 <insert_sorted_allocList+0x16a>
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	a3 40 50 80 00       	mov    %eax,0x805040
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	8b 55 08             	mov    0x8(%ebp),%edx
  80290d:	89 50 04             	mov    %edx,0x4(%eax)
  802910:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802915:	40                   	inc    %eax
  802916:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  80291b:	e9 59 01 00 00       	jmp    802a79 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	8b 50 08             	mov    0x8(%eax),%edx
  802926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802929:	8b 40 08             	mov    0x8(%eax),%eax
  80292c:	39 c2                	cmp    %eax,%edx
  80292e:	0f 86 98 00 00 00    	jbe    8029cc <insert_sorted_allocList+0x22f>
  802934:	8b 45 08             	mov    0x8(%ebp),%eax
  802937:	8b 50 08             	mov    0x8(%eax),%edx
  80293a:	a1 44 50 80 00       	mov    0x805044,%eax
  80293f:	8b 40 08             	mov    0x8(%eax),%eax
  802942:	39 c2                	cmp    %eax,%edx
  802944:	0f 83 82 00 00 00    	jae    8029cc <insert_sorted_allocList+0x22f>
  80294a:	8b 45 08             	mov    0x8(%ebp),%eax
  80294d:	8b 50 08             	mov    0x8(%eax),%edx
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 00                	mov    (%eax),%eax
  802955:	8b 40 08             	mov    0x8(%eax),%eax
  802958:	39 c2                	cmp    %eax,%edx
  80295a:	73 70                	jae    8029cc <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80295c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802960:	74 06                	je     802968 <insert_sorted_allocList+0x1cb>
  802962:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802966:	75 14                	jne    80297c <insert_sorted_allocList+0x1df>
  802968:	83 ec 04             	sub    $0x4,%esp
  80296b:	68 c4 41 80 00       	push   $0x8041c4
  802970:	6a 7c                	push   $0x7c
  802972:	68 73 41 80 00       	push   $0x804173
  802977:	e8 90 df ff ff       	call   80090c <_panic>
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	8b 10                	mov    (%eax),%edx
  802981:	8b 45 08             	mov    0x8(%ebp),%eax
  802984:	89 10                	mov    %edx,(%eax)
  802986:	8b 45 08             	mov    0x8(%ebp),%eax
  802989:	8b 00                	mov    (%eax),%eax
  80298b:	85 c0                	test   %eax,%eax
  80298d:	74 0b                	je     80299a <insert_sorted_allocList+0x1fd>
  80298f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	8b 55 08             	mov    0x8(%ebp),%edx
  802997:	89 50 04             	mov    %edx,0x4(%eax)
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a0:	89 10                	mov    %edx,(%eax)
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a8:	89 50 04             	mov    %edx,0x4(%eax)
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	85 c0                	test   %eax,%eax
  8029b2:	75 08                	jne    8029bc <insert_sorted_allocList+0x21f>
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	a3 44 50 80 00       	mov    %eax,0x805044
  8029bc:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029c1:	40                   	inc    %eax
  8029c2:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  8029c7:	e9 ad 00 00 00       	jmp    802a79 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	8b 50 08             	mov    0x8(%eax),%edx
  8029d2:	a1 44 50 80 00       	mov    0x805044,%eax
  8029d7:	8b 40 08             	mov    0x8(%eax),%eax
  8029da:	39 c2                	cmp    %eax,%edx
  8029dc:	76 65                	jbe    802a43 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8029de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029e2:	75 17                	jne    8029fb <insert_sorted_allocList+0x25e>
  8029e4:	83 ec 04             	sub    $0x4,%esp
  8029e7:	68 f8 41 80 00       	push   $0x8041f8
  8029ec:	68 80 00 00 00       	push   $0x80
  8029f1:	68 73 41 80 00       	push   $0x804173
  8029f6:	e8 11 df ff ff       	call   80090c <_panic>
  8029fb:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	89 50 04             	mov    %edx,0x4(%eax)
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	8b 40 04             	mov    0x4(%eax),%eax
  802a0d:	85 c0                	test   %eax,%eax
  802a0f:	74 0c                	je     802a1d <insert_sorted_allocList+0x280>
  802a11:	a1 44 50 80 00       	mov    0x805044,%eax
  802a16:	8b 55 08             	mov    0x8(%ebp),%edx
  802a19:	89 10                	mov    %edx,(%eax)
  802a1b:	eb 08                	jmp    802a25 <insert_sorted_allocList+0x288>
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	a3 40 50 80 00       	mov    %eax,0x805040
  802a25:	8b 45 08             	mov    0x8(%ebp),%eax
  802a28:	a3 44 50 80 00       	mov    %eax,0x805044
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a36:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a3b:	40                   	inc    %eax
  802a3c:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802a41:	eb 36                	jmp    802a79 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802a43:	a1 48 50 80 00       	mov    0x805048,%eax
  802a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4f:	74 07                	je     802a58 <insert_sorted_allocList+0x2bb>
  802a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a54:	8b 00                	mov    (%eax),%eax
  802a56:	eb 05                	jmp    802a5d <insert_sorted_allocList+0x2c0>
  802a58:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5d:	a3 48 50 80 00       	mov    %eax,0x805048
  802a62:	a1 48 50 80 00       	mov    0x805048,%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	0f 85 23 fe ff ff    	jne    802892 <insert_sorted_allocList+0xf5>
  802a6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a73:	0f 85 19 fe ff ff    	jne    802892 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802a79:	90                   	nop
  802a7a:	c9                   	leave  
  802a7b:	c3                   	ret    

00802a7c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a7c:	55                   	push   %ebp
  802a7d:	89 e5                	mov    %esp,%ebp
  802a7f:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802a82:	a1 38 51 80 00       	mov    0x805138,%eax
  802a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a8a:	e9 7c 01 00 00       	jmp    802c0b <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 40 0c             	mov    0xc(%eax),%eax
  802a95:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a98:	0f 85 90 00 00 00    	jne    802b2e <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802aa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa8:	75 17                	jne    802ac1 <alloc_block_FF+0x45>
  802aaa:	83 ec 04             	sub    $0x4,%esp
  802aad:	68 1b 42 80 00       	push   $0x80421b
  802ab2:	68 ba 00 00 00       	push   $0xba
  802ab7:	68 73 41 80 00       	push   $0x804173
  802abc:	e8 4b de ff ff       	call   80090c <_panic>
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	74 10                	je     802ada <alloc_block_FF+0x5e>
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 00                	mov    (%eax),%eax
  802acf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ad2:	8b 52 04             	mov    0x4(%edx),%edx
  802ad5:	89 50 04             	mov    %edx,0x4(%eax)
  802ad8:	eb 0b                	jmp    802ae5 <alloc_block_FF+0x69>
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	8b 40 04             	mov    0x4(%eax),%eax
  802ae0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 40 04             	mov    0x4(%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	74 0f                	je     802afe <alloc_block_FF+0x82>
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 40 04             	mov    0x4(%eax),%eax
  802af5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af8:	8b 12                	mov    (%edx),%edx
  802afa:	89 10                	mov    %edx,(%eax)
  802afc:	eb 0a                	jmp    802b08 <alloc_block_FF+0x8c>
  802afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b01:	8b 00                	mov    (%eax),%eax
  802b03:	a3 38 51 80 00       	mov    %eax,0x805138
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b1b:	a1 44 51 80 00       	mov    0x805144,%eax
  802b20:	48                   	dec    %eax
  802b21:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b29:	e9 10 01 00 00       	jmp    802c3e <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	8b 40 0c             	mov    0xc(%eax),%eax
  802b34:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b37:	0f 86 c6 00 00 00    	jbe    802c03 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802b3d:	a1 48 51 80 00       	mov    0x805148,%eax
  802b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802b45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b49:	75 17                	jne    802b62 <alloc_block_FF+0xe6>
  802b4b:	83 ec 04             	sub    $0x4,%esp
  802b4e:	68 1b 42 80 00       	push   $0x80421b
  802b53:	68 c2 00 00 00       	push   $0xc2
  802b58:	68 73 41 80 00       	push   $0x804173
  802b5d:	e8 aa dd ff ff       	call   80090c <_panic>
  802b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	85 c0                	test   %eax,%eax
  802b69:	74 10                	je     802b7b <alloc_block_FF+0xff>
  802b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6e:	8b 00                	mov    (%eax),%eax
  802b70:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b73:	8b 52 04             	mov    0x4(%edx),%edx
  802b76:	89 50 04             	mov    %edx,0x4(%eax)
  802b79:	eb 0b                	jmp    802b86 <alloc_block_FF+0x10a>
  802b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7e:	8b 40 04             	mov    0x4(%eax),%eax
  802b81:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	8b 40 04             	mov    0x4(%eax),%eax
  802b8c:	85 c0                	test   %eax,%eax
  802b8e:	74 0f                	je     802b9f <alloc_block_FF+0x123>
  802b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b93:	8b 40 04             	mov    0x4(%eax),%eax
  802b96:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b99:	8b 12                	mov    (%edx),%edx
  802b9b:	89 10                	mov    %edx,(%eax)
  802b9d:	eb 0a                	jmp    802ba9 <alloc_block_FF+0x12d>
  802b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbc:	a1 54 51 80 00       	mov    0x805154,%eax
  802bc1:	48                   	dec    %eax
  802bc2:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bca:	8b 50 08             	mov    0x8(%eax),%edx
  802bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd0:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd9:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	8b 40 0c             	mov    0xc(%eax),%eax
  802be2:	2b 45 08             	sub    0x8(%ebp),%eax
  802be5:	89 c2                	mov    %eax,%edx
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf0:	8b 50 08             	mov    0x8(%eax),%edx
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	01 c2                	add    %eax,%edx
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c01:	eb 3b                	jmp    802c3e <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802c03:	a1 40 51 80 00       	mov    0x805140,%eax
  802c08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0f:	74 07                	je     802c18 <alloc_block_FF+0x19c>
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 00                	mov    (%eax),%eax
  802c16:	eb 05                	jmp    802c1d <alloc_block_FF+0x1a1>
  802c18:	b8 00 00 00 00       	mov    $0x0,%eax
  802c1d:	a3 40 51 80 00       	mov    %eax,0x805140
  802c22:	a1 40 51 80 00       	mov    0x805140,%eax
  802c27:	85 c0                	test   %eax,%eax
  802c29:	0f 85 60 fe ff ff    	jne    802a8f <alloc_block_FF+0x13>
  802c2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c33:	0f 85 56 fe ff ff    	jne    802a8f <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802c39:	b8 00 00 00 00       	mov    $0x0,%eax
  802c3e:	c9                   	leave  
  802c3f:	c3                   	ret    

00802c40 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802c40:	55                   	push   %ebp
  802c41:	89 e5                	mov    %esp,%ebp
  802c43:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802c46:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802c4d:	a1 38 51 80 00       	mov    0x805138,%eax
  802c52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c55:	eb 3a                	jmp    802c91 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c60:	72 27                	jb     802c89 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802c62:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c66:	75 0b                	jne    802c73 <alloc_block_BF+0x33>
					best_size= element->size;
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c71:	eb 16                	jmp    802c89 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 50 0c             	mov    0xc(%eax),%edx
  802c79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7c:	39 c2                	cmp    %eax,%edx
  802c7e:	77 09                	ja     802c89 <alloc_block_BF+0x49>
					best_size=element->size;
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	8b 40 0c             	mov    0xc(%eax),%eax
  802c86:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802c89:	a1 40 51 80 00       	mov    0x805140,%eax
  802c8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c95:	74 07                	je     802c9e <alloc_block_BF+0x5e>
  802c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9a:	8b 00                	mov    (%eax),%eax
  802c9c:	eb 05                	jmp    802ca3 <alloc_block_BF+0x63>
  802c9e:	b8 00 00 00 00       	mov    $0x0,%eax
  802ca3:	a3 40 51 80 00       	mov    %eax,0x805140
  802ca8:	a1 40 51 80 00       	mov    0x805140,%eax
  802cad:	85 c0                	test   %eax,%eax
  802caf:	75 a6                	jne    802c57 <alloc_block_BF+0x17>
  802cb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb5:	75 a0                	jne    802c57 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802cb7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802cbb:	0f 84 d3 01 00 00    	je     802e94 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802cc1:	a1 38 51 80 00       	mov    0x805138,%eax
  802cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc9:	e9 98 01 00 00       	jmp    802e66 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd1:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd4:	0f 86 da 00 00 00    	jbe    802db4 <alloc_block_BF+0x174>
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ce3:	39 c2                	cmp    %eax,%edx
  802ce5:	0f 85 c9 00 00 00    	jne    802db4 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802ceb:	a1 48 51 80 00       	mov    0x805148,%eax
  802cf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802cf3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cf7:	75 17                	jne    802d10 <alloc_block_BF+0xd0>
  802cf9:	83 ec 04             	sub    $0x4,%esp
  802cfc:	68 1b 42 80 00       	push   $0x80421b
  802d01:	68 ea 00 00 00       	push   $0xea
  802d06:	68 73 41 80 00       	push   $0x804173
  802d0b:	e8 fc db ff ff       	call   80090c <_panic>
  802d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d13:	8b 00                	mov    (%eax),%eax
  802d15:	85 c0                	test   %eax,%eax
  802d17:	74 10                	je     802d29 <alloc_block_BF+0xe9>
  802d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d21:	8b 52 04             	mov    0x4(%edx),%edx
  802d24:	89 50 04             	mov    %edx,0x4(%eax)
  802d27:	eb 0b                	jmp    802d34 <alloc_block_BF+0xf4>
  802d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d2c:	8b 40 04             	mov    0x4(%eax),%eax
  802d2f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d37:	8b 40 04             	mov    0x4(%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	74 0f                	je     802d4d <alloc_block_BF+0x10d>
  802d3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d41:	8b 40 04             	mov    0x4(%eax),%eax
  802d44:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d47:	8b 12                	mov    (%edx),%edx
  802d49:	89 10                	mov    %edx,(%eax)
  802d4b:	eb 0a                	jmp    802d57 <alloc_block_BF+0x117>
  802d4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d50:	8b 00                	mov    (%eax),%eax
  802d52:	a3 48 51 80 00       	mov    %eax,0x805148
  802d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6a:	a1 54 51 80 00       	mov    0x805154,%eax
  802d6f:	48                   	dec    %eax
  802d70:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	8b 50 08             	mov    0x8(%eax),%edx
  802d7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7e:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d84:	8b 55 08             	mov    0x8(%ebp),%edx
  802d87:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d90:	2b 45 08             	sub    0x8(%ebp),%eax
  802d93:	89 c2                	mov    %eax,%edx
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 50 08             	mov    0x8(%eax),%edx
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	01 c2                	add    %eax,%edx
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802dac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802daf:	e9 e5 00 00 00       	jmp    802e99 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 50 0c             	mov    0xc(%eax),%edx
  802dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dbd:	39 c2                	cmp    %eax,%edx
  802dbf:	0f 85 99 00 00 00    	jne    802e5e <alloc_block_BF+0x21e>
  802dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dcb:	0f 85 8d 00 00 00    	jne    802e5e <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802dd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddb:	75 17                	jne    802df4 <alloc_block_BF+0x1b4>
  802ddd:	83 ec 04             	sub    $0x4,%esp
  802de0:	68 1b 42 80 00       	push   $0x80421b
  802de5:	68 f7 00 00 00       	push   $0xf7
  802dea:	68 73 41 80 00       	push   $0x804173
  802def:	e8 18 db ff ff       	call   80090c <_panic>
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	8b 00                	mov    (%eax),%eax
  802df9:	85 c0                	test   %eax,%eax
  802dfb:	74 10                	je     802e0d <alloc_block_BF+0x1cd>
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 00                	mov    (%eax),%eax
  802e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e05:	8b 52 04             	mov    0x4(%edx),%edx
  802e08:	89 50 04             	mov    %edx,0x4(%eax)
  802e0b:	eb 0b                	jmp    802e18 <alloc_block_BF+0x1d8>
  802e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e10:	8b 40 04             	mov    0x4(%eax),%eax
  802e13:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	8b 40 04             	mov    0x4(%eax),%eax
  802e1e:	85 c0                	test   %eax,%eax
  802e20:	74 0f                	je     802e31 <alloc_block_BF+0x1f1>
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 40 04             	mov    0x4(%eax),%eax
  802e28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e2b:	8b 12                	mov    (%edx),%edx
  802e2d:	89 10                	mov    %edx,(%eax)
  802e2f:	eb 0a                	jmp    802e3b <alloc_block_BF+0x1fb>
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 00                	mov    (%eax),%eax
  802e36:	a3 38 51 80 00       	mov    %eax,0x805138
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e53:	48                   	dec    %eax
  802e54:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5c:	eb 3b                	jmp    802e99 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802e5e:	a1 40 51 80 00       	mov    0x805140,%eax
  802e63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6a:	74 07                	je     802e73 <alloc_block_BF+0x233>
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 00                	mov    (%eax),%eax
  802e71:	eb 05                	jmp    802e78 <alloc_block_BF+0x238>
  802e73:	b8 00 00 00 00       	mov    $0x0,%eax
  802e78:	a3 40 51 80 00       	mov    %eax,0x805140
  802e7d:	a1 40 51 80 00       	mov    0x805140,%eax
  802e82:	85 c0                	test   %eax,%eax
  802e84:	0f 85 44 fe ff ff    	jne    802cce <alloc_block_BF+0x8e>
  802e8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8e:	0f 85 3a fe ff ff    	jne    802cce <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802e94:	b8 00 00 00 00       	mov    $0x0,%eax
  802e99:	c9                   	leave  
  802e9a:	c3                   	ret    

00802e9b <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e9b:	55                   	push   %ebp
  802e9c:	89 e5                	mov    %esp,%ebp
  802e9e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802ea1:	83 ec 04             	sub    $0x4,%esp
  802ea4:	68 3c 42 80 00       	push   $0x80423c
  802ea9:	68 04 01 00 00       	push   $0x104
  802eae:	68 73 41 80 00       	push   $0x804173
  802eb3:	e8 54 da ff ff       	call   80090c <_panic>

00802eb8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802eb8:	55                   	push   %ebp
  802eb9:	89 e5                	mov    %esp,%ebp
  802ebb:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802ebe:	a1 38 51 80 00       	mov    0x805138,%eax
  802ec3:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802ec6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ecb:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802ece:	a1 38 51 80 00       	mov    0x805138,%eax
  802ed3:	85 c0                	test   %eax,%eax
  802ed5:	75 68                	jne    802f3f <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802ed7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802edb:	75 17                	jne    802ef4 <insert_sorted_with_merge_freeList+0x3c>
  802edd:	83 ec 04             	sub    $0x4,%esp
  802ee0:	68 50 41 80 00       	push   $0x804150
  802ee5:	68 14 01 00 00       	push   $0x114
  802eea:	68 73 41 80 00       	push   $0x804173
  802eef:	e8 18 da ff ff       	call   80090c <_panic>
  802ef4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	89 10                	mov    %edx,(%eax)
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	8b 00                	mov    (%eax),%eax
  802f04:	85 c0                	test   %eax,%eax
  802f06:	74 0d                	je     802f15 <insert_sorted_with_merge_freeList+0x5d>
  802f08:	a1 38 51 80 00       	mov    0x805138,%eax
  802f0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f10:	89 50 04             	mov    %edx,0x4(%eax)
  802f13:	eb 08                	jmp    802f1d <insert_sorted_with_merge_freeList+0x65>
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	a3 38 51 80 00       	mov    %eax,0x805138
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2f:	a1 44 51 80 00       	mov    0x805144,%eax
  802f34:	40                   	inc    %eax
  802f35:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802f3a:	e9 d2 06 00 00       	jmp    803611 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	8b 50 08             	mov    0x8(%eax),%edx
  802f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f48:	8b 40 08             	mov    0x8(%eax),%eax
  802f4b:	39 c2                	cmp    %eax,%edx
  802f4d:	0f 83 22 01 00 00    	jae    803075 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	8b 50 08             	mov    0x8(%eax),%edx
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5f:	01 c2                	add    %eax,%edx
  802f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f64:	8b 40 08             	mov    0x8(%eax),%eax
  802f67:	39 c2                	cmp    %eax,%edx
  802f69:	0f 85 9e 00 00 00    	jne    80300d <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	8b 50 08             	mov    0x8(%eax),%edx
  802f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f78:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7e:	8b 50 0c             	mov    0xc(%eax),%edx
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	8b 40 0c             	mov    0xc(%eax),%eax
  802f87:	01 c2                	add    %eax,%edx
  802f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8c:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	8b 50 08             	mov    0x8(%eax),%edx
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802fa5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa9:	75 17                	jne    802fc2 <insert_sorted_with_merge_freeList+0x10a>
  802fab:	83 ec 04             	sub    $0x4,%esp
  802fae:	68 50 41 80 00       	push   $0x804150
  802fb3:	68 21 01 00 00       	push   $0x121
  802fb8:	68 73 41 80 00       	push   $0x804173
  802fbd:	e8 4a d9 ff ff       	call   80090c <_panic>
  802fc2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	89 10                	mov    %edx,(%eax)
  802fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd0:	8b 00                	mov    (%eax),%eax
  802fd2:	85 c0                	test   %eax,%eax
  802fd4:	74 0d                	je     802fe3 <insert_sorted_with_merge_freeList+0x12b>
  802fd6:	a1 48 51 80 00       	mov    0x805148,%eax
  802fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  802fde:	89 50 04             	mov    %edx,0x4(%eax)
  802fe1:	eb 08                	jmp    802feb <insert_sorted_with_merge_freeList+0x133>
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffd:	a1 54 51 80 00       	mov    0x805154,%eax
  803002:	40                   	inc    %eax
  803003:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803008:	e9 04 06 00 00       	jmp    803611 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80300d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803011:	75 17                	jne    80302a <insert_sorted_with_merge_freeList+0x172>
  803013:	83 ec 04             	sub    $0x4,%esp
  803016:	68 50 41 80 00       	push   $0x804150
  80301b:	68 26 01 00 00       	push   $0x126
  803020:	68 73 41 80 00       	push   $0x804173
  803025:	e8 e2 d8 ff ff       	call   80090c <_panic>
  80302a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	89 10                	mov    %edx,(%eax)
  803035:	8b 45 08             	mov    0x8(%ebp),%eax
  803038:	8b 00                	mov    (%eax),%eax
  80303a:	85 c0                	test   %eax,%eax
  80303c:	74 0d                	je     80304b <insert_sorted_with_merge_freeList+0x193>
  80303e:	a1 38 51 80 00       	mov    0x805138,%eax
  803043:	8b 55 08             	mov    0x8(%ebp),%edx
  803046:	89 50 04             	mov    %edx,0x4(%eax)
  803049:	eb 08                	jmp    803053 <insert_sorted_with_merge_freeList+0x19b>
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	a3 38 51 80 00       	mov    %eax,0x805138
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803065:	a1 44 51 80 00       	mov    0x805144,%eax
  80306a:	40                   	inc    %eax
  80306b:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803070:	e9 9c 05 00 00       	jmp    803611 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	8b 50 08             	mov    0x8(%eax),%edx
  80307b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307e:	8b 40 08             	mov    0x8(%eax),%eax
  803081:	39 c2                	cmp    %eax,%edx
  803083:	0f 86 16 01 00 00    	jbe    80319f <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803089:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308c:	8b 50 08             	mov    0x8(%eax),%edx
  80308f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803092:	8b 40 0c             	mov    0xc(%eax),%eax
  803095:	01 c2                	add    %eax,%edx
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	8b 40 08             	mov    0x8(%eax),%eax
  80309d:	39 c2                	cmp    %eax,%edx
  80309f:	0f 85 92 00 00 00    	jne    803137 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  8030a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030a8:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b1:	01 c2                	add    %eax,%edx
  8030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b6:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c6:	8b 50 08             	mov    0x8(%eax),%edx
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8030cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030d3:	75 17                	jne    8030ec <insert_sorted_with_merge_freeList+0x234>
  8030d5:	83 ec 04             	sub    $0x4,%esp
  8030d8:	68 50 41 80 00       	push   $0x804150
  8030dd:	68 31 01 00 00       	push   $0x131
  8030e2:	68 73 41 80 00       	push   $0x804173
  8030e7:	e8 20 d8 ff ff       	call   80090c <_panic>
  8030ec:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	89 10                	mov    %edx,(%eax)
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	8b 00                	mov    (%eax),%eax
  8030fc:	85 c0                	test   %eax,%eax
  8030fe:	74 0d                	je     80310d <insert_sorted_with_merge_freeList+0x255>
  803100:	a1 48 51 80 00       	mov    0x805148,%eax
  803105:	8b 55 08             	mov    0x8(%ebp),%edx
  803108:	89 50 04             	mov    %edx,0x4(%eax)
  80310b:	eb 08                	jmp    803115 <insert_sorted_with_merge_freeList+0x25d>
  80310d:	8b 45 08             	mov    0x8(%ebp),%eax
  803110:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803115:	8b 45 08             	mov    0x8(%ebp),%eax
  803118:	a3 48 51 80 00       	mov    %eax,0x805148
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803127:	a1 54 51 80 00       	mov    0x805154,%eax
  80312c:	40                   	inc    %eax
  80312d:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803132:	e9 da 04 00 00       	jmp    803611 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  803137:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313b:	75 17                	jne    803154 <insert_sorted_with_merge_freeList+0x29c>
  80313d:	83 ec 04             	sub    $0x4,%esp
  803140:	68 f8 41 80 00       	push   $0x8041f8
  803145:	68 37 01 00 00       	push   $0x137
  80314a:	68 73 41 80 00       	push   $0x804173
  80314f:	e8 b8 d7 ff ff       	call   80090c <_panic>
  803154:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	89 50 04             	mov    %edx,0x4(%eax)
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	8b 40 04             	mov    0x4(%eax),%eax
  803166:	85 c0                	test   %eax,%eax
  803168:	74 0c                	je     803176 <insert_sorted_with_merge_freeList+0x2be>
  80316a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80316f:	8b 55 08             	mov    0x8(%ebp),%edx
  803172:	89 10                	mov    %edx,(%eax)
  803174:	eb 08                	jmp    80317e <insert_sorted_with_merge_freeList+0x2c6>
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	a3 38 51 80 00       	mov    %eax,0x805138
  80317e:	8b 45 08             	mov    0x8(%ebp),%eax
  803181:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803186:	8b 45 08             	mov    0x8(%ebp),%eax
  803189:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318f:	a1 44 51 80 00       	mov    0x805144,%eax
  803194:	40                   	inc    %eax
  803195:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  80319a:	e9 72 04 00 00       	jmp    803611 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80319f:	a1 38 51 80 00       	mov    0x805138,%eax
  8031a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031a7:	e9 35 04 00 00       	jmp    8035e1 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  8031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	8b 50 08             	mov    0x8(%eax),%edx
  8031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bd:	8b 40 08             	mov    0x8(%eax),%eax
  8031c0:	39 c2                	cmp    %eax,%edx
  8031c2:	0f 86 11 04 00 00    	jbe    8035d9 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  8031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cb:	8b 50 08             	mov    0x8(%eax),%edx
  8031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d4:	01 c2                	add    %eax,%edx
  8031d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d9:	8b 40 08             	mov    0x8(%eax),%eax
  8031dc:	39 c2                	cmp    %eax,%edx
  8031de:	0f 83 8b 00 00 00    	jae    80326f <insert_sorted_with_merge_freeList+0x3b7>
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	8b 50 08             	mov    0x8(%eax),%edx
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8031f0:	01 c2                	add    %eax,%edx
  8031f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031f5:	8b 40 08             	mov    0x8(%eax),%eax
  8031f8:	39 c2                	cmp    %eax,%edx
  8031fa:	73 73                	jae    80326f <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  8031fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803200:	74 06                	je     803208 <insert_sorted_with_merge_freeList+0x350>
  803202:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803206:	75 17                	jne    80321f <insert_sorted_with_merge_freeList+0x367>
  803208:	83 ec 04             	sub    $0x4,%esp
  80320b:	68 c4 41 80 00       	push   $0x8041c4
  803210:	68 48 01 00 00       	push   $0x148
  803215:	68 73 41 80 00       	push   $0x804173
  80321a:	e8 ed d6 ff ff       	call   80090c <_panic>
  80321f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803222:	8b 10                	mov    (%eax),%edx
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	89 10                	mov    %edx,(%eax)
  803229:	8b 45 08             	mov    0x8(%ebp),%eax
  80322c:	8b 00                	mov    (%eax),%eax
  80322e:	85 c0                	test   %eax,%eax
  803230:	74 0b                	je     80323d <insert_sorted_with_merge_freeList+0x385>
  803232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803235:	8b 00                	mov    (%eax),%eax
  803237:	8b 55 08             	mov    0x8(%ebp),%edx
  80323a:	89 50 04             	mov    %edx,0x4(%eax)
  80323d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803240:	8b 55 08             	mov    0x8(%ebp),%edx
  803243:	89 10                	mov    %edx,(%eax)
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80324b:	89 50 04             	mov    %edx,0x4(%eax)
  80324e:	8b 45 08             	mov    0x8(%ebp),%eax
  803251:	8b 00                	mov    (%eax),%eax
  803253:	85 c0                	test   %eax,%eax
  803255:	75 08                	jne    80325f <insert_sorted_with_merge_freeList+0x3a7>
  803257:	8b 45 08             	mov    0x8(%ebp),%eax
  80325a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80325f:	a1 44 51 80 00       	mov    0x805144,%eax
  803264:	40                   	inc    %eax
  803265:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  80326a:	e9 a2 03 00 00       	jmp    803611 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80326f:	8b 45 08             	mov    0x8(%ebp),%eax
  803272:	8b 50 08             	mov    0x8(%eax),%edx
  803275:	8b 45 08             	mov    0x8(%ebp),%eax
  803278:	8b 40 0c             	mov    0xc(%eax),%eax
  80327b:	01 c2                	add    %eax,%edx
  80327d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803280:	8b 40 08             	mov    0x8(%eax),%eax
  803283:	39 c2                	cmp    %eax,%edx
  803285:	0f 83 ae 00 00 00    	jae    803339 <insert_sorted_with_merge_freeList+0x481>
  80328b:	8b 45 08             	mov    0x8(%ebp),%eax
  80328e:	8b 50 08             	mov    0x8(%eax),%edx
  803291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803294:	8b 48 08             	mov    0x8(%eax),%ecx
  803297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329a:	8b 40 0c             	mov    0xc(%eax),%eax
  80329d:	01 c8                	add    %ecx,%eax
  80329f:	39 c2                	cmp    %eax,%edx
  8032a1:	0f 85 92 00 00 00    	jne    803339 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  8032a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032aa:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b3:	01 c2                	add    %eax,%edx
  8032b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b8:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  8032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032be:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	8b 50 08             	mov    0x8(%eax),%edx
  8032cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ce:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8032d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d5:	75 17                	jne    8032ee <insert_sorted_with_merge_freeList+0x436>
  8032d7:	83 ec 04             	sub    $0x4,%esp
  8032da:	68 50 41 80 00       	push   $0x804150
  8032df:	68 51 01 00 00       	push   $0x151
  8032e4:	68 73 41 80 00       	push   $0x804173
  8032e9:	e8 1e d6 ff ff       	call   80090c <_panic>
  8032ee:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f7:	89 10                	mov    %edx,(%eax)
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	8b 00                	mov    (%eax),%eax
  8032fe:	85 c0                	test   %eax,%eax
  803300:	74 0d                	je     80330f <insert_sorted_with_merge_freeList+0x457>
  803302:	a1 48 51 80 00       	mov    0x805148,%eax
  803307:	8b 55 08             	mov    0x8(%ebp),%edx
  80330a:	89 50 04             	mov    %edx,0x4(%eax)
  80330d:	eb 08                	jmp    803317 <insert_sorted_with_merge_freeList+0x45f>
  80330f:	8b 45 08             	mov    0x8(%ebp),%eax
  803312:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	a3 48 51 80 00       	mov    %eax,0x805148
  80331f:	8b 45 08             	mov    0x8(%ebp),%eax
  803322:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803329:	a1 54 51 80 00       	mov    0x805154,%eax
  80332e:	40                   	inc    %eax
  80332f:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  803334:	e9 d8 02 00 00       	jmp    803611 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  803339:	8b 45 08             	mov    0x8(%ebp),%eax
  80333c:	8b 50 08             	mov    0x8(%eax),%edx
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	8b 40 0c             	mov    0xc(%eax),%eax
  803345:	01 c2                	add    %eax,%edx
  803347:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80334a:	8b 40 08             	mov    0x8(%eax),%eax
  80334d:	39 c2                	cmp    %eax,%edx
  80334f:	0f 85 ba 00 00 00    	jne    80340f <insert_sorted_with_merge_freeList+0x557>
  803355:	8b 45 08             	mov    0x8(%ebp),%eax
  803358:	8b 50 08             	mov    0x8(%eax),%edx
  80335b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335e:	8b 48 08             	mov    0x8(%eax),%ecx
  803361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803364:	8b 40 0c             	mov    0xc(%eax),%eax
  803367:	01 c8                	add    %ecx,%eax
  803369:	39 c2                	cmp    %eax,%edx
  80336b:	0f 86 9e 00 00 00    	jbe    80340f <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803371:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803374:	8b 50 0c             	mov    0xc(%eax),%edx
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	8b 40 0c             	mov    0xc(%eax),%eax
  80337d:	01 c2                	add    %eax,%edx
  80337f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803382:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	8b 50 08             	mov    0x8(%eax),%edx
  80338b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338e:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803391:	8b 45 08             	mov    0x8(%ebp),%eax
  803394:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	8b 50 08             	mov    0x8(%eax),%edx
  8033a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a4:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8033a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ab:	75 17                	jne    8033c4 <insert_sorted_with_merge_freeList+0x50c>
  8033ad:	83 ec 04             	sub    $0x4,%esp
  8033b0:	68 50 41 80 00       	push   $0x804150
  8033b5:	68 5b 01 00 00       	push   $0x15b
  8033ba:	68 73 41 80 00       	push   $0x804173
  8033bf:	e8 48 d5 ff ff       	call   80090c <_panic>
  8033c4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cd:	89 10                	mov    %edx,(%eax)
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	85 c0                	test   %eax,%eax
  8033d6:	74 0d                	je     8033e5 <insert_sorted_with_merge_freeList+0x52d>
  8033d8:	a1 48 51 80 00       	mov    0x805148,%eax
  8033dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e0:	89 50 04             	mov    %edx,0x4(%eax)
  8033e3:	eb 08                	jmp    8033ed <insert_sorted_with_merge_freeList+0x535>
  8033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f0:	a3 48 51 80 00       	mov    %eax,0x805148
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ff:	a1 54 51 80 00       	mov    0x805154,%eax
  803404:	40                   	inc    %eax
  803405:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  80340a:	e9 02 02 00 00       	jmp    803611 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80340f:	8b 45 08             	mov    0x8(%ebp),%eax
  803412:	8b 50 08             	mov    0x8(%eax),%edx
  803415:	8b 45 08             	mov    0x8(%ebp),%eax
  803418:	8b 40 0c             	mov    0xc(%eax),%eax
  80341b:	01 c2                	add    %eax,%edx
  80341d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803420:	8b 40 08             	mov    0x8(%eax),%eax
  803423:	39 c2                	cmp    %eax,%edx
  803425:	0f 85 ae 01 00 00    	jne    8035d9 <insert_sorted_with_merge_freeList+0x721>
  80342b:	8b 45 08             	mov    0x8(%ebp),%eax
  80342e:	8b 50 08             	mov    0x8(%eax),%edx
  803431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803434:	8b 48 08             	mov    0x8(%eax),%ecx
  803437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343a:	8b 40 0c             	mov    0xc(%eax),%eax
  80343d:	01 c8                	add    %ecx,%eax
  80343f:	39 c2                	cmp    %eax,%edx
  803441:	0f 85 92 01 00 00    	jne    8035d9 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  803447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344a:	8b 50 0c             	mov    0xc(%eax),%edx
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	8b 40 0c             	mov    0xc(%eax),%eax
  803453:	01 c2                	add    %eax,%edx
  803455:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803458:	8b 40 0c             	mov    0xc(%eax),%eax
  80345b:	01 c2                	add    %eax,%edx
  80345d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803460:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803463:	8b 45 08             	mov    0x8(%ebp),%eax
  803466:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	8b 50 08             	mov    0x8(%eax),%edx
  803473:	8b 45 08             	mov    0x8(%ebp),%eax
  803476:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803479:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80347c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803483:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803486:	8b 50 08             	mov    0x8(%eax),%edx
  803489:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80348c:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  80348f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803493:	75 17                	jne    8034ac <insert_sorted_with_merge_freeList+0x5f4>
  803495:	83 ec 04             	sub    $0x4,%esp
  803498:	68 1b 42 80 00       	push   $0x80421b
  80349d:	68 63 01 00 00       	push   $0x163
  8034a2:	68 73 41 80 00       	push   $0x804173
  8034a7:	e8 60 d4 ff ff       	call   80090c <_panic>
  8034ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034af:	8b 00                	mov    (%eax),%eax
  8034b1:	85 c0                	test   %eax,%eax
  8034b3:	74 10                	je     8034c5 <insert_sorted_with_merge_freeList+0x60d>
  8034b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034b8:	8b 00                	mov    (%eax),%eax
  8034ba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034bd:	8b 52 04             	mov    0x4(%edx),%edx
  8034c0:	89 50 04             	mov    %edx,0x4(%eax)
  8034c3:	eb 0b                	jmp    8034d0 <insert_sorted_with_merge_freeList+0x618>
  8034c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c8:	8b 40 04             	mov    0x4(%eax),%eax
  8034cb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d3:	8b 40 04             	mov    0x4(%eax),%eax
  8034d6:	85 c0                	test   %eax,%eax
  8034d8:	74 0f                	je     8034e9 <insert_sorted_with_merge_freeList+0x631>
  8034da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034dd:	8b 40 04             	mov    0x4(%eax),%eax
  8034e0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034e3:	8b 12                	mov    (%edx),%edx
  8034e5:	89 10                	mov    %edx,(%eax)
  8034e7:	eb 0a                	jmp    8034f3 <insert_sorted_with_merge_freeList+0x63b>
  8034e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ec:	8b 00                	mov    (%eax),%eax
  8034ee:	a3 38 51 80 00       	mov    %eax,0x805138
  8034f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803506:	a1 44 51 80 00       	mov    0x805144,%eax
  80350b:	48                   	dec    %eax
  80350c:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  803511:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803515:	75 17                	jne    80352e <insert_sorted_with_merge_freeList+0x676>
  803517:	83 ec 04             	sub    $0x4,%esp
  80351a:	68 50 41 80 00       	push   $0x804150
  80351f:	68 64 01 00 00       	push   $0x164
  803524:	68 73 41 80 00       	push   $0x804173
  803529:	e8 de d3 ff ff       	call   80090c <_panic>
  80352e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803534:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803537:	89 10                	mov    %edx,(%eax)
  803539:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80353c:	8b 00                	mov    (%eax),%eax
  80353e:	85 c0                	test   %eax,%eax
  803540:	74 0d                	je     80354f <insert_sorted_with_merge_freeList+0x697>
  803542:	a1 48 51 80 00       	mov    0x805148,%eax
  803547:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80354a:	89 50 04             	mov    %edx,0x4(%eax)
  80354d:	eb 08                	jmp    803557 <insert_sorted_with_merge_freeList+0x69f>
  80354f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803552:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803557:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355a:	a3 48 51 80 00       	mov    %eax,0x805148
  80355f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803562:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803569:	a1 54 51 80 00       	mov    0x805154,%eax
  80356e:	40                   	inc    %eax
  80356f:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803574:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803578:	75 17                	jne    803591 <insert_sorted_with_merge_freeList+0x6d9>
  80357a:	83 ec 04             	sub    $0x4,%esp
  80357d:	68 50 41 80 00       	push   $0x804150
  803582:	68 65 01 00 00       	push   $0x165
  803587:	68 73 41 80 00       	push   $0x804173
  80358c:	e8 7b d3 ff ff       	call   80090c <_panic>
  803591:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803597:	8b 45 08             	mov    0x8(%ebp),%eax
  80359a:	89 10                	mov    %edx,(%eax)
  80359c:	8b 45 08             	mov    0x8(%ebp),%eax
  80359f:	8b 00                	mov    (%eax),%eax
  8035a1:	85 c0                	test   %eax,%eax
  8035a3:	74 0d                	je     8035b2 <insert_sorted_with_merge_freeList+0x6fa>
  8035a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8035aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8035ad:	89 50 04             	mov    %edx,0x4(%eax)
  8035b0:	eb 08                	jmp    8035ba <insert_sorted_with_merge_freeList+0x702>
  8035b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bd:	a3 48 51 80 00       	mov    %eax,0x805148
  8035c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035cc:	a1 54 51 80 00       	mov    0x805154,%eax
  8035d1:	40                   	inc    %eax
  8035d2:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8035d7:	eb 38                	jmp    803611 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8035d9:	a1 40 51 80 00       	mov    0x805140,%eax
  8035de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035e5:	74 07                	je     8035ee <insert_sorted_with_merge_freeList+0x736>
  8035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ea:	8b 00                	mov    (%eax),%eax
  8035ec:	eb 05                	jmp    8035f3 <insert_sorted_with_merge_freeList+0x73b>
  8035ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8035f3:	a3 40 51 80 00       	mov    %eax,0x805140
  8035f8:	a1 40 51 80 00       	mov    0x805140,%eax
  8035fd:	85 c0                	test   %eax,%eax
  8035ff:	0f 85 a7 fb ff ff    	jne    8031ac <insert_sorted_with_merge_freeList+0x2f4>
  803605:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803609:	0f 85 9d fb ff ff    	jne    8031ac <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  80360f:	eb 00                	jmp    803611 <insert_sorted_with_merge_freeList+0x759>
  803611:	90                   	nop
  803612:	c9                   	leave  
  803613:	c3                   	ret    

00803614 <__udivdi3>:
  803614:	55                   	push   %ebp
  803615:	57                   	push   %edi
  803616:	56                   	push   %esi
  803617:	53                   	push   %ebx
  803618:	83 ec 1c             	sub    $0x1c,%esp
  80361b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80361f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803623:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803627:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80362b:	89 ca                	mov    %ecx,%edx
  80362d:	89 f8                	mov    %edi,%eax
  80362f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803633:	85 f6                	test   %esi,%esi
  803635:	75 2d                	jne    803664 <__udivdi3+0x50>
  803637:	39 cf                	cmp    %ecx,%edi
  803639:	77 65                	ja     8036a0 <__udivdi3+0x8c>
  80363b:	89 fd                	mov    %edi,%ebp
  80363d:	85 ff                	test   %edi,%edi
  80363f:	75 0b                	jne    80364c <__udivdi3+0x38>
  803641:	b8 01 00 00 00       	mov    $0x1,%eax
  803646:	31 d2                	xor    %edx,%edx
  803648:	f7 f7                	div    %edi
  80364a:	89 c5                	mov    %eax,%ebp
  80364c:	31 d2                	xor    %edx,%edx
  80364e:	89 c8                	mov    %ecx,%eax
  803650:	f7 f5                	div    %ebp
  803652:	89 c1                	mov    %eax,%ecx
  803654:	89 d8                	mov    %ebx,%eax
  803656:	f7 f5                	div    %ebp
  803658:	89 cf                	mov    %ecx,%edi
  80365a:	89 fa                	mov    %edi,%edx
  80365c:	83 c4 1c             	add    $0x1c,%esp
  80365f:	5b                   	pop    %ebx
  803660:	5e                   	pop    %esi
  803661:	5f                   	pop    %edi
  803662:	5d                   	pop    %ebp
  803663:	c3                   	ret    
  803664:	39 ce                	cmp    %ecx,%esi
  803666:	77 28                	ja     803690 <__udivdi3+0x7c>
  803668:	0f bd fe             	bsr    %esi,%edi
  80366b:	83 f7 1f             	xor    $0x1f,%edi
  80366e:	75 40                	jne    8036b0 <__udivdi3+0x9c>
  803670:	39 ce                	cmp    %ecx,%esi
  803672:	72 0a                	jb     80367e <__udivdi3+0x6a>
  803674:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803678:	0f 87 9e 00 00 00    	ja     80371c <__udivdi3+0x108>
  80367e:	b8 01 00 00 00       	mov    $0x1,%eax
  803683:	89 fa                	mov    %edi,%edx
  803685:	83 c4 1c             	add    $0x1c,%esp
  803688:	5b                   	pop    %ebx
  803689:	5e                   	pop    %esi
  80368a:	5f                   	pop    %edi
  80368b:	5d                   	pop    %ebp
  80368c:	c3                   	ret    
  80368d:	8d 76 00             	lea    0x0(%esi),%esi
  803690:	31 ff                	xor    %edi,%edi
  803692:	31 c0                	xor    %eax,%eax
  803694:	89 fa                	mov    %edi,%edx
  803696:	83 c4 1c             	add    $0x1c,%esp
  803699:	5b                   	pop    %ebx
  80369a:	5e                   	pop    %esi
  80369b:	5f                   	pop    %edi
  80369c:	5d                   	pop    %ebp
  80369d:	c3                   	ret    
  80369e:	66 90                	xchg   %ax,%ax
  8036a0:	89 d8                	mov    %ebx,%eax
  8036a2:	f7 f7                	div    %edi
  8036a4:	31 ff                	xor    %edi,%edi
  8036a6:	89 fa                	mov    %edi,%edx
  8036a8:	83 c4 1c             	add    $0x1c,%esp
  8036ab:	5b                   	pop    %ebx
  8036ac:	5e                   	pop    %esi
  8036ad:	5f                   	pop    %edi
  8036ae:	5d                   	pop    %ebp
  8036af:	c3                   	ret    
  8036b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8036b5:	89 eb                	mov    %ebp,%ebx
  8036b7:	29 fb                	sub    %edi,%ebx
  8036b9:	89 f9                	mov    %edi,%ecx
  8036bb:	d3 e6                	shl    %cl,%esi
  8036bd:	89 c5                	mov    %eax,%ebp
  8036bf:	88 d9                	mov    %bl,%cl
  8036c1:	d3 ed                	shr    %cl,%ebp
  8036c3:	89 e9                	mov    %ebp,%ecx
  8036c5:	09 f1                	or     %esi,%ecx
  8036c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036cb:	89 f9                	mov    %edi,%ecx
  8036cd:	d3 e0                	shl    %cl,%eax
  8036cf:	89 c5                	mov    %eax,%ebp
  8036d1:	89 d6                	mov    %edx,%esi
  8036d3:	88 d9                	mov    %bl,%cl
  8036d5:	d3 ee                	shr    %cl,%esi
  8036d7:	89 f9                	mov    %edi,%ecx
  8036d9:	d3 e2                	shl    %cl,%edx
  8036db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036df:	88 d9                	mov    %bl,%cl
  8036e1:	d3 e8                	shr    %cl,%eax
  8036e3:	09 c2                	or     %eax,%edx
  8036e5:	89 d0                	mov    %edx,%eax
  8036e7:	89 f2                	mov    %esi,%edx
  8036e9:	f7 74 24 0c          	divl   0xc(%esp)
  8036ed:	89 d6                	mov    %edx,%esi
  8036ef:	89 c3                	mov    %eax,%ebx
  8036f1:	f7 e5                	mul    %ebp
  8036f3:	39 d6                	cmp    %edx,%esi
  8036f5:	72 19                	jb     803710 <__udivdi3+0xfc>
  8036f7:	74 0b                	je     803704 <__udivdi3+0xf0>
  8036f9:	89 d8                	mov    %ebx,%eax
  8036fb:	31 ff                	xor    %edi,%edi
  8036fd:	e9 58 ff ff ff       	jmp    80365a <__udivdi3+0x46>
  803702:	66 90                	xchg   %ax,%ax
  803704:	8b 54 24 08          	mov    0x8(%esp),%edx
  803708:	89 f9                	mov    %edi,%ecx
  80370a:	d3 e2                	shl    %cl,%edx
  80370c:	39 c2                	cmp    %eax,%edx
  80370e:	73 e9                	jae    8036f9 <__udivdi3+0xe5>
  803710:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803713:	31 ff                	xor    %edi,%edi
  803715:	e9 40 ff ff ff       	jmp    80365a <__udivdi3+0x46>
  80371a:	66 90                	xchg   %ax,%ax
  80371c:	31 c0                	xor    %eax,%eax
  80371e:	e9 37 ff ff ff       	jmp    80365a <__udivdi3+0x46>
  803723:	90                   	nop

00803724 <__umoddi3>:
  803724:	55                   	push   %ebp
  803725:	57                   	push   %edi
  803726:	56                   	push   %esi
  803727:	53                   	push   %ebx
  803728:	83 ec 1c             	sub    $0x1c,%esp
  80372b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80372f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803733:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803737:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80373b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80373f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803743:	89 f3                	mov    %esi,%ebx
  803745:	89 fa                	mov    %edi,%edx
  803747:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80374b:	89 34 24             	mov    %esi,(%esp)
  80374e:	85 c0                	test   %eax,%eax
  803750:	75 1a                	jne    80376c <__umoddi3+0x48>
  803752:	39 f7                	cmp    %esi,%edi
  803754:	0f 86 a2 00 00 00    	jbe    8037fc <__umoddi3+0xd8>
  80375a:	89 c8                	mov    %ecx,%eax
  80375c:	89 f2                	mov    %esi,%edx
  80375e:	f7 f7                	div    %edi
  803760:	89 d0                	mov    %edx,%eax
  803762:	31 d2                	xor    %edx,%edx
  803764:	83 c4 1c             	add    $0x1c,%esp
  803767:	5b                   	pop    %ebx
  803768:	5e                   	pop    %esi
  803769:	5f                   	pop    %edi
  80376a:	5d                   	pop    %ebp
  80376b:	c3                   	ret    
  80376c:	39 f0                	cmp    %esi,%eax
  80376e:	0f 87 ac 00 00 00    	ja     803820 <__umoddi3+0xfc>
  803774:	0f bd e8             	bsr    %eax,%ebp
  803777:	83 f5 1f             	xor    $0x1f,%ebp
  80377a:	0f 84 ac 00 00 00    	je     80382c <__umoddi3+0x108>
  803780:	bf 20 00 00 00       	mov    $0x20,%edi
  803785:	29 ef                	sub    %ebp,%edi
  803787:	89 fe                	mov    %edi,%esi
  803789:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80378d:	89 e9                	mov    %ebp,%ecx
  80378f:	d3 e0                	shl    %cl,%eax
  803791:	89 d7                	mov    %edx,%edi
  803793:	89 f1                	mov    %esi,%ecx
  803795:	d3 ef                	shr    %cl,%edi
  803797:	09 c7                	or     %eax,%edi
  803799:	89 e9                	mov    %ebp,%ecx
  80379b:	d3 e2                	shl    %cl,%edx
  80379d:	89 14 24             	mov    %edx,(%esp)
  8037a0:	89 d8                	mov    %ebx,%eax
  8037a2:	d3 e0                	shl    %cl,%eax
  8037a4:	89 c2                	mov    %eax,%edx
  8037a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037aa:	d3 e0                	shl    %cl,%eax
  8037ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037b4:	89 f1                	mov    %esi,%ecx
  8037b6:	d3 e8                	shr    %cl,%eax
  8037b8:	09 d0                	or     %edx,%eax
  8037ba:	d3 eb                	shr    %cl,%ebx
  8037bc:	89 da                	mov    %ebx,%edx
  8037be:	f7 f7                	div    %edi
  8037c0:	89 d3                	mov    %edx,%ebx
  8037c2:	f7 24 24             	mull   (%esp)
  8037c5:	89 c6                	mov    %eax,%esi
  8037c7:	89 d1                	mov    %edx,%ecx
  8037c9:	39 d3                	cmp    %edx,%ebx
  8037cb:	0f 82 87 00 00 00    	jb     803858 <__umoddi3+0x134>
  8037d1:	0f 84 91 00 00 00    	je     803868 <__umoddi3+0x144>
  8037d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037db:	29 f2                	sub    %esi,%edx
  8037dd:	19 cb                	sbb    %ecx,%ebx
  8037df:	89 d8                	mov    %ebx,%eax
  8037e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037e5:	d3 e0                	shl    %cl,%eax
  8037e7:	89 e9                	mov    %ebp,%ecx
  8037e9:	d3 ea                	shr    %cl,%edx
  8037eb:	09 d0                	or     %edx,%eax
  8037ed:	89 e9                	mov    %ebp,%ecx
  8037ef:	d3 eb                	shr    %cl,%ebx
  8037f1:	89 da                	mov    %ebx,%edx
  8037f3:	83 c4 1c             	add    $0x1c,%esp
  8037f6:	5b                   	pop    %ebx
  8037f7:	5e                   	pop    %esi
  8037f8:	5f                   	pop    %edi
  8037f9:	5d                   	pop    %ebp
  8037fa:	c3                   	ret    
  8037fb:	90                   	nop
  8037fc:	89 fd                	mov    %edi,%ebp
  8037fe:	85 ff                	test   %edi,%edi
  803800:	75 0b                	jne    80380d <__umoddi3+0xe9>
  803802:	b8 01 00 00 00       	mov    $0x1,%eax
  803807:	31 d2                	xor    %edx,%edx
  803809:	f7 f7                	div    %edi
  80380b:	89 c5                	mov    %eax,%ebp
  80380d:	89 f0                	mov    %esi,%eax
  80380f:	31 d2                	xor    %edx,%edx
  803811:	f7 f5                	div    %ebp
  803813:	89 c8                	mov    %ecx,%eax
  803815:	f7 f5                	div    %ebp
  803817:	89 d0                	mov    %edx,%eax
  803819:	e9 44 ff ff ff       	jmp    803762 <__umoddi3+0x3e>
  80381e:	66 90                	xchg   %ax,%ax
  803820:	89 c8                	mov    %ecx,%eax
  803822:	89 f2                	mov    %esi,%edx
  803824:	83 c4 1c             	add    $0x1c,%esp
  803827:	5b                   	pop    %ebx
  803828:	5e                   	pop    %esi
  803829:	5f                   	pop    %edi
  80382a:	5d                   	pop    %ebp
  80382b:	c3                   	ret    
  80382c:	3b 04 24             	cmp    (%esp),%eax
  80382f:	72 06                	jb     803837 <__umoddi3+0x113>
  803831:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803835:	77 0f                	ja     803846 <__umoddi3+0x122>
  803837:	89 f2                	mov    %esi,%edx
  803839:	29 f9                	sub    %edi,%ecx
  80383b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80383f:	89 14 24             	mov    %edx,(%esp)
  803842:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803846:	8b 44 24 04          	mov    0x4(%esp),%eax
  80384a:	8b 14 24             	mov    (%esp),%edx
  80384d:	83 c4 1c             	add    $0x1c,%esp
  803850:	5b                   	pop    %ebx
  803851:	5e                   	pop    %esi
  803852:	5f                   	pop    %edi
  803853:	5d                   	pop    %ebp
  803854:	c3                   	ret    
  803855:	8d 76 00             	lea    0x0(%esi),%esi
  803858:	2b 04 24             	sub    (%esp),%eax
  80385b:	19 fa                	sbb    %edi,%edx
  80385d:	89 d1                	mov    %edx,%ecx
  80385f:	89 c6                	mov    %eax,%esi
  803861:	e9 71 ff ff ff       	jmp    8037d7 <__umoddi3+0xb3>
  803866:	66 90                	xchg   %ax,%ax
  803868:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80386c:	72 ea                	jb     803858 <__umoddi3+0x134>
  80386e:	89 d9                	mov    %ebx,%ecx
  803870:	e9 62 ff ff ff       	jmp    8037d7 <__umoddi3+0xb3>
