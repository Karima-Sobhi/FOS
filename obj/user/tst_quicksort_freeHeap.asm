
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 30 08 00 00       	call   800866 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 44 01 00 00    	sub    $0x144,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_disable_interrupt();
  80004c:	e8 52 22 00 00       	call   8022a3 <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 20 3b 80 00       	push   $0x803b20
  800060:	e8 73 12 00 00       	call   8012d8 <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 c3 17 00 00       	call   80183e <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 f8 1c 00 00       	call   801d88 <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)
		uint32 num_disk_tables = 1;  //Since it is created with the first array, so it will be decremented in the 1st case only
  800096:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  80009d:	a1 24 50 80 00       	mov    0x805024,%eax
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	50                   	push   %eax
  8000a6:	e8 88 03 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  8000b1:	e8 00 21 00 00       	call   8021b6 <sys_calculate_free_frames>
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	e8 12 21 00 00       	call   8021cf <sys_calculate_modified_frames>
  8000bd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c3:	29 c2                	sub    %eax,%edx
  8000c5:	89 d0                	mov    %edx,%eax
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		Elements[NumOfElements] = 10 ;
  8000ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 40 3b 80 00       	push   $0x803b40
  8000e7:	e8 6a 0b 00 00       	call   800c56 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 63 3b 80 00       	push   $0x803b63
  8000f7:	e8 5a 0b 00 00       	call   800c56 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 71 3b 80 00       	push   $0x803b71
  800107:	e8 4a 0b 00 00       	call   800c56 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 80 3b 80 00       	push   $0x803b80
  800117:	e8 3a 0b 00 00       	call   800c56 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 90 3b 80 00       	push   $0x803b90
  800127:	e8 2a 0b 00 00       	call   800c56 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012f:	e8 da 06 00 00       	call   80080e <getchar>
  800134:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800137:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 82 06 00 00       	call   8007c6 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 75 06 00 00       	call   8007c6 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>
	sys_enable_interrupt();
  800166:	e8 52 21 00 00       	call   8022bd <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  80016b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016f:	83 f8 62             	cmp    $0x62,%eax
  800172:	74 1d                	je     800191 <_main+0x159>
  800174:	83 f8 63             	cmp    $0x63,%eax
  800177:	74 2b                	je     8001a4 <_main+0x16c>
  800179:	83 f8 61             	cmp    $0x61,%eax
  80017c:	75 39                	jne    8001b7 <_main+0x17f>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	ff 75 ec             	pushl  -0x14(%ebp)
  800184:	ff 75 e8             	pushl  -0x18(%ebp)
  800187:	e8 02 05 00 00       	call   80068e <InitializeAscending>
  80018c:	83 c4 10             	add    $0x10,%esp
			break ;
  80018f:	eb 37                	jmp    8001c8 <_main+0x190>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	ff 75 ec             	pushl  -0x14(%ebp)
  800197:	ff 75 e8             	pushl  -0x18(%ebp)
  80019a:	e8 20 05 00 00       	call   8006bf <InitializeDescending>
  80019f:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a2:	eb 24                	jmp    8001c8 <_main+0x190>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ad:	e8 42 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001b2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b5:	eb 11                	jmp    8001c8 <_main+0x190>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c0:	e8 2f 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001c5:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d1:	e8 fd 02 00 00       	call   8004d3 <QuickSort>
  8001d6:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e2:	e8 fd 03 00 00       	call   8005e4 <CheckSorted>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001f1:	75 14                	jne    800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 9c 3b 80 00       	push   $0x803b9c
  8001fb:	6a 57                	push   $0x57
  8001fd:	68 be 3b 80 00       	push   $0x803bbe
  800202:	e8 9b 07 00 00       	call   8009a2 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 dc 3b 80 00       	push   $0x803bdc
  80020f:	e8 42 0a 00 00       	call   800c56 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 10 3c 80 00       	push   $0x803c10
  80021f:	e8 32 0a 00 00       	call   800c56 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 44 3c 80 00       	push   $0x803c44
  80022f:	e8 22 0a 00 00       	call   800c56 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 76 3c 80 00       	push   $0x803c76
  80023f:	e8 12 0a 00 00       	call   800c56 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 e8             	pushl  -0x18(%ebp)
  80024d:	e8 b1 1b 00 00       	call   801e03 <free>
  800252:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  800255:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800259:	75 7b                	jne    8002d6 <_main+0x29e>
		{
			InitFreeFrames -= num_disk_tables;
  80025b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800261:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800264:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80026b:	75 06                	jne    800273 <_main+0x23b>
  80026d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800271:	74 14                	je     800287 <_main+0x24f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 8c 3c 80 00       	push   $0x803c8c
  80027b:	6a 6a                	push   $0x6a
  80027d:	68 be 3b 80 00       	push   $0x803bbe
  800282:	e8 1b 07 00 00       	call   8009a2 <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800287:	a1 24 50 80 00       	mov    0x805024,%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 9e 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80029b:	e8 16 1f 00 00       	call   8021b6 <sys_calculate_free_frames>
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	e8 28 1f 00 00       	call   8021cf <sys_calculate_modified_frames>
  8002a7:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ad:	29 c2                	sub    %eax,%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002ba:	0f 84 05 01 00 00    	je     8003c5 <_main+0x38d>
  8002c0:	68 dc 3c 80 00       	push   $0x803cdc
  8002c5:	68 01 3d 80 00       	push   $0x803d01
  8002ca:	6a 6e                	push   $0x6e
  8002cc:	68 be 3b 80 00       	push   $0x803bbe
  8002d1:	e8 cc 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 2 )
  8002d6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002da:	75 72                	jne    80034e <_main+0x316>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002dc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002e3:	75 06                	jne    8002eb <_main+0x2b3>
  8002e5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 8c 3c 80 00       	push   $0x803c8c
  8002f3:	6a 73                	push   $0x73
  8002f5:	68 be 3b 80 00       	push   $0x803bbe
  8002fa:	e8 a3 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ff:	a1 24 50 80 00       	mov    0x805024,%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	e8 26 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800313:	e8 9e 1e 00 00       	call   8021b6 <sys_calculate_free_frames>
  800318:	89 c3                	mov    %eax,%ebx
  80031a:	e8 b0 1e 00 00       	call   8021cf <sys_calculate_modified_frames>
  80031f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800325:	29 c2                	sub    %eax,%edx
  800327:	89 d0                	mov    %edx,%eax
  800329:	89 45 cc             	mov    %eax,-0x34(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80032c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	0f 84 8d 00 00 00    	je     8003c5 <_main+0x38d>
  800338:	68 dc 3c 80 00       	push   $0x803cdc
  80033d:	68 01 3d 80 00       	push   $0x803d01
  800342:	6a 77                	push   $0x77
  800344:	68 be 3b 80 00       	push   $0x803bbe
  800349:	e8 54 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 3 )
  80034e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800352:	75 71                	jne    8003c5 <_main+0x38d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800354:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80035b:	75 06                	jne    800363 <_main+0x32b>
  80035d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800361:	74 14                	je     800377 <_main+0x33f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 8c 3c 80 00       	push   $0x803c8c
  80036b:	6a 7c                	push   $0x7c
  80036d:	68 be 3b 80 00       	push   $0x803bbe
  800372:	e8 2b 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800377:	a1 24 50 80 00       	mov    0x805024,%eax
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	e8 ae 00 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 c8             	mov    %eax,-0x38(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80038b:	e8 26 1e 00 00       	call   8021b6 <sys_calculate_free_frames>
  800390:	89 c3                	mov    %eax,%ebx
  800392:	e8 38 1e 00 00       	call   8021cf <sys_calculate_modified_frames>
  800397:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80039a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80039d:	29 c2                	sub    %eax,%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003aa:	74 19                	je     8003c5 <_main+0x38d>
  8003ac:	68 dc 3c 80 00       	push   $0x803cdc
  8003b1:	68 01 3d 80 00       	push   $0x803d01
  8003b6:	68 81 00 00 00       	push   $0x81
  8003bb:	68 be 3b 80 00       	push   $0x803bbe
  8003c0:	e8 dd 05 00 00       	call   8009a2 <_panic>
		}
		///========================================================================
	sys_disable_interrupt();
  8003c5:	e8 d9 1e 00 00       	call   8022a3 <sys_disable_interrupt>
		Chose = 0 ;
  8003ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003ce:	eb 42                	jmp    800412 <_main+0x3da>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 16 3d 80 00       	push   $0x803d16
  8003d8:	e8 79 08 00 00       	call   800c56 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003e0:	e8 29 04 00 00       	call   80080e <getchar>
  8003e5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	50                   	push   %eax
  8003f0:	e8 d1 03 00 00       	call   8007c6 <cputchar>
  8003f5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	6a 0a                	push   $0xa
  8003fd:	e8 c4 03 00 00       	call   8007c6 <cputchar>
  800402:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	6a 0a                	push   $0xa
  80040a:	e8 b7 03 00 00       	call   8007c6 <cputchar>
  80040f:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800412:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800416:	74 06                	je     80041e <_main+0x3e6>
  800418:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80041c:	75 b2                	jne    8003d0 <_main+0x398>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_enable_interrupt();
  80041e:	e8 9a 1e 00 00       	call   8022bd <sys_enable_interrupt>

	} while (Chose == 'y');
  800423:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800427:	0f 84 1c fc ff ff    	je     800049 <_main+0x11>
}
  80042d:	90                   	nop
  80042e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800447:	eb 74                	jmp    8004bd <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800455:	89 d0                	mov    %edx,%eax
  800457:	01 c0                	add    %eax,%eax
  800459:	01 d0                	add    %edx,%eax
  80045b:	c1 e0 03             	shl    $0x3,%eax
  80045e:	01 c8                	add    %ecx,%eax
  800460:	8a 40 04             	mov    0x4(%eax),%al
  800463:	84 c0                	test   %al,%al
  800465:	74 05                	je     80046c <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800467:	ff 45 f4             	incl   -0xc(%ebp)
  80046a:	eb 4e                	jmp    8004ba <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800478:	89 d0                	mov    %edx,%eax
  80047a:	01 c0                	add    %eax,%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	c1 e0 03             	shl    $0x3,%eax
  800481:	01 c8                	add    %ecx,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800490:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	79 20                	jns    8004ba <CheckAndCountEmptyLocInWS+0x87>
  80049a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8004a1:	77 17                	ja     8004ba <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 34 3d 80 00       	push   $0x803d34
  8004ab:	68 a0 00 00 00       	push   $0xa0
  8004b0:	68 be 3b 80 00       	push   $0x803bbe
  8004b5:	e8 e8 04 00 00       	call   8009a2 <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004ba:	ff 45 f0             	incl   -0x10(%ebp)
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	8b 50 74             	mov    0x74(%eax),%edx
  8004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c6:	39 c2                	cmp    %eax,%edx
  8004c8:	0f 87 7b ff ff ff    	ja     800449 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004ce:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dc:	48                   	dec    %eax
  8004dd:	50                   	push   %eax
  8004de:	6a 00                	push   $0x0
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 06 00 00 00       	call   8004f1 <QSort>
  8004eb:	83 c4 10             	add    $0x10,%esp
}
  8004ee:	90                   	nop
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004fd:	0f 8d de 00 00 00    	jge    8005e1 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	40                   	inc    %eax
  800507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800510:	e9 80 00 00 00       	jmp    800595 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800515:	ff 45 f4             	incl   -0xc(%ebp)
  800518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80051e:	7f 2b                	jg     80054b <QSort+0x5a>
  800520:	8b 45 10             	mov    0x10(%ebp),%eax
  800523:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	01 d0                	add    %edx,%eax
  80052f:	8b 10                	mov    (%eax),%edx
  800531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800534:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	01 c8                	add    %ecx,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	39 c2                	cmp    %eax,%edx
  800544:	7d cf                	jge    800515 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800546:	eb 03                	jmp    80054b <QSort+0x5a>
  800548:	ff 4d f0             	decl   -0x10(%ebp)
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800551:	7e 26                	jle    800579 <QSort+0x88>
  800553:	8b 45 10             	mov    0x10(%ebp),%eax
  800556:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	8b 10                	mov    (%eax),%edx
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	01 c8                	add    %ecx,%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	7e cf                	jle    800548 <QSort+0x57>

		if (i <= j)
  800579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80057f:	7f 14                	jg     800595 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800581:	83 ec 04             	sub    $0x4,%esp
  800584:	ff 75 f0             	pushl  -0x10(%ebp)
  800587:	ff 75 f4             	pushl  -0xc(%ebp)
  80058a:	ff 75 08             	pushl  0x8(%ebp)
  80058d:	e8 a9 00 00 00       	call   80063b <Swap>
  800592:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800598:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059b:	0f 8e 77 ff ff ff    	jle    800518 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005a7:	ff 75 10             	pushl  0x10(%ebp)
  8005aa:	ff 75 08             	pushl  0x8(%ebp)
  8005ad:	e8 89 00 00 00       	call   80063b <Swap>
  8005b2:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b8:	48                   	dec    %eax
  8005b9:	50                   	push   %eax
  8005ba:	ff 75 10             	pushl  0x10(%ebp)
  8005bd:	ff 75 0c             	pushl  0xc(%ebp)
  8005c0:	ff 75 08             	pushl  0x8(%ebp)
  8005c3:	e8 29 ff ff ff       	call   8004f1 <QSort>
  8005c8:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005cb:	ff 75 14             	pushl  0x14(%ebp)
  8005ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d1:	ff 75 0c             	pushl  0xc(%ebp)
  8005d4:	ff 75 08             	pushl  0x8(%ebp)
  8005d7:	e8 15 ff ff ff       	call   8004f1 <QSort>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	eb 01                	jmp    8005e2 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005e1:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005e2:	c9                   	leave  
  8005e3:	c3                   	ret    

008005e4 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
  8005e7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005f8:	eb 33                	jmp    80062d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80060e:	40                   	inc    %eax
  80060f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	01 c8                	add    %ecx,%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	7e 09                	jle    80062a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800621:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800628:	eb 0c                	jmp    800636 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80062a:	ff 45 f8             	incl   -0x8(%ebp)
  80062d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800630:	48                   	dec    %eax
  800631:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800634:	7f c4                	jg     8005fa <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800636:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800639:	c9                   	leave  
  80063a:	c3                   	ret    

0080063b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800641:	8b 45 0c             	mov    0xc(%ebp),%eax
  800644:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800655:	8b 45 0c             	mov    0xc(%ebp),%eax
  800658:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	01 c2                	add    %eax,%edx
  800664:	8b 45 10             	mov    0x10(%ebp),%eax
  800667:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	01 c8                	add    %ecx,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800677:	8b 45 10             	mov    0x10(%ebp),%eax
  80067a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	01 c2                	add    %eax,%edx
  800686:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800689:	89 02                	mov    %eax,(%edx)
}
  80068b:	90                   	nop
  80068c:	c9                   	leave  
  80068d:	c3                   	ret    

0080068e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800694:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80069b:	eb 17                	jmp    8006b4 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80069d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	01 c2                	add    %eax,%edx
  8006ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006af:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b1:	ff 45 fc             	incl   -0x4(%ebp)
  8006b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ba:	7c e1                	jl     80069d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006bc:	90                   	nop
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006cc:	eb 1b                	jmp    8006e9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	01 c2                	add    %eax,%edx
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006e3:	48                   	dec    %eax
  8006e4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006e6:	ff 45 fc             	incl   -0x4(%ebp)
  8006e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ef:	7c dd                	jl     8006ce <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006f1:	90                   	nop
  8006f2:	c9                   	leave  
  8006f3:	c3                   	ret    

008006f4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006fd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800702:	f7 e9                	imul   %ecx
  800704:	c1 f9 1f             	sar    $0x1f,%ecx
  800707:	89 d0                	mov    %edx,%eax
  800709:	29 c8                	sub    %ecx,%eax
  80070b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80070e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800715:	eb 1e                	jmp    800735 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800717:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80072a:	99                   	cltd   
  80072b:	f7 7d f8             	idivl  -0x8(%ebp)
  80072e:	89 d0                	mov    %edx,%eax
  800730:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800732:	ff 45 fc             	incl   -0x4(%ebp)
  800735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800738:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073b:	7c da                	jl     800717 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  80073d:	90                   	nop
  80073e:	c9                   	leave  
  80073f:	c3                   	ret    

00800740 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800746:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80074d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800754:	eb 42                	jmp    800798 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800759:	99                   	cltd   
  80075a:	f7 7d f0             	idivl  -0x10(%ebp)
  80075d:	89 d0                	mov    %edx,%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	75 10                	jne    800773 <PrintElements+0x33>
			cprintf("\n");
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	68 62 3d 80 00       	push   $0x803d62
  80076b:	e8 e6 04 00 00       	call   800c56 <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800776:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	01 d0                	add    %edx,%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	50                   	push   %eax
  800788:	68 64 3d 80 00       	push   $0x803d64
  80078d:	e8 c4 04 00 00       	call   800c56 <cprintf>
  800792:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800795:	ff 45 f4             	incl   -0xc(%ebp)
  800798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079b:	48                   	dec    %eax
  80079c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80079f:	7f b5                	jg     800756 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	01 d0                	add    %edx,%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	50                   	push   %eax
  8007b6:	68 69 3d 80 00       	push   $0x803d69
  8007bb:	e8 96 04 00 00       	call   800c56 <cprintf>
  8007c0:	83 c4 10             	add    $0x10,%esp

}
  8007c3:	90                   	nop
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007d2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007d6:	83 ec 0c             	sub    $0xc,%esp
  8007d9:	50                   	push   %eax
  8007da:	e8 f8 1a 00 00       	call   8022d7 <sys_cputc>
  8007df:	83 c4 10             	add    $0x10,%esp
}
  8007e2:	90                   	nop
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007eb:	e8 b3 1a 00 00       	call   8022a3 <sys_disable_interrupt>
	char c = ch;
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007f6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007fa:	83 ec 0c             	sub    $0xc,%esp
  8007fd:	50                   	push   %eax
  8007fe:	e8 d4 1a 00 00       	call   8022d7 <sys_cputc>
  800803:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800806:	e8 b2 1a 00 00       	call   8022bd <sys_enable_interrupt>
}
  80080b:	90                   	nop
  80080c:	c9                   	leave  
  80080d:	c3                   	ret    

0080080e <getchar>:

int
getchar(void)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800814:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80081b:	eb 08                	jmp    800825 <getchar+0x17>
	{
		c = sys_cgetc();
  80081d:	e8 fc 18 00 00       	call   80211e <sys_cgetc>
  800822:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800829:	74 f2                	je     80081d <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80082b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80082e:	c9                   	leave  
  80082f:	c3                   	ret    

00800830 <atomic_getchar>:

int
atomic_getchar(void)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800836:	e8 68 1a 00 00       	call   8022a3 <sys_disable_interrupt>
	int c=0;
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800842:	eb 08                	jmp    80084c <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800844:	e8 d5 18 00 00       	call   80211e <sys_cgetc>
  800849:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80084c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800850:	74 f2                	je     800844 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800852:	e8 66 1a 00 00       	call   8022bd <sys_enable_interrupt>
	return c;
  800857:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80085a:	c9                   	leave  
  80085b:	c3                   	ret    

0080085c <iscons>:

int iscons(int fdnum)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80085f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80086c:	e8 25 1c 00 00       	call   802496 <sys_getenvindex>
  800871:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800877:	89 d0                	mov    %edx,%eax
  800879:	c1 e0 03             	shl    $0x3,%eax
  80087c:	01 d0                	add    %edx,%eax
  80087e:	01 c0                	add    %eax,%eax
  800880:	01 d0                	add    %edx,%eax
  800882:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800889:	01 d0                	add    %edx,%eax
  80088b:	c1 e0 04             	shl    $0x4,%eax
  80088e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800893:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800898:	a1 24 50 80 00       	mov    0x805024,%eax
  80089d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8008a3:	84 c0                	test   %al,%al
  8008a5:	74 0f                	je     8008b6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8008a7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008ac:	05 5c 05 00 00       	add    $0x55c,%eax
  8008b1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008ba:	7e 0a                	jle    8008c6 <libmain+0x60>
		binaryname = argv[0];
  8008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	ff 75 08             	pushl  0x8(%ebp)
  8008cf:	e8 64 f7 ff ff       	call   800038 <_main>
  8008d4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8008d7:	e8 c7 19 00 00       	call   8022a3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008dc:	83 ec 0c             	sub    $0xc,%esp
  8008df:	68 88 3d 80 00       	push   $0x803d88
  8008e4:	e8 6d 03 00 00       	call   800c56 <cprintf>
  8008e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008ec:	a1 24 50 80 00       	mov    0x805024,%eax
  8008f1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8008f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008fc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800902:	83 ec 04             	sub    $0x4,%esp
  800905:	52                   	push   %edx
  800906:	50                   	push   %eax
  800907:	68 b0 3d 80 00       	push   $0x803db0
  80090c:	e8 45 03 00 00       	call   800c56 <cprintf>
  800911:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800914:	a1 24 50 80 00       	mov    0x805024,%eax
  800919:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80091f:	a1 24 50 80 00       	mov    0x805024,%eax
  800924:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80092a:	a1 24 50 80 00       	mov    0x805024,%eax
  80092f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800935:	51                   	push   %ecx
  800936:	52                   	push   %edx
  800937:	50                   	push   %eax
  800938:	68 d8 3d 80 00       	push   $0x803dd8
  80093d:	e8 14 03 00 00       	call   800c56 <cprintf>
  800942:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800945:	a1 24 50 80 00       	mov    0x805024,%eax
  80094a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	50                   	push   %eax
  800954:	68 30 3e 80 00       	push   $0x803e30
  800959:	e8 f8 02 00 00       	call   800c56 <cprintf>
  80095e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 88 3d 80 00       	push   $0x803d88
  800969:	e8 e8 02 00 00       	call   800c56 <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800971:	e8 47 19 00 00       	call   8022bd <sys_enable_interrupt>

	// exit gracefully
	exit();
  800976:	e8 19 00 00 00       	call   800994 <exit>
}
  80097b:	90                   	nop
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    

0080097e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	6a 00                	push   $0x0
  800989:	e8 d4 1a 00 00       	call   802462 <sys_destroy_env>
  80098e:	83 c4 10             	add    $0x10,%esp
}
  800991:	90                   	nop
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <exit>:

void
exit(void)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80099a:	e8 29 1b 00 00       	call   8024c8 <sys_exit_env>
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ab:	83 c0 04             	add    $0x4,%eax
  8009ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009b1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009b6:	85 c0                	test   %eax,%eax
  8009b8:	74 16                	je     8009d0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009ba:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	50                   	push   %eax
  8009c3:	68 44 3e 80 00       	push   $0x803e44
  8009c8:	e8 89 02 00 00       	call   800c56 <cprintf>
  8009cd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009d0:	a1 00 50 80 00       	mov    0x805000,%eax
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	ff 75 08             	pushl  0x8(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	68 49 3e 80 00       	push   $0x803e49
  8009e1:	e8 70 02 00 00       	call   800c56 <cprintf>
  8009e6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f2:	50                   	push   %eax
  8009f3:	e8 f3 01 00 00       	call   800beb <vcprintf>
  8009f8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	6a 00                	push   $0x0
  800a00:	68 65 3e 80 00       	push   $0x803e65
  800a05:	e8 e1 01 00 00       	call   800beb <vcprintf>
  800a0a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a0d:	e8 82 ff ff ff       	call   800994 <exit>

	// should not return here
	while (1) ;
  800a12:	eb fe                	jmp    800a12 <_panic+0x70>

00800a14 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a1a:	a1 24 50 80 00       	mov    0x805024,%eax
  800a1f:	8b 50 74             	mov    0x74(%eax),%edx
  800a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a25:	39 c2                	cmp    %eax,%edx
  800a27:	74 14                	je     800a3d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	68 68 3e 80 00       	push   $0x803e68
  800a31:	6a 26                	push   $0x26
  800a33:	68 b4 3e 80 00       	push   $0x803eb4
  800a38:	e8 65 ff ff ff       	call   8009a2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a4b:	e9 c2 00 00 00       	jmp    800b12 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a53:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	01 d0                	add    %edx,%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	85 c0                	test   %eax,%eax
  800a63:	75 08                	jne    800a6d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800a65:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a68:	e9 a2 00 00 00       	jmp    800b0f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800a6d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a7b:	eb 69                	jmp    800ae6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a7d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a82:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a88:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a8b:	89 d0                	mov    %edx,%eax
  800a8d:	01 c0                	add    %eax,%eax
  800a8f:	01 d0                	add    %edx,%eax
  800a91:	c1 e0 03             	shl    $0x3,%eax
  800a94:	01 c8                	add    %ecx,%eax
  800a96:	8a 40 04             	mov    0x4(%eax),%al
  800a99:	84 c0                	test   %al,%al
  800a9b:	75 46                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a9d:	a1 24 50 80 00       	mov    0x805024,%eax
  800aa2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	01 c0                	add    %eax,%eax
  800aaf:	01 d0                	add    %edx,%eax
  800ab1:	c1 e0 03             	shl    $0x3,%eax
  800ab4:	01 c8                	add    %ecx,%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800abb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800abe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ac3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	01 c8                	add    %ecx,%eax
  800ad4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ad6:	39 c2                	cmp    %eax,%edx
  800ad8:	75 09                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800ada:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800ae1:	eb 12                	jmp    800af5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ae3:	ff 45 e8             	incl   -0x18(%ebp)
  800ae6:	a1 24 50 80 00       	mov    0x805024,%eax
  800aeb:	8b 50 74             	mov    0x74(%eax),%edx
  800aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af1:	39 c2                	cmp    %eax,%edx
  800af3:	77 88                	ja     800a7d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800af5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800af9:	75 14                	jne    800b0f <CheckWSWithoutLastIndex+0xfb>
			panic(
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 c0 3e 80 00       	push   $0x803ec0
  800b03:	6a 3a                	push   $0x3a
  800b05:	68 b4 3e 80 00       	push   $0x803eb4
  800b0a:	e8 93 fe ff ff       	call   8009a2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b0f:	ff 45 f0             	incl   -0x10(%ebp)
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b18:	0f 8c 32 ff ff ff    	jl     800a50 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b2c:	eb 26                	jmp    800b54 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b2e:	a1 24 50 80 00       	mov    0x805024,%eax
  800b33:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b3c:	89 d0                	mov    %edx,%eax
  800b3e:	01 c0                	add    %eax,%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	c1 e0 03             	shl    $0x3,%eax
  800b45:	01 c8                	add    %ecx,%eax
  800b47:	8a 40 04             	mov    0x4(%eax),%al
  800b4a:	3c 01                	cmp    $0x1,%al
  800b4c:	75 03                	jne    800b51 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800b4e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b51:	ff 45 e0             	incl   -0x20(%ebp)
  800b54:	a1 24 50 80 00       	mov    0x805024,%eax
  800b59:	8b 50 74             	mov    0x74(%eax),%edx
  800b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b5f:	39 c2                	cmp    %eax,%edx
  800b61:	77 cb                	ja     800b2e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b66:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b69:	74 14                	je     800b7f <CheckWSWithoutLastIndex+0x16b>
		panic(
  800b6b:	83 ec 04             	sub    $0x4,%esp
  800b6e:	68 14 3f 80 00       	push   $0x803f14
  800b73:	6a 44                	push   $0x44
  800b75:	68 b4 3e 80 00       	push   $0x803eb4
  800b7a:	e8 23 fe ff ff       	call   8009a2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b7f:	90                   	nop
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 d1                	mov    %dl,%cl
  800b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bab:	75 2c                	jne    800bd9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800bad:	a0 28 50 80 00       	mov    0x805028,%al
  800bb2:	0f b6 c0             	movzbl %al,%eax
  800bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb8:	8b 12                	mov    (%edx),%edx
  800bba:	89 d1                	mov    %edx,%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	83 c2 08             	add    $0x8,%edx
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	50                   	push   %eax
  800bc6:	51                   	push   %ecx
  800bc7:	52                   	push   %edx
  800bc8:	e8 28 15 00 00       	call   8020f5 <sys_cputs>
  800bcd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	8b 40 04             	mov    0x4(%eax),%eax
  800bdf:	8d 50 01             	lea    0x1(%eax),%edx
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	89 50 04             	mov    %edx,0x4(%eax)
}
  800be8:	90                   	nop
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bf4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bfb:	00 00 00 
	b.cnt = 0;
  800bfe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c05:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	ff 75 08             	pushl  0x8(%ebp)
  800c0e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	68 82 0b 80 00       	push   $0x800b82
  800c1a:	e8 11 02 00 00       	call   800e30 <vprintfmt>
  800c1f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c22:	a0 28 50 80 00       	mov    0x805028,%al
  800c27:	0f b6 c0             	movzbl %al,%eax
  800c2a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	50                   	push   %eax
  800c34:	52                   	push   %edx
  800c35:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c3b:	83 c0 08             	add    $0x8,%eax
  800c3e:	50                   	push   %eax
  800c3f:	e8 b1 14 00 00       	call   8020f5 <sys_cputs>
  800c44:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c47:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800c4e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <cprintf>:

int cprintf(const char *fmt, ...) {
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c5c:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800c63:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	83 ec 08             	sub    $0x8,%esp
  800c6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c72:	50                   	push   %eax
  800c73:	e8 73 ff ff ff       	call   800beb <vcprintf>
  800c78:	83 c4 10             	add    $0x10,%esp
  800c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c89:	e8 15 16 00 00       	call   8022a3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c8e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	e8 48 ff ff ff       	call   800beb <vcprintf>
  800ca3:	83 c4 10             	add    $0x10,%esp
  800ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ca9:	e8 0f 16 00 00       	call   8022bd <sys_enable_interrupt>
	return cnt;
  800cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 14             	sub    $0x14,%esp
  800cba:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cc6:	8b 45 18             	mov    0x18(%ebp),%eax
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd1:	77 55                	ja     800d28 <printnum+0x75>
  800cd3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd6:	72 05                	jb     800cdd <printnum+0x2a>
  800cd8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cdb:	77 4b                	ja     800d28 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cdd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ce0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ce3:	8b 45 18             	mov    0x18(%ebp),%eax
  800ce6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ceb:	52                   	push   %edx
  800cec:	50                   	push   %eax
  800ced:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf0:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf3:	e8 b8 2b 00 00       	call   8038b0 <__udivdi3>
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	83 ec 04             	sub    $0x4,%esp
  800cfe:	ff 75 20             	pushl  0x20(%ebp)
  800d01:	53                   	push   %ebx
  800d02:	ff 75 18             	pushl  0x18(%ebp)
  800d05:	52                   	push   %edx
  800d06:	50                   	push   %eax
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	ff 75 08             	pushl  0x8(%ebp)
  800d0d:	e8 a1 ff ff ff       	call   800cb3 <printnum>
  800d12:	83 c4 20             	add    $0x20,%esp
  800d15:	eb 1a                	jmp    800d31 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 20             	pushl  0x20(%ebp)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d28:	ff 4d 1c             	decl   0x1c(%ebp)
  800d2b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d2f:	7f e6                	jg     800d17 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d31:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3f:	53                   	push   %ebx
  800d40:	51                   	push   %ecx
  800d41:	52                   	push   %edx
  800d42:	50                   	push   %eax
  800d43:	e8 78 2c 00 00       	call   8039c0 <__umoddi3>
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	05 74 41 80 00       	add    $0x804174,%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f be c0             	movsbl %al,%eax
  800d55:	83 ec 08             	sub    $0x8,%esp
  800d58:	ff 75 0c             	pushl  0xc(%ebp)
  800d5b:	50                   	push   %eax
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	ff d0                	call   *%eax
  800d61:	83 c4 10             	add    $0x10,%esp
}
  800d64:	90                   	nop
  800d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d6d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d71:	7e 1c                	jle    800d8f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	8d 50 08             	lea    0x8(%eax),%edx
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 10                	mov    %edx,(%eax)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	83 e8 08             	sub    $0x8,%eax
  800d88:	8b 50 04             	mov    0x4(%eax),%edx
  800d8b:	8b 00                	mov    (%eax),%eax
  800d8d:	eb 40                	jmp    800dcf <getuint+0x65>
	else if (lflag)
  800d8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d93:	74 1e                	je     800db3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8b 00                	mov    (%eax),%eax
  800d9a:	8d 50 04             	lea    0x4(%eax),%edx
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 10                	mov    %edx,(%eax)
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8b 00                	mov    (%eax),%eax
  800da7:	83 e8 04             	sub    $0x4,%eax
  800daa:	8b 00                	mov    (%eax),%eax
  800dac:	ba 00 00 00 00       	mov    $0x0,%edx
  800db1:	eb 1c                	jmp    800dcf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	8d 50 04             	lea    0x4(%eax),%edx
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 10                	mov    %edx,(%eax)
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	83 e8 04             	sub    $0x4,%eax
  800dc8:	8b 00                	mov    (%eax),%eax
  800dca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    

00800dd1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dd8:	7e 1c                	jle    800df6 <getint+0x25>
		return va_arg(*ap, long long);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	8d 50 08             	lea    0x8(%eax),%edx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 10                	mov    %edx,(%eax)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	83 e8 08             	sub    $0x8,%eax
  800def:	8b 50 04             	mov    0x4(%eax),%edx
  800df2:	8b 00                	mov    (%eax),%eax
  800df4:	eb 38                	jmp    800e2e <getint+0x5d>
	else if (lflag)
  800df6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfa:	74 1a                	je     800e16 <getint+0x45>
		return va_arg(*ap, long);
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8b 00                	mov    (%eax),%eax
  800e01:	8d 50 04             	lea    0x4(%eax),%edx
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 10                	mov    %edx,(%eax)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8b 00                	mov    (%eax),%eax
  800e0e:	83 e8 04             	sub    $0x4,%eax
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	99                   	cltd   
  800e14:	eb 18                	jmp    800e2e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8b 00                	mov    (%eax),%eax
  800e1b:	8d 50 04             	lea    0x4(%eax),%edx
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 10                	mov    %edx,(%eax)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8b 00                	mov    (%eax),%eax
  800e28:	83 e8 04             	sub    $0x4,%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	99                   	cltd   
}
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e38:	eb 17                	jmp    800e51 <vprintfmt+0x21>
			if (ch == '\0')
  800e3a:	85 db                	test   %ebx,%ebx
  800e3c:	0f 84 af 03 00 00    	je     8011f1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	53                   	push   %ebx
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e51:	8b 45 10             	mov    0x10(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 d8             	movzbl %al,%ebx
  800e5f:	83 fb 25             	cmp    $0x25,%ebx
  800e62:	75 d6                	jne    800e3a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e64:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e68:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e84:	8b 45 10             	mov    0x10(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	0f b6 d8             	movzbl %al,%ebx
  800e92:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e95:	83 f8 55             	cmp    $0x55,%eax
  800e98:	0f 87 2b 03 00 00    	ja     8011c9 <vprintfmt+0x399>
  800e9e:	8b 04 85 98 41 80 00 	mov    0x804198(,%eax,4),%eax
  800ea5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ea7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800eab:	eb d7                	jmp    800e84 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ead:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800eb1:	eb d1                	jmp    800e84 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ebd:	89 d0                	mov    %edx,%eax
  800ebf:	c1 e0 02             	shl    $0x2,%eax
  800ec2:	01 d0                	add    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d8                	add    %ebx,%eax
  800ec8:	83 e8 30             	sub    $0x30,%eax
  800ecb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ece:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ed6:	83 fb 2f             	cmp    $0x2f,%ebx
  800ed9:	7e 3e                	jle    800f19 <vprintfmt+0xe9>
  800edb:	83 fb 39             	cmp    $0x39,%ebx
  800ede:	7f 39                	jg     800f19 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ee0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ee3:	eb d5                	jmp    800eba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ee5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee8:	83 c0 04             	add    $0x4,%eax
  800eeb:	89 45 14             	mov    %eax,0x14(%ebp)
  800eee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef1:	83 e8 04             	sub    $0x4,%eax
  800ef4:	8b 00                	mov    (%eax),%eax
  800ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ef9:	eb 1f                	jmp    800f1a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800efb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eff:	79 83                	jns    800e84 <vprintfmt+0x54>
				width = 0;
  800f01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f08:	e9 77 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f0d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f14:	e9 6b ff ff ff       	jmp    800e84 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f19:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1e:	0f 89 60 ff ff ff    	jns    800e84 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f2a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f31:	e9 4e ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f36:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f39:	e9 46 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 14             	mov    %eax,0x14(%ebp)
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	83 e8 04             	sub    $0x4,%eax
  800f4d:	8b 00                	mov    (%eax),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	50                   	push   %eax
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	ff d0                	call   *%eax
  800f5b:	83 c4 10             	add    $0x10,%esp
			break;
  800f5e:	e9 89 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f63:	8b 45 14             	mov    0x14(%ebp),%eax
  800f66:	83 c0 04             	add    $0x4,%eax
  800f69:	89 45 14             	mov    %eax,0x14(%ebp)
  800f6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6f:	83 e8 04             	sub    $0x4,%eax
  800f72:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f74:	85 db                	test   %ebx,%ebx
  800f76:	79 02                	jns    800f7a <vprintfmt+0x14a>
				err = -err;
  800f78:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f7a:	83 fb 64             	cmp    $0x64,%ebx
  800f7d:	7f 0b                	jg     800f8a <vprintfmt+0x15a>
  800f7f:	8b 34 9d e0 3f 80 00 	mov    0x803fe0(,%ebx,4),%esi
  800f86:	85 f6                	test   %esi,%esi
  800f88:	75 19                	jne    800fa3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f8a:	53                   	push   %ebx
  800f8b:	68 85 41 80 00       	push   $0x804185
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	ff 75 08             	pushl  0x8(%ebp)
  800f96:	e8 5e 02 00 00       	call   8011f9 <printfmt>
  800f9b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f9e:	e9 49 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa3:	56                   	push   %esi
  800fa4:	68 8e 41 80 00       	push   $0x80418e
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 45 02 00 00       	call   8011f9 <printfmt>
  800fb4:	83 c4 10             	add    $0x10,%esp
			break;
  800fb7:	e9 30 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbf:	83 c0 04             	add    $0x4,%eax
  800fc2:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc8:	83 e8 04             	sub    $0x4,%eax
  800fcb:	8b 30                	mov    (%eax),%esi
  800fcd:	85 f6                	test   %esi,%esi
  800fcf:	75 05                	jne    800fd6 <vprintfmt+0x1a6>
				p = "(null)";
  800fd1:	be 91 41 80 00       	mov    $0x804191,%esi
			if (width > 0 && padc != '-')
  800fd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fda:	7e 6d                	jle    801049 <vprintfmt+0x219>
  800fdc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fe0:	74 67                	je     801049 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	50                   	push   %eax
  800fe9:	56                   	push   %esi
  800fea:	e8 12 05 00 00       	call   801501 <strnlen>
  800fef:	83 c4 10             	add    $0x10,%esp
  800ff2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ff5:	eb 16                	jmp    80100d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ff7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	50                   	push   %eax
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	ff d0                	call   *%eax
  801007:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80100a:	ff 4d e4             	decl   -0x1c(%ebp)
  80100d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801011:	7f e4                	jg     800ff7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801013:	eb 34                	jmp    801049 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801015:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801019:	74 1c                	je     801037 <vprintfmt+0x207>
  80101b:	83 fb 1f             	cmp    $0x1f,%ebx
  80101e:	7e 05                	jle    801025 <vprintfmt+0x1f5>
  801020:	83 fb 7e             	cmp    $0x7e,%ebx
  801023:	7e 12                	jle    801037 <vprintfmt+0x207>
					putch('?', putdat);
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	6a 3f                	push   $0x3f
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	ff d0                	call   *%eax
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	eb 0f                	jmp    801046 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	ff 75 0c             	pushl  0xc(%ebp)
  80103d:	53                   	push   %ebx
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	ff d0                	call   *%eax
  801043:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801046:	ff 4d e4             	decl   -0x1c(%ebp)
  801049:	89 f0                	mov    %esi,%eax
  80104b:	8d 70 01             	lea    0x1(%eax),%esi
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f be d8             	movsbl %al,%ebx
  801053:	85 db                	test   %ebx,%ebx
  801055:	74 24                	je     80107b <vprintfmt+0x24b>
  801057:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80105b:	78 b8                	js     801015 <vprintfmt+0x1e5>
  80105d:	ff 4d e0             	decl   -0x20(%ebp)
  801060:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801064:	79 af                	jns    801015 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801066:	eb 13                	jmp    80107b <vprintfmt+0x24b>
				putch(' ', putdat);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 0c             	pushl  0xc(%ebp)
  80106e:	6a 20                	push   $0x20
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	ff d0                	call   *%eax
  801075:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801078:	ff 4d e4             	decl   -0x1c(%ebp)
  80107b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80107f:	7f e7                	jg     801068 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801081:	e9 66 01 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	ff 75 e8             	pushl  -0x18(%ebp)
  80108c:	8d 45 14             	lea    0x14(%ebp),%eax
  80108f:	50                   	push   %eax
  801090:	e8 3c fd ff ff       	call   800dd1 <getint>
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80109e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a4:	85 d2                	test   %edx,%edx
  8010a6:	79 23                	jns    8010cb <vprintfmt+0x29b>
				putch('-', putdat);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	6a 2d                	push   $0x2d
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010be:	f7 d8                	neg    %eax
  8010c0:	83 d2 00             	adc    $0x0,%edx
  8010c3:	f7 da                	neg    %edx
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d2:	e9 bc 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	ff 75 e8             	pushl  -0x18(%ebp)
  8010dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e0:	50                   	push   %eax
  8010e1:	e8 84 fc ff ff       	call   800d6a <getuint>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010ef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010f6:	e9 98 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	6a 58                	push   $0x58
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 0c             	pushl  0xc(%ebp)
  801111:	6a 58                	push   $0x58
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	ff d0                	call   *%eax
  801118:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	6a 58                	push   $0x58
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	ff d0                	call   *%eax
  801128:	83 c4 10             	add    $0x10,%esp
			break;
  80112b:	e9 bc 00 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	6a 30                	push   $0x30
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	ff d0                	call   *%eax
  80113d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	6a 78                	push   $0x78
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	ff d0                	call   *%eax
  80114d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801150:	8b 45 14             	mov    0x14(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 14             	mov    %eax,0x14(%ebp)
  801159:	8b 45 14             	mov    0x14(%ebp),%eax
  80115c:	83 e8 04             	sub    $0x4,%eax
  80115f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801164:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80116b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801172:	eb 1f                	jmp    801193 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801174:	83 ec 08             	sub    $0x8,%esp
  801177:	ff 75 e8             	pushl  -0x18(%ebp)
  80117a:	8d 45 14             	lea    0x14(%ebp),%eax
  80117d:	50                   	push   %eax
  80117e:	e8 e7 fb ff ff       	call   800d6a <getuint>
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801189:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80118c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801193:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	52                   	push   %edx
  80119e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a1:	50                   	push   %eax
  8011a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 00 fb ff ff       	call   800cb3 <printnum>
  8011b3:	83 c4 20             	add    $0x20,%esp
			break;
  8011b6:	eb 34                	jmp    8011ec <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	ff 75 0c             	pushl  0xc(%ebp)
  8011be:	53                   	push   %ebx
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	ff d0                	call   *%eax
  8011c4:	83 c4 10             	add    $0x10,%esp
			break;
  8011c7:	eb 23                	jmp    8011ec <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011c9:	83 ec 08             	sub    $0x8,%esp
  8011cc:	ff 75 0c             	pushl  0xc(%ebp)
  8011cf:	6a 25                	push   $0x25
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	ff d0                	call   *%eax
  8011d6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011d9:	ff 4d 10             	decl   0x10(%ebp)
  8011dc:	eb 03                	jmp    8011e1 <vprintfmt+0x3b1>
  8011de:	ff 4d 10             	decl   0x10(%ebp)
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	48                   	dec    %eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	3c 25                	cmp    $0x25,%al
  8011e9:	75 f3                	jne    8011de <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8011eb:	90                   	nop
		}
	}
  8011ec:	e9 47 fc ff ff       	jmp    800e38 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011f1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ff:	8d 45 10             	lea    0x10(%ebp),%eax
  801202:	83 c0 04             	add    $0x4,%eax
  801205:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	ff 75 f4             	pushl  -0xc(%ebp)
  80120e:	50                   	push   %eax
  80120f:	ff 75 0c             	pushl  0xc(%ebp)
  801212:	ff 75 08             	pushl  0x8(%ebp)
  801215:	e8 16 fc ff ff       	call   800e30 <vprintfmt>
  80121a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	8b 40 08             	mov    0x8(%eax),%eax
  801229:	8d 50 01             	lea    0x1(%eax),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	8b 10                	mov    (%eax),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8b 40 04             	mov    0x4(%eax),%eax
  80123d:	39 c2                	cmp    %eax,%edx
  80123f:	73 12                	jae    801253 <sprintputch+0x33>
		*b->buf++ = ch;
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	8b 00                	mov    (%eax),%eax
  801246:	8d 48 01             	lea    0x1(%eax),%ecx
  801249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124c:	89 0a                	mov    %ecx,(%edx)
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	88 10                	mov    %dl,(%eax)
}
  801253:	90                   	nop
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	8d 50 ff             	lea    -0x1(%eax),%edx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	01 d0                	add    %edx,%eax
  80126d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801270:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801277:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127b:	74 06                	je     801283 <vsnprintf+0x2d>
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	7f 07                	jg     80128a <vsnprintf+0x34>
		return -E_INVAL;
  801283:	b8 03 00 00 00       	mov    $0x3,%eax
  801288:	eb 20                	jmp    8012aa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80128a:	ff 75 14             	pushl  0x14(%ebp)
  80128d:	ff 75 10             	pushl  0x10(%ebp)
  801290:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801293:	50                   	push   %eax
  801294:	68 20 12 80 00       	push   $0x801220
  801299:	e8 92 fb ff ff       	call   800e30 <vprintfmt>
  80129e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b5:	83 c0 04             	add    $0x4,%eax
  8012b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	ff 75 08             	pushl  0x8(%ebp)
  8012c8:	e8 89 ff ff ff       	call   801256 <vsnprintf>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8012de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e2:	74 13                	je     8012f7 <readline+0x1f>
		cprintf("%s", prompt);
  8012e4:	83 ec 08             	sub    $0x8,%esp
  8012e7:	ff 75 08             	pushl  0x8(%ebp)
  8012ea:	68 f0 42 80 00       	push   $0x8042f0
  8012ef:	e8 62 f9 ff ff       	call   800c56 <cprintf>
  8012f4:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fe:	83 ec 0c             	sub    $0xc,%esp
  801301:	6a 00                	push   $0x0
  801303:	e8 54 f5 ff ff       	call   80085c <iscons>
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130e:	e8 fb f4 ff ff       	call   80080e <getchar>
  801313:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801316:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80131a:	79 22                	jns    80133e <readline+0x66>
			if (c != -E_EOF)
  80131c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801320:	0f 84 ad 00 00 00    	je     8013d3 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801326:	83 ec 08             	sub    $0x8,%esp
  801329:	ff 75 ec             	pushl  -0x14(%ebp)
  80132c:	68 f3 42 80 00       	push   $0x8042f3
  801331:	e8 20 f9 ff ff       	call   800c56 <cprintf>
  801336:	83 c4 10             	add    $0x10,%esp
			return;
  801339:	e9 95 00 00 00       	jmp    8013d3 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801342:	7e 34                	jle    801378 <readline+0xa0>
  801344:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134b:	7f 2b                	jg     801378 <readline+0xa0>
			if (echoing)
  80134d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801351:	74 0e                	je     801361 <readline+0x89>
				cputchar(c);
  801353:	83 ec 0c             	sub    $0xc,%esp
  801356:	ff 75 ec             	pushl  -0x14(%ebp)
  801359:	e8 68 f4 ff ff       	call   8007c6 <cputchar>
  80135e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	88 10                	mov    %dl,(%eax)
  801376:	eb 56                	jmp    8013ce <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801378:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137c:	75 1f                	jne    80139d <readline+0xc5>
  80137e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801382:	7e 19                	jle    80139d <readline+0xc5>
			if (echoing)
  801384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801388:	74 0e                	je     801398 <readline+0xc0>
				cputchar(c);
  80138a:	83 ec 0c             	sub    $0xc,%esp
  80138d:	ff 75 ec             	pushl  -0x14(%ebp)
  801390:	e8 31 f4 ff ff       	call   8007c6 <cputchar>
  801395:	83 c4 10             	add    $0x10,%esp

			i--;
  801398:	ff 4d f4             	decl   -0xc(%ebp)
  80139b:	eb 31                	jmp    8013ce <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80139d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a1:	74 0a                	je     8013ad <readline+0xd5>
  8013a3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a7:	0f 85 61 ff ff ff    	jne    80130e <readline+0x36>
			if (echoing)
  8013ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b1:	74 0e                	je     8013c1 <readline+0xe9>
				cputchar(c);
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b9:	e8 08 f4 ff ff       	call   8007c6 <cputchar>
  8013be:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8013c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8013cc:	eb 06                	jmp    8013d4 <readline+0xfc>
		}
	}
  8013ce:	e9 3b ff ff ff       	jmp    80130e <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8013d3:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8013dc:	e8 c2 0e 00 00       	call   8022a3 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8013e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e5:	74 13                	je     8013fa <atomic_readline+0x24>
		cprintf("%s", prompt);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	ff 75 08             	pushl  0x8(%ebp)
  8013ed:	68 f0 42 80 00       	push   $0x8042f0
  8013f2:	e8 5f f8 ff ff       	call   800c56 <cprintf>
  8013f7:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8013fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	6a 00                	push   $0x0
  801406:	e8 51 f4 ff ff       	call   80085c <iscons>
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801411:	e8 f8 f3 ff ff       	call   80080e <getchar>
  801416:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801419:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80141d:	79 23                	jns    801442 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80141f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801423:	74 13                	je     801438 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 ec             	pushl  -0x14(%ebp)
  80142b:	68 f3 42 80 00       	push   $0x8042f3
  801430:	e8 21 f8 ff ff       	call   800c56 <cprintf>
  801435:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801438:	e8 80 0e 00 00       	call   8022bd <sys_enable_interrupt>
			return;
  80143d:	e9 9a 00 00 00       	jmp    8014dc <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801442:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801446:	7e 34                	jle    80147c <atomic_readline+0xa6>
  801448:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80144f:	7f 2b                	jg     80147c <atomic_readline+0xa6>
			if (echoing)
  801451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801455:	74 0e                	je     801465 <atomic_readline+0x8f>
				cputchar(c);
  801457:	83 ec 0c             	sub    $0xc,%esp
  80145a:	ff 75 ec             	pushl  -0x14(%ebp)
  80145d:	e8 64 f3 ff ff       	call   8007c6 <cputchar>
  801462:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80146e:	89 c2                	mov    %eax,%edx
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801478:	88 10                	mov    %dl,(%eax)
  80147a:	eb 5b                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80147c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801480:	75 1f                	jne    8014a1 <atomic_readline+0xcb>
  801482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801486:	7e 19                	jle    8014a1 <atomic_readline+0xcb>
			if (echoing)
  801488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80148c:	74 0e                	je     80149c <atomic_readline+0xc6>
				cputchar(c);
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	ff 75 ec             	pushl  -0x14(%ebp)
  801494:	e8 2d f3 ff ff       	call   8007c6 <cputchar>
  801499:	83 c4 10             	add    $0x10,%esp
			i--;
  80149c:	ff 4d f4             	decl   -0xc(%ebp)
  80149f:	eb 36                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8014a1:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8014a5:	74 0a                	je     8014b1 <atomic_readline+0xdb>
  8014a7:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8014ab:	0f 85 60 ff ff ff    	jne    801411 <atomic_readline+0x3b>
			if (echoing)
  8014b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014b5:	74 0e                	je     8014c5 <atomic_readline+0xef>
				cputchar(c);
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8014bd:	e8 04 f3 ff ff       	call   8007c6 <cputchar>
  8014c2:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8014c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cb:	01 d0                	add    %edx,%eax
  8014cd:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8014d0:	e8 e8 0d 00 00       	call   8022bd <sys_enable_interrupt>
			return;
  8014d5:	eb 05                	jmp    8014dc <atomic_readline+0x106>
		}
	}
  8014d7:	e9 35 ff ff ff       	jmp    801411 <atomic_readline+0x3b>
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014eb:	eb 06                	jmp    8014f3 <strlen+0x15>
		n++;
  8014ed:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014f0:	ff 45 08             	incl   0x8(%ebp)
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	84 c0                	test   %al,%al
  8014fa:	75 f1                	jne    8014ed <strlen+0xf>
		n++;
	return n;
  8014fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801507:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80150e:	eb 09                	jmp    801519 <strnlen+0x18>
		n++;
  801510:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801513:	ff 45 08             	incl   0x8(%ebp)
  801516:	ff 4d 0c             	decl   0xc(%ebp)
  801519:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151d:	74 09                	je     801528 <strnlen+0x27>
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	84 c0                	test   %al,%al
  801526:	75 e8                	jne    801510 <strnlen+0xf>
		n++;
	return n;
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801539:	90                   	nop
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8d 50 01             	lea    0x1(%eax),%edx
  801540:	89 55 08             	mov    %edx,0x8(%ebp)
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	8d 4a 01             	lea    0x1(%edx),%ecx
  801549:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80154c:	8a 12                	mov    (%edx),%dl
  80154e:	88 10                	mov    %dl,(%eax)
  801550:	8a 00                	mov    (%eax),%al
  801552:	84 c0                	test   %al,%al
  801554:	75 e4                	jne    80153a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801556:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80156e:	eb 1f                	jmp    80158f <strncpy+0x34>
		*dst++ = *src;
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 08             	mov    %edx,0x8(%ebp)
  801579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	8a 00                	mov    (%eax),%al
  801585:	84 c0                	test   %al,%al
  801587:	74 03                	je     80158c <strncpy+0x31>
			src++;
  801589:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80158c:	ff 45 fc             	incl   -0x4(%ebp)
  80158f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801592:	3b 45 10             	cmp    0x10(%ebp),%eax
  801595:	72 d9                	jb     801570 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801597:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8015a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ac:	74 30                	je     8015de <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8015ae:	eb 16                	jmp    8015c6 <strlcpy+0x2a>
			*dst++ = *src++;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8d 50 01             	lea    0x1(%eax),%edx
  8015b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015c2:	8a 12                	mov    (%edx),%dl
  8015c4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015c6:	ff 4d 10             	decl   0x10(%ebp)
  8015c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015cd:	74 09                	je     8015d8 <strlcpy+0x3c>
  8015cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	84 c0                	test   %al,%al
  8015d6:	75 d8                	jne    8015b0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015de:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e4:	29 c2                	sub    %eax,%edx
  8015e6:	89 d0                	mov    %edx,%eax
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015ed:	eb 06                	jmp    8015f5 <strcmp+0xb>
		p++, q++;
  8015ef:	ff 45 08             	incl   0x8(%ebp)
  8015f2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	74 0e                	je     80160c <strcmp+0x22>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 10                	mov    (%eax),%dl
  801603:	8b 45 0c             	mov    0xc(%ebp),%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	38 c2                	cmp    %al,%dl
  80160a:	74 e3                	je     8015ef <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8a 00                	mov    (%eax),%al
  801611:	0f b6 d0             	movzbl %al,%edx
  801614:	8b 45 0c             	mov    0xc(%ebp),%eax
  801617:	8a 00                	mov    (%eax),%al
  801619:	0f b6 c0             	movzbl %al,%eax
  80161c:	29 c2                	sub    %eax,%edx
  80161e:	89 d0                	mov    %edx,%eax
}
  801620:	5d                   	pop    %ebp
  801621:	c3                   	ret    

00801622 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801625:	eb 09                	jmp    801630 <strncmp+0xe>
		n--, p++, q++;
  801627:	ff 4d 10             	decl   0x10(%ebp)
  80162a:	ff 45 08             	incl   0x8(%ebp)
  80162d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801630:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801634:	74 17                	je     80164d <strncmp+0x2b>
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8a 00                	mov    (%eax),%al
  80163b:	84 c0                	test   %al,%al
  80163d:	74 0e                	je     80164d <strncmp+0x2b>
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8a 10                	mov    (%eax),%dl
  801644:	8b 45 0c             	mov    0xc(%ebp),%eax
  801647:	8a 00                	mov    (%eax),%al
  801649:	38 c2                	cmp    %al,%dl
  80164b:	74 da                	je     801627 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80164d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801651:	75 07                	jne    80165a <strncmp+0x38>
		return 0;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	eb 14                	jmp    80166e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	8a 00                	mov    (%eax),%al
  80165f:	0f b6 d0             	movzbl %al,%edx
  801662:	8b 45 0c             	mov    0xc(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	0f b6 c0             	movzbl %al,%eax
  80166a:	29 c2                	sub    %eax,%edx
  80166c:	89 d0                	mov    %edx,%eax
}
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80167c:	eb 12                	jmp    801690 <strchr+0x20>
		if (*s == c)
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801686:	75 05                	jne    80168d <strchr+0x1d>
			return (char *) s;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	eb 11                	jmp    80169e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80168d:	ff 45 08             	incl   0x8(%ebp)
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	84 c0                	test   %al,%al
  801697:	75 e5                	jne    80167e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8016ac:	eb 0d                	jmp    8016bb <strfind+0x1b>
		if (*s == c)
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8016b6:	74 0e                	je     8016c6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016b8:	ff 45 08             	incl   0x8(%ebp)
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	84 c0                	test   %al,%al
  8016c2:	75 ea                	jne    8016ae <strfind+0xe>
  8016c4:	eb 01                	jmp    8016c7 <strfind+0x27>
		if (*s == c)
			break;
  8016c6:	90                   	nop
	return (char *) s;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016de:	eb 0e                	jmp    8016ee <memset+0x22>
		*p++ = c;
  8016e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e3:	8d 50 01             	lea    0x1(%eax),%edx
  8016e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ec:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016ee:	ff 4d f8             	decl   -0x8(%ebp)
  8016f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016f5:	79 e9                	jns    8016e0 <memset+0x14>
		*p++ = c;

	return v;
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801702:	8b 45 0c             	mov    0xc(%ebp),%eax
  801705:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80170e:	eb 16                	jmp    801726 <memcpy+0x2a>
		*d++ = *s++;
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	8d 50 01             	lea    0x1(%eax),%edx
  801716:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801719:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80171f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801722:	8a 12                	mov    (%edx),%dl
  801724:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801726:	8b 45 10             	mov    0x10(%ebp),%eax
  801729:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172c:	89 55 10             	mov    %edx,0x10(%ebp)
  80172f:	85 c0                	test   %eax,%eax
  801731:	75 dd                	jne    801710 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80173e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801741:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80174d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801750:	73 50                	jae    8017a2 <memmove+0x6a>
  801752:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	01 d0                	add    %edx,%eax
  80175a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80175d:	76 43                	jbe    8017a2 <memmove+0x6a>
		s += n;
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801765:	8b 45 10             	mov    0x10(%ebp),%eax
  801768:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80176b:	eb 10                	jmp    80177d <memmove+0x45>
			*--d = *--s;
  80176d:	ff 4d f8             	decl   -0x8(%ebp)
  801770:	ff 4d fc             	decl   -0x4(%ebp)
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801776:	8a 10                	mov    (%eax),%dl
  801778:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80177d:	8b 45 10             	mov    0x10(%ebp),%eax
  801780:	8d 50 ff             	lea    -0x1(%eax),%edx
  801783:	89 55 10             	mov    %edx,0x10(%ebp)
  801786:	85 c0                	test   %eax,%eax
  801788:	75 e3                	jne    80176d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80178a:	eb 23                	jmp    8017af <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80178c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801795:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801798:	8d 4a 01             	lea    0x1(%edx),%ecx
  80179b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80179e:	8a 12                	mov    (%edx),%dl
  8017a0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8017a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	75 dd                	jne    80178c <memmove+0x54>
			*d++ = *s++;

	return dst;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8017c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8017c6:	eb 2a                	jmp    8017f2 <memcmp+0x3e>
		if (*s1 != *s2)
  8017c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017cb:	8a 10                	mov    (%eax),%dl
  8017cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	38 c2                	cmp    %al,%dl
  8017d4:	74 16                	je     8017ec <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f b6 d0             	movzbl %al,%edx
  8017de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	0f b6 c0             	movzbl %al,%eax
  8017e6:	29 c2                	sub    %eax,%edx
  8017e8:	89 d0                	mov    %edx,%eax
  8017ea:	eb 18                	jmp    801804 <memcmp+0x50>
		s1++, s2++;
  8017ec:	ff 45 fc             	incl   -0x4(%ebp)
  8017ef:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	75 c9                	jne    8017c8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80180c:	8b 55 08             	mov    0x8(%ebp),%edx
  80180f:	8b 45 10             	mov    0x10(%ebp),%eax
  801812:	01 d0                	add    %edx,%eax
  801814:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801817:	eb 15                	jmp    80182e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8a 00                	mov    (%eax),%al
  80181e:	0f b6 d0             	movzbl %al,%edx
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	0f b6 c0             	movzbl %al,%eax
  801827:	39 c2                	cmp    %eax,%edx
  801829:	74 0d                	je     801838 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80182b:	ff 45 08             	incl   0x8(%ebp)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801834:	72 e3                	jb     801819 <memfind+0x13>
  801836:	eb 01                	jmp    801839 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801838:	90                   	nop
	return (void *) s;
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801844:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80184b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801852:	eb 03                	jmp    801857 <strtol+0x19>
		s++;
  801854:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 20                	cmp    $0x20,%al
  80185e:	74 f4                	je     801854 <strtol+0x16>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 09                	cmp    $0x9,%al
  801867:	74 eb                	je     801854 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	3c 2b                	cmp    $0x2b,%al
  801870:	75 05                	jne    801877 <strtol+0x39>
		s++;
  801872:	ff 45 08             	incl   0x8(%ebp)
  801875:	eb 13                	jmp    80188a <strtol+0x4c>
	else if (*s == '-')
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	8a 00                	mov    (%eax),%al
  80187c:	3c 2d                	cmp    $0x2d,%al
  80187e:	75 0a                	jne    80188a <strtol+0x4c>
		s++, neg = 1;
  801880:	ff 45 08             	incl   0x8(%ebp)
  801883:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80188e:	74 06                	je     801896 <strtol+0x58>
  801890:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801894:	75 20                	jne    8018b6 <strtol+0x78>
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	8a 00                	mov    (%eax),%al
  80189b:	3c 30                	cmp    $0x30,%al
  80189d:	75 17                	jne    8018b6 <strtol+0x78>
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	40                   	inc    %eax
  8018a3:	8a 00                	mov    (%eax),%al
  8018a5:	3c 78                	cmp    $0x78,%al
  8018a7:	75 0d                	jne    8018b6 <strtol+0x78>
		s += 2, base = 16;
  8018a9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8018ad:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8018b4:	eb 28                	jmp    8018de <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8018b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018ba:	75 15                	jne    8018d1 <strtol+0x93>
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8a 00                	mov    (%eax),%al
  8018c1:	3c 30                	cmp    $0x30,%al
  8018c3:	75 0c                	jne    8018d1 <strtol+0x93>
		s++, base = 8;
  8018c5:	ff 45 08             	incl   0x8(%ebp)
  8018c8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018cf:	eb 0d                	jmp    8018de <strtol+0xa0>
	else if (base == 0)
  8018d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018d5:	75 07                	jne    8018de <strtol+0xa0>
		base = 10;
  8018d7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	3c 2f                	cmp    $0x2f,%al
  8018e5:	7e 19                	jle    801900 <strtol+0xc2>
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	3c 39                	cmp    $0x39,%al
  8018ee:	7f 10                	jg     801900 <strtol+0xc2>
			dig = *s - '0';
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	0f be c0             	movsbl %al,%eax
  8018f8:	83 e8 30             	sub    $0x30,%eax
  8018fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018fe:	eb 42                	jmp    801942 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	8a 00                	mov    (%eax),%al
  801905:	3c 60                	cmp    $0x60,%al
  801907:	7e 19                	jle    801922 <strtol+0xe4>
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	8a 00                	mov    (%eax),%al
  80190e:	3c 7a                	cmp    $0x7a,%al
  801910:	7f 10                	jg     801922 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	8a 00                	mov    (%eax),%al
  801917:	0f be c0             	movsbl %al,%eax
  80191a:	83 e8 57             	sub    $0x57,%eax
  80191d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801920:	eb 20                	jmp    801942 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	8a 00                	mov    (%eax),%al
  801927:	3c 40                	cmp    $0x40,%al
  801929:	7e 39                	jle    801964 <strtol+0x126>
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	8a 00                	mov    (%eax),%al
  801930:	3c 5a                	cmp    $0x5a,%al
  801932:	7f 30                	jg     801964 <strtol+0x126>
			dig = *s - 'A' + 10;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8a 00                	mov    (%eax),%al
  801939:	0f be c0             	movsbl %al,%eax
  80193c:	83 e8 37             	sub    $0x37,%eax
  80193f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	3b 45 10             	cmp    0x10(%ebp),%eax
  801948:	7d 19                	jge    801963 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80194a:	ff 45 08             	incl   0x8(%ebp)
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	0f af 45 10          	imul   0x10(%ebp),%eax
  801954:	89 c2                	mov    %eax,%edx
  801956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801959:	01 d0                	add    %edx,%eax
  80195b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80195e:	e9 7b ff ff ff       	jmp    8018de <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801963:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801964:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801968:	74 08                	je     801972 <strtol+0x134>
		*endptr = (char *) s;
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	8b 55 08             	mov    0x8(%ebp),%edx
  801970:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801972:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801976:	74 07                	je     80197f <strtol+0x141>
  801978:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197b:	f7 d8                	neg    %eax
  80197d:	eb 03                	jmp    801982 <strtol+0x144>
  80197f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <ltostr>:

void
ltostr(long value, char *str)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80198a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801991:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801998:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80199c:	79 13                	jns    8019b1 <ltostr+0x2d>
	{
		neg = 1;
  80199e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8019ab:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8019ae:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8019b9:	99                   	cltd   
  8019ba:	f7 f9                	idiv   %ecx
  8019bc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8019bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c2:	8d 50 01             	lea    0x1(%eax),%edx
  8019c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019c8:	89 c2                	mov    %eax,%edx
  8019ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cd:	01 d0                	add    %edx,%eax
  8019cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019d2:	83 c2 30             	add    $0x30,%edx
  8019d5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019df:	f7 e9                	imul   %ecx
  8019e1:	c1 fa 02             	sar    $0x2,%edx
  8019e4:	89 c8                	mov    %ecx,%eax
  8019e6:	c1 f8 1f             	sar    $0x1f,%eax
  8019e9:	29 c2                	sub    %eax,%edx
  8019eb:	89 d0                	mov    %edx,%eax
  8019ed:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8019f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019f3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019f8:	f7 e9                	imul   %ecx
  8019fa:	c1 fa 02             	sar    $0x2,%edx
  8019fd:	89 c8                	mov    %ecx,%eax
  8019ff:	c1 f8 1f             	sar    $0x1f,%eax
  801a02:	29 c2                	sub    %eax,%edx
  801a04:	89 d0                	mov    %edx,%eax
  801a06:	c1 e0 02             	shl    $0x2,%eax
  801a09:	01 d0                	add    %edx,%eax
  801a0b:	01 c0                	add    %eax,%eax
  801a0d:	29 c1                	sub    %eax,%ecx
  801a0f:	89 ca                	mov    %ecx,%edx
  801a11:	85 d2                	test   %edx,%edx
  801a13:	75 9c                	jne    8019b1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1f:	48                   	dec    %eax
  801a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a23:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a27:	74 3d                	je     801a66 <ltostr+0xe2>
		start = 1 ;
  801a29:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a30:	eb 34                	jmp    801a66 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	8a 00                	mov    (%eax),%al
  801a3c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a45:	01 c2                	add    %eax,%edx
  801a47:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4d:	01 c8                	add    %ecx,%eax
  801a4f:	8a 00                	mov    (%eax),%al
  801a51:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a59:	01 c2                	add    %eax,%edx
  801a5b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a5e:	88 02                	mov    %al,(%edx)
		start++ ;
  801a60:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a63:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a6c:	7c c4                	jl     801a32 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a6e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a74:	01 d0                	add    %edx,%eax
  801a76:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a79:	90                   	nop
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a82:	ff 75 08             	pushl  0x8(%ebp)
  801a85:	e8 54 fa ff ff       	call   8014de <strlen>
  801a8a:	83 c4 04             	add    $0x4,%esp
  801a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	e8 46 fa ff ff       	call   8014de <strlen>
  801a98:	83 c4 04             	add    $0x4,%esp
  801a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801aa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801aac:	eb 17                	jmp    801ac5 <strcconcat+0x49>
		final[s] = str1[s] ;
  801aae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab4:	01 c2                	add    %eax,%edx
  801ab6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	01 c8                	add    %ecx,%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ac2:	ff 45 fc             	incl   -0x4(%ebp)
  801ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801acb:	7c e1                	jl     801aae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801acd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ad4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801adb:	eb 1f                	jmp    801afc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801add:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae0:	8d 50 01             	lea    0x1(%eax),%edx
  801ae3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ae6:	89 c2                	mov    %eax,%edx
  801ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  801aeb:	01 c2                	add    %eax,%edx
  801aed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af3:	01 c8                	add    %ecx,%eax
  801af5:	8a 00                	mov    (%eax),%al
  801af7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801af9:	ff 45 f8             	incl   -0x8(%ebp)
  801afc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b02:	7c d9                	jl     801add <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b07:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0a:	01 d0                	add    %edx,%eax
  801b0c:	c6 00 00             	movb   $0x0,(%eax)
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b15:	8b 45 14             	mov    0x14(%ebp),%eax
  801b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b21:	8b 00                	mov    (%eax),%eax
  801b23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2d:	01 d0                	add    %edx,%eax
  801b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b35:	eb 0c                	jmp    801b43 <strsplit+0x31>
			*string++ = 0;
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	8d 50 01             	lea    0x1(%eax),%edx
  801b3d:	89 55 08             	mov    %edx,0x8(%ebp)
  801b40:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	8a 00                	mov    (%eax),%al
  801b48:	84 c0                	test   %al,%al
  801b4a:	74 18                	je     801b64 <strsplit+0x52>
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	8a 00                	mov    (%eax),%al
  801b51:	0f be c0             	movsbl %al,%eax
  801b54:	50                   	push   %eax
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	e8 13 fb ff ff       	call   801670 <strchr>
  801b5d:	83 c4 08             	add    $0x8,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	75 d3                	jne    801b37 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	8a 00                	mov    (%eax),%al
  801b69:	84 c0                	test   %al,%al
  801b6b:	74 5a                	je     801bc7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b70:	8b 00                	mov    (%eax),%eax
  801b72:	83 f8 0f             	cmp    $0xf,%eax
  801b75:	75 07                	jne    801b7e <strsplit+0x6c>
		{
			return 0;
  801b77:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7c:	eb 66                	jmp    801be4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b81:	8b 00                	mov    (%eax),%eax
  801b83:	8d 48 01             	lea    0x1(%eax),%ecx
  801b86:	8b 55 14             	mov    0x14(%ebp),%edx
  801b89:	89 0a                	mov    %ecx,(%edx)
  801b8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b92:	8b 45 10             	mov    0x10(%ebp),%eax
  801b95:	01 c2                	add    %eax,%edx
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b9c:	eb 03                	jmp    801ba1 <strsplit+0x8f>
			string++;
  801b9e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	8a 00                	mov    (%eax),%al
  801ba6:	84 c0                	test   %al,%al
  801ba8:	74 8b                	je     801b35 <strsplit+0x23>
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	8a 00                	mov    (%eax),%al
  801baf:	0f be c0             	movsbl %al,%eax
  801bb2:	50                   	push   %eax
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	e8 b5 fa ff ff       	call   801670 <strchr>
  801bbb:	83 c4 08             	add    $0x8,%esp
  801bbe:	85 c0                	test   %eax,%eax
  801bc0:	74 dc                	je     801b9e <strsplit+0x8c>
			string++;
	}
  801bc2:	e9 6e ff ff ff       	jmp    801b35 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801bc7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcb:	8b 00                	mov    (%eax),%eax
  801bcd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd7:	01 d0                	add    %edx,%eax
  801bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801bdf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801bec:	a1 04 50 80 00       	mov    0x805004,%eax
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	74 1f                	je     801c14 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801bf5:	e8 1d 00 00 00       	call   801c17 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801bfa:	83 ec 0c             	sub    $0xc,%esp
  801bfd:	68 04 43 80 00       	push   $0x804304
  801c02:	e8 4f f0 ff ff       	call   800c56 <cprintf>
  801c07:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801c0a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801c11:	00 00 00 
	}
}
  801c14:	90                   	nop
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801c1d:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801c24:	00 00 00 
  801c27:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801c2e:	00 00 00 
  801c31:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801c38:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801c3b:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801c42:	00 00 00 
  801c45:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801c4c:	00 00 00 
  801c4f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801c56:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801c59:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801c60:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801c63:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c72:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c77:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801c7c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801c83:	a1 20 51 80 00       	mov    0x805120,%eax
  801c88:	c1 e0 04             	shl    $0x4,%eax
  801c8b:	89 c2                	mov    %eax,%edx
  801c8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c90:	01 d0                	add    %edx,%eax
  801c92:	48                   	dec    %eax
  801c93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801c96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c99:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9e:	f7 75 f0             	divl   -0x10(%ebp)
  801ca1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ca4:	29 d0                	sub    %edx,%eax
  801ca6:	89 c2                	mov    %eax,%edx
  801ca8:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801caf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801cb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801cb7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cbc:	83 ec 04             	sub    $0x4,%esp
  801cbf:	6a 06                	push   $0x6
  801cc1:	52                   	push   %edx
  801cc2:	50                   	push   %eax
  801cc3:	e8 71 05 00 00       	call   802239 <sys_allocate_chunk>
  801cc8:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ccb:	a1 20 51 80 00       	mov    0x805120,%eax
  801cd0:	83 ec 0c             	sub    $0xc,%esp
  801cd3:	50                   	push   %eax
  801cd4:	e8 e6 0b 00 00       	call   8028bf <initialize_MemBlocksList>
  801cd9:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801cdc:	a1 48 51 80 00       	mov    0x805148,%eax
  801ce1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801ce4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ce8:	75 14                	jne    801cfe <initialize_dyn_block_system+0xe7>
  801cea:	83 ec 04             	sub    $0x4,%esp
  801ced:	68 29 43 80 00       	push   $0x804329
  801cf2:	6a 2b                	push   $0x2b
  801cf4:	68 47 43 80 00       	push   $0x804347
  801cf9:	e8 a4 ec ff ff       	call   8009a2 <_panic>
  801cfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d01:	8b 00                	mov    (%eax),%eax
  801d03:	85 c0                	test   %eax,%eax
  801d05:	74 10                	je     801d17 <initialize_dyn_block_system+0x100>
  801d07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d0a:	8b 00                	mov    (%eax),%eax
  801d0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d0f:	8b 52 04             	mov    0x4(%edx),%edx
  801d12:	89 50 04             	mov    %edx,0x4(%eax)
  801d15:	eb 0b                	jmp    801d22 <initialize_dyn_block_system+0x10b>
  801d17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d1a:	8b 40 04             	mov    0x4(%eax),%eax
  801d1d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801d22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d25:	8b 40 04             	mov    0x4(%eax),%eax
  801d28:	85 c0                	test   %eax,%eax
  801d2a:	74 0f                	je     801d3b <initialize_dyn_block_system+0x124>
  801d2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d2f:	8b 40 04             	mov    0x4(%eax),%eax
  801d32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801d35:	8b 12                	mov    (%edx),%edx
  801d37:	89 10                	mov    %edx,(%eax)
  801d39:	eb 0a                	jmp    801d45 <initialize_dyn_block_system+0x12e>
  801d3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d3e:	8b 00                	mov    (%eax),%eax
  801d40:	a3 48 51 80 00       	mov    %eax,0x805148
  801d45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d58:	a1 54 51 80 00       	mov    0x805154,%eax
  801d5d:	48                   	dec    %eax
  801d5e:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d66:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801d6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d70:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801d77:	83 ec 0c             	sub    $0xc,%esp
  801d7a:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d7d:	e8 d2 13 00 00       	call   803154 <insert_sorted_with_merge_freeList>
  801d82:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801d85:	90                   	nop
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d8e:	e8 53 fe ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d97:	75 07                	jne    801da0 <malloc+0x18>
  801d99:	b8 00 00 00 00       	mov    $0x0,%eax
  801d9e:	eb 61                	jmp    801e01 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801da0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801da7:	8b 55 08             	mov    0x8(%ebp),%edx
  801daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dad:	01 d0                	add    %edx,%eax
  801daf:	48                   	dec    %eax
  801db0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db6:	ba 00 00 00 00       	mov    $0x0,%edx
  801dbb:	f7 75 f4             	divl   -0xc(%ebp)
  801dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dc1:	29 d0                	sub    %edx,%eax
  801dc3:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801dc6:	e8 3c 08 00 00       	call   802607 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dcb:	85 c0                	test   %eax,%eax
  801dcd:	74 2d                	je     801dfc <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801dcf:	83 ec 0c             	sub    $0xc,%esp
  801dd2:	ff 75 08             	pushl  0x8(%ebp)
  801dd5:	e8 3e 0f 00 00       	call   802d18 <alloc_block_FF>
  801dda:	83 c4 10             	add    $0x10,%esp
  801ddd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801de0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801de4:	74 16                	je     801dfc <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801de6:	83 ec 0c             	sub    $0xc,%esp
  801de9:	ff 75 ec             	pushl  -0x14(%ebp)
  801dec:	e8 48 0c 00 00       	call   802a39 <insert_sorted_allocList>
  801df1:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801df4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801df7:	8b 40 08             	mov    0x8(%eax),%eax
  801dfa:	eb 05                	jmp    801e01 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801e17:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1d:	83 ec 08             	sub    $0x8,%esp
  801e20:	50                   	push   %eax
  801e21:	68 40 50 80 00       	push   $0x805040
  801e26:	e8 71 0b 00 00       	call   80299c <find_block>
  801e2b:	83 c4 10             	add    $0x10,%esp
  801e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e34:	8b 50 0c             	mov    0xc(%eax),%edx
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	83 ec 08             	sub    $0x8,%esp
  801e3d:	52                   	push   %edx
  801e3e:	50                   	push   %eax
  801e3f:	e8 bd 03 00 00       	call   802201 <sys_free_user_mem>
  801e44:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801e47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e4b:	75 14                	jne    801e61 <free+0x5e>
  801e4d:	83 ec 04             	sub    $0x4,%esp
  801e50:	68 29 43 80 00       	push   $0x804329
  801e55:	6a 71                	push   $0x71
  801e57:	68 47 43 80 00       	push   $0x804347
  801e5c:	e8 41 eb ff ff       	call   8009a2 <_panic>
  801e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e64:	8b 00                	mov    (%eax),%eax
  801e66:	85 c0                	test   %eax,%eax
  801e68:	74 10                	je     801e7a <free+0x77>
  801e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6d:	8b 00                	mov    (%eax),%eax
  801e6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e72:	8b 52 04             	mov    0x4(%edx),%edx
  801e75:	89 50 04             	mov    %edx,0x4(%eax)
  801e78:	eb 0b                	jmp    801e85 <free+0x82>
  801e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7d:	8b 40 04             	mov    0x4(%eax),%eax
  801e80:	a3 44 50 80 00       	mov    %eax,0x805044
  801e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e88:	8b 40 04             	mov    0x4(%eax),%eax
  801e8b:	85 c0                	test   %eax,%eax
  801e8d:	74 0f                	je     801e9e <free+0x9b>
  801e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e92:	8b 40 04             	mov    0x4(%eax),%eax
  801e95:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e98:	8b 12                	mov    (%edx),%edx
  801e9a:	89 10                	mov    %edx,(%eax)
  801e9c:	eb 0a                	jmp    801ea8 <free+0xa5>
  801e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea1:	8b 00                	mov    (%eax),%eax
  801ea3:	a3 40 50 80 00       	mov    %eax,0x805040
  801ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ebb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ec0:	48                   	dec    %eax
  801ec1:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801ec6:	83 ec 0c             	sub    $0xc,%esp
  801ec9:	ff 75 f0             	pushl  -0x10(%ebp)
  801ecc:	e8 83 12 00 00       	call   803154 <insert_sorted_with_merge_freeList>
  801ed1:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801ed4:	90                   	nop
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 28             	sub    $0x28,%esp
  801edd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee0:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ee3:	e8 fe fc ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ee8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eec:	75 0a                	jne    801ef8 <smalloc+0x21>
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef3:	e9 86 00 00 00       	jmp    801f7e <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801ef8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801eff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f05:	01 d0                	add    %edx,%eax
  801f07:	48                   	dec    %eax
  801f08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f13:	f7 75 f4             	divl   -0xc(%ebp)
  801f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f19:	29 d0                	sub    %edx,%eax
  801f1b:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801f1e:	e8 e4 06 00 00       	call   802607 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f23:	85 c0                	test   %eax,%eax
  801f25:	74 52                	je     801f79 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801f27:	83 ec 0c             	sub    $0xc,%esp
  801f2a:	ff 75 0c             	pushl  0xc(%ebp)
  801f2d:	e8 e6 0d 00 00       	call   802d18 <alloc_block_FF>
  801f32:	83 c4 10             	add    $0x10,%esp
  801f35:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801f38:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f3c:	75 07                	jne    801f45 <smalloc+0x6e>
			return NULL ;
  801f3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f43:	eb 39                	jmp    801f7e <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801f45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f48:	8b 40 08             	mov    0x8(%eax),%eax
  801f4b:	89 c2                	mov    %eax,%edx
  801f4d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801f51:	52                   	push   %edx
  801f52:	50                   	push   %eax
  801f53:	ff 75 0c             	pushl  0xc(%ebp)
  801f56:	ff 75 08             	pushl  0x8(%ebp)
  801f59:	e8 2e 04 00 00       	call   80238c <sys_createSharedObject>
  801f5e:	83 c4 10             	add    $0x10,%esp
  801f61:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801f64:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801f68:	79 07                	jns    801f71 <smalloc+0x9a>
			return (void*)NULL ;
  801f6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6f:	eb 0d                	jmp    801f7e <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801f71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f74:	8b 40 08             	mov    0x8(%eax),%eax
  801f77:	eb 05                	jmp    801f7e <smalloc+0xa7>
		}
		return (void*)NULL ;
  801f79:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f86:	e8 5b fc ff ff       	call   801be6 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f8b:	83 ec 08             	sub    $0x8,%esp
  801f8e:	ff 75 0c             	pushl  0xc(%ebp)
  801f91:	ff 75 08             	pushl  0x8(%ebp)
  801f94:	e8 1d 04 00 00       	call   8023b6 <sys_getSizeOfSharedObject>
  801f99:	83 c4 10             	add    $0x10,%esp
  801f9c:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801f9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa3:	75 0a                	jne    801faf <sget+0x2f>
			return NULL ;
  801fa5:	b8 00 00 00 00       	mov    $0x0,%eax
  801faa:	e9 83 00 00 00       	jmp    802032 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801faf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbc:	01 d0                	add    %edx,%eax
  801fbe:	48                   	dec    %eax
  801fbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801fc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fc5:	ba 00 00 00 00       	mov    $0x0,%edx
  801fca:	f7 75 f0             	divl   -0x10(%ebp)
  801fcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd0:	29 d0                	sub    %edx,%eax
  801fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801fd5:	e8 2d 06 00 00       	call   802607 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fda:	85 c0                	test   %eax,%eax
  801fdc:	74 4f                	je     80202d <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	83 ec 0c             	sub    $0xc,%esp
  801fe4:	50                   	push   %eax
  801fe5:	e8 2e 0d 00 00       	call   802d18 <alloc_block_FF>
  801fea:	83 c4 10             	add    $0x10,%esp
  801fed:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801ff0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801ff4:	75 07                	jne    801ffd <sget+0x7d>
					return (void*)NULL ;
  801ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffb:	eb 35                	jmp    802032 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801ffd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802000:	8b 40 08             	mov    0x8(%eax),%eax
  802003:	83 ec 04             	sub    $0x4,%esp
  802006:	50                   	push   %eax
  802007:	ff 75 0c             	pushl  0xc(%ebp)
  80200a:	ff 75 08             	pushl  0x8(%ebp)
  80200d:	e8 c1 03 00 00       	call   8023d3 <sys_getSharedObject>
  802012:	83 c4 10             	add    $0x10,%esp
  802015:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  802018:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80201c:	79 07                	jns    802025 <sget+0xa5>
				return (void*)NULL ;
  80201e:	b8 00 00 00 00       	mov    $0x0,%eax
  802023:	eb 0d                	jmp    802032 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  802025:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802028:	8b 40 08             	mov    0x8(%eax),%eax
  80202b:	eb 05                	jmp    802032 <sget+0xb2>


		}
	return (void*)NULL ;
  80202d:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80203a:	e8 a7 fb ff ff       	call   801be6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80203f:	83 ec 04             	sub    $0x4,%esp
  802042:	68 54 43 80 00       	push   $0x804354
  802047:	68 f9 00 00 00       	push   $0xf9
  80204c:	68 47 43 80 00       	push   $0x804347
  802051:	e8 4c e9 ff ff       	call   8009a2 <_panic>

00802056 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	68 7c 43 80 00       	push   $0x80437c
  802064:	68 0d 01 00 00       	push   $0x10d
  802069:	68 47 43 80 00       	push   $0x804347
  80206e:	e8 2f e9 ff ff       	call   8009a2 <_panic>

00802073 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
  802076:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802079:	83 ec 04             	sub    $0x4,%esp
  80207c:	68 a0 43 80 00       	push   $0x8043a0
  802081:	68 18 01 00 00       	push   $0x118
  802086:	68 47 43 80 00       	push   $0x804347
  80208b:	e8 12 e9 ff ff       	call   8009a2 <_panic>

00802090 <shrink>:

}
void shrink(uint32 newSize)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802096:	83 ec 04             	sub    $0x4,%esp
  802099:	68 a0 43 80 00       	push   $0x8043a0
  80209e:	68 1d 01 00 00       	push   $0x11d
  8020a3:	68 47 43 80 00       	push   $0x804347
  8020a8:	e8 f5 e8 ff ff       	call   8009a2 <_panic>

008020ad <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020b3:	83 ec 04             	sub    $0x4,%esp
  8020b6:	68 a0 43 80 00       	push   $0x8043a0
  8020bb:	68 22 01 00 00       	push   $0x122
  8020c0:	68 47 43 80 00       	push   $0x804347
  8020c5:	e8 d8 e8 ff ff       	call   8009a2 <_panic>

008020ca <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	57                   	push   %edi
  8020ce:	56                   	push   %esi
  8020cf:	53                   	push   %ebx
  8020d0:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020df:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020e2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020e5:	cd 30                	int    $0x30
  8020e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020ed:	83 c4 10             	add    $0x10,%esp
  8020f0:	5b                   	pop    %ebx
  8020f1:	5e                   	pop    %esi
  8020f2:	5f                   	pop    %edi
  8020f3:	5d                   	pop    %ebp
  8020f4:	c3                   	ret    

008020f5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8020fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802101:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802105:	8b 45 08             	mov    0x8(%ebp),%eax
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	52                   	push   %edx
  80210d:	ff 75 0c             	pushl  0xc(%ebp)
  802110:	50                   	push   %eax
  802111:	6a 00                	push   $0x0
  802113:	e8 b2 ff ff ff       	call   8020ca <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	90                   	nop
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sys_cgetc>:

int
sys_cgetc(void)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802121:	6a 00                	push   $0x0
  802123:	6a 00                	push   $0x0
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 01                	push   $0x1
  80212d:	e8 98 ff ff ff       	call   8020ca <syscall>
  802132:	83 c4 18             	add    $0x18,%esp
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80213a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	52                   	push   %edx
  802147:	50                   	push   %eax
  802148:	6a 05                	push   $0x5
  80214a:	e8 7b ff ff ff       	call   8020ca <syscall>
  80214f:	83 c4 18             	add    $0x18,%esp
}
  802152:	c9                   	leave  
  802153:	c3                   	ret    

00802154 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802154:	55                   	push   %ebp
  802155:	89 e5                	mov    %esp,%ebp
  802157:	56                   	push   %esi
  802158:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802159:	8b 75 18             	mov    0x18(%ebp),%esi
  80215c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80215f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802162:	8b 55 0c             	mov    0xc(%ebp),%edx
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	56                   	push   %esi
  802169:	53                   	push   %ebx
  80216a:	51                   	push   %ecx
  80216b:	52                   	push   %edx
  80216c:	50                   	push   %eax
  80216d:	6a 06                	push   $0x6
  80216f:	e8 56 ff ff ff       	call   8020ca <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
}
  802177:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80217a:	5b                   	pop    %ebx
  80217b:	5e                   	pop    %esi
  80217c:	5d                   	pop    %ebp
  80217d:	c3                   	ret    

0080217e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802181:	8b 55 0c             	mov    0xc(%ebp),%edx
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	52                   	push   %edx
  80218e:	50                   	push   %eax
  80218f:	6a 07                	push   $0x7
  802191:	e8 34 ff ff ff       	call   8020ca <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80219e:	6a 00                	push   $0x0
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	ff 75 0c             	pushl  0xc(%ebp)
  8021a7:	ff 75 08             	pushl  0x8(%ebp)
  8021aa:	6a 08                	push   $0x8
  8021ac:	e8 19 ff ff ff       	call   8020ca <syscall>
  8021b1:	83 c4 18             	add    $0x18,%esp
}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 09                	push   $0x9
  8021c5:	e8 00 ff ff ff       	call   8020ca <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
}
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 0a                	push   $0xa
  8021de:	e8 e7 fe ff ff       	call   8020ca <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021e8:	55                   	push   %ebp
  8021e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 0b                	push   $0xb
  8021f7:	e8 ce fe ff ff       	call   8020ca <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	ff 75 0c             	pushl  0xc(%ebp)
  80220d:	ff 75 08             	pushl  0x8(%ebp)
  802210:	6a 0f                	push   $0xf
  802212:	e8 b3 fe ff ff       	call   8020ca <syscall>
  802217:	83 c4 18             	add    $0x18,%esp
	return;
  80221a:	90                   	nop
}
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	ff 75 0c             	pushl  0xc(%ebp)
  802229:	ff 75 08             	pushl  0x8(%ebp)
  80222c:	6a 10                	push   $0x10
  80222e:	e8 97 fe ff ff       	call   8020ca <syscall>
  802233:	83 c4 18             	add    $0x18,%esp
	return ;
  802236:	90                   	nop
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80223c:	6a 00                	push   $0x0
  80223e:	6a 00                	push   $0x0
  802240:	ff 75 10             	pushl  0x10(%ebp)
  802243:	ff 75 0c             	pushl  0xc(%ebp)
  802246:	ff 75 08             	pushl  0x8(%ebp)
  802249:	6a 11                	push   $0x11
  80224b:	e8 7a fe ff ff       	call   8020ca <syscall>
  802250:	83 c4 18             	add    $0x18,%esp
	return ;
  802253:	90                   	nop
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 0c                	push   $0xc
  802265:	e8 60 fe ff ff       	call   8020ca <syscall>
  80226a:	83 c4 18             	add    $0x18,%esp
}
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	6a 00                	push   $0x0
  80227a:	ff 75 08             	pushl  0x8(%ebp)
  80227d:	6a 0d                	push   $0xd
  80227f:	e8 46 fe ff ff       	call   8020ca <syscall>
  802284:	83 c4 18             	add    $0x18,%esp
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 0e                	push   $0xe
  802298:	e8 2d fe ff ff       	call   8020ca <syscall>
  80229d:	83 c4 18             	add    $0x18,%esp
}
  8022a0:	90                   	nop
  8022a1:	c9                   	leave  
  8022a2:	c3                   	ret    

008022a3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8022a3:	55                   	push   %ebp
  8022a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 13                	push   $0x13
  8022b2:	e8 13 fe ff ff       	call   8020ca <syscall>
  8022b7:	83 c4 18             	add    $0x18,%esp
}
  8022ba:	90                   	nop
  8022bb:	c9                   	leave  
  8022bc:	c3                   	ret    

008022bd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8022bd:	55                   	push   %ebp
  8022be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 14                	push   $0x14
  8022cc:	e8 f9 fd ff ff       	call   8020ca <syscall>
  8022d1:	83 c4 18             	add    $0x18,%esp
}
  8022d4:	90                   	nop
  8022d5:	c9                   	leave  
  8022d6:	c3                   	ret    

008022d7 <sys_cputc>:


void
sys_cputc(const char c)
{
  8022d7:	55                   	push   %ebp
  8022d8:	89 e5                	mov    %esp,%ebp
  8022da:	83 ec 04             	sub    $0x4,%esp
  8022dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022e3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	50                   	push   %eax
  8022f0:	6a 15                	push   $0x15
  8022f2:	e8 d3 fd ff ff       	call   8020ca <syscall>
  8022f7:	83 c4 18             	add    $0x18,%esp
}
  8022fa:	90                   	nop
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 16                	push   $0x16
  80230c:	e8 b9 fd ff ff       	call   8020ca <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
}
  802314:	90                   	nop
  802315:	c9                   	leave  
  802316:	c3                   	ret    

00802317 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802317:	55                   	push   %ebp
  802318:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	ff 75 0c             	pushl  0xc(%ebp)
  802326:	50                   	push   %eax
  802327:	6a 17                	push   $0x17
  802329:	e8 9c fd ff ff       	call   8020ca <syscall>
  80232e:	83 c4 18             	add    $0x18,%esp
}
  802331:	c9                   	leave  
  802332:	c3                   	ret    

00802333 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802336:	8b 55 0c             	mov    0xc(%ebp),%edx
  802339:	8b 45 08             	mov    0x8(%ebp),%eax
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	52                   	push   %edx
  802343:	50                   	push   %eax
  802344:	6a 1a                	push   $0x1a
  802346:	e8 7f fd ff ff       	call   8020ca <syscall>
  80234b:	83 c4 18             	add    $0x18,%esp
}
  80234e:	c9                   	leave  
  80234f:	c3                   	ret    

00802350 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802353:	8b 55 0c             	mov    0xc(%ebp),%edx
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	6a 00                	push   $0x0
  80235f:	52                   	push   %edx
  802360:	50                   	push   %eax
  802361:	6a 18                	push   $0x18
  802363:	e8 62 fd ff ff       	call   8020ca <syscall>
  802368:	83 c4 18             	add    $0x18,%esp
}
  80236b:	90                   	nop
  80236c:	c9                   	leave  
  80236d:	c3                   	ret    

0080236e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802371:	8b 55 0c             	mov    0xc(%ebp),%edx
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	52                   	push   %edx
  80237e:	50                   	push   %eax
  80237f:	6a 19                	push   $0x19
  802381:	e8 44 fd ff ff       	call   8020ca <syscall>
  802386:	83 c4 18             	add    $0x18,%esp
}
  802389:	90                   	nop
  80238a:	c9                   	leave  
  80238b:	c3                   	ret    

0080238c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80238c:	55                   	push   %ebp
  80238d:	89 e5                	mov    %esp,%ebp
  80238f:	83 ec 04             	sub    $0x4,%esp
  802392:	8b 45 10             	mov    0x10(%ebp),%eax
  802395:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802398:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80239b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a2:	6a 00                	push   $0x0
  8023a4:	51                   	push   %ecx
  8023a5:	52                   	push   %edx
  8023a6:	ff 75 0c             	pushl  0xc(%ebp)
  8023a9:	50                   	push   %eax
  8023aa:	6a 1b                	push   $0x1b
  8023ac:	e8 19 fd ff ff       	call   8020ca <syscall>
  8023b1:	83 c4 18             	add    $0x18,%esp
}
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	6a 00                	push   $0x0
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	52                   	push   %edx
  8023c6:	50                   	push   %eax
  8023c7:	6a 1c                	push   $0x1c
  8023c9:	e8 fc fc ff ff       	call   8020ca <syscall>
  8023ce:	83 c4 18             	add    $0x18,%esp
}
  8023d1:	c9                   	leave  
  8023d2:	c3                   	ret    

008023d3 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	51                   	push   %ecx
  8023e4:	52                   	push   %edx
  8023e5:	50                   	push   %eax
  8023e6:	6a 1d                	push   $0x1d
  8023e8:	e8 dd fc ff ff       	call   8020ca <syscall>
  8023ed:	83 c4 18             	add    $0x18,%esp
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	52                   	push   %edx
  802402:	50                   	push   %eax
  802403:	6a 1e                	push   $0x1e
  802405:	e8 c0 fc ff ff       	call   8020ca <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
}
  80240d:	c9                   	leave  
  80240e:	c3                   	ret    

0080240f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802412:	6a 00                	push   $0x0
  802414:	6a 00                	push   $0x0
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	6a 00                	push   $0x0
  80241c:	6a 1f                	push   $0x1f
  80241e:	e8 a7 fc ff ff       	call   8020ca <syscall>
  802423:	83 c4 18             	add    $0x18,%esp
}
  802426:	c9                   	leave  
  802427:	c3                   	ret    

00802428 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	6a 00                	push   $0x0
  802430:	ff 75 14             	pushl  0x14(%ebp)
  802433:	ff 75 10             	pushl  0x10(%ebp)
  802436:	ff 75 0c             	pushl  0xc(%ebp)
  802439:	50                   	push   %eax
  80243a:	6a 20                	push   $0x20
  80243c:	e8 89 fc ff ff       	call   8020ca <syscall>
  802441:	83 c4 18             	add    $0x18,%esp
}
  802444:	c9                   	leave  
  802445:	c3                   	ret    

00802446 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	6a 00                	push   $0x0
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	50                   	push   %eax
  802455:	6a 21                	push   $0x21
  802457:	e8 6e fc ff ff       	call   8020ca <syscall>
  80245c:	83 c4 18             	add    $0x18,%esp
}
  80245f:	90                   	nop
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	50                   	push   %eax
  802471:	6a 22                	push   $0x22
  802473:	e8 52 fc ff ff       	call   8020ca <syscall>
  802478:	83 c4 18             	add    $0x18,%esp
}
  80247b:	c9                   	leave  
  80247c:	c3                   	ret    

0080247d <sys_getenvid>:

int32 sys_getenvid(void)
{
  80247d:	55                   	push   %ebp
  80247e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 02                	push   $0x2
  80248c:	e8 39 fc ff ff       	call   8020ca <syscall>
  802491:	83 c4 18             	add    $0x18,%esp
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802499:	6a 00                	push   $0x0
  80249b:	6a 00                	push   $0x0
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 03                	push   $0x3
  8024a5:	e8 20 fc ff ff       	call   8020ca <syscall>
  8024aa:	83 c4 18             	add    $0x18,%esp
}
  8024ad:	c9                   	leave  
  8024ae:	c3                   	ret    

008024af <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 04                	push   $0x4
  8024be:	e8 07 fc ff ff       	call   8020ca <syscall>
  8024c3:	83 c4 18             	add    $0x18,%esp
}
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <sys_exit_env>:


void sys_exit_env(void)
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 00                	push   $0x0
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	6a 23                	push   $0x23
  8024d7:	e8 ee fb ff ff       	call   8020ca <syscall>
  8024dc:	83 c4 18             	add    $0x18,%esp
}
  8024df:	90                   	nop
  8024e0:	c9                   	leave  
  8024e1:	c3                   	ret    

008024e2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
  8024e5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024e8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024eb:	8d 50 04             	lea    0x4(%eax),%edx
  8024ee:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024f1:	6a 00                	push   $0x0
  8024f3:	6a 00                	push   $0x0
  8024f5:	6a 00                	push   $0x0
  8024f7:	52                   	push   %edx
  8024f8:	50                   	push   %eax
  8024f9:	6a 24                	push   $0x24
  8024fb:	e8 ca fb ff ff       	call   8020ca <syscall>
  802500:	83 c4 18             	add    $0x18,%esp
	return result;
  802503:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802506:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802509:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80250c:	89 01                	mov    %eax,(%ecx)
  80250e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802511:	8b 45 08             	mov    0x8(%ebp),%eax
  802514:	c9                   	leave  
  802515:	c2 04 00             	ret    $0x4

00802518 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	ff 75 10             	pushl  0x10(%ebp)
  802522:	ff 75 0c             	pushl  0xc(%ebp)
  802525:	ff 75 08             	pushl  0x8(%ebp)
  802528:	6a 12                	push   $0x12
  80252a:	e8 9b fb ff ff       	call   8020ca <syscall>
  80252f:	83 c4 18             	add    $0x18,%esp
	return ;
  802532:	90                   	nop
}
  802533:	c9                   	leave  
  802534:	c3                   	ret    

00802535 <sys_rcr2>:
uint32 sys_rcr2()
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802538:	6a 00                	push   $0x0
  80253a:	6a 00                	push   $0x0
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 25                	push   $0x25
  802544:	e8 81 fb ff ff       	call   8020ca <syscall>
  802549:	83 c4 18             	add    $0x18,%esp
}
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	83 ec 04             	sub    $0x4,%esp
  802554:	8b 45 08             	mov    0x8(%ebp),%eax
  802557:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80255a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	6a 00                	push   $0x0
  802564:	6a 00                	push   $0x0
  802566:	50                   	push   %eax
  802567:	6a 26                	push   $0x26
  802569:	e8 5c fb ff ff       	call   8020ca <syscall>
  80256e:	83 c4 18             	add    $0x18,%esp
	return ;
  802571:	90                   	nop
}
  802572:	c9                   	leave  
  802573:	c3                   	ret    

00802574 <rsttst>:
void rsttst()
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802577:	6a 00                	push   $0x0
  802579:	6a 00                	push   $0x0
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	6a 28                	push   $0x28
  802583:	e8 42 fb ff ff       	call   8020ca <syscall>
  802588:	83 c4 18             	add    $0x18,%esp
	return ;
  80258b:	90                   	nop
}
  80258c:	c9                   	leave  
  80258d:	c3                   	ret    

0080258e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80258e:	55                   	push   %ebp
  80258f:	89 e5                	mov    %esp,%ebp
  802591:	83 ec 04             	sub    $0x4,%esp
  802594:	8b 45 14             	mov    0x14(%ebp),%eax
  802597:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80259a:	8b 55 18             	mov    0x18(%ebp),%edx
  80259d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025a1:	52                   	push   %edx
  8025a2:	50                   	push   %eax
  8025a3:	ff 75 10             	pushl  0x10(%ebp)
  8025a6:	ff 75 0c             	pushl  0xc(%ebp)
  8025a9:	ff 75 08             	pushl  0x8(%ebp)
  8025ac:	6a 27                	push   $0x27
  8025ae:	e8 17 fb ff ff       	call   8020ca <syscall>
  8025b3:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b6:	90                   	nop
}
  8025b7:	c9                   	leave  
  8025b8:	c3                   	ret    

008025b9 <chktst>:
void chktst(uint32 n)
{
  8025b9:	55                   	push   %ebp
  8025ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 00                	push   $0x0
  8025c2:	6a 00                	push   $0x0
  8025c4:	ff 75 08             	pushl  0x8(%ebp)
  8025c7:	6a 29                	push   $0x29
  8025c9:	e8 fc fa ff ff       	call   8020ca <syscall>
  8025ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8025d1:	90                   	nop
}
  8025d2:	c9                   	leave  
  8025d3:	c3                   	ret    

008025d4 <inctst>:

void inctst()
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 2a                	push   $0x2a
  8025e3:	e8 e2 fa ff ff       	call   8020ca <syscall>
  8025e8:	83 c4 18             	add    $0x18,%esp
	return ;
  8025eb:	90                   	nop
}
  8025ec:	c9                   	leave  
  8025ed:	c3                   	ret    

008025ee <gettst>:
uint32 gettst()
{
  8025ee:	55                   	push   %ebp
  8025ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 2b                	push   $0x2b
  8025fd:	e8 c8 fa ff ff       	call   8020ca <syscall>
  802602:	83 c4 18             	add    $0x18,%esp
}
  802605:	c9                   	leave  
  802606:	c3                   	ret    

00802607 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802607:	55                   	push   %ebp
  802608:	89 e5                	mov    %esp,%ebp
  80260a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	6a 00                	push   $0x0
  802617:	6a 2c                	push   $0x2c
  802619:	e8 ac fa ff ff       	call   8020ca <syscall>
  80261e:	83 c4 18             	add    $0x18,%esp
  802621:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802624:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802628:	75 07                	jne    802631 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80262a:	b8 01 00 00 00       	mov    $0x1,%eax
  80262f:	eb 05                	jmp    802636 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802631:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802636:	c9                   	leave  
  802637:	c3                   	ret    

00802638 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802638:	55                   	push   %ebp
  802639:	89 e5                	mov    %esp,%ebp
  80263b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80263e:	6a 00                	push   $0x0
  802640:	6a 00                	push   $0x0
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	6a 2c                	push   $0x2c
  80264a:	e8 7b fa ff ff       	call   8020ca <syscall>
  80264f:	83 c4 18             	add    $0x18,%esp
  802652:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802655:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802659:	75 07                	jne    802662 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80265b:	b8 01 00 00 00       	mov    $0x1,%eax
  802660:	eb 05                	jmp    802667 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802662:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802667:	c9                   	leave  
  802668:	c3                   	ret    

00802669 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802669:	55                   	push   %ebp
  80266a:	89 e5                	mov    %esp,%ebp
  80266c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	6a 00                	push   $0x0
  802679:	6a 2c                	push   $0x2c
  80267b:	e8 4a fa ff ff       	call   8020ca <syscall>
  802680:	83 c4 18             	add    $0x18,%esp
  802683:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802686:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80268a:	75 07                	jne    802693 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80268c:	b8 01 00 00 00       	mov    $0x1,%eax
  802691:	eb 05                	jmp    802698 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802693:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    

0080269a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80269a:	55                   	push   %ebp
  80269b:	89 e5                	mov    %esp,%ebp
  80269d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026a0:	6a 00                	push   $0x0
  8026a2:	6a 00                	push   $0x0
  8026a4:	6a 00                	push   $0x0
  8026a6:	6a 00                	push   $0x0
  8026a8:	6a 00                	push   $0x0
  8026aa:	6a 2c                	push   $0x2c
  8026ac:	e8 19 fa ff ff       	call   8020ca <syscall>
  8026b1:	83 c4 18             	add    $0x18,%esp
  8026b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026b7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026bb:	75 07                	jne    8026c4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8026c2:	eb 05                	jmp    8026c9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c9:	c9                   	leave  
  8026ca:	c3                   	ret    

008026cb <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026cb:	55                   	push   %ebp
  8026cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026ce:	6a 00                	push   $0x0
  8026d0:	6a 00                	push   $0x0
  8026d2:	6a 00                	push   $0x0
  8026d4:	6a 00                	push   $0x0
  8026d6:	ff 75 08             	pushl  0x8(%ebp)
  8026d9:	6a 2d                	push   $0x2d
  8026db:	e8 ea f9 ff ff       	call   8020ca <syscall>
  8026e0:	83 c4 18             	add    $0x18,%esp
	return ;
  8026e3:	90                   	nop
}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    

008026e6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
  8026e9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	6a 00                	push   $0x0
  8026f8:	53                   	push   %ebx
  8026f9:	51                   	push   %ecx
  8026fa:	52                   	push   %edx
  8026fb:	50                   	push   %eax
  8026fc:	6a 2e                	push   $0x2e
  8026fe:	e8 c7 f9 ff ff       	call   8020ca <syscall>
  802703:	83 c4 18             	add    $0x18,%esp
}
  802706:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802709:	c9                   	leave  
  80270a:	c3                   	ret    

0080270b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80270b:	55                   	push   %ebp
  80270c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80270e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802711:	8b 45 08             	mov    0x8(%ebp),%eax
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	6a 00                	push   $0x0
  80271a:	52                   	push   %edx
  80271b:	50                   	push   %eax
  80271c:	6a 2f                	push   $0x2f
  80271e:	e8 a7 f9 ff ff       	call   8020ca <syscall>
  802723:	83 c4 18             	add    $0x18,%esp
}
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80272e:	83 ec 0c             	sub    $0xc,%esp
  802731:	68 b0 43 80 00       	push   $0x8043b0
  802736:	e8 1b e5 ff ff       	call   800c56 <cprintf>
  80273b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80273e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802745:	83 ec 0c             	sub    $0xc,%esp
  802748:	68 dc 43 80 00       	push   $0x8043dc
  80274d:	e8 04 e5 ff ff       	call   800c56 <cprintf>
  802752:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802755:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802759:	a1 38 51 80 00       	mov    0x805138,%eax
  80275e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802761:	eb 56                	jmp    8027b9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802763:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802767:	74 1c                	je     802785 <print_mem_block_lists+0x5d>
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 50 08             	mov    0x8(%eax),%edx
  80276f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802772:	8b 48 08             	mov    0x8(%eax),%ecx
  802775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802778:	8b 40 0c             	mov    0xc(%eax),%eax
  80277b:	01 c8                	add    %ecx,%eax
  80277d:	39 c2                	cmp    %eax,%edx
  80277f:	73 04                	jae    802785 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802781:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802785:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802788:	8b 50 08             	mov    0x8(%eax),%edx
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 40 0c             	mov    0xc(%eax),%eax
  802791:	01 c2                	add    %eax,%edx
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	8b 40 08             	mov    0x8(%eax),%eax
  802799:	83 ec 04             	sub    $0x4,%esp
  80279c:	52                   	push   %edx
  80279d:	50                   	push   %eax
  80279e:	68 f1 43 80 00       	push   $0x8043f1
  8027a3:	e8 ae e4 ff ff       	call   800c56 <cprintf>
  8027a8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027b1:	a1 40 51 80 00       	mov    0x805140,%eax
  8027b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bd:	74 07                	je     8027c6 <print_mem_block_lists+0x9e>
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	eb 05                	jmp    8027cb <print_mem_block_lists+0xa3>
  8027c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027cb:	a3 40 51 80 00       	mov    %eax,0x805140
  8027d0:	a1 40 51 80 00       	mov    0x805140,%eax
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	75 8a                	jne    802763 <print_mem_block_lists+0x3b>
  8027d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027dd:	75 84                	jne    802763 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8027df:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027e3:	75 10                	jne    8027f5 <print_mem_block_lists+0xcd>
  8027e5:	83 ec 0c             	sub    $0xc,%esp
  8027e8:	68 00 44 80 00       	push   $0x804400
  8027ed:	e8 64 e4 ff ff       	call   800c56 <cprintf>
  8027f2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8027f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8027fc:	83 ec 0c             	sub    $0xc,%esp
  8027ff:	68 24 44 80 00       	push   $0x804424
  802804:	e8 4d e4 ff ff       	call   800c56 <cprintf>
  802809:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80280c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802810:	a1 40 50 80 00       	mov    0x805040,%eax
  802815:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802818:	eb 56                	jmp    802870 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80281a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80281e:	74 1c                	je     80283c <print_mem_block_lists+0x114>
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 50 08             	mov    0x8(%eax),%edx
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	8b 48 08             	mov    0x8(%eax),%ecx
  80282c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282f:	8b 40 0c             	mov    0xc(%eax),%eax
  802832:	01 c8                	add    %ecx,%eax
  802834:	39 c2                	cmp    %eax,%edx
  802836:	73 04                	jae    80283c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802838:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80283c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283f:	8b 50 08             	mov    0x8(%eax),%edx
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	8b 40 0c             	mov    0xc(%eax),%eax
  802848:	01 c2                	add    %eax,%edx
  80284a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284d:	8b 40 08             	mov    0x8(%eax),%eax
  802850:	83 ec 04             	sub    $0x4,%esp
  802853:	52                   	push   %edx
  802854:	50                   	push   %eax
  802855:	68 f1 43 80 00       	push   $0x8043f1
  80285a:	e8 f7 e3 ff ff       	call   800c56 <cprintf>
  80285f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802868:	a1 48 50 80 00       	mov    0x805048,%eax
  80286d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802870:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802874:	74 07                	je     80287d <print_mem_block_lists+0x155>
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	eb 05                	jmp    802882 <print_mem_block_lists+0x15a>
  80287d:	b8 00 00 00 00       	mov    $0x0,%eax
  802882:	a3 48 50 80 00       	mov    %eax,0x805048
  802887:	a1 48 50 80 00       	mov    0x805048,%eax
  80288c:	85 c0                	test   %eax,%eax
  80288e:	75 8a                	jne    80281a <print_mem_block_lists+0xf2>
  802890:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802894:	75 84                	jne    80281a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802896:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80289a:	75 10                	jne    8028ac <print_mem_block_lists+0x184>
  80289c:	83 ec 0c             	sub    $0xc,%esp
  80289f:	68 3c 44 80 00       	push   $0x80443c
  8028a4:	e8 ad e3 ff ff       	call   800c56 <cprintf>
  8028a9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8028ac:	83 ec 0c             	sub    $0xc,%esp
  8028af:	68 b0 43 80 00       	push   $0x8043b0
  8028b4:	e8 9d e3 ff ff       	call   800c56 <cprintf>
  8028b9:	83 c4 10             	add    $0x10,%esp

}
  8028bc:	90                   	nop
  8028bd:	c9                   	leave  
  8028be:	c3                   	ret    

008028bf <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8028bf:	55                   	push   %ebp
  8028c0:	89 e5                	mov    %esp,%ebp
  8028c2:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8028c5:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8028cc:	00 00 00 
  8028cf:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8028d6:	00 00 00 
  8028d9:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8028e0:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8028e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028ea:	e9 9e 00 00 00       	jmp    80298d <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8028ef:	a1 50 50 80 00       	mov    0x805050,%eax
  8028f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f7:	c1 e2 04             	shl    $0x4,%edx
  8028fa:	01 d0                	add    %edx,%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	75 14                	jne    802914 <initialize_MemBlocksList+0x55>
  802900:	83 ec 04             	sub    $0x4,%esp
  802903:	68 64 44 80 00       	push   $0x804464
  802908:	6a 43                	push   $0x43
  80290a:	68 87 44 80 00       	push   $0x804487
  80290f:	e8 8e e0 ff ff       	call   8009a2 <_panic>
  802914:	a1 50 50 80 00       	mov    0x805050,%eax
  802919:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80291c:	c1 e2 04             	shl    $0x4,%edx
  80291f:	01 d0                	add    %edx,%eax
  802921:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802927:	89 10                	mov    %edx,(%eax)
  802929:	8b 00                	mov    (%eax),%eax
  80292b:	85 c0                	test   %eax,%eax
  80292d:	74 18                	je     802947 <initialize_MemBlocksList+0x88>
  80292f:	a1 48 51 80 00       	mov    0x805148,%eax
  802934:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80293a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80293d:	c1 e1 04             	shl    $0x4,%ecx
  802940:	01 ca                	add    %ecx,%edx
  802942:	89 50 04             	mov    %edx,0x4(%eax)
  802945:	eb 12                	jmp    802959 <initialize_MemBlocksList+0x9a>
  802947:	a1 50 50 80 00       	mov    0x805050,%eax
  80294c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80294f:	c1 e2 04             	shl    $0x4,%edx
  802952:	01 d0                	add    %edx,%eax
  802954:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802959:	a1 50 50 80 00       	mov    0x805050,%eax
  80295e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802961:	c1 e2 04             	shl    $0x4,%edx
  802964:	01 d0                	add    %edx,%eax
  802966:	a3 48 51 80 00       	mov    %eax,0x805148
  80296b:	a1 50 50 80 00       	mov    0x805050,%eax
  802970:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802973:	c1 e2 04             	shl    $0x4,%edx
  802976:	01 d0                	add    %edx,%eax
  802978:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297f:	a1 54 51 80 00       	mov    0x805154,%eax
  802984:	40                   	inc    %eax
  802985:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80298a:	ff 45 f4             	incl   -0xc(%ebp)
  80298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802990:	3b 45 08             	cmp    0x8(%ebp),%eax
  802993:	0f 82 56 ff ff ff    	jb     8028ef <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802999:	90                   	nop
  80299a:	c9                   	leave  
  80299b:	c3                   	ret    

0080299c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80299c:	55                   	push   %ebp
  80299d:	89 e5                	mov    %esp,%ebp
  80299f:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8029a2:	a1 38 51 80 00       	mov    0x805138,%eax
  8029a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8029aa:	eb 18                	jmp    8029c4 <find_block+0x28>
	{
		if (ele->sva==va)
  8029ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029af:	8b 40 08             	mov    0x8(%eax),%eax
  8029b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029b5:	75 05                	jne    8029bc <find_block+0x20>
			return ele;
  8029b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029ba:	eb 7b                	jmp    802a37 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8029bc:	a1 40 51 80 00       	mov    0x805140,%eax
  8029c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8029c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029c8:	74 07                	je     8029d1 <find_block+0x35>
  8029ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029cd:	8b 00                	mov    (%eax),%eax
  8029cf:	eb 05                	jmp    8029d6 <find_block+0x3a>
  8029d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d6:	a3 40 51 80 00       	mov    %eax,0x805140
  8029db:	a1 40 51 80 00       	mov    0x805140,%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	75 c8                	jne    8029ac <find_block+0x10>
  8029e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029e8:	75 c2                	jne    8029ac <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8029ea:	a1 40 50 80 00       	mov    0x805040,%eax
  8029ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8029f2:	eb 18                	jmp    802a0c <find_block+0x70>
	{
		if (ele->sva==va)
  8029f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029f7:	8b 40 08             	mov    0x8(%eax),%eax
  8029fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029fd:	75 05                	jne    802a04 <find_block+0x68>
					return ele;
  8029ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a02:	eb 33                	jmp    802a37 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802a04:	a1 48 50 80 00       	mov    0x805048,%eax
  802a09:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802a0c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a10:	74 07                	je     802a19 <find_block+0x7d>
  802a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a15:	8b 00                	mov    (%eax),%eax
  802a17:	eb 05                	jmp    802a1e <find_block+0x82>
  802a19:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1e:	a3 48 50 80 00       	mov    %eax,0x805048
  802a23:	a1 48 50 80 00       	mov    0x805048,%eax
  802a28:	85 c0                	test   %eax,%eax
  802a2a:	75 c8                	jne    8029f4 <find_block+0x58>
  802a2c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a30:	75 c2                	jne    8029f4 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802a32:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802a37:	c9                   	leave  
  802a38:	c3                   	ret    

00802a39 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802a39:	55                   	push   %ebp
  802a3a:	89 e5                	mov    %esp,%ebp
  802a3c:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802a3f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a44:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802a47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a4b:	75 62                	jne    802aaf <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802a4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a51:	75 14                	jne    802a67 <insert_sorted_allocList+0x2e>
  802a53:	83 ec 04             	sub    $0x4,%esp
  802a56:	68 64 44 80 00       	push   $0x804464
  802a5b:	6a 69                	push   $0x69
  802a5d:	68 87 44 80 00       	push   $0x804487
  802a62:	e8 3b df ff ff       	call   8009a2 <_panic>
  802a67:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	89 10                	mov    %edx,(%eax)
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	8b 00                	mov    (%eax),%eax
  802a77:	85 c0                	test   %eax,%eax
  802a79:	74 0d                	je     802a88 <insert_sorted_allocList+0x4f>
  802a7b:	a1 40 50 80 00       	mov    0x805040,%eax
  802a80:	8b 55 08             	mov    0x8(%ebp),%edx
  802a83:	89 50 04             	mov    %edx,0x4(%eax)
  802a86:	eb 08                	jmp    802a90 <insert_sorted_allocList+0x57>
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	a3 44 50 80 00       	mov    %eax,0x805044
  802a90:	8b 45 08             	mov    0x8(%ebp),%eax
  802a93:	a3 40 50 80 00       	mov    %eax,0x805040
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802aa7:	40                   	inc    %eax
  802aa8:	a3 4c 50 80 00       	mov    %eax,0x80504c
  802aad:	eb 72                	jmp    802b21 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802aaf:	a1 40 50 80 00       	mov    0x805040,%eax
  802ab4:	8b 50 08             	mov    0x8(%eax),%edx
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	8b 40 08             	mov    0x8(%eax),%eax
  802abd:	39 c2                	cmp    %eax,%edx
  802abf:	76 60                	jbe    802b21 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802ac1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ac5:	75 14                	jne    802adb <insert_sorted_allocList+0xa2>
  802ac7:	83 ec 04             	sub    $0x4,%esp
  802aca:	68 64 44 80 00       	push   $0x804464
  802acf:	6a 6d                	push   $0x6d
  802ad1:	68 87 44 80 00       	push   $0x804487
  802ad6:	e8 c7 de ff ff       	call   8009a2 <_panic>
  802adb:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	89 10                	mov    %edx,(%eax)
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	74 0d                	je     802afc <insert_sorted_allocList+0xc3>
  802aef:	a1 40 50 80 00       	mov    0x805040,%eax
  802af4:	8b 55 08             	mov    0x8(%ebp),%edx
  802af7:	89 50 04             	mov    %edx,0x4(%eax)
  802afa:	eb 08                	jmp    802b04 <insert_sorted_allocList+0xcb>
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	a3 44 50 80 00       	mov    %eax,0x805044
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	a3 40 50 80 00       	mov    %eax,0x805040
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b16:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b1b:	40                   	inc    %eax
  802b1c:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802b21:	a1 40 50 80 00       	mov    0x805040,%eax
  802b26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b29:	e9 b9 01 00 00       	jmp    802ce7 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b31:	8b 50 08             	mov    0x8(%eax),%edx
  802b34:	a1 40 50 80 00       	mov    0x805040,%eax
  802b39:	8b 40 08             	mov    0x8(%eax),%eax
  802b3c:	39 c2                	cmp    %eax,%edx
  802b3e:	76 7c                	jbe    802bbc <insert_sorted_allocList+0x183>
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	8b 50 08             	mov    0x8(%eax),%edx
  802b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b49:	8b 40 08             	mov    0x8(%eax),%eax
  802b4c:	39 c2                	cmp    %eax,%edx
  802b4e:	73 6c                	jae    802bbc <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802b50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b54:	74 06                	je     802b5c <insert_sorted_allocList+0x123>
  802b56:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b5a:	75 14                	jne    802b70 <insert_sorted_allocList+0x137>
  802b5c:	83 ec 04             	sub    $0x4,%esp
  802b5f:	68 a0 44 80 00       	push   $0x8044a0
  802b64:	6a 75                	push   $0x75
  802b66:	68 87 44 80 00       	push   $0x804487
  802b6b:	e8 32 de ff ff       	call   8009a2 <_panic>
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	8b 50 04             	mov    0x4(%eax),%edx
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	89 50 04             	mov    %edx,0x4(%eax)
  802b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b82:	89 10                	mov    %edx,(%eax)
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	8b 40 04             	mov    0x4(%eax),%eax
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	74 0d                	je     802b9b <insert_sorted_allocList+0x162>
  802b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b91:	8b 40 04             	mov    0x4(%eax),%eax
  802b94:	8b 55 08             	mov    0x8(%ebp),%edx
  802b97:	89 10                	mov    %edx,(%eax)
  802b99:	eb 08                	jmp    802ba3 <insert_sorted_allocList+0x16a>
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	a3 40 50 80 00       	mov    %eax,0x805040
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba9:	89 50 04             	mov    %edx,0x4(%eax)
  802bac:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bb1:	40                   	inc    %eax
  802bb2:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802bb7:	e9 59 01 00 00       	jmp    802d15 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	8b 50 08             	mov    0x8(%eax),%edx
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 40 08             	mov    0x8(%eax),%eax
  802bc8:	39 c2                	cmp    %eax,%edx
  802bca:	0f 86 98 00 00 00    	jbe    802c68 <insert_sorted_allocList+0x22f>
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	8b 50 08             	mov    0x8(%eax),%edx
  802bd6:	a1 44 50 80 00       	mov    0x805044,%eax
  802bdb:	8b 40 08             	mov    0x8(%eax),%eax
  802bde:	39 c2                	cmp    %eax,%edx
  802be0:	0f 83 82 00 00 00    	jae    802c68 <insert_sorted_allocList+0x22f>
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	8b 50 08             	mov    0x8(%eax),%edx
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 00                	mov    (%eax),%eax
  802bf1:	8b 40 08             	mov    0x8(%eax),%eax
  802bf4:	39 c2                	cmp    %eax,%edx
  802bf6:	73 70                	jae    802c68 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802bf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bfc:	74 06                	je     802c04 <insert_sorted_allocList+0x1cb>
  802bfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c02:	75 14                	jne    802c18 <insert_sorted_allocList+0x1df>
  802c04:	83 ec 04             	sub    $0x4,%esp
  802c07:	68 d8 44 80 00       	push   $0x8044d8
  802c0c:	6a 7c                	push   $0x7c
  802c0e:	68 87 44 80 00       	push   $0x804487
  802c13:	e8 8a dd ff ff       	call   8009a2 <_panic>
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	8b 10                	mov    (%eax),%edx
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	89 10                	mov    %edx,(%eax)
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	8b 00                	mov    (%eax),%eax
  802c27:	85 c0                	test   %eax,%eax
  802c29:	74 0b                	je     802c36 <insert_sorted_allocList+0x1fd>
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	8b 00                	mov    (%eax),%eax
  802c30:	8b 55 08             	mov    0x8(%ebp),%edx
  802c33:	89 50 04             	mov    %edx,0x4(%eax)
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	8b 55 08             	mov    0x8(%ebp),%edx
  802c3c:	89 10                	mov    %edx,(%eax)
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c44:	89 50 04             	mov    %edx,0x4(%eax)
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	8b 00                	mov    (%eax),%eax
  802c4c:	85 c0                	test   %eax,%eax
  802c4e:	75 08                	jne    802c58 <insert_sorted_allocList+0x21f>
  802c50:	8b 45 08             	mov    0x8(%ebp),%eax
  802c53:	a3 44 50 80 00       	mov    %eax,0x805044
  802c58:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c5d:	40                   	inc    %eax
  802c5e:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802c63:	e9 ad 00 00 00       	jmp    802d15 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	8b 50 08             	mov    0x8(%eax),%edx
  802c6e:	a1 44 50 80 00       	mov    0x805044,%eax
  802c73:	8b 40 08             	mov    0x8(%eax),%eax
  802c76:	39 c2                	cmp    %eax,%edx
  802c78:	76 65                	jbe    802cdf <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802c7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c7e:	75 17                	jne    802c97 <insert_sorted_allocList+0x25e>
  802c80:	83 ec 04             	sub    $0x4,%esp
  802c83:	68 0c 45 80 00       	push   $0x80450c
  802c88:	68 80 00 00 00       	push   $0x80
  802c8d:	68 87 44 80 00       	push   $0x804487
  802c92:	e8 0b dd ff ff       	call   8009a2 <_panic>
  802c97:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	89 50 04             	mov    %edx,0x4(%eax)
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	8b 40 04             	mov    0x4(%eax),%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	74 0c                	je     802cb9 <insert_sorted_allocList+0x280>
  802cad:	a1 44 50 80 00       	mov    0x805044,%eax
  802cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb5:	89 10                	mov    %edx,(%eax)
  802cb7:	eb 08                	jmp    802cc1 <insert_sorted_allocList+0x288>
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	a3 40 50 80 00       	mov    %eax,0x805040
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	a3 44 50 80 00       	mov    %eax,0x805044
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cd2:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cd7:	40                   	inc    %eax
  802cd8:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802cdd:	eb 36                	jmp    802d15 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802cdf:	a1 48 50 80 00       	mov    0x805048,%eax
  802ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ceb:	74 07                	je     802cf4 <insert_sorted_allocList+0x2bb>
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 00                	mov    (%eax),%eax
  802cf2:	eb 05                	jmp    802cf9 <insert_sorted_allocList+0x2c0>
  802cf4:	b8 00 00 00 00       	mov    $0x0,%eax
  802cf9:	a3 48 50 80 00       	mov    %eax,0x805048
  802cfe:	a1 48 50 80 00       	mov    0x805048,%eax
  802d03:	85 c0                	test   %eax,%eax
  802d05:	0f 85 23 fe ff ff    	jne    802b2e <insert_sorted_allocList+0xf5>
  802d0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d0f:	0f 85 19 fe ff ff    	jne    802b2e <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802d15:	90                   	nop
  802d16:	c9                   	leave  
  802d17:	c3                   	ret    

00802d18 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802d18:	55                   	push   %ebp
  802d19:	89 e5                	mov    %esp,%ebp
  802d1b:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802d1e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d26:	e9 7c 01 00 00       	jmp    802ea7 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d31:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d34:	0f 85 90 00 00 00    	jne    802dca <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802d40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d44:	75 17                	jne    802d5d <alloc_block_FF+0x45>
  802d46:	83 ec 04             	sub    $0x4,%esp
  802d49:	68 2f 45 80 00       	push   $0x80452f
  802d4e:	68 ba 00 00 00       	push   $0xba
  802d53:	68 87 44 80 00       	push   $0x804487
  802d58:	e8 45 dc ff ff       	call   8009a2 <_panic>
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 00                	mov    (%eax),%eax
  802d62:	85 c0                	test   %eax,%eax
  802d64:	74 10                	je     802d76 <alloc_block_FF+0x5e>
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 00                	mov    (%eax),%eax
  802d6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d6e:	8b 52 04             	mov    0x4(%edx),%edx
  802d71:	89 50 04             	mov    %edx,0x4(%eax)
  802d74:	eb 0b                	jmp    802d81 <alloc_block_FF+0x69>
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	8b 40 04             	mov    0x4(%eax),%eax
  802d7c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	8b 40 04             	mov    0x4(%eax),%eax
  802d87:	85 c0                	test   %eax,%eax
  802d89:	74 0f                	je     802d9a <alloc_block_FF+0x82>
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	8b 40 04             	mov    0x4(%eax),%eax
  802d91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d94:	8b 12                	mov    (%edx),%edx
  802d96:	89 10                	mov    %edx,(%eax)
  802d98:	eb 0a                	jmp    802da4 <alloc_block_FF+0x8c>
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 00                	mov    (%eax),%eax
  802d9f:	a3 38 51 80 00       	mov    %eax,0x805138
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db7:	a1 44 51 80 00       	mov    0x805144,%eax
  802dbc:	48                   	dec    %eax
  802dbd:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802dc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc5:	e9 10 01 00 00       	jmp    802eda <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcd:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802dd3:	0f 86 c6 00 00 00    	jbe    802e9f <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802dd9:	a1 48 51 80 00       	mov    0x805148,%eax
  802dde:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802de1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802de5:	75 17                	jne    802dfe <alloc_block_FF+0xe6>
  802de7:	83 ec 04             	sub    $0x4,%esp
  802dea:	68 2f 45 80 00       	push   $0x80452f
  802def:	68 c2 00 00 00       	push   $0xc2
  802df4:	68 87 44 80 00       	push   $0x804487
  802df9:	e8 a4 db ff ff       	call   8009a2 <_panic>
  802dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	74 10                	je     802e17 <alloc_block_FF+0xff>
  802e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e0f:	8b 52 04             	mov    0x4(%edx),%edx
  802e12:	89 50 04             	mov    %edx,0x4(%eax)
  802e15:	eb 0b                	jmp    802e22 <alloc_block_FF+0x10a>
  802e17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e1a:	8b 40 04             	mov    0x4(%eax),%eax
  802e1d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e25:	8b 40 04             	mov    0x4(%eax),%eax
  802e28:	85 c0                	test   %eax,%eax
  802e2a:	74 0f                	je     802e3b <alloc_block_FF+0x123>
  802e2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2f:	8b 40 04             	mov    0x4(%eax),%eax
  802e32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e35:	8b 12                	mov    (%edx),%edx
  802e37:	89 10                	mov    %edx,(%eax)
  802e39:	eb 0a                	jmp    802e45 <alloc_block_FF+0x12d>
  802e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e3e:	8b 00                	mov    (%eax),%eax
  802e40:	a3 48 51 80 00       	mov    %eax,0x805148
  802e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e58:	a1 54 51 80 00       	mov    0x805154,%eax
  802e5d:	48                   	dec    %eax
  802e5e:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 50 08             	mov    0x8(%eax),%edx
  802e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e6c:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e72:	8b 55 08             	mov    0x8(%ebp),%edx
  802e75:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7e:	2b 45 08             	sub    0x8(%ebp),%eax
  802e81:	89 c2                	mov    %eax,%edx
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 50 08             	mov    0x8(%eax),%edx
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	01 c2                	add    %eax,%edx
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9d:	eb 3b                	jmp    802eda <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802e9f:	a1 40 51 80 00       	mov    0x805140,%eax
  802ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eab:	74 07                	je     802eb4 <alloc_block_FF+0x19c>
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 00                	mov    (%eax),%eax
  802eb2:	eb 05                	jmp    802eb9 <alloc_block_FF+0x1a1>
  802eb4:	b8 00 00 00 00       	mov    $0x0,%eax
  802eb9:	a3 40 51 80 00       	mov    %eax,0x805140
  802ebe:	a1 40 51 80 00       	mov    0x805140,%eax
  802ec3:	85 c0                	test   %eax,%eax
  802ec5:	0f 85 60 fe ff ff    	jne    802d2b <alloc_block_FF+0x13>
  802ecb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ecf:	0f 85 56 fe ff ff    	jne    802d2b <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802ed5:	b8 00 00 00 00       	mov    $0x0,%eax
  802eda:	c9                   	leave  
  802edb:	c3                   	ret    

00802edc <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802edc:	55                   	push   %ebp
  802edd:	89 e5                	mov    %esp,%ebp
  802edf:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802ee2:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802ee9:	a1 38 51 80 00       	mov    0x805138,%eax
  802eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ef1:	eb 3a                	jmp    802f2d <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef9:	3b 45 08             	cmp    0x8(%ebp),%eax
  802efc:	72 27                	jb     802f25 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802efe:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802f02:	75 0b                	jne    802f0f <alloc_block_BF+0x33>
					best_size= element->size;
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802f0d:	eb 16                	jmp    802f25 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	8b 50 0c             	mov    0xc(%eax),%edx
  802f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f18:	39 c2                	cmp    %eax,%edx
  802f1a:	77 09                	ja     802f25 <alloc_block_BF+0x49>
					best_size=element->size;
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f22:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802f25:	a1 40 51 80 00       	mov    0x805140,%eax
  802f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f31:	74 07                	je     802f3a <alloc_block_BF+0x5e>
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	eb 05                	jmp    802f3f <alloc_block_BF+0x63>
  802f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3f:	a3 40 51 80 00       	mov    %eax,0x805140
  802f44:	a1 40 51 80 00       	mov    0x805140,%eax
  802f49:	85 c0                	test   %eax,%eax
  802f4b:	75 a6                	jne    802ef3 <alloc_block_BF+0x17>
  802f4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f51:	75 a0                	jne    802ef3 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802f53:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802f57:	0f 84 d3 01 00 00    	je     803130 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802f5d:	a1 38 51 80 00       	mov    0x805138,%eax
  802f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f65:	e9 98 01 00 00       	jmp    803102 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f6d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f70:	0f 86 da 00 00 00    	jbe    803050 <alloc_block_BF+0x174>
  802f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f79:	8b 50 0c             	mov    0xc(%eax),%edx
  802f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7f:	39 c2                	cmp    %eax,%edx
  802f81:	0f 85 c9 00 00 00    	jne    803050 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802f87:	a1 48 51 80 00       	mov    0x805148,%eax
  802f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802f8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f93:	75 17                	jne    802fac <alloc_block_BF+0xd0>
  802f95:	83 ec 04             	sub    $0x4,%esp
  802f98:	68 2f 45 80 00       	push   $0x80452f
  802f9d:	68 ea 00 00 00       	push   $0xea
  802fa2:	68 87 44 80 00       	push   $0x804487
  802fa7:	e8 f6 d9 ff ff       	call   8009a2 <_panic>
  802fac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	85 c0                	test   %eax,%eax
  802fb3:	74 10                	je     802fc5 <alloc_block_BF+0xe9>
  802fb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb8:	8b 00                	mov    (%eax),%eax
  802fba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fbd:	8b 52 04             	mov    0x4(%edx),%edx
  802fc0:	89 50 04             	mov    %edx,0x4(%eax)
  802fc3:	eb 0b                	jmp    802fd0 <alloc_block_BF+0xf4>
  802fc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc8:	8b 40 04             	mov    0x4(%eax),%eax
  802fcb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd3:	8b 40 04             	mov    0x4(%eax),%eax
  802fd6:	85 c0                	test   %eax,%eax
  802fd8:	74 0f                	je     802fe9 <alloc_block_BF+0x10d>
  802fda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fdd:	8b 40 04             	mov    0x4(%eax),%eax
  802fe0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fe3:	8b 12                	mov    (%edx),%edx
  802fe5:	89 10                	mov    %edx,(%eax)
  802fe7:	eb 0a                	jmp    802ff3 <alloc_block_BF+0x117>
  802fe9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fec:	8b 00                	mov    (%eax),%eax
  802fee:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ffc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803006:	a1 54 51 80 00       	mov    0x805154,%eax
  80300b:	48                   	dec    %eax
  80300c:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  803011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803014:	8b 50 08             	mov    0x8(%eax),%edx
  803017:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301a:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80301d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803020:	8b 55 08             	mov    0x8(%ebp),%edx
  803023:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  803026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803029:	8b 40 0c             	mov    0xc(%eax),%eax
  80302c:	2b 45 08             	sub    0x8(%ebp),%eax
  80302f:	89 c2                	mov    %eax,%edx
  803031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803034:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  803037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303a:	8b 50 08             	mov    0x8(%eax),%edx
  80303d:	8b 45 08             	mov    0x8(%ebp),%eax
  803040:	01 c2                	add    %eax,%edx
  803042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803045:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  803048:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80304b:	e9 e5 00 00 00       	jmp    803135 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  803050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803053:	8b 50 0c             	mov    0xc(%eax),%edx
  803056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803059:	39 c2                	cmp    %eax,%edx
  80305b:	0f 85 99 00 00 00    	jne    8030fa <alloc_block_BF+0x21e>
  803061:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803064:	3b 45 08             	cmp    0x8(%ebp),%eax
  803067:	0f 85 8d 00 00 00    	jne    8030fa <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  803073:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803077:	75 17                	jne    803090 <alloc_block_BF+0x1b4>
  803079:	83 ec 04             	sub    $0x4,%esp
  80307c:	68 2f 45 80 00       	push   $0x80452f
  803081:	68 f7 00 00 00       	push   $0xf7
  803086:	68 87 44 80 00       	push   $0x804487
  80308b:	e8 12 d9 ff ff       	call   8009a2 <_panic>
  803090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803093:	8b 00                	mov    (%eax),%eax
  803095:	85 c0                	test   %eax,%eax
  803097:	74 10                	je     8030a9 <alloc_block_BF+0x1cd>
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	8b 00                	mov    (%eax),%eax
  80309e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030a1:	8b 52 04             	mov    0x4(%edx),%edx
  8030a4:	89 50 04             	mov    %edx,0x4(%eax)
  8030a7:	eb 0b                	jmp    8030b4 <alloc_block_BF+0x1d8>
  8030a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ac:	8b 40 04             	mov    0x4(%eax),%eax
  8030af:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	8b 40 04             	mov    0x4(%eax),%eax
  8030ba:	85 c0                	test   %eax,%eax
  8030bc:	74 0f                	je     8030cd <alloc_block_BF+0x1f1>
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	8b 40 04             	mov    0x4(%eax),%eax
  8030c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030c7:	8b 12                	mov    (%edx),%edx
  8030c9:	89 10                	mov    %edx,(%eax)
  8030cb:	eb 0a                	jmp    8030d7 <alloc_block_BF+0x1fb>
  8030cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d0:	8b 00                	mov    (%eax),%eax
  8030d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8030d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ef:	48                   	dec    %eax
  8030f0:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  8030f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f8:	eb 3b                	jmp    803135 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8030fa:	a1 40 51 80 00       	mov    0x805140,%eax
  8030ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803106:	74 07                	je     80310f <alloc_block_BF+0x233>
  803108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	eb 05                	jmp    803114 <alloc_block_BF+0x238>
  80310f:	b8 00 00 00 00       	mov    $0x0,%eax
  803114:	a3 40 51 80 00       	mov    %eax,0x805140
  803119:	a1 40 51 80 00       	mov    0x805140,%eax
  80311e:	85 c0                	test   %eax,%eax
  803120:	0f 85 44 fe ff ff    	jne    802f6a <alloc_block_BF+0x8e>
  803126:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312a:	0f 85 3a fe ff ff    	jne    802f6a <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  803130:	b8 00 00 00 00       	mov    $0x0,%eax
  803135:	c9                   	leave  
  803136:	c3                   	ret    

00803137 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803137:	55                   	push   %ebp
  803138:	89 e5                	mov    %esp,%ebp
  80313a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80313d:	83 ec 04             	sub    $0x4,%esp
  803140:	68 50 45 80 00       	push   $0x804550
  803145:	68 04 01 00 00       	push   $0x104
  80314a:	68 87 44 80 00       	push   $0x804487
  80314f:	e8 4e d8 ff ff       	call   8009a2 <_panic>

00803154 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  803154:	55                   	push   %ebp
  803155:	89 e5                	mov    %esp,%ebp
  803157:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  80315a:	a1 38 51 80 00       	mov    0x805138,%eax
  80315f:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  803162:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803167:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  80316a:	a1 38 51 80 00       	mov    0x805138,%eax
  80316f:	85 c0                	test   %eax,%eax
  803171:	75 68                	jne    8031db <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  803173:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803177:	75 17                	jne    803190 <insert_sorted_with_merge_freeList+0x3c>
  803179:	83 ec 04             	sub    $0x4,%esp
  80317c:	68 64 44 80 00       	push   $0x804464
  803181:	68 14 01 00 00       	push   $0x114
  803186:	68 87 44 80 00       	push   $0x804487
  80318b:	e8 12 d8 ff ff       	call   8009a2 <_panic>
  803190:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	89 10                	mov    %edx,(%eax)
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	8b 00                	mov    (%eax),%eax
  8031a0:	85 c0                	test   %eax,%eax
  8031a2:	74 0d                	je     8031b1 <insert_sorted_with_merge_freeList+0x5d>
  8031a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8031a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ac:	89 50 04             	mov    %edx,0x4(%eax)
  8031af:	eb 08                	jmp    8031b9 <insert_sorted_with_merge_freeList+0x65>
  8031b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bc:	a3 38 51 80 00       	mov    %eax,0x805138
  8031c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031cb:	a1 44 51 80 00       	mov    0x805144,%eax
  8031d0:	40                   	inc    %eax
  8031d1:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8031d6:	e9 d2 06 00 00       	jmp    8038ad <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	8b 50 08             	mov    0x8(%eax),%edx
  8031e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031e4:	8b 40 08             	mov    0x8(%eax),%eax
  8031e7:	39 c2                	cmp    %eax,%edx
  8031e9:	0f 83 22 01 00 00    	jae    803311 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8031ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f2:	8b 50 08             	mov    0x8(%eax),%edx
  8031f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fb:	01 c2                	add    %eax,%edx
  8031fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803200:	8b 40 08             	mov    0x8(%eax),%eax
  803203:	39 c2                	cmp    %eax,%edx
  803205:	0f 85 9e 00 00 00    	jne    8032a9 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	8b 50 08             	mov    0x8(%eax),%edx
  803211:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803214:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803217:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321a:	8b 50 0c             	mov    0xc(%eax),%edx
  80321d:	8b 45 08             	mov    0x8(%ebp),%eax
  803220:	8b 40 0c             	mov    0xc(%eax),%eax
  803223:	01 c2                	add    %eax,%edx
  803225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803228:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  80322b:	8b 45 08             	mov    0x8(%ebp),%eax
  80322e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803235:	8b 45 08             	mov    0x8(%ebp),%eax
  803238:	8b 50 08             	mov    0x8(%eax),%edx
  80323b:	8b 45 08             	mov    0x8(%ebp),%eax
  80323e:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803241:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803245:	75 17                	jne    80325e <insert_sorted_with_merge_freeList+0x10a>
  803247:	83 ec 04             	sub    $0x4,%esp
  80324a:	68 64 44 80 00       	push   $0x804464
  80324f:	68 21 01 00 00       	push   $0x121
  803254:	68 87 44 80 00       	push   $0x804487
  803259:	e8 44 d7 ff ff       	call   8009a2 <_panic>
  80325e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	89 10                	mov    %edx,(%eax)
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	8b 00                	mov    (%eax),%eax
  80326e:	85 c0                	test   %eax,%eax
  803270:	74 0d                	je     80327f <insert_sorted_with_merge_freeList+0x12b>
  803272:	a1 48 51 80 00       	mov    0x805148,%eax
  803277:	8b 55 08             	mov    0x8(%ebp),%edx
  80327a:	89 50 04             	mov    %edx,0x4(%eax)
  80327d:	eb 08                	jmp    803287 <insert_sorted_with_merge_freeList+0x133>
  80327f:	8b 45 08             	mov    0x8(%ebp),%eax
  803282:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803287:	8b 45 08             	mov    0x8(%ebp),%eax
  80328a:	a3 48 51 80 00       	mov    %eax,0x805148
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803299:	a1 54 51 80 00       	mov    0x805154,%eax
  80329e:	40                   	inc    %eax
  80329f:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8032a4:	e9 04 06 00 00       	jmp    8038ad <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8032a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ad:	75 17                	jne    8032c6 <insert_sorted_with_merge_freeList+0x172>
  8032af:	83 ec 04             	sub    $0x4,%esp
  8032b2:	68 64 44 80 00       	push   $0x804464
  8032b7:	68 26 01 00 00       	push   $0x126
  8032bc:	68 87 44 80 00       	push   $0x804487
  8032c1:	e8 dc d6 ff ff       	call   8009a2 <_panic>
  8032c6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cf:	89 10                	mov    %edx,(%eax)
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	8b 00                	mov    (%eax),%eax
  8032d6:	85 c0                	test   %eax,%eax
  8032d8:	74 0d                	je     8032e7 <insert_sorted_with_merge_freeList+0x193>
  8032da:	a1 38 51 80 00       	mov    0x805138,%eax
  8032df:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e2:	89 50 04             	mov    %edx,0x4(%eax)
  8032e5:	eb 08                	jmp    8032ef <insert_sorted_with_merge_freeList+0x19b>
  8032e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803301:	a1 44 51 80 00       	mov    0x805144,%eax
  803306:	40                   	inc    %eax
  803307:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  80330c:	e9 9c 05 00 00       	jmp    8038ad <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	8b 50 08             	mov    0x8(%eax),%edx
  803317:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80331a:	8b 40 08             	mov    0x8(%eax),%eax
  80331d:	39 c2                	cmp    %eax,%edx
  80331f:	0f 86 16 01 00 00    	jbe    80343b <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803325:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803328:	8b 50 08             	mov    0x8(%eax),%edx
  80332b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80332e:	8b 40 0c             	mov    0xc(%eax),%eax
  803331:	01 c2                	add    %eax,%edx
  803333:	8b 45 08             	mov    0x8(%ebp),%eax
  803336:	8b 40 08             	mov    0x8(%eax),%eax
  803339:	39 c2                	cmp    %eax,%edx
  80333b:	0f 85 92 00 00 00    	jne    8033d3 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  803341:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803344:	8b 50 0c             	mov    0xc(%eax),%edx
  803347:	8b 45 08             	mov    0x8(%ebp),%eax
  80334a:	8b 40 0c             	mov    0xc(%eax),%eax
  80334d:	01 c2                	add    %eax,%edx
  80334f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803352:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  803355:	8b 45 08             	mov    0x8(%ebp),%eax
  803358:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80335f:	8b 45 08             	mov    0x8(%ebp),%eax
  803362:	8b 50 08             	mov    0x8(%eax),%edx
  803365:	8b 45 08             	mov    0x8(%ebp),%eax
  803368:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80336b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80336f:	75 17                	jne    803388 <insert_sorted_with_merge_freeList+0x234>
  803371:	83 ec 04             	sub    $0x4,%esp
  803374:	68 64 44 80 00       	push   $0x804464
  803379:	68 31 01 00 00       	push   $0x131
  80337e:	68 87 44 80 00       	push   $0x804487
  803383:	e8 1a d6 ff ff       	call   8009a2 <_panic>
  803388:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80338e:	8b 45 08             	mov    0x8(%ebp),%eax
  803391:	89 10                	mov    %edx,(%eax)
  803393:	8b 45 08             	mov    0x8(%ebp),%eax
  803396:	8b 00                	mov    (%eax),%eax
  803398:	85 c0                	test   %eax,%eax
  80339a:	74 0d                	je     8033a9 <insert_sorted_with_merge_freeList+0x255>
  80339c:	a1 48 51 80 00       	mov    0x805148,%eax
  8033a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a4:	89 50 04             	mov    %edx,0x4(%eax)
  8033a7:	eb 08                	jmp    8033b1 <insert_sorted_with_merge_freeList+0x25d>
  8033a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ac:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b4:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c3:	a1 54 51 80 00       	mov    0x805154,%eax
  8033c8:	40                   	inc    %eax
  8033c9:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8033ce:	e9 da 04 00 00       	jmp    8038ad <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  8033d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033d7:	75 17                	jne    8033f0 <insert_sorted_with_merge_freeList+0x29c>
  8033d9:	83 ec 04             	sub    $0x4,%esp
  8033dc:	68 0c 45 80 00       	push   $0x80450c
  8033e1:	68 37 01 00 00       	push   $0x137
  8033e6:	68 87 44 80 00       	push   $0x804487
  8033eb:	e8 b2 d5 ff ff       	call   8009a2 <_panic>
  8033f0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8033f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f9:	89 50 04             	mov    %edx,0x4(%eax)
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	8b 40 04             	mov    0x4(%eax),%eax
  803402:	85 c0                	test   %eax,%eax
  803404:	74 0c                	je     803412 <insert_sorted_with_merge_freeList+0x2be>
  803406:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80340b:	8b 55 08             	mov    0x8(%ebp),%edx
  80340e:	89 10                	mov    %edx,(%eax)
  803410:	eb 08                	jmp    80341a <insert_sorted_with_merge_freeList+0x2c6>
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	a3 38 51 80 00       	mov    %eax,0x805138
  80341a:	8b 45 08             	mov    0x8(%ebp),%eax
  80341d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803422:	8b 45 08             	mov    0x8(%ebp),%eax
  803425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80342b:	a1 44 51 80 00       	mov    0x805144,%eax
  803430:	40                   	inc    %eax
  803431:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803436:	e9 72 04 00 00       	jmp    8038ad <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  80343b:	a1 38 51 80 00       	mov    0x805138,%eax
  803440:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803443:	e9 35 04 00 00       	jmp    80387d <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  803448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344b:	8b 00                	mov    (%eax),%eax
  80344d:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  803450:	8b 45 08             	mov    0x8(%ebp),%eax
  803453:	8b 50 08             	mov    0x8(%eax),%edx
  803456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803459:	8b 40 08             	mov    0x8(%eax),%eax
  80345c:	39 c2                	cmp    %eax,%edx
  80345e:	0f 86 11 04 00 00    	jbe    803875 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  803464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803467:	8b 50 08             	mov    0x8(%eax),%edx
  80346a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346d:	8b 40 0c             	mov    0xc(%eax),%eax
  803470:	01 c2                	add    %eax,%edx
  803472:	8b 45 08             	mov    0x8(%ebp),%eax
  803475:	8b 40 08             	mov    0x8(%eax),%eax
  803478:	39 c2                	cmp    %eax,%edx
  80347a:	0f 83 8b 00 00 00    	jae    80350b <insert_sorted_with_merge_freeList+0x3b7>
  803480:	8b 45 08             	mov    0x8(%ebp),%eax
  803483:	8b 50 08             	mov    0x8(%eax),%edx
  803486:	8b 45 08             	mov    0x8(%ebp),%eax
  803489:	8b 40 0c             	mov    0xc(%eax),%eax
  80348c:	01 c2                	add    %eax,%edx
  80348e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803491:	8b 40 08             	mov    0x8(%eax),%eax
  803494:	39 c2                	cmp    %eax,%edx
  803496:	73 73                	jae    80350b <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  803498:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80349c:	74 06                	je     8034a4 <insert_sorted_with_merge_freeList+0x350>
  80349e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034a2:	75 17                	jne    8034bb <insert_sorted_with_merge_freeList+0x367>
  8034a4:	83 ec 04             	sub    $0x4,%esp
  8034a7:	68 d8 44 80 00       	push   $0x8044d8
  8034ac:	68 48 01 00 00       	push   $0x148
  8034b1:	68 87 44 80 00       	push   $0x804487
  8034b6:	e8 e7 d4 ff ff       	call   8009a2 <_panic>
  8034bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034be:	8b 10                	mov    (%eax),%edx
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	89 10                	mov    %edx,(%eax)
  8034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c8:	8b 00                	mov    (%eax),%eax
  8034ca:	85 c0                	test   %eax,%eax
  8034cc:	74 0b                	je     8034d9 <insert_sorted_with_merge_freeList+0x385>
  8034ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d1:	8b 00                	mov    (%eax),%eax
  8034d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8034d6:	89 50 04             	mov    %edx,0x4(%eax)
  8034d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8034df:	89 10                	mov    %edx,(%eax)
  8034e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034e7:	89 50 04             	mov    %edx,0x4(%eax)
  8034ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ed:	8b 00                	mov    (%eax),%eax
  8034ef:	85 c0                	test   %eax,%eax
  8034f1:	75 08                	jne    8034fb <insert_sorted_with_merge_freeList+0x3a7>
  8034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034fb:	a1 44 51 80 00       	mov    0x805144,%eax
  803500:	40                   	inc    %eax
  803501:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  803506:	e9 a2 03 00 00       	jmp    8038ad <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  80350b:	8b 45 08             	mov    0x8(%ebp),%eax
  80350e:	8b 50 08             	mov    0x8(%eax),%edx
  803511:	8b 45 08             	mov    0x8(%ebp),%eax
  803514:	8b 40 0c             	mov    0xc(%eax),%eax
  803517:	01 c2                	add    %eax,%edx
  803519:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80351c:	8b 40 08             	mov    0x8(%eax),%eax
  80351f:	39 c2                	cmp    %eax,%edx
  803521:	0f 83 ae 00 00 00    	jae    8035d5 <insert_sorted_with_merge_freeList+0x481>
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	8b 50 08             	mov    0x8(%eax),%edx
  80352d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803530:	8b 48 08             	mov    0x8(%eax),%ecx
  803533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803536:	8b 40 0c             	mov    0xc(%eax),%eax
  803539:	01 c8                	add    %ecx,%eax
  80353b:	39 c2                	cmp    %eax,%edx
  80353d:	0f 85 92 00 00 00    	jne    8035d5 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  803543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803546:	8b 50 0c             	mov    0xc(%eax),%edx
  803549:	8b 45 08             	mov    0x8(%ebp),%eax
  80354c:	8b 40 0c             	mov    0xc(%eax),%eax
  80354f:	01 c2                	add    %eax,%edx
  803551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803554:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803557:	8b 45 08             	mov    0x8(%ebp),%eax
  80355a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803561:	8b 45 08             	mov    0x8(%ebp),%eax
  803564:	8b 50 08             	mov    0x8(%eax),%edx
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80356d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803571:	75 17                	jne    80358a <insert_sorted_with_merge_freeList+0x436>
  803573:	83 ec 04             	sub    $0x4,%esp
  803576:	68 64 44 80 00       	push   $0x804464
  80357b:	68 51 01 00 00       	push   $0x151
  803580:	68 87 44 80 00       	push   $0x804487
  803585:	e8 18 d4 ff ff       	call   8009a2 <_panic>
  80358a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803590:	8b 45 08             	mov    0x8(%ebp),%eax
  803593:	89 10                	mov    %edx,(%eax)
  803595:	8b 45 08             	mov    0x8(%ebp),%eax
  803598:	8b 00                	mov    (%eax),%eax
  80359a:	85 c0                	test   %eax,%eax
  80359c:	74 0d                	je     8035ab <insert_sorted_with_merge_freeList+0x457>
  80359e:	a1 48 51 80 00       	mov    0x805148,%eax
  8035a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8035a6:	89 50 04             	mov    %edx,0x4(%eax)
  8035a9:	eb 08                	jmp    8035b3 <insert_sorted_with_merge_freeList+0x45f>
  8035ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b6:	a3 48 51 80 00       	mov    %eax,0x805148
  8035bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035c5:	a1 54 51 80 00       	mov    0x805154,%eax
  8035ca:	40                   	inc    %eax
  8035cb:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  8035d0:	e9 d8 02 00 00       	jmp    8038ad <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  8035d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d8:	8b 50 08             	mov    0x8(%eax),%edx
  8035db:	8b 45 08             	mov    0x8(%ebp),%eax
  8035de:	8b 40 0c             	mov    0xc(%eax),%eax
  8035e1:	01 c2                	add    %eax,%edx
  8035e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035e6:	8b 40 08             	mov    0x8(%eax),%eax
  8035e9:	39 c2                	cmp    %eax,%edx
  8035eb:	0f 85 ba 00 00 00    	jne    8036ab <insert_sorted_with_merge_freeList+0x557>
  8035f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f4:	8b 50 08             	mov    0x8(%eax),%edx
  8035f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fa:	8b 48 08             	mov    0x8(%eax),%ecx
  8035fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803600:	8b 40 0c             	mov    0xc(%eax),%eax
  803603:	01 c8                	add    %ecx,%eax
  803605:	39 c2                	cmp    %eax,%edx
  803607:	0f 86 9e 00 00 00    	jbe    8036ab <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  80360d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803610:	8b 50 0c             	mov    0xc(%eax),%edx
  803613:	8b 45 08             	mov    0x8(%ebp),%eax
  803616:	8b 40 0c             	mov    0xc(%eax),%eax
  803619:	01 c2                	add    %eax,%edx
  80361b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361e:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  803621:	8b 45 08             	mov    0x8(%ebp),%eax
  803624:	8b 50 08             	mov    0x8(%eax),%edx
  803627:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80362a:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  80362d:	8b 45 08             	mov    0x8(%ebp),%eax
  803630:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803637:	8b 45 08             	mov    0x8(%ebp),%eax
  80363a:	8b 50 08             	mov    0x8(%eax),%edx
  80363d:	8b 45 08             	mov    0x8(%ebp),%eax
  803640:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803643:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803647:	75 17                	jne    803660 <insert_sorted_with_merge_freeList+0x50c>
  803649:	83 ec 04             	sub    $0x4,%esp
  80364c:	68 64 44 80 00       	push   $0x804464
  803651:	68 5b 01 00 00       	push   $0x15b
  803656:	68 87 44 80 00       	push   $0x804487
  80365b:	e8 42 d3 ff ff       	call   8009a2 <_panic>
  803660:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803666:	8b 45 08             	mov    0x8(%ebp),%eax
  803669:	89 10                	mov    %edx,(%eax)
  80366b:	8b 45 08             	mov    0x8(%ebp),%eax
  80366e:	8b 00                	mov    (%eax),%eax
  803670:	85 c0                	test   %eax,%eax
  803672:	74 0d                	je     803681 <insert_sorted_with_merge_freeList+0x52d>
  803674:	a1 48 51 80 00       	mov    0x805148,%eax
  803679:	8b 55 08             	mov    0x8(%ebp),%edx
  80367c:	89 50 04             	mov    %edx,0x4(%eax)
  80367f:	eb 08                	jmp    803689 <insert_sorted_with_merge_freeList+0x535>
  803681:	8b 45 08             	mov    0x8(%ebp),%eax
  803684:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803689:	8b 45 08             	mov    0x8(%ebp),%eax
  80368c:	a3 48 51 80 00       	mov    %eax,0x805148
  803691:	8b 45 08             	mov    0x8(%ebp),%eax
  803694:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80369b:	a1 54 51 80 00       	mov    0x805154,%eax
  8036a0:	40                   	inc    %eax
  8036a1:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8036a6:	e9 02 02 00 00       	jmp    8038ad <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8036ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ae:	8b 50 08             	mov    0x8(%eax),%edx
  8036b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8036b7:	01 c2                	add    %eax,%edx
  8036b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036bc:	8b 40 08             	mov    0x8(%eax),%eax
  8036bf:	39 c2                	cmp    %eax,%edx
  8036c1:	0f 85 ae 01 00 00    	jne    803875 <insert_sorted_with_merge_freeList+0x721>
  8036c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ca:	8b 50 08             	mov    0x8(%eax),%edx
  8036cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d0:	8b 48 08             	mov    0x8(%eax),%ecx
  8036d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d9:	01 c8                	add    %ecx,%eax
  8036db:	39 c2                	cmp    %eax,%edx
  8036dd:	0f 85 92 01 00 00    	jne    803875 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  8036e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e6:	8b 50 0c             	mov    0xc(%eax),%edx
  8036e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ef:	01 c2                	add    %eax,%edx
  8036f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f7:	01 c2                	add    %eax,%edx
  8036f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fc:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  8036ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803702:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803709:	8b 45 08             	mov    0x8(%ebp),%eax
  80370c:	8b 50 08             	mov    0x8(%eax),%edx
  80370f:	8b 45 08             	mov    0x8(%ebp),%eax
  803712:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803715:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803718:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80371f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803722:	8b 50 08             	mov    0x8(%eax),%edx
  803725:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803728:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  80372b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80372f:	75 17                	jne    803748 <insert_sorted_with_merge_freeList+0x5f4>
  803731:	83 ec 04             	sub    $0x4,%esp
  803734:	68 2f 45 80 00       	push   $0x80452f
  803739:	68 63 01 00 00       	push   $0x163
  80373e:	68 87 44 80 00       	push   $0x804487
  803743:	e8 5a d2 ff ff       	call   8009a2 <_panic>
  803748:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80374b:	8b 00                	mov    (%eax),%eax
  80374d:	85 c0                	test   %eax,%eax
  80374f:	74 10                	je     803761 <insert_sorted_with_merge_freeList+0x60d>
  803751:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803754:	8b 00                	mov    (%eax),%eax
  803756:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803759:	8b 52 04             	mov    0x4(%edx),%edx
  80375c:	89 50 04             	mov    %edx,0x4(%eax)
  80375f:	eb 0b                	jmp    80376c <insert_sorted_with_merge_freeList+0x618>
  803761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803764:	8b 40 04             	mov    0x4(%eax),%eax
  803767:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80376c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80376f:	8b 40 04             	mov    0x4(%eax),%eax
  803772:	85 c0                	test   %eax,%eax
  803774:	74 0f                	je     803785 <insert_sorted_with_merge_freeList+0x631>
  803776:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803779:	8b 40 04             	mov    0x4(%eax),%eax
  80377c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80377f:	8b 12                	mov    (%edx),%edx
  803781:	89 10                	mov    %edx,(%eax)
  803783:	eb 0a                	jmp    80378f <insert_sorted_with_merge_freeList+0x63b>
  803785:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803788:	8b 00                	mov    (%eax),%eax
  80378a:	a3 38 51 80 00       	mov    %eax,0x805138
  80378f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803792:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803798:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80379b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a2:	a1 44 51 80 00       	mov    0x805144,%eax
  8037a7:	48                   	dec    %eax
  8037a8:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8037ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037b1:	75 17                	jne    8037ca <insert_sorted_with_merge_freeList+0x676>
  8037b3:	83 ec 04             	sub    $0x4,%esp
  8037b6:	68 64 44 80 00       	push   $0x804464
  8037bb:	68 64 01 00 00       	push   $0x164
  8037c0:	68 87 44 80 00       	push   $0x804487
  8037c5:	e8 d8 d1 ff ff       	call   8009a2 <_panic>
  8037ca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d3:	89 10                	mov    %edx,(%eax)
  8037d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037d8:	8b 00                	mov    (%eax),%eax
  8037da:	85 c0                	test   %eax,%eax
  8037dc:	74 0d                	je     8037eb <insert_sorted_with_merge_freeList+0x697>
  8037de:	a1 48 51 80 00       	mov    0x805148,%eax
  8037e3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8037e6:	89 50 04             	mov    %edx,0x4(%eax)
  8037e9:	eb 08                	jmp    8037f3 <insert_sorted_with_merge_freeList+0x69f>
  8037eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037ee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8037fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803805:	a1 54 51 80 00       	mov    0x805154,%eax
  80380a:	40                   	inc    %eax
  80380b:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803810:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803814:	75 17                	jne    80382d <insert_sorted_with_merge_freeList+0x6d9>
  803816:	83 ec 04             	sub    $0x4,%esp
  803819:	68 64 44 80 00       	push   $0x804464
  80381e:	68 65 01 00 00       	push   $0x165
  803823:	68 87 44 80 00       	push   $0x804487
  803828:	e8 75 d1 ff ff       	call   8009a2 <_panic>
  80382d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803833:	8b 45 08             	mov    0x8(%ebp),%eax
  803836:	89 10                	mov    %edx,(%eax)
  803838:	8b 45 08             	mov    0x8(%ebp),%eax
  80383b:	8b 00                	mov    (%eax),%eax
  80383d:	85 c0                	test   %eax,%eax
  80383f:	74 0d                	je     80384e <insert_sorted_with_merge_freeList+0x6fa>
  803841:	a1 48 51 80 00       	mov    0x805148,%eax
  803846:	8b 55 08             	mov    0x8(%ebp),%edx
  803849:	89 50 04             	mov    %edx,0x4(%eax)
  80384c:	eb 08                	jmp    803856 <insert_sorted_with_merge_freeList+0x702>
  80384e:	8b 45 08             	mov    0x8(%ebp),%eax
  803851:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803856:	8b 45 08             	mov    0x8(%ebp),%eax
  803859:	a3 48 51 80 00       	mov    %eax,0x805148
  80385e:	8b 45 08             	mov    0x8(%ebp),%eax
  803861:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803868:	a1 54 51 80 00       	mov    0x805154,%eax
  80386d:	40                   	inc    %eax
  80386e:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  803873:	eb 38                	jmp    8038ad <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803875:	a1 40 51 80 00       	mov    0x805140,%eax
  80387a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80387d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803881:	74 07                	je     80388a <insert_sorted_with_merge_freeList+0x736>
  803883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803886:	8b 00                	mov    (%eax),%eax
  803888:	eb 05                	jmp    80388f <insert_sorted_with_merge_freeList+0x73b>
  80388a:	b8 00 00 00 00       	mov    $0x0,%eax
  80388f:	a3 40 51 80 00       	mov    %eax,0x805140
  803894:	a1 40 51 80 00       	mov    0x805140,%eax
  803899:	85 c0                	test   %eax,%eax
  80389b:	0f 85 a7 fb ff ff    	jne    803448 <insert_sorted_with_merge_freeList+0x2f4>
  8038a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038a5:	0f 85 9d fb ff ff    	jne    803448 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8038ab:	eb 00                	jmp    8038ad <insert_sorted_with_merge_freeList+0x759>
  8038ad:	90                   	nop
  8038ae:	c9                   	leave  
  8038af:	c3                   	ret    

008038b0 <__udivdi3>:
  8038b0:	55                   	push   %ebp
  8038b1:	57                   	push   %edi
  8038b2:	56                   	push   %esi
  8038b3:	53                   	push   %ebx
  8038b4:	83 ec 1c             	sub    $0x1c,%esp
  8038b7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038bb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038bf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038c7:	89 ca                	mov    %ecx,%edx
  8038c9:	89 f8                	mov    %edi,%eax
  8038cb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038cf:	85 f6                	test   %esi,%esi
  8038d1:	75 2d                	jne    803900 <__udivdi3+0x50>
  8038d3:	39 cf                	cmp    %ecx,%edi
  8038d5:	77 65                	ja     80393c <__udivdi3+0x8c>
  8038d7:	89 fd                	mov    %edi,%ebp
  8038d9:	85 ff                	test   %edi,%edi
  8038db:	75 0b                	jne    8038e8 <__udivdi3+0x38>
  8038dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8038e2:	31 d2                	xor    %edx,%edx
  8038e4:	f7 f7                	div    %edi
  8038e6:	89 c5                	mov    %eax,%ebp
  8038e8:	31 d2                	xor    %edx,%edx
  8038ea:	89 c8                	mov    %ecx,%eax
  8038ec:	f7 f5                	div    %ebp
  8038ee:	89 c1                	mov    %eax,%ecx
  8038f0:	89 d8                	mov    %ebx,%eax
  8038f2:	f7 f5                	div    %ebp
  8038f4:	89 cf                	mov    %ecx,%edi
  8038f6:	89 fa                	mov    %edi,%edx
  8038f8:	83 c4 1c             	add    $0x1c,%esp
  8038fb:	5b                   	pop    %ebx
  8038fc:	5e                   	pop    %esi
  8038fd:	5f                   	pop    %edi
  8038fe:	5d                   	pop    %ebp
  8038ff:	c3                   	ret    
  803900:	39 ce                	cmp    %ecx,%esi
  803902:	77 28                	ja     80392c <__udivdi3+0x7c>
  803904:	0f bd fe             	bsr    %esi,%edi
  803907:	83 f7 1f             	xor    $0x1f,%edi
  80390a:	75 40                	jne    80394c <__udivdi3+0x9c>
  80390c:	39 ce                	cmp    %ecx,%esi
  80390e:	72 0a                	jb     80391a <__udivdi3+0x6a>
  803910:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803914:	0f 87 9e 00 00 00    	ja     8039b8 <__udivdi3+0x108>
  80391a:	b8 01 00 00 00       	mov    $0x1,%eax
  80391f:	89 fa                	mov    %edi,%edx
  803921:	83 c4 1c             	add    $0x1c,%esp
  803924:	5b                   	pop    %ebx
  803925:	5e                   	pop    %esi
  803926:	5f                   	pop    %edi
  803927:	5d                   	pop    %ebp
  803928:	c3                   	ret    
  803929:	8d 76 00             	lea    0x0(%esi),%esi
  80392c:	31 ff                	xor    %edi,%edi
  80392e:	31 c0                	xor    %eax,%eax
  803930:	89 fa                	mov    %edi,%edx
  803932:	83 c4 1c             	add    $0x1c,%esp
  803935:	5b                   	pop    %ebx
  803936:	5e                   	pop    %esi
  803937:	5f                   	pop    %edi
  803938:	5d                   	pop    %ebp
  803939:	c3                   	ret    
  80393a:	66 90                	xchg   %ax,%ax
  80393c:	89 d8                	mov    %ebx,%eax
  80393e:	f7 f7                	div    %edi
  803940:	31 ff                	xor    %edi,%edi
  803942:	89 fa                	mov    %edi,%edx
  803944:	83 c4 1c             	add    $0x1c,%esp
  803947:	5b                   	pop    %ebx
  803948:	5e                   	pop    %esi
  803949:	5f                   	pop    %edi
  80394a:	5d                   	pop    %ebp
  80394b:	c3                   	ret    
  80394c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803951:	89 eb                	mov    %ebp,%ebx
  803953:	29 fb                	sub    %edi,%ebx
  803955:	89 f9                	mov    %edi,%ecx
  803957:	d3 e6                	shl    %cl,%esi
  803959:	89 c5                	mov    %eax,%ebp
  80395b:	88 d9                	mov    %bl,%cl
  80395d:	d3 ed                	shr    %cl,%ebp
  80395f:	89 e9                	mov    %ebp,%ecx
  803961:	09 f1                	or     %esi,%ecx
  803963:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803967:	89 f9                	mov    %edi,%ecx
  803969:	d3 e0                	shl    %cl,%eax
  80396b:	89 c5                	mov    %eax,%ebp
  80396d:	89 d6                	mov    %edx,%esi
  80396f:	88 d9                	mov    %bl,%cl
  803971:	d3 ee                	shr    %cl,%esi
  803973:	89 f9                	mov    %edi,%ecx
  803975:	d3 e2                	shl    %cl,%edx
  803977:	8b 44 24 08          	mov    0x8(%esp),%eax
  80397b:	88 d9                	mov    %bl,%cl
  80397d:	d3 e8                	shr    %cl,%eax
  80397f:	09 c2                	or     %eax,%edx
  803981:	89 d0                	mov    %edx,%eax
  803983:	89 f2                	mov    %esi,%edx
  803985:	f7 74 24 0c          	divl   0xc(%esp)
  803989:	89 d6                	mov    %edx,%esi
  80398b:	89 c3                	mov    %eax,%ebx
  80398d:	f7 e5                	mul    %ebp
  80398f:	39 d6                	cmp    %edx,%esi
  803991:	72 19                	jb     8039ac <__udivdi3+0xfc>
  803993:	74 0b                	je     8039a0 <__udivdi3+0xf0>
  803995:	89 d8                	mov    %ebx,%eax
  803997:	31 ff                	xor    %edi,%edi
  803999:	e9 58 ff ff ff       	jmp    8038f6 <__udivdi3+0x46>
  80399e:	66 90                	xchg   %ax,%ax
  8039a0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039a4:	89 f9                	mov    %edi,%ecx
  8039a6:	d3 e2                	shl    %cl,%edx
  8039a8:	39 c2                	cmp    %eax,%edx
  8039aa:	73 e9                	jae    803995 <__udivdi3+0xe5>
  8039ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039af:	31 ff                	xor    %edi,%edi
  8039b1:	e9 40 ff ff ff       	jmp    8038f6 <__udivdi3+0x46>
  8039b6:	66 90                	xchg   %ax,%ax
  8039b8:	31 c0                	xor    %eax,%eax
  8039ba:	e9 37 ff ff ff       	jmp    8038f6 <__udivdi3+0x46>
  8039bf:	90                   	nop

008039c0 <__umoddi3>:
  8039c0:	55                   	push   %ebp
  8039c1:	57                   	push   %edi
  8039c2:	56                   	push   %esi
  8039c3:	53                   	push   %ebx
  8039c4:	83 ec 1c             	sub    $0x1c,%esp
  8039c7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039cb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039d3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039db:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039df:	89 f3                	mov    %esi,%ebx
  8039e1:	89 fa                	mov    %edi,%edx
  8039e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039e7:	89 34 24             	mov    %esi,(%esp)
  8039ea:	85 c0                	test   %eax,%eax
  8039ec:	75 1a                	jne    803a08 <__umoddi3+0x48>
  8039ee:	39 f7                	cmp    %esi,%edi
  8039f0:	0f 86 a2 00 00 00    	jbe    803a98 <__umoddi3+0xd8>
  8039f6:	89 c8                	mov    %ecx,%eax
  8039f8:	89 f2                	mov    %esi,%edx
  8039fa:	f7 f7                	div    %edi
  8039fc:	89 d0                	mov    %edx,%eax
  8039fe:	31 d2                	xor    %edx,%edx
  803a00:	83 c4 1c             	add    $0x1c,%esp
  803a03:	5b                   	pop    %ebx
  803a04:	5e                   	pop    %esi
  803a05:	5f                   	pop    %edi
  803a06:	5d                   	pop    %ebp
  803a07:	c3                   	ret    
  803a08:	39 f0                	cmp    %esi,%eax
  803a0a:	0f 87 ac 00 00 00    	ja     803abc <__umoddi3+0xfc>
  803a10:	0f bd e8             	bsr    %eax,%ebp
  803a13:	83 f5 1f             	xor    $0x1f,%ebp
  803a16:	0f 84 ac 00 00 00    	je     803ac8 <__umoddi3+0x108>
  803a1c:	bf 20 00 00 00       	mov    $0x20,%edi
  803a21:	29 ef                	sub    %ebp,%edi
  803a23:	89 fe                	mov    %edi,%esi
  803a25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a29:	89 e9                	mov    %ebp,%ecx
  803a2b:	d3 e0                	shl    %cl,%eax
  803a2d:	89 d7                	mov    %edx,%edi
  803a2f:	89 f1                	mov    %esi,%ecx
  803a31:	d3 ef                	shr    %cl,%edi
  803a33:	09 c7                	or     %eax,%edi
  803a35:	89 e9                	mov    %ebp,%ecx
  803a37:	d3 e2                	shl    %cl,%edx
  803a39:	89 14 24             	mov    %edx,(%esp)
  803a3c:	89 d8                	mov    %ebx,%eax
  803a3e:	d3 e0                	shl    %cl,%eax
  803a40:	89 c2                	mov    %eax,%edx
  803a42:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a46:	d3 e0                	shl    %cl,%eax
  803a48:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a4c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a50:	89 f1                	mov    %esi,%ecx
  803a52:	d3 e8                	shr    %cl,%eax
  803a54:	09 d0                	or     %edx,%eax
  803a56:	d3 eb                	shr    %cl,%ebx
  803a58:	89 da                	mov    %ebx,%edx
  803a5a:	f7 f7                	div    %edi
  803a5c:	89 d3                	mov    %edx,%ebx
  803a5e:	f7 24 24             	mull   (%esp)
  803a61:	89 c6                	mov    %eax,%esi
  803a63:	89 d1                	mov    %edx,%ecx
  803a65:	39 d3                	cmp    %edx,%ebx
  803a67:	0f 82 87 00 00 00    	jb     803af4 <__umoddi3+0x134>
  803a6d:	0f 84 91 00 00 00    	je     803b04 <__umoddi3+0x144>
  803a73:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a77:	29 f2                	sub    %esi,%edx
  803a79:	19 cb                	sbb    %ecx,%ebx
  803a7b:	89 d8                	mov    %ebx,%eax
  803a7d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a81:	d3 e0                	shl    %cl,%eax
  803a83:	89 e9                	mov    %ebp,%ecx
  803a85:	d3 ea                	shr    %cl,%edx
  803a87:	09 d0                	or     %edx,%eax
  803a89:	89 e9                	mov    %ebp,%ecx
  803a8b:	d3 eb                	shr    %cl,%ebx
  803a8d:	89 da                	mov    %ebx,%edx
  803a8f:	83 c4 1c             	add    $0x1c,%esp
  803a92:	5b                   	pop    %ebx
  803a93:	5e                   	pop    %esi
  803a94:	5f                   	pop    %edi
  803a95:	5d                   	pop    %ebp
  803a96:	c3                   	ret    
  803a97:	90                   	nop
  803a98:	89 fd                	mov    %edi,%ebp
  803a9a:	85 ff                	test   %edi,%edi
  803a9c:	75 0b                	jne    803aa9 <__umoddi3+0xe9>
  803a9e:	b8 01 00 00 00       	mov    $0x1,%eax
  803aa3:	31 d2                	xor    %edx,%edx
  803aa5:	f7 f7                	div    %edi
  803aa7:	89 c5                	mov    %eax,%ebp
  803aa9:	89 f0                	mov    %esi,%eax
  803aab:	31 d2                	xor    %edx,%edx
  803aad:	f7 f5                	div    %ebp
  803aaf:	89 c8                	mov    %ecx,%eax
  803ab1:	f7 f5                	div    %ebp
  803ab3:	89 d0                	mov    %edx,%eax
  803ab5:	e9 44 ff ff ff       	jmp    8039fe <__umoddi3+0x3e>
  803aba:	66 90                	xchg   %ax,%ax
  803abc:	89 c8                	mov    %ecx,%eax
  803abe:	89 f2                	mov    %esi,%edx
  803ac0:	83 c4 1c             	add    $0x1c,%esp
  803ac3:	5b                   	pop    %ebx
  803ac4:	5e                   	pop    %esi
  803ac5:	5f                   	pop    %edi
  803ac6:	5d                   	pop    %ebp
  803ac7:	c3                   	ret    
  803ac8:	3b 04 24             	cmp    (%esp),%eax
  803acb:	72 06                	jb     803ad3 <__umoddi3+0x113>
  803acd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ad1:	77 0f                	ja     803ae2 <__umoddi3+0x122>
  803ad3:	89 f2                	mov    %esi,%edx
  803ad5:	29 f9                	sub    %edi,%ecx
  803ad7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803adb:	89 14 24             	mov    %edx,(%esp)
  803ade:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803ae2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ae6:	8b 14 24             	mov    (%esp),%edx
  803ae9:	83 c4 1c             	add    $0x1c,%esp
  803aec:	5b                   	pop    %ebx
  803aed:	5e                   	pop    %esi
  803aee:	5f                   	pop    %edi
  803aef:	5d                   	pop    %ebp
  803af0:	c3                   	ret    
  803af1:	8d 76 00             	lea    0x0(%esi),%esi
  803af4:	2b 04 24             	sub    (%esp),%eax
  803af7:	19 fa                	sbb    %edi,%edx
  803af9:	89 d1                	mov    %edx,%ecx
  803afb:	89 c6                	mov    %eax,%esi
  803afd:	e9 71 ff ff ff       	jmp    803a73 <__umoddi3+0xb3>
  803b02:	66 90                	xchg   %ax,%ax
  803b04:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b08:	72 ea                	jb     803af4 <__umoddi3+0x134>
  803b0a:	89 d9                	mov    %ebx,%ecx
  803b0c:	e9 62 ff ff ff       	jmp    803a73 <__umoddi3+0xb3>
