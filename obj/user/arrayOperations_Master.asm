
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 2b 07 00 00       	call   800761 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 88 00 00 00    	sub    $0x88,%esp
	/*[1] CREATE SHARED ARRAY*/
	int ret;
	char Chose;
	char Line[30];
	//2012: lock the interrupt
	sys_disable_interrupt();
  800041:	e8 58 21 00 00       	call   80219e <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 3a 80 00       	push   $0x803a20
  80004e:	e8 fe 0a 00 00       	call   800b51 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 3a 80 00       	push   $0x803a22
  80005e:	e8 ee 0a 00 00       	call   800b51 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 40 3a 80 00       	push   $0x803a40
  80006e:	e8 de 0a 00 00       	call   800b51 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 3a 80 00       	push   $0x803a22
  80007e:	e8 ce 0a 00 00       	call   800b51 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 3a 80 00       	push   $0x803a20
  80008e:	e8 be 0a 00 00       	call   800b51 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 60 3a 80 00       	push   $0x803a60
  8000a2:	e8 2c 11 00 00       	call   8011d3 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 7f 3a 80 00       	push   $0x803a7f
  8000b6:	e8 17 1d 00 00       	call   801dd2 <smalloc>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 0a                	push   $0xa
  8000c6:	6a 00                	push   $0x0
  8000c8:	8d 45 82             	lea    -0x7e(%ebp),%eax
  8000cb:	50                   	push   %eax
  8000cc:	e8 68 16 00 00       	call   801739 <strtol>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	89 c2                	mov    %eax,%edx
  8000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d9:	89 10                	mov    %edx,(%eax)
		int NumOfElements = *arrSize;
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8b 00                	mov    (%eax),%eax
  8000e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  8000e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e6:	c1 e0 02             	shl    $0x2,%eax
  8000e9:	83 ec 04             	sub    $0x4,%esp
  8000ec:	6a 00                	push   $0x0
  8000ee:	50                   	push   %eax
  8000ef:	68 87 3a 80 00       	push   $0x803a87
  8000f4:	e8 d9 1c 00 00       	call   801dd2 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 8c 3a 80 00       	push   $0x803a8c
  800107:	e8 45 0a 00 00       	call   800b51 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 ae 3a 80 00       	push   $0x803aae
  800117:	e8 35 0a 00 00       	call   800b51 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 bc 3a 80 00       	push   $0x803abc
  800127:	e8 25 0a 00 00       	call   800b51 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 cb 3a 80 00       	push   $0x803acb
  800137:	e8 15 0a 00 00       	call   800b51 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 db 3a 80 00       	push   $0x803adb
  800147:	e8 05 0a 00 00       	call   800b51 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80014f:	e8 b5 05 00 00       	call   800709 <getchar>
  800154:	88 45 eb             	mov    %al,-0x15(%ebp)
			cputchar(Chose);
  800157:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	50                   	push   %eax
  80015f:	e8 5d 05 00 00       	call   8006c1 <cputchar>
  800164:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	6a 0a                	push   $0xa
  80016c:	e8 50 05 00 00       	call   8006c1 <cputchar>
  800171:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800174:	80 7d eb 61          	cmpb   $0x61,-0x15(%ebp)
  800178:	74 0c                	je     800186 <_main+0x14e>
  80017a:	80 7d eb 62          	cmpb   $0x62,-0x15(%ebp)
  80017e:	74 06                	je     800186 <_main+0x14e>
  800180:	80 7d eb 63          	cmpb   $0x63,-0x15(%ebp)
  800184:	75 b9                	jne    80013f <_main+0x107>

	//2012: unlock the interrupt
	sys_enable_interrupt();
  800186:	e8 2d 20 00 00       	call   8021b8 <sys_enable_interrupt>

	int  i ;
	switch (Chose)
  80018b:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80018f:	83 f8 62             	cmp    $0x62,%eax
  800192:	74 1d                	je     8001b1 <_main+0x179>
  800194:	83 f8 63             	cmp    $0x63,%eax
  800197:	74 2b                	je     8001c4 <_main+0x18c>
  800199:	83 f8 61             	cmp    $0x61,%eax
  80019c:	75 39                	jne    8001d7 <_main+0x19f>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	e8 9b 03 00 00       	call   800547 <InitializeAscending>
  8001ac:	83 c4 10             	add    $0x10,%esp
		break ;
  8001af:	eb 37                	jmp    8001e8 <_main+0x1b0>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 b9 03 00 00       	call   800578 <InitializeDescending>
  8001bf:	83 c4 10             	add    $0x10,%esp
		break ;
  8001c2:	eb 24                	jmp    8001e8 <_main+0x1b0>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 db 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001d2:	83 c4 10             	add    $0x10,%esp
		break ;
  8001d5:	eb 11                	jmp    8001e8 <_main+0x1b0>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	ff 75 f0             	pushl  -0x10(%ebp)
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	e8 c8 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001e5:	83 c4 10             	add    $0x10,%esp
	}

	//Create the check-finishing counter
	int numOfSlaveProgs = 3 ;
  8001e8:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	6a 04                	push   $0x4
  8001f6:	68 e4 3a 80 00       	push   $0x803ae4
  8001fb:	e8 d2 1b 00 00       	call   801dd2 <smalloc>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  800206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[2] RUN THE SLAVES PROGRAMS*/
	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80020f:	a1 20 50 80 00       	mov    0x805020,%eax
  800214:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800225:	89 c1                	mov    %eax,%ecx
  800227:	a1 20 50 80 00       	mov    0x805020,%eax
  80022c:	8b 40 74             	mov    0x74(%eax),%eax
  80022f:	52                   	push   %edx
  800230:	51                   	push   %ecx
  800231:	50                   	push   %eax
  800232:	68 f2 3a 80 00       	push   $0x803af2
  800237:	e8 e7 20 00 00       	call   802323 <sys_create_env>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800242:	a1 20 50 80 00       	mov    0x805020,%eax
  800247:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80024d:	a1 20 50 80 00       	mov    0x805020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c1                	mov    %eax,%ecx
  80025a:	a1 20 50 80 00       	mov    0x805020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	52                   	push   %edx
  800263:	51                   	push   %ecx
  800264:	50                   	push   %eax
  800265:	68 fb 3a 80 00       	push   $0x803afb
  80026a:	e8 b4 20 00 00       	call   802323 <sys_create_env>
  80026f:	83 c4 10             	add    $0x10,%esp
  800272:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800275:	a1 20 50 80 00       	mov    0x805020,%eax
  80027a:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800280:	a1 20 50 80 00       	mov    0x805020,%eax
  800285:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80028b:	89 c1                	mov    %eax,%ecx
  80028d:	a1 20 50 80 00       	mov    0x805020,%eax
  800292:	8b 40 74             	mov    0x74(%eax),%eax
  800295:	52                   	push   %edx
  800296:	51                   	push   %ecx
  800297:	50                   	push   %eax
  800298:	68 04 3b 80 00       	push   $0x803b04
  80029d:	e8 81 20 00 00       	call   802323 <sys_create_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  8002a8:	83 7d dc ef          	cmpl   $0xffffffef,-0x24(%ebp)
  8002ac:	74 0c                	je     8002ba <_main+0x282>
  8002ae:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  8002b2:	74 06                	je     8002ba <_main+0x282>
  8002b4:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8002b8:	75 14                	jne    8002ce <_main+0x296>
		panic("NO AVAILABLE ENVs...");
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 10 3b 80 00       	push   $0x803b10
  8002c2:	6a 4b                	push   $0x4b
  8002c4:	68 25 3b 80 00       	push   $0x803b25
  8002c9:	e8 cf 05 00 00       	call   80089d <_panic>

	sys_run_env(envIdQuickSort);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	e8 68 20 00 00       	call   802341 <sys_run_env>
  8002d9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	e8 5a 20 00 00       	call   802341 <sys_run_env>
  8002e7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f0:	e8 4c 20 00 00       	call   802341 <sys_run_env>
  8002f5:	83 c4 10             	add    $0x10,%esp

	/*[3] BUSY-WAIT TILL FINISHING THEM*/
	while (*numOfFinished != numOfSlaveProgs) ;
  8002f8:	90                   	nop
  8002f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fc:	8b 00                	mov    (%eax),%eax
  8002fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800301:	75 f6                	jne    8002f9 <_main+0x2c1>

	/*[4] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  800303:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int *mergesortedArr = NULL;
  80030a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	int *mean = NULL;
  800311:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	int *var = NULL;
  800318:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	int *min = NULL;
  80031f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
	int *max = NULL;
  800326:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int *med = NULL;
  80032d:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	68 43 3b 80 00       	push   $0x803b43
  80033c:	ff 75 dc             	pushl  -0x24(%ebp)
  80033f:	e8 37 1b 00 00       	call   801e7b <sget>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	68 52 3b 80 00       	push   $0x803b52
  800352:	ff 75 d8             	pushl  -0x28(%ebp)
  800355:	e8 21 1b 00 00       	call   801e7b <sget>
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	68 61 3b 80 00       	push   $0x803b61
  800368:	ff 75 d4             	pushl  -0x2c(%ebp)
  80036b:	e8 0b 1b 00 00       	call   801e7b <sget>
  800370:	83 c4 10             	add    $0x10,%esp
  800373:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	68 66 3b 80 00       	push   $0x803b66
  80037e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800381:	e8 f5 1a 00 00       	call   801e7b <sget>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	68 6a 3b 80 00       	push   $0x803b6a
  800394:	ff 75 d4             	pushl  -0x2c(%ebp)
  800397:	e8 df 1a 00 00       	call   801e7b <sget>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	68 6e 3b 80 00       	push   $0x803b6e
  8003aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003ad:	e8 c9 1a 00 00       	call   801e7b <sget>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 72 3b 80 00       	push   $0x803b72
  8003c0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003c3:	e8 b3 1a 00 00       	call   801e7b <sget>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 b8             	mov    %eax,-0x48(%ebp)

	/*[5] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d7:	e8 14 01 00 00       	call   8004f0 <CheckSorted>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  8003e2:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8003e6:	75 14                	jne    8003fc <_main+0x3c4>
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	68 78 3b 80 00       	push   $0x803b78
  8003f0:	6a 66                	push   $0x66
  8003f2:	68 25 3b 80 00       	push   $0x803b25
  8003f7:	e8 a1 04 00 00       	call   80089d <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800402:	ff 75 cc             	pushl  -0x34(%ebp)
  800405:	e8 e6 00 00 00       	call   8004f0 <CheckSorted>
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  800410:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  800414:	75 14                	jne    80042a <_main+0x3f2>
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 a0 3b 80 00       	push   $0x803ba0
  80041e:	6a 68                	push   $0x68
  800420:	68 25 3b 80 00       	push   $0x803b25
  800425:	e8 73 04 00 00       	call   80089d <_panic>
	int correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  80042a:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  800430:	50                   	push   %eax
  800431:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800437:	50                   	push   %eax
  800438:	ff 75 f0             	pushl  -0x10(%ebp)
  80043b:	ff 75 ec             	pushl  -0x14(%ebp)
  80043e:	e8 b6 01 00 00       	call   8005f9 <ArrayStats>
  800443:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  800446:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int last = NumOfElements-1;
  80044e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800451:	48                   	dec    %eax
  800452:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int middle = (NumOfElements-1)/2;
  800455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800458:	48                   	dec    %eax
  800459:	89 c2                	mov    %eax,%edx
  80045b:	c1 ea 1f             	shr    $0x1f,%edx
  80045e:	01 d0                	add    %edx,%eax
  800460:	d1 f8                	sar    %eax
  800462:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int correctMax = quicksortedArr[last];
  800465:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int correctMed = quicksortedArr[middle];
  800479:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//cprintf("Array is correctly sorted\n");
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);

	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  80048d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800490:	8b 10                	mov    (%eax),%edx
  800492:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800498:	39 c2                	cmp    %eax,%edx
  80049a:	75 2d                	jne    8004c9 <_main+0x491>
  80049c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80049f:	8b 10                	mov    (%eax),%edx
  8004a1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8004a7:	39 c2                	cmp    %eax,%edx
  8004a9:	75 1e                	jne    8004c9 <_main+0x491>
  8004ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  8004b3:	75 14                	jne    8004c9 <_main+0x491>
  8004b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8004bd:	75 0a                	jne    8004c9 <_main+0x491>
  8004bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  8004c7:	74 14                	je     8004dd <_main+0x4a5>
		panic("The array STATS are NOT calculated correctly") ;
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 c8 3b 80 00       	push   $0x803bc8
  8004d1:	6a 75                	push   $0x75
  8004d3:	68 25 3b 80 00       	push   $0x803b25
  8004d8:	e8 c0 03 00 00       	call   80089d <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	68 f8 3b 80 00       	push   $0x803bf8
  8004e5:	e8 67 06 00 00       	call   800b51 <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp

	return;
  8004ed:	90                   	nop
}
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8004f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8004fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800504:	eb 33                	jmp    800539 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800506:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 d0                	add    %edx,%eax
  800515:	8b 10                	mov    (%eax),%edx
  800517:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80051a:	40                   	inc    %eax
  80051b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	01 c8                	add    %ecx,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	39 c2                	cmp    %eax,%edx
  80052b:	7e 09                	jle    800536 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80052d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800534:	eb 0c                	jmp    800542 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800536:	ff 45 f8             	incl   -0x8(%ebp)
  800539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053c:	48                   	dec    %eax
  80053d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800540:	7f c4                	jg     800506 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800542:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80054d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800554:	eb 17                	jmp    80056d <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800556:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 c2                	add    %eax,%edx
  800565:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800568:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80056a:	ff 45 fc             	incl   -0x4(%ebp)
  80056d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800570:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800573:	7c e1                	jl     800556 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800575:	90                   	nop
  800576:	c9                   	leave  
  800577:	c3                   	ret    

00800578 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80057e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800585:	eb 1b                	jmp    8005a2 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80058a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	01 c2                	add    %eax,%edx
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80059c:	48                   	dec    %eax
  80059d:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80059f:	ff 45 fc             	incl   -0x4(%ebp)
  8005a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005a8:	7c dd                	jl     800587 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8005aa:	90                   	nop
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8005b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b6:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8005bb:	f7 e9                	imul   %ecx
  8005bd:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c0:	89 d0                	mov    %edx,%eax
  8005c2:	29 c8                	sub    %ecx,%eax
  8005c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8005c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8005ce:	eb 1e                	jmp    8005ee <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8005d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8005e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005e3:	99                   	cltd   
  8005e4:	f7 7d f8             	idivl  -0x8(%ebp)
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005eb:	ff 45 fc             	incl   -0x4(%ebp)
  8005ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f4:	7c da                	jl     8005d0 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  8005f6:	90                   	nop
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	53                   	push   %ebx
  8005fd:	83 ec 10             	sub    $0x10,%esp
	int i ;
	*mean =0 ;
  800600:	8b 45 10             	mov    0x10(%ebp),%eax
  800603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800609:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800610:	eb 20                	jmp    800632 <ArrayStats+0x39>
	{
		*mean += Elements[i];
  800612:	8b 45 10             	mov    0x10(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80061a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	01 c8                	add    %ecx,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	01 c2                	add    %eax,%edx
  80062a:	8b 45 10             	mov    0x10(%ebp),%eax
  80062d:	89 10                	mov    %edx,(%eax)

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  80062f:	ff 45 f8             	incl   -0x8(%ebp)
  800632:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800635:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800638:	7c d8                	jl     800612 <ArrayStats+0x19>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  80063a:	8b 45 10             	mov    0x10(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
  800640:	f7 7d 0c             	idivl  0xc(%ebp)
  800643:	89 c2                	mov    %eax,%edx
  800645:	8b 45 10             	mov    0x10(%ebp),%eax
  800648:	89 10                	mov    %edx,(%eax)
	*var = 0;
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800653:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80065a:	eb 46                	jmp    8006a2 <ArrayStats+0xa9>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800664:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	01 c8                	add    %ecx,%eax
  800670:	8b 08                	mov    (%eax),%ecx
  800672:	8b 45 10             	mov    0x10(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 cb                	mov    %ecx,%ebx
  800679:	29 c3                	sub    %eax,%ebx
  80067b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80067e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	01 c8                	add    %ecx,%eax
  80068a:	8b 08                	mov    (%eax),%ecx
  80068c:	8b 45 10             	mov    0x10(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	29 c1                	sub    %eax,%ecx
  800693:	89 c8                	mov    %ecx,%eax
  800695:	0f af c3             	imul   %ebx,%eax
  800698:	01 c2                	add    %eax,%edx
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	89 10                	mov    %edx,(%eax)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  80069f:	ff 45 f8             	incl   -0x8(%ebp)
  8006a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006a8:	7c b2                	jl     80065c <ArrayStats+0x63>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
	}
	*var /= NumOfElements;
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	99                   	cltd   
  8006b0:	f7 7d 0c             	idivl  0xc(%ebp)
  8006b3:	89 c2                	mov    %eax,%edx
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	89 10                	mov    %edx,(%eax)
}
  8006ba:	90                   	nop
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	5b                   	pop    %ebx
  8006bf:	5d                   	pop    %ebp
  8006c0:	c3                   	ret    

008006c1 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006cd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006d1:	83 ec 0c             	sub    $0xc,%esp
  8006d4:	50                   	push   %eax
  8006d5:	e8 f8 1a 00 00       	call   8021d2 <sys_cputc>
  8006da:	83 c4 10             	add    $0x10,%esp
}
  8006dd:	90                   	nop
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e6:	e8 b3 1a 00 00       	call   80219e <sys_disable_interrupt>
	char c = ch;
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006f1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006f5:	83 ec 0c             	sub    $0xc,%esp
  8006f8:	50                   	push   %eax
  8006f9:	e8 d4 1a 00 00       	call   8021d2 <sys_cputc>
  8006fe:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800701:	e8 b2 1a 00 00       	call   8021b8 <sys_enable_interrupt>
}
  800706:	90                   	nop
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <getchar>:

int
getchar(void)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80070f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800716:	eb 08                	jmp    800720 <getchar+0x17>
	{
		c = sys_cgetc();
  800718:	e8 fc 18 00 00       	call   802019 <sys_cgetc>
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800724:	74 f2                	je     800718 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800726:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <atomic_getchar>:

int
atomic_getchar(void)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800731:	e8 68 1a 00 00       	call   80219e <sys_disable_interrupt>
	int c=0;
  800736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80073d:	eb 08                	jmp    800747 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  80073f:	e8 d5 18 00 00       	call   802019 <sys_cgetc>
  800744:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80074b:	74 f2                	je     80073f <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  80074d:	e8 66 1a 00 00       	call   8021b8 <sys_enable_interrupt>
	return c;
  800752:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800755:	c9                   	leave  
  800756:	c3                   	ret    

00800757 <iscons>:

int iscons(int fdnum)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80075a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800767:	e8 25 1c 00 00       	call   802391 <sys_getenvindex>
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80076f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800772:	89 d0                	mov    %edx,%eax
  800774:	c1 e0 03             	shl    $0x3,%eax
  800777:	01 d0                	add    %edx,%eax
  800779:	01 c0                	add    %eax,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800784:	01 d0                	add    %edx,%eax
  800786:	c1 e0 04             	shl    $0x4,%eax
  800789:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80078e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800793:	a1 20 50 80 00       	mov    0x805020,%eax
  800798:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80079e:	84 c0                	test   %al,%al
  8007a0:	74 0f                	je     8007b1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007a7:	05 5c 05 00 00       	add    $0x55c,%eax
  8007ac:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007b5:	7e 0a                	jle    8007c1 <libmain+0x60>
		binaryname = argv[0];
  8007b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 69 f8 ff ff       	call   800038 <_main>
  8007cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8007d2:	e8 c7 19 00 00       	call   80219e <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	68 74 3c 80 00       	push   $0x803c74
  8007df:	e8 6d 03 00 00       	call   800b51 <cprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007ec:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8007f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	52                   	push   %edx
  800801:	50                   	push   %eax
  800802:	68 9c 3c 80 00       	push   $0x803c9c
  800807:	e8 45 03 00 00       	call   800b51 <cprintf>
  80080c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80080f:	a1 20 50 80 00       	mov    0x805020,%eax
  800814:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80081a:	a1 20 50 80 00       	mov    0x805020,%eax
  80081f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800825:	a1 20 50 80 00       	mov    0x805020,%eax
  80082a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800830:	51                   	push   %ecx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	68 c4 3c 80 00       	push   $0x803cc4
  800838:	e8 14 03 00 00       	call   800b51 <cprintf>
  80083d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800840:	a1 20 50 80 00       	mov    0x805020,%eax
  800845:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	50                   	push   %eax
  80084f:	68 1c 3d 80 00       	push   $0x803d1c
  800854:	e8 f8 02 00 00       	call   800b51 <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	68 74 3c 80 00       	push   $0x803c74
  800864:	e8 e8 02 00 00       	call   800b51 <cprintf>
  800869:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80086c:	e8 47 19 00 00       	call   8021b8 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800871:	e8 19 00 00 00       	call   80088f <exit>
}
  800876:	90                   	nop
  800877:	c9                   	leave  
  800878:	c3                   	ret    

00800879 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80087f:	83 ec 0c             	sub    $0xc,%esp
  800882:	6a 00                	push   $0x0
  800884:	e8 d4 1a 00 00       	call   80235d <sys_destroy_env>
  800889:	83 c4 10             	add    $0x10,%esp
}
  80088c:	90                   	nop
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    

0080088f <exit>:

void
exit(void)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800895:	e8 29 1b 00 00       	call   8023c3 <sys_exit_env>
}
  80089a:	90                   	nop
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a6:	83 c0 04             	add    $0x4,%eax
  8008a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008ac:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008b1:	85 c0                	test   %eax,%eax
  8008b3:	74 16                	je     8008cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008b5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 30 3d 80 00       	push   $0x803d30
  8008c3:	e8 89 02 00 00       	call   800b51 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	68 35 3d 80 00       	push   $0x803d35
  8008dc:	e8 70 02 00 00       	call   800b51 <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ed:	50                   	push   %eax
  8008ee:	e8 f3 01 00 00       	call   800ae6 <vcprintf>
  8008f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	6a 00                	push   $0x0
  8008fb:	68 51 3d 80 00       	push   $0x803d51
  800900:	e8 e1 01 00 00       	call   800ae6 <vcprintf>
  800905:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800908:	e8 82 ff ff ff       	call   80088f <exit>

	// should not return here
	while (1) ;
  80090d:	eb fe                	jmp    80090d <_panic+0x70>

0080090f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800915:	a1 20 50 80 00       	mov    0x805020,%eax
  80091a:	8b 50 74             	mov    0x74(%eax),%edx
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	39 c2                	cmp    %eax,%edx
  800922:	74 14                	je     800938 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	68 54 3d 80 00       	push   $0x803d54
  80092c:	6a 26                	push   $0x26
  80092e:	68 a0 3d 80 00       	push   $0x803da0
  800933:	e8 65 ff ff ff       	call   80089d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800938:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80093f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800946:	e9 c2 00 00 00       	jmp    800a0d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80094b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	85 c0                	test   %eax,%eax
  80095e:	75 08                	jne    800968 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800960:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800963:	e9 a2 00 00 00       	jmp    800a0a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800968:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800976:	eb 69                	jmp    8009e1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800978:	a1 20 50 80 00       	mov    0x805020,%eax
  80097d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800983:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800986:	89 d0                	mov    %edx,%eax
  800988:	01 c0                	add    %eax,%eax
  80098a:	01 d0                	add    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 c8                	add    %ecx,%eax
  800991:	8a 40 04             	mov    0x4(%eax),%al
  800994:	84 c0                	test   %al,%al
  800996:	75 46                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800998:	a1 20 50 80 00       	mov    0x805020,%eax
  80099d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	c1 e0 03             	shl    $0x3,%eax
  8009af:	01 c8                	add    %ecx,%eax
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	01 c8                	add    %ecx,%eax
  8009cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d1:	39 c2                	cmp    %eax,%edx
  8009d3:	75 09                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8009d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009dc:	eb 12                	jmp    8009f0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	ff 45 e8             	incl   -0x18(%ebp)
  8009e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8009e6:	8b 50 74             	mov    0x74(%eax),%edx
  8009e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009ec:	39 c2                	cmp    %eax,%edx
  8009ee:	77 88                	ja     800978 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009f4:	75 14                	jne    800a0a <CheckWSWithoutLastIndex+0xfb>
			panic(
  8009f6:	83 ec 04             	sub    $0x4,%esp
  8009f9:	68 ac 3d 80 00       	push   $0x803dac
  8009fe:	6a 3a                	push   $0x3a
  800a00:	68 a0 3d 80 00       	push   $0x803da0
  800a05:	e8 93 fe ff ff       	call   80089d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a0a:	ff 45 f0             	incl   -0x10(%ebp)
  800a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a10:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a13:	0f 8c 32 ff ff ff    	jl     80094b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a27:	eb 26                	jmp    800a4f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a29:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a37:	89 d0                	mov    %edx,%eax
  800a39:	01 c0                	add    %eax,%eax
  800a3b:	01 d0                	add    %edx,%eax
  800a3d:	c1 e0 03             	shl    $0x3,%eax
  800a40:	01 c8                	add    %ecx,%eax
  800a42:	8a 40 04             	mov    0x4(%eax),%al
  800a45:	3c 01                	cmp    $0x1,%al
  800a47:	75 03                	jne    800a4c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a49:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4c:	ff 45 e0             	incl   -0x20(%ebp)
  800a4f:	a1 20 50 80 00       	mov    0x805020,%eax
  800a54:	8b 50 74             	mov    0x74(%eax),%edx
  800a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5a:	39 c2                	cmp    %eax,%edx
  800a5c:	77 cb                	ja     800a29 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a61:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a64:	74 14                	je     800a7a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800a66:	83 ec 04             	sub    $0x4,%esp
  800a69:	68 00 3e 80 00       	push   $0x803e00
  800a6e:	6a 44                	push   $0x44
  800a70:	68 a0 3d 80 00       	push   $0x803da0
  800a75:	e8 23 fe ff ff       	call   80089d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a7a:	90                   	nop
  800a7b:	c9                   	leave  
  800a7c:	c3                   	ret    

00800a7d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	8b 00                	mov    (%eax),%eax
  800a88:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8e:	89 0a                	mov    %ecx,(%edx)
  800a90:	8b 55 08             	mov    0x8(%ebp),%edx
  800a93:	88 d1                	mov    %dl,%cl
  800a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a98:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aa6:	75 2c                	jne    800ad4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800aa8:	a0 24 50 80 00       	mov    0x805024,%al
  800aad:	0f b6 c0             	movzbl %al,%eax
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab3:	8b 12                	mov    (%edx),%edx
  800ab5:	89 d1                	mov    %edx,%ecx
  800ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aba:	83 c2 08             	add    $0x8,%edx
  800abd:	83 ec 04             	sub    $0x4,%esp
  800ac0:	50                   	push   %eax
  800ac1:	51                   	push   %ecx
  800ac2:	52                   	push   %edx
  800ac3:	e8 28 15 00 00       	call   801ff0 <sys_cputs>
  800ac8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ace:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad7:	8b 40 04             	mov    0x4(%eax),%eax
  800ada:	8d 50 01             	lea    0x1(%eax),%edx
  800add:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae0:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ae3:	90                   	nop
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800af6:	00 00 00 
	b.cnt = 0;
  800af9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b00:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b0f:	50                   	push   %eax
  800b10:	68 7d 0a 80 00       	push   $0x800a7d
  800b15:	e8 11 02 00 00       	call   800d2b <vprintfmt>
  800b1a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b1d:	a0 24 50 80 00       	mov    0x805024,%al
  800b22:	0f b6 c0             	movzbl %al,%eax
  800b25:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b2b:	83 ec 04             	sub    $0x4,%esp
  800b2e:	50                   	push   %eax
  800b2f:	52                   	push   %edx
  800b30:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b36:	83 c0 08             	add    $0x8,%eax
  800b39:	50                   	push   %eax
  800b3a:	e8 b1 14 00 00       	call   801ff0 <sys_cputs>
  800b3f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b42:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800b49:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b57:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800b5e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	e8 73 ff ff ff       	call   800ae6 <vcprintf>
  800b73:	83 c4 10             	add    $0x10,%esp
  800b76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b84:	e8 15 16 00 00       	call   80219e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b89:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 f4             	pushl  -0xc(%ebp)
  800b98:	50                   	push   %eax
  800b99:	e8 48 ff ff ff       	call   800ae6 <vcprintf>
  800b9e:	83 c4 10             	add    $0x10,%esp
  800ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ba4:	e8 0f 16 00 00       	call   8021b8 <sys_enable_interrupt>
	return cnt;
  800ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	53                   	push   %ebx
  800bb2:	83 ec 14             	sub    $0x14,%esp
  800bb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc1:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bcc:	77 55                	ja     800c23 <printnum+0x75>
  800bce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd1:	72 05                	jb     800bd8 <printnum+0x2a>
  800bd3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bd6:	77 4b                	ja     800c23 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bdb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bde:	8b 45 18             	mov    0x18(%ebp),%eax
  800be1:	ba 00 00 00 00       	mov    $0x0,%edx
  800be6:	52                   	push   %edx
  800be7:	50                   	push   %eax
  800be8:	ff 75 f4             	pushl  -0xc(%ebp)
  800beb:	ff 75 f0             	pushl  -0x10(%ebp)
  800bee:	e8 b9 2b 00 00       	call   8037ac <__udivdi3>
  800bf3:	83 c4 10             	add    $0x10,%esp
  800bf6:	83 ec 04             	sub    $0x4,%esp
  800bf9:	ff 75 20             	pushl  0x20(%ebp)
  800bfc:	53                   	push   %ebx
  800bfd:	ff 75 18             	pushl  0x18(%ebp)
  800c00:	52                   	push   %edx
  800c01:	50                   	push   %eax
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 a1 ff ff ff       	call   800bae <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
  800c10:	eb 1a                	jmp    800c2c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	ff 75 20             	pushl  0x20(%ebp)
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c23:	ff 4d 1c             	decl   0x1c(%ebp)
  800c26:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c2a:	7f e6                	jg     800c12 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c2c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3a:	53                   	push   %ebx
  800c3b:	51                   	push   %ecx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	e8 79 2c 00 00       	call   8038bc <__umoddi3>
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	05 74 40 80 00       	add    $0x804074,%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	0f be c0             	movsbl %al,%eax
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	50                   	push   %eax
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
}
  800c5f:	90                   	nop
  800c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c68:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c6c:	7e 1c                	jle    800c8a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 50 08             	lea    0x8(%eax),%edx
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 10                	mov    %edx,(%eax)
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8b 00                	mov    (%eax),%eax
  800c80:	83 e8 08             	sub    $0x8,%eax
  800c83:	8b 50 04             	mov    0x4(%eax),%edx
  800c86:	8b 00                	mov    (%eax),%eax
  800c88:	eb 40                	jmp    800cca <getuint+0x65>
	else if (lflag)
  800c8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8e:	74 1e                	je     800cae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	8d 50 04             	lea    0x4(%eax),%edx
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	89 10                	mov    %edx,(%eax)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8b 00                	mov    (%eax),%eax
  800ca2:	83 e8 04             	sub    $0x4,%eax
  800ca5:	8b 00                	mov    (%eax),%eax
  800ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cac:	eb 1c                	jmp    800cca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8b 00                	mov    (%eax),%eax
  800cb3:	8d 50 04             	lea    0x4(%eax),%edx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 10                	mov    %edx,(%eax)
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	83 e8 04             	sub    $0x4,%eax
  800cc3:	8b 00                	mov    (%eax),%eax
  800cc5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd3:	7e 1c                	jle    800cf1 <getint+0x25>
		return va_arg(*ap, long long);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8b 00                	mov    (%eax),%eax
  800cda:	8d 50 08             	lea    0x8(%eax),%edx
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	89 10                	mov    %edx,(%eax)
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8b 00                	mov    (%eax),%eax
  800ce7:	83 e8 08             	sub    $0x8,%eax
  800cea:	8b 50 04             	mov    0x4(%eax),%edx
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	eb 38                	jmp    800d29 <getint+0x5d>
	else if (lflag)
  800cf1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf5:	74 1a                	je     800d11 <getint+0x45>
		return va_arg(*ap, long);
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8b 00                	mov    (%eax),%eax
  800cfc:	8d 50 04             	lea    0x4(%eax),%edx
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	89 10                	mov    %edx,(%eax)
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	83 e8 04             	sub    $0x4,%eax
  800d0c:	8b 00                	mov    (%eax),%eax
  800d0e:	99                   	cltd   
  800d0f:	eb 18                	jmp    800d29 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	8d 50 04             	lea    0x4(%eax),%edx
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 10                	mov    %edx,(%eax)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	83 e8 04             	sub    $0x4,%eax
  800d26:	8b 00                	mov    (%eax),%eax
  800d28:	99                   	cltd   
}
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d33:	eb 17                	jmp    800d4c <vprintfmt+0x21>
			if (ch == '\0')
  800d35:	85 db                	test   %ebx,%ebx
  800d37:	0f 84 af 03 00 00    	je     8010ec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	53                   	push   %ebx
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	ff d0                	call   *%eax
  800d49:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4f:	8d 50 01             	lea    0x1(%eax),%edx
  800d52:	89 55 10             	mov    %edx,0x10(%ebp)
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f b6 d8             	movzbl %al,%ebx
  800d5a:	83 fb 25             	cmp    $0x25,%ebx
  800d5d:	75 d6                	jne    800d35 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d5f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d63:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d6a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d78:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	8d 50 01             	lea    0x1(%eax),%edx
  800d85:	89 55 10             	mov    %edx,0x10(%ebp)
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	0f b6 d8             	movzbl %al,%ebx
  800d8d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d90:	83 f8 55             	cmp    $0x55,%eax
  800d93:	0f 87 2b 03 00 00    	ja     8010c4 <vprintfmt+0x399>
  800d99:	8b 04 85 98 40 80 00 	mov    0x804098(,%eax,4),%eax
  800da0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800da2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800da6:	eb d7                	jmp    800d7f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800da8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dac:	eb d1                	jmp    800d7f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800db5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800db8:	89 d0                	mov    %edx,%eax
  800dba:	c1 e0 02             	shl    $0x2,%eax
  800dbd:	01 d0                	add    %edx,%eax
  800dbf:	01 c0                	add    %eax,%eax
  800dc1:	01 d8                	add    %ebx,%eax
  800dc3:	83 e8 30             	sub    $0x30,%eax
  800dc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dd1:	83 fb 2f             	cmp    $0x2f,%ebx
  800dd4:	7e 3e                	jle    800e14 <vprintfmt+0xe9>
  800dd6:	83 fb 39             	cmp    $0x39,%ebx
  800dd9:	7f 39                	jg     800e14 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ddb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dde:	eb d5                	jmp    800db5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	83 c0 04             	add    $0x4,%eax
  800de6:	89 45 14             	mov    %eax,0x14(%ebp)
  800de9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dec:	83 e8 04             	sub    $0x4,%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800df4:	eb 1f                	jmp    800e15 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800df6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfa:	79 83                	jns    800d7f <vprintfmt+0x54>
				width = 0;
  800dfc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e03:	e9 77 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e08:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e0f:	e9 6b ff ff ff       	jmp    800d7f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e14:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e19:	0f 89 60 ff ff ff    	jns    800d7f <vprintfmt+0x54>
				width = precision, precision = -1;
  800e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e25:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e2c:	e9 4e ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e31:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e34:	e9 46 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e39:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3c:	83 c0 04             	add    $0x4,%eax
  800e3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e42:	8b 45 14             	mov    0x14(%ebp),%eax
  800e45:	83 e8 04             	sub    $0x4,%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	50                   	push   %eax
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	ff d0                	call   *%eax
  800e56:	83 c4 10             	add    $0x10,%esp
			break;
  800e59:	e9 89 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e61:	83 c0 04             	add    $0x4,%eax
  800e64:	89 45 14             	mov    %eax,0x14(%ebp)
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 e8 04             	sub    $0x4,%eax
  800e6d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e6f:	85 db                	test   %ebx,%ebx
  800e71:	79 02                	jns    800e75 <vprintfmt+0x14a>
				err = -err;
  800e73:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e75:	83 fb 64             	cmp    $0x64,%ebx
  800e78:	7f 0b                	jg     800e85 <vprintfmt+0x15a>
  800e7a:	8b 34 9d e0 3e 80 00 	mov    0x803ee0(,%ebx,4),%esi
  800e81:	85 f6                	test   %esi,%esi
  800e83:	75 19                	jne    800e9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e85:	53                   	push   %ebx
  800e86:	68 85 40 80 00       	push   $0x804085
  800e8b:	ff 75 0c             	pushl  0xc(%ebp)
  800e8e:	ff 75 08             	pushl  0x8(%ebp)
  800e91:	e8 5e 02 00 00       	call   8010f4 <printfmt>
  800e96:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e99:	e9 49 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e9e:	56                   	push   %esi
  800e9f:	68 8e 40 80 00       	push   $0x80408e
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	ff 75 08             	pushl  0x8(%ebp)
  800eaa:	e8 45 02 00 00       	call   8010f4 <printfmt>
  800eaf:	83 c4 10             	add    $0x10,%esp
			break;
  800eb2:	e9 30 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eba:	83 c0 04             	add    $0x4,%eax
  800ebd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec3:	83 e8 04             	sub    $0x4,%eax
  800ec6:	8b 30                	mov    (%eax),%esi
  800ec8:	85 f6                	test   %esi,%esi
  800eca:	75 05                	jne    800ed1 <vprintfmt+0x1a6>
				p = "(null)";
  800ecc:	be 91 40 80 00       	mov    $0x804091,%esi
			if (width > 0 && padc != '-')
  800ed1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed5:	7e 6d                	jle    800f44 <vprintfmt+0x219>
  800ed7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800edb:	74 67                	je     800f44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	50                   	push   %eax
  800ee4:	56                   	push   %esi
  800ee5:	e8 12 05 00 00       	call   8013fc <strnlen>
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ef0:	eb 16                	jmp    800f08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ef2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	50                   	push   %eax
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	ff d0                	call   *%eax
  800f02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f05:	ff 4d e4             	decl   -0x1c(%ebp)
  800f08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0c:	7f e4                	jg     800ef2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f0e:	eb 34                	jmp    800f44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f14:	74 1c                	je     800f32 <vprintfmt+0x207>
  800f16:	83 fb 1f             	cmp    $0x1f,%ebx
  800f19:	7e 05                	jle    800f20 <vprintfmt+0x1f5>
  800f1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800f1e:	7e 12                	jle    800f32 <vprintfmt+0x207>
					putch('?', putdat);
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	6a 3f                	push   $0x3f
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	ff d0                	call   *%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	eb 0f                	jmp    800f41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	ff 75 0c             	pushl  0xc(%ebp)
  800f38:	53                   	push   %ebx
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	ff d0                	call   *%eax
  800f3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f41:	ff 4d e4             	decl   -0x1c(%ebp)
  800f44:	89 f0                	mov    %esi,%eax
  800f46:	8d 70 01             	lea    0x1(%eax),%esi
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f be d8             	movsbl %al,%ebx
  800f4e:	85 db                	test   %ebx,%ebx
  800f50:	74 24                	je     800f76 <vprintfmt+0x24b>
  800f52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f56:	78 b8                	js     800f10 <vprintfmt+0x1e5>
  800f58:	ff 4d e0             	decl   -0x20(%ebp)
  800f5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f5f:	79 af                	jns    800f10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f61:	eb 13                	jmp    800f76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 0c             	pushl  0xc(%ebp)
  800f69:	6a 20                	push   $0x20
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	ff d0                	call   *%eax
  800f70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f73:	ff 4d e4             	decl   -0x1c(%ebp)
  800f76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7a:	7f e7                	jg     800f63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f7c:	e9 66 01 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f81:	83 ec 08             	sub    $0x8,%esp
  800f84:	ff 75 e8             	pushl  -0x18(%ebp)
  800f87:	8d 45 14             	lea    0x14(%ebp),%eax
  800f8a:	50                   	push   %eax
  800f8b:	e8 3c fd ff ff       	call   800ccc <getint>
  800f90:	83 c4 10             	add    $0x10,%esp
  800f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9f:	85 d2                	test   %edx,%edx
  800fa1:	79 23                	jns    800fc6 <vprintfmt+0x29b>
				putch('-', putdat);
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	6a 2d                	push   $0x2d
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	ff d0                	call   *%eax
  800fb0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb9:	f7 d8                	neg    %eax
  800fbb:	83 d2 00             	adc    $0x0,%edx
  800fbe:	f7 da                	neg    %edx
  800fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fc6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fcd:	e9 bc 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800fd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800fdb:	50                   	push   %eax
  800fdc:	e8 84 fc ff ff       	call   800c65 <getuint>
  800fe1:	83 c4 10             	add    $0x10,%esp
  800fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ff1:	e9 98 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ff6:	83 ec 08             	sub    $0x8,%esp
  800ff9:	ff 75 0c             	pushl  0xc(%ebp)
  800ffc:	6a 58                	push   $0x58
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	6a 58                	push   $0x58
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	ff d0                	call   *%eax
  801013:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801016:	83 ec 08             	sub    $0x8,%esp
  801019:	ff 75 0c             	pushl  0xc(%ebp)
  80101c:	6a 58                	push   $0x58
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	ff d0                	call   *%eax
  801023:	83 c4 10             	add    $0x10,%esp
			break;
  801026:	e9 bc 00 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	6a 30                	push   $0x30
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	ff d0                	call   *%eax
  801038:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80103b:	83 ec 08             	sub    $0x8,%esp
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	6a 78                	push   $0x78
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	ff d0                	call   *%eax
  801048:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80104b:	8b 45 14             	mov    0x14(%ebp),%eax
  80104e:	83 c0 04             	add    $0x4,%eax
  801051:	89 45 14             	mov    %eax,0x14(%ebp)
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	83 e8 04             	sub    $0x4,%eax
  80105a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801066:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80106d:	eb 1f                	jmp    80108e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80106f:	83 ec 08             	sub    $0x8,%esp
  801072:	ff 75 e8             	pushl  -0x18(%ebp)
  801075:	8d 45 14             	lea    0x14(%ebp),%eax
  801078:	50                   	push   %eax
  801079:	e8 e7 fb ff ff       	call   800c65 <getuint>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801084:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801087:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80108e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	52                   	push   %edx
  801099:	ff 75 e4             	pushl  -0x1c(%ebp)
  80109c:	50                   	push   %eax
  80109d:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 00 fb ff ff       	call   800bae <printnum>
  8010ae:	83 c4 20             	add    $0x20,%esp
			break;
  8010b1:	eb 34                	jmp    8010e7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010b3:	83 ec 08             	sub    $0x8,%esp
  8010b6:	ff 75 0c             	pushl  0xc(%ebp)
  8010b9:	53                   	push   %ebx
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	ff d0                	call   *%eax
  8010bf:	83 c4 10             	add    $0x10,%esp
			break;
  8010c2:	eb 23                	jmp    8010e7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010c4:	83 ec 08             	sub    $0x8,%esp
  8010c7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ca:	6a 25                	push   $0x25
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	ff d0                	call   *%eax
  8010d1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010d4:	ff 4d 10             	decl   0x10(%ebp)
  8010d7:	eb 03                	jmp    8010dc <vprintfmt+0x3b1>
  8010d9:	ff 4d 10             	decl   0x10(%ebp)
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	48                   	dec    %eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	3c 25                	cmp    $0x25,%al
  8010e4:	75 f3                	jne    8010d9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8010e6:	90                   	nop
		}
	}
  8010e7:	e9 47 fc ff ff       	jmp    800d33 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010ec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    

008010f4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8010fd:	83 c0 04             	add    $0x4,%eax
  801100:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	ff 75 f4             	pushl  -0xc(%ebp)
  801109:	50                   	push   %eax
  80110a:	ff 75 0c             	pushl  0xc(%ebp)
  80110d:	ff 75 08             	pushl  0x8(%ebp)
  801110:	e8 16 fc ff ff       	call   800d2b <vprintfmt>
  801115:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801118:	90                   	nop
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	8b 40 08             	mov    0x8(%eax),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	8b 10                	mov    (%eax),%edx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	8b 40 04             	mov    0x4(%eax),%eax
  801138:	39 c2                	cmp    %eax,%edx
  80113a:	73 12                	jae    80114e <sprintputch+0x33>
		*b->buf++ = ch;
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8b 00                	mov    (%eax),%eax
  801141:	8d 48 01             	lea    0x1(%eax),%ecx
  801144:	8b 55 0c             	mov    0xc(%ebp),%edx
  801147:	89 0a                	mov    %ecx,(%edx)
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	88 10                	mov    %dl,(%eax)
}
  80114e:	90                   	nop
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    

00801151 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8d 50 ff             	lea    -0x1(%eax),%edx
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	01 d0                	add    %edx,%eax
  801168:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801172:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801176:	74 06                	je     80117e <vsnprintf+0x2d>
  801178:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80117c:	7f 07                	jg     801185 <vsnprintf+0x34>
		return -E_INVAL;
  80117e:	b8 03 00 00 00       	mov    $0x3,%eax
  801183:	eb 20                	jmp    8011a5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801185:	ff 75 14             	pushl  0x14(%ebp)
  801188:	ff 75 10             	pushl  0x10(%ebp)
  80118b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80118e:	50                   	push   %eax
  80118f:	68 1b 11 80 00       	push   $0x80111b
  801194:	e8 92 fb ff ff       	call   800d2b <vprintfmt>
  801199:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80119c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    

008011a7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8011b0:	83 c0 04             	add    $0x4,%eax
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bc:	50                   	push   %eax
  8011bd:	ff 75 0c             	pushl  0xc(%ebp)
  8011c0:	ff 75 08             	pushl  0x8(%ebp)
  8011c3:	e8 89 ff ff ff       	call   801151 <vsnprintf>
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8011d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011dd:	74 13                	je     8011f2 <readline+0x1f>
		cprintf("%s", prompt);
  8011df:	83 ec 08             	sub    $0x8,%esp
  8011e2:	ff 75 08             	pushl  0x8(%ebp)
  8011e5:	68 f0 41 80 00       	push   $0x8041f0
  8011ea:	e8 62 f9 ff ff       	call   800b51 <cprintf>
  8011ef:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	6a 00                	push   $0x0
  8011fe:	e8 54 f5 ff ff       	call   800757 <iscons>
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801209:	e8 fb f4 ff ff       	call   800709 <getchar>
  80120e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801211:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801215:	79 22                	jns    801239 <readline+0x66>
			if (c != -E_EOF)
  801217:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80121b:	0f 84 ad 00 00 00    	je     8012ce <readline+0xfb>
				cprintf("read error: %e\n", c);
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	ff 75 ec             	pushl  -0x14(%ebp)
  801227:	68 f3 41 80 00       	push   $0x8041f3
  80122c:	e8 20 f9 ff ff       	call   800b51 <cprintf>
  801231:	83 c4 10             	add    $0x10,%esp
			return;
  801234:	e9 95 00 00 00       	jmp    8012ce <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801239:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80123d:	7e 34                	jle    801273 <readline+0xa0>
  80123f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801246:	7f 2b                	jg     801273 <readline+0xa0>
			if (echoing)
  801248:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80124c:	74 0e                	je     80125c <readline+0x89>
				cputchar(c);
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	ff 75 ec             	pushl  -0x14(%ebp)
  801254:	e8 68 f4 ff ff       	call   8006c1 <cputchar>
  801259:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80125c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125f:	8d 50 01             	lea    0x1(%eax),%edx
  801262:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801265:	89 c2                	mov    %eax,%edx
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	01 d0                	add    %edx,%eax
  80126c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80126f:	88 10                	mov    %dl,(%eax)
  801271:	eb 56                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801273:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801277:	75 1f                	jne    801298 <readline+0xc5>
  801279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80127d:	7e 19                	jle    801298 <readline+0xc5>
			if (echoing)
  80127f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801283:	74 0e                	je     801293 <readline+0xc0>
				cputchar(c);
  801285:	83 ec 0c             	sub    $0xc,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	e8 31 f4 ff ff       	call   8006c1 <cputchar>
  801290:	83 c4 10             	add    $0x10,%esp

			i--;
  801293:	ff 4d f4             	decl   -0xc(%ebp)
  801296:	eb 31                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801298:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80129c:	74 0a                	je     8012a8 <readline+0xd5>
  80129e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012a2:	0f 85 61 ff ff ff    	jne    801209 <readline+0x36>
			if (echoing)
  8012a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ac:	74 0e                	je     8012bc <readline+0xe9>
				cputchar(c);
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b4:	e8 08 f4 ff ff       	call   8006c1 <cputchar>
  8012b9:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	01 d0                	add    %edx,%eax
  8012c4:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8012c7:	eb 06                	jmp    8012cf <readline+0xfc>
		}
	}
  8012c9:	e9 3b ff ff ff       	jmp    801209 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8012ce:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8012d7:	e8 c2 0e 00 00       	call   80219e <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8012dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e0:	74 13                	je     8012f5 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	ff 75 08             	pushl  0x8(%ebp)
  8012e8:	68 f0 41 80 00       	push   $0x8041f0
  8012ed:	e8 5f f8 ff ff       	call   800b51 <cprintf>
  8012f2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	6a 00                	push   $0x0
  801301:	e8 51 f4 ff ff       	call   800757 <iscons>
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130c:	e8 f8 f3 ff ff       	call   800709 <getchar>
  801311:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801314:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801318:	79 23                	jns    80133d <atomic_readline+0x6c>
			if (c != -E_EOF)
  80131a:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80131e:	74 13                	je     801333 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	ff 75 ec             	pushl  -0x14(%ebp)
  801326:	68 f3 41 80 00       	push   $0x8041f3
  80132b:	e8 21 f8 ff ff       	call   800b51 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801333:	e8 80 0e 00 00       	call   8021b8 <sys_enable_interrupt>
			return;
  801338:	e9 9a 00 00 00       	jmp    8013d7 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801341:	7e 34                	jle    801377 <atomic_readline+0xa6>
  801343:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134a:	7f 2b                	jg     801377 <atomic_readline+0xa6>
			if (echoing)
  80134c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801350:	74 0e                	je     801360 <atomic_readline+0x8f>
				cputchar(c);
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	ff 75 ec             	pushl  -0x14(%ebp)
  801358:	e8 64 f3 ff ff       	call   8006c1 <cputchar>
  80135d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801363:	8d 50 01             	lea    0x1(%eax),%edx
  801366:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801369:	89 c2                	mov    %eax,%edx
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801373:	88 10                	mov    %dl,(%eax)
  801375:	eb 5b                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801377:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137b:	75 1f                	jne    80139c <atomic_readline+0xcb>
  80137d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801381:	7e 19                	jle    80139c <atomic_readline+0xcb>
			if (echoing)
  801383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801387:	74 0e                	je     801397 <atomic_readline+0xc6>
				cputchar(c);
  801389:	83 ec 0c             	sub    $0xc,%esp
  80138c:	ff 75 ec             	pushl  -0x14(%ebp)
  80138f:	e8 2d f3 ff ff       	call   8006c1 <cputchar>
  801394:	83 c4 10             	add    $0x10,%esp
			i--;
  801397:	ff 4d f4             	decl   -0xc(%ebp)
  80139a:	eb 36                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80139c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a0:	74 0a                	je     8013ac <atomic_readline+0xdb>
  8013a2:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a6:	0f 85 60 ff ff ff    	jne    80130c <atomic_readline+0x3b>
			if (echoing)
  8013ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b0:	74 0e                	je     8013c0 <atomic_readline+0xef>
				cputchar(c);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b8:	e8 04 f3 ff ff       	call   8006c1 <cputchar>
  8013bd:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	01 d0                	add    %edx,%eax
  8013c8:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8013cb:	e8 e8 0d 00 00       	call   8021b8 <sys_enable_interrupt>
			return;
  8013d0:	eb 05                	jmp    8013d7 <atomic_readline+0x106>
		}
	}
  8013d2:	e9 35 ff ff ff       	jmp    80130c <atomic_readline+0x3b>
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e6:	eb 06                	jmp    8013ee <strlen+0x15>
		n++;
  8013e8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013eb:	ff 45 08             	incl   0x8(%ebp)
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	84 c0                	test   %al,%al
  8013f5:	75 f1                	jne    8013e8 <strlen+0xf>
		n++;
	return n;
  8013f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801409:	eb 09                	jmp    801414 <strnlen+0x18>
		n++;
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80140e:	ff 45 08             	incl   0x8(%ebp)
  801411:	ff 4d 0c             	decl   0xc(%ebp)
  801414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801418:	74 09                	je     801423 <strnlen+0x27>
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	84 c0                	test   %al,%al
  801421:	75 e8                	jne    80140b <strnlen+0xf>
		n++;
	return n;
  801423:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801434:	90                   	nop
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8d 50 01             	lea    0x1(%eax),%edx
  80143b:	89 55 08             	mov    %edx,0x8(%ebp)
  80143e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801441:	8d 4a 01             	lea    0x1(%edx),%ecx
  801444:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801447:	8a 12                	mov    (%edx),%dl
  801449:	88 10                	mov    %dl,(%eax)
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	84 c0                	test   %al,%al
  80144f:	75 e4                	jne    801435 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801451:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801462:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801469:	eb 1f                	jmp    80148a <strncpy+0x34>
		*dst++ = *src;
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8d 50 01             	lea    0x1(%eax),%edx
  801471:	89 55 08             	mov    %edx,0x8(%ebp)
  801474:	8b 55 0c             	mov    0xc(%ebp),%edx
  801477:	8a 12                	mov    (%edx),%dl
  801479:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	84 c0                	test   %al,%al
  801482:	74 03                	je     801487 <strncpy+0x31>
			src++;
  801484:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801487:	ff 45 fc             	incl   -0x4(%ebp)
  80148a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801490:	72 d9                	jb     80146b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801492:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a7:	74 30                	je     8014d9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014a9:	eb 16                	jmp    8014c1 <strlcpy+0x2a>
			*dst++ = *src++;
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8d 50 01             	lea    0x1(%eax),%edx
  8014b1:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014bd:	8a 12                	mov    (%edx),%dl
  8014bf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014c1:	ff 4d 10             	decl   0x10(%ebp)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	74 09                	je     8014d3 <strlcpy+0x3c>
  8014ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	84 c0                	test   %al,%al
  8014d1:	75 d8                	jne    8014ab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014df:	29 c2                	sub    %eax,%edx
  8014e1:	89 d0                	mov    %edx,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014e8:	eb 06                	jmp    8014f0 <strcmp+0xb>
		p++, q++;
  8014ea:	ff 45 08             	incl   0x8(%ebp)
  8014ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	84 c0                	test   %al,%al
  8014f7:	74 0e                	je     801507 <strcmp+0x22>
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	8a 10                	mov    (%eax),%dl
  8014fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	38 c2                	cmp    %al,%dl
  801505:	74 e3                	je     8014ea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	0f b6 d0             	movzbl %al,%edx
  80150f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	0f b6 c0             	movzbl %al,%eax
  801517:	29 c2                	sub    %eax,%edx
  801519:	89 d0                	mov    %edx,%eax
}
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801520:	eb 09                	jmp    80152b <strncmp+0xe>
		n--, p++, q++;
  801522:	ff 4d 10             	decl   0x10(%ebp)
  801525:	ff 45 08             	incl   0x8(%ebp)
  801528:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80152b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152f:	74 17                	je     801548 <strncmp+0x2b>
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	84 c0                	test   %al,%al
  801538:	74 0e                	je     801548 <strncmp+0x2b>
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 10                	mov    (%eax),%dl
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	38 c2                	cmp    %al,%dl
  801546:	74 da                	je     801522 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801548:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80154c:	75 07                	jne    801555 <strncmp+0x38>
		return 0;
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
  801553:	eb 14                	jmp    801569 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	0f b6 d0             	movzbl %al,%edx
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	0f b6 c0             	movzbl %al,%eax
  801565:	29 c2                	sub    %eax,%edx
  801567:	89 d0                	mov    %edx,%eax
}
  801569:	5d                   	pop    %ebp
  80156a:	c3                   	ret    

0080156b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801577:	eb 12                	jmp    80158b <strchr+0x20>
		if (*s == c)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801581:	75 05                	jne    801588 <strchr+0x1d>
			return (char *) s;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	eb 11                	jmp    801599 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801588:	ff 45 08             	incl   0x8(%ebp)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	84 c0                	test   %al,%al
  801592:	75 e5                	jne    801579 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015a7:	eb 0d                	jmp    8015b6 <strfind+0x1b>
		if (*s == c)
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015b1:	74 0e                	je     8015c1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015b3:	ff 45 08             	incl   0x8(%ebp)
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 00                	mov    (%eax),%al
  8015bb:	84 c0                	test   %al,%al
  8015bd:	75 ea                	jne    8015a9 <strfind+0xe>
  8015bf:	eb 01                	jmp    8015c2 <strfind+0x27>
		if (*s == c)
			break;
  8015c1:	90                   	nop
	return (char *) s;
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015d9:	eb 0e                	jmp    8015e9 <memset+0x22>
		*p++ = c;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015de:	8d 50 01             	lea    0x1(%eax),%edx
  8015e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015e9:	ff 4d f8             	decl   -0x8(%ebp)
  8015ec:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015f0:	79 e9                	jns    8015db <memset+0x14>
		*p++ = c;

	return v;
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801609:	eb 16                	jmp    801621 <memcpy+0x2a>
		*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801645:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80164b:	73 50                	jae    80169d <memmove+0x6a>
  80164d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801650:	8b 45 10             	mov    0x10(%ebp),%eax
  801653:	01 d0                	add    %edx,%eax
  801655:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801658:	76 43                	jbe    80169d <memmove+0x6a>
		s += n;
  80165a:	8b 45 10             	mov    0x10(%ebp),%eax
  80165d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801660:	8b 45 10             	mov    0x10(%ebp),%eax
  801663:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801666:	eb 10                	jmp    801678 <memmove+0x45>
			*--d = *--s;
  801668:	ff 4d f8             	decl   -0x8(%ebp)
  80166b:	ff 4d fc             	decl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	8a 10                	mov    (%eax),%dl
  801673:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801676:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801678:	8b 45 10             	mov    0x10(%ebp),%eax
  80167b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80167e:	89 55 10             	mov    %edx,0x10(%ebp)
  801681:	85 c0                	test   %eax,%eax
  801683:	75 e3                	jne    801668 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801685:	eb 23                	jmp    8016aa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801687:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168a:	8d 50 01             	lea    0x1(%eax),%edx
  80168d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801690:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801693:	8d 4a 01             	lea    0x1(%edx),%ecx
  801696:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801699:	8a 12                	mov    (%edx),%dl
  80169b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	75 dd                	jne    801687 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016be:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016c1:	eb 2a                	jmp    8016ed <memcmp+0x3e>
		if (*s1 != *s2)
  8016c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c6:	8a 10                	mov    (%eax),%dl
  8016c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	38 c2                	cmp    %al,%dl
  8016cf:	74 16                	je     8016e7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f b6 d0             	movzbl %al,%edx
  8016d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	0f b6 c0             	movzbl %al,%eax
  8016e1:	29 c2                	sub    %eax,%edx
  8016e3:	89 d0                	mov    %edx,%eax
  8016e5:	eb 18                	jmp    8016ff <memcmp+0x50>
		s1++, s2++;
  8016e7:	ff 45 fc             	incl   -0x4(%ebp)
  8016ea:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	75 c9                	jne    8016c3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801707:	8b 55 08             	mov    0x8(%ebp),%edx
  80170a:	8b 45 10             	mov    0x10(%ebp),%eax
  80170d:	01 d0                	add    %edx,%eax
  80170f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801712:	eb 15                	jmp    801729 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	8a 00                	mov    (%eax),%al
  801719:	0f b6 d0             	movzbl %al,%edx
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	0f b6 c0             	movzbl %al,%eax
  801722:	39 c2                	cmp    %eax,%edx
  801724:	74 0d                	je     801733 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801726:	ff 45 08             	incl   0x8(%ebp)
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80172f:	72 e3                	jb     801714 <memfind+0x13>
  801731:	eb 01                	jmp    801734 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801733:	90                   	nop
	return (void *) s;
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80173f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801746:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174d:	eb 03                	jmp    801752 <strtol+0x19>
		s++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	3c 20                	cmp    $0x20,%al
  801759:	74 f4                	je     80174f <strtol+0x16>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	3c 09                	cmp    $0x9,%al
  801762:	74 eb                	je     80174f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 2b                	cmp    $0x2b,%al
  80176b:	75 05                	jne    801772 <strtol+0x39>
		s++;
  80176d:	ff 45 08             	incl   0x8(%ebp)
  801770:	eb 13                	jmp    801785 <strtol+0x4c>
	else if (*s == '-')
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8a 00                	mov    (%eax),%al
  801777:	3c 2d                	cmp    $0x2d,%al
  801779:	75 0a                	jne    801785 <strtol+0x4c>
		s++, neg = 1;
  80177b:	ff 45 08             	incl   0x8(%ebp)
  80177e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801785:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801789:	74 06                	je     801791 <strtol+0x58>
  80178b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80178f:	75 20                	jne    8017b1 <strtol+0x78>
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	3c 30                	cmp    $0x30,%al
  801798:	75 17                	jne    8017b1 <strtol+0x78>
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	40                   	inc    %eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	3c 78                	cmp    $0x78,%al
  8017a2:	75 0d                	jne    8017b1 <strtol+0x78>
		s += 2, base = 16;
  8017a4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017a8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017af:	eb 28                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b5:	75 15                	jne    8017cc <strtol+0x93>
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8a 00                	mov    (%eax),%al
  8017bc:	3c 30                	cmp    $0x30,%al
  8017be:	75 0c                	jne    8017cc <strtol+0x93>
		s++, base = 8;
  8017c0:	ff 45 08             	incl   0x8(%ebp)
  8017c3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017ca:	eb 0d                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0)
  8017cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d0:	75 07                	jne    8017d9 <strtol+0xa0>
		base = 10;
  8017d2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8a 00                	mov    (%eax),%al
  8017de:	3c 2f                	cmp    $0x2f,%al
  8017e0:	7e 19                	jle    8017fb <strtol+0xc2>
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	3c 39                	cmp    $0x39,%al
  8017e9:	7f 10                	jg     8017fb <strtol+0xc2>
			dig = *s - '0';
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	0f be c0             	movsbl %al,%eax
  8017f3:	83 e8 30             	sub    $0x30,%eax
  8017f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f9:	eb 42                	jmp    80183d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8a 00                	mov    (%eax),%al
  801800:	3c 60                	cmp    $0x60,%al
  801802:	7e 19                	jle    80181d <strtol+0xe4>
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8a 00                	mov    (%eax),%al
  801809:	3c 7a                	cmp    $0x7a,%al
  80180b:	7f 10                	jg     80181d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	0f be c0             	movsbl %al,%eax
  801815:	83 e8 57             	sub    $0x57,%eax
  801818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80181b:	eb 20                	jmp    80183d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	3c 40                	cmp    $0x40,%al
  801824:	7e 39                	jle    80185f <strtol+0x126>
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	3c 5a                	cmp    $0x5a,%al
  80182d:	7f 30                	jg     80185f <strtol+0x126>
			dig = *s - 'A' + 10;
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	0f be c0             	movsbl %al,%eax
  801837:	83 e8 37             	sub    $0x37,%eax
  80183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801840:	3b 45 10             	cmp    0x10(%ebp),%eax
  801843:	7d 19                	jge    80185e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801845:	ff 45 08             	incl   0x8(%ebp)
  801848:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80184f:	89 c2                	mov    %eax,%edx
  801851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801854:	01 d0                	add    %edx,%eax
  801856:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801859:	e9 7b ff ff ff       	jmp    8017d9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80185e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80185f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801863:	74 08                	je     80186d <strtol+0x134>
		*endptr = (char *) s;
  801865:	8b 45 0c             	mov    0xc(%ebp),%eax
  801868:	8b 55 08             	mov    0x8(%ebp),%edx
  80186b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80186d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801871:	74 07                	je     80187a <strtol+0x141>
  801873:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801876:	f7 d8                	neg    %eax
  801878:	eb 03                	jmp    80187d <strtol+0x144>
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <ltostr>:

void
ltostr(long value, char *str)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801885:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80188c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801893:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801897:	79 13                	jns    8018ac <ltostr+0x2d>
	{
		neg = 1;
  801899:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018a6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018a9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018b4:	99                   	cltd   
  8018b5:	f7 f9                	idiv   %ecx
  8018b7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018bd:	8d 50 01             	lea    0x1(%eax),%edx
  8018c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018c3:	89 c2                	mov    %eax,%edx
  8018c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c8:	01 d0                	add    %edx,%eax
  8018ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018cd:	83 c2 30             	add    $0x30,%edx
  8018d0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018da:	f7 e9                	imul   %ecx
  8018dc:	c1 fa 02             	sar    $0x2,%edx
  8018df:	89 c8                	mov    %ecx,%eax
  8018e1:	c1 f8 1f             	sar    $0x1f,%eax
  8018e4:	29 c2                	sub    %eax,%edx
  8018e6:	89 d0                	mov    %edx,%eax
  8018e8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018f3:	f7 e9                	imul   %ecx
  8018f5:	c1 fa 02             	sar    $0x2,%edx
  8018f8:	89 c8                	mov    %ecx,%eax
  8018fa:	c1 f8 1f             	sar    $0x1f,%eax
  8018fd:	29 c2                	sub    %eax,%edx
  8018ff:	89 d0                	mov    %edx,%eax
  801901:	c1 e0 02             	shl    $0x2,%eax
  801904:	01 d0                	add    %edx,%eax
  801906:	01 c0                	add    %eax,%eax
  801908:	29 c1                	sub    %eax,%ecx
  80190a:	89 ca                	mov    %ecx,%edx
  80190c:	85 d2                	test   %edx,%edx
  80190e:	75 9c                	jne    8018ac <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801917:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191a:	48                   	dec    %eax
  80191b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80191e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801922:	74 3d                	je     801961 <ltostr+0xe2>
		start = 1 ;
  801924:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80192b:	eb 34                	jmp    801961 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80192d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801930:	8b 45 0c             	mov    0xc(%ebp),%eax
  801933:	01 d0                	add    %edx,%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80193a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801940:	01 c2                	add    %eax,%edx
  801942:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801945:	8b 45 0c             	mov    0xc(%ebp),%eax
  801948:	01 c8                	add    %ecx,%eax
  80194a:	8a 00                	mov    (%eax),%al
  80194c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80194e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	01 c2                	add    %eax,%edx
  801956:	8a 45 eb             	mov    -0x15(%ebp),%al
  801959:	88 02                	mov    %al,(%edx)
		start++ ;
  80195b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80195e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801964:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801967:	7c c4                	jl     80192d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801969:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80196c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196f:	01 d0                	add    %edx,%eax
  801971:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801974:	90                   	nop
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80197d:	ff 75 08             	pushl  0x8(%ebp)
  801980:	e8 54 fa ff ff       	call   8013d9 <strlen>
  801985:	83 c4 04             	add    $0x4,%esp
  801988:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80198b:	ff 75 0c             	pushl  0xc(%ebp)
  80198e:	e8 46 fa ff ff       	call   8013d9 <strlen>
  801993:	83 c4 04             	add    $0x4,%esp
  801996:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801999:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019a7:	eb 17                	jmp    8019c0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8019af:	01 c2                	add    %eax,%edx
  8019b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	01 c8                	add    %ecx,%eax
  8019b9:	8a 00                	mov    (%eax),%al
  8019bb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019bd:	ff 45 fc             	incl   -0x4(%ebp)
  8019c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019c6:	7c e1                	jl     8019a9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019d6:	eb 1f                	jmp    8019f7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019db:	8d 50 01             	lea    0x1(%eax),%edx
  8019de:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019e1:	89 c2                	mov    %eax,%edx
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	01 c2                	add    %eax,%edx
  8019e8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ee:	01 c8                	add    %ecx,%eax
  8019f0:	8a 00                	mov    (%eax),%al
  8019f2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019f4:	ff 45 f8             	incl   -0x8(%ebp)
  8019f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019fd:	7c d9                	jl     8019d8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a02:	8b 45 10             	mov    0x10(%ebp),%eax
  801a05:	01 d0                	add    %edx,%eax
  801a07:	c6 00 00             	movb   $0x0,(%eax)
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a10:	8b 45 14             	mov    0x14(%ebp),%eax
  801a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a19:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1c:	8b 00                	mov    (%eax),%eax
  801a1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a25:	8b 45 10             	mov    0x10(%ebp),%eax
  801a28:	01 d0                	add    %edx,%eax
  801a2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a30:	eb 0c                	jmp    801a3e <strsplit+0x31>
			*string++ = 0;
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	8d 50 01             	lea    0x1(%eax),%edx
  801a38:	89 55 08             	mov    %edx,0x8(%ebp)
  801a3b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	84 c0                	test   %al,%al
  801a45:	74 18                	je     801a5f <strsplit+0x52>
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8a 00                	mov    (%eax),%al
  801a4c:	0f be c0             	movsbl %al,%eax
  801a4f:	50                   	push   %eax
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	e8 13 fb ff ff       	call   80156b <strchr>
  801a58:	83 c4 08             	add    $0x8,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	75 d3                	jne    801a32 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8a 00                	mov    (%eax),%al
  801a64:	84 c0                	test   %al,%al
  801a66:	74 5a                	je     801ac2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a68:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6b:	8b 00                	mov    (%eax),%eax
  801a6d:	83 f8 0f             	cmp    $0xf,%eax
  801a70:	75 07                	jne    801a79 <strsplit+0x6c>
		{
			return 0;
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
  801a77:	eb 66                	jmp    801adf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a79:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7c:	8b 00                	mov    (%eax),%eax
  801a7e:	8d 48 01             	lea    0x1(%eax),%ecx
  801a81:	8b 55 14             	mov    0x14(%ebp),%edx
  801a84:	89 0a                	mov    %ecx,(%edx)
  801a86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a90:	01 c2                	add    %eax,%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a97:	eb 03                	jmp    801a9c <strsplit+0x8f>
			string++;
  801a99:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8a 00                	mov    (%eax),%al
  801aa1:	84 c0                	test   %al,%al
  801aa3:	74 8b                	je     801a30 <strsplit+0x23>
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	8a 00                	mov    (%eax),%al
  801aaa:	0f be c0             	movsbl %al,%eax
  801aad:	50                   	push   %eax
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	e8 b5 fa ff ff       	call   80156b <strchr>
  801ab6:	83 c4 08             	add    $0x8,%esp
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	74 dc                	je     801a99 <strsplit+0x8c>
			string++;
	}
  801abd:	e9 6e ff ff ff       	jmp    801a30 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ac2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac6:	8b 00                	mov    (%eax),%eax
  801ac8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801acf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad2:	01 d0                	add    %edx,%eax
  801ad4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ada:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ae7:	a1 04 50 80 00       	mov    0x805004,%eax
  801aec:	85 c0                	test   %eax,%eax
  801aee:	74 1f                	je     801b0f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801af0:	e8 1d 00 00 00       	call   801b12 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	68 04 42 80 00       	push   $0x804204
  801afd:	e8 4f f0 ff ff       	call   800b51 <cprintf>
  801b02:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b05:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b0c:	00 00 00 
	}
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801b18:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b1f:	00 00 00 
  801b22:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b29:	00 00 00 
  801b2c:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b33:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801b36:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b3d:	00 00 00 
  801b40:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b47:	00 00 00 
  801b4a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b51:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801b54:	c7 05 20 51 80 00 00 	movl   $0x20000,0x805120
  801b5b:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801b5e:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b68:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b6d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b72:	a3 50 50 80 00       	mov    %eax,0x805050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801b77:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b7e:	a1 20 51 80 00       	mov    0x805120,%eax
  801b83:	c1 e0 04             	shl    $0x4,%eax
  801b86:	89 c2                	mov    %eax,%edx
  801b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8b:	01 d0                	add    %edx,%eax
  801b8d:	48                   	dec    %eax
  801b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b94:	ba 00 00 00 00       	mov    $0x0,%edx
  801b99:	f7 75 f0             	divl   -0x10(%ebp)
  801b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b9f:	29 d0                	sub    %edx,%eax
  801ba1:	89 c2                	mov    %eax,%edx
  801ba3:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801baa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bb2:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bb7:	83 ec 04             	sub    $0x4,%esp
  801bba:	6a 06                	push   $0x6
  801bbc:	52                   	push   %edx
  801bbd:	50                   	push   %eax
  801bbe:	e8 71 05 00 00       	call   802134 <sys_allocate_chunk>
  801bc3:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bc6:	a1 20 51 80 00       	mov    0x805120,%eax
  801bcb:	83 ec 0c             	sub    $0xc,%esp
  801bce:	50                   	push   %eax
  801bcf:	e8 e6 0b 00 00       	call   8027ba <initialize_MemBlocksList>
  801bd4:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801bd7:	a1 48 51 80 00       	mov    0x805148,%eax
  801bdc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  801bdf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801be3:	75 14                	jne    801bf9 <initialize_dyn_block_system+0xe7>
  801be5:	83 ec 04             	sub    $0x4,%esp
  801be8:	68 29 42 80 00       	push   $0x804229
  801bed:	6a 2b                	push   $0x2b
  801bef:	68 47 42 80 00       	push   $0x804247
  801bf4:	e8 a4 ec ff ff       	call   80089d <_panic>
  801bf9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bfc:	8b 00                	mov    (%eax),%eax
  801bfe:	85 c0                	test   %eax,%eax
  801c00:	74 10                	je     801c12 <initialize_dyn_block_system+0x100>
  801c02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c05:	8b 00                	mov    (%eax),%eax
  801c07:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c0a:	8b 52 04             	mov    0x4(%edx),%edx
  801c0d:	89 50 04             	mov    %edx,0x4(%eax)
  801c10:	eb 0b                	jmp    801c1d <initialize_dyn_block_system+0x10b>
  801c12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c15:	8b 40 04             	mov    0x4(%eax),%eax
  801c18:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c20:	8b 40 04             	mov    0x4(%eax),%eax
  801c23:	85 c0                	test   %eax,%eax
  801c25:	74 0f                	je     801c36 <initialize_dyn_block_system+0x124>
  801c27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c2a:	8b 40 04             	mov    0x4(%eax),%eax
  801c2d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c30:	8b 12                	mov    (%edx),%edx
  801c32:	89 10                	mov    %edx,(%eax)
  801c34:	eb 0a                	jmp    801c40 <initialize_dyn_block_system+0x12e>
  801c36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c39:	8b 00                	mov    (%eax),%eax
  801c3b:	a3 48 51 80 00       	mov    %eax,0x805148
  801c40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c53:	a1 54 51 80 00       	mov    0x805154,%eax
  801c58:	48                   	dec    %eax
  801c59:	a3 54 51 80 00       	mov    %eax,0x805154
		block_node->sva = USER_HEAP_START ;
  801c5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c61:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801c68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c6b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801c72:	83 ec 0c             	sub    $0xc,%esp
  801c75:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c78:	e8 d2 13 00 00       	call   80304f <insert_sorted_with_merge_freeList>
  801c7d:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801c80:	90                   	nop
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c89:	e8 53 fe ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801c8e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801c92:	75 07                	jne    801c9b <malloc+0x18>
  801c94:	b8 00 00 00 00       	mov    $0x0,%eax
  801c99:	eb 61                	jmp    801cfc <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801c9b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  801ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca8:	01 d0                	add    %edx,%eax
  801caa:	48                   	dec    %eax
  801cab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb1:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb6:	f7 75 f4             	divl   -0xc(%ebp)
  801cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbc:	29 d0                	sub    %edx,%eax
  801cbe:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801cc1:	e8 3c 08 00 00       	call   802502 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cc6:	85 c0                	test   %eax,%eax
  801cc8:	74 2d                	je     801cf7 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801cca:	83 ec 0c             	sub    $0xc,%esp
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	e8 3e 0f 00 00       	call   802c13 <alloc_block_FF>
  801cd5:	83 c4 10             	add    $0x10,%esp
  801cd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801cdb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801cdf:	74 16                	je     801cf7 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  801ce1:	83 ec 0c             	sub    $0xc,%esp
  801ce4:	ff 75 ec             	pushl  -0x14(%ebp)
  801ce7:	e8 48 0c 00 00       	call   802934 <insert_sorted_allocList>
  801cec:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801cef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801cf2:	8b 40 08             	mov    0x8(%eax),%eax
  801cf5:	eb 05                	jmp    801cfc <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801cf7:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d12:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	83 ec 08             	sub    $0x8,%esp
  801d1b:	50                   	push   %eax
  801d1c:	68 40 50 80 00       	push   $0x805040
  801d21:	e8 71 0b 00 00       	call   802897 <find_block>
  801d26:	83 c4 10             	add    $0x10,%esp
  801d29:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2f:	8b 50 0c             	mov    0xc(%eax),%edx
  801d32:	8b 45 08             	mov    0x8(%ebp),%eax
  801d35:	83 ec 08             	sub    $0x8,%esp
  801d38:	52                   	push   %edx
  801d39:	50                   	push   %eax
  801d3a:	e8 bd 03 00 00       	call   8020fc <sys_free_user_mem>
  801d3f:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801d42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d46:	75 14                	jne    801d5c <free+0x5e>
  801d48:	83 ec 04             	sub    $0x4,%esp
  801d4b:	68 29 42 80 00       	push   $0x804229
  801d50:	6a 71                	push   $0x71
  801d52:	68 47 42 80 00       	push   $0x804247
  801d57:	e8 41 eb ff ff       	call   80089d <_panic>
  801d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d5f:	8b 00                	mov    (%eax),%eax
  801d61:	85 c0                	test   %eax,%eax
  801d63:	74 10                	je     801d75 <free+0x77>
  801d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d68:	8b 00                	mov    (%eax),%eax
  801d6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d6d:	8b 52 04             	mov    0x4(%edx),%edx
  801d70:	89 50 04             	mov    %edx,0x4(%eax)
  801d73:	eb 0b                	jmp    801d80 <free+0x82>
  801d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d78:	8b 40 04             	mov    0x4(%eax),%eax
  801d7b:	a3 44 50 80 00       	mov    %eax,0x805044
  801d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d83:	8b 40 04             	mov    0x4(%eax),%eax
  801d86:	85 c0                	test   %eax,%eax
  801d88:	74 0f                	je     801d99 <free+0x9b>
  801d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8d:	8b 40 04             	mov    0x4(%eax),%eax
  801d90:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d93:	8b 12                	mov    (%edx),%edx
  801d95:	89 10                	mov    %edx,(%eax)
  801d97:	eb 0a                	jmp    801da3 <free+0xa5>
  801d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9c:	8b 00                	mov    (%eax),%eax
  801d9e:	a3 40 50 80 00       	mov    %eax,0x805040
  801da3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801dac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801daf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801db6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801dbb:	48                   	dec    %eax
  801dbc:	a3 4c 50 80 00       	mov    %eax,0x80504c
		insert_sorted_with_merge_freeList(elementForEach);
  801dc1:	83 ec 0c             	sub    $0xc,%esp
  801dc4:	ff 75 f0             	pushl  -0x10(%ebp)
  801dc7:	e8 83 12 00 00       	call   80304f <insert_sorted_with_merge_freeList>
  801dcc:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801dcf:	90                   	nop
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	83 ec 28             	sub    $0x28,%esp
  801dd8:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddb:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dde:	e8 fe fc ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801de3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801de7:	75 0a                	jne    801df3 <smalloc+0x21>
  801de9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dee:	e9 86 00 00 00       	jmp    801e79 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801df3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e00:	01 d0                	add    %edx,%eax
  801e02:	48                   	dec    %eax
  801e03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e09:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0e:	f7 75 f4             	divl   -0xc(%ebp)
  801e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e14:	29 d0                	sub    %edx,%eax
  801e16:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801e19:	e8 e4 06 00 00       	call   802502 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e1e:	85 c0                	test   %eax,%eax
  801e20:	74 52                	je     801e74 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801e22:	83 ec 0c             	sub    $0xc,%esp
  801e25:	ff 75 0c             	pushl  0xc(%ebp)
  801e28:	e8 e6 0d 00 00       	call   802c13 <alloc_block_FF>
  801e2d:	83 c4 10             	add    $0x10,%esp
  801e30:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801e33:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e37:	75 07                	jne    801e40 <smalloc+0x6e>
			return NULL ;
  801e39:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3e:	eb 39                	jmp    801e79 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801e40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e43:	8b 40 08             	mov    0x8(%eax),%eax
  801e46:	89 c2                	mov    %eax,%edx
  801e48:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801e4c:	52                   	push   %edx
  801e4d:	50                   	push   %eax
  801e4e:	ff 75 0c             	pushl  0xc(%ebp)
  801e51:	ff 75 08             	pushl  0x8(%ebp)
  801e54:	e8 2e 04 00 00       	call   802287 <sys_createSharedObject>
  801e59:	83 c4 10             	add    $0x10,%esp
  801e5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801e5f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801e63:	79 07                	jns    801e6c <smalloc+0x9a>
			return (void*)NULL ;
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6a:	eb 0d                	jmp    801e79 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e6f:	8b 40 08             	mov    0x8(%eax),%eax
  801e72:	eb 05                	jmp    801e79 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801e74:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e81:	e8 5b fc ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e86:	83 ec 08             	sub    $0x8,%esp
  801e89:	ff 75 0c             	pushl  0xc(%ebp)
  801e8c:	ff 75 08             	pushl  0x8(%ebp)
  801e8f:	e8 1d 04 00 00       	call   8022b1 <sys_getSizeOfSharedObject>
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801e9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e9e:	75 0a                	jne    801eaa <sget+0x2f>
			return NULL ;
  801ea0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea5:	e9 83 00 00 00       	jmp    801f2d <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801eaa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb7:	01 d0                	add    %edx,%eax
  801eb9:	48                   	dec    %eax
  801eba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ebd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ec0:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec5:	f7 75 f0             	divl   -0x10(%ebp)
  801ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecb:	29 d0                	sub    %edx,%eax
  801ecd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801ed0:	e8 2d 06 00 00       	call   802502 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	74 4f                	je     801f28 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edc:	83 ec 0c             	sub    $0xc,%esp
  801edf:	50                   	push   %eax
  801ee0:	e8 2e 0d 00 00       	call   802c13 <alloc_block_FF>
  801ee5:	83 c4 10             	add    $0x10,%esp
  801ee8:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801eeb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801eef:	75 07                	jne    801ef8 <sget+0x7d>
					return (void*)NULL ;
  801ef1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef6:	eb 35                	jmp    801f2d <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801ef8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801efb:	8b 40 08             	mov    0x8(%eax),%eax
  801efe:	83 ec 04             	sub    $0x4,%esp
  801f01:	50                   	push   %eax
  801f02:	ff 75 0c             	pushl  0xc(%ebp)
  801f05:	ff 75 08             	pushl  0x8(%ebp)
  801f08:	e8 c1 03 00 00       	call   8022ce <sys_getSharedObject>
  801f0d:	83 c4 10             	add    $0x10,%esp
  801f10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801f13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f17:	79 07                	jns    801f20 <sget+0xa5>
				return (void*)NULL ;
  801f19:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1e:	eb 0d                	jmp    801f2d <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801f20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f23:	8b 40 08             	mov    0x8(%eax),%eax
  801f26:	eb 05                	jmp    801f2d <sget+0xb2>


		}
	return (void*)NULL ;
  801f28:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
  801f32:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f35:	e8 a7 fb ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f3a:	83 ec 04             	sub    $0x4,%esp
  801f3d:	68 54 42 80 00       	push   $0x804254
  801f42:	68 f9 00 00 00       	push   $0xf9
  801f47:	68 47 42 80 00       	push   $0x804247
  801f4c:	e8 4c e9 ff ff       	call   80089d <_panic>

00801f51 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f57:	83 ec 04             	sub    $0x4,%esp
  801f5a:	68 7c 42 80 00       	push   $0x80427c
  801f5f:	68 0d 01 00 00       	push   $0x10d
  801f64:	68 47 42 80 00       	push   $0x804247
  801f69:	e8 2f e9 ff ff       	call   80089d <_panic>

00801f6e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f74:	83 ec 04             	sub    $0x4,%esp
  801f77:	68 a0 42 80 00       	push   $0x8042a0
  801f7c:	68 18 01 00 00       	push   $0x118
  801f81:	68 47 42 80 00       	push   $0x804247
  801f86:	e8 12 e9 ff ff       	call   80089d <_panic>

00801f8b <shrink>:

}
void shrink(uint32 newSize)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f91:	83 ec 04             	sub    $0x4,%esp
  801f94:	68 a0 42 80 00       	push   $0x8042a0
  801f99:	68 1d 01 00 00       	push   $0x11d
  801f9e:	68 47 42 80 00       	push   $0x804247
  801fa3:	e8 f5 e8 ff ff       	call   80089d <_panic>

00801fa8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801fae:	83 ec 04             	sub    $0x4,%esp
  801fb1:	68 a0 42 80 00       	push   $0x8042a0
  801fb6:	68 22 01 00 00       	push   $0x122
  801fbb:	68 47 42 80 00       	push   $0x804247
  801fc0:	e8 d8 e8 ff ff       	call   80089d <_panic>

00801fc5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	57                   	push   %edi
  801fc9:	56                   	push   %esi
  801fca:	53                   	push   %ebx
  801fcb:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fd7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fda:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fdd:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fe0:	cd 30                	int    $0x30
  801fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fe8:	83 c4 10             	add    $0x10,%esp
  801feb:	5b                   	pop    %ebx
  801fec:	5e                   	pop    %esi
  801fed:	5f                   	pop    %edi
  801fee:	5d                   	pop    %ebp
  801fef:	c3                   	ret    

00801ff0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	83 ec 04             	sub    $0x4,%esp
  801ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ffc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802000:	8b 45 08             	mov    0x8(%ebp),%eax
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	52                   	push   %edx
  802008:	ff 75 0c             	pushl  0xc(%ebp)
  80200b:	50                   	push   %eax
  80200c:	6a 00                	push   $0x0
  80200e:	e8 b2 ff ff ff       	call   801fc5 <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
}
  802016:	90                   	nop
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <sys_cgetc>:

int
sys_cgetc(void)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 01                	push   $0x1
  802028:	e8 98 ff ff ff       	call   801fc5 <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802035:	8b 55 0c             	mov    0xc(%ebp),%edx
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	52                   	push   %edx
  802042:	50                   	push   %eax
  802043:	6a 05                	push   $0x5
  802045:	e8 7b ff ff ff       	call   801fc5 <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	56                   	push   %esi
  802053:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802054:	8b 75 18             	mov    0x18(%ebp),%esi
  802057:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80205a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80205d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802060:	8b 45 08             	mov    0x8(%ebp),%eax
  802063:	56                   	push   %esi
  802064:	53                   	push   %ebx
  802065:	51                   	push   %ecx
  802066:	52                   	push   %edx
  802067:	50                   	push   %eax
  802068:	6a 06                	push   $0x6
  80206a:	e8 56 ff ff ff       	call   801fc5 <syscall>
  80206f:	83 c4 18             	add    $0x18,%esp
}
  802072:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802075:	5b                   	pop    %ebx
  802076:	5e                   	pop    %esi
  802077:	5d                   	pop    %ebp
  802078:	c3                   	ret    

00802079 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80207c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207f:	8b 45 08             	mov    0x8(%ebp),%eax
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	52                   	push   %edx
  802089:	50                   	push   %eax
  80208a:	6a 07                	push   $0x7
  80208c:	e8 34 ff ff ff       	call   801fc5 <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 00                	push   $0x0
  80209f:	ff 75 0c             	pushl  0xc(%ebp)
  8020a2:	ff 75 08             	pushl  0x8(%ebp)
  8020a5:	6a 08                	push   $0x8
  8020a7:	e8 19 ff ff ff       	call   801fc5 <syscall>
  8020ac:	83 c4 18             	add    $0x18,%esp
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 00                	push   $0x0
  8020b8:	6a 00                	push   $0x0
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 09                	push   $0x9
  8020c0:	e8 00 ff ff ff       	call   801fc5 <syscall>
  8020c5:	83 c4 18             	add    $0x18,%esp
}
  8020c8:	c9                   	leave  
  8020c9:	c3                   	ret    

008020ca <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 0a                	push   $0xa
  8020d9:	e8 e7 fe ff ff       	call   801fc5 <syscall>
  8020de:	83 c4 18             	add    $0x18,%esp
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 0b                	push   $0xb
  8020f2:	e8 ce fe ff ff       	call   801fc5 <syscall>
  8020f7:	83 c4 18             	add    $0x18,%esp
}
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	ff 75 0c             	pushl  0xc(%ebp)
  802108:	ff 75 08             	pushl  0x8(%ebp)
  80210b:	6a 0f                	push   $0xf
  80210d:	e8 b3 fe ff ff       	call   801fc5 <syscall>
  802112:	83 c4 18             	add    $0x18,%esp
	return;
  802115:	90                   	nop
}
  802116:	c9                   	leave  
  802117:	c3                   	ret    

00802118 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80211b:	6a 00                	push   $0x0
  80211d:	6a 00                	push   $0x0
  80211f:	6a 00                	push   $0x0
  802121:	ff 75 0c             	pushl  0xc(%ebp)
  802124:	ff 75 08             	pushl  0x8(%ebp)
  802127:	6a 10                	push   $0x10
  802129:	e8 97 fe ff ff       	call   801fc5 <syscall>
  80212e:	83 c4 18             	add    $0x18,%esp
	return ;
  802131:	90                   	nop
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	ff 75 10             	pushl  0x10(%ebp)
  80213e:	ff 75 0c             	pushl  0xc(%ebp)
  802141:	ff 75 08             	pushl  0x8(%ebp)
  802144:	6a 11                	push   $0x11
  802146:	e8 7a fe ff ff       	call   801fc5 <syscall>
  80214b:	83 c4 18             	add    $0x18,%esp
	return ;
  80214e:	90                   	nop
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 0c                	push   $0xc
  802160:	e8 60 fe ff ff       	call   801fc5 <syscall>
  802165:	83 c4 18             	add    $0x18,%esp
}
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	ff 75 08             	pushl  0x8(%ebp)
  802178:	6a 0d                	push   $0xd
  80217a:	e8 46 fe ff ff       	call   801fc5 <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 0e                	push   $0xe
  802193:	e8 2d fe ff ff       	call   801fc5 <syscall>
  802198:	83 c4 18             	add    $0x18,%esp
}
  80219b:	90                   	nop
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 13                	push   $0x13
  8021ad:	e8 13 fe ff ff       	call   801fc5 <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
}
  8021b5:	90                   	nop
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 14                	push   $0x14
  8021c7:	e8 f9 fd ff ff       	call   801fc5 <syscall>
  8021cc:	83 c4 18             	add    $0x18,%esp
}
  8021cf:	90                   	nop
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 04             	sub    $0x4,%esp
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021de:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	6a 00                	push   $0x0
  8021ea:	50                   	push   %eax
  8021eb:	6a 15                	push   $0x15
  8021ed:	e8 d3 fd ff ff       	call   801fc5 <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
}
  8021f5:	90                   	nop
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 16                	push   $0x16
  802207:	e8 b9 fd ff ff       	call   801fc5 <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	90                   	nop
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	ff 75 0c             	pushl  0xc(%ebp)
  802221:	50                   	push   %eax
  802222:	6a 17                	push   $0x17
  802224:	e8 9c fd ff ff       	call   801fc5 <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802231:	8b 55 0c             	mov    0xc(%ebp),%edx
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	52                   	push   %edx
  80223e:	50                   	push   %eax
  80223f:	6a 1a                	push   $0x1a
  802241:	e8 7f fd ff ff       	call   801fc5 <syscall>
  802246:	83 c4 18             	add    $0x18,%esp
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80224e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	52                   	push   %edx
  80225b:	50                   	push   %eax
  80225c:	6a 18                	push   $0x18
  80225e:	e8 62 fd ff ff       	call   801fc5 <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
}
  802266:	90                   	nop
  802267:	c9                   	leave  
  802268:	c3                   	ret    

00802269 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802269:	55                   	push   %ebp
  80226a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80226c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	6a 00                	push   $0x0
  802274:	6a 00                	push   $0x0
  802276:	6a 00                	push   $0x0
  802278:	52                   	push   %edx
  802279:	50                   	push   %eax
  80227a:	6a 19                	push   $0x19
  80227c:	e8 44 fd ff ff       	call   801fc5 <syscall>
  802281:	83 c4 18             	add    $0x18,%esp
}
  802284:	90                   	nop
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
  80228a:	83 ec 04             	sub    $0x4,%esp
  80228d:	8b 45 10             	mov    0x10(%ebp),%eax
  802290:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802293:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802296:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	6a 00                	push   $0x0
  80229f:	51                   	push   %ecx
  8022a0:	52                   	push   %edx
  8022a1:	ff 75 0c             	pushl  0xc(%ebp)
  8022a4:	50                   	push   %eax
  8022a5:	6a 1b                	push   $0x1b
  8022a7:	e8 19 fd ff ff       	call   801fc5 <syscall>
  8022ac:	83 c4 18             	add    $0x18,%esp
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8022b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	6a 00                	push   $0x0
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	52                   	push   %edx
  8022c1:	50                   	push   %eax
  8022c2:	6a 1c                	push   $0x1c
  8022c4:	e8 fc fc ff ff       	call   801fc5 <syscall>
  8022c9:	83 c4 18             	add    $0x18,%esp
}
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8022d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	51                   	push   %ecx
  8022df:	52                   	push   %edx
  8022e0:	50                   	push   %eax
  8022e1:	6a 1d                	push   $0x1d
  8022e3:	e8 dd fc ff ff       	call   801fc5 <syscall>
  8022e8:	83 c4 18             	add    $0x18,%esp
}
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 00                	push   $0x0
  8022fc:	52                   	push   %edx
  8022fd:	50                   	push   %eax
  8022fe:	6a 1e                	push   $0x1e
  802300:	e8 c0 fc ff ff       	call   801fc5 <syscall>
  802305:	83 c4 18             	add    $0x18,%esp
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	6a 00                	push   $0x0
  802317:	6a 1f                	push   $0x1f
  802319:	e8 a7 fc ff ff       	call   801fc5 <syscall>
  80231e:	83 c4 18             	add    $0x18,%esp
}
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	6a 00                	push   $0x0
  80232b:	ff 75 14             	pushl  0x14(%ebp)
  80232e:	ff 75 10             	pushl  0x10(%ebp)
  802331:	ff 75 0c             	pushl  0xc(%ebp)
  802334:	50                   	push   %eax
  802335:	6a 20                	push   $0x20
  802337:	e8 89 fc ff ff       	call   801fc5 <syscall>
  80233c:	83 c4 18             	add    $0x18,%esp
}
  80233f:	c9                   	leave  
  802340:	c3                   	ret    

00802341 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	50                   	push   %eax
  802350:	6a 21                	push   $0x21
  802352:	e8 6e fc ff ff       	call   801fc5 <syscall>
  802357:	83 c4 18             	add    $0x18,%esp
}
  80235a:	90                   	nop
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	6a 00                	push   $0x0
  802365:	6a 00                	push   $0x0
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	50                   	push   %eax
  80236c:	6a 22                	push   $0x22
  80236e:	e8 52 fc ff ff       	call   801fc5 <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 02                	push   $0x2
  802387:	e8 39 fc ff ff       	call   801fc5 <syscall>
  80238c:	83 c4 18             	add    $0x18,%esp
}
  80238f:	c9                   	leave  
  802390:	c3                   	ret    

00802391 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 03                	push   $0x3
  8023a0:	e8 20 fc ff ff       	call   801fc5 <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 04                	push   $0x4
  8023b9:	e8 07 fc ff ff       	call   801fc5 <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <sys_exit_env>:


void sys_exit_env(void)
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 23                	push   $0x23
  8023d2:	e8 ee fb ff ff       	call   801fc5 <syscall>
  8023d7:	83 c4 18             	add    $0x18,%esp
}
  8023da:	90                   	nop
  8023db:	c9                   	leave  
  8023dc:	c3                   	ret    

008023dd <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8023dd:	55                   	push   %ebp
  8023de:	89 e5                	mov    %esp,%ebp
  8023e0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023e3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023e6:	8d 50 04             	lea    0x4(%eax),%edx
  8023e9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	52                   	push   %edx
  8023f3:	50                   	push   %eax
  8023f4:	6a 24                	push   $0x24
  8023f6:	e8 ca fb ff ff       	call   801fc5 <syscall>
  8023fb:	83 c4 18             	add    $0x18,%esp
	return result;
  8023fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802401:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802404:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802407:	89 01                	mov    %eax,(%ecx)
  802409:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	c9                   	leave  
  802410:	c2 04 00             	ret    $0x4

00802413 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802413:	55                   	push   %ebp
  802414:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802416:	6a 00                	push   $0x0
  802418:	6a 00                	push   $0x0
  80241a:	ff 75 10             	pushl  0x10(%ebp)
  80241d:	ff 75 0c             	pushl  0xc(%ebp)
  802420:	ff 75 08             	pushl  0x8(%ebp)
  802423:	6a 12                	push   $0x12
  802425:	e8 9b fb ff ff       	call   801fc5 <syscall>
  80242a:	83 c4 18             	add    $0x18,%esp
	return ;
  80242d:	90                   	nop
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <sys_rcr2>:
uint32 sys_rcr2()
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802433:	6a 00                	push   $0x0
  802435:	6a 00                	push   $0x0
  802437:	6a 00                	push   $0x0
  802439:	6a 00                	push   $0x0
  80243b:	6a 00                	push   $0x0
  80243d:	6a 25                	push   $0x25
  80243f:	e8 81 fb ff ff       	call   801fc5 <syscall>
  802444:	83 c4 18             	add    $0x18,%esp
}
  802447:	c9                   	leave  
  802448:	c3                   	ret    

00802449 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802449:	55                   	push   %ebp
  80244a:	89 e5                	mov    %esp,%ebp
  80244c:	83 ec 04             	sub    $0x4,%esp
  80244f:	8b 45 08             	mov    0x8(%ebp),%eax
  802452:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802455:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802459:	6a 00                	push   $0x0
  80245b:	6a 00                	push   $0x0
  80245d:	6a 00                	push   $0x0
  80245f:	6a 00                	push   $0x0
  802461:	50                   	push   %eax
  802462:	6a 26                	push   $0x26
  802464:	e8 5c fb ff ff       	call   801fc5 <syscall>
  802469:	83 c4 18             	add    $0x18,%esp
	return ;
  80246c:	90                   	nop
}
  80246d:	c9                   	leave  
  80246e:	c3                   	ret    

0080246f <rsttst>:
void rsttst()
{
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 28                	push   $0x28
  80247e:	e8 42 fb ff ff       	call   801fc5 <syscall>
  802483:	83 c4 18             	add    $0x18,%esp
	return ;
  802486:	90                   	nop
}
  802487:	c9                   	leave  
  802488:	c3                   	ret    

00802489 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802489:	55                   	push   %ebp
  80248a:	89 e5                	mov    %esp,%ebp
  80248c:	83 ec 04             	sub    $0x4,%esp
  80248f:	8b 45 14             	mov    0x14(%ebp),%eax
  802492:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802495:	8b 55 18             	mov    0x18(%ebp),%edx
  802498:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80249c:	52                   	push   %edx
  80249d:	50                   	push   %eax
  80249e:	ff 75 10             	pushl  0x10(%ebp)
  8024a1:	ff 75 0c             	pushl  0xc(%ebp)
  8024a4:	ff 75 08             	pushl  0x8(%ebp)
  8024a7:	6a 27                	push   $0x27
  8024a9:	e8 17 fb ff ff       	call   801fc5 <syscall>
  8024ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8024b1:	90                   	nop
}
  8024b2:	c9                   	leave  
  8024b3:	c3                   	ret    

008024b4 <chktst>:
void chktst(uint32 n)
{
  8024b4:	55                   	push   %ebp
  8024b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	ff 75 08             	pushl  0x8(%ebp)
  8024c2:	6a 29                	push   $0x29
  8024c4:	e8 fc fa ff ff       	call   801fc5 <syscall>
  8024c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024cc:	90                   	nop
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <inctst>:

void inctst()
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 2a                	push   $0x2a
  8024de:	e8 e2 fa ff ff       	call   801fc5 <syscall>
  8024e3:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e6:	90                   	nop
}
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <gettst>:
uint32 gettst()
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024ec:	6a 00                	push   $0x0
  8024ee:	6a 00                	push   $0x0
  8024f0:	6a 00                	push   $0x0
  8024f2:	6a 00                	push   $0x0
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 2b                	push   $0x2b
  8024f8:	e8 c8 fa ff ff       	call   801fc5 <syscall>
  8024fd:	83 c4 18             	add    $0x18,%esp
}
  802500:	c9                   	leave  
  802501:	c3                   	ret    

00802502 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802502:	55                   	push   %ebp
  802503:	89 e5                	mov    %esp,%ebp
  802505:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802508:	6a 00                	push   $0x0
  80250a:	6a 00                	push   $0x0
  80250c:	6a 00                	push   $0x0
  80250e:	6a 00                	push   $0x0
  802510:	6a 00                	push   $0x0
  802512:	6a 2c                	push   $0x2c
  802514:	e8 ac fa ff ff       	call   801fc5 <syscall>
  802519:	83 c4 18             	add    $0x18,%esp
  80251c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80251f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802523:	75 07                	jne    80252c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802525:	b8 01 00 00 00       	mov    $0x1,%eax
  80252a:	eb 05                	jmp    802531 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80252c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802531:	c9                   	leave  
  802532:	c3                   	ret    

00802533 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802533:	55                   	push   %ebp
  802534:	89 e5                	mov    %esp,%ebp
  802536:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	6a 2c                	push   $0x2c
  802545:	e8 7b fa ff ff       	call   801fc5 <syscall>
  80254a:	83 c4 18             	add    $0x18,%esp
  80254d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802550:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802554:	75 07                	jne    80255d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802556:	b8 01 00 00 00       	mov    $0x1,%eax
  80255b:	eb 05                	jmp    802562 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80255d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802562:	c9                   	leave  
  802563:	c3                   	ret    

00802564 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80256a:	6a 00                	push   $0x0
  80256c:	6a 00                	push   $0x0
  80256e:	6a 00                	push   $0x0
  802570:	6a 00                	push   $0x0
  802572:	6a 00                	push   $0x0
  802574:	6a 2c                	push   $0x2c
  802576:	e8 4a fa ff ff       	call   801fc5 <syscall>
  80257b:	83 c4 18             	add    $0x18,%esp
  80257e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802581:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802585:	75 07                	jne    80258e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802587:	b8 01 00 00 00       	mov    $0x1,%eax
  80258c:	eb 05                	jmp    802593 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80258e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	6a 2c                	push   $0x2c
  8025a7:	e8 19 fa ff ff       	call   801fc5 <syscall>
  8025ac:	83 c4 18             	add    $0x18,%esp
  8025af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8025b2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8025b6:	75 07                	jne    8025bf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8025b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bd:	eb 05                	jmp    8025c4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8025bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025c4:	c9                   	leave  
  8025c5:	c3                   	ret    

008025c6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8025c9:	6a 00                	push   $0x0
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	ff 75 08             	pushl  0x8(%ebp)
  8025d4:	6a 2d                	push   $0x2d
  8025d6:	e8 ea f9 ff ff       	call   801fc5 <syscall>
  8025db:	83 c4 18             	add    $0x18,%esp
	return ;
  8025de:	90                   	nop
}
  8025df:	c9                   	leave  
  8025e0:	c3                   	ret    

008025e1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025e1:	55                   	push   %ebp
  8025e2:	89 e5                	mov    %esp,%ebp
  8025e4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f1:	6a 00                	push   $0x0
  8025f3:	53                   	push   %ebx
  8025f4:	51                   	push   %ecx
  8025f5:	52                   	push   %edx
  8025f6:	50                   	push   %eax
  8025f7:	6a 2e                	push   $0x2e
  8025f9:	e8 c7 f9 ff ff       	call   801fc5 <syscall>
  8025fe:	83 c4 18             	add    $0x18,%esp
}
  802601:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802609:	8b 55 0c             	mov    0xc(%ebp),%edx
  80260c:	8b 45 08             	mov    0x8(%ebp),%eax
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 00                	push   $0x0
  802615:	52                   	push   %edx
  802616:	50                   	push   %eax
  802617:	6a 2f                	push   $0x2f
  802619:	e8 a7 f9 ff ff       	call   801fc5 <syscall>
  80261e:	83 c4 18             	add    $0x18,%esp
}
  802621:	c9                   	leave  
  802622:	c3                   	ret    

00802623 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802623:	55                   	push   %ebp
  802624:	89 e5                	mov    %esp,%ebp
  802626:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802629:	83 ec 0c             	sub    $0xc,%esp
  80262c:	68 b0 42 80 00       	push   $0x8042b0
  802631:	e8 1b e5 ff ff       	call   800b51 <cprintf>
  802636:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802639:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802640:	83 ec 0c             	sub    $0xc,%esp
  802643:	68 dc 42 80 00       	push   $0x8042dc
  802648:	e8 04 e5 ff ff       	call   800b51 <cprintf>
  80264d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802650:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802654:	a1 38 51 80 00       	mov    0x805138,%eax
  802659:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265c:	eb 56                	jmp    8026b4 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80265e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802662:	74 1c                	je     802680 <print_mem_block_lists+0x5d>
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 50 08             	mov    0x8(%eax),%edx
  80266a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266d:	8b 48 08             	mov    0x8(%eax),%ecx
  802670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802673:	8b 40 0c             	mov    0xc(%eax),%eax
  802676:	01 c8                	add    %ecx,%eax
  802678:	39 c2                	cmp    %eax,%edx
  80267a:	73 04                	jae    802680 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80267c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 50 08             	mov    0x8(%eax),%edx
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 40 0c             	mov    0xc(%eax),%eax
  80268c:	01 c2                	add    %eax,%edx
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 40 08             	mov    0x8(%eax),%eax
  802694:	83 ec 04             	sub    $0x4,%esp
  802697:	52                   	push   %edx
  802698:	50                   	push   %eax
  802699:	68 f1 42 80 00       	push   $0x8042f1
  80269e:	e8 ae e4 ff ff       	call   800b51 <cprintf>
  8026a3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8026ac:	a1 40 51 80 00       	mov    0x805140,%eax
  8026b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026b8:	74 07                	je     8026c1 <print_mem_block_lists+0x9e>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	eb 05                	jmp    8026c6 <print_mem_block_lists+0xa3>
  8026c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c6:	a3 40 51 80 00       	mov    %eax,0x805140
  8026cb:	a1 40 51 80 00       	mov    0x805140,%eax
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	75 8a                	jne    80265e <print_mem_block_lists+0x3b>
  8026d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d8:	75 84                	jne    80265e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8026da:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026de:	75 10                	jne    8026f0 <print_mem_block_lists+0xcd>
  8026e0:	83 ec 0c             	sub    $0xc,%esp
  8026e3:	68 00 43 80 00       	push   $0x804300
  8026e8:	e8 64 e4 ff ff       	call   800b51 <cprintf>
  8026ed:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8026f0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8026f7:	83 ec 0c             	sub    $0xc,%esp
  8026fa:	68 24 43 80 00       	push   $0x804324
  8026ff:	e8 4d e4 ff ff       	call   800b51 <cprintf>
  802704:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802707:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80270b:	a1 40 50 80 00       	mov    0x805040,%eax
  802710:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802713:	eb 56                	jmp    80276b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802715:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802719:	74 1c                	je     802737 <print_mem_block_lists+0x114>
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 50 08             	mov    0x8(%eax),%edx
  802721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802724:	8b 48 08             	mov    0x8(%eax),%ecx
  802727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272a:	8b 40 0c             	mov    0xc(%eax),%eax
  80272d:	01 c8                	add    %ecx,%eax
  80272f:	39 c2                	cmp    %eax,%edx
  802731:	73 04                	jae    802737 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802733:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 50 08             	mov    0x8(%eax),%edx
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 40 0c             	mov    0xc(%eax),%eax
  802743:	01 c2                	add    %eax,%edx
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 40 08             	mov    0x8(%eax),%eax
  80274b:	83 ec 04             	sub    $0x4,%esp
  80274e:	52                   	push   %edx
  80274f:	50                   	push   %eax
  802750:	68 f1 42 80 00       	push   $0x8042f1
  802755:	e8 f7 e3 ff ff       	call   800b51 <cprintf>
  80275a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802763:	a1 48 50 80 00       	mov    0x805048,%eax
  802768:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80276b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80276f:	74 07                	je     802778 <print_mem_block_lists+0x155>
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 00                	mov    (%eax),%eax
  802776:	eb 05                	jmp    80277d <print_mem_block_lists+0x15a>
  802778:	b8 00 00 00 00       	mov    $0x0,%eax
  80277d:	a3 48 50 80 00       	mov    %eax,0x805048
  802782:	a1 48 50 80 00       	mov    0x805048,%eax
  802787:	85 c0                	test   %eax,%eax
  802789:	75 8a                	jne    802715 <print_mem_block_lists+0xf2>
  80278b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278f:	75 84                	jne    802715 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802791:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802795:	75 10                	jne    8027a7 <print_mem_block_lists+0x184>
  802797:	83 ec 0c             	sub    $0xc,%esp
  80279a:	68 3c 43 80 00       	push   $0x80433c
  80279f:	e8 ad e3 ff ff       	call   800b51 <cprintf>
  8027a4:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8027a7:	83 ec 0c             	sub    $0xc,%esp
  8027aa:	68 b0 42 80 00       	push   $0x8042b0
  8027af:	e8 9d e3 ff ff       	call   800b51 <cprintf>
  8027b4:	83 c4 10             	add    $0x10,%esp

}
  8027b7:	90                   	nop
  8027b8:	c9                   	leave  
  8027b9:	c3                   	ret    

008027ba <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8027ba:	55                   	push   %ebp
  8027bb:	89 e5                	mov    %esp,%ebp
  8027bd:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8027c0:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8027c7:	00 00 00 
  8027ca:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8027d1:	00 00 00 
  8027d4:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8027db:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8027de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8027e5:	e9 9e 00 00 00       	jmp    802888 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  8027ea:	a1 50 50 80 00       	mov    0x805050,%eax
  8027ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f2:	c1 e2 04             	shl    $0x4,%edx
  8027f5:	01 d0                	add    %edx,%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	75 14                	jne    80280f <initialize_MemBlocksList+0x55>
  8027fb:	83 ec 04             	sub    $0x4,%esp
  8027fe:	68 64 43 80 00       	push   $0x804364
  802803:	6a 43                	push   $0x43
  802805:	68 87 43 80 00       	push   $0x804387
  80280a:	e8 8e e0 ff ff       	call   80089d <_panic>
  80280f:	a1 50 50 80 00       	mov    0x805050,%eax
  802814:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802817:	c1 e2 04             	shl    $0x4,%edx
  80281a:	01 d0                	add    %edx,%eax
  80281c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802822:	89 10                	mov    %edx,(%eax)
  802824:	8b 00                	mov    (%eax),%eax
  802826:	85 c0                	test   %eax,%eax
  802828:	74 18                	je     802842 <initialize_MemBlocksList+0x88>
  80282a:	a1 48 51 80 00       	mov    0x805148,%eax
  80282f:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802835:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802838:	c1 e1 04             	shl    $0x4,%ecx
  80283b:	01 ca                	add    %ecx,%edx
  80283d:	89 50 04             	mov    %edx,0x4(%eax)
  802840:	eb 12                	jmp    802854 <initialize_MemBlocksList+0x9a>
  802842:	a1 50 50 80 00       	mov    0x805050,%eax
  802847:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284a:	c1 e2 04             	shl    $0x4,%edx
  80284d:	01 d0                	add    %edx,%eax
  80284f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802854:	a1 50 50 80 00       	mov    0x805050,%eax
  802859:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80285c:	c1 e2 04             	shl    $0x4,%edx
  80285f:	01 d0                	add    %edx,%eax
  802861:	a3 48 51 80 00       	mov    %eax,0x805148
  802866:	a1 50 50 80 00       	mov    0x805050,%eax
  80286b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80286e:	c1 e2 04             	shl    $0x4,%edx
  802871:	01 d0                	add    %edx,%eax
  802873:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80287a:	a1 54 51 80 00       	mov    0x805154,%eax
  80287f:	40                   	inc    %eax
  802880:	a3 54 51 80 00       	mov    %eax,0x805154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802885:	ff 45 f4             	incl   -0xc(%ebp)
  802888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80288e:	0f 82 56 ff ff ff    	jb     8027ea <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802894:	90                   	nop
  802895:	c9                   	leave  
  802896:	c3                   	ret    

00802897 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802897:	55                   	push   %ebp
  802898:	89 e5                	mov    %esp,%ebp
  80289a:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80289d:	a1 38 51 80 00       	mov    0x805138,%eax
  8028a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028a5:	eb 18                	jmp    8028bf <find_block+0x28>
	{
		if (ele->sva==va)
  8028a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028aa:	8b 40 08             	mov    0x8(%eax),%eax
  8028ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8028b0:	75 05                	jne    8028b7 <find_block+0x20>
			return ele;
  8028b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028b5:	eb 7b                	jmp    802932 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8028b7:	a1 40 51 80 00       	mov    0x805140,%eax
  8028bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028bf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028c3:	74 07                	je     8028cc <find_block+0x35>
  8028c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028c8:	8b 00                	mov    (%eax),%eax
  8028ca:	eb 05                	jmp    8028d1 <find_block+0x3a>
  8028cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8028d1:	a3 40 51 80 00       	mov    %eax,0x805140
  8028d6:	a1 40 51 80 00       	mov    0x805140,%eax
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	75 c8                	jne    8028a7 <find_block+0x10>
  8028df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8028e3:	75 c2                	jne    8028a7 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8028e5:	a1 40 50 80 00       	mov    0x805040,%eax
  8028ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8028ed:	eb 18                	jmp    802907 <find_block+0x70>
	{
		if (ele->sva==va)
  8028ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028f2:	8b 40 08             	mov    0x8(%eax),%eax
  8028f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8028f8:	75 05                	jne    8028ff <find_block+0x68>
					return ele;
  8028fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8028fd:	eb 33                	jmp    802932 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8028ff:	a1 48 50 80 00       	mov    0x805048,%eax
  802904:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802907:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80290b:	74 07                	je     802914 <find_block+0x7d>
  80290d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802910:	8b 00                	mov    (%eax),%eax
  802912:	eb 05                	jmp    802919 <find_block+0x82>
  802914:	b8 00 00 00 00       	mov    $0x0,%eax
  802919:	a3 48 50 80 00       	mov    %eax,0x805048
  80291e:	a1 48 50 80 00       	mov    0x805048,%eax
  802923:	85 c0                	test   %eax,%eax
  802925:	75 c8                	jne    8028ef <find_block+0x58>
  802927:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80292b:	75 c2                	jne    8028ef <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  80292d:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802932:	c9                   	leave  
  802933:	c3                   	ret    

00802934 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802934:	55                   	push   %ebp
  802935:	89 e5                	mov    %esp,%ebp
  802937:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  80293a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80293f:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802942:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802946:	75 62                	jne    8029aa <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802948:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80294c:	75 14                	jne    802962 <insert_sorted_allocList+0x2e>
  80294e:	83 ec 04             	sub    $0x4,%esp
  802951:	68 64 43 80 00       	push   $0x804364
  802956:	6a 69                	push   $0x69
  802958:	68 87 43 80 00       	push   $0x804387
  80295d:	e8 3b df ff ff       	call   80089d <_panic>
  802962:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802968:	8b 45 08             	mov    0x8(%ebp),%eax
  80296b:	89 10                	mov    %edx,(%eax)
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	74 0d                	je     802983 <insert_sorted_allocList+0x4f>
  802976:	a1 40 50 80 00       	mov    0x805040,%eax
  80297b:	8b 55 08             	mov    0x8(%ebp),%edx
  80297e:	89 50 04             	mov    %edx,0x4(%eax)
  802981:	eb 08                	jmp    80298b <insert_sorted_allocList+0x57>
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	a3 44 50 80 00       	mov    %eax,0x805044
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	a3 40 50 80 00       	mov    %eax,0x805040
  802993:	8b 45 08             	mov    0x8(%ebp),%eax
  802996:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80299d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029a2:	40                   	inc    %eax
  8029a3:	a3 4c 50 80 00       	mov    %eax,0x80504c
  8029a8:	eb 72                	jmp    802a1c <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8029aa:	a1 40 50 80 00       	mov    0x805040,%eax
  8029af:	8b 50 08             	mov    0x8(%eax),%edx
  8029b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b5:	8b 40 08             	mov    0x8(%eax),%eax
  8029b8:	39 c2                	cmp    %eax,%edx
  8029ba:	76 60                	jbe    802a1c <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8029bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c0:	75 14                	jne    8029d6 <insert_sorted_allocList+0xa2>
  8029c2:	83 ec 04             	sub    $0x4,%esp
  8029c5:	68 64 43 80 00       	push   $0x804364
  8029ca:	6a 6d                	push   $0x6d
  8029cc:	68 87 43 80 00       	push   $0x804387
  8029d1:	e8 c7 de ff ff       	call   80089d <_panic>
  8029d6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	89 10                	mov    %edx,(%eax)
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	8b 00                	mov    (%eax),%eax
  8029e6:	85 c0                	test   %eax,%eax
  8029e8:	74 0d                	je     8029f7 <insert_sorted_allocList+0xc3>
  8029ea:	a1 40 50 80 00       	mov    0x805040,%eax
  8029ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f2:	89 50 04             	mov    %edx,0x4(%eax)
  8029f5:	eb 08                	jmp    8029ff <insert_sorted_allocList+0xcb>
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	a3 44 50 80 00       	mov    %eax,0x805044
  8029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802a02:	a3 40 50 80 00       	mov    %eax,0x805040
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a11:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a16:	40                   	inc    %eax
  802a17:	a3 4c 50 80 00       	mov    %eax,0x80504c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802a1c:	a1 40 50 80 00       	mov    0x805040,%eax
  802a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a24:	e9 b9 01 00 00       	jmp    802be2 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	8b 50 08             	mov    0x8(%eax),%edx
  802a2f:	a1 40 50 80 00       	mov    0x805040,%eax
  802a34:	8b 40 08             	mov    0x8(%eax),%eax
  802a37:	39 c2                	cmp    %eax,%edx
  802a39:	76 7c                	jbe    802ab7 <insert_sorted_allocList+0x183>
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	8b 50 08             	mov    0x8(%eax),%edx
  802a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a44:	8b 40 08             	mov    0x8(%eax),%eax
  802a47:	39 c2                	cmp    %eax,%edx
  802a49:	73 6c                	jae    802ab7 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802a4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a4f:	74 06                	je     802a57 <insert_sorted_allocList+0x123>
  802a51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a55:	75 14                	jne    802a6b <insert_sorted_allocList+0x137>
  802a57:	83 ec 04             	sub    $0x4,%esp
  802a5a:	68 a0 43 80 00       	push   $0x8043a0
  802a5f:	6a 75                	push   $0x75
  802a61:	68 87 43 80 00       	push   $0x804387
  802a66:	e8 32 de ff ff       	call   80089d <_panic>
  802a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6e:	8b 50 04             	mov    0x4(%eax),%edx
  802a71:	8b 45 08             	mov    0x8(%ebp),%eax
  802a74:	89 50 04             	mov    %edx,0x4(%eax)
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a7d:	89 10                	mov    %edx,(%eax)
  802a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a82:	8b 40 04             	mov    0x4(%eax),%eax
  802a85:	85 c0                	test   %eax,%eax
  802a87:	74 0d                	je     802a96 <insert_sorted_allocList+0x162>
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	8b 40 04             	mov    0x4(%eax),%eax
  802a8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a92:	89 10                	mov    %edx,(%eax)
  802a94:	eb 08                	jmp    802a9e <insert_sorted_allocList+0x16a>
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	a3 40 50 80 00       	mov    %eax,0x805040
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa4:	89 50 04             	mov    %edx,0x4(%eax)
  802aa7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802aac:	40                   	inc    %eax
  802aad:	a3 4c 50 80 00       	mov    %eax,0x80504c

		break;}
  802ab2:	e9 59 01 00 00       	jmp    802c10 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	8b 50 08             	mov    0x8(%eax),%edx
  802abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac0:	8b 40 08             	mov    0x8(%eax),%eax
  802ac3:	39 c2                	cmp    %eax,%edx
  802ac5:	0f 86 98 00 00 00    	jbe    802b63 <insert_sorted_allocList+0x22f>
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	8b 50 08             	mov    0x8(%eax),%edx
  802ad1:	a1 44 50 80 00       	mov    0x805044,%eax
  802ad6:	8b 40 08             	mov    0x8(%eax),%eax
  802ad9:	39 c2                	cmp    %eax,%edx
  802adb:	0f 83 82 00 00 00    	jae    802b63 <insert_sorted_allocList+0x22f>
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	8b 50 08             	mov    0x8(%eax),%edx
  802ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aea:	8b 00                	mov    (%eax),%eax
  802aec:	8b 40 08             	mov    0x8(%eax),%eax
  802aef:	39 c2                	cmp    %eax,%edx
  802af1:	73 70                	jae    802b63 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af7:	74 06                	je     802aff <insert_sorted_allocList+0x1cb>
  802af9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802afd:	75 14                	jne    802b13 <insert_sorted_allocList+0x1df>
  802aff:	83 ec 04             	sub    $0x4,%esp
  802b02:	68 d8 43 80 00       	push   $0x8043d8
  802b07:	6a 7c                	push   $0x7c
  802b09:	68 87 43 80 00       	push   $0x804387
  802b0e:	e8 8a dd ff ff       	call   80089d <_panic>
  802b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b16:	8b 10                	mov    (%eax),%edx
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	89 10                	mov    %edx,(%eax)
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	74 0b                	je     802b31 <insert_sorted_allocList+0x1fd>
  802b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b29:	8b 00                	mov    (%eax),%eax
  802b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2e:	89 50 04             	mov    %edx,0x4(%eax)
  802b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b34:	8b 55 08             	mov    0x8(%ebp),%edx
  802b37:	89 10                	mov    %edx,(%eax)
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b3f:	89 50 04             	mov    %edx,0x4(%eax)
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	75 08                	jne    802b53 <insert_sorted_allocList+0x21f>
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	a3 44 50 80 00       	mov    %eax,0x805044
  802b53:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b58:	40                   	inc    %eax
  802b59:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802b5e:	e9 ad 00 00 00       	jmp    802c10 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	8b 50 08             	mov    0x8(%eax),%edx
  802b69:	a1 44 50 80 00       	mov    0x805044,%eax
  802b6e:	8b 40 08             	mov    0x8(%eax),%eax
  802b71:	39 c2                	cmp    %eax,%edx
  802b73:	76 65                	jbe    802bda <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802b75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b79:	75 17                	jne    802b92 <insert_sorted_allocList+0x25e>
  802b7b:	83 ec 04             	sub    $0x4,%esp
  802b7e:	68 0c 44 80 00       	push   $0x80440c
  802b83:	68 80 00 00 00       	push   $0x80
  802b88:	68 87 43 80 00       	push   $0x804387
  802b8d:	e8 0b dd ff ff       	call   80089d <_panic>
  802b92:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	89 50 04             	mov    %edx,0x4(%eax)
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	8b 40 04             	mov    0x4(%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 0c                	je     802bb4 <insert_sorted_allocList+0x280>
  802ba8:	a1 44 50 80 00       	mov    0x805044,%eax
  802bad:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb0:	89 10                	mov    %edx,(%eax)
  802bb2:	eb 08                	jmp    802bbc <insert_sorted_allocList+0x288>
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	a3 40 50 80 00       	mov    %eax,0x805040
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	a3 44 50 80 00       	mov    %eax,0x805044
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bcd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bd2:	40                   	inc    %eax
  802bd3:	a3 4c 50 80 00       	mov    %eax,0x80504c
		break;
  802bd8:	eb 36                	jmp    802c10 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802bda:	a1 48 50 80 00       	mov    0x805048,%eax
  802bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802be2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802be6:	74 07                	je     802bef <insert_sorted_allocList+0x2bb>
  802be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802beb:	8b 00                	mov    (%eax),%eax
  802bed:	eb 05                	jmp    802bf4 <insert_sorted_allocList+0x2c0>
  802bef:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf4:	a3 48 50 80 00       	mov    %eax,0x805048
  802bf9:	a1 48 50 80 00       	mov    0x805048,%eax
  802bfe:	85 c0                	test   %eax,%eax
  802c00:	0f 85 23 fe ff ff    	jne    802a29 <insert_sorted_allocList+0xf5>
  802c06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c0a:	0f 85 19 fe ff ff    	jne    802a29 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802c10:	90                   	nop
  802c11:	c9                   	leave  
  802c12:	c3                   	ret    

00802c13 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c13:	55                   	push   %ebp
  802c14:	89 e5                	mov    %esp,%ebp
  802c16:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802c19:	a1 38 51 80 00       	mov    0x805138,%eax
  802c1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c21:	e9 7c 01 00 00       	jmp    802da2 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c29:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c2f:	0f 85 90 00 00 00    	jne    802cc5 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802c3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3f:	75 17                	jne    802c58 <alloc_block_FF+0x45>
  802c41:	83 ec 04             	sub    $0x4,%esp
  802c44:	68 2f 44 80 00       	push   $0x80442f
  802c49:	68 ba 00 00 00       	push   $0xba
  802c4e:	68 87 43 80 00       	push   $0x804387
  802c53:	e8 45 dc ff ff       	call   80089d <_panic>
  802c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5b:	8b 00                	mov    (%eax),%eax
  802c5d:	85 c0                	test   %eax,%eax
  802c5f:	74 10                	je     802c71 <alloc_block_FF+0x5e>
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c69:	8b 52 04             	mov    0x4(%edx),%edx
  802c6c:	89 50 04             	mov    %edx,0x4(%eax)
  802c6f:	eb 0b                	jmp    802c7c <alloc_block_FF+0x69>
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	8b 40 04             	mov    0x4(%eax),%eax
  802c77:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	8b 40 04             	mov    0x4(%eax),%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	74 0f                	je     802c95 <alloc_block_FF+0x82>
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	8b 40 04             	mov    0x4(%eax),%eax
  802c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8f:	8b 12                	mov    (%edx),%edx
  802c91:	89 10                	mov    %edx,(%eax)
  802c93:	eb 0a                	jmp    802c9f <alloc_block_FF+0x8c>
  802c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c98:	8b 00                	mov    (%eax),%eax
  802c9a:	a3 38 51 80 00       	mov    %eax,0x805138
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb2:	a1 44 51 80 00       	mov    0x805144,%eax
  802cb7:	48                   	dec    %eax
  802cb8:	a3 44 51 80 00       	mov    %eax,0x805144
					return tmp_block;
  802cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cc0:	e9 10 01 00 00       	jmp    802dd5 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccb:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cce:	0f 86 c6 00 00 00    	jbe    802d9a <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802cd4:	a1 48 51 80 00       	mov    0x805148,%eax
  802cd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802cdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ce0:	75 17                	jne    802cf9 <alloc_block_FF+0xe6>
  802ce2:	83 ec 04             	sub    $0x4,%esp
  802ce5:	68 2f 44 80 00       	push   $0x80442f
  802cea:	68 c2 00 00 00       	push   $0xc2
  802cef:	68 87 43 80 00       	push   $0x804387
  802cf4:	e8 a4 db ff ff       	call   80089d <_panic>
  802cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cfc:	8b 00                	mov    (%eax),%eax
  802cfe:	85 c0                	test   %eax,%eax
  802d00:	74 10                	je     802d12 <alloc_block_FF+0xff>
  802d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d05:	8b 00                	mov    (%eax),%eax
  802d07:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d0a:	8b 52 04             	mov    0x4(%edx),%edx
  802d0d:	89 50 04             	mov    %edx,0x4(%eax)
  802d10:	eb 0b                	jmp    802d1d <alloc_block_FF+0x10a>
  802d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d15:	8b 40 04             	mov    0x4(%eax),%eax
  802d18:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d20:	8b 40 04             	mov    0x4(%eax),%eax
  802d23:	85 c0                	test   %eax,%eax
  802d25:	74 0f                	je     802d36 <alloc_block_FF+0x123>
  802d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2a:	8b 40 04             	mov    0x4(%eax),%eax
  802d2d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d30:	8b 12                	mov    (%edx),%edx
  802d32:	89 10                	mov    %edx,(%eax)
  802d34:	eb 0a                	jmp    802d40 <alloc_block_FF+0x12d>
  802d36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d39:	8b 00                	mov    (%eax),%eax
  802d3b:	a3 48 51 80 00       	mov    %eax,0x805148
  802d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d43:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d53:	a1 54 51 80 00       	mov    0x805154,%eax
  802d58:	48                   	dec    %eax
  802d59:	a3 54 51 80 00       	mov    %eax,0x805154
					tmp_block->sva=element->sva;
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 50 08             	mov    0x8(%eax),%edx
  802d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d67:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d70:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	8b 40 0c             	mov    0xc(%eax),%eax
  802d79:	2b 45 08             	sub    0x8(%ebp),%eax
  802d7c:	89 c2                	mov    %eax,%edx
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 50 08             	mov    0x8(%eax),%edx
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	01 c2                	add    %eax,%edx
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d98:	eb 3b                	jmp    802dd5 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802d9a:	a1 40 51 80 00       	mov    0x805140,%eax
  802d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802da2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da6:	74 07                	je     802daf <alloc_block_FF+0x19c>
  802da8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dab:	8b 00                	mov    (%eax),%eax
  802dad:	eb 05                	jmp    802db4 <alloc_block_FF+0x1a1>
  802daf:	b8 00 00 00 00       	mov    $0x0,%eax
  802db4:	a3 40 51 80 00       	mov    %eax,0x805140
  802db9:	a1 40 51 80 00       	mov    0x805140,%eax
  802dbe:	85 c0                	test   %eax,%eax
  802dc0:	0f 85 60 fe ff ff    	jne    802c26 <alloc_block_FF+0x13>
  802dc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dca:	0f 85 56 fe ff ff    	jne    802c26 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  802dd0:	b8 00 00 00 00       	mov    $0x0,%eax
  802dd5:	c9                   	leave  
  802dd6:	c3                   	ret    

00802dd7 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802dd7:	55                   	push   %ebp
  802dd8:	89 e5                	mov    %esp,%ebp
  802dda:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802ddd:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802de4:	a1 38 51 80 00       	mov    0x805138,%eax
  802de9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dec:	eb 3a                	jmp    802e28 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	8b 40 0c             	mov    0xc(%eax),%eax
  802df4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802df7:	72 27                	jb     802e20 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802df9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802dfd:	75 0b                	jne    802e0a <alloc_block_BF+0x33>
					best_size= element->size;
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 40 0c             	mov    0xc(%eax),%eax
  802e05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802e08:	eb 16                	jmp    802e20 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e13:	39 c2                	cmp    %eax,%edx
  802e15:	77 09                	ja     802e20 <alloc_block_BF+0x49>
					best_size=element->size;
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1d:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802e20:	a1 40 51 80 00       	mov    0x805140,%eax
  802e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2c:	74 07                	je     802e35 <alloc_block_BF+0x5e>
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 00                	mov    (%eax),%eax
  802e33:	eb 05                	jmp    802e3a <alloc_block_BF+0x63>
  802e35:	b8 00 00 00 00       	mov    $0x0,%eax
  802e3a:	a3 40 51 80 00       	mov    %eax,0x805140
  802e3f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e44:	85 c0                	test   %eax,%eax
  802e46:	75 a6                	jne    802dee <alloc_block_BF+0x17>
  802e48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4c:	75 a0                	jne    802dee <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802e4e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802e52:	0f 84 d3 01 00 00    	je     80302b <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802e58:	a1 38 51 80 00       	mov    0x805138,%eax
  802e5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e60:	e9 98 01 00 00       	jmp    802ffd <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e68:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e6b:	0f 86 da 00 00 00    	jbe    802f4b <alloc_block_BF+0x174>
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 50 0c             	mov    0xc(%eax),%edx
  802e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7a:	39 c2                	cmp    %eax,%edx
  802e7c:	0f 85 c9 00 00 00    	jne    802f4b <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802e82:	a1 48 51 80 00       	mov    0x805148,%eax
  802e87:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802e8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e8e:	75 17                	jne    802ea7 <alloc_block_BF+0xd0>
  802e90:	83 ec 04             	sub    $0x4,%esp
  802e93:	68 2f 44 80 00       	push   $0x80442f
  802e98:	68 ea 00 00 00       	push   $0xea
  802e9d:	68 87 43 80 00       	push   $0x804387
  802ea2:	e8 f6 d9 ff ff       	call   80089d <_panic>
  802ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eaa:	8b 00                	mov    (%eax),%eax
  802eac:	85 c0                	test   %eax,%eax
  802eae:	74 10                	je     802ec0 <alloc_block_BF+0xe9>
  802eb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802eb8:	8b 52 04             	mov    0x4(%edx),%edx
  802ebb:	89 50 04             	mov    %edx,0x4(%eax)
  802ebe:	eb 0b                	jmp    802ecb <alloc_block_BF+0xf4>
  802ec0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec3:	8b 40 04             	mov    0x4(%eax),%eax
  802ec6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ecb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ece:	8b 40 04             	mov    0x4(%eax),%eax
  802ed1:	85 c0                	test   %eax,%eax
  802ed3:	74 0f                	je     802ee4 <alloc_block_BF+0x10d>
  802ed5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ed8:	8b 40 04             	mov    0x4(%eax),%eax
  802edb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ede:	8b 12                	mov    (%edx),%edx
  802ee0:	89 10                	mov    %edx,(%eax)
  802ee2:	eb 0a                	jmp    802eee <alloc_block_BF+0x117>
  802ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ee7:	8b 00                	mov    (%eax),%eax
  802ee9:	a3 48 51 80 00       	mov    %eax,0x805148
  802eee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ef1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ef7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802efa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f01:	a1 54 51 80 00       	mov    0x805154,%eax
  802f06:	48                   	dec    %eax
  802f07:	a3 54 51 80 00       	mov    %eax,0x805154
				tmp_block->sva=element->sva;
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	8b 50 08             	mov    0x8(%eax),%edx
  802f12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f15:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1e:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	8b 40 0c             	mov    0xc(%eax),%eax
  802f27:	2b 45 08             	sub    0x8(%ebp),%eax
  802f2a:	89 c2                	mov    %eax,%edx
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	8b 50 08             	mov    0x8(%eax),%edx
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	01 c2                	add    %eax,%edx
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802f43:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f46:	e9 e5 00 00 00       	jmp    803030 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 50 0c             	mov    0xc(%eax),%edx
  802f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f54:	39 c2                	cmp    %eax,%edx
  802f56:	0f 85 99 00 00 00    	jne    802ff5 <alloc_block_BF+0x21e>
  802f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f5f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f62:	0f 85 8d 00 00 00    	jne    802ff5 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802f6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f72:	75 17                	jne    802f8b <alloc_block_BF+0x1b4>
  802f74:	83 ec 04             	sub    $0x4,%esp
  802f77:	68 2f 44 80 00       	push   $0x80442f
  802f7c:	68 f7 00 00 00       	push   $0xf7
  802f81:	68 87 43 80 00       	push   $0x804387
  802f86:	e8 12 d9 ff ff       	call   80089d <_panic>
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	85 c0                	test   %eax,%eax
  802f92:	74 10                	je     802fa4 <alloc_block_BF+0x1cd>
  802f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f97:	8b 00                	mov    (%eax),%eax
  802f99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f9c:	8b 52 04             	mov    0x4(%edx),%edx
  802f9f:	89 50 04             	mov    %edx,0x4(%eax)
  802fa2:	eb 0b                	jmp    802faf <alloc_block_BF+0x1d8>
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	8b 40 04             	mov    0x4(%eax),%eax
  802faa:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	8b 40 04             	mov    0x4(%eax),%eax
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	74 0f                	je     802fc8 <alloc_block_BF+0x1f1>
  802fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbc:	8b 40 04             	mov    0x4(%eax),%eax
  802fbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc2:	8b 12                	mov    (%edx),%edx
  802fc4:	89 10                	mov    %edx,(%eax)
  802fc6:	eb 0a                	jmp    802fd2 <alloc_block_BF+0x1fb>
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 00                	mov    (%eax),%eax
  802fcd:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe5:	a1 44 51 80 00       	mov    0x805144,%eax
  802fea:	48                   	dec    %eax
  802feb:	a3 44 51 80 00       	mov    %eax,0x805144
				return tmp_block;
  802ff0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff3:	eb 3b                	jmp    803030 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802ff5:	a1 40 51 80 00       	mov    0x805140,%eax
  802ffa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ffd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803001:	74 07                	je     80300a <alloc_block_BF+0x233>
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	8b 00                	mov    (%eax),%eax
  803008:	eb 05                	jmp    80300f <alloc_block_BF+0x238>
  80300a:	b8 00 00 00 00       	mov    $0x0,%eax
  80300f:	a3 40 51 80 00       	mov    %eax,0x805140
  803014:	a1 40 51 80 00       	mov    0x805140,%eax
  803019:	85 c0                	test   %eax,%eax
  80301b:	0f 85 44 fe ff ff    	jne    802e65 <alloc_block_BF+0x8e>
  803021:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803025:	0f 85 3a fe ff ff    	jne    802e65 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80302b:	b8 00 00 00 00       	mov    $0x0,%eax
  803030:	c9                   	leave  
  803031:	c3                   	ret    

00803032 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  803032:	55                   	push   %ebp
  803033:	89 e5                	mov    %esp,%ebp
  803035:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  803038:	83 ec 04             	sub    $0x4,%esp
  80303b:	68 50 44 80 00       	push   $0x804450
  803040:	68 04 01 00 00       	push   $0x104
  803045:	68 87 43 80 00       	push   $0x804387
  80304a:	e8 4e d8 ff ff       	call   80089d <_panic>

0080304f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80304f:	55                   	push   %ebp
  803050:	89 e5                	mov    %esp,%ebp
  803052:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  803055:	a1 38 51 80 00       	mov    0x805138,%eax
  80305a:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  80305d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803062:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  803065:	a1 38 51 80 00       	mov    0x805138,%eax
  80306a:	85 c0                	test   %eax,%eax
  80306c:	75 68                	jne    8030d6 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80306e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803072:	75 17                	jne    80308b <insert_sorted_with_merge_freeList+0x3c>
  803074:	83 ec 04             	sub    $0x4,%esp
  803077:	68 64 43 80 00       	push   $0x804364
  80307c:	68 14 01 00 00       	push   $0x114
  803081:	68 87 43 80 00       	push   $0x804387
  803086:	e8 12 d8 ff ff       	call   80089d <_panic>
  80308b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803091:	8b 45 08             	mov    0x8(%ebp),%eax
  803094:	89 10                	mov    %edx,(%eax)
  803096:	8b 45 08             	mov    0x8(%ebp),%eax
  803099:	8b 00                	mov    (%eax),%eax
  80309b:	85 c0                	test   %eax,%eax
  80309d:	74 0d                	je     8030ac <insert_sorted_with_merge_freeList+0x5d>
  80309f:	a1 38 51 80 00       	mov    0x805138,%eax
  8030a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a7:	89 50 04             	mov    %edx,0x4(%eax)
  8030aa:	eb 08                	jmp    8030b4 <insert_sorted_with_merge_freeList+0x65>
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b7:	a3 38 51 80 00       	mov    %eax,0x805138
  8030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c6:	a1 44 51 80 00       	mov    0x805144,%eax
  8030cb:	40                   	inc    %eax
  8030cc:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  8030d1:	e9 d2 06 00 00       	jmp    8037a8 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8030d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d9:	8b 50 08             	mov    0x8(%eax),%edx
  8030dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030df:	8b 40 08             	mov    0x8(%eax),%eax
  8030e2:	39 c2                	cmp    %eax,%edx
  8030e4:	0f 83 22 01 00 00    	jae    80320c <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	8b 50 08             	mov    0x8(%eax),%edx
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f6:	01 c2                	add    %eax,%edx
  8030f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030fb:	8b 40 08             	mov    0x8(%eax),%eax
  8030fe:	39 c2                	cmp    %eax,%edx
  803100:	0f 85 9e 00 00 00    	jne    8031a4 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  803106:	8b 45 08             	mov    0x8(%ebp),%eax
  803109:	8b 50 08             	mov    0x8(%eax),%edx
  80310c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80310f:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  803112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803115:	8b 50 0c             	mov    0xc(%eax),%edx
  803118:	8b 45 08             	mov    0x8(%ebp),%eax
  80311b:	8b 40 0c             	mov    0xc(%eax),%eax
  80311e:	01 c2                	add    %eax,%edx
  803120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803123:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  803126:	8b 45 08             	mov    0x8(%ebp),%eax
  803129:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803130:	8b 45 08             	mov    0x8(%ebp),%eax
  803133:	8b 50 08             	mov    0x8(%eax),%edx
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80313c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803140:	75 17                	jne    803159 <insert_sorted_with_merge_freeList+0x10a>
  803142:	83 ec 04             	sub    $0x4,%esp
  803145:	68 64 43 80 00       	push   $0x804364
  80314a:	68 21 01 00 00       	push   $0x121
  80314f:	68 87 43 80 00       	push   $0x804387
  803154:	e8 44 d7 ff ff       	call   80089d <_panic>
  803159:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80315f:	8b 45 08             	mov    0x8(%ebp),%eax
  803162:	89 10                	mov    %edx,(%eax)
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	74 0d                	je     80317a <insert_sorted_with_merge_freeList+0x12b>
  80316d:	a1 48 51 80 00       	mov    0x805148,%eax
  803172:	8b 55 08             	mov    0x8(%ebp),%edx
  803175:	89 50 04             	mov    %edx,0x4(%eax)
  803178:	eb 08                	jmp    803182 <insert_sorted_with_merge_freeList+0x133>
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	a3 48 51 80 00       	mov    %eax,0x805148
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803194:	a1 54 51 80 00       	mov    0x805154,%eax
  803199:	40                   	inc    %eax
  80319a:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  80319f:	e9 04 06 00 00       	jmp    8037a8 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8031a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031a8:	75 17                	jne    8031c1 <insert_sorted_with_merge_freeList+0x172>
  8031aa:	83 ec 04             	sub    $0x4,%esp
  8031ad:	68 64 43 80 00       	push   $0x804364
  8031b2:	68 26 01 00 00       	push   $0x126
  8031b7:	68 87 43 80 00       	push   $0x804387
  8031bc:	e8 dc d6 ff ff       	call   80089d <_panic>
  8031c1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	89 10                	mov    %edx,(%eax)
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031cf:	8b 00                	mov    (%eax),%eax
  8031d1:	85 c0                	test   %eax,%eax
  8031d3:	74 0d                	je     8031e2 <insert_sorted_with_merge_freeList+0x193>
  8031d5:	a1 38 51 80 00       	mov    0x805138,%eax
  8031da:	8b 55 08             	mov    0x8(%ebp),%edx
  8031dd:	89 50 04             	mov    %edx,0x4(%eax)
  8031e0:	eb 08                	jmp    8031ea <insert_sorted_with_merge_freeList+0x19b>
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	a3 38 51 80 00       	mov    %eax,0x805138
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fc:	a1 44 51 80 00       	mov    0x805144,%eax
  803201:	40                   	inc    %eax
  803202:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803207:	e9 9c 05 00 00       	jmp    8037a8 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	8b 50 08             	mov    0x8(%eax),%edx
  803212:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803215:	8b 40 08             	mov    0x8(%eax),%eax
  803218:	39 c2                	cmp    %eax,%edx
  80321a:	0f 86 16 01 00 00    	jbe    803336 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  803220:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803223:	8b 50 08             	mov    0x8(%eax),%edx
  803226:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803229:	8b 40 0c             	mov    0xc(%eax),%eax
  80322c:	01 c2                	add    %eax,%edx
  80322e:	8b 45 08             	mov    0x8(%ebp),%eax
  803231:	8b 40 08             	mov    0x8(%eax),%eax
  803234:	39 c2                	cmp    %eax,%edx
  803236:	0f 85 92 00 00 00    	jne    8032ce <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  80323c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80323f:	8b 50 0c             	mov    0xc(%eax),%edx
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	8b 40 0c             	mov    0xc(%eax),%eax
  803248:	01 c2                	add    %eax,%edx
  80324a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80324d:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80325a:	8b 45 08             	mov    0x8(%ebp),%eax
  80325d:	8b 50 08             	mov    0x8(%eax),%edx
  803260:	8b 45 08             	mov    0x8(%ebp),%eax
  803263:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803266:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80326a:	75 17                	jne    803283 <insert_sorted_with_merge_freeList+0x234>
  80326c:	83 ec 04             	sub    $0x4,%esp
  80326f:	68 64 43 80 00       	push   $0x804364
  803274:	68 31 01 00 00       	push   $0x131
  803279:	68 87 43 80 00       	push   $0x804387
  80327e:	e8 1a d6 ff ff       	call   80089d <_panic>
  803283:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803289:	8b 45 08             	mov    0x8(%ebp),%eax
  80328c:	89 10                	mov    %edx,(%eax)
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	8b 00                	mov    (%eax),%eax
  803293:	85 c0                	test   %eax,%eax
  803295:	74 0d                	je     8032a4 <insert_sorted_with_merge_freeList+0x255>
  803297:	a1 48 51 80 00       	mov    0x805148,%eax
  80329c:	8b 55 08             	mov    0x8(%ebp),%edx
  80329f:	89 50 04             	mov    %edx,0x4(%eax)
  8032a2:	eb 08                	jmp    8032ac <insert_sorted_with_merge_freeList+0x25d>
  8032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8032af:	a3 48 51 80 00       	mov    %eax,0x805148
  8032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032be:	a1 54 51 80 00       	mov    0x805154,%eax
  8032c3:	40                   	inc    %eax
  8032c4:	a3 54 51 80 00       	mov    %eax,0x805154
						}
				}
        }

}
}
  8032c9:	e9 da 04 00 00       	jmp    8037a8 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  8032ce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d2:	75 17                	jne    8032eb <insert_sorted_with_merge_freeList+0x29c>
  8032d4:	83 ec 04             	sub    $0x4,%esp
  8032d7:	68 0c 44 80 00       	push   $0x80440c
  8032dc:	68 37 01 00 00       	push   $0x137
  8032e1:	68 87 43 80 00       	push   $0x804387
  8032e6:	e8 b2 d5 ff ff       	call   80089d <_panic>
  8032eb:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f4:	89 50 04             	mov    %edx,0x4(%eax)
  8032f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fa:	8b 40 04             	mov    0x4(%eax),%eax
  8032fd:	85 c0                	test   %eax,%eax
  8032ff:	74 0c                	je     80330d <insert_sorted_with_merge_freeList+0x2be>
  803301:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803306:	8b 55 08             	mov    0x8(%ebp),%edx
  803309:	89 10                	mov    %edx,(%eax)
  80330b:	eb 08                	jmp    803315 <insert_sorted_with_merge_freeList+0x2c6>
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	a3 38 51 80 00       	mov    %eax,0x805138
  803315:	8b 45 08             	mov    0x8(%ebp),%eax
  803318:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803326:	a1 44 51 80 00       	mov    0x805144,%eax
  80332b:	40                   	inc    %eax
  80332c:	a3 44 51 80 00       	mov    %eax,0x805144
						}
				}
        }

}
}
  803331:	e9 72 04 00 00       	jmp    8037a8 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803336:	a1 38 51 80 00       	mov    0x805138,%eax
  80333b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80333e:	e9 35 04 00 00       	jmp    803778 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  803343:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803346:	8b 00                	mov    (%eax),%eax
  803348:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  80334b:	8b 45 08             	mov    0x8(%ebp),%eax
  80334e:	8b 50 08             	mov    0x8(%eax),%edx
  803351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803354:	8b 40 08             	mov    0x8(%eax),%eax
  803357:	39 c2                	cmp    %eax,%edx
  803359:	0f 86 11 04 00 00    	jbe    803770 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  80335f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803362:	8b 50 08             	mov    0x8(%eax),%edx
  803365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803368:	8b 40 0c             	mov    0xc(%eax),%eax
  80336b:	01 c2                	add    %eax,%edx
  80336d:	8b 45 08             	mov    0x8(%ebp),%eax
  803370:	8b 40 08             	mov    0x8(%eax),%eax
  803373:	39 c2                	cmp    %eax,%edx
  803375:	0f 83 8b 00 00 00    	jae    803406 <insert_sorted_with_merge_freeList+0x3b7>
  80337b:	8b 45 08             	mov    0x8(%ebp),%eax
  80337e:	8b 50 08             	mov    0x8(%eax),%edx
  803381:	8b 45 08             	mov    0x8(%ebp),%eax
  803384:	8b 40 0c             	mov    0xc(%eax),%eax
  803387:	01 c2                	add    %eax,%edx
  803389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80338c:	8b 40 08             	mov    0x8(%eax),%eax
  80338f:	39 c2                	cmp    %eax,%edx
  803391:	73 73                	jae    803406 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  803393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803397:	74 06                	je     80339f <insert_sorted_with_merge_freeList+0x350>
  803399:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339d:	75 17                	jne    8033b6 <insert_sorted_with_merge_freeList+0x367>
  80339f:	83 ec 04             	sub    $0x4,%esp
  8033a2:	68 d8 43 80 00       	push   $0x8043d8
  8033a7:	68 48 01 00 00       	push   $0x148
  8033ac:	68 87 43 80 00       	push   $0x804387
  8033b1:	e8 e7 d4 ff ff       	call   80089d <_panic>
  8033b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033b9:	8b 10                	mov    (%eax),%edx
  8033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033be:	89 10                	mov    %edx,(%eax)
  8033c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c3:	8b 00                	mov    (%eax),%eax
  8033c5:	85 c0                	test   %eax,%eax
  8033c7:	74 0b                	je     8033d4 <insert_sorted_with_merge_freeList+0x385>
  8033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033cc:	8b 00                	mov    (%eax),%eax
  8033ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d1:	89 50 04             	mov    %edx,0x4(%eax)
  8033d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033da:	89 10                	mov    %edx,(%eax)
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e2:	89 50 04             	mov    %edx,0x4(%eax)
  8033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e8:	8b 00                	mov    (%eax),%eax
  8033ea:	85 c0                	test   %eax,%eax
  8033ec:	75 08                	jne    8033f6 <insert_sorted_with_merge_freeList+0x3a7>
  8033ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f6:	a1 44 51 80 00       	mov    0x805144,%eax
  8033fb:	40                   	inc    %eax
  8033fc:	a3 44 51 80 00       	mov    %eax,0x805144
								break;
  803401:	e9 a2 03 00 00       	jmp    8037a8 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  803406:	8b 45 08             	mov    0x8(%ebp),%eax
  803409:	8b 50 08             	mov    0x8(%eax),%edx
  80340c:	8b 45 08             	mov    0x8(%ebp),%eax
  80340f:	8b 40 0c             	mov    0xc(%eax),%eax
  803412:	01 c2                	add    %eax,%edx
  803414:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803417:	8b 40 08             	mov    0x8(%eax),%eax
  80341a:	39 c2                	cmp    %eax,%edx
  80341c:	0f 83 ae 00 00 00    	jae    8034d0 <insert_sorted_with_merge_freeList+0x481>
  803422:	8b 45 08             	mov    0x8(%ebp),%eax
  803425:	8b 50 08             	mov    0x8(%eax),%edx
  803428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342b:	8b 48 08             	mov    0x8(%eax),%ecx
  80342e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803431:	8b 40 0c             	mov    0xc(%eax),%eax
  803434:	01 c8                	add    %ecx,%eax
  803436:	39 c2                	cmp    %eax,%edx
  803438:	0f 85 92 00 00 00    	jne    8034d0 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  80343e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803441:	8b 50 0c             	mov    0xc(%eax),%edx
  803444:	8b 45 08             	mov    0x8(%ebp),%eax
  803447:	8b 40 0c             	mov    0xc(%eax),%eax
  80344a:	01 c2                	add    %eax,%edx
  80344c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344f:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  803452:	8b 45 08             	mov    0x8(%ebp),%eax
  803455:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80345c:	8b 45 08             	mov    0x8(%ebp),%eax
  80345f:	8b 50 08             	mov    0x8(%eax),%edx
  803462:	8b 45 08             	mov    0x8(%ebp),%eax
  803465:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  803468:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80346c:	75 17                	jne    803485 <insert_sorted_with_merge_freeList+0x436>
  80346e:	83 ec 04             	sub    $0x4,%esp
  803471:	68 64 43 80 00       	push   $0x804364
  803476:	68 51 01 00 00       	push   $0x151
  80347b:	68 87 43 80 00       	push   $0x804387
  803480:	e8 18 d4 ff ff       	call   80089d <_panic>
  803485:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80348b:	8b 45 08             	mov    0x8(%ebp),%eax
  80348e:	89 10                	mov    %edx,(%eax)
  803490:	8b 45 08             	mov    0x8(%ebp),%eax
  803493:	8b 00                	mov    (%eax),%eax
  803495:	85 c0                	test   %eax,%eax
  803497:	74 0d                	je     8034a6 <insert_sorted_with_merge_freeList+0x457>
  803499:	a1 48 51 80 00       	mov    0x805148,%eax
  80349e:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a1:	89 50 04             	mov    %edx,0x4(%eax)
  8034a4:	eb 08                	jmp    8034ae <insert_sorted_with_merge_freeList+0x45f>
  8034a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b1:	a3 48 51 80 00       	mov    %eax,0x805148
  8034b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c0:	a1 54 51 80 00       	mov    0x805154,%eax
  8034c5:	40                   	inc    %eax
  8034c6:	a3 54 51 80 00       	mov    %eax,0x805154
								 break;
  8034cb:	e9 d8 02 00 00       	jmp    8037a8 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  8034d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d3:	8b 50 08             	mov    0x8(%eax),%edx
  8034d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8034dc:	01 c2                	add    %eax,%edx
  8034de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8034e1:	8b 40 08             	mov    0x8(%eax),%eax
  8034e4:	39 c2                	cmp    %eax,%edx
  8034e6:	0f 85 ba 00 00 00    	jne    8035a6 <insert_sorted_with_merge_freeList+0x557>
  8034ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ef:	8b 50 08             	mov    0x8(%eax),%edx
  8034f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f5:	8b 48 08             	mov    0x8(%eax),%ecx
  8034f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8034fe:	01 c8                	add    %ecx,%eax
  803500:	39 c2                	cmp    %eax,%edx
  803502:	0f 86 9e 00 00 00    	jbe    8035a6 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  803508:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80350b:	8b 50 0c             	mov    0xc(%eax),%edx
  80350e:	8b 45 08             	mov    0x8(%ebp),%eax
  803511:	8b 40 0c             	mov    0xc(%eax),%eax
  803514:	01 c2                	add    %eax,%edx
  803516:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803519:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  80351c:	8b 45 08             	mov    0x8(%ebp),%eax
  80351f:	8b 50 08             	mov    0x8(%eax),%edx
  803522:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803525:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  803528:	8b 45 08             	mov    0x8(%ebp),%eax
  80352b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803532:	8b 45 08             	mov    0x8(%ebp),%eax
  803535:	8b 50 08             	mov    0x8(%eax),%edx
  803538:	8b 45 08             	mov    0x8(%ebp),%eax
  80353b:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80353e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803542:	75 17                	jne    80355b <insert_sorted_with_merge_freeList+0x50c>
  803544:	83 ec 04             	sub    $0x4,%esp
  803547:	68 64 43 80 00       	push   $0x804364
  80354c:	68 5b 01 00 00       	push   $0x15b
  803551:	68 87 43 80 00       	push   $0x804387
  803556:	e8 42 d3 ff ff       	call   80089d <_panic>
  80355b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803561:	8b 45 08             	mov    0x8(%ebp),%eax
  803564:	89 10                	mov    %edx,(%eax)
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	8b 00                	mov    (%eax),%eax
  80356b:	85 c0                	test   %eax,%eax
  80356d:	74 0d                	je     80357c <insert_sorted_with_merge_freeList+0x52d>
  80356f:	a1 48 51 80 00       	mov    0x805148,%eax
  803574:	8b 55 08             	mov    0x8(%ebp),%edx
  803577:	89 50 04             	mov    %edx,0x4(%eax)
  80357a:	eb 08                	jmp    803584 <insert_sorted_with_merge_freeList+0x535>
  80357c:	8b 45 08             	mov    0x8(%ebp),%eax
  80357f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803584:	8b 45 08             	mov    0x8(%ebp),%eax
  803587:	a3 48 51 80 00       	mov    %eax,0x805148
  80358c:	8b 45 08             	mov    0x8(%ebp),%eax
  80358f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803596:	a1 54 51 80 00       	mov    0x805154,%eax
  80359b:	40                   	inc    %eax
  80359c:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  8035a1:	e9 02 02 00 00       	jmp    8037a8 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  8035a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a9:	8b 50 08             	mov    0x8(%eax),%edx
  8035ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8035af:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b2:	01 c2                	add    %eax,%edx
  8035b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035b7:	8b 40 08             	mov    0x8(%eax),%eax
  8035ba:	39 c2                	cmp    %eax,%edx
  8035bc:	0f 85 ae 01 00 00    	jne    803770 <insert_sorted_with_merge_freeList+0x721>
  8035c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c5:	8b 50 08             	mov    0x8(%eax),%edx
  8035c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035cb:	8b 48 08             	mov    0x8(%eax),%ecx
  8035ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d4:	01 c8                	add    %ecx,%eax
  8035d6:	39 c2                	cmp    %eax,%edx
  8035d8:	0f 85 92 01 00 00    	jne    803770 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  8035de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e1:	8b 50 0c             	mov    0xc(%eax),%edx
  8035e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ea:	01 c2                	add    %eax,%edx
  8035ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8035ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f2:	01 c2                	add    %eax,%edx
  8035f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f7:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  8035fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  803604:	8b 45 08             	mov    0x8(%ebp),%eax
  803607:	8b 50 08             	mov    0x8(%eax),%edx
  80360a:	8b 45 08             	mov    0x8(%ebp),%eax
  80360d:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  803610:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803613:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80361a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80361d:	8b 50 08             	mov    0x8(%eax),%edx
  803620:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803623:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  803626:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80362a:	75 17                	jne    803643 <insert_sorted_with_merge_freeList+0x5f4>
  80362c:	83 ec 04             	sub    $0x4,%esp
  80362f:	68 2f 44 80 00       	push   $0x80442f
  803634:	68 63 01 00 00       	push   $0x163
  803639:	68 87 43 80 00       	push   $0x804387
  80363e:	e8 5a d2 ff ff       	call   80089d <_panic>
  803643:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803646:	8b 00                	mov    (%eax),%eax
  803648:	85 c0                	test   %eax,%eax
  80364a:	74 10                	je     80365c <insert_sorted_with_merge_freeList+0x60d>
  80364c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80364f:	8b 00                	mov    (%eax),%eax
  803651:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803654:	8b 52 04             	mov    0x4(%edx),%edx
  803657:	89 50 04             	mov    %edx,0x4(%eax)
  80365a:	eb 0b                	jmp    803667 <insert_sorted_with_merge_freeList+0x618>
  80365c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80365f:	8b 40 04             	mov    0x4(%eax),%eax
  803662:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803667:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80366a:	8b 40 04             	mov    0x4(%eax),%eax
  80366d:	85 c0                	test   %eax,%eax
  80366f:	74 0f                	je     803680 <insert_sorted_with_merge_freeList+0x631>
  803671:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803674:	8b 40 04             	mov    0x4(%eax),%eax
  803677:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80367a:	8b 12                	mov    (%edx),%edx
  80367c:	89 10                	mov    %edx,(%eax)
  80367e:	eb 0a                	jmp    80368a <insert_sorted_with_merge_freeList+0x63b>
  803680:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803683:	8b 00                	mov    (%eax),%eax
  803685:	a3 38 51 80 00       	mov    %eax,0x805138
  80368a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80368d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803693:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803696:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80369d:	a1 44 51 80 00       	mov    0x805144,%eax
  8036a2:	48                   	dec    %eax
  8036a3:	a3 44 51 80 00       	mov    %eax,0x805144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  8036a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8036ac:	75 17                	jne    8036c5 <insert_sorted_with_merge_freeList+0x676>
  8036ae:	83 ec 04             	sub    $0x4,%esp
  8036b1:	68 64 43 80 00       	push   $0x804364
  8036b6:	68 64 01 00 00       	push   $0x164
  8036bb:	68 87 43 80 00       	push   $0x804387
  8036c0:	e8 d8 d1 ff ff       	call   80089d <_panic>
  8036c5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036ce:	89 10                	mov    %edx,(%eax)
  8036d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036d3:	8b 00                	mov    (%eax),%eax
  8036d5:	85 c0                	test   %eax,%eax
  8036d7:	74 0d                	je     8036e6 <insert_sorted_with_merge_freeList+0x697>
  8036d9:	a1 48 51 80 00       	mov    0x805148,%eax
  8036de:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8036e1:	89 50 04             	mov    %edx,0x4(%eax)
  8036e4:	eb 08                	jmp    8036ee <insert_sorted_with_merge_freeList+0x69f>
  8036e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036e9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f1:	a3 48 51 80 00       	mov    %eax,0x805148
  8036f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8036f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803700:	a1 54 51 80 00       	mov    0x805154,%eax
  803705:	40                   	inc    %eax
  803706:	a3 54 51 80 00       	mov    %eax,0x805154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80370b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80370f:	75 17                	jne    803728 <insert_sorted_with_merge_freeList+0x6d9>
  803711:	83 ec 04             	sub    $0x4,%esp
  803714:	68 64 43 80 00       	push   $0x804364
  803719:	68 65 01 00 00       	push   $0x165
  80371e:	68 87 43 80 00       	push   $0x804387
  803723:	e8 75 d1 ff ff       	call   80089d <_panic>
  803728:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80372e:	8b 45 08             	mov    0x8(%ebp),%eax
  803731:	89 10                	mov    %edx,(%eax)
  803733:	8b 45 08             	mov    0x8(%ebp),%eax
  803736:	8b 00                	mov    (%eax),%eax
  803738:	85 c0                	test   %eax,%eax
  80373a:	74 0d                	je     803749 <insert_sorted_with_merge_freeList+0x6fa>
  80373c:	a1 48 51 80 00       	mov    0x805148,%eax
  803741:	8b 55 08             	mov    0x8(%ebp),%edx
  803744:	89 50 04             	mov    %edx,0x4(%eax)
  803747:	eb 08                	jmp    803751 <insert_sorted_with_merge_freeList+0x702>
  803749:	8b 45 08             	mov    0x8(%ebp),%eax
  80374c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803751:	8b 45 08             	mov    0x8(%ebp),%eax
  803754:	a3 48 51 80 00       	mov    %eax,0x805148
  803759:	8b 45 08             	mov    0x8(%ebp),%eax
  80375c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803763:	a1 54 51 80 00       	mov    0x805154,%eax
  803768:	40                   	inc    %eax
  803769:	a3 54 51 80 00       	mov    %eax,0x805154
								break;
  80376e:	eb 38                	jmp    8037a8 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  803770:	a1 40 51 80 00       	mov    0x805140,%eax
  803775:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803778:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80377c:	74 07                	je     803785 <insert_sorted_with_merge_freeList+0x736>
  80377e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803781:	8b 00                	mov    (%eax),%eax
  803783:	eb 05                	jmp    80378a <insert_sorted_with_merge_freeList+0x73b>
  803785:	b8 00 00 00 00       	mov    $0x0,%eax
  80378a:	a3 40 51 80 00       	mov    %eax,0x805140
  80378f:	a1 40 51 80 00       	mov    0x805140,%eax
  803794:	85 c0                	test   %eax,%eax
  803796:	0f 85 a7 fb ff ff    	jne    803343 <insert_sorted_with_merge_freeList+0x2f4>
  80379c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037a0:	0f 85 9d fb ff ff    	jne    803343 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  8037a6:	eb 00                	jmp    8037a8 <insert_sorted_with_merge_freeList+0x759>
  8037a8:	90                   	nop
  8037a9:	c9                   	leave  
  8037aa:	c3                   	ret    
  8037ab:	90                   	nop

008037ac <__udivdi3>:
  8037ac:	55                   	push   %ebp
  8037ad:	57                   	push   %edi
  8037ae:	56                   	push   %esi
  8037af:	53                   	push   %ebx
  8037b0:	83 ec 1c             	sub    $0x1c,%esp
  8037b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8037b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8037bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8037c3:	89 ca                	mov    %ecx,%edx
  8037c5:	89 f8                	mov    %edi,%eax
  8037c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8037cb:	85 f6                	test   %esi,%esi
  8037cd:	75 2d                	jne    8037fc <__udivdi3+0x50>
  8037cf:	39 cf                	cmp    %ecx,%edi
  8037d1:	77 65                	ja     803838 <__udivdi3+0x8c>
  8037d3:	89 fd                	mov    %edi,%ebp
  8037d5:	85 ff                	test   %edi,%edi
  8037d7:	75 0b                	jne    8037e4 <__udivdi3+0x38>
  8037d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8037de:	31 d2                	xor    %edx,%edx
  8037e0:	f7 f7                	div    %edi
  8037e2:	89 c5                	mov    %eax,%ebp
  8037e4:	31 d2                	xor    %edx,%edx
  8037e6:	89 c8                	mov    %ecx,%eax
  8037e8:	f7 f5                	div    %ebp
  8037ea:	89 c1                	mov    %eax,%ecx
  8037ec:	89 d8                	mov    %ebx,%eax
  8037ee:	f7 f5                	div    %ebp
  8037f0:	89 cf                	mov    %ecx,%edi
  8037f2:	89 fa                	mov    %edi,%edx
  8037f4:	83 c4 1c             	add    $0x1c,%esp
  8037f7:	5b                   	pop    %ebx
  8037f8:	5e                   	pop    %esi
  8037f9:	5f                   	pop    %edi
  8037fa:	5d                   	pop    %ebp
  8037fb:	c3                   	ret    
  8037fc:	39 ce                	cmp    %ecx,%esi
  8037fe:	77 28                	ja     803828 <__udivdi3+0x7c>
  803800:	0f bd fe             	bsr    %esi,%edi
  803803:	83 f7 1f             	xor    $0x1f,%edi
  803806:	75 40                	jne    803848 <__udivdi3+0x9c>
  803808:	39 ce                	cmp    %ecx,%esi
  80380a:	72 0a                	jb     803816 <__udivdi3+0x6a>
  80380c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803810:	0f 87 9e 00 00 00    	ja     8038b4 <__udivdi3+0x108>
  803816:	b8 01 00 00 00       	mov    $0x1,%eax
  80381b:	89 fa                	mov    %edi,%edx
  80381d:	83 c4 1c             	add    $0x1c,%esp
  803820:	5b                   	pop    %ebx
  803821:	5e                   	pop    %esi
  803822:	5f                   	pop    %edi
  803823:	5d                   	pop    %ebp
  803824:	c3                   	ret    
  803825:	8d 76 00             	lea    0x0(%esi),%esi
  803828:	31 ff                	xor    %edi,%edi
  80382a:	31 c0                	xor    %eax,%eax
  80382c:	89 fa                	mov    %edi,%edx
  80382e:	83 c4 1c             	add    $0x1c,%esp
  803831:	5b                   	pop    %ebx
  803832:	5e                   	pop    %esi
  803833:	5f                   	pop    %edi
  803834:	5d                   	pop    %ebp
  803835:	c3                   	ret    
  803836:	66 90                	xchg   %ax,%ax
  803838:	89 d8                	mov    %ebx,%eax
  80383a:	f7 f7                	div    %edi
  80383c:	31 ff                	xor    %edi,%edi
  80383e:	89 fa                	mov    %edi,%edx
  803840:	83 c4 1c             	add    $0x1c,%esp
  803843:	5b                   	pop    %ebx
  803844:	5e                   	pop    %esi
  803845:	5f                   	pop    %edi
  803846:	5d                   	pop    %ebp
  803847:	c3                   	ret    
  803848:	bd 20 00 00 00       	mov    $0x20,%ebp
  80384d:	89 eb                	mov    %ebp,%ebx
  80384f:	29 fb                	sub    %edi,%ebx
  803851:	89 f9                	mov    %edi,%ecx
  803853:	d3 e6                	shl    %cl,%esi
  803855:	89 c5                	mov    %eax,%ebp
  803857:	88 d9                	mov    %bl,%cl
  803859:	d3 ed                	shr    %cl,%ebp
  80385b:	89 e9                	mov    %ebp,%ecx
  80385d:	09 f1                	or     %esi,%ecx
  80385f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803863:	89 f9                	mov    %edi,%ecx
  803865:	d3 e0                	shl    %cl,%eax
  803867:	89 c5                	mov    %eax,%ebp
  803869:	89 d6                	mov    %edx,%esi
  80386b:	88 d9                	mov    %bl,%cl
  80386d:	d3 ee                	shr    %cl,%esi
  80386f:	89 f9                	mov    %edi,%ecx
  803871:	d3 e2                	shl    %cl,%edx
  803873:	8b 44 24 08          	mov    0x8(%esp),%eax
  803877:	88 d9                	mov    %bl,%cl
  803879:	d3 e8                	shr    %cl,%eax
  80387b:	09 c2                	or     %eax,%edx
  80387d:	89 d0                	mov    %edx,%eax
  80387f:	89 f2                	mov    %esi,%edx
  803881:	f7 74 24 0c          	divl   0xc(%esp)
  803885:	89 d6                	mov    %edx,%esi
  803887:	89 c3                	mov    %eax,%ebx
  803889:	f7 e5                	mul    %ebp
  80388b:	39 d6                	cmp    %edx,%esi
  80388d:	72 19                	jb     8038a8 <__udivdi3+0xfc>
  80388f:	74 0b                	je     80389c <__udivdi3+0xf0>
  803891:	89 d8                	mov    %ebx,%eax
  803893:	31 ff                	xor    %edi,%edi
  803895:	e9 58 ff ff ff       	jmp    8037f2 <__udivdi3+0x46>
  80389a:	66 90                	xchg   %ax,%ax
  80389c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8038a0:	89 f9                	mov    %edi,%ecx
  8038a2:	d3 e2                	shl    %cl,%edx
  8038a4:	39 c2                	cmp    %eax,%edx
  8038a6:	73 e9                	jae    803891 <__udivdi3+0xe5>
  8038a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8038ab:	31 ff                	xor    %edi,%edi
  8038ad:	e9 40 ff ff ff       	jmp    8037f2 <__udivdi3+0x46>
  8038b2:	66 90                	xchg   %ax,%ax
  8038b4:	31 c0                	xor    %eax,%eax
  8038b6:	e9 37 ff ff ff       	jmp    8037f2 <__udivdi3+0x46>
  8038bb:	90                   	nop

008038bc <__umoddi3>:
  8038bc:	55                   	push   %ebp
  8038bd:	57                   	push   %edi
  8038be:	56                   	push   %esi
  8038bf:	53                   	push   %ebx
  8038c0:	83 ec 1c             	sub    $0x1c,%esp
  8038c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8038c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8038cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8038d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8038d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8038db:	89 f3                	mov    %esi,%ebx
  8038dd:	89 fa                	mov    %edi,%edx
  8038df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038e3:	89 34 24             	mov    %esi,(%esp)
  8038e6:	85 c0                	test   %eax,%eax
  8038e8:	75 1a                	jne    803904 <__umoddi3+0x48>
  8038ea:	39 f7                	cmp    %esi,%edi
  8038ec:	0f 86 a2 00 00 00    	jbe    803994 <__umoddi3+0xd8>
  8038f2:	89 c8                	mov    %ecx,%eax
  8038f4:	89 f2                	mov    %esi,%edx
  8038f6:	f7 f7                	div    %edi
  8038f8:	89 d0                	mov    %edx,%eax
  8038fa:	31 d2                	xor    %edx,%edx
  8038fc:	83 c4 1c             	add    $0x1c,%esp
  8038ff:	5b                   	pop    %ebx
  803900:	5e                   	pop    %esi
  803901:	5f                   	pop    %edi
  803902:	5d                   	pop    %ebp
  803903:	c3                   	ret    
  803904:	39 f0                	cmp    %esi,%eax
  803906:	0f 87 ac 00 00 00    	ja     8039b8 <__umoddi3+0xfc>
  80390c:	0f bd e8             	bsr    %eax,%ebp
  80390f:	83 f5 1f             	xor    $0x1f,%ebp
  803912:	0f 84 ac 00 00 00    	je     8039c4 <__umoddi3+0x108>
  803918:	bf 20 00 00 00       	mov    $0x20,%edi
  80391d:	29 ef                	sub    %ebp,%edi
  80391f:	89 fe                	mov    %edi,%esi
  803921:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803925:	89 e9                	mov    %ebp,%ecx
  803927:	d3 e0                	shl    %cl,%eax
  803929:	89 d7                	mov    %edx,%edi
  80392b:	89 f1                	mov    %esi,%ecx
  80392d:	d3 ef                	shr    %cl,%edi
  80392f:	09 c7                	or     %eax,%edi
  803931:	89 e9                	mov    %ebp,%ecx
  803933:	d3 e2                	shl    %cl,%edx
  803935:	89 14 24             	mov    %edx,(%esp)
  803938:	89 d8                	mov    %ebx,%eax
  80393a:	d3 e0                	shl    %cl,%eax
  80393c:	89 c2                	mov    %eax,%edx
  80393e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803942:	d3 e0                	shl    %cl,%eax
  803944:	89 44 24 04          	mov    %eax,0x4(%esp)
  803948:	8b 44 24 08          	mov    0x8(%esp),%eax
  80394c:	89 f1                	mov    %esi,%ecx
  80394e:	d3 e8                	shr    %cl,%eax
  803950:	09 d0                	or     %edx,%eax
  803952:	d3 eb                	shr    %cl,%ebx
  803954:	89 da                	mov    %ebx,%edx
  803956:	f7 f7                	div    %edi
  803958:	89 d3                	mov    %edx,%ebx
  80395a:	f7 24 24             	mull   (%esp)
  80395d:	89 c6                	mov    %eax,%esi
  80395f:	89 d1                	mov    %edx,%ecx
  803961:	39 d3                	cmp    %edx,%ebx
  803963:	0f 82 87 00 00 00    	jb     8039f0 <__umoddi3+0x134>
  803969:	0f 84 91 00 00 00    	je     803a00 <__umoddi3+0x144>
  80396f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803973:	29 f2                	sub    %esi,%edx
  803975:	19 cb                	sbb    %ecx,%ebx
  803977:	89 d8                	mov    %ebx,%eax
  803979:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80397d:	d3 e0                	shl    %cl,%eax
  80397f:	89 e9                	mov    %ebp,%ecx
  803981:	d3 ea                	shr    %cl,%edx
  803983:	09 d0                	or     %edx,%eax
  803985:	89 e9                	mov    %ebp,%ecx
  803987:	d3 eb                	shr    %cl,%ebx
  803989:	89 da                	mov    %ebx,%edx
  80398b:	83 c4 1c             	add    $0x1c,%esp
  80398e:	5b                   	pop    %ebx
  80398f:	5e                   	pop    %esi
  803990:	5f                   	pop    %edi
  803991:	5d                   	pop    %ebp
  803992:	c3                   	ret    
  803993:	90                   	nop
  803994:	89 fd                	mov    %edi,%ebp
  803996:	85 ff                	test   %edi,%edi
  803998:	75 0b                	jne    8039a5 <__umoddi3+0xe9>
  80399a:	b8 01 00 00 00       	mov    $0x1,%eax
  80399f:	31 d2                	xor    %edx,%edx
  8039a1:	f7 f7                	div    %edi
  8039a3:	89 c5                	mov    %eax,%ebp
  8039a5:	89 f0                	mov    %esi,%eax
  8039a7:	31 d2                	xor    %edx,%edx
  8039a9:	f7 f5                	div    %ebp
  8039ab:	89 c8                	mov    %ecx,%eax
  8039ad:	f7 f5                	div    %ebp
  8039af:	89 d0                	mov    %edx,%eax
  8039b1:	e9 44 ff ff ff       	jmp    8038fa <__umoddi3+0x3e>
  8039b6:	66 90                	xchg   %ax,%ax
  8039b8:	89 c8                	mov    %ecx,%eax
  8039ba:	89 f2                	mov    %esi,%edx
  8039bc:	83 c4 1c             	add    $0x1c,%esp
  8039bf:	5b                   	pop    %ebx
  8039c0:	5e                   	pop    %esi
  8039c1:	5f                   	pop    %edi
  8039c2:	5d                   	pop    %ebp
  8039c3:	c3                   	ret    
  8039c4:	3b 04 24             	cmp    (%esp),%eax
  8039c7:	72 06                	jb     8039cf <__umoddi3+0x113>
  8039c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8039cd:	77 0f                	ja     8039de <__umoddi3+0x122>
  8039cf:	89 f2                	mov    %esi,%edx
  8039d1:	29 f9                	sub    %edi,%ecx
  8039d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8039d7:	89 14 24             	mov    %edx,(%esp)
  8039da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8039e2:	8b 14 24             	mov    (%esp),%edx
  8039e5:	83 c4 1c             	add    $0x1c,%esp
  8039e8:	5b                   	pop    %ebx
  8039e9:	5e                   	pop    %esi
  8039ea:	5f                   	pop    %edi
  8039eb:	5d                   	pop    %ebp
  8039ec:	c3                   	ret    
  8039ed:	8d 76 00             	lea    0x0(%esi),%esi
  8039f0:	2b 04 24             	sub    (%esp),%eax
  8039f3:	19 fa                	sbb    %edi,%edx
  8039f5:	89 d1                	mov    %edx,%ecx
  8039f7:	89 c6                	mov    %eax,%esi
  8039f9:	e9 71 ff ff ff       	jmp    80396f <__umoddi3+0xb3>
  8039fe:	66 90                	xchg   %ax,%ax
  803a00:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803a04:	72 ea                	jb     8039f0 <__umoddi3+0x134>
  803a06:	89 d9                	mov    %ebx,%ecx
  803a08:	e9 62 ff ff ff       	jmp    80396f <__umoddi3+0xb3>
