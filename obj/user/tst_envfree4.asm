
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 0d 01 00 00       	call   800143 <libmain>
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
	// Testing scenario 4: Freeing the allocated semaphores
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 00 32 80 00       	push   $0x803200
  80004a:	e8 5f 15 00 00       	call   8015ae <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 2a 18 00 00       	call   80188d <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 c2 18 00 00       	call   80192d <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 10 32 80 00       	push   $0x803210
  800079:	e8 b5 04 00 00       	call   800533 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tsem1", 100,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	6a 64                	push   $0x64
  800091:	68 43 32 80 00       	push   $0x803243
  800096:	e8 64 1a 00 00       	call   801aff <sys_create_env>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8000a7:	e8 71 1a 00 00       	call   801b1d <sys_run_env>
  8000ac:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000af:	90                   	nop
  8000b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	83 f8 01             	cmp    $0x1,%eax
  8000b8:	75 f6                	jne    8000b0 <_main+0x78>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ba:	e8 ce 17 00 00       	call   80188d <sys_calculate_free_frames>
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	50                   	push   %eax
  8000c3:	68 4c 32 80 00       	push   $0x80324c
  8000c8:	e8 66 04 00 00       	call   800533 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d6:	e8 5e 1a 00 00       	call   801b39 <sys_destroy_env>
  8000db:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000de:	e8 aa 17 00 00       	call   80188d <sys_calculate_free_frames>
  8000e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e6:	e8 42 18 00 00       	call   80192d <sys_pf_calculate_allocated_pages>
  8000eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f4:	74 27                	je     80011d <_main+0xe5>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fc:	68 80 32 80 00       	push   $0x803280
  800101:	e8 2d 04 00 00       	call   800533 <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 d0 32 80 00       	push   $0x8032d0
  800111:	6a 1f                	push   $0x1f
  800113:	68 06 33 80 00       	push   $0x803306
  800118:	e8 62 01 00 00       	call   80027f <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	ff 75 e4             	pushl  -0x1c(%ebp)
  800123:	68 1c 33 80 00       	push   $0x80331c
  800128:	e8 06 04 00 00       	call   800533 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 4 for envfree completed successfully.\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 7c 33 80 00       	push   $0x80337c
  800138:	e8 f6 03 00 00       	call   800533 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
	return;
  800140:	90                   	nop
}
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800149:	e8 1f 1a 00 00       	call   801b6d <sys_getenvindex>
  80014e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800154:	89 d0                	mov    %edx,%eax
  800156:	c1 e0 03             	shl    $0x3,%eax
  800159:	01 d0                	add    %edx,%eax
  80015b:	01 c0                	add    %eax,%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800166:	01 d0                	add    %edx,%eax
  800168:	c1 e0 04             	shl    $0x4,%eax
  80016b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800170:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800175:	a1 20 40 80 00       	mov    0x804020,%eax
  80017a:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0f                	je     800193 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	05 5c 05 00 00       	add    $0x55c,%eax
  80018e:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800197:	7e 0a                	jle    8001a3 <libmain+0x60>
		binaryname = argv[0];
  800199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019c:	8b 00                	mov    (%eax),%eax
  80019e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	ff 75 0c             	pushl  0xc(%ebp)
  8001a9:	ff 75 08             	pushl  0x8(%ebp)
  8001ac:	e8 87 fe ff ff       	call   800038 <_main>
  8001b1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b4:	e8 c1 17 00 00       	call   80197a <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	68 e0 33 80 00       	push   $0x8033e0
  8001c1:	e8 6d 03 00 00       	call   800533 <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d9:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001df:	83 ec 04             	sub    $0x4,%esp
  8001e2:	52                   	push   %edx
  8001e3:	50                   	push   %eax
  8001e4:	68 08 34 80 00       	push   $0x803408
  8001e9:	e8 45 03 00 00       	call   800533 <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800207:	a1 20 40 80 00       	mov    0x804020,%eax
  80020c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800212:	51                   	push   %ecx
  800213:	52                   	push   %edx
  800214:	50                   	push   %eax
  800215:	68 30 34 80 00       	push   $0x803430
  80021a:	e8 14 03 00 00       	call   800533 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800222:	a1 20 40 80 00       	mov    0x804020,%eax
  800227:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	50                   	push   %eax
  800231:	68 88 34 80 00       	push   $0x803488
  800236:	e8 f8 02 00 00       	call   800533 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	68 e0 33 80 00       	push   $0x8033e0
  800246:	e8 e8 02 00 00       	call   800533 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024e:	e8 41 17 00 00       	call   801994 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800253:	e8 19 00 00 00       	call   800271 <exit>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	6a 00                	push   $0x0
  800266:	e8 ce 18 00 00       	call   801b39 <sys_destroy_env>
  80026b:	83 c4 10             	add    $0x10,%esp
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <exit>:

void
exit(void)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800277:	e8 23 19 00 00       	call   801b9f <sys_exit_env>
}
  80027c:	90                   	nop
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800285:	8d 45 10             	lea    0x10(%ebp),%eax
  800288:	83 c0 04             	add    $0x4,%eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800293:	85 c0                	test   %eax,%eax
  800295:	74 16                	je     8002ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  800297:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	50                   	push   %eax
  8002a0:	68 9c 34 80 00       	push   $0x80349c
  8002a5:	e8 89 02 00 00       	call   800533 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ad:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	50                   	push   %eax
  8002b9:	68 a1 34 80 00       	push   $0x8034a1
  8002be:	e8 70 02 00 00       	call   800533 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cf:	50                   	push   %eax
  8002d0:	e8 f3 01 00 00       	call   8004c8 <vcprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	6a 00                	push   $0x0
  8002dd:	68 bd 34 80 00       	push   $0x8034bd
  8002e2:	e8 e1 01 00 00       	call   8004c8 <vcprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ea:	e8 82 ff ff ff       	call   800271 <exit>

	// should not return here
	while (1) ;
  8002ef:	eb fe                	jmp    8002ef <_panic+0x70>

008002f1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fc:	8b 50 74             	mov    0x74(%eax),%edx
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	74 14                	je     80031a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	68 c0 34 80 00       	push   $0x8034c0
  80030e:	6a 26                	push   $0x26
  800310:	68 0c 35 80 00       	push   $0x80350c
  800315:	e8 65 ff ff ff       	call   80027f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	e9 c2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800330:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	01 d0                	add    %edx,%eax
  80033c:	8b 00                	mov    (%eax),%eax
  80033e:	85 c0                	test   %eax,%eax
  800340:	75 08                	jne    80034a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800342:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800345:	e9 a2 00 00 00       	jmp    8003ec <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800351:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800358:	eb 69                	jmp    8003c3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035a:	a1 20 40 80 00       	mov    0x804020,%eax
  80035f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800365:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800368:	89 d0                	mov    %edx,%eax
  80036a:	01 c0                	add    %eax,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	c1 e0 03             	shl    $0x3,%eax
  800371:	01 c8                	add    %ecx,%eax
  800373:	8a 40 04             	mov    0x4(%eax),%al
  800376:	84 c0                	test   %al,%al
  800378:	75 46                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037a:	a1 20 40 80 00       	mov    0x804020,%eax
  80037f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800385:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800388:	89 d0                	mov    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	c1 e0 03             	shl    $0x3,%eax
  800391:	01 c8                	add    %ecx,%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800398:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	75 09                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003b7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003be:	eb 12                	jmp    8003d2 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c0:	ff 45 e8             	incl   -0x18(%ebp)
  8003c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c8:	8b 50 74             	mov    0x74(%eax),%edx
  8003cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ce:	39 c2                	cmp    %eax,%edx
  8003d0:	77 88                	ja     80035a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d6:	75 14                	jne    8003ec <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d8:	83 ec 04             	sub    $0x4,%esp
  8003db:	68 18 35 80 00       	push   $0x803518
  8003e0:	6a 3a                	push   $0x3a
  8003e2:	68 0c 35 80 00       	push   $0x80350c
  8003e7:	e8 93 fe ff ff       	call   80027f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ec:	ff 45 f0             	incl   -0x10(%ebp)
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f5:	0f 8c 32 ff ff ff    	jl     80032d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800402:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800409:	eb 26                	jmp    800431 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040b:	a1 20 40 80 00       	mov    0x804020,%eax
  800410:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800416:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800419:	89 d0                	mov    %edx,%eax
  80041b:	01 c0                	add    %eax,%eax
  80041d:	01 d0                	add    %edx,%eax
  80041f:	c1 e0 03             	shl    $0x3,%eax
  800422:	01 c8                	add    %ecx,%eax
  800424:	8a 40 04             	mov    0x4(%eax),%al
  800427:	3c 01                	cmp    $0x1,%al
  800429:	75 03                	jne    80042e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042e:	ff 45 e0             	incl   -0x20(%ebp)
  800431:	a1 20 40 80 00       	mov    0x804020,%eax
  800436:	8b 50 74             	mov    0x74(%eax),%edx
  800439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043c:	39 c2                	cmp    %eax,%edx
  80043e:	77 cb                	ja     80040b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800443:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800446:	74 14                	je     80045c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	68 6c 35 80 00       	push   $0x80356c
  800450:	6a 44                	push   $0x44
  800452:	68 0c 35 80 00       	push   $0x80350c
  800457:	e8 23 fe ff ff       	call   80027f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045c:	90                   	nop
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    

0080045f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 48 01             	lea    0x1(%eax),%ecx
  80046d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800470:	89 0a                	mov    %ecx,(%edx)
  800472:	8b 55 08             	mov    0x8(%ebp),%edx
  800475:	88 d1                	mov    %dl,%cl
  800477:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80047e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	3d ff 00 00 00       	cmp    $0xff,%eax
  800488:	75 2c                	jne    8004b6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048a:	a0 24 40 80 00       	mov    0x804024,%al
  80048f:	0f b6 c0             	movzbl %al,%eax
  800492:	8b 55 0c             	mov    0xc(%ebp),%edx
  800495:	8b 12                	mov    (%edx),%edx
  800497:	89 d1                	mov    %edx,%ecx
  800499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049c:	83 c2 08             	add    $0x8,%edx
  80049f:	83 ec 04             	sub    $0x4,%esp
  8004a2:	50                   	push   %eax
  8004a3:	51                   	push   %ecx
  8004a4:	52                   	push   %edx
  8004a5:	e8 22 13 00 00       	call   8017cc <sys_cputs>
  8004aa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b9:	8b 40 04             	mov    0x4(%eax),%eax
  8004bc:	8d 50 01             	lea    0x1(%eax),%edx
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d8:	00 00 00 
	b.cnt = 0;
  8004db:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e5:	ff 75 0c             	pushl  0xc(%ebp)
  8004e8:	ff 75 08             	pushl  0x8(%ebp)
  8004eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f1:	50                   	push   %eax
  8004f2:	68 5f 04 80 00       	push   $0x80045f
  8004f7:	e8 11 02 00 00       	call   80070d <vprintfmt>
  8004fc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004ff:	a0 24 40 80 00       	mov    0x804024,%al
  800504:	0f b6 c0             	movzbl %al,%eax
  800507:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	50                   	push   %eax
  800511:	52                   	push   %edx
  800512:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800518:	83 c0 08             	add    $0x8,%eax
  80051b:	50                   	push   %eax
  80051c:	e8 ab 12 00 00       	call   8017cc <sys_cputs>
  800521:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800524:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <cprintf>:

int cprintf(const char *fmt, ...) {
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800539:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800540:	8d 45 0c             	lea    0xc(%ebp),%eax
  800543:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	ff 75 f4             	pushl  -0xc(%ebp)
  80054f:	50                   	push   %eax
  800550:	e8 73 ff ff ff       	call   8004c8 <vcprintf>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800566:	e8 0f 14 00 00       	call   80197a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 48 ff ff ff       	call   8004c8 <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800586:	e8 09 14 00 00       	call   801994 <sys_enable_interrupt>
	return cnt;
  80058b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	53                   	push   %ebx
  800594:	83 ec 14             	sub    $0x14,%esp
  800597:	8b 45 10             	mov    0x10(%ebp),%eax
  80059a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ab:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ae:	77 55                	ja     800605 <printnum+0x75>
  8005b0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b3:	72 05                	jb     8005ba <printnum+0x2a>
  8005b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b8:	77 4b                	ja     800605 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ba:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c0:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c8:	52                   	push   %edx
  8005c9:	50                   	push   %eax
  8005ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d0:	e8 b3 29 00 00       	call   802f88 <__udivdi3>
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	83 ec 04             	sub    $0x4,%esp
  8005db:	ff 75 20             	pushl  0x20(%ebp)
  8005de:	53                   	push   %ebx
  8005df:	ff 75 18             	pushl  0x18(%ebp)
  8005e2:	52                   	push   %edx
  8005e3:	50                   	push   %eax
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	e8 a1 ff ff ff       	call   800590 <printnum>
  8005ef:	83 c4 20             	add    $0x20,%esp
  8005f2:	eb 1a                	jmp    80060e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	ff 75 0c             	pushl  0xc(%ebp)
  8005fa:	ff 75 20             	pushl  0x20(%ebp)
  8005fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800600:	ff d0                	call   *%eax
  800602:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800605:	ff 4d 1c             	decl   0x1c(%ebp)
  800608:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060c:	7f e6                	jg     8005f4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800611:	bb 00 00 00 00       	mov    $0x0,%ebx
  800616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061c:	53                   	push   %ebx
  80061d:	51                   	push   %ecx
  80061e:	52                   	push   %edx
  80061f:	50                   	push   %eax
  800620:	e8 73 2a 00 00       	call   803098 <__umoddi3>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	05 d4 37 80 00       	add    $0x8037d4,%eax
  80062d:	8a 00                	mov    (%eax),%al
  80062f:	0f be c0             	movsbl %al,%eax
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	50                   	push   %eax
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	ff d0                	call   *%eax
  80063e:	83 c4 10             	add    $0x10,%esp
}
  800641:	90                   	nop
  800642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800645:	c9                   	leave  
  800646:	c3                   	ret    

00800647 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800647:	55                   	push   %ebp
  800648:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064e:	7e 1c                	jle    80066c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	8d 50 08             	lea    0x8(%eax),%edx
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	89 10                	mov    %edx,(%eax)
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	83 e8 08             	sub    $0x8,%eax
  800665:	8b 50 04             	mov    0x4(%eax),%edx
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	eb 40                	jmp    8006ac <getuint+0x65>
	else if (lflag)
  80066c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800670:	74 1e                	je     800690 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 04             	lea    0x4(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 04             	sub    $0x4,%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	eb 1c                	jmp    8006ac <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	8d 50 04             	lea    0x4(%eax),%edx
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	89 10                	mov    %edx,(%eax)
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	83 e8 04             	sub    $0x4,%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ac:	5d                   	pop    %ebp
  8006ad:	c3                   	ret    

008006ae <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b5:	7e 1c                	jle    8006d3 <getint+0x25>
		return va_arg(*ap, long long);
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	8d 50 08             	lea    0x8(%eax),%edx
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	89 10                	mov    %edx,(%eax)
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	83 e8 08             	sub    $0x8,%eax
  8006cc:	8b 50 04             	mov    0x4(%eax),%edx
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	eb 38                	jmp    80070b <getint+0x5d>
	else if (lflag)
  8006d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d7:	74 1a                	je     8006f3 <getint+0x45>
		return va_arg(*ap, long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 04             	lea    0x4(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 04             	sub    $0x4,%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	99                   	cltd   
  8006f1:	eb 18                	jmp    80070b <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	8d 50 04             	lea    0x4(%eax),%edx
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	89 10                	mov    %edx,(%eax)
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	83 e8 04             	sub    $0x4,%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	99                   	cltd   
}
  80070b:	5d                   	pop    %ebp
  80070c:	c3                   	ret    

0080070d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	56                   	push   %esi
  800711:	53                   	push   %ebx
  800712:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800715:	eb 17                	jmp    80072e <vprintfmt+0x21>
			if (ch == '\0')
  800717:	85 db                	test   %ebx,%ebx
  800719:	0f 84 af 03 00 00    	je     800ace <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	53                   	push   %ebx
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	8d 50 01             	lea    0x1(%eax),%edx
  800734:	89 55 10             	mov    %edx,0x10(%ebp)
  800737:	8a 00                	mov    (%eax),%al
  800739:	0f b6 d8             	movzbl %al,%ebx
  80073c:	83 fb 25             	cmp    $0x25,%ebx
  80073f:	75 d6                	jne    800717 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800741:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800745:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800753:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800772:	83 f8 55             	cmp    $0x55,%eax
  800775:	0f 87 2b 03 00 00    	ja     800aa6 <vprintfmt+0x399>
  80077b:	8b 04 85 f8 37 80 00 	mov    0x8037f8(,%eax,4),%eax
  800782:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800784:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800788:	eb d7                	jmp    800761 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078e:	eb d1                	jmp    800761 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800790:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800797:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079a:	89 d0                	mov    %edx,%eax
  80079c:	c1 e0 02             	shl    $0x2,%eax
  80079f:	01 d0                	add    %edx,%eax
  8007a1:	01 c0                	add    %eax,%eax
  8007a3:	01 d8                	add    %ebx,%eax
  8007a5:	83 e8 30             	sub    $0x30,%eax
  8007a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ae:	8a 00                	mov    (%eax),%al
  8007b0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b6:	7e 3e                	jle    8007f6 <vprintfmt+0xe9>
  8007b8:	83 fb 39             	cmp    $0x39,%ebx
  8007bb:	7f 39                	jg     8007f6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c0:	eb d5                	jmp    800797 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d6:	eb 1f                	jmp    8007f7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007dc:	79 83                	jns    800761 <vprintfmt+0x54>
				width = 0;
  8007de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e5:	e9 77 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ea:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f1:	e9 6b ff ff ff       	jmp    800761 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fb:	0f 89 60 ff ff ff    	jns    800761 <vprintfmt+0x54>
				width = precision, precision = -1;
  800801:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800807:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080e:	e9 4e ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800813:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800816:	e9 46 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 14             	mov    %eax,0x14(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	83 e8 04             	sub    $0x4,%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	50                   	push   %eax
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
			break;
  80083b:	e9 89 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	83 c0 04             	add    $0x4,%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	83 e8 04             	sub    $0x4,%eax
  80084f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800851:	85 db                	test   %ebx,%ebx
  800853:	79 02                	jns    800857 <vprintfmt+0x14a>
				err = -err;
  800855:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800857:	83 fb 64             	cmp    $0x64,%ebx
  80085a:	7f 0b                	jg     800867 <vprintfmt+0x15a>
  80085c:	8b 34 9d 40 36 80 00 	mov    0x803640(,%ebx,4),%esi
  800863:	85 f6                	test   %esi,%esi
  800865:	75 19                	jne    800880 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800867:	53                   	push   %ebx
  800868:	68 e5 37 80 00       	push   $0x8037e5
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	ff 75 08             	pushl  0x8(%ebp)
  800873:	e8 5e 02 00 00       	call   800ad6 <printfmt>
  800878:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087b:	e9 49 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800880:	56                   	push   %esi
  800881:	68 ee 37 80 00       	push   $0x8037ee
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	ff 75 08             	pushl  0x8(%ebp)
  80088c:	e8 45 02 00 00       	call   800ad6 <printfmt>
  800891:	83 c4 10             	add    $0x10,%esp
			break;
  800894:	e9 30 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	83 c0 04             	add    $0x4,%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	83 e8 04             	sub    $0x4,%eax
  8008a8:	8b 30                	mov    (%eax),%esi
  8008aa:	85 f6                	test   %esi,%esi
  8008ac:	75 05                	jne    8008b3 <vprintfmt+0x1a6>
				p = "(null)";
  8008ae:	be f1 37 80 00       	mov    $0x8037f1,%esi
			if (width > 0 && padc != '-')
  8008b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b7:	7e 6d                	jle    800926 <vprintfmt+0x219>
  8008b9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008bd:	74 67                	je     800926 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	50                   	push   %eax
  8008c6:	56                   	push   %esi
  8008c7:	e8 0c 03 00 00       	call   800bd8 <strnlen>
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d2:	eb 16                	jmp    8008ea <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	50                   	push   %eax
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	ff d0                	call   *%eax
  8008e4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e7:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7f e4                	jg     8008d4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f0:	eb 34                	jmp    800926 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f6:	74 1c                	je     800914 <vprintfmt+0x207>
  8008f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fb:	7e 05                	jle    800902 <vprintfmt+0x1f5>
  8008fd:	83 fb 7e             	cmp    $0x7e,%ebx
  800900:	7e 12                	jle    800914 <vprintfmt+0x207>
					putch('?', putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	6a 3f                	push   $0x3f
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
  800912:	eb 0f                	jmp    800923 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	ff 4d e4             	decl   -0x1c(%ebp)
  800926:	89 f0                	mov    %esi,%eax
  800928:	8d 70 01             	lea    0x1(%eax),%esi
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
  800930:	85 db                	test   %ebx,%ebx
  800932:	74 24                	je     800958 <vprintfmt+0x24b>
  800934:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800938:	78 b8                	js     8008f2 <vprintfmt+0x1e5>
  80093a:	ff 4d e0             	decl   -0x20(%ebp)
  80093d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800941:	79 af                	jns    8008f2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800943:	eb 13                	jmp    800958 <vprintfmt+0x24b>
				putch(' ', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 20                	push   $0x20
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800955:	ff 4d e4             	decl   -0x1c(%ebp)
  800958:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095c:	7f e7                	jg     800945 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095e:	e9 66 01 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 e8             	pushl  -0x18(%ebp)
  800969:	8d 45 14             	lea    0x14(%ebp),%eax
  80096c:	50                   	push   %eax
  80096d:	e8 3c fd ff ff       	call   8006ae <getint>
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800978:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800981:	85 d2                	test   %edx,%edx
  800983:	79 23                	jns    8009a8 <vprintfmt+0x29b>
				putch('-', putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	6a 2d                	push   $0x2d
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800998:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099b:	f7 d8                	neg    %eax
  80099d:	83 d2 00             	adc    $0x0,%edx
  8009a0:	f7 da                	neg    %edx
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 bc 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bd:	50                   	push   %eax
  8009be:	e8 84 fc ff ff       	call   800647 <getuint>
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d3:	e9 98 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	6a 58                	push   $0x58
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	ff d0                	call   *%eax
  8009e5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 58                	push   $0x58
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 58                	push   $0x58
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
			break;
  800a08:	e9 bc 00 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 30                	push   $0x30
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 78                	push   $0x78
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 e8 04             	sub    $0x4,%eax
  800a3c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a48:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a4f:	eb 1f                	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 e8             	pushl  -0x18(%ebp)
  800a57:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5a:	50                   	push   %eax
  800a5b:	e8 e7 fb ff ff       	call   800647 <getuint>
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a66:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a69:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a70:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	52                   	push   %edx
  800a7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7e:	50                   	push   %eax
  800a7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a82:	ff 75 f0             	pushl  -0x10(%ebp)
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	ff 75 08             	pushl  0x8(%ebp)
  800a8b:	e8 00 fb ff ff       	call   800590 <printnum>
  800a90:	83 c4 20             	add    $0x20,%esp
			break;
  800a93:	eb 34                	jmp    800ac9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	53                   	push   %ebx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			break;
  800aa4:	eb 23                	jmp    800ac9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	6a 25                	push   $0x25
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	ff d0                	call   *%eax
  800ab3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab6:	ff 4d 10             	decl   0x10(%ebp)
  800ab9:	eb 03                	jmp    800abe <vprintfmt+0x3b1>
  800abb:	ff 4d 10             	decl   0x10(%ebp)
  800abe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac1:	48                   	dec    %eax
  800ac2:	8a 00                	mov    (%eax),%al
  800ac4:	3c 25                	cmp    $0x25,%al
  800ac6:	75 f3                	jne    800abb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac8:	90                   	nop
		}
	}
  800ac9:	e9 47 fc ff ff       	jmp    800715 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ace:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adc:	8d 45 10             	lea    0x10(%ebp),%eax
  800adf:	83 c0 04             	add    $0x4,%eax
  800ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae8:	ff 75 f4             	pushl  -0xc(%ebp)
  800aeb:	50                   	push   %eax
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	e8 16 fc ff ff       	call   80070d <vprintfmt>
  800af7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afa:	90                   	nop
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 40 08             	mov    0x8(%eax),%eax
  800b06:	8d 50 01             	lea    0x1(%eax),%edx
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	8b 10                	mov    (%eax),%edx
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	8b 40 04             	mov    0x4(%eax),%eax
  800b1a:	39 c2                	cmp    %eax,%edx
  800b1c:	73 12                	jae    800b30 <sprintputch+0x33>
		*b->buf++ = ch;
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	8d 48 01             	lea    0x1(%eax),%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	89 0a                	mov    %ecx,(%edx)
  800b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2e:	88 10                	mov    %dl,(%eax)
}
  800b30:	90                   	nop
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	01 d0                	add    %edx,%eax
  800b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b58:	74 06                	je     800b60 <vsnprintf+0x2d>
  800b5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5e:	7f 07                	jg     800b67 <vsnprintf+0x34>
		return -E_INVAL;
  800b60:	b8 03 00 00 00       	mov    $0x3,%eax
  800b65:	eb 20                	jmp    800b87 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b67:	ff 75 14             	pushl  0x14(%ebp)
  800b6a:	ff 75 10             	pushl  0x10(%ebp)
  800b6d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b70:	50                   	push   %eax
  800b71:	68 fd 0a 80 00       	push   $0x800afd
  800b76:	e8 92 fb ff ff       	call   80070d <vprintfmt>
  800b7b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b81:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b92:	83 c0 04             	add    $0x4,%eax
  800b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9e:	50                   	push   %eax
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	ff 75 08             	pushl  0x8(%ebp)
  800ba5:	e8 89 ff ff ff       	call   800b33 <vsnprintf>
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc2:	eb 06                	jmp    800bca <strlen+0x15>
		n++;
  800bc4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc7:	ff 45 08             	incl   0x8(%ebp)
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	84 c0                	test   %al,%al
  800bd1:	75 f1                	jne    800bc4 <strlen+0xf>
		n++;
	return n;
  800bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be5:	eb 09                	jmp    800bf0 <strnlen+0x18>
		n++;
  800be7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bea:	ff 45 08             	incl   0x8(%ebp)
  800bed:	ff 4d 0c             	decl   0xc(%ebp)
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	74 09                	je     800bff <strnlen+0x27>
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	84 c0                	test   %al,%al
  800bfd:	75 e8                	jne    800be7 <strnlen+0xf>
		n++;
	return n;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c10:	90                   	nop
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8d 50 01             	lea    0x1(%eax),%edx
  800c17:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c20:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c23:	8a 12                	mov    (%edx),%dl
  800c25:	88 10                	mov    %dl,(%eax)
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	75 e4                	jne    800c11 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c45:	eb 1f                	jmp    800c66 <strncpy+0x34>
		*dst++ = *src;
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8d 50 01             	lea    0x1(%eax),%edx
  800c4d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c53:	8a 12                	mov    (%edx),%dl
  800c55:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	74 03                	je     800c63 <strncpy+0x31>
			src++;
  800c60:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c63:	ff 45 fc             	incl   -0x4(%ebp)
  800c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c69:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6c:	72 d9                	jb     800c47 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c83:	74 30                	je     800cb5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c85:	eb 16                	jmp    800c9d <strlcpy+0x2a>
			*dst++ = *src++;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8d 50 01             	lea    0x1(%eax),%edx
  800c8d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c96:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c99:	8a 12                	mov    (%edx),%dl
  800c9b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c9d:	ff 4d 10             	decl   0x10(%ebp)
  800ca0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca4:	74 09                	je     800caf <strlcpy+0x3c>
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	75 d8                	jne    800c87 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	29 c2                	sub    %eax,%edx
  800cbd:	89 d0                	mov    %edx,%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc4:	eb 06                	jmp    800ccc <strcmp+0xb>
		p++, q++;
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	84 c0                	test   %al,%al
  800cd3:	74 0e                	je     800ce3 <strcmp+0x22>
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 10                	mov    (%eax),%dl
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	38 c2                	cmp    %al,%dl
  800ce1:	74 e3                	je     800cc6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 d0             	movzbl %al,%edx
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	0f b6 c0             	movzbl %al,%eax
  800cf3:	29 c2                	sub    %eax,%edx
  800cf5:	89 d0                	mov    %edx,%eax
}
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cfc:	eb 09                	jmp    800d07 <strncmp+0xe>
		n--, p++, q++;
  800cfe:	ff 4d 10             	decl   0x10(%ebp)
  800d01:	ff 45 08             	incl   0x8(%ebp)
  800d04:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0b:	74 17                	je     800d24 <strncmp+0x2b>
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 0e                	je     800d24 <strncmp+0x2b>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 10                	mov    (%eax),%dl
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	38 c2                	cmp    %al,%dl
  800d22:	74 da                	je     800cfe <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d28:	75 07                	jne    800d31 <strncmp+0x38>
		return 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2f:	eb 14                	jmp    800d45 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 d0             	movzbl %al,%edx
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 c0             	movzbl %al,%eax
  800d41:	29 c2                	sub    %eax,%edx
  800d43:	89 d0                	mov    %edx,%eax
}
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 04             	sub    $0x4,%esp
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d53:	eb 12                	jmp    800d67 <strchr+0x20>
		if (*s == c)
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5d:	75 05                	jne    800d64 <strchr+0x1d>
			return (char *) s;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	eb 11                	jmp    800d75 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d64:	ff 45 08             	incl   0x8(%ebp)
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	84 c0                	test   %al,%al
  800d6e:	75 e5                	jne    800d55 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 04             	sub    $0x4,%esp
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d83:	eb 0d                	jmp    800d92 <strfind+0x1b>
		if (*s == c)
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8d:	74 0e                	je     800d9d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d8f:	ff 45 08             	incl   0x8(%ebp)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	84 c0                	test   %al,%al
  800d99:	75 ea                	jne    800d85 <strfind+0xe>
  800d9b:	eb 01                	jmp    800d9e <strfind+0x27>
		if (*s == c)
			break;
  800d9d:	90                   	nop
	return (char *) s;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800daf:	8b 45 10             	mov    0x10(%ebp),%eax
  800db2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db5:	eb 0e                	jmp    800dc5 <memset+0x22>
		*p++ = c;
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	8d 50 01             	lea    0x1(%eax),%edx
  800dbd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc5:	ff 4d f8             	decl   -0x8(%ebp)
  800dc8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcc:	79 e9                	jns    800db7 <memset+0x14>
		*p++ = c;

	return v;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de5:	eb 16                	jmp    800dfd <memcpy+0x2a>
		*d++ = *s++;
  800de7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dea:	8d 50 01             	lea    0x1(%eax),%edx
  800ded:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df9:	8a 12                	mov    (%edx),%dl
  800dfb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800e00:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e03:	89 55 10             	mov    %edx,0x10(%ebp)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	75 dd                	jne    800de7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0d:	c9                   	leave  
  800e0e:	c3                   	ret    

00800e0f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e27:	73 50                	jae    800e79 <memmove+0x6a>
  800e29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	01 d0                	add    %edx,%eax
  800e31:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e34:	76 43                	jbe    800e79 <memmove+0x6a>
		s += n;
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e42:	eb 10                	jmp    800e54 <memmove+0x45>
			*--d = *--s;
  800e44:	ff 4d f8             	decl   -0x8(%ebp)
  800e47:	ff 4d fc             	decl   -0x4(%ebp)
  800e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e54:	8b 45 10             	mov    0x10(%ebp),%eax
  800e57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 e3                	jne    800e44 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e61:	eb 23                	jmp    800e86 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e72:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e75:	8a 12                	mov    (%edx),%dl
  800e77:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e79:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	75 dd                	jne    800e63 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e9d:	eb 2a                	jmp    800ec9 <memcmp+0x3e>
		if (*s1 != *s2)
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 10                	mov    (%eax),%dl
  800ea4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	38 c2                	cmp    %al,%dl
  800eab:	74 16                	je     800ec3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 d0             	movzbl %al,%edx
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	29 c2                	sub    %eax,%edx
  800ebf:	89 d0                	mov    %edx,%eax
  800ec1:	eb 18                	jmp    800edb <memcmp+0x50>
		s1++, s2++;
  800ec3:	ff 45 fc             	incl   -0x4(%ebp)
  800ec6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ecf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	75 c9                	jne    800e9f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee9:	01 d0                	add    %edx,%eax
  800eeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eee:	eb 15                	jmp    800f05 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	0f b6 d0             	movzbl %al,%edx
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	0f b6 c0             	movzbl %al,%eax
  800efe:	39 c2                	cmp    %eax,%edx
  800f00:	74 0d                	je     800f0f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0b:	72 e3                	jb     800ef0 <memfind+0x13>
  800f0d:	eb 01                	jmp    800f10 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f0f:	90                   	nop
	return (void *) s;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f22:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f29:	eb 03                	jmp    800f2e <strtol+0x19>
		s++;
  800f2b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 20                	cmp    $0x20,%al
  800f35:	74 f4                	je     800f2b <strtol+0x16>
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	3c 09                	cmp    $0x9,%al
  800f3e:	74 eb                	je     800f2b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2b                	cmp    $0x2b,%al
  800f47:	75 05                	jne    800f4e <strtol+0x39>
		s++;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	eb 13                	jmp    800f61 <strtol+0x4c>
	else if (*s == '-')
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	3c 2d                	cmp    $0x2d,%al
  800f55:	75 0a                	jne    800f61 <strtol+0x4c>
		s++, neg = 1;
  800f57:	ff 45 08             	incl   0x8(%ebp)
  800f5a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f65:	74 06                	je     800f6d <strtol+0x58>
  800f67:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6b:	75 20                	jne    800f8d <strtol+0x78>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3c 30                	cmp    $0x30,%al
  800f74:	75 17                	jne    800f8d <strtol+0x78>
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	40                   	inc    %eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 78                	cmp    $0x78,%al
  800f7e:	75 0d                	jne    800f8d <strtol+0x78>
		s += 2, base = 16;
  800f80:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f84:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8b:	eb 28                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f91:	75 15                	jne    800fa8 <strtol+0x93>
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	3c 30                	cmp    $0x30,%al
  800f9a:	75 0c                	jne    800fa8 <strtol+0x93>
		s++, base = 8;
  800f9c:	ff 45 08             	incl   0x8(%ebp)
  800f9f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa6:	eb 0d                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0)
  800fa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fac:	75 07                	jne    800fb5 <strtol+0xa0>
		base = 10;
  800fae:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 2f                	cmp    $0x2f,%al
  800fbc:	7e 19                	jle    800fd7 <strtol+0xc2>
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	3c 39                	cmp    $0x39,%al
  800fc5:	7f 10                	jg     800fd7 <strtol+0xc2>
			dig = *s - '0';
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	0f be c0             	movsbl %al,%eax
  800fcf:	83 e8 30             	sub    $0x30,%eax
  800fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd5:	eb 42                	jmp    801019 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 60                	cmp    $0x60,%al
  800fde:	7e 19                	jle    800ff9 <strtol+0xe4>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 7a                	cmp    $0x7a,%al
  800fe7:	7f 10                	jg     800ff9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f be c0             	movsbl %al,%eax
  800ff1:	83 e8 57             	sub    $0x57,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff7:	eb 20                	jmp    801019 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 40                	cmp    $0x40,%al
  801000:	7e 39                	jle    80103b <strtol+0x126>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 5a                	cmp    $0x5a,%al
  801009:	7f 30                	jg     80103b <strtol+0x126>
			dig = *s - 'A' + 10;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f be c0             	movsbl %al,%eax
  801013:	83 e8 37             	sub    $0x37,%eax
  801016:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101f:	7d 19                	jge    80103a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801021:	ff 45 08             	incl   0x8(%ebp)
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102b:	89 c2                	mov    %eax,%edx
  80102d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801030:	01 d0                	add    %edx,%eax
  801032:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801035:	e9 7b ff ff ff       	jmp    800fb5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80103f:	74 08                	je     801049 <strtol+0x134>
		*endptr = (char *) s;
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	8b 55 08             	mov    0x8(%ebp),%edx
  801047:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801049:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80104d:	74 07                	je     801056 <strtol+0x141>
  80104f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801052:	f7 d8                	neg    %eax
  801054:	eb 03                	jmp    801059 <strtol+0x144>
  801056:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <ltostr>:

void
ltostr(long value, char *str)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801068:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80106f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801073:	79 13                	jns    801088 <ltostr+0x2d>
	{
		neg = 1;
  801075:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801082:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801085:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801090:	99                   	cltd   
  801091:	f7 f9                	idiv   %ecx
  801093:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801096:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801099:	8d 50 01             	lea    0x1(%eax),%edx
  80109c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109f:	89 c2                	mov    %eax,%edx
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	01 d0                	add    %edx,%eax
  8010a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a9:	83 c2 30             	add    $0x30,%edx
  8010ac:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b6:	f7 e9                	imul   %ecx
  8010b8:	c1 fa 02             	sar    $0x2,%edx
  8010bb:	89 c8                	mov    %ecx,%eax
  8010bd:	c1 f8 1f             	sar    $0x1f,%eax
  8010c0:	29 c2                	sub    %eax,%edx
  8010c2:	89 d0                	mov    %edx,%eax
  8010c4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ca:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010cf:	f7 e9                	imul   %ecx
  8010d1:	c1 fa 02             	sar    $0x2,%edx
  8010d4:	89 c8                	mov    %ecx,%eax
  8010d6:	c1 f8 1f             	sar    $0x1f,%eax
  8010d9:	29 c2                	sub    %eax,%edx
  8010db:	89 d0                	mov    %edx,%eax
  8010dd:	c1 e0 02             	shl    $0x2,%eax
  8010e0:	01 d0                	add    %edx,%eax
  8010e2:	01 c0                	add    %eax,%eax
  8010e4:	29 c1                	sub    %eax,%ecx
  8010e6:	89 ca                	mov    %ecx,%edx
  8010e8:	85 d2                	test   %edx,%edx
  8010ea:	75 9c                	jne    801088 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f6:	48                   	dec    %eax
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010fe:	74 3d                	je     80113d <ltostr+0xe2>
		start = 1 ;
  801100:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801107:	eb 34                	jmp    80113d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110f:	01 d0                	add    %edx,%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801116:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c2                	add    %eax,%edx
  80111e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	01 c8                	add    %ecx,%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	01 c2                	add    %eax,%edx
  801132:	8a 45 eb             	mov    -0x15(%ebp),%al
  801135:	88 02                	mov    %al,(%edx)
		start++ ;
  801137:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80113d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801143:	7c c4                	jl     801109 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801145:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801150:	90                   	nop
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801159:	ff 75 08             	pushl  0x8(%ebp)
  80115c:	e8 54 fa ff ff       	call   800bb5 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801167:	ff 75 0c             	pushl  0xc(%ebp)
  80116a:	e8 46 fa ff ff       	call   800bb5 <strlen>
  80116f:	83 c4 04             	add    $0x4,%esp
  801172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801183:	eb 17                	jmp    80119c <strcconcat+0x49>
		final[s] = str1[s] ;
  801185:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	01 c2                	add    %eax,%edx
  80118d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	01 c8                	add    %ecx,%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801199:	ff 45 fc             	incl   -0x4(%ebp)
  80119c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a2:	7c e1                	jl     801185 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b2:	eb 1f                	jmp    8011d3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d0:	ff 45 f8             	incl   -0x8(%ebp)
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c d9                	jl     8011b4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f8:	8b 00                	mov    (%eax),%eax
  8011fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801201:	8b 45 10             	mov    0x10(%ebp),%eax
  801204:	01 d0                	add    %edx,%eax
  801206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	eb 0c                	jmp    80121a <strsplit+0x31>
			*string++ = 0;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8d 50 01             	lea    0x1(%eax),%edx
  801214:	89 55 08             	mov    %edx,0x8(%ebp)
  801217:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	84 c0                	test   %al,%al
  801221:	74 18                	je     80123b <strsplit+0x52>
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	0f be c0             	movsbl %al,%eax
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	e8 13 fb ff ff       	call   800d47 <strchr>
  801234:	83 c4 08             	add    $0x8,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	75 d3                	jne    80120e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	84 c0                	test   %al,%al
  801242:	74 5a                	je     80129e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	83 f8 0f             	cmp    $0xf,%eax
  80124c:	75 07                	jne    801255 <strsplit+0x6c>
		{
			return 0;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
  801253:	eb 66                	jmp    8012bb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	8d 48 01             	lea    0x1(%eax),%ecx
  80125d:	8b 55 14             	mov    0x14(%ebp),%edx
  801260:	89 0a                	mov    %ecx,(%edx)
  801262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801269:	8b 45 10             	mov    0x10(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801273:	eb 03                	jmp    801278 <strsplit+0x8f>
			string++;
  801275:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	84 c0                	test   %al,%al
  80127f:	74 8b                	je     80120c <strsplit+0x23>
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	0f be c0             	movsbl %al,%eax
  801289:	50                   	push   %eax
  80128a:	ff 75 0c             	pushl  0xc(%ebp)
  80128d:	e8 b5 fa ff ff       	call   800d47 <strchr>
  801292:	83 c4 08             	add    $0x8,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	74 dc                	je     801275 <strsplit+0x8c>
			string++;
	}
  801299:	e9 6e ff ff ff       	jmp    80120c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80129e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80129f:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a2:	8b 00                	mov    (%eax),%eax
  8012a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 1f                	je     8012eb <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cc:	e8 1d 00 00 00       	call   8012ee <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	68 50 39 80 00       	push   $0x803950
  8012d9:	e8 55 f2 ff ff       	call   800533 <cprintf>
  8012de:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e1:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012e8:	00 00 00 
	}
}
  8012eb:	90                   	nop
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8012f4:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012fb:	00 00 00 
  8012fe:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801305:	00 00 00 
  801308:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80130f:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801312:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801319:	00 00 00 
  80131c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801323:	00 00 00 
  801326:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80132d:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801330:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801337:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80133a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801344:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801349:	2d 00 10 00 00       	sub    $0x1000,%eax
  80134e:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801353:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80135a:	a1 20 41 80 00       	mov    0x804120,%eax
  80135f:	c1 e0 04             	shl    $0x4,%eax
  801362:	89 c2                	mov    %eax,%edx
  801364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801367:	01 d0                	add    %edx,%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80136d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801370:	ba 00 00 00 00       	mov    $0x0,%edx
  801375:	f7 75 f0             	divl   -0x10(%ebp)
  801378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80137b:	29 d0                	sub    %edx,%eax
  80137d:	89 c2                	mov    %eax,%edx
  80137f:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801386:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801389:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80138e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801393:	83 ec 04             	sub    $0x4,%esp
  801396:	6a 06                	push   $0x6
  801398:	52                   	push   %edx
  801399:	50                   	push   %eax
  80139a:	e8 71 05 00 00       	call   801910 <sys_allocate_chunk>
  80139f:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013a2:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a7:	83 ec 0c             	sub    $0xc,%esp
  8013aa:	50                   	push   %eax
  8013ab:	e8 e6 0b 00 00       	call   801f96 <initialize_MemBlocksList>
  8013b0:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8013b3:	a1 48 41 80 00       	mov    0x804148,%eax
  8013b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8013bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013bf:	75 14                	jne    8013d5 <initialize_dyn_block_system+0xe7>
  8013c1:	83 ec 04             	sub    $0x4,%esp
  8013c4:	68 75 39 80 00       	push   $0x803975
  8013c9:	6a 2b                	push   $0x2b
  8013cb:	68 93 39 80 00       	push   $0x803993
  8013d0:	e8 aa ee ff ff       	call   80027f <_panic>
  8013d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d8:	8b 00                	mov    (%eax),%eax
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	74 10                	je     8013ee <initialize_dyn_block_system+0x100>
  8013de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e1:	8b 00                	mov    (%eax),%eax
  8013e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013e6:	8b 52 04             	mov    0x4(%edx),%edx
  8013e9:	89 50 04             	mov    %edx,0x4(%eax)
  8013ec:	eb 0b                	jmp    8013f9 <initialize_dyn_block_system+0x10b>
  8013ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f1:	8b 40 04             	mov    0x4(%eax),%eax
  8013f4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013fc:	8b 40 04             	mov    0x4(%eax),%eax
  8013ff:	85 c0                	test   %eax,%eax
  801401:	74 0f                	je     801412 <initialize_dyn_block_system+0x124>
  801403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801406:	8b 40 04             	mov    0x4(%eax),%eax
  801409:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80140c:	8b 12                	mov    (%edx),%edx
  80140e:	89 10                	mov    %edx,(%eax)
  801410:	eb 0a                	jmp    80141c <initialize_dyn_block_system+0x12e>
  801412:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801415:	8b 00                	mov    (%eax),%eax
  801417:	a3 48 41 80 00       	mov    %eax,0x804148
  80141c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80141f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801428:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80142f:	a1 54 41 80 00       	mov    0x804154,%eax
  801434:	48                   	dec    %eax
  801435:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  80143a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80143d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801447:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	ff 75 e4             	pushl  -0x1c(%ebp)
  801454:	e8 d2 13 00 00       	call   80282b <insert_sorted_with_merge_freeList>
  801459:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80145c:	90                   	nop
  80145d:	c9                   	leave  
  80145e:	c3                   	ret    

0080145f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801465:	e8 53 fe ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  80146a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80146e:	75 07                	jne    801477 <malloc+0x18>
  801470:	b8 00 00 00 00       	mov    $0x0,%eax
  801475:	eb 61                	jmp    8014d8 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801477:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80147e:	8b 55 08             	mov    0x8(%ebp),%edx
  801481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801484:	01 d0                	add    %edx,%eax
  801486:	48                   	dec    %eax
  801487:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80148a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148d:	ba 00 00 00 00       	mov    $0x0,%edx
  801492:	f7 75 f4             	divl   -0xc(%ebp)
  801495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801498:	29 d0                	sub    %edx,%eax
  80149a:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80149d:	e8 3c 08 00 00       	call   801cde <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	74 2d                	je     8014d3 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8014a6:	83 ec 0c             	sub    $0xc,%esp
  8014a9:	ff 75 08             	pushl  0x8(%ebp)
  8014ac:	e8 3e 0f 00 00       	call   8023ef <alloc_block_FF>
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8014b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014bb:	74 16                	je     8014d3 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8014bd:	83 ec 0c             	sub    $0xc,%esp
  8014c0:	ff 75 ec             	pushl  -0x14(%ebp)
  8014c3:	e8 48 0c 00 00       	call   802110 <insert_sorted_allocList>
  8014c8:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8014cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ce:	8b 40 08             	mov    0x8(%eax),%eax
  8014d1:	eb 05                	jmp    8014d8 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8014d3:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8014e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ee:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	83 ec 08             	sub    $0x8,%esp
  8014f7:	50                   	push   %eax
  8014f8:	68 40 40 80 00       	push   $0x804040
  8014fd:	e8 71 0b 00 00       	call   802073 <find_block>
  801502:	83 c4 10             	add    $0x10,%esp
  801505:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150b:	8b 50 0c             	mov    0xc(%eax),%edx
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	83 ec 08             	sub    $0x8,%esp
  801514:	52                   	push   %edx
  801515:	50                   	push   %eax
  801516:	e8 bd 03 00 00       	call   8018d8 <sys_free_user_mem>
  80151b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80151e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801522:	75 14                	jne    801538 <free+0x5e>
  801524:	83 ec 04             	sub    $0x4,%esp
  801527:	68 75 39 80 00       	push   $0x803975
  80152c:	6a 71                	push   $0x71
  80152e:	68 93 39 80 00       	push   $0x803993
  801533:	e8 47 ed ff ff       	call   80027f <_panic>
  801538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153b:	8b 00                	mov    (%eax),%eax
  80153d:	85 c0                	test   %eax,%eax
  80153f:	74 10                	je     801551 <free+0x77>
  801541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801544:	8b 00                	mov    (%eax),%eax
  801546:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801549:	8b 52 04             	mov    0x4(%edx),%edx
  80154c:	89 50 04             	mov    %edx,0x4(%eax)
  80154f:	eb 0b                	jmp    80155c <free+0x82>
  801551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801554:	8b 40 04             	mov    0x4(%eax),%eax
  801557:	a3 44 40 80 00       	mov    %eax,0x804044
  80155c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155f:	8b 40 04             	mov    0x4(%eax),%eax
  801562:	85 c0                	test   %eax,%eax
  801564:	74 0f                	je     801575 <free+0x9b>
  801566:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801569:	8b 40 04             	mov    0x4(%eax),%eax
  80156c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80156f:	8b 12                	mov    (%edx),%edx
  801571:	89 10                	mov    %edx,(%eax)
  801573:	eb 0a                	jmp    80157f <free+0xa5>
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801578:	8b 00                	mov    (%eax),%eax
  80157a:	a3 40 40 80 00       	mov    %eax,0x804040
  80157f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801582:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801592:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801597:	48                   	dec    %eax
  801598:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  80159d:	83 ec 0c             	sub    $0xc,%esp
  8015a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8015a3:	e8 83 12 00 00       	call   80282b <insert_sorted_with_merge_freeList>
  8015a8:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015ab:	90                   	nop
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 28             	sub    $0x28,%esp
  8015b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b7:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ba:	e8 fe fc ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  8015bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c3:	75 0a                	jne    8015cf <smalloc+0x21>
  8015c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ca:	e9 86 00 00 00       	jmp    801655 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8015cf:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015dc:	01 d0                	add    %edx,%eax
  8015de:	48                   	dec    %eax
  8015df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ea:	f7 75 f4             	divl   -0xc(%ebp)
  8015ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f0:	29 d0                	sub    %edx,%eax
  8015f2:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015f5:	e8 e4 06 00 00       	call   801cde <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015fa:	85 c0                	test   %eax,%eax
  8015fc:	74 52                	je     801650 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  8015fe:	83 ec 0c             	sub    $0xc,%esp
  801601:	ff 75 0c             	pushl  0xc(%ebp)
  801604:	e8 e6 0d 00 00       	call   8023ef <alloc_block_FF>
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  80160f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801613:	75 07                	jne    80161c <smalloc+0x6e>
			return NULL ;
  801615:	b8 00 00 00 00       	mov    $0x0,%eax
  80161a:	eb 39                	jmp    801655 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80161c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80161f:	8b 40 08             	mov    0x8(%eax),%eax
  801622:	89 c2                	mov    %eax,%edx
  801624:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801628:	52                   	push   %edx
  801629:	50                   	push   %eax
  80162a:	ff 75 0c             	pushl  0xc(%ebp)
  80162d:	ff 75 08             	pushl  0x8(%ebp)
  801630:	e8 2e 04 00 00       	call   801a63 <sys_createSharedObject>
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80163b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80163f:	79 07                	jns    801648 <smalloc+0x9a>
			return (void*)NULL ;
  801641:	b8 00 00 00 00       	mov    $0x0,%eax
  801646:	eb 0d                	jmp    801655 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801648:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164b:	8b 40 08             	mov    0x8(%eax),%eax
  80164e:	eb 05                	jmp    801655 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801650:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801655:	c9                   	leave  
  801656:	c3                   	ret    

00801657 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801657:	55                   	push   %ebp
  801658:	89 e5                	mov    %esp,%ebp
  80165a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80165d:	e8 5b fc ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801662:	83 ec 08             	sub    $0x8,%esp
  801665:	ff 75 0c             	pushl  0xc(%ebp)
  801668:	ff 75 08             	pushl  0x8(%ebp)
  80166b:	e8 1d 04 00 00       	call   801a8d <sys_getSizeOfSharedObject>
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80167a:	75 0a                	jne    801686 <sget+0x2f>
			return NULL ;
  80167c:	b8 00 00 00 00       	mov    $0x0,%eax
  801681:	e9 83 00 00 00       	jmp    801709 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801686:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80168d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801690:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801693:	01 d0                	add    %edx,%eax
  801695:	48                   	dec    %eax
  801696:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801699:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169c:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a1:	f7 75 f0             	divl   -0x10(%ebp)
  8016a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a7:	29 d0                	sub    %edx,%eax
  8016a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ac:	e8 2d 06 00 00       	call   801cde <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	74 4f                	je     801704 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8016b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b8:	83 ec 0c             	sub    $0xc,%esp
  8016bb:	50                   	push   %eax
  8016bc:	e8 2e 0d 00 00       	call   8023ef <alloc_block_FF>
  8016c1:	83 c4 10             	add    $0x10,%esp
  8016c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8016c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016cb:	75 07                	jne    8016d4 <sget+0x7d>
					return (void*)NULL ;
  8016cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d2:	eb 35                	jmp    801709 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8016d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016d7:	8b 40 08             	mov    0x8(%eax),%eax
  8016da:	83 ec 04             	sub    $0x4,%esp
  8016dd:	50                   	push   %eax
  8016de:	ff 75 0c             	pushl  0xc(%ebp)
  8016e1:	ff 75 08             	pushl  0x8(%ebp)
  8016e4:	e8 c1 03 00 00       	call   801aaa <sys_getSharedObject>
  8016e9:	83 c4 10             	add    $0x10,%esp
  8016ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8016ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016f3:	79 07                	jns    8016fc <sget+0xa5>
				return (void*)NULL ;
  8016f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fa:	eb 0d                	jmp    801709 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8016fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ff:	8b 40 08             	mov    0x8(%eax),%eax
  801702:	eb 05                	jmp    801709 <sget+0xb2>


		}
	return (void*)NULL ;
  801704:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801709:	c9                   	leave  
  80170a:	c3                   	ret    

0080170b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801711:	e8 a7 fb ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801716:	83 ec 04             	sub    $0x4,%esp
  801719:	68 a0 39 80 00       	push   $0x8039a0
  80171e:	68 f9 00 00 00       	push   $0xf9
  801723:	68 93 39 80 00       	push   $0x803993
  801728:	e8 52 eb ff ff       	call   80027f <_panic>

0080172d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801733:	83 ec 04             	sub    $0x4,%esp
  801736:	68 c8 39 80 00       	push   $0x8039c8
  80173b:	68 0d 01 00 00       	push   $0x10d
  801740:	68 93 39 80 00       	push   $0x803993
  801745:	e8 35 eb ff ff       	call   80027f <_panic>

0080174a <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80174a:	55                   	push   %ebp
  80174b:	89 e5                	mov    %esp,%ebp
  80174d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	68 ec 39 80 00       	push   $0x8039ec
  801758:	68 18 01 00 00       	push   $0x118
  80175d:	68 93 39 80 00       	push   $0x803993
  801762:	e8 18 eb ff ff       	call   80027f <_panic>

00801767 <shrink>:

}
void shrink(uint32 newSize)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	68 ec 39 80 00       	push   $0x8039ec
  801775:	68 1d 01 00 00       	push   $0x11d
  80177a:	68 93 39 80 00       	push   $0x803993
  80177f:	e8 fb ea ff ff       	call   80027f <_panic>

00801784 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178a:	83 ec 04             	sub    $0x4,%esp
  80178d:	68 ec 39 80 00       	push   $0x8039ec
  801792:	68 22 01 00 00       	push   $0x122
  801797:	68 93 39 80 00       	push   $0x803993
  80179c:	e8 de ea ff ff       	call   80027f <_panic>

008017a1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	57                   	push   %edi
  8017a5:	56                   	push   %esi
  8017a6:	53                   	push   %ebx
  8017a7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017b6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017b9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017bc:	cd 30                	int    $0x30
  8017be:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017c4:	83 c4 10             	add    $0x10,%esp
  8017c7:	5b                   	pop    %ebx
  8017c8:	5e                   	pop    %esi
  8017c9:	5f                   	pop    %edi
  8017ca:	5d                   	pop    %ebp
  8017cb:	c3                   	ret    

008017cc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 04             	sub    $0x4,%esp
  8017d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017d8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	52                   	push   %edx
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	50                   	push   %eax
  8017e8:	6a 00                	push   $0x0
  8017ea:	e8 b2 ff ff ff       	call   8017a1 <syscall>
  8017ef:	83 c4 18             	add    $0x18,%esp
}
  8017f2:	90                   	nop
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 01                	push   $0x1
  801804:	e8 98 ff ff ff       	call   8017a1 <syscall>
  801809:	83 c4 18             	add    $0x18,%esp
}
  80180c:	c9                   	leave  
  80180d:	c3                   	ret    

0080180e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801811:	8b 55 0c             	mov    0xc(%ebp),%edx
  801814:	8b 45 08             	mov    0x8(%ebp),%eax
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	52                   	push   %edx
  80181e:	50                   	push   %eax
  80181f:	6a 05                	push   $0x5
  801821:	e8 7b ff ff ff       	call   8017a1 <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	c9                   	leave  
  80182a:	c3                   	ret    

0080182b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	56                   	push   %esi
  80182f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801830:	8b 75 18             	mov    0x18(%ebp),%esi
  801833:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801836:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801839:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	56                   	push   %esi
  801840:	53                   	push   %ebx
  801841:	51                   	push   %ecx
  801842:	52                   	push   %edx
  801843:	50                   	push   %eax
  801844:	6a 06                	push   $0x6
  801846:	e8 56 ff ff ff       	call   8017a1 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801851:	5b                   	pop    %ebx
  801852:	5e                   	pop    %esi
  801853:	5d                   	pop    %ebp
  801854:	c3                   	ret    

00801855 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801858:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	52                   	push   %edx
  801865:	50                   	push   %eax
  801866:	6a 07                	push   $0x7
  801868:	e8 34 ff ff ff       	call   8017a1 <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	ff 75 0c             	pushl  0xc(%ebp)
  80187e:	ff 75 08             	pushl  0x8(%ebp)
  801881:	6a 08                	push   $0x8
  801883:	e8 19 ff ff ff       	call   8017a1 <syscall>
  801888:	83 c4 18             	add    $0x18,%esp
}
  80188b:	c9                   	leave  
  80188c:	c3                   	ret    

0080188d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 00                	push   $0x0
  80189a:	6a 09                	push   $0x9
  80189c:	e8 00 ff ff ff       	call   8017a1 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 0a                	push   $0xa
  8018b5:	e8 e7 fe ff ff       	call   8017a1 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 0b                	push   $0xb
  8018ce:	e8 ce fe ff ff       	call   8017a1 <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	ff 75 0c             	pushl  0xc(%ebp)
  8018e4:	ff 75 08             	pushl  0x8(%ebp)
  8018e7:	6a 0f                	push   $0xf
  8018e9:	e8 b3 fe ff ff       	call   8017a1 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
	return;
  8018f1:	90                   	nop
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	ff 75 0c             	pushl  0xc(%ebp)
  801900:	ff 75 08             	pushl  0x8(%ebp)
  801903:	6a 10                	push   $0x10
  801905:	e8 97 fe ff ff       	call   8017a1 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
	return ;
  80190d:	90                   	nop
}
  80190e:	c9                   	leave  
  80190f:	c3                   	ret    

00801910 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801913:	6a 00                	push   $0x0
  801915:	6a 00                	push   $0x0
  801917:	ff 75 10             	pushl  0x10(%ebp)
  80191a:	ff 75 0c             	pushl  0xc(%ebp)
  80191d:	ff 75 08             	pushl  0x8(%ebp)
  801920:	6a 11                	push   $0x11
  801922:	e8 7a fe ff ff       	call   8017a1 <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
	return ;
  80192a:	90                   	nop
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 0c                	push   $0xc
  80193c:	e8 60 fe ff ff       	call   8017a1 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
}
  801944:	c9                   	leave  
  801945:	c3                   	ret    

00801946 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	ff 75 08             	pushl  0x8(%ebp)
  801954:	6a 0d                	push   $0xd
  801956:	e8 46 fe ff ff       	call   8017a1 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 0e                	push   $0xe
  80196f:	e8 2d fe ff ff       	call   8017a1 <syscall>
  801974:	83 c4 18             	add    $0x18,%esp
}
  801977:	90                   	nop
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 13                	push   $0x13
  801989:	e8 13 fe ff ff       	call   8017a1 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	90                   	nop
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 14                	push   $0x14
  8019a3:	e8 f9 fd ff ff       	call   8017a1 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	90                   	nop
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_cputc>:


void
sys_cputc(const char c)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019ba:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	50                   	push   %eax
  8019c7:	6a 15                	push   $0x15
  8019c9:	e8 d3 fd ff ff       	call   8017a1 <syscall>
  8019ce:	83 c4 18             	add    $0x18,%esp
}
  8019d1:	90                   	nop
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 16                	push   $0x16
  8019e3:	e8 b9 fd ff ff       	call   8017a1 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	90                   	nop
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	ff 75 0c             	pushl  0xc(%ebp)
  8019fd:	50                   	push   %eax
  8019fe:	6a 17                	push   $0x17
  801a00:	e8 9c fd ff ff       	call   8017a1 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	52                   	push   %edx
  801a1a:	50                   	push   %eax
  801a1b:	6a 1a                	push   $0x1a
  801a1d:	e8 7f fd ff ff       	call   8017a1 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	52                   	push   %edx
  801a37:	50                   	push   %eax
  801a38:	6a 18                	push   $0x18
  801a3a:	e8 62 fd ff ff       	call   8017a1 <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	90                   	nop
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	52                   	push   %edx
  801a55:	50                   	push   %eax
  801a56:	6a 19                	push   $0x19
  801a58:	e8 44 fd ff ff       	call   8017a1 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	90                   	nop
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 04             	sub    $0x4,%esp
  801a69:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a6f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a72:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a76:	8b 45 08             	mov    0x8(%ebp),%eax
  801a79:	6a 00                	push   $0x0
  801a7b:	51                   	push   %ecx
  801a7c:	52                   	push   %edx
  801a7d:	ff 75 0c             	pushl  0xc(%ebp)
  801a80:	50                   	push   %eax
  801a81:	6a 1b                	push   $0x1b
  801a83:	e8 19 fd ff ff       	call   8017a1 <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	52                   	push   %edx
  801a9d:	50                   	push   %eax
  801a9e:	6a 1c                	push   $0x1c
  801aa0:	e8 fc fc ff ff       	call   8017a1 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801aad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	51                   	push   %ecx
  801abb:	52                   	push   %edx
  801abc:	50                   	push   %eax
  801abd:	6a 1d                	push   $0x1d
  801abf:	e8 dd fc ff ff       	call   8017a1 <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	52                   	push   %edx
  801ad9:	50                   	push   %eax
  801ada:	6a 1e                	push   $0x1e
  801adc:	e8 c0 fc ff ff       	call   8017a1 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 1f                	push   $0x1f
  801af5:	e8 a7 fc ff ff       	call   8017a1 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	6a 00                	push   $0x0
  801b07:	ff 75 14             	pushl  0x14(%ebp)
  801b0a:	ff 75 10             	pushl  0x10(%ebp)
  801b0d:	ff 75 0c             	pushl  0xc(%ebp)
  801b10:	50                   	push   %eax
  801b11:	6a 20                	push   $0x20
  801b13:	e8 89 fc ff ff       	call   8017a1 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	50                   	push   %eax
  801b2c:	6a 21                	push   $0x21
  801b2e:	e8 6e fc ff ff       	call   8017a1 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	90                   	nop
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	50                   	push   %eax
  801b48:	6a 22                	push   $0x22
  801b4a:	e8 52 fc ff ff       	call   8017a1 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 02                	push   $0x2
  801b63:	e8 39 fc ff ff       	call   8017a1 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 03                	push   $0x3
  801b7c:	e8 20 fc ff ff       	call   8017a1 <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 04                	push   $0x4
  801b95:	e8 07 fc ff ff       	call   8017a1 <syscall>
  801b9a:	83 c4 18             	add    $0x18,%esp
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <sys_exit_env>:


void sys_exit_env(void)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 23                	push   $0x23
  801bae:	e8 ee fb ff ff       	call   8017a1 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	90                   	nop
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bbf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bc2:	8d 50 04             	lea    0x4(%eax),%edx
  801bc5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	52                   	push   %edx
  801bcf:	50                   	push   %eax
  801bd0:	6a 24                	push   $0x24
  801bd2:	e8 ca fb ff ff       	call   8017a1 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
	return result;
  801bda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bdd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801be0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be3:	89 01                	mov    %eax,(%ecx)
  801be5:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	c9                   	leave  
  801bec:	c2 04 00             	ret    $0x4

00801bef <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	ff 75 10             	pushl  0x10(%ebp)
  801bf9:	ff 75 0c             	pushl  0xc(%ebp)
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	6a 12                	push   $0x12
  801c01:	e8 9b fb ff ff       	call   8017a1 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
	return ;
  801c09:	90                   	nop
}
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_rcr2>:
uint32 sys_rcr2()
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 25                	push   $0x25
  801c1b:	e8 81 fb ff ff       	call   8017a1 <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
}
  801c23:	c9                   	leave  
  801c24:	c3                   	ret    

00801c25 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	83 ec 04             	sub    $0x4,%esp
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c31:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	50                   	push   %eax
  801c3e:	6a 26                	push   $0x26
  801c40:	e8 5c fb ff ff       	call   8017a1 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
	return ;
  801c48:	90                   	nop
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <rsttst>:
void rsttst()
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 28                	push   $0x28
  801c5a:	e8 42 fb ff ff       	call   8017a1 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c62:	90                   	nop
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 04             	sub    $0x4,%esp
  801c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c71:	8b 55 18             	mov    0x18(%ebp),%edx
  801c74:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c78:	52                   	push   %edx
  801c79:	50                   	push   %eax
  801c7a:	ff 75 10             	pushl  0x10(%ebp)
  801c7d:	ff 75 0c             	pushl  0xc(%ebp)
  801c80:	ff 75 08             	pushl  0x8(%ebp)
  801c83:	6a 27                	push   $0x27
  801c85:	e8 17 fb ff ff       	call   8017a1 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8d:	90                   	nop
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <chktst>:
void chktst(uint32 n)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	ff 75 08             	pushl  0x8(%ebp)
  801c9e:	6a 29                	push   $0x29
  801ca0:	e8 fc fa ff ff       	call   8017a1 <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca8:	90                   	nop
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <inctst>:

void inctst()
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 2a                	push   $0x2a
  801cba:	e8 e2 fa ff ff       	call   8017a1 <syscall>
  801cbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc2:	90                   	nop
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <gettst>:
uint32 gettst()
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 2b                	push   $0x2b
  801cd4:	e8 c8 fa ff ff       	call   8017a1 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 2c                	push   $0x2c
  801cf0:	e8 ac fa ff ff       	call   8017a1 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
  801cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cfb:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cff:	75 07                	jne    801d08 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d01:	b8 01 00 00 00       	mov    $0x1,%eax
  801d06:	eb 05                	jmp    801d0d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 2c                	push   $0x2c
  801d21:	e8 7b fa ff ff       	call   8017a1 <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
  801d29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d2c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d30:	75 07                	jne    801d39 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d32:	b8 01 00 00 00       	mov    $0x1,%eax
  801d37:	eb 05                	jmp    801d3e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 2c                	push   $0x2c
  801d52:	e8 4a fa ff ff       	call   8017a1 <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
  801d5a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d5d:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d61:	75 07                	jne    801d6a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d63:	b8 01 00 00 00       	mov    $0x1,%eax
  801d68:	eb 05                	jmp    801d6f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 2c                	push   $0x2c
  801d83:	e8 19 fa ff ff       	call   8017a1 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
  801d8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d8e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d92:	75 07                	jne    801d9b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d94:	b8 01 00 00 00       	mov    $0x1,%eax
  801d99:	eb 05                	jmp    801da0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da0:	c9                   	leave  
  801da1:	c3                   	ret    

00801da2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801da2:	55                   	push   %ebp
  801da3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	ff 75 08             	pushl  0x8(%ebp)
  801db0:	6a 2d                	push   $0x2d
  801db2:	e8 ea f9 ff ff       	call   8017a1 <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dba:	90                   	nop
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dc1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	6a 00                	push   $0x0
  801dcf:	53                   	push   %ebx
  801dd0:	51                   	push   %ecx
  801dd1:	52                   	push   %edx
  801dd2:	50                   	push   %eax
  801dd3:	6a 2e                	push   $0x2e
  801dd5:	e8 c7 f9 ff ff       	call   8017a1 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
}
  801ddd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de0:	c9                   	leave  
  801de1:	c3                   	ret    

00801de2 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801de2:	55                   	push   %ebp
  801de3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801de5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	52                   	push   %edx
  801df2:	50                   	push   %eax
  801df3:	6a 2f                	push   $0x2f
  801df5:	e8 a7 f9 ff ff       	call   8017a1 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e05:	83 ec 0c             	sub    $0xc,%esp
  801e08:	68 fc 39 80 00       	push   $0x8039fc
  801e0d:	e8 21 e7 ff ff       	call   800533 <cprintf>
  801e12:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e15:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e1c:	83 ec 0c             	sub    $0xc,%esp
  801e1f:	68 28 3a 80 00       	push   $0x803a28
  801e24:	e8 0a e7 ff ff       	call   800533 <cprintf>
  801e29:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e2c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e30:	a1 38 41 80 00       	mov    0x804138,%eax
  801e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e38:	eb 56                	jmp    801e90 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e3e:	74 1c                	je     801e5c <print_mem_block_lists+0x5d>
  801e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e43:	8b 50 08             	mov    0x8(%eax),%edx
  801e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e49:	8b 48 08             	mov    0x8(%eax),%ecx
  801e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e52:	01 c8                	add    %ecx,%eax
  801e54:	39 c2                	cmp    %eax,%edx
  801e56:	73 04                	jae    801e5c <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e58:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5f:	8b 50 08             	mov    0x8(%eax),%edx
  801e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e65:	8b 40 0c             	mov    0xc(%eax),%eax
  801e68:	01 c2                	add    %eax,%edx
  801e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6d:	8b 40 08             	mov    0x8(%eax),%eax
  801e70:	83 ec 04             	sub    $0x4,%esp
  801e73:	52                   	push   %edx
  801e74:	50                   	push   %eax
  801e75:	68 3d 3a 80 00       	push   $0x803a3d
  801e7a:	e8 b4 e6 ff ff       	call   800533 <cprintf>
  801e7f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e85:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e88:	a1 40 41 80 00       	mov    0x804140,%eax
  801e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e94:	74 07                	je     801e9d <print_mem_block_lists+0x9e>
  801e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e99:	8b 00                	mov    (%eax),%eax
  801e9b:	eb 05                	jmp    801ea2 <print_mem_block_lists+0xa3>
  801e9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea2:	a3 40 41 80 00       	mov    %eax,0x804140
  801ea7:	a1 40 41 80 00       	mov    0x804140,%eax
  801eac:	85 c0                	test   %eax,%eax
  801eae:	75 8a                	jne    801e3a <print_mem_block_lists+0x3b>
  801eb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb4:	75 84                	jne    801e3a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801eb6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eba:	75 10                	jne    801ecc <print_mem_block_lists+0xcd>
  801ebc:	83 ec 0c             	sub    $0xc,%esp
  801ebf:	68 4c 3a 80 00       	push   $0x803a4c
  801ec4:	e8 6a e6 ff ff       	call   800533 <cprintf>
  801ec9:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ecc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ed3:	83 ec 0c             	sub    $0xc,%esp
  801ed6:	68 70 3a 80 00       	push   $0x803a70
  801edb:	e8 53 e6 ff ff       	call   800533 <cprintf>
  801ee0:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ee3:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ee7:	a1 40 40 80 00       	mov    0x804040,%eax
  801eec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eef:	eb 56                	jmp    801f47 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ef1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ef5:	74 1c                	je     801f13 <print_mem_block_lists+0x114>
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	8b 50 08             	mov    0x8(%eax),%edx
  801efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f00:	8b 48 08             	mov    0x8(%eax),%ecx
  801f03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f06:	8b 40 0c             	mov    0xc(%eax),%eax
  801f09:	01 c8                	add    %ecx,%eax
  801f0b:	39 c2                	cmp    %eax,%edx
  801f0d:	73 04                	jae    801f13 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f0f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	8b 50 08             	mov    0x8(%eax),%edx
  801f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1f:	01 c2                	add    %eax,%edx
  801f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f24:	8b 40 08             	mov    0x8(%eax),%eax
  801f27:	83 ec 04             	sub    $0x4,%esp
  801f2a:	52                   	push   %edx
  801f2b:	50                   	push   %eax
  801f2c:	68 3d 3a 80 00       	push   $0x803a3d
  801f31:	e8 fd e5 ff ff       	call   800533 <cprintf>
  801f36:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f3f:	a1 48 40 80 00       	mov    0x804048,%eax
  801f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4b:	74 07                	je     801f54 <print_mem_block_lists+0x155>
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	8b 00                	mov    (%eax),%eax
  801f52:	eb 05                	jmp    801f59 <print_mem_block_lists+0x15a>
  801f54:	b8 00 00 00 00       	mov    $0x0,%eax
  801f59:	a3 48 40 80 00       	mov    %eax,0x804048
  801f5e:	a1 48 40 80 00       	mov    0x804048,%eax
  801f63:	85 c0                	test   %eax,%eax
  801f65:	75 8a                	jne    801ef1 <print_mem_block_lists+0xf2>
  801f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f6b:	75 84                	jne    801ef1 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f6d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f71:	75 10                	jne    801f83 <print_mem_block_lists+0x184>
  801f73:	83 ec 0c             	sub    $0xc,%esp
  801f76:	68 88 3a 80 00       	push   $0x803a88
  801f7b:	e8 b3 e5 ff ff       	call   800533 <cprintf>
  801f80:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f83:	83 ec 0c             	sub    $0xc,%esp
  801f86:	68 fc 39 80 00       	push   $0x8039fc
  801f8b:	e8 a3 e5 ff ff       	call   800533 <cprintf>
  801f90:	83 c4 10             	add    $0x10,%esp

}
  801f93:	90                   	nop
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801f9c:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fa3:	00 00 00 
  801fa6:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fad:	00 00 00 
  801fb0:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801fb7:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801fba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fc1:	e9 9e 00 00 00       	jmp    802064 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  801fc6:	a1 50 40 80 00       	mov    0x804050,%eax
  801fcb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fce:	c1 e2 04             	shl    $0x4,%edx
  801fd1:	01 d0                	add    %edx,%eax
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	75 14                	jne    801feb <initialize_MemBlocksList+0x55>
  801fd7:	83 ec 04             	sub    $0x4,%esp
  801fda:	68 b0 3a 80 00       	push   $0x803ab0
  801fdf:	6a 43                	push   $0x43
  801fe1:	68 d3 3a 80 00       	push   $0x803ad3
  801fe6:	e8 94 e2 ff ff       	call   80027f <_panic>
  801feb:	a1 50 40 80 00       	mov    0x804050,%eax
  801ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff3:	c1 e2 04             	shl    $0x4,%edx
  801ff6:	01 d0                	add    %edx,%eax
  801ff8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ffe:	89 10                	mov    %edx,(%eax)
  802000:	8b 00                	mov    (%eax),%eax
  802002:	85 c0                	test   %eax,%eax
  802004:	74 18                	je     80201e <initialize_MemBlocksList+0x88>
  802006:	a1 48 41 80 00       	mov    0x804148,%eax
  80200b:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802011:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802014:	c1 e1 04             	shl    $0x4,%ecx
  802017:	01 ca                	add    %ecx,%edx
  802019:	89 50 04             	mov    %edx,0x4(%eax)
  80201c:	eb 12                	jmp    802030 <initialize_MemBlocksList+0x9a>
  80201e:	a1 50 40 80 00       	mov    0x804050,%eax
  802023:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802026:	c1 e2 04             	shl    $0x4,%edx
  802029:	01 d0                	add    %edx,%eax
  80202b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802030:	a1 50 40 80 00       	mov    0x804050,%eax
  802035:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802038:	c1 e2 04             	shl    $0x4,%edx
  80203b:	01 d0                	add    %edx,%eax
  80203d:	a3 48 41 80 00       	mov    %eax,0x804148
  802042:	a1 50 40 80 00       	mov    0x804050,%eax
  802047:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204a:	c1 e2 04             	shl    $0x4,%edx
  80204d:	01 d0                	add    %edx,%eax
  80204f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802056:	a1 54 41 80 00       	mov    0x804154,%eax
  80205b:	40                   	inc    %eax
  80205c:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802061:	ff 45 f4             	incl   -0xc(%ebp)
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	3b 45 08             	cmp    0x8(%ebp),%eax
  80206a:	0f 82 56 ff ff ff    	jb     801fc6 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802070:	90                   	nop
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
  802076:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802079:	a1 38 41 80 00       	mov    0x804138,%eax
  80207e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802081:	eb 18                	jmp    80209b <find_block+0x28>
	{
		if (ele->sva==va)
  802083:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802086:	8b 40 08             	mov    0x8(%eax),%eax
  802089:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80208c:	75 05                	jne    802093 <find_block+0x20>
			return ele;
  80208e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802091:	eb 7b                	jmp    80210e <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802093:	a1 40 41 80 00       	mov    0x804140,%eax
  802098:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80209b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80209f:	74 07                	je     8020a8 <find_block+0x35>
  8020a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a4:	8b 00                	mov    (%eax),%eax
  8020a6:	eb 05                	jmp    8020ad <find_block+0x3a>
  8020a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ad:	a3 40 41 80 00       	mov    %eax,0x804140
  8020b2:	a1 40 41 80 00       	mov    0x804140,%eax
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	75 c8                	jne    802083 <find_block+0x10>
  8020bb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020bf:	75 c2                	jne    802083 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020c1:	a1 40 40 80 00       	mov    0x804040,%eax
  8020c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020c9:	eb 18                	jmp    8020e3 <find_block+0x70>
	{
		if (ele->sva==va)
  8020cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ce:	8b 40 08             	mov    0x8(%eax),%eax
  8020d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020d4:	75 05                	jne    8020db <find_block+0x68>
					return ele;
  8020d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d9:	eb 33                	jmp    80210e <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020db:	a1 48 40 80 00       	mov    0x804048,%eax
  8020e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020e7:	74 07                	je     8020f0 <find_block+0x7d>
  8020e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ec:	8b 00                	mov    (%eax),%eax
  8020ee:	eb 05                	jmp    8020f5 <find_block+0x82>
  8020f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f5:	a3 48 40 80 00       	mov    %eax,0x804048
  8020fa:	a1 48 40 80 00       	mov    0x804048,%eax
  8020ff:	85 c0                	test   %eax,%eax
  802101:	75 c8                	jne    8020cb <find_block+0x58>
  802103:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802107:	75 c2                	jne    8020cb <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802109:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802116:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80211b:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80211e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802122:	75 62                	jne    802186 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802124:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802128:	75 14                	jne    80213e <insert_sorted_allocList+0x2e>
  80212a:	83 ec 04             	sub    $0x4,%esp
  80212d:	68 b0 3a 80 00       	push   $0x803ab0
  802132:	6a 69                	push   $0x69
  802134:	68 d3 3a 80 00       	push   $0x803ad3
  802139:	e8 41 e1 ff ff       	call   80027f <_panic>
  80213e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	89 10                	mov    %edx,(%eax)
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	8b 00                	mov    (%eax),%eax
  80214e:	85 c0                	test   %eax,%eax
  802150:	74 0d                	je     80215f <insert_sorted_allocList+0x4f>
  802152:	a1 40 40 80 00       	mov    0x804040,%eax
  802157:	8b 55 08             	mov    0x8(%ebp),%edx
  80215a:	89 50 04             	mov    %edx,0x4(%eax)
  80215d:	eb 08                	jmp    802167 <insert_sorted_allocList+0x57>
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	a3 44 40 80 00       	mov    %eax,0x804044
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	a3 40 40 80 00       	mov    %eax,0x804040
  80216f:	8b 45 08             	mov    0x8(%ebp),%eax
  802172:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802179:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80217e:	40                   	inc    %eax
  80217f:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802184:	eb 72                	jmp    8021f8 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802186:	a1 40 40 80 00       	mov    0x804040,%eax
  80218b:	8b 50 08             	mov    0x8(%eax),%edx
  80218e:	8b 45 08             	mov    0x8(%ebp),%eax
  802191:	8b 40 08             	mov    0x8(%eax),%eax
  802194:	39 c2                	cmp    %eax,%edx
  802196:	76 60                	jbe    8021f8 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802198:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80219c:	75 14                	jne    8021b2 <insert_sorted_allocList+0xa2>
  80219e:	83 ec 04             	sub    $0x4,%esp
  8021a1:	68 b0 3a 80 00       	push   $0x803ab0
  8021a6:	6a 6d                	push   $0x6d
  8021a8:	68 d3 3a 80 00       	push   $0x803ad3
  8021ad:	e8 cd e0 ff ff       	call   80027f <_panic>
  8021b2:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bb:	89 10                	mov    %edx,(%eax)
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	8b 00                	mov    (%eax),%eax
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	74 0d                	je     8021d3 <insert_sorted_allocList+0xc3>
  8021c6:	a1 40 40 80 00       	mov    0x804040,%eax
  8021cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ce:	89 50 04             	mov    %edx,0x4(%eax)
  8021d1:	eb 08                	jmp    8021db <insert_sorted_allocList+0xcb>
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	a3 44 40 80 00       	mov    %eax,0x804044
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	a3 40 40 80 00       	mov    %eax,0x804040
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ed:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021f2:	40                   	inc    %eax
  8021f3:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8021f8:	a1 40 40 80 00       	mov    0x804040,%eax
  8021fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802200:	e9 b9 01 00 00       	jmp    8023be <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802205:	8b 45 08             	mov    0x8(%ebp),%eax
  802208:	8b 50 08             	mov    0x8(%eax),%edx
  80220b:	a1 40 40 80 00       	mov    0x804040,%eax
  802210:	8b 40 08             	mov    0x8(%eax),%eax
  802213:	39 c2                	cmp    %eax,%edx
  802215:	76 7c                	jbe    802293 <insert_sorted_allocList+0x183>
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	8b 50 08             	mov    0x8(%eax),%edx
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	8b 40 08             	mov    0x8(%eax),%eax
  802223:	39 c2                	cmp    %eax,%edx
  802225:	73 6c                	jae    802293 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222b:	74 06                	je     802233 <insert_sorted_allocList+0x123>
  80222d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802231:	75 14                	jne    802247 <insert_sorted_allocList+0x137>
  802233:	83 ec 04             	sub    $0x4,%esp
  802236:	68 ec 3a 80 00       	push   $0x803aec
  80223b:	6a 75                	push   $0x75
  80223d:	68 d3 3a 80 00       	push   $0x803ad3
  802242:	e8 38 e0 ff ff       	call   80027f <_panic>
  802247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224a:	8b 50 04             	mov    0x4(%eax),%edx
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	89 50 04             	mov    %edx,0x4(%eax)
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802259:	89 10                	mov    %edx,(%eax)
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 40 04             	mov    0x4(%eax),%eax
  802261:	85 c0                	test   %eax,%eax
  802263:	74 0d                	je     802272 <insert_sorted_allocList+0x162>
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	8b 40 04             	mov    0x4(%eax),%eax
  80226b:	8b 55 08             	mov    0x8(%ebp),%edx
  80226e:	89 10                	mov    %edx,(%eax)
  802270:	eb 08                	jmp    80227a <insert_sorted_allocList+0x16a>
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	a3 40 40 80 00       	mov    %eax,0x804040
  80227a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227d:	8b 55 08             	mov    0x8(%ebp),%edx
  802280:	89 50 04             	mov    %edx,0x4(%eax)
  802283:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802288:	40                   	inc    %eax
  802289:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  80228e:	e9 59 01 00 00       	jmp    8023ec <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	8b 50 08             	mov    0x8(%eax),%edx
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	8b 40 08             	mov    0x8(%eax),%eax
  80229f:	39 c2                	cmp    %eax,%edx
  8022a1:	0f 86 98 00 00 00    	jbe    80233f <insert_sorted_allocList+0x22f>
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	8b 50 08             	mov    0x8(%eax),%edx
  8022ad:	a1 44 40 80 00       	mov    0x804044,%eax
  8022b2:	8b 40 08             	mov    0x8(%eax),%eax
  8022b5:	39 c2                	cmp    %eax,%edx
  8022b7:	0f 83 82 00 00 00    	jae    80233f <insert_sorted_allocList+0x22f>
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	8b 50 08             	mov    0x8(%eax),%edx
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 00                	mov    (%eax),%eax
  8022c8:	8b 40 08             	mov    0x8(%eax),%eax
  8022cb:	39 c2                	cmp    %eax,%edx
  8022cd:	73 70                	jae    80233f <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8022cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d3:	74 06                	je     8022db <insert_sorted_allocList+0x1cb>
  8022d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d9:	75 14                	jne    8022ef <insert_sorted_allocList+0x1df>
  8022db:	83 ec 04             	sub    $0x4,%esp
  8022de:	68 24 3b 80 00       	push   $0x803b24
  8022e3:	6a 7c                	push   $0x7c
  8022e5:	68 d3 3a 80 00       	push   $0x803ad3
  8022ea:	e8 90 df ff ff       	call   80027f <_panic>
  8022ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f2:	8b 10                	mov    (%eax),%edx
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	89 10                	mov    %edx,(%eax)
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	8b 00                	mov    (%eax),%eax
  8022fe:	85 c0                	test   %eax,%eax
  802300:	74 0b                	je     80230d <insert_sorted_allocList+0x1fd>
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	8b 00                	mov    (%eax),%eax
  802307:	8b 55 08             	mov    0x8(%ebp),%edx
  80230a:	89 50 04             	mov    %edx,0x4(%eax)
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	8b 55 08             	mov    0x8(%ebp),%edx
  802313:	89 10                	mov    %edx,(%eax)
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231b:	89 50 04             	mov    %edx,0x4(%eax)
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	8b 00                	mov    (%eax),%eax
  802323:	85 c0                	test   %eax,%eax
  802325:	75 08                	jne    80232f <insert_sorted_allocList+0x21f>
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	a3 44 40 80 00       	mov    %eax,0x804044
  80232f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802334:	40                   	inc    %eax
  802335:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80233a:	e9 ad 00 00 00       	jmp    8023ec <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	8b 50 08             	mov    0x8(%eax),%edx
  802345:	a1 44 40 80 00       	mov    0x804044,%eax
  80234a:	8b 40 08             	mov    0x8(%eax),%eax
  80234d:	39 c2                	cmp    %eax,%edx
  80234f:	76 65                	jbe    8023b6 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802355:	75 17                	jne    80236e <insert_sorted_allocList+0x25e>
  802357:	83 ec 04             	sub    $0x4,%esp
  80235a:	68 58 3b 80 00       	push   $0x803b58
  80235f:	68 80 00 00 00       	push   $0x80
  802364:	68 d3 3a 80 00       	push   $0x803ad3
  802369:	e8 11 df ff ff       	call   80027f <_panic>
  80236e:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802374:	8b 45 08             	mov    0x8(%ebp),%eax
  802377:	89 50 04             	mov    %edx,0x4(%eax)
  80237a:	8b 45 08             	mov    0x8(%ebp),%eax
  80237d:	8b 40 04             	mov    0x4(%eax),%eax
  802380:	85 c0                	test   %eax,%eax
  802382:	74 0c                	je     802390 <insert_sorted_allocList+0x280>
  802384:	a1 44 40 80 00       	mov    0x804044,%eax
  802389:	8b 55 08             	mov    0x8(%ebp),%edx
  80238c:	89 10                	mov    %edx,(%eax)
  80238e:	eb 08                	jmp    802398 <insert_sorted_allocList+0x288>
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	a3 40 40 80 00       	mov    %eax,0x804040
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	a3 44 40 80 00       	mov    %eax,0x804044
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023ae:	40                   	inc    %eax
  8023af:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8023b4:	eb 36                	jmp    8023ec <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8023b6:	a1 48 40 80 00       	mov    0x804048,%eax
  8023bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c2:	74 07                	je     8023cb <insert_sorted_allocList+0x2bb>
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	8b 00                	mov    (%eax),%eax
  8023c9:	eb 05                	jmp    8023d0 <insert_sorted_allocList+0x2c0>
  8023cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d0:	a3 48 40 80 00       	mov    %eax,0x804048
  8023d5:	a1 48 40 80 00       	mov    0x804048,%eax
  8023da:	85 c0                	test   %eax,%eax
  8023dc:	0f 85 23 fe ff ff    	jne    802205 <insert_sorted_allocList+0xf5>
  8023e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e6:	0f 85 19 fe ff ff    	jne    802205 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8023ec:	90                   	nop
  8023ed:	c9                   	leave  
  8023ee:	c3                   	ret    

008023ef <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8023f5:	a1 38 41 80 00       	mov    0x804138,%eax
  8023fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023fd:	e9 7c 01 00 00       	jmp    80257e <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802405:	8b 40 0c             	mov    0xc(%eax),%eax
  802408:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240b:	0f 85 90 00 00 00    	jne    8024a1 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802414:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802417:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241b:	75 17                	jne    802434 <alloc_block_FF+0x45>
  80241d:	83 ec 04             	sub    $0x4,%esp
  802420:	68 7b 3b 80 00       	push   $0x803b7b
  802425:	68 ba 00 00 00       	push   $0xba
  80242a:	68 d3 3a 80 00       	push   $0x803ad3
  80242f:	e8 4b de ff ff       	call   80027f <_panic>
  802434:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802437:	8b 00                	mov    (%eax),%eax
  802439:	85 c0                	test   %eax,%eax
  80243b:	74 10                	je     80244d <alloc_block_FF+0x5e>
  80243d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802440:	8b 00                	mov    (%eax),%eax
  802442:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802445:	8b 52 04             	mov    0x4(%edx),%edx
  802448:	89 50 04             	mov    %edx,0x4(%eax)
  80244b:	eb 0b                	jmp    802458 <alloc_block_FF+0x69>
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	8b 40 04             	mov    0x4(%eax),%eax
  802453:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 40 04             	mov    0x4(%eax),%eax
  80245e:	85 c0                	test   %eax,%eax
  802460:	74 0f                	je     802471 <alloc_block_FF+0x82>
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 40 04             	mov    0x4(%eax),%eax
  802468:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246b:	8b 12                	mov    (%edx),%edx
  80246d:	89 10                	mov    %edx,(%eax)
  80246f:	eb 0a                	jmp    80247b <alloc_block_FF+0x8c>
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	8b 00                	mov    (%eax),%eax
  802476:	a3 38 41 80 00       	mov    %eax,0x804138
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248e:	a1 44 41 80 00       	mov    0x804144,%eax
  802493:	48                   	dec    %eax
  802494:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  802499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249c:	e9 10 01 00 00       	jmp    8025b1 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8024a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024aa:	0f 86 c6 00 00 00    	jbe    802576 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8024b0:	a1 48 41 80 00       	mov    0x804148,%eax
  8024b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8024b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024bc:	75 17                	jne    8024d5 <alloc_block_FF+0xe6>
  8024be:	83 ec 04             	sub    $0x4,%esp
  8024c1:	68 7b 3b 80 00       	push   $0x803b7b
  8024c6:	68 c2 00 00 00       	push   $0xc2
  8024cb:	68 d3 3a 80 00       	push   $0x803ad3
  8024d0:	e8 aa dd ff ff       	call   80027f <_panic>
  8024d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d8:	8b 00                	mov    (%eax),%eax
  8024da:	85 c0                	test   %eax,%eax
  8024dc:	74 10                	je     8024ee <alloc_block_FF+0xff>
  8024de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e1:	8b 00                	mov    (%eax),%eax
  8024e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e6:	8b 52 04             	mov    0x4(%edx),%edx
  8024e9:	89 50 04             	mov    %edx,0x4(%eax)
  8024ec:	eb 0b                	jmp    8024f9 <alloc_block_FF+0x10a>
  8024ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f1:	8b 40 04             	mov    0x4(%eax),%eax
  8024f4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fc:	8b 40 04             	mov    0x4(%eax),%eax
  8024ff:	85 c0                	test   %eax,%eax
  802501:	74 0f                	je     802512 <alloc_block_FF+0x123>
  802503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802506:	8b 40 04             	mov    0x4(%eax),%eax
  802509:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80250c:	8b 12                	mov    (%edx),%edx
  80250e:	89 10                	mov    %edx,(%eax)
  802510:	eb 0a                	jmp    80251c <alloc_block_FF+0x12d>
  802512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802515:	8b 00                	mov    (%eax),%eax
  802517:	a3 48 41 80 00       	mov    %eax,0x804148
  80251c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802528:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252f:	a1 54 41 80 00       	mov    0x804154,%eax
  802534:	48                   	dec    %eax
  802535:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	8b 50 08             	mov    0x8(%eax),%edx
  802540:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802543:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802549:	8b 55 08             	mov    0x8(%ebp),%edx
  80254c:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 40 0c             	mov    0xc(%eax),%eax
  802555:	2b 45 08             	sub    0x8(%ebp),%eax
  802558:	89 c2                	mov    %eax,%edx
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 50 08             	mov    0x8(%eax),%edx
  802566:	8b 45 08             	mov    0x8(%ebp),%eax
  802569:	01 c2                	add    %eax,%edx
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802574:	eb 3b                	jmp    8025b1 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802576:	a1 40 41 80 00       	mov    0x804140,%eax
  80257b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802582:	74 07                	je     80258b <alloc_block_FF+0x19c>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 00                	mov    (%eax),%eax
  802589:	eb 05                	jmp    802590 <alloc_block_FF+0x1a1>
  80258b:	b8 00 00 00 00       	mov    $0x0,%eax
  802590:	a3 40 41 80 00       	mov    %eax,0x804140
  802595:	a1 40 41 80 00       	mov    0x804140,%eax
  80259a:	85 c0                	test   %eax,%eax
  80259c:	0f 85 60 fe ff ff    	jne    802402 <alloc_block_FF+0x13>
  8025a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a6:	0f 85 56 fe ff ff    	jne    802402 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8025ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b1:	c9                   	leave  
  8025b2:	c3                   	ret    

008025b3 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
  8025b6:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8025b9:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025c0:	a1 38 41 80 00       	mov    0x804138,%eax
  8025c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c8:	eb 3a                	jmp    802604 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d3:	72 27                	jb     8025fc <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8025d5:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8025d9:	75 0b                	jne    8025e6 <alloc_block_BF+0x33>
					best_size= element->size;
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8025e4:	eb 16                	jmp    8025fc <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8025ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ef:	39 c2                	cmp    %eax,%edx
  8025f1:	77 09                	ja     8025fc <alloc_block_BF+0x49>
					best_size=element->size;
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f9:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025fc:	a1 40 41 80 00       	mov    0x804140,%eax
  802601:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802604:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802608:	74 07                	je     802611 <alloc_block_BF+0x5e>
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 00                	mov    (%eax),%eax
  80260f:	eb 05                	jmp    802616 <alloc_block_BF+0x63>
  802611:	b8 00 00 00 00       	mov    $0x0,%eax
  802616:	a3 40 41 80 00       	mov    %eax,0x804140
  80261b:	a1 40 41 80 00       	mov    0x804140,%eax
  802620:	85 c0                	test   %eax,%eax
  802622:	75 a6                	jne    8025ca <alloc_block_BF+0x17>
  802624:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802628:	75 a0                	jne    8025ca <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80262a:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80262e:	0f 84 d3 01 00 00    	je     802807 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802634:	a1 38 41 80 00       	mov    0x804138,%eax
  802639:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263c:	e9 98 01 00 00       	jmp    8027d9 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802644:	3b 45 08             	cmp    0x8(%ebp),%eax
  802647:	0f 86 da 00 00 00    	jbe    802727 <alloc_block_BF+0x174>
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	8b 50 0c             	mov    0xc(%eax),%edx
  802653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802656:	39 c2                	cmp    %eax,%edx
  802658:	0f 85 c9 00 00 00    	jne    802727 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  80265e:	a1 48 41 80 00       	mov    0x804148,%eax
  802663:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802666:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80266a:	75 17                	jne    802683 <alloc_block_BF+0xd0>
  80266c:	83 ec 04             	sub    $0x4,%esp
  80266f:	68 7b 3b 80 00       	push   $0x803b7b
  802674:	68 ea 00 00 00       	push   $0xea
  802679:	68 d3 3a 80 00       	push   $0x803ad3
  80267e:	e8 fc db ff ff       	call   80027f <_panic>
  802683:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802686:	8b 00                	mov    (%eax),%eax
  802688:	85 c0                	test   %eax,%eax
  80268a:	74 10                	je     80269c <alloc_block_BF+0xe9>
  80268c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802694:	8b 52 04             	mov    0x4(%edx),%edx
  802697:	89 50 04             	mov    %edx,0x4(%eax)
  80269a:	eb 0b                	jmp    8026a7 <alloc_block_BF+0xf4>
  80269c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269f:	8b 40 04             	mov    0x4(%eax),%eax
  8026a2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026aa:	8b 40 04             	mov    0x4(%eax),%eax
  8026ad:	85 c0                	test   %eax,%eax
  8026af:	74 0f                	je     8026c0 <alloc_block_BF+0x10d>
  8026b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b4:	8b 40 04             	mov    0x4(%eax),%eax
  8026b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026ba:	8b 12                	mov    (%edx),%edx
  8026bc:	89 10                	mov    %edx,(%eax)
  8026be:	eb 0a                	jmp    8026ca <alloc_block_BF+0x117>
  8026c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c3:	8b 00                	mov    (%eax),%eax
  8026c5:	a3 48 41 80 00       	mov    %eax,0x804148
  8026ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026dd:	a1 54 41 80 00       	mov    0x804154,%eax
  8026e2:	48                   	dec    %eax
  8026e3:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	8b 50 08             	mov    0x8(%eax),%edx
  8026ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f1:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8026f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8026fa:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 40 0c             	mov    0xc(%eax),%eax
  802703:	2b 45 08             	sub    0x8(%ebp),%eax
  802706:	89 c2                	mov    %eax,%edx
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 50 08             	mov    0x8(%eax),%edx
  802714:	8b 45 08             	mov    0x8(%ebp),%eax
  802717:	01 c2                	add    %eax,%edx
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  80271f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802722:	e9 e5 00 00 00       	jmp    80280c <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 50 0c             	mov    0xc(%eax),%edx
  80272d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802730:	39 c2                	cmp    %eax,%edx
  802732:	0f 85 99 00 00 00    	jne    8027d1 <alloc_block_BF+0x21e>
  802738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80273e:	0f 85 8d 00 00 00    	jne    8027d1 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802744:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802747:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  80274a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274e:	75 17                	jne    802767 <alloc_block_BF+0x1b4>
  802750:	83 ec 04             	sub    $0x4,%esp
  802753:	68 7b 3b 80 00       	push   $0x803b7b
  802758:	68 f7 00 00 00       	push   $0xf7
  80275d:	68 d3 3a 80 00       	push   $0x803ad3
  802762:	e8 18 db ff ff       	call   80027f <_panic>
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 00                	mov    (%eax),%eax
  80276c:	85 c0                	test   %eax,%eax
  80276e:	74 10                	je     802780 <alloc_block_BF+0x1cd>
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 00                	mov    (%eax),%eax
  802775:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802778:	8b 52 04             	mov    0x4(%edx),%edx
  80277b:	89 50 04             	mov    %edx,0x4(%eax)
  80277e:	eb 0b                	jmp    80278b <alloc_block_BF+0x1d8>
  802780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802783:	8b 40 04             	mov    0x4(%eax),%eax
  802786:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 40 04             	mov    0x4(%eax),%eax
  802791:	85 c0                	test   %eax,%eax
  802793:	74 0f                	je     8027a4 <alloc_block_BF+0x1f1>
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	8b 40 04             	mov    0x4(%eax),%eax
  80279b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80279e:	8b 12                	mov    (%edx),%edx
  8027a0:	89 10                	mov    %edx,(%eax)
  8027a2:	eb 0a                	jmp    8027ae <alloc_block_BF+0x1fb>
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	a3 38 41 80 00       	mov    %eax,0x804138
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c1:	a1 44 41 80 00       	mov    0x804144,%eax
  8027c6:	48                   	dec    %eax
  8027c7:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8027cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cf:	eb 3b                	jmp    80280c <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8027d1:	a1 40 41 80 00       	mov    0x804140,%eax
  8027d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027dd:	74 07                	je     8027e6 <alloc_block_BF+0x233>
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	eb 05                	jmp    8027eb <alloc_block_BF+0x238>
  8027e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027eb:	a3 40 41 80 00       	mov    %eax,0x804140
  8027f0:	a1 40 41 80 00       	mov    0x804140,%eax
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	0f 85 44 fe ff ff    	jne    802641 <alloc_block_BF+0x8e>
  8027fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802801:	0f 85 3a fe ff ff    	jne    802641 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802807:	b8 00 00 00 00       	mov    $0x0,%eax
  80280c:	c9                   	leave  
  80280d:	c3                   	ret    

0080280e <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80280e:	55                   	push   %ebp
  80280f:	89 e5                	mov    %esp,%ebp
  802811:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802814:	83 ec 04             	sub    $0x4,%esp
  802817:	68 9c 3b 80 00       	push   $0x803b9c
  80281c:	68 04 01 00 00       	push   $0x104
  802821:	68 d3 3a 80 00       	push   $0x803ad3
  802826:	e8 54 da ff ff       	call   80027f <_panic>

0080282b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80282b:	55                   	push   %ebp
  80282c:	89 e5                	mov    %esp,%ebp
  80282e:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802831:	a1 38 41 80 00       	mov    0x804138,%eax
  802836:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802839:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80283e:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802841:	a1 38 41 80 00       	mov    0x804138,%eax
  802846:	85 c0                	test   %eax,%eax
  802848:	75 68                	jne    8028b2 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80284a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80284e:	75 17                	jne    802867 <insert_sorted_with_merge_freeList+0x3c>
  802850:	83 ec 04             	sub    $0x4,%esp
  802853:	68 b0 3a 80 00       	push   $0x803ab0
  802858:	68 14 01 00 00       	push   $0x114
  80285d:	68 d3 3a 80 00       	push   $0x803ad3
  802862:	e8 18 da ff ff       	call   80027f <_panic>
  802867:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	89 10                	mov    %edx,(%eax)
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	8b 00                	mov    (%eax),%eax
  802877:	85 c0                	test   %eax,%eax
  802879:	74 0d                	je     802888 <insert_sorted_with_merge_freeList+0x5d>
  80287b:	a1 38 41 80 00       	mov    0x804138,%eax
  802880:	8b 55 08             	mov    0x8(%ebp),%edx
  802883:	89 50 04             	mov    %edx,0x4(%eax)
  802886:	eb 08                	jmp    802890 <insert_sorted_with_merge_freeList+0x65>
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	a3 38 41 80 00       	mov    %eax,0x804138
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a2:	a1 44 41 80 00       	mov    0x804144,%eax
  8028a7:	40                   	inc    %eax
  8028a8:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8028ad:	e9 d2 06 00 00       	jmp    802f84 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8028b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b5:	8b 50 08             	mov    0x8(%eax),%edx
  8028b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bb:	8b 40 08             	mov    0x8(%eax),%eax
  8028be:	39 c2                	cmp    %eax,%edx
  8028c0:	0f 83 22 01 00 00    	jae    8029e8 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8028c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c9:	8b 50 08             	mov    0x8(%eax),%edx
  8028cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d2:	01 c2                	add    %eax,%edx
  8028d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d7:	8b 40 08             	mov    0x8(%eax),%eax
  8028da:	39 c2                	cmp    %eax,%edx
  8028dc:	0f 85 9e 00 00 00    	jne    802980 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	8b 50 08             	mov    0x8(%eax),%edx
  8028e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028eb:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8028ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fa:	01 c2                	add    %eax,%edx
  8028fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ff:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802902:	8b 45 08             	mov    0x8(%ebp),%eax
  802905:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80290c:	8b 45 08             	mov    0x8(%ebp),%eax
  80290f:	8b 50 08             	mov    0x8(%eax),%edx
  802912:	8b 45 08             	mov    0x8(%ebp),%eax
  802915:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802918:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80291c:	75 17                	jne    802935 <insert_sorted_with_merge_freeList+0x10a>
  80291e:	83 ec 04             	sub    $0x4,%esp
  802921:	68 b0 3a 80 00       	push   $0x803ab0
  802926:	68 21 01 00 00       	push   $0x121
  80292b:	68 d3 3a 80 00       	push   $0x803ad3
  802930:	e8 4a d9 ff ff       	call   80027f <_panic>
  802935:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	89 10                	mov    %edx,(%eax)
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	8b 00                	mov    (%eax),%eax
  802945:	85 c0                	test   %eax,%eax
  802947:	74 0d                	je     802956 <insert_sorted_with_merge_freeList+0x12b>
  802949:	a1 48 41 80 00       	mov    0x804148,%eax
  80294e:	8b 55 08             	mov    0x8(%ebp),%edx
  802951:	89 50 04             	mov    %edx,0x4(%eax)
  802954:	eb 08                	jmp    80295e <insert_sorted_with_merge_freeList+0x133>
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	a3 48 41 80 00       	mov    %eax,0x804148
  802966:	8b 45 08             	mov    0x8(%ebp),%eax
  802969:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802970:	a1 54 41 80 00       	mov    0x804154,%eax
  802975:	40                   	inc    %eax
  802976:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  80297b:	e9 04 06 00 00       	jmp    802f84 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802980:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802984:	75 17                	jne    80299d <insert_sorted_with_merge_freeList+0x172>
  802986:	83 ec 04             	sub    $0x4,%esp
  802989:	68 b0 3a 80 00       	push   $0x803ab0
  80298e:	68 26 01 00 00       	push   $0x126
  802993:	68 d3 3a 80 00       	push   $0x803ad3
  802998:	e8 e2 d8 ff ff       	call   80027f <_panic>
  80299d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a6:	89 10                	mov    %edx,(%eax)
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	8b 00                	mov    (%eax),%eax
  8029ad:	85 c0                	test   %eax,%eax
  8029af:	74 0d                	je     8029be <insert_sorted_with_merge_freeList+0x193>
  8029b1:	a1 38 41 80 00       	mov    0x804138,%eax
  8029b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b9:	89 50 04             	mov    %edx,0x4(%eax)
  8029bc:	eb 08                	jmp    8029c6 <insert_sorted_with_merge_freeList+0x19b>
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	a3 38 41 80 00       	mov    %eax,0x804138
  8029ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d8:	a1 44 41 80 00       	mov    0x804144,%eax
  8029dd:	40                   	inc    %eax
  8029de:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8029e3:	e9 9c 05 00 00       	jmp    802f84 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	8b 50 08             	mov    0x8(%eax),%edx
  8029ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f1:	8b 40 08             	mov    0x8(%eax),%eax
  8029f4:	39 c2                	cmp    %eax,%edx
  8029f6:	0f 86 16 01 00 00    	jbe    802b12 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  8029fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ff:	8b 50 08             	mov    0x8(%eax),%edx
  802a02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a05:	8b 40 0c             	mov    0xc(%eax),%eax
  802a08:	01 c2                	add    %eax,%edx
  802a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0d:	8b 40 08             	mov    0x8(%eax),%eax
  802a10:	39 c2                	cmp    %eax,%edx
  802a12:	0f 85 92 00 00 00    	jne    802aaa <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1b:	8b 50 0c             	mov    0xc(%eax),%edx
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	8b 40 0c             	mov    0xc(%eax),%eax
  802a24:	01 c2                	add    %eax,%edx
  802a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a29:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	8b 50 08             	mov    0x8(%eax),%edx
  802a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3f:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a46:	75 17                	jne    802a5f <insert_sorted_with_merge_freeList+0x234>
  802a48:	83 ec 04             	sub    $0x4,%esp
  802a4b:	68 b0 3a 80 00       	push   $0x803ab0
  802a50:	68 31 01 00 00       	push   $0x131
  802a55:	68 d3 3a 80 00       	push   $0x803ad3
  802a5a:	e8 20 d8 ff ff       	call   80027f <_panic>
  802a5f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	89 10                	mov    %edx,(%eax)
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	8b 00                	mov    (%eax),%eax
  802a6f:	85 c0                	test   %eax,%eax
  802a71:	74 0d                	je     802a80 <insert_sorted_with_merge_freeList+0x255>
  802a73:	a1 48 41 80 00       	mov    0x804148,%eax
  802a78:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7b:	89 50 04             	mov    %edx,0x4(%eax)
  802a7e:	eb 08                	jmp    802a88 <insert_sorted_with_merge_freeList+0x25d>
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	a3 48 41 80 00       	mov    %eax,0x804148
  802a90:	8b 45 08             	mov    0x8(%ebp),%eax
  802a93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9a:	a1 54 41 80 00       	mov    0x804154,%eax
  802a9f:	40                   	inc    %eax
  802aa0:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802aa5:	e9 da 04 00 00       	jmp    802f84 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802aaa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aae:	75 17                	jne    802ac7 <insert_sorted_with_merge_freeList+0x29c>
  802ab0:	83 ec 04             	sub    $0x4,%esp
  802ab3:	68 58 3b 80 00       	push   $0x803b58
  802ab8:	68 37 01 00 00       	push   $0x137
  802abd:	68 d3 3a 80 00       	push   $0x803ad3
  802ac2:	e8 b8 d7 ff ff       	call   80027f <_panic>
  802ac7:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	89 50 04             	mov    %edx,0x4(%eax)
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	8b 40 04             	mov    0x4(%eax),%eax
  802ad9:	85 c0                	test   %eax,%eax
  802adb:	74 0c                	je     802ae9 <insert_sorted_with_merge_freeList+0x2be>
  802add:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ae2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae5:	89 10                	mov    %edx,(%eax)
  802ae7:	eb 08                	jmp    802af1 <insert_sorted_with_merge_freeList+0x2c6>
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	a3 38 41 80 00       	mov    %eax,0x804138
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802af9:	8b 45 08             	mov    0x8(%ebp),%eax
  802afc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b02:	a1 44 41 80 00       	mov    0x804144,%eax
  802b07:	40                   	inc    %eax
  802b08:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b0d:	e9 72 04 00 00       	jmp    802f84 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802b12:	a1 38 41 80 00       	mov    0x804138,%eax
  802b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1a:	e9 35 04 00 00       	jmp    802f54 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 00                	mov    (%eax),%eax
  802b24:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	8b 50 08             	mov    0x8(%eax),%edx
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	8b 40 08             	mov    0x8(%eax),%eax
  802b33:	39 c2                	cmp    %eax,%edx
  802b35:	0f 86 11 04 00 00    	jbe    802f4c <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	8b 50 08             	mov    0x8(%eax),%edx
  802b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b44:	8b 40 0c             	mov    0xc(%eax),%eax
  802b47:	01 c2                	add    %eax,%edx
  802b49:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4c:	8b 40 08             	mov    0x8(%eax),%eax
  802b4f:	39 c2                	cmp    %eax,%edx
  802b51:	0f 83 8b 00 00 00    	jae    802be2 <insert_sorted_with_merge_freeList+0x3b7>
  802b57:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5a:	8b 50 08             	mov    0x8(%eax),%edx
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	8b 40 0c             	mov    0xc(%eax),%eax
  802b63:	01 c2                	add    %eax,%edx
  802b65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b68:	8b 40 08             	mov    0x8(%eax),%eax
  802b6b:	39 c2                	cmp    %eax,%edx
  802b6d:	73 73                	jae    802be2 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802b6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b73:	74 06                	je     802b7b <insert_sorted_with_merge_freeList+0x350>
  802b75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b79:	75 17                	jne    802b92 <insert_sorted_with_merge_freeList+0x367>
  802b7b:	83 ec 04             	sub    $0x4,%esp
  802b7e:	68 24 3b 80 00       	push   $0x803b24
  802b83:	68 48 01 00 00       	push   $0x148
  802b88:	68 d3 3a 80 00       	push   $0x803ad3
  802b8d:	e8 ed d6 ff ff       	call   80027f <_panic>
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 10                	mov    (%eax),%edx
  802b97:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9a:	89 10                	mov    %edx,(%eax)
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	74 0b                	je     802bb0 <insert_sorted_with_merge_freeList+0x385>
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	8b 55 08             	mov    0x8(%ebp),%edx
  802bad:	89 50 04             	mov    %edx,0x4(%eax)
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb6:	89 10                	mov    %edx,(%eax)
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbe:	89 50 04             	mov    %edx,0x4(%eax)
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	85 c0                	test   %eax,%eax
  802bc8:	75 08                	jne    802bd2 <insert_sorted_with_merge_freeList+0x3a7>
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bd2:	a1 44 41 80 00       	mov    0x804144,%eax
  802bd7:	40                   	inc    %eax
  802bd8:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802bdd:	e9 a2 03 00 00       	jmp    802f84 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802be2:	8b 45 08             	mov    0x8(%ebp),%eax
  802be5:	8b 50 08             	mov    0x8(%eax),%edx
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bee:	01 c2                	add    %eax,%edx
  802bf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf3:	8b 40 08             	mov    0x8(%eax),%eax
  802bf6:	39 c2                	cmp    %eax,%edx
  802bf8:	0f 83 ae 00 00 00    	jae    802cac <insert_sorted_with_merge_freeList+0x481>
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	8b 50 08             	mov    0x8(%eax),%edx
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 48 08             	mov    0x8(%eax),%ecx
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c10:	01 c8                	add    %ecx,%eax
  802c12:	39 c2                	cmp    %eax,%edx
  802c14:	0f 85 92 00 00 00    	jne    802cac <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 50 0c             	mov    0xc(%eax),%edx
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	8b 40 0c             	mov    0xc(%eax),%eax
  802c26:	01 c2                	add    %eax,%edx
  802c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2b:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	8b 50 08             	mov    0x8(%eax),%edx
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c48:	75 17                	jne    802c61 <insert_sorted_with_merge_freeList+0x436>
  802c4a:	83 ec 04             	sub    $0x4,%esp
  802c4d:	68 b0 3a 80 00       	push   $0x803ab0
  802c52:	68 51 01 00 00       	push   $0x151
  802c57:	68 d3 3a 80 00       	push   $0x803ad3
  802c5c:	e8 1e d6 ff ff       	call   80027f <_panic>
  802c61:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c67:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6a:	89 10                	mov    %edx,(%eax)
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	8b 00                	mov    (%eax),%eax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	74 0d                	je     802c82 <insert_sorted_with_merge_freeList+0x457>
  802c75:	a1 48 41 80 00       	mov    0x804148,%eax
  802c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7d:	89 50 04             	mov    %edx,0x4(%eax)
  802c80:	eb 08                	jmp    802c8a <insert_sorted_with_merge_freeList+0x45f>
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	a3 48 41 80 00       	mov    %eax,0x804148
  802c92:	8b 45 08             	mov    0x8(%ebp),%eax
  802c95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9c:	a1 54 41 80 00       	mov    0x804154,%eax
  802ca1:	40                   	inc    %eax
  802ca2:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802ca7:	e9 d8 02 00 00       	jmp    802f84 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	8b 50 08             	mov    0x8(%eax),%edx
  802cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb8:	01 c2                	add    %eax,%edx
  802cba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cbd:	8b 40 08             	mov    0x8(%eax),%eax
  802cc0:	39 c2                	cmp    %eax,%edx
  802cc2:	0f 85 ba 00 00 00    	jne    802d82 <insert_sorted_with_merge_freeList+0x557>
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	8b 50 08             	mov    0x8(%eax),%edx
  802cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd1:	8b 48 08             	mov    0x8(%eax),%ecx
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802cda:	01 c8                	add    %ecx,%eax
  802cdc:	39 c2                	cmp    %eax,%edx
  802cde:	0f 86 9e 00 00 00    	jbe    802d82 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802ce4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce7:	8b 50 0c             	mov    0xc(%eax),%edx
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf0:	01 c2                	add    %eax,%edx
  802cf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf5:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	8b 50 08             	mov    0x8(%eax),%edx
  802cfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d01:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	8b 50 08             	mov    0x8(%eax),%edx
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d1e:	75 17                	jne    802d37 <insert_sorted_with_merge_freeList+0x50c>
  802d20:	83 ec 04             	sub    $0x4,%esp
  802d23:	68 b0 3a 80 00       	push   $0x803ab0
  802d28:	68 5b 01 00 00       	push   $0x15b
  802d2d:	68 d3 3a 80 00       	push   $0x803ad3
  802d32:	e8 48 d5 ff ff       	call   80027f <_panic>
  802d37:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d40:	89 10                	mov    %edx,(%eax)
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	8b 00                	mov    (%eax),%eax
  802d47:	85 c0                	test   %eax,%eax
  802d49:	74 0d                	je     802d58 <insert_sorted_with_merge_freeList+0x52d>
  802d4b:	a1 48 41 80 00       	mov    0x804148,%eax
  802d50:	8b 55 08             	mov    0x8(%ebp),%edx
  802d53:	89 50 04             	mov    %edx,0x4(%eax)
  802d56:	eb 08                	jmp    802d60 <insert_sorted_with_merge_freeList+0x535>
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	a3 48 41 80 00       	mov    %eax,0x804148
  802d68:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d72:	a1 54 41 80 00       	mov    0x804154,%eax
  802d77:	40                   	inc    %eax
  802d78:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802d7d:	e9 02 02 00 00       	jmp    802f84 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	8b 50 08             	mov    0x8(%eax),%edx
  802d88:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8e:	01 c2                	add    %eax,%edx
  802d90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d93:	8b 40 08             	mov    0x8(%eax),%eax
  802d96:	39 c2                	cmp    %eax,%edx
  802d98:	0f 85 ae 01 00 00    	jne    802f4c <insert_sorted_with_merge_freeList+0x721>
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	8b 50 08             	mov    0x8(%eax),%edx
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 48 08             	mov    0x8(%eax),%ecx
  802daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dad:	8b 40 0c             	mov    0xc(%eax),%eax
  802db0:	01 c8                	add    %ecx,%eax
  802db2:	39 c2                	cmp    %eax,%edx
  802db4:	0f 85 92 01 00 00    	jne    802f4c <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc6:	01 c2                	add    %eax,%edx
  802dc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dcb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dce:	01 c2                	add    %eax,%edx
  802dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd3:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	8b 50 08             	mov    0x8(%eax),%edx
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802dec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802def:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802df6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df9:	8b 50 08             	mov    0x8(%eax),%edx
  802dfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dff:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802e02:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e06:	75 17                	jne    802e1f <insert_sorted_with_merge_freeList+0x5f4>
  802e08:	83 ec 04             	sub    $0x4,%esp
  802e0b:	68 7b 3b 80 00       	push   $0x803b7b
  802e10:	68 63 01 00 00       	push   $0x163
  802e15:	68 d3 3a 80 00       	push   $0x803ad3
  802e1a:	e8 60 d4 ff ff       	call   80027f <_panic>
  802e1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e22:	8b 00                	mov    (%eax),%eax
  802e24:	85 c0                	test   %eax,%eax
  802e26:	74 10                	je     802e38 <insert_sorted_with_merge_freeList+0x60d>
  802e28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2b:	8b 00                	mov    (%eax),%eax
  802e2d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e30:	8b 52 04             	mov    0x4(%edx),%edx
  802e33:	89 50 04             	mov    %edx,0x4(%eax)
  802e36:	eb 0b                	jmp    802e43 <insert_sorted_with_merge_freeList+0x618>
  802e38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3b:	8b 40 04             	mov    0x4(%eax),%eax
  802e3e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e46:	8b 40 04             	mov    0x4(%eax),%eax
  802e49:	85 c0                	test   %eax,%eax
  802e4b:	74 0f                	je     802e5c <insert_sorted_with_merge_freeList+0x631>
  802e4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e50:	8b 40 04             	mov    0x4(%eax),%eax
  802e53:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e56:	8b 12                	mov    (%edx),%edx
  802e58:	89 10                	mov    %edx,(%eax)
  802e5a:	eb 0a                	jmp    802e66 <insert_sorted_with_merge_freeList+0x63b>
  802e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5f:	8b 00                	mov    (%eax),%eax
  802e61:	a3 38 41 80 00       	mov    %eax,0x804138
  802e66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e79:	a1 44 41 80 00       	mov    0x804144,%eax
  802e7e:	48                   	dec    %eax
  802e7f:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802e84:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e88:	75 17                	jne    802ea1 <insert_sorted_with_merge_freeList+0x676>
  802e8a:	83 ec 04             	sub    $0x4,%esp
  802e8d:	68 b0 3a 80 00       	push   $0x803ab0
  802e92:	68 64 01 00 00       	push   $0x164
  802e97:	68 d3 3a 80 00       	push   $0x803ad3
  802e9c:	e8 de d3 ff ff       	call   80027f <_panic>
  802ea1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ea7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eaa:	89 10                	mov    %edx,(%eax)
  802eac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eaf:	8b 00                	mov    (%eax),%eax
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	74 0d                	je     802ec2 <insert_sorted_with_merge_freeList+0x697>
  802eb5:	a1 48 41 80 00       	mov    0x804148,%eax
  802eba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ebd:	89 50 04             	mov    %edx,0x4(%eax)
  802ec0:	eb 08                	jmp    802eca <insert_sorted_with_merge_freeList+0x69f>
  802ec2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ecd:	a3 48 41 80 00       	mov    %eax,0x804148
  802ed2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802edc:	a1 54 41 80 00       	mov    0x804154,%eax
  802ee1:	40                   	inc    %eax
  802ee2:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802ee7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eeb:	75 17                	jne    802f04 <insert_sorted_with_merge_freeList+0x6d9>
  802eed:	83 ec 04             	sub    $0x4,%esp
  802ef0:	68 b0 3a 80 00       	push   $0x803ab0
  802ef5:	68 65 01 00 00       	push   $0x165
  802efa:	68 d3 3a 80 00       	push   $0x803ad3
  802eff:	e8 7b d3 ff ff       	call   80027f <_panic>
  802f04:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0d:	89 10                	mov    %edx,(%eax)
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	8b 00                	mov    (%eax),%eax
  802f14:	85 c0                	test   %eax,%eax
  802f16:	74 0d                	je     802f25 <insert_sorted_with_merge_freeList+0x6fa>
  802f18:	a1 48 41 80 00       	mov    0x804148,%eax
  802f1d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f20:	89 50 04             	mov    %edx,0x4(%eax)
  802f23:	eb 08                	jmp    802f2d <insert_sorted_with_merge_freeList+0x702>
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	a3 48 41 80 00       	mov    %eax,0x804148
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3f:	a1 54 41 80 00       	mov    0x804154,%eax
  802f44:	40                   	inc    %eax
  802f45:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802f4a:	eb 38                	jmp    802f84 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f4c:	a1 40 41 80 00       	mov    0x804140,%eax
  802f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f58:	74 07                	je     802f61 <insert_sorted_with_merge_freeList+0x736>
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	8b 00                	mov    (%eax),%eax
  802f5f:	eb 05                	jmp    802f66 <insert_sorted_with_merge_freeList+0x73b>
  802f61:	b8 00 00 00 00       	mov    $0x0,%eax
  802f66:	a3 40 41 80 00       	mov    %eax,0x804140
  802f6b:	a1 40 41 80 00       	mov    0x804140,%eax
  802f70:	85 c0                	test   %eax,%eax
  802f72:	0f 85 a7 fb ff ff    	jne    802b1f <insert_sorted_with_merge_freeList+0x2f4>
  802f78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7c:	0f 85 9d fb ff ff    	jne    802b1f <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802f82:	eb 00                	jmp    802f84 <insert_sorted_with_merge_freeList+0x759>
  802f84:	90                   	nop
  802f85:	c9                   	leave  
  802f86:	c3                   	ret    
  802f87:	90                   	nop

00802f88 <__udivdi3>:
  802f88:	55                   	push   %ebp
  802f89:	57                   	push   %edi
  802f8a:	56                   	push   %esi
  802f8b:	53                   	push   %ebx
  802f8c:	83 ec 1c             	sub    $0x1c,%esp
  802f8f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f93:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f97:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f9f:	89 ca                	mov    %ecx,%edx
  802fa1:	89 f8                	mov    %edi,%eax
  802fa3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802fa7:	85 f6                	test   %esi,%esi
  802fa9:	75 2d                	jne    802fd8 <__udivdi3+0x50>
  802fab:	39 cf                	cmp    %ecx,%edi
  802fad:	77 65                	ja     803014 <__udivdi3+0x8c>
  802faf:	89 fd                	mov    %edi,%ebp
  802fb1:	85 ff                	test   %edi,%edi
  802fb3:	75 0b                	jne    802fc0 <__udivdi3+0x38>
  802fb5:	b8 01 00 00 00       	mov    $0x1,%eax
  802fba:	31 d2                	xor    %edx,%edx
  802fbc:	f7 f7                	div    %edi
  802fbe:	89 c5                	mov    %eax,%ebp
  802fc0:	31 d2                	xor    %edx,%edx
  802fc2:	89 c8                	mov    %ecx,%eax
  802fc4:	f7 f5                	div    %ebp
  802fc6:	89 c1                	mov    %eax,%ecx
  802fc8:	89 d8                	mov    %ebx,%eax
  802fca:	f7 f5                	div    %ebp
  802fcc:	89 cf                	mov    %ecx,%edi
  802fce:	89 fa                	mov    %edi,%edx
  802fd0:	83 c4 1c             	add    $0x1c,%esp
  802fd3:	5b                   	pop    %ebx
  802fd4:	5e                   	pop    %esi
  802fd5:	5f                   	pop    %edi
  802fd6:	5d                   	pop    %ebp
  802fd7:	c3                   	ret    
  802fd8:	39 ce                	cmp    %ecx,%esi
  802fda:	77 28                	ja     803004 <__udivdi3+0x7c>
  802fdc:	0f bd fe             	bsr    %esi,%edi
  802fdf:	83 f7 1f             	xor    $0x1f,%edi
  802fe2:	75 40                	jne    803024 <__udivdi3+0x9c>
  802fe4:	39 ce                	cmp    %ecx,%esi
  802fe6:	72 0a                	jb     802ff2 <__udivdi3+0x6a>
  802fe8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802fec:	0f 87 9e 00 00 00    	ja     803090 <__udivdi3+0x108>
  802ff2:	b8 01 00 00 00       	mov    $0x1,%eax
  802ff7:	89 fa                	mov    %edi,%edx
  802ff9:	83 c4 1c             	add    $0x1c,%esp
  802ffc:	5b                   	pop    %ebx
  802ffd:	5e                   	pop    %esi
  802ffe:	5f                   	pop    %edi
  802fff:	5d                   	pop    %ebp
  803000:	c3                   	ret    
  803001:	8d 76 00             	lea    0x0(%esi),%esi
  803004:	31 ff                	xor    %edi,%edi
  803006:	31 c0                	xor    %eax,%eax
  803008:	89 fa                	mov    %edi,%edx
  80300a:	83 c4 1c             	add    $0x1c,%esp
  80300d:	5b                   	pop    %ebx
  80300e:	5e                   	pop    %esi
  80300f:	5f                   	pop    %edi
  803010:	5d                   	pop    %ebp
  803011:	c3                   	ret    
  803012:	66 90                	xchg   %ax,%ax
  803014:	89 d8                	mov    %ebx,%eax
  803016:	f7 f7                	div    %edi
  803018:	31 ff                	xor    %edi,%edi
  80301a:	89 fa                	mov    %edi,%edx
  80301c:	83 c4 1c             	add    $0x1c,%esp
  80301f:	5b                   	pop    %ebx
  803020:	5e                   	pop    %esi
  803021:	5f                   	pop    %edi
  803022:	5d                   	pop    %ebp
  803023:	c3                   	ret    
  803024:	bd 20 00 00 00       	mov    $0x20,%ebp
  803029:	89 eb                	mov    %ebp,%ebx
  80302b:	29 fb                	sub    %edi,%ebx
  80302d:	89 f9                	mov    %edi,%ecx
  80302f:	d3 e6                	shl    %cl,%esi
  803031:	89 c5                	mov    %eax,%ebp
  803033:	88 d9                	mov    %bl,%cl
  803035:	d3 ed                	shr    %cl,%ebp
  803037:	89 e9                	mov    %ebp,%ecx
  803039:	09 f1                	or     %esi,%ecx
  80303b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80303f:	89 f9                	mov    %edi,%ecx
  803041:	d3 e0                	shl    %cl,%eax
  803043:	89 c5                	mov    %eax,%ebp
  803045:	89 d6                	mov    %edx,%esi
  803047:	88 d9                	mov    %bl,%cl
  803049:	d3 ee                	shr    %cl,%esi
  80304b:	89 f9                	mov    %edi,%ecx
  80304d:	d3 e2                	shl    %cl,%edx
  80304f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803053:	88 d9                	mov    %bl,%cl
  803055:	d3 e8                	shr    %cl,%eax
  803057:	09 c2                	or     %eax,%edx
  803059:	89 d0                	mov    %edx,%eax
  80305b:	89 f2                	mov    %esi,%edx
  80305d:	f7 74 24 0c          	divl   0xc(%esp)
  803061:	89 d6                	mov    %edx,%esi
  803063:	89 c3                	mov    %eax,%ebx
  803065:	f7 e5                	mul    %ebp
  803067:	39 d6                	cmp    %edx,%esi
  803069:	72 19                	jb     803084 <__udivdi3+0xfc>
  80306b:	74 0b                	je     803078 <__udivdi3+0xf0>
  80306d:	89 d8                	mov    %ebx,%eax
  80306f:	31 ff                	xor    %edi,%edi
  803071:	e9 58 ff ff ff       	jmp    802fce <__udivdi3+0x46>
  803076:	66 90                	xchg   %ax,%ax
  803078:	8b 54 24 08          	mov    0x8(%esp),%edx
  80307c:	89 f9                	mov    %edi,%ecx
  80307e:	d3 e2                	shl    %cl,%edx
  803080:	39 c2                	cmp    %eax,%edx
  803082:	73 e9                	jae    80306d <__udivdi3+0xe5>
  803084:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803087:	31 ff                	xor    %edi,%edi
  803089:	e9 40 ff ff ff       	jmp    802fce <__udivdi3+0x46>
  80308e:	66 90                	xchg   %ax,%ax
  803090:	31 c0                	xor    %eax,%eax
  803092:	e9 37 ff ff ff       	jmp    802fce <__udivdi3+0x46>
  803097:	90                   	nop

00803098 <__umoddi3>:
  803098:	55                   	push   %ebp
  803099:	57                   	push   %edi
  80309a:	56                   	push   %esi
  80309b:	53                   	push   %ebx
  80309c:	83 ec 1c             	sub    $0x1c,%esp
  80309f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8030a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030b7:	89 f3                	mov    %esi,%ebx
  8030b9:	89 fa                	mov    %edi,%edx
  8030bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030bf:	89 34 24             	mov    %esi,(%esp)
  8030c2:	85 c0                	test   %eax,%eax
  8030c4:	75 1a                	jne    8030e0 <__umoddi3+0x48>
  8030c6:	39 f7                	cmp    %esi,%edi
  8030c8:	0f 86 a2 00 00 00    	jbe    803170 <__umoddi3+0xd8>
  8030ce:	89 c8                	mov    %ecx,%eax
  8030d0:	89 f2                	mov    %esi,%edx
  8030d2:	f7 f7                	div    %edi
  8030d4:	89 d0                	mov    %edx,%eax
  8030d6:	31 d2                	xor    %edx,%edx
  8030d8:	83 c4 1c             	add    $0x1c,%esp
  8030db:	5b                   	pop    %ebx
  8030dc:	5e                   	pop    %esi
  8030dd:	5f                   	pop    %edi
  8030de:	5d                   	pop    %ebp
  8030df:	c3                   	ret    
  8030e0:	39 f0                	cmp    %esi,%eax
  8030e2:	0f 87 ac 00 00 00    	ja     803194 <__umoddi3+0xfc>
  8030e8:	0f bd e8             	bsr    %eax,%ebp
  8030eb:	83 f5 1f             	xor    $0x1f,%ebp
  8030ee:	0f 84 ac 00 00 00    	je     8031a0 <__umoddi3+0x108>
  8030f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8030f9:	29 ef                	sub    %ebp,%edi
  8030fb:	89 fe                	mov    %edi,%esi
  8030fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803101:	89 e9                	mov    %ebp,%ecx
  803103:	d3 e0                	shl    %cl,%eax
  803105:	89 d7                	mov    %edx,%edi
  803107:	89 f1                	mov    %esi,%ecx
  803109:	d3 ef                	shr    %cl,%edi
  80310b:	09 c7                	or     %eax,%edi
  80310d:	89 e9                	mov    %ebp,%ecx
  80310f:	d3 e2                	shl    %cl,%edx
  803111:	89 14 24             	mov    %edx,(%esp)
  803114:	89 d8                	mov    %ebx,%eax
  803116:	d3 e0                	shl    %cl,%eax
  803118:	89 c2                	mov    %eax,%edx
  80311a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80311e:	d3 e0                	shl    %cl,%eax
  803120:	89 44 24 04          	mov    %eax,0x4(%esp)
  803124:	8b 44 24 08          	mov    0x8(%esp),%eax
  803128:	89 f1                	mov    %esi,%ecx
  80312a:	d3 e8                	shr    %cl,%eax
  80312c:	09 d0                	or     %edx,%eax
  80312e:	d3 eb                	shr    %cl,%ebx
  803130:	89 da                	mov    %ebx,%edx
  803132:	f7 f7                	div    %edi
  803134:	89 d3                	mov    %edx,%ebx
  803136:	f7 24 24             	mull   (%esp)
  803139:	89 c6                	mov    %eax,%esi
  80313b:	89 d1                	mov    %edx,%ecx
  80313d:	39 d3                	cmp    %edx,%ebx
  80313f:	0f 82 87 00 00 00    	jb     8031cc <__umoddi3+0x134>
  803145:	0f 84 91 00 00 00    	je     8031dc <__umoddi3+0x144>
  80314b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80314f:	29 f2                	sub    %esi,%edx
  803151:	19 cb                	sbb    %ecx,%ebx
  803153:	89 d8                	mov    %ebx,%eax
  803155:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803159:	d3 e0                	shl    %cl,%eax
  80315b:	89 e9                	mov    %ebp,%ecx
  80315d:	d3 ea                	shr    %cl,%edx
  80315f:	09 d0                	or     %edx,%eax
  803161:	89 e9                	mov    %ebp,%ecx
  803163:	d3 eb                	shr    %cl,%ebx
  803165:	89 da                	mov    %ebx,%edx
  803167:	83 c4 1c             	add    $0x1c,%esp
  80316a:	5b                   	pop    %ebx
  80316b:	5e                   	pop    %esi
  80316c:	5f                   	pop    %edi
  80316d:	5d                   	pop    %ebp
  80316e:	c3                   	ret    
  80316f:	90                   	nop
  803170:	89 fd                	mov    %edi,%ebp
  803172:	85 ff                	test   %edi,%edi
  803174:	75 0b                	jne    803181 <__umoddi3+0xe9>
  803176:	b8 01 00 00 00       	mov    $0x1,%eax
  80317b:	31 d2                	xor    %edx,%edx
  80317d:	f7 f7                	div    %edi
  80317f:	89 c5                	mov    %eax,%ebp
  803181:	89 f0                	mov    %esi,%eax
  803183:	31 d2                	xor    %edx,%edx
  803185:	f7 f5                	div    %ebp
  803187:	89 c8                	mov    %ecx,%eax
  803189:	f7 f5                	div    %ebp
  80318b:	89 d0                	mov    %edx,%eax
  80318d:	e9 44 ff ff ff       	jmp    8030d6 <__umoddi3+0x3e>
  803192:	66 90                	xchg   %ax,%ax
  803194:	89 c8                	mov    %ecx,%eax
  803196:	89 f2                	mov    %esi,%edx
  803198:	83 c4 1c             	add    $0x1c,%esp
  80319b:	5b                   	pop    %ebx
  80319c:	5e                   	pop    %esi
  80319d:	5f                   	pop    %edi
  80319e:	5d                   	pop    %ebp
  80319f:	c3                   	ret    
  8031a0:	3b 04 24             	cmp    (%esp),%eax
  8031a3:	72 06                	jb     8031ab <__umoddi3+0x113>
  8031a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8031a9:	77 0f                	ja     8031ba <__umoddi3+0x122>
  8031ab:	89 f2                	mov    %esi,%edx
  8031ad:	29 f9                	sub    %edi,%ecx
  8031af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031b3:	89 14 24             	mov    %edx,(%esp)
  8031b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031be:	8b 14 24             	mov    (%esp),%edx
  8031c1:	83 c4 1c             	add    $0x1c,%esp
  8031c4:	5b                   	pop    %ebx
  8031c5:	5e                   	pop    %esi
  8031c6:	5f                   	pop    %edi
  8031c7:	5d                   	pop    %ebp
  8031c8:	c3                   	ret    
  8031c9:	8d 76 00             	lea    0x0(%esi),%esi
  8031cc:	2b 04 24             	sub    (%esp),%eax
  8031cf:	19 fa                	sbb    %edi,%edx
  8031d1:	89 d1                	mov    %edx,%ecx
  8031d3:	89 c6                	mov    %eax,%esi
  8031d5:	e9 71 ff ff ff       	jmp    80314b <__umoddi3+0xb3>
  8031da:	66 90                	xchg   %ax,%ax
  8031dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031e0:	72 ea                	jb     8031cc <__umoddi3+0x134>
  8031e2:	89 d9                	mov    %ebx,%ecx
  8031e4:	e9 62 ff ff ff       	jmp    80314b <__umoddi3+0xb3>
