
obj/user/tst_envfree6:     file format elf32-i386


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
  800031:	e8 5c 01 00 00       	call   800192 <libmain>
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
	// Testing scenario 6: Semaphores & shared variables
	// Testing removing the shared variables and semaphores
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 00 33 80 00       	push   $0x803300
  80004a:	e8 ae 15 00 00       	call   8015fd <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 79 18 00 00       	call   8018dc <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 11 19 00 00       	call   80197c <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 10 33 80 00       	push   $0x803310
  800079:	e8 04 05 00 00       	call   800582 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000, (myEnv->SecondListSize),50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 43 33 80 00       	push   $0x803343
  800099:	e8 b0 1a 00 00       	call   801b4e <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", 20,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	6a 14                	push   $0x14
  8000b4:	68 4c 33 80 00       	push   $0x80334c
  8000b9:	e8 90 1a 00 00       	call   801b4e <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 9d 1a 00 00       	call   801b6c <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 10 27 00 00       	push   $0x2710
  8000da:	e8 f7 2e 00 00       	call   802fd6 <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e8:	e8 7f 1a 00 00       	call   801b6c <sys_run_env>
  8000ed:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f0:	90                   	nop
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	83 f8 02             	cmp    $0x2,%eax
  8000f9:	75 f6                	jne    8000f1 <_main+0xb9>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fb:	e8 dc 17 00 00       	call   8018dc <sys_calculate_free_frames>
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	68 58 33 80 00       	push   $0x803358
  800109:	e8 74 04 00 00       	call   800582 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	ff 75 e8             	pushl  -0x18(%ebp)
  800117:	e8 6c 1a 00 00       	call   801b88 <sys_destroy_env>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 5e 1a 00 00       	call   801b88 <sys_destroy_env>
  80012a:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80012d:	e8 aa 17 00 00       	call   8018dc <sys_calculate_free_frames>
  800132:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800135:	e8 42 18 00 00       	call   80197c <sys_pf_calculate_allocated_pages>
  80013a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80013d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800143:	74 27                	je     80016c <_main+0x134>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 e0             	pushl  -0x20(%ebp)
  80014b:	68 8c 33 80 00       	push   $0x80338c
  800150:	e8 2d 04 00 00       	call   800582 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 dc 33 80 00       	push   $0x8033dc
  800160:	6a 23                	push   $0x23
  800162:	68 12 34 80 00       	push   $0x803412
  800167:	e8 62 01 00 00       	call   8002ce <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 e0             	pushl  -0x20(%ebp)
  800172:	68 28 34 80 00       	push   $0x803428
  800177:	e8 06 04 00 00       	call   800582 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 88 34 80 00       	push   $0x803488
  800187:	e8 f6 03 00 00       	call   800582 <cprintf>
  80018c:	83 c4 10             	add    $0x10,%esp
	return;
  80018f:	90                   	nop
}
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800198:	e8 1f 1a 00 00       	call   801bbc <sys_getenvindex>
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a3:	89 d0                	mov    %edx,%eax
  8001a5:	c1 e0 03             	shl    $0x3,%eax
  8001a8:	01 d0                	add    %edx,%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	01 d0                	add    %edx,%eax
  8001ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b5:	01 d0                	add    %edx,%eax
  8001b7:	c1 e0 04             	shl    $0x4,%eax
  8001ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bf:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c9:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001cf:	84 c0                	test   %al,%al
  8001d1:	74 0f                	je     8001e2 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d8:	05 5c 05 00 00       	add    $0x55c,%eax
  8001dd:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e6:	7e 0a                	jle    8001f2 <libmain+0x60>
		binaryname = argv[0];
  8001e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001eb:	8b 00                	mov    (%eax),%eax
  8001ed:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 38 fe ff ff       	call   800038 <_main>
  800200:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800203:	e8 c1 17 00 00       	call   8019c9 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 ec 34 80 00       	push   $0x8034ec
  800210:	e8 6d 03 00 00       	call   800582 <cprintf>
  800215:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800218:	a1 20 40 80 00       	mov    0x804020,%eax
  80021d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800223:	a1 20 40 80 00       	mov    0x804020,%eax
  800228:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	52                   	push   %edx
  800232:	50                   	push   %eax
  800233:	68 14 35 80 00       	push   $0x803514
  800238:	e8 45 03 00 00       	call   800582 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800240:	a1 20 40 80 00       	mov    0x804020,%eax
  800245:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800256:	a1 20 40 80 00       	mov    0x804020,%eax
  80025b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800261:	51                   	push   %ecx
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	68 3c 35 80 00       	push   $0x80353c
  800269:	e8 14 03 00 00       	call   800582 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800271:	a1 20 40 80 00       	mov    0x804020,%eax
  800276:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 94 35 80 00       	push   $0x803594
  800285:	e8 f8 02 00 00       	call   800582 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 ec 34 80 00       	push   $0x8034ec
  800295:	e8 e8 02 00 00       	call   800582 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029d:	e8 41 17 00 00       	call   8019e3 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a2:	e8 19 00 00 00       	call   8002c0 <exit>
}
  8002a7:	90                   	nop
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b0:	83 ec 0c             	sub    $0xc,%esp
  8002b3:	6a 00                	push   $0x0
  8002b5:	e8 ce 18 00 00       	call   801b88 <sys_destroy_env>
  8002ba:	83 c4 10             	add    $0x10,%esp
}
  8002bd:	90                   	nop
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <exit>:

void
exit(void)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c6:	e8 23 19 00 00       	call   801bee <sys_exit_env>
}
  8002cb:	90                   	nop
  8002cc:	c9                   	leave  
  8002cd:	c3                   	ret    

008002ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d4:	8d 45 10             	lea    0x10(%ebp),%eax
  8002d7:	83 c0 04             	add    $0x4,%eax
  8002da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002dd:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002e2:	85 c0                	test   %eax,%eax
  8002e4:	74 16                	je     8002fc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	50                   	push   %eax
  8002ef:	68 a8 35 80 00       	push   $0x8035a8
  8002f4:	e8 89 02 00 00       	call   800582 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fc:	a1 00 40 80 00       	mov    0x804000,%eax
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	50                   	push   %eax
  800308:	68 ad 35 80 00       	push   $0x8035ad
  80030d:	e8 70 02 00 00       	call   800582 <cprintf>
  800312:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800315:	8b 45 10             	mov    0x10(%ebp),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 f4             	pushl  -0xc(%ebp)
  80031e:	50                   	push   %eax
  80031f:	e8 f3 01 00 00       	call   800517 <vcprintf>
  800324:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	6a 00                	push   $0x0
  80032c:	68 c9 35 80 00       	push   $0x8035c9
  800331:	e8 e1 01 00 00       	call   800517 <vcprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800339:	e8 82 ff ff ff       	call   8002c0 <exit>

	// should not return here
	while (1) ;
  80033e:	eb fe                	jmp    80033e <_panic+0x70>

00800340 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800346:	a1 20 40 80 00       	mov    0x804020,%eax
  80034b:	8b 50 74             	mov    0x74(%eax),%edx
  80034e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800351:	39 c2                	cmp    %eax,%edx
  800353:	74 14                	je     800369 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	68 cc 35 80 00       	push   $0x8035cc
  80035d:	6a 26                	push   $0x26
  80035f:	68 18 36 80 00       	push   $0x803618
  800364:	e8 65 ff ff ff       	call   8002ce <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800370:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800377:	e9 c2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	01 d0                	add    %edx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	85 c0                	test   %eax,%eax
  80038f:	75 08                	jne    800399 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800391:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800394:	e9 a2 00 00 00       	jmp    80043b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800399:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a7:	eb 69                	jmp    800412 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ae:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b7:	89 d0                	mov    %edx,%eax
  8003b9:	01 c0                	add    %eax,%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	c1 e0 03             	shl    $0x3,%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8a 40 04             	mov    0x4(%eax),%al
  8003c5:	84 c0                	test   %al,%al
  8003c7:	75 46                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ce:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d7:	89 d0                	mov    %edx,%eax
  8003d9:	01 c0                	add    %eax,%eax
  8003db:	01 d0                	add    %edx,%eax
  8003dd:	c1 e0 03             	shl    $0x3,%eax
  8003e0:	01 c8                	add    %ecx,%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ef:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800402:	39 c2                	cmp    %eax,%edx
  800404:	75 09                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800406:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80040d:	eb 12                	jmp    800421 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040f:	ff 45 e8             	incl   -0x18(%ebp)
  800412:	a1 20 40 80 00       	mov    0x804020,%eax
  800417:	8b 50 74             	mov    0x74(%eax),%edx
  80041a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	77 88                	ja     8003a9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800421:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800425:	75 14                	jne    80043b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800427:	83 ec 04             	sub    $0x4,%esp
  80042a:	68 24 36 80 00       	push   $0x803624
  80042f:	6a 3a                	push   $0x3a
  800431:	68 18 36 80 00       	push   $0x803618
  800436:	e8 93 fe ff ff       	call   8002ce <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043b:	ff 45 f0             	incl   -0x10(%ebp)
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800444:	0f 8c 32 ff ff ff    	jl     80037c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800451:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800458:	eb 26                	jmp    800480 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045a:	a1 20 40 80 00       	mov    0x804020,%eax
  80045f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800465:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800468:	89 d0                	mov    %edx,%eax
  80046a:	01 c0                	add    %eax,%eax
  80046c:	01 d0                	add    %edx,%eax
  80046e:	c1 e0 03             	shl    $0x3,%eax
  800471:	01 c8                	add    %ecx,%eax
  800473:	8a 40 04             	mov    0x4(%eax),%al
  800476:	3c 01                	cmp    $0x1,%al
  800478:	75 03                	jne    80047d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047d:	ff 45 e0             	incl   -0x20(%ebp)
  800480:	a1 20 40 80 00       	mov    0x804020,%eax
  800485:	8b 50 74             	mov    0x74(%eax),%edx
  800488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048b:	39 c2                	cmp    %eax,%edx
  80048d:	77 cb                	ja     80045a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800495:	74 14                	je     8004ab <CheckWSWithoutLastIndex+0x16b>
		panic(
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	68 78 36 80 00       	push   $0x803678
  80049f:	6a 44                	push   $0x44
  8004a1:	68 18 36 80 00       	push   $0x803618
  8004a6:	e8 23 fe ff ff       	call   8002ce <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bf:	89 0a                	mov    %ecx,(%edx)
  8004c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c4:	88 d1                	mov    %dl,%cl
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d7:	75 2c                	jne    800505 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004d9:	a0 24 40 80 00       	mov    0x804024,%al
  8004de:	0f b6 c0             	movzbl %al,%eax
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	8b 12                	mov    (%edx),%edx
  8004e6:	89 d1                	mov    %edx,%ecx
  8004e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004eb:	83 c2 08             	add    $0x8,%edx
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	50                   	push   %eax
  8004f2:	51                   	push   %ecx
  8004f3:	52                   	push   %edx
  8004f4:	e8 22 13 00 00       	call   80181b <sys_cputs>
  8004f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
  800508:	8b 40 04             	mov    0x4(%eax),%eax
  80050b:	8d 50 01             	lea    0x1(%eax),%edx
  80050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800511:	89 50 04             	mov    %edx,0x4(%eax)
}
  800514:	90                   	nop
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800520:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800527:	00 00 00 
	b.cnt = 0;
  80052a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800531:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800534:	ff 75 0c             	pushl  0xc(%ebp)
  800537:	ff 75 08             	pushl  0x8(%ebp)
  80053a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800540:	50                   	push   %eax
  800541:	68 ae 04 80 00       	push   $0x8004ae
  800546:	e8 11 02 00 00       	call   80075c <vprintfmt>
  80054b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80054e:	a0 24 40 80 00       	mov    0x804024,%al
  800553:	0f b6 c0             	movzbl %al,%eax
  800556:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055c:	83 ec 04             	sub    $0x4,%esp
  80055f:	50                   	push   %eax
  800560:	52                   	push   %edx
  800561:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800567:	83 c0 08             	add    $0x8,%eax
  80056a:	50                   	push   %eax
  80056b:	e8 ab 12 00 00       	call   80181b <sys_cputs>
  800570:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800573:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80057a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <cprintf>:

int cprintf(const char *fmt, ...) {
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800588:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80058f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	ff 75 f4             	pushl  -0xc(%ebp)
  80059e:	50                   	push   %eax
  80059f:	e8 73 ff ff ff       	call   800517 <vcprintf>
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b5:	e8 0f 14 00 00       	call   8019c9 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	83 ec 08             	sub    $0x8,%esp
  8005c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c9:	50                   	push   %eax
  8005ca:	e8 48 ff ff ff       	call   800517 <vcprintf>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d5:	e8 09 14 00 00       	call   8019e3 <sys_enable_interrupt>
	return cnt;
  8005da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	53                   	push   %ebx
  8005e3:	83 ec 14             	sub    $0x14,%esp
  8005e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005fd:	77 55                	ja     800654 <printnum+0x75>
  8005ff:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800602:	72 05                	jb     800609 <printnum+0x2a>
  800604:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800607:	77 4b                	ja     800654 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800609:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80060f:	8b 45 18             	mov    0x18(%ebp),%eax
  800612:	ba 00 00 00 00       	mov    $0x0,%edx
  800617:	52                   	push   %edx
  800618:	50                   	push   %eax
  800619:	ff 75 f4             	pushl  -0xc(%ebp)
  80061c:	ff 75 f0             	pushl  -0x10(%ebp)
  80061f:	e8 68 2a 00 00       	call   80308c <__udivdi3>
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	83 ec 04             	sub    $0x4,%esp
  80062a:	ff 75 20             	pushl  0x20(%ebp)
  80062d:	53                   	push   %ebx
  80062e:	ff 75 18             	pushl  0x18(%ebp)
  800631:	52                   	push   %edx
  800632:	50                   	push   %eax
  800633:	ff 75 0c             	pushl  0xc(%ebp)
  800636:	ff 75 08             	pushl  0x8(%ebp)
  800639:	e8 a1 ff ff ff       	call   8005df <printnum>
  80063e:	83 c4 20             	add    $0x20,%esp
  800641:	eb 1a                	jmp    80065d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	ff 75 20             	pushl  0x20(%ebp)
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	ff d0                	call   *%eax
  800651:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800654:	ff 4d 1c             	decl   0x1c(%ebp)
  800657:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065b:	7f e6                	jg     800643 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80065d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800660:	bb 00 00 00 00       	mov    $0x0,%ebx
  800665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800668:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066b:	53                   	push   %ebx
  80066c:	51                   	push   %ecx
  80066d:	52                   	push   %edx
  80066e:	50                   	push   %eax
  80066f:	e8 28 2b 00 00       	call   80319c <__umoddi3>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	05 f4 38 80 00       	add    $0x8038f4,%eax
  80067c:	8a 00                	mov    (%eax),%al
  80067e:	0f be c0             	movsbl %al,%eax
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	50                   	push   %eax
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	ff d0                	call   *%eax
  80068d:	83 c4 10             	add    $0x10,%esp
}
  800690:	90                   	nop
  800691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800694:	c9                   	leave  
  800695:	c3                   	ret    

00800696 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800696:	55                   	push   %ebp
  800697:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800699:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80069d:	7e 1c                	jle    8006bb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	8d 50 08             	lea    0x8(%eax),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	89 10                	mov    %edx,(%eax)
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	83 e8 08             	sub    $0x8,%eax
  8006b4:	8b 50 04             	mov    0x4(%eax),%edx
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	eb 40                	jmp    8006fb <getuint+0x65>
	else if (lflag)
  8006bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006bf:	74 1e                	je     8006df <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	8d 50 04             	lea    0x4(%eax),%edx
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	89 10                	mov    %edx,(%eax)
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	83 e8 04             	sub    $0x4,%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dd:	eb 1c                	jmp    8006fb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	8d 50 04             	lea    0x4(%eax),%edx
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	89 10                	mov    %edx,(%eax)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	83 e8 04             	sub    $0x4,%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getint+0x25>
		return va_arg(*ap, long long);
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	8d 50 08             	lea    0x8(%eax),%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	89 10                	mov    %edx,(%eax)
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	83 e8 08             	sub    $0x8,%eax
  80071b:	8b 50 04             	mov    0x4(%eax),%edx
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	eb 38                	jmp    80075a <getint+0x5d>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1a                	je     800742 <getint+0x45>
		return va_arg(*ap, long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	99                   	cltd   
  800740:	eb 18                	jmp    80075a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	8d 50 04             	lea    0x4(%eax),%edx
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	89 10                	mov    %edx,(%eax)
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	83 e8 04             	sub    $0x4,%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	99                   	cltd   
}
  80075a:	5d                   	pop    %ebp
  80075b:	c3                   	ret    

0080075c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	56                   	push   %esi
  800760:	53                   	push   %ebx
  800761:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	eb 17                	jmp    80077d <vprintfmt+0x21>
			if (ch == '\0')
  800766:	85 db                	test   %ebx,%ebx
  800768:	0f 84 af 03 00 00    	je     800b1d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	53                   	push   %ebx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077d:	8b 45 10             	mov    0x10(%ebp),%eax
  800780:	8d 50 01             	lea    0x1(%eax),%edx
  800783:	89 55 10             	mov    %edx,0x10(%ebp)
  800786:	8a 00                	mov    (%eax),%al
  800788:	0f b6 d8             	movzbl %al,%ebx
  80078b:	83 fb 25             	cmp    $0x25,%ebx
  80078e:	75 d6                	jne    800766 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800790:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800794:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b3:	8d 50 01             	lea    0x1(%eax),%edx
  8007b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b9:	8a 00                	mov    (%eax),%al
  8007bb:	0f b6 d8             	movzbl %al,%ebx
  8007be:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c1:	83 f8 55             	cmp    $0x55,%eax
  8007c4:	0f 87 2b 03 00 00    	ja     800af5 <vprintfmt+0x399>
  8007ca:	8b 04 85 18 39 80 00 	mov    0x803918(,%eax,4),%eax
  8007d1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007d7:	eb d7                	jmp    8007b0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007d9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007dd:	eb d1                	jmp    8007b0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007e9:	89 d0                	mov    %edx,%eax
  8007eb:	c1 e0 02             	shl    $0x2,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	01 c0                	add    %eax,%eax
  8007f2:	01 d8                	add    %ebx,%eax
  8007f4:	83 e8 30             	sub    $0x30,%eax
  8007f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fd:	8a 00                	mov    (%eax),%al
  8007ff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800802:	83 fb 2f             	cmp    $0x2f,%ebx
  800805:	7e 3e                	jle    800845 <vprintfmt+0xe9>
  800807:	83 fb 39             	cmp    $0x39,%ebx
  80080a:	7f 39                	jg     800845 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80080f:	eb d5                	jmp    8007e6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	83 c0 04             	add    $0x4,%eax
  800817:	89 45 14             	mov    %eax,0x14(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	83 e8 04             	sub    $0x4,%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800825:	eb 1f                	jmp    800846 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800827:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082b:	79 83                	jns    8007b0 <vprintfmt+0x54>
				width = 0;
  80082d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800834:	e9 77 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800839:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800840:	e9 6b ff ff ff       	jmp    8007b0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800845:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800846:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084a:	0f 89 60 ff ff ff    	jns    8007b0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800850:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800856:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80085d:	e9 4e ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800862:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800865:	e9 46 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	83 c0 04             	add    $0x4,%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 e8 04             	sub    $0x4,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	50                   	push   %eax
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	ff d0                	call   *%eax
  800887:	83 c4 10             	add    $0x10,%esp
			break;
  80088a:	e9 89 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	83 c0 04             	add    $0x4,%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	83 e8 04             	sub    $0x4,%eax
  80089e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a0:	85 db                	test   %ebx,%ebx
  8008a2:	79 02                	jns    8008a6 <vprintfmt+0x14a>
				err = -err;
  8008a4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a6:	83 fb 64             	cmp    $0x64,%ebx
  8008a9:	7f 0b                	jg     8008b6 <vprintfmt+0x15a>
  8008ab:	8b 34 9d 60 37 80 00 	mov    0x803760(,%ebx,4),%esi
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	75 19                	jne    8008cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b6:	53                   	push   %ebx
  8008b7:	68 05 39 80 00       	push   $0x803905
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 5e 02 00 00       	call   800b25 <printfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ca:	e9 49 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008cf:	56                   	push   %esi
  8008d0:	68 0e 39 80 00       	push   $0x80390e
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	ff 75 08             	pushl  0x8(%ebp)
  8008db:	e8 45 02 00 00       	call   800b25 <printfmt>
  8008e0:	83 c4 10             	add    $0x10,%esp
			break;
  8008e3:	e9 30 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	83 c0 04             	add    $0x4,%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	83 e8 04             	sub    $0x4,%eax
  8008f7:	8b 30                	mov    (%eax),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 05                	jne    800902 <vprintfmt+0x1a6>
				p = "(null)";
  8008fd:	be 11 39 80 00       	mov    $0x803911,%esi
			if (width > 0 && padc != '-')
  800902:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800906:	7e 6d                	jle    800975 <vprintfmt+0x219>
  800908:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090c:	74 67                	je     800975 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80090e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	50                   	push   %eax
  800915:	56                   	push   %esi
  800916:	e8 0c 03 00 00       	call   800c27 <strnlen>
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800921:	eb 16                	jmp    800939 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800923:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	50                   	push   %eax
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800936:	ff 4d e4             	decl   -0x1c(%ebp)
  800939:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093d:	7f e4                	jg     800923 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093f:	eb 34                	jmp    800975 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800941:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800945:	74 1c                	je     800963 <vprintfmt+0x207>
  800947:	83 fb 1f             	cmp    $0x1f,%ebx
  80094a:	7e 05                	jle    800951 <vprintfmt+0x1f5>
  80094c:	83 fb 7e             	cmp    $0x7e,%ebx
  80094f:	7e 12                	jle    800963 <vprintfmt+0x207>
					putch('?', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	6a 3f                	push   $0x3f
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	eb 0f                	jmp    800972 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	53                   	push   %ebx
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	ff d0                	call   *%eax
  80096f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800972:	ff 4d e4             	decl   -0x1c(%ebp)
  800975:	89 f0                	mov    %esi,%eax
  800977:	8d 70 01             	lea    0x1(%eax),%esi
  80097a:	8a 00                	mov    (%eax),%al
  80097c:	0f be d8             	movsbl %al,%ebx
  80097f:	85 db                	test   %ebx,%ebx
  800981:	74 24                	je     8009a7 <vprintfmt+0x24b>
  800983:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800987:	78 b8                	js     800941 <vprintfmt+0x1e5>
  800989:	ff 4d e0             	decl   -0x20(%ebp)
  80098c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800990:	79 af                	jns    800941 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800992:	eb 13                	jmp    8009a7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	6a 20                	push   $0x20
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	ff d0                	call   *%eax
  8009a1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ab:	7f e7                	jg     800994 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009ad:	e9 66 01 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bb:	50                   	push   %eax
  8009bc:	e8 3c fd ff ff       	call   8006fd <getint>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d0:	85 d2                	test   %edx,%edx
  8009d2:	79 23                	jns    8009f7 <vprintfmt+0x29b>
				putch('-', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 2d                	push   $0x2d
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ea:	f7 d8                	neg    %eax
  8009ec:	83 d2 00             	adc    $0x0,%edx
  8009ef:	f7 da                	neg    %edx
  8009f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009fe:	e9 bc 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 e8             	pushl  -0x18(%ebp)
  800a09:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0c:	50                   	push   %eax
  800a0d:	e8 84 fc ff ff       	call   800696 <getuint>
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a22:	e9 98 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	6a 58                	push   $0x58
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	6a 58                	push   $0x58
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	6a 58                	push   $0x58
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	ff d0                	call   *%eax
  800a54:	83 c4 10             	add    $0x10,%esp
			break;
  800a57:	e9 bc 00 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	6a 30                	push   $0x30
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	ff d0                	call   *%eax
  800a69:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	6a 78                	push   $0x78
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a9e:	eb 1f                	jmp    800abf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa6:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa9:	50                   	push   %eax
  800aaa:	e8 e7 fb ff ff       	call   800696 <getuint>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ab8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800abf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac6:	83 ec 04             	sub    $0x4,%esp
  800ac9:	52                   	push   %edx
  800aca:	ff 75 e4             	pushl  -0x1c(%ebp)
  800acd:	50                   	push   %eax
  800ace:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	ff 75 08             	pushl  0x8(%ebp)
  800ada:	e8 00 fb ff ff       	call   8005df <printnum>
  800adf:	83 c4 20             	add    $0x20,%esp
			break;
  800ae2:	eb 34                	jmp    800b18 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	53                   	push   %ebx
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	eb 23                	jmp    800b18 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	6a 25                	push   $0x25
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b05:	ff 4d 10             	decl   0x10(%ebp)
  800b08:	eb 03                	jmp    800b0d <vprintfmt+0x3b1>
  800b0a:	ff 4d 10             	decl   0x10(%ebp)
  800b0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b10:	48                   	dec    %eax
  800b11:	8a 00                	mov    (%eax),%al
  800b13:	3c 25                	cmp    $0x25,%al
  800b15:	75 f3                	jne    800b0a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b17:	90                   	nop
		}
	}
  800b18:	e9 47 fc ff ff       	jmp    800764 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b1d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b2e:	83 c0 04             	add    $0x4,%eax
  800b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b34:	8b 45 10             	mov    0x10(%ebp),%eax
  800b37:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3a:	50                   	push   %eax
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 16 fc ff ff       	call   80075c <vprintfmt>
  800b46:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b49:	90                   	nop
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8b 40 08             	mov    0x8(%eax),%eax
  800b55:	8d 50 01             	lea    0x1(%eax),%edx
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 10                	mov    (%eax),%edx
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8b 40 04             	mov    0x4(%eax),%eax
  800b69:	39 c2                	cmp    %eax,%edx
  800b6b:	73 12                	jae    800b7f <sprintputch+0x33>
		*b->buf++ = ch;
  800b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b70:	8b 00                	mov    (%eax),%eax
  800b72:	8d 48 01             	lea    0x1(%eax),%ecx
  800b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b78:	89 0a                	mov    %ecx,(%edx)
  800b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7d:	88 10                	mov    %dl,(%eax)
}
  800b7f:	90                   	nop
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	01 d0                	add    %edx,%eax
  800b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba7:	74 06                	je     800baf <vsnprintf+0x2d>
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	7f 07                	jg     800bb6 <vsnprintf+0x34>
		return -E_INVAL;
  800baf:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb4:	eb 20                	jmp    800bd6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb6:	ff 75 14             	pushl  0x14(%ebp)
  800bb9:	ff 75 10             	pushl  0x10(%ebp)
  800bbc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bbf:	50                   	push   %eax
  800bc0:	68 4c 0b 80 00       	push   $0x800b4c
  800bc5:	e8 92 fb ff ff       	call   80075c <vprintfmt>
  800bca:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bde:	8d 45 10             	lea    0x10(%ebp),%eax
  800be1:	83 c0 04             	add    $0x4,%eax
  800be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	ff 75 f4             	pushl  -0xc(%ebp)
  800bed:	50                   	push   %eax
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	ff 75 08             	pushl  0x8(%ebp)
  800bf4:	e8 89 ff ff ff       	call   800b82 <vsnprintf>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c11:	eb 06                	jmp    800c19 <strlen+0x15>
		n++;
  800c13:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c16:	ff 45 08             	incl   0x8(%ebp)
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	84 c0                	test   %al,%al
  800c20:	75 f1                	jne    800c13 <strlen+0xf>
		n++;
	return n;
  800c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c34:	eb 09                	jmp    800c3f <strnlen+0x18>
		n++;
  800c36:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c39:	ff 45 08             	incl   0x8(%ebp)
  800c3c:	ff 4d 0c             	decl   0xc(%ebp)
  800c3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c43:	74 09                	je     800c4e <strnlen+0x27>
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	84 c0                	test   %al,%al
  800c4c:	75 e8                	jne    800c36 <strnlen+0xf>
		n++;
	return n;
  800c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c5f:	90                   	nop
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8d 50 01             	lea    0x1(%eax),%edx
  800c66:	89 55 08             	mov    %edx,0x8(%ebp)
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c72:	8a 12                	mov    (%edx),%dl
  800c74:	88 10                	mov    %dl,(%eax)
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 e4                	jne    800c60 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c94:	eb 1f                	jmp    800cb5 <strncpy+0x34>
		*dst++ = *src;
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8d 50 01             	lea    0x1(%eax),%edx
  800c9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca2:	8a 12                	mov    (%edx),%dl
  800ca4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	74 03                	je     800cb2 <strncpy+0x31>
			src++;
  800caf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb2:	ff 45 fc             	incl   -0x4(%ebp)
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbb:	72 d9                	jb     800c96 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc0:	c9                   	leave  
  800cc1:	c3                   	ret    

00800cc2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd2:	74 30                	je     800d04 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd4:	eb 16                	jmp    800cec <strlcpy+0x2a>
			*dst++ = *src++;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8d 50 01             	lea    0x1(%eax),%edx
  800cdc:	89 55 08             	mov    %edx,0x8(%ebp)
  800cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce8:	8a 12                	mov    (%edx),%dl
  800cea:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cec:	ff 4d 10             	decl   0x10(%ebp)
  800cef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf3:	74 09                	je     800cfe <strlcpy+0x3c>
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 d8                	jne    800cd6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0a:	29 c2                	sub    %eax,%edx
  800d0c:	89 d0                	mov    %edx,%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d13:	eb 06                	jmp    800d1b <strcmp+0xb>
		p++, q++;
  800d15:	ff 45 08             	incl   0x8(%ebp)
  800d18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	84 c0                	test   %al,%al
  800d22:	74 0e                	je     800d32 <strcmp+0x22>
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8a 10                	mov    (%eax),%dl
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	38 c2                	cmp    %al,%dl
  800d30:	74 e3                	je     800d15 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	0f b6 d0             	movzbl %al,%edx
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	0f b6 c0             	movzbl %al,%eax
  800d42:	29 c2                	sub    %eax,%edx
  800d44:	89 d0                	mov    %edx,%eax
}
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4b:	eb 09                	jmp    800d56 <strncmp+0xe>
		n--, p++, q++;
  800d4d:	ff 4d 10             	decl   0x10(%ebp)
  800d50:	ff 45 08             	incl   0x8(%ebp)
  800d53:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 17                	je     800d73 <strncmp+0x2b>
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	74 0e                	je     800d73 <strncmp+0x2b>
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 10                	mov    (%eax),%dl
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	38 c2                	cmp    %al,%dl
  800d71:	74 da                	je     800d4d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d77:	75 07                	jne    800d80 <strncmp+0x38>
		return 0;
  800d79:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7e:	eb 14                	jmp    800d94 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 d0             	movzbl %al,%edx
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	0f b6 c0             	movzbl %al,%eax
  800d90:	29 c2                	sub    %eax,%edx
  800d92:	89 d0                	mov    %edx,%eax
}
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 04             	sub    $0x4,%esp
  800d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da2:	eb 12                	jmp    800db6 <strchr+0x20>
		if (*s == c)
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dac:	75 05                	jne    800db3 <strchr+0x1d>
			return (char *) s;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	eb 11                	jmp    800dc4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db3:	ff 45 08             	incl   0x8(%ebp)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	75 e5                	jne    800da4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 04             	sub    $0x4,%esp
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd2:	eb 0d                	jmp    800de1 <strfind+0x1b>
		if (*s == c)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddc:	74 0e                	je     800dec <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dde:	ff 45 08             	incl   0x8(%ebp)
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	84 c0                	test   %al,%al
  800de8:	75 ea                	jne    800dd4 <strfind+0xe>
  800dea:	eb 01                	jmp    800ded <strfind+0x27>
		if (*s == c)
			break;
  800dec:	90                   	nop
	return (char *) s;
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800e01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e04:	eb 0e                	jmp    800e14 <memset+0x22>
		*p++ = c;
  800e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e09:	8d 50 01             	lea    0x1(%eax),%edx
  800e0c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e12:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e14:	ff 4d f8             	decl   -0x8(%ebp)
  800e17:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1b:	79 e9                	jns    800e06 <memset+0x14>
		*p++ = c;

	return v;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e34:	eb 16                	jmp    800e4c <memcpy+0x2a>
		*d++ = *s++;
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e39:	8d 50 01             	lea    0x1(%eax),%edx
  800e3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e45:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e48:	8a 12                	mov    (%edx),%dl
  800e4a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 dd                	jne    800e36 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e76:	73 50                	jae    800ec8 <memmove+0x6a>
  800e78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	01 d0                	add    %edx,%eax
  800e80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e83:	76 43                	jbe    800ec8 <memmove+0x6a>
		s += n;
  800e85:	8b 45 10             	mov    0x10(%ebp),%eax
  800e88:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e91:	eb 10                	jmp    800ea3 <memmove+0x45>
			*--d = *--s;
  800e93:	ff 4d f8             	decl   -0x8(%ebp)
  800e96:	ff 4d fc             	decl   -0x4(%ebp)
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	8a 10                	mov    (%eax),%dl
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	75 e3                	jne    800e93 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb0:	eb 23                	jmp    800ed5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb5:	8d 50 01             	lea    0x1(%eax),%edx
  800eb8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ebe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec4:	8a 12                	mov    (%edx),%dl
  800ec6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ece:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	75 dd                	jne    800eb2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed8:	c9                   	leave  
  800ed9:	c3                   	ret    

00800eda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eec:	eb 2a                	jmp    800f18 <memcmp+0x3e>
		if (*s1 != *s2)
  800eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef1:	8a 10                	mov    (%eax),%dl
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	38 c2                	cmp    %al,%dl
  800efa:	74 16                	je     800f12 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	0f b6 d0             	movzbl %al,%edx
  800f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	0f b6 c0             	movzbl %al,%eax
  800f0c:	29 c2                	sub    %eax,%edx
  800f0e:	89 d0                	mov    %edx,%eax
  800f10:	eb 18                	jmp    800f2a <memcmp+0x50>
		s1++, s2++;
  800f12:	ff 45 fc             	incl   -0x4(%ebp)
  800f15:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f18:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	75 c9                	jne    800eee <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 d0                	add    %edx,%eax
  800f3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f3d:	eb 15                	jmp    800f54 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	0f b6 d0             	movzbl %al,%edx
  800f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4a:	0f b6 c0             	movzbl %al,%eax
  800f4d:	39 c2                	cmp    %eax,%edx
  800f4f:	74 0d                	je     800f5e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f51:	ff 45 08             	incl   0x8(%ebp)
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5a:	72 e3                	jb     800f3f <memfind+0x13>
  800f5c:	eb 01                	jmp    800f5f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f5e:	90                   	nop
	return (void *) s;
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f71:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f78:	eb 03                	jmp    800f7d <strtol+0x19>
		s++;
  800f7a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3c 20                	cmp    $0x20,%al
  800f84:	74 f4                	je     800f7a <strtol+0x16>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	3c 09                	cmp    $0x9,%al
  800f8d:	74 eb                	je     800f7a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 2b                	cmp    $0x2b,%al
  800f96:	75 05                	jne    800f9d <strtol+0x39>
		s++;
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	eb 13                	jmp    800fb0 <strtol+0x4c>
	else if (*s == '-')
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3c 2d                	cmp    $0x2d,%al
  800fa4:	75 0a                	jne    800fb0 <strtol+0x4c>
		s++, neg = 1;
  800fa6:	ff 45 08             	incl   0x8(%ebp)
  800fa9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb4:	74 06                	je     800fbc <strtol+0x58>
  800fb6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fba:	75 20                	jne    800fdc <strtol+0x78>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 30                	cmp    $0x30,%al
  800fc3:	75 17                	jne    800fdc <strtol+0x78>
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	40                   	inc    %eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 78                	cmp    $0x78,%al
  800fcd:	75 0d                	jne    800fdc <strtol+0x78>
		s += 2, base = 16;
  800fcf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fda:	eb 28                	jmp    801004 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe0:	75 15                	jne    800ff7 <strtol+0x93>
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	3c 30                	cmp    $0x30,%al
  800fe9:	75 0c                	jne    800ff7 <strtol+0x93>
		s++, base = 8;
  800feb:	ff 45 08             	incl   0x8(%ebp)
  800fee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff5:	eb 0d                	jmp    801004 <strtol+0xa0>
	else if (base == 0)
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 07                	jne    801004 <strtol+0xa0>
		base = 10;
  800ffd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2f                	cmp    $0x2f,%al
  80100b:	7e 19                	jle    801026 <strtol+0xc2>
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 39                	cmp    $0x39,%al
  801014:	7f 10                	jg     801026 <strtol+0xc2>
			dig = *s - '0';
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	0f be c0             	movsbl %al,%eax
  80101e:	83 e8 30             	sub    $0x30,%eax
  801021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801024:	eb 42                	jmp    801068 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 60                	cmp    $0x60,%al
  80102d:	7e 19                	jle    801048 <strtol+0xe4>
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 7a                	cmp    $0x7a,%al
  801036:	7f 10                	jg     801048 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	83 e8 57             	sub    $0x57,%eax
  801043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801046:	eb 20                	jmp    801068 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 40                	cmp    $0x40,%al
  80104f:	7e 39                	jle    80108a <strtol+0x126>
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 5a                	cmp    $0x5a,%al
  801058:	7f 30                	jg     80108a <strtol+0x126>
			dig = *s - 'A' + 10;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	0f be c0             	movsbl %al,%eax
  801062:	83 e8 37             	sub    $0x37,%eax
  801065:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80106e:	7d 19                	jge    801089 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801070:	ff 45 08             	incl   0x8(%ebp)
  801073:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801076:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80107f:	01 d0                	add    %edx,%eax
  801081:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801084:	e9 7b ff ff ff       	jmp    801004 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801089:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108e:	74 08                	je     801098 <strtol+0x134>
		*endptr = (char *) s;
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801098:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109c:	74 07                	je     8010a5 <strtol+0x141>
  80109e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a1:	f7 d8                	neg    %eax
  8010a3:	eb 03                	jmp    8010a8 <strtol+0x144>
  8010a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <ltostr>:

void
ltostr(long value, char *str)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c2:	79 13                	jns    8010d7 <ltostr+0x2d>
	{
		neg = 1;
  8010c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010df:	99                   	cltd   
  8010e0:	f7 f9                	idiv   %ecx
  8010e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	83 c2 30             	add    $0x30,%edx
  8010fb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801100:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801105:	f7 e9                	imul   %ecx
  801107:	c1 fa 02             	sar    $0x2,%edx
  80110a:	89 c8                	mov    %ecx,%eax
  80110c:	c1 f8 1f             	sar    $0x1f,%eax
  80110f:	29 c2                	sub    %eax,%edx
  801111:	89 d0                	mov    %edx,%eax
  801113:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801116:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801119:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80111e:	f7 e9                	imul   %ecx
  801120:	c1 fa 02             	sar    $0x2,%edx
  801123:	89 c8                	mov    %ecx,%eax
  801125:	c1 f8 1f             	sar    $0x1f,%eax
  801128:	29 c2                	sub    %eax,%edx
  80112a:	89 d0                	mov    %edx,%eax
  80112c:	c1 e0 02             	shl    $0x2,%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	01 c0                	add    %eax,%eax
  801133:	29 c1                	sub    %eax,%ecx
  801135:	89 ca                	mov    %ecx,%edx
  801137:	85 d2                	test   %edx,%edx
  801139:	75 9c                	jne    8010d7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	48                   	dec    %eax
  801146:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801149:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114d:	74 3d                	je     80118c <ltostr+0xe2>
		start = 1 ;
  80114f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801156:	eb 34                	jmp    80118c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801165:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	01 c2                	add    %eax,%edx
  80116d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	01 c8                	add    %ecx,%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801179:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	01 c2                	add    %eax,%edx
  801181:	8a 45 eb             	mov    -0x15(%ebp),%al
  801184:	88 02                	mov    %al,(%edx)
		start++ ;
  801186:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801189:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801192:	7c c4                	jl     801158 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801194:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80119f:	90                   	nop
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011a8:	ff 75 08             	pushl  0x8(%ebp)
  8011ab:	e8 54 fa ff ff       	call   800c04 <strlen>
  8011b0:	83 c4 04             	add    $0x4,%esp
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b6:	ff 75 0c             	pushl  0xc(%ebp)
  8011b9:	e8 46 fa ff ff       	call   800c04 <strlen>
  8011be:	83 c4 04             	add    $0x4,%esp
  8011c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d2:	eb 17                	jmp    8011eb <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	01 c2                	add    %eax,%edx
  8011dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	01 c8                	add    %ecx,%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011e8:	ff 45 fc             	incl   -0x4(%ebp)
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f1:	7c e1                	jl     8011d4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801201:	eb 1f                	jmp    801222 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801203:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801206:	8d 50 01             	lea    0x1(%eax),%edx
  801209:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120c:	89 c2                	mov    %eax,%edx
  80120e:	8b 45 10             	mov    0x10(%ebp),%eax
  801211:	01 c2                	add    %eax,%edx
  801213:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 c8                	add    %ecx,%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80121f:	ff 45 f8             	incl   -0x8(%ebp)
  801222:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801225:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801228:	7c d9                	jl     801203 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	c6 00 00             	movb   $0x0,(%eax)
}
  801235:	90                   	nop
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123b:	8b 45 14             	mov    0x14(%ebp),%eax
  80123e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801250:	8b 45 10             	mov    0x10(%ebp),%eax
  801253:	01 d0                	add    %edx,%eax
  801255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125b:	eb 0c                	jmp    801269 <strsplit+0x31>
			*string++ = 0;
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8d 50 01             	lea    0x1(%eax),%edx
  801263:	89 55 08             	mov    %edx,0x8(%ebp)
  801266:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	84 c0                	test   %al,%al
  801270:	74 18                	je     80128a <strsplit+0x52>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	0f be c0             	movsbl %al,%eax
  80127a:	50                   	push   %eax
  80127b:	ff 75 0c             	pushl  0xc(%ebp)
  80127e:	e8 13 fb ff ff       	call   800d96 <strchr>
  801283:	83 c4 08             	add    $0x8,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	75 d3                	jne    80125d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	84 c0                	test   %al,%al
  801291:	74 5a                	je     8012ed <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	83 f8 0f             	cmp    $0xf,%eax
  80129b:	75 07                	jne    8012a4 <strsplit+0x6c>
		{
			return 0;
  80129d:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a2:	eb 66                	jmp    80130a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a7:	8b 00                	mov    (%eax),%eax
  8012a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ac:	8b 55 14             	mov    0x14(%ebp),%edx
  8012af:	89 0a                	mov    %ecx,(%edx)
  8012b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c2:	eb 03                	jmp    8012c7 <strsplit+0x8f>
			string++;
  8012c4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	84 c0                	test   %al,%al
  8012ce:	74 8b                	je     80125b <strsplit+0x23>
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	0f be c0             	movsbl %al,%eax
  8012d8:	50                   	push   %eax
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	e8 b5 fa ff ff       	call   800d96 <strchr>
  8012e1:	83 c4 08             	add    $0x8,%esp
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	74 dc                	je     8012c4 <strsplit+0x8c>
			string++;
	}
  8012e8:	e9 6e ff ff ff       	jmp    80125b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012ed:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f1:	8b 00                	mov    (%eax),%eax
  8012f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fd:	01 d0                	add    %edx,%eax
  8012ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801305:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801312:	a1 04 40 80 00       	mov    0x804004,%eax
  801317:	85 c0                	test   %eax,%eax
  801319:	74 1f                	je     80133a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131b:	e8 1d 00 00 00       	call   80133d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801320:	83 ec 0c             	sub    $0xc,%esp
  801323:	68 70 3a 80 00       	push   $0x803a70
  801328:	e8 55 f2 ff ff       	call   800582 <cprintf>
  80132d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801330:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801337:	00 00 00 
	}
}
  80133a:	90                   	nop
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801343:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80134a:	00 00 00 
  80134d:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801354:	00 00 00 
  801357:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80135e:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801361:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801368:	00 00 00 
  80136b:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801372:	00 00 00 
  801375:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80137c:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80137f:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801386:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801389:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801398:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139d:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  8013a2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013a9:	a1 20 41 80 00       	mov    0x804120,%eax
  8013ae:	c1 e0 04             	shl    $0x4,%eax
  8013b1:	89 c2                	mov    %eax,%edx
  8013b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b6:	01 d0                	add    %edx,%eax
  8013b8:	48                   	dec    %eax
  8013b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c4:	f7 75 f0             	divl   -0x10(%ebp)
  8013c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ca:	29 d0                	sub    %edx,%eax
  8013cc:	89 c2                	mov    %eax,%edx
  8013ce:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8013d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013d8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013dd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013e2:	83 ec 04             	sub    $0x4,%esp
  8013e5:	6a 06                	push   $0x6
  8013e7:	52                   	push   %edx
  8013e8:	50                   	push   %eax
  8013e9:	e8 71 05 00 00       	call   80195f <sys_allocate_chunk>
  8013ee:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013f1:	a1 20 41 80 00       	mov    0x804120,%eax
  8013f6:	83 ec 0c             	sub    $0xc,%esp
  8013f9:	50                   	push   %eax
  8013fa:	e8 e6 0b 00 00       	call   801fe5 <initialize_MemBlocksList>
  8013ff:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  801402:	a1 48 41 80 00       	mov    0x804148,%eax
  801407:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  80140a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80140e:	75 14                	jne    801424 <initialize_dyn_block_system+0xe7>
  801410:	83 ec 04             	sub    $0x4,%esp
  801413:	68 95 3a 80 00       	push   $0x803a95
  801418:	6a 2b                	push   $0x2b
  80141a:	68 b3 3a 80 00       	push   $0x803ab3
  80141f:	e8 aa ee ff ff       	call   8002ce <_panic>
  801424:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801427:	8b 00                	mov    (%eax),%eax
  801429:	85 c0                	test   %eax,%eax
  80142b:	74 10                	je     80143d <initialize_dyn_block_system+0x100>
  80142d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801430:	8b 00                	mov    (%eax),%eax
  801432:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801435:	8b 52 04             	mov    0x4(%edx),%edx
  801438:	89 50 04             	mov    %edx,0x4(%eax)
  80143b:	eb 0b                	jmp    801448 <initialize_dyn_block_system+0x10b>
  80143d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801440:	8b 40 04             	mov    0x4(%eax),%eax
  801443:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80144b:	8b 40 04             	mov    0x4(%eax),%eax
  80144e:	85 c0                	test   %eax,%eax
  801450:	74 0f                	je     801461 <initialize_dyn_block_system+0x124>
  801452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801455:	8b 40 04             	mov    0x4(%eax),%eax
  801458:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80145b:	8b 12                	mov    (%edx),%edx
  80145d:	89 10                	mov    %edx,(%eax)
  80145f:	eb 0a                	jmp    80146b <initialize_dyn_block_system+0x12e>
  801461:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801464:	8b 00                	mov    (%eax),%eax
  801466:	a3 48 41 80 00       	mov    %eax,0x804148
  80146b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80146e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801477:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80147e:	a1 54 41 80 00       	mov    0x804154,%eax
  801483:	48                   	dec    %eax
  801484:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80148c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801496:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80149d:	83 ec 0c             	sub    $0xc,%esp
  8014a0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014a3:	e8 d2 13 00 00       	call   80287a <insert_sorted_with_merge_freeList>
  8014a8:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  8014ab:	90                   	nop
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014b4:	e8 53 fe ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  8014b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014bd:	75 07                	jne    8014c6 <malloc+0x18>
  8014bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c4:	eb 61                	jmp    801527 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8014c6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d3:	01 d0                	add    %edx,%eax
  8014d5:	48                   	dec    %eax
  8014d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e1:	f7 75 f4             	divl   -0xc(%ebp)
  8014e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e7:	29 d0                	sub    %edx,%eax
  8014e9:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014ec:	e8 3c 08 00 00       	call   801d2d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	74 2d                	je     801522 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8014f5:	83 ec 0c             	sub    $0xc,%esp
  8014f8:	ff 75 08             	pushl  0x8(%ebp)
  8014fb:	e8 3e 0f 00 00       	call   80243e <alloc_block_FF>
  801500:	83 c4 10             	add    $0x10,%esp
  801503:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  801506:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80150a:	74 16                	je     801522 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  80150c:	83 ec 0c             	sub    $0xc,%esp
  80150f:	ff 75 ec             	pushl  -0x14(%ebp)
  801512:	e8 48 0c 00 00       	call   80215f <insert_sorted_allocList>
  801517:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  80151a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80151d:	8b 40 08             	mov    0x8(%eax),%eax
  801520:	eb 05                	jmp    801527 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801522:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801527:	c9                   	leave  
  801528:	c3                   	ret    

00801529 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801529:	55                   	push   %ebp
  80152a:	89 e5                	mov    %esp,%ebp
  80152c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801538:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80153d:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	83 ec 08             	sub    $0x8,%esp
  801546:	50                   	push   %eax
  801547:	68 40 40 80 00       	push   $0x804040
  80154c:	e8 71 0b 00 00       	call   8020c2 <find_block>
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155a:	8b 50 0c             	mov    0xc(%eax),%edx
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	52                   	push   %edx
  801564:	50                   	push   %eax
  801565:	e8 bd 03 00 00       	call   801927 <sys_free_user_mem>
  80156a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80156d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801571:	75 14                	jne    801587 <free+0x5e>
  801573:	83 ec 04             	sub    $0x4,%esp
  801576:	68 95 3a 80 00       	push   $0x803a95
  80157b:	6a 71                	push   $0x71
  80157d:	68 b3 3a 80 00       	push   $0x803ab3
  801582:	e8 47 ed ff ff       	call   8002ce <_panic>
  801587:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158a:	8b 00                	mov    (%eax),%eax
  80158c:	85 c0                	test   %eax,%eax
  80158e:	74 10                	je     8015a0 <free+0x77>
  801590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801593:	8b 00                	mov    (%eax),%eax
  801595:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801598:	8b 52 04             	mov    0x4(%edx),%edx
  80159b:	89 50 04             	mov    %edx,0x4(%eax)
  80159e:	eb 0b                	jmp    8015ab <free+0x82>
  8015a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a3:	8b 40 04             	mov    0x4(%eax),%eax
  8015a6:	a3 44 40 80 00       	mov    %eax,0x804044
  8015ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ae:	8b 40 04             	mov    0x4(%eax),%eax
  8015b1:	85 c0                	test   %eax,%eax
  8015b3:	74 0f                	je     8015c4 <free+0x9b>
  8015b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b8:	8b 40 04             	mov    0x4(%eax),%eax
  8015bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015be:	8b 12                	mov    (%edx),%edx
  8015c0:	89 10                	mov    %edx,(%eax)
  8015c2:	eb 0a                	jmp    8015ce <free+0xa5>
  8015c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c7:	8b 00                	mov    (%eax),%eax
  8015c9:	a3 40 40 80 00       	mov    %eax,0x804040
  8015ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015e1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015e6:	48                   	dec    %eax
  8015e7:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8015ec:	83 ec 0c             	sub    $0xc,%esp
  8015ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f2:	e8 83 12 00 00       	call   80287a <insert_sorted_with_merge_freeList>
  8015f7:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015fa:	90                   	nop
  8015fb:	c9                   	leave  
  8015fc:	c3                   	ret    

008015fd <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015fd:	55                   	push   %ebp
  8015fe:	89 e5                	mov    %esp,%ebp
  801600:	83 ec 28             	sub    $0x28,%esp
  801603:	8b 45 10             	mov    0x10(%ebp),%eax
  801606:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801609:	e8 fe fc ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  80160e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801612:	75 0a                	jne    80161e <smalloc+0x21>
  801614:	b8 00 00 00 00       	mov    $0x0,%eax
  801619:	e9 86 00 00 00       	jmp    8016a4 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  80161e:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801625:	8b 55 0c             	mov    0xc(%ebp),%edx
  801628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162b:	01 d0                	add    %edx,%eax
  80162d:	48                   	dec    %eax
  80162e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801634:	ba 00 00 00 00       	mov    $0x0,%edx
  801639:	f7 75 f4             	divl   -0xc(%ebp)
  80163c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163f:	29 d0                	sub    %edx,%eax
  801641:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801644:	e8 e4 06 00 00       	call   801d2d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801649:	85 c0                	test   %eax,%eax
  80164b:	74 52                	je     80169f <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  80164d:	83 ec 0c             	sub    $0xc,%esp
  801650:	ff 75 0c             	pushl  0xc(%ebp)
  801653:	e8 e6 0d 00 00       	call   80243e <alloc_block_FF>
  801658:	83 c4 10             	add    $0x10,%esp
  80165b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  80165e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801662:	75 07                	jne    80166b <smalloc+0x6e>
			return NULL ;
  801664:	b8 00 00 00 00       	mov    $0x0,%eax
  801669:	eb 39                	jmp    8016a4 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80166b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166e:	8b 40 08             	mov    0x8(%eax),%eax
  801671:	89 c2                	mov    %eax,%edx
  801673:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801677:	52                   	push   %edx
  801678:	50                   	push   %eax
  801679:	ff 75 0c             	pushl  0xc(%ebp)
  80167c:	ff 75 08             	pushl  0x8(%ebp)
  80167f:	e8 2e 04 00 00       	call   801ab2 <sys_createSharedObject>
  801684:	83 c4 10             	add    $0x10,%esp
  801687:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80168a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80168e:	79 07                	jns    801697 <smalloc+0x9a>
			return (void*)NULL ;
  801690:	b8 00 00 00 00       	mov    $0x0,%eax
  801695:	eb 0d                	jmp    8016a4 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801697:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169a:	8b 40 08             	mov    0x8(%eax),%eax
  80169d:	eb 05                	jmp    8016a4 <smalloc+0xa7>
		}
		return (void*)NULL ;
  80169f:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016a4:	c9                   	leave  
  8016a5:	c3                   	ret    

008016a6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016a6:	55                   	push   %ebp
  8016a7:	89 e5                	mov    %esp,%ebp
  8016a9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ac:	e8 5b fc ff ff       	call   80130c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016b1:	83 ec 08             	sub    $0x8,%esp
  8016b4:	ff 75 0c             	pushl  0xc(%ebp)
  8016b7:	ff 75 08             	pushl  0x8(%ebp)
  8016ba:	e8 1d 04 00 00       	call   801adc <sys_getSizeOfSharedObject>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8016c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016c9:	75 0a                	jne    8016d5 <sget+0x2f>
			return NULL ;
  8016cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d0:	e9 83 00 00 00       	jmp    801758 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8016d5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	48                   	dec    %eax
  8016e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f0:	f7 75 f0             	divl   -0x10(%ebp)
  8016f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f6:	29 d0                	sub    %edx,%eax
  8016f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016fb:	e8 2d 06 00 00       	call   801d2d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801700:	85 c0                	test   %eax,%eax
  801702:	74 4f                	je     801753 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  801704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801707:	83 ec 0c             	sub    $0xc,%esp
  80170a:	50                   	push   %eax
  80170b:	e8 2e 0d 00 00       	call   80243e <alloc_block_FF>
  801710:	83 c4 10             	add    $0x10,%esp
  801713:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801716:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80171a:	75 07                	jne    801723 <sget+0x7d>
					return (void*)NULL ;
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
  801721:	eb 35                	jmp    801758 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801723:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801726:	8b 40 08             	mov    0x8(%eax),%eax
  801729:	83 ec 04             	sub    $0x4,%esp
  80172c:	50                   	push   %eax
  80172d:	ff 75 0c             	pushl  0xc(%ebp)
  801730:	ff 75 08             	pushl  0x8(%ebp)
  801733:	e8 c1 03 00 00       	call   801af9 <sys_getSharedObject>
  801738:	83 c4 10             	add    $0x10,%esp
  80173b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  80173e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801742:	79 07                	jns    80174b <sget+0xa5>
				return (void*)NULL ;
  801744:	b8 00 00 00 00       	mov    $0x0,%eax
  801749:	eb 0d                	jmp    801758 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  80174b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80174e:	8b 40 08             	mov    0x8(%eax),%eax
  801751:	eb 05                	jmp    801758 <sget+0xb2>


		}
	return (void*)NULL ;
  801753:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801760:	e8 a7 fb ff ff       	call   80130c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801765:	83 ec 04             	sub    $0x4,%esp
  801768:	68 c0 3a 80 00       	push   $0x803ac0
  80176d:	68 f9 00 00 00       	push   $0xf9
  801772:	68 b3 3a 80 00       	push   $0x803ab3
  801777:	e8 52 eb ff ff       	call   8002ce <_panic>

0080177c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	68 e8 3a 80 00       	push   $0x803ae8
  80178a:	68 0d 01 00 00       	push   $0x10d
  80178f:	68 b3 3a 80 00       	push   $0x803ab3
  801794:	e8 35 eb ff ff       	call   8002ce <_panic>

00801799 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80179f:	83 ec 04             	sub    $0x4,%esp
  8017a2:	68 0c 3b 80 00       	push   $0x803b0c
  8017a7:	68 18 01 00 00       	push   $0x118
  8017ac:	68 b3 3a 80 00       	push   $0x803ab3
  8017b1:	e8 18 eb ff ff       	call   8002ce <_panic>

008017b6 <shrink>:

}
void shrink(uint32 newSize)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017bc:	83 ec 04             	sub    $0x4,%esp
  8017bf:	68 0c 3b 80 00       	push   $0x803b0c
  8017c4:	68 1d 01 00 00       	push   $0x11d
  8017c9:	68 b3 3a 80 00       	push   $0x803ab3
  8017ce:	e8 fb ea ff ff       	call   8002ce <_panic>

008017d3 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	68 0c 3b 80 00       	push   $0x803b0c
  8017e1:	68 22 01 00 00       	push   $0x122
  8017e6:	68 b3 3a 80 00       	push   $0x803ab3
  8017eb:	e8 de ea ff ff       	call   8002ce <_panic>

008017f0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	57                   	push   %edi
  8017f4:	56                   	push   %esi
  8017f5:	53                   	push   %ebx
  8017f6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ff:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801802:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801805:	8b 7d 18             	mov    0x18(%ebp),%edi
  801808:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80180b:	cd 30                	int    $0x30
  80180d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801810:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801813:	83 c4 10             	add    $0x10,%esp
  801816:	5b                   	pop    %ebx
  801817:	5e                   	pop    %esi
  801818:	5f                   	pop    %edi
  801819:	5d                   	pop    %ebp
  80181a:	c3                   	ret    

0080181b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	8b 45 10             	mov    0x10(%ebp),%eax
  801824:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801827:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182b:	8b 45 08             	mov    0x8(%ebp),%eax
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	52                   	push   %edx
  801833:	ff 75 0c             	pushl  0xc(%ebp)
  801836:	50                   	push   %eax
  801837:	6a 00                	push   $0x0
  801839:	e8 b2 ff ff ff       	call   8017f0 <syscall>
  80183e:	83 c4 18             	add    $0x18,%esp
}
  801841:	90                   	nop
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <sys_cgetc>:

int
sys_cgetc(void)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801847:	6a 00                	push   $0x0
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 01                	push   $0x1
  801853:	e8 98 ff ff ff       	call   8017f0 <syscall>
  801858:	83 c4 18             	add    $0x18,%esp
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801860:	8b 55 0c             	mov    0xc(%ebp),%edx
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	52                   	push   %edx
  80186d:	50                   	push   %eax
  80186e:	6a 05                	push   $0x5
  801870:	e8 7b ff ff ff       	call   8017f0 <syscall>
  801875:	83 c4 18             	add    $0x18,%esp
}
  801878:	c9                   	leave  
  801879:	c3                   	ret    

0080187a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	56                   	push   %esi
  80187e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80187f:	8b 75 18             	mov    0x18(%ebp),%esi
  801882:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801885:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801888:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	56                   	push   %esi
  80188f:	53                   	push   %ebx
  801890:	51                   	push   %ecx
  801891:	52                   	push   %edx
  801892:	50                   	push   %eax
  801893:	6a 06                	push   $0x6
  801895:	e8 56 ff ff ff       	call   8017f0 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a0:	5b                   	pop    %ebx
  8018a1:	5e                   	pop    %esi
  8018a2:	5d                   	pop    %ebp
  8018a3:	c3                   	ret    

008018a4 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	52                   	push   %edx
  8018b4:	50                   	push   %eax
  8018b5:	6a 07                	push   $0x7
  8018b7:	e8 34 ff ff ff       	call   8017f0 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	ff 75 0c             	pushl  0xc(%ebp)
  8018cd:	ff 75 08             	pushl  0x8(%ebp)
  8018d0:	6a 08                	push   $0x8
  8018d2:	e8 19 ff ff ff       	call   8017f0 <syscall>
  8018d7:	83 c4 18             	add    $0x18,%esp
}
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 09                	push   $0x9
  8018eb:	e8 00 ff ff ff       	call   8017f0 <syscall>
  8018f0:	83 c4 18             	add    $0x18,%esp
}
  8018f3:	c9                   	leave  
  8018f4:	c3                   	ret    

008018f5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 0a                	push   $0xa
  801904:	e8 e7 fe ff ff       	call   8017f0 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 0b                	push   $0xb
  80191d:	e8 ce fe ff ff       	call   8017f0 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
}
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	ff 75 0c             	pushl  0xc(%ebp)
  801933:	ff 75 08             	pushl  0x8(%ebp)
  801936:	6a 0f                	push   $0xf
  801938:	e8 b3 fe ff ff       	call   8017f0 <syscall>
  80193d:	83 c4 18             	add    $0x18,%esp
	return;
  801940:	90                   	nop
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	ff 75 0c             	pushl  0xc(%ebp)
  80194f:	ff 75 08             	pushl  0x8(%ebp)
  801952:	6a 10                	push   $0x10
  801954:	e8 97 fe ff ff       	call   8017f0 <syscall>
  801959:	83 c4 18             	add    $0x18,%esp
	return ;
  80195c:	90                   	nop
}
  80195d:	c9                   	leave  
  80195e:	c3                   	ret    

0080195f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	ff 75 10             	pushl  0x10(%ebp)
  801969:	ff 75 0c             	pushl  0xc(%ebp)
  80196c:	ff 75 08             	pushl  0x8(%ebp)
  80196f:	6a 11                	push   $0x11
  801971:	e8 7a fe ff ff       	call   8017f0 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
	return ;
  801979:	90                   	nop
}
  80197a:	c9                   	leave  
  80197b:	c3                   	ret    

0080197c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 0c                	push   $0xc
  80198b:	e8 60 fe ff ff       	call   8017f0 <syscall>
  801990:	83 c4 18             	add    $0x18,%esp
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	ff 75 08             	pushl  0x8(%ebp)
  8019a3:	6a 0d                	push   $0xd
  8019a5:	e8 46 fe ff ff       	call   8017f0 <syscall>
  8019aa:	83 c4 18             	add    $0x18,%esp
}
  8019ad:	c9                   	leave  
  8019ae:	c3                   	ret    

008019af <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 0e                	push   $0xe
  8019be:	e8 2d fe ff ff       	call   8017f0 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
}
  8019c6:	90                   	nop
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 13                	push   $0x13
  8019d8:	e8 13 fe ff ff       	call   8017f0 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
}
  8019e0:	90                   	nop
  8019e1:	c9                   	leave  
  8019e2:	c3                   	ret    

008019e3 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 14                	push   $0x14
  8019f2:	e8 f9 fd ff ff       	call   8017f0 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	90                   	nop
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <sys_cputc>:


void
sys_cputc(const char c)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 04             	sub    $0x4,%esp
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a09:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	50                   	push   %eax
  801a16:	6a 15                	push   $0x15
  801a18:	e8 d3 fd ff ff       	call   8017f0 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	90                   	nop
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 16                	push   $0x16
  801a32:	e8 b9 fd ff ff       	call   8017f0 <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	90                   	nop
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a40:	8b 45 08             	mov    0x8(%ebp),%eax
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	50                   	push   %eax
  801a4d:	6a 17                	push   $0x17
  801a4f:	e8 9c fd ff ff       	call   8017f0 <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	52                   	push   %edx
  801a69:	50                   	push   %eax
  801a6a:	6a 1a                	push   $0x1a
  801a6c:	e8 7f fd ff ff       	call   8017f0 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	52                   	push   %edx
  801a86:	50                   	push   %eax
  801a87:	6a 18                	push   $0x18
  801a89:	e8 62 fd ff ff       	call   8017f0 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	90                   	nop
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	52                   	push   %edx
  801aa4:	50                   	push   %eax
  801aa5:	6a 19                	push   $0x19
  801aa7:	e8 44 fd ff ff       	call   8017f0 <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	90                   	nop
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 04             	sub    $0x4,%esp
  801ab8:	8b 45 10             	mov    0x10(%ebp),%eax
  801abb:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801abe:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	6a 00                	push   $0x0
  801aca:	51                   	push   %ecx
  801acb:	52                   	push   %edx
  801acc:	ff 75 0c             	pushl  0xc(%ebp)
  801acf:	50                   	push   %eax
  801ad0:	6a 1b                	push   $0x1b
  801ad2:	e8 19 fd ff ff       	call   8017f0 <syscall>
  801ad7:	83 c4 18             	add    $0x18,%esp
}
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	52                   	push   %edx
  801aec:	50                   	push   %eax
  801aed:	6a 1c                	push   $0x1c
  801aef:	e8 fc fc ff ff       	call   8017f0 <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801afc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	51                   	push   %ecx
  801b0a:	52                   	push   %edx
  801b0b:	50                   	push   %eax
  801b0c:	6a 1d                	push   $0x1d
  801b0e:	e8 dd fc ff ff       	call   8017f0 <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	52                   	push   %edx
  801b28:	50                   	push   %eax
  801b29:	6a 1e                	push   $0x1e
  801b2b:	e8 c0 fc ff ff       	call   8017f0 <syscall>
  801b30:	83 c4 18             	add    $0x18,%esp
}
  801b33:	c9                   	leave  
  801b34:	c3                   	ret    

00801b35 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b35:	55                   	push   %ebp
  801b36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 1f                	push   $0x1f
  801b44:	e8 a7 fc ff ff       	call   8017f0 <syscall>
  801b49:	83 c4 18             	add    $0x18,%esp
}
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	6a 00                	push   $0x0
  801b56:	ff 75 14             	pushl  0x14(%ebp)
  801b59:	ff 75 10             	pushl  0x10(%ebp)
  801b5c:	ff 75 0c             	pushl  0xc(%ebp)
  801b5f:	50                   	push   %eax
  801b60:	6a 20                	push   $0x20
  801b62:	e8 89 fc ff ff       	call   8017f0 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	c9                   	leave  
  801b6b:	c3                   	ret    

00801b6c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	50                   	push   %eax
  801b7b:	6a 21                	push   $0x21
  801b7d:	e8 6e fc ff ff       	call   8017f0 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	90                   	nop
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	50                   	push   %eax
  801b97:	6a 22                	push   $0x22
  801b99:	e8 52 fc ff ff       	call   8017f0 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 02                	push   $0x2
  801bb2:	e8 39 fc ff ff       	call   8017f0 <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 03                	push   $0x3
  801bcb:	e8 20 fc ff ff       	call   8017f0 <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 04                	push   $0x4
  801be4:	e8 07 fc ff ff       	call   8017f0 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	c9                   	leave  
  801bed:	c3                   	ret    

00801bee <sys_exit_env>:


void sys_exit_env(void)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 23                	push   $0x23
  801bfd:	e8 ee fb ff ff       	call   8017f0 <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	90                   	nop
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
  801c0b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c0e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c11:	8d 50 04             	lea    0x4(%eax),%edx
  801c14:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	52                   	push   %edx
  801c1e:	50                   	push   %eax
  801c1f:	6a 24                	push   $0x24
  801c21:	e8 ca fb ff ff       	call   8017f0 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
	return result;
  801c29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c2f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c32:	89 01                	mov    %eax,(%ecx)
  801c34:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	c9                   	leave  
  801c3b:	c2 04 00             	ret    $0x4

00801c3e <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	ff 75 10             	pushl  0x10(%ebp)
  801c48:	ff 75 0c             	pushl  0xc(%ebp)
  801c4b:	ff 75 08             	pushl  0x8(%ebp)
  801c4e:	6a 12                	push   $0x12
  801c50:	e8 9b fb ff ff       	call   8017f0 <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
	return ;
  801c58:	90                   	nop
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_rcr2>:
uint32 sys_rcr2()
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 25                	push   $0x25
  801c6a:	e8 81 fb ff ff       	call   8017f0 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	83 ec 04             	sub    $0x4,%esp
  801c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c80:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	50                   	push   %eax
  801c8d:	6a 26                	push   $0x26
  801c8f:	e8 5c fb ff ff       	call   8017f0 <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
	return ;
  801c97:	90                   	nop
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <rsttst>:
void rsttst()
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 28                	push   $0x28
  801ca9:	e8 42 fb ff ff       	call   8017f0 <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb1:	90                   	nop
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	83 ec 04             	sub    $0x4,%esp
  801cba:	8b 45 14             	mov    0x14(%ebp),%eax
  801cbd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc0:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cc7:	52                   	push   %edx
  801cc8:	50                   	push   %eax
  801cc9:	ff 75 10             	pushl  0x10(%ebp)
  801ccc:	ff 75 0c             	pushl  0xc(%ebp)
  801ccf:	ff 75 08             	pushl  0x8(%ebp)
  801cd2:	6a 27                	push   $0x27
  801cd4:	e8 17 fb ff ff       	call   8017f0 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdc:	90                   	nop
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <chktst>:
void chktst(uint32 n)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	ff 75 08             	pushl  0x8(%ebp)
  801ced:	6a 29                	push   $0x29
  801cef:	e8 fc fa ff ff       	call   8017f0 <syscall>
  801cf4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf7:	90                   	nop
}
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <inctst>:

void inctst()
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 2a                	push   $0x2a
  801d09:	e8 e2 fa ff ff       	call   8017f0 <syscall>
  801d0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d11:	90                   	nop
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <gettst>:
uint32 gettst()
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 2b                	push   $0x2b
  801d23:	e8 c8 fa ff ff       	call   8017f0 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 2c                	push   $0x2c
  801d3f:	e8 ac fa ff ff       	call   8017f0 <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
  801d47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d4a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d4e:	75 07                	jne    801d57 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d50:	b8 01 00 00 00       	mov    $0x1,%eax
  801d55:	eb 05                	jmp    801d5c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 2c                	push   $0x2c
  801d70:	e8 7b fa ff ff       	call   8017f0 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
  801d78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d7b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d7f:	75 07                	jne    801d88 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d81:	b8 01 00 00 00       	mov    $0x1,%eax
  801d86:	eb 05                	jmp    801d8d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 2c                	push   $0x2c
  801da1:	e8 4a fa ff ff       	call   8017f0 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
  801da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dac:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801db0:	75 07                	jne    801db9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801db2:	b8 01 00 00 00       	mov    $0x1,%eax
  801db7:	eb 05                	jmp    801dbe <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 2c                	push   $0x2c
  801dd2:	e8 19 fa ff ff       	call   8017f0 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
  801dda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ddd:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801de1:	75 07                	jne    801dea <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801de3:	b8 01 00 00 00       	mov    $0x1,%eax
  801de8:	eb 05                	jmp    801def <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	ff 75 08             	pushl  0x8(%ebp)
  801dff:	6a 2d                	push   $0x2d
  801e01:	e8 ea f9 ff ff       	call   8017f0 <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
	return ;
  801e09:	90                   	nop
}
  801e0a:	c9                   	leave  
  801e0b:	c3                   	ret    

00801e0c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e10:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e13:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e19:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1c:	6a 00                	push   $0x0
  801e1e:	53                   	push   %ebx
  801e1f:	51                   	push   %ecx
  801e20:	52                   	push   %edx
  801e21:	50                   	push   %eax
  801e22:	6a 2e                	push   $0x2e
  801e24:	e8 c7 f9 ff ff       	call   8017f0 <syscall>
  801e29:	83 c4 18             	add    $0x18,%esp
}
  801e2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	52                   	push   %edx
  801e41:	50                   	push   %eax
  801e42:	6a 2f                	push   $0x2f
  801e44:	e8 a7 f9 ff ff       	call   8017f0 <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e54:	83 ec 0c             	sub    $0xc,%esp
  801e57:	68 1c 3b 80 00       	push   $0x803b1c
  801e5c:	e8 21 e7 ff ff       	call   800582 <cprintf>
  801e61:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e64:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e6b:	83 ec 0c             	sub    $0xc,%esp
  801e6e:	68 48 3b 80 00       	push   $0x803b48
  801e73:	e8 0a e7 ff ff       	call   800582 <cprintf>
  801e78:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e7b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e7f:	a1 38 41 80 00       	mov    0x804138,%eax
  801e84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e87:	eb 56                	jmp    801edf <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e8d:	74 1c                	je     801eab <print_mem_block_lists+0x5d>
  801e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e92:	8b 50 08             	mov    0x8(%eax),%edx
  801e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e98:	8b 48 08             	mov    0x8(%eax),%ecx
  801e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea1:	01 c8                	add    %ecx,%eax
  801ea3:	39 c2                	cmp    %eax,%edx
  801ea5:	73 04                	jae    801eab <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ea7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eae:	8b 50 08             	mov    0x8(%eax),%edx
  801eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb4:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb7:	01 c2                	add    %eax,%edx
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	8b 40 08             	mov    0x8(%eax),%eax
  801ebf:	83 ec 04             	sub    $0x4,%esp
  801ec2:	52                   	push   %edx
  801ec3:	50                   	push   %eax
  801ec4:	68 5d 3b 80 00       	push   $0x803b5d
  801ec9:	e8 b4 e6 ff ff       	call   800582 <cprintf>
  801ece:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ed7:	a1 40 41 80 00       	mov    0x804140,%eax
  801edc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801edf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee3:	74 07                	je     801eec <print_mem_block_lists+0x9e>
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee8:	8b 00                	mov    (%eax),%eax
  801eea:	eb 05                	jmp    801ef1 <print_mem_block_lists+0xa3>
  801eec:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef1:	a3 40 41 80 00       	mov    %eax,0x804140
  801ef6:	a1 40 41 80 00       	mov    0x804140,%eax
  801efb:	85 c0                	test   %eax,%eax
  801efd:	75 8a                	jne    801e89 <print_mem_block_lists+0x3b>
  801eff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f03:	75 84                	jne    801e89 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f05:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f09:	75 10                	jne    801f1b <print_mem_block_lists+0xcd>
  801f0b:	83 ec 0c             	sub    $0xc,%esp
  801f0e:	68 6c 3b 80 00       	push   $0x803b6c
  801f13:	e8 6a e6 ff ff       	call   800582 <cprintf>
  801f18:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f1b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f22:	83 ec 0c             	sub    $0xc,%esp
  801f25:	68 90 3b 80 00       	push   $0x803b90
  801f2a:	e8 53 e6 ff ff       	call   800582 <cprintf>
  801f2f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f32:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f36:	a1 40 40 80 00       	mov    0x804040,%eax
  801f3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3e:	eb 56                	jmp    801f96 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f44:	74 1c                	je     801f62 <print_mem_block_lists+0x114>
  801f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f49:	8b 50 08             	mov    0x8(%eax),%edx
  801f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4f:	8b 48 08             	mov    0x8(%eax),%ecx
  801f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f55:	8b 40 0c             	mov    0xc(%eax),%eax
  801f58:	01 c8                	add    %ecx,%eax
  801f5a:	39 c2                	cmp    %eax,%edx
  801f5c:	73 04                	jae    801f62 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f5e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f65:	8b 50 08             	mov    0x8(%eax),%edx
  801f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6e:	01 c2                	add    %eax,%edx
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	8b 40 08             	mov    0x8(%eax),%eax
  801f76:	83 ec 04             	sub    $0x4,%esp
  801f79:	52                   	push   %edx
  801f7a:	50                   	push   %eax
  801f7b:	68 5d 3b 80 00       	push   $0x803b5d
  801f80:	e8 fd e5 ff ff       	call   800582 <cprintf>
  801f85:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f8e:	a1 48 40 80 00       	mov    0x804048,%eax
  801f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9a:	74 07                	je     801fa3 <print_mem_block_lists+0x155>
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	8b 00                	mov    (%eax),%eax
  801fa1:	eb 05                	jmp    801fa8 <print_mem_block_lists+0x15a>
  801fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa8:	a3 48 40 80 00       	mov    %eax,0x804048
  801fad:	a1 48 40 80 00       	mov    0x804048,%eax
  801fb2:	85 c0                	test   %eax,%eax
  801fb4:	75 8a                	jne    801f40 <print_mem_block_lists+0xf2>
  801fb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fba:	75 84                	jne    801f40 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fbc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc0:	75 10                	jne    801fd2 <print_mem_block_lists+0x184>
  801fc2:	83 ec 0c             	sub    $0xc,%esp
  801fc5:	68 a8 3b 80 00       	push   $0x803ba8
  801fca:	e8 b3 e5 ff ff       	call   800582 <cprintf>
  801fcf:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fd2:	83 ec 0c             	sub    $0xc,%esp
  801fd5:	68 1c 3b 80 00       	push   $0x803b1c
  801fda:	e8 a3 e5 ff ff       	call   800582 <cprintf>
  801fdf:	83 c4 10             	add    $0x10,%esp

}
  801fe2:	90                   	nop
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801feb:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ff2:	00 00 00 
  801ff5:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ffc:	00 00 00 
  801fff:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802006:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802009:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802010:	e9 9e 00 00 00       	jmp    8020b3 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802015:	a1 50 40 80 00       	mov    0x804050,%eax
  80201a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201d:	c1 e2 04             	shl    $0x4,%edx
  802020:	01 d0                	add    %edx,%eax
  802022:	85 c0                	test   %eax,%eax
  802024:	75 14                	jne    80203a <initialize_MemBlocksList+0x55>
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	68 d0 3b 80 00       	push   $0x803bd0
  80202e:	6a 43                	push   $0x43
  802030:	68 f3 3b 80 00       	push   $0x803bf3
  802035:	e8 94 e2 ff ff       	call   8002ce <_panic>
  80203a:	a1 50 40 80 00       	mov    0x804050,%eax
  80203f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802042:	c1 e2 04             	shl    $0x4,%edx
  802045:	01 d0                	add    %edx,%eax
  802047:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80204d:	89 10                	mov    %edx,(%eax)
  80204f:	8b 00                	mov    (%eax),%eax
  802051:	85 c0                	test   %eax,%eax
  802053:	74 18                	je     80206d <initialize_MemBlocksList+0x88>
  802055:	a1 48 41 80 00       	mov    0x804148,%eax
  80205a:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802060:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802063:	c1 e1 04             	shl    $0x4,%ecx
  802066:	01 ca                	add    %ecx,%edx
  802068:	89 50 04             	mov    %edx,0x4(%eax)
  80206b:	eb 12                	jmp    80207f <initialize_MemBlocksList+0x9a>
  80206d:	a1 50 40 80 00       	mov    0x804050,%eax
  802072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802075:	c1 e2 04             	shl    $0x4,%edx
  802078:	01 d0                	add    %edx,%eax
  80207a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80207f:	a1 50 40 80 00       	mov    0x804050,%eax
  802084:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802087:	c1 e2 04             	shl    $0x4,%edx
  80208a:	01 d0                	add    %edx,%eax
  80208c:	a3 48 41 80 00       	mov    %eax,0x804148
  802091:	a1 50 40 80 00       	mov    0x804050,%eax
  802096:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802099:	c1 e2 04             	shl    $0x4,%edx
  80209c:	01 d0                	add    %edx,%eax
  80209e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a5:	a1 54 41 80 00       	mov    0x804154,%eax
  8020aa:	40                   	inc    %eax
  8020ab:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  8020b0:	ff 45 f4             	incl   -0xc(%ebp)
  8020b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020b9:	0f 82 56 ff ff ff    	jb     802015 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8020bf:	90                   	nop
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8020c8:	a1 38 41 80 00       	mov    0x804138,%eax
  8020cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d0:	eb 18                	jmp    8020ea <find_block+0x28>
	{
		if (ele->sva==va)
  8020d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d5:	8b 40 08             	mov    0x8(%eax),%eax
  8020d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020db:	75 05                	jne    8020e2 <find_block+0x20>
			return ele;
  8020dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e0:	eb 7b                	jmp    80215d <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8020e2:	a1 40 41 80 00       	mov    0x804140,%eax
  8020e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ea:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020ee:	74 07                	je     8020f7 <find_block+0x35>
  8020f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f3:	8b 00                	mov    (%eax),%eax
  8020f5:	eb 05                	jmp    8020fc <find_block+0x3a>
  8020f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fc:	a3 40 41 80 00       	mov    %eax,0x804140
  802101:	a1 40 41 80 00       	mov    0x804140,%eax
  802106:	85 c0                	test   %eax,%eax
  802108:	75 c8                	jne    8020d2 <find_block+0x10>
  80210a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80210e:	75 c2                	jne    8020d2 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802110:	a1 40 40 80 00       	mov    0x804040,%eax
  802115:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802118:	eb 18                	jmp    802132 <find_block+0x70>
	{
		if (ele->sva==va)
  80211a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211d:	8b 40 08             	mov    0x8(%eax),%eax
  802120:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802123:	75 05                	jne    80212a <find_block+0x68>
					return ele;
  802125:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802128:	eb 33                	jmp    80215d <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  80212a:	a1 48 40 80 00       	mov    0x804048,%eax
  80212f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802132:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802136:	74 07                	je     80213f <find_block+0x7d>
  802138:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213b:	8b 00                	mov    (%eax),%eax
  80213d:	eb 05                	jmp    802144 <find_block+0x82>
  80213f:	b8 00 00 00 00       	mov    $0x0,%eax
  802144:	a3 48 40 80 00       	mov    %eax,0x804048
  802149:	a1 48 40 80 00       	mov    0x804048,%eax
  80214e:	85 c0                	test   %eax,%eax
  802150:	75 c8                	jne    80211a <find_block+0x58>
  802152:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802156:	75 c2                	jne    80211a <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802158:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802165:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80216a:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80216d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802171:	75 62                	jne    8021d5 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802173:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802177:	75 14                	jne    80218d <insert_sorted_allocList+0x2e>
  802179:	83 ec 04             	sub    $0x4,%esp
  80217c:	68 d0 3b 80 00       	push   $0x803bd0
  802181:	6a 69                	push   $0x69
  802183:	68 f3 3b 80 00       	push   $0x803bf3
  802188:	e8 41 e1 ff ff       	call   8002ce <_panic>
  80218d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	89 10                	mov    %edx,(%eax)
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	8b 00                	mov    (%eax),%eax
  80219d:	85 c0                	test   %eax,%eax
  80219f:	74 0d                	je     8021ae <insert_sorted_allocList+0x4f>
  8021a1:	a1 40 40 80 00       	mov    0x804040,%eax
  8021a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a9:	89 50 04             	mov    %edx,0x4(%eax)
  8021ac:	eb 08                	jmp    8021b6 <insert_sorted_allocList+0x57>
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	a3 44 40 80 00       	mov    %eax,0x804044
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	a3 40 40 80 00       	mov    %eax,0x804040
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021c8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021cd:	40                   	inc    %eax
  8021ce:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021d3:	eb 72                	jmp    802247 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8021d5:	a1 40 40 80 00       	mov    0x804040,%eax
  8021da:	8b 50 08             	mov    0x8(%eax),%edx
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	8b 40 08             	mov    0x8(%eax),%eax
  8021e3:	39 c2                	cmp    %eax,%edx
  8021e5:	76 60                	jbe    802247 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8021e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021eb:	75 14                	jne    802201 <insert_sorted_allocList+0xa2>
  8021ed:	83 ec 04             	sub    $0x4,%esp
  8021f0:	68 d0 3b 80 00       	push   $0x803bd0
  8021f5:	6a 6d                	push   $0x6d
  8021f7:	68 f3 3b 80 00       	push   $0x803bf3
  8021fc:	e8 cd e0 ff ff       	call   8002ce <_panic>
  802201:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	89 10                	mov    %edx,(%eax)
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	8b 00                	mov    (%eax),%eax
  802211:	85 c0                	test   %eax,%eax
  802213:	74 0d                	je     802222 <insert_sorted_allocList+0xc3>
  802215:	a1 40 40 80 00       	mov    0x804040,%eax
  80221a:	8b 55 08             	mov    0x8(%ebp),%edx
  80221d:	89 50 04             	mov    %edx,0x4(%eax)
  802220:	eb 08                	jmp    80222a <insert_sorted_allocList+0xcb>
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	a3 44 40 80 00       	mov    %eax,0x804044
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	a3 40 40 80 00       	mov    %eax,0x804040
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80223c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802241:	40                   	inc    %eax
  802242:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802247:	a1 40 40 80 00       	mov    0x804040,%eax
  80224c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224f:	e9 b9 01 00 00       	jmp    80240d <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802254:	8b 45 08             	mov    0x8(%ebp),%eax
  802257:	8b 50 08             	mov    0x8(%eax),%edx
  80225a:	a1 40 40 80 00       	mov    0x804040,%eax
  80225f:	8b 40 08             	mov    0x8(%eax),%eax
  802262:	39 c2                	cmp    %eax,%edx
  802264:	76 7c                	jbe    8022e2 <insert_sorted_allocList+0x183>
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8b 50 08             	mov    0x8(%eax),%edx
  80226c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226f:	8b 40 08             	mov    0x8(%eax),%eax
  802272:	39 c2                	cmp    %eax,%edx
  802274:	73 6c                	jae    8022e2 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227a:	74 06                	je     802282 <insert_sorted_allocList+0x123>
  80227c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802280:	75 14                	jne    802296 <insert_sorted_allocList+0x137>
  802282:	83 ec 04             	sub    $0x4,%esp
  802285:	68 0c 3c 80 00       	push   $0x803c0c
  80228a:	6a 75                	push   $0x75
  80228c:	68 f3 3b 80 00       	push   $0x803bf3
  802291:	e8 38 e0 ff ff       	call   8002ce <_panic>
  802296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802299:	8b 50 04             	mov    0x4(%eax),%edx
  80229c:	8b 45 08             	mov    0x8(%ebp),%eax
  80229f:	89 50 04             	mov    %edx,0x4(%eax)
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a8:	89 10                	mov    %edx,(%eax)
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 40 04             	mov    0x4(%eax),%eax
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	74 0d                	je     8022c1 <insert_sorted_allocList+0x162>
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bd:	89 10                	mov    %edx,(%eax)
  8022bf:	eb 08                	jmp    8022c9 <insert_sorted_allocList+0x16a>
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	a3 40 40 80 00       	mov    %eax,0x804040
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8022cf:	89 50 04             	mov    %edx,0x4(%eax)
  8022d2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d7:	40                   	inc    %eax
  8022d8:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8022dd:	e9 59 01 00 00       	jmp    80243b <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	8b 50 08             	mov    0x8(%eax),%edx
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 40 08             	mov    0x8(%eax),%eax
  8022ee:	39 c2                	cmp    %eax,%edx
  8022f0:	0f 86 98 00 00 00    	jbe    80238e <insert_sorted_allocList+0x22f>
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	8b 50 08             	mov    0x8(%eax),%edx
  8022fc:	a1 44 40 80 00       	mov    0x804044,%eax
  802301:	8b 40 08             	mov    0x8(%eax),%eax
  802304:	39 c2                	cmp    %eax,%edx
  802306:	0f 83 82 00 00 00    	jae    80238e <insert_sorted_allocList+0x22f>
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	8b 50 08             	mov    0x8(%eax),%edx
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 00                	mov    (%eax),%eax
  802317:	8b 40 08             	mov    0x8(%eax),%eax
  80231a:	39 c2                	cmp    %eax,%edx
  80231c:	73 70                	jae    80238e <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80231e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802322:	74 06                	je     80232a <insert_sorted_allocList+0x1cb>
  802324:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802328:	75 14                	jne    80233e <insert_sorted_allocList+0x1df>
  80232a:	83 ec 04             	sub    $0x4,%esp
  80232d:	68 44 3c 80 00       	push   $0x803c44
  802332:	6a 7c                	push   $0x7c
  802334:	68 f3 3b 80 00       	push   $0x803bf3
  802339:	e8 90 df ff ff       	call   8002ce <_panic>
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 10                	mov    (%eax),%edx
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	89 10                	mov    %edx,(%eax)
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	8b 00                	mov    (%eax),%eax
  80234d:	85 c0                	test   %eax,%eax
  80234f:	74 0b                	je     80235c <insert_sorted_allocList+0x1fd>
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	8b 55 08             	mov    0x8(%ebp),%edx
  802359:	89 50 04             	mov    %edx,0x4(%eax)
  80235c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235f:	8b 55 08             	mov    0x8(%ebp),%edx
  802362:	89 10                	mov    %edx,(%eax)
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236a:	89 50 04             	mov    %edx,0x4(%eax)
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	8b 00                	mov    (%eax),%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	75 08                	jne    80237e <insert_sorted_allocList+0x21f>
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	a3 44 40 80 00       	mov    %eax,0x804044
  80237e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802383:	40                   	inc    %eax
  802384:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802389:	e9 ad 00 00 00       	jmp    80243b <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	8b 50 08             	mov    0x8(%eax),%edx
  802394:	a1 44 40 80 00       	mov    0x804044,%eax
  802399:	8b 40 08             	mov    0x8(%eax),%eax
  80239c:	39 c2                	cmp    %eax,%edx
  80239e:	76 65                	jbe    802405 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  8023a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023a4:	75 17                	jne    8023bd <insert_sorted_allocList+0x25e>
  8023a6:	83 ec 04             	sub    $0x4,%esp
  8023a9:	68 78 3c 80 00       	push   $0x803c78
  8023ae:	68 80 00 00 00       	push   $0x80
  8023b3:	68 f3 3b 80 00       	push   $0x803bf3
  8023b8:	e8 11 df ff ff       	call   8002ce <_panic>
  8023bd:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c6:	89 50 04             	mov    %edx,0x4(%eax)
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	8b 40 04             	mov    0x4(%eax),%eax
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	74 0c                	je     8023df <insert_sorted_allocList+0x280>
  8023d3:	a1 44 40 80 00       	mov    0x804044,%eax
  8023d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8023db:	89 10                	mov    %edx,(%eax)
  8023dd:	eb 08                	jmp    8023e7 <insert_sorted_allocList+0x288>
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e2:	a3 40 40 80 00       	mov    %eax,0x804040
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	a3 44 40 80 00       	mov    %eax,0x804044
  8023ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023fd:	40                   	inc    %eax
  8023fe:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802403:	eb 36                	jmp    80243b <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802405:	a1 48 40 80 00       	mov    0x804048,%eax
  80240a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802411:	74 07                	je     80241a <insert_sorted_allocList+0x2bb>
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 00                	mov    (%eax),%eax
  802418:	eb 05                	jmp    80241f <insert_sorted_allocList+0x2c0>
  80241a:	b8 00 00 00 00       	mov    $0x0,%eax
  80241f:	a3 48 40 80 00       	mov    %eax,0x804048
  802424:	a1 48 40 80 00       	mov    0x804048,%eax
  802429:	85 c0                	test   %eax,%eax
  80242b:	0f 85 23 fe ff ff    	jne    802254 <insert_sorted_allocList+0xf5>
  802431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802435:	0f 85 19 fe ff ff    	jne    802254 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  80243b:	90                   	nop
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
  802441:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802444:	a1 38 41 80 00       	mov    0x804138,%eax
  802449:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244c:	e9 7c 01 00 00       	jmp    8025cd <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	8b 40 0c             	mov    0xc(%eax),%eax
  802457:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245a:	0f 85 90 00 00 00    	jne    8024f0 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80246a:	75 17                	jne    802483 <alloc_block_FF+0x45>
  80246c:	83 ec 04             	sub    $0x4,%esp
  80246f:	68 9b 3c 80 00       	push   $0x803c9b
  802474:	68 ba 00 00 00       	push   $0xba
  802479:	68 f3 3b 80 00       	push   $0x803bf3
  80247e:	e8 4b de ff ff       	call   8002ce <_panic>
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 00                	mov    (%eax),%eax
  802488:	85 c0                	test   %eax,%eax
  80248a:	74 10                	je     80249c <alloc_block_FF+0x5e>
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 00                	mov    (%eax),%eax
  802491:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802494:	8b 52 04             	mov    0x4(%edx),%edx
  802497:	89 50 04             	mov    %edx,0x4(%eax)
  80249a:	eb 0b                	jmp    8024a7 <alloc_block_FF+0x69>
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 40 04             	mov    0x4(%eax),%eax
  8024a2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 40 04             	mov    0x4(%eax),%eax
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	74 0f                	je     8024c0 <alloc_block_FF+0x82>
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 04             	mov    0x4(%eax),%eax
  8024b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ba:	8b 12                	mov    (%edx),%edx
  8024bc:	89 10                	mov    %edx,(%eax)
  8024be:	eb 0a                	jmp    8024ca <alloc_block_FF+0x8c>
  8024c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c3:	8b 00                	mov    (%eax),%eax
  8024c5:	a3 38 41 80 00       	mov    %eax,0x804138
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024dd:	a1 44 41 80 00       	mov    0x804144,%eax
  8024e2:	48                   	dec    %eax
  8024e3:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8024e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024eb:	e9 10 01 00 00       	jmp    802600 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8024f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f9:	0f 86 c6 00 00 00    	jbe    8025c5 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8024ff:	a1 48 41 80 00       	mov    0x804148,%eax
  802504:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802507:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80250b:	75 17                	jne    802524 <alloc_block_FF+0xe6>
  80250d:	83 ec 04             	sub    $0x4,%esp
  802510:	68 9b 3c 80 00       	push   $0x803c9b
  802515:	68 c2 00 00 00       	push   $0xc2
  80251a:	68 f3 3b 80 00       	push   $0x803bf3
  80251f:	e8 aa dd ff ff       	call   8002ce <_panic>
  802524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802527:	8b 00                	mov    (%eax),%eax
  802529:	85 c0                	test   %eax,%eax
  80252b:	74 10                	je     80253d <alloc_block_FF+0xff>
  80252d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802530:	8b 00                	mov    (%eax),%eax
  802532:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802535:	8b 52 04             	mov    0x4(%edx),%edx
  802538:	89 50 04             	mov    %edx,0x4(%eax)
  80253b:	eb 0b                	jmp    802548 <alloc_block_FF+0x10a>
  80253d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802540:	8b 40 04             	mov    0x4(%eax),%eax
  802543:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254b:	8b 40 04             	mov    0x4(%eax),%eax
  80254e:	85 c0                	test   %eax,%eax
  802550:	74 0f                	je     802561 <alloc_block_FF+0x123>
  802552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802555:	8b 40 04             	mov    0x4(%eax),%eax
  802558:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80255b:	8b 12                	mov    (%edx),%edx
  80255d:	89 10                	mov    %edx,(%eax)
  80255f:	eb 0a                	jmp    80256b <alloc_block_FF+0x12d>
  802561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802564:	8b 00                	mov    (%eax),%eax
  802566:	a3 48 41 80 00       	mov    %eax,0x804148
  80256b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802577:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257e:	a1 54 41 80 00       	mov    0x804154,%eax
  802583:	48                   	dec    %eax
  802584:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	8b 50 08             	mov    0x8(%eax),%edx
  80258f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802592:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802595:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802598:	8b 55 08             	mov    0x8(%ebp),%edx
  80259b:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a4:	2b 45 08             	sub    0x8(%ebp),%eax
  8025a7:	89 c2                	mov    %eax,%edx
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 50 08             	mov    0x8(%eax),%edx
  8025b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b8:	01 c2                	add    %eax,%edx
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8025c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c3:	eb 3b                	jmp    802600 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025c5:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d1:	74 07                	je     8025da <alloc_block_FF+0x19c>
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 00                	mov    (%eax),%eax
  8025d8:	eb 05                	jmp    8025df <alloc_block_FF+0x1a1>
  8025da:	b8 00 00 00 00       	mov    $0x0,%eax
  8025df:	a3 40 41 80 00       	mov    %eax,0x804140
  8025e4:	a1 40 41 80 00       	mov    0x804140,%eax
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	0f 85 60 fe ff ff    	jne    802451 <alloc_block_FF+0x13>
  8025f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f5:	0f 85 56 fe ff ff    	jne    802451 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8025fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802600:	c9                   	leave  
  802601:	c3                   	ret    

00802602 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  802602:	55                   	push   %ebp
  802603:	89 e5                	mov    %esp,%ebp
  802605:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  802608:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80260f:	a1 38 41 80 00       	mov    0x804138,%eax
  802614:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802617:	eb 3a                	jmp    802653 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 40 0c             	mov    0xc(%eax),%eax
  80261f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802622:	72 27                	jb     80264b <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802624:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802628:	75 0b                	jne    802635 <alloc_block_BF+0x33>
					best_size= element->size;
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 40 0c             	mov    0xc(%eax),%eax
  802630:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802633:	eb 16                	jmp    80264b <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	8b 50 0c             	mov    0xc(%eax),%edx
  80263b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263e:	39 c2                	cmp    %eax,%edx
  802640:	77 09                	ja     80264b <alloc_block_BF+0x49>
					best_size=element->size;
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 40 0c             	mov    0xc(%eax),%eax
  802648:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80264b:	a1 40 41 80 00       	mov    0x804140,%eax
  802650:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802653:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802657:	74 07                	je     802660 <alloc_block_BF+0x5e>
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 00                	mov    (%eax),%eax
  80265e:	eb 05                	jmp    802665 <alloc_block_BF+0x63>
  802660:	b8 00 00 00 00       	mov    $0x0,%eax
  802665:	a3 40 41 80 00       	mov    %eax,0x804140
  80266a:	a1 40 41 80 00       	mov    0x804140,%eax
  80266f:	85 c0                	test   %eax,%eax
  802671:	75 a6                	jne    802619 <alloc_block_BF+0x17>
  802673:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802677:	75 a0                	jne    802619 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802679:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80267d:	0f 84 d3 01 00 00    	je     802856 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802683:	a1 38 41 80 00       	mov    0x804138,%eax
  802688:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268b:	e9 98 01 00 00       	jmp    802828 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802693:	3b 45 08             	cmp    0x8(%ebp),%eax
  802696:	0f 86 da 00 00 00    	jbe    802776 <alloc_block_BF+0x174>
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 50 0c             	mov    0xc(%eax),%edx
  8026a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a5:	39 c2                	cmp    %eax,%edx
  8026a7:	0f 85 c9 00 00 00    	jne    802776 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  8026ad:	a1 48 41 80 00       	mov    0x804148,%eax
  8026b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8026b5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026b9:	75 17                	jne    8026d2 <alloc_block_BF+0xd0>
  8026bb:	83 ec 04             	sub    $0x4,%esp
  8026be:	68 9b 3c 80 00       	push   $0x803c9b
  8026c3:	68 ea 00 00 00       	push   $0xea
  8026c8:	68 f3 3b 80 00       	push   $0x803bf3
  8026cd:	e8 fc db ff ff       	call   8002ce <_panic>
  8026d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d5:	8b 00                	mov    (%eax),%eax
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	74 10                	je     8026eb <alloc_block_BF+0xe9>
  8026db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026de:	8b 00                	mov    (%eax),%eax
  8026e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e3:	8b 52 04             	mov    0x4(%edx),%edx
  8026e6:	89 50 04             	mov    %edx,0x4(%eax)
  8026e9:	eb 0b                	jmp    8026f6 <alloc_block_BF+0xf4>
  8026eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ee:	8b 40 04             	mov    0x4(%eax),%eax
  8026f1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f9:	8b 40 04             	mov    0x4(%eax),%eax
  8026fc:	85 c0                	test   %eax,%eax
  8026fe:	74 0f                	je     80270f <alloc_block_BF+0x10d>
  802700:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802703:	8b 40 04             	mov    0x4(%eax),%eax
  802706:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802709:	8b 12                	mov    (%edx),%edx
  80270b:	89 10                	mov    %edx,(%eax)
  80270d:	eb 0a                	jmp    802719 <alloc_block_BF+0x117>
  80270f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	a3 48 41 80 00       	mov    %eax,0x804148
  802719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802722:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802725:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272c:	a1 54 41 80 00       	mov    0x804154,%eax
  802731:	48                   	dec    %eax
  802732:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 50 08             	mov    0x8(%eax),%edx
  80273d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802740:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802746:	8b 55 08             	mov    0x8(%ebp),%edx
  802749:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	8b 40 0c             	mov    0xc(%eax),%eax
  802752:	2b 45 08             	sub    0x8(%ebp),%eax
  802755:	89 c2                	mov    %eax,%edx
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 50 08             	mov    0x8(%eax),%edx
  802763:	8b 45 08             	mov    0x8(%ebp),%eax
  802766:	01 c2                	add    %eax,%edx
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  80276e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802771:	e9 e5 00 00 00       	jmp    80285b <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 50 0c             	mov    0xc(%eax),%edx
  80277c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277f:	39 c2                	cmp    %eax,%edx
  802781:	0f 85 99 00 00 00    	jne    802820 <alloc_block_BF+0x21e>
  802787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80278d:	0f 85 8d 00 00 00    	jne    802820 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802793:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802796:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802799:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279d:	75 17                	jne    8027b6 <alloc_block_BF+0x1b4>
  80279f:	83 ec 04             	sub    $0x4,%esp
  8027a2:	68 9b 3c 80 00       	push   $0x803c9b
  8027a7:	68 f7 00 00 00       	push   $0xf7
  8027ac:	68 f3 3b 80 00       	push   $0x803bf3
  8027b1:	e8 18 db ff ff       	call   8002ce <_panic>
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	85 c0                	test   %eax,%eax
  8027bd:	74 10                	je     8027cf <alloc_block_BF+0x1cd>
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 00                	mov    (%eax),%eax
  8027c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c7:	8b 52 04             	mov    0x4(%edx),%edx
  8027ca:	89 50 04             	mov    %edx,0x4(%eax)
  8027cd:	eb 0b                	jmp    8027da <alloc_block_BF+0x1d8>
  8027cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d2:	8b 40 04             	mov    0x4(%eax),%eax
  8027d5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 40 04             	mov    0x4(%eax),%eax
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	74 0f                	je     8027f3 <alloc_block_BF+0x1f1>
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ed:	8b 12                	mov    (%edx),%edx
  8027ef:	89 10                	mov    %edx,(%eax)
  8027f1:	eb 0a                	jmp    8027fd <alloc_block_BF+0x1fb>
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 00                	mov    (%eax),%eax
  8027f8:	a3 38 41 80 00       	mov    %eax,0x804138
  8027fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802800:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802810:	a1 44 41 80 00       	mov    0x804144,%eax
  802815:	48                   	dec    %eax
  802816:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  80281b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281e:	eb 3b                	jmp    80285b <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802820:	a1 40 41 80 00       	mov    0x804140,%eax
  802825:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282c:	74 07                	je     802835 <alloc_block_BF+0x233>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	eb 05                	jmp    80283a <alloc_block_BF+0x238>
  802835:	b8 00 00 00 00       	mov    $0x0,%eax
  80283a:	a3 40 41 80 00       	mov    %eax,0x804140
  80283f:	a1 40 41 80 00       	mov    0x804140,%eax
  802844:	85 c0                	test   %eax,%eax
  802846:	0f 85 44 fe ff ff    	jne    802690 <alloc_block_BF+0x8e>
  80284c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802850:	0f 85 3a fe ff ff    	jne    802690 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802856:	b8 00 00 00 00       	mov    $0x0,%eax
  80285b:	c9                   	leave  
  80285c:	c3                   	ret    

0080285d <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80285d:	55                   	push   %ebp
  80285e:	89 e5                	mov    %esp,%ebp
  802860:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802863:	83 ec 04             	sub    $0x4,%esp
  802866:	68 bc 3c 80 00       	push   $0x803cbc
  80286b:	68 04 01 00 00       	push   $0x104
  802870:	68 f3 3b 80 00       	push   $0x803bf3
  802875:	e8 54 da ff ff       	call   8002ce <_panic>

0080287a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
  80287d:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802880:	a1 38 41 80 00       	mov    0x804138,%eax
  802885:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802888:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80288d:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802890:	a1 38 41 80 00       	mov    0x804138,%eax
  802895:	85 c0                	test   %eax,%eax
  802897:	75 68                	jne    802901 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802899:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80289d:	75 17                	jne    8028b6 <insert_sorted_with_merge_freeList+0x3c>
  80289f:	83 ec 04             	sub    $0x4,%esp
  8028a2:	68 d0 3b 80 00       	push   $0x803bd0
  8028a7:	68 14 01 00 00       	push   $0x114
  8028ac:	68 f3 3b 80 00       	push   $0x803bf3
  8028b1:	e8 18 da ff ff       	call   8002ce <_panic>
  8028b6:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	89 10                	mov    %edx,(%eax)
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	74 0d                	je     8028d7 <insert_sorted_with_merge_freeList+0x5d>
  8028ca:	a1 38 41 80 00       	mov    0x804138,%eax
  8028cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8028d2:	89 50 04             	mov    %edx,0x4(%eax)
  8028d5:	eb 08                	jmp    8028df <insert_sorted_with_merge_freeList+0x65>
  8028d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028da:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028df:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e2:	a3 38 41 80 00       	mov    %eax,0x804138
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028f1:	a1 44 41 80 00       	mov    0x804144,%eax
  8028f6:	40                   	inc    %eax
  8028f7:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8028fc:	e9 d2 06 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  802901:	8b 45 08             	mov    0x8(%ebp),%eax
  802904:	8b 50 08             	mov    0x8(%eax),%edx
  802907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290a:	8b 40 08             	mov    0x8(%eax),%eax
  80290d:	39 c2                	cmp    %eax,%edx
  80290f:	0f 83 22 01 00 00    	jae    802a37 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	8b 50 08             	mov    0x8(%eax),%edx
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	8b 40 0c             	mov    0xc(%eax),%eax
  802921:	01 c2                	add    %eax,%edx
  802923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802926:	8b 40 08             	mov    0x8(%eax),%eax
  802929:	39 c2                	cmp    %eax,%edx
  80292b:	0f 85 9e 00 00 00    	jne    8029cf <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802931:	8b 45 08             	mov    0x8(%ebp),%eax
  802934:	8b 50 08             	mov    0x8(%eax),%edx
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  80293d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802940:	8b 50 0c             	mov    0xc(%eax),%edx
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	8b 40 0c             	mov    0xc(%eax),%eax
  802949:	01 c2                	add    %eax,%edx
  80294b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294e:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	8b 50 08             	mov    0x8(%eax),%edx
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802967:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80296b:	75 17                	jne    802984 <insert_sorted_with_merge_freeList+0x10a>
  80296d:	83 ec 04             	sub    $0x4,%esp
  802970:	68 d0 3b 80 00       	push   $0x803bd0
  802975:	68 21 01 00 00       	push   $0x121
  80297a:	68 f3 3b 80 00       	push   $0x803bf3
  80297f:	e8 4a d9 ff ff       	call   8002ce <_panic>
  802984:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	89 10                	mov    %edx,(%eax)
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	8b 00                	mov    (%eax),%eax
  802994:	85 c0                	test   %eax,%eax
  802996:	74 0d                	je     8029a5 <insert_sorted_with_merge_freeList+0x12b>
  802998:	a1 48 41 80 00       	mov    0x804148,%eax
  80299d:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a0:	89 50 04             	mov    %edx,0x4(%eax)
  8029a3:	eb 08                	jmp    8029ad <insert_sorted_with_merge_freeList+0x133>
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	a3 48 41 80 00       	mov    %eax,0x804148
  8029b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029bf:	a1 54 41 80 00       	mov    0x804154,%eax
  8029c4:	40                   	inc    %eax
  8029c5:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  8029ca:	e9 04 06 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8029cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d3:	75 17                	jne    8029ec <insert_sorted_with_merge_freeList+0x172>
  8029d5:	83 ec 04             	sub    $0x4,%esp
  8029d8:	68 d0 3b 80 00       	push   $0x803bd0
  8029dd:	68 26 01 00 00       	push   $0x126
  8029e2:	68 f3 3b 80 00       	push   $0x803bf3
  8029e7:	e8 e2 d8 ff ff       	call   8002ce <_panic>
  8029ec:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f5:	89 10                	mov    %edx,(%eax)
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	8b 00                	mov    (%eax),%eax
  8029fc:	85 c0                	test   %eax,%eax
  8029fe:	74 0d                	je     802a0d <insert_sorted_with_merge_freeList+0x193>
  802a00:	a1 38 41 80 00       	mov    0x804138,%eax
  802a05:	8b 55 08             	mov    0x8(%ebp),%edx
  802a08:	89 50 04             	mov    %edx,0x4(%eax)
  802a0b:	eb 08                	jmp    802a15 <insert_sorted_with_merge_freeList+0x19b>
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a15:	8b 45 08             	mov    0x8(%ebp),%eax
  802a18:	a3 38 41 80 00       	mov    %eax,0x804138
  802a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a27:	a1 44 41 80 00       	mov    0x804144,%eax
  802a2c:	40                   	inc    %eax
  802a2d:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802a32:	e9 9c 05 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	8b 50 08             	mov    0x8(%eax),%edx
  802a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a40:	8b 40 08             	mov    0x8(%eax),%eax
  802a43:	39 c2                	cmp    %eax,%edx
  802a45:	0f 86 16 01 00 00    	jbe    802b61 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4e:	8b 50 08             	mov    0x8(%eax),%edx
  802a51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a54:	8b 40 0c             	mov    0xc(%eax),%eax
  802a57:	01 c2                	add    %eax,%edx
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	8b 40 08             	mov    0x8(%eax),%eax
  802a5f:	39 c2                	cmp    %eax,%edx
  802a61:	0f 85 92 00 00 00    	jne    802af9 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802a67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6a:	8b 50 0c             	mov    0xc(%eax),%edx
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	8b 40 0c             	mov    0xc(%eax),%eax
  802a73:	01 c2                	add    %eax,%edx
  802a75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a78:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a85:	8b 45 08             	mov    0x8(%ebp),%eax
  802a88:	8b 50 08             	mov    0x8(%eax),%edx
  802a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8e:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a95:	75 17                	jne    802aae <insert_sorted_with_merge_freeList+0x234>
  802a97:	83 ec 04             	sub    $0x4,%esp
  802a9a:	68 d0 3b 80 00       	push   $0x803bd0
  802a9f:	68 31 01 00 00       	push   $0x131
  802aa4:	68 f3 3b 80 00       	push   $0x803bf3
  802aa9:	e8 20 d8 ff ff       	call   8002ce <_panic>
  802aae:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	89 10                	mov    %edx,(%eax)
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 0d                	je     802acf <insert_sorted_with_merge_freeList+0x255>
  802ac2:	a1 48 41 80 00       	mov    0x804148,%eax
  802ac7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aca:	89 50 04             	mov    %edx,0x4(%eax)
  802acd:	eb 08                	jmp    802ad7 <insert_sorted_with_merge_freeList+0x25d>
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	a3 48 41 80 00       	mov    %eax,0x804148
  802adf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae9:	a1 54 41 80 00       	mov    0x804154,%eax
  802aee:	40                   	inc    %eax
  802aef:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802af4:	e9 da 04 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802af9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802afd:	75 17                	jne    802b16 <insert_sorted_with_merge_freeList+0x29c>
  802aff:	83 ec 04             	sub    $0x4,%esp
  802b02:	68 78 3c 80 00       	push   $0x803c78
  802b07:	68 37 01 00 00       	push   $0x137
  802b0c:	68 f3 3b 80 00       	push   $0x803bf3
  802b11:	e8 b8 d7 ff ff       	call   8002ce <_panic>
  802b16:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	89 50 04             	mov    %edx,0x4(%eax)
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	8b 40 04             	mov    0x4(%eax),%eax
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	74 0c                	je     802b38 <insert_sorted_with_merge_freeList+0x2be>
  802b2c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b31:	8b 55 08             	mov    0x8(%ebp),%edx
  802b34:	89 10                	mov    %edx,(%eax)
  802b36:	eb 08                	jmp    802b40 <insert_sorted_with_merge_freeList+0x2c6>
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	a3 38 41 80 00       	mov    %eax,0x804138
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b51:	a1 44 41 80 00       	mov    0x804144,%eax
  802b56:	40                   	inc    %eax
  802b57:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b5c:	e9 72 04 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802b61:	a1 38 41 80 00       	mov    0x804138,%eax
  802b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b69:	e9 35 04 00 00       	jmp    802fa3 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b71:	8b 00                	mov    (%eax),%eax
  802b73:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	8b 50 08             	mov    0x8(%eax),%edx
  802b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7f:	8b 40 08             	mov    0x8(%eax),%eax
  802b82:	39 c2                	cmp    %eax,%edx
  802b84:	0f 86 11 04 00 00    	jbe    802f9b <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 50 08             	mov    0x8(%eax),%edx
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	8b 40 0c             	mov    0xc(%eax),%eax
  802b96:	01 c2                	add    %eax,%edx
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	8b 40 08             	mov    0x8(%eax),%eax
  802b9e:	39 c2                	cmp    %eax,%edx
  802ba0:	0f 83 8b 00 00 00    	jae    802c31 <insert_sorted_with_merge_freeList+0x3b7>
  802ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba9:	8b 50 08             	mov    0x8(%eax),%edx
  802bac:	8b 45 08             	mov    0x8(%ebp),%eax
  802baf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb2:	01 c2                	add    %eax,%edx
  802bb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb7:	8b 40 08             	mov    0x8(%eax),%eax
  802bba:	39 c2                	cmp    %eax,%edx
  802bbc:	73 73                	jae    802c31 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802bbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bc2:	74 06                	je     802bca <insert_sorted_with_merge_freeList+0x350>
  802bc4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc8:	75 17                	jne    802be1 <insert_sorted_with_merge_freeList+0x367>
  802bca:	83 ec 04             	sub    $0x4,%esp
  802bcd:	68 44 3c 80 00       	push   $0x803c44
  802bd2:	68 48 01 00 00       	push   $0x148
  802bd7:	68 f3 3b 80 00       	push   $0x803bf3
  802bdc:	e8 ed d6 ff ff       	call   8002ce <_panic>
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	8b 10                	mov    (%eax),%edx
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	89 10                	mov    %edx,(%eax)
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	8b 00                	mov    (%eax),%eax
  802bf0:	85 c0                	test   %eax,%eax
  802bf2:	74 0b                	je     802bff <insert_sorted_with_merge_freeList+0x385>
  802bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf7:	8b 00                	mov    (%eax),%eax
  802bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bfc:	89 50 04             	mov    %edx,0x4(%eax)
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 55 08             	mov    0x8(%ebp),%edx
  802c05:	89 10                	mov    %edx,(%eax)
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c0d:	89 50 04             	mov    %edx,0x4(%eax)
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	85 c0                	test   %eax,%eax
  802c17:	75 08                	jne    802c21 <insert_sorted_with_merge_freeList+0x3a7>
  802c19:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c21:	a1 44 41 80 00       	mov    0x804144,%eax
  802c26:	40                   	inc    %eax
  802c27:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802c2c:	e9 a2 03 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	8b 50 08             	mov    0x8(%eax),%edx
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3d:	01 c2                	add    %eax,%edx
  802c3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c42:	8b 40 08             	mov    0x8(%eax),%eax
  802c45:	39 c2                	cmp    %eax,%edx
  802c47:	0f 83 ae 00 00 00    	jae    802cfb <insert_sorted_with_merge_freeList+0x481>
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	8b 50 08             	mov    0x8(%eax),%edx
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 48 08             	mov    0x8(%eax),%ecx
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5f:	01 c8                	add    %ecx,%eax
  802c61:	39 c2                	cmp    %eax,%edx
  802c63:	0f 85 92 00 00 00    	jne    802cfb <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 50 0c             	mov    0xc(%eax),%edx
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	8b 40 0c             	mov    0xc(%eax),%eax
  802c75:	01 c2                	add    %eax,%edx
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c80:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	8b 50 08             	mov    0x8(%eax),%edx
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c97:	75 17                	jne    802cb0 <insert_sorted_with_merge_freeList+0x436>
  802c99:	83 ec 04             	sub    $0x4,%esp
  802c9c:	68 d0 3b 80 00       	push   $0x803bd0
  802ca1:	68 51 01 00 00       	push   $0x151
  802ca6:	68 f3 3b 80 00       	push   $0x803bf3
  802cab:	e8 1e d6 ff ff       	call   8002ce <_panic>
  802cb0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb9:	89 10                	mov    %edx,(%eax)
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	8b 00                	mov    (%eax),%eax
  802cc0:	85 c0                	test   %eax,%eax
  802cc2:	74 0d                	je     802cd1 <insert_sorted_with_merge_freeList+0x457>
  802cc4:	a1 48 41 80 00       	mov    0x804148,%eax
  802cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccc:	89 50 04             	mov    %edx,0x4(%eax)
  802ccf:	eb 08                	jmp    802cd9 <insert_sorted_with_merge_freeList+0x45f>
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	a3 48 41 80 00       	mov    %eax,0x804148
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ceb:	a1 54 41 80 00       	mov    0x804154,%eax
  802cf0:	40                   	inc    %eax
  802cf1:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802cf6:	e9 d8 02 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	8b 50 08             	mov    0x8(%eax),%edx
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	8b 40 0c             	mov    0xc(%eax),%eax
  802d07:	01 c2                	add    %eax,%edx
  802d09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0c:	8b 40 08             	mov    0x8(%eax),%eax
  802d0f:	39 c2                	cmp    %eax,%edx
  802d11:	0f 85 ba 00 00 00    	jne    802dd1 <insert_sorted_with_merge_freeList+0x557>
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	8b 50 08             	mov    0x8(%eax),%edx
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	8b 48 08             	mov    0x8(%eax),%ecx
  802d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d26:	8b 40 0c             	mov    0xc(%eax),%eax
  802d29:	01 c8                	add    %ecx,%eax
  802d2b:	39 c2                	cmp    %eax,%edx
  802d2d:	0f 86 9e 00 00 00    	jbe    802dd1 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802d33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d36:	8b 50 0c             	mov    0xc(%eax),%edx
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3f:	01 c2                	add    %eax,%edx
  802d41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d44:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802d47:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4a:	8b 50 08             	mov    0x8(%eax),%edx
  802d4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d50:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d60:	8b 50 08             	mov    0x8(%eax),%edx
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6d:	75 17                	jne    802d86 <insert_sorted_with_merge_freeList+0x50c>
  802d6f:	83 ec 04             	sub    $0x4,%esp
  802d72:	68 d0 3b 80 00       	push   $0x803bd0
  802d77:	68 5b 01 00 00       	push   $0x15b
  802d7c:	68 f3 3b 80 00       	push   $0x803bf3
  802d81:	e8 48 d5 ff ff       	call   8002ce <_panic>
  802d86:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	89 10                	mov    %edx,(%eax)
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	74 0d                	je     802da7 <insert_sorted_with_merge_freeList+0x52d>
  802d9a:	a1 48 41 80 00       	mov    0x804148,%eax
  802d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802da2:	89 50 04             	mov    %edx,0x4(%eax)
  802da5:	eb 08                	jmp    802daf <insert_sorted_with_merge_freeList+0x535>
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	a3 48 41 80 00       	mov    %eax,0x804148
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc1:	a1 54 41 80 00       	mov    0x804154,%eax
  802dc6:	40                   	inc    %eax
  802dc7:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802dcc:	e9 02 02 00 00       	jmp    802fd3 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	8b 50 08             	mov    0x8(%eax),%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddd:	01 c2                	add    %eax,%edx
  802ddf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de2:	8b 40 08             	mov    0x8(%eax),%eax
  802de5:	39 c2                	cmp    %eax,%edx
  802de7:	0f 85 ae 01 00 00    	jne    802f9b <insert_sorted_with_merge_freeList+0x721>
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	8b 50 08             	mov    0x8(%eax),%edx
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	8b 48 08             	mov    0x8(%eax),%ecx
  802df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dff:	01 c8                	add    %ecx,%eax
  802e01:	39 c2                	cmp    %eax,%edx
  802e03:	0f 85 92 01 00 00    	jne    802f9b <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	8b 40 0c             	mov    0xc(%eax),%eax
  802e15:	01 c2                	add    %eax,%edx
  802e17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e1d:	01 c2                	add    %eax,%edx
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	8b 50 08             	mov    0x8(%eax),%edx
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802e3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e48:	8b 50 08             	mov    0x8(%eax),%edx
  802e4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4e:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802e51:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e55:	75 17                	jne    802e6e <insert_sorted_with_merge_freeList+0x5f4>
  802e57:	83 ec 04             	sub    $0x4,%esp
  802e5a:	68 9b 3c 80 00       	push   $0x803c9b
  802e5f:	68 63 01 00 00       	push   $0x163
  802e64:	68 f3 3b 80 00       	push   $0x803bf3
  802e69:	e8 60 d4 ff ff       	call   8002ce <_panic>
  802e6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e71:	8b 00                	mov    (%eax),%eax
  802e73:	85 c0                	test   %eax,%eax
  802e75:	74 10                	je     802e87 <insert_sorted_with_merge_freeList+0x60d>
  802e77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e7f:	8b 52 04             	mov    0x4(%edx),%edx
  802e82:	89 50 04             	mov    %edx,0x4(%eax)
  802e85:	eb 0b                	jmp    802e92 <insert_sorted_with_merge_freeList+0x618>
  802e87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8a:	8b 40 04             	mov    0x4(%eax),%eax
  802e8d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e95:	8b 40 04             	mov    0x4(%eax),%eax
  802e98:	85 c0                	test   %eax,%eax
  802e9a:	74 0f                	je     802eab <insert_sorted_with_merge_freeList+0x631>
  802e9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ea2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ea5:	8b 12                	mov    (%edx),%edx
  802ea7:	89 10                	mov    %edx,(%eax)
  802ea9:	eb 0a                	jmp    802eb5 <insert_sorted_with_merge_freeList+0x63b>
  802eab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eae:	8b 00                	mov    (%eax),%eax
  802eb0:	a3 38 41 80 00       	mov    %eax,0x804138
  802eb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec8:	a1 44 41 80 00       	mov    0x804144,%eax
  802ecd:	48                   	dec    %eax
  802ece:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802ed3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ed7:	75 17                	jne    802ef0 <insert_sorted_with_merge_freeList+0x676>
  802ed9:	83 ec 04             	sub    $0x4,%esp
  802edc:	68 d0 3b 80 00       	push   $0x803bd0
  802ee1:	68 64 01 00 00       	push   $0x164
  802ee6:	68 f3 3b 80 00       	push   $0x803bf3
  802eeb:	e8 de d3 ff ff       	call   8002ce <_panic>
  802ef0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef9:	89 10                	mov    %edx,(%eax)
  802efb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efe:	8b 00                	mov    (%eax),%eax
  802f00:	85 c0                	test   %eax,%eax
  802f02:	74 0d                	je     802f11 <insert_sorted_with_merge_freeList+0x697>
  802f04:	a1 48 41 80 00       	mov    0x804148,%eax
  802f09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f0c:	89 50 04             	mov    %edx,0x4(%eax)
  802f0f:	eb 08                	jmp    802f19 <insert_sorted_with_merge_freeList+0x69f>
  802f11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f14:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f19:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f1c:	a3 48 41 80 00       	mov    %eax,0x804148
  802f21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2b:	a1 54 41 80 00       	mov    0x804154,%eax
  802f30:	40                   	inc    %eax
  802f31:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f3a:	75 17                	jne    802f53 <insert_sorted_with_merge_freeList+0x6d9>
  802f3c:	83 ec 04             	sub    $0x4,%esp
  802f3f:	68 d0 3b 80 00       	push   $0x803bd0
  802f44:	68 65 01 00 00       	push   $0x165
  802f49:	68 f3 3b 80 00       	push   $0x803bf3
  802f4e:	e8 7b d3 ff ff       	call   8002ce <_panic>
  802f53:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	89 10                	mov    %edx,(%eax)
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	8b 00                	mov    (%eax),%eax
  802f63:	85 c0                	test   %eax,%eax
  802f65:	74 0d                	je     802f74 <insert_sorted_with_merge_freeList+0x6fa>
  802f67:	a1 48 41 80 00       	mov    0x804148,%eax
  802f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6f:	89 50 04             	mov    %edx,0x4(%eax)
  802f72:	eb 08                	jmp    802f7c <insert_sorted_with_merge_freeList+0x702>
  802f74:	8b 45 08             	mov    0x8(%ebp),%eax
  802f77:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	a3 48 41 80 00       	mov    %eax,0x804148
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8e:	a1 54 41 80 00       	mov    0x804154,%eax
  802f93:	40                   	inc    %eax
  802f94:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802f99:	eb 38                	jmp    802fd3 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f9b:	a1 40 41 80 00       	mov    0x804140,%eax
  802fa0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa7:	74 07                	je     802fb0 <insert_sorted_with_merge_freeList+0x736>
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	8b 00                	mov    (%eax),%eax
  802fae:	eb 05                	jmp    802fb5 <insert_sorted_with_merge_freeList+0x73b>
  802fb0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fb5:	a3 40 41 80 00       	mov    %eax,0x804140
  802fba:	a1 40 41 80 00       	mov    0x804140,%eax
  802fbf:	85 c0                	test   %eax,%eax
  802fc1:	0f 85 a7 fb ff ff    	jne    802b6e <insert_sorted_with_merge_freeList+0x2f4>
  802fc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fcb:	0f 85 9d fb ff ff    	jne    802b6e <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802fd1:	eb 00                	jmp    802fd3 <insert_sorted_with_merge_freeList+0x759>
  802fd3:	90                   	nop
  802fd4:	c9                   	leave  
  802fd5:	c3                   	ret    

00802fd6 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802fd6:	55                   	push   %ebp
  802fd7:	89 e5                	mov    %esp,%ebp
  802fd9:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802fdc:	8b 55 08             	mov    0x8(%ebp),%edx
  802fdf:	89 d0                	mov    %edx,%eax
  802fe1:	c1 e0 02             	shl    $0x2,%eax
  802fe4:	01 d0                	add    %edx,%eax
  802fe6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fed:	01 d0                	add    %edx,%eax
  802fef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ff6:	01 d0                	add    %edx,%eax
  802ff8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fff:	01 d0                	add    %edx,%eax
  803001:	c1 e0 04             	shl    $0x4,%eax
  803004:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803007:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80300e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803011:	83 ec 0c             	sub    $0xc,%esp
  803014:	50                   	push   %eax
  803015:	e8 ee eb ff ff       	call   801c08 <sys_get_virtual_time>
  80301a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80301d:	eb 41                	jmp    803060 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80301f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803022:	83 ec 0c             	sub    $0xc,%esp
  803025:	50                   	push   %eax
  803026:	e8 dd eb ff ff       	call   801c08 <sys_get_virtual_time>
  80302b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80302e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803031:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803034:	29 c2                	sub    %eax,%edx
  803036:	89 d0                	mov    %edx,%eax
  803038:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80303b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80303e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803041:	89 d1                	mov    %edx,%ecx
  803043:	29 c1                	sub    %eax,%ecx
  803045:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803048:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80304b:	39 c2                	cmp    %eax,%edx
  80304d:	0f 97 c0             	seta   %al
  803050:	0f b6 c0             	movzbl %al,%eax
  803053:	29 c1                	sub    %eax,%ecx
  803055:	89 c8                	mov    %ecx,%eax
  803057:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80305a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80305d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803066:	72 b7                	jb     80301f <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803068:	90                   	nop
  803069:	c9                   	leave  
  80306a:	c3                   	ret    

0080306b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80306b:	55                   	push   %ebp
  80306c:	89 e5                	mov    %esp,%ebp
  80306e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803071:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803078:	eb 03                	jmp    80307d <busy_wait+0x12>
  80307a:	ff 45 fc             	incl   -0x4(%ebp)
  80307d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803080:	3b 45 08             	cmp    0x8(%ebp),%eax
  803083:	72 f5                	jb     80307a <busy_wait+0xf>
	return i;
  803085:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803088:	c9                   	leave  
  803089:	c3                   	ret    
  80308a:	66 90                	xchg   %ax,%ax

0080308c <__udivdi3>:
  80308c:	55                   	push   %ebp
  80308d:	57                   	push   %edi
  80308e:	56                   	push   %esi
  80308f:	53                   	push   %ebx
  803090:	83 ec 1c             	sub    $0x1c,%esp
  803093:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803097:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80309b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80309f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030a3:	89 ca                	mov    %ecx,%edx
  8030a5:	89 f8                	mov    %edi,%eax
  8030a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030ab:	85 f6                	test   %esi,%esi
  8030ad:	75 2d                	jne    8030dc <__udivdi3+0x50>
  8030af:	39 cf                	cmp    %ecx,%edi
  8030b1:	77 65                	ja     803118 <__udivdi3+0x8c>
  8030b3:	89 fd                	mov    %edi,%ebp
  8030b5:	85 ff                	test   %edi,%edi
  8030b7:	75 0b                	jne    8030c4 <__udivdi3+0x38>
  8030b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8030be:	31 d2                	xor    %edx,%edx
  8030c0:	f7 f7                	div    %edi
  8030c2:	89 c5                	mov    %eax,%ebp
  8030c4:	31 d2                	xor    %edx,%edx
  8030c6:	89 c8                	mov    %ecx,%eax
  8030c8:	f7 f5                	div    %ebp
  8030ca:	89 c1                	mov    %eax,%ecx
  8030cc:	89 d8                	mov    %ebx,%eax
  8030ce:	f7 f5                	div    %ebp
  8030d0:	89 cf                	mov    %ecx,%edi
  8030d2:	89 fa                	mov    %edi,%edx
  8030d4:	83 c4 1c             	add    $0x1c,%esp
  8030d7:	5b                   	pop    %ebx
  8030d8:	5e                   	pop    %esi
  8030d9:	5f                   	pop    %edi
  8030da:	5d                   	pop    %ebp
  8030db:	c3                   	ret    
  8030dc:	39 ce                	cmp    %ecx,%esi
  8030de:	77 28                	ja     803108 <__udivdi3+0x7c>
  8030e0:	0f bd fe             	bsr    %esi,%edi
  8030e3:	83 f7 1f             	xor    $0x1f,%edi
  8030e6:	75 40                	jne    803128 <__udivdi3+0x9c>
  8030e8:	39 ce                	cmp    %ecx,%esi
  8030ea:	72 0a                	jb     8030f6 <__udivdi3+0x6a>
  8030ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030f0:	0f 87 9e 00 00 00    	ja     803194 <__udivdi3+0x108>
  8030f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030fb:	89 fa                	mov    %edi,%edx
  8030fd:	83 c4 1c             	add    $0x1c,%esp
  803100:	5b                   	pop    %ebx
  803101:	5e                   	pop    %esi
  803102:	5f                   	pop    %edi
  803103:	5d                   	pop    %ebp
  803104:	c3                   	ret    
  803105:	8d 76 00             	lea    0x0(%esi),%esi
  803108:	31 ff                	xor    %edi,%edi
  80310a:	31 c0                	xor    %eax,%eax
  80310c:	89 fa                	mov    %edi,%edx
  80310e:	83 c4 1c             	add    $0x1c,%esp
  803111:	5b                   	pop    %ebx
  803112:	5e                   	pop    %esi
  803113:	5f                   	pop    %edi
  803114:	5d                   	pop    %ebp
  803115:	c3                   	ret    
  803116:	66 90                	xchg   %ax,%ax
  803118:	89 d8                	mov    %ebx,%eax
  80311a:	f7 f7                	div    %edi
  80311c:	31 ff                	xor    %edi,%edi
  80311e:	89 fa                	mov    %edi,%edx
  803120:	83 c4 1c             	add    $0x1c,%esp
  803123:	5b                   	pop    %ebx
  803124:	5e                   	pop    %esi
  803125:	5f                   	pop    %edi
  803126:	5d                   	pop    %ebp
  803127:	c3                   	ret    
  803128:	bd 20 00 00 00       	mov    $0x20,%ebp
  80312d:	89 eb                	mov    %ebp,%ebx
  80312f:	29 fb                	sub    %edi,%ebx
  803131:	89 f9                	mov    %edi,%ecx
  803133:	d3 e6                	shl    %cl,%esi
  803135:	89 c5                	mov    %eax,%ebp
  803137:	88 d9                	mov    %bl,%cl
  803139:	d3 ed                	shr    %cl,%ebp
  80313b:	89 e9                	mov    %ebp,%ecx
  80313d:	09 f1                	or     %esi,%ecx
  80313f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803143:	89 f9                	mov    %edi,%ecx
  803145:	d3 e0                	shl    %cl,%eax
  803147:	89 c5                	mov    %eax,%ebp
  803149:	89 d6                	mov    %edx,%esi
  80314b:	88 d9                	mov    %bl,%cl
  80314d:	d3 ee                	shr    %cl,%esi
  80314f:	89 f9                	mov    %edi,%ecx
  803151:	d3 e2                	shl    %cl,%edx
  803153:	8b 44 24 08          	mov    0x8(%esp),%eax
  803157:	88 d9                	mov    %bl,%cl
  803159:	d3 e8                	shr    %cl,%eax
  80315b:	09 c2                	or     %eax,%edx
  80315d:	89 d0                	mov    %edx,%eax
  80315f:	89 f2                	mov    %esi,%edx
  803161:	f7 74 24 0c          	divl   0xc(%esp)
  803165:	89 d6                	mov    %edx,%esi
  803167:	89 c3                	mov    %eax,%ebx
  803169:	f7 e5                	mul    %ebp
  80316b:	39 d6                	cmp    %edx,%esi
  80316d:	72 19                	jb     803188 <__udivdi3+0xfc>
  80316f:	74 0b                	je     80317c <__udivdi3+0xf0>
  803171:	89 d8                	mov    %ebx,%eax
  803173:	31 ff                	xor    %edi,%edi
  803175:	e9 58 ff ff ff       	jmp    8030d2 <__udivdi3+0x46>
  80317a:	66 90                	xchg   %ax,%ax
  80317c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803180:	89 f9                	mov    %edi,%ecx
  803182:	d3 e2                	shl    %cl,%edx
  803184:	39 c2                	cmp    %eax,%edx
  803186:	73 e9                	jae    803171 <__udivdi3+0xe5>
  803188:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80318b:	31 ff                	xor    %edi,%edi
  80318d:	e9 40 ff ff ff       	jmp    8030d2 <__udivdi3+0x46>
  803192:	66 90                	xchg   %ax,%ax
  803194:	31 c0                	xor    %eax,%eax
  803196:	e9 37 ff ff ff       	jmp    8030d2 <__udivdi3+0x46>
  80319b:	90                   	nop

0080319c <__umoddi3>:
  80319c:	55                   	push   %ebp
  80319d:	57                   	push   %edi
  80319e:	56                   	push   %esi
  80319f:	53                   	push   %ebx
  8031a0:	83 ec 1c             	sub    $0x1c,%esp
  8031a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031bb:	89 f3                	mov    %esi,%ebx
  8031bd:	89 fa                	mov    %edi,%edx
  8031bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031c3:	89 34 24             	mov    %esi,(%esp)
  8031c6:	85 c0                	test   %eax,%eax
  8031c8:	75 1a                	jne    8031e4 <__umoddi3+0x48>
  8031ca:	39 f7                	cmp    %esi,%edi
  8031cc:	0f 86 a2 00 00 00    	jbe    803274 <__umoddi3+0xd8>
  8031d2:	89 c8                	mov    %ecx,%eax
  8031d4:	89 f2                	mov    %esi,%edx
  8031d6:	f7 f7                	div    %edi
  8031d8:	89 d0                	mov    %edx,%eax
  8031da:	31 d2                	xor    %edx,%edx
  8031dc:	83 c4 1c             	add    $0x1c,%esp
  8031df:	5b                   	pop    %ebx
  8031e0:	5e                   	pop    %esi
  8031e1:	5f                   	pop    %edi
  8031e2:	5d                   	pop    %ebp
  8031e3:	c3                   	ret    
  8031e4:	39 f0                	cmp    %esi,%eax
  8031e6:	0f 87 ac 00 00 00    	ja     803298 <__umoddi3+0xfc>
  8031ec:	0f bd e8             	bsr    %eax,%ebp
  8031ef:	83 f5 1f             	xor    $0x1f,%ebp
  8031f2:	0f 84 ac 00 00 00    	je     8032a4 <__umoddi3+0x108>
  8031f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8031fd:	29 ef                	sub    %ebp,%edi
  8031ff:	89 fe                	mov    %edi,%esi
  803201:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803205:	89 e9                	mov    %ebp,%ecx
  803207:	d3 e0                	shl    %cl,%eax
  803209:	89 d7                	mov    %edx,%edi
  80320b:	89 f1                	mov    %esi,%ecx
  80320d:	d3 ef                	shr    %cl,%edi
  80320f:	09 c7                	or     %eax,%edi
  803211:	89 e9                	mov    %ebp,%ecx
  803213:	d3 e2                	shl    %cl,%edx
  803215:	89 14 24             	mov    %edx,(%esp)
  803218:	89 d8                	mov    %ebx,%eax
  80321a:	d3 e0                	shl    %cl,%eax
  80321c:	89 c2                	mov    %eax,%edx
  80321e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803222:	d3 e0                	shl    %cl,%eax
  803224:	89 44 24 04          	mov    %eax,0x4(%esp)
  803228:	8b 44 24 08          	mov    0x8(%esp),%eax
  80322c:	89 f1                	mov    %esi,%ecx
  80322e:	d3 e8                	shr    %cl,%eax
  803230:	09 d0                	or     %edx,%eax
  803232:	d3 eb                	shr    %cl,%ebx
  803234:	89 da                	mov    %ebx,%edx
  803236:	f7 f7                	div    %edi
  803238:	89 d3                	mov    %edx,%ebx
  80323a:	f7 24 24             	mull   (%esp)
  80323d:	89 c6                	mov    %eax,%esi
  80323f:	89 d1                	mov    %edx,%ecx
  803241:	39 d3                	cmp    %edx,%ebx
  803243:	0f 82 87 00 00 00    	jb     8032d0 <__umoddi3+0x134>
  803249:	0f 84 91 00 00 00    	je     8032e0 <__umoddi3+0x144>
  80324f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803253:	29 f2                	sub    %esi,%edx
  803255:	19 cb                	sbb    %ecx,%ebx
  803257:	89 d8                	mov    %ebx,%eax
  803259:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80325d:	d3 e0                	shl    %cl,%eax
  80325f:	89 e9                	mov    %ebp,%ecx
  803261:	d3 ea                	shr    %cl,%edx
  803263:	09 d0                	or     %edx,%eax
  803265:	89 e9                	mov    %ebp,%ecx
  803267:	d3 eb                	shr    %cl,%ebx
  803269:	89 da                	mov    %ebx,%edx
  80326b:	83 c4 1c             	add    $0x1c,%esp
  80326e:	5b                   	pop    %ebx
  80326f:	5e                   	pop    %esi
  803270:	5f                   	pop    %edi
  803271:	5d                   	pop    %ebp
  803272:	c3                   	ret    
  803273:	90                   	nop
  803274:	89 fd                	mov    %edi,%ebp
  803276:	85 ff                	test   %edi,%edi
  803278:	75 0b                	jne    803285 <__umoddi3+0xe9>
  80327a:	b8 01 00 00 00       	mov    $0x1,%eax
  80327f:	31 d2                	xor    %edx,%edx
  803281:	f7 f7                	div    %edi
  803283:	89 c5                	mov    %eax,%ebp
  803285:	89 f0                	mov    %esi,%eax
  803287:	31 d2                	xor    %edx,%edx
  803289:	f7 f5                	div    %ebp
  80328b:	89 c8                	mov    %ecx,%eax
  80328d:	f7 f5                	div    %ebp
  80328f:	89 d0                	mov    %edx,%eax
  803291:	e9 44 ff ff ff       	jmp    8031da <__umoddi3+0x3e>
  803296:	66 90                	xchg   %ax,%ax
  803298:	89 c8                	mov    %ecx,%eax
  80329a:	89 f2                	mov    %esi,%edx
  80329c:	83 c4 1c             	add    $0x1c,%esp
  80329f:	5b                   	pop    %ebx
  8032a0:	5e                   	pop    %esi
  8032a1:	5f                   	pop    %edi
  8032a2:	5d                   	pop    %ebp
  8032a3:	c3                   	ret    
  8032a4:	3b 04 24             	cmp    (%esp),%eax
  8032a7:	72 06                	jb     8032af <__umoddi3+0x113>
  8032a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032ad:	77 0f                	ja     8032be <__umoddi3+0x122>
  8032af:	89 f2                	mov    %esi,%edx
  8032b1:	29 f9                	sub    %edi,%ecx
  8032b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032b7:	89 14 24             	mov    %edx,(%esp)
  8032ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032c2:	8b 14 24             	mov    (%esp),%edx
  8032c5:	83 c4 1c             	add    $0x1c,%esp
  8032c8:	5b                   	pop    %ebx
  8032c9:	5e                   	pop    %esi
  8032ca:	5f                   	pop    %edi
  8032cb:	5d                   	pop    %ebp
  8032cc:	c3                   	ret    
  8032cd:	8d 76 00             	lea    0x0(%esi),%esi
  8032d0:	2b 04 24             	sub    (%esp),%eax
  8032d3:	19 fa                	sbb    %edi,%edx
  8032d5:	89 d1                	mov    %edx,%ecx
  8032d7:	89 c6                	mov    %eax,%esi
  8032d9:	e9 71 ff ff ff       	jmp    80324f <__umoddi3+0xb3>
  8032de:	66 90                	xchg   %ax,%ax
  8032e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032e4:	72 ea                	jb     8032d0 <__umoddi3+0x134>
  8032e6:	89 d9                	mov    %ebx,%ecx
  8032e8:	e9 62 ff ff ff       	jmp    80324f <__umoddi3+0xb3>
