
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 65 07 00 00       	call   80079b <libmain>
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
  800041:	e8 92 21 00 00       	call   8021d8 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 60 3a 80 00       	push   $0x803a60
  80004e:	e8 38 0b 00 00       	call   800b8b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 62 3a 80 00       	push   $0x803a62
  80005e:	e8 28 0b 00 00       	call   800b8b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 78 3a 80 00       	push   $0x803a78
  80006e:	e8 18 0b 00 00       	call   800b8b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 62 3a 80 00       	push   $0x803a62
  80007e:	e8 08 0b 00 00       	call   800b8b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 60 3a 80 00       	push   $0x803a60
  80008e:	e8 f8 0a 00 00       	call   800b8b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 90 3a 80 00       	push   $0x803a90
  8000a5:	e8 63 11 00 00       	call   80120d <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 b3 16 00 00       	call   801773 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 e8 1b 00 00       	call   801cbd <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 b0 3a 80 00       	push   $0x803ab0
  8000e3:	e8 a3 0a 00 00       	call   800b8b <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 d2 3a 80 00       	push   $0x803ad2
  8000f3:	e8 93 0a 00 00       	call   800b8b <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 e0 3a 80 00       	push   $0x803ae0
  800103:	e8 83 0a 00 00       	call   800b8b <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 ef 3a 80 00       	push   $0x803aef
  800113:	e8 73 0a 00 00       	call   800b8b <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 ff 3a 80 00       	push   $0x803aff
  800123:	e8 63 0a 00 00       	call   800b8b <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 13 06 00 00       	call   800743 <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
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
  800162:	e8 8b 20 00 00       	call   8021f2 <sys_enable_interrupt>

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 fc 1f 00 00       	call   8021d8 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 08 3b 80 00       	push   $0x803b08
  8001e4:	e8 a2 09 00 00       	call   800b8b <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 01 20 00 00       	call   8021f2 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 3c 3b 80 00       	push   $0x803b3c
  800213:	6a 4a                	push   $0x4a
  800215:	68 5e 3b 80 00       	push   $0x803b5e
  80021a:	e8 b8 06 00 00       	call   8008d7 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 b4 1f 00 00       	call   8021d8 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 78 3b 80 00       	push   $0x803b78
  80022c:	e8 5a 09 00 00       	call   800b8b <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 ac 3b 80 00       	push   $0x803bac
  80023c:	e8 4a 09 00 00       	call   800b8b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 e0 3b 80 00       	push   $0x803be0
  80024c:	e8 3a 09 00 00       	call   800b8b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 99 1f 00 00       	call   8021f2 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 7a 1f 00 00       	call   8021d8 <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 12 3c 80 00       	push   $0x803c12
  80026c:	e8 1a 09 00 00       	call   800b8b <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 ca 04 00 00       	call   800743 <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 3b 1f 00 00       	call   8021f2 <sys_enable_interrupt>

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
  800446:	68 60 3a 80 00       	push   $0x803a60
  80044b:	e8 3b 07 00 00       	call   800b8b <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 30 3c 80 00       	push   $0x803c30
  80046d:	e8 19 07 00 00       	call   800b8b <cprintf>
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
  800496:	68 35 3c 80 00       	push   $0x803c35
  80049b:	e8 eb 06 00 00       	call   800b8b <cprintf>
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
  80053c:	e8 7c 17 00 00       	call   801cbd <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 67 17 00 00       	call   801cbd <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

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

	//	int Left[5000] ;
	//	int Right[5000] ;

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

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 f8 1a 00 00       	call   80220c <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800720:	e8 b3 1a 00 00       	call   8021d8 <sys_disable_interrupt>
	char c = ch;
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80072b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	50                   	push   %eax
  800733:	e8 d4 1a 00 00       	call   80220c <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 b2 1a 00 00       	call   8021f2 <sys_enable_interrupt>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <getchar>:

int
getchar(void)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800750:	eb 08                	jmp    80075a <getchar+0x17>
	{
		c = sys_cgetc();
  800752:	e8 fc 18 00 00       	call   802053 <sys_cgetc>
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80075a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80075e:	74 f2                	je     800752 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800760:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <atomic_getchar>:

int
atomic_getchar(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80076b:	e8 68 1a 00 00       	call   8021d8 <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 d5 18 00 00       	call   802053 <sys_cgetc>
  80077e:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800785:	74 f2                	je     800779 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800787:	e8 66 1a 00 00       	call   8021f2 <sys_enable_interrupt>
	return c;
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <iscons>:

int iscons(int fdnum)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800794:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007a1:	e8 25 1c 00 00       	call   8023cb <sys_getenvindex>
  8007a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	c1 e0 03             	shl    $0x3,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	01 c0                	add    %eax,%eax
  8007b5:	01 d0                	add    %edx,%eax
  8007b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007be:	01 d0                	add    %edx,%eax
  8007c0:	c1 e0 04             	shl    $0x4,%eax
  8007c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007c8:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007cd:	a1 24 50 80 00       	mov    0x805024,%eax
  8007d2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	74 0f                	je     8007eb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8007e1:	05 5c 05 00 00       	add    $0x55c,%eax
  8007e6:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007ef:	7e 0a                	jle    8007fb <libmain+0x60>
		binaryname = argv[0];
  8007f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 2f f8 ff ff       	call   800038 <_main>
  800809:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80080c:	e8 c7 19 00 00       	call   8021d8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	68 54 3c 80 00       	push   $0x803c54
  800819:	e8 6d 03 00 00       	call   800b8b <cprintf>
  80081e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80082c:	a1 24 50 80 00       	mov    0x805024,%eax
  800831:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800837:	83 ec 04             	sub    $0x4,%esp
  80083a:	52                   	push   %edx
  80083b:	50                   	push   %eax
  80083c:	68 7c 3c 80 00       	push   $0x803c7c
  800841:	e8 45 03 00 00       	call   800b8b <cprintf>
  800846:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800849:	a1 24 50 80 00       	mov    0x805024,%eax
  80084e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800854:	a1 24 50 80 00       	mov    0x805024,%eax
  800859:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80085f:	a1 24 50 80 00       	mov    0x805024,%eax
  800864:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80086a:	51                   	push   %ecx
  80086b:	52                   	push   %edx
  80086c:	50                   	push   %eax
  80086d:	68 a4 3c 80 00       	push   $0x803ca4
  800872:	e8 14 03 00 00       	call   800b8b <cprintf>
  800877:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80087a:	a1 24 50 80 00       	mov    0x805024,%eax
  80087f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	50                   	push   %eax
  800889:	68 fc 3c 80 00       	push   $0x803cfc
  80088e:	e8 f8 02 00 00       	call   800b8b <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	68 54 3c 80 00       	push   $0x803c54
  80089e:	e8 e8 02 00 00       	call   800b8b <cprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a6:	e8 47 19 00 00       	call   8021f2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008ab:	e8 19 00 00 00       	call   8008c9 <exit>
}
  8008b0:	90                   	nop
  8008b1:	c9                   	leave  
  8008b2:	c3                   	ret    

008008b3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008b9:	83 ec 0c             	sub    $0xc,%esp
  8008bc:	6a 00                	push   $0x0
  8008be:	e8 d4 1a 00 00       	call   802397 <sys_destroy_env>
  8008c3:	83 c4 10             	add    $0x10,%esp
}
  8008c6:	90                   	nop
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <exit>:

void
exit(void)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008cf:	e8 29 1b 00 00       	call   8023fd <sys_exit_env>
}
  8008d4:	90                   	nop
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    

008008d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008dd:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e0:	83 c0 04             	add    $0x4,%eax
  8008e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008e6:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008eb:	85 c0                	test   %eax,%eax
  8008ed:	74 16                	je     800905 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008ef:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	50                   	push   %eax
  8008f8:	68 10 3d 80 00       	push   $0x803d10
  8008fd:	e8 89 02 00 00       	call   800b8b <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800905:	a1 00 50 80 00       	mov    0x805000,%eax
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	50                   	push   %eax
  800911:	68 15 3d 80 00       	push   $0x803d15
  800916:	e8 70 02 00 00       	call   800b8b <cprintf>
  80091b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80091e:	8b 45 10             	mov    0x10(%ebp),%eax
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 f4             	pushl  -0xc(%ebp)
  800927:	50                   	push   %eax
  800928:	e8 f3 01 00 00       	call   800b20 <vcprintf>
  80092d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	6a 00                	push   $0x0
  800935:	68 31 3d 80 00       	push   $0x803d31
  80093a:	e8 e1 01 00 00       	call   800b20 <vcprintf>
  80093f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800942:	e8 82 ff ff ff       	call   8008c9 <exit>

	// should not return here
	while (1) ;
  800947:	eb fe                	jmp    800947 <_panic+0x70>

00800949 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80094f:	a1 24 50 80 00       	mov    0x805024,%eax
  800954:	8b 50 74             	mov    0x74(%eax),%edx
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	39 c2                	cmp    %eax,%edx
  80095c:	74 14                	je     800972 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 34 3d 80 00       	push   $0x803d34
  800966:	6a 26                	push   $0x26
  800968:	68 80 3d 80 00       	push   $0x803d80
  80096d:	e8 65 ff ff ff       	call   8008d7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800972:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800979:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800980:	e9 c2 00 00 00       	jmp    800a47 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800988:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	01 d0                	add    %edx,%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	85 c0                	test   %eax,%eax
  800998:	75 08                	jne    8009a2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80099a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80099d:	e9 a2 00 00 00       	jmp    800a44 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009b0:	eb 69                	jmp    800a1b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c0:	89 d0                	mov    %edx,%eax
  8009c2:	01 c0                	add    %eax,%eax
  8009c4:	01 d0                	add    %edx,%eax
  8009c6:	c1 e0 03             	shl    $0x3,%eax
  8009c9:	01 c8                	add    %ecx,%eax
  8009cb:	8a 40 04             	mov    0x4(%eax),%al
  8009ce:	84 c0                	test   %al,%al
  8009d0:	75 46                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009e0:	89 d0                	mov    %edx,%eax
  8009e2:	01 c0                	add    %eax,%eax
  8009e4:	01 d0                	add    %edx,%eax
  8009e6:	c1 e0 03             	shl    $0x3,%eax
  8009e9:	01 c8                	add    %ecx,%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009f8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	01 c8                	add    %ecx,%eax
  800a09:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a0b:	39 c2                	cmp    %eax,%edx
  800a0d:	75 09                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a0f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a16:	eb 12                	jmp    800a2a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a18:	ff 45 e8             	incl   -0x18(%ebp)
  800a1b:	a1 24 50 80 00       	mov    0x805024,%eax
  800a20:	8b 50 74             	mov    0x74(%eax),%edx
  800a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a26:	39 c2                	cmp    %eax,%edx
  800a28:	77 88                	ja     8009b2 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a2e:	75 14                	jne    800a44 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a30:	83 ec 04             	sub    $0x4,%esp
  800a33:	68 8c 3d 80 00       	push   $0x803d8c
  800a38:	6a 3a                	push   $0x3a
  800a3a:	68 80 3d 80 00       	push   $0x803d80
  800a3f:	e8 93 fe ff ff       	call   8008d7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a44:	ff 45 f0             	incl   -0x10(%ebp)
  800a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a4d:	0f 8c 32 ff ff ff    	jl     800985 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a5a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a61:	eb 26                	jmp    800a89 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a63:	a1 24 50 80 00       	mov    0x805024,%eax
  800a68:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	01 c0                	add    %eax,%eax
  800a75:	01 d0                	add    %edx,%eax
  800a77:	c1 e0 03             	shl    $0x3,%eax
  800a7a:	01 c8                	add    %ecx,%eax
  800a7c:	8a 40 04             	mov    0x4(%eax),%al
  800a7f:	3c 01                	cmp    $0x1,%al
  800a81:	75 03                	jne    800a86 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a83:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a86:	ff 45 e0             	incl   -0x20(%ebp)
  800a89:	a1 24 50 80 00       	mov    0x805024,%eax
  800a8e:	8b 50 74             	mov    0x74(%eax),%edx
  800a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a94:	39 c2                	cmp    %eax,%edx
  800a96:	77 cb                	ja     800a63 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a9b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a9e:	74 14                	je     800ab4 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 e0 3d 80 00       	push   $0x803de0
  800aa8:	6a 44                	push   $0x44
  800aaa:	68 80 3d 80 00       	push   $0x803d80
  800aaf:	e8 23 fe ff ff       	call   8008d7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ab4:	90                   	nop
  800ab5:	c9                   	leave  
  800ab6:	c3                   	ret    

00800ab7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac0:	8b 00                	mov    (%eax),%eax
  800ac2:	8d 48 01             	lea    0x1(%eax),%ecx
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac8:	89 0a                	mov    %ecx,(%edx)
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	88 d1                	mov    %dl,%cl
  800acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ae0:	75 2c                	jne    800b0e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ae2:	a0 28 50 80 00       	mov    0x805028,%al
  800ae7:	0f b6 c0             	movzbl %al,%eax
  800aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aed:	8b 12                	mov    (%edx),%edx
  800aef:	89 d1                	mov    %edx,%ecx
  800af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af4:	83 c2 08             	add    $0x8,%edx
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	50                   	push   %eax
  800afb:	51                   	push   %ecx
  800afc:	52                   	push   %edx
  800afd:	e8 28 15 00 00       	call   80202a <sys_cputs>
  800b02:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	8b 40 04             	mov    0x4(%eax),%eax
  800b14:	8d 50 01             	lea    0x1(%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b1d:	90                   	nop
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b29:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b30:	00 00 00 
	b.cnt = 0;
  800b33:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b3a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	ff 75 08             	pushl  0x8(%ebp)
  800b43:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	68 b7 0a 80 00       	push   $0x800ab7
  800b4f:	e8 11 02 00 00       	call   800d65 <vprintfmt>
  800b54:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b57:	a0 28 50 80 00       	mov    0x805028,%al
  800b5c:	0f b6 c0             	movzbl %al,%eax
  800b5f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b65:	83 ec 04             	sub    $0x4,%esp
  800b68:	50                   	push   %eax
  800b69:	52                   	push   %edx
  800b6a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b70:	83 c0 08             	add    $0x8,%eax
  800b73:	50                   	push   %eax
  800b74:	e8 b1 14 00 00       	call   80202a <sys_cputs>
  800b79:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b7c:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b83:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <cprintf>:

int cprintf(const char *fmt, ...) {
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b91:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800b98:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba7:	50                   	push   %eax
  800ba8:	e8 73 ff ff ff       	call   800b20 <vcprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bbe:	e8 15 16 00 00       	call   8021d8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bc3:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	50                   	push   %eax
  800bd3:	e8 48 ff ff ff       	call   800b20 <vcprintf>
  800bd8:	83 c4 10             	add    $0x10,%esp
  800bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bde:	e8 0f 16 00 00       	call   8021f2 <sys_enable_interrupt>
	return cnt;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	53                   	push   %ebx
  800bec:	83 ec 14             	sub    $0x14,%esp
  800bef:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bfb:	8b 45 18             	mov    0x18(%ebp),%eax
  800bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800c03:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c06:	77 55                	ja     800c5d <printnum+0x75>
  800c08:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c0b:	72 05                	jb     800c12 <printnum+0x2a>
  800c0d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c10:	77 4b                	ja     800c5d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c12:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c15:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c18:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c20:	52                   	push   %edx
  800c21:	50                   	push   %eax
  800c22:	ff 75 f4             	pushl  -0xc(%ebp)
  800c25:	ff 75 f0             	pushl  -0x10(%ebp)
  800c28:	e8 bb 2b 00 00       	call   8037e8 <__udivdi3>
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	ff 75 20             	pushl  0x20(%ebp)
  800c36:	53                   	push   %ebx
  800c37:	ff 75 18             	pushl  0x18(%ebp)
  800c3a:	52                   	push   %edx
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 a1 ff ff ff       	call   800be8 <printnum>
  800c47:	83 c4 20             	add    $0x20,%esp
  800c4a:	eb 1a                	jmp    800c66 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 20             	pushl  0x20(%ebp)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	ff d0                	call   *%eax
  800c5a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c5d:	ff 4d 1c             	decl   0x1c(%ebp)
  800c60:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c64:	7f e6                	jg     800c4c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c66:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c74:	53                   	push   %ebx
  800c75:	51                   	push   %ecx
  800c76:	52                   	push   %edx
  800c77:	50                   	push   %eax
  800c78:	e8 7b 2c 00 00       	call   8038f8 <__umoddi3>
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	05 54 40 80 00       	add    $0x804054,%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	0f be c0             	movsbl %al,%eax
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	50                   	push   %eax
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	ff d0                	call   *%eax
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ca2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ca6:	7e 1c                	jle    800cc4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	8d 50 08             	lea    0x8(%eax),%edx
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 10                	mov    %edx,(%eax)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8b 00                	mov    (%eax),%eax
  800cba:	83 e8 08             	sub    $0x8,%eax
  800cbd:	8b 50 04             	mov    0x4(%eax),%edx
  800cc0:	8b 00                	mov    (%eax),%eax
  800cc2:	eb 40                	jmp    800d04 <getuint+0x65>
	else if (lflag)
  800cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc8:	74 1e                	je     800ce8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8b 00                	mov    (%eax),%eax
  800ccf:	8d 50 04             	lea    0x4(%eax),%edx
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	89 10                	mov    %edx,(%eax)
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8b 00                	mov    (%eax),%eax
  800cdc:	83 e8 04             	sub    $0x4,%eax
  800cdf:	8b 00                	mov    (%eax),%eax
  800ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce6:	eb 1c                	jmp    800d04 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8b 00                	mov    (%eax),%eax
  800ced:	8d 50 04             	lea    0x4(%eax),%edx
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	89 10                	mov    %edx,(%eax)
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8b 00                	mov    (%eax),%eax
  800cfa:	83 e8 04             	sub    $0x4,%eax
  800cfd:	8b 00                	mov    (%eax),%eax
  800cff:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d09:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d0d:	7e 1c                	jle    800d2b <getint+0x25>
		return va_arg(*ap, long long);
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8b 00                	mov    (%eax),%eax
  800d14:	8d 50 08             	lea    0x8(%eax),%edx
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	89 10                	mov    %edx,(%eax)
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8b 00                	mov    (%eax),%eax
  800d21:	83 e8 08             	sub    $0x8,%eax
  800d24:	8b 50 04             	mov    0x4(%eax),%edx
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	eb 38                	jmp    800d63 <getint+0x5d>
	else if (lflag)
  800d2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2f:	74 1a                	je     800d4b <getint+0x45>
		return va_arg(*ap, long);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8b 00                	mov    (%eax),%eax
  800d36:	8d 50 04             	lea    0x4(%eax),%edx
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	89 10                	mov    %edx,(%eax)
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8b 00                	mov    (%eax),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	99                   	cltd   
  800d49:	eb 18                	jmp    800d63 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	8d 50 04             	lea    0x4(%eax),%edx
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 10                	mov    %edx,(%eax)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 00                	mov    (%eax),%eax
  800d5d:	83 e8 04             	sub    $0x4,%eax
  800d60:	8b 00                	mov    (%eax),%eax
  800d62:	99                   	cltd   
}
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6d:	eb 17                	jmp    800d86 <vprintfmt+0x21>
			if (ch == '\0')
  800d6f:	85 db                	test   %ebx,%ebx
  800d71:	0f 84 af 03 00 00    	je     801126 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	53                   	push   %ebx
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d8             	movzbl %al,%ebx
  800d94:	83 fb 25             	cmp    $0x25,%ebx
  800d97:	75 d6                	jne    800d6f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d99:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d9d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800da4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800db2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	8d 50 01             	lea    0x1(%eax),%edx
  800dbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	0f b6 d8             	movzbl %al,%ebx
  800dc7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dca:	83 f8 55             	cmp    $0x55,%eax
  800dcd:	0f 87 2b 03 00 00    	ja     8010fe <vprintfmt+0x399>
  800dd3:	8b 04 85 78 40 80 00 	mov    0x804078(,%eax,4),%eax
  800dda:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ddc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800de0:	eb d7                	jmp    800db9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800de2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800de6:	eb d1                	jmp    800db9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800de8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800def:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800df2:	89 d0                	mov    %edx,%eax
  800df4:	c1 e0 02             	shl    $0x2,%eax
  800df7:	01 d0                	add    %edx,%eax
  800df9:	01 c0                	add    %eax,%eax
  800dfb:	01 d8                	add    %ebx,%eax
  800dfd:	83 e8 30             	sub    $0x30,%eax
  800e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e0b:	83 fb 2f             	cmp    $0x2f,%ebx
  800e0e:	7e 3e                	jle    800e4e <vprintfmt+0xe9>
  800e10:	83 fb 39             	cmp    $0x39,%ebx
  800e13:	7f 39                	jg     800e4e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e15:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e18:	eb d5                	jmp    800def <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1d:	83 c0 04             	add    $0x4,%eax
  800e20:	89 45 14             	mov    %eax,0x14(%ebp)
  800e23:	8b 45 14             	mov    0x14(%ebp),%eax
  800e26:	83 e8 04             	sub    $0x4,%eax
  800e29:	8b 00                	mov    (%eax),%eax
  800e2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e2e:	eb 1f                	jmp    800e4f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e34:	79 83                	jns    800db9 <vprintfmt+0x54>
				width = 0;
  800e36:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e3d:	e9 77 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e42:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e49:	e9 6b ff ff ff       	jmp    800db9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e4e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e53:	0f 89 60 ff ff ff    	jns    800db9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e5f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e66:	e9 4e ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e6b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e6e:	e9 46 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e73:	8b 45 14             	mov    0x14(%ebp),%eax
  800e76:	83 c0 04             	add    $0x4,%eax
  800e79:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7f:	83 e8 04             	sub    $0x4,%eax
  800e82:	8b 00                	mov    (%eax),%eax
  800e84:	83 ec 08             	sub    $0x8,%esp
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	50                   	push   %eax
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	ff d0                	call   *%eax
  800e90:	83 c4 10             	add    $0x10,%esp
			break;
  800e93:	e9 89 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 c0 04             	add    $0x4,%eax
  800e9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea4:	83 e8 04             	sub    $0x4,%eax
  800ea7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ea9:	85 db                	test   %ebx,%ebx
  800eab:	79 02                	jns    800eaf <vprintfmt+0x14a>
				err = -err;
  800ead:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800eaf:	83 fb 64             	cmp    $0x64,%ebx
  800eb2:	7f 0b                	jg     800ebf <vprintfmt+0x15a>
  800eb4:	8b 34 9d c0 3e 80 00 	mov    0x803ec0(,%ebx,4),%esi
  800ebb:	85 f6                	test   %esi,%esi
  800ebd:	75 19                	jne    800ed8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ebf:	53                   	push   %ebx
  800ec0:	68 65 40 80 00       	push   $0x804065
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	ff 75 08             	pushl  0x8(%ebp)
  800ecb:	e8 5e 02 00 00       	call   80112e <printfmt>
  800ed0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ed3:	e9 49 02 00 00       	jmp    801121 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ed8:	56                   	push   %esi
  800ed9:	68 6e 40 80 00       	push   $0x80406e
  800ede:	ff 75 0c             	pushl  0xc(%ebp)
  800ee1:	ff 75 08             	pushl  0x8(%ebp)
  800ee4:	e8 45 02 00 00       	call   80112e <printfmt>
  800ee9:	83 c4 10             	add    $0x10,%esp
			break;
  800eec:	e9 30 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ef1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef4:	83 c0 04             	add    $0x4,%eax
  800ef7:	89 45 14             	mov    %eax,0x14(%ebp)
  800efa:	8b 45 14             	mov    0x14(%ebp),%eax
  800efd:	83 e8 04             	sub    $0x4,%eax
  800f00:	8b 30                	mov    (%eax),%esi
  800f02:	85 f6                	test   %esi,%esi
  800f04:	75 05                	jne    800f0b <vprintfmt+0x1a6>
				p = "(null)";
  800f06:	be 71 40 80 00       	mov    $0x804071,%esi
			if (width > 0 && padc != '-')
  800f0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0f:	7e 6d                	jle    800f7e <vprintfmt+0x219>
  800f11:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f15:	74 67                	je     800f7e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	50                   	push   %eax
  800f1e:	56                   	push   %esi
  800f1f:	e8 12 05 00 00       	call   801436 <strnlen>
  800f24:	83 c4 10             	add    $0x10,%esp
  800f27:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f2a:	eb 16                	jmp    800f42 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f2c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	50                   	push   %eax
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800f42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f46:	7f e4                	jg     800f2c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f48:	eb 34                	jmp    800f7e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f4a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f4e:	74 1c                	je     800f6c <vprintfmt+0x207>
  800f50:	83 fb 1f             	cmp    $0x1f,%ebx
  800f53:	7e 05                	jle    800f5a <vprintfmt+0x1f5>
  800f55:	83 fb 7e             	cmp    $0x7e,%ebx
  800f58:	7e 12                	jle    800f6c <vprintfmt+0x207>
					putch('?', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 3f                	push   $0x3f
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
  800f6a:	eb 0f                	jmp    800f7b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f6c:	83 ec 08             	sub    $0x8,%esp
  800f6f:	ff 75 0c             	pushl  0xc(%ebp)
  800f72:	53                   	push   %ebx
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	ff d0                	call   *%eax
  800f78:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f7e:	89 f0                	mov    %esi,%eax
  800f80:	8d 70 01             	lea    0x1(%eax),%esi
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	0f be d8             	movsbl %al,%ebx
  800f88:	85 db                	test   %ebx,%ebx
  800f8a:	74 24                	je     800fb0 <vprintfmt+0x24b>
  800f8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f90:	78 b8                	js     800f4a <vprintfmt+0x1e5>
  800f92:	ff 4d e0             	decl   -0x20(%ebp)
  800f95:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f99:	79 af                	jns    800f4a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f9b:	eb 13                	jmp    800fb0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	6a 20                	push   $0x20
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fad:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb4:	7f e7                	jg     800f9d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fb6:	e9 66 01 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fbb:	83 ec 08             	sub    $0x8,%esp
  800fbe:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc1:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 3c fd ff ff       	call   800d06 <getint>
  800fca:	83 c4 10             	add    $0x10,%esp
  800fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd9:	85 d2                	test   %edx,%edx
  800fdb:	79 23                	jns    801000 <vprintfmt+0x29b>
				putch('-', putdat);
  800fdd:	83 ec 08             	sub    $0x8,%esp
  800fe0:	ff 75 0c             	pushl  0xc(%ebp)
  800fe3:	6a 2d                	push   $0x2d
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	ff d0                	call   *%eax
  800fea:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff3:	f7 d8                	neg    %eax
  800ff5:	83 d2 00             	adc    $0x0,%edx
  800ff8:	f7 da                	neg    %edx
  800ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801000:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801007:	e9 bc 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 e8             	pushl  -0x18(%ebp)
  801012:	8d 45 14             	lea    0x14(%ebp),%eax
  801015:	50                   	push   %eax
  801016:	e8 84 fc ff ff       	call   800c9f <getuint>
  80101b:	83 c4 10             	add    $0x10,%esp
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801021:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801024:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80102b:	e9 98 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801030:	83 ec 08             	sub    $0x8,%esp
  801033:	ff 75 0c             	pushl  0xc(%ebp)
  801036:	6a 58                	push   $0x58
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	ff d0                	call   *%eax
  80103d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801040:	83 ec 08             	sub    $0x8,%esp
  801043:	ff 75 0c             	pushl  0xc(%ebp)
  801046:	6a 58                	push   $0x58
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	ff d0                	call   *%eax
  80104d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801050:	83 ec 08             	sub    $0x8,%esp
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	6a 58                	push   $0x58
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	ff d0                	call   *%eax
  80105d:	83 c4 10             	add    $0x10,%esp
			break;
  801060:	e9 bc 00 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 30                	push   $0x30
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 78                	push   $0x78
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801085:	8b 45 14             	mov    0x14(%ebp),%eax
  801088:	83 c0 04             	add    $0x4,%eax
  80108b:	89 45 14             	mov    %eax,0x14(%ebp)
  80108e:	8b 45 14             	mov    0x14(%ebp),%eax
  801091:	83 e8 04             	sub    $0x4,%eax
  801094:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010a0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010a7:	eb 1f                	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8010af:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b2:	50                   	push   %eax
  8010b3:	e8 e7 fb ff ff       	call   800c9f <getuint>
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010c1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010c8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010cf:	83 ec 04             	sub    $0x4,%esp
  8010d2:	52                   	push   %edx
  8010d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d6:	50                   	push   %eax
  8010d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010da:	ff 75 f0             	pushl  -0x10(%ebp)
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	ff 75 08             	pushl  0x8(%ebp)
  8010e3:	e8 00 fb ff ff       	call   800be8 <printnum>
  8010e8:	83 c4 20             	add    $0x20,%esp
			break;
  8010eb:	eb 34                	jmp    801121 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	53                   	push   %ebx
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	ff d0                	call   *%eax
  8010f9:	83 c4 10             	add    $0x10,%esp
			break;
  8010fc:	eb 23                	jmp    801121 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	ff 75 0c             	pushl  0xc(%ebp)
  801104:	6a 25                	push   $0x25
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	ff d0                	call   *%eax
  80110b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80110e:	ff 4d 10             	decl   0x10(%ebp)
  801111:	eb 03                	jmp    801116 <vprintfmt+0x3b1>
  801113:	ff 4d 10             	decl   0x10(%ebp)
  801116:	8b 45 10             	mov    0x10(%ebp),%eax
  801119:	48                   	dec    %eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 25                	cmp    $0x25,%al
  80111e:	75 f3                	jne    801113 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801120:	90                   	nop
		}
	}
  801121:	e9 47 fc ff ff       	jmp    800d6d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801126:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80112a:	5b                   	pop    %ebx
  80112b:	5e                   	pop    %esi
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801134:	8d 45 10             	lea    0x10(%ebp),%eax
  801137:	83 c0 04             	add    $0x4,%eax
  80113a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	ff 75 f4             	pushl  -0xc(%ebp)
  801143:	50                   	push   %eax
  801144:	ff 75 0c             	pushl  0xc(%ebp)
  801147:	ff 75 08             	pushl  0x8(%ebp)
  80114a:	e8 16 fc ff ff       	call   800d65 <vprintfmt>
  80114f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801152:	90                   	nop
  801153:	c9                   	leave  
  801154:	c3                   	ret    

00801155 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	8b 40 08             	mov    0x8(%eax),%eax
  80115e:	8d 50 01             	lea    0x1(%eax),%edx
  801161:	8b 45 0c             	mov    0xc(%ebp),%eax
  801164:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 10                	mov    (%eax),%edx
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	8b 40 04             	mov    0x4(%eax),%eax
  801172:	39 c2                	cmp    %eax,%edx
  801174:	73 12                	jae    801188 <sprintputch+0x33>
		*b->buf++ = ch;
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	8b 00                	mov    (%eax),%eax
  80117b:	8d 48 01             	lea    0x1(%eax),%ecx
  80117e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801181:	89 0a                	mov    %ecx,(%edx)
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	88 10                	mov    %dl,(%eax)
}
  801188:	90                   	nop
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	01 d0                	add    %edx,%eax
  8011a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b0:	74 06                	je     8011b8 <vsnprintf+0x2d>
  8011b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b6:	7f 07                	jg     8011bf <vsnprintf+0x34>
		return -E_INVAL;
  8011b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8011bd:	eb 20                	jmp    8011df <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011bf:	ff 75 14             	pushl  0x14(%ebp)
  8011c2:	ff 75 10             	pushl  0x10(%ebp)
  8011c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011c8:	50                   	push   %eax
  8011c9:	68 55 11 80 00       	push   $0x801155
  8011ce:	e8 92 fb ff ff       	call   800d65 <vprintfmt>
  8011d3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011d9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ea:	83 c0 04             	add    $0x4,%eax
  8011ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f6:	50                   	push   %eax
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	ff 75 08             	pushl  0x8(%ebp)
  8011fd:	e8 89 ff ff ff       	call   80118b <vsnprintf>
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801208:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801217:	74 13                	je     80122c <readline+0x1f>
		cprintf("%s", prompt);
  801219:	83 ec 08             	sub    $0x8,%esp
  80121c:	ff 75 08             	pushl  0x8(%ebp)
  80121f:	68 d0 41 80 00       	push   $0x8041d0
  801224:	e8 62 f9 ff ff       	call   800b8b <cprintf>
  801229:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80122c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	6a 00                	push   $0x0
  801238:	e8 54 f5 ff ff       	call   800791 <iscons>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801243:	e8 fb f4 ff ff       	call   800743 <getchar>
  801248:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80124b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80124f:	79 22                	jns    801273 <readline+0x66>
			if (c != -E_EOF)
  801251:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801255:	0f 84 ad 00 00 00    	je     801308 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	ff 75 ec             	pushl  -0x14(%ebp)
  801261:	68 d3 41 80 00       	push   $0x8041d3
  801266:	e8 20 f9 ff ff       	call   800b8b <cprintf>
  80126b:	83 c4 10             	add    $0x10,%esp
			return;
  80126e:	e9 95 00 00 00       	jmp    801308 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801273:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801277:	7e 34                	jle    8012ad <readline+0xa0>
  801279:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801280:	7f 2b                	jg     8012ad <readline+0xa0>
			if (echoing)
  801282:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801286:	74 0e                	je     801296 <readline+0x89>
				cputchar(c);
  801288:	83 ec 0c             	sub    $0xc,%esp
  80128b:	ff 75 ec             	pushl  -0x14(%ebp)
  80128e:	e8 68 f4 ff ff       	call   8006fb <cputchar>
  801293:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801299:	8d 50 01             	lea    0x1(%eax),%edx
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80129f:	89 c2                	mov    %eax,%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 d0                	add    %edx,%eax
  8012a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012a9:	88 10                	mov    %dl,(%eax)
  8012ab:	eb 56                	jmp    801303 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012ad:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012b1:	75 1f                	jne    8012d2 <readline+0xc5>
  8012b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012b7:	7e 19                	jle    8012d2 <readline+0xc5>
			if (echoing)
  8012b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012bd:	74 0e                	je     8012cd <readline+0xc0>
				cputchar(c);
  8012bf:	83 ec 0c             	sub    $0xc,%esp
  8012c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c5:	e8 31 f4 ff ff       	call   8006fb <cputchar>
  8012ca:	83 c4 10             	add    $0x10,%esp

			i--;
  8012cd:	ff 4d f4             	decl   -0xc(%ebp)
  8012d0:	eb 31                	jmp    801303 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012d2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012d6:	74 0a                	je     8012e2 <readline+0xd5>
  8012d8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012dc:	0f 85 61 ff ff ff    	jne    801243 <readline+0x36>
			if (echoing)
  8012e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e6:	74 0e                	je     8012f6 <readline+0xe9>
				cputchar(c);
  8012e8:	83 ec 0c             	sub    $0xc,%esp
  8012eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ee:	e8 08 f4 ff ff       	call   8006fb <cputchar>
  8012f3:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	01 d0                	add    %edx,%eax
  8012fe:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801301:	eb 06                	jmp    801309 <readline+0xfc>
		}
	}
  801303:	e9 3b ff ff ff       	jmp    801243 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801308:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801311:	e8 c2 0e 00 00       	call   8021d8 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131a:	74 13                	je     80132f <atomic_readline+0x24>
		cprintf("%s", prompt);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 08             	pushl  0x8(%ebp)
  801322:	68 d0 41 80 00       	push   $0x8041d0
  801327:	e8 5f f8 ff ff       	call   800b8b <cprintf>
  80132c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80132f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	6a 00                	push   $0x0
  80133b:	e8 51 f4 ff ff       	call   800791 <iscons>
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801346:	e8 f8 f3 ff ff       	call   800743 <getchar>
  80134b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80134e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801352:	79 23                	jns    801377 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801354:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801358:	74 13                	je     80136d <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	ff 75 ec             	pushl  -0x14(%ebp)
  801360:	68 d3 41 80 00       	push   $0x8041d3
  801365:	e8 21 f8 ff ff       	call   800b8b <cprintf>
  80136a:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80136d:	e8 80 0e 00 00       	call   8021f2 <sys_enable_interrupt>
			return;
  801372:	e9 9a 00 00 00       	jmp    801411 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801377:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80137b:	7e 34                	jle    8013b1 <atomic_readline+0xa6>
  80137d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801384:	7f 2b                	jg     8013b1 <atomic_readline+0xa6>
			if (echoing)
  801386:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80138a:	74 0e                	je     80139a <atomic_readline+0x8f>
				cputchar(c);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 ec             	pushl  -0x14(%ebp)
  801392:	e8 64 f3 ff ff       	call   8006fb <cputchar>
  801397:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80139a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139d:	8d 50 01             	lea    0x1(%eax),%edx
  8013a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013a3:	89 c2                	mov    %eax,%edx
  8013a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a8:	01 d0                	add    %edx,%eax
  8013aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ad:	88 10                	mov    %dl,(%eax)
  8013af:	eb 5b                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013b1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013b5:	75 1f                	jne    8013d6 <atomic_readline+0xcb>
  8013b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013bb:	7e 19                	jle    8013d6 <atomic_readline+0xcb>
			if (echoing)
  8013bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c1:	74 0e                	je     8013d1 <atomic_readline+0xc6>
				cputchar(c);
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013c9:	e8 2d f3 ff ff       	call   8006fb <cputchar>
  8013ce:	83 c4 10             	add    $0x10,%esp
			i--;
  8013d1:	ff 4d f4             	decl   -0xc(%ebp)
  8013d4:	eb 36                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8013d6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013da:	74 0a                	je     8013e6 <atomic_readline+0xdb>
  8013dc:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013e0:	0f 85 60 ff ff ff    	jne    801346 <atomic_readline+0x3b>
			if (echoing)
  8013e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ea:	74 0e                	je     8013fa <atomic_readline+0xef>
				cputchar(c);
  8013ec:	83 ec 0c             	sub    $0xc,%esp
  8013ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f2:	e8 04 f3 ff ff       	call   8006fb <cputchar>
  8013f7:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801400:	01 d0                	add    %edx,%eax
  801402:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801405:	e8 e8 0d 00 00       	call   8021f2 <sys_enable_interrupt>
			return;
  80140a:	eb 05                	jmp    801411 <atomic_readline+0x106>
		}
	}
  80140c:	e9 35 ff ff ff       	jmp    801346 <atomic_readline+0x3b>
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801419:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801420:	eb 06                	jmp    801428 <strlen+0x15>
		n++;
  801422:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801425:	ff 45 08             	incl   0x8(%ebp)
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	84 c0                	test   %al,%al
  80142f:	75 f1                	jne    801422 <strlen+0xf>
		n++;
	return n;
  801431:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80143c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801443:	eb 09                	jmp    80144e <strnlen+0x18>
		n++;
  801445:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801448:	ff 45 08             	incl   0x8(%ebp)
  80144b:	ff 4d 0c             	decl   0xc(%ebp)
  80144e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801452:	74 09                	je     80145d <strnlen+0x27>
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	84 c0                	test   %al,%al
  80145b:	75 e8                	jne    801445 <strnlen+0xf>
		n++;
	return n;
  80145d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80146e:	90                   	nop
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8d 50 01             	lea    0x1(%eax),%edx
  801475:	89 55 08             	mov    %edx,0x8(%ebp)
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80147e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801481:	8a 12                	mov    (%edx),%dl
  801483:	88 10                	mov    %dl,(%eax)
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	75 e4                	jne    80146f <strcpy+0xd>
		/* do nothing */;
	return ret;
  80148b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80149c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a3:	eb 1f                	jmp    8014c4 <strncpy+0x34>
		*dst++ = *src;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8d 50 01             	lea    0x1(%eax),%edx
  8014ab:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b1:	8a 12                	mov    (%edx),%dl
  8014b3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 03                	je     8014c1 <strncpy+0x31>
			src++;
  8014be:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014c1:	ff 45 fc             	incl   -0x4(%ebp)
  8014c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014ca:	72 d9                	jb     8014a5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e1:	74 30                	je     801513 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014e3:	eb 16                	jmp    8014fb <strlcpy+0x2a>
			*dst++ = *src++;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8d 50 01             	lea    0x1(%eax),%edx
  8014eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014f7:	8a 12                	mov    (%edx),%dl
  8014f9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014fb:	ff 4d 10             	decl   0x10(%ebp)
  8014fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801502:	74 09                	je     80150d <strlcpy+0x3c>
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	84 c0                	test   %al,%al
  80150b:	75 d8                	jne    8014e5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801513:	8b 55 08             	mov    0x8(%ebp),%edx
  801516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801519:	29 c2                	sub    %eax,%edx
  80151b:	89 d0                	mov    %edx,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801522:	eb 06                	jmp    80152a <strcmp+0xb>
		p++, q++;
  801524:	ff 45 08             	incl   0x8(%ebp)
  801527:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8a 00                	mov    (%eax),%al
  80152f:	84 c0                	test   %al,%al
  801531:	74 0e                	je     801541 <strcmp+0x22>
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8a 10                	mov    (%eax),%dl
  801538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	38 c2                	cmp    %al,%dl
  80153f:	74 e3                	je     801524 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f b6 d0             	movzbl %al,%edx
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8a 00                	mov    (%eax),%al
  80154e:	0f b6 c0             	movzbl %al,%eax
  801551:	29 c2                	sub    %eax,%edx
  801553:	89 d0                	mov    %edx,%eax
}
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    

00801557 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80155a:	eb 09                	jmp    801565 <strncmp+0xe>
		n--, p++, q++;
  80155c:	ff 4d 10             	decl   0x10(%ebp)
  80155f:	ff 45 08             	incl   0x8(%ebp)
  801562:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801565:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801569:	74 17                	je     801582 <strncmp+0x2b>
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 0e                	je     801582 <strncmp+0x2b>
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8a 10                	mov    (%eax),%dl
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	38 c2                	cmp    %al,%dl
  801580:	74 da                	je     80155c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801582:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801586:	75 07                	jne    80158f <strncmp+0x38>
		return 0;
  801588:	b8 00 00 00 00       	mov    $0x0,%eax
  80158d:	eb 14                	jmp    8015a3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	0f b6 d0             	movzbl %al,%edx
  801597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	0f b6 c0             	movzbl %al,%eax
  80159f:	29 c2                	sub    %eax,%edx
  8015a1:	89 d0                	mov    %edx,%eax
}
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b1:	eb 12                	jmp    8015c5 <strchr+0x20>
		if (*s == c)
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015bb:	75 05                	jne    8015c2 <strchr+0x1d>
			return (char *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	eb 11                	jmp    8015d3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015c2:	ff 45 08             	incl   0x8(%ebp)
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	84 c0                	test   %al,%al
  8015cc:	75 e5                	jne    8015b3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015e1:	eb 0d                	jmp    8015f0 <strfind+0x1b>
		if (*s == c)
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015eb:	74 0e                	je     8015fb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015ed:	ff 45 08             	incl   0x8(%ebp)
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	84 c0                	test   %al,%al
  8015f7:	75 ea                	jne    8015e3 <strfind+0xe>
  8015f9:	eb 01                	jmp    8015fc <strfind+0x27>
		if (*s == c)
			break;
  8015fb:	90                   	nop
	return (char *) s;
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80160d:	8b 45 10             	mov    0x10(%ebp),%eax
  801610:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801613:	eb 0e                	jmp    801623 <memset+0x22>
		*p++ = c;
  801615:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801618:	8d 50 01             	lea    0x1(%eax),%edx
  80161b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801621:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801623:	ff 4d f8             	decl   -0x8(%ebp)
  801626:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80162a:	79 e9                	jns    801615 <memset+0x14>
		*p++ = c;

	return v;
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801643:	eb 16                	jmp    80165b <memcpy+0x2a>
		*d++ = *s++;
  801645:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801648:	8d 50 01             	lea    0x1(%eax),%edx
  80164b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80164e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801651:	8d 4a 01             	lea    0x1(%edx),%ecx
  801654:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801657:	8a 12                	mov    (%edx),%dl
  801659:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801661:	89 55 10             	mov    %edx,0x10(%ebp)
  801664:	85 c0                	test   %eax,%eax
  801666:	75 dd                	jne    801645 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801682:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801685:	73 50                	jae    8016d7 <memmove+0x6a>
  801687:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	01 d0                	add    %edx,%eax
  80168f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801692:	76 43                	jbe    8016d7 <memmove+0x6a>
		s += n;
  801694:	8b 45 10             	mov    0x10(%ebp),%eax
  801697:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80169a:	8b 45 10             	mov    0x10(%ebp),%eax
  80169d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016a0:	eb 10                	jmp    8016b2 <memmove+0x45>
			*--d = *--s;
  8016a2:	ff 4d f8             	decl   -0x8(%ebp)
  8016a5:	ff 4d fc             	decl   -0x4(%ebp)
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ab:	8a 10                	mov    (%eax),%dl
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	75 e3                	jne    8016a2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016bf:	eb 23                	jmp    8016e4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c4:	8d 50 01             	lea    0x1(%eax),%edx
  8016c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016d3:	8a 12                	mov    (%edx),%dl
  8016d5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	75 dd                	jne    8016c1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016fb:	eb 2a                	jmp    801727 <memcmp+0x3e>
		if (*s1 != *s2)
  8016fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801700:	8a 10                	mov    (%eax),%dl
  801702:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	38 c2                	cmp    %al,%dl
  801709:	74 16                	je     801721 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80170b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	0f b6 d0             	movzbl %al,%edx
  801713:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	0f b6 c0             	movzbl %al,%eax
  80171b:	29 c2                	sub    %eax,%edx
  80171d:	89 d0                	mov    %edx,%eax
  80171f:	eb 18                	jmp    801739 <memcmp+0x50>
		s1++, s2++;
  801721:	ff 45 fc             	incl   -0x4(%ebp)
  801724:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801727:	8b 45 10             	mov    0x10(%ebp),%eax
  80172a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172d:	89 55 10             	mov    %edx,0x10(%ebp)
  801730:	85 c0                	test   %eax,%eax
  801732:	75 c9                	jne    8016fd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801741:	8b 55 08             	mov    0x8(%ebp),%edx
  801744:	8b 45 10             	mov    0x10(%ebp),%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80174c:	eb 15                	jmp    801763 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	0f b6 d0             	movzbl %al,%edx
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	0f b6 c0             	movzbl %al,%eax
  80175c:	39 c2                	cmp    %eax,%edx
  80175e:	74 0d                	je     80176d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801760:	ff 45 08             	incl   0x8(%ebp)
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801769:	72 e3                	jb     80174e <memfind+0x13>
  80176b:	eb 01                	jmp    80176e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80176d:	90                   	nop
	return (void *) s;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801787:	eb 03                	jmp    80178c <strtol+0x19>
		s++;
  801789:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	3c 20                	cmp    $0x20,%al
  801793:	74 f4                	je     801789 <strtol+0x16>
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	3c 09                	cmp    $0x9,%al
  80179c:	74 eb                	je     801789 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8a 00                	mov    (%eax),%al
  8017a3:	3c 2b                	cmp    $0x2b,%al
  8017a5:	75 05                	jne    8017ac <strtol+0x39>
		s++;
  8017a7:	ff 45 08             	incl   0x8(%ebp)
  8017aa:	eb 13                	jmp    8017bf <strtol+0x4c>
	else if (*s == '-')
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	3c 2d                	cmp    $0x2d,%al
  8017b3:	75 0a                	jne    8017bf <strtol+0x4c>
		s++, neg = 1;
  8017b5:	ff 45 08             	incl   0x8(%ebp)
  8017b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c3:	74 06                	je     8017cb <strtol+0x58>
  8017c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017c9:	75 20                	jne    8017eb <strtol+0x78>
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	3c 30                	cmp    $0x30,%al
  8017d2:	75 17                	jne    8017eb <strtol+0x78>
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	40                   	inc    %eax
  8017d8:	8a 00                	mov    (%eax),%al
  8017da:	3c 78                	cmp    $0x78,%al
  8017dc:	75 0d                	jne    8017eb <strtol+0x78>
		s += 2, base = 16;
  8017de:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017e2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017e9:	eb 28                	jmp    801813 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ef:	75 15                	jne    801806 <strtol+0x93>
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	8a 00                	mov    (%eax),%al
  8017f6:	3c 30                	cmp    $0x30,%al
  8017f8:	75 0c                	jne    801806 <strtol+0x93>
		s++, base = 8;
  8017fa:	ff 45 08             	incl   0x8(%ebp)
  8017fd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801804:	eb 0d                	jmp    801813 <strtol+0xa0>
	else if (base == 0)
  801806:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80180a:	75 07                	jne    801813 <strtol+0xa0>
		base = 10;
  80180c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8a 00                	mov    (%eax),%al
  801818:	3c 2f                	cmp    $0x2f,%al
  80181a:	7e 19                	jle    801835 <strtol+0xc2>
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8a 00                	mov    (%eax),%al
  801821:	3c 39                	cmp    $0x39,%al
  801823:	7f 10                	jg     801835 <strtol+0xc2>
			dig = *s - '0';
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8a 00                	mov    (%eax),%al
  80182a:	0f be c0             	movsbl %al,%eax
  80182d:	83 e8 30             	sub    $0x30,%eax
  801830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801833:	eb 42                	jmp    801877 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	8a 00                	mov    (%eax),%al
  80183a:	3c 60                	cmp    $0x60,%al
  80183c:	7e 19                	jle    801857 <strtol+0xe4>
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8a 00                	mov    (%eax),%al
  801843:	3c 7a                	cmp    $0x7a,%al
  801845:	7f 10                	jg     801857 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8a 00                	mov    (%eax),%al
  80184c:	0f be c0             	movsbl %al,%eax
  80184f:	83 e8 57             	sub    $0x57,%eax
  801852:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801855:	eb 20                	jmp    801877 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 40                	cmp    $0x40,%al
  80185e:	7e 39                	jle    801899 <strtol+0x126>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 5a                	cmp    $0x5a,%al
  801867:	7f 30                	jg     801899 <strtol+0x126>
			dig = *s - 'A' + 10;
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	0f be c0             	movsbl %al,%eax
  801871:	83 e8 37             	sub    $0x37,%eax
  801874:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80187d:	7d 19                	jge    801898 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80187f:	ff 45 08             	incl   0x8(%ebp)
  801882:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801885:	0f af 45 10          	imul   0x10(%ebp),%eax
  801889:	89 c2                	mov    %eax,%edx
  80188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801893:	e9 7b ff ff ff       	jmp    801813 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801898:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801899:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80189d:	74 08                	je     8018a7 <strtol+0x134>
		*endptr = (char *) s;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ab:	74 07                	je     8018b4 <strtol+0x141>
  8018ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b0:	f7 d8                	neg    %eax
  8018b2:	eb 03                	jmp    8018b7 <strtol+0x144>
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <ltostr>:

void
ltostr(long value, char *str)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d1:	79 13                	jns    8018e6 <ltostr+0x2d>
	{
		neg = 1;
  8018d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018e0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018e3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018ee:	99                   	cltd   
  8018ef:	f7 f9                	idiv   %ecx
  8018f1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f7:	8d 50 01             	lea    0x1(%eax),%edx
  8018fa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018fd:	89 c2                	mov    %eax,%edx
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	01 d0                	add    %edx,%eax
  801904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801907:	83 c2 30             	add    $0x30,%edx
  80190a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80190c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80190f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801914:	f7 e9                	imul   %ecx
  801916:	c1 fa 02             	sar    $0x2,%edx
  801919:	89 c8                	mov    %ecx,%eax
  80191b:	c1 f8 1f             	sar    $0x1f,%eax
  80191e:	29 c2                	sub    %eax,%edx
  801920:	89 d0                	mov    %edx,%eax
  801922:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801925:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801928:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80192d:	f7 e9                	imul   %ecx
  80192f:	c1 fa 02             	sar    $0x2,%edx
  801932:	89 c8                	mov    %ecx,%eax
  801934:	c1 f8 1f             	sar    $0x1f,%eax
  801937:	29 c2                	sub    %eax,%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	c1 e0 02             	shl    $0x2,%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	01 c0                	add    %eax,%eax
  801942:	29 c1                	sub    %eax,%ecx
  801944:	89 ca                	mov    %ecx,%edx
  801946:	85 d2                	test   %edx,%edx
  801948:	75 9c                	jne    8018e6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80194a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801951:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801954:	48                   	dec    %eax
  801955:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801958:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80195c:	74 3d                	je     80199b <ltostr+0xe2>
		start = 1 ;
  80195e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801965:	eb 34                	jmp    80199b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	01 d0                	add    %edx,%eax
  80196f:	8a 00                	mov    (%eax),%al
  801971:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197a:	01 c2                	add    %eax,%edx
  80197c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80197f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801982:	01 c8                	add    %ecx,%eax
  801984:	8a 00                	mov    (%eax),%al
  801986:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801988:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198e:	01 c2                	add    %eax,%edx
  801990:	8a 45 eb             	mov    -0x15(%ebp),%al
  801993:	88 02                	mov    %al,(%edx)
		start++ ;
  801995:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801998:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80199b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a1:	7c c4                	jl     801967 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a9:	01 d0                	add    %edx,%eax
  8019ab:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	e8 54 fa ff ff       	call   801413 <strlen>
  8019bf:	83 c4 04             	add    $0x4,%esp
  8019c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	e8 46 fa ff ff       	call   801413 <strlen>
  8019cd:	83 c4 04             	add    $0x4,%esp
  8019d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019e1:	eb 17                	jmp    8019fa <strcconcat+0x49>
		final[s] = str1[s] ;
  8019e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e9:	01 c2                	add    %eax,%edx
  8019eb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	01 c8                	add    %ecx,%eax
  8019f3:	8a 00                	mov    (%eax),%al
  8019f5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019f7:	ff 45 fc             	incl   -0x4(%ebp)
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a00:	7c e1                	jl     8019e3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a02:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a10:	eb 1f                	jmp    801a31 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a15:	8d 50 01             	lea    0x1(%eax),%edx
  801a18:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a1b:	89 c2                	mov    %eax,%edx
  801a1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a20:	01 c2                	add    %eax,%edx
  801a22:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a28:	01 c8                	add    %ecx,%eax
  801a2a:	8a 00                	mov    (%eax),%al
  801a2c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a2e:	ff 45 f8             	incl   -0x8(%ebp)
  801a31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a34:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a37:	7c d9                	jl     801a12 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3f:	01 d0                	add    %edx,%eax
  801a41:	c6 00 00             	movb   $0x0,(%eax)
}
  801a44:	90                   	nop
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a53:	8b 45 14             	mov    0x14(%ebp),%eax
  801a56:	8b 00                	mov    (%eax),%eax
  801a58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a62:	01 d0                	add    %edx,%eax
  801a64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a6a:	eb 0c                	jmp    801a78 <strsplit+0x31>
			*string++ = 0;
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	8d 50 01             	lea    0x1(%eax),%edx
  801a72:	89 55 08             	mov    %edx,0x8(%ebp)
  801a75:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	8a 00                	mov    (%eax),%al
  801a7d:	84 c0                	test   %al,%al
  801a7f:	74 18                	je     801a99 <strsplit+0x52>
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	0f be c0             	movsbl %al,%eax
  801a89:	50                   	push   %eax
  801a8a:	ff 75 0c             	pushl  0xc(%ebp)
  801a8d:	e8 13 fb ff ff       	call   8015a5 <strchr>
  801a92:	83 c4 08             	add    $0x8,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	75 d3                	jne    801a6c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	84 c0                	test   %al,%al
  801aa0:	74 5a                	je     801afc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa5:	8b 00                	mov    (%eax),%eax
  801aa7:	83 f8 0f             	cmp    $0xf,%eax
  801aaa:	75 07                	jne    801ab3 <strsplit+0x6c>
		{
			return 0;
  801aac:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab1:	eb 66                	jmp    801b19 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab6:	8b 00                	mov    (%eax),%eax
  801ab8:	8d 48 01             	lea    0x1(%eax),%ecx
  801abb:	8b 55 14             	mov    0x14(%ebp),%edx
  801abe:	89 0a                	mov    %ecx,(%edx)
  801ac0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aca:	01 c2                	add    %eax,%edx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad1:	eb 03                	jmp    801ad6 <strsplit+0x8f>
			string++;
  801ad3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	8a 00                	mov    (%eax),%al
  801adb:	84 c0                	test   %al,%al
  801add:	74 8b                	je     801a6a <strsplit+0x23>
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8a 00                	mov    (%eax),%al
  801ae4:	0f be c0             	movsbl %al,%eax
  801ae7:	50                   	push   %eax
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	e8 b5 fa ff ff       	call   8015a5 <strchr>
  801af0:	83 c4 08             	add    $0x8,%esp
  801af3:	85 c0                	test   %eax,%eax
  801af5:	74 dc                	je     801ad3 <strsplit+0x8c>
			string++;
	}
  801af7:	e9 6e ff ff ff       	jmp    801a6a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801afc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801afd:	8b 45 14             	mov    0x14(%ebp),%eax
  801b00:	8b 00                	mov    (%eax),%eax
  801b02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b09:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0c:	01 d0                	add    %edx,%eax
  801b0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b14:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b21:	a1 04 50 80 00       	mov    0x805004,%eax
  801b26:	85 c0                	test   %eax,%eax
  801b28:	74 1f                	je     801b49 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b2a:	e8 1d 00 00 00       	call   801b4c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	68 e4 41 80 00       	push   $0x8041e4
  801b37:	e8 4f f0 ff ff       	call   800b8b <cprintf>
  801b3c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b3f:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b46:	00 00 00 
	}
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801b52:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b59:	00 00 00 
  801b5c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b63:	00 00 00 
  801b66:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b6d:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801b70:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b77:	00 00 00 
  801b7a:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b81:	00 00 00 
  801b84:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b8b:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801b8e:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b95:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801b98:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ba7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bac:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801bb1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bb8:	a1 20 51 80 00       	mov    0x805120,%eax
  801bbd:	c1 e0 04             	shl    $0x4,%eax
  801bc0:	89 c2                	mov    %eax,%edx
  801bc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc5:	01 d0                	add    %edx,%eax
  801bc7:	48                   	dec    %eax
  801bc8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bce:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd3:	f7 75 f0             	divl   -0x10(%ebp)
  801bd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd9:	29 d0                	sub    %edx,%eax
  801bdb:	89 c2                	mov    %eax,%edx
  801bdd:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801be4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801be7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bec:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bf1:	83 ec 04             	sub    $0x4,%esp
  801bf4:	6a 06                	push   $0x6
  801bf6:	52                   	push   %edx
  801bf7:	50                   	push   %eax
  801bf8:	e8 71 05 00 00       	call   80216e <sys_allocate_chunk>
  801bfd:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c00:	a1 20 51 80 00       	mov    0x805120,%eax
  801c05:	83 ec 0c             	sub    $0xc,%esp
  801c08:	50                   	push   %eax
  801c09:	e8 e6 0b 00 00       	call   8027f4 <initialize_MemBlocksList>
  801c0e:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801c11:	a1 48 51 80 00       	mov    0x805148,%eax
  801c16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801c19:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c1d:	75 14                	jne    801c33 <initialize_dyn_block_system+0xe7>
  801c1f:	83 ec 04             	sub    $0x4,%esp
  801c22:	68 09 42 80 00       	push   $0x804209
  801c27:	6a 2b                	push   $0x2b
  801c29:	68 27 42 80 00       	push   $0x804227
  801c2e:	e8 a4 ec ff ff       	call   8008d7 <_panic>
  801c33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c36:	8b 00                	mov    (%eax),%eax
  801c38:	85 c0                	test   %eax,%eax
  801c3a:	74 10                	je     801c4c <initialize_dyn_block_system+0x100>
  801c3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c3f:	8b 00                	mov    (%eax),%eax
  801c41:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c44:	8b 52 04             	mov    0x4(%edx),%edx
  801c47:	89 50 04             	mov    %edx,0x4(%eax)
  801c4a:	eb 0b                	jmp    801c57 <initialize_dyn_block_system+0x10b>
  801c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c4f:	8b 40 04             	mov    0x4(%eax),%eax
  801c52:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c5a:	8b 40 04             	mov    0x4(%eax),%eax
  801c5d:	85 c0                	test   %eax,%eax
  801c5f:	74 0f                	je     801c70 <initialize_dyn_block_system+0x124>
  801c61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c64:	8b 40 04             	mov    0x4(%eax),%eax
  801c67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c6a:	8b 12                	mov    (%edx),%edx
  801c6c:	89 10                	mov    %edx,(%eax)
  801c6e:	eb 0a                	jmp    801c7a <initialize_dyn_block_system+0x12e>
  801c70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c73:	8b 00                	mov    (%eax),%eax
  801c75:	a3 48 51 80 00       	mov    %eax,0x805148
  801c7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c8d:	a1 54 51 80 00       	mov    0x805154,%eax
  801c92:	48                   	dec    %eax
  801c93:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801c98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c9b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801ca2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ca5:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801cac:	83 ec 0c             	sub    $0xc,%esp
  801caf:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cb2:	e8 d2 13 00 00       	call   803089 <insert_sorted_with_merge_freeList>
  801cb7:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801cba:	90                   	nop
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
  801cc0:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cc3:	e8 53 fe ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801cc8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ccc:	75 07                	jne    801cd5 <malloc+0x18>
  801cce:	b8 00 00 00 00       	mov    $0x0,%eax
  801cd3:	eb 61                	jmp    801d36 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801cd5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  801cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ce2:	01 d0                	add    %edx,%eax
  801ce4:	48                   	dec    %eax
  801ce5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ce8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ceb:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf0:	f7 75 f4             	divl   -0xc(%ebp)
  801cf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf6:	29 d0                	sub    %edx,%eax
  801cf8:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801cfb:	e8 3c 08 00 00       	call   80253c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d00:	85 c0                	test   %eax,%eax
  801d02:	74 2d                	je     801d31 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801d04:	83 ec 0c             	sub    $0xc,%esp
  801d07:	ff 75 08             	pushl  0x8(%ebp)
  801d0a:	e8 3e 0f 00 00       	call   802c4d <alloc_block_FF>
  801d0f:	83 c4 10             	add    $0x10,%esp
  801d12:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801d15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d19:	74 16                	je     801d31 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801d1b:	83 ec 0c             	sub    $0xc,%esp
  801d1e:	ff 75 ec             	pushl  -0x14(%ebp)
  801d21:	e8 48 0c 00 00       	call   80296e <insert_sorted_allocList>
  801d26:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801d29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2c:	8b 40 08             	mov    0x8(%eax),%eax
  801d2f:	eb 05                	jmp    801d36 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801d31:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d47:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d4c:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d52:	83 ec 08             	sub    $0x8,%esp
  801d55:	50                   	push   %eax
  801d56:	68 40 50 80 00       	push   $0x805040
  801d5b:	e8 71 0b 00 00       	call   8028d1 <find_block>
  801d60:	83 c4 10             	add    $0x10,%esp
  801d63:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d69:	8b 50 0c             	mov    0xc(%eax),%edx
  801d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6f:	83 ec 08             	sub    $0x8,%esp
  801d72:	52                   	push   %edx
  801d73:	50                   	push   %eax
  801d74:	e8 bd 03 00 00       	call   802136 <sys_free_user_mem>
  801d79:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801d7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d80:	75 14                	jne    801d96 <free+0x5e>
  801d82:	83 ec 04             	sub    $0x4,%esp
  801d85:	68 09 42 80 00       	push   $0x804209
  801d8a:	6a 71                	push   $0x71
  801d8c:	68 27 42 80 00       	push   $0x804227
  801d91:	e8 41 eb ff ff       	call   8008d7 <_panic>
  801d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d99:	8b 00                	mov    (%eax),%eax
  801d9b:	85 c0                	test   %eax,%eax
  801d9d:	74 10                	je     801daf <free+0x77>
  801d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da2:	8b 00                	mov    (%eax),%eax
  801da4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801da7:	8b 52 04             	mov    0x4(%edx),%edx
  801daa:	89 50 04             	mov    %edx,0x4(%eax)
  801dad:	eb 0b                	jmp    801dba <free+0x82>
  801daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db2:	8b 40 04             	mov    0x4(%eax),%eax
  801db5:	a3 44 50 80 00       	mov    %eax,0x805044
  801dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbd:	8b 40 04             	mov    0x4(%eax),%eax
  801dc0:	85 c0                	test   %eax,%eax
  801dc2:	74 0f                	je     801dd3 <free+0x9b>
  801dc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc7:	8b 40 04             	mov    0x4(%eax),%eax
  801dca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dcd:	8b 12                	mov    (%edx),%edx
  801dcf:	89 10                	mov    %edx,(%eax)
  801dd1:	eb 0a                	jmp    801ddd <free+0xa5>
  801dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dd6:	8b 00                	mov    (%eax),%eax
  801dd8:	a3 40 50 80 00       	mov    %eax,0x805040
  801ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801de9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801df0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801df5:	48                   	dec    %eax
  801df6:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801dfb:	83 ec 0c             	sub    $0xc,%esp
  801dfe:	ff 75 f0             	pushl  -0x10(%ebp)
  801e01:	e8 83 12 00 00       	call   803089 <insert_sorted_with_merge_freeList>
  801e06:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801e09:	90                   	nop
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	83 ec 28             	sub    $0x28,%esp
  801e12:	8b 45 10             	mov    0x10(%ebp),%eax
  801e15:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e18:	e8 fe fc ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801e1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e21:	75 0a                	jne    801e2d <smalloc+0x21>
  801e23:	b8 00 00 00 00       	mov    $0x0,%eax
  801e28:	e9 86 00 00 00       	jmp    801eb3 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801e2d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3a:	01 d0                	add    %edx,%eax
  801e3c:	48                   	dec    %eax
  801e3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e43:	ba 00 00 00 00       	mov    $0x0,%edx
  801e48:	f7 75 f4             	divl   -0xc(%ebp)
  801e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4e:	29 d0                	sub    %edx,%eax
  801e50:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e53:	e8 e4 06 00 00       	call   80253c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	74 52                	je     801eae <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801e5c:	83 ec 0c             	sub    $0xc,%esp
  801e5f:	ff 75 0c             	pushl  0xc(%ebp)
  801e62:	e8 e6 0d 00 00       	call   802c4d <alloc_block_FF>
  801e67:	83 c4 10             	add    $0x10,%esp
  801e6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801e6d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e71:	75 07                	jne    801e7a <smalloc+0x6e>
			return NULL ;
  801e73:	b8 00 00 00 00       	mov    $0x0,%eax
  801e78:	eb 39                	jmp    801eb3 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801e7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e7d:	8b 40 08             	mov    0x8(%eax),%eax
  801e80:	89 c2                	mov    %eax,%edx
  801e82:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e86:	52                   	push   %edx
  801e87:	50                   	push   %eax
  801e88:	ff 75 0c             	pushl  0xc(%ebp)
  801e8b:	ff 75 08             	pushl  0x8(%ebp)
  801e8e:	e8 2e 04 00 00       	call   8022c1 <sys_createSharedObject>
  801e93:	83 c4 10             	add    $0x10,%esp
  801e96:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801e99:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e9d:	79 07                	jns    801ea6 <smalloc+0x9a>
			return (void*)NULL ;
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea4:	eb 0d                	jmp    801eb3 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801ea6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ea9:	8b 40 08             	mov    0x8(%eax),%eax
  801eac:	eb 05                	jmp    801eb3 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801eae:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ebb:	e8 5b fc ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801ec0:	83 ec 08             	sub    $0x8,%esp
  801ec3:	ff 75 0c             	pushl  0xc(%ebp)
  801ec6:	ff 75 08             	pushl  0x8(%ebp)
  801ec9:	e8 1d 04 00 00       	call   8022eb <sys_getSizeOfSharedObject>
  801ece:	83 c4 10             	add    $0x10,%esp
  801ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed8:	75 0a                	jne    801ee4 <sget+0x2f>
			return NULL ;
  801eda:	b8 00 00 00 00       	mov    $0x0,%eax
  801edf:	e9 83 00 00 00       	jmp    801f67 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801ee4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801eeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef1:	01 d0                	add    %edx,%eax
  801ef3:	48                   	dec    %eax
  801ef4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801efa:	ba 00 00 00 00       	mov    $0x0,%edx
  801eff:	f7 75 f0             	divl   -0x10(%ebp)
  801f02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f05:	29 d0                	sub    %edx,%eax
  801f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f0a:	e8 2d 06 00 00       	call   80253c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f0f:	85 c0                	test   %eax,%eax
  801f11:	74 4f                	je     801f62 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	83 ec 0c             	sub    $0xc,%esp
  801f19:	50                   	push   %eax
  801f1a:	e8 2e 0d 00 00       	call   802c4d <alloc_block_FF>
  801f1f:	83 c4 10             	add    $0x10,%esp
  801f22:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801f25:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f29:	75 07                	jne    801f32 <sget+0x7d>
					return (void*)NULL ;
  801f2b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f30:	eb 35                	jmp    801f67 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801f32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f35:	8b 40 08             	mov    0x8(%eax),%eax
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	50                   	push   %eax
  801f3c:	ff 75 0c             	pushl  0xc(%ebp)
  801f3f:	ff 75 08             	pushl  0x8(%ebp)
  801f42:	e8 c1 03 00 00       	call   802308 <sys_getSharedObject>
  801f47:	83 c4 10             	add    $0x10,%esp
  801f4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801f4d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f51:	79 07                	jns    801f5a <sget+0xa5>
				return (void*)NULL ;
  801f53:	b8 00 00 00 00       	mov    $0x0,%eax
  801f58:	eb 0d                	jmp    801f67 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801f5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f5d:	8b 40 08             	mov    0x8(%eax),%eax
  801f60:	eb 05                	jmp    801f67 <sget+0xb2>


		}
	return (void*)NULL ;
  801f62:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f67:	c9                   	leave  
  801f68:	c3                   	ret    

00801f69 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f69:	55                   	push   %ebp
  801f6a:	89 e5                	mov    %esp,%ebp
  801f6c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f6f:	e8 a7 fb ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f74:	83 ec 04             	sub    $0x4,%esp
  801f77:	68 34 42 80 00       	push   $0x804234
  801f7c:	68 f9 00 00 00       	push   $0xf9
  801f81:	68 27 42 80 00       	push   $0x804227
  801f86:	e8 4c e9 ff ff       	call   8008d7 <_panic>

00801f8b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f91:	83 ec 04             	sub    $0x4,%esp
  801f94:	68 5c 42 80 00       	push   $0x80425c
  801f99:	68 0d 01 00 00       	push   $0x10d
  801f9e:	68 27 42 80 00       	push   $0x804227
  801fa3:	e8 2f e9 ff ff       	call   8008d7 <_panic>

00801fa8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fae:	83 ec 04             	sub    $0x4,%esp
  801fb1:	68 80 42 80 00       	push   $0x804280
  801fb6:	68 18 01 00 00       	push   $0x118
  801fbb:	68 27 42 80 00       	push   $0x804227
  801fc0:	e8 12 e9 ff ff       	call   8008d7 <_panic>

00801fc5 <shrink>:

}
void shrink(uint32 newSize)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fcb:	83 ec 04             	sub    $0x4,%esp
  801fce:	68 80 42 80 00       	push   $0x804280
  801fd3:	68 1d 01 00 00       	push   $0x11d
  801fd8:	68 27 42 80 00       	push   $0x804227
  801fdd:	e8 f5 e8 ff ff       	call   8008d7 <_panic>

00801fe2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
  801fe5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	68 80 42 80 00       	push   $0x804280
  801ff0:	68 22 01 00 00       	push   $0x122
  801ff5:	68 27 42 80 00       	push   $0x804227
  801ffa:	e8 d8 e8 ff ff       	call   8008d7 <_panic>

00801fff <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
  802002:	57                   	push   %edi
  802003:	56                   	push   %esi
  802004:	53                   	push   %ebx
  802005:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802011:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802014:	8b 7d 18             	mov    0x18(%ebp),%edi
  802017:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80201a:	cd 30                	int    $0x30
  80201c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80201f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802022:	83 c4 10             	add    $0x10,%esp
  802025:	5b                   	pop    %ebx
  802026:	5e                   	pop    %esi
  802027:	5f                   	pop    %edi
  802028:	5d                   	pop    %ebp
  802029:	c3                   	ret    

0080202a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 04             	sub    $0x4,%esp
  802030:	8b 45 10             	mov    0x10(%ebp),%eax
  802033:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802036:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	52                   	push   %edx
  802042:	ff 75 0c             	pushl  0xc(%ebp)
  802045:	50                   	push   %eax
  802046:	6a 00                	push   $0x0
  802048:	e8 b2 ff ff ff       	call   801fff <syscall>
  80204d:	83 c4 18             	add    $0x18,%esp
}
  802050:	90                   	nop
  802051:	c9                   	leave  
  802052:	c3                   	ret    

00802053 <sys_cgetc>:

int
sys_cgetc(void)
{
  802053:	55                   	push   %ebp
  802054:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 01                	push   $0x1
  802062:	e8 98 ff ff ff       	call   801fff <syscall>
  802067:	83 c4 18             	add    $0x18,%esp
}
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80206f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	6a 00                	push   $0x0
  802077:	6a 00                	push   $0x0
  802079:	6a 00                	push   $0x0
  80207b:	52                   	push   %edx
  80207c:	50                   	push   %eax
  80207d:	6a 05                	push   $0x5
  80207f:	e8 7b ff ff ff       	call   801fff <syscall>
  802084:	83 c4 18             	add    $0x18,%esp
}
  802087:	c9                   	leave  
  802088:	c3                   	ret    

00802089 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802089:	55                   	push   %ebp
  80208a:	89 e5                	mov    %esp,%ebp
  80208c:	56                   	push   %esi
  80208d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80208e:	8b 75 18             	mov    0x18(%ebp),%esi
  802091:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802094:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802097:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	56                   	push   %esi
  80209e:	53                   	push   %ebx
  80209f:	51                   	push   %ecx
  8020a0:	52                   	push   %edx
  8020a1:	50                   	push   %eax
  8020a2:	6a 06                	push   $0x6
  8020a4:	e8 56 ff ff ff       	call   801fff <syscall>
  8020a9:	83 c4 18             	add    $0x18,%esp
}
  8020ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020af:	5b                   	pop    %ebx
  8020b0:	5e                   	pop    %esi
  8020b1:	5d                   	pop    %ebp
  8020b2:	c3                   	ret    

008020b3 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8020b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	52                   	push   %edx
  8020c3:	50                   	push   %eax
  8020c4:	6a 07                	push   $0x7
  8020c6:	e8 34 ff ff ff       	call   801fff <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	ff 75 0c             	pushl  0xc(%ebp)
  8020dc:	ff 75 08             	pushl  0x8(%ebp)
  8020df:	6a 08                	push   $0x8
  8020e1:	e8 19 ff ff ff       	call   801fff <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 09                	push   $0x9
  8020fa:	e8 00 ff ff ff       	call   801fff <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
}
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 0a                	push   $0xa
  802113:	e8 e7 fe ff ff       	call   801fff <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	c9                   	leave  
  80211c:	c3                   	ret    

0080211d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80211d:	55                   	push   %ebp
  80211e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 0b                	push   $0xb
  80212c:	e8 ce fe ff ff       	call   801fff <syscall>
  802131:	83 c4 18             	add    $0x18,%esp
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	ff 75 0c             	pushl  0xc(%ebp)
  802142:	ff 75 08             	pushl  0x8(%ebp)
  802145:	6a 0f                	push   $0xf
  802147:	e8 b3 fe ff ff       	call   801fff <syscall>
  80214c:	83 c4 18             	add    $0x18,%esp
	return;
  80214f:	90                   	nop
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	ff 75 0c             	pushl  0xc(%ebp)
  80215e:	ff 75 08             	pushl  0x8(%ebp)
  802161:	6a 10                	push   $0x10
  802163:	e8 97 fe ff ff       	call   801fff <syscall>
  802168:	83 c4 18             	add    $0x18,%esp
	return ;
  80216b:	90                   	nop
}
  80216c:	c9                   	leave  
  80216d:	c3                   	ret    

0080216e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80216e:	55                   	push   %ebp
  80216f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	ff 75 10             	pushl  0x10(%ebp)
  802178:	ff 75 0c             	pushl  0xc(%ebp)
  80217b:	ff 75 08             	pushl  0x8(%ebp)
  80217e:	6a 11                	push   $0x11
  802180:	e8 7a fe ff ff       	call   801fff <syscall>
  802185:	83 c4 18             	add    $0x18,%esp
	return ;
  802188:	90                   	nop
}
  802189:	c9                   	leave  
  80218a:	c3                   	ret    

0080218b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80218b:	55                   	push   %ebp
  80218c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 0c                	push   $0xc
  80219a:	e8 60 fe ff ff       	call   801fff <syscall>
  80219f:	83 c4 18             	add    $0x18,%esp
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	6a 00                	push   $0x0
  8021af:	ff 75 08             	pushl  0x8(%ebp)
  8021b2:	6a 0d                	push   $0xd
  8021b4:	e8 46 fe ff ff       	call   801fff <syscall>
  8021b9:	83 c4 18             	add    $0x18,%esp
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <sys_scarce_memory>:

void sys_scarce_memory()
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 0e                	push   $0xe
  8021cd:	e8 2d fe ff ff       	call   801fff <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
}
  8021d5:	90                   	nop
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8021db:	6a 00                	push   $0x0
  8021dd:	6a 00                	push   $0x0
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 13                	push   $0x13
  8021e7:	e8 13 fe ff ff       	call   801fff <syscall>
  8021ec:	83 c4 18             	add    $0x18,%esp
}
  8021ef:	90                   	nop
  8021f0:	c9                   	leave  
  8021f1:	c3                   	ret    

008021f2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 14                	push   $0x14
  802201:	e8 f9 fd ff ff       	call   801fff <syscall>
  802206:	83 c4 18             	add    $0x18,%esp
}
  802209:	90                   	nop
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <sys_cputc>:


void
sys_cputc(const char c)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 04             	sub    $0x4,%esp
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802218:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	50                   	push   %eax
  802225:	6a 15                	push   $0x15
  802227:	e8 d3 fd ff ff       	call   801fff <syscall>
  80222c:	83 c4 18             	add    $0x18,%esp
}
  80222f:	90                   	nop
  802230:	c9                   	leave  
  802231:	c3                   	ret    

00802232 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802235:	6a 00                	push   $0x0
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 16                	push   $0x16
  802241:	e8 b9 fd ff ff       	call   801fff <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
}
  802249:	90                   	nop
  80224a:	c9                   	leave  
  80224b:	c3                   	ret    

0080224c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80224f:	8b 45 08             	mov    0x8(%ebp),%eax
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	ff 75 0c             	pushl  0xc(%ebp)
  80225b:	50                   	push   %eax
  80225c:	6a 17                	push   $0x17
  80225e:	e8 9c fd ff ff       	call   801fff <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80226b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226e:	8b 45 08             	mov    0x8(%ebp),%eax
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	52                   	push   %edx
  802278:	50                   	push   %eax
  802279:	6a 1a                	push   $0x1a
  80227b:	e8 7f fd ff ff       	call   801fff <syscall>
  802280:	83 c4 18             	add    $0x18,%esp
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802288:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	52                   	push   %edx
  802295:	50                   	push   %eax
  802296:	6a 18                	push   $0x18
  802298:	e8 62 fd ff ff       	call   801fff <syscall>
  80229d:	83 c4 18             	add    $0x18,%esp
}
  8022a0:	90                   	nop
  8022a1:	c9                   	leave  
  8022a2:	c3                   	ret    

008022a3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8022a3:	55                   	push   %ebp
  8022a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8022a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	52                   	push   %edx
  8022b3:	50                   	push   %eax
  8022b4:	6a 19                	push   $0x19
  8022b6:	e8 44 fd ff ff       	call   801fff <syscall>
  8022bb:	83 c4 18             	add    $0x18,%esp
}
  8022be:	90                   	nop
  8022bf:	c9                   	leave  
  8022c0:	c3                   	ret    

008022c1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	83 ec 04             	sub    $0x4,%esp
  8022c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ca:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8022cd:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8022d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	6a 00                	push   $0x0
  8022d9:	51                   	push   %ecx
  8022da:	52                   	push   %edx
  8022db:	ff 75 0c             	pushl  0xc(%ebp)
  8022de:	50                   	push   %eax
  8022df:	6a 1b                	push   $0x1b
  8022e1:	e8 19 fd ff ff       	call   801fff <syscall>
  8022e6:	83 c4 18             	add    $0x18,%esp
}
  8022e9:	c9                   	leave  
  8022ea:	c3                   	ret    

008022eb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8022eb:	55                   	push   %ebp
  8022ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8022ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	52                   	push   %edx
  8022fb:	50                   	push   %eax
  8022fc:	6a 1c                	push   $0x1c
  8022fe:	e8 fc fc ff ff       	call   801fff <syscall>
  802303:	83 c4 18             	add    $0x18,%esp
}
  802306:	c9                   	leave  
  802307:	c3                   	ret    

00802308 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802308:	55                   	push   %ebp
  802309:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80230b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80230e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	51                   	push   %ecx
  802319:	52                   	push   %edx
  80231a:	50                   	push   %eax
  80231b:	6a 1d                	push   $0x1d
  80231d:	e8 dd fc ff ff       	call   801fff <syscall>
  802322:	83 c4 18             	add    $0x18,%esp
}
  802325:	c9                   	leave  
  802326:	c3                   	ret    

00802327 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80232a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	52                   	push   %edx
  802337:	50                   	push   %eax
  802338:	6a 1e                	push   $0x1e
  80233a:	e8 c0 fc ff ff       	call   801fff <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
}
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 00                	push   $0x0
  802351:	6a 1f                	push   $0x1f
  802353:	e8 a7 fc ff ff       	call   801fff <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	6a 00                	push   $0x0
  802365:	ff 75 14             	pushl  0x14(%ebp)
  802368:	ff 75 10             	pushl  0x10(%ebp)
  80236b:	ff 75 0c             	pushl  0xc(%ebp)
  80236e:	50                   	push   %eax
  80236f:	6a 20                	push   $0x20
  802371:	e8 89 fc ff ff       	call   801fff <syscall>
  802376:	83 c4 18             	add    $0x18,%esp
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	50                   	push   %eax
  80238a:	6a 21                	push   $0x21
  80238c:	e8 6e fc ff ff       	call   801fff <syscall>
  802391:	83 c4 18             	add    $0x18,%esp
}
  802394:	90                   	nop
  802395:	c9                   	leave  
  802396:	c3                   	ret    

00802397 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802397:	55                   	push   %ebp
  802398:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	50                   	push   %eax
  8023a6:	6a 22                	push   $0x22
  8023a8:	e8 52 fc ff ff       	call   801fff <syscall>
  8023ad:	83 c4 18             	add    $0x18,%esp
}
  8023b0:	c9                   	leave  
  8023b1:	c3                   	ret    

008023b2 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8023b2:	55                   	push   %ebp
  8023b3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 00                	push   $0x0
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 02                	push   $0x2
  8023c1:	e8 39 fc ff ff       	call   801fff <syscall>
  8023c6:	83 c4 18             	add    $0x18,%esp
}
  8023c9:	c9                   	leave  
  8023ca:	c3                   	ret    

008023cb <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8023cb:	55                   	push   %ebp
  8023cc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	6a 00                	push   $0x0
  8023d4:	6a 00                	push   $0x0
  8023d6:	6a 00                	push   $0x0
  8023d8:	6a 03                	push   $0x3
  8023da:	e8 20 fc ff ff       	call   801fff <syscall>
  8023df:	83 c4 18             	add    $0x18,%esp
}
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	6a 04                	push   $0x4
  8023f3:	e8 07 fc ff ff       	call   801fff <syscall>
  8023f8:	83 c4 18             	add    $0x18,%esp
}
  8023fb:	c9                   	leave  
  8023fc:	c3                   	ret    

008023fd <sys_exit_env>:


void sys_exit_env(void)
{
  8023fd:	55                   	push   %ebp
  8023fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	6a 00                	push   $0x0
  802408:	6a 00                	push   $0x0
  80240a:	6a 23                	push   $0x23
  80240c:	e8 ee fb ff ff       	call   801fff <syscall>
  802411:	83 c4 18             	add    $0x18,%esp
}
  802414:	90                   	nop
  802415:	c9                   	leave  
  802416:	c3                   	ret    

00802417 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802417:	55                   	push   %ebp
  802418:	89 e5                	mov    %esp,%ebp
  80241a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80241d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802420:	8d 50 04             	lea    0x4(%eax),%edx
  802423:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802426:	6a 00                	push   $0x0
  802428:	6a 00                	push   $0x0
  80242a:	6a 00                	push   $0x0
  80242c:	52                   	push   %edx
  80242d:	50                   	push   %eax
  80242e:	6a 24                	push   $0x24
  802430:	e8 ca fb ff ff       	call   801fff <syscall>
  802435:	83 c4 18             	add    $0x18,%esp
	return result;
  802438:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80243b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80243e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802441:	89 01                	mov    %eax,(%ecx)
  802443:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	c9                   	leave  
  80244a:	c2 04 00             	ret    $0x4

0080244d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80244d:	55                   	push   %ebp
  80244e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	ff 75 10             	pushl  0x10(%ebp)
  802457:	ff 75 0c             	pushl  0xc(%ebp)
  80245a:	ff 75 08             	pushl  0x8(%ebp)
  80245d:	6a 12                	push   $0x12
  80245f:	e8 9b fb ff ff       	call   801fff <syscall>
  802464:	83 c4 18             	add    $0x18,%esp
	return ;
  802467:	90                   	nop
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <sys_rcr2>:
uint32 sys_rcr2()
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80246d:	6a 00                	push   $0x0
  80246f:	6a 00                	push   $0x0
  802471:	6a 00                	push   $0x0
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 25                	push   $0x25
  802479:	e8 81 fb ff ff       	call   801fff <syscall>
  80247e:	83 c4 18             	add    $0x18,%esp
}
  802481:	c9                   	leave  
  802482:	c3                   	ret    

00802483 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	83 ec 04             	sub    $0x4,%esp
  802489:	8b 45 08             	mov    0x8(%ebp),%eax
  80248c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80248f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802493:	6a 00                	push   $0x0
  802495:	6a 00                	push   $0x0
  802497:	6a 00                	push   $0x0
  802499:	6a 00                	push   $0x0
  80249b:	50                   	push   %eax
  80249c:	6a 26                	push   $0x26
  80249e:	e8 5c fb ff ff       	call   801fff <syscall>
  8024a3:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a6:	90                   	nop
}
  8024a7:	c9                   	leave  
  8024a8:	c3                   	ret    

008024a9 <rsttst>:
void rsttst()
{
  8024a9:	55                   	push   %ebp
  8024aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 28                	push   $0x28
  8024b8:	e8 42 fb ff ff       	call   801fff <syscall>
  8024bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8024c0:	90                   	nop
}
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	83 ec 04             	sub    $0x4,%esp
  8024c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8024cc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8024cf:	8b 55 18             	mov    0x18(%ebp),%edx
  8024d2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024d6:	52                   	push   %edx
  8024d7:	50                   	push   %eax
  8024d8:	ff 75 10             	pushl  0x10(%ebp)
  8024db:	ff 75 0c             	pushl  0xc(%ebp)
  8024de:	ff 75 08             	pushl  0x8(%ebp)
  8024e1:	6a 27                	push   $0x27
  8024e3:	e8 17 fb ff ff       	call   801fff <syscall>
  8024e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8024eb:	90                   	nop
}
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <chktst>:
void chktst(uint32 n)
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	ff 75 08             	pushl  0x8(%ebp)
  8024fc:	6a 29                	push   $0x29
  8024fe:	e8 fc fa ff ff       	call   801fff <syscall>
  802503:	83 c4 18             	add    $0x18,%esp
	return ;
  802506:	90                   	nop
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <inctst>:

void inctst()
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 2a                	push   $0x2a
  802518:	e8 e2 fa ff ff       	call   801fff <syscall>
  80251d:	83 c4 18             	add    $0x18,%esp
	return ;
  802520:	90                   	nop
}
  802521:	c9                   	leave  
  802522:	c3                   	ret    

00802523 <gettst>:
uint32 gettst()
{
  802523:	55                   	push   %ebp
  802524:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802526:	6a 00                	push   $0x0
  802528:	6a 00                	push   $0x0
  80252a:	6a 00                	push   $0x0
  80252c:	6a 00                	push   $0x0
  80252e:	6a 00                	push   $0x0
  802530:	6a 2b                	push   $0x2b
  802532:	e8 c8 fa ff ff       	call   801fff <syscall>
  802537:	83 c4 18             	add    $0x18,%esp
}
  80253a:	c9                   	leave  
  80253b:	c3                   	ret    

0080253c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80253c:	55                   	push   %ebp
  80253d:	89 e5                	mov    %esp,%ebp
  80253f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	6a 2c                	push   $0x2c
  80254e:	e8 ac fa ff ff       	call   801fff <syscall>
  802553:	83 c4 18             	add    $0x18,%esp
  802556:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802559:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80255d:	75 07                	jne    802566 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80255f:	b8 01 00 00 00       	mov    $0x1,%eax
  802564:	eb 05                	jmp    80256b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802566:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80256b:	c9                   	leave  
  80256c:	c3                   	ret    

0080256d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80256d:	55                   	push   %ebp
  80256e:	89 e5                	mov    %esp,%ebp
  802570:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802573:	6a 00                	push   $0x0
  802575:	6a 00                	push   $0x0
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 2c                	push   $0x2c
  80257f:	e8 7b fa ff ff       	call   801fff <syscall>
  802584:	83 c4 18             	add    $0x18,%esp
  802587:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80258a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80258e:	75 07                	jne    802597 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802590:	b8 01 00 00 00       	mov    $0x1,%eax
  802595:	eb 05                	jmp    80259c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802597:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259c:	c9                   	leave  
  80259d:	c3                   	ret    

0080259e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80259e:	55                   	push   %ebp
  80259f:	89 e5                	mov    %esp,%ebp
  8025a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	6a 00                	push   $0x0
  8025ac:	6a 00                	push   $0x0
  8025ae:	6a 2c                	push   $0x2c
  8025b0:	e8 4a fa ff ff       	call   801fff <syscall>
  8025b5:	83 c4 18             	add    $0x18,%esp
  8025b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8025bb:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8025bf:	75 07                	jne    8025c8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8025c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c6:	eb 05                	jmp    8025cd <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8025c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025cd:	c9                   	leave  
  8025ce:	c3                   	ret    

008025cf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
  8025d2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 2c                	push   $0x2c
  8025e1:	e8 19 fa ff ff       	call   801fff <syscall>
  8025e6:	83 c4 18             	add    $0x18,%esp
  8025e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025ec:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025f0:	75 07                	jne    8025f9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f7:	eb 05                	jmp    8025fe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025fe:	c9                   	leave  
  8025ff:	c3                   	ret    

00802600 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	6a 00                	push   $0x0
  80260b:	ff 75 08             	pushl  0x8(%ebp)
  80260e:	6a 2d                	push   $0x2d
  802610:	e8 ea f9 ff ff       	call   801fff <syscall>
  802615:	83 c4 18             	add    $0x18,%esp
	return ;
  802618:	90                   	nop
}
  802619:	c9                   	leave  
  80261a:	c3                   	ret    

0080261b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80261b:	55                   	push   %ebp
  80261c:	89 e5                	mov    %esp,%ebp
  80261e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80261f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802622:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802625:	8b 55 0c             	mov    0xc(%ebp),%edx
  802628:	8b 45 08             	mov    0x8(%ebp),%eax
  80262b:	6a 00                	push   $0x0
  80262d:	53                   	push   %ebx
  80262e:	51                   	push   %ecx
  80262f:	52                   	push   %edx
  802630:	50                   	push   %eax
  802631:	6a 2e                	push   $0x2e
  802633:	e8 c7 f9 ff ff       	call   801fff <syscall>
  802638:	83 c4 18             	add    $0x18,%esp
}
  80263b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80263e:	c9                   	leave  
  80263f:	c3                   	ret    

00802640 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802643:	8b 55 0c             	mov    0xc(%ebp),%edx
  802646:	8b 45 08             	mov    0x8(%ebp),%eax
  802649:	6a 00                	push   $0x0
  80264b:	6a 00                	push   $0x0
  80264d:	6a 00                	push   $0x0
  80264f:	52                   	push   %edx
  802650:	50                   	push   %eax
  802651:	6a 2f                	push   $0x2f
  802653:	e8 a7 f9 ff ff       	call   801fff <syscall>
  802658:	83 c4 18             	add    $0x18,%esp
}
  80265b:	c9                   	leave  
  80265c:	c3                   	ret    

0080265d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80265d:	55                   	push   %ebp
  80265e:	89 e5                	mov    %esp,%ebp
  802660:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802663:	83 ec 0c             	sub    $0xc,%esp
  802666:	68 90 42 80 00       	push   $0x804290
  80266b:	e8 1b e5 ff ff       	call   800b8b <cprintf>
  802670:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802673:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80267a:	83 ec 0c             	sub    $0xc,%esp
  80267d:	68 bc 42 80 00       	push   $0x8042bc
  802682:	e8 04 e5 ff ff       	call   800b8b <cprintf>
  802687:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80268a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80268e:	a1 38 51 80 00       	mov    0x805138,%eax
  802693:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802696:	eb 56                	jmp    8026ee <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802698:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80269c:	74 1c                	je     8026ba <print_mem_block_lists+0x5d>
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 50 08             	mov    0x8(%eax),%edx
  8026a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a7:	8b 48 08             	mov    0x8(%eax),%ecx
  8026aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b0:	01 c8                	add    %ecx,%eax
  8026b2:	39 c2                	cmp    %eax,%edx
  8026b4:	73 04                	jae    8026ba <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8026b6:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 50 08             	mov    0x8(%eax),%edx
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c6:	01 c2                	add    %eax,%edx
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 40 08             	mov    0x8(%eax),%eax
  8026ce:	83 ec 04             	sub    $0x4,%esp
  8026d1:	52                   	push   %edx
  8026d2:	50                   	push   %eax
  8026d3:	68 d1 42 80 00       	push   $0x8042d1
  8026d8:	e8 ae e4 ff ff       	call   800b8b <cprintf>
  8026dd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8026eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f2:	74 07                	je     8026fb <print_mem_block_lists+0x9e>
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 00                	mov    (%eax),%eax
  8026f9:	eb 05                	jmp    802700 <print_mem_block_lists+0xa3>
  8026fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802700:	a3 40 51 80 00       	mov    %eax,0x805140
  802705:	a1 40 51 80 00       	mov    0x805140,%eax
  80270a:	85 c0                	test   %eax,%eax
  80270c:	75 8a                	jne    802698 <print_mem_block_lists+0x3b>
  80270e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802712:	75 84                	jne    802698 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802714:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802718:	75 10                	jne    80272a <print_mem_block_lists+0xcd>
  80271a:	83 ec 0c             	sub    $0xc,%esp
  80271d:	68 e0 42 80 00       	push   $0x8042e0
  802722:	e8 64 e4 ff ff       	call   800b8b <cprintf>
  802727:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80272a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802731:	83 ec 0c             	sub    $0xc,%esp
  802734:	68 04 43 80 00       	push   $0x804304
  802739:	e8 4d e4 ff ff       	call   800b8b <cprintf>
  80273e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802741:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802745:	a1 40 50 80 00       	mov    0x805040,%eax
  80274a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274d:	eb 56                	jmp    8027a5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80274f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802753:	74 1c                	je     802771 <print_mem_block_lists+0x114>
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	8b 50 08             	mov    0x8(%eax),%edx
  80275b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275e:	8b 48 08             	mov    0x8(%eax),%ecx
  802761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802764:	8b 40 0c             	mov    0xc(%eax),%eax
  802767:	01 c8                	add    %ecx,%eax
  802769:	39 c2                	cmp    %eax,%edx
  80276b:	73 04                	jae    802771 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80276d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 50 08             	mov    0x8(%eax),%edx
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 40 0c             	mov    0xc(%eax),%eax
  80277d:	01 c2                	add    %eax,%edx
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 40 08             	mov    0x8(%eax),%eax
  802785:	83 ec 04             	sub    $0x4,%esp
  802788:	52                   	push   %edx
  802789:	50                   	push   %eax
  80278a:	68 d1 42 80 00       	push   $0x8042d1
  80278f:	e8 f7 e3 ff ff       	call   800b8b <cprintf>
  802794:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80279d:	a1 48 50 80 00       	mov    0x805048,%eax
  8027a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a9:	74 07                	je     8027b2 <print_mem_block_lists+0x155>
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 00                	mov    (%eax),%eax
  8027b0:	eb 05                	jmp    8027b7 <print_mem_block_lists+0x15a>
  8027b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b7:	a3 48 50 80 00       	mov    %eax,0x805048
  8027bc:	a1 48 50 80 00       	mov    0x805048,%eax
  8027c1:	85 c0                	test   %eax,%eax
  8027c3:	75 8a                	jne    80274f <print_mem_block_lists+0xf2>
  8027c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c9:	75 84                	jne    80274f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8027cb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027cf:	75 10                	jne    8027e1 <print_mem_block_lists+0x184>
  8027d1:	83 ec 0c             	sub    $0xc,%esp
  8027d4:	68 1c 43 80 00       	push   $0x80431c
  8027d9:	e8 ad e3 ff ff       	call   800b8b <cprintf>
  8027de:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8027e1:	83 ec 0c             	sub    $0xc,%esp
  8027e4:	68 90 42 80 00       	push   $0x804290
  8027e9:	e8 9d e3 ff ff       	call   800b8b <cprintf>
  8027ee:	83 c4 10             	add    $0x10,%esp

}
  8027f1:	90                   	nop
  8027f2:	c9                   	leave  
  8027f3:	c3                   	ret    

008027f4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8027f4:	55                   	push   %ebp
  8027f5:	89 e5                	mov    %esp,%ebp
  8027f7:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8027fa:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802801:	00 00 00 
  802804:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80280b:	00 00 00 
  80280e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802815:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802818:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80281f:	e9 9e 00 00 00       	jmp    8028c2 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802824:	a1 50 50 80 00       	mov    0x805050,%eax
  802829:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282c:	c1 e2 04             	shl    $0x4,%edx
  80282f:	01 d0                	add    %edx,%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	75 14                	jne    802849 <initialize_MemBlocksList+0x55>
  802835:	83 ec 04             	sub    $0x4,%esp
  802838:	68 44 43 80 00       	push   $0x804344
  80283d:	6a 43                	push   $0x43
  80283f:	68 67 43 80 00       	push   $0x804367
  802844:	e8 8e e0 ff ff       	call   8008d7 <_panic>
  802849:	a1 50 50 80 00       	mov    0x805050,%eax
  80284e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802851:	c1 e2 04             	shl    $0x4,%edx
  802854:	01 d0                	add    %edx,%eax
  802856:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80285c:	89 10                	mov    %edx,(%eax)
  80285e:	8b 00                	mov    (%eax),%eax
  802860:	85 c0                	test   %eax,%eax
  802862:	74 18                	je     80287c <initialize_MemBlocksList+0x88>
  802864:	a1 48 51 80 00       	mov    0x805148,%eax
  802869:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80286f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802872:	c1 e1 04             	shl    $0x4,%ecx
  802875:	01 ca                	add    %ecx,%edx
  802877:	89 50 04             	mov    %edx,0x4(%eax)
  80287a:	eb 12                	jmp    80288e <initialize_MemBlocksList+0x9a>
  80287c:	a1 50 50 80 00       	mov    0x805050,%eax
  802881:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802884:	c1 e2 04             	shl    $0x4,%edx
  802887:	01 d0                	add    %edx,%eax
  802889:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80288e:	a1 50 50 80 00       	mov    0x805050,%eax
  802893:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802896:	c1 e2 04             	shl    $0x4,%edx
  802899:	01 d0                	add    %edx,%eax
  80289b:	a3 48 51 80 00       	mov    %eax,0x805148
  8028a0:	a1 50 50 80 00       	mov    0x805050,%eax
  8028a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a8:	c1 e2 04             	shl    $0x4,%edx
  8028ab:	01 d0                	add    %edx,%eax
  8028ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8028b9:	40                   	inc    %eax
  8028ba:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8028bf:	ff 45 f4             	incl   -0xc(%ebp)
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c8:	0f 82 56 ff ff ff    	jb     802824 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8028ce:	90                   	nop
  8028cf:	c9                   	leave  
  8028d0:	c3                   	ret    

008028d1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8028d1:	55                   	push   %ebp
  8028d2:	89 e5                	mov    %esp,%ebp
  8028d4:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8028d7:	a1 38 51 80 00       	mov    0x805138,%eax
  8028dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028df:	eb 18                	jmp    8028f9 <find_block+0x28>
	{
		if (ele->sva==va)
  8028e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028e4:	8b 40 08             	mov    0x8(%eax),%eax
  8028e7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8028ea:	75 05                	jne    8028f1 <find_block+0x20>
			return ele;
  8028ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028ef:	eb 7b                	jmp    80296c <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8028f1:	a1 40 51 80 00       	mov    0x805140,%eax
  8028f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028fd:	74 07                	je     802906 <find_block+0x35>
  8028ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802902:	8b 00                	mov    (%eax),%eax
  802904:	eb 05                	jmp    80290b <find_block+0x3a>
  802906:	b8 00 00 00 00       	mov    $0x0,%eax
  80290b:	a3 40 51 80 00       	mov    %eax,0x805140
  802910:	a1 40 51 80 00       	mov    0x805140,%eax
  802915:	85 c0                	test   %eax,%eax
  802917:	75 c8                	jne    8028e1 <find_block+0x10>
  802919:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80291d:	75 c2                	jne    8028e1 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80291f:	a1 40 50 80 00       	mov    0x805040,%eax
  802924:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802927:	eb 18                	jmp    802941 <find_block+0x70>
	{
		if (ele->sva==va)
  802929:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80292c:	8b 40 08             	mov    0x8(%eax),%eax
  80292f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802932:	75 05                	jne    802939 <find_block+0x68>
					return ele;
  802934:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802937:	eb 33                	jmp    80296c <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802939:	a1 48 50 80 00       	mov    0x805048,%eax
  80293e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802941:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802945:	74 07                	je     80294e <find_block+0x7d>
  802947:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80294a:	8b 00                	mov    (%eax),%eax
  80294c:	eb 05                	jmp    802953 <find_block+0x82>
  80294e:	b8 00 00 00 00       	mov    $0x0,%eax
  802953:	a3 48 50 80 00       	mov    %eax,0x805048
  802958:	a1 48 50 80 00       	mov    0x805048,%eax
  80295d:	85 c0                	test   %eax,%eax
  80295f:	75 c8                	jne    802929 <find_block+0x58>
  802961:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802965:	75 c2                	jne    802929 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802967:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80296c:	c9                   	leave  
  80296d:	c3                   	ret    

0080296e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
  802971:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802974:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802979:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80297c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802980:	75 62                	jne    8029e4 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802982:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802986:	75 14                	jne    80299c <insert_sorted_allocList+0x2e>
  802988:	83 ec 04             	sub    $0x4,%esp
  80298b:	68 44 43 80 00       	push   $0x804344
  802990:	6a 69                	push   $0x69
  802992:	68 67 43 80 00       	push   $0x804367
  802997:	e8 3b df ff ff       	call   8008d7 <_panic>
  80299c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a5:	89 10                	mov    %edx,(%eax)
  8029a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029aa:	8b 00                	mov    (%eax),%eax
  8029ac:	85 c0                	test   %eax,%eax
  8029ae:	74 0d                	je     8029bd <insert_sorted_allocList+0x4f>
  8029b0:	a1 40 50 80 00       	mov    0x805040,%eax
  8029b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b8:	89 50 04             	mov    %edx,0x4(%eax)
  8029bb:	eb 08                	jmp    8029c5 <insert_sorted_allocList+0x57>
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	a3 44 50 80 00       	mov    %eax,0x805044
  8029c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c8:	a3 40 50 80 00       	mov    %eax,0x805040
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029dc:	40                   	inc    %eax
  8029dd:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8029e2:	eb 72                	jmp    802a56 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8029e4:	a1 40 50 80 00       	mov    0x805040,%eax
  8029e9:	8b 50 08             	mov    0x8(%eax),%edx
  8029ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ef:	8b 40 08             	mov    0x8(%eax),%eax
  8029f2:	39 c2                	cmp    %eax,%edx
  8029f4:	76 60                	jbe    802a56 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8029f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029fa:	75 14                	jne    802a10 <insert_sorted_allocList+0xa2>
  8029fc:	83 ec 04             	sub    $0x4,%esp
  8029ff:	68 44 43 80 00       	push   $0x804344
  802a04:	6a 6d                	push   $0x6d
  802a06:	68 67 43 80 00       	push   $0x804367
  802a0b:	e8 c7 de ff ff       	call   8008d7 <_panic>
  802a10:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	89 10                	mov    %edx,(%eax)
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	8b 00                	mov    (%eax),%eax
  802a20:	85 c0                	test   %eax,%eax
  802a22:	74 0d                	je     802a31 <insert_sorted_allocList+0xc3>
  802a24:	a1 40 50 80 00       	mov    0x805040,%eax
  802a29:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2c:	89 50 04             	mov    %edx,0x4(%eax)
  802a2f:	eb 08                	jmp    802a39 <insert_sorted_allocList+0xcb>
  802a31:	8b 45 08             	mov    0x8(%ebp),%eax
  802a34:	a3 44 50 80 00       	mov    %eax,0x805044
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	a3 40 50 80 00       	mov    %eax,0x805040
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a50:	40                   	inc    %eax
  802a51:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802a56:	a1 40 50 80 00       	mov    0x805040,%eax
  802a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a5e:	e9 b9 01 00 00       	jmp    802c1c <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	8b 50 08             	mov    0x8(%eax),%edx
  802a69:	a1 40 50 80 00       	mov    0x805040,%eax
  802a6e:	8b 40 08             	mov    0x8(%eax),%eax
  802a71:	39 c2                	cmp    %eax,%edx
  802a73:	76 7c                	jbe    802af1 <insert_sorted_allocList+0x183>
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	8b 50 08             	mov    0x8(%eax),%edx
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 40 08             	mov    0x8(%eax),%eax
  802a81:	39 c2                	cmp    %eax,%edx
  802a83:	73 6c                	jae    802af1 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802a85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a89:	74 06                	je     802a91 <insert_sorted_allocList+0x123>
  802a8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8f:	75 14                	jne    802aa5 <insert_sorted_allocList+0x137>
  802a91:	83 ec 04             	sub    $0x4,%esp
  802a94:	68 80 43 80 00       	push   $0x804380
  802a99:	6a 75                	push   $0x75
  802a9b:	68 67 43 80 00       	push   $0x804367
  802aa0:	e8 32 de ff ff       	call   8008d7 <_panic>
  802aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa8:	8b 50 04             	mov    0x4(%eax),%edx
  802aab:	8b 45 08             	mov    0x8(%ebp),%eax
  802aae:	89 50 04             	mov    %edx,0x4(%eax)
  802ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab7:	89 10                	mov    %edx,(%eax)
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 40 04             	mov    0x4(%eax),%eax
  802abf:	85 c0                	test   %eax,%eax
  802ac1:	74 0d                	je     802ad0 <insert_sorted_allocList+0x162>
  802ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac6:	8b 40 04             	mov    0x4(%eax),%eax
  802ac9:	8b 55 08             	mov    0x8(%ebp),%edx
  802acc:	89 10                	mov    %edx,(%eax)
  802ace:	eb 08                	jmp    802ad8 <insert_sorted_allocList+0x16a>
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	a3 40 50 80 00       	mov    %eax,0x805040
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ade:	89 50 04             	mov    %edx,0x4(%eax)
  802ae1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ae6:	40                   	inc    %eax
  802ae7:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802aec:	e9 59 01 00 00       	jmp    802c4a <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	8b 50 08             	mov    0x8(%eax),%edx
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	8b 40 08             	mov    0x8(%eax),%eax
  802afd:	39 c2                	cmp    %eax,%edx
  802aff:	0f 86 98 00 00 00    	jbe    802b9d <insert_sorted_allocList+0x22f>
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	8b 50 08             	mov    0x8(%eax),%edx
  802b0b:	a1 44 50 80 00       	mov    0x805044,%eax
  802b10:	8b 40 08             	mov    0x8(%eax),%eax
  802b13:	39 c2                	cmp    %eax,%edx
  802b15:	0f 83 82 00 00 00    	jae    802b9d <insert_sorted_allocList+0x22f>
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	8b 50 08             	mov    0x8(%eax),%edx
  802b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	8b 40 08             	mov    0x8(%eax),%eax
  802b29:	39 c2                	cmp    %eax,%edx
  802b2b:	73 70                	jae    802b9d <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802b2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b31:	74 06                	je     802b39 <insert_sorted_allocList+0x1cb>
  802b33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b37:	75 14                	jne    802b4d <insert_sorted_allocList+0x1df>
  802b39:	83 ec 04             	sub    $0x4,%esp
  802b3c:	68 b8 43 80 00       	push   $0x8043b8
  802b41:	6a 7c                	push   $0x7c
  802b43:	68 67 43 80 00       	push   $0x804367
  802b48:	e8 8a dd ff ff       	call   8008d7 <_panic>
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	8b 10                	mov    (%eax),%edx
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	89 10                	mov    %edx,(%eax)
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	8b 00                	mov    (%eax),%eax
  802b5c:	85 c0                	test   %eax,%eax
  802b5e:	74 0b                	je     802b6b <insert_sorted_allocList+0x1fd>
  802b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b63:	8b 00                	mov    (%eax),%eax
  802b65:	8b 55 08             	mov    0x8(%ebp),%edx
  802b68:	89 50 04             	mov    %edx,0x4(%eax)
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b71:	89 10                	mov    %edx,(%eax)
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b79:	89 50 04             	mov    %edx,0x4(%eax)
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	8b 00                	mov    (%eax),%eax
  802b81:	85 c0                	test   %eax,%eax
  802b83:	75 08                	jne    802b8d <insert_sorted_allocList+0x21f>
  802b85:	8b 45 08             	mov    0x8(%ebp),%eax
  802b88:	a3 44 50 80 00       	mov    %eax,0x805044
  802b8d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b92:	40                   	inc    %eax
  802b93:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802b98:	e9 ad 00 00 00       	jmp    802c4a <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	8b 50 08             	mov    0x8(%eax),%edx
  802ba3:	a1 44 50 80 00       	mov    0x805044,%eax
  802ba8:	8b 40 08             	mov    0x8(%eax),%eax
  802bab:	39 c2                	cmp    %eax,%edx
  802bad:	76 65                	jbe    802c14 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802baf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb3:	75 17                	jne    802bcc <insert_sorted_allocList+0x25e>
  802bb5:	83 ec 04             	sub    $0x4,%esp
  802bb8:	68 ec 43 80 00       	push   $0x8043ec
  802bbd:	68 80 00 00 00       	push   $0x80
  802bc2:	68 67 43 80 00       	push   $0x804367
  802bc7:	e8 0b dd ff ff       	call   8008d7 <_panic>
  802bcc:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	89 50 04             	mov    %edx,0x4(%eax)
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	8b 40 04             	mov    0x4(%eax),%eax
  802bde:	85 c0                	test   %eax,%eax
  802be0:	74 0c                	je     802bee <insert_sorted_allocList+0x280>
  802be2:	a1 44 50 80 00       	mov    0x805044,%eax
  802be7:	8b 55 08             	mov    0x8(%ebp),%edx
  802bea:	89 10                	mov    %edx,(%eax)
  802bec:	eb 08                	jmp    802bf6 <insert_sorted_allocList+0x288>
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	a3 40 50 80 00       	mov    %eax,0x805040
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	a3 44 50 80 00       	mov    %eax,0x805044
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c07:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c0c:	40                   	inc    %eax
  802c0d:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802c12:	eb 36                	jmp    802c4a <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802c14:	a1 48 50 80 00       	mov    0x805048,%eax
  802c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c20:	74 07                	je     802c29 <insert_sorted_allocList+0x2bb>
  802c22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c25:	8b 00                	mov    (%eax),%eax
  802c27:	eb 05                	jmp    802c2e <insert_sorted_allocList+0x2c0>
  802c29:	b8 00 00 00 00       	mov    $0x0,%eax
  802c2e:	a3 48 50 80 00       	mov    %eax,0x805048
  802c33:	a1 48 50 80 00       	mov    0x805048,%eax
  802c38:	85 c0                	test   %eax,%eax
  802c3a:	0f 85 23 fe ff ff    	jne    802a63 <insert_sorted_allocList+0xf5>
  802c40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c44:	0f 85 19 fe ff ff    	jne    802a63 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802c4a:	90                   	nop
  802c4b:	c9                   	leave  
  802c4c:	c3                   	ret    

00802c4d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c4d:	55                   	push   %ebp
  802c4e:	89 e5                	mov    %esp,%ebp
  802c50:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802c53:	a1 38 51 80 00       	mov    0x805138,%eax
  802c58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c5b:	e9 7c 01 00 00       	jmp    802ddc <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 40 0c             	mov    0xc(%eax),%eax
  802c66:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c69:	0f 85 90 00 00 00    	jne    802cff <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802c75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c79:	75 17                	jne    802c92 <alloc_block_FF+0x45>
  802c7b:	83 ec 04             	sub    $0x4,%esp
  802c7e:	68 0f 44 80 00       	push   $0x80440f
  802c83:	68 ba 00 00 00       	push   $0xba
  802c88:	68 67 43 80 00       	push   $0x804367
  802c8d:	e8 45 dc ff ff       	call   8008d7 <_panic>
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 00                	mov    (%eax),%eax
  802c97:	85 c0                	test   %eax,%eax
  802c99:	74 10                	je     802cab <alloc_block_FF+0x5e>
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	8b 00                	mov    (%eax),%eax
  802ca0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca3:	8b 52 04             	mov    0x4(%edx),%edx
  802ca6:	89 50 04             	mov    %edx,0x4(%eax)
  802ca9:	eb 0b                	jmp    802cb6 <alloc_block_FF+0x69>
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	8b 40 04             	mov    0x4(%eax),%eax
  802cb1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 40 04             	mov    0x4(%eax),%eax
  802cbc:	85 c0                	test   %eax,%eax
  802cbe:	74 0f                	je     802ccf <alloc_block_FF+0x82>
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 40 04             	mov    0x4(%eax),%eax
  802cc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc9:	8b 12                	mov    (%edx),%edx
  802ccb:	89 10                	mov    %edx,(%eax)
  802ccd:	eb 0a                	jmp    802cd9 <alloc_block_FF+0x8c>
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	a3 38 51 80 00       	mov    %eax,0x805138
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cec:	a1 44 51 80 00       	mov    0x805144,%eax
  802cf1:	48                   	dec    %eax
  802cf2:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfa:	e9 10 01 00 00       	jmp    802e0f <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 40 0c             	mov    0xc(%eax),%eax
  802d05:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d08:	0f 86 c6 00 00 00    	jbe    802dd4 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802d0e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d13:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802d16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d1a:	75 17                	jne    802d33 <alloc_block_FF+0xe6>
  802d1c:	83 ec 04             	sub    $0x4,%esp
  802d1f:	68 0f 44 80 00       	push   $0x80440f
  802d24:	68 c2 00 00 00       	push   $0xc2
  802d29:	68 67 43 80 00       	push   $0x804367
  802d2e:	e8 a4 db ff ff       	call   8008d7 <_panic>
  802d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d36:	8b 00                	mov    (%eax),%eax
  802d38:	85 c0                	test   %eax,%eax
  802d3a:	74 10                	je     802d4c <alloc_block_FF+0xff>
  802d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d44:	8b 52 04             	mov    0x4(%edx),%edx
  802d47:	89 50 04             	mov    %edx,0x4(%eax)
  802d4a:	eb 0b                	jmp    802d57 <alloc_block_FF+0x10a>
  802d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4f:	8b 40 04             	mov    0x4(%eax),%eax
  802d52:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d5a:	8b 40 04             	mov    0x4(%eax),%eax
  802d5d:	85 c0                	test   %eax,%eax
  802d5f:	74 0f                	je     802d70 <alloc_block_FF+0x123>
  802d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d64:	8b 40 04             	mov    0x4(%eax),%eax
  802d67:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d6a:	8b 12                	mov    (%edx),%edx
  802d6c:	89 10                	mov    %edx,(%eax)
  802d6e:	eb 0a                	jmp    802d7a <alloc_block_FF+0x12d>
  802d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d73:	8b 00                	mov    (%eax),%eax
  802d75:	a3 48 51 80 00       	mov    %eax,0x805148
  802d7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8d:	a1 54 51 80 00       	mov    0x805154,%eax
  802d92:	48                   	dec    %eax
  802d93:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802d98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9b:	8b 50 08             	mov    0x8(%eax),%edx
  802d9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da1:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da7:	8b 55 08             	mov    0x8(%ebp),%edx
  802daa:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	8b 40 0c             	mov    0xc(%eax),%eax
  802db3:	2b 45 08             	sub    0x8(%ebp),%eax
  802db6:	89 c2                	mov    %eax,%edx
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	8b 50 08             	mov    0x8(%eax),%edx
  802dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc7:	01 c2                	add    %eax,%edx
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dd2:	eb 3b                	jmp    802e0f <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802dd4:	a1 40 51 80 00       	mov    0x805140,%eax
  802dd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de0:	74 07                	je     802de9 <alloc_block_FF+0x19c>
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	8b 00                	mov    (%eax),%eax
  802de7:	eb 05                	jmp    802dee <alloc_block_FF+0x1a1>
  802de9:	b8 00 00 00 00       	mov    $0x0,%eax
  802dee:	a3 40 51 80 00       	mov    %eax,0x805140
  802df3:	a1 40 51 80 00       	mov    0x805140,%eax
  802df8:	85 c0                	test   %eax,%eax
  802dfa:	0f 85 60 fe ff ff    	jne    802c60 <alloc_block_FF+0x13>
  802e00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e04:	0f 85 56 fe ff ff    	jne    802c60 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802e0a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e0f:	c9                   	leave  
  802e10:	c3                   	ret    

00802e11 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802e11:	55                   	push   %ebp
  802e12:	89 e5                	mov    %esp,%ebp
  802e14:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802e17:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802e1e:	a1 38 51 80 00       	mov    0x805138,%eax
  802e23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e26:	eb 3a                	jmp    802e62 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e31:	72 27                	jb     802e5a <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802e33:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802e37:	75 0b                	jne    802e44 <alloc_block_BF+0x33>
					best_size= element->size;
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e42:	eb 16                	jmp    802e5a <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	8b 50 0c             	mov    0xc(%eax),%edx
  802e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e4d:	39 c2                	cmp    %eax,%edx
  802e4f:	77 09                	ja     802e5a <alloc_block_BF+0x49>
					best_size=element->size;
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	8b 40 0c             	mov    0xc(%eax),%eax
  802e57:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802e5a:	a1 40 51 80 00       	mov    0x805140,%eax
  802e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e66:	74 07                	je     802e6f <alloc_block_BF+0x5e>
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	8b 00                	mov    (%eax),%eax
  802e6d:	eb 05                	jmp    802e74 <alloc_block_BF+0x63>
  802e6f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e74:	a3 40 51 80 00       	mov    %eax,0x805140
  802e79:	a1 40 51 80 00       	mov    0x805140,%eax
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	75 a6                	jne    802e28 <alloc_block_BF+0x17>
  802e82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e86:	75 a0                	jne    802e28 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802e88:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802e8c:	0f 84 d3 01 00 00    	je     803065 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802e92:	a1 38 51 80 00       	mov    0x805138,%eax
  802e97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e9a:	e9 98 01 00 00       	jmp    803037 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ea5:	0f 86 da 00 00 00    	jbe    802f85 <alloc_block_BF+0x174>
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 50 0c             	mov    0xc(%eax),%edx
  802eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb4:	39 c2                	cmp    %eax,%edx
  802eb6:	0f 85 c9 00 00 00    	jne    802f85 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802ebc:	a1 48 51 80 00       	mov    0x805148,%eax
  802ec1:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802ec4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ec8:	75 17                	jne    802ee1 <alloc_block_BF+0xd0>
  802eca:	83 ec 04             	sub    $0x4,%esp
  802ecd:	68 0f 44 80 00       	push   $0x80440f
  802ed2:	68 ea 00 00 00       	push   $0xea
  802ed7:	68 67 43 80 00       	push   $0x804367
  802edc:	e8 f6 d9 ff ff       	call   8008d7 <_panic>
  802ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee4:	8b 00                	mov    (%eax),%eax
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	74 10                	je     802efa <alloc_block_BF+0xe9>
  802eea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ef2:	8b 52 04             	mov    0x4(%edx),%edx
  802ef5:	89 50 04             	mov    %edx,0x4(%eax)
  802ef8:	eb 0b                	jmp    802f05 <alloc_block_BF+0xf4>
  802efa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efd:	8b 40 04             	mov    0x4(%eax),%eax
  802f00:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f08:	8b 40 04             	mov    0x4(%eax),%eax
  802f0b:	85 c0                	test   %eax,%eax
  802f0d:	74 0f                	je     802f1e <alloc_block_BF+0x10d>
  802f0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f12:	8b 40 04             	mov    0x4(%eax),%eax
  802f15:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f18:	8b 12                	mov    (%edx),%edx
  802f1a:	89 10                	mov    %edx,(%eax)
  802f1c:	eb 0a                	jmp    802f28 <alloc_block_BF+0x117>
  802f1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f21:	8b 00                	mov    (%eax),%eax
  802f23:	a3 48 51 80 00       	mov    %eax,0x805148
  802f28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f2b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3b:	a1 54 51 80 00       	mov    0x805154,%eax
  802f40:	48                   	dec    %eax
  802f41:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f49:	8b 50 08             	mov    0x8(%eax),%edx
  802f4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f4f:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802f52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f55:	8b 55 08             	mov    0x8(%ebp),%edx
  802f58:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f61:	2b 45 08             	sub    0x8(%ebp),%eax
  802f64:	89 c2                	mov    %eax,%edx
  802f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f69:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	8b 50 08             	mov    0x8(%eax),%edx
  802f72:	8b 45 08             	mov    0x8(%ebp),%eax
  802f75:	01 c2                	add    %eax,%edx
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f80:	e9 e5 00 00 00       	jmp    80306a <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	8b 50 0c             	mov    0xc(%eax),%edx
  802f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f8e:	39 c2                	cmp    %eax,%edx
  802f90:	0f 85 99 00 00 00    	jne    80302f <alloc_block_BF+0x21e>
  802f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f99:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f9c:	0f 85 8d 00 00 00    	jne    80302f <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802fa8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fac:	75 17                	jne    802fc5 <alloc_block_BF+0x1b4>
  802fae:	83 ec 04             	sub    $0x4,%esp
  802fb1:	68 0f 44 80 00       	push   $0x80440f
  802fb6:	68 f7 00 00 00       	push   $0xf7
  802fbb:	68 67 43 80 00       	push   $0x804367
  802fc0:	e8 12 d9 ff ff       	call   8008d7 <_panic>
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	8b 00                	mov    (%eax),%eax
  802fca:	85 c0                	test   %eax,%eax
  802fcc:	74 10                	je     802fde <alloc_block_BF+0x1cd>
  802fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd1:	8b 00                	mov    (%eax),%eax
  802fd3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fd6:	8b 52 04             	mov    0x4(%edx),%edx
  802fd9:	89 50 04             	mov    %edx,0x4(%eax)
  802fdc:	eb 0b                	jmp    802fe9 <alloc_block_BF+0x1d8>
  802fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe1:	8b 40 04             	mov    0x4(%eax),%eax
  802fe4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fec:	8b 40 04             	mov    0x4(%eax),%eax
  802fef:	85 c0                	test   %eax,%eax
  802ff1:	74 0f                	je     803002 <alloc_block_BF+0x1f1>
  802ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff6:	8b 40 04             	mov    0x4(%eax),%eax
  802ff9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ffc:	8b 12                	mov    (%edx),%edx
  802ffe:	89 10                	mov    %edx,(%eax)
  803000:	eb 0a                	jmp    80300c <alloc_block_BF+0x1fb>
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 00                	mov    (%eax),%eax
  803007:	a3 38 51 80 00       	mov    %eax,0x805138
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301f:	a1 44 51 80 00       	mov    0x805144,%eax
  803024:	48                   	dec    %eax
  803025:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  80302a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302d:	eb 3b                	jmp    80306a <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80302f:	a1 40 51 80 00       	mov    0x805140,%eax
  803034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803037:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303b:	74 07                	je     803044 <alloc_block_BF+0x233>
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	8b 00                	mov    (%eax),%eax
  803042:	eb 05                	jmp    803049 <alloc_block_BF+0x238>
  803044:	b8 00 00 00 00       	mov    $0x0,%eax
  803049:	a3 40 51 80 00       	mov    %eax,0x805140
  80304e:	a1 40 51 80 00       	mov    0x805140,%eax
  803053:	85 c0                	test   %eax,%eax
  803055:	0f 85 44 fe ff ff    	jne    802e9f <alloc_block_BF+0x8e>
  80305b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305f:	0f 85 3a fe ff ff    	jne    802e9f <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  803065:	b8 00 00 00 00       	mov    $0x0,%eax
  80306a:	c9                   	leave  
  80306b:	c3                   	ret    

0080306c <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80306c:	55                   	push   %ebp
  80306d:	89 e5                	mov    %esp,%ebp
  80306f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  803072:	83 ec 04             	sub    $0x4,%esp
  803075:	68 30 44 80 00       	push   $0x804430
  80307a:	68 04 01 00 00       	push   $0x104
  80307f:	68 67 43 80 00       	push   $0x804367
  803084:	e8 4e d8 ff ff       	call   8008d7 <_panic>

00803089 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  803089:	55                   	push   %ebp
  80308a:	89 e5                	mov    %esp,%ebp
  80308c:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  80308f:	a1 38 51 80 00       	mov    0x805138,%eax
  803094:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  803097:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80309c:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  80309f:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a4:	85 c0                	test   %eax,%eax
  8030a6:	75 68                	jne    803110 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8030a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ac:	75 17                	jne    8030c5 <insert_sorted_with_merge_freeList+0x3c>
  8030ae:	83 ec 04             	sub    $0x4,%esp
  8030b1:	68 44 43 80 00       	push   $0x804344
  8030b6:	68 14 01 00 00       	push   $0x114
  8030bb:	68 67 43 80 00       	push   $0x804367
  8030c0:	e8 12 d8 ff ff       	call   8008d7 <_panic>
  8030c5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	89 10                	mov    %edx,(%eax)
  8030d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d3:	8b 00                	mov    (%eax),%eax
  8030d5:	85 c0                	test   %eax,%eax
  8030d7:	74 0d                	je     8030e6 <insert_sorted_with_merge_freeList+0x5d>
  8030d9:	a1 38 51 80 00       	mov    0x805138,%eax
  8030de:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e1:	89 50 04             	mov    %edx,0x4(%eax)
  8030e4:	eb 08                	jmp    8030ee <insert_sorted_with_merge_freeList+0x65>
  8030e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8030f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803100:	a1 44 51 80 00       	mov    0x805144,%eax
  803105:	40                   	inc    %eax
  803106:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  80310b:	e9 d2 06 00 00       	jmp    8037e2 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	8b 50 08             	mov    0x8(%eax),%edx
  803116:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803119:	8b 40 08             	mov    0x8(%eax),%eax
  80311c:	39 c2                	cmp    %eax,%edx
  80311e:	0f 83 22 01 00 00    	jae    803246 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  803124:	8b 45 08             	mov    0x8(%ebp),%eax
  803127:	8b 50 08             	mov    0x8(%eax),%edx
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	8b 40 0c             	mov    0xc(%eax),%eax
  803130:	01 c2                	add    %eax,%edx
  803132:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803135:	8b 40 08             	mov    0x8(%eax),%eax
  803138:	39 c2                	cmp    %eax,%edx
  80313a:	0f 85 9e 00 00 00    	jne    8031de <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  803140:	8b 45 08             	mov    0x8(%ebp),%eax
  803143:	8b 50 08             	mov    0x8(%eax),%edx
  803146:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803149:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  80314c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314f:	8b 50 0c             	mov    0xc(%eax),%edx
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	8b 40 0c             	mov    0xc(%eax),%eax
  803158:	01 c2                	add    %eax,%edx
  80315a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80315d:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  803160:	8b 45 08             	mov    0x8(%ebp),%eax
  803163:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80316a:	8b 45 08             	mov    0x8(%ebp),%eax
  80316d:	8b 50 08             	mov    0x8(%eax),%edx
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803176:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317a:	75 17                	jne    803193 <insert_sorted_with_merge_freeList+0x10a>
  80317c:	83 ec 04             	sub    $0x4,%esp
  80317f:	68 44 43 80 00       	push   $0x804344
  803184:	68 21 01 00 00       	push   $0x121
  803189:	68 67 43 80 00       	push   $0x804367
  80318e:	e8 44 d7 ff ff       	call   8008d7 <_panic>
  803193:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	89 10                	mov    %edx,(%eax)
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	85 c0                	test   %eax,%eax
  8031a5:	74 0d                	je     8031b4 <insert_sorted_with_merge_freeList+0x12b>
  8031a7:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8031af:	89 50 04             	mov    %edx,0x4(%eax)
  8031b2:	eb 08                	jmp    8031bc <insert_sorted_with_merge_freeList+0x133>
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8031c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ce:	a1 54 51 80 00       	mov    0x805154,%eax
  8031d3:	40                   	inc    %eax
  8031d4:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8031d9:	e9 04 06 00 00       	jmp    8037e2 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8031de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031e2:	75 17                	jne    8031fb <insert_sorted_with_merge_freeList+0x172>
  8031e4:	83 ec 04             	sub    $0x4,%esp
  8031e7:	68 44 43 80 00       	push   $0x804344
  8031ec:	68 26 01 00 00       	push   $0x126
  8031f1:	68 67 43 80 00       	push   $0x804367
  8031f6:	e8 dc d6 ff ff       	call   8008d7 <_panic>
  8031fb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803201:	8b 45 08             	mov    0x8(%ebp),%eax
  803204:	89 10                	mov    %edx,(%eax)
  803206:	8b 45 08             	mov    0x8(%ebp),%eax
  803209:	8b 00                	mov    (%eax),%eax
  80320b:	85 c0                	test   %eax,%eax
  80320d:	74 0d                	je     80321c <insert_sorted_with_merge_freeList+0x193>
  80320f:	a1 38 51 80 00       	mov    0x805138,%eax
  803214:	8b 55 08             	mov    0x8(%ebp),%edx
  803217:	89 50 04             	mov    %edx,0x4(%eax)
  80321a:	eb 08                	jmp    803224 <insert_sorted_with_merge_freeList+0x19b>
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	a3 38 51 80 00       	mov    %eax,0x805138
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803236:	a1 44 51 80 00       	mov    0x805144,%eax
  80323b:	40                   	inc    %eax
  80323c:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803241:	e9 9c 05 00 00       	jmp    8037e2 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	8b 50 08             	mov    0x8(%eax),%edx
  80324c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324f:	8b 40 08             	mov    0x8(%eax),%eax
  803252:	39 c2                	cmp    %eax,%edx
  803254:	0f 86 16 01 00 00    	jbe    803370 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  80325a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80325d:	8b 50 08             	mov    0x8(%eax),%edx
  803260:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803263:	8b 40 0c             	mov    0xc(%eax),%eax
  803266:	01 c2                	add    %eax,%edx
  803268:	8b 45 08             	mov    0x8(%ebp),%eax
  80326b:	8b 40 08             	mov    0x8(%eax),%eax
  80326e:	39 c2                	cmp    %eax,%edx
  803270:	0f 85 92 00 00 00    	jne    803308 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  803276:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803279:	8b 50 0c             	mov    0xc(%eax),%edx
  80327c:	8b 45 08             	mov    0x8(%ebp),%eax
  80327f:	8b 40 0c             	mov    0xc(%eax),%eax
  803282:	01 c2                	add    %eax,%edx
  803284:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803287:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  80328a:	8b 45 08             	mov    0x8(%ebp),%eax
  80328d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803294:	8b 45 08             	mov    0x8(%ebp),%eax
  803297:	8b 50 08             	mov    0x8(%eax),%edx
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8032a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032a4:	75 17                	jne    8032bd <insert_sorted_with_merge_freeList+0x234>
  8032a6:	83 ec 04             	sub    $0x4,%esp
  8032a9:	68 44 43 80 00       	push   $0x804344
  8032ae:	68 31 01 00 00       	push   $0x131
  8032b3:	68 67 43 80 00       	push   $0x804367
  8032b8:	e8 1a d6 ff ff       	call   8008d7 <_panic>
  8032bd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c6:	89 10                	mov    %edx,(%eax)
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	8b 00                	mov    (%eax),%eax
  8032cd:	85 c0                	test   %eax,%eax
  8032cf:	74 0d                	je     8032de <insert_sorted_with_merge_freeList+0x255>
  8032d1:	a1 48 51 80 00       	mov    0x805148,%eax
  8032d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032d9:	89 50 04             	mov    %edx,0x4(%eax)
  8032dc:	eb 08                	jmp    8032e6 <insert_sorted_with_merge_freeList+0x25d>
  8032de:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	a3 48 51 80 00       	mov    %eax,0x805148
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032f8:	a1 54 51 80 00       	mov    0x805154,%eax
  8032fd:	40                   	inc    %eax
  8032fe:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  803303:	e9 da 04 00 00       	jmp    8037e2 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  803308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80330c:	75 17                	jne    803325 <insert_sorted_with_merge_freeList+0x29c>
  80330e:	83 ec 04             	sub    $0x4,%esp
  803311:	68 ec 43 80 00       	push   $0x8043ec
  803316:	68 37 01 00 00       	push   $0x137
  80331b:	68 67 43 80 00       	push   $0x804367
  803320:	e8 b2 d5 ff ff       	call   8008d7 <_panic>
  803325:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80332b:	8b 45 08             	mov    0x8(%ebp),%eax
  80332e:	89 50 04             	mov    %edx,0x4(%eax)
  803331:	8b 45 08             	mov    0x8(%ebp),%eax
  803334:	8b 40 04             	mov    0x4(%eax),%eax
  803337:	85 c0                	test   %eax,%eax
  803339:	74 0c                	je     803347 <insert_sorted_with_merge_freeList+0x2be>
  80333b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803340:	8b 55 08             	mov    0x8(%ebp),%edx
  803343:	89 10                	mov    %edx,(%eax)
  803345:	eb 08                	jmp    80334f <insert_sorted_with_merge_freeList+0x2c6>
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	a3 38 51 80 00       	mov    %eax,0x805138
  80334f:	8b 45 08             	mov    0x8(%ebp),%eax
  803352:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803357:	8b 45 08             	mov    0x8(%ebp),%eax
  80335a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803360:	a1 44 51 80 00       	mov    0x805144,%eax
  803365:	40                   	inc    %eax
  803366:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  80336b:	e9 72 04 00 00       	jmp    8037e2 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803370:	a1 38 51 80 00       	mov    0x805138,%eax
  803375:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803378:	e9 35 04 00 00       	jmp    8037b2 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  80337d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803380:	8b 00                	mov    (%eax),%eax
  803382:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	8b 50 08             	mov    0x8(%eax),%edx
  80338b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338e:	8b 40 08             	mov    0x8(%eax),%eax
  803391:	39 c2                	cmp    %eax,%edx
  803393:	0f 86 11 04 00 00    	jbe    8037aa <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339c:	8b 50 08             	mov    0x8(%eax),%edx
  80339f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8033a5:	01 c2                	add    %eax,%edx
  8033a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033aa:	8b 40 08             	mov    0x8(%eax),%eax
  8033ad:	39 c2                	cmp    %eax,%edx
  8033af:	0f 83 8b 00 00 00    	jae    803440 <insert_sorted_with_merge_freeList+0x3b7>
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	8b 50 08             	mov    0x8(%eax),%edx
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c1:	01 c2                	add    %eax,%edx
  8033c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c6:	8b 40 08             	mov    0x8(%eax),%eax
  8033c9:	39 c2                	cmp    %eax,%edx
  8033cb:	73 73                	jae    803440 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  8033cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033d1:	74 06                	je     8033d9 <insert_sorted_with_merge_freeList+0x350>
  8033d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d7:	75 17                	jne    8033f0 <insert_sorted_with_merge_freeList+0x367>
  8033d9:	83 ec 04             	sub    $0x4,%esp
  8033dc:	68 b8 43 80 00       	push   $0x8043b8
  8033e1:	68 48 01 00 00       	push   $0x148
  8033e6:	68 67 43 80 00       	push   $0x804367
  8033eb:	e8 e7 d4 ff ff       	call   8008d7 <_panic>
  8033f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f3:	8b 10                	mov    (%eax),%edx
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	89 10                	mov    %edx,(%eax)
  8033fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fd:	8b 00                	mov    (%eax),%eax
  8033ff:	85 c0                	test   %eax,%eax
  803401:	74 0b                	je     80340e <insert_sorted_with_merge_freeList+0x385>
  803403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803406:	8b 00                	mov    (%eax),%eax
  803408:	8b 55 08             	mov    0x8(%ebp),%edx
  80340b:	89 50 04             	mov    %edx,0x4(%eax)
  80340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803411:	8b 55 08             	mov    0x8(%ebp),%edx
  803414:	89 10                	mov    %edx,(%eax)
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80341c:	89 50 04             	mov    %edx,0x4(%eax)
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	8b 00                	mov    (%eax),%eax
  803424:	85 c0                	test   %eax,%eax
  803426:	75 08                	jne    803430 <insert_sorted_with_merge_freeList+0x3a7>
  803428:	8b 45 08             	mov    0x8(%ebp),%eax
  80342b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803430:	a1 44 51 80 00       	mov    0x805144,%eax
  803435:	40                   	inc    %eax
  803436:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  80343b:	e9 a2 03 00 00       	jmp    8037e2 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803440:	8b 45 08             	mov    0x8(%ebp),%eax
  803443:	8b 50 08             	mov    0x8(%eax),%edx
  803446:	8b 45 08             	mov    0x8(%ebp),%eax
  803449:	8b 40 0c             	mov    0xc(%eax),%eax
  80344c:	01 c2                	add    %eax,%edx
  80344e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803451:	8b 40 08             	mov    0x8(%eax),%eax
  803454:	39 c2                	cmp    %eax,%edx
  803456:	0f 83 ae 00 00 00    	jae    80350a <insert_sorted_with_merge_freeList+0x481>
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	8b 50 08             	mov    0x8(%eax),%edx
  803462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803465:	8b 48 08             	mov    0x8(%eax),%ecx
  803468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346b:	8b 40 0c             	mov    0xc(%eax),%eax
  80346e:	01 c8                	add    %ecx,%eax
  803470:	39 c2                	cmp    %eax,%edx
  803472:	0f 85 92 00 00 00    	jne    80350a <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  803478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347b:	8b 50 0c             	mov    0xc(%eax),%edx
  80347e:	8b 45 08             	mov    0x8(%ebp),%eax
  803481:	8b 40 0c             	mov    0xc(%eax),%eax
  803484:	01 c2                	add    %eax,%edx
  803486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803489:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  80348c:	8b 45 08             	mov    0x8(%ebp),%eax
  80348f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803496:	8b 45 08             	mov    0x8(%ebp),%eax
  803499:	8b 50 08             	mov    0x8(%eax),%edx
  80349c:	8b 45 08             	mov    0x8(%ebp),%eax
  80349f:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  8034a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034a6:	75 17                	jne    8034bf <insert_sorted_with_merge_freeList+0x436>
  8034a8:	83 ec 04             	sub    $0x4,%esp
  8034ab:	68 44 43 80 00       	push   $0x804344
  8034b0:	68 51 01 00 00       	push   $0x151
  8034b5:	68 67 43 80 00       	push   $0x804367
  8034ba:	e8 18 d4 ff ff       	call   8008d7 <_panic>
  8034bf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c8:	89 10                	mov    %edx,(%eax)
  8034ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cd:	8b 00                	mov    (%eax),%eax
  8034cf:	85 c0                	test   %eax,%eax
  8034d1:	74 0d                	je     8034e0 <insert_sorted_with_merge_freeList+0x457>
  8034d3:	a1 48 51 80 00       	mov    0x805148,%eax
  8034d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8034db:	89 50 04             	mov    %edx,0x4(%eax)
  8034de:	eb 08                	jmp    8034e8 <insert_sorted_with_merge_freeList+0x45f>
  8034e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8034f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ff:	40                   	inc    %eax
  803500:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  803505:	e9 d8 02 00 00       	jmp    8037e2 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  80350a:	8b 45 08             	mov    0x8(%ebp),%eax
  80350d:	8b 50 08             	mov    0x8(%eax),%edx
  803510:	8b 45 08             	mov    0x8(%ebp),%eax
  803513:	8b 40 0c             	mov    0xc(%eax),%eax
  803516:	01 c2                	add    %eax,%edx
  803518:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351b:	8b 40 08             	mov    0x8(%eax),%eax
  80351e:	39 c2                	cmp    %eax,%edx
  803520:	0f 85 ba 00 00 00    	jne    8035e0 <insert_sorted_with_merge_freeList+0x557>
  803526:	8b 45 08             	mov    0x8(%ebp),%eax
  803529:	8b 50 08             	mov    0x8(%eax),%edx
  80352c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352f:	8b 48 08             	mov    0x8(%eax),%ecx
  803532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803535:	8b 40 0c             	mov    0xc(%eax),%eax
  803538:	01 c8                	add    %ecx,%eax
  80353a:	39 c2                	cmp    %eax,%edx
  80353c:	0f 86 9e 00 00 00    	jbe    8035e0 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803542:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803545:	8b 50 0c             	mov    0xc(%eax),%edx
  803548:	8b 45 08             	mov    0x8(%ebp),%eax
  80354b:	8b 40 0c             	mov    0xc(%eax),%eax
  80354e:	01 c2                	add    %eax,%edx
  803550:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803553:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	8b 50 08             	mov    0x8(%eax),%edx
  80355c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80355f:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803562:	8b 45 08             	mov    0x8(%ebp),%eax
  803565:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	8b 50 08             	mov    0x8(%eax),%edx
  803572:	8b 45 08             	mov    0x8(%ebp),%eax
  803575:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803578:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80357c:	75 17                	jne    803595 <insert_sorted_with_merge_freeList+0x50c>
  80357e:	83 ec 04             	sub    $0x4,%esp
  803581:	68 44 43 80 00       	push   $0x804344
  803586:	68 5b 01 00 00       	push   $0x15b
  80358b:	68 67 43 80 00       	push   $0x804367
  803590:	e8 42 d3 ff ff       	call   8008d7 <_panic>
  803595:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80359b:	8b 45 08             	mov    0x8(%ebp),%eax
  80359e:	89 10                	mov    %edx,(%eax)
  8035a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a3:	8b 00                	mov    (%eax),%eax
  8035a5:	85 c0                	test   %eax,%eax
  8035a7:	74 0d                	je     8035b6 <insert_sorted_with_merge_freeList+0x52d>
  8035a9:	a1 48 51 80 00       	mov    0x805148,%eax
  8035ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8035b1:	89 50 04             	mov    %edx,0x4(%eax)
  8035b4:	eb 08                	jmp    8035be <insert_sorted_with_merge_freeList+0x535>
  8035b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8035c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035d0:	a1 54 51 80 00       	mov    0x805154,%eax
  8035d5:	40                   	inc    %eax
  8035d6:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8035db:	e9 02 02 00 00       	jmp    8037e2 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8035e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e3:	8b 50 08             	mov    0x8(%eax),%edx
  8035e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ec:	01 c2                	add    %eax,%edx
  8035ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035f1:	8b 40 08             	mov    0x8(%eax),%eax
  8035f4:	39 c2                	cmp    %eax,%edx
  8035f6:	0f 85 ae 01 00 00    	jne    8037aa <insert_sorted_with_merge_freeList+0x721>
  8035fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ff:	8b 50 08             	mov    0x8(%eax),%edx
  803602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803605:	8b 48 08             	mov    0x8(%eax),%ecx
  803608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360b:	8b 40 0c             	mov    0xc(%eax),%eax
  80360e:	01 c8                	add    %ecx,%eax
  803610:	39 c2                	cmp    %eax,%edx
  803612:	0f 85 92 01 00 00    	jne    8037aa <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  803618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361b:	8b 50 0c             	mov    0xc(%eax),%edx
  80361e:	8b 45 08             	mov    0x8(%ebp),%eax
  803621:	8b 40 0c             	mov    0xc(%eax),%eax
  803624:	01 c2                	add    %eax,%edx
  803626:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803629:	8b 40 0c             	mov    0xc(%eax),%eax
  80362c:	01 c2                	add    %eax,%edx
  80362e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803631:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  803634:	8b 45 08             	mov    0x8(%ebp),%eax
  803637:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80363e:	8b 45 08             	mov    0x8(%ebp),%eax
  803641:	8b 50 08             	mov    0x8(%eax),%edx
  803644:	8b 45 08             	mov    0x8(%ebp),%eax
  803647:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  80364a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803654:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803657:	8b 50 08             	mov    0x8(%eax),%edx
  80365a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365d:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803660:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803664:	75 17                	jne    80367d <insert_sorted_with_merge_freeList+0x5f4>
  803666:	83 ec 04             	sub    $0x4,%esp
  803669:	68 0f 44 80 00       	push   $0x80440f
  80366e:	68 63 01 00 00       	push   $0x163
  803673:	68 67 43 80 00       	push   $0x804367
  803678:	e8 5a d2 ff ff       	call   8008d7 <_panic>
  80367d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803680:	8b 00                	mov    (%eax),%eax
  803682:	85 c0                	test   %eax,%eax
  803684:	74 10                	je     803696 <insert_sorted_with_merge_freeList+0x60d>
  803686:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803689:	8b 00                	mov    (%eax),%eax
  80368b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80368e:	8b 52 04             	mov    0x4(%edx),%edx
  803691:	89 50 04             	mov    %edx,0x4(%eax)
  803694:	eb 0b                	jmp    8036a1 <insert_sorted_with_merge_freeList+0x618>
  803696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803699:	8b 40 04             	mov    0x4(%eax),%eax
  80369c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8036a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036a4:	8b 40 04             	mov    0x4(%eax),%eax
  8036a7:	85 c0                	test   %eax,%eax
  8036a9:	74 0f                	je     8036ba <insert_sorted_with_merge_freeList+0x631>
  8036ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ae:	8b 40 04             	mov    0x4(%eax),%eax
  8036b1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036b4:	8b 12                	mov    (%edx),%edx
  8036b6:	89 10                	mov    %edx,(%eax)
  8036b8:	eb 0a                	jmp    8036c4 <insert_sorted_with_merge_freeList+0x63b>
  8036ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bd:	8b 00                	mov    (%eax),%eax
  8036bf:	a3 38 51 80 00       	mov    %eax,0x805138
  8036c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036c7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8036cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036d7:	a1 44 51 80 00       	mov    0x805144,%eax
  8036dc:	48                   	dec    %eax
  8036dd:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8036e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036e6:	75 17                	jne    8036ff <insert_sorted_with_merge_freeList+0x676>
  8036e8:	83 ec 04             	sub    $0x4,%esp
  8036eb:	68 44 43 80 00       	push   $0x804344
  8036f0:	68 64 01 00 00       	push   $0x164
  8036f5:	68 67 43 80 00       	push   $0x804367
  8036fa:	e8 d8 d1 ff ff       	call   8008d7 <_panic>
  8036ff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803705:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803708:	89 10                	mov    %edx,(%eax)
  80370a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	85 c0                	test   %eax,%eax
  803711:	74 0d                	je     803720 <insert_sorted_with_merge_freeList+0x697>
  803713:	a1 48 51 80 00       	mov    0x805148,%eax
  803718:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80371b:	89 50 04             	mov    %edx,0x4(%eax)
  80371e:	eb 08                	jmp    803728 <insert_sorted_with_merge_freeList+0x69f>
  803720:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803723:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803728:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80372b:	a3 48 51 80 00       	mov    %eax,0x805148
  803730:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803733:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373a:	a1 54 51 80 00       	mov    0x805154,%eax
  80373f:	40                   	inc    %eax
  803740:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803745:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803749:	75 17                	jne    803762 <insert_sorted_with_merge_freeList+0x6d9>
  80374b:	83 ec 04             	sub    $0x4,%esp
  80374e:	68 44 43 80 00       	push   $0x804344
  803753:	68 65 01 00 00       	push   $0x165
  803758:	68 67 43 80 00       	push   $0x804367
  80375d:	e8 75 d1 ff ff       	call   8008d7 <_panic>
  803762:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803768:	8b 45 08             	mov    0x8(%ebp),%eax
  80376b:	89 10                	mov    %edx,(%eax)
  80376d:	8b 45 08             	mov    0x8(%ebp),%eax
  803770:	8b 00                	mov    (%eax),%eax
  803772:	85 c0                	test   %eax,%eax
  803774:	74 0d                	je     803783 <insert_sorted_with_merge_freeList+0x6fa>
  803776:	a1 48 51 80 00       	mov    0x805148,%eax
  80377b:	8b 55 08             	mov    0x8(%ebp),%edx
  80377e:	89 50 04             	mov    %edx,0x4(%eax)
  803781:	eb 08                	jmp    80378b <insert_sorted_with_merge_freeList+0x702>
  803783:	8b 45 08             	mov    0x8(%ebp),%eax
  803786:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80378b:	8b 45 08             	mov    0x8(%ebp),%eax
  80378e:	a3 48 51 80 00       	mov    %eax,0x805148
  803793:	8b 45 08             	mov    0x8(%ebp),%eax
  803796:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80379d:	a1 54 51 80 00       	mov    0x805154,%eax
  8037a2:	40                   	inc    %eax
  8037a3:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8037a8:	eb 38                	jmp    8037e2 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  8037aa:	a1 40 51 80 00       	mov    0x805140,%eax
  8037af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037b6:	74 07                	je     8037bf <insert_sorted_with_merge_freeList+0x736>
  8037b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bb:	8b 00                	mov    (%eax),%eax
  8037bd:	eb 05                	jmp    8037c4 <insert_sorted_with_merge_freeList+0x73b>
  8037bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8037c4:	a3 40 51 80 00       	mov    %eax,0x805140
  8037c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8037ce:	85 c0                	test   %eax,%eax
  8037d0:	0f 85 a7 fb ff ff    	jne    80337d <insert_sorted_with_merge_freeList+0x2f4>
  8037d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037da:	0f 85 9d fb ff ff    	jne    80337d <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8037e0:	eb 00                	jmp    8037e2 <insert_sorted_with_merge_freeList+0x759>
  8037e2:	90                   	nop
  8037e3:	c9                   	leave  
  8037e4:	c3                   	ret    
  8037e5:	66 90                	xchg   %ax,%ax
  8037e7:	90                   	nop

008037e8 <__udivdi3>:
  8037e8:	55                   	push   %ebp
  8037e9:	57                   	push   %edi
  8037ea:	56                   	push   %esi
  8037eb:	53                   	push   %ebx
  8037ec:	83 ec 1c             	sub    $0x1c,%esp
  8037ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037ff:	89 ca                	mov    %ecx,%edx
  803801:	89 f8                	mov    %edi,%eax
  803803:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803807:	85 f6                	test   %esi,%esi
  803809:	75 2d                	jne    803838 <__udivdi3+0x50>
  80380b:	39 cf                	cmp    %ecx,%edi
  80380d:	77 65                	ja     803874 <__udivdi3+0x8c>
  80380f:	89 fd                	mov    %edi,%ebp
  803811:	85 ff                	test   %edi,%edi
  803813:	75 0b                	jne    803820 <__udivdi3+0x38>
  803815:	b8 01 00 00 00       	mov    $0x1,%eax
  80381a:	31 d2                	xor    %edx,%edx
  80381c:	f7 f7                	div    %edi
  80381e:	89 c5                	mov    %eax,%ebp
  803820:	31 d2                	xor    %edx,%edx
  803822:	89 c8                	mov    %ecx,%eax
  803824:	f7 f5                	div    %ebp
  803826:	89 c1                	mov    %eax,%ecx
  803828:	89 d8                	mov    %ebx,%eax
  80382a:	f7 f5                	div    %ebp
  80382c:	89 cf                	mov    %ecx,%edi
  80382e:	89 fa                	mov    %edi,%edx
  803830:	83 c4 1c             	add    $0x1c,%esp
  803833:	5b                   	pop    %ebx
  803834:	5e                   	pop    %esi
  803835:	5f                   	pop    %edi
  803836:	5d                   	pop    %ebp
  803837:	c3                   	ret    
  803838:	39 ce                	cmp    %ecx,%esi
  80383a:	77 28                	ja     803864 <__udivdi3+0x7c>
  80383c:	0f bd fe             	bsr    %esi,%edi
  80383f:	83 f7 1f             	xor    $0x1f,%edi
  803842:	75 40                	jne    803884 <__udivdi3+0x9c>
  803844:	39 ce                	cmp    %ecx,%esi
  803846:	72 0a                	jb     803852 <__udivdi3+0x6a>
  803848:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80384c:	0f 87 9e 00 00 00    	ja     8038f0 <__udivdi3+0x108>
  803852:	b8 01 00 00 00       	mov    $0x1,%eax
  803857:	89 fa                	mov    %edi,%edx
  803859:	83 c4 1c             	add    $0x1c,%esp
  80385c:	5b                   	pop    %ebx
  80385d:	5e                   	pop    %esi
  80385e:	5f                   	pop    %edi
  80385f:	5d                   	pop    %ebp
  803860:	c3                   	ret    
  803861:	8d 76 00             	lea    0x0(%esi),%esi
  803864:	31 ff                	xor    %edi,%edi
  803866:	31 c0                	xor    %eax,%eax
  803868:	89 fa                	mov    %edi,%edx
  80386a:	83 c4 1c             	add    $0x1c,%esp
  80386d:	5b                   	pop    %ebx
  80386e:	5e                   	pop    %esi
  80386f:	5f                   	pop    %edi
  803870:	5d                   	pop    %ebp
  803871:	c3                   	ret    
  803872:	66 90                	xchg   %ax,%ax
  803874:	89 d8                	mov    %ebx,%eax
  803876:	f7 f7                	div    %edi
  803878:	31 ff                	xor    %edi,%edi
  80387a:	89 fa                	mov    %edi,%edx
  80387c:	83 c4 1c             	add    $0x1c,%esp
  80387f:	5b                   	pop    %ebx
  803880:	5e                   	pop    %esi
  803881:	5f                   	pop    %edi
  803882:	5d                   	pop    %ebp
  803883:	c3                   	ret    
  803884:	bd 20 00 00 00       	mov    $0x20,%ebp
  803889:	89 eb                	mov    %ebp,%ebx
  80388b:	29 fb                	sub    %edi,%ebx
  80388d:	89 f9                	mov    %edi,%ecx
  80388f:	d3 e6                	shl    %cl,%esi
  803891:	89 c5                	mov    %eax,%ebp
  803893:	88 d9                	mov    %bl,%cl
  803895:	d3 ed                	shr    %cl,%ebp
  803897:	89 e9                	mov    %ebp,%ecx
  803899:	09 f1                	or     %esi,%ecx
  80389b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80389f:	89 f9                	mov    %edi,%ecx
  8038a1:	d3 e0                	shl    %cl,%eax
  8038a3:	89 c5                	mov    %eax,%ebp
  8038a5:	89 d6                	mov    %edx,%esi
  8038a7:	88 d9                	mov    %bl,%cl
  8038a9:	d3 ee                	shr    %cl,%esi
  8038ab:	89 f9                	mov    %edi,%ecx
  8038ad:	d3 e2                	shl    %cl,%edx
  8038af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038b3:	88 d9                	mov    %bl,%cl
  8038b5:	d3 e8                	shr    %cl,%eax
  8038b7:	09 c2                	or     %eax,%edx
  8038b9:	89 d0                	mov    %edx,%eax
  8038bb:	89 f2                	mov    %esi,%edx
  8038bd:	f7 74 24 0c          	divl   0xc(%esp)
  8038c1:	89 d6                	mov    %edx,%esi
  8038c3:	89 c3                	mov    %eax,%ebx
  8038c5:	f7 e5                	mul    %ebp
  8038c7:	39 d6                	cmp    %edx,%esi
  8038c9:	72 19                	jb     8038e4 <__udivdi3+0xfc>
  8038cb:	74 0b                	je     8038d8 <__udivdi3+0xf0>
  8038cd:	89 d8                	mov    %ebx,%eax
  8038cf:	31 ff                	xor    %edi,%edi
  8038d1:	e9 58 ff ff ff       	jmp    80382e <__udivdi3+0x46>
  8038d6:	66 90                	xchg   %ax,%ax
  8038d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038dc:	89 f9                	mov    %edi,%ecx
  8038de:	d3 e2                	shl    %cl,%edx
  8038e0:	39 c2                	cmp    %eax,%edx
  8038e2:	73 e9                	jae    8038cd <__udivdi3+0xe5>
  8038e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038e7:	31 ff                	xor    %edi,%edi
  8038e9:	e9 40 ff ff ff       	jmp    80382e <__udivdi3+0x46>
  8038ee:	66 90                	xchg   %ax,%ax
  8038f0:	31 c0                	xor    %eax,%eax
  8038f2:	e9 37 ff ff ff       	jmp    80382e <__udivdi3+0x46>
  8038f7:	90                   	nop

008038f8 <__umoddi3>:
  8038f8:	55                   	push   %ebp
  8038f9:	57                   	push   %edi
  8038fa:	56                   	push   %esi
  8038fb:	53                   	push   %ebx
  8038fc:	83 ec 1c             	sub    $0x1c,%esp
  8038ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803903:	8b 74 24 34          	mov    0x34(%esp),%esi
  803907:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80390b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80390f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803913:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803917:	89 f3                	mov    %esi,%ebx
  803919:	89 fa                	mov    %edi,%edx
  80391b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80391f:	89 34 24             	mov    %esi,(%esp)
  803922:	85 c0                	test   %eax,%eax
  803924:	75 1a                	jne    803940 <__umoddi3+0x48>
  803926:	39 f7                	cmp    %esi,%edi
  803928:	0f 86 a2 00 00 00    	jbe    8039d0 <__umoddi3+0xd8>
  80392e:	89 c8                	mov    %ecx,%eax
  803930:	89 f2                	mov    %esi,%edx
  803932:	f7 f7                	div    %edi
  803934:	89 d0                	mov    %edx,%eax
  803936:	31 d2                	xor    %edx,%edx
  803938:	83 c4 1c             	add    $0x1c,%esp
  80393b:	5b                   	pop    %ebx
  80393c:	5e                   	pop    %esi
  80393d:	5f                   	pop    %edi
  80393e:	5d                   	pop    %ebp
  80393f:	c3                   	ret    
  803940:	39 f0                	cmp    %esi,%eax
  803942:	0f 87 ac 00 00 00    	ja     8039f4 <__umoddi3+0xfc>
  803948:	0f bd e8             	bsr    %eax,%ebp
  80394b:	83 f5 1f             	xor    $0x1f,%ebp
  80394e:	0f 84 ac 00 00 00    	je     803a00 <__umoddi3+0x108>
  803954:	bf 20 00 00 00       	mov    $0x20,%edi
  803959:	29 ef                	sub    %ebp,%edi
  80395b:	89 fe                	mov    %edi,%esi
  80395d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803961:	89 e9                	mov    %ebp,%ecx
  803963:	d3 e0                	shl    %cl,%eax
  803965:	89 d7                	mov    %edx,%edi
  803967:	89 f1                	mov    %esi,%ecx
  803969:	d3 ef                	shr    %cl,%edi
  80396b:	09 c7                	or     %eax,%edi
  80396d:	89 e9                	mov    %ebp,%ecx
  80396f:	d3 e2                	shl    %cl,%edx
  803971:	89 14 24             	mov    %edx,(%esp)
  803974:	89 d8                	mov    %ebx,%eax
  803976:	d3 e0                	shl    %cl,%eax
  803978:	89 c2                	mov    %eax,%edx
  80397a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80397e:	d3 e0                	shl    %cl,%eax
  803980:	89 44 24 04          	mov    %eax,0x4(%esp)
  803984:	8b 44 24 08          	mov    0x8(%esp),%eax
  803988:	89 f1                	mov    %esi,%ecx
  80398a:	d3 e8                	shr    %cl,%eax
  80398c:	09 d0                	or     %edx,%eax
  80398e:	d3 eb                	shr    %cl,%ebx
  803990:	89 da                	mov    %ebx,%edx
  803992:	f7 f7                	div    %edi
  803994:	89 d3                	mov    %edx,%ebx
  803996:	f7 24 24             	mull   (%esp)
  803999:	89 c6                	mov    %eax,%esi
  80399b:	89 d1                	mov    %edx,%ecx
  80399d:	39 d3                	cmp    %edx,%ebx
  80399f:	0f 82 87 00 00 00    	jb     803a2c <__umoddi3+0x134>
  8039a5:	0f 84 91 00 00 00    	je     803a3c <__umoddi3+0x144>
  8039ab:	8b 54 24 04          	mov    0x4(%esp),%edx
  8039af:	29 f2                	sub    %esi,%edx
  8039b1:	19 cb                	sbb    %ecx,%ebx
  8039b3:	89 d8                	mov    %ebx,%eax
  8039b5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8039b9:	d3 e0                	shl    %cl,%eax
  8039bb:	89 e9                	mov    %ebp,%ecx
  8039bd:	d3 ea                	shr    %cl,%edx
  8039bf:	09 d0                	or     %edx,%eax
  8039c1:	89 e9                	mov    %ebp,%ecx
  8039c3:	d3 eb                	shr    %cl,%ebx
  8039c5:	89 da                	mov    %ebx,%edx
  8039c7:	83 c4 1c             	add    $0x1c,%esp
  8039ca:	5b                   	pop    %ebx
  8039cb:	5e                   	pop    %esi
  8039cc:	5f                   	pop    %edi
  8039cd:	5d                   	pop    %ebp
  8039ce:	c3                   	ret    
  8039cf:	90                   	nop
  8039d0:	89 fd                	mov    %edi,%ebp
  8039d2:	85 ff                	test   %edi,%edi
  8039d4:	75 0b                	jne    8039e1 <__umoddi3+0xe9>
  8039d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8039db:	31 d2                	xor    %edx,%edx
  8039dd:	f7 f7                	div    %edi
  8039df:	89 c5                	mov    %eax,%ebp
  8039e1:	89 f0                	mov    %esi,%eax
  8039e3:	31 d2                	xor    %edx,%edx
  8039e5:	f7 f5                	div    %ebp
  8039e7:	89 c8                	mov    %ecx,%eax
  8039e9:	f7 f5                	div    %ebp
  8039eb:	89 d0                	mov    %edx,%eax
  8039ed:	e9 44 ff ff ff       	jmp    803936 <__umoddi3+0x3e>
  8039f2:	66 90                	xchg   %ax,%ax
  8039f4:	89 c8                	mov    %ecx,%eax
  8039f6:	89 f2                	mov    %esi,%edx
  8039f8:	83 c4 1c             	add    $0x1c,%esp
  8039fb:	5b                   	pop    %ebx
  8039fc:	5e                   	pop    %esi
  8039fd:	5f                   	pop    %edi
  8039fe:	5d                   	pop    %ebp
  8039ff:	c3                   	ret    
  803a00:	3b 04 24             	cmp    (%esp),%eax
  803a03:	72 06                	jb     803a0b <__umoddi3+0x113>
  803a05:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a09:	77 0f                	ja     803a1a <__umoddi3+0x122>
  803a0b:	89 f2                	mov    %esi,%edx
  803a0d:	29 f9                	sub    %edi,%ecx
  803a0f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a13:	89 14 24             	mov    %edx,(%esp)
  803a16:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a1a:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a1e:	8b 14 24             	mov    (%esp),%edx
  803a21:	83 c4 1c             	add    $0x1c,%esp
  803a24:	5b                   	pop    %ebx
  803a25:	5e                   	pop    %esi
  803a26:	5f                   	pop    %edi
  803a27:	5d                   	pop    %ebp
  803a28:	c3                   	ret    
  803a29:	8d 76 00             	lea    0x0(%esi),%esi
  803a2c:	2b 04 24             	sub    (%esp),%eax
  803a2f:	19 fa                	sbb    %edi,%edx
  803a31:	89 d1                	mov    %edx,%ecx
  803a33:	89 c6                	mov    %eax,%esi
  803a35:	e9 71 ff ff ff       	jmp    8039ab <__umoddi3+0xb3>
  803a3a:	66 90                	xchg   %ax,%ax
  803a3c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a40:	72 ea                	jb     803a2c <__umoddi3+0x134>
  803a42:	89 d9                	mov    %ebx,%ecx
  803a44:	e9 62 ff ff ff       	jmp    8039ab <__umoddi3+0xb3>
