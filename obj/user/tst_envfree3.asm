
obj/user/tst_envfree3:     file format elf32-i386


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
  800031:	e8 5f 01 00 00       	call   800195 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 3: Freeing the allocated shared variables [covers: smalloc (1 env) & sget (multiple envs)]
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 00 33 80 00       	push   $0x803300
  80004a:	e8 b1 15 00 00       	call   801600 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 7c 18 00 00       	call   8018df <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 14 19 00 00       	call   80197f <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 10 33 80 00       	push   $0x803310
  800079:	e8 07 05 00 00       	call   800585 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 43 33 80 00       	push   $0x803343
  800099:	e8 b3 1a 00 00       	call   801b51 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", 2000,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	68 d0 07 00 00       	push   $0x7d0
  8000b7:	68 4c 33 80 00       	push   $0x80334c
  8000bc:	e8 90 1a 00 00       	call   801b51 <sys_create_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 9d 1a 00 00       	call   801b6f <sys_run_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
	env_sleep(5000) ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 88 13 00 00       	push   $0x1388
  8000dd:	e8 f7 2e 00 00       	call   802fd9 <env_sleep>
  8000e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000eb:	e8 7f 1a 00 00       	call   801b6f <sys_run_env>
  8000f0:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f3:	90                   	nop
  8000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	83 f8 02             	cmp    $0x2,%eax
  8000fc:	75 f6                	jne    8000f4 <_main+0xbc>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fe:	e8 dc 17 00 00       	call   8018df <sys_calculate_free_frames>
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	50                   	push   %eax
  800107:	68 58 33 80 00       	push   $0x803358
  80010c:	e8 74 04 00 00       	call   800585 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 e8             	pushl  -0x18(%ebp)
  80011a:	e8 6c 1a 00 00       	call   801b8b <sys_destroy_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 e4             	pushl  -0x1c(%ebp)
  800128:	e8 5e 1a 00 00       	call   801b8b <sys_destroy_env>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800130:	e8 aa 17 00 00       	call   8018df <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800138:	e8 42 18 00 00       	call   80197f <sys_pf_calculate_allocated_pages>
  80013d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800146:	74 27                	je     80016f <_main+0x137>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 e0             	pushl  -0x20(%ebp)
  80014e:	68 8c 33 80 00       	push   $0x80338c
  800153:	e8 2d 04 00 00       	call   800585 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 dc 33 80 00       	push   $0x8033dc
  800163:	6a 23                	push   $0x23
  800165:	68 12 34 80 00       	push   $0x803412
  80016a:	e8 62 01 00 00       	call   8002d1 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 e0             	pushl  -0x20(%ebp)
  800175:	68 28 34 80 00       	push   $0x803428
  80017a:	e8 06 04 00 00       	call   800585 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 88 34 80 00       	push   $0x803488
  80018a:	e8 f6 03 00 00       	call   800585 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
	return;
  800192:	90                   	nop
}
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80019b:	e8 1f 1a 00 00       	call   801bbf <sys_getenvindex>
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a6:	89 d0                	mov    %edx,%eax
  8001a8:	c1 e0 03             	shl    $0x3,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	01 c0                	add    %eax,%eax
  8001af:	01 d0                	add    %edx,%eax
  8001b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b8:	01 d0                	add    %edx,%eax
  8001ba:	c1 e0 04             	shl    $0x4,%eax
  8001bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c2:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001d2:	84 c0                	test   %al,%al
  8001d4:	74 0f                	je     8001e5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001db:	05 5c 05 00 00       	add    $0x55c,%eax
  8001e0:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e9:	7e 0a                	jle    8001f5 <libmain+0x60>
		binaryname = argv[0];
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 0c             	pushl  0xc(%ebp)
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	e8 35 fe ff ff       	call   800038 <_main>
  800203:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800206:	e8 c1 17 00 00       	call   8019cc <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 ec 34 80 00       	push   $0x8034ec
  800213:	e8 6d 03 00 00       	call   800585 <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80021b:	a1 20 40 80 00       	mov    0x804020,%eax
  800220:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800226:	a1 20 40 80 00       	mov    0x804020,%eax
  80022b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800231:	83 ec 04             	sub    $0x4,%esp
  800234:	52                   	push   %edx
  800235:	50                   	push   %eax
  800236:	68 14 35 80 00       	push   $0x803514
  80023b:	e8 45 03 00 00       	call   800585 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800243:	a1 20 40 80 00       	mov    0x804020,%eax
  800248:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024e:	a1 20 40 80 00       	mov    0x804020,%eax
  800253:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800259:	a1 20 40 80 00       	mov    0x804020,%eax
  80025e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800264:	51                   	push   %ecx
  800265:	52                   	push   %edx
  800266:	50                   	push   %eax
  800267:	68 3c 35 80 00       	push   $0x80353c
  80026c:	e8 14 03 00 00       	call   800585 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	50                   	push   %eax
  800283:	68 94 35 80 00       	push   $0x803594
  800288:	e8 f8 02 00 00       	call   800585 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 ec 34 80 00       	push   $0x8034ec
  800298:	e8 e8 02 00 00       	call   800585 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002a0:	e8 41 17 00 00       	call   8019e6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a5:	e8 19 00 00 00       	call   8002c3 <exit>
}
  8002aa:	90                   	nop
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	6a 00                	push   $0x0
  8002b8:	e8 ce 18 00 00       	call   801b8b <sys_destroy_env>
  8002bd:	83 c4 10             	add    $0x10,%esp
}
  8002c0:	90                   	nop
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <exit>:

void
exit(void)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c9:	e8 23 19 00 00       	call   801bf1 <sys_exit_env>
}
  8002ce:	90                   	nop
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8002da:	83 c0 04             	add    $0x4,%eax
  8002dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002e0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002e5:	85 c0                	test   %eax,%eax
  8002e7:	74 16                	je     8002ff <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	50                   	push   %eax
  8002f2:	68 a8 35 80 00       	push   $0x8035a8
  8002f7:	e8 89 02 00 00       	call   800585 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ff:	a1 00 40 80 00       	mov    0x804000,%eax
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	50                   	push   %eax
  80030b:	68 ad 35 80 00       	push   $0x8035ad
  800310:	e8 70 02 00 00       	call   800585 <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800318:	8b 45 10             	mov    0x10(%ebp),%eax
  80031b:	83 ec 08             	sub    $0x8,%esp
  80031e:	ff 75 f4             	pushl  -0xc(%ebp)
  800321:	50                   	push   %eax
  800322:	e8 f3 01 00 00       	call   80051a <vcprintf>
  800327:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80032a:	83 ec 08             	sub    $0x8,%esp
  80032d:	6a 00                	push   $0x0
  80032f:	68 c9 35 80 00       	push   $0x8035c9
  800334:	e8 e1 01 00 00       	call   80051a <vcprintf>
  800339:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80033c:	e8 82 ff ff ff       	call   8002c3 <exit>

	// should not return here
	while (1) ;
  800341:	eb fe                	jmp    800341 <_panic+0x70>

00800343 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800349:	a1 20 40 80 00       	mov    0x804020,%eax
  80034e:	8b 50 74             	mov    0x74(%eax),%edx
  800351:	8b 45 0c             	mov    0xc(%ebp),%eax
  800354:	39 c2                	cmp    %eax,%edx
  800356:	74 14                	je     80036c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 cc 35 80 00       	push   $0x8035cc
  800360:	6a 26                	push   $0x26
  800362:	68 18 36 80 00       	push   $0x803618
  800367:	e8 65 ff ff ff       	call   8002d1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80036c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800373:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80037a:	e9 c2 00 00 00       	jmp    800441 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800382:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	8b 00                	mov    (%eax),%eax
  800390:	85 c0                	test   %eax,%eax
  800392:	75 08                	jne    80039c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800394:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800397:	e9 a2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80039c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003aa:	eb 69                	jmp    800415 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ba:	89 d0                	mov    %edx,%eax
  8003bc:	01 c0                	add    %eax,%eax
  8003be:	01 d0                	add    %edx,%eax
  8003c0:	c1 e0 03             	shl    $0x3,%eax
  8003c3:	01 c8                	add    %ecx,%eax
  8003c5:	8a 40 04             	mov    0x4(%eax),%al
  8003c8:	84 c0                	test   %al,%al
  8003ca:	75 46                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003da:	89 d0                	mov    %edx,%eax
  8003dc:	01 c0                	add    %eax,%eax
  8003de:	01 d0                	add    %edx,%eax
  8003e0:	c1 e0 03             	shl    $0x3,%eax
  8003e3:	01 c8                	add    %ecx,%eax
  8003e5:	8b 00                	mov    (%eax),%eax
  8003e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003f2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	01 c8                	add    %ecx,%eax
  800403:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800405:	39 c2                	cmp    %eax,%edx
  800407:	75 09                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800409:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800410:	eb 12                	jmp    800424 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800412:	ff 45 e8             	incl   -0x18(%ebp)
  800415:	a1 20 40 80 00       	mov    0x804020,%eax
  80041a:	8b 50 74             	mov    0x74(%eax),%edx
  80041d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	77 88                	ja     8003ac <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800424:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800428:	75 14                	jne    80043e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80042a:	83 ec 04             	sub    $0x4,%esp
  80042d:	68 24 36 80 00       	push   $0x803624
  800432:	6a 3a                	push   $0x3a
  800434:	68 18 36 80 00       	push   $0x803618
  800439:	e8 93 fe ff ff       	call   8002d1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043e:	ff 45 f0             	incl   -0x10(%ebp)
  800441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800444:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800447:	0f 8c 32 ff ff ff    	jl     80037f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800454:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80045b:	eb 26                	jmp    800483 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045d:	a1 20 40 80 00       	mov    0x804020,%eax
  800462:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800468:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80046b:	89 d0                	mov    %edx,%eax
  80046d:	01 c0                	add    %eax,%eax
  80046f:	01 d0                	add    %edx,%eax
  800471:	c1 e0 03             	shl    $0x3,%eax
  800474:	01 c8                	add    %ecx,%eax
  800476:	8a 40 04             	mov    0x4(%eax),%al
  800479:	3c 01                	cmp    $0x1,%al
  80047b:	75 03                	jne    800480 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800480:	ff 45 e0             	incl   -0x20(%ebp)
  800483:	a1 20 40 80 00       	mov    0x804020,%eax
  800488:	8b 50 74             	mov    0x74(%eax),%edx
  80048b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048e:	39 c2                	cmp    %eax,%edx
  800490:	77 cb                	ja     80045d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800495:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800498:	74 14                	je     8004ae <CheckWSWithoutLastIndex+0x16b>
		panic(
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 78 36 80 00       	push   $0x803678
  8004a2:	6a 44                	push   $0x44
  8004a4:	68 18 36 80 00       	push   $0x803618
  8004a9:	e8 23 fe ff ff       	call   8002d1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ae:	90                   	nop
  8004af:	c9                   	leave  
  8004b0:	c3                   	ret    

008004b1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c2:	89 0a                	mov    %ecx,(%edx)
  8004c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c7:	88 d1                	mov    %dl,%cl
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004da:	75 2c                	jne    800508 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004dc:	a0 24 40 80 00       	mov    0x804024,%al
  8004e1:	0f b6 c0             	movzbl %al,%eax
  8004e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e7:	8b 12                	mov    (%edx),%edx
  8004e9:	89 d1                	mov    %edx,%ecx
  8004eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ee:	83 c2 08             	add    $0x8,%edx
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	50                   	push   %eax
  8004f5:	51                   	push   %ecx
  8004f6:	52                   	push   %edx
  8004f7:	e8 22 13 00 00       	call   80181e <sys_cputs>
  8004fc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	8b 40 04             	mov    0x4(%eax),%eax
  80050e:	8d 50 01             	lea    0x1(%eax),%edx
  800511:	8b 45 0c             	mov    0xc(%ebp),%eax
  800514:	89 50 04             	mov    %edx,0x4(%eax)
}
  800517:	90                   	nop
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800523:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80052a:	00 00 00 
	b.cnt = 0;
  80052d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800534:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	ff 75 08             	pushl  0x8(%ebp)
  80053d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800543:	50                   	push   %eax
  800544:	68 b1 04 80 00       	push   $0x8004b1
  800549:	e8 11 02 00 00       	call   80075f <vprintfmt>
  80054e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800551:	a0 24 40 80 00       	mov    0x804024,%al
  800556:	0f b6 c0             	movzbl %al,%eax
  800559:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	50                   	push   %eax
  800563:	52                   	push   %edx
  800564:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80056a:	83 c0 08             	add    $0x8,%eax
  80056d:	50                   	push   %eax
  80056e:	e8 ab 12 00 00       	call   80181e <sys_cputs>
  800573:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800576:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80057d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <cprintf>:

int cprintf(const char *fmt, ...) {
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80058b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800592:	8d 45 0c             	lea    0xc(%ebp),%eax
  800595:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a1:	50                   	push   %eax
  8005a2:	e8 73 ff ff ff       	call   80051a <vcprintf>
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b8:	e8 0f 14 00 00       	call   8019cc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cc:	50                   	push   %eax
  8005cd:	e8 48 ff ff ff       	call   80051a <vcprintf>
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d8:	e8 09 14 00 00       	call   8019e6 <sys_enable_interrupt>
	return cnt;
  8005dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e0:	c9                   	leave  
  8005e1:	c3                   	ret    

008005e2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	53                   	push   %ebx
  8005e6:	83 ec 14             	sub    $0x14,%esp
  8005e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800600:	77 55                	ja     800657 <printnum+0x75>
  800602:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800605:	72 05                	jb     80060c <printnum+0x2a>
  800607:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80060a:	77 4b                	ja     800657 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800612:	8b 45 18             	mov    0x18(%ebp),%eax
  800615:	ba 00 00 00 00       	mov    $0x0,%edx
  80061a:	52                   	push   %edx
  80061b:	50                   	push   %eax
  80061c:	ff 75 f4             	pushl  -0xc(%ebp)
  80061f:	ff 75 f0             	pushl  -0x10(%ebp)
  800622:	e8 69 2a 00 00       	call   803090 <__udivdi3>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	83 ec 04             	sub    $0x4,%esp
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	53                   	push   %ebx
  800631:	ff 75 18             	pushl  0x18(%ebp)
  800634:	52                   	push   %edx
  800635:	50                   	push   %eax
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	ff 75 08             	pushl  0x8(%ebp)
  80063c:	e8 a1 ff ff ff       	call   8005e2 <printnum>
  800641:	83 c4 20             	add    $0x20,%esp
  800644:	eb 1a                	jmp    800660 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	ff 75 20             	pushl  0x20(%ebp)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	ff d0                	call   *%eax
  800654:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800657:	ff 4d 1c             	decl   0x1c(%ebp)
  80065a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065e:	7f e6                	jg     800646 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800660:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800663:	bb 00 00 00 00       	mov    $0x0,%ebx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066e:	53                   	push   %ebx
  80066f:	51                   	push   %ecx
  800670:	52                   	push   %edx
  800671:	50                   	push   %eax
  800672:	e8 29 2b 00 00       	call   8031a0 <__umoddi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	05 f4 38 80 00       	add    $0x8038f4,%eax
  80067f:	8a 00                	mov    (%eax),%al
  800681:	0f be c0             	movsbl %al,%eax
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	50                   	push   %eax
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	ff d0                	call   *%eax
  800690:	83 c4 10             	add    $0x10,%esp
}
  800693:	90                   	nop
  800694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800697:	c9                   	leave  
  800698:	c3                   	ret    

00800699 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a0:	7e 1c                	jle    8006be <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	8d 50 08             	lea    0x8(%eax),%edx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	89 10                	mov    %edx,(%eax)
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	83 e8 08             	sub    $0x8,%eax
  8006b7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	eb 40                	jmp    8006fe <getuint+0x65>
	else if (lflag)
  8006be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c2:	74 1e                	je     8006e2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	8d 50 04             	lea    0x4(%eax),%edx
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	89 10                	mov    %edx,(%eax)
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	83 e8 04             	sub    $0x4,%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e0:	eb 1c                	jmp    8006fe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	89 10                	mov    %edx,(%eax)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	83 e8 04             	sub    $0x4,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fe:	5d                   	pop    %ebp
  8006ff:	c3                   	ret    

00800700 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800703:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800707:	7e 1c                	jle    800725 <getint+0x25>
		return va_arg(*ap, long long);
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	8d 50 08             	lea    0x8(%eax),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	89 10                	mov    %edx,(%eax)
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	83 e8 08             	sub    $0x8,%eax
  80071e:	8b 50 04             	mov    0x4(%eax),%edx
  800721:	8b 00                	mov    (%eax),%eax
  800723:	eb 38                	jmp    80075d <getint+0x5d>
	else if (lflag)
  800725:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800729:	74 1a                	je     800745 <getint+0x45>
		return va_arg(*ap, long);
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	8d 50 04             	lea    0x4(%eax),%edx
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	89 10                	mov    %edx,(%eax)
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	83 e8 04             	sub    $0x4,%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	99                   	cltd   
  800743:	eb 18                	jmp    80075d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	8d 50 04             	lea    0x4(%eax),%edx
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	89 10                	mov    %edx,(%eax)
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	83 e8 04             	sub    $0x4,%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	99                   	cltd   
}
  80075d:	5d                   	pop    %ebp
  80075e:	c3                   	ret    

0080075f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	56                   	push   %esi
  800763:	53                   	push   %ebx
  800764:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800767:	eb 17                	jmp    800780 <vprintfmt+0x21>
			if (ch == '\0')
  800769:	85 db                	test   %ebx,%ebx
  80076b:	0f 84 af 03 00 00    	je     800b20 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	53                   	push   %ebx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	ff d0                	call   *%eax
  80077d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800780:	8b 45 10             	mov    0x10(%ebp),%eax
  800783:	8d 50 01             	lea    0x1(%eax),%edx
  800786:	89 55 10             	mov    %edx,0x10(%ebp)
  800789:	8a 00                	mov    (%eax),%al
  80078b:	0f b6 d8             	movzbl %al,%ebx
  80078e:	83 fb 25             	cmp    $0x25,%ebx
  800791:	75 d6                	jne    800769 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800793:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800797:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b6:	8d 50 01             	lea    0x1(%eax),%edx
  8007b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8007bc:	8a 00                	mov    (%eax),%al
  8007be:	0f b6 d8             	movzbl %al,%ebx
  8007c1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c4:	83 f8 55             	cmp    $0x55,%eax
  8007c7:	0f 87 2b 03 00 00    	ja     800af8 <vprintfmt+0x399>
  8007cd:	8b 04 85 18 39 80 00 	mov    0x803918(,%eax,4),%eax
  8007d4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007da:	eb d7                	jmp    8007b3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007dc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007e0:	eb d1                	jmp    8007b3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ec:	89 d0                	mov    %edx,%eax
  8007ee:	c1 e0 02             	shl    $0x2,%eax
  8007f1:	01 d0                	add    %edx,%eax
  8007f3:	01 c0                	add    %eax,%eax
  8007f5:	01 d8                	add    %ebx,%eax
  8007f7:	83 e8 30             	sub    $0x30,%eax
  8007fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800805:	83 fb 2f             	cmp    $0x2f,%ebx
  800808:	7e 3e                	jle    800848 <vprintfmt+0xe9>
  80080a:	83 fb 39             	cmp    $0x39,%ebx
  80080d:	7f 39                	jg     800848 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800812:	eb d5                	jmp    8007e9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	83 c0 04             	add    $0x4,%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	83 e8 04             	sub    $0x4,%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800828:	eb 1f                	jmp    800849 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	79 83                	jns    8007b3 <vprintfmt+0x54>
				width = 0;
  800830:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800837:	e9 77 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80083c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800843:	e9 6b ff ff ff       	jmp    8007b3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800848:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800849:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084d:	0f 89 60 ff ff ff    	jns    8007b3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800856:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800859:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800860:	e9 4e ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800865:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800868:	e9 46 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	83 c0 04             	add    $0x4,%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 e8 04             	sub    $0x4,%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	50                   	push   %eax
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			break;
  80088d:	e9 89 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 c0 04             	add    $0x4,%eax
  800898:	89 45 14             	mov    %eax,0x14(%ebp)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a3:	85 db                	test   %ebx,%ebx
  8008a5:	79 02                	jns    8008a9 <vprintfmt+0x14a>
				err = -err;
  8008a7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a9:	83 fb 64             	cmp    $0x64,%ebx
  8008ac:	7f 0b                	jg     8008b9 <vprintfmt+0x15a>
  8008ae:	8b 34 9d 60 37 80 00 	mov    0x803760(,%ebx,4),%esi
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 19                	jne    8008d2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b9:	53                   	push   %ebx
  8008ba:	68 05 39 80 00       	push   $0x803905
  8008bf:	ff 75 0c             	pushl  0xc(%ebp)
  8008c2:	ff 75 08             	pushl  0x8(%ebp)
  8008c5:	e8 5e 02 00 00       	call   800b28 <printfmt>
  8008ca:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008cd:	e9 49 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008d2:	56                   	push   %esi
  8008d3:	68 0e 39 80 00       	push   $0x80390e
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	ff 75 08             	pushl  0x8(%ebp)
  8008de:	e8 45 02 00 00       	call   800b28 <printfmt>
  8008e3:	83 c4 10             	add    $0x10,%esp
			break;
  8008e6:	e9 30 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	83 c0 04             	add    $0x4,%eax
  8008f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 30                	mov    (%eax),%esi
  8008fc:	85 f6                	test   %esi,%esi
  8008fe:	75 05                	jne    800905 <vprintfmt+0x1a6>
				p = "(null)";
  800900:	be 11 39 80 00       	mov    $0x803911,%esi
			if (width > 0 && padc != '-')
  800905:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800909:	7e 6d                	jle    800978 <vprintfmt+0x219>
  80090b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090f:	74 67                	je     800978 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800911:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	50                   	push   %eax
  800918:	56                   	push   %esi
  800919:	e8 0c 03 00 00       	call   800c2a <strnlen>
  80091e:	83 c4 10             	add    $0x10,%esp
  800921:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800924:	eb 16                	jmp    80093c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800926:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	50                   	push   %eax
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	ff d0                	call   *%eax
  800936:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800939:	ff 4d e4             	decl   -0x1c(%ebp)
  80093c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800940:	7f e4                	jg     800926 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800942:	eb 34                	jmp    800978 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800944:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800948:	74 1c                	je     800966 <vprintfmt+0x207>
  80094a:	83 fb 1f             	cmp    $0x1f,%ebx
  80094d:	7e 05                	jle    800954 <vprintfmt+0x1f5>
  80094f:	83 fb 7e             	cmp    $0x7e,%ebx
  800952:	7e 12                	jle    800966 <vprintfmt+0x207>
					putch('?', putdat);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	6a 3f                	push   $0x3f
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	ff d0                	call   *%eax
  800961:	83 c4 10             	add    $0x10,%esp
  800964:	eb 0f                	jmp    800975 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	53                   	push   %ebx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	ff d0                	call   *%eax
  800972:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800975:	ff 4d e4             	decl   -0x1c(%ebp)
  800978:	89 f0                	mov    %esi,%eax
  80097a:	8d 70 01             	lea    0x1(%eax),%esi
  80097d:	8a 00                	mov    (%eax),%al
  80097f:	0f be d8             	movsbl %al,%ebx
  800982:	85 db                	test   %ebx,%ebx
  800984:	74 24                	je     8009aa <vprintfmt+0x24b>
  800986:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80098a:	78 b8                	js     800944 <vprintfmt+0x1e5>
  80098c:	ff 4d e0             	decl   -0x20(%ebp)
  80098f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800993:	79 af                	jns    800944 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800995:	eb 13                	jmp    8009aa <vprintfmt+0x24b>
				putch(' ', putdat);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	6a 20                	push   $0x20
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	ff d0                	call   *%eax
  8009a4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ae:	7f e7                	jg     800997 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009b0:	e9 66 01 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009be:	50                   	push   %eax
  8009bf:	e8 3c fd ff ff       	call   800700 <getint>
  8009c4:	83 c4 10             	add    $0x10,%esp
  8009c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d3:	85 d2                	test   %edx,%edx
  8009d5:	79 23                	jns    8009fa <vprintfmt+0x29b>
				putch('-', putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	6a 2d                	push   $0x2d
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	ff d0                	call   *%eax
  8009e4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ed:	f7 d8                	neg    %eax
  8009ef:	83 d2 00             	adc    $0x0,%edx
  8009f2:	f7 da                	neg    %edx
  8009f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a01:	e9 bc 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 e8             	pushl  -0x18(%ebp)
  800a0c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	e8 84 fc ff ff       	call   800699 <getuint>
  800a15:	83 c4 10             	add    $0x10,%esp
  800a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a25:	e9 98 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	ff 75 0c             	pushl  0xc(%ebp)
  800a30:	6a 58                	push   $0x58
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	ff d0                	call   *%eax
  800a37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	6a 58                	push   $0x58
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	ff d0                	call   *%eax
  800a47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	6a 58                	push   $0x58
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	ff d0                	call   *%eax
  800a57:	83 c4 10             	add    $0x10,%esp
			break;
  800a5a:	e9 bc 00 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	6a 30                	push   $0x30
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	ff d0                	call   *%eax
  800a6c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	6a 78                	push   $0x78
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	ff d0                	call   *%eax
  800a7c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	83 c0 04             	add    $0x4,%eax
  800a85:	89 45 14             	mov    %eax,0x14(%ebp)
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	83 e8 04             	sub    $0x4,%eax
  800a8e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a9a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aa1:	eb 1f                	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 e7 fb ff ff       	call   800699 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800abb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac9:	83 ec 04             	sub    $0x4,%esp
  800acc:	52                   	push   %edx
  800acd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ad0:	50                   	push   %eax
  800ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	ff 75 08             	pushl  0x8(%ebp)
  800add:	e8 00 fb ff ff       	call   8005e2 <printnum>
  800ae2:	83 c4 20             	add    $0x20,%esp
			break;
  800ae5:	eb 34                	jmp    800b1b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	53                   	push   %ebx
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	ff d0                	call   *%eax
  800af3:	83 c4 10             	add    $0x10,%esp
			break;
  800af6:	eb 23                	jmp    800b1b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 25                	push   $0x25
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b08:	ff 4d 10             	decl   0x10(%ebp)
  800b0b:	eb 03                	jmp    800b10 <vprintfmt+0x3b1>
  800b0d:	ff 4d 10             	decl   0x10(%ebp)
  800b10:	8b 45 10             	mov    0x10(%ebp),%eax
  800b13:	48                   	dec    %eax
  800b14:	8a 00                	mov    (%eax),%al
  800b16:	3c 25                	cmp    $0x25,%al
  800b18:	75 f3                	jne    800b0d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b1a:	90                   	nop
		}
	}
  800b1b:	e9 47 fc ff ff       	jmp    800767 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b20:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b31:	83 c0 04             	add    $0x4,%eax
  800b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b37:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3d:	50                   	push   %eax
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	ff 75 08             	pushl  0x8(%ebp)
  800b44:	e8 16 fc ff ff       	call   80075f <vprintfmt>
  800b49:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b4c:	90                   	nop
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 08             	mov    0x8(%eax),%eax
  800b58:	8d 50 01             	lea    0x1(%eax),%edx
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8b 10                	mov    (%eax),%edx
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8b 40 04             	mov    0x4(%eax),%eax
  800b6c:	39 c2                	cmp    %eax,%edx
  800b6e:	73 12                	jae    800b82 <sprintputch+0x33>
		*b->buf++ = ch;
  800b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b73:	8b 00                	mov    (%eax),%eax
  800b75:	8d 48 01             	lea    0x1(%eax),%ecx
  800b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7b:	89 0a                	mov    %ecx,(%edx)
  800b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b80:	88 10                	mov    %dl,(%eax)
}
  800b82:	90                   	nop
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	01 d0                	add    %edx,%eax
  800b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800baa:	74 06                	je     800bb2 <vsnprintf+0x2d>
  800bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb0:	7f 07                	jg     800bb9 <vsnprintf+0x34>
		return -E_INVAL;
  800bb2:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb7:	eb 20                	jmp    800bd9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb9:	ff 75 14             	pushl  0x14(%ebp)
  800bbc:	ff 75 10             	pushl  0x10(%ebp)
  800bbf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc2:	50                   	push   %eax
  800bc3:	68 4f 0b 80 00       	push   $0x800b4f
  800bc8:	e8 92 fb ff ff       	call   80075f <vprintfmt>
  800bcd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be1:	8d 45 10             	lea    0x10(%ebp),%eax
  800be4:	83 c0 04             	add    $0x4,%eax
  800be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bea:	8b 45 10             	mov    0x10(%ebp),%eax
  800bed:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf0:	50                   	push   %eax
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	ff 75 08             	pushl  0x8(%ebp)
  800bf7:	e8 89 ff ff ff       	call   800b85 <vsnprintf>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c14:	eb 06                	jmp    800c1c <strlen+0x15>
		n++;
  800c16:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c19:	ff 45 08             	incl   0x8(%ebp)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 f1                	jne    800c16 <strlen+0xf>
		n++;
	return n;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 09                	jmp    800c42 <strnlen+0x18>
		n++;
  800c39:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c3c:	ff 45 08             	incl   0x8(%ebp)
  800c3f:	ff 4d 0c             	decl   0xc(%ebp)
  800c42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c46:	74 09                	je     800c51 <strnlen+0x27>
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	84 c0                	test   %al,%al
  800c4f:	75 e8                	jne    800c39 <strnlen+0xf>
		n++;
	return n;
  800c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c62:	90                   	nop
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	84 c0                	test   %al,%al
  800c7d:	75 e4                	jne    800c63 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c97:	eb 1f                	jmp    800cb8 <strncpy+0x34>
		*dst++ = *src;
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8d 50 01             	lea    0x1(%eax),%edx
  800c9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca5:	8a 12                	mov    (%edx),%dl
  800ca7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	74 03                	je     800cb5 <strncpy+0x31>
			src++;
  800cb2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb5:	ff 45 fc             	incl   -0x4(%ebp)
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbe:	72 d9                	jb     800c99 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd5:	74 30                	je     800d07 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd7:	eb 16                	jmp    800cef <strlcpy+0x2a>
			*dst++ = *src++;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8d 50 01             	lea    0x1(%eax),%edx
  800cdf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ceb:	8a 12                	mov    (%edx),%dl
  800ced:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cef:	ff 4d 10             	decl   0x10(%ebp)
  800cf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf6:	74 09                	je     800d01 <strlcpy+0x3c>
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	84 c0                	test   %al,%al
  800cff:	75 d8                	jne    800cd9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d07:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0d:	29 c2                	sub    %eax,%edx
  800d0f:	89 d0                	mov    %edx,%eax
}
  800d11:	c9                   	leave  
  800d12:	c3                   	ret    

00800d13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d16:	eb 06                	jmp    800d1e <strcmp+0xb>
		p++, q++;
  800d18:	ff 45 08             	incl   0x8(%ebp)
  800d1b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strcmp+0x22>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 e3                	je     800d18 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f b6 d0             	movzbl %al,%edx
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	0f b6 c0             	movzbl %al,%eax
  800d45:	29 c2                	sub    %eax,%edx
  800d47:	89 d0                	mov    %edx,%eax
}
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4e:	eb 09                	jmp    800d59 <strncmp+0xe>
		n--, p++, q++;
  800d50:	ff 4d 10             	decl   0x10(%ebp)
  800d53:	ff 45 08             	incl   0x8(%ebp)
  800d56:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5d:	74 17                	je     800d76 <strncmp+0x2b>
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	74 0e                	je     800d76 <strncmp+0x2b>
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 10                	mov    (%eax),%dl
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	38 c2                	cmp    %al,%dl
  800d74:	74 da                	je     800d50 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	75 07                	jne    800d83 <strncmp+0x38>
		return 0;
  800d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d81:	eb 14                	jmp    800d97 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	0f b6 d0             	movzbl %al,%edx
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	0f b6 c0             	movzbl %al,%eax
  800d93:	29 c2                	sub    %eax,%edx
  800d95:	89 d0                	mov    %edx,%eax
}
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 04             	sub    $0x4,%esp
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da5:	eb 12                	jmp    800db9 <strchr+0x20>
		if (*s == c)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800daf:	75 05                	jne    800db6 <strchr+0x1d>
			return (char *) s;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	eb 11                	jmp    800dc7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db6:	ff 45 08             	incl   0x8(%ebp)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	84 c0                	test   %al,%al
  800dc0:	75 e5                	jne    800da7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc7:	c9                   	leave  
  800dc8:	c3                   	ret    

00800dc9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 04             	sub    $0x4,%esp
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd5:	eb 0d                	jmp    800de4 <strfind+0x1b>
		if (*s == c)
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddf:	74 0e                	je     800def <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 ea                	jne    800dd7 <strfind+0xe>
  800ded:	eb 01                	jmp    800df0 <strfind+0x27>
		if (*s == c)
			break;
  800def:	90                   	nop
	return (char *) s;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e01:	8b 45 10             	mov    0x10(%ebp),%eax
  800e04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e07:	eb 0e                	jmp    800e17 <memset+0x22>
		*p++ = c;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0c:	8d 50 01             	lea    0x1(%eax),%edx
  800e0f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e15:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e17:	ff 4d f8             	decl   -0x8(%ebp)
  800e1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1e:	79 e9                	jns    800e09 <memset+0x14>
		*p++ = c;

	return v;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e37:	eb 16                	jmp    800e4f <memcpy+0x2a>
		*d++ = *s++;
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e55:	89 55 10             	mov    %edx,0x10(%ebp)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	75 dd                	jne    800e39 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e79:	73 50                	jae    800ecb <memmove+0x6a>
  800e7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e81:	01 d0                	add    %edx,%eax
  800e83:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e86:	76 43                	jbe    800ecb <memmove+0x6a>
		s += n;
  800e88:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e91:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e94:	eb 10                	jmp    800ea6 <memmove+0x45>
			*--d = *--s;
  800e96:	ff 4d f8             	decl   -0x8(%ebp)
  800e99:	ff 4d fc             	decl   -0x4(%ebp)
  800e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9f:	8a 10                	mov    (%eax),%dl
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eac:	89 55 10             	mov    %edx,0x10(%ebp)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	75 e3                	jne    800e96 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb3:	eb 23                	jmp    800ed8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8d 50 01             	lea    0x1(%eax),%edx
  800ebb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec7:	8a 12                	mov    (%edx),%dl
  800ec9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ece:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	75 dd                	jne    800eb5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eef:	eb 2a                	jmp    800f1b <memcmp+0x3e>
		if (*s1 != *s2)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	38 c2                	cmp    %al,%dl
  800efd:	74 16                	je     800f15 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	0f b6 d0             	movzbl %al,%edx
  800f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	29 c2                	sub    %eax,%edx
  800f11:	89 d0                	mov    %edx,%eax
  800f13:	eb 18                	jmp    800f2d <memcmp+0x50>
		s1++, s2++;
  800f15:	ff 45 fc             	incl   -0x4(%ebp)
  800f18:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 c9                	jne    800ef1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2d:	c9                   	leave  
  800f2e:	c3                   	ret    

00800f2f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f35:	8b 55 08             	mov    0x8(%ebp),%edx
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	01 d0                	add    %edx,%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f40:	eb 15                	jmp    800f57 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 d0             	movzbl %al,%edx
  800f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4d:	0f b6 c0             	movzbl %al,%eax
  800f50:	39 c2                	cmp    %eax,%edx
  800f52:	74 0d                	je     800f61 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5d:	72 e3                	jb     800f42 <memfind+0x13>
  800f5f:	eb 01                	jmp    800f62 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f61:	90                   	nop
	return (void *) s;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f74:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7b:	eb 03                	jmp    800f80 <strtol+0x19>
		s++;
  800f7d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 20                	cmp    $0x20,%al
  800f87:	74 f4                	je     800f7d <strtol+0x16>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 09                	cmp    $0x9,%al
  800f90:	74 eb                	je     800f7d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	3c 2b                	cmp    $0x2b,%al
  800f99:	75 05                	jne    800fa0 <strtol+0x39>
		s++;
  800f9b:	ff 45 08             	incl   0x8(%ebp)
  800f9e:	eb 13                	jmp    800fb3 <strtol+0x4c>
	else if (*s == '-')
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 2d                	cmp    $0x2d,%al
  800fa7:	75 0a                	jne    800fb3 <strtol+0x4c>
		s++, neg = 1;
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	74 06                	je     800fbf <strtol+0x58>
  800fb9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fbd:	75 20                	jne    800fdf <strtol+0x78>
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 30                	cmp    $0x30,%al
  800fc6:	75 17                	jne    800fdf <strtol+0x78>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	40                   	inc    %eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 78                	cmp    $0x78,%al
  800fd0:	75 0d                	jne    800fdf <strtol+0x78>
		s += 2, base = 16;
  800fd2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fdd:	eb 28                	jmp    801007 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 15                	jne    800ffa <strtol+0x93>
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3c 30                	cmp    $0x30,%al
  800fec:	75 0c                	jne    800ffa <strtol+0x93>
		s++, base = 8;
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff8:	eb 0d                	jmp    801007 <strtol+0xa0>
	else if (base == 0)
  800ffa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffe:	75 07                	jne    801007 <strtol+0xa0>
		base = 10;
  801000:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3c 2f                	cmp    $0x2f,%al
  80100e:	7e 19                	jle    801029 <strtol+0xc2>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 39                	cmp    $0x39,%al
  801017:	7f 10                	jg     801029 <strtol+0xc2>
			dig = *s - '0';
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	0f be c0             	movsbl %al,%eax
  801021:	83 e8 30             	sub    $0x30,%eax
  801024:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801027:	eb 42                	jmp    80106b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 60                	cmp    $0x60,%al
  801030:	7e 19                	jle    80104b <strtol+0xe4>
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	3c 7a                	cmp    $0x7a,%al
  801039:	7f 10                	jg     80104b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	0f be c0             	movsbl %al,%eax
  801043:	83 e8 57             	sub    $0x57,%eax
  801046:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801049:	eb 20                	jmp    80106b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 40                	cmp    $0x40,%al
  801052:	7e 39                	jle    80108d <strtol+0x126>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 5a                	cmp    $0x5a,%al
  80105b:	7f 30                	jg     80108d <strtol+0x126>
			dig = *s - 'A' + 10;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 37             	sub    $0x37,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801071:	7d 19                	jge    80108c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801073:	ff 45 08             	incl   0x8(%ebp)
  801076:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801079:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107d:	89 c2                	mov    %eax,%edx
  80107f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801082:	01 d0                	add    %edx,%eax
  801084:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801087:	e9 7b ff ff ff       	jmp    801007 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80108c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801091:	74 08                	je     80109b <strtol+0x134>
		*endptr = (char *) s;
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80109b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109f:	74 07                	je     8010a8 <strtol+0x141>
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	f7 d8                	neg    %eax
  8010a6:	eb 03                	jmp    8010ab <strtol+0x144>
  8010a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <ltostr>:

void
ltostr(long value, char *str)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c5:	79 13                	jns    8010da <ltostr+0x2d>
	{
		neg = 1;
  8010c7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010e2:	99                   	cltd   
  8010e3:	f7 f9                	idiv   %ecx
  8010e5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010eb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f1:	89 c2                	mov    %eax,%edx
  8010f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010fb:	83 c2 30             	add    $0x30,%edx
  8010fe:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801100:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801103:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801108:	f7 e9                	imul   %ecx
  80110a:	c1 fa 02             	sar    $0x2,%edx
  80110d:	89 c8                	mov    %ecx,%eax
  80110f:	c1 f8 1f             	sar    $0x1f,%eax
  801112:	29 c2                	sub    %eax,%edx
  801114:	89 d0                	mov    %edx,%eax
  801116:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801119:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801121:	f7 e9                	imul   %ecx
  801123:	c1 fa 02             	sar    $0x2,%edx
  801126:	89 c8                	mov    %ecx,%eax
  801128:	c1 f8 1f             	sar    $0x1f,%eax
  80112b:	29 c2                	sub    %eax,%edx
  80112d:	89 d0                	mov    %edx,%eax
  80112f:	c1 e0 02             	shl    $0x2,%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	01 c0                	add    %eax,%eax
  801136:	29 c1                	sub    %eax,%ecx
  801138:	89 ca                	mov    %ecx,%edx
  80113a:	85 d2                	test   %edx,%edx
  80113c:	75 9c                	jne    8010da <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	48                   	dec    %eax
  801149:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80114c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801150:	74 3d                	je     80118f <ltostr+0xe2>
		start = 1 ;
  801152:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801159:	eb 34                	jmp    80118f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80115b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	01 c8                	add    %ecx,%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80117c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 c2                	add    %eax,%edx
  801184:	8a 45 eb             	mov    -0x15(%ebp),%al
  801187:	88 02                	mov    %al,(%edx)
		start++ ;
  801189:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80118c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801192:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801195:	7c c4                	jl     80115b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801197:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	01 d0                	add    %edx,%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011a2:	90                   	nop
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 54 fa ff ff       	call   800c07 <strlen>
  8011b3:	83 c4 04             	add    $0x4,%esp
  8011b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	e8 46 fa ff ff       	call   800c07 <strlen>
  8011c1:	83 c4 04             	add    $0x4,%esp
  8011c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d5:	eb 17                	jmp    8011ee <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	01 c2                	add    %eax,%edx
  8011df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	01 c8                	add    %ecx,%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011eb:	ff 45 fc             	incl   -0x4(%ebp)
  8011ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f4:	7c e1                	jl     8011d7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801204:	eb 1f                	jmp    801225 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120f:	89 c2                	mov    %eax,%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 c2                	add    %eax,%edx
  801216:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	01 c8                	add    %ecx,%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801222:	ff 45 f8             	incl   -0x8(%ebp)
  801225:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801228:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122b:	7c d9                	jl     801206 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	01 d0                	add    %edx,%eax
  801235:	c6 00 00             	movb   $0x0,(%eax)
}
  801238:	90                   	nop
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801253:	8b 45 10             	mov    0x10(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125e:	eb 0c                	jmp    80126c <strsplit+0x31>
			*string++ = 0;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8d 50 01             	lea    0x1(%eax),%edx
  801266:	89 55 08             	mov    %edx,0x8(%ebp)
  801269:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	74 18                	je     80128d <strsplit+0x52>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	0f be c0             	movsbl %al,%eax
  80127d:	50                   	push   %eax
  80127e:	ff 75 0c             	pushl  0xc(%ebp)
  801281:	e8 13 fb ff ff       	call   800d99 <strchr>
  801286:	83 c4 08             	add    $0x8,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 d3                	jne    801260 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	84 c0                	test   %al,%al
  801294:	74 5a                	je     8012f0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801296:	8b 45 14             	mov    0x14(%ebp),%eax
  801299:	8b 00                	mov    (%eax),%eax
  80129b:	83 f8 0f             	cmp    $0xf,%eax
  80129e:	75 07                	jne    8012a7 <strsplit+0x6c>
		{
			return 0;
  8012a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a5:	eb 66                	jmp    80130d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012aa:	8b 00                	mov    (%eax),%eax
  8012ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8012af:	8b 55 14             	mov    0x14(%ebp),%edx
  8012b2:	89 0a                	mov    %ecx,(%edx)
  8012b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	01 c2                	add    %eax,%edx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c5:	eb 03                	jmp    8012ca <strsplit+0x8f>
			string++;
  8012c7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	84 c0                	test   %al,%al
  8012d1:	74 8b                	je     80125e <strsplit+0x23>
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	0f be c0             	movsbl %al,%eax
  8012db:	50                   	push   %eax
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 b5 fa ff ff       	call   800d99 <strchr>
  8012e4:	83 c4 08             	add    $0x8,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	74 dc                	je     8012c7 <strsplit+0x8c>
			string++;
	}
  8012eb:	e9 6e ff ff ff       	jmp    80125e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012f0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f4:	8b 00                	mov    (%eax),%eax
  8012f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 d0                	add    %edx,%eax
  801302:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801308:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801315:	a1 04 40 80 00       	mov    0x804004,%eax
  80131a:	85 c0                	test   %eax,%eax
  80131c:	74 1f                	je     80133d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131e:	e8 1d 00 00 00       	call   801340 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 70 3a 80 00       	push   $0x803a70
  80132b:	e8 55 f2 ff ff       	call   800585 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801333:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80133a:	00 00 00 
	}
}
  80133d:	90                   	nop
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801346:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80134d:	00 00 00 
  801350:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801357:	00 00 00 
  80135a:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801361:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801364:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80136b:	00 00 00 
  80136e:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801375:	00 00 00 
  801378:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80137f:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801382:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801389:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80138c:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801396:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139b:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a0:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8013a5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013ac:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b1:	c1 e0 04             	shl    $0x4,%eax
  8013b4:	89 c2                	mov    %eax,%edx
  8013b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b9:	01 d0                	add    %edx,%eax
  8013bb:	48                   	dec    %eax
  8013bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c7:	f7 75 f0             	divl   -0x10(%ebp)
  8013ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013cd:	29 d0                	sub    %edx,%eax
  8013cf:	89 c2                	mov    %eax,%edx
  8013d1:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8013d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013e5:	83 ec 04             	sub    $0x4,%esp
  8013e8:	6a 06                	push   $0x6
  8013ea:	52                   	push   %edx
  8013eb:	50                   	push   %eax
  8013ec:	e8 71 05 00 00       	call   801962 <sys_allocate_chunk>
  8013f1:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013f4:	a1 20 41 80 00       	mov    0x804120,%eax
  8013f9:	83 ec 0c             	sub    $0xc,%esp
  8013fc:	50                   	push   %eax
  8013fd:	e8 e6 0b 00 00       	call   801fe8 <initialize_MemBlocksList>
  801402:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801405:	a1 48 41 80 00       	mov    0x804148,%eax
  80140a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  80140d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801411:	75 14                	jne    801427 <initialize_dyn_block_system+0xe7>
  801413:	83 ec 04             	sub    $0x4,%esp
  801416:	68 95 3a 80 00       	push   $0x803a95
  80141b:	6a 2b                	push   $0x2b
  80141d:	68 b3 3a 80 00       	push   $0x803ab3
  801422:	e8 aa ee ff ff       	call   8002d1 <_panic>
  801427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80142a:	8b 00                	mov    (%eax),%eax
  80142c:	85 c0                	test   %eax,%eax
  80142e:	74 10                	je     801440 <initialize_dyn_block_system+0x100>
  801430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801433:	8b 00                	mov    (%eax),%eax
  801435:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801438:	8b 52 04             	mov    0x4(%edx),%edx
  80143b:	89 50 04             	mov    %edx,0x4(%eax)
  80143e:	eb 0b                	jmp    80144b <initialize_dyn_block_system+0x10b>
  801440:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801443:	8b 40 04             	mov    0x4(%eax),%eax
  801446:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80144b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80144e:	8b 40 04             	mov    0x4(%eax),%eax
  801451:	85 c0                	test   %eax,%eax
  801453:	74 0f                	je     801464 <initialize_dyn_block_system+0x124>
  801455:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801458:	8b 40 04             	mov    0x4(%eax),%eax
  80145b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80145e:	8b 12                	mov    (%edx),%edx
  801460:	89 10                	mov    %edx,(%eax)
  801462:	eb 0a                	jmp    80146e <initialize_dyn_block_system+0x12e>
  801464:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801467:	8b 00                	mov    (%eax),%eax
  801469:	a3 48 41 80 00       	mov    %eax,0x804148
  80146e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801471:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801477:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801481:	a1 54 41 80 00       	mov    0x804154,%eax
  801486:	48                   	dec    %eax
  801487:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  80148c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80148f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801499:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a6:	e8 d2 13 00 00       	call   80287d <insert_sorted_with_merge_freeList>
  8014ab:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014ae:	90                   	nop
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014b7:	e8 53 fe ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  8014bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c0:	75 07                	jne    8014c9 <malloc+0x18>
  8014c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c7:	eb 61                	jmp    80152a <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8014c9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d6:	01 d0                	add    %edx,%eax
  8014d8:	48                   	dec    %eax
  8014d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014df:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e4:	f7 75 f4             	divl   -0xc(%ebp)
  8014e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ea:	29 d0                	sub    %edx,%eax
  8014ec:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014ef:	e8 3c 08 00 00       	call   801d30 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014f4:	85 c0                	test   %eax,%eax
  8014f6:	74 2d                	je     801525 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8014f8:	83 ec 0c             	sub    $0xc,%esp
  8014fb:	ff 75 08             	pushl  0x8(%ebp)
  8014fe:	e8 3e 0f 00 00       	call   802441 <alloc_block_FF>
  801503:	83 c4 10             	add    $0x10,%esp
  801506:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801509:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80150d:	74 16                	je     801525 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  80150f:	83 ec 0c             	sub    $0xc,%esp
  801512:	ff 75 ec             	pushl  -0x14(%ebp)
  801515:	e8 48 0c 00 00       	call   802162 <insert_sorted_allocList>
  80151a:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  80151d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801520:	8b 40 08             	mov    0x8(%eax),%eax
  801523:	eb 05                	jmp    80152a <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801525:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801540:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	83 ec 08             	sub    $0x8,%esp
  801549:	50                   	push   %eax
  80154a:	68 40 40 80 00       	push   $0x804040
  80154f:	e8 71 0b 00 00       	call   8020c5 <find_block>
  801554:	83 c4 10             	add    $0x10,%esp
  801557:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80155a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155d:	8b 50 0c             	mov    0xc(%eax),%edx
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	83 ec 08             	sub    $0x8,%esp
  801566:	52                   	push   %edx
  801567:	50                   	push   %eax
  801568:	e8 bd 03 00 00       	call   80192a <sys_free_user_mem>
  80156d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801570:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801574:	75 14                	jne    80158a <free+0x5e>
  801576:	83 ec 04             	sub    $0x4,%esp
  801579:	68 95 3a 80 00       	push   $0x803a95
  80157e:	6a 71                	push   $0x71
  801580:	68 b3 3a 80 00       	push   $0x803ab3
  801585:	e8 47 ed ff ff       	call   8002d1 <_panic>
  80158a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158d:	8b 00                	mov    (%eax),%eax
  80158f:	85 c0                	test   %eax,%eax
  801591:	74 10                	je     8015a3 <free+0x77>
  801593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801596:	8b 00                	mov    (%eax),%eax
  801598:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80159b:	8b 52 04             	mov    0x4(%edx),%edx
  80159e:	89 50 04             	mov    %edx,0x4(%eax)
  8015a1:	eb 0b                	jmp    8015ae <free+0x82>
  8015a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a6:	8b 40 04             	mov    0x4(%eax),%eax
  8015a9:	a3 44 40 80 00       	mov    %eax,0x804044
  8015ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b1:	8b 40 04             	mov    0x4(%eax),%eax
  8015b4:	85 c0                	test   %eax,%eax
  8015b6:	74 0f                	je     8015c7 <free+0x9b>
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bb:	8b 40 04             	mov    0x4(%eax),%eax
  8015be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015c1:	8b 12                	mov    (%edx),%edx
  8015c3:	89 10                	mov    %edx,(%eax)
  8015c5:	eb 0a                	jmp    8015d1 <free+0xa5>
  8015c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	a3 40 40 80 00       	mov    %eax,0x804040
  8015d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015e4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015e9:	48                   	dec    %eax
  8015ea:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8015ef:	83 ec 0c             	sub    $0xc,%esp
  8015f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f5:	e8 83 12 00 00       	call   80287d <insert_sorted_with_merge_freeList>
  8015fa:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015fd:	90                   	nop
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
  801603:	83 ec 28             	sub    $0x28,%esp
  801606:	8b 45 10             	mov    0x10(%ebp),%eax
  801609:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80160c:	e8 fe fc ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  801611:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801615:	75 0a                	jne    801621 <smalloc+0x21>
  801617:	b8 00 00 00 00       	mov    $0x0,%eax
  80161c:	e9 86 00 00 00       	jmp    8016a7 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801621:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162e:	01 d0                	add    %edx,%eax
  801630:	48                   	dec    %eax
  801631:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801637:	ba 00 00 00 00       	mov    $0x0,%edx
  80163c:	f7 75 f4             	divl   -0xc(%ebp)
  80163f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801642:	29 d0                	sub    %edx,%eax
  801644:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801647:	e8 e4 06 00 00       	call   801d30 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80164c:	85 c0                	test   %eax,%eax
  80164e:	74 52                	je     8016a2 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801650:	83 ec 0c             	sub    $0xc,%esp
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	e8 e6 0d 00 00       	call   802441 <alloc_block_FF>
  80165b:	83 c4 10             	add    $0x10,%esp
  80165e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801661:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801665:	75 07                	jne    80166e <smalloc+0x6e>
			return NULL ;
  801667:	b8 00 00 00 00       	mov    $0x0,%eax
  80166c:	eb 39                	jmp    8016a7 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80166e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801671:	8b 40 08             	mov    0x8(%eax),%eax
  801674:	89 c2                	mov    %eax,%edx
  801676:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80167a:	52                   	push   %edx
  80167b:	50                   	push   %eax
  80167c:	ff 75 0c             	pushl  0xc(%ebp)
  80167f:	ff 75 08             	pushl  0x8(%ebp)
  801682:	e8 2e 04 00 00       	call   801ab5 <sys_createSharedObject>
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80168d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801691:	79 07                	jns    80169a <smalloc+0x9a>
			return (void*)NULL ;
  801693:	b8 00 00 00 00       	mov    $0x0,%eax
  801698:	eb 0d                	jmp    8016a7 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  80169a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169d:	8b 40 08             	mov    0x8(%eax),%eax
  8016a0:	eb 05                	jmp    8016a7 <smalloc+0xa7>
		}
		return (void*)NULL ;
  8016a2:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016a7:	c9                   	leave  
  8016a8:	c3                   	ret    

008016a9 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016a9:	55                   	push   %ebp
  8016aa:	89 e5                	mov    %esp,%ebp
  8016ac:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016af:	e8 5b fc ff ff       	call   80130f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016b4:	83 ec 08             	sub    $0x8,%esp
  8016b7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ba:	ff 75 08             	pushl  0x8(%ebp)
  8016bd:	e8 1d 04 00 00       	call   801adf <sys_getSizeOfSharedObject>
  8016c2:	83 c4 10             	add    $0x10,%esp
  8016c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8016c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016cc:	75 0a                	jne    8016d8 <sget+0x2f>
			return NULL ;
  8016ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d3:	e9 83 00 00 00       	jmp    80175b <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8016d8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e5:	01 d0                	add    %edx,%eax
  8016e7:	48                   	dec    %eax
  8016e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f3:	f7 75 f0             	divl   -0x10(%ebp)
  8016f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f9:	29 d0                	sub    %edx,%eax
  8016fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016fe:	e8 2d 06 00 00       	call   801d30 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801703:	85 c0                	test   %eax,%eax
  801705:	74 4f                	je     801756 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170a:	83 ec 0c             	sub    $0xc,%esp
  80170d:	50                   	push   %eax
  80170e:	e8 2e 0d 00 00       	call   802441 <alloc_block_FF>
  801713:	83 c4 10             	add    $0x10,%esp
  801716:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801719:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80171d:	75 07                	jne    801726 <sget+0x7d>
					return (void*)NULL ;
  80171f:	b8 00 00 00 00       	mov    $0x0,%eax
  801724:	eb 35                	jmp    80175b <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801726:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801729:	8b 40 08             	mov    0x8(%eax),%eax
  80172c:	83 ec 04             	sub    $0x4,%esp
  80172f:	50                   	push   %eax
  801730:	ff 75 0c             	pushl  0xc(%ebp)
  801733:	ff 75 08             	pushl  0x8(%ebp)
  801736:	e8 c1 03 00 00       	call   801afc <sys_getSharedObject>
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801741:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801745:	79 07                	jns    80174e <sget+0xa5>
				return (void*)NULL ;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
  80174c:	eb 0d                	jmp    80175b <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  80174e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801751:	8b 40 08             	mov    0x8(%eax),%eax
  801754:	eb 05                	jmp    80175b <sget+0xb2>


		}
	return (void*)NULL ;
  801756:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80175b:	c9                   	leave  
  80175c:	c3                   	ret    

0080175d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801763:	e8 a7 fb ff ff       	call   80130f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801768:	83 ec 04             	sub    $0x4,%esp
  80176b:	68 c0 3a 80 00       	push   $0x803ac0
  801770:	68 f9 00 00 00       	push   $0xf9
  801775:	68 b3 3a 80 00       	push   $0x803ab3
  80177a:	e8 52 eb ff ff       	call   8002d1 <_panic>

0080177f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801785:	83 ec 04             	sub    $0x4,%esp
  801788:	68 e8 3a 80 00       	push   $0x803ae8
  80178d:	68 0d 01 00 00       	push   $0x10d
  801792:	68 b3 3a 80 00       	push   $0x803ab3
  801797:	e8 35 eb ff ff       	call   8002d1 <_panic>

0080179c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a2:	83 ec 04             	sub    $0x4,%esp
  8017a5:	68 0c 3b 80 00       	push   $0x803b0c
  8017aa:	68 18 01 00 00       	push   $0x118
  8017af:	68 b3 3a 80 00       	push   $0x803ab3
  8017b4:	e8 18 eb ff ff       	call   8002d1 <_panic>

008017b9 <shrink>:

}
void shrink(uint32 newSize)
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017bf:	83 ec 04             	sub    $0x4,%esp
  8017c2:	68 0c 3b 80 00       	push   $0x803b0c
  8017c7:	68 1d 01 00 00       	push   $0x11d
  8017cc:	68 b3 3a 80 00       	push   $0x803ab3
  8017d1:	e8 fb ea ff ff       	call   8002d1 <_panic>

008017d6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	68 0c 3b 80 00       	push   $0x803b0c
  8017e4:	68 22 01 00 00       	push   $0x122
  8017e9:	68 b3 3a 80 00       	push   $0x803ab3
  8017ee:	e8 de ea ff ff       	call   8002d1 <_panic>

008017f3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	57                   	push   %edi
  8017f7:	56                   	push   %esi
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801802:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801805:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801808:	8b 7d 18             	mov    0x18(%ebp),%edi
  80180b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80180e:	cd 30                	int    $0x30
  801810:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801813:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	5b                   	pop    %ebx
  80181a:	5e                   	pop    %esi
  80181b:	5f                   	pop    %edi
  80181c:	5d                   	pop    %ebp
  80181d:	c3                   	ret    

0080181e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 04             	sub    $0x4,%esp
  801824:	8b 45 10             	mov    0x10(%ebp),%eax
  801827:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80182a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	52                   	push   %edx
  801836:	ff 75 0c             	pushl  0xc(%ebp)
  801839:	50                   	push   %eax
  80183a:	6a 00                	push   $0x0
  80183c:	e8 b2 ff ff ff       	call   8017f3 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	90                   	nop
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <sys_cgetc>:

int
sys_cgetc(void)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	6a 00                	push   $0x0
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 01                	push   $0x1
  801856:	e8 98 ff ff ff       	call   8017f3 <syscall>
  80185b:	83 c4 18             	add    $0x18,%esp
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801863:	8b 55 0c             	mov    0xc(%ebp),%edx
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	6a 00                	push   $0x0
  80186f:	52                   	push   %edx
  801870:	50                   	push   %eax
  801871:	6a 05                	push   $0x5
  801873:	e8 7b ff ff ff       	call   8017f3 <syscall>
  801878:	83 c4 18             	add    $0x18,%esp
}
  80187b:	c9                   	leave  
  80187c:	c3                   	ret    

0080187d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	56                   	push   %esi
  801881:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801882:	8b 75 18             	mov    0x18(%ebp),%esi
  801885:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801888:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	56                   	push   %esi
  801892:	53                   	push   %ebx
  801893:	51                   	push   %ecx
  801894:	52                   	push   %edx
  801895:	50                   	push   %eax
  801896:	6a 06                	push   $0x6
  801898:	e8 56 ff ff ff       	call   8017f3 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a3:	5b                   	pop    %ebx
  8018a4:	5e                   	pop    %esi
  8018a5:	5d                   	pop    %ebp
  8018a6:	c3                   	ret    

008018a7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	52                   	push   %edx
  8018b7:	50                   	push   %eax
  8018b8:	6a 07                	push   $0x7
  8018ba:	e8 34 ff ff ff       	call   8017f3 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	ff 75 0c             	pushl  0xc(%ebp)
  8018d0:	ff 75 08             	pushl  0x8(%ebp)
  8018d3:	6a 08                	push   $0x8
  8018d5:	e8 19 ff ff ff       	call   8017f3 <syscall>
  8018da:	83 c4 18             	add    $0x18,%esp
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 09                	push   $0x9
  8018ee:	e8 00 ff ff ff       	call   8017f3 <syscall>
  8018f3:	83 c4 18             	add    $0x18,%esp
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 0a                	push   $0xa
  801907:	e8 e7 fe ff ff       	call   8017f3 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	6a 0b                	push   $0xb
  801920:	e8 ce fe ff ff       	call   8017f3 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	ff 75 08             	pushl  0x8(%ebp)
  801939:	6a 0f                	push   $0xf
  80193b:	e8 b3 fe ff ff       	call   8017f3 <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
	return;
  801943:	90                   	nop
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	ff 75 0c             	pushl  0xc(%ebp)
  801952:	ff 75 08             	pushl  0x8(%ebp)
  801955:	6a 10                	push   $0x10
  801957:	e8 97 fe ff ff       	call   8017f3 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
	return ;
  80195f:	90                   	nop
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	ff 75 10             	pushl  0x10(%ebp)
  80196c:	ff 75 0c             	pushl  0xc(%ebp)
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	6a 11                	push   $0x11
  801974:	e8 7a fe ff ff       	call   8017f3 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
	return ;
  80197c:	90                   	nop
}
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 0c                	push   $0xc
  80198e:	e8 60 fe ff ff       	call   8017f3 <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	ff 75 08             	pushl  0x8(%ebp)
  8019a6:	6a 0d                	push   $0xd
  8019a8:	e8 46 fe ff ff       	call   8017f3 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 0e                	push   $0xe
  8019c1:	e8 2d fe ff ff       	call   8017f3 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	90                   	nop
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 13                	push   $0x13
  8019db:	e8 13 fe ff ff       	call   8017f3 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	90                   	nop
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 14                	push   $0x14
  8019f5:	e8 f9 fd ff ff       	call   8017f3 <syscall>
  8019fa:	83 c4 18             	add    $0x18,%esp
}
  8019fd:	90                   	nop
  8019fe:	c9                   	leave  
  8019ff:	c3                   	ret    

00801a00 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 04             	sub    $0x4,%esp
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a0c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	50                   	push   %eax
  801a19:	6a 15                	push   $0x15
  801a1b:	e8 d3 fd ff ff       	call   8017f3 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	90                   	nop
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 16                	push   $0x16
  801a35:	e8 b9 fd ff ff       	call   8017f3 <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	50                   	push   %eax
  801a50:	6a 17                	push   $0x17
  801a52:	e8 9c fd ff ff       	call   8017f3 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	52                   	push   %edx
  801a6c:	50                   	push   %eax
  801a6d:	6a 1a                	push   $0x1a
  801a6f:	e8 7f fd ff ff       	call   8017f3 <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	52                   	push   %edx
  801a89:	50                   	push   %eax
  801a8a:	6a 18                	push   $0x18
  801a8c:	e8 62 fd ff ff       	call   8017f3 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	90                   	nop
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	52                   	push   %edx
  801aa7:	50                   	push   %eax
  801aa8:	6a 19                	push   $0x19
  801aaa:	e8 44 fd ff ff       	call   8017f3 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	90                   	nop
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	83 ec 04             	sub    $0x4,%esp
  801abb:	8b 45 10             	mov    0x10(%ebp),%eax
  801abe:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ac1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	6a 00                	push   $0x0
  801acd:	51                   	push   %ecx
  801ace:	52                   	push   %edx
  801acf:	ff 75 0c             	pushl  0xc(%ebp)
  801ad2:	50                   	push   %eax
  801ad3:	6a 1b                	push   $0x1b
  801ad5:	e8 19 fd ff ff       	call   8017f3 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	52                   	push   %edx
  801aef:	50                   	push   %eax
  801af0:	6a 1c                	push   $0x1c
  801af2:	e8 fc fc ff ff       	call   8017f3 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801aff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	51                   	push   %ecx
  801b0d:	52                   	push   %edx
  801b0e:	50                   	push   %eax
  801b0f:	6a 1d                	push   $0x1d
  801b11:	e8 dd fc ff ff       	call   8017f3 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	52                   	push   %edx
  801b2b:	50                   	push   %eax
  801b2c:	6a 1e                	push   $0x1e
  801b2e:	e8 c0 fc ff ff       	call   8017f3 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 1f                	push   $0x1f
  801b47:	e8 a7 fc ff ff       	call   8017f3 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	ff 75 14             	pushl  0x14(%ebp)
  801b5c:	ff 75 10             	pushl  0x10(%ebp)
  801b5f:	ff 75 0c             	pushl  0xc(%ebp)
  801b62:	50                   	push   %eax
  801b63:	6a 20                	push   $0x20
  801b65:	e8 89 fc ff ff       	call   8017f3 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	50                   	push   %eax
  801b7e:	6a 21                	push   $0x21
  801b80:	e8 6e fc ff ff       	call   8017f3 <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	90                   	nop
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	50                   	push   %eax
  801b9a:	6a 22                	push   $0x22
  801b9c:	e8 52 fc ff ff       	call   8017f3 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 02                	push   $0x2
  801bb5:	e8 39 fc ff ff       	call   8017f3 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 03                	push   $0x3
  801bce:	e8 20 fc ff ff       	call   8017f3 <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 04                	push   $0x4
  801be7:	e8 07 fc ff ff       	call   8017f3 <syscall>
  801bec:	83 c4 18             	add    $0x18,%esp
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_exit_env>:


void sys_exit_env(void)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 23                	push   $0x23
  801c00:	e8 ee fb ff ff       	call   8017f3 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	90                   	nop
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c11:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c14:	8d 50 04             	lea    0x4(%eax),%edx
  801c17:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	52                   	push   %edx
  801c21:	50                   	push   %eax
  801c22:	6a 24                	push   $0x24
  801c24:	e8 ca fb ff ff       	call   8017f3 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
	return result;
  801c2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c32:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c35:	89 01                	mov    %eax,(%ecx)
  801c37:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	c9                   	leave  
  801c3e:	c2 04 00             	ret    $0x4

00801c41 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	ff 75 10             	pushl  0x10(%ebp)
  801c4b:	ff 75 0c             	pushl  0xc(%ebp)
  801c4e:	ff 75 08             	pushl  0x8(%ebp)
  801c51:	6a 12                	push   $0x12
  801c53:	e8 9b fb ff ff       	call   8017f3 <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5b:	90                   	nop
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_rcr2>:
uint32 sys_rcr2()
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 25                	push   $0x25
  801c6d:	e8 81 fb ff ff       	call   8017f3 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
  801c7a:	83 ec 04             	sub    $0x4,%esp
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c83:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	50                   	push   %eax
  801c90:	6a 26                	push   $0x26
  801c92:	e8 5c fb ff ff       	call   8017f3 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9a:	90                   	nop
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <rsttst>:
void rsttst()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 28                	push   $0x28
  801cac:	e8 42 fb ff ff       	call   8017f3 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb4:	90                   	nop
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 04             	sub    $0x4,%esp
  801cbd:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc3:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cca:	52                   	push   %edx
  801ccb:	50                   	push   %eax
  801ccc:	ff 75 10             	pushl  0x10(%ebp)
  801ccf:	ff 75 0c             	pushl  0xc(%ebp)
  801cd2:	ff 75 08             	pushl  0x8(%ebp)
  801cd5:	6a 27                	push   $0x27
  801cd7:	e8 17 fb ff ff       	call   8017f3 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdf:	90                   	nop
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <chktst>:
void chktst(uint32 n)
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	ff 75 08             	pushl  0x8(%ebp)
  801cf0:	6a 29                	push   $0x29
  801cf2:	e8 fc fa ff ff       	call   8017f3 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfa:	90                   	nop
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <inctst>:

void inctst()
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 2a                	push   $0x2a
  801d0c:	e8 e2 fa ff ff       	call   8017f3 <syscall>
  801d11:	83 c4 18             	add    $0x18,%esp
	return ;
  801d14:	90                   	nop
}
  801d15:	c9                   	leave  
  801d16:	c3                   	ret    

00801d17 <gettst>:
uint32 gettst()
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 2b                	push   $0x2b
  801d26:	e8 c8 fa ff ff       	call   8017f3 <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 2c                	push   $0x2c
  801d42:	e8 ac fa ff ff       	call   8017f3 <syscall>
  801d47:	83 c4 18             	add    $0x18,%esp
  801d4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d4d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d51:	75 07                	jne    801d5a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d53:	b8 01 00 00 00       	mov    $0x1,%eax
  801d58:	eb 05                	jmp    801d5f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 2c                	push   $0x2c
  801d73:	e8 7b fa ff ff       	call   8017f3 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
  801d7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d7e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d82:	75 07                	jne    801d8b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d84:	b8 01 00 00 00       	mov    $0x1,%eax
  801d89:	eb 05                	jmp    801d90 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d90:	c9                   	leave  
  801d91:	c3                   	ret    

00801d92 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d92:	55                   	push   %ebp
  801d93:	89 e5                	mov    %esp,%ebp
  801d95:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 00                	push   $0x0
  801da2:	6a 2c                	push   $0x2c
  801da4:	e8 4a fa ff ff       	call   8017f3 <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
  801dac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801daf:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801db3:	75 07                	jne    801dbc <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801db5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dba:	eb 05                	jmp    801dc1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc1:	c9                   	leave  
  801dc2:	c3                   	ret    

00801dc3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 2c                	push   $0x2c
  801dd5:	e8 19 fa ff ff       	call   8017f3 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
  801ddd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801de0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801de4:	75 07                	jne    801ded <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801de6:	b8 01 00 00 00       	mov    $0x1,%eax
  801deb:	eb 05                	jmp    801df2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	6a 2d                	push   $0x2d
  801e04:	e8 ea f9 ff ff       	call   8017f3 <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0c:	90                   	nop
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e13:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e16:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1f:	6a 00                	push   $0x0
  801e21:	53                   	push   %ebx
  801e22:	51                   	push   %ecx
  801e23:	52                   	push   %edx
  801e24:	50                   	push   %eax
  801e25:	6a 2e                	push   $0x2e
  801e27:	e8 c7 f9 ff ff       	call   8017f3 <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
}
  801e2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e37:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	52                   	push   %edx
  801e44:	50                   	push   %eax
  801e45:	6a 2f                	push   $0x2f
  801e47:	e8 a7 f9 ff ff       	call   8017f3 <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e57:	83 ec 0c             	sub    $0xc,%esp
  801e5a:	68 1c 3b 80 00       	push   $0x803b1c
  801e5f:	e8 21 e7 ff ff       	call   800585 <cprintf>
  801e64:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e6e:	83 ec 0c             	sub    $0xc,%esp
  801e71:	68 48 3b 80 00       	push   $0x803b48
  801e76:	e8 0a e7 ff ff       	call   800585 <cprintf>
  801e7b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e7e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e82:	a1 38 41 80 00       	mov    0x804138,%eax
  801e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e8a:	eb 56                	jmp    801ee2 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e90:	74 1c                	je     801eae <print_mem_block_lists+0x5d>
  801e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e95:	8b 50 08             	mov    0x8(%eax),%edx
  801e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9b:	8b 48 08             	mov    0x8(%eax),%ecx
  801e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea4:	01 c8                	add    %ecx,%eax
  801ea6:	39 c2                	cmp    %eax,%edx
  801ea8:	73 04                	jae    801eae <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eaa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb1:	8b 50 08             	mov    0x8(%eax),%edx
  801eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eba:	01 c2                	add    %eax,%edx
  801ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebf:	8b 40 08             	mov    0x8(%eax),%eax
  801ec2:	83 ec 04             	sub    $0x4,%esp
  801ec5:	52                   	push   %edx
  801ec6:	50                   	push   %eax
  801ec7:	68 5d 3b 80 00       	push   $0x803b5d
  801ecc:	e8 b4 e6 ff ff       	call   800585 <cprintf>
  801ed1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eda:	a1 40 41 80 00       	mov    0x804140,%eax
  801edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee6:	74 07                	je     801eef <print_mem_block_lists+0x9e>
  801ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eeb:	8b 00                	mov    (%eax),%eax
  801eed:	eb 05                	jmp    801ef4 <print_mem_block_lists+0xa3>
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef4:	a3 40 41 80 00       	mov    %eax,0x804140
  801ef9:	a1 40 41 80 00       	mov    0x804140,%eax
  801efe:	85 c0                	test   %eax,%eax
  801f00:	75 8a                	jne    801e8c <print_mem_block_lists+0x3b>
  801f02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f06:	75 84                	jne    801e8c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f08:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f0c:	75 10                	jne    801f1e <print_mem_block_lists+0xcd>
  801f0e:	83 ec 0c             	sub    $0xc,%esp
  801f11:	68 6c 3b 80 00       	push   $0x803b6c
  801f16:	e8 6a e6 ff ff       	call   800585 <cprintf>
  801f1b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f1e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f25:	83 ec 0c             	sub    $0xc,%esp
  801f28:	68 90 3b 80 00       	push   $0x803b90
  801f2d:	e8 53 e6 ff ff       	call   800585 <cprintf>
  801f32:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f35:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f39:	a1 40 40 80 00       	mov    0x804040,%eax
  801f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f41:	eb 56                	jmp    801f99 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f43:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f47:	74 1c                	je     801f65 <print_mem_block_lists+0x114>
  801f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4c:	8b 50 08             	mov    0x8(%eax),%edx
  801f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f52:	8b 48 08             	mov    0x8(%eax),%ecx
  801f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f58:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5b:	01 c8                	add    %ecx,%eax
  801f5d:	39 c2                	cmp    %eax,%edx
  801f5f:	73 04                	jae    801f65 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f61:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f68:	8b 50 08             	mov    0x8(%eax),%edx
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f71:	01 c2                	add    %eax,%edx
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	8b 40 08             	mov    0x8(%eax),%eax
  801f79:	83 ec 04             	sub    $0x4,%esp
  801f7c:	52                   	push   %edx
  801f7d:	50                   	push   %eax
  801f7e:	68 5d 3b 80 00       	push   $0x803b5d
  801f83:	e8 fd e5 ff ff       	call   800585 <cprintf>
  801f88:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f91:	a1 48 40 80 00       	mov    0x804048,%eax
  801f96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9d:	74 07                	je     801fa6 <print_mem_block_lists+0x155>
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	8b 00                	mov    (%eax),%eax
  801fa4:	eb 05                	jmp    801fab <print_mem_block_lists+0x15a>
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fab:	a3 48 40 80 00       	mov    %eax,0x804048
  801fb0:	a1 48 40 80 00       	mov    0x804048,%eax
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	75 8a                	jne    801f43 <print_mem_block_lists+0xf2>
  801fb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fbd:	75 84                	jne    801f43 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fbf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc3:	75 10                	jne    801fd5 <print_mem_block_lists+0x184>
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	68 a8 3b 80 00       	push   $0x803ba8
  801fcd:	e8 b3 e5 ff ff       	call   800585 <cprintf>
  801fd2:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fd5:	83 ec 0c             	sub    $0xc,%esp
  801fd8:	68 1c 3b 80 00       	push   $0x803b1c
  801fdd:	e8 a3 e5 ff ff       	call   800585 <cprintf>
  801fe2:	83 c4 10             	add    $0x10,%esp

}
  801fe5:	90                   	nop
  801fe6:	c9                   	leave  
  801fe7:	c3                   	ret    

00801fe8 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801fee:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ff5:	00 00 00 
  801ff8:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fff:	00 00 00 
  802002:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802009:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80200c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802013:	e9 9e 00 00 00       	jmp    8020b6 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802018:	a1 50 40 80 00       	mov    0x804050,%eax
  80201d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802020:	c1 e2 04             	shl    $0x4,%edx
  802023:	01 d0                	add    %edx,%eax
  802025:	85 c0                	test   %eax,%eax
  802027:	75 14                	jne    80203d <initialize_MemBlocksList+0x55>
  802029:	83 ec 04             	sub    $0x4,%esp
  80202c:	68 d0 3b 80 00       	push   $0x803bd0
  802031:	6a 43                	push   $0x43
  802033:	68 f3 3b 80 00       	push   $0x803bf3
  802038:	e8 94 e2 ff ff       	call   8002d1 <_panic>
  80203d:	a1 50 40 80 00       	mov    0x804050,%eax
  802042:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802045:	c1 e2 04             	shl    $0x4,%edx
  802048:	01 d0                	add    %edx,%eax
  80204a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802050:	89 10                	mov    %edx,(%eax)
  802052:	8b 00                	mov    (%eax),%eax
  802054:	85 c0                	test   %eax,%eax
  802056:	74 18                	je     802070 <initialize_MemBlocksList+0x88>
  802058:	a1 48 41 80 00       	mov    0x804148,%eax
  80205d:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802063:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802066:	c1 e1 04             	shl    $0x4,%ecx
  802069:	01 ca                	add    %ecx,%edx
  80206b:	89 50 04             	mov    %edx,0x4(%eax)
  80206e:	eb 12                	jmp    802082 <initialize_MemBlocksList+0x9a>
  802070:	a1 50 40 80 00       	mov    0x804050,%eax
  802075:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802078:	c1 e2 04             	shl    $0x4,%edx
  80207b:	01 d0                	add    %edx,%eax
  80207d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802082:	a1 50 40 80 00       	mov    0x804050,%eax
  802087:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208a:	c1 e2 04             	shl    $0x4,%edx
  80208d:	01 d0                	add    %edx,%eax
  80208f:	a3 48 41 80 00       	mov    %eax,0x804148
  802094:	a1 50 40 80 00       	mov    0x804050,%eax
  802099:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209c:	c1 e2 04             	shl    $0x4,%edx
  80209f:	01 d0                	add    %edx,%eax
  8020a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a8:	a1 54 41 80 00       	mov    0x804154,%eax
  8020ad:	40                   	inc    %eax
  8020ae:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8020b3:	ff 45 f4             	incl   -0xc(%ebp)
  8020b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020bc:	0f 82 56 ff ff ff    	jb     802018 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8020c2:	90                   	nop
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8020cb:	a1 38 41 80 00       	mov    0x804138,%eax
  8020d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d3:	eb 18                	jmp    8020ed <find_block+0x28>
	{
		if (ele->sva==va)
  8020d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d8:	8b 40 08             	mov    0x8(%eax),%eax
  8020db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020de:	75 05                	jne    8020e5 <find_block+0x20>
			return ele;
  8020e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e3:	eb 7b                	jmp    802160 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8020e5:	a1 40 41 80 00       	mov    0x804140,%eax
  8020ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ed:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f1:	74 07                	je     8020fa <find_block+0x35>
  8020f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f6:	8b 00                	mov    (%eax),%eax
  8020f8:	eb 05                	jmp    8020ff <find_block+0x3a>
  8020fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ff:	a3 40 41 80 00       	mov    %eax,0x804140
  802104:	a1 40 41 80 00       	mov    0x804140,%eax
  802109:	85 c0                	test   %eax,%eax
  80210b:	75 c8                	jne    8020d5 <find_block+0x10>
  80210d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802111:	75 c2                	jne    8020d5 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802113:	a1 40 40 80 00       	mov    0x804040,%eax
  802118:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80211b:	eb 18                	jmp    802135 <find_block+0x70>
	{
		if (ele->sva==va)
  80211d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802120:	8b 40 08             	mov    0x8(%eax),%eax
  802123:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802126:	75 05                	jne    80212d <find_block+0x68>
					return ele;
  802128:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212b:	eb 33                	jmp    802160 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80212d:	a1 48 40 80 00       	mov    0x804048,%eax
  802132:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802135:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802139:	74 07                	je     802142 <find_block+0x7d>
  80213b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213e:	8b 00                	mov    (%eax),%eax
  802140:	eb 05                	jmp    802147 <find_block+0x82>
  802142:	b8 00 00 00 00       	mov    $0x0,%eax
  802147:	a3 48 40 80 00       	mov    %eax,0x804048
  80214c:	a1 48 40 80 00       	mov    0x804048,%eax
  802151:	85 c0                	test   %eax,%eax
  802153:	75 c8                	jne    80211d <find_block+0x58>
  802155:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802159:	75 c2                	jne    80211d <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  80215b:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802168:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80216d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802170:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802174:	75 62                	jne    8021d8 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802176:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80217a:	75 14                	jne    802190 <insert_sorted_allocList+0x2e>
  80217c:	83 ec 04             	sub    $0x4,%esp
  80217f:	68 d0 3b 80 00       	push   $0x803bd0
  802184:	6a 69                	push   $0x69
  802186:	68 f3 3b 80 00       	push   $0x803bf3
  80218b:	e8 41 e1 ff ff       	call   8002d1 <_panic>
  802190:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	89 10                	mov    %edx,(%eax)
  80219b:	8b 45 08             	mov    0x8(%ebp),%eax
  80219e:	8b 00                	mov    (%eax),%eax
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	74 0d                	je     8021b1 <insert_sorted_allocList+0x4f>
  8021a4:	a1 40 40 80 00       	mov    0x804040,%eax
  8021a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ac:	89 50 04             	mov    %edx,0x4(%eax)
  8021af:	eb 08                	jmp    8021b9 <insert_sorted_allocList+0x57>
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	a3 44 40 80 00       	mov    %eax,0x804044
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	a3 40 40 80 00       	mov    %eax,0x804040
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021cb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021d0:	40                   	inc    %eax
  8021d1:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021d6:	eb 72                	jmp    80224a <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8021d8:	a1 40 40 80 00       	mov    0x804040,%eax
  8021dd:	8b 50 08             	mov    0x8(%eax),%edx
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	8b 40 08             	mov    0x8(%eax),%eax
  8021e6:	39 c2                	cmp    %eax,%edx
  8021e8:	76 60                	jbe    80224a <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8021ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ee:	75 14                	jne    802204 <insert_sorted_allocList+0xa2>
  8021f0:	83 ec 04             	sub    $0x4,%esp
  8021f3:	68 d0 3b 80 00       	push   $0x803bd0
  8021f8:	6a 6d                	push   $0x6d
  8021fa:	68 f3 3b 80 00       	push   $0x803bf3
  8021ff:	e8 cd e0 ff ff       	call   8002d1 <_panic>
  802204:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	89 10                	mov    %edx,(%eax)
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	8b 00                	mov    (%eax),%eax
  802214:	85 c0                	test   %eax,%eax
  802216:	74 0d                	je     802225 <insert_sorted_allocList+0xc3>
  802218:	a1 40 40 80 00       	mov    0x804040,%eax
  80221d:	8b 55 08             	mov    0x8(%ebp),%edx
  802220:	89 50 04             	mov    %edx,0x4(%eax)
  802223:	eb 08                	jmp    80222d <insert_sorted_allocList+0xcb>
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	a3 44 40 80 00       	mov    %eax,0x804044
  80222d:	8b 45 08             	mov    0x8(%ebp),%eax
  802230:	a3 40 40 80 00       	mov    %eax,0x804040
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80223f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802244:	40                   	inc    %eax
  802245:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80224a:	a1 40 40 80 00       	mov    0x804040,%eax
  80224f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802252:	e9 b9 01 00 00       	jmp    802410 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	8b 50 08             	mov    0x8(%eax),%edx
  80225d:	a1 40 40 80 00       	mov    0x804040,%eax
  802262:	8b 40 08             	mov    0x8(%eax),%eax
  802265:	39 c2                	cmp    %eax,%edx
  802267:	76 7c                	jbe    8022e5 <insert_sorted_allocList+0x183>
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	8b 50 08             	mov    0x8(%eax),%edx
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 40 08             	mov    0x8(%eax),%eax
  802275:	39 c2                	cmp    %eax,%edx
  802277:	73 6c                	jae    8022e5 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227d:	74 06                	je     802285 <insert_sorted_allocList+0x123>
  80227f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802283:	75 14                	jne    802299 <insert_sorted_allocList+0x137>
  802285:	83 ec 04             	sub    $0x4,%esp
  802288:	68 0c 3c 80 00       	push   $0x803c0c
  80228d:	6a 75                	push   $0x75
  80228f:	68 f3 3b 80 00       	push   $0x803bf3
  802294:	e8 38 e0 ff ff       	call   8002d1 <_panic>
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	8b 50 04             	mov    0x4(%eax),%edx
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	89 50 04             	mov    %edx,0x4(%eax)
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ab:	89 10                	mov    %edx,(%eax)
  8022ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b0:	8b 40 04             	mov    0x4(%eax),%eax
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	74 0d                	je     8022c4 <insert_sorted_allocList+0x162>
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	8b 40 04             	mov    0x4(%eax),%eax
  8022bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c0:	89 10                	mov    %edx,(%eax)
  8022c2:	eb 08                	jmp    8022cc <insert_sorted_allocList+0x16a>
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	a3 40 40 80 00       	mov    %eax,0x804040
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d2:	89 50 04             	mov    %edx,0x4(%eax)
  8022d5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022da:	40                   	inc    %eax
  8022db:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8022e0:	e9 59 01 00 00       	jmp    80243e <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	8b 50 08             	mov    0x8(%eax),%edx
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	8b 40 08             	mov    0x8(%eax),%eax
  8022f1:	39 c2                	cmp    %eax,%edx
  8022f3:	0f 86 98 00 00 00    	jbe    802391 <insert_sorted_allocList+0x22f>
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	8b 50 08             	mov    0x8(%eax),%edx
  8022ff:	a1 44 40 80 00       	mov    0x804044,%eax
  802304:	8b 40 08             	mov    0x8(%eax),%eax
  802307:	39 c2                	cmp    %eax,%edx
  802309:	0f 83 82 00 00 00    	jae    802391 <insert_sorted_allocList+0x22f>
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	8b 50 08             	mov    0x8(%eax),%edx
  802315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802318:	8b 00                	mov    (%eax),%eax
  80231a:	8b 40 08             	mov    0x8(%eax),%eax
  80231d:	39 c2                	cmp    %eax,%edx
  80231f:	73 70                	jae    802391 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802321:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802325:	74 06                	je     80232d <insert_sorted_allocList+0x1cb>
  802327:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80232b:	75 14                	jne    802341 <insert_sorted_allocList+0x1df>
  80232d:	83 ec 04             	sub    $0x4,%esp
  802330:	68 44 3c 80 00       	push   $0x803c44
  802335:	6a 7c                	push   $0x7c
  802337:	68 f3 3b 80 00       	push   $0x803bf3
  80233c:	e8 90 df ff ff       	call   8002d1 <_panic>
  802341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802344:	8b 10                	mov    (%eax),%edx
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	89 10                	mov    %edx,(%eax)
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	8b 00                	mov    (%eax),%eax
  802350:	85 c0                	test   %eax,%eax
  802352:	74 0b                	je     80235f <insert_sorted_allocList+0x1fd>
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 00                	mov    (%eax),%eax
  802359:	8b 55 08             	mov    0x8(%ebp),%edx
  80235c:	89 50 04             	mov    %edx,0x4(%eax)
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	8b 55 08             	mov    0x8(%ebp),%edx
  802365:	89 10                	mov    %edx,(%eax)
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236d:	89 50 04             	mov    %edx,0x4(%eax)
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	8b 00                	mov    (%eax),%eax
  802375:	85 c0                	test   %eax,%eax
  802377:	75 08                	jne    802381 <insert_sorted_allocList+0x21f>
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	a3 44 40 80 00       	mov    %eax,0x804044
  802381:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802386:	40                   	inc    %eax
  802387:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80238c:	e9 ad 00 00 00       	jmp    80243e <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802391:	8b 45 08             	mov    0x8(%ebp),%eax
  802394:	8b 50 08             	mov    0x8(%eax),%edx
  802397:	a1 44 40 80 00       	mov    0x804044,%eax
  80239c:	8b 40 08             	mov    0x8(%eax),%eax
  80239f:	39 c2                	cmp    %eax,%edx
  8023a1:	76 65                	jbe    802408 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8023a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023a7:	75 17                	jne    8023c0 <insert_sorted_allocList+0x25e>
  8023a9:	83 ec 04             	sub    $0x4,%esp
  8023ac:	68 78 3c 80 00       	push   $0x803c78
  8023b1:	68 80 00 00 00       	push   $0x80
  8023b6:	68 f3 3b 80 00       	push   $0x803bf3
  8023bb:	e8 11 df ff ff       	call   8002d1 <_panic>
  8023c0:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c9:	89 50 04             	mov    %edx,0x4(%eax)
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	8b 40 04             	mov    0x4(%eax),%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	74 0c                	je     8023e2 <insert_sorted_allocList+0x280>
  8023d6:	a1 44 40 80 00       	mov    0x804044,%eax
  8023db:	8b 55 08             	mov    0x8(%ebp),%edx
  8023de:	89 10                	mov    %edx,(%eax)
  8023e0:	eb 08                	jmp    8023ea <insert_sorted_allocList+0x288>
  8023e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e5:	a3 40 40 80 00       	mov    %eax,0x804040
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	a3 44 40 80 00       	mov    %eax,0x804044
  8023f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023fb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802400:	40                   	inc    %eax
  802401:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802406:	eb 36                	jmp    80243e <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802408:	a1 48 40 80 00       	mov    0x804048,%eax
  80240d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802410:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802414:	74 07                	je     80241d <insert_sorted_allocList+0x2bb>
  802416:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802419:	8b 00                	mov    (%eax),%eax
  80241b:	eb 05                	jmp    802422 <insert_sorted_allocList+0x2c0>
  80241d:	b8 00 00 00 00       	mov    $0x0,%eax
  802422:	a3 48 40 80 00       	mov    %eax,0x804048
  802427:	a1 48 40 80 00       	mov    0x804048,%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	0f 85 23 fe ff ff    	jne    802257 <insert_sorted_allocList+0xf5>
  802434:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802438:	0f 85 19 fe ff ff    	jne    802257 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  80243e:	90                   	nop
  80243f:	c9                   	leave  
  802440:	c3                   	ret    

00802441 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802441:	55                   	push   %ebp
  802442:	89 e5                	mov    %esp,%ebp
  802444:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802447:	a1 38 41 80 00       	mov    0x804138,%eax
  80244c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244f:	e9 7c 01 00 00       	jmp    8025d0 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 0c             	mov    0xc(%eax),%eax
  80245a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245d:	0f 85 90 00 00 00    	jne    8024f3 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802469:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246d:	75 17                	jne    802486 <alloc_block_FF+0x45>
  80246f:	83 ec 04             	sub    $0x4,%esp
  802472:	68 9b 3c 80 00       	push   $0x803c9b
  802477:	68 ba 00 00 00       	push   $0xba
  80247c:	68 f3 3b 80 00       	push   $0x803bf3
  802481:	e8 4b de ff ff       	call   8002d1 <_panic>
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	8b 00                	mov    (%eax),%eax
  80248b:	85 c0                	test   %eax,%eax
  80248d:	74 10                	je     80249f <alloc_block_FF+0x5e>
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 00                	mov    (%eax),%eax
  802494:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802497:	8b 52 04             	mov    0x4(%edx),%edx
  80249a:	89 50 04             	mov    %edx,0x4(%eax)
  80249d:	eb 0b                	jmp    8024aa <alloc_block_FF+0x69>
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	8b 40 04             	mov    0x4(%eax),%eax
  8024a5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 40 04             	mov    0x4(%eax),%eax
  8024b0:	85 c0                	test   %eax,%eax
  8024b2:	74 0f                	je     8024c3 <alloc_block_FF+0x82>
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024bd:	8b 12                	mov    (%edx),%edx
  8024bf:	89 10                	mov    %edx,(%eax)
  8024c1:	eb 0a                	jmp    8024cd <alloc_block_FF+0x8c>
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	8b 00                	mov    (%eax),%eax
  8024c8:	a3 38 41 80 00       	mov    %eax,0x804138
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e0:	a1 44 41 80 00       	mov    0x804144,%eax
  8024e5:	48                   	dec    %eax
  8024e6:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8024eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ee:	e9 10 01 00 00       	jmp    802603 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024fc:	0f 86 c6 00 00 00    	jbe    8025c8 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  802502:	a1 48 41 80 00       	mov    0x804148,%eax
  802507:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80250a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80250e:	75 17                	jne    802527 <alloc_block_FF+0xe6>
  802510:	83 ec 04             	sub    $0x4,%esp
  802513:	68 9b 3c 80 00       	push   $0x803c9b
  802518:	68 c2 00 00 00       	push   $0xc2
  80251d:	68 f3 3b 80 00       	push   $0x803bf3
  802522:	e8 aa dd ff ff       	call   8002d1 <_panic>
  802527:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252a:	8b 00                	mov    (%eax),%eax
  80252c:	85 c0                	test   %eax,%eax
  80252e:	74 10                	je     802540 <alloc_block_FF+0xff>
  802530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802533:	8b 00                	mov    (%eax),%eax
  802535:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802538:	8b 52 04             	mov    0x4(%edx),%edx
  80253b:	89 50 04             	mov    %edx,0x4(%eax)
  80253e:	eb 0b                	jmp    80254b <alloc_block_FF+0x10a>
  802540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802543:	8b 40 04             	mov    0x4(%eax),%eax
  802546:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80254b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254e:	8b 40 04             	mov    0x4(%eax),%eax
  802551:	85 c0                	test   %eax,%eax
  802553:	74 0f                	je     802564 <alloc_block_FF+0x123>
  802555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802558:	8b 40 04             	mov    0x4(%eax),%eax
  80255b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255e:	8b 12                	mov    (%edx),%edx
  802560:	89 10                	mov    %edx,(%eax)
  802562:	eb 0a                	jmp    80256e <alloc_block_FF+0x12d>
  802564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802567:	8b 00                	mov    (%eax),%eax
  802569:	a3 48 41 80 00       	mov    %eax,0x804148
  80256e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802571:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802581:	a1 54 41 80 00       	mov    0x804154,%eax
  802586:	48                   	dec    %eax
  802587:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 50 08             	mov    0x8(%eax),%edx
  802592:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802595:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259b:	8b 55 08             	mov    0x8(%ebp),%edx
  80259e:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a7:	2b 45 08             	sub    0x8(%ebp),%eax
  8025aa:	89 c2                	mov    %eax,%edx
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 50 08             	mov    0x8(%eax),%edx
  8025b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bb:	01 c2                	add    %eax,%edx
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8025c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c6:	eb 3b                	jmp    802603 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025c8:	a1 40 41 80 00       	mov    0x804140,%eax
  8025cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d4:	74 07                	je     8025dd <alloc_block_FF+0x19c>
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	8b 00                	mov    (%eax),%eax
  8025db:	eb 05                	jmp    8025e2 <alloc_block_FF+0x1a1>
  8025dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e2:	a3 40 41 80 00       	mov    %eax,0x804140
  8025e7:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ec:	85 c0                	test   %eax,%eax
  8025ee:	0f 85 60 fe ff ff    	jne    802454 <alloc_block_FF+0x13>
  8025f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f8:	0f 85 56 fe ff ff    	jne    802454 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
  802608:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  80260b:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802612:	a1 38 41 80 00       	mov    0x804138,%eax
  802617:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80261a:	eb 3a                	jmp    802656 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 40 0c             	mov    0xc(%eax),%eax
  802622:	3b 45 08             	cmp    0x8(%ebp),%eax
  802625:	72 27                	jb     80264e <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802627:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80262b:	75 0b                	jne    802638 <alloc_block_BF+0x33>
					best_size= element->size;
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 40 0c             	mov    0xc(%eax),%eax
  802633:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802636:	eb 16                	jmp    80264e <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 50 0c             	mov    0xc(%eax),%edx
  80263e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802641:	39 c2                	cmp    %eax,%edx
  802643:	77 09                	ja     80264e <alloc_block_BF+0x49>
					best_size=element->size;
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 40 0c             	mov    0xc(%eax),%eax
  80264b:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80264e:	a1 40 41 80 00       	mov    0x804140,%eax
  802653:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265a:	74 07                	je     802663 <alloc_block_BF+0x5e>
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 00                	mov    (%eax),%eax
  802661:	eb 05                	jmp    802668 <alloc_block_BF+0x63>
  802663:	b8 00 00 00 00       	mov    $0x0,%eax
  802668:	a3 40 41 80 00       	mov    %eax,0x804140
  80266d:	a1 40 41 80 00       	mov    0x804140,%eax
  802672:	85 c0                	test   %eax,%eax
  802674:	75 a6                	jne    80261c <alloc_block_BF+0x17>
  802676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267a:	75 a0                	jne    80261c <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80267c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802680:	0f 84 d3 01 00 00    	je     802859 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802686:	a1 38 41 80 00       	mov    0x804138,%eax
  80268b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268e:	e9 98 01 00 00       	jmp    80282b <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802696:	3b 45 08             	cmp    0x8(%ebp),%eax
  802699:	0f 86 da 00 00 00    	jbe    802779 <alloc_block_BF+0x174>
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 50 0c             	mov    0xc(%eax),%edx
  8026a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a8:	39 c2                	cmp    %eax,%edx
  8026aa:	0f 85 c9 00 00 00    	jne    802779 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  8026b0:	a1 48 41 80 00       	mov    0x804148,%eax
  8026b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8026b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026bc:	75 17                	jne    8026d5 <alloc_block_BF+0xd0>
  8026be:	83 ec 04             	sub    $0x4,%esp
  8026c1:	68 9b 3c 80 00       	push   $0x803c9b
  8026c6:	68 ea 00 00 00       	push   $0xea
  8026cb:	68 f3 3b 80 00       	push   $0x803bf3
  8026d0:	e8 fc db ff ff       	call   8002d1 <_panic>
  8026d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d8:	8b 00                	mov    (%eax),%eax
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	74 10                	je     8026ee <alloc_block_BF+0xe9>
  8026de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e6:	8b 52 04             	mov    0x4(%edx),%edx
  8026e9:	89 50 04             	mov    %edx,0x4(%eax)
  8026ec:	eb 0b                	jmp    8026f9 <alloc_block_BF+0xf4>
  8026ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f1:	8b 40 04             	mov    0x4(%eax),%eax
  8026f4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fc:	8b 40 04             	mov    0x4(%eax),%eax
  8026ff:	85 c0                	test   %eax,%eax
  802701:	74 0f                	je     802712 <alloc_block_BF+0x10d>
  802703:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802706:	8b 40 04             	mov    0x4(%eax),%eax
  802709:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80270c:	8b 12                	mov    (%edx),%edx
  80270e:	89 10                	mov    %edx,(%eax)
  802710:	eb 0a                	jmp    80271c <alloc_block_BF+0x117>
  802712:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802715:	8b 00                	mov    (%eax),%eax
  802717:	a3 48 41 80 00       	mov    %eax,0x804148
  80271c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802725:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802728:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272f:	a1 54 41 80 00       	mov    0x804154,%eax
  802734:	48                   	dec    %eax
  802735:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  80273a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273d:	8b 50 08             	mov    0x8(%eax),%edx
  802740:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802743:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802746:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802749:	8b 55 08             	mov    0x8(%ebp),%edx
  80274c:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	8b 40 0c             	mov    0xc(%eax),%eax
  802755:	2b 45 08             	sub    0x8(%ebp),%eax
  802758:	89 c2                	mov    %eax,%edx
  80275a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275d:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802763:	8b 50 08             	mov    0x8(%eax),%edx
  802766:	8b 45 08             	mov    0x8(%ebp),%eax
  802769:	01 c2                	add    %eax,%edx
  80276b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276e:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802771:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802774:	e9 e5 00 00 00       	jmp    80285e <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 50 0c             	mov    0xc(%eax),%edx
  80277f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802782:	39 c2                	cmp    %eax,%edx
  802784:	0f 85 99 00 00 00    	jne    802823 <alloc_block_BF+0x21e>
  80278a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802790:	0f 85 8d 00 00 00    	jne    802823 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  80279c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027a0:	75 17                	jne    8027b9 <alloc_block_BF+0x1b4>
  8027a2:	83 ec 04             	sub    $0x4,%esp
  8027a5:	68 9b 3c 80 00       	push   $0x803c9b
  8027aa:	68 f7 00 00 00       	push   $0xf7
  8027af:	68 f3 3b 80 00       	push   $0x803bf3
  8027b4:	e8 18 db ff ff       	call   8002d1 <_panic>
  8027b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bc:	8b 00                	mov    (%eax),%eax
  8027be:	85 c0                	test   %eax,%eax
  8027c0:	74 10                	je     8027d2 <alloc_block_BF+0x1cd>
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 00                	mov    (%eax),%eax
  8027c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ca:	8b 52 04             	mov    0x4(%edx),%edx
  8027cd:	89 50 04             	mov    %edx,0x4(%eax)
  8027d0:	eb 0b                	jmp    8027dd <alloc_block_BF+0x1d8>
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	8b 40 04             	mov    0x4(%eax),%eax
  8027d8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 40 04             	mov    0x4(%eax),%eax
  8027e3:	85 c0                	test   %eax,%eax
  8027e5:	74 0f                	je     8027f6 <alloc_block_BF+0x1f1>
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 40 04             	mov    0x4(%eax),%eax
  8027ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f0:	8b 12                	mov    (%edx),%edx
  8027f2:	89 10                	mov    %edx,(%eax)
  8027f4:	eb 0a                	jmp    802800 <alloc_block_BF+0x1fb>
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	8b 00                	mov    (%eax),%eax
  8027fb:	a3 38 41 80 00       	mov    %eax,0x804138
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802813:	a1 44 41 80 00       	mov    0x804144,%eax
  802818:	48                   	dec    %eax
  802819:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  80281e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802821:	eb 3b                	jmp    80285e <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802823:	a1 40 41 80 00       	mov    0x804140,%eax
  802828:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282f:	74 07                	je     802838 <alloc_block_BF+0x233>
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	8b 00                	mov    (%eax),%eax
  802836:	eb 05                	jmp    80283d <alloc_block_BF+0x238>
  802838:	b8 00 00 00 00       	mov    $0x0,%eax
  80283d:	a3 40 41 80 00       	mov    %eax,0x804140
  802842:	a1 40 41 80 00       	mov    0x804140,%eax
  802847:	85 c0                	test   %eax,%eax
  802849:	0f 85 44 fe ff ff    	jne    802693 <alloc_block_BF+0x8e>
  80284f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802853:	0f 85 3a fe ff ff    	jne    802693 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802859:	b8 00 00 00 00       	mov    $0x0,%eax
  80285e:	c9                   	leave  
  80285f:	c3                   	ret    

00802860 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
  802863:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802866:	83 ec 04             	sub    $0x4,%esp
  802869:	68 bc 3c 80 00       	push   $0x803cbc
  80286e:	68 04 01 00 00       	push   $0x104
  802873:	68 f3 3b 80 00       	push   $0x803bf3
  802878:	e8 54 da ff ff       	call   8002d1 <_panic>

0080287d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80287d:	55                   	push   %ebp
  80287e:	89 e5                	mov    %esp,%ebp
  802880:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802883:	a1 38 41 80 00       	mov    0x804138,%eax
  802888:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  80288b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802890:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802893:	a1 38 41 80 00       	mov    0x804138,%eax
  802898:	85 c0                	test   %eax,%eax
  80289a:	75 68                	jne    802904 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80289c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028a0:	75 17                	jne    8028b9 <insert_sorted_with_merge_freeList+0x3c>
  8028a2:	83 ec 04             	sub    $0x4,%esp
  8028a5:	68 d0 3b 80 00       	push   $0x803bd0
  8028aa:	68 14 01 00 00       	push   $0x114
  8028af:	68 f3 3b 80 00       	push   $0x803bf3
  8028b4:	e8 18 da ff ff       	call   8002d1 <_panic>
  8028b9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	89 10                	mov    %edx,(%eax)
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	8b 00                	mov    (%eax),%eax
  8028c9:	85 c0                	test   %eax,%eax
  8028cb:	74 0d                	je     8028da <insert_sorted_with_merge_freeList+0x5d>
  8028cd:	a1 38 41 80 00       	mov    0x804138,%eax
  8028d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d5:	89 50 04             	mov    %edx,0x4(%eax)
  8028d8:	eb 08                	jmp    8028e2 <insert_sorted_with_merge_freeList+0x65>
  8028da:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	a3 38 41 80 00       	mov    %eax,0x804138
  8028ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f4:	a1 44 41 80 00       	mov    0x804144,%eax
  8028f9:	40                   	inc    %eax
  8028fa:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8028ff:	e9 d2 06 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802904:	8b 45 08             	mov    0x8(%ebp),%eax
  802907:	8b 50 08             	mov    0x8(%eax),%edx
  80290a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290d:	8b 40 08             	mov    0x8(%eax),%eax
  802910:	39 c2                	cmp    %eax,%edx
  802912:	0f 83 22 01 00 00    	jae    802a3a <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802918:	8b 45 08             	mov    0x8(%ebp),%eax
  80291b:	8b 50 08             	mov    0x8(%eax),%edx
  80291e:	8b 45 08             	mov    0x8(%ebp),%eax
  802921:	8b 40 0c             	mov    0xc(%eax),%eax
  802924:	01 c2                	add    %eax,%edx
  802926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802929:	8b 40 08             	mov    0x8(%eax),%eax
  80292c:	39 c2                	cmp    %eax,%edx
  80292e:	0f 85 9e 00 00 00    	jne    8029d2 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802934:	8b 45 08             	mov    0x8(%ebp),%eax
  802937:	8b 50 08             	mov    0x8(%eax),%edx
  80293a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293d:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802943:	8b 50 0c             	mov    0xc(%eax),%edx
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	8b 40 0c             	mov    0xc(%eax),%eax
  80294c:	01 c2                	add    %eax,%edx
  80294e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802951:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	8b 50 08             	mov    0x8(%eax),%edx
  802964:	8b 45 08             	mov    0x8(%ebp),%eax
  802967:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80296a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80296e:	75 17                	jne    802987 <insert_sorted_with_merge_freeList+0x10a>
  802970:	83 ec 04             	sub    $0x4,%esp
  802973:	68 d0 3b 80 00       	push   $0x803bd0
  802978:	68 21 01 00 00       	push   $0x121
  80297d:	68 f3 3b 80 00       	push   $0x803bf3
  802982:	e8 4a d9 ff ff       	call   8002d1 <_panic>
  802987:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80298d:	8b 45 08             	mov    0x8(%ebp),%eax
  802990:	89 10                	mov    %edx,(%eax)
  802992:	8b 45 08             	mov    0x8(%ebp),%eax
  802995:	8b 00                	mov    (%eax),%eax
  802997:	85 c0                	test   %eax,%eax
  802999:	74 0d                	je     8029a8 <insert_sorted_with_merge_freeList+0x12b>
  80299b:	a1 48 41 80 00       	mov    0x804148,%eax
  8029a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a3:	89 50 04             	mov    %edx,0x4(%eax)
  8029a6:	eb 08                	jmp    8029b0 <insert_sorted_with_merge_freeList+0x133>
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	a3 48 41 80 00       	mov    %eax,0x804148
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c2:	a1 54 41 80 00       	mov    0x804154,%eax
  8029c7:	40                   	inc    %eax
  8029c8:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  8029cd:	e9 04 06 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8029d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d6:	75 17                	jne    8029ef <insert_sorted_with_merge_freeList+0x172>
  8029d8:	83 ec 04             	sub    $0x4,%esp
  8029db:	68 d0 3b 80 00       	push   $0x803bd0
  8029e0:	68 26 01 00 00       	push   $0x126
  8029e5:	68 f3 3b 80 00       	push   $0x803bf3
  8029ea:	e8 e2 d8 ff ff       	call   8002d1 <_panic>
  8029ef:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f8:	89 10                	mov    %edx,(%eax)
  8029fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fd:	8b 00                	mov    (%eax),%eax
  8029ff:	85 c0                	test   %eax,%eax
  802a01:	74 0d                	je     802a10 <insert_sorted_with_merge_freeList+0x193>
  802a03:	a1 38 41 80 00       	mov    0x804138,%eax
  802a08:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0b:	89 50 04             	mov    %edx,0x4(%eax)
  802a0e:	eb 08                	jmp    802a18 <insert_sorted_with_merge_freeList+0x19b>
  802a10:	8b 45 08             	mov    0x8(%ebp),%eax
  802a13:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	a3 38 41 80 00       	mov    %eax,0x804138
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2a:	a1 44 41 80 00       	mov    0x804144,%eax
  802a2f:	40                   	inc    %eax
  802a30:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802a35:	e9 9c 05 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	8b 50 08             	mov    0x8(%eax),%edx
  802a40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a43:	8b 40 08             	mov    0x8(%eax),%eax
  802a46:	39 c2                	cmp    %eax,%edx
  802a48:	0f 86 16 01 00 00    	jbe    802b64 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802a4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a51:	8b 50 08             	mov    0x8(%eax),%edx
  802a54:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a57:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5a:	01 c2                	add    %eax,%edx
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	8b 40 08             	mov    0x8(%eax),%eax
  802a62:	39 c2                	cmp    %eax,%edx
  802a64:	0f 85 92 00 00 00    	jne    802afc <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802a6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6d:	8b 50 0c             	mov    0xc(%eax),%edx
  802a70:	8b 45 08             	mov    0x8(%ebp),%eax
  802a73:	8b 40 0c             	mov    0xc(%eax),%eax
  802a76:	01 c2                	add    %eax,%edx
  802a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	8b 50 08             	mov    0x8(%eax),%edx
  802a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a91:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a94:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a98:	75 17                	jne    802ab1 <insert_sorted_with_merge_freeList+0x234>
  802a9a:	83 ec 04             	sub    $0x4,%esp
  802a9d:	68 d0 3b 80 00       	push   $0x803bd0
  802aa2:	68 31 01 00 00       	push   $0x131
  802aa7:	68 f3 3b 80 00       	push   $0x803bf3
  802aac:	e8 20 d8 ff ff       	call   8002d1 <_panic>
  802ab1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	89 10                	mov    %edx,(%eax)
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	8b 00                	mov    (%eax),%eax
  802ac1:	85 c0                	test   %eax,%eax
  802ac3:	74 0d                	je     802ad2 <insert_sorted_with_merge_freeList+0x255>
  802ac5:	a1 48 41 80 00       	mov    0x804148,%eax
  802aca:	8b 55 08             	mov    0x8(%ebp),%edx
  802acd:	89 50 04             	mov    %edx,0x4(%eax)
  802ad0:	eb 08                	jmp    802ada <insert_sorted_with_merge_freeList+0x25d>
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	a3 48 41 80 00       	mov    %eax,0x804148
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aec:	a1 54 41 80 00       	mov    0x804154,%eax
  802af1:	40                   	inc    %eax
  802af2:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802af7:	e9 da 04 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802afc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b00:	75 17                	jne    802b19 <insert_sorted_with_merge_freeList+0x29c>
  802b02:	83 ec 04             	sub    $0x4,%esp
  802b05:	68 78 3c 80 00       	push   $0x803c78
  802b0a:	68 37 01 00 00       	push   $0x137
  802b0f:	68 f3 3b 80 00       	push   $0x803bf3
  802b14:	e8 b8 d7 ff ff       	call   8002d1 <_panic>
  802b19:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	89 50 04             	mov    %edx,0x4(%eax)
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	8b 40 04             	mov    0x4(%eax),%eax
  802b2b:	85 c0                	test   %eax,%eax
  802b2d:	74 0c                	je     802b3b <insert_sorted_with_merge_freeList+0x2be>
  802b2f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b34:	8b 55 08             	mov    0x8(%ebp),%edx
  802b37:	89 10                	mov    %edx,(%eax)
  802b39:	eb 08                	jmp    802b43 <insert_sorted_with_merge_freeList+0x2c6>
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	a3 38 41 80 00       	mov    %eax,0x804138
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b54:	a1 44 41 80 00       	mov    0x804144,%eax
  802b59:	40                   	inc    %eax
  802b5a:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b5f:	e9 72 04 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802b64:	a1 38 41 80 00       	mov    0x804138,%eax
  802b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b6c:	e9 35 04 00 00       	jmp    802fa6 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	8b 00                	mov    (%eax),%eax
  802b76:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	8b 50 08             	mov    0x8(%eax),%edx
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 40 08             	mov    0x8(%eax),%eax
  802b85:	39 c2                	cmp    %eax,%edx
  802b87:	0f 86 11 04 00 00    	jbe    802f9e <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 50 08             	mov    0x8(%eax),%edx
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	8b 40 0c             	mov    0xc(%eax),%eax
  802b99:	01 c2                	add    %eax,%edx
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	8b 40 08             	mov    0x8(%eax),%eax
  802ba1:	39 c2                	cmp    %eax,%edx
  802ba3:	0f 83 8b 00 00 00    	jae    802c34 <insert_sorted_with_merge_freeList+0x3b7>
  802ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bac:	8b 50 08             	mov    0x8(%eax),%edx
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb5:	01 c2                	add    %eax,%edx
  802bb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bba:	8b 40 08             	mov    0x8(%eax),%eax
  802bbd:	39 c2                	cmp    %eax,%edx
  802bbf:	73 73                	jae    802c34 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802bc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc5:	74 06                	je     802bcd <insert_sorted_with_merge_freeList+0x350>
  802bc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bcb:	75 17                	jne    802be4 <insert_sorted_with_merge_freeList+0x367>
  802bcd:	83 ec 04             	sub    $0x4,%esp
  802bd0:	68 44 3c 80 00       	push   $0x803c44
  802bd5:	68 48 01 00 00       	push   $0x148
  802bda:	68 f3 3b 80 00       	push   $0x803bf3
  802bdf:	e8 ed d6 ff ff       	call   8002d1 <_panic>
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 10                	mov    (%eax),%edx
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	89 10                	mov    %edx,(%eax)
  802bee:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf1:	8b 00                	mov    (%eax),%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	74 0b                	je     802c02 <insert_sorted_with_merge_freeList+0x385>
  802bf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	8b 55 08             	mov    0x8(%ebp),%edx
  802bff:	89 50 04             	mov    %edx,0x4(%eax)
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 55 08             	mov    0x8(%ebp),%edx
  802c08:	89 10                	mov    %edx,(%eax)
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c10:	89 50 04             	mov    %edx,0x4(%eax)
  802c13:	8b 45 08             	mov    0x8(%ebp),%eax
  802c16:	8b 00                	mov    (%eax),%eax
  802c18:	85 c0                	test   %eax,%eax
  802c1a:	75 08                	jne    802c24 <insert_sorted_with_merge_freeList+0x3a7>
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c24:	a1 44 41 80 00       	mov    0x804144,%eax
  802c29:	40                   	inc    %eax
  802c2a:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802c2f:	e9 a2 03 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802c34:	8b 45 08             	mov    0x8(%ebp),%eax
  802c37:	8b 50 08             	mov    0x8(%eax),%edx
  802c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c40:	01 c2                	add    %eax,%edx
  802c42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c45:	8b 40 08             	mov    0x8(%eax),%eax
  802c48:	39 c2                	cmp    %eax,%edx
  802c4a:	0f 83 ae 00 00 00    	jae    802cfe <insert_sorted_with_merge_freeList+0x481>
  802c50:	8b 45 08             	mov    0x8(%ebp),%eax
  802c53:	8b 50 08             	mov    0x8(%eax),%edx
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	8b 48 08             	mov    0x8(%eax),%ecx
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802c62:	01 c8                	add    %ecx,%eax
  802c64:	39 c2                	cmp    %eax,%edx
  802c66:	0f 85 92 00 00 00    	jne    802cfe <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 50 0c             	mov    0xc(%eax),%edx
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	8b 40 0c             	mov    0xc(%eax),%eax
  802c78:	01 c2                	add    %eax,%edx
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802c80:	8b 45 08             	mov    0x8(%ebp),%eax
  802c83:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	8b 50 08             	mov    0x8(%eax),%edx
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9a:	75 17                	jne    802cb3 <insert_sorted_with_merge_freeList+0x436>
  802c9c:	83 ec 04             	sub    $0x4,%esp
  802c9f:	68 d0 3b 80 00       	push   $0x803bd0
  802ca4:	68 51 01 00 00       	push   $0x151
  802ca9:	68 f3 3b 80 00       	push   $0x803bf3
  802cae:	e8 1e d6 ff ff       	call   8002d1 <_panic>
  802cb3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	89 10                	mov    %edx,(%eax)
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	8b 00                	mov    (%eax),%eax
  802cc3:	85 c0                	test   %eax,%eax
  802cc5:	74 0d                	je     802cd4 <insert_sorted_with_merge_freeList+0x457>
  802cc7:	a1 48 41 80 00       	mov    0x804148,%eax
  802ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccf:	89 50 04             	mov    %edx,0x4(%eax)
  802cd2:	eb 08                	jmp    802cdc <insert_sorted_with_merge_freeList+0x45f>
  802cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	a3 48 41 80 00       	mov    %eax,0x804148
  802ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cee:	a1 54 41 80 00       	mov    0x804154,%eax
  802cf3:	40                   	inc    %eax
  802cf4:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802cf9:	e9 d8 02 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	8b 50 08             	mov    0x8(%eax),%edx
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0a:	01 c2                	add    %eax,%edx
  802d0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0f:	8b 40 08             	mov    0x8(%eax),%eax
  802d12:	39 c2                	cmp    %eax,%edx
  802d14:	0f 85 ba 00 00 00    	jne    802dd4 <insert_sorted_with_merge_freeList+0x557>
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	8b 50 08             	mov    0x8(%eax),%edx
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	8b 48 08             	mov    0x8(%eax),%ecx
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2c:	01 c8                	add    %ecx,%eax
  802d2e:	39 c2                	cmp    %eax,%edx
  802d30:	0f 86 9e 00 00 00    	jbe    802dd4 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d39:	8b 50 0c             	mov    0xc(%eax),%edx
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d42:	01 c2                	add    %eax,%edx
  802d44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d47:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	8b 50 08             	mov    0x8(%eax),%edx
  802d50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d53:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	8b 50 08             	mov    0x8(%eax),%edx
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d70:	75 17                	jne    802d89 <insert_sorted_with_merge_freeList+0x50c>
  802d72:	83 ec 04             	sub    $0x4,%esp
  802d75:	68 d0 3b 80 00       	push   $0x803bd0
  802d7a:	68 5b 01 00 00       	push   $0x15b
  802d7f:	68 f3 3b 80 00       	push   $0x803bf3
  802d84:	e8 48 d5 ff ff       	call   8002d1 <_panic>
  802d89:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d92:	89 10                	mov    %edx,(%eax)
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	8b 00                	mov    (%eax),%eax
  802d99:	85 c0                	test   %eax,%eax
  802d9b:	74 0d                	je     802daa <insert_sorted_with_merge_freeList+0x52d>
  802d9d:	a1 48 41 80 00       	mov    0x804148,%eax
  802da2:	8b 55 08             	mov    0x8(%ebp),%edx
  802da5:	89 50 04             	mov    %edx,0x4(%eax)
  802da8:	eb 08                	jmp    802db2 <insert_sorted_with_merge_freeList+0x535>
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	a3 48 41 80 00       	mov    %eax,0x804148
  802dba:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc4:	a1 54 41 80 00       	mov    0x804154,%eax
  802dc9:	40                   	inc    %eax
  802dca:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802dcf:	e9 02 02 00 00       	jmp    802fd6 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	8b 50 08             	mov    0x8(%eax),%edx
  802dda:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddd:	8b 40 0c             	mov    0xc(%eax),%eax
  802de0:	01 c2                	add    %eax,%edx
  802de2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de5:	8b 40 08             	mov    0x8(%eax),%eax
  802de8:	39 c2                	cmp    %eax,%edx
  802dea:	0f 85 ae 01 00 00    	jne    802f9e <insert_sorted_with_merge_freeList+0x721>
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	8b 50 08             	mov    0x8(%eax),%edx
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 48 08             	mov    0x8(%eax),%ecx
  802dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dff:	8b 40 0c             	mov    0xc(%eax),%eax
  802e02:	01 c8                	add    %ecx,%eax
  802e04:	39 c2                	cmp    %eax,%edx
  802e06:	0f 85 92 01 00 00    	jne    802f9e <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 50 0c             	mov    0xc(%eax),%edx
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	8b 40 0c             	mov    0xc(%eax),%eax
  802e18:	01 c2                	add    %eax,%edx
  802e1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e20:	01 c2                	add    %eax,%edx
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e32:	8b 45 08             	mov    0x8(%ebp),%eax
  802e35:	8b 50 08             	mov    0x8(%eax),%edx
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802e3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e41:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4b:	8b 50 08             	mov    0x8(%eax),%edx
  802e4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e51:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802e54:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e58:	75 17                	jne    802e71 <insert_sorted_with_merge_freeList+0x5f4>
  802e5a:	83 ec 04             	sub    $0x4,%esp
  802e5d:	68 9b 3c 80 00       	push   $0x803c9b
  802e62:	68 63 01 00 00       	push   $0x163
  802e67:	68 f3 3b 80 00       	push   $0x803bf3
  802e6c:	e8 60 d4 ff ff       	call   8002d1 <_panic>
  802e71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e74:	8b 00                	mov    (%eax),%eax
  802e76:	85 c0                	test   %eax,%eax
  802e78:	74 10                	je     802e8a <insert_sorted_with_merge_freeList+0x60d>
  802e7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7d:	8b 00                	mov    (%eax),%eax
  802e7f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e82:	8b 52 04             	mov    0x4(%edx),%edx
  802e85:	89 50 04             	mov    %edx,0x4(%eax)
  802e88:	eb 0b                	jmp    802e95 <insert_sorted_with_merge_freeList+0x618>
  802e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8d:	8b 40 04             	mov    0x4(%eax),%eax
  802e90:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e95:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e98:	8b 40 04             	mov    0x4(%eax),%eax
  802e9b:	85 c0                	test   %eax,%eax
  802e9d:	74 0f                	je     802eae <insert_sorted_with_merge_freeList+0x631>
  802e9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea2:	8b 40 04             	mov    0x4(%eax),%eax
  802ea5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ea8:	8b 12                	mov    (%edx),%edx
  802eaa:	89 10                	mov    %edx,(%eax)
  802eac:	eb 0a                	jmp    802eb8 <insert_sorted_with_merge_freeList+0x63b>
  802eae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb1:	8b 00                	mov    (%eax),%eax
  802eb3:	a3 38 41 80 00       	mov    %eax,0x804138
  802eb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ecb:	a1 44 41 80 00       	mov    0x804144,%eax
  802ed0:	48                   	dec    %eax
  802ed1:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802ed6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802eda:	75 17                	jne    802ef3 <insert_sorted_with_merge_freeList+0x676>
  802edc:	83 ec 04             	sub    $0x4,%esp
  802edf:	68 d0 3b 80 00       	push   $0x803bd0
  802ee4:	68 64 01 00 00       	push   $0x164
  802ee9:	68 f3 3b 80 00       	push   $0x803bf3
  802eee:	e8 de d3 ff ff       	call   8002d1 <_panic>
  802ef3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efc:	89 10                	mov    %edx,(%eax)
  802efe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f01:	8b 00                	mov    (%eax),%eax
  802f03:	85 c0                	test   %eax,%eax
  802f05:	74 0d                	je     802f14 <insert_sorted_with_merge_freeList+0x697>
  802f07:	a1 48 41 80 00       	mov    0x804148,%eax
  802f0c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f0f:	89 50 04             	mov    %edx,0x4(%eax)
  802f12:	eb 08                	jmp    802f1c <insert_sorted_with_merge_freeList+0x69f>
  802f14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f17:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f1c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1f:	a3 48 41 80 00       	mov    %eax,0x804148
  802f24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2e:	a1 54 41 80 00       	mov    0x804154,%eax
  802f33:	40                   	inc    %eax
  802f34:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f3d:	75 17                	jne    802f56 <insert_sorted_with_merge_freeList+0x6d9>
  802f3f:	83 ec 04             	sub    $0x4,%esp
  802f42:	68 d0 3b 80 00       	push   $0x803bd0
  802f47:	68 65 01 00 00       	push   $0x165
  802f4c:	68 f3 3b 80 00       	push   $0x803bf3
  802f51:	e8 7b d3 ff ff       	call   8002d1 <_panic>
  802f56:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	89 10                	mov    %edx,(%eax)
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	74 0d                	je     802f77 <insert_sorted_with_merge_freeList+0x6fa>
  802f6a:	a1 48 41 80 00       	mov    0x804148,%eax
  802f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f72:	89 50 04             	mov    %edx,0x4(%eax)
  802f75:	eb 08                	jmp    802f7f <insert_sorted_with_merge_freeList+0x702>
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	a3 48 41 80 00       	mov    %eax,0x804148
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f91:	a1 54 41 80 00       	mov    0x804154,%eax
  802f96:	40                   	inc    %eax
  802f97:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802f9c:	eb 38                	jmp    802fd6 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f9e:	a1 40 41 80 00       	mov    0x804140,%eax
  802fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802faa:	74 07                	je     802fb3 <insert_sorted_with_merge_freeList+0x736>
  802fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faf:	8b 00                	mov    (%eax),%eax
  802fb1:	eb 05                	jmp    802fb8 <insert_sorted_with_merge_freeList+0x73b>
  802fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb8:	a3 40 41 80 00       	mov    %eax,0x804140
  802fbd:	a1 40 41 80 00       	mov    0x804140,%eax
  802fc2:	85 c0                	test   %eax,%eax
  802fc4:	0f 85 a7 fb ff ff    	jne    802b71 <insert_sorted_with_merge_freeList+0x2f4>
  802fca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fce:	0f 85 9d fb ff ff    	jne    802b71 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802fd4:	eb 00                	jmp    802fd6 <insert_sorted_with_merge_freeList+0x759>
  802fd6:	90                   	nop
  802fd7:	c9                   	leave  
  802fd8:	c3                   	ret    

00802fd9 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802fd9:	55                   	push   %ebp
  802fda:	89 e5                	mov    %esp,%ebp
  802fdc:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe2:	89 d0                	mov    %edx,%eax
  802fe4:	c1 e0 02             	shl    $0x2,%eax
  802fe7:	01 d0                	add    %edx,%eax
  802fe9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ff0:	01 d0                	add    %edx,%eax
  802ff2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ff9:	01 d0                	add    %edx,%eax
  802ffb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803002:	01 d0                	add    %edx,%eax
  803004:	c1 e0 04             	shl    $0x4,%eax
  803007:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80300a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803011:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803014:	83 ec 0c             	sub    $0xc,%esp
  803017:	50                   	push   %eax
  803018:	e8 ee eb ff ff       	call   801c0b <sys_get_virtual_time>
  80301d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803020:	eb 41                	jmp    803063 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803022:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803025:	83 ec 0c             	sub    $0xc,%esp
  803028:	50                   	push   %eax
  803029:	e8 dd eb ff ff       	call   801c0b <sys_get_virtual_time>
  80302e:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803031:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803034:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803037:	29 c2                	sub    %eax,%edx
  803039:	89 d0                	mov    %edx,%eax
  80303b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80303e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803041:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803044:	89 d1                	mov    %edx,%ecx
  803046:	29 c1                	sub    %eax,%ecx
  803048:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80304b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80304e:	39 c2                	cmp    %eax,%edx
  803050:	0f 97 c0             	seta   %al
  803053:	0f b6 c0             	movzbl %al,%eax
  803056:	29 c1                	sub    %eax,%ecx
  803058:	89 c8                	mov    %ecx,%eax
  80305a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80305d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803060:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803066:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803069:	72 b7                	jb     803022 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80306b:	90                   	nop
  80306c:	c9                   	leave  
  80306d:	c3                   	ret    

0080306e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80306e:	55                   	push   %ebp
  80306f:	89 e5                	mov    %esp,%ebp
  803071:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803074:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80307b:	eb 03                	jmp    803080 <busy_wait+0x12>
  80307d:	ff 45 fc             	incl   -0x4(%ebp)
  803080:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803083:	3b 45 08             	cmp    0x8(%ebp),%eax
  803086:	72 f5                	jb     80307d <busy_wait+0xf>
	return i;
  803088:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80308b:	c9                   	leave  
  80308c:	c3                   	ret    
  80308d:	66 90                	xchg   %ax,%ax
  80308f:	90                   	nop

00803090 <__udivdi3>:
  803090:	55                   	push   %ebp
  803091:	57                   	push   %edi
  803092:	56                   	push   %esi
  803093:	53                   	push   %ebx
  803094:	83 ec 1c             	sub    $0x1c,%esp
  803097:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80309b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80309f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030a7:	89 ca                	mov    %ecx,%edx
  8030a9:	89 f8                	mov    %edi,%eax
  8030ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030af:	85 f6                	test   %esi,%esi
  8030b1:	75 2d                	jne    8030e0 <__udivdi3+0x50>
  8030b3:	39 cf                	cmp    %ecx,%edi
  8030b5:	77 65                	ja     80311c <__udivdi3+0x8c>
  8030b7:	89 fd                	mov    %edi,%ebp
  8030b9:	85 ff                	test   %edi,%edi
  8030bb:	75 0b                	jne    8030c8 <__udivdi3+0x38>
  8030bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8030c2:	31 d2                	xor    %edx,%edx
  8030c4:	f7 f7                	div    %edi
  8030c6:	89 c5                	mov    %eax,%ebp
  8030c8:	31 d2                	xor    %edx,%edx
  8030ca:	89 c8                	mov    %ecx,%eax
  8030cc:	f7 f5                	div    %ebp
  8030ce:	89 c1                	mov    %eax,%ecx
  8030d0:	89 d8                	mov    %ebx,%eax
  8030d2:	f7 f5                	div    %ebp
  8030d4:	89 cf                	mov    %ecx,%edi
  8030d6:	89 fa                	mov    %edi,%edx
  8030d8:	83 c4 1c             	add    $0x1c,%esp
  8030db:	5b                   	pop    %ebx
  8030dc:	5e                   	pop    %esi
  8030dd:	5f                   	pop    %edi
  8030de:	5d                   	pop    %ebp
  8030df:	c3                   	ret    
  8030e0:	39 ce                	cmp    %ecx,%esi
  8030e2:	77 28                	ja     80310c <__udivdi3+0x7c>
  8030e4:	0f bd fe             	bsr    %esi,%edi
  8030e7:	83 f7 1f             	xor    $0x1f,%edi
  8030ea:	75 40                	jne    80312c <__udivdi3+0x9c>
  8030ec:	39 ce                	cmp    %ecx,%esi
  8030ee:	72 0a                	jb     8030fa <__udivdi3+0x6a>
  8030f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030f4:	0f 87 9e 00 00 00    	ja     803198 <__udivdi3+0x108>
  8030fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ff:	89 fa                	mov    %edi,%edx
  803101:	83 c4 1c             	add    $0x1c,%esp
  803104:	5b                   	pop    %ebx
  803105:	5e                   	pop    %esi
  803106:	5f                   	pop    %edi
  803107:	5d                   	pop    %ebp
  803108:	c3                   	ret    
  803109:	8d 76 00             	lea    0x0(%esi),%esi
  80310c:	31 ff                	xor    %edi,%edi
  80310e:	31 c0                	xor    %eax,%eax
  803110:	89 fa                	mov    %edi,%edx
  803112:	83 c4 1c             	add    $0x1c,%esp
  803115:	5b                   	pop    %ebx
  803116:	5e                   	pop    %esi
  803117:	5f                   	pop    %edi
  803118:	5d                   	pop    %ebp
  803119:	c3                   	ret    
  80311a:	66 90                	xchg   %ax,%ax
  80311c:	89 d8                	mov    %ebx,%eax
  80311e:	f7 f7                	div    %edi
  803120:	31 ff                	xor    %edi,%edi
  803122:	89 fa                	mov    %edi,%edx
  803124:	83 c4 1c             	add    $0x1c,%esp
  803127:	5b                   	pop    %ebx
  803128:	5e                   	pop    %esi
  803129:	5f                   	pop    %edi
  80312a:	5d                   	pop    %ebp
  80312b:	c3                   	ret    
  80312c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803131:	89 eb                	mov    %ebp,%ebx
  803133:	29 fb                	sub    %edi,%ebx
  803135:	89 f9                	mov    %edi,%ecx
  803137:	d3 e6                	shl    %cl,%esi
  803139:	89 c5                	mov    %eax,%ebp
  80313b:	88 d9                	mov    %bl,%cl
  80313d:	d3 ed                	shr    %cl,%ebp
  80313f:	89 e9                	mov    %ebp,%ecx
  803141:	09 f1                	or     %esi,%ecx
  803143:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803147:	89 f9                	mov    %edi,%ecx
  803149:	d3 e0                	shl    %cl,%eax
  80314b:	89 c5                	mov    %eax,%ebp
  80314d:	89 d6                	mov    %edx,%esi
  80314f:	88 d9                	mov    %bl,%cl
  803151:	d3 ee                	shr    %cl,%esi
  803153:	89 f9                	mov    %edi,%ecx
  803155:	d3 e2                	shl    %cl,%edx
  803157:	8b 44 24 08          	mov    0x8(%esp),%eax
  80315b:	88 d9                	mov    %bl,%cl
  80315d:	d3 e8                	shr    %cl,%eax
  80315f:	09 c2                	or     %eax,%edx
  803161:	89 d0                	mov    %edx,%eax
  803163:	89 f2                	mov    %esi,%edx
  803165:	f7 74 24 0c          	divl   0xc(%esp)
  803169:	89 d6                	mov    %edx,%esi
  80316b:	89 c3                	mov    %eax,%ebx
  80316d:	f7 e5                	mul    %ebp
  80316f:	39 d6                	cmp    %edx,%esi
  803171:	72 19                	jb     80318c <__udivdi3+0xfc>
  803173:	74 0b                	je     803180 <__udivdi3+0xf0>
  803175:	89 d8                	mov    %ebx,%eax
  803177:	31 ff                	xor    %edi,%edi
  803179:	e9 58 ff ff ff       	jmp    8030d6 <__udivdi3+0x46>
  80317e:	66 90                	xchg   %ax,%ax
  803180:	8b 54 24 08          	mov    0x8(%esp),%edx
  803184:	89 f9                	mov    %edi,%ecx
  803186:	d3 e2                	shl    %cl,%edx
  803188:	39 c2                	cmp    %eax,%edx
  80318a:	73 e9                	jae    803175 <__udivdi3+0xe5>
  80318c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80318f:	31 ff                	xor    %edi,%edi
  803191:	e9 40 ff ff ff       	jmp    8030d6 <__udivdi3+0x46>
  803196:	66 90                	xchg   %ax,%ax
  803198:	31 c0                	xor    %eax,%eax
  80319a:	e9 37 ff ff ff       	jmp    8030d6 <__udivdi3+0x46>
  80319f:	90                   	nop

008031a0 <__umoddi3>:
  8031a0:	55                   	push   %ebp
  8031a1:	57                   	push   %edi
  8031a2:	56                   	push   %esi
  8031a3:	53                   	push   %ebx
  8031a4:	83 ec 1c             	sub    $0x1c,%esp
  8031a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031bf:	89 f3                	mov    %esi,%ebx
  8031c1:	89 fa                	mov    %edi,%edx
  8031c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031c7:	89 34 24             	mov    %esi,(%esp)
  8031ca:	85 c0                	test   %eax,%eax
  8031cc:	75 1a                	jne    8031e8 <__umoddi3+0x48>
  8031ce:	39 f7                	cmp    %esi,%edi
  8031d0:	0f 86 a2 00 00 00    	jbe    803278 <__umoddi3+0xd8>
  8031d6:	89 c8                	mov    %ecx,%eax
  8031d8:	89 f2                	mov    %esi,%edx
  8031da:	f7 f7                	div    %edi
  8031dc:	89 d0                	mov    %edx,%eax
  8031de:	31 d2                	xor    %edx,%edx
  8031e0:	83 c4 1c             	add    $0x1c,%esp
  8031e3:	5b                   	pop    %ebx
  8031e4:	5e                   	pop    %esi
  8031e5:	5f                   	pop    %edi
  8031e6:	5d                   	pop    %ebp
  8031e7:	c3                   	ret    
  8031e8:	39 f0                	cmp    %esi,%eax
  8031ea:	0f 87 ac 00 00 00    	ja     80329c <__umoddi3+0xfc>
  8031f0:	0f bd e8             	bsr    %eax,%ebp
  8031f3:	83 f5 1f             	xor    $0x1f,%ebp
  8031f6:	0f 84 ac 00 00 00    	je     8032a8 <__umoddi3+0x108>
  8031fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803201:	29 ef                	sub    %ebp,%edi
  803203:	89 fe                	mov    %edi,%esi
  803205:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803209:	89 e9                	mov    %ebp,%ecx
  80320b:	d3 e0                	shl    %cl,%eax
  80320d:	89 d7                	mov    %edx,%edi
  80320f:	89 f1                	mov    %esi,%ecx
  803211:	d3 ef                	shr    %cl,%edi
  803213:	09 c7                	or     %eax,%edi
  803215:	89 e9                	mov    %ebp,%ecx
  803217:	d3 e2                	shl    %cl,%edx
  803219:	89 14 24             	mov    %edx,(%esp)
  80321c:	89 d8                	mov    %ebx,%eax
  80321e:	d3 e0                	shl    %cl,%eax
  803220:	89 c2                	mov    %eax,%edx
  803222:	8b 44 24 08          	mov    0x8(%esp),%eax
  803226:	d3 e0                	shl    %cl,%eax
  803228:	89 44 24 04          	mov    %eax,0x4(%esp)
  80322c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803230:	89 f1                	mov    %esi,%ecx
  803232:	d3 e8                	shr    %cl,%eax
  803234:	09 d0                	or     %edx,%eax
  803236:	d3 eb                	shr    %cl,%ebx
  803238:	89 da                	mov    %ebx,%edx
  80323a:	f7 f7                	div    %edi
  80323c:	89 d3                	mov    %edx,%ebx
  80323e:	f7 24 24             	mull   (%esp)
  803241:	89 c6                	mov    %eax,%esi
  803243:	89 d1                	mov    %edx,%ecx
  803245:	39 d3                	cmp    %edx,%ebx
  803247:	0f 82 87 00 00 00    	jb     8032d4 <__umoddi3+0x134>
  80324d:	0f 84 91 00 00 00    	je     8032e4 <__umoddi3+0x144>
  803253:	8b 54 24 04          	mov    0x4(%esp),%edx
  803257:	29 f2                	sub    %esi,%edx
  803259:	19 cb                	sbb    %ecx,%ebx
  80325b:	89 d8                	mov    %ebx,%eax
  80325d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803261:	d3 e0                	shl    %cl,%eax
  803263:	89 e9                	mov    %ebp,%ecx
  803265:	d3 ea                	shr    %cl,%edx
  803267:	09 d0                	or     %edx,%eax
  803269:	89 e9                	mov    %ebp,%ecx
  80326b:	d3 eb                	shr    %cl,%ebx
  80326d:	89 da                	mov    %ebx,%edx
  80326f:	83 c4 1c             	add    $0x1c,%esp
  803272:	5b                   	pop    %ebx
  803273:	5e                   	pop    %esi
  803274:	5f                   	pop    %edi
  803275:	5d                   	pop    %ebp
  803276:	c3                   	ret    
  803277:	90                   	nop
  803278:	89 fd                	mov    %edi,%ebp
  80327a:	85 ff                	test   %edi,%edi
  80327c:	75 0b                	jne    803289 <__umoddi3+0xe9>
  80327e:	b8 01 00 00 00       	mov    $0x1,%eax
  803283:	31 d2                	xor    %edx,%edx
  803285:	f7 f7                	div    %edi
  803287:	89 c5                	mov    %eax,%ebp
  803289:	89 f0                	mov    %esi,%eax
  80328b:	31 d2                	xor    %edx,%edx
  80328d:	f7 f5                	div    %ebp
  80328f:	89 c8                	mov    %ecx,%eax
  803291:	f7 f5                	div    %ebp
  803293:	89 d0                	mov    %edx,%eax
  803295:	e9 44 ff ff ff       	jmp    8031de <__umoddi3+0x3e>
  80329a:	66 90                	xchg   %ax,%ax
  80329c:	89 c8                	mov    %ecx,%eax
  80329e:	89 f2                	mov    %esi,%edx
  8032a0:	83 c4 1c             	add    $0x1c,%esp
  8032a3:	5b                   	pop    %ebx
  8032a4:	5e                   	pop    %esi
  8032a5:	5f                   	pop    %edi
  8032a6:	5d                   	pop    %ebp
  8032a7:	c3                   	ret    
  8032a8:	3b 04 24             	cmp    (%esp),%eax
  8032ab:	72 06                	jb     8032b3 <__umoddi3+0x113>
  8032ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032b1:	77 0f                	ja     8032c2 <__umoddi3+0x122>
  8032b3:	89 f2                	mov    %esi,%edx
  8032b5:	29 f9                	sub    %edi,%ecx
  8032b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032bb:	89 14 24             	mov    %edx,(%esp)
  8032be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032c6:	8b 14 24             	mov    (%esp),%edx
  8032c9:	83 c4 1c             	add    $0x1c,%esp
  8032cc:	5b                   	pop    %ebx
  8032cd:	5e                   	pop    %esi
  8032ce:	5f                   	pop    %edi
  8032cf:	5d                   	pop    %ebp
  8032d0:	c3                   	ret    
  8032d1:	8d 76 00             	lea    0x0(%esi),%esi
  8032d4:	2b 04 24             	sub    (%esp),%eax
  8032d7:	19 fa                	sbb    %edi,%edx
  8032d9:	89 d1                	mov    %edx,%ecx
  8032db:	89 c6                	mov    %eax,%esi
  8032dd:	e9 71 ff ff ff       	jmp    803253 <__umoddi3+0xb3>
  8032e2:	66 90                	xchg   %ax,%ax
  8032e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032e8:	72 ea                	jb     8032d4 <__umoddi3+0x134>
  8032ea:	89 d9                	mov    %ebx,%ecx
  8032ec:	e9 62 ff ff ff       	jmp    803253 <__umoddi3+0xb3>
