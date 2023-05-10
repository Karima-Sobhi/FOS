
obj/user/ef_mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 81 07 00 00       	call   8007b7 <libmain>
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
  800041:	e8 a8 1f 00 00       	call   801fee <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 38 80 00       	push   $0x803860
  80004e:	e8 54 0b 00 00       	call   800ba7 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 38 80 00       	push   $0x803862
  80005e:	e8 44 0b 00 00       	call   800ba7 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 78 38 80 00       	push   $0x803878
  80006e:	e8 34 0b 00 00       	call   800ba7 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 38 80 00       	push   $0x803862
  80007e:	e8 24 0b 00 00       	call   800ba7 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 38 80 00       	push   $0x803860
  80008e:	e8 14 0b 00 00       	call   800ba7 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 90 38 80 00       	push   $0x803890
  80009e:	e8 04 0b 00 00       	call   800ba7 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 af 38 80 00       	push   $0x8038af
  8000b8:	e8 ea 0a 00 00       	call   800ba7 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c3:	c1 e0 02             	shl    $0x2,%eax
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	50                   	push   %eax
  8000ca:	e8 04 1a 00 00       	call   801ad3 <malloc>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 b4 38 80 00       	push   $0x8038b4
  8000dd:	e8 c5 0a 00 00       	call   800ba7 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 d6 38 80 00       	push   $0x8038d6
  8000ed:	e8 b5 0a 00 00       	call   800ba7 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 e4 38 80 00       	push   $0x8038e4
  8000fd:	e8 a5 0a 00 00       	call   800ba7 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 f3 38 80 00       	push   $0x8038f3
  80010d:	e8 95 0a 00 00       	call   800ba7 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 03 39 80 00       	push   $0x803903
  80011d:	e8 85 0a 00 00       	call   800ba7 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
			//Chose = getchar() ;
			Chose = 'a';
  800125:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
			cputchar(Chose);
  800129:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	e8 e1 05 00 00       	call   800717 <cputchar>
  800136:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	e8 d4 05 00 00       	call   800717 <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800146:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80014a:	74 0c                	je     800158 <_main+0x120>
  80014c:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800150:	74 06                	je     800158 <_main+0x120>
  800152:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800156:	75 bd                	jne    800115 <_main+0xdd>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800158:	e8 ab 1e 00 00       	call   802008 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80015d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800161:	83 f8 62             	cmp    $0x62,%eax
  800164:	74 1d                	je     800183 <_main+0x14b>
  800166:	83 f8 63             	cmp    $0x63,%eax
  800169:	74 2b                	je     800196 <_main+0x15e>
  80016b:	83 f8 61             	cmp    $0x61,%eax
  80016e:	75 39                	jne    8001a9 <_main+0x171>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 75 f0             	pushl  -0x10(%ebp)
  800176:	ff 75 ec             	pushl  -0x14(%ebp)
  800179:	e8 f0 01 00 00       	call   80036e <InitializeAscending>
  80017e:	83 c4 10             	add    $0x10,%esp
			break ;
  800181:	eb 37                	jmp    8001ba <_main+0x182>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 f0             	pushl  -0x10(%ebp)
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	e8 0e 02 00 00       	call   80039f <InitializeDescending>
  800191:	83 c4 10             	add    $0x10,%esp
			break ;
  800194:	eb 24                	jmp    8001ba <_main+0x182>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 f0             	pushl  -0x10(%ebp)
  80019c:	ff 75 ec             	pushl  -0x14(%ebp)
  80019f:	e8 30 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001a4:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a7:	eb 11                	jmp    8001ba <_main+0x182>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8001af:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b2:	e8 1d 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001b7:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8001c0:	6a 01                	push   $0x1
  8001c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c5:	e8 dc 02 00 00       	call   8004a6 <MSort>
  8001ca:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001cd:	e8 1c 1e 00 00       	call   801fee <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 0c 39 80 00       	push   $0x80390c
  8001da:	e8 c8 09 00 00       	call   800ba7 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001e2:	e8 21 1e 00 00       	call   802008 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 cf 00 00 00       	call   8002c4 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 40 39 80 00       	push   $0x803940
  800209:	6a 4e                	push   $0x4e
  80020b:	68 62 39 80 00       	push   $0x803962
  800210:	e8 de 06 00 00       	call   8008f3 <_panic>
		else
		{
			sys_disable_interrupt();
  800215:	e8 d4 1d 00 00       	call   801fee <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 80 39 80 00       	push   $0x803980
  800222:	e8 80 09 00 00       	call   800ba7 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 b4 39 80 00       	push   $0x8039b4
  800232:	e8 70 09 00 00       	call   800ba7 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 e8 39 80 00       	push   $0x8039e8
  800242:	e8 60 09 00 00       	call   800ba7 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80024a:	e8 b9 1d 00 00       	call   802008 <sys_enable_interrupt>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 f4 18 00 00       	call   801b4e <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  80025d:	e8 8c 1d 00 00       	call   801fee <sys_disable_interrupt>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 1a 3a 80 00       	push   $0x803a1a
  800270:	e8 32 09 00 00       	call   800ba7 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = 'n' ;
  800278:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 8e 04 00 00       	call   800717 <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 81 04 00 00       	call   800717 <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 74 04 00 00       	call   800717 <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b6                	jne    800268 <_main+0x230>
				Chose = 'n' ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 51 1d 00 00       	call   802008 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>
}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 60 38 80 00       	push   $0x803860
  80044b:	e8 57 07 00 00       	call   800ba7 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 38 3a 80 00       	push   $0x803a38
  80046d:	e8 35 07 00 00       	call   800ba7 <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 af 38 80 00       	push   $0x8038af
  80049b:	e8 07 07 00 00       	call   800ba7 <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 92 15 00 00       	call   801ad3 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 7d 15 00 00       	call   801ad3 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fe:	e8 4b 14 00 00       	call   801b4e <free>
  800703:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d4             	pushl  -0x2c(%ebp)
  80070c:	e8 3d 14 00 00       	call   801b4e <free>
  800711:	83 c4 10             	add    $0x10,%esp

}
  800714:	90                   	nop
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800723:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	50                   	push   %eax
  80072b:	e8 f2 18 00 00       	call   802022 <sys_cputc>
  800730:	83 c4 10             	add    $0x10,%esp
}
  800733:	90                   	nop
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80073c:	e8 ad 18 00 00       	call   801fee <sys_disable_interrupt>
	char c = ch;
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800747:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80074b:	83 ec 0c             	sub    $0xc,%esp
  80074e:	50                   	push   %eax
  80074f:	e8 ce 18 00 00       	call   802022 <sys_cputc>
  800754:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800757:	e8 ac 18 00 00       	call   802008 <sys_enable_interrupt>
}
  80075c:	90                   	nop
  80075d:	c9                   	leave  
  80075e:	c3                   	ret    

0080075f <getchar>:

int
getchar(void)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800765:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80076c:	eb 08                	jmp    800776 <getchar+0x17>
	{
		c = sys_cgetc();
  80076e:	e8 f6 16 00 00       	call   801e69 <sys_cgetc>
  800773:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80077a:	74 f2                	je     80076e <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80077f:	c9                   	leave  
  800780:	c3                   	ret    

00800781 <atomic_getchar>:

int
atomic_getchar(void)
{
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800787:	e8 62 18 00 00       	call   801fee <sys_disable_interrupt>
	int c=0;
  80078c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800793:	eb 08                	jmp    80079d <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800795:	e8 cf 16 00 00       	call   801e69 <sys_cgetc>
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80079d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007a1:	74 f2                	je     800795 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007a3:	e8 60 18 00 00       	call   802008 <sys_enable_interrupt>
	return c;
  8007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <iscons>:

int iscons(int fdnum)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007bd:	e8 1f 1a 00 00       	call   8021e1 <sys_getenvindex>
  8007c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c8:	89 d0                	mov    %edx,%eax
  8007ca:	c1 e0 03             	shl    $0x3,%eax
  8007cd:	01 d0                	add    %edx,%eax
  8007cf:	01 c0                	add    %eax,%eax
  8007d1:	01 d0                	add    %edx,%eax
  8007d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007da:	01 d0                	add    %edx,%eax
  8007dc:	c1 e0 04             	shl    $0x4,%eax
  8007df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007e4:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007e9:	a1 24 50 80 00       	mov    0x805024,%eax
  8007ee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007f4:	84 c0                	test   %al,%al
  8007f6:	74 0f                	je     800807 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	05 5c 05 00 00       	add    $0x55c,%eax
  800802:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800807:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80080b:	7e 0a                	jle    800817 <libmain+0x60>
		binaryname = argv[0];
  80080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	ff 75 08             	pushl  0x8(%ebp)
  800820:	e8 13 f8 ff ff       	call   800038 <_main>
  800825:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800828:	e8 c1 17 00 00       	call   801fee <sys_disable_interrupt>
	cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 58 3a 80 00       	push   $0x803a58
  800835:	e8 6d 03 00 00       	call   800ba7 <cprintf>
  80083a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80083d:	a1 24 50 80 00       	mov    0x805024,%eax
  800842:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800848:	a1 24 50 80 00       	mov    0x805024,%eax
  80084d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800853:	83 ec 04             	sub    $0x4,%esp
  800856:	52                   	push   %edx
  800857:	50                   	push   %eax
  800858:	68 80 3a 80 00       	push   $0x803a80
  80085d:	e8 45 03 00 00       	call   800ba7 <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800865:	a1 24 50 80 00       	mov    0x805024,%eax
  80086a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800870:	a1 24 50 80 00       	mov    0x805024,%eax
  800875:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800886:	51                   	push   %ecx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	68 a8 3a 80 00       	push   $0x803aa8
  80088e:	e8 14 03 00 00       	call   800ba7 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800896:	a1 24 50 80 00       	mov    0x805024,%eax
  80089b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 00 3b 80 00       	push   $0x803b00
  8008aa:	e8 f8 02 00 00       	call   800ba7 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 58 3a 80 00       	push   $0x803a58
  8008ba:	e8 e8 02 00 00       	call   800ba7 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008c2:	e8 41 17 00 00       	call   802008 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008c7:	e8 19 00 00 00       	call   8008e5 <exit>
}
  8008cc:	90                   	nop
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008d5:	83 ec 0c             	sub    $0xc,%esp
  8008d8:	6a 00                	push   $0x0
  8008da:	e8 ce 18 00 00       	call   8021ad <sys_destroy_env>
  8008df:	83 c4 10             	add    $0x10,%esp
}
  8008e2:	90                   	nop
  8008e3:	c9                   	leave  
  8008e4:	c3                   	ret    

008008e5 <exit>:

void
exit(void)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008eb:	e8 23 19 00 00       	call   802213 <sys_exit_env>
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fc:	83 c0 04             	add    $0x4,%eax
  8008ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800902:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800907:	85 c0                	test   %eax,%eax
  800909:	74 16                	je     800921 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80090b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	50                   	push   %eax
  800914:	68 14 3b 80 00       	push   $0x803b14
  800919:	e8 89 02 00 00       	call   800ba7 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800921:	a1 00 50 80 00       	mov    0x805000,%eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 19 3b 80 00       	push   $0x803b19
  800932:	e8 70 02 00 00       	call   800ba7 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80093a:	8b 45 10             	mov    0x10(%ebp),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 f4             	pushl  -0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	e8 f3 01 00 00       	call   800b3c <vcprintf>
  800949:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	6a 00                	push   $0x0
  800951:	68 35 3b 80 00       	push   $0x803b35
  800956:	e8 e1 01 00 00       	call   800b3c <vcprintf>
  80095b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80095e:	e8 82 ff ff ff       	call   8008e5 <exit>

	// should not return here
	while (1) ;
  800963:	eb fe                	jmp    800963 <_panic+0x70>

00800965 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80096b:	a1 24 50 80 00       	mov    0x805024,%eax
  800970:	8b 50 74             	mov    0x74(%eax),%edx
  800973:	8b 45 0c             	mov    0xc(%ebp),%eax
  800976:	39 c2                	cmp    %eax,%edx
  800978:	74 14                	je     80098e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80097a:	83 ec 04             	sub    $0x4,%esp
  80097d:	68 38 3b 80 00       	push   $0x803b38
  800982:	6a 26                	push   $0x26
  800984:	68 84 3b 80 00       	push   $0x803b84
  800989:	e8 65 ff ff ff       	call   8008f3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80098e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800995:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099c:	e9 c2 00 00 00       	jmp    800a63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	85 c0                	test   %eax,%eax
  8009b4:	75 08                	jne    8009be <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009b6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009b9:	e9 a2 00 00 00       	jmp    800a60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009cc:	eb 69                	jmp    800a37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009ce:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	01 c0                	add    %eax,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	c1 e0 03             	shl    $0x3,%eax
  8009e5:	01 c8                	add    %ecx,%eax
  8009e7:	8a 40 04             	mov    0x4(%eax),%al
  8009ea:	84 c0                	test   %al,%al
  8009ec:	75 46                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8009f3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009fc:	89 d0                	mov    %edx,%eax
  8009fe:	01 c0                	add    %eax,%eax
  800a00:	01 d0                	add    %edx,%eax
  800a02:	c1 e0 03             	shl    $0x3,%eax
  800a05:	01 c8                	add    %ecx,%eax
  800a07:	8b 00                	mov    (%eax),%eax
  800a09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	01 c8                	add    %ecx,%eax
  800a25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a27:	39 c2                	cmp    %eax,%edx
  800a29:	75 09                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a32:	eb 12                	jmp    800a46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a34:	ff 45 e8             	incl   -0x18(%ebp)
  800a37:	a1 24 50 80 00       	mov    0x805024,%eax
  800a3c:	8b 50 74             	mov    0x74(%eax),%edx
  800a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a42:	39 c2                	cmp    %eax,%edx
  800a44:	77 88                	ja     8009ce <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a4a:	75 14                	jne    800a60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a4c:	83 ec 04             	sub    $0x4,%esp
  800a4f:	68 90 3b 80 00       	push   $0x803b90
  800a54:	6a 3a                	push   $0x3a
  800a56:	68 84 3b 80 00       	push   $0x803b84
  800a5b:	e8 93 fe ff ff       	call   8008f3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a60:	ff 45 f0             	incl   -0x10(%ebp)
  800a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a69:	0f 8c 32 ff ff ff    	jl     8009a1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a7d:	eb 26                	jmp    800aa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a7f:	a1 24 50 80 00       	mov    0x805024,%eax
  800a84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a8d:	89 d0                	mov    %edx,%eax
  800a8f:	01 c0                	add    %eax,%eax
  800a91:	01 d0                	add    %edx,%eax
  800a93:	c1 e0 03             	shl    $0x3,%eax
  800a96:	01 c8                	add    %ecx,%eax
  800a98:	8a 40 04             	mov    0x4(%eax),%al
  800a9b:	3c 01                	cmp    $0x1,%al
  800a9d:	75 03                	jne    800aa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa2:	ff 45 e0             	incl   -0x20(%ebp)
  800aa5:	a1 24 50 80 00       	mov    0x805024,%eax
  800aaa:	8b 50 74             	mov    0x74(%eax),%edx
  800aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab0:	39 c2                	cmp    %eax,%edx
  800ab2:	77 cb                	ja     800a7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800aba:	74 14                	je     800ad0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800abc:	83 ec 04             	sub    $0x4,%esp
  800abf:	68 e4 3b 80 00       	push   $0x803be4
  800ac4:	6a 44                	push   $0x44
  800ac6:	68 84 3b 80 00       	push   $0x803b84
  800acb:	e8 23 fe ff ff       	call   8008f3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ad0:	90                   	nop
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	8d 48 01             	lea    0x1(%eax),%ecx
  800ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae4:	89 0a                	mov    %ecx,(%edx)
  800ae6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae9:	88 d1                	mov    %dl,%cl
  800aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800afc:	75 2c                	jne    800b2a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800afe:	a0 28 50 80 00       	mov    0x805028,%al
  800b03:	0f b6 c0             	movzbl %al,%eax
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	8b 12                	mov    (%edx),%edx
  800b0b:	89 d1                	mov    %edx,%ecx
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b10:	83 c2 08             	add    $0x8,%edx
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	50                   	push   %eax
  800b17:	51                   	push   %ecx
  800b18:	52                   	push   %edx
  800b19:	e8 22 13 00 00       	call   801e40 <sys_cputs>
  800b1e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	8b 40 04             	mov    0x4(%eax),%eax
  800b30:	8d 50 01             	lea    0x1(%eax),%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b39:	90                   	nop
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b45:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b4c:	00 00 00 
	b.cnt = 0;
  800b4f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b56:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	ff 75 08             	pushl  0x8(%ebp)
  800b5f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b65:	50                   	push   %eax
  800b66:	68 d3 0a 80 00       	push   $0x800ad3
  800b6b:	e8 11 02 00 00       	call   800d81 <vprintfmt>
  800b70:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b73:	a0 28 50 80 00       	mov    0x805028,%al
  800b78:	0f b6 c0             	movzbl %al,%eax
  800b7b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b81:	83 ec 04             	sub    $0x4,%esp
  800b84:	50                   	push   %eax
  800b85:	52                   	push   %edx
  800b86:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b8c:	83 c0 08             	add    $0x8,%eax
  800b8f:	50                   	push   %eax
  800b90:	e8 ab 12 00 00       	call   801e40 <sys_cputs>
  800b95:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b98:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b9f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bad:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bb4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc3:	50                   	push   %eax
  800bc4:	e8 73 ff ff ff       	call   800b3c <vcprintf>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bda:	e8 0f 14 00 00       	call   801fee <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bdf:	8d 45 0c             	lea    0xc(%ebp),%eax
  800be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	83 ec 08             	sub    $0x8,%esp
  800beb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bee:	50                   	push   %eax
  800bef:	e8 48 ff ff ff       	call   800b3c <vcprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bfa:	e8 09 14 00 00       	call   802008 <sys_enable_interrupt>
	return cnt;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	53                   	push   %ebx
  800c08:	83 ec 14             	sub    $0x14,%esp
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c11:	8b 45 14             	mov    0x14(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c17:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c22:	77 55                	ja     800c79 <printnum+0x75>
  800c24:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c27:	72 05                	jb     800c2e <printnum+0x2a>
  800c29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c2c:	77 4b                	ja     800c79 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c2e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c34:	8b 45 18             	mov    0x18(%ebp),%eax
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c41:	ff 75 f0             	pushl  -0x10(%ebp)
  800c44:	e8 b3 29 00 00       	call   8035fc <__udivdi3>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	83 ec 04             	sub    $0x4,%esp
  800c4f:	ff 75 20             	pushl  0x20(%ebp)
  800c52:	53                   	push   %ebx
  800c53:	ff 75 18             	pushl  0x18(%ebp)
  800c56:	52                   	push   %edx
  800c57:	50                   	push   %eax
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	ff 75 08             	pushl  0x8(%ebp)
  800c5e:	e8 a1 ff ff ff       	call   800c04 <printnum>
  800c63:	83 c4 20             	add    $0x20,%esp
  800c66:	eb 1a                	jmp    800c82 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c68:	83 ec 08             	sub    $0x8,%esp
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	ff 75 20             	pushl  0x20(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	ff d0                	call   *%eax
  800c76:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c79:	ff 4d 1c             	decl   0x1c(%ebp)
  800c7c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c80:	7f e6                	jg     800c68 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c82:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c90:	53                   	push   %ebx
  800c91:	51                   	push   %ecx
  800c92:	52                   	push   %edx
  800c93:	50                   	push   %eax
  800c94:	e8 73 2a 00 00       	call   80370c <__umoddi3>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	05 54 3e 80 00       	add    $0x803e54,%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	0f be c0             	movsbl %al,%eax
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 0c             	pushl  0xc(%ebp)
  800cac:	50                   	push   %eax
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
}
  800cb5:	90                   	nop
  800cb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cbe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cc2:	7e 1c                	jle    800ce0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8b 00                	mov    (%eax),%eax
  800cc9:	8d 50 08             	lea    0x8(%eax),%edx
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	89 10                	mov    %edx,(%eax)
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8b 00                	mov    (%eax),%eax
  800cd6:	83 e8 08             	sub    $0x8,%eax
  800cd9:	8b 50 04             	mov    0x4(%eax),%edx
  800cdc:	8b 00                	mov    (%eax),%eax
  800cde:	eb 40                	jmp    800d20 <getuint+0x65>
	else if (lflag)
  800ce0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce4:	74 1e                	je     800d04 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8b 00                	mov    (%eax),%eax
  800ceb:	8d 50 04             	lea    0x4(%eax),%edx
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 10                	mov    %edx,(%eax)
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8b 00                	mov    (%eax),%eax
  800cf8:	83 e8 04             	sub    $0x4,%eax
  800cfb:	8b 00                	mov    (%eax),%eax
  800cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800d02:	eb 1c                	jmp    800d20 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	8d 50 04             	lea    0x4(%eax),%edx
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	89 10                	mov    %edx,(%eax)
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	83 e8 04             	sub    $0x4,%eax
  800d19:	8b 00                	mov    (%eax),%eax
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d25:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d29:	7e 1c                	jle    800d47 <getint+0x25>
		return va_arg(*ap, long long);
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	8d 50 08             	lea    0x8(%eax),%edx
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	89 10                	mov    %edx,(%eax)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	83 e8 08             	sub    $0x8,%eax
  800d40:	8b 50 04             	mov    0x4(%eax),%edx
  800d43:	8b 00                	mov    (%eax),%eax
  800d45:	eb 38                	jmp    800d7f <getint+0x5d>
	else if (lflag)
  800d47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4b:	74 1a                	je     800d67 <getint+0x45>
		return va_arg(*ap, long);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	8d 50 04             	lea    0x4(%eax),%edx
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	89 10                	mov    %edx,(%eax)
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	83 e8 04             	sub    $0x4,%eax
  800d62:	8b 00                	mov    (%eax),%eax
  800d64:	99                   	cltd   
  800d65:	eb 18                	jmp    800d7f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	8d 50 04             	lea    0x4(%eax),%edx
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	89 10                	mov    %edx,(%eax)
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 00                	mov    (%eax),%eax
  800d79:	83 e8 04             	sub    $0x4,%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	99                   	cltd   
}
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d89:	eb 17                	jmp    800da2 <vprintfmt+0x21>
			if (ch == '\0')
  800d8b:	85 db                	test   %ebx,%ebx
  800d8d:	0f 84 af 03 00 00    	je     801142 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	53                   	push   %ebx
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	ff d0                	call   *%eax
  800d9f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	8d 50 01             	lea    0x1(%eax),%edx
  800da8:	89 55 10             	mov    %edx,0x10(%ebp)
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	0f b6 d8             	movzbl %al,%ebx
  800db0:	83 fb 25             	cmp    $0x25,%ebx
  800db3:	75 d6                	jne    800d8b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800db5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800db9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dc0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dc7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800dce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	0f b6 d8             	movzbl %al,%ebx
  800de3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800de6:	83 f8 55             	cmp    $0x55,%eax
  800de9:	0f 87 2b 03 00 00    	ja     80111a <vprintfmt+0x399>
  800def:	8b 04 85 78 3e 80 00 	mov    0x803e78(,%eax,4),%eax
  800df6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800df8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800dfc:	eb d7                	jmp    800dd5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dfe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e02:	eb d1                	jmp    800dd5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e04:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e0e:	89 d0                	mov    %edx,%eax
  800e10:	c1 e0 02             	shl    $0x2,%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	01 c0                	add    %eax,%eax
  800e17:	01 d8                	add    %ebx,%eax
  800e19:	83 e8 30             	sub    $0x30,%eax
  800e1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e27:	83 fb 2f             	cmp    $0x2f,%ebx
  800e2a:	7e 3e                	jle    800e6a <vprintfmt+0xe9>
  800e2c:	83 fb 39             	cmp    $0x39,%ebx
  800e2f:	7f 39                	jg     800e6a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e31:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e34:	eb d5                	jmp    800e0b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e36:	8b 45 14             	mov    0x14(%ebp),%eax
  800e39:	83 c0 04             	add    $0x4,%eax
  800e3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	83 e8 04             	sub    $0x4,%eax
  800e45:	8b 00                	mov    (%eax),%eax
  800e47:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e4a:	eb 1f                	jmp    800e6b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e50:	79 83                	jns    800dd5 <vprintfmt+0x54>
				width = 0;
  800e52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e59:	e9 77 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e5e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e65:	e9 6b ff ff ff       	jmp    800dd5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e6a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6f:	0f 89 60 ff ff ff    	jns    800dd5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e7b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e82:	e9 4e ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e87:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e8a:	e9 46 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 0c             	pushl  0xc(%ebp)
  800ea6:	50                   	push   %eax
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 89 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800eb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb7:	83 c0 04             	add    $0x4,%eax
  800eba:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec0:	83 e8 04             	sub    $0x4,%eax
  800ec3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ec5:	85 db                	test   %ebx,%ebx
  800ec7:	79 02                	jns    800ecb <vprintfmt+0x14a>
				err = -err;
  800ec9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ecb:	83 fb 64             	cmp    $0x64,%ebx
  800ece:	7f 0b                	jg     800edb <vprintfmt+0x15a>
  800ed0:	8b 34 9d c0 3c 80 00 	mov    0x803cc0(,%ebx,4),%esi
  800ed7:	85 f6                	test   %esi,%esi
  800ed9:	75 19                	jne    800ef4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800edb:	53                   	push   %ebx
  800edc:	68 65 3e 80 00       	push   $0x803e65
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	ff 75 08             	pushl  0x8(%ebp)
  800ee7:	e8 5e 02 00 00       	call   80114a <printfmt>
  800eec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800eef:	e9 49 02 00 00       	jmp    80113d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ef4:	56                   	push   %esi
  800ef5:	68 6e 3e 80 00       	push   $0x803e6e
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 45 02 00 00       	call   80114a <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			break;
  800f08:	e9 30 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f10:	83 c0 04             	add    $0x4,%eax
  800f13:	89 45 14             	mov    %eax,0x14(%ebp)
  800f16:	8b 45 14             	mov    0x14(%ebp),%eax
  800f19:	83 e8 04             	sub    $0x4,%eax
  800f1c:	8b 30                	mov    (%eax),%esi
  800f1e:	85 f6                	test   %esi,%esi
  800f20:	75 05                	jne    800f27 <vprintfmt+0x1a6>
				p = "(null)";
  800f22:	be 71 3e 80 00       	mov    $0x803e71,%esi
			if (width > 0 && padc != '-')
  800f27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f2b:	7e 6d                	jle    800f9a <vprintfmt+0x219>
  800f2d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f31:	74 67                	je     800f9a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	50                   	push   %eax
  800f3a:	56                   	push   %esi
  800f3b:	e8 0c 03 00 00       	call   80124c <strnlen>
  800f40:	83 c4 10             	add    $0x10,%esp
  800f43:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f46:	eb 16                	jmp    800f5e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f48:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	ff 75 0c             	pushl  0xc(%ebp)
  800f52:	50                   	push   %eax
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	ff d0                	call   *%eax
  800f58:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f5b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f62:	7f e4                	jg     800f48 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f64:	eb 34                	jmp    800f9a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f66:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f6a:	74 1c                	je     800f88 <vprintfmt+0x207>
  800f6c:	83 fb 1f             	cmp    $0x1f,%ebx
  800f6f:	7e 05                	jle    800f76 <vprintfmt+0x1f5>
  800f71:	83 fb 7e             	cmp    $0x7e,%ebx
  800f74:	7e 12                	jle    800f88 <vprintfmt+0x207>
					putch('?', putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	6a 3f                	push   $0x3f
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	ff d0                	call   *%eax
  800f83:	83 c4 10             	add    $0x10,%esp
  800f86:	eb 0f                	jmp    800f97 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f88:	83 ec 08             	sub    $0x8,%esp
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	53                   	push   %ebx
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	ff d0                	call   *%eax
  800f94:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f97:	ff 4d e4             	decl   -0x1c(%ebp)
  800f9a:	89 f0                	mov    %esi,%eax
  800f9c:	8d 70 01             	lea    0x1(%eax),%esi
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f be d8             	movsbl %al,%ebx
  800fa4:	85 db                	test   %ebx,%ebx
  800fa6:	74 24                	je     800fcc <vprintfmt+0x24b>
  800fa8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fac:	78 b8                	js     800f66 <vprintfmt+0x1e5>
  800fae:	ff 4d e0             	decl   -0x20(%ebp)
  800fb1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fb5:	79 af                	jns    800f66 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fb7:	eb 13                	jmp    800fcc <vprintfmt+0x24b>
				putch(' ', putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	6a 20                	push   $0x20
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	ff d0                	call   *%eax
  800fc6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc9:	ff 4d e4             	decl   -0x1c(%ebp)
  800fcc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd0:	7f e7                	jg     800fb9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fd2:	e9 66 01 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fd7:	83 ec 08             	sub    $0x8,%esp
  800fda:	ff 75 e8             	pushl  -0x18(%ebp)
  800fdd:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe0:	50                   	push   %eax
  800fe1:	e8 3c fd ff ff       	call   800d22 <getint>
  800fe6:	83 c4 10             	add    $0x10,%esp
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff5:	85 d2                	test   %edx,%edx
  800ff7:	79 23                	jns    80101c <vprintfmt+0x29b>
				putch('-', putdat);
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	6a 2d                	push   $0x2d
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	ff d0                	call   *%eax
  801006:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100f:	f7 d8                	neg    %eax
  801011:	83 d2 00             	adc    $0x0,%edx
  801014:	f7 da                	neg    %edx
  801016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801019:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80101c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801023:	e9 bc 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801028:	83 ec 08             	sub    $0x8,%esp
  80102b:	ff 75 e8             	pushl  -0x18(%ebp)
  80102e:	8d 45 14             	lea    0x14(%ebp),%eax
  801031:	50                   	push   %eax
  801032:	e8 84 fc ff ff       	call   800cbb <getuint>
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801040:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801047:	e9 98 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80104c:	83 ec 08             	sub    $0x8,%esp
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	6a 58                	push   $0x58
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	ff d0                	call   *%eax
  801059:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	6a 58                	push   $0x58
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	6a 58                	push   $0x58
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	ff d0                	call   *%eax
  801079:	83 c4 10             	add    $0x10,%esp
			break;
  80107c:	e9 bc 00 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801081:	83 ec 08             	sub    $0x8,%esp
  801084:	ff 75 0c             	pushl  0xc(%ebp)
  801087:	6a 30                	push   $0x30
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	ff d0                	call   *%eax
  80108e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	6a 78                	push   $0x78
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	ff d0                	call   *%eax
  80109e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8010aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ad:	83 e8 04             	sub    $0x4,%eax
  8010b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010c3:	eb 1f                	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010c5:	83 ec 08             	sub    $0x8,%esp
  8010c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8010cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8010ce:	50                   	push   %eax
  8010cf:	e8 e7 fb ff ff       	call   800cbb <getuint>
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010eb:	83 ec 04             	sub    $0x4,%esp
  8010ee:	52                   	push   %edx
  8010ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f2:	50                   	push   %eax
  8010f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8010f9:	ff 75 0c             	pushl  0xc(%ebp)
  8010fc:	ff 75 08             	pushl  0x8(%ebp)
  8010ff:	e8 00 fb ff ff       	call   800c04 <printnum>
  801104:	83 c4 20             	add    $0x20,%esp
			break;
  801107:	eb 34                	jmp    80113d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801109:	83 ec 08             	sub    $0x8,%esp
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	53                   	push   %ebx
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	ff d0                	call   *%eax
  801115:	83 c4 10             	add    $0x10,%esp
			break;
  801118:	eb 23                	jmp    80113d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80111a:	83 ec 08             	sub    $0x8,%esp
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	6a 25                	push   $0x25
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	ff d0                	call   *%eax
  801127:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80112a:	ff 4d 10             	decl   0x10(%ebp)
  80112d:	eb 03                	jmp    801132 <vprintfmt+0x3b1>
  80112f:	ff 4d 10             	decl   0x10(%ebp)
  801132:	8b 45 10             	mov    0x10(%ebp),%eax
  801135:	48                   	dec    %eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 25                	cmp    $0x25,%al
  80113a:	75 f3                	jne    80112f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80113c:	90                   	nop
		}
	}
  80113d:	e9 47 fc ff ff       	jmp    800d89 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801142:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801143:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801150:	8d 45 10             	lea    0x10(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	ff 75 f4             	pushl  -0xc(%ebp)
  80115f:	50                   	push   %eax
  801160:	ff 75 0c             	pushl  0xc(%ebp)
  801163:	ff 75 08             	pushl  0x8(%ebp)
  801166:	e8 16 fc ff ff       	call   800d81 <vprintfmt>
  80116b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80116e:	90                   	nop
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	8b 40 08             	mov    0x8(%eax),%eax
  80117a:	8d 50 01             	lea    0x1(%eax),%edx
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	8b 10                	mov    (%eax),%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	8b 40 04             	mov    0x4(%eax),%eax
  80118e:	39 c2                	cmp    %eax,%edx
  801190:	73 12                	jae    8011a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	8b 00                	mov    (%eax),%eax
  801197:	8d 48 01             	lea    0x1(%eax),%ecx
  80119a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119d:	89 0a                	mov    %ecx,(%edx)
  80119f:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a2:	88 10                	mov    %dl,(%eax)
}
  8011a4:	90                   	nop
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011cc:	74 06                	je     8011d4 <vsnprintf+0x2d>
  8011ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d2:	7f 07                	jg     8011db <vsnprintf+0x34>
		return -E_INVAL;
  8011d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8011d9:	eb 20                	jmp    8011fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011db:	ff 75 14             	pushl  0x14(%ebp)
  8011de:	ff 75 10             	pushl  0x10(%ebp)
  8011e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011e4:	50                   	push   %eax
  8011e5:	68 71 11 80 00       	push   $0x801171
  8011ea:	e8 92 fb ff ff       	call   800d81 <vprintfmt>
  8011ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801203:	8d 45 10             	lea    0x10(%ebp),%eax
  801206:	83 c0 04             	add    $0x4,%eax
  801209:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	ff 75 f4             	pushl  -0xc(%ebp)
  801212:	50                   	push   %eax
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	ff 75 08             	pushl  0x8(%ebp)
  801219:	e8 89 ff ff ff       	call   8011a7 <vsnprintf>
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801224:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80122f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801236:	eb 06                	jmp    80123e <strlen+0x15>
		n++;
  801238:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	75 f1                	jne    801238 <strlen+0xf>
		n++;
	return n;
  801247:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801259:	eb 09                	jmp    801264 <strnlen+0x18>
		n++;
  80125b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80125e:	ff 45 08             	incl   0x8(%ebp)
  801261:	ff 4d 0c             	decl   0xc(%ebp)
  801264:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801268:	74 09                	je     801273 <strnlen+0x27>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	75 e8                	jne    80125b <strnlen+0xf>
		n++;
	return n;
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801284:	90                   	nop
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8d 50 01             	lea    0x1(%eax),%edx
  80128b:	89 55 08             	mov    %edx,0x8(%ebp)
  80128e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801291:	8d 4a 01             	lea    0x1(%edx),%ecx
  801294:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801297:	8a 12                	mov    (%edx),%dl
  801299:	88 10                	mov    %dl,(%eax)
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	84 c0                	test   %al,%al
  80129f:	75 e4                	jne    801285 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b9:	eb 1f                	jmp    8012da <strncpy+0x34>
		*dst++ = *src;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8d 50 01             	lea    0x1(%eax),%edx
  8012c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c7:	8a 12                	mov    (%edx),%dl
  8012c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	84 c0                	test   %al,%al
  8012d2:	74 03                	je     8012d7 <strncpy+0x31>
			src++;
  8012d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d7:	ff 45 fc             	incl   -0x4(%ebp)
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012e0:	72 d9                	jb     8012bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f7:	74 30                	je     801329 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012f9:	eb 16                	jmp    801311 <strlcpy+0x2a>
			*dst++ = *src++;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8d 50 01             	lea    0x1(%eax),%edx
  801301:	89 55 08             	mov    %edx,0x8(%ebp)
  801304:	8b 55 0c             	mov    0xc(%ebp),%edx
  801307:	8d 4a 01             	lea    0x1(%edx),%ecx
  80130a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80130d:	8a 12                	mov    (%edx),%dl
  80130f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801311:	ff 4d 10             	decl   0x10(%ebp)
  801314:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801318:	74 09                	je     801323 <strlcpy+0x3c>
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	84 c0                	test   %al,%al
  801321:	75 d8                	jne    8012fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801329:	8b 55 08             	mov    0x8(%ebp),%edx
  80132c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132f:	29 c2                	sub    %eax,%edx
  801331:	89 d0                	mov    %edx,%eax
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801338:	eb 06                	jmp    801340 <strcmp+0xb>
		p++, q++;
  80133a:	ff 45 08             	incl   0x8(%ebp)
  80133d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	84 c0                	test   %al,%al
  801347:	74 0e                	je     801357 <strcmp+0x22>
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 10                	mov    (%eax),%dl
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	38 c2                	cmp    %al,%dl
  801355:	74 e3                	je     80133a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	0f b6 d0             	movzbl %al,%edx
  80135f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	0f b6 c0             	movzbl %al,%eax
  801367:	29 c2                	sub    %eax,%edx
  801369:	89 d0                	mov    %edx,%eax
}
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801370:	eb 09                	jmp    80137b <strncmp+0xe>
		n--, p++, q++;
  801372:	ff 4d 10             	decl   0x10(%ebp)
  801375:	ff 45 08             	incl   0x8(%ebp)
  801378:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80137b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137f:	74 17                	je     801398 <strncmp+0x2b>
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	84 c0                	test   %al,%al
  801388:	74 0e                	je     801398 <strncmp+0x2b>
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8a 10                	mov    (%eax),%dl
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	38 c2                	cmp    %al,%dl
  801396:	74 da                	je     801372 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801398:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139c:	75 07                	jne    8013a5 <strncmp+0x38>
		return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 14                	jmp    8013b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	0f b6 d0             	movzbl %al,%edx
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	0f b6 c0             	movzbl %al,%eax
  8013b5:	29 c2                	sub    %eax,%edx
  8013b7:	89 d0                	mov    %edx,%eax
}
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013c7:	eb 12                	jmp    8013db <strchr+0x20>
		if (*s == c)
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013d1:	75 05                	jne    8013d8 <strchr+0x1d>
			return (char *) s;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	eb 11                	jmp    8013e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013d8:	ff 45 08             	incl   0x8(%ebp)
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	84 c0                	test   %al,%al
  8013e2:	75 e5                	jne    8013c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013f7:	eb 0d                	jmp    801406 <strfind+0x1b>
		if (*s == c)
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	8a 00                	mov    (%eax),%al
  8013fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801401:	74 0e                	je     801411 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801403:	ff 45 08             	incl   0x8(%ebp)
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	84 c0                	test   %al,%al
  80140d:	75 ea                	jne    8013f9 <strfind+0xe>
  80140f:	eb 01                	jmp    801412 <strfind+0x27>
		if (*s == c)
			break;
  801411:	90                   	nop
	return (char *) s;
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801429:	eb 0e                	jmp    801439 <memset+0x22>
		*p++ = c;
  80142b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142e:	8d 50 01             	lea    0x1(%eax),%edx
  801431:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801434:	8b 55 0c             	mov    0xc(%ebp),%edx
  801437:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801439:	ff 4d f8             	decl   -0x8(%ebp)
  80143c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801440:	79 e9                	jns    80142b <memset+0x14>
		*p++ = c;

	return v;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801459:	eb 16                	jmp    801471 <memcpy+0x2a>
		*d++ = *s++;
  80145b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145e:	8d 50 01             	lea    0x1(%eax),%edx
  801461:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801464:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801467:	8d 4a 01             	lea    0x1(%edx),%ecx
  80146a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80146d:	8a 12                	mov    (%edx),%dl
  80146f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801471:	8b 45 10             	mov    0x10(%ebp),%eax
  801474:	8d 50 ff             	lea    -0x1(%eax),%edx
  801477:	89 55 10             	mov    %edx,0x10(%ebp)
  80147a:	85 c0                	test   %eax,%eax
  80147c:	75 dd                	jne    80145b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801498:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80149b:	73 50                	jae    8014ed <memmove+0x6a>
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a3:	01 d0                	add    %edx,%eax
  8014a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014a8:	76 43                	jbe    8014ed <memmove+0x6a>
		s += n;
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014b6:	eb 10                	jmp    8014c8 <memmove+0x45>
			*--d = *--s;
  8014b8:	ff 4d f8             	decl   -0x8(%ebp)
  8014bb:	ff 4d fc             	decl   -0x4(%ebp)
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	75 e3                	jne    8014b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014d5:	eb 23                	jmp    8014fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014da:	8d 50 01             	lea    0x1(%eax),%edx
  8014dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014e9:	8a 12                	mov    (%edx),%dl
  8014eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	75 dd                	jne    8014d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801511:	eb 2a                	jmp    80153d <memcmp+0x3e>
		if (*s1 != *s2)
  801513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801516:	8a 10                	mov    (%eax),%dl
  801518:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151b:	8a 00                	mov    (%eax),%al
  80151d:	38 c2                	cmp    %al,%dl
  80151f:	74 16                	je     801537 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 d0             	movzbl %al,%edx
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	0f b6 c0             	movzbl %al,%eax
  801531:	29 c2                	sub    %eax,%edx
  801533:	89 d0                	mov    %edx,%eax
  801535:	eb 18                	jmp    80154f <memcmp+0x50>
		s1++, s2++;
  801537:	ff 45 fc             	incl   -0x4(%ebp)
  80153a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	8d 50 ff             	lea    -0x1(%eax),%edx
  801543:	89 55 10             	mov    %edx,0x10(%ebp)
  801546:	85 c0                	test   %eax,%eax
  801548:	75 c9                	jne    801513 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801557:	8b 55 08             	mov    0x8(%ebp),%edx
  80155a:	8b 45 10             	mov    0x10(%ebp),%eax
  80155d:	01 d0                	add    %edx,%eax
  80155f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801562:	eb 15                	jmp    801579 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	0f b6 d0             	movzbl %al,%edx
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	0f b6 c0             	movzbl %al,%eax
  801572:	39 c2                	cmp    %eax,%edx
  801574:	74 0d                	je     801583 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801576:	ff 45 08             	incl   0x8(%ebp)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80157f:	72 e3                	jb     801564 <memfind+0x13>
  801581:	eb 01                	jmp    801584 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801583:	90                   	nop
	return (void *) s;
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80158f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801596:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159d:	eb 03                	jmp    8015a2 <strtol+0x19>
		s++;
  80159f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	3c 20                	cmp    $0x20,%al
  8015a9:	74 f4                	je     80159f <strtol+0x16>
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	3c 09                	cmp    $0x9,%al
  8015b2:	74 eb                	je     80159f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	3c 2b                	cmp    $0x2b,%al
  8015bb:	75 05                	jne    8015c2 <strtol+0x39>
		s++;
  8015bd:	ff 45 08             	incl   0x8(%ebp)
  8015c0:	eb 13                	jmp    8015d5 <strtol+0x4c>
	else if (*s == '-')
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	3c 2d                	cmp    $0x2d,%al
  8015c9:	75 0a                	jne    8015d5 <strtol+0x4c>
		s++, neg = 1;
  8015cb:	ff 45 08             	incl   0x8(%ebp)
  8015ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d9:	74 06                	je     8015e1 <strtol+0x58>
  8015db:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015df:	75 20                	jne    801601 <strtol+0x78>
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8a 00                	mov    (%eax),%al
  8015e6:	3c 30                	cmp    $0x30,%al
  8015e8:	75 17                	jne    801601 <strtol+0x78>
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	40                   	inc    %eax
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	3c 78                	cmp    $0x78,%al
  8015f2:	75 0d                	jne    801601 <strtol+0x78>
		s += 2, base = 16;
  8015f4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015f8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015ff:	eb 28                	jmp    801629 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801601:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801605:	75 15                	jne    80161c <strtol+0x93>
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	3c 30                	cmp    $0x30,%al
  80160e:	75 0c                	jne    80161c <strtol+0x93>
		s++, base = 8;
  801610:	ff 45 08             	incl   0x8(%ebp)
  801613:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80161a:	eb 0d                	jmp    801629 <strtol+0xa0>
	else if (base == 0)
  80161c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801620:	75 07                	jne    801629 <strtol+0xa0>
		base = 10;
  801622:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	3c 2f                	cmp    $0x2f,%al
  801630:	7e 19                	jle    80164b <strtol+0xc2>
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	3c 39                	cmp    $0x39,%al
  801639:	7f 10                	jg     80164b <strtol+0xc2>
			dig = *s - '0';
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8a 00                	mov    (%eax),%al
  801640:	0f be c0             	movsbl %al,%eax
  801643:	83 e8 30             	sub    $0x30,%eax
  801646:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801649:	eb 42                	jmp    80168d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 60                	cmp    $0x60,%al
  801652:	7e 19                	jle    80166d <strtol+0xe4>
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	3c 7a                	cmp    $0x7a,%al
  80165b:	7f 10                	jg     80166d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 e8 57             	sub    $0x57,%eax
  801668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80166b:	eb 20                	jmp    80168d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 40                	cmp    $0x40,%al
  801674:	7e 39                	jle    8016af <strtol+0x126>
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	3c 5a                	cmp    $0x5a,%al
  80167d:	7f 30                	jg     8016af <strtol+0x126>
			dig = *s - 'A' + 10;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8a 00                	mov    (%eax),%al
  801684:	0f be c0             	movsbl %al,%eax
  801687:	83 e8 37             	sub    $0x37,%eax
  80168a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	3b 45 10             	cmp    0x10(%ebp),%eax
  801693:	7d 19                	jge    8016ae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801695:	ff 45 08             	incl   0x8(%ebp)
  801698:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80169f:	89 c2                	mov    %eax,%edx
  8016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a4:	01 d0                	add    %edx,%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016a9:	e9 7b ff ff ff       	jmp    801629 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016ae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b3:	74 08                	je     8016bd <strtol+0x134>
		*endptr = (char *) s;
  8016b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016c1:	74 07                	je     8016ca <strtol+0x141>
  8016c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c6:	f7 d8                	neg    %eax
  8016c8:	eb 03                	jmp    8016cd <strtol+0x144>
  8016ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <ltostr>:

void
ltostr(long value, char *str)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016e7:	79 13                	jns    8016fc <ltostr+0x2d>
	{
		neg = 1;
  8016e9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016f6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016f9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801704:	99                   	cltd   
  801705:	f7 f9                	idiv   %ecx
  801707:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80170a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170d:	8d 50 01             	lea    0x1(%eax),%edx
  801710:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801713:	89 c2                	mov    %eax,%edx
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	01 d0                	add    %edx,%eax
  80171a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80171d:	83 c2 30             	add    $0x30,%edx
  801720:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801722:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801725:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80172a:	f7 e9                	imul   %ecx
  80172c:	c1 fa 02             	sar    $0x2,%edx
  80172f:	89 c8                	mov    %ecx,%eax
  801731:	c1 f8 1f             	sar    $0x1f,%eax
  801734:	29 c2                	sub    %eax,%edx
  801736:	89 d0                	mov    %edx,%eax
  801738:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	c1 e0 02             	shl    $0x2,%eax
  801754:	01 d0                	add    %edx,%eax
  801756:	01 c0                	add    %eax,%eax
  801758:	29 c1                	sub    %eax,%ecx
  80175a:	89 ca                	mov    %ecx,%edx
  80175c:	85 d2                	test   %edx,%edx
  80175e:	75 9c                	jne    8016fc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801760:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	48                   	dec    %eax
  80176b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80176e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801772:	74 3d                	je     8017b1 <ltostr+0xe2>
		start = 1 ;
  801774:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80177b:	eb 34                	jmp    8017b1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80177d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	01 d0                	add    %edx,%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80178a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801790:	01 c2                	add    %eax,%edx
  801792:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801795:	8b 45 0c             	mov    0xc(%ebp),%eax
  801798:	01 c8                	add    %ecx,%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80179e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a4:	01 c2                	add    %eax,%edx
  8017a6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017a9:	88 02                	mov    %al,(%edx)
		start++ ;
  8017ab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017ae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017b7:	7c c4                	jl     80177d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bf:	01 d0                	add    %edx,%eax
  8017c1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017c4:	90                   	nop
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	e8 54 fa ff ff       	call   801229 <strlen>
  8017d5:	83 c4 04             	add    $0x4,%esp
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	e8 46 fa ff ff       	call   801229 <strlen>
  8017e3:	83 c4 04             	add    $0x4,%esp
  8017e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017f7:	eb 17                	jmp    801810 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	01 c2                	add    %eax,%edx
  801801:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	01 c8                	add    %ecx,%eax
  801809:	8a 00                	mov    (%eax),%al
  80180b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80180d:	ff 45 fc             	incl   -0x4(%ebp)
  801810:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801813:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801816:	7c e1                	jl     8017f9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801818:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80181f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801826:	eb 1f                	jmp    801847 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801828:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801831:	89 c2                	mov    %eax,%edx
  801833:	8b 45 10             	mov    0x10(%ebp),%eax
  801836:	01 c2                	add    %eax,%edx
  801838:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80183b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183e:	01 c8                	add    %ecx,%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801844:	ff 45 f8             	incl   -0x8(%ebp)
  801847:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184d:	7c d9                	jl     801828 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80184f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	c6 00 00             	movb   $0x0,(%eax)
}
  80185a:	90                   	nop
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801860:	8b 45 14             	mov    0x14(%ebp),%eax
  801863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801869:	8b 45 14             	mov    0x14(%ebp),%eax
  80186c:	8b 00                	mov    (%eax),%eax
  80186e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801875:	8b 45 10             	mov    0x10(%ebp),%eax
  801878:	01 d0                	add    %edx,%eax
  80187a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801880:	eb 0c                	jmp    80188e <strsplit+0x31>
			*string++ = 0;
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	8d 50 01             	lea    0x1(%eax),%edx
  801888:	89 55 08             	mov    %edx,0x8(%ebp)
  80188b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	8a 00                	mov    (%eax),%al
  801893:	84 c0                	test   %al,%al
  801895:	74 18                	je     8018af <strsplit+0x52>
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	8a 00                	mov    (%eax),%al
  80189c:	0f be c0             	movsbl %al,%eax
  80189f:	50                   	push   %eax
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	e8 13 fb ff ff       	call   8013bb <strchr>
  8018a8:	83 c4 08             	add    $0x8,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	75 d3                	jne    801882 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	8a 00                	mov    (%eax),%al
  8018b4:	84 c0                	test   %al,%al
  8018b6:	74 5a                	je     801912 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bb:	8b 00                	mov    (%eax),%eax
  8018bd:	83 f8 0f             	cmp    $0xf,%eax
  8018c0:	75 07                	jne    8018c9 <strsplit+0x6c>
		{
			return 0;
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c7:	eb 66                	jmp    80192f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018cc:	8b 00                	mov    (%eax),%eax
  8018ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8018d1:	8b 55 14             	mov    0x14(%ebp),%edx
  8018d4:	89 0a                	mov    %ecx,(%edx)
  8018d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e0:	01 c2                	add    %eax,%edx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018e7:	eb 03                	jmp    8018ec <strsplit+0x8f>
			string++;
  8018e9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	8a 00                	mov    (%eax),%al
  8018f1:	84 c0                	test   %al,%al
  8018f3:	74 8b                	je     801880 <strsplit+0x23>
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	8a 00                	mov    (%eax),%al
  8018fa:	0f be c0             	movsbl %al,%eax
  8018fd:	50                   	push   %eax
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	e8 b5 fa ff ff       	call   8013bb <strchr>
  801906:	83 c4 08             	add    $0x8,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	74 dc                	je     8018e9 <strsplit+0x8c>
			string++;
	}
  80190d:	e9 6e ff ff ff       	jmp    801880 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801912:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801913:	8b 45 14             	mov    0x14(%ebp),%eax
  801916:	8b 00                	mov    (%eax),%eax
  801918:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80191f:	8b 45 10             	mov    0x10(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80192a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801937:	a1 04 50 80 00       	mov    0x805004,%eax
  80193c:	85 c0                	test   %eax,%eax
  80193e:	74 1f                	je     80195f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801940:	e8 1d 00 00 00       	call   801962 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	68 d0 3f 80 00       	push   $0x803fd0
  80194d:	e8 55 f2 ff ff       	call   800ba7 <cprintf>
  801952:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801955:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80195c:	00 00 00 
	}
}
  80195f:	90                   	nop
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801968:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80196f:	00 00 00 
  801972:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801979:	00 00 00 
  80197c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801983:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801986:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80198d:	00 00 00 
  801990:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801997:	00 00 00 
  80199a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8019a1:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  8019a4:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  8019ab:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  8019ae:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8019b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019bd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019c2:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8019c7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019ce:	a1 20 51 80 00       	mov    0x805120,%eax
  8019d3:	c1 e0 04             	shl    $0x4,%eax
  8019d6:	89 c2                	mov    %eax,%edx
  8019d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019db:	01 d0                	add    %edx,%eax
  8019dd:	48                   	dec    %eax
  8019de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e9:	f7 75 f0             	divl   -0x10(%ebp)
  8019ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ef:	29 d0                	sub    %edx,%eax
  8019f1:	89 c2                	mov    %eax,%edx
  8019f3:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8019fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a02:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a07:	83 ec 04             	sub    $0x4,%esp
  801a0a:	6a 06                	push   $0x6
  801a0c:	52                   	push   %edx
  801a0d:	50                   	push   %eax
  801a0e:	e8 71 05 00 00       	call   801f84 <sys_allocate_chunk>
  801a13:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a16:	a1 20 51 80 00       	mov    0x805120,%eax
  801a1b:	83 ec 0c             	sub    $0xc,%esp
  801a1e:	50                   	push   %eax
  801a1f:	e8 e6 0b 00 00       	call   80260a <initialize_MemBlocksList>
  801a24:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801a27:	a1 48 51 80 00       	mov    0x805148,%eax
  801a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801a2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a33:	75 14                	jne    801a49 <initialize_dyn_block_system+0xe7>
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	68 f5 3f 80 00       	push   $0x803ff5
  801a3d:	6a 2b                	push   $0x2b
  801a3f:	68 13 40 80 00       	push   $0x804013
  801a44:	e8 aa ee ff ff       	call   8008f3 <_panic>
  801a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a4c:	8b 00                	mov    (%eax),%eax
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	74 10                	je     801a62 <initialize_dyn_block_system+0x100>
  801a52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a55:	8b 00                	mov    (%eax),%eax
  801a57:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a5a:	8b 52 04             	mov    0x4(%edx),%edx
  801a5d:	89 50 04             	mov    %edx,0x4(%eax)
  801a60:	eb 0b                	jmp    801a6d <initialize_dyn_block_system+0x10b>
  801a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a65:	8b 40 04             	mov    0x4(%eax),%eax
  801a68:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801a6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a70:	8b 40 04             	mov    0x4(%eax),%eax
  801a73:	85 c0                	test   %eax,%eax
  801a75:	74 0f                	je     801a86 <initialize_dyn_block_system+0x124>
  801a77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a7a:	8b 40 04             	mov    0x4(%eax),%eax
  801a7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801a80:	8b 12                	mov    (%edx),%edx
  801a82:	89 10                	mov    %edx,(%eax)
  801a84:	eb 0a                	jmp    801a90 <initialize_dyn_block_system+0x12e>
  801a86:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a89:	8b 00                	mov    (%eax),%eax
  801a8b:	a3 48 51 80 00       	mov    %eax,0x805148
  801a90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801aa3:	a1 54 51 80 00       	mov    0x805154,%eax
  801aa8:	48                   	dec    %eax
  801aa9:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801aae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ab1:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801ab8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801abb:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801ac2:	83 ec 0c             	sub    $0xc,%esp
  801ac5:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ac8:	e8 d2 13 00 00       	call   802e9f <insert_sorted_with_merge_freeList>
  801acd:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801ad0:	90                   	nop
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
  801ad6:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ad9:	e8 53 fe ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ade:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ae2:	75 07                	jne    801aeb <malloc+0x18>
  801ae4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ae9:	eb 61                	jmp    801b4c <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801aeb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801af2:	8b 55 08             	mov    0x8(%ebp),%edx
  801af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af8:	01 d0                	add    %edx,%eax
  801afa:	48                   	dec    %eax
  801afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801afe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b01:	ba 00 00 00 00       	mov    $0x0,%edx
  801b06:	f7 75 f4             	divl   -0xc(%ebp)
  801b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0c:	29 d0                	sub    %edx,%eax
  801b0e:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801b11:	e8 3c 08 00 00       	call   802352 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b16:	85 c0                	test   %eax,%eax
  801b18:	74 2d                	je     801b47 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801b1a:	83 ec 0c             	sub    $0xc,%esp
  801b1d:	ff 75 08             	pushl  0x8(%ebp)
  801b20:	e8 3e 0f 00 00       	call   802a63 <alloc_block_FF>
  801b25:	83 c4 10             	add    $0x10,%esp
  801b28:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801b2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801b2f:	74 16                	je     801b47 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801b31:	83 ec 0c             	sub    $0xc,%esp
  801b34:	ff 75 ec             	pushl  -0x14(%ebp)
  801b37:	e8 48 0c 00 00       	call   802784 <insert_sorted_allocList>
  801b3c:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b42:	8b 40 08             	mov    0x8(%eax),%eax
  801b45:	eb 05                	jmp    801b4c <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801b47:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b62:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	83 ec 08             	sub    $0x8,%esp
  801b6b:	50                   	push   %eax
  801b6c:	68 40 50 80 00       	push   $0x805040
  801b71:	e8 71 0b 00 00       	call   8026e7 <find_block>
  801b76:	83 c4 10             	add    $0x10,%esp
  801b79:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7f:	8b 50 0c             	mov    0xc(%eax),%edx
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	83 ec 08             	sub    $0x8,%esp
  801b88:	52                   	push   %edx
  801b89:	50                   	push   %eax
  801b8a:	e8 bd 03 00 00       	call   801f4c <sys_free_user_mem>
  801b8f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801b92:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b96:	75 14                	jne    801bac <free+0x5e>
  801b98:	83 ec 04             	sub    $0x4,%esp
  801b9b:	68 f5 3f 80 00       	push   $0x803ff5
  801ba0:	6a 71                	push   $0x71
  801ba2:	68 13 40 80 00       	push   $0x804013
  801ba7:	e8 47 ed ff ff       	call   8008f3 <_panic>
  801bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801baf:	8b 00                	mov    (%eax),%eax
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	74 10                	je     801bc5 <free+0x77>
  801bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb8:	8b 00                	mov    (%eax),%eax
  801bba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bbd:	8b 52 04             	mov    0x4(%edx),%edx
  801bc0:	89 50 04             	mov    %edx,0x4(%eax)
  801bc3:	eb 0b                	jmp    801bd0 <free+0x82>
  801bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc8:	8b 40 04             	mov    0x4(%eax),%eax
  801bcb:	a3 44 50 80 00       	mov    %eax,0x805044
  801bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd3:	8b 40 04             	mov    0x4(%eax),%eax
  801bd6:	85 c0                	test   %eax,%eax
  801bd8:	74 0f                	je     801be9 <free+0x9b>
  801bda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bdd:	8b 40 04             	mov    0x4(%eax),%eax
  801be0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801be3:	8b 12                	mov    (%edx),%edx
  801be5:	89 10                	mov    %edx,(%eax)
  801be7:	eb 0a                	jmp    801bf3 <free+0xa5>
  801be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bec:	8b 00                	mov    (%eax),%eax
  801bee:	a3 40 50 80 00       	mov    %eax,0x805040
  801bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bf6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c06:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c0b:	48                   	dec    %eax
  801c0c:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801c11:	83 ec 0c             	sub    $0xc,%esp
  801c14:	ff 75 f0             	pushl  -0x10(%ebp)
  801c17:	e8 83 12 00 00       	call   802e9f <insert_sorted_with_merge_freeList>
  801c1c:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801c1f:	90                   	nop
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 28             	sub    $0x28,%esp
  801c28:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2b:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c2e:	e8 fe fc ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c33:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c37:	75 0a                	jne    801c43 <smalloc+0x21>
  801c39:	b8 00 00 00 00       	mov    $0x0,%eax
  801c3e:	e9 86 00 00 00       	jmp    801cc9 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801c43:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c50:	01 d0                	add    %edx,%eax
  801c52:	48                   	dec    %eax
  801c53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c59:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5e:	f7 75 f4             	divl   -0xc(%ebp)
  801c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c64:	29 d0                	sub    %edx,%eax
  801c66:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801c69:	e8 e4 06 00 00       	call   802352 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	74 52                	je     801cc4 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801c72:	83 ec 0c             	sub    $0xc,%esp
  801c75:	ff 75 0c             	pushl  0xc(%ebp)
  801c78:	e8 e6 0d 00 00       	call   802a63 <alloc_block_FF>
  801c7d:	83 c4 10             	add    $0x10,%esp
  801c80:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801c83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c87:	75 07                	jne    801c90 <smalloc+0x6e>
			return NULL ;
  801c89:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8e:	eb 39                	jmp    801cc9 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801c90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c93:	8b 40 08             	mov    0x8(%eax),%eax
  801c96:	89 c2                	mov    %eax,%edx
  801c98:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801c9c:	52                   	push   %edx
  801c9d:	50                   	push   %eax
  801c9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ca1:	ff 75 08             	pushl  0x8(%ebp)
  801ca4:	e8 2e 04 00 00       	call   8020d7 <sys_createSharedObject>
  801ca9:	83 c4 10             	add    $0x10,%esp
  801cac:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801caf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801cb3:	79 07                	jns    801cbc <smalloc+0x9a>
			return (void*)NULL ;
  801cb5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cba:	eb 0d                	jmp    801cc9 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801cbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cbf:	8b 40 08             	mov    0x8(%eax),%eax
  801cc2:	eb 05                	jmp    801cc9 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801cc4:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cd1:	e8 5b fc ff ff       	call   801931 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801cd6:	83 ec 08             	sub    $0x8,%esp
  801cd9:	ff 75 0c             	pushl  0xc(%ebp)
  801cdc:	ff 75 08             	pushl  0x8(%ebp)
  801cdf:	e8 1d 04 00 00       	call   802101 <sys_getSizeOfSharedObject>
  801ce4:	83 c4 10             	add    $0x10,%esp
  801ce7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801cea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801cee:	75 0a                	jne    801cfa <sget+0x2f>
			return NULL ;
  801cf0:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf5:	e9 83 00 00 00       	jmp    801d7d <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801cfa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d07:	01 d0                	add    %edx,%eax
  801d09:	48                   	dec    %eax
  801d0a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d10:	ba 00 00 00 00       	mov    $0x0,%edx
  801d15:	f7 75 f0             	divl   -0x10(%ebp)
  801d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d1b:	29 d0                	sub    %edx,%eax
  801d1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801d20:	e8 2d 06 00 00       	call   802352 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d25:	85 c0                	test   %eax,%eax
  801d27:	74 4f                	je     801d78 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2c:	83 ec 0c             	sub    $0xc,%esp
  801d2f:	50                   	push   %eax
  801d30:	e8 2e 0d 00 00       	call   802a63 <alloc_block_FF>
  801d35:	83 c4 10             	add    $0x10,%esp
  801d38:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801d3b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801d3f:	75 07                	jne    801d48 <sget+0x7d>
					return (void*)NULL ;
  801d41:	b8 00 00 00 00       	mov    $0x0,%eax
  801d46:	eb 35                	jmp    801d7d <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801d48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d4b:	8b 40 08             	mov    0x8(%eax),%eax
  801d4e:	83 ec 04             	sub    $0x4,%esp
  801d51:	50                   	push   %eax
  801d52:	ff 75 0c             	pushl  0xc(%ebp)
  801d55:	ff 75 08             	pushl  0x8(%ebp)
  801d58:	e8 c1 03 00 00       	call   80211e <sys_getSharedObject>
  801d5d:	83 c4 10             	add    $0x10,%esp
  801d60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801d63:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d67:	79 07                	jns    801d70 <sget+0xa5>
				return (void*)NULL ;
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6e:	eb 0d                	jmp    801d7d <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801d70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801d73:	8b 40 08             	mov    0x8(%eax),%eax
  801d76:	eb 05                	jmp    801d7d <sget+0xb2>


		}
	return (void*)NULL ;
  801d78:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d85:	e8 a7 fb ff ff       	call   801931 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d8a:	83 ec 04             	sub    $0x4,%esp
  801d8d:	68 20 40 80 00       	push   $0x804020
  801d92:	68 f9 00 00 00       	push   $0xf9
  801d97:	68 13 40 80 00       	push   $0x804013
  801d9c:	e8 52 eb ff ff       	call   8008f3 <_panic>

00801da1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801da7:	83 ec 04             	sub    $0x4,%esp
  801daa:	68 48 40 80 00       	push   $0x804048
  801daf:	68 0d 01 00 00       	push   $0x10d
  801db4:	68 13 40 80 00       	push   $0x804013
  801db9:	e8 35 eb ff ff       	call   8008f3 <_panic>

00801dbe <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dc4:	83 ec 04             	sub    $0x4,%esp
  801dc7:	68 6c 40 80 00       	push   $0x80406c
  801dcc:	68 18 01 00 00       	push   $0x118
  801dd1:	68 13 40 80 00       	push   $0x804013
  801dd6:	e8 18 eb ff ff       	call   8008f3 <_panic>

00801ddb <shrink>:

}
void shrink(uint32 newSize)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	68 6c 40 80 00       	push   $0x80406c
  801de9:	68 1d 01 00 00       	push   $0x11d
  801dee:	68 13 40 80 00       	push   $0x804013
  801df3:	e8 fb ea ff ff       	call   8008f3 <_panic>

00801df8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801dfe:	83 ec 04             	sub    $0x4,%esp
  801e01:	68 6c 40 80 00       	push   $0x80406c
  801e06:	68 22 01 00 00       	push   $0x122
  801e0b:	68 13 40 80 00       	push   $0x804013
  801e10:	e8 de ea ff ff       	call   8008f3 <_panic>

00801e15 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	57                   	push   %edi
  801e19:	56                   	push   %esi
  801e1a:	53                   	push   %ebx
  801e1b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e27:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e2a:	8b 7d 18             	mov    0x18(%ebp),%edi
  801e2d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801e30:	cd 30                	int    $0x30
  801e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801e35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801e38:	83 c4 10             	add    $0x10,%esp
  801e3b:	5b                   	pop    %ebx
  801e3c:	5e                   	pop    %esi
  801e3d:	5f                   	pop    %edi
  801e3e:	5d                   	pop    %ebp
  801e3f:	c3                   	ret    

00801e40 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 04             	sub    $0x4,%esp
  801e46:	8b 45 10             	mov    0x10(%ebp),%eax
  801e49:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801e4c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	52                   	push   %edx
  801e58:	ff 75 0c             	pushl  0xc(%ebp)
  801e5b:	50                   	push   %eax
  801e5c:	6a 00                	push   $0x0
  801e5e:	e8 b2 ff ff ff       	call   801e15 <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
}
  801e66:	90                   	nop
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_cgetc>:

int
sys_cgetc(void)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 01                	push   $0x1
  801e78:	e8 98 ff ff ff       	call   801e15 <syscall>
  801e7d:	83 c4 18             	add    $0x18,%esp
}
  801e80:	c9                   	leave  
  801e81:	c3                   	ret    

00801e82 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e82:	55                   	push   %ebp
  801e83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e88:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	52                   	push   %edx
  801e92:	50                   	push   %eax
  801e93:	6a 05                	push   $0x5
  801e95:	e8 7b ff ff ff       	call   801e15 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
  801ea2:	56                   	push   %esi
  801ea3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ea4:	8b 75 18             	mov    0x18(%ebp),%esi
  801ea7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	56                   	push   %esi
  801eb4:	53                   	push   %ebx
  801eb5:	51                   	push   %ecx
  801eb6:	52                   	push   %edx
  801eb7:	50                   	push   %eax
  801eb8:	6a 06                	push   $0x6
  801eba:	e8 56 ff ff ff       	call   801e15 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
}
  801ec2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ec5:	5b                   	pop    %ebx
  801ec6:	5e                   	pop    %esi
  801ec7:	5d                   	pop    %ebp
  801ec8:	c3                   	ret    

00801ec9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ec9:	55                   	push   %ebp
  801eca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ecc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	52                   	push   %edx
  801ed9:	50                   	push   %eax
  801eda:	6a 07                	push   $0x7
  801edc:	e8 34 ff ff ff       	call   801e15 <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	ff 75 0c             	pushl  0xc(%ebp)
  801ef2:	ff 75 08             	pushl  0x8(%ebp)
  801ef5:	6a 08                	push   $0x8
  801ef7:	e8 19 ff ff ff       	call   801e15 <syscall>
  801efc:	83 c4 18             	add    $0x18,%esp
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 09                	push   $0x9
  801f10:	e8 00 ff ff ff       	call   801e15 <syscall>
  801f15:	83 c4 18             	add    $0x18,%esp
}
  801f18:	c9                   	leave  
  801f19:	c3                   	ret    

00801f1a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801f1a:	55                   	push   %ebp
  801f1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 00                	push   $0x0
  801f25:	6a 00                	push   $0x0
  801f27:	6a 0a                	push   $0xa
  801f29:	e8 e7 fe ff ff       	call   801e15 <syscall>
  801f2e:	83 c4 18             	add    $0x18,%esp
}
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 0b                	push   $0xb
  801f42:	e8 ce fe ff ff       	call   801e15 <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	ff 75 0c             	pushl  0xc(%ebp)
  801f58:	ff 75 08             	pushl  0x8(%ebp)
  801f5b:	6a 0f                	push   $0xf
  801f5d:	e8 b3 fe ff ff       	call   801e15 <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
	return;
  801f65:	90                   	nop
}
  801f66:	c9                   	leave  
  801f67:	c3                   	ret    

00801f68 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801f68:	55                   	push   %ebp
  801f69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	ff 75 0c             	pushl  0xc(%ebp)
  801f74:	ff 75 08             	pushl  0x8(%ebp)
  801f77:	6a 10                	push   $0x10
  801f79:	e8 97 fe ff ff       	call   801e15 <syscall>
  801f7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801f81:	90                   	nop
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	ff 75 10             	pushl  0x10(%ebp)
  801f8e:	ff 75 0c             	pushl  0xc(%ebp)
  801f91:	ff 75 08             	pushl  0x8(%ebp)
  801f94:	6a 11                	push   $0x11
  801f96:	e8 7a fe ff ff       	call   801e15 <syscall>
  801f9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9e:	90                   	nop
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 0c                	push   $0xc
  801fb0:	e8 60 fe ff ff       	call   801e15 <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	ff 75 08             	pushl  0x8(%ebp)
  801fc8:	6a 0d                	push   $0xd
  801fca:	e8 46 fe ff ff       	call   801e15 <syscall>
  801fcf:	83 c4 18             	add    $0x18,%esp
}
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 0e                	push   $0xe
  801fe3:	e8 2d fe ff ff       	call   801e15 <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
}
  801feb:	90                   	nop
  801fec:	c9                   	leave  
  801fed:	c3                   	ret    

00801fee <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ff1:	6a 00                	push   $0x0
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 13                	push   $0x13
  801ffd:	e8 13 fe ff ff       	call   801e15 <syscall>
  802002:	83 c4 18             	add    $0x18,%esp
}
  802005:	90                   	nop
  802006:	c9                   	leave  
  802007:	c3                   	ret    

00802008 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802008:	55                   	push   %ebp
  802009:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	6a 00                	push   $0x0
  802013:	6a 00                	push   $0x0
  802015:	6a 14                	push   $0x14
  802017:	e8 f9 fd ff ff       	call   801e15 <syscall>
  80201c:	83 c4 18             	add    $0x18,%esp
}
  80201f:	90                   	nop
  802020:	c9                   	leave  
  802021:	c3                   	ret    

00802022 <sys_cputc>:


void
sys_cputc(const char c)
{
  802022:	55                   	push   %ebp
  802023:	89 e5                	mov    %esp,%ebp
  802025:	83 ec 04             	sub    $0x4,%esp
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80202e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	50                   	push   %eax
  80203b:	6a 15                	push   $0x15
  80203d:	e8 d3 fd ff ff       	call   801e15 <syscall>
  802042:	83 c4 18             	add    $0x18,%esp
}
  802045:	90                   	nop
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 16                	push   $0x16
  802057:	e8 b9 fd ff ff       	call   801e15 <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
}
  80205f:	90                   	nop
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	ff 75 0c             	pushl  0xc(%ebp)
  802071:	50                   	push   %eax
  802072:	6a 17                	push   $0x17
  802074:	e8 9c fd ff ff       	call   801e15 <syscall>
  802079:	83 c4 18             	add    $0x18,%esp
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802081:	8b 55 0c             	mov    0xc(%ebp),%edx
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	52                   	push   %edx
  80208e:	50                   	push   %eax
  80208f:	6a 1a                	push   $0x1a
  802091:	e8 7f fd ff ff       	call   801e15 <syscall>
  802096:	83 c4 18             	add    $0x18,%esp
}
  802099:	c9                   	leave  
  80209a:	c3                   	ret    

0080209b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80209b:	55                   	push   %ebp
  80209c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80209e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	52                   	push   %edx
  8020ab:	50                   	push   %eax
  8020ac:	6a 18                	push   $0x18
  8020ae:	e8 62 fd ff ff       	call   801e15 <syscall>
  8020b3:	83 c4 18             	add    $0x18,%esp
}
  8020b6:	90                   	nop
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8020bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	52                   	push   %edx
  8020c9:	50                   	push   %eax
  8020ca:	6a 19                	push   $0x19
  8020cc:	e8 44 fd ff ff       	call   801e15 <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	90                   	nop
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
  8020da:	83 ec 04             	sub    $0x4,%esp
  8020dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8020e3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8020e6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	6a 00                	push   $0x0
  8020ef:	51                   	push   %ecx
  8020f0:	52                   	push   %edx
  8020f1:	ff 75 0c             	pushl  0xc(%ebp)
  8020f4:	50                   	push   %eax
  8020f5:	6a 1b                	push   $0x1b
  8020f7:	e8 19 fd ff ff       	call   801e15 <syscall>
  8020fc:	83 c4 18             	add    $0x18,%esp
}
  8020ff:	c9                   	leave  
  802100:	c3                   	ret    

00802101 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802101:	55                   	push   %ebp
  802102:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802104:	8b 55 0c             	mov    0xc(%ebp),%edx
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	52                   	push   %edx
  802111:	50                   	push   %eax
  802112:	6a 1c                	push   $0x1c
  802114:	e8 fc fc ff ff       	call   801e15 <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802121:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802124:	8b 55 0c             	mov    0xc(%ebp),%edx
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	51                   	push   %ecx
  80212f:	52                   	push   %edx
  802130:	50                   	push   %eax
  802131:	6a 1d                	push   $0x1d
  802133:	e8 dd fc ff ff       	call   801e15 <syscall>
  802138:	83 c4 18             	add    $0x18,%esp
}
  80213b:	c9                   	leave  
  80213c:	c3                   	ret    

0080213d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80213d:	55                   	push   %ebp
  80213e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802140:	8b 55 0c             	mov    0xc(%ebp),%edx
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	52                   	push   %edx
  80214d:	50                   	push   %eax
  80214e:	6a 1e                	push   $0x1e
  802150:	e8 c0 fc ff ff       	call   801e15 <syscall>
  802155:	83 c4 18             	add    $0x18,%esp
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    

0080215a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80215a:	55                   	push   %ebp
  80215b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 1f                	push   $0x1f
  802169:	e8 a7 fc ff ff       	call   801e15 <syscall>
  80216e:	83 c4 18             	add    $0x18,%esp
}
  802171:	c9                   	leave  
  802172:	c3                   	ret    

00802173 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	6a 00                	push   $0x0
  80217b:	ff 75 14             	pushl  0x14(%ebp)
  80217e:	ff 75 10             	pushl  0x10(%ebp)
  802181:	ff 75 0c             	pushl  0xc(%ebp)
  802184:	50                   	push   %eax
  802185:	6a 20                	push   $0x20
  802187:	e8 89 fc ff ff       	call   801e15 <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
}
  80218f:	c9                   	leave  
  802190:	c3                   	ret    

00802191 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802194:	8b 45 08             	mov    0x8(%ebp),%eax
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	50                   	push   %eax
  8021a0:	6a 21                	push   $0x21
  8021a2:	e8 6e fc ff ff       	call   801e15 <syscall>
  8021a7:	83 c4 18             	add    $0x18,%esp
}
  8021aa:	90                   	nop
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	6a 00                	push   $0x0
  8021b5:	6a 00                	push   $0x0
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	50                   	push   %eax
  8021bc:	6a 22                	push   $0x22
  8021be:	e8 52 fc ff ff       	call   801e15 <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
}
  8021c6:	c9                   	leave  
  8021c7:	c3                   	ret    

008021c8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8021c8:	55                   	push   %ebp
  8021c9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 02                	push   $0x2
  8021d7:	e8 39 fc ff ff       	call   801e15 <syscall>
  8021dc:	83 c4 18             	add    $0x18,%esp
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 03                	push   $0x3
  8021f0:	e8 20 fc ff ff       	call   801e15 <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
}
  8021f8:	c9                   	leave  
  8021f9:	c3                   	ret    

008021fa <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 04                	push   $0x4
  802209:	e8 07 fc ff ff       	call   801e15 <syscall>
  80220e:	83 c4 18             	add    $0x18,%esp
}
  802211:	c9                   	leave  
  802212:	c3                   	ret    

00802213 <sys_exit_env>:


void sys_exit_env(void)
{
  802213:	55                   	push   %ebp
  802214:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 23                	push   $0x23
  802222:	e8 ee fb ff ff       	call   801e15 <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
}
  80222a:	90                   	nop
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
  802230:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802233:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802236:	8d 50 04             	lea    0x4(%eax),%edx
  802239:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	6a 00                	push   $0x0
  802242:	52                   	push   %edx
  802243:	50                   	push   %eax
  802244:	6a 24                	push   $0x24
  802246:	e8 ca fb ff ff       	call   801e15 <syscall>
  80224b:	83 c4 18             	add    $0x18,%esp
	return result;
  80224e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802251:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802254:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802257:	89 01                	mov    %eax,(%ecx)
  802259:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	c9                   	leave  
  802260:	c2 04 00             	ret    $0x4

00802263 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	ff 75 10             	pushl  0x10(%ebp)
  80226d:	ff 75 0c             	pushl  0xc(%ebp)
  802270:	ff 75 08             	pushl  0x8(%ebp)
  802273:	6a 12                	push   $0x12
  802275:	e8 9b fb ff ff       	call   801e15 <syscall>
  80227a:	83 c4 18             	add    $0x18,%esp
	return ;
  80227d:	90                   	nop
}
  80227e:	c9                   	leave  
  80227f:	c3                   	ret    

00802280 <sys_rcr2>:
uint32 sys_rcr2()
{
  802280:	55                   	push   %ebp
  802281:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 25                	push   $0x25
  80228f:	e8 81 fb ff ff       	call   801e15 <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
  80229c:	83 ec 04             	sub    $0x4,%esp
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8022a5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	50                   	push   %eax
  8022b2:	6a 26                	push   $0x26
  8022b4:	e8 5c fb ff ff       	call   801e15 <syscall>
  8022b9:	83 c4 18             	add    $0x18,%esp
	return ;
  8022bc:	90                   	nop
}
  8022bd:	c9                   	leave  
  8022be:	c3                   	ret    

008022bf <rsttst>:
void rsttst()
{
  8022bf:	55                   	push   %ebp
  8022c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 28                	push   $0x28
  8022ce:	e8 42 fb ff ff       	call   801e15 <syscall>
  8022d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d6:	90                   	nop
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	83 ec 04             	sub    $0x4,%esp
  8022df:	8b 45 14             	mov    0x14(%ebp),%eax
  8022e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8022e5:	8b 55 18             	mov    0x18(%ebp),%edx
  8022e8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022ec:	52                   	push   %edx
  8022ed:	50                   	push   %eax
  8022ee:	ff 75 10             	pushl  0x10(%ebp)
  8022f1:	ff 75 0c             	pushl  0xc(%ebp)
  8022f4:	ff 75 08             	pushl  0x8(%ebp)
  8022f7:	6a 27                	push   $0x27
  8022f9:	e8 17 fb ff ff       	call   801e15 <syscall>
  8022fe:	83 c4 18             	add    $0x18,%esp
	return ;
  802301:	90                   	nop
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <chktst>:
void chktst(uint32 n)
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 00                	push   $0x0
  80230f:	ff 75 08             	pushl  0x8(%ebp)
  802312:	6a 29                	push   $0x29
  802314:	e8 fc fa ff ff       	call   801e15 <syscall>
  802319:	83 c4 18             	add    $0x18,%esp
	return ;
  80231c:	90                   	nop
}
  80231d:	c9                   	leave  
  80231e:	c3                   	ret    

0080231f <inctst>:

void inctst()
{
  80231f:	55                   	push   %ebp
  802320:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	6a 00                	push   $0x0
  802328:	6a 00                	push   $0x0
  80232a:	6a 00                	push   $0x0
  80232c:	6a 2a                	push   $0x2a
  80232e:	e8 e2 fa ff ff       	call   801e15 <syscall>
  802333:	83 c4 18             	add    $0x18,%esp
	return ;
  802336:	90                   	nop
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <gettst>:
uint32 gettst()
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 2b                	push   $0x2b
  802348:	e8 c8 fa ff ff       	call   801e15 <syscall>
  80234d:	83 c4 18             	add    $0x18,%esp
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 2c                	push   $0x2c
  802364:	e8 ac fa ff ff       	call   801e15 <syscall>
  802369:	83 c4 18             	add    $0x18,%esp
  80236c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80236f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802373:	75 07                	jne    80237c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802375:	b8 01 00 00 00       	mov    $0x1,%eax
  80237a:	eb 05                	jmp    802381 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80237c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802381:	c9                   	leave  
  802382:	c3                   	ret    

00802383 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802383:	55                   	push   %ebp
  802384:	89 e5                	mov    %esp,%ebp
  802386:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 2c                	push   $0x2c
  802395:	e8 7b fa ff ff       	call   801e15 <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
  80239d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8023a0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8023a4:	75 07                	jne    8023ad <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8023a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023ab:	eb 05                	jmp    8023b2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8023ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8023ba:	6a 00                	push   $0x0
  8023bc:	6a 00                	push   $0x0
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 2c                	push   $0x2c
  8023c6:	e8 4a fa ff ff       	call   801e15 <syscall>
  8023cb:	83 c4 18             	add    $0x18,%esp
  8023ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8023d1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8023d5:	75 07                	jne    8023de <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8023d7:	b8 01 00 00 00       	mov    $0x1,%eax
  8023dc:	eb 05                	jmp    8023e3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8023de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e3:	c9                   	leave  
  8023e4:	c3                   	ret    

008023e5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  8023f7:	e8 19 fa ff ff       	call   801e15 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
  8023ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802402:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802406:	75 07                	jne    80240f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802408:	b8 01 00 00 00       	mov    $0x1,%eax
  80240d:	eb 05                	jmp    802414 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802419:	6a 00                	push   $0x0
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	ff 75 08             	pushl  0x8(%ebp)
  802424:	6a 2d                	push   $0x2d
  802426:	e8 ea f9 ff ff       	call   801e15 <syscall>
  80242b:	83 c4 18             	add    $0x18,%esp
	return ;
  80242e:	90                   	nop
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802435:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802438:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80243b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	6a 00                	push   $0x0
  802443:	53                   	push   %ebx
  802444:	51                   	push   %ecx
  802445:	52                   	push   %edx
  802446:	50                   	push   %eax
  802447:	6a 2e                	push   $0x2e
  802449:	e8 c7 f9 ff ff       	call   801e15 <syscall>
  80244e:	83 c4 18             	add    $0x18,%esp
}
  802451:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802459:	8b 55 0c             	mov    0xc(%ebp),%edx
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	6a 00                	push   $0x0
  802461:	6a 00                	push   $0x0
  802463:	6a 00                	push   $0x0
  802465:	52                   	push   %edx
  802466:	50                   	push   %eax
  802467:	6a 2f                	push   $0x2f
  802469:	e8 a7 f9 ff ff       	call   801e15 <syscall>
  80246e:	83 c4 18             	add    $0x18,%esp
}
  802471:	c9                   	leave  
  802472:	c3                   	ret    

00802473 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802473:	55                   	push   %ebp
  802474:	89 e5                	mov    %esp,%ebp
  802476:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802479:	83 ec 0c             	sub    $0xc,%esp
  80247c:	68 7c 40 80 00       	push   $0x80407c
  802481:	e8 21 e7 ff ff       	call   800ba7 <cprintf>
  802486:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802489:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802490:	83 ec 0c             	sub    $0xc,%esp
  802493:	68 a8 40 80 00       	push   $0x8040a8
  802498:	e8 0a e7 ff ff       	call   800ba7 <cprintf>
  80249d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8024a0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8024a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ac:	eb 56                	jmp    802504 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024b2:	74 1c                	je     8024d0 <print_mem_block_lists+0x5d>
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 50 08             	mov    0x8(%eax),%edx
  8024ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bd:	8b 48 08             	mov    0x8(%eax),%ecx
  8024c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c6:	01 c8                	add    %ecx,%eax
  8024c8:	39 c2                	cmp    %eax,%edx
  8024ca:	73 04                	jae    8024d0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8024cc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 50 08             	mov    0x8(%eax),%edx
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024dc:	01 c2                	add    %eax,%edx
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 40 08             	mov    0x8(%eax),%eax
  8024e4:	83 ec 04             	sub    $0x4,%esp
  8024e7:	52                   	push   %edx
  8024e8:	50                   	push   %eax
  8024e9:	68 bd 40 80 00       	push   $0x8040bd
  8024ee:	e8 b4 e6 ff ff       	call   800ba7 <cprintf>
  8024f3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8024fc:	a1 40 51 80 00       	mov    0x805140,%eax
  802501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802508:	74 07                	je     802511 <print_mem_block_lists+0x9e>
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	eb 05                	jmp    802516 <print_mem_block_lists+0xa3>
  802511:	b8 00 00 00 00       	mov    $0x0,%eax
  802516:	a3 40 51 80 00       	mov    %eax,0x805140
  80251b:	a1 40 51 80 00       	mov    0x805140,%eax
  802520:	85 c0                	test   %eax,%eax
  802522:	75 8a                	jne    8024ae <print_mem_block_lists+0x3b>
  802524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802528:	75 84                	jne    8024ae <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80252a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80252e:	75 10                	jne    802540 <print_mem_block_lists+0xcd>
  802530:	83 ec 0c             	sub    $0xc,%esp
  802533:	68 cc 40 80 00       	push   $0x8040cc
  802538:	e8 6a e6 ff ff       	call   800ba7 <cprintf>
  80253d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802540:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802547:	83 ec 0c             	sub    $0xc,%esp
  80254a:	68 f0 40 80 00       	push   $0x8040f0
  80254f:	e8 53 e6 ff ff       	call   800ba7 <cprintf>
  802554:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802557:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80255b:	a1 40 50 80 00       	mov    0x805040,%eax
  802560:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802563:	eb 56                	jmp    8025bb <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802565:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802569:	74 1c                	je     802587 <print_mem_block_lists+0x114>
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 50 08             	mov    0x8(%eax),%edx
  802571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802574:	8b 48 08             	mov    0x8(%eax),%ecx
  802577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257a:	8b 40 0c             	mov    0xc(%eax),%eax
  80257d:	01 c8                	add    %ecx,%eax
  80257f:	39 c2                	cmp    %eax,%edx
  802581:	73 04                	jae    802587 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802583:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 50 08             	mov    0x8(%eax),%edx
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 40 0c             	mov    0xc(%eax),%eax
  802593:	01 c2                	add    %eax,%edx
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 40 08             	mov    0x8(%eax),%eax
  80259b:	83 ec 04             	sub    $0x4,%esp
  80259e:	52                   	push   %edx
  80259f:	50                   	push   %eax
  8025a0:	68 bd 40 80 00       	push   $0x8040bd
  8025a5:	e8 fd e5 ff ff       	call   800ba7 <cprintf>
  8025aa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8025b3:	a1 48 50 80 00       	mov    0x805048,%eax
  8025b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bf:	74 07                	je     8025c8 <print_mem_block_lists+0x155>
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	eb 05                	jmp    8025cd <print_mem_block_lists+0x15a>
  8025c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cd:	a3 48 50 80 00       	mov    %eax,0x805048
  8025d2:	a1 48 50 80 00       	mov    0x805048,%eax
  8025d7:	85 c0                	test   %eax,%eax
  8025d9:	75 8a                	jne    802565 <print_mem_block_lists+0xf2>
  8025db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025df:	75 84                	jne    802565 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8025e1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8025e5:	75 10                	jne    8025f7 <print_mem_block_lists+0x184>
  8025e7:	83 ec 0c             	sub    $0xc,%esp
  8025ea:	68 08 41 80 00       	push   $0x804108
  8025ef:	e8 b3 e5 ff ff       	call   800ba7 <cprintf>
  8025f4:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8025f7:	83 ec 0c             	sub    $0xc,%esp
  8025fa:	68 7c 40 80 00       	push   $0x80407c
  8025ff:	e8 a3 e5 ff ff       	call   800ba7 <cprintf>
  802604:	83 c4 10             	add    $0x10,%esp

}
  802607:	90                   	nop
  802608:	c9                   	leave  
  802609:	c3                   	ret    

0080260a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80260a:	55                   	push   %ebp
  80260b:	89 e5                	mov    %esp,%ebp
  80260d:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802610:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802617:	00 00 00 
  80261a:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802621:	00 00 00 
  802624:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80262b:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80262e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802635:	e9 9e 00 00 00       	jmp    8026d8 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  80263a:	a1 50 50 80 00       	mov    0x805050,%eax
  80263f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802642:	c1 e2 04             	shl    $0x4,%edx
  802645:	01 d0                	add    %edx,%eax
  802647:	85 c0                	test   %eax,%eax
  802649:	75 14                	jne    80265f <initialize_MemBlocksList+0x55>
  80264b:	83 ec 04             	sub    $0x4,%esp
  80264e:	68 30 41 80 00       	push   $0x804130
  802653:	6a 43                	push   $0x43
  802655:	68 53 41 80 00       	push   $0x804153
  80265a:	e8 94 e2 ff ff       	call   8008f3 <_panic>
  80265f:	a1 50 50 80 00       	mov    0x805050,%eax
  802664:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802667:	c1 e2 04             	shl    $0x4,%edx
  80266a:	01 d0                	add    %edx,%eax
  80266c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802672:	89 10                	mov    %edx,(%eax)
  802674:	8b 00                	mov    (%eax),%eax
  802676:	85 c0                	test   %eax,%eax
  802678:	74 18                	je     802692 <initialize_MemBlocksList+0x88>
  80267a:	a1 48 51 80 00       	mov    0x805148,%eax
  80267f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802685:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802688:	c1 e1 04             	shl    $0x4,%ecx
  80268b:	01 ca                	add    %ecx,%edx
  80268d:	89 50 04             	mov    %edx,0x4(%eax)
  802690:	eb 12                	jmp    8026a4 <initialize_MemBlocksList+0x9a>
  802692:	a1 50 50 80 00       	mov    0x805050,%eax
  802697:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269a:	c1 e2 04             	shl    $0x4,%edx
  80269d:	01 d0                	add    %edx,%eax
  80269f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026a4:	a1 50 50 80 00       	mov    0x805050,%eax
  8026a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ac:	c1 e2 04             	shl    $0x4,%edx
  8026af:	01 d0                	add    %edx,%eax
  8026b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8026b6:	a1 50 50 80 00       	mov    0x805050,%eax
  8026bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026be:	c1 e2 04             	shl    $0x4,%edx
  8026c1:	01 d0                	add    %edx,%eax
  8026c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ca:	a1 54 51 80 00       	mov    0x805154,%eax
  8026cf:	40                   	inc    %eax
  8026d0:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8026d5:	ff 45 f4             	incl   -0xc(%ebp)
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026de:	0f 82 56 ff ff ff    	jb     80263a <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8026e4:	90                   	nop
  8026e5:	c9                   	leave  
  8026e6:	c3                   	ret    

008026e7 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8026e7:	55                   	push   %ebp
  8026e8:	89 e5                	mov    %esp,%ebp
  8026ea:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8026ed:	a1 38 51 80 00       	mov    0x805138,%eax
  8026f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8026f5:	eb 18                	jmp    80270f <find_block+0x28>
	{
		if (ele->sva==va)
  8026f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8026fa:	8b 40 08             	mov    0x8(%eax),%eax
  8026fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802700:	75 05                	jne    802707 <find_block+0x20>
			return ele;
  802702:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802705:	eb 7b                	jmp    802782 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802707:	a1 40 51 80 00       	mov    0x805140,%eax
  80270c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80270f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802713:	74 07                	je     80271c <find_block+0x35>
  802715:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802718:	8b 00                	mov    (%eax),%eax
  80271a:	eb 05                	jmp    802721 <find_block+0x3a>
  80271c:	b8 00 00 00 00       	mov    $0x0,%eax
  802721:	a3 40 51 80 00       	mov    %eax,0x805140
  802726:	a1 40 51 80 00       	mov    0x805140,%eax
  80272b:	85 c0                	test   %eax,%eax
  80272d:	75 c8                	jne    8026f7 <find_block+0x10>
  80272f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802733:	75 c2                	jne    8026f7 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802735:	a1 40 50 80 00       	mov    0x805040,%eax
  80273a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80273d:	eb 18                	jmp    802757 <find_block+0x70>
	{
		if (ele->sva==va)
  80273f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802742:	8b 40 08             	mov    0x8(%eax),%eax
  802745:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802748:	75 05                	jne    80274f <find_block+0x68>
					return ele;
  80274a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80274d:	eb 33                	jmp    802782 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80274f:	a1 48 50 80 00       	mov    0x805048,%eax
  802754:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802757:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80275b:	74 07                	je     802764 <find_block+0x7d>
  80275d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802760:	8b 00                	mov    (%eax),%eax
  802762:	eb 05                	jmp    802769 <find_block+0x82>
  802764:	b8 00 00 00 00       	mov    $0x0,%eax
  802769:	a3 48 50 80 00       	mov    %eax,0x805048
  80276e:	a1 48 50 80 00       	mov    0x805048,%eax
  802773:	85 c0                	test   %eax,%eax
  802775:	75 c8                	jne    80273f <find_block+0x58>
  802777:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80277b:	75 c2                	jne    80273f <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  80277d:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802782:	c9                   	leave  
  802783:	c3                   	ret    

00802784 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802784:	55                   	push   %ebp
  802785:	89 e5                	mov    %esp,%ebp
  802787:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  80278a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80278f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802792:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802796:	75 62                	jne    8027fa <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802798:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80279c:	75 14                	jne    8027b2 <insert_sorted_allocList+0x2e>
  80279e:	83 ec 04             	sub    $0x4,%esp
  8027a1:	68 30 41 80 00       	push   $0x804130
  8027a6:	6a 69                	push   $0x69
  8027a8:	68 53 41 80 00       	push   $0x804153
  8027ad:	e8 41 e1 ff ff       	call   8008f3 <_panic>
  8027b2:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8027b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bb:	89 10                	mov    %edx,(%eax)
  8027bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c0:	8b 00                	mov    (%eax),%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	74 0d                	je     8027d3 <insert_sorted_allocList+0x4f>
  8027c6:	a1 40 50 80 00       	mov    0x805040,%eax
  8027cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ce:	89 50 04             	mov    %edx,0x4(%eax)
  8027d1:	eb 08                	jmp    8027db <insert_sorted_allocList+0x57>
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	a3 44 50 80 00       	mov    %eax,0x805044
  8027db:	8b 45 08             	mov    0x8(%ebp),%eax
  8027de:	a3 40 50 80 00       	mov    %eax,0x805040
  8027e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ed:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027f2:	40                   	inc    %eax
  8027f3:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8027f8:	eb 72                	jmp    80286c <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8027fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8027ff:	8b 50 08             	mov    0x8(%eax),%edx
  802802:	8b 45 08             	mov    0x8(%ebp),%eax
  802805:	8b 40 08             	mov    0x8(%eax),%eax
  802808:	39 c2                	cmp    %eax,%edx
  80280a:	76 60                	jbe    80286c <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80280c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802810:	75 14                	jne    802826 <insert_sorted_allocList+0xa2>
  802812:	83 ec 04             	sub    $0x4,%esp
  802815:	68 30 41 80 00       	push   $0x804130
  80281a:	6a 6d                	push   $0x6d
  80281c:	68 53 41 80 00       	push   $0x804153
  802821:	e8 cd e0 ff ff       	call   8008f3 <_panic>
  802826:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	89 10                	mov    %edx,(%eax)
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	8b 00                	mov    (%eax),%eax
  802836:	85 c0                	test   %eax,%eax
  802838:	74 0d                	je     802847 <insert_sorted_allocList+0xc3>
  80283a:	a1 40 50 80 00       	mov    0x805040,%eax
  80283f:	8b 55 08             	mov    0x8(%ebp),%edx
  802842:	89 50 04             	mov    %edx,0x4(%eax)
  802845:	eb 08                	jmp    80284f <insert_sorted_allocList+0xcb>
  802847:	8b 45 08             	mov    0x8(%ebp),%eax
  80284a:	a3 44 50 80 00       	mov    %eax,0x805044
  80284f:	8b 45 08             	mov    0x8(%ebp),%eax
  802852:	a3 40 50 80 00       	mov    %eax,0x805040
  802857:	8b 45 08             	mov    0x8(%ebp),%eax
  80285a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802861:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802866:	40                   	inc    %eax
  802867:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80286c:	a1 40 50 80 00       	mov    0x805040,%eax
  802871:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802874:	e9 b9 01 00 00       	jmp    802a32 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802879:	8b 45 08             	mov    0x8(%ebp),%eax
  80287c:	8b 50 08             	mov    0x8(%eax),%edx
  80287f:	a1 40 50 80 00       	mov    0x805040,%eax
  802884:	8b 40 08             	mov    0x8(%eax),%eax
  802887:	39 c2                	cmp    %eax,%edx
  802889:	76 7c                	jbe    802907 <insert_sorted_allocList+0x183>
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	8b 50 08             	mov    0x8(%eax),%edx
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	8b 40 08             	mov    0x8(%eax),%eax
  802897:	39 c2                	cmp    %eax,%edx
  802899:	73 6c                	jae    802907 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80289b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80289f:	74 06                	je     8028a7 <insert_sorted_allocList+0x123>
  8028a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028a5:	75 14                	jne    8028bb <insert_sorted_allocList+0x137>
  8028a7:	83 ec 04             	sub    $0x4,%esp
  8028aa:	68 6c 41 80 00       	push   $0x80416c
  8028af:	6a 75                	push   $0x75
  8028b1:	68 53 41 80 00       	push   $0x804153
  8028b6:	e8 38 e0 ff ff       	call   8008f3 <_panic>
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	8b 50 04             	mov    0x4(%eax),%edx
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	89 50 04             	mov    %edx,0x4(%eax)
  8028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028cd:	89 10                	mov    %edx,(%eax)
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 40 04             	mov    0x4(%eax),%eax
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	74 0d                	je     8028e6 <insert_sorted_allocList+0x162>
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	8b 40 04             	mov    0x4(%eax),%eax
  8028df:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e2:	89 10                	mov    %edx,(%eax)
  8028e4:	eb 08                	jmp    8028ee <insert_sorted_allocList+0x16a>
  8028e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e9:	a3 40 50 80 00       	mov    %eax,0x805040
  8028ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f4:	89 50 04             	mov    %edx,0x4(%eax)
  8028f7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028fc:	40                   	inc    %eax
  8028fd:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802902:	e9 59 01 00 00       	jmp    802a60 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	8b 50 08             	mov    0x8(%eax),%edx
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	8b 40 08             	mov    0x8(%eax),%eax
  802913:	39 c2                	cmp    %eax,%edx
  802915:	0f 86 98 00 00 00    	jbe    8029b3 <insert_sorted_allocList+0x22f>
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	8b 50 08             	mov    0x8(%eax),%edx
  802921:	a1 44 50 80 00       	mov    0x805044,%eax
  802926:	8b 40 08             	mov    0x8(%eax),%eax
  802929:	39 c2                	cmp    %eax,%edx
  80292b:	0f 83 82 00 00 00    	jae    8029b3 <insert_sorted_allocList+0x22f>
  802931:	8b 45 08             	mov    0x8(%ebp),%eax
  802934:	8b 50 08             	mov    0x8(%eax),%edx
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	8b 40 08             	mov    0x8(%eax),%eax
  80293f:	39 c2                	cmp    %eax,%edx
  802941:	73 70                	jae    8029b3 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802943:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802947:	74 06                	je     80294f <insert_sorted_allocList+0x1cb>
  802949:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80294d:	75 14                	jne    802963 <insert_sorted_allocList+0x1df>
  80294f:	83 ec 04             	sub    $0x4,%esp
  802952:	68 a4 41 80 00       	push   $0x8041a4
  802957:	6a 7c                	push   $0x7c
  802959:	68 53 41 80 00       	push   $0x804153
  80295e:	e8 90 df ff ff       	call   8008f3 <_panic>
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 10                	mov    (%eax),%edx
  802968:	8b 45 08             	mov    0x8(%ebp),%eax
  80296b:	89 10                	mov    %edx,(%eax)
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	74 0b                	je     802981 <insert_sorted_allocList+0x1fd>
  802976:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802979:	8b 00                	mov    (%eax),%eax
  80297b:	8b 55 08             	mov    0x8(%ebp),%edx
  80297e:	89 50 04             	mov    %edx,0x4(%eax)
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 55 08             	mov    0x8(%ebp),%edx
  802987:	89 10                	mov    %edx,(%eax)
  802989:	8b 45 08             	mov    0x8(%ebp),%eax
  80298c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298f:	89 50 04             	mov    %edx,0x4(%eax)
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	8b 00                	mov    (%eax),%eax
  802997:	85 c0                	test   %eax,%eax
  802999:	75 08                	jne    8029a3 <insert_sorted_allocList+0x21f>
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	a3 44 50 80 00       	mov    %eax,0x805044
  8029a3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029a8:	40                   	inc    %eax
  8029a9:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  8029ae:	e9 ad 00 00 00       	jmp    802a60 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	8b 50 08             	mov    0x8(%eax),%edx
  8029b9:	a1 44 50 80 00       	mov    0x805044,%eax
  8029be:	8b 40 08             	mov    0x8(%eax),%eax
  8029c1:	39 c2                	cmp    %eax,%edx
  8029c3:	76 65                	jbe    802a2a <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8029c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c9:	75 17                	jne    8029e2 <insert_sorted_allocList+0x25e>
  8029cb:	83 ec 04             	sub    $0x4,%esp
  8029ce:	68 d8 41 80 00       	push   $0x8041d8
  8029d3:	68 80 00 00 00       	push   $0x80
  8029d8:	68 53 41 80 00       	push   $0x804153
  8029dd:	e8 11 df ff ff       	call   8008f3 <_panic>
  8029e2:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	89 50 04             	mov    %edx,0x4(%eax)
  8029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f1:	8b 40 04             	mov    0x4(%eax),%eax
  8029f4:	85 c0                	test   %eax,%eax
  8029f6:	74 0c                	je     802a04 <insert_sorted_allocList+0x280>
  8029f8:	a1 44 50 80 00       	mov    0x805044,%eax
  8029fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802a00:	89 10                	mov    %edx,(%eax)
  802a02:	eb 08                	jmp    802a0c <insert_sorted_allocList+0x288>
  802a04:	8b 45 08             	mov    0x8(%ebp),%eax
  802a07:	a3 40 50 80 00       	mov    %eax,0x805040
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	a3 44 50 80 00       	mov    %eax,0x805044
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a1d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a22:	40                   	inc    %eax
  802a23:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802a28:	eb 36                	jmp    802a60 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802a2a:	a1 48 50 80 00       	mov    0x805048,%eax
  802a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a36:	74 07                	je     802a3f <insert_sorted_allocList+0x2bb>
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	eb 05                	jmp    802a44 <insert_sorted_allocList+0x2c0>
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a44:	a3 48 50 80 00       	mov    %eax,0x805048
  802a49:	a1 48 50 80 00       	mov    0x805048,%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	0f 85 23 fe ff ff    	jne    802879 <insert_sorted_allocList+0xf5>
  802a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5a:	0f 85 19 fe ff ff    	jne    802879 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802a60:	90                   	nop
  802a61:	c9                   	leave  
  802a62:	c3                   	ret    

00802a63 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a63:	55                   	push   %ebp
  802a64:	89 e5                	mov    %esp,%ebp
  802a66:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802a69:	a1 38 51 80 00       	mov    0x805138,%eax
  802a6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a71:	e9 7c 01 00 00       	jmp    802bf2 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a79:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a7f:	0f 85 90 00 00 00    	jne    802b15 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802a8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8f:	75 17                	jne    802aa8 <alloc_block_FF+0x45>
  802a91:	83 ec 04             	sub    $0x4,%esp
  802a94:	68 fb 41 80 00       	push   $0x8041fb
  802a99:	68 ba 00 00 00       	push   $0xba
  802a9e:	68 53 41 80 00       	push   $0x804153
  802aa3:	e8 4b de ff ff       	call   8008f3 <_panic>
  802aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aab:	8b 00                	mov    (%eax),%eax
  802aad:	85 c0                	test   %eax,%eax
  802aaf:	74 10                	je     802ac1 <alloc_block_FF+0x5e>
  802ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab4:	8b 00                	mov    (%eax),%eax
  802ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab9:	8b 52 04             	mov    0x4(%edx),%edx
  802abc:	89 50 04             	mov    %edx,0x4(%eax)
  802abf:	eb 0b                	jmp    802acc <alloc_block_FF+0x69>
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 40 04             	mov    0x4(%eax),%eax
  802ac7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acf:	8b 40 04             	mov    0x4(%eax),%eax
  802ad2:	85 c0                	test   %eax,%eax
  802ad4:	74 0f                	je     802ae5 <alloc_block_FF+0x82>
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 40 04             	mov    0x4(%eax),%eax
  802adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adf:	8b 12                	mov    (%edx),%edx
  802ae1:	89 10                	mov    %edx,(%eax)
  802ae3:	eb 0a                	jmp    802aef <alloc_block_FF+0x8c>
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	a3 38 51 80 00       	mov    %eax,0x805138
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b02:	a1 44 51 80 00       	mov    0x805144,%eax
  802b07:	48                   	dec    %eax
  802b08:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b10:	e9 10 01 00 00       	jmp    802c25 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1b:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b1e:	0f 86 c6 00 00 00    	jbe    802bea <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802b24:	a1 48 51 80 00       	mov    0x805148,%eax
  802b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802b2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b30:	75 17                	jne    802b49 <alloc_block_FF+0xe6>
  802b32:	83 ec 04             	sub    $0x4,%esp
  802b35:	68 fb 41 80 00       	push   $0x8041fb
  802b3a:	68 c2 00 00 00       	push   $0xc2
  802b3f:	68 53 41 80 00       	push   $0x804153
  802b44:	e8 aa dd ff ff       	call   8008f3 <_panic>
  802b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	85 c0                	test   %eax,%eax
  802b50:	74 10                	je     802b62 <alloc_block_FF+0xff>
  802b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b55:	8b 00                	mov    (%eax),%eax
  802b57:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b5a:	8b 52 04             	mov    0x4(%edx),%edx
  802b5d:	89 50 04             	mov    %edx,0x4(%eax)
  802b60:	eb 0b                	jmp    802b6d <alloc_block_FF+0x10a>
  802b62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b65:	8b 40 04             	mov    0x4(%eax),%eax
  802b68:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b70:	8b 40 04             	mov    0x4(%eax),%eax
  802b73:	85 c0                	test   %eax,%eax
  802b75:	74 0f                	je     802b86 <alloc_block_FF+0x123>
  802b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b7a:	8b 40 04             	mov    0x4(%eax),%eax
  802b7d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b80:	8b 12                	mov    (%edx),%edx
  802b82:	89 10                	mov    %edx,(%eax)
  802b84:	eb 0a                	jmp    802b90 <alloc_block_FF+0x12d>
  802b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b89:	8b 00                	mov    (%eax),%eax
  802b8b:	a3 48 51 80 00       	mov    %eax,0x805148
  802b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba3:	a1 54 51 80 00       	mov    0x805154,%eax
  802ba8:	48                   	dec    %eax
  802ba9:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	8b 50 08             	mov    0x8(%eax),%edx
  802bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb7:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802bba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc0:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc9:	2b 45 08             	sub    0x8(%ebp),%eax
  802bcc:	89 c2                	mov    %eax,%edx
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 50 08             	mov    0x8(%eax),%edx
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	01 c2                	add    %eax,%edx
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802be8:	eb 3b                	jmp    802c25 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802bea:	a1 40 51 80 00       	mov    0x805140,%eax
  802bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf6:	74 07                	je     802bff <alloc_block_FF+0x19c>
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	eb 05                	jmp    802c04 <alloc_block_FF+0x1a1>
  802bff:	b8 00 00 00 00       	mov    $0x0,%eax
  802c04:	a3 40 51 80 00       	mov    %eax,0x805140
  802c09:	a1 40 51 80 00       	mov    0x805140,%eax
  802c0e:	85 c0                	test   %eax,%eax
  802c10:	0f 85 60 fe ff ff    	jne    802a76 <alloc_block_FF+0x13>
  802c16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c1a:	0f 85 56 fe ff ff    	jne    802a76 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802c20:	b8 00 00 00 00       	mov    $0x0,%eax
  802c25:	c9                   	leave  
  802c26:	c3                   	ret    

00802c27 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802c27:	55                   	push   %ebp
  802c28:	89 e5                	mov    %esp,%ebp
  802c2a:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802c2d:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802c34:	a1 38 51 80 00       	mov    0x805138,%eax
  802c39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3c:	eb 3a                	jmp    802c78 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 40 0c             	mov    0xc(%eax),%eax
  802c44:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c47:	72 27                	jb     802c70 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802c49:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802c4d:	75 0b                	jne    802c5a <alloc_block_BF+0x33>
					best_size= element->size;
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 40 0c             	mov    0xc(%eax),%eax
  802c55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802c58:	eb 16                	jmp    802c70 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	8b 50 0c             	mov    0xc(%eax),%edx
  802c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c63:	39 c2                	cmp    %eax,%edx
  802c65:	77 09                	ja     802c70 <alloc_block_BF+0x49>
					best_size=element->size;
  802c67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802c70:	a1 40 51 80 00       	mov    0x805140,%eax
  802c75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7c:	74 07                	je     802c85 <alloc_block_BF+0x5e>
  802c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c81:	8b 00                	mov    (%eax),%eax
  802c83:	eb 05                	jmp    802c8a <alloc_block_BF+0x63>
  802c85:	b8 00 00 00 00       	mov    $0x0,%eax
  802c8a:	a3 40 51 80 00       	mov    %eax,0x805140
  802c8f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c94:	85 c0                	test   %eax,%eax
  802c96:	75 a6                	jne    802c3e <alloc_block_BF+0x17>
  802c98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9c:	75 a0                	jne    802c3e <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802c9e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802ca2:	0f 84 d3 01 00 00    	je     802e7b <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802ca8:	a1 38 51 80 00       	mov    0x805138,%eax
  802cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb0:	e9 98 01 00 00       	jmp    802e4d <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802cb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cbb:	0f 86 da 00 00 00    	jbe    802d9b <alloc_block_BF+0x174>
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 50 0c             	mov    0xc(%eax),%edx
  802cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cca:	39 c2                	cmp    %eax,%edx
  802ccc:	0f 85 c9 00 00 00    	jne    802d9b <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802cd2:	a1 48 51 80 00       	mov    0x805148,%eax
  802cd7:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802cda:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cde:	75 17                	jne    802cf7 <alloc_block_BF+0xd0>
  802ce0:	83 ec 04             	sub    $0x4,%esp
  802ce3:	68 fb 41 80 00       	push   $0x8041fb
  802ce8:	68 ea 00 00 00       	push   $0xea
  802ced:	68 53 41 80 00       	push   $0x804153
  802cf2:	e8 fc db ff ff       	call   8008f3 <_panic>
  802cf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cfa:	8b 00                	mov    (%eax),%eax
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	74 10                	je     802d10 <alloc_block_BF+0xe9>
  802d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d03:	8b 00                	mov    (%eax),%eax
  802d05:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d08:	8b 52 04             	mov    0x4(%edx),%edx
  802d0b:	89 50 04             	mov    %edx,0x4(%eax)
  802d0e:	eb 0b                	jmp    802d1b <alloc_block_BF+0xf4>
  802d10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d13:	8b 40 04             	mov    0x4(%eax),%eax
  802d16:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d1e:	8b 40 04             	mov    0x4(%eax),%eax
  802d21:	85 c0                	test   %eax,%eax
  802d23:	74 0f                	je     802d34 <alloc_block_BF+0x10d>
  802d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d28:	8b 40 04             	mov    0x4(%eax),%eax
  802d2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d2e:	8b 12                	mov    (%edx),%edx
  802d30:	89 10                	mov    %edx,(%eax)
  802d32:	eb 0a                	jmp    802d3e <alloc_block_BF+0x117>
  802d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d37:	8b 00                	mov    (%eax),%eax
  802d39:	a3 48 51 80 00       	mov    %eax,0x805148
  802d3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d41:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d51:	a1 54 51 80 00       	mov    0x805154,%eax
  802d56:	48                   	dec    %eax
  802d57:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5f:	8b 50 08             	mov    0x8(%eax),%edx
  802d62:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d65:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802d68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6e:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 40 0c             	mov    0xc(%eax),%eax
  802d77:	2b 45 08             	sub    0x8(%ebp),%eax
  802d7a:	89 c2                	mov    %eax,%edx
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d85:	8b 50 08             	mov    0x8(%eax),%edx
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	01 c2                	add    %eax,%edx
  802d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d90:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802d93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d96:	e9 e5 00 00 00       	jmp    802e80 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 50 0c             	mov    0xc(%eax),%edx
  802da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da4:	39 c2                	cmp    %eax,%edx
  802da6:	0f 85 99 00 00 00    	jne    802e45 <alloc_block_BF+0x21e>
  802dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802daf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802db2:	0f 85 8d 00 00 00    	jne    802e45 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802dbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc2:	75 17                	jne    802ddb <alloc_block_BF+0x1b4>
  802dc4:	83 ec 04             	sub    $0x4,%esp
  802dc7:	68 fb 41 80 00       	push   $0x8041fb
  802dcc:	68 f7 00 00 00       	push   $0xf7
  802dd1:	68 53 41 80 00       	push   $0x804153
  802dd6:	e8 18 db ff ff       	call   8008f3 <_panic>
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 00                	mov    (%eax),%eax
  802de0:	85 c0                	test   %eax,%eax
  802de2:	74 10                	je     802df4 <alloc_block_BF+0x1cd>
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 00                	mov    (%eax),%eax
  802de9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dec:	8b 52 04             	mov    0x4(%edx),%edx
  802def:	89 50 04             	mov    %edx,0x4(%eax)
  802df2:	eb 0b                	jmp    802dff <alloc_block_BF+0x1d8>
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	8b 40 04             	mov    0x4(%eax),%eax
  802dfa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 40 04             	mov    0x4(%eax),%eax
  802e05:	85 c0                	test   %eax,%eax
  802e07:	74 0f                	je     802e18 <alloc_block_BF+0x1f1>
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	8b 40 04             	mov    0x4(%eax),%eax
  802e0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e12:	8b 12                	mov    (%edx),%edx
  802e14:	89 10                	mov    %edx,(%eax)
  802e16:	eb 0a                	jmp    802e22 <alloc_block_BF+0x1fb>
  802e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1b:	8b 00                	mov    (%eax),%eax
  802e1d:	a3 38 51 80 00       	mov    %eax,0x805138
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e35:	a1 44 51 80 00       	mov    0x805144,%eax
  802e3a:	48                   	dec    %eax
  802e3b:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802e40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e43:	eb 3b                	jmp    802e80 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802e45:	a1 40 51 80 00       	mov    0x805140,%eax
  802e4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e51:	74 07                	je     802e5a <alloc_block_BF+0x233>
  802e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e56:	8b 00                	mov    (%eax),%eax
  802e58:	eb 05                	jmp    802e5f <alloc_block_BF+0x238>
  802e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5f:	a3 40 51 80 00       	mov    %eax,0x805140
  802e64:	a1 40 51 80 00       	mov    0x805140,%eax
  802e69:	85 c0                	test   %eax,%eax
  802e6b:	0f 85 44 fe ff ff    	jne    802cb5 <alloc_block_BF+0x8e>
  802e71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e75:	0f 85 3a fe ff ff    	jne    802cb5 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e80:	c9                   	leave  
  802e81:	c3                   	ret    

00802e82 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802e82:	55                   	push   %ebp
  802e83:	89 e5                	mov    %esp,%ebp
  802e85:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802e88:	83 ec 04             	sub    $0x4,%esp
  802e8b:	68 1c 42 80 00       	push   $0x80421c
  802e90:	68 04 01 00 00       	push   $0x104
  802e95:	68 53 41 80 00       	push   $0x804153
  802e9a:	e8 54 da ff ff       	call   8008f3 <_panic>

00802e9f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802e9f:	55                   	push   %ebp
  802ea0:	89 e5                	mov    %esp,%ebp
  802ea2:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802ea5:	a1 38 51 80 00       	mov    0x805138,%eax
  802eaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802ead:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802eb2:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802eb5:	a1 38 51 80 00       	mov    0x805138,%eax
  802eba:	85 c0                	test   %eax,%eax
  802ebc:	75 68                	jne    802f26 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802ebe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec2:	75 17                	jne    802edb <insert_sorted_with_merge_freeList+0x3c>
  802ec4:	83 ec 04             	sub    $0x4,%esp
  802ec7:	68 30 41 80 00       	push   $0x804130
  802ecc:	68 14 01 00 00       	push   $0x114
  802ed1:	68 53 41 80 00       	push   $0x804153
  802ed6:	e8 18 da ff ff       	call   8008f3 <_panic>
  802edb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	89 10                	mov    %edx,(%eax)
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	8b 00                	mov    (%eax),%eax
  802eeb:	85 c0                	test   %eax,%eax
  802eed:	74 0d                	je     802efc <insert_sorted_with_merge_freeList+0x5d>
  802eef:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef7:	89 50 04             	mov    %edx,0x4(%eax)
  802efa:	eb 08                	jmp    802f04 <insert_sorted_with_merge_freeList+0x65>
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	a3 38 51 80 00       	mov    %eax,0x805138
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f16:	a1 44 51 80 00       	mov    0x805144,%eax
  802f1b:	40                   	inc    %eax
  802f1c:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  802f21:	e9 d2 06 00 00       	jmp    8035f8 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	8b 50 08             	mov    0x8(%eax),%edx
  802f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2f:	8b 40 08             	mov    0x8(%eax),%eax
  802f32:	39 c2                	cmp    %eax,%edx
  802f34:	0f 83 22 01 00 00    	jae    80305c <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	8b 50 08             	mov    0x8(%eax),%edx
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	8b 40 0c             	mov    0xc(%eax),%eax
  802f46:	01 c2                	add    %eax,%edx
  802f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4b:	8b 40 08             	mov    0x8(%eax),%eax
  802f4e:	39 c2                	cmp    %eax,%edx
  802f50:	0f 85 9e 00 00 00    	jne    802ff4 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	8b 50 08             	mov    0x8(%eax),%edx
  802f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5f:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f65:	8b 50 0c             	mov    0xc(%eax),%edx
  802f68:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6e:	01 c2                	add    %eax,%edx
  802f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f73:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	8b 50 08             	mov    0x8(%eax),%edx
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f8c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f90:	75 17                	jne    802fa9 <insert_sorted_with_merge_freeList+0x10a>
  802f92:	83 ec 04             	sub    $0x4,%esp
  802f95:	68 30 41 80 00       	push   $0x804130
  802f9a:	68 21 01 00 00       	push   $0x121
  802f9f:	68 53 41 80 00       	push   $0x804153
  802fa4:	e8 4a d9 ff ff       	call   8008f3 <_panic>
  802fa9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	89 10                	mov    %edx,(%eax)
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	8b 00                	mov    (%eax),%eax
  802fb9:	85 c0                	test   %eax,%eax
  802fbb:	74 0d                	je     802fca <insert_sorted_with_merge_freeList+0x12b>
  802fbd:	a1 48 51 80 00       	mov    0x805148,%eax
  802fc2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc5:	89 50 04             	mov    %edx,0x4(%eax)
  802fc8:	eb 08                	jmp    802fd2 <insert_sorted_with_merge_freeList+0x133>
  802fca:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	a3 48 51 80 00       	mov    %eax,0x805148
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe4:	a1 54 51 80 00       	mov    0x805154,%eax
  802fe9:	40                   	inc    %eax
  802fea:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  802fef:	e9 04 06 00 00       	jmp    8035f8 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802ff4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ff8:	75 17                	jne    803011 <insert_sorted_with_merge_freeList+0x172>
  802ffa:	83 ec 04             	sub    $0x4,%esp
  802ffd:	68 30 41 80 00       	push   $0x804130
  803002:	68 26 01 00 00       	push   $0x126
  803007:	68 53 41 80 00       	push   $0x804153
  80300c:	e8 e2 d8 ff ff       	call   8008f3 <_panic>
  803011:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803017:	8b 45 08             	mov    0x8(%ebp),%eax
  80301a:	89 10                	mov    %edx,(%eax)
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	8b 00                	mov    (%eax),%eax
  803021:	85 c0                	test   %eax,%eax
  803023:	74 0d                	je     803032 <insert_sorted_with_merge_freeList+0x193>
  803025:	a1 38 51 80 00       	mov    0x805138,%eax
  80302a:	8b 55 08             	mov    0x8(%ebp),%edx
  80302d:	89 50 04             	mov    %edx,0x4(%eax)
  803030:	eb 08                	jmp    80303a <insert_sorted_with_merge_freeList+0x19b>
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80303a:	8b 45 08             	mov    0x8(%ebp),%eax
  80303d:	a3 38 51 80 00       	mov    %eax,0x805138
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80304c:	a1 44 51 80 00       	mov    0x805144,%eax
  803051:	40                   	inc    %eax
  803052:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803057:	e9 9c 05 00 00       	jmp    8035f8 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	8b 50 08             	mov    0x8(%eax),%edx
  803062:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803065:	8b 40 08             	mov    0x8(%eax),%eax
  803068:	39 c2                	cmp    %eax,%edx
  80306a:	0f 86 16 01 00 00    	jbe    803186 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803070:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803073:	8b 50 08             	mov    0x8(%eax),%edx
  803076:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803079:	8b 40 0c             	mov    0xc(%eax),%eax
  80307c:	01 c2                	add    %eax,%edx
  80307e:	8b 45 08             	mov    0x8(%ebp),%eax
  803081:	8b 40 08             	mov    0x8(%eax),%eax
  803084:	39 c2                	cmp    %eax,%edx
  803086:	0f 85 92 00 00 00    	jne    80311e <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  80308c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80308f:	8b 50 0c             	mov    0xc(%eax),%edx
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	8b 40 0c             	mov    0xc(%eax),%eax
  803098:	01 c2                	add    %eax,%edx
  80309a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  8030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8030aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ad:	8b 50 08             	mov    0x8(%eax),%edx
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8030b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ba:	75 17                	jne    8030d3 <insert_sorted_with_merge_freeList+0x234>
  8030bc:	83 ec 04             	sub    $0x4,%esp
  8030bf:	68 30 41 80 00       	push   $0x804130
  8030c4:	68 31 01 00 00       	push   $0x131
  8030c9:	68 53 41 80 00       	push   $0x804153
  8030ce:	e8 20 d8 ff ff       	call   8008f3 <_panic>
  8030d3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	89 10                	mov    %edx,(%eax)
  8030de:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e1:	8b 00                	mov    (%eax),%eax
  8030e3:	85 c0                	test   %eax,%eax
  8030e5:	74 0d                	je     8030f4 <insert_sorted_with_merge_freeList+0x255>
  8030e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ef:	89 50 04             	mov    %edx,0x4(%eax)
  8030f2:	eb 08                	jmp    8030fc <insert_sorted_with_merge_freeList+0x25d>
  8030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ff:	a3 48 51 80 00       	mov    %eax,0x805148
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310e:	a1 54 51 80 00       	mov    0x805154,%eax
  803113:	40                   	inc    %eax
  803114:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803119:	e9 da 04 00 00       	jmp    8035f8 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  80311e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803122:	75 17                	jne    80313b <insert_sorted_with_merge_freeList+0x29c>
  803124:	83 ec 04             	sub    $0x4,%esp
  803127:	68 d8 41 80 00       	push   $0x8041d8
  80312c:	68 37 01 00 00       	push   $0x137
  803131:	68 53 41 80 00       	push   $0x804153
  803136:	e8 b8 d7 ff ff       	call   8008f3 <_panic>
  80313b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803141:	8b 45 08             	mov    0x8(%ebp),%eax
  803144:	89 50 04             	mov    %edx,0x4(%eax)
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	8b 40 04             	mov    0x4(%eax),%eax
  80314d:	85 c0                	test   %eax,%eax
  80314f:	74 0c                	je     80315d <insert_sorted_with_merge_freeList+0x2be>
  803151:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803156:	8b 55 08             	mov    0x8(%ebp),%edx
  803159:	89 10                	mov    %edx,(%eax)
  80315b:	eb 08                	jmp    803165 <insert_sorted_with_merge_freeList+0x2c6>
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	a3 38 51 80 00       	mov    %eax,0x805138
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80316d:	8b 45 08             	mov    0x8(%ebp),%eax
  803170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803176:	a1 44 51 80 00       	mov    0x805144,%eax
  80317b:	40                   	inc    %eax
  80317c:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803181:	e9 72 04 00 00       	jmp    8035f8 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803186:	a1 38 51 80 00       	mov    0x805138,%eax
  80318b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80318e:	e9 35 04 00 00       	jmp    8035c8 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  803193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803196:	8b 00                	mov    (%eax),%eax
  803198:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	8b 50 08             	mov    0x8(%eax),%edx
  8031a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a4:	8b 40 08             	mov    0x8(%eax),%eax
  8031a7:	39 c2                	cmp    %eax,%edx
  8031a9:	0f 86 11 04 00 00    	jbe    8035c0 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  8031af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b2:	8b 50 08             	mov    0x8(%eax),%edx
  8031b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031bb:	01 c2                	add    %eax,%edx
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	8b 40 08             	mov    0x8(%eax),%eax
  8031c3:	39 c2                	cmp    %eax,%edx
  8031c5:	0f 83 8b 00 00 00    	jae    803256 <insert_sorted_with_merge_freeList+0x3b7>
  8031cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ce:	8b 50 08             	mov    0x8(%eax),%edx
  8031d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d7:	01 c2                	add    %eax,%edx
  8031d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031dc:	8b 40 08             	mov    0x8(%eax),%eax
  8031df:	39 c2                	cmp    %eax,%edx
  8031e1:	73 73                	jae    803256 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  8031e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031e7:	74 06                	je     8031ef <insert_sorted_with_merge_freeList+0x350>
  8031e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ed:	75 17                	jne    803206 <insert_sorted_with_merge_freeList+0x367>
  8031ef:	83 ec 04             	sub    $0x4,%esp
  8031f2:	68 a4 41 80 00       	push   $0x8041a4
  8031f7:	68 48 01 00 00       	push   $0x148
  8031fc:	68 53 41 80 00       	push   $0x804153
  803201:	e8 ed d6 ff ff       	call   8008f3 <_panic>
  803206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803209:	8b 10                	mov    (%eax),%edx
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	89 10                	mov    %edx,(%eax)
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 0b                	je     803224 <insert_sorted_with_merge_freeList+0x385>
  803219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321c:	8b 00                	mov    (%eax),%eax
  80321e:	8b 55 08             	mov    0x8(%ebp),%edx
  803221:	89 50 04             	mov    %edx,0x4(%eax)
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	8b 55 08             	mov    0x8(%ebp),%edx
  80322a:	89 10                	mov    %edx,(%eax)
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803232:	89 50 04             	mov    %edx,0x4(%eax)
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	8b 00                	mov    (%eax),%eax
  80323a:	85 c0                	test   %eax,%eax
  80323c:	75 08                	jne    803246 <insert_sorted_with_merge_freeList+0x3a7>
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803246:	a1 44 51 80 00       	mov    0x805144,%eax
  80324b:	40                   	inc    %eax
  80324c:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  803251:	e9 a2 03 00 00       	jmp    8035f8 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803256:	8b 45 08             	mov    0x8(%ebp),%eax
  803259:	8b 50 08             	mov    0x8(%eax),%edx
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	8b 40 0c             	mov    0xc(%eax),%eax
  803262:	01 c2                	add    %eax,%edx
  803264:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803267:	8b 40 08             	mov    0x8(%eax),%eax
  80326a:	39 c2                	cmp    %eax,%edx
  80326c:	0f 83 ae 00 00 00    	jae    803320 <insert_sorted_with_merge_freeList+0x481>
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	8b 50 08             	mov    0x8(%eax),%edx
  803278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327b:	8b 48 08             	mov    0x8(%eax),%ecx
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	8b 40 0c             	mov    0xc(%eax),%eax
  803284:	01 c8                	add    %ecx,%eax
  803286:	39 c2                	cmp    %eax,%edx
  803288:	0f 85 92 00 00 00    	jne    803320 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  80328e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803291:	8b 50 0c             	mov    0xc(%eax),%edx
  803294:	8b 45 08             	mov    0x8(%ebp),%eax
  803297:	8b 40 0c             	mov    0xc(%eax),%eax
  80329a:	01 c2                	add    %eax,%edx
  80329c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80329f:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  8032a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	8b 50 08             	mov    0x8(%eax),%edx
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8032b8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032bc:	75 17                	jne    8032d5 <insert_sorted_with_merge_freeList+0x436>
  8032be:	83 ec 04             	sub    $0x4,%esp
  8032c1:	68 30 41 80 00       	push   $0x804130
  8032c6:	68 51 01 00 00       	push   $0x151
  8032cb:	68 53 41 80 00       	push   $0x804153
  8032d0:	e8 1e d6 ff ff       	call   8008f3 <_panic>
  8032d5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	89 10                	mov    %edx,(%eax)
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	8b 00                	mov    (%eax),%eax
  8032e5:	85 c0                	test   %eax,%eax
  8032e7:	74 0d                	je     8032f6 <insert_sorted_with_merge_freeList+0x457>
  8032e9:	a1 48 51 80 00       	mov    0x805148,%eax
  8032ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f1:	89 50 04             	mov    %edx,0x4(%eax)
  8032f4:	eb 08                	jmp    8032fe <insert_sorted_with_merge_freeList+0x45f>
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	a3 48 51 80 00       	mov    %eax,0x805148
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803310:	a1 54 51 80 00       	mov    0x805154,%eax
  803315:	40                   	inc    %eax
  803316:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  80331b:	e9 d8 02 00 00       	jmp    8035f8 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  803320:	8b 45 08             	mov    0x8(%ebp),%eax
  803323:	8b 50 08             	mov    0x8(%eax),%edx
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	8b 40 0c             	mov    0xc(%eax),%eax
  80332c:	01 c2                	add    %eax,%edx
  80332e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803331:	8b 40 08             	mov    0x8(%eax),%eax
  803334:	39 c2                	cmp    %eax,%edx
  803336:	0f 85 ba 00 00 00    	jne    8033f6 <insert_sorted_with_merge_freeList+0x557>
  80333c:	8b 45 08             	mov    0x8(%ebp),%eax
  80333f:	8b 50 08             	mov    0x8(%eax),%edx
  803342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803345:	8b 48 08             	mov    0x8(%eax),%ecx
  803348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334b:	8b 40 0c             	mov    0xc(%eax),%eax
  80334e:	01 c8                	add    %ecx,%eax
  803350:	39 c2                	cmp    %eax,%edx
  803352:	0f 86 9e 00 00 00    	jbe    8033f6 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803358:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80335b:	8b 50 0c             	mov    0xc(%eax),%edx
  80335e:	8b 45 08             	mov    0x8(%ebp),%eax
  803361:	8b 40 0c             	mov    0xc(%eax),%eax
  803364:	01 c2                	add    %eax,%edx
  803366:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803369:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  80336c:	8b 45 08             	mov    0x8(%ebp),%eax
  80336f:	8b 50 08             	mov    0x8(%eax),%edx
  803372:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803375:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803378:	8b 45 08             	mov    0x8(%ebp),%eax
  80337b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803382:	8b 45 08             	mov    0x8(%ebp),%eax
  803385:	8b 50 08             	mov    0x8(%eax),%edx
  803388:	8b 45 08             	mov    0x8(%ebp),%eax
  80338b:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80338e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803392:	75 17                	jne    8033ab <insert_sorted_with_merge_freeList+0x50c>
  803394:	83 ec 04             	sub    $0x4,%esp
  803397:	68 30 41 80 00       	push   $0x804130
  80339c:	68 5b 01 00 00       	push   $0x15b
  8033a1:	68 53 41 80 00       	push   $0x804153
  8033a6:	e8 48 d5 ff ff       	call   8008f3 <_panic>
  8033ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	89 10                	mov    %edx,(%eax)
  8033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b9:	8b 00                	mov    (%eax),%eax
  8033bb:	85 c0                	test   %eax,%eax
  8033bd:	74 0d                	je     8033cc <insert_sorted_with_merge_freeList+0x52d>
  8033bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8033c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ca:	eb 08                	jmp    8033d4 <insert_sorted_with_merge_freeList+0x535>
  8033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8033eb:	40                   	inc    %eax
  8033ec:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8033f1:	e9 02 02 00 00       	jmp    8035f8 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f9:	8b 50 08             	mov    0x8(%eax),%edx
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	8b 40 0c             	mov    0xc(%eax),%eax
  803402:	01 c2                	add    %eax,%edx
  803404:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803407:	8b 40 08             	mov    0x8(%eax),%eax
  80340a:	39 c2                	cmp    %eax,%edx
  80340c:	0f 85 ae 01 00 00    	jne    8035c0 <insert_sorted_with_merge_freeList+0x721>
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	8b 50 08             	mov    0x8(%eax),%edx
  803418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341b:	8b 48 08             	mov    0x8(%eax),%ecx
  80341e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803421:	8b 40 0c             	mov    0xc(%eax),%eax
  803424:	01 c8                	add    %ecx,%eax
  803426:	39 c2                	cmp    %eax,%edx
  803428:	0f 85 92 01 00 00    	jne    8035c0 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	8b 50 0c             	mov    0xc(%eax),%edx
  803434:	8b 45 08             	mov    0x8(%ebp),%eax
  803437:	8b 40 0c             	mov    0xc(%eax),%eax
  80343a:	01 c2                	add    %eax,%edx
  80343c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80343f:	8b 40 0c             	mov    0xc(%eax),%eax
  803442:	01 c2                	add    %eax,%edx
  803444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803447:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  80344a:	8b 45 08             	mov    0x8(%ebp),%eax
  80344d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803454:	8b 45 08             	mov    0x8(%ebp),%eax
  803457:	8b 50 08             	mov    0x8(%eax),%edx
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803460:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803463:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80346a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80346d:	8b 50 08             	mov    0x8(%eax),%edx
  803470:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803473:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803476:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80347a:	75 17                	jne    803493 <insert_sorted_with_merge_freeList+0x5f4>
  80347c:	83 ec 04             	sub    $0x4,%esp
  80347f:	68 fb 41 80 00       	push   $0x8041fb
  803484:	68 63 01 00 00       	push   $0x163
  803489:	68 53 41 80 00       	push   $0x804153
  80348e:	e8 60 d4 ff ff       	call   8008f3 <_panic>
  803493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803496:	8b 00                	mov    (%eax),%eax
  803498:	85 c0                	test   %eax,%eax
  80349a:	74 10                	je     8034ac <insert_sorted_with_merge_freeList+0x60d>
  80349c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80349f:	8b 00                	mov    (%eax),%eax
  8034a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034a4:	8b 52 04             	mov    0x4(%edx),%edx
  8034a7:	89 50 04             	mov    %edx,0x4(%eax)
  8034aa:	eb 0b                	jmp    8034b7 <insert_sorted_with_merge_freeList+0x618>
  8034ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034af:	8b 40 04             	mov    0x4(%eax),%eax
  8034b2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034ba:	8b 40 04             	mov    0x4(%eax),%eax
  8034bd:	85 c0                	test   %eax,%eax
  8034bf:	74 0f                	je     8034d0 <insert_sorted_with_merge_freeList+0x631>
  8034c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034c4:	8b 40 04             	mov    0x4(%eax),%eax
  8034c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8034ca:	8b 12                	mov    (%edx),%edx
  8034cc:	89 10                	mov    %edx,(%eax)
  8034ce:	eb 0a                	jmp    8034da <insert_sorted_with_merge_freeList+0x63b>
  8034d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034d3:	8b 00                	mov    (%eax),%eax
  8034d5:	a3 38 51 80 00       	mov    %eax,0x805138
  8034da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8034e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ed:	a1 44 51 80 00       	mov    0x805144,%eax
  8034f2:	48                   	dec    %eax
  8034f3:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8034f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8034fc:	75 17                	jne    803515 <insert_sorted_with_merge_freeList+0x676>
  8034fe:	83 ec 04             	sub    $0x4,%esp
  803501:	68 30 41 80 00       	push   $0x804130
  803506:	68 64 01 00 00       	push   $0x164
  80350b:	68 53 41 80 00       	push   $0x804153
  803510:	e8 de d3 ff ff       	call   8008f3 <_panic>
  803515:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80351b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351e:	89 10                	mov    %edx,(%eax)
  803520:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803523:	8b 00                	mov    (%eax),%eax
  803525:	85 c0                	test   %eax,%eax
  803527:	74 0d                	je     803536 <insert_sorted_with_merge_freeList+0x697>
  803529:	a1 48 51 80 00       	mov    0x805148,%eax
  80352e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803531:	89 50 04             	mov    %edx,0x4(%eax)
  803534:	eb 08                	jmp    80353e <insert_sorted_with_merge_freeList+0x69f>
  803536:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803539:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80353e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803541:	a3 48 51 80 00       	mov    %eax,0x805148
  803546:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803549:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803550:	a1 54 51 80 00       	mov    0x805154,%eax
  803555:	40                   	inc    %eax
  803556:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80355b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80355f:	75 17                	jne    803578 <insert_sorted_with_merge_freeList+0x6d9>
  803561:	83 ec 04             	sub    $0x4,%esp
  803564:	68 30 41 80 00       	push   $0x804130
  803569:	68 65 01 00 00       	push   $0x165
  80356e:	68 53 41 80 00       	push   $0x804153
  803573:	e8 7b d3 ff ff       	call   8008f3 <_panic>
  803578:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	89 10                	mov    %edx,(%eax)
  803583:	8b 45 08             	mov    0x8(%ebp),%eax
  803586:	8b 00                	mov    (%eax),%eax
  803588:	85 c0                	test   %eax,%eax
  80358a:	74 0d                	je     803599 <insert_sorted_with_merge_freeList+0x6fa>
  80358c:	a1 48 51 80 00       	mov    0x805148,%eax
  803591:	8b 55 08             	mov    0x8(%ebp),%edx
  803594:	89 50 04             	mov    %edx,0x4(%eax)
  803597:	eb 08                	jmp    8035a1 <insert_sorted_with_merge_freeList+0x702>
  803599:	8b 45 08             	mov    0x8(%ebp),%eax
  80359c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a4:	a3 48 51 80 00       	mov    %eax,0x805148
  8035a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035b3:	a1 54 51 80 00       	mov    0x805154,%eax
  8035b8:	40                   	inc    %eax
  8035b9:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8035be:	eb 38                	jmp    8035f8 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8035c0:	a1 40 51 80 00       	mov    0x805140,%eax
  8035c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8035c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035cc:	74 07                	je     8035d5 <insert_sorted_with_merge_freeList+0x736>
  8035ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d1:	8b 00                	mov    (%eax),%eax
  8035d3:	eb 05                	jmp    8035da <insert_sorted_with_merge_freeList+0x73b>
  8035d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8035da:	a3 40 51 80 00       	mov    %eax,0x805140
  8035df:	a1 40 51 80 00       	mov    0x805140,%eax
  8035e4:	85 c0                	test   %eax,%eax
  8035e6:	0f 85 a7 fb ff ff    	jne    803193 <insert_sorted_with_merge_freeList+0x2f4>
  8035ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035f0:	0f 85 9d fb ff ff    	jne    803193 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8035f6:	eb 00                	jmp    8035f8 <insert_sorted_with_merge_freeList+0x759>
  8035f8:	90                   	nop
  8035f9:	c9                   	leave  
  8035fa:	c3                   	ret    
  8035fb:	90                   	nop

008035fc <__udivdi3>:
  8035fc:	55                   	push   %ebp
  8035fd:	57                   	push   %edi
  8035fe:	56                   	push   %esi
  8035ff:	53                   	push   %ebx
  803600:	83 ec 1c             	sub    $0x1c,%esp
  803603:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803607:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80360b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80360f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803613:	89 ca                	mov    %ecx,%edx
  803615:	89 f8                	mov    %edi,%eax
  803617:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80361b:	85 f6                	test   %esi,%esi
  80361d:	75 2d                	jne    80364c <__udivdi3+0x50>
  80361f:	39 cf                	cmp    %ecx,%edi
  803621:	77 65                	ja     803688 <__udivdi3+0x8c>
  803623:	89 fd                	mov    %edi,%ebp
  803625:	85 ff                	test   %edi,%edi
  803627:	75 0b                	jne    803634 <__udivdi3+0x38>
  803629:	b8 01 00 00 00       	mov    $0x1,%eax
  80362e:	31 d2                	xor    %edx,%edx
  803630:	f7 f7                	div    %edi
  803632:	89 c5                	mov    %eax,%ebp
  803634:	31 d2                	xor    %edx,%edx
  803636:	89 c8                	mov    %ecx,%eax
  803638:	f7 f5                	div    %ebp
  80363a:	89 c1                	mov    %eax,%ecx
  80363c:	89 d8                	mov    %ebx,%eax
  80363e:	f7 f5                	div    %ebp
  803640:	89 cf                	mov    %ecx,%edi
  803642:	89 fa                	mov    %edi,%edx
  803644:	83 c4 1c             	add    $0x1c,%esp
  803647:	5b                   	pop    %ebx
  803648:	5e                   	pop    %esi
  803649:	5f                   	pop    %edi
  80364a:	5d                   	pop    %ebp
  80364b:	c3                   	ret    
  80364c:	39 ce                	cmp    %ecx,%esi
  80364e:	77 28                	ja     803678 <__udivdi3+0x7c>
  803650:	0f bd fe             	bsr    %esi,%edi
  803653:	83 f7 1f             	xor    $0x1f,%edi
  803656:	75 40                	jne    803698 <__udivdi3+0x9c>
  803658:	39 ce                	cmp    %ecx,%esi
  80365a:	72 0a                	jb     803666 <__udivdi3+0x6a>
  80365c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803660:	0f 87 9e 00 00 00    	ja     803704 <__udivdi3+0x108>
  803666:	b8 01 00 00 00       	mov    $0x1,%eax
  80366b:	89 fa                	mov    %edi,%edx
  80366d:	83 c4 1c             	add    $0x1c,%esp
  803670:	5b                   	pop    %ebx
  803671:	5e                   	pop    %esi
  803672:	5f                   	pop    %edi
  803673:	5d                   	pop    %ebp
  803674:	c3                   	ret    
  803675:	8d 76 00             	lea    0x0(%esi),%esi
  803678:	31 ff                	xor    %edi,%edi
  80367a:	31 c0                	xor    %eax,%eax
  80367c:	89 fa                	mov    %edi,%edx
  80367e:	83 c4 1c             	add    $0x1c,%esp
  803681:	5b                   	pop    %ebx
  803682:	5e                   	pop    %esi
  803683:	5f                   	pop    %edi
  803684:	5d                   	pop    %ebp
  803685:	c3                   	ret    
  803686:	66 90                	xchg   %ax,%ax
  803688:	89 d8                	mov    %ebx,%eax
  80368a:	f7 f7                	div    %edi
  80368c:	31 ff                	xor    %edi,%edi
  80368e:	89 fa                	mov    %edi,%edx
  803690:	83 c4 1c             	add    $0x1c,%esp
  803693:	5b                   	pop    %ebx
  803694:	5e                   	pop    %esi
  803695:	5f                   	pop    %edi
  803696:	5d                   	pop    %ebp
  803697:	c3                   	ret    
  803698:	bd 20 00 00 00       	mov    $0x20,%ebp
  80369d:	89 eb                	mov    %ebp,%ebx
  80369f:	29 fb                	sub    %edi,%ebx
  8036a1:	89 f9                	mov    %edi,%ecx
  8036a3:	d3 e6                	shl    %cl,%esi
  8036a5:	89 c5                	mov    %eax,%ebp
  8036a7:	88 d9                	mov    %bl,%cl
  8036a9:	d3 ed                	shr    %cl,%ebp
  8036ab:	89 e9                	mov    %ebp,%ecx
  8036ad:	09 f1                	or     %esi,%ecx
  8036af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8036b3:	89 f9                	mov    %edi,%ecx
  8036b5:	d3 e0                	shl    %cl,%eax
  8036b7:	89 c5                	mov    %eax,%ebp
  8036b9:	89 d6                	mov    %edx,%esi
  8036bb:	88 d9                	mov    %bl,%cl
  8036bd:	d3 ee                	shr    %cl,%esi
  8036bf:	89 f9                	mov    %edi,%ecx
  8036c1:	d3 e2                	shl    %cl,%edx
  8036c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036c7:	88 d9                	mov    %bl,%cl
  8036c9:	d3 e8                	shr    %cl,%eax
  8036cb:	09 c2                	or     %eax,%edx
  8036cd:	89 d0                	mov    %edx,%eax
  8036cf:	89 f2                	mov    %esi,%edx
  8036d1:	f7 74 24 0c          	divl   0xc(%esp)
  8036d5:	89 d6                	mov    %edx,%esi
  8036d7:	89 c3                	mov    %eax,%ebx
  8036d9:	f7 e5                	mul    %ebp
  8036db:	39 d6                	cmp    %edx,%esi
  8036dd:	72 19                	jb     8036f8 <__udivdi3+0xfc>
  8036df:	74 0b                	je     8036ec <__udivdi3+0xf0>
  8036e1:	89 d8                	mov    %ebx,%eax
  8036e3:	31 ff                	xor    %edi,%edi
  8036e5:	e9 58 ff ff ff       	jmp    803642 <__udivdi3+0x46>
  8036ea:	66 90                	xchg   %ax,%ax
  8036ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8036f0:	89 f9                	mov    %edi,%ecx
  8036f2:	d3 e2                	shl    %cl,%edx
  8036f4:	39 c2                	cmp    %eax,%edx
  8036f6:	73 e9                	jae    8036e1 <__udivdi3+0xe5>
  8036f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8036fb:	31 ff                	xor    %edi,%edi
  8036fd:	e9 40 ff ff ff       	jmp    803642 <__udivdi3+0x46>
  803702:	66 90                	xchg   %ax,%ax
  803704:	31 c0                	xor    %eax,%eax
  803706:	e9 37 ff ff ff       	jmp    803642 <__udivdi3+0x46>
  80370b:	90                   	nop

0080370c <__umoddi3>:
  80370c:	55                   	push   %ebp
  80370d:	57                   	push   %edi
  80370e:	56                   	push   %esi
  80370f:	53                   	push   %ebx
  803710:	83 ec 1c             	sub    $0x1c,%esp
  803713:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803717:	8b 74 24 34          	mov    0x34(%esp),%esi
  80371b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80371f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803723:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803727:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80372b:	89 f3                	mov    %esi,%ebx
  80372d:	89 fa                	mov    %edi,%edx
  80372f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803733:	89 34 24             	mov    %esi,(%esp)
  803736:	85 c0                	test   %eax,%eax
  803738:	75 1a                	jne    803754 <__umoddi3+0x48>
  80373a:	39 f7                	cmp    %esi,%edi
  80373c:	0f 86 a2 00 00 00    	jbe    8037e4 <__umoddi3+0xd8>
  803742:	89 c8                	mov    %ecx,%eax
  803744:	89 f2                	mov    %esi,%edx
  803746:	f7 f7                	div    %edi
  803748:	89 d0                	mov    %edx,%eax
  80374a:	31 d2                	xor    %edx,%edx
  80374c:	83 c4 1c             	add    $0x1c,%esp
  80374f:	5b                   	pop    %ebx
  803750:	5e                   	pop    %esi
  803751:	5f                   	pop    %edi
  803752:	5d                   	pop    %ebp
  803753:	c3                   	ret    
  803754:	39 f0                	cmp    %esi,%eax
  803756:	0f 87 ac 00 00 00    	ja     803808 <__umoddi3+0xfc>
  80375c:	0f bd e8             	bsr    %eax,%ebp
  80375f:	83 f5 1f             	xor    $0x1f,%ebp
  803762:	0f 84 ac 00 00 00    	je     803814 <__umoddi3+0x108>
  803768:	bf 20 00 00 00       	mov    $0x20,%edi
  80376d:	29 ef                	sub    %ebp,%edi
  80376f:	89 fe                	mov    %edi,%esi
  803771:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803775:	89 e9                	mov    %ebp,%ecx
  803777:	d3 e0                	shl    %cl,%eax
  803779:	89 d7                	mov    %edx,%edi
  80377b:	89 f1                	mov    %esi,%ecx
  80377d:	d3 ef                	shr    %cl,%edi
  80377f:	09 c7                	or     %eax,%edi
  803781:	89 e9                	mov    %ebp,%ecx
  803783:	d3 e2                	shl    %cl,%edx
  803785:	89 14 24             	mov    %edx,(%esp)
  803788:	89 d8                	mov    %ebx,%eax
  80378a:	d3 e0                	shl    %cl,%eax
  80378c:	89 c2                	mov    %eax,%edx
  80378e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803792:	d3 e0                	shl    %cl,%eax
  803794:	89 44 24 04          	mov    %eax,0x4(%esp)
  803798:	8b 44 24 08          	mov    0x8(%esp),%eax
  80379c:	89 f1                	mov    %esi,%ecx
  80379e:	d3 e8                	shr    %cl,%eax
  8037a0:	09 d0                	or     %edx,%eax
  8037a2:	d3 eb                	shr    %cl,%ebx
  8037a4:	89 da                	mov    %ebx,%edx
  8037a6:	f7 f7                	div    %edi
  8037a8:	89 d3                	mov    %edx,%ebx
  8037aa:	f7 24 24             	mull   (%esp)
  8037ad:	89 c6                	mov    %eax,%esi
  8037af:	89 d1                	mov    %edx,%ecx
  8037b1:	39 d3                	cmp    %edx,%ebx
  8037b3:	0f 82 87 00 00 00    	jb     803840 <__umoddi3+0x134>
  8037b9:	0f 84 91 00 00 00    	je     803850 <__umoddi3+0x144>
  8037bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8037c3:	29 f2                	sub    %esi,%edx
  8037c5:	19 cb                	sbb    %ecx,%ebx
  8037c7:	89 d8                	mov    %ebx,%eax
  8037c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8037cd:	d3 e0                	shl    %cl,%eax
  8037cf:	89 e9                	mov    %ebp,%ecx
  8037d1:	d3 ea                	shr    %cl,%edx
  8037d3:	09 d0                	or     %edx,%eax
  8037d5:	89 e9                	mov    %ebp,%ecx
  8037d7:	d3 eb                	shr    %cl,%ebx
  8037d9:	89 da                	mov    %ebx,%edx
  8037db:	83 c4 1c             	add    $0x1c,%esp
  8037de:	5b                   	pop    %ebx
  8037df:	5e                   	pop    %esi
  8037e0:	5f                   	pop    %edi
  8037e1:	5d                   	pop    %ebp
  8037e2:	c3                   	ret    
  8037e3:	90                   	nop
  8037e4:	89 fd                	mov    %edi,%ebp
  8037e6:	85 ff                	test   %edi,%edi
  8037e8:	75 0b                	jne    8037f5 <__umoddi3+0xe9>
  8037ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8037ef:	31 d2                	xor    %edx,%edx
  8037f1:	f7 f7                	div    %edi
  8037f3:	89 c5                	mov    %eax,%ebp
  8037f5:	89 f0                	mov    %esi,%eax
  8037f7:	31 d2                	xor    %edx,%edx
  8037f9:	f7 f5                	div    %ebp
  8037fb:	89 c8                	mov    %ecx,%eax
  8037fd:	f7 f5                	div    %ebp
  8037ff:	89 d0                	mov    %edx,%eax
  803801:	e9 44 ff ff ff       	jmp    80374a <__umoddi3+0x3e>
  803806:	66 90                	xchg   %ax,%ax
  803808:	89 c8                	mov    %ecx,%eax
  80380a:	89 f2                	mov    %esi,%edx
  80380c:	83 c4 1c             	add    $0x1c,%esp
  80380f:	5b                   	pop    %ebx
  803810:	5e                   	pop    %esi
  803811:	5f                   	pop    %edi
  803812:	5d                   	pop    %ebp
  803813:	c3                   	ret    
  803814:	3b 04 24             	cmp    (%esp),%eax
  803817:	72 06                	jb     80381f <__umoddi3+0x113>
  803819:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80381d:	77 0f                	ja     80382e <__umoddi3+0x122>
  80381f:	89 f2                	mov    %esi,%edx
  803821:	29 f9                	sub    %edi,%ecx
  803823:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803827:	89 14 24             	mov    %edx,(%esp)
  80382a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80382e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803832:	8b 14 24             	mov    (%esp),%edx
  803835:	83 c4 1c             	add    $0x1c,%esp
  803838:	5b                   	pop    %ebx
  803839:	5e                   	pop    %esi
  80383a:	5f                   	pop    %edi
  80383b:	5d                   	pop    %ebp
  80383c:	c3                   	ret    
  80383d:	8d 76 00             	lea    0x0(%esi),%esi
  803840:	2b 04 24             	sub    (%esp),%eax
  803843:	19 fa                	sbb    %edi,%edx
  803845:	89 d1                	mov    %edx,%ecx
  803847:	89 c6                	mov    %eax,%esi
  803849:	e9 71 ff ff ff       	jmp    8037bf <__umoddi3+0xb3>
  80384e:	66 90                	xchg   %ax,%ax
  803850:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803854:	72 ea                	jb     803840 <__umoddi3+0x134>
  803856:	89 d9                	mov    %ebx,%ecx
  803858:	e9 62 ff ff ff       	jmp    8037bf <__umoddi3+0xb3>
