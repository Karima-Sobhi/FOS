
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 4b 01 00 00       	call   800181 <libmain>
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
	// Testing removing the shared variables
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 e0 32 80 00       	push   $0x8032e0
  80004a:	e8 9d 15 00 00       	call   8015ec <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 68 18 00 00       	call   8018cb <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 00 19 00 00       	call   80196b <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 f0 32 80 00       	push   $0x8032f0
  800079:	e8 f3 04 00 00       	call   800571 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 23 33 80 00       	push   $0x803323
  80008f:	e8 a9 1a 00 00       	call   801b3d <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 2c 33 80 00       	push   $0x80332c
  8000a8:	e8 90 1a 00 00       	call   801b3d <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 9d 1a 00 00       	call   801b5b <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 f7 2e 00 00       	call   802fc5 <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 7f 1a 00 00       	call   801b5b <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 dc 17 00 00       	call   8018cb <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 38 33 80 00       	push   $0x803338
  8000f8:	e8 74 04 00 00       	call   800571 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 6c 1a 00 00       	call   801b77 <sys_destroy_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 5e 1a 00 00       	call   801b77 <sys_destroy_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 aa 17 00 00       	call   8018cb <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 42 18 00 00       	call   80196b <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 6c 33 80 00       	push   $0x80336c
  80013f:	e8 2d 04 00 00       	call   800571 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 bc 33 80 00       	push   $0x8033bc
  80014f:	6a 23                	push   $0x23
  800151:	68 f2 33 80 00       	push   $0x8033f2
  800156:	e8 62 01 00 00       	call   8002bd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 08 34 80 00       	push   $0x803408
  800166:	e8 06 04 00 00       	call   800571 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 68 34 80 00       	push   $0x803468
  800176:	e8 f6 03 00 00       	call   800571 <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp
	return;
  80017e:	90                   	nop
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800187:	e8 1f 1a 00 00       	call   801bab <sys_getenvindex>
  80018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80018f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	c1 e0 03             	shl    $0x3,%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001a4:	01 d0                	add    %edx,%eax
  8001a6:	c1 e0 04             	shl    $0x4,%eax
  8001a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ae:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b8:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001be:	84 c0                	test   %al,%al
  8001c0:	74 0f                	je     8001d1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c7:	05 5c 05 00 00       	add    $0x55c,%eax
  8001cc:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d5:	7e 0a                	jle    8001e1 <libmain+0x60>
		binaryname = argv[0];
  8001d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001da:	8b 00                	mov    (%eax),%eax
  8001dc:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	e8 49 fe ff ff       	call   800038 <_main>
  8001ef:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001f2:	e8 c1 17 00 00       	call   8019b8 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 cc 34 80 00       	push   $0x8034cc
  8001ff:	e8 6d 03 00 00       	call   800571 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800207:	a1 20 40 80 00       	mov    0x804020,%eax
  80020c:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800212:	a1 20 40 80 00       	mov    0x804020,%eax
  800217:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	68 f4 34 80 00       	push   $0x8034f4
  800227:	e8 45 03 00 00       	call   800571 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80023a:	a1 20 40 80 00       	mov    0x804020,%eax
  80023f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800245:	a1 20 40 80 00       	mov    0x804020,%eax
  80024a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800250:	51                   	push   %ecx
  800251:	52                   	push   %edx
  800252:	50                   	push   %eax
  800253:	68 1c 35 80 00       	push   $0x80351c
  800258:	e8 14 03 00 00       	call   800571 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 40 80 00       	mov    0x804020,%eax
  800265:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 74 35 80 00       	push   $0x803574
  800274:	e8 f8 02 00 00       	call   800571 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 cc 34 80 00       	push   $0x8034cc
  800284:	e8 e8 02 00 00       	call   800571 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80028c:	e8 41 17 00 00       	call   8019d2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800291:	e8 19 00 00 00       	call   8002af <exit>
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	6a 00                	push   $0x0
  8002a4:	e8 ce 18 00 00       	call   801b77 <sys_destroy_env>
  8002a9:	83 c4 10             	add    $0x10,%esp
}
  8002ac:	90                   	nop
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <exit>:

void
exit(void)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b5:	e8 23 19 00 00       	call   801bdd <sys_exit_env>
}
  8002ba:	90                   	nop
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8002c6:	83 c0 04             	add    $0x4,%eax
  8002c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002cc:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002d1:	85 c0                	test   %eax,%eax
  8002d3:	74 16                	je     8002eb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002d5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	50                   	push   %eax
  8002de:	68 88 35 80 00       	push   $0x803588
  8002e3:	e8 89 02 00 00       	call   800571 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002eb:	a1 00 40 80 00       	mov    0x804000,%eax
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	68 8d 35 80 00       	push   $0x80358d
  8002fc:	e8 70 02 00 00       	call   800571 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800304:	8b 45 10             	mov    0x10(%ebp),%eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 f4             	pushl  -0xc(%ebp)
  80030d:	50                   	push   %eax
  80030e:	e8 f3 01 00 00       	call   800506 <vcprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 a9 35 80 00       	push   $0x8035a9
  800320:	e8 e1 01 00 00       	call   800506 <vcprintf>
  800325:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800328:	e8 82 ff ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  80032d:	eb fe                	jmp    80032d <_panic+0x70>

0080032f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800335:	a1 20 40 80 00       	mov    0x804020,%eax
  80033a:	8b 50 74             	mov    0x74(%eax),%edx
  80033d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800340:	39 c2                	cmp    %eax,%edx
  800342:	74 14                	je     800358 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	68 ac 35 80 00       	push   $0x8035ac
  80034c:	6a 26                	push   $0x26
  80034e:	68 f8 35 80 00       	push   $0x8035f8
  800353:	e8 65 ff ff ff       	call   8002bd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80035f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800366:	e9 c2 00 00 00       	jmp    80042d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80036b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	01 d0                	add    %edx,%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	85 c0                	test   %eax,%eax
  80037e:	75 08                	jne    800388 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800380:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800383:	e9 a2 00 00 00       	jmp    80042a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800388:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80038f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800396:	eb 69                	jmp    800401 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800398:	a1 20 40 80 00       	mov    0x804020,%eax
  80039d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a6:	89 d0                	mov    %edx,%eax
  8003a8:	01 c0                	add    %eax,%eax
  8003aa:	01 d0                	add    %edx,%eax
  8003ac:	c1 e0 03             	shl    $0x3,%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8a 40 04             	mov    0x4(%eax),%al
  8003b4:	84 c0                	test   %al,%al
  8003b6:	75 46                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003bd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003c6:	89 d0                	mov    %edx,%eax
  8003c8:	01 c0                	add    %eax,%eax
  8003ca:	01 d0                	add    %edx,%eax
  8003cc:	c1 e0 03             	shl    $0x3,%eax
  8003cf:	01 c8                	add    %ecx,%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003de:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	01 c8                	add    %ecx,%eax
  8003ef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f1:	39 c2                	cmp    %eax,%edx
  8003f3:	75 09                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003f5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003fc:	eb 12                	jmp    800410 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fe:	ff 45 e8             	incl   -0x18(%ebp)
  800401:	a1 20 40 80 00       	mov    0x804020,%eax
  800406:	8b 50 74             	mov    0x74(%eax),%edx
  800409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	77 88                	ja     800398 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800414:	75 14                	jne    80042a <CheckWSWithoutLastIndex+0xfb>
			panic(
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 04 36 80 00       	push   $0x803604
  80041e:	6a 3a                	push   $0x3a
  800420:	68 f8 35 80 00       	push   $0x8035f8
  800425:	e8 93 fe ff ff       	call   8002bd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80042a:	ff 45 f0             	incl   -0x10(%ebp)
  80042d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800430:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800433:	0f 8c 32 ff ff ff    	jl     80036b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800439:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800440:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800447:	eb 26                	jmp    80046f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800449:	a1 20 40 80 00       	mov    0x804020,%eax
  80044e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800454:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	c1 e0 03             	shl    $0x3,%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8a 40 04             	mov    0x4(%eax),%al
  800465:	3c 01                	cmp    $0x1,%al
  800467:	75 03                	jne    80046c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800469:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	ff 45 e0             	incl   -0x20(%ebp)
  80046f:	a1 20 40 80 00       	mov    0x804020,%eax
  800474:	8b 50 74             	mov    0x74(%eax),%edx
  800477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047a:	39 c2                	cmp    %eax,%edx
  80047c:	77 cb                	ja     800449 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80047e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800481:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800484:	74 14                	je     80049a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 58 36 80 00       	push   $0x803658
  80048e:	6a 44                	push   $0x44
  800490:	68 f8 35 80 00       	push   $0x8035f8
  800495:	e8 23 fe ff ff       	call   8002bd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ae:	89 0a                	mov    %ecx,(%edx)
  8004b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b3:	88 d1                	mov    %dl,%cl
  8004b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c6:	75 2c                	jne    8004f4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c8:	a0 24 40 80 00       	mov    0x804024,%al
  8004cd:	0f b6 c0             	movzbl %al,%eax
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	8b 12                	mov    (%edx),%edx
  8004d5:	89 d1                	mov    %edx,%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	83 c2 08             	add    $0x8,%edx
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	50                   	push   %eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	e8 22 13 00 00       	call   80180a <sys_cputs>
  8004e8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8b 40 04             	mov    0x4(%eax),%eax
  8004fa:	8d 50 01             	lea    0x1(%eax),%edx
  8004fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800500:	89 50 04             	mov    %edx,0x4(%eax)
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80050f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800516:	00 00 00 
	b.cnt = 0;
  800519:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800520:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800523:	ff 75 0c             	pushl  0xc(%ebp)
  800526:	ff 75 08             	pushl  0x8(%ebp)
  800529:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	68 9d 04 80 00       	push   $0x80049d
  800535:	e8 11 02 00 00       	call   80074b <vprintfmt>
  80053a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80053d:	a0 24 40 80 00       	mov    0x804024,%al
  800542:	0f b6 c0             	movzbl %al,%eax
  800545:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80054b:	83 ec 04             	sub    $0x4,%esp
  80054e:	50                   	push   %eax
  80054f:	52                   	push   %edx
  800550:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800556:	83 c0 08             	add    $0x8,%eax
  800559:	50                   	push   %eax
  80055a:	e8 ab 12 00 00       	call   80180a <sys_cputs>
  80055f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800562:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800569:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <cprintf>:

int cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800577:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80057e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	ff 75 f4             	pushl  -0xc(%ebp)
  80058d:	50                   	push   %eax
  80058e:	e8 73 ff ff ff       	call   800506 <vcprintf>
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800599:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059c:	c9                   	leave  
  80059d:	c3                   	ret    

0080059e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005a4:	e8 0f 14 00 00       	call   8019b8 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	e8 48 ff ff ff       	call   800506 <vcprintf>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005c4:	e8 09 14 00 00       	call   8019d2 <sys_enable_interrupt>
	return cnt;
  8005c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cc:	c9                   	leave  
  8005cd:	c3                   	ret    

008005ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
  8005d1:	53                   	push   %ebx
  8005d2:	83 ec 14             	sub    $0x14,%esp
  8005d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ec:	77 55                	ja     800643 <printnum+0x75>
  8005ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f1:	72 05                	jb     8005f8 <printnum+0x2a>
  8005f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005f6:	77 4b                	ja     800643 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	52                   	push   %edx
  800607:	50                   	push   %eax
  800608:	ff 75 f4             	pushl  -0xc(%ebp)
  80060b:	ff 75 f0             	pushl  -0x10(%ebp)
  80060e:	e8 69 2a 00 00       	call   80307c <__udivdi3>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	ff 75 20             	pushl  0x20(%ebp)
  80061c:	53                   	push   %ebx
  80061d:	ff 75 18             	pushl  0x18(%ebp)
  800620:	52                   	push   %edx
  800621:	50                   	push   %eax
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	ff 75 08             	pushl  0x8(%ebp)
  800628:	e8 a1 ff ff ff       	call   8005ce <printnum>
  80062d:	83 c4 20             	add    $0x20,%esp
  800630:	eb 1a                	jmp    80064c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 20             	pushl  0x20(%ebp)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	ff d0                	call   *%eax
  800640:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800643:	ff 4d 1c             	decl   0x1c(%ebp)
  800646:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80064a:	7f e6                	jg     800632 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80064c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80064f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80065a:	53                   	push   %ebx
  80065b:	51                   	push   %ecx
  80065c:	52                   	push   %edx
  80065d:	50                   	push   %eax
  80065e:	e8 29 2b 00 00       	call   80318c <__umoddi3>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	05 d4 38 80 00       	add    $0x8038d4,%eax
  80066b:	8a 00                	mov    (%eax),%al
  80066d:	0f be c0             	movsbl %al,%eax
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	ff 75 0c             	pushl  0xc(%ebp)
  800676:	50                   	push   %eax
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	ff d0                	call   *%eax
  80067c:	83 c4 10             	add    $0x10,%esp
}
  80067f:	90                   	nop
  800680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800683:	c9                   	leave  
  800684:	c3                   	ret    

00800685 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800688:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80068c:	7e 1c                	jle    8006aa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	8d 50 08             	lea    0x8(%eax),%edx
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	89 10                	mov    %edx,(%eax)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	83 e8 08             	sub    $0x8,%eax
  8006a3:	8b 50 04             	mov    0x4(%eax),%edx
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	eb 40                	jmp    8006ea <getuint+0x65>
	else if (lflag)
  8006aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ae:	74 1e                	je     8006ce <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	8d 50 04             	lea    0x4(%eax),%edx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	89 10                	mov    %edx,(%eax)
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	83 e8 04             	sub    $0x4,%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cc:	eb 1c                	jmp    8006ea <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	8d 50 04             	lea    0x4(%eax),%edx
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	89 10                	mov    %edx,(%eax)
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	83 e8 04             	sub    $0x4,%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ea:	5d                   	pop    %ebp
  8006eb:	c3                   	ret    

008006ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f3:	7e 1c                	jle    800711 <getint+0x25>
		return va_arg(*ap, long long);
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	8d 50 08             	lea    0x8(%eax),%edx
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	89 10                	mov    %edx,(%eax)
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	83 e8 08             	sub    $0x8,%eax
  80070a:	8b 50 04             	mov    0x4(%eax),%edx
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	eb 38                	jmp    800749 <getint+0x5d>
	else if (lflag)
  800711:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800715:	74 1a                	je     800731 <getint+0x45>
		return va_arg(*ap, long);
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	8d 50 04             	lea    0x4(%eax),%edx
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	89 10                	mov    %edx,(%eax)
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	83 e8 04             	sub    $0x4,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	99                   	cltd   
  80072f:	eb 18                	jmp    800749 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	8d 50 04             	lea    0x4(%eax),%edx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	89 10                	mov    %edx,(%eax)
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	83 e8 04             	sub    $0x4,%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	99                   	cltd   
}
  800749:	5d                   	pop    %ebp
  80074a:	c3                   	ret    

0080074b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	56                   	push   %esi
  80074f:	53                   	push   %ebx
  800750:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800753:	eb 17                	jmp    80076c <vprintfmt+0x21>
			if (ch == '\0')
  800755:	85 db                	test   %ebx,%ebx
  800757:	0f 84 af 03 00 00    	je     800b0c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076c:	8b 45 10             	mov    0x10(%ebp),%eax
  80076f:	8d 50 01             	lea    0x1(%eax),%edx
  800772:	89 55 10             	mov    %edx,0x10(%ebp)
  800775:	8a 00                	mov    (%eax),%al
  800777:	0f b6 d8             	movzbl %al,%ebx
  80077a:	83 fb 25             	cmp    $0x25,%ebx
  80077d:	75 d6                	jne    800755 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80077f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800783:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80078a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800791:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800798:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80079f:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a2:	8d 50 01             	lea    0x1(%eax),%edx
  8007a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a8:	8a 00                	mov    (%eax),%al
  8007aa:	0f b6 d8             	movzbl %al,%ebx
  8007ad:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007b0:	83 f8 55             	cmp    $0x55,%eax
  8007b3:	0f 87 2b 03 00 00    	ja     800ae4 <vprintfmt+0x399>
  8007b9:	8b 04 85 f8 38 80 00 	mov    0x8038f8(,%eax,4),%eax
  8007c0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007c2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007c6:	eb d7                	jmp    80079f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007cc:	eb d1                	jmp    80079f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	c1 e0 02             	shl    $0x2,%eax
  8007dd:	01 d0                	add    %edx,%eax
  8007df:	01 c0                	add    %eax,%eax
  8007e1:	01 d8                	add    %ebx,%eax
  8007e3:	83 e8 30             	sub    $0x30,%eax
  8007e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ec:	8a 00                	mov    (%eax),%al
  8007ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007f4:	7e 3e                	jle    800834 <vprintfmt+0xe9>
  8007f6:	83 fb 39             	cmp    $0x39,%ebx
  8007f9:	7f 39                	jg     800834 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007fe:	eb d5                	jmp    8007d5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 c0 04             	add    $0x4,%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	83 e8 04             	sub    $0x4,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800814:	eb 1f                	jmp    800835 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800816:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081a:	79 83                	jns    80079f <vprintfmt+0x54>
				width = 0;
  80081c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800823:	e9 77 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800828:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80082f:	e9 6b ff ff ff       	jmp    80079f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800834:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800835:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800839:	0f 89 60 ff ff ff    	jns    80079f <vprintfmt+0x54>
				width = precision, precision = -1;
  80083f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800845:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80084c:	e9 4e ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800851:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800854:	e9 46 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 c0 04             	add    $0x4,%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 e8 04             	sub    $0x4,%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	50                   	push   %eax
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
  800876:	83 c4 10             	add    $0x10,%esp
			break;
  800879:	e9 89 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 c0 04             	add    $0x4,%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	83 e8 04             	sub    $0x4,%eax
  80088d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80088f:	85 db                	test   %ebx,%ebx
  800891:	79 02                	jns    800895 <vprintfmt+0x14a>
				err = -err;
  800893:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800895:	83 fb 64             	cmp    $0x64,%ebx
  800898:	7f 0b                	jg     8008a5 <vprintfmt+0x15a>
  80089a:	8b 34 9d 40 37 80 00 	mov    0x803740(,%ebx,4),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 19                	jne    8008be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a5:	53                   	push   %ebx
  8008a6:	68 e5 38 80 00       	push   $0x8038e5
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	ff 75 08             	pushl  0x8(%ebp)
  8008b1:	e8 5e 02 00 00       	call   800b14 <printfmt>
  8008b6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b9:	e9 49 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008be:	56                   	push   %esi
  8008bf:	68 ee 38 80 00       	push   $0x8038ee
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	e8 45 02 00 00       	call   800b14 <printfmt>
  8008cf:	83 c4 10             	add    $0x10,%esp
			break;
  8008d2:	e9 30 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 c0 04             	add    $0x4,%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 e8 04             	sub    $0x4,%eax
  8008e6:	8b 30                	mov    (%eax),%esi
  8008e8:	85 f6                	test   %esi,%esi
  8008ea:	75 05                	jne    8008f1 <vprintfmt+0x1a6>
				p = "(null)";
  8008ec:	be f1 38 80 00       	mov    $0x8038f1,%esi
			if (width > 0 && padc != '-')
  8008f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f5:	7e 6d                	jle    800964 <vprintfmt+0x219>
  8008f7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008fb:	74 67                	je     800964 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	50                   	push   %eax
  800904:	56                   	push   %esi
  800905:	e8 0c 03 00 00       	call   800c16 <strnlen>
  80090a:	83 c4 10             	add    $0x10,%esp
  80090d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800910:	eb 16                	jmp    800928 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800912:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800925:	ff 4d e4             	decl   -0x1c(%ebp)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	7f e4                	jg     800912 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092e:	eb 34                	jmp    800964 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800930:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800934:	74 1c                	je     800952 <vprintfmt+0x207>
  800936:	83 fb 1f             	cmp    $0x1f,%ebx
  800939:	7e 05                	jle    800940 <vprintfmt+0x1f5>
  80093b:	83 fb 7e             	cmp    $0x7e,%ebx
  80093e:	7e 12                	jle    800952 <vprintfmt+0x207>
					putch('?', putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	6a 3f                	push   $0x3f
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	ff d0                	call   *%eax
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	eb 0f                	jmp    800961 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800961:	ff 4d e4             	decl   -0x1c(%ebp)
  800964:	89 f0                	mov    %esi,%eax
  800966:	8d 70 01             	lea    0x1(%eax),%esi
  800969:	8a 00                	mov    (%eax),%al
  80096b:	0f be d8             	movsbl %al,%ebx
  80096e:	85 db                	test   %ebx,%ebx
  800970:	74 24                	je     800996 <vprintfmt+0x24b>
  800972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800976:	78 b8                	js     800930 <vprintfmt+0x1e5>
  800978:	ff 4d e0             	decl   -0x20(%ebp)
  80097b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097f:	79 af                	jns    800930 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800981:	eb 13                	jmp    800996 <vprintfmt+0x24b>
				putch(' ', putdat);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 0c             	pushl  0xc(%ebp)
  800989:	6a 20                	push   $0x20
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800993:	ff 4d e4             	decl   -0x1c(%ebp)
  800996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099a:	7f e7                	jg     800983 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80099c:	e9 66 01 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a7:	8d 45 14             	lea    0x14(%ebp),%eax
  8009aa:	50                   	push   %eax
  8009ab:	e8 3c fd ff ff       	call   8006ec <getint>
  8009b0:	83 c4 10             	add    $0x10,%esp
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	79 23                	jns    8009e6 <vprintfmt+0x29b>
				putch('-', putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	6a 2d                	push   $0x2d
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	ff d0                	call   *%eax
  8009d0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d9:	f7 d8                	neg    %eax
  8009db:	83 d2 00             	adc    $0x0,%edx
  8009de:	f7 da                	neg    %edx
  8009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009e6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ed:	e9 bc 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fb:	50                   	push   %eax
  8009fc:	e8 84 fc ff ff       	call   800685 <getuint>
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a11:	e9 98 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	6a 58                	push   $0x58
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	ff d0                	call   *%eax
  800a23:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	6a 58                	push   $0x58
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	ff d0                	call   *%eax
  800a33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	6a 58                	push   $0x58
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
			break;
  800a46:	e9 bc 00 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	6a 30                	push   $0x30
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	ff d0                	call   *%eax
  800a58:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	6a 78                	push   $0x78
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 c0 04             	add    $0x4,%eax
  800a71:	89 45 14             	mov    %eax,0x14(%ebp)
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	83 e8 04             	sub    $0x4,%eax
  800a7a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a8d:	eb 1f                	jmp    800aae <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 e8             	pushl  -0x18(%ebp)
  800a95:	8d 45 14             	lea    0x14(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	e8 e7 fb ff ff       	call   800685 <getuint>
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aae:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab5:	83 ec 04             	sub    $0x4,%esp
  800ab8:	52                   	push   %edx
  800ab9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800abc:	50                   	push   %eax
  800abd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	ff 75 08             	pushl  0x8(%ebp)
  800ac9:	e8 00 fb ff ff       	call   8005ce <printnum>
  800ace:	83 c4 20             	add    $0x20,%esp
			break;
  800ad1:	eb 34                	jmp    800b07 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	53                   	push   %ebx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	ff d0                	call   *%eax
  800adf:	83 c4 10             	add    $0x10,%esp
			break;
  800ae2:	eb 23                	jmp    800b07 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	6a 25                	push   $0x25
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af4:	ff 4d 10             	decl   0x10(%ebp)
  800af7:	eb 03                	jmp    800afc <vprintfmt+0x3b1>
  800af9:	ff 4d 10             	decl   0x10(%ebp)
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	48                   	dec    %eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	3c 25                	cmp    $0x25,%al
  800b04:	75 f3                	jne    800af9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b06:	90                   	nop
		}
	}
  800b07:	e9 47 fc ff ff       	jmp    800753 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b0c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b1a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b1d:	83 c0 04             	add    $0x4,%eax
  800b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b23:	8b 45 10             	mov    0x10(%ebp),%eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	50                   	push   %eax
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	e8 16 fc ff ff       	call   80074b <vprintfmt>
  800b35:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b38:	90                   	nop
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	8b 40 08             	mov    0x8(%eax),%eax
  800b44:	8d 50 01             	lea    0x1(%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	8b 10                	mov    (%eax),%edx
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 04             	mov    0x4(%eax),%eax
  800b58:	39 c2                	cmp    %eax,%edx
  800b5a:	73 12                	jae    800b6e <sprintputch+0x33>
		*b->buf++ = ch;
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	8d 48 01             	lea    0x1(%eax),%ecx
  800b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b67:	89 0a                	mov    %ecx,(%edx)
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	88 10                	mov    %dl,(%eax)
}
  800b6e:	90                   	nop
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	01 d0                	add    %edx,%eax
  800b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b96:	74 06                	je     800b9e <vsnprintf+0x2d>
  800b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9c:	7f 07                	jg     800ba5 <vsnprintf+0x34>
		return -E_INVAL;
  800b9e:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba3:	eb 20                	jmp    800bc5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba5:	ff 75 14             	pushl  0x14(%ebp)
  800ba8:	ff 75 10             	pushl  0x10(%ebp)
  800bab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bae:	50                   	push   %eax
  800baf:	68 3b 0b 80 00       	push   $0x800b3b
  800bb4:	e8 92 fb ff ff       	call   80074b <vprintfmt>
  800bb9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc5:	c9                   	leave  
  800bc6:	c3                   	ret    

00800bc7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bcd:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd0:	83 c0 04             	add    $0x4,%eax
  800bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	e8 89 ff ff ff       	call   800b71 <vsnprintf>
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c00:	eb 06                	jmp    800c08 <strlen+0x15>
		n++;
  800c02:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c05:	ff 45 08             	incl   0x8(%ebp)
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	84 c0                	test   %al,%al
  800c0f:	75 f1                	jne    800c02 <strlen+0xf>
		n++;
	return n;
  800c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c23:	eb 09                	jmp    800c2e <strnlen+0x18>
		n++;
  800c25:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 4d 0c             	decl   0xc(%ebp)
  800c2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c32:	74 09                	je     800c3d <strnlen+0x27>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 e8                	jne    800c25 <strnlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c4e:	90                   	nop
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8d 50 01             	lea    0x1(%eax),%edx
  800c55:	89 55 08             	mov    %edx,0x8(%ebp)
  800c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c61:	8a 12                	mov    (%edx),%dl
  800c63:	88 10                	mov    %dl,(%eax)
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	84 c0                	test   %al,%al
  800c69:	75 e4                	jne    800c4f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c83:	eb 1f                	jmp    800ca4 <strncpy+0x34>
		*dst++ = *src;
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8d 50 01             	lea    0x1(%eax),%edx
  800c8b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	84 c0                	test   %al,%al
  800c9c:	74 03                	je     800ca1 <strncpy+0x31>
			src++;
  800c9e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca1:	ff 45 fc             	incl   -0x4(%ebp)
  800ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800caa:	72 d9                	jb     800c85 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc1:	74 30                	je     800cf3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc3:	eb 16                	jmp    800cdb <strlcpy+0x2a>
			*dst++ = *src++;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8d 50 01             	lea    0x1(%eax),%edx
  800ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd7:	8a 12                	mov    (%edx),%dl
  800cd9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cdb:	ff 4d 10             	decl   0x10(%ebp)
  800cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce2:	74 09                	je     800ced <strlcpy+0x3c>
  800ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	84 c0                	test   %al,%al
  800ceb:	75 d8                	jne    800cc5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	29 c2                	sub    %eax,%edx
  800cfb:	89 d0                	mov    %edx,%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d02:	eb 06                	jmp    800d0a <strcmp+0xb>
		p++, q++;
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	84 c0                	test   %al,%al
  800d11:	74 0e                	je     800d21 <strcmp+0x22>
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 10                	mov    (%eax),%dl
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	38 c2                	cmp    %al,%dl
  800d1f:	74 e3                	je     800d04 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	0f b6 d0             	movzbl %al,%edx
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 c0             	movzbl %al,%eax
  800d31:	29 c2                	sub    %eax,%edx
  800d33:	89 d0                	mov    %edx,%eax
}
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d3a:	eb 09                	jmp    800d45 <strncmp+0xe>
		n--, p++, q++;
  800d3c:	ff 4d 10             	decl   0x10(%ebp)
  800d3f:	ff 45 08             	incl   0x8(%ebp)
  800d42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 17                	je     800d62 <strncmp+0x2b>
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	84 c0                	test   %al,%al
  800d52:	74 0e                	je     800d62 <strncmp+0x2b>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 10                	mov    (%eax),%dl
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	38 c2                	cmp    %al,%dl
  800d60:	74 da                	je     800d3c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d66:	75 07                	jne    800d6f <strncmp+0x38>
		return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6d:	eb 14                	jmp    800d83 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	0f b6 d0             	movzbl %al,%edx
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	0f b6 c0             	movzbl %al,%eax
  800d7f:	29 c2                	sub    %eax,%edx
  800d81:	89 d0                	mov    %edx,%eax
}
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 04             	sub    $0x4,%esp
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d91:	eb 12                	jmp    800da5 <strchr+0x20>
		if (*s == c)
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9b:	75 05                	jne    800da2 <strchr+0x1d>
			return (char *) s;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	eb 11                	jmp    800db3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da2:	ff 45 08             	incl   0x8(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 e5                	jne    800d93 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 04             	sub    $0x4,%esp
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc1:	eb 0d                	jmp    800dd0 <strfind+0x1b>
		if (*s == c)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dcb:	74 0e                	je     800ddb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dcd:	ff 45 08             	incl   0x8(%ebp)
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	75 ea                	jne    800dc3 <strfind+0xe>
  800dd9:	eb 01                	jmp    800ddc <strfind+0x27>
		if (*s == c)
			break;
  800ddb:	90                   	nop
	return (char *) s;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800df3:	eb 0e                	jmp    800e03 <memset+0x22>
		*p++ = c;
  800df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df8:	8d 50 01             	lea    0x1(%eax),%edx
  800dfb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e01:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e03:	ff 4d f8             	decl   -0x8(%ebp)
  800e06:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e0a:	79 e9                	jns    800df5 <memset+0x14>
		*p++ = c;

	return v;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e23:	eb 16                	jmp    800e3b <memcpy+0x2a>
		*d++ = *s++;
  800e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e28:	8d 50 01             	lea    0x1(%eax),%edx
  800e2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e37:	8a 12                	mov    (%edx),%dl
  800e39:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e41:	89 55 10             	mov    %edx,0x10(%ebp)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	75 dd                	jne    800e25 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e65:	73 50                	jae    800eb7 <memmove+0x6a>
  800e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	01 d0                	add    %edx,%eax
  800e6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e72:	76 43                	jbe    800eb7 <memmove+0x6a>
		s += n;
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e80:	eb 10                	jmp    800e92 <memmove+0x45>
			*--d = *--s;
  800e82:	ff 4d f8             	decl   -0x8(%ebp)
  800e85:	ff 4d fc             	decl   -0x4(%ebp)
  800e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8b:	8a 10                	mov    (%eax),%dl
  800e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e90:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e98:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	75 e3                	jne    800e82 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e9f:	eb 23                	jmp    800ec4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eaa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	75 dd                	jne    800ea1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800edb:	eb 2a                	jmp    800f07 <memcmp+0x3e>
		if (*s1 != *s2)
  800edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee0:	8a 10                	mov    (%eax),%dl
  800ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	38 c2                	cmp    %al,%dl
  800ee9:	74 16                	je     800f01 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	0f b6 d0             	movzbl %al,%edx
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 c0             	movzbl %al,%eax
  800efb:	29 c2                	sub    %eax,%edx
  800efd:	89 d0                	mov    %edx,%eax
  800eff:	eb 18                	jmp    800f19 <memcmp+0x50>
		s1++, s2++;
  800f01:	ff 45 fc             	incl   -0x4(%ebp)
  800f04:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f07:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	75 c9                	jne    800edd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	01 d0                	add    %edx,%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f2c:	eb 15                	jmp    800f43 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	0f b6 d0             	movzbl %al,%edx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	0f b6 c0             	movzbl %al,%eax
  800f3c:	39 c2                	cmp    %eax,%edx
  800f3e:	74 0d                	je     800f4d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f49:	72 e3                	jb     800f2e <memfind+0x13>
  800f4b:	eb 01                	jmp    800f4e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f4d:	90                   	nop
	return (void *) s;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f67:	eb 03                	jmp    800f6c <strtol+0x19>
		s++;
  800f69:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 20                	cmp    $0x20,%al
  800f73:	74 f4                	je     800f69 <strtol+0x16>
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	3c 09                	cmp    $0x9,%al
  800f7c:	74 eb                	je     800f69 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 2b                	cmp    $0x2b,%al
  800f85:	75 05                	jne    800f8c <strtol+0x39>
		s++;
  800f87:	ff 45 08             	incl   0x8(%ebp)
  800f8a:	eb 13                	jmp    800f9f <strtol+0x4c>
	else if (*s == '-')
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	3c 2d                	cmp    $0x2d,%al
  800f93:	75 0a                	jne    800f9f <strtol+0x4c>
		s++, neg = 1;
  800f95:	ff 45 08             	incl   0x8(%ebp)
  800f98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	74 06                	je     800fab <strtol+0x58>
  800fa5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa9:	75 20                	jne    800fcb <strtol+0x78>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 30                	cmp    $0x30,%al
  800fb2:	75 17                	jne    800fcb <strtol+0x78>
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	40                   	inc    %eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 78                	cmp    $0x78,%al
  800fbc:	75 0d                	jne    800fcb <strtol+0x78>
		s += 2, base = 16;
  800fbe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fc2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc9:	eb 28                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	75 15                	jne    800fe6 <strtol+0x93>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 30                	cmp    $0x30,%al
  800fd8:	75 0c                	jne    800fe6 <strtol+0x93>
		s++, base = 8;
  800fda:	ff 45 08             	incl   0x8(%ebp)
  800fdd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fe4:	eb 0d                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0)
  800fe6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fea:	75 07                	jne    800ff3 <strtol+0xa0>
		base = 10;
  800fec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 2f                	cmp    $0x2f,%al
  800ffa:	7e 19                	jle    801015 <strtol+0xc2>
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 39                	cmp    $0x39,%al
  801003:	7f 10                	jg     801015 <strtol+0xc2>
			dig = *s - '0';
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f be c0             	movsbl %al,%eax
  80100d:	83 e8 30             	sub    $0x30,%eax
  801010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801013:	eb 42                	jmp    801057 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3c 60                	cmp    $0x60,%al
  80101c:	7e 19                	jle    801037 <strtol+0xe4>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 7a                	cmp    $0x7a,%al
  801025:	7f 10                	jg     801037 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	0f be c0             	movsbl %al,%eax
  80102f:	83 e8 57             	sub    $0x57,%eax
  801032:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801035:	eb 20                	jmp    801057 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	3c 40                	cmp    $0x40,%al
  80103e:	7e 39                	jle    801079 <strtol+0x126>
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	3c 5a                	cmp    $0x5a,%al
  801047:	7f 30                	jg     801079 <strtol+0x126>
			dig = *s - 'A' + 10;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	0f be c0             	movsbl %al,%eax
  801051:	83 e8 37             	sub    $0x37,%eax
  801054:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80105d:	7d 19                	jge    801078 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80105f:	ff 45 08             	incl   0x8(%ebp)
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	0f af 45 10          	imul   0x10(%ebp),%eax
  801069:	89 c2                	mov    %eax,%edx
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801073:	e9 7b ff ff ff       	jmp    800ff3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801078:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801079:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107d:	74 08                	je     801087 <strtol+0x134>
		*endptr = (char *) s;
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	8b 55 08             	mov    0x8(%ebp),%edx
  801085:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801087:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80108b:	74 07                	je     801094 <strtol+0x141>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801090:	f7 d8                	neg    %eax
  801092:	eb 03                	jmp    801097 <strtol+0x144>
  801094:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <ltostr>:

void
ltostr(long value, char *str)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b1:	79 13                	jns    8010c6 <ltostr+0x2d>
	{
		neg = 1;
  8010b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010c0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010c3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010ce:	99                   	cltd   
  8010cf:	f7 f9                	idiv   %ecx
  8010d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d7:	8d 50 01             	lea    0x1(%eax),%edx
  8010da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010dd:	89 c2                	mov    %eax,%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	01 d0                	add    %edx,%eax
  8010e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e7:	83 c2 30             	add    $0x30,%edx
  8010ea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f4:	f7 e9                	imul   %ecx
  8010f6:	c1 fa 02             	sar    $0x2,%edx
  8010f9:	89 c8                	mov    %ecx,%eax
  8010fb:	c1 f8 1f             	sar    $0x1f,%eax
  8010fe:	29 c2                	sub    %eax,%edx
  801100:	89 d0                	mov    %edx,%eax
  801102:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801108:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80110d:	f7 e9                	imul   %ecx
  80110f:	c1 fa 02             	sar    $0x2,%edx
  801112:	89 c8                	mov    %ecx,%eax
  801114:	c1 f8 1f             	sar    $0x1f,%eax
  801117:	29 c2                	sub    %eax,%edx
  801119:	89 d0                	mov    %edx,%eax
  80111b:	c1 e0 02             	shl    $0x2,%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	01 c0                	add    %eax,%eax
  801122:	29 c1                	sub    %eax,%ecx
  801124:	89 ca                	mov    %ecx,%edx
  801126:	85 d2                	test   %edx,%edx
  801128:	75 9c                	jne    8010c6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80112a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801134:	48                   	dec    %eax
  801135:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 3d                	je     80117b <ltostr+0xe2>
		start = 1 ;
  80113e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801145:	eb 34                	jmp    80117b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 c2                	add    %eax,%edx
  80115c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801168:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8a 45 eb             	mov    -0x15(%ebp),%al
  801173:	88 02                	mov    %al,(%edx)
		start++ ;
  801175:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801178:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80117b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801181:	7c c4                	jl     801147 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801183:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	01 d0                	add    %edx,%eax
  80118b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80118e:	90                   	nop
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801197:	ff 75 08             	pushl  0x8(%ebp)
  80119a:	e8 54 fa ff ff       	call   800bf3 <strlen>
  80119f:	83 c4 04             	add    $0x4,%esp
  8011a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	e8 46 fa ff ff       	call   800bf3 <strlen>
  8011ad:	83 c4 04             	add    $0x4,%esp
  8011b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c1:	eb 17                	jmp    8011da <strcconcat+0x49>
		final[s] = str1[s] ;
  8011c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 c2                	add    %eax,%edx
  8011cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	01 c8                	add    %ecx,%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d7:	ff 45 fc             	incl   -0x4(%ebp)
  8011da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011e0:	7c e1                	jl     8011c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011f0:	eb 1f                	jmp    801211 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f5:	8d 50 01             	lea    0x1(%eax),%edx
  8011f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801200:	01 c2                	add    %eax,%edx
  801202:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c8                	add    %ecx,%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801217:	7c d9                	jl     8011f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801219:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121c:	8b 45 10             	mov    0x10(%ebp),%eax
  80121f:	01 d0                	add    %edx,%eax
  801221:	c6 00 00             	movb   $0x0,(%eax)
}
  801224:	90                   	nop
  801225:	c9                   	leave  
  801226:	c3                   	ret    

00801227 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80122a:	8b 45 14             	mov    0x14(%ebp),%eax
  80122d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801233:	8b 45 14             	mov    0x14(%ebp),%eax
  801236:	8b 00                	mov    (%eax),%eax
  801238:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123f:	8b 45 10             	mov    0x10(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124a:	eb 0c                	jmp    801258 <strsplit+0x31>
			*string++ = 0;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8d 50 01             	lea    0x1(%eax),%edx
  801252:	89 55 08             	mov    %edx,0x8(%ebp)
  801255:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	84 c0                	test   %al,%al
  80125f:	74 18                	je     801279 <strsplit+0x52>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	0f be c0             	movsbl %al,%eax
  801269:	50                   	push   %eax
  80126a:	ff 75 0c             	pushl  0xc(%ebp)
  80126d:	e8 13 fb ff ff       	call   800d85 <strchr>
  801272:	83 c4 08             	add    $0x8,%esp
  801275:	85 c0                	test   %eax,%eax
  801277:	75 d3                	jne    80124c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	84 c0                	test   %al,%al
  801280:	74 5a                	je     8012dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	8b 00                	mov    (%eax),%eax
  801287:	83 f8 0f             	cmp    $0xf,%eax
  80128a:	75 07                	jne    801293 <strsplit+0x6c>
		{
			return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
  801291:	eb 66                	jmp    8012f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 48 01             	lea    0x1(%eax),%ecx
  80129b:	8b 55 14             	mov    0x14(%ebp),%edx
  80129e:	89 0a                	mov    %ecx,(%edx)
  8012a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012aa:	01 c2                	add    %eax,%edx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b1:	eb 03                	jmp    8012b6 <strsplit+0x8f>
			string++;
  8012b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	84 c0                	test   %al,%al
  8012bd:	74 8b                	je     80124a <strsplit+0x23>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	0f be c0             	movsbl %al,%eax
  8012c7:	50                   	push   %eax
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	e8 b5 fa ff ff       	call   800d85 <strchr>
  8012d0:	83 c4 08             	add    $0x8,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	74 dc                	je     8012b3 <strsplit+0x8c>
			string++;
	}
  8012d7:	e9 6e ff ff ff       	jmp    80124a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e0:	8b 00                	mov    (%eax),%eax
  8012e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801301:	a1 04 40 80 00       	mov    0x804004,%eax
  801306:	85 c0                	test   %eax,%eax
  801308:	74 1f                	je     801329 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80130a:	e8 1d 00 00 00       	call   80132c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80130f:	83 ec 0c             	sub    $0xc,%esp
  801312:	68 50 3a 80 00       	push   $0x803a50
  801317:	e8 55 f2 ff ff       	call   800571 <cprintf>
  80131c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80131f:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801326:	00 00 00 
	}
}
  801329:	90                   	nop
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801332:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801339:	00 00 00 
  80133c:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801343:	00 00 00 
  801346:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80134d:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801350:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801357:	00 00 00 
  80135a:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801361:	00 00 00 
  801364:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80136b:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  80136e:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801375:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801378:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80137f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801382:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801387:	2d 00 10 00 00       	sub    $0x1000,%eax
  80138c:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801391:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801398:	a1 20 41 80 00       	mov    0x804120,%eax
  80139d:	c1 e0 04             	shl    $0x4,%eax
  8013a0:	89 c2                	mov    %eax,%edx
  8013a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a5:	01 d0                	add    %edx,%eax
  8013a7:	48                   	dec    %eax
  8013a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b3:	f7 75 f0             	divl   -0x10(%ebp)
  8013b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b9:	29 d0                	sub    %edx,%eax
  8013bb:	89 c2                	mov    %eax,%edx
  8013bd:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8013c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cc:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013d1:	83 ec 04             	sub    $0x4,%esp
  8013d4:	6a 06                	push   $0x6
  8013d6:	52                   	push   %edx
  8013d7:	50                   	push   %eax
  8013d8:	e8 71 05 00 00       	call   80194e <sys_allocate_chunk>
  8013dd:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013e0:	a1 20 41 80 00       	mov    0x804120,%eax
  8013e5:	83 ec 0c             	sub    $0xc,%esp
  8013e8:	50                   	push   %eax
  8013e9:	e8 e6 0b 00 00       	call   801fd4 <initialize_MemBlocksList>
  8013ee:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8013f1:	a1 48 41 80 00       	mov    0x804148,%eax
  8013f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8013f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013fd:	75 14                	jne    801413 <initialize_dyn_block_system+0xe7>
  8013ff:	83 ec 04             	sub    $0x4,%esp
  801402:	68 75 3a 80 00       	push   $0x803a75
  801407:	6a 2b                	push   $0x2b
  801409:	68 93 3a 80 00       	push   $0x803a93
  80140e:	e8 aa ee ff ff       	call   8002bd <_panic>
  801413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801416:	8b 00                	mov    (%eax),%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	74 10                	je     80142c <initialize_dyn_block_system+0x100>
  80141c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801424:	8b 52 04             	mov    0x4(%edx),%edx
  801427:	89 50 04             	mov    %edx,0x4(%eax)
  80142a:	eb 0b                	jmp    801437 <initialize_dyn_block_system+0x10b>
  80142c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80142f:	8b 40 04             	mov    0x4(%eax),%eax
  801432:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80143a:	8b 40 04             	mov    0x4(%eax),%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 0f                	je     801450 <initialize_dyn_block_system+0x124>
  801441:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801444:	8b 40 04             	mov    0x4(%eax),%eax
  801447:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80144a:	8b 12                	mov    (%edx),%edx
  80144c:	89 10                	mov    %edx,(%eax)
  80144e:	eb 0a                	jmp    80145a <initialize_dyn_block_system+0x12e>
  801450:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801453:	8b 00                	mov    (%eax),%eax
  801455:	a3 48 41 80 00       	mov    %eax,0x804148
  80145a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80145d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801466:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80146d:	a1 54 41 80 00       	mov    0x804154,%eax
  801472:	48                   	dec    %eax
  801473:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801478:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801485:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80148c:	83 ec 0c             	sub    $0xc,%esp
  80148f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801492:	e8 d2 13 00 00       	call   802869 <insert_sorted_with_merge_freeList>
  801497:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80149a:	90                   	nop
  80149b:	c9                   	leave  
  80149c:	c3                   	ret    

0080149d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014a3:	e8 53 fe ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  8014a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014ac:	75 07                	jne    8014b5 <malloc+0x18>
  8014ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b3:	eb 61                	jmp    801516 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8014b5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8014bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c2:	01 d0                	add    %edx,%eax
  8014c4:	48                   	dec    %eax
  8014c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d0:	f7 75 f4             	divl   -0xc(%ebp)
  8014d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d6:	29 d0                	sub    %edx,%eax
  8014d8:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014db:	e8 3c 08 00 00       	call   801d1c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014e0:	85 c0                	test   %eax,%eax
  8014e2:	74 2d                	je     801511 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8014e4:	83 ec 0c             	sub    $0xc,%esp
  8014e7:	ff 75 08             	pushl  0x8(%ebp)
  8014ea:	e8 3e 0f 00 00       	call   80242d <alloc_block_FF>
  8014ef:	83 c4 10             	add    $0x10,%esp
  8014f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8014f5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014f9:	74 16                	je     801511 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8014fb:	83 ec 0c             	sub    $0xc,%esp
  8014fe:	ff 75 ec             	pushl  -0x14(%ebp)
  801501:	e8 48 0c 00 00       	call   80214e <insert_sorted_allocList>
  801506:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801509:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80150c:	8b 40 08             	mov    0x8(%eax),%eax
  80150f:	eb 05                	jmp    801516 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  801511:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801527:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80152c:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	83 ec 08             	sub    $0x8,%esp
  801535:	50                   	push   %eax
  801536:	68 40 40 80 00       	push   $0x804040
  80153b:	e8 71 0b 00 00       	call   8020b1 <find_block>
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801549:	8b 50 0c             	mov    0xc(%eax),%edx
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	83 ec 08             	sub    $0x8,%esp
  801552:	52                   	push   %edx
  801553:	50                   	push   %eax
  801554:	e8 bd 03 00 00       	call   801916 <sys_free_user_mem>
  801559:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80155c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801560:	75 14                	jne    801576 <free+0x5e>
  801562:	83 ec 04             	sub    $0x4,%esp
  801565:	68 75 3a 80 00       	push   $0x803a75
  80156a:	6a 71                	push   $0x71
  80156c:	68 93 3a 80 00       	push   $0x803a93
  801571:	e8 47 ed ff ff       	call   8002bd <_panic>
  801576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801579:	8b 00                	mov    (%eax),%eax
  80157b:	85 c0                	test   %eax,%eax
  80157d:	74 10                	je     80158f <free+0x77>
  80157f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801582:	8b 00                	mov    (%eax),%eax
  801584:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801587:	8b 52 04             	mov    0x4(%edx),%edx
  80158a:	89 50 04             	mov    %edx,0x4(%eax)
  80158d:	eb 0b                	jmp    80159a <free+0x82>
  80158f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801592:	8b 40 04             	mov    0x4(%eax),%eax
  801595:	a3 44 40 80 00       	mov    %eax,0x804044
  80159a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159d:	8b 40 04             	mov    0x4(%eax),%eax
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	74 0f                	je     8015b3 <free+0x9b>
  8015a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a7:	8b 40 04             	mov    0x4(%eax),%eax
  8015aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ad:	8b 12                	mov    (%edx),%edx
  8015af:	89 10                	mov    %edx,(%eax)
  8015b1:	eb 0a                	jmp    8015bd <free+0xa5>
  8015b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b6:	8b 00                	mov    (%eax),%eax
  8015b8:	a3 40 40 80 00       	mov    %eax,0x804040
  8015bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015d0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015d5:	48                   	dec    %eax
  8015d6:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8015db:	83 ec 0c             	sub    $0xc,%esp
  8015de:	ff 75 f0             	pushl  -0x10(%ebp)
  8015e1:	e8 83 12 00 00       	call   802869 <insert_sorted_with_merge_freeList>
  8015e6:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015e9:	90                   	nop
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 28             	sub    $0x28,%esp
  8015f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f5:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f8:	e8 fe fc ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  8015fd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801601:	75 0a                	jne    80160d <smalloc+0x21>
  801603:	b8 00 00 00 00       	mov    $0x0,%eax
  801608:	e9 86 00 00 00       	jmp    801693 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  80160d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801614:	8b 55 0c             	mov    0xc(%ebp),%edx
  801617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161a:	01 d0                	add    %edx,%eax
  80161c:	48                   	dec    %eax
  80161d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801623:	ba 00 00 00 00       	mov    $0x0,%edx
  801628:	f7 75 f4             	divl   -0xc(%ebp)
  80162b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162e:	29 d0                	sub    %edx,%eax
  801630:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801633:	e8 e4 06 00 00       	call   801d1c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801638:	85 c0                	test   %eax,%eax
  80163a:	74 52                	je     80168e <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  80163c:	83 ec 0c             	sub    $0xc,%esp
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	e8 e6 0d 00 00       	call   80242d <alloc_block_FF>
  801647:	83 c4 10             	add    $0x10,%esp
  80164a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  80164d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801651:	75 07                	jne    80165a <smalloc+0x6e>
			return NULL ;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	eb 39                	jmp    801693 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80165a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165d:	8b 40 08             	mov    0x8(%eax),%eax
  801660:	89 c2                	mov    %eax,%edx
  801662:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801666:	52                   	push   %edx
  801667:	50                   	push   %eax
  801668:	ff 75 0c             	pushl  0xc(%ebp)
  80166b:	ff 75 08             	pushl  0x8(%ebp)
  80166e:	e8 2e 04 00 00       	call   801aa1 <sys_createSharedObject>
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801679:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80167d:	79 07                	jns    801686 <smalloc+0x9a>
			return (void*)NULL ;
  80167f:	b8 00 00 00 00       	mov    $0x0,%eax
  801684:	eb 0d                	jmp    801693 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801686:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801689:	8b 40 08             	mov    0x8(%eax),%eax
  80168c:	eb 05                	jmp    801693 <smalloc+0xa7>
		}
		return (void*)NULL ;
  80168e:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80169b:	e8 5b fc ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016a0:	83 ec 08             	sub    $0x8,%esp
  8016a3:	ff 75 0c             	pushl  0xc(%ebp)
  8016a6:	ff 75 08             	pushl  0x8(%ebp)
  8016a9:	e8 1d 04 00 00       	call   801acb <sys_getSizeOfSharedObject>
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8016b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016b8:	75 0a                	jne    8016c4 <sget+0x2f>
			return NULL ;
  8016ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bf:	e9 83 00 00 00       	jmp    801747 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8016c4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d1:	01 d0                	add    %edx,%eax
  8016d3:	48                   	dec    %eax
  8016d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016da:	ba 00 00 00 00       	mov    $0x0,%edx
  8016df:	f7 75 f0             	divl   -0x10(%ebp)
  8016e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e5:	29 d0                	sub    %edx,%eax
  8016e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ea:	e8 2d 06 00 00       	call   801d1c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	74 4f                	je     801742 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8016f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f6:	83 ec 0c             	sub    $0xc,%esp
  8016f9:	50                   	push   %eax
  8016fa:	e8 2e 0d 00 00       	call   80242d <alloc_block_FF>
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  801705:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801709:	75 07                	jne    801712 <sget+0x7d>
					return (void*)NULL ;
  80170b:	b8 00 00 00 00       	mov    $0x0,%eax
  801710:	eb 35                	jmp    801747 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  801712:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801715:	8b 40 08             	mov    0x8(%eax),%eax
  801718:	83 ec 04             	sub    $0x4,%esp
  80171b:	50                   	push   %eax
  80171c:	ff 75 0c             	pushl  0xc(%ebp)
  80171f:	ff 75 08             	pushl  0x8(%ebp)
  801722:	e8 c1 03 00 00       	call   801ae8 <sys_getSharedObject>
  801727:	83 c4 10             	add    $0x10,%esp
  80172a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  80172d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801731:	79 07                	jns    80173a <sget+0xa5>
				return (void*)NULL ;
  801733:	b8 00 00 00 00       	mov    $0x0,%eax
  801738:	eb 0d                	jmp    801747 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  80173a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80173d:	8b 40 08             	mov    0x8(%eax),%eax
  801740:	eb 05                	jmp    801747 <sget+0xb2>


		}
	return (void*)NULL ;
  801742:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801747:	c9                   	leave  
  801748:	c3                   	ret    

00801749 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80174f:	e8 a7 fb ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	68 a0 3a 80 00       	push   $0x803aa0
  80175c:	68 f9 00 00 00       	push   $0xf9
  801761:	68 93 3a 80 00       	push   $0x803a93
  801766:	e8 52 eb ff ff       	call   8002bd <_panic>

0080176b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801771:	83 ec 04             	sub    $0x4,%esp
  801774:	68 c8 3a 80 00       	push   $0x803ac8
  801779:	68 0d 01 00 00       	push   $0x10d
  80177e:	68 93 3a 80 00       	push   $0x803a93
  801783:	e8 35 eb ff ff       	call   8002bd <_panic>

00801788 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178e:	83 ec 04             	sub    $0x4,%esp
  801791:	68 ec 3a 80 00       	push   $0x803aec
  801796:	68 18 01 00 00       	push   $0x118
  80179b:	68 93 3a 80 00       	push   $0x803a93
  8017a0:	e8 18 eb ff ff       	call   8002bd <_panic>

008017a5 <shrink>:

}
void shrink(uint32 newSize)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ab:	83 ec 04             	sub    $0x4,%esp
  8017ae:	68 ec 3a 80 00       	push   $0x803aec
  8017b3:	68 1d 01 00 00       	push   $0x11d
  8017b8:	68 93 3a 80 00       	push   $0x803a93
  8017bd:	e8 fb ea ff ff       	call   8002bd <_panic>

008017c2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c8:	83 ec 04             	sub    $0x4,%esp
  8017cb:	68 ec 3a 80 00       	push   $0x803aec
  8017d0:	68 22 01 00 00       	push   $0x122
  8017d5:	68 93 3a 80 00       	push   $0x803a93
  8017da:	e8 de ea ff ff       	call   8002bd <_panic>

008017df <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	57                   	push   %edi
  8017e3:	56                   	push   %esi
  8017e4:	53                   	push   %ebx
  8017e5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017f7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017fa:	cd 30                	int    $0x30
  8017fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	5b                   	pop    %ebx
  801806:	5e                   	pop    %esi
  801807:	5f                   	pop    %edi
  801808:	5d                   	pop    %ebp
  801809:	c3                   	ret    

0080180a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 04             	sub    $0x4,%esp
  801810:	8b 45 10             	mov    0x10(%ebp),%eax
  801813:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801816:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80181a:	8b 45 08             	mov    0x8(%ebp),%eax
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	52                   	push   %edx
  801822:	ff 75 0c             	pushl  0xc(%ebp)
  801825:	50                   	push   %eax
  801826:	6a 00                	push   $0x0
  801828:	e8 b2 ff ff ff       	call   8017df <syscall>
  80182d:	83 c4 18             	add    $0x18,%esp
}
  801830:	90                   	nop
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sys_cgetc>:

int
sys_cgetc(void)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 01                	push   $0x1
  801842:	e8 98 ff ff ff       	call   8017df <syscall>
  801847:	83 c4 18             	add    $0x18,%esp
}
  80184a:	c9                   	leave  
  80184b:	c3                   	ret    

0080184c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80184f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	6a 00                	push   $0x0
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	52                   	push   %edx
  80185c:	50                   	push   %eax
  80185d:	6a 05                	push   $0x5
  80185f:	e8 7b ff ff ff       	call   8017df <syscall>
  801864:	83 c4 18             	add    $0x18,%esp
}
  801867:	c9                   	leave  
  801868:	c3                   	ret    

00801869 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	56                   	push   %esi
  80186d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80186e:	8b 75 18             	mov    0x18(%ebp),%esi
  801871:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801874:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801877:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187a:	8b 45 08             	mov    0x8(%ebp),%eax
  80187d:	56                   	push   %esi
  80187e:	53                   	push   %ebx
  80187f:	51                   	push   %ecx
  801880:	52                   	push   %edx
  801881:	50                   	push   %eax
  801882:	6a 06                	push   $0x6
  801884:	e8 56 ff ff ff       	call   8017df <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188f:	5b                   	pop    %ebx
  801890:	5e                   	pop    %esi
  801891:	5d                   	pop    %ebp
  801892:	c3                   	ret    

00801893 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801896:	8b 55 0c             	mov    0xc(%ebp),%edx
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	52                   	push   %edx
  8018a3:	50                   	push   %eax
  8018a4:	6a 07                	push   $0x7
  8018a6:	e8 34 ff ff ff       	call   8017df <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	ff 75 08             	pushl  0x8(%ebp)
  8018bf:	6a 08                	push   $0x8
  8018c1:	e8 19 ff ff ff       	call   8017df <syscall>
  8018c6:	83 c4 18             	add    $0x18,%esp
}
  8018c9:	c9                   	leave  
  8018ca:	c3                   	ret    

008018cb <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018cb:	55                   	push   %ebp
  8018cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 09                	push   $0x9
  8018da:	e8 00 ff ff ff       	call   8017df <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
}
  8018e2:	c9                   	leave  
  8018e3:	c3                   	ret    

008018e4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 0a                	push   $0xa
  8018f3:	e8 e7 fe ff ff       	call   8017df <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
}
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 0b                	push   $0xb
  80190c:	e8 ce fe ff ff       	call   8017df <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	ff 75 0c             	pushl  0xc(%ebp)
  801922:	ff 75 08             	pushl  0x8(%ebp)
  801925:	6a 0f                	push   $0xf
  801927:	e8 b3 fe ff ff       	call   8017df <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
	return;
  80192f:	90                   	nop
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	ff 75 0c             	pushl  0xc(%ebp)
  80193e:	ff 75 08             	pushl  0x8(%ebp)
  801941:	6a 10                	push   $0x10
  801943:	e8 97 fe ff ff       	call   8017df <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
	return ;
  80194b:	90                   	nop
}
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	ff 75 10             	pushl  0x10(%ebp)
  801958:	ff 75 0c             	pushl  0xc(%ebp)
  80195b:	ff 75 08             	pushl  0x8(%ebp)
  80195e:	6a 11                	push   $0x11
  801960:	e8 7a fe ff ff       	call   8017df <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
	return ;
  801968:	90                   	nop
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 0c                	push   $0xc
  80197a:	e8 60 fe ff ff       	call   8017df <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	ff 75 08             	pushl  0x8(%ebp)
  801992:	6a 0d                	push   $0xd
  801994:	e8 46 fe ff ff       	call   8017df <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 0e                	push   $0xe
  8019ad:	e8 2d fe ff ff       	call   8017df <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	90                   	nop
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 13                	push   $0x13
  8019c7:	e8 13 fe ff ff       	call   8017df <syscall>
  8019cc:	83 c4 18             	add    $0x18,%esp
}
  8019cf:	90                   	nop
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 14                	push   $0x14
  8019e1:	e8 f9 fd ff ff       	call   8017df <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	90                   	nop
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_cputc>:


void
sys_cputc(const char c)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
  8019ef:	83 ec 04             	sub    $0x4,%esp
  8019f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019f8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	50                   	push   %eax
  801a05:	6a 15                	push   $0x15
  801a07:	e8 d3 fd ff ff       	call   8017df <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	90                   	nop
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 16                	push   $0x16
  801a21:	e8 b9 fd ff ff       	call   8017df <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	90                   	nop
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	ff 75 0c             	pushl  0xc(%ebp)
  801a3b:	50                   	push   %eax
  801a3c:	6a 17                	push   $0x17
  801a3e:	e8 9c fd ff ff       	call   8017df <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	52                   	push   %edx
  801a58:	50                   	push   %eax
  801a59:	6a 1a                	push   $0x1a
  801a5b:	e8 7f fd ff ff       	call   8017df <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	52                   	push   %edx
  801a75:	50                   	push   %eax
  801a76:	6a 18                	push   $0x18
  801a78:	e8 62 fd ff ff       	call   8017df <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	90                   	nop
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	52                   	push   %edx
  801a93:	50                   	push   %eax
  801a94:	6a 19                	push   $0x19
  801a96:	e8 44 fd ff ff       	call   8017df <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	90                   	nop
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 04             	sub    $0x4,%esp
  801aa7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aaa:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aad:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ab0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	6a 00                	push   $0x0
  801ab9:	51                   	push   %ecx
  801aba:	52                   	push   %edx
  801abb:	ff 75 0c             	pushl  0xc(%ebp)
  801abe:	50                   	push   %eax
  801abf:	6a 1b                	push   $0x1b
  801ac1:	e8 19 fd ff ff       	call   8017df <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ace:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	52                   	push   %edx
  801adb:	50                   	push   %eax
  801adc:	6a 1c                	push   $0x1c
  801ade:	e8 fc fc ff ff       	call   8017df <syscall>
  801ae3:	83 c4 18             	add    $0x18,%esp
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801aeb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aee:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	51                   	push   %ecx
  801af9:	52                   	push   %edx
  801afa:	50                   	push   %eax
  801afb:	6a 1d                	push   $0x1d
  801afd:	e8 dd fc ff ff       	call   8017df <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	52                   	push   %edx
  801b17:	50                   	push   %eax
  801b18:	6a 1e                	push   $0x1e
  801b1a:	e8 c0 fc ff ff       	call   8017df <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 1f                	push   $0x1f
  801b33:	e8 a7 fc ff ff       	call   8017df <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	6a 00                	push   $0x0
  801b45:	ff 75 14             	pushl  0x14(%ebp)
  801b48:	ff 75 10             	pushl  0x10(%ebp)
  801b4b:	ff 75 0c             	pushl  0xc(%ebp)
  801b4e:	50                   	push   %eax
  801b4f:	6a 20                	push   $0x20
  801b51:	e8 89 fc ff ff       	call   8017df <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	50                   	push   %eax
  801b6a:	6a 21                	push   $0x21
  801b6c:	e8 6e fc ff ff       	call   8017df <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	90                   	nop
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	50                   	push   %eax
  801b86:	6a 22                	push   $0x22
  801b88:	e8 52 fc ff ff       	call   8017df <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 02                	push   $0x2
  801ba1:	e8 39 fc ff ff       	call   8017df <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 03                	push   $0x3
  801bba:	e8 20 fc ff ff       	call   8017df <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 04                	push   $0x4
  801bd3:	e8 07 fc ff ff       	call   8017df <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	c9                   	leave  
  801bdc:	c3                   	ret    

00801bdd <sys_exit_env>:


void sys_exit_env(void)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 23                	push   $0x23
  801bec:	e8 ee fb ff ff       	call   8017df <syscall>
  801bf1:	83 c4 18             	add    $0x18,%esp
}
  801bf4:	90                   	nop
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bfd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c00:	8d 50 04             	lea    0x4(%eax),%edx
  801c03:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	52                   	push   %edx
  801c0d:	50                   	push   %eax
  801c0e:	6a 24                	push   $0x24
  801c10:	e8 ca fb ff ff       	call   8017df <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
	return result;
  801c18:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c21:	89 01                	mov    %eax,(%ecx)
  801c23:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	c9                   	leave  
  801c2a:	c2 04 00             	ret    $0x4

00801c2d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	ff 75 10             	pushl  0x10(%ebp)
  801c37:	ff 75 0c             	pushl  0xc(%ebp)
  801c3a:	ff 75 08             	pushl  0x8(%ebp)
  801c3d:	6a 12                	push   $0x12
  801c3f:	e8 9b fb ff ff       	call   8017df <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
	return ;
  801c47:	90                   	nop
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_rcr2>:
uint32 sys_rcr2()
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 25                	push   $0x25
  801c59:	e8 81 fb ff ff       	call   8017df <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	c9                   	leave  
  801c62:	c3                   	ret    

00801c63 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	83 ec 04             	sub    $0x4,%esp
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c6f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	50                   	push   %eax
  801c7c:	6a 26                	push   $0x26
  801c7e:	e8 5c fb ff ff       	call   8017df <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
	return ;
  801c86:	90                   	nop
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <rsttst>:
void rsttst()
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 28                	push   $0x28
  801c98:	e8 42 fb ff ff       	call   8017df <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca0:	90                   	nop
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 04             	sub    $0x4,%esp
  801ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  801cac:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801caf:	8b 55 18             	mov    0x18(%ebp),%edx
  801cb2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cb6:	52                   	push   %edx
  801cb7:	50                   	push   %eax
  801cb8:	ff 75 10             	pushl  0x10(%ebp)
  801cbb:	ff 75 0c             	pushl  0xc(%ebp)
  801cbe:	ff 75 08             	pushl  0x8(%ebp)
  801cc1:	6a 27                	push   $0x27
  801cc3:	e8 17 fb ff ff       	call   8017df <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccb:	90                   	nop
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <chktst>:
void chktst(uint32 n)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	ff 75 08             	pushl  0x8(%ebp)
  801cdc:	6a 29                	push   $0x29
  801cde:	e8 fc fa ff ff       	call   8017df <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce6:	90                   	nop
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <inctst>:

void inctst()
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 2a                	push   $0x2a
  801cf8:	e8 e2 fa ff ff       	call   8017df <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
	return ;
  801d00:	90                   	nop
}
  801d01:	c9                   	leave  
  801d02:	c3                   	ret    

00801d03 <gettst>:
uint32 gettst()
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 2b                	push   $0x2b
  801d12:	e8 c8 fa ff ff       	call   8017df <syscall>
  801d17:	83 c4 18             	add    $0x18,%esp
}
  801d1a:	c9                   	leave  
  801d1b:	c3                   	ret    

00801d1c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d1c:	55                   	push   %ebp
  801d1d:	89 e5                	mov    %esp,%ebp
  801d1f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 2c                	push   $0x2c
  801d2e:	e8 ac fa ff ff       	call   8017df <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
  801d36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d39:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d3d:	75 07                	jne    801d46 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d3f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d44:	eb 05                	jmp    801d4b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 2c                	push   $0x2c
  801d5f:	e8 7b fa ff ff       	call   8017df <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
  801d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d6a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d6e:	75 07                	jne    801d77 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d70:	b8 01 00 00 00       	mov    $0x1,%eax
  801d75:	eb 05                	jmp    801d7c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7c:	c9                   	leave  
  801d7d:	c3                   	ret    

00801d7e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d7e:	55                   	push   %ebp
  801d7f:	89 e5                	mov    %esp,%ebp
  801d81:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 2c                	push   $0x2c
  801d90:	e8 4a fa ff ff       	call   8017df <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
  801d98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d9b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d9f:	75 07                	jne    801da8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801da1:	b8 01 00 00 00       	mov    $0x1,%eax
  801da6:	eb 05                	jmp    801dad <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801da8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 2c                	push   $0x2c
  801dc1:	e8 19 fa ff ff       	call   8017df <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
  801dc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dcc:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dd0:	75 07                	jne    801dd9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd7:	eb 05                	jmp    801dde <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	ff 75 08             	pushl  0x8(%ebp)
  801dee:	6a 2d                	push   $0x2d
  801df0:	e8 ea f9 ff ff       	call   8017df <syscall>
  801df5:	83 c4 18             	add    $0x18,%esp
	return ;
  801df8:	90                   	nop
}
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e02:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e08:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0b:	6a 00                	push   $0x0
  801e0d:	53                   	push   %ebx
  801e0e:	51                   	push   %ecx
  801e0f:	52                   	push   %edx
  801e10:	50                   	push   %eax
  801e11:	6a 2e                	push   $0x2e
  801e13:	e8 c7 f9 ff ff       	call   8017df <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e26:	8b 45 08             	mov    0x8(%ebp),%eax
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	52                   	push   %edx
  801e30:	50                   	push   %eax
  801e31:	6a 2f                	push   $0x2f
  801e33:	e8 a7 f9 ff ff       	call   8017df <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e43:	83 ec 0c             	sub    $0xc,%esp
  801e46:	68 fc 3a 80 00       	push   $0x803afc
  801e4b:	e8 21 e7 ff ff       	call   800571 <cprintf>
  801e50:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e53:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e5a:	83 ec 0c             	sub    $0xc,%esp
  801e5d:	68 28 3b 80 00       	push   $0x803b28
  801e62:	e8 0a e7 ff ff       	call   800571 <cprintf>
  801e67:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e6a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e6e:	a1 38 41 80 00       	mov    0x804138,%eax
  801e73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e76:	eb 56                	jmp    801ece <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e7c:	74 1c                	je     801e9a <print_mem_block_lists+0x5d>
  801e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e81:	8b 50 08             	mov    0x8(%eax),%edx
  801e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e87:	8b 48 08             	mov    0x8(%eax),%ecx
  801e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e90:	01 c8                	add    %ecx,%eax
  801e92:	39 c2                	cmp    %eax,%edx
  801e94:	73 04                	jae    801e9a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e96:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9d:	8b 50 08             	mov    0x8(%eax),%edx
  801ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea6:	01 c2                	add    %eax,%edx
  801ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eab:	8b 40 08             	mov    0x8(%eax),%eax
  801eae:	83 ec 04             	sub    $0x4,%esp
  801eb1:	52                   	push   %edx
  801eb2:	50                   	push   %eax
  801eb3:	68 3d 3b 80 00       	push   $0x803b3d
  801eb8:	e8 b4 e6 ff ff       	call   800571 <cprintf>
  801ebd:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec6:	a1 40 41 80 00       	mov    0x804140,%eax
  801ecb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ece:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed2:	74 07                	je     801edb <print_mem_block_lists+0x9e>
  801ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed7:	8b 00                	mov    (%eax),%eax
  801ed9:	eb 05                	jmp    801ee0 <print_mem_block_lists+0xa3>
  801edb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee0:	a3 40 41 80 00       	mov    %eax,0x804140
  801ee5:	a1 40 41 80 00       	mov    0x804140,%eax
  801eea:	85 c0                	test   %eax,%eax
  801eec:	75 8a                	jne    801e78 <print_mem_block_lists+0x3b>
  801eee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef2:	75 84                	jne    801e78 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ef4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ef8:	75 10                	jne    801f0a <print_mem_block_lists+0xcd>
  801efa:	83 ec 0c             	sub    $0xc,%esp
  801efd:	68 4c 3b 80 00       	push   $0x803b4c
  801f02:	e8 6a e6 ff ff       	call   800571 <cprintf>
  801f07:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f11:	83 ec 0c             	sub    $0xc,%esp
  801f14:	68 70 3b 80 00       	push   $0x803b70
  801f19:	e8 53 e6 ff ff       	call   800571 <cprintf>
  801f1e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f21:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f25:	a1 40 40 80 00       	mov    0x804040,%eax
  801f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2d:	eb 56                	jmp    801f85 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f33:	74 1c                	je     801f51 <print_mem_block_lists+0x114>
  801f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f38:	8b 50 08             	mov    0x8(%eax),%edx
  801f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3e:	8b 48 08             	mov    0x8(%eax),%ecx
  801f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f44:	8b 40 0c             	mov    0xc(%eax),%eax
  801f47:	01 c8                	add    %ecx,%eax
  801f49:	39 c2                	cmp    %eax,%edx
  801f4b:	73 04                	jae    801f51 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f4d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f54:	8b 50 08             	mov    0x8(%eax),%edx
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5d:	01 c2                	add    %eax,%edx
  801f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f62:	8b 40 08             	mov    0x8(%eax),%eax
  801f65:	83 ec 04             	sub    $0x4,%esp
  801f68:	52                   	push   %edx
  801f69:	50                   	push   %eax
  801f6a:	68 3d 3b 80 00       	push   $0x803b3d
  801f6f:	e8 fd e5 ff ff       	call   800571 <cprintf>
  801f74:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f7d:	a1 48 40 80 00       	mov    0x804048,%eax
  801f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f89:	74 07                	je     801f92 <print_mem_block_lists+0x155>
  801f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8e:	8b 00                	mov    (%eax),%eax
  801f90:	eb 05                	jmp    801f97 <print_mem_block_lists+0x15a>
  801f92:	b8 00 00 00 00       	mov    $0x0,%eax
  801f97:	a3 48 40 80 00       	mov    %eax,0x804048
  801f9c:	a1 48 40 80 00       	mov    0x804048,%eax
  801fa1:	85 c0                	test   %eax,%eax
  801fa3:	75 8a                	jne    801f2f <print_mem_block_lists+0xf2>
  801fa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa9:	75 84                	jne    801f2f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fab:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801faf:	75 10                	jne    801fc1 <print_mem_block_lists+0x184>
  801fb1:	83 ec 0c             	sub    $0xc,%esp
  801fb4:	68 88 3b 80 00       	push   $0x803b88
  801fb9:	e8 b3 e5 ff ff       	call   800571 <cprintf>
  801fbe:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fc1:	83 ec 0c             	sub    $0xc,%esp
  801fc4:	68 fc 3a 80 00       	push   $0x803afc
  801fc9:	e8 a3 e5 ff ff       	call   800571 <cprintf>
  801fce:	83 c4 10             	add    $0x10,%esp

}
  801fd1:	90                   	nop
  801fd2:	c9                   	leave  
  801fd3:	c3                   	ret    

00801fd4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801fda:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fe1:	00 00 00 
  801fe4:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801feb:	00 00 00 
  801fee:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ff5:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801ff8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fff:	e9 9e 00 00 00       	jmp    8020a2 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  802004:	a1 50 40 80 00       	mov    0x804050,%eax
  802009:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200c:	c1 e2 04             	shl    $0x4,%edx
  80200f:	01 d0                	add    %edx,%eax
  802011:	85 c0                	test   %eax,%eax
  802013:	75 14                	jne    802029 <initialize_MemBlocksList+0x55>
  802015:	83 ec 04             	sub    $0x4,%esp
  802018:	68 b0 3b 80 00       	push   $0x803bb0
  80201d:	6a 43                	push   $0x43
  80201f:	68 d3 3b 80 00       	push   $0x803bd3
  802024:	e8 94 e2 ff ff       	call   8002bd <_panic>
  802029:	a1 50 40 80 00       	mov    0x804050,%eax
  80202e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802031:	c1 e2 04             	shl    $0x4,%edx
  802034:	01 d0                	add    %edx,%eax
  802036:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80203c:	89 10                	mov    %edx,(%eax)
  80203e:	8b 00                	mov    (%eax),%eax
  802040:	85 c0                	test   %eax,%eax
  802042:	74 18                	je     80205c <initialize_MemBlocksList+0x88>
  802044:	a1 48 41 80 00       	mov    0x804148,%eax
  802049:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80204f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802052:	c1 e1 04             	shl    $0x4,%ecx
  802055:	01 ca                	add    %ecx,%edx
  802057:	89 50 04             	mov    %edx,0x4(%eax)
  80205a:	eb 12                	jmp    80206e <initialize_MemBlocksList+0x9a>
  80205c:	a1 50 40 80 00       	mov    0x804050,%eax
  802061:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802064:	c1 e2 04             	shl    $0x4,%edx
  802067:	01 d0                	add    %edx,%eax
  802069:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80206e:	a1 50 40 80 00       	mov    0x804050,%eax
  802073:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802076:	c1 e2 04             	shl    $0x4,%edx
  802079:	01 d0                	add    %edx,%eax
  80207b:	a3 48 41 80 00       	mov    %eax,0x804148
  802080:	a1 50 40 80 00       	mov    0x804050,%eax
  802085:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802088:	c1 e2 04             	shl    $0x4,%edx
  80208b:	01 d0                	add    %edx,%eax
  80208d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802094:	a1 54 41 80 00       	mov    0x804154,%eax
  802099:	40                   	inc    %eax
  80209a:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  80209f:	ff 45 f4             	incl   -0xc(%ebp)
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020a8:	0f 82 56 ff ff ff    	jb     802004 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8020ae:	90                   	nop
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8020b7:	a1 38 41 80 00       	mov    0x804138,%eax
  8020bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020bf:	eb 18                	jmp    8020d9 <find_block+0x28>
	{
		if (ele->sva==va)
  8020c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c4:	8b 40 08             	mov    0x8(%eax),%eax
  8020c7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020ca:	75 05                	jne    8020d1 <find_block+0x20>
			return ele;
  8020cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020cf:	eb 7b                	jmp    80214c <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8020d1:	a1 40 41 80 00       	mov    0x804140,%eax
  8020d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020dd:	74 07                	je     8020e6 <find_block+0x35>
  8020df:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e2:	8b 00                	mov    (%eax),%eax
  8020e4:	eb 05                	jmp    8020eb <find_block+0x3a>
  8020e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020eb:	a3 40 41 80 00       	mov    %eax,0x804140
  8020f0:	a1 40 41 80 00       	mov    0x804140,%eax
  8020f5:	85 c0                	test   %eax,%eax
  8020f7:	75 c8                	jne    8020c1 <find_block+0x10>
  8020f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020fd:	75 c2                	jne    8020c1 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020ff:	a1 40 40 80 00       	mov    0x804040,%eax
  802104:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802107:	eb 18                	jmp    802121 <find_block+0x70>
	{
		if (ele->sva==va)
  802109:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80210c:	8b 40 08             	mov    0x8(%eax),%eax
  80210f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802112:	75 05                	jne    802119 <find_block+0x68>
					return ele;
  802114:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802117:	eb 33                	jmp    80214c <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802119:	a1 48 40 80 00       	mov    0x804048,%eax
  80211e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802121:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802125:	74 07                	je     80212e <find_block+0x7d>
  802127:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80212a:	8b 00                	mov    (%eax),%eax
  80212c:	eb 05                	jmp    802133 <find_block+0x82>
  80212e:	b8 00 00 00 00       	mov    $0x0,%eax
  802133:	a3 48 40 80 00       	mov    %eax,0x804048
  802138:	a1 48 40 80 00       	mov    0x804048,%eax
  80213d:	85 c0                	test   %eax,%eax
  80213f:	75 c8                	jne    802109 <find_block+0x58>
  802141:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802145:	75 c2                	jne    802109 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802147:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80214c:	c9                   	leave  
  80214d:	c3                   	ret    

0080214e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802154:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802159:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80215c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802160:	75 62                	jne    8021c4 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802162:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802166:	75 14                	jne    80217c <insert_sorted_allocList+0x2e>
  802168:	83 ec 04             	sub    $0x4,%esp
  80216b:	68 b0 3b 80 00       	push   $0x803bb0
  802170:	6a 69                	push   $0x69
  802172:	68 d3 3b 80 00       	push   $0x803bd3
  802177:	e8 41 e1 ff ff       	call   8002bd <_panic>
  80217c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	89 10                	mov    %edx,(%eax)
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	8b 00                	mov    (%eax),%eax
  80218c:	85 c0                	test   %eax,%eax
  80218e:	74 0d                	je     80219d <insert_sorted_allocList+0x4f>
  802190:	a1 40 40 80 00       	mov    0x804040,%eax
  802195:	8b 55 08             	mov    0x8(%ebp),%edx
  802198:	89 50 04             	mov    %edx,0x4(%eax)
  80219b:	eb 08                	jmp    8021a5 <insert_sorted_allocList+0x57>
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	a3 44 40 80 00       	mov    %eax,0x804044
  8021a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a8:	a3 40 40 80 00       	mov    %eax,0x804040
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021bc:	40                   	inc    %eax
  8021bd:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021c2:	eb 72                	jmp    802236 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8021c4:	a1 40 40 80 00       	mov    0x804040,%eax
  8021c9:	8b 50 08             	mov    0x8(%eax),%edx
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	8b 40 08             	mov    0x8(%eax),%eax
  8021d2:	39 c2                	cmp    %eax,%edx
  8021d4:	76 60                	jbe    802236 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8021d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021da:	75 14                	jne    8021f0 <insert_sorted_allocList+0xa2>
  8021dc:	83 ec 04             	sub    $0x4,%esp
  8021df:	68 b0 3b 80 00       	push   $0x803bb0
  8021e4:	6a 6d                	push   $0x6d
  8021e6:	68 d3 3b 80 00       	push   $0x803bd3
  8021eb:	e8 cd e0 ff ff       	call   8002bd <_panic>
  8021f0:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	89 10                	mov    %edx,(%eax)
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	8b 00                	mov    (%eax),%eax
  802200:	85 c0                	test   %eax,%eax
  802202:	74 0d                	je     802211 <insert_sorted_allocList+0xc3>
  802204:	a1 40 40 80 00       	mov    0x804040,%eax
  802209:	8b 55 08             	mov    0x8(%ebp),%edx
  80220c:	89 50 04             	mov    %edx,0x4(%eax)
  80220f:	eb 08                	jmp    802219 <insert_sorted_allocList+0xcb>
  802211:	8b 45 08             	mov    0x8(%ebp),%eax
  802214:	a3 44 40 80 00       	mov    %eax,0x804044
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	a3 40 40 80 00       	mov    %eax,0x804040
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80222b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802230:	40                   	inc    %eax
  802231:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802236:	a1 40 40 80 00       	mov    0x804040,%eax
  80223b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80223e:	e9 b9 01 00 00       	jmp    8023fc <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	8b 50 08             	mov    0x8(%eax),%edx
  802249:	a1 40 40 80 00       	mov    0x804040,%eax
  80224e:	8b 40 08             	mov    0x8(%eax),%eax
  802251:	39 c2                	cmp    %eax,%edx
  802253:	76 7c                	jbe    8022d1 <insert_sorted_allocList+0x183>
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	8b 50 08             	mov    0x8(%eax),%edx
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 40 08             	mov    0x8(%eax),%eax
  802261:	39 c2                	cmp    %eax,%edx
  802263:	73 6c                	jae    8022d1 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802265:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802269:	74 06                	je     802271 <insert_sorted_allocList+0x123>
  80226b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80226f:	75 14                	jne    802285 <insert_sorted_allocList+0x137>
  802271:	83 ec 04             	sub    $0x4,%esp
  802274:	68 ec 3b 80 00       	push   $0x803bec
  802279:	6a 75                	push   $0x75
  80227b:	68 d3 3b 80 00       	push   $0x803bd3
  802280:	e8 38 e0 ff ff       	call   8002bd <_panic>
  802285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802288:	8b 50 04             	mov    0x4(%eax),%edx
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	89 50 04             	mov    %edx,0x4(%eax)
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802297:	89 10                	mov    %edx,(%eax)
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	8b 40 04             	mov    0x4(%eax),%eax
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	74 0d                	je     8022b0 <insert_sorted_allocList+0x162>
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 40 04             	mov    0x4(%eax),%eax
  8022a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ac:	89 10                	mov    %edx,(%eax)
  8022ae:	eb 08                	jmp    8022b8 <insert_sorted_allocList+0x16a>
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	a3 40 40 80 00       	mov    %eax,0x804040
  8022b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022be:	89 50 04             	mov    %edx,0x4(%eax)
  8022c1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022c6:	40                   	inc    %eax
  8022c7:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8022cc:	e9 59 01 00 00       	jmp    80242a <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	8b 50 08             	mov    0x8(%eax),%edx
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 40 08             	mov    0x8(%eax),%eax
  8022dd:	39 c2                	cmp    %eax,%edx
  8022df:	0f 86 98 00 00 00    	jbe    80237d <insert_sorted_allocList+0x22f>
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	8b 50 08             	mov    0x8(%eax),%edx
  8022eb:	a1 44 40 80 00       	mov    0x804044,%eax
  8022f0:	8b 40 08             	mov    0x8(%eax),%eax
  8022f3:	39 c2                	cmp    %eax,%edx
  8022f5:	0f 83 82 00 00 00    	jae    80237d <insert_sorted_allocList+0x22f>
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	8b 50 08             	mov    0x8(%eax),%edx
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 00                	mov    (%eax),%eax
  802306:	8b 40 08             	mov    0x8(%eax),%eax
  802309:	39 c2                	cmp    %eax,%edx
  80230b:	73 70                	jae    80237d <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  80230d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802311:	74 06                	je     802319 <insert_sorted_allocList+0x1cb>
  802313:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802317:	75 14                	jne    80232d <insert_sorted_allocList+0x1df>
  802319:	83 ec 04             	sub    $0x4,%esp
  80231c:	68 24 3c 80 00       	push   $0x803c24
  802321:	6a 7c                	push   $0x7c
  802323:	68 d3 3b 80 00       	push   $0x803bd3
  802328:	e8 90 df ff ff       	call   8002bd <_panic>
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 10                	mov    (%eax),%edx
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	89 10                	mov    %edx,(%eax)
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	8b 00                	mov    (%eax),%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	74 0b                	je     80234b <insert_sorted_allocList+0x1fd>
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 00                	mov    (%eax),%eax
  802345:	8b 55 08             	mov    0x8(%ebp),%edx
  802348:	89 50 04             	mov    %edx,0x4(%eax)
  80234b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234e:	8b 55 08             	mov    0x8(%ebp),%edx
  802351:	89 10                	mov    %edx,(%eax)
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802359:	89 50 04             	mov    %edx,0x4(%eax)
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	8b 00                	mov    (%eax),%eax
  802361:	85 c0                	test   %eax,%eax
  802363:	75 08                	jne    80236d <insert_sorted_allocList+0x21f>
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	a3 44 40 80 00       	mov    %eax,0x804044
  80236d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802372:	40                   	inc    %eax
  802373:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802378:	e9 ad 00 00 00       	jmp    80242a <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	8b 50 08             	mov    0x8(%eax),%edx
  802383:	a1 44 40 80 00       	mov    0x804044,%eax
  802388:	8b 40 08             	mov    0x8(%eax),%eax
  80238b:	39 c2                	cmp    %eax,%edx
  80238d:	76 65                	jbe    8023f4 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  80238f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802393:	75 17                	jne    8023ac <insert_sorted_allocList+0x25e>
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	68 58 3c 80 00       	push   $0x803c58
  80239d:	68 80 00 00 00       	push   $0x80
  8023a2:	68 d3 3b 80 00       	push   $0x803bd3
  8023a7:	e8 11 df ff ff       	call   8002bd <_panic>
  8023ac:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	89 50 04             	mov    %edx,0x4(%eax)
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8b 40 04             	mov    0x4(%eax),%eax
  8023be:	85 c0                	test   %eax,%eax
  8023c0:	74 0c                	je     8023ce <insert_sorted_allocList+0x280>
  8023c2:	a1 44 40 80 00       	mov    0x804044,%eax
  8023c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ca:	89 10                	mov    %edx,(%eax)
  8023cc:	eb 08                	jmp    8023d6 <insert_sorted_allocList+0x288>
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	a3 40 40 80 00       	mov    %eax,0x804040
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	a3 44 40 80 00       	mov    %eax,0x804044
  8023de:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023ec:	40                   	inc    %eax
  8023ed:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8023f2:	eb 36                	jmp    80242a <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8023f4:	a1 48 40 80 00       	mov    0x804048,%eax
  8023f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802400:	74 07                	je     802409 <insert_sorted_allocList+0x2bb>
  802402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802405:	8b 00                	mov    (%eax),%eax
  802407:	eb 05                	jmp    80240e <insert_sorted_allocList+0x2c0>
  802409:	b8 00 00 00 00       	mov    $0x0,%eax
  80240e:	a3 48 40 80 00       	mov    %eax,0x804048
  802413:	a1 48 40 80 00       	mov    0x804048,%eax
  802418:	85 c0                	test   %eax,%eax
  80241a:	0f 85 23 fe ff ff    	jne    802243 <insert_sorted_allocList+0xf5>
  802420:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802424:	0f 85 19 fe ff ff    	jne    802243 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  80242a:	90                   	nop
  80242b:	c9                   	leave  
  80242c:	c3                   	ret    

0080242d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80242d:	55                   	push   %ebp
  80242e:	89 e5                	mov    %esp,%ebp
  802430:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802433:	a1 38 41 80 00       	mov    0x804138,%eax
  802438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80243b:	e9 7c 01 00 00       	jmp    8025bc <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	8b 40 0c             	mov    0xc(%eax),%eax
  802446:	3b 45 08             	cmp    0x8(%ebp),%eax
  802449:	0f 85 90 00 00 00    	jne    8024df <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802455:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802459:	75 17                	jne    802472 <alloc_block_FF+0x45>
  80245b:	83 ec 04             	sub    $0x4,%esp
  80245e:	68 7b 3c 80 00       	push   $0x803c7b
  802463:	68 ba 00 00 00       	push   $0xba
  802468:	68 d3 3b 80 00       	push   $0x803bd3
  80246d:	e8 4b de ff ff       	call   8002bd <_panic>
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	8b 00                	mov    (%eax),%eax
  802477:	85 c0                	test   %eax,%eax
  802479:	74 10                	je     80248b <alloc_block_FF+0x5e>
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	8b 00                	mov    (%eax),%eax
  802480:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802483:	8b 52 04             	mov    0x4(%edx),%edx
  802486:	89 50 04             	mov    %edx,0x4(%eax)
  802489:	eb 0b                	jmp    802496 <alloc_block_FF+0x69>
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 40 04             	mov    0x4(%eax),%eax
  802491:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	8b 40 04             	mov    0x4(%eax),%eax
  80249c:	85 c0                	test   %eax,%eax
  80249e:	74 0f                	je     8024af <alloc_block_FF+0x82>
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 04             	mov    0x4(%eax),%eax
  8024a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a9:	8b 12                	mov    (%edx),%edx
  8024ab:	89 10                	mov    %edx,(%eax)
  8024ad:	eb 0a                	jmp    8024b9 <alloc_block_FF+0x8c>
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 00                	mov    (%eax),%eax
  8024b4:	a3 38 41 80 00       	mov    %eax,0x804138
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024cc:	a1 44 41 80 00       	mov    0x804144,%eax
  8024d1:	48                   	dec    %eax
  8024d2:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8024d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024da:	e9 10 01 00 00       	jmp    8025ef <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e8:	0f 86 c6 00 00 00    	jbe    8025b4 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8024ee:	a1 48 41 80 00       	mov    0x804148,%eax
  8024f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8024f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024fa:	75 17                	jne    802513 <alloc_block_FF+0xe6>
  8024fc:	83 ec 04             	sub    $0x4,%esp
  8024ff:	68 7b 3c 80 00       	push   $0x803c7b
  802504:	68 c2 00 00 00       	push   $0xc2
  802509:	68 d3 3b 80 00       	push   $0x803bd3
  80250e:	e8 aa dd ff ff       	call   8002bd <_panic>
  802513:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802516:	8b 00                	mov    (%eax),%eax
  802518:	85 c0                	test   %eax,%eax
  80251a:	74 10                	je     80252c <alloc_block_FF+0xff>
  80251c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251f:	8b 00                	mov    (%eax),%eax
  802521:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802524:	8b 52 04             	mov    0x4(%edx),%edx
  802527:	89 50 04             	mov    %edx,0x4(%eax)
  80252a:	eb 0b                	jmp    802537 <alloc_block_FF+0x10a>
  80252c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252f:	8b 40 04             	mov    0x4(%eax),%eax
  802532:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802537:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253a:	8b 40 04             	mov    0x4(%eax),%eax
  80253d:	85 c0                	test   %eax,%eax
  80253f:	74 0f                	je     802550 <alloc_block_FF+0x123>
  802541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802544:	8b 40 04             	mov    0x4(%eax),%eax
  802547:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80254a:	8b 12                	mov    (%edx),%edx
  80254c:	89 10                	mov    %edx,(%eax)
  80254e:	eb 0a                	jmp    80255a <alloc_block_FF+0x12d>
  802550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802553:	8b 00                	mov    (%eax),%eax
  802555:	a3 48 41 80 00       	mov    %eax,0x804148
  80255a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802566:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80256d:	a1 54 41 80 00       	mov    0x804154,%eax
  802572:	48                   	dec    %eax
  802573:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	8b 50 08             	mov    0x8(%eax),%edx
  80257e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802581:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802587:	8b 55 08             	mov    0x8(%ebp),%edx
  80258a:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 40 0c             	mov    0xc(%eax),%eax
  802593:	2b 45 08             	sub    0x8(%ebp),%eax
  802596:	89 c2                	mov    %eax,%edx
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  80259e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a1:	8b 50 08             	mov    0x8(%eax),%edx
  8025a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a7:	01 c2                	add    %eax,%edx
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8025af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b2:	eb 3b                	jmp    8025ef <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025b4:	a1 40 41 80 00       	mov    0x804140,%eax
  8025b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c0:	74 07                	je     8025c9 <alloc_block_FF+0x19c>
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 00                	mov    (%eax),%eax
  8025c7:	eb 05                	jmp    8025ce <alloc_block_FF+0x1a1>
  8025c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ce:	a3 40 41 80 00       	mov    %eax,0x804140
  8025d3:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	0f 85 60 fe ff ff    	jne    802440 <alloc_block_FF+0x13>
  8025e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e4:	0f 85 56 fe ff ff    	jne    802440 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8025ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ef:	c9                   	leave  
  8025f0:	c3                   	ret    

008025f1 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8025f1:	55                   	push   %ebp
  8025f2:	89 e5                	mov    %esp,%ebp
  8025f4:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8025f7:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025fe:	a1 38 41 80 00       	mov    0x804138,%eax
  802603:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802606:	eb 3a                	jmp    802642 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 40 0c             	mov    0xc(%eax),%eax
  80260e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802611:	72 27                	jb     80263a <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  802613:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802617:	75 0b                	jne    802624 <alloc_block_BF+0x33>
					best_size= element->size;
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 40 0c             	mov    0xc(%eax),%eax
  80261f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802622:	eb 16                	jmp    80263a <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 50 0c             	mov    0xc(%eax),%edx
  80262a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262d:	39 c2                	cmp    %eax,%edx
  80262f:	77 09                	ja     80263a <alloc_block_BF+0x49>
					best_size=element->size;
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 40 0c             	mov    0xc(%eax),%eax
  802637:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80263a:	a1 40 41 80 00       	mov    0x804140,%eax
  80263f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802642:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802646:	74 07                	je     80264f <alloc_block_BF+0x5e>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	eb 05                	jmp    802654 <alloc_block_BF+0x63>
  80264f:	b8 00 00 00 00       	mov    $0x0,%eax
  802654:	a3 40 41 80 00       	mov    %eax,0x804140
  802659:	a1 40 41 80 00       	mov    0x804140,%eax
  80265e:	85 c0                	test   %eax,%eax
  802660:	75 a6                	jne    802608 <alloc_block_BF+0x17>
  802662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802666:	75 a0                	jne    802608 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802668:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80266c:	0f 84 d3 01 00 00    	je     802845 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802672:	a1 38 41 80 00       	mov    0x804138,%eax
  802677:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267a:	e9 98 01 00 00       	jmp    802817 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  80267f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802682:	3b 45 08             	cmp    0x8(%ebp),%eax
  802685:	0f 86 da 00 00 00    	jbe    802765 <alloc_block_BF+0x174>
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 50 0c             	mov    0xc(%eax),%edx
  802691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802694:	39 c2                	cmp    %eax,%edx
  802696:	0f 85 c9 00 00 00    	jne    802765 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  80269c:	a1 48 41 80 00       	mov    0x804148,%eax
  8026a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8026a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026a8:	75 17                	jne    8026c1 <alloc_block_BF+0xd0>
  8026aa:	83 ec 04             	sub    $0x4,%esp
  8026ad:	68 7b 3c 80 00       	push   $0x803c7b
  8026b2:	68 ea 00 00 00       	push   $0xea
  8026b7:	68 d3 3b 80 00       	push   $0x803bd3
  8026bc:	e8 fc db ff ff       	call   8002bd <_panic>
  8026c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c4:	8b 00                	mov    (%eax),%eax
  8026c6:	85 c0                	test   %eax,%eax
  8026c8:	74 10                	je     8026da <alloc_block_BF+0xe9>
  8026ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026cd:	8b 00                	mov    (%eax),%eax
  8026cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026d2:	8b 52 04             	mov    0x4(%edx),%edx
  8026d5:	89 50 04             	mov    %edx,0x4(%eax)
  8026d8:	eb 0b                	jmp    8026e5 <alloc_block_BF+0xf4>
  8026da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026dd:	8b 40 04             	mov    0x4(%eax),%eax
  8026e0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e8:	8b 40 04             	mov    0x4(%eax),%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	74 0f                	je     8026fe <alloc_block_BF+0x10d>
  8026ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f2:	8b 40 04             	mov    0x4(%eax),%eax
  8026f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026f8:	8b 12                	mov    (%edx),%edx
  8026fa:	89 10                	mov    %edx,(%eax)
  8026fc:	eb 0a                	jmp    802708 <alloc_block_BF+0x117>
  8026fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	a3 48 41 80 00       	mov    %eax,0x804148
  802708:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802714:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271b:	a1 54 41 80 00       	mov    0x804154,%eax
  802720:	48                   	dec    %eax
  802721:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 50 08             	mov    0x8(%eax),%edx
  80272c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272f:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802732:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802735:	8b 55 08             	mov    0x8(%ebp),%edx
  802738:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	8b 40 0c             	mov    0xc(%eax),%eax
  802741:	2b 45 08             	sub    0x8(%ebp),%eax
  802744:	89 c2                	mov    %eax,%edx
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	8b 50 08             	mov    0x8(%eax),%edx
  802752:	8b 45 08             	mov    0x8(%ebp),%eax
  802755:	01 c2                	add    %eax,%edx
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  80275d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802760:	e9 e5 00 00 00       	jmp    80284a <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 50 0c             	mov    0xc(%eax),%edx
  80276b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276e:	39 c2                	cmp    %eax,%edx
  802770:	0f 85 99 00 00 00    	jne    80280f <alloc_block_BF+0x21e>
  802776:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802779:	3b 45 08             	cmp    0x8(%ebp),%eax
  80277c:	0f 85 8d 00 00 00    	jne    80280f <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278c:	75 17                	jne    8027a5 <alloc_block_BF+0x1b4>
  80278e:	83 ec 04             	sub    $0x4,%esp
  802791:	68 7b 3c 80 00       	push   $0x803c7b
  802796:	68 f7 00 00 00       	push   $0xf7
  80279b:	68 d3 3b 80 00       	push   $0x803bd3
  8027a0:	e8 18 db ff ff       	call   8002bd <_panic>
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	8b 00                	mov    (%eax),%eax
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	74 10                	je     8027be <alloc_block_BF+0x1cd>
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 00                	mov    (%eax),%eax
  8027b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b6:	8b 52 04             	mov    0x4(%edx),%edx
  8027b9:	89 50 04             	mov    %edx,0x4(%eax)
  8027bc:	eb 0b                	jmp    8027c9 <alloc_block_BF+0x1d8>
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	8b 40 04             	mov    0x4(%eax),%eax
  8027c4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 40 04             	mov    0x4(%eax),%eax
  8027cf:	85 c0                	test   %eax,%eax
  8027d1:	74 0f                	je     8027e2 <alloc_block_BF+0x1f1>
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 40 04             	mov    0x4(%eax),%eax
  8027d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027dc:	8b 12                	mov    (%edx),%edx
  8027de:	89 10                	mov    %edx,(%eax)
  8027e0:	eb 0a                	jmp    8027ec <alloc_block_BF+0x1fb>
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	a3 38 41 80 00       	mov    %eax,0x804138
  8027ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ff:	a1 44 41 80 00       	mov    0x804144,%eax
  802804:	48                   	dec    %eax
  802805:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  80280a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280d:	eb 3b                	jmp    80284a <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80280f:	a1 40 41 80 00       	mov    0x804140,%eax
  802814:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802817:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281b:	74 07                	je     802824 <alloc_block_BF+0x233>
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	8b 00                	mov    (%eax),%eax
  802822:	eb 05                	jmp    802829 <alloc_block_BF+0x238>
  802824:	b8 00 00 00 00       	mov    $0x0,%eax
  802829:	a3 40 41 80 00       	mov    %eax,0x804140
  80282e:	a1 40 41 80 00       	mov    0x804140,%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	0f 85 44 fe ff ff    	jne    80267f <alloc_block_BF+0x8e>
  80283b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80283f:	0f 85 3a fe ff ff    	jne    80267f <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802845:	b8 00 00 00 00       	mov    $0x0,%eax
  80284a:	c9                   	leave  
  80284b:	c3                   	ret    

0080284c <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80284c:	55                   	push   %ebp
  80284d:	89 e5                	mov    %esp,%ebp
  80284f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802852:	83 ec 04             	sub    $0x4,%esp
  802855:	68 9c 3c 80 00       	push   $0x803c9c
  80285a:	68 04 01 00 00       	push   $0x104
  80285f:	68 d3 3b 80 00       	push   $0x803bd3
  802864:	e8 54 da ff ff       	call   8002bd <_panic>

00802869 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802869:	55                   	push   %ebp
  80286a:	89 e5                	mov    %esp,%ebp
  80286c:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  80286f:	a1 38 41 80 00       	mov    0x804138,%eax
  802874:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802877:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80287c:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  80287f:	a1 38 41 80 00       	mov    0x804138,%eax
  802884:	85 c0                	test   %eax,%eax
  802886:	75 68                	jne    8028f0 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802888:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80288c:	75 17                	jne    8028a5 <insert_sorted_with_merge_freeList+0x3c>
  80288e:	83 ec 04             	sub    $0x4,%esp
  802891:	68 b0 3b 80 00       	push   $0x803bb0
  802896:	68 14 01 00 00       	push   $0x114
  80289b:	68 d3 3b 80 00       	push   $0x803bd3
  8028a0:	e8 18 da ff ff       	call   8002bd <_panic>
  8028a5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	89 10                	mov    %edx,(%eax)
  8028b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b3:	8b 00                	mov    (%eax),%eax
  8028b5:	85 c0                	test   %eax,%eax
  8028b7:	74 0d                	je     8028c6 <insert_sorted_with_merge_freeList+0x5d>
  8028b9:	a1 38 41 80 00       	mov    0x804138,%eax
  8028be:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c1:	89 50 04             	mov    %edx,0x4(%eax)
  8028c4:	eb 08                	jmp    8028ce <insert_sorted_with_merge_freeList+0x65>
  8028c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	a3 38 41 80 00       	mov    %eax,0x804138
  8028d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e0:	a1 44 41 80 00       	mov    0x804144,%eax
  8028e5:	40                   	inc    %eax
  8028e6:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8028eb:	e9 d2 06 00 00       	jmp    802fc2 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	8b 50 08             	mov    0x8(%eax),%edx
  8028f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f9:	8b 40 08             	mov    0x8(%eax),%eax
  8028fc:	39 c2                	cmp    %eax,%edx
  8028fe:	0f 83 22 01 00 00    	jae    802a26 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  802904:	8b 45 08             	mov    0x8(%ebp),%eax
  802907:	8b 50 08             	mov    0x8(%eax),%edx
  80290a:	8b 45 08             	mov    0x8(%ebp),%eax
  80290d:	8b 40 0c             	mov    0xc(%eax),%eax
  802910:	01 c2                	add    %eax,%edx
  802912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802915:	8b 40 08             	mov    0x8(%eax),%eax
  802918:	39 c2                	cmp    %eax,%edx
  80291a:	0f 85 9e 00 00 00    	jne    8029be <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	8b 50 08             	mov    0x8(%eax),%edx
  802926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802929:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  80292c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292f:	8b 50 0c             	mov    0xc(%eax),%edx
  802932:	8b 45 08             	mov    0x8(%ebp),%eax
  802935:	8b 40 0c             	mov    0xc(%eax),%eax
  802938:	01 c2                	add    %eax,%edx
  80293a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293d:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802940:	8b 45 08             	mov    0x8(%ebp),%eax
  802943:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80294a:	8b 45 08             	mov    0x8(%ebp),%eax
  80294d:	8b 50 08             	mov    0x8(%eax),%edx
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802956:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80295a:	75 17                	jne    802973 <insert_sorted_with_merge_freeList+0x10a>
  80295c:	83 ec 04             	sub    $0x4,%esp
  80295f:	68 b0 3b 80 00       	push   $0x803bb0
  802964:	68 21 01 00 00       	push   $0x121
  802969:	68 d3 3b 80 00       	push   $0x803bd3
  80296e:	e8 4a d9 ff ff       	call   8002bd <_panic>
  802973:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	89 10                	mov    %edx,(%eax)
  80297e:	8b 45 08             	mov    0x8(%ebp),%eax
  802981:	8b 00                	mov    (%eax),%eax
  802983:	85 c0                	test   %eax,%eax
  802985:	74 0d                	je     802994 <insert_sorted_with_merge_freeList+0x12b>
  802987:	a1 48 41 80 00       	mov    0x804148,%eax
  80298c:	8b 55 08             	mov    0x8(%ebp),%edx
  80298f:	89 50 04             	mov    %edx,0x4(%eax)
  802992:	eb 08                	jmp    80299c <insert_sorted_with_merge_freeList+0x133>
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80299c:	8b 45 08             	mov    0x8(%ebp),%eax
  80299f:	a3 48 41 80 00       	mov    %eax,0x804148
  8029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ae:	a1 54 41 80 00       	mov    0x804154,%eax
  8029b3:	40                   	inc    %eax
  8029b4:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  8029b9:	e9 04 06 00 00       	jmp    802fc2 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8029be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029c2:	75 17                	jne    8029db <insert_sorted_with_merge_freeList+0x172>
  8029c4:	83 ec 04             	sub    $0x4,%esp
  8029c7:	68 b0 3b 80 00       	push   $0x803bb0
  8029cc:	68 26 01 00 00       	push   $0x126
  8029d1:	68 d3 3b 80 00       	push   $0x803bd3
  8029d6:	e8 e2 d8 ff ff       	call   8002bd <_panic>
  8029db:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	89 10                	mov    %edx,(%eax)
  8029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	74 0d                	je     8029fc <insert_sorted_with_merge_freeList+0x193>
  8029ef:	a1 38 41 80 00       	mov    0x804138,%eax
  8029f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f7:	89 50 04             	mov    %edx,0x4(%eax)
  8029fa:	eb 08                	jmp    802a04 <insert_sorted_with_merge_freeList+0x19b>
  8029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ff:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a04:	8b 45 08             	mov    0x8(%ebp),%eax
  802a07:	a3 38 41 80 00       	mov    %eax,0x804138
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a16:	a1 44 41 80 00       	mov    0x804144,%eax
  802a1b:	40                   	inc    %eax
  802a1c:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802a21:	e9 9c 05 00 00       	jmp    802fc2 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	8b 50 08             	mov    0x8(%eax),%edx
  802a2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2f:	8b 40 08             	mov    0x8(%eax),%eax
  802a32:	39 c2                	cmp    %eax,%edx
  802a34:	0f 86 16 01 00 00    	jbe    802b50 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3d:	8b 50 08             	mov    0x8(%eax),%edx
  802a40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a43:	8b 40 0c             	mov    0xc(%eax),%eax
  802a46:	01 c2                	add    %eax,%edx
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	8b 40 08             	mov    0x8(%eax),%eax
  802a4e:	39 c2                	cmp    %eax,%edx
  802a50:	0f 85 92 00 00 00    	jne    802ae8 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a59:	8b 50 0c             	mov    0xc(%eax),%edx
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a62:	01 c2                	add    %eax,%edx
  802a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a67:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	8b 50 08             	mov    0x8(%eax),%edx
  802a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7d:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a84:	75 17                	jne    802a9d <insert_sorted_with_merge_freeList+0x234>
  802a86:	83 ec 04             	sub    $0x4,%esp
  802a89:	68 b0 3b 80 00       	push   $0x803bb0
  802a8e:	68 31 01 00 00       	push   $0x131
  802a93:	68 d3 3b 80 00       	push   $0x803bd3
  802a98:	e8 20 d8 ff ff       	call   8002bd <_panic>
  802a9d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	89 10                	mov    %edx,(%eax)
  802aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aab:	8b 00                	mov    (%eax),%eax
  802aad:	85 c0                	test   %eax,%eax
  802aaf:	74 0d                	je     802abe <insert_sorted_with_merge_freeList+0x255>
  802ab1:	a1 48 41 80 00       	mov    0x804148,%eax
  802ab6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab9:	89 50 04             	mov    %edx,0x4(%eax)
  802abc:	eb 08                	jmp    802ac6 <insert_sorted_with_merge_freeList+0x25d>
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac9:	a3 48 41 80 00       	mov    %eax,0x804148
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad8:	a1 54 41 80 00       	mov    0x804154,%eax
  802add:	40                   	inc    %eax
  802ade:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802ae3:	e9 da 04 00 00       	jmp    802fc2 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802ae8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aec:	75 17                	jne    802b05 <insert_sorted_with_merge_freeList+0x29c>
  802aee:	83 ec 04             	sub    $0x4,%esp
  802af1:	68 58 3c 80 00       	push   $0x803c58
  802af6:	68 37 01 00 00       	push   $0x137
  802afb:	68 d3 3b 80 00       	push   $0x803bd3
  802b00:	e8 b8 d7 ff ff       	call   8002bd <_panic>
  802b05:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	89 50 04             	mov    %edx,0x4(%eax)
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	8b 40 04             	mov    0x4(%eax),%eax
  802b17:	85 c0                	test   %eax,%eax
  802b19:	74 0c                	je     802b27 <insert_sorted_with_merge_freeList+0x2be>
  802b1b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b20:	8b 55 08             	mov    0x8(%ebp),%edx
  802b23:	89 10                	mov    %edx,(%eax)
  802b25:	eb 08                	jmp    802b2f <insert_sorted_with_merge_freeList+0x2c6>
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	a3 38 41 80 00       	mov    %eax,0x804138
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b37:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b40:	a1 44 41 80 00       	mov    0x804144,%eax
  802b45:	40                   	inc    %eax
  802b46:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b4b:	e9 72 04 00 00       	jmp    802fc2 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802b50:	a1 38 41 80 00       	mov    0x804138,%eax
  802b55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b58:	e9 35 04 00 00       	jmp    802f92 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b60:	8b 00                	mov    (%eax),%eax
  802b62:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802b65:	8b 45 08             	mov    0x8(%ebp),%eax
  802b68:	8b 50 08             	mov    0x8(%eax),%edx
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 40 08             	mov    0x8(%eax),%eax
  802b71:	39 c2                	cmp    %eax,%edx
  802b73:	0f 86 11 04 00 00    	jbe    802f8a <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	8b 50 08             	mov    0x8(%eax),%edx
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 40 0c             	mov    0xc(%eax),%eax
  802b85:	01 c2                	add    %eax,%edx
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	8b 40 08             	mov    0x8(%eax),%eax
  802b8d:	39 c2                	cmp    %eax,%edx
  802b8f:	0f 83 8b 00 00 00    	jae    802c20 <insert_sorted_with_merge_freeList+0x3b7>
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	8b 50 08             	mov    0x8(%eax),%edx
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba1:	01 c2                	add    %eax,%edx
  802ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba6:	8b 40 08             	mov    0x8(%eax),%eax
  802ba9:	39 c2                	cmp    %eax,%edx
  802bab:	73 73                	jae    802c20 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802bad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb1:	74 06                	je     802bb9 <insert_sorted_with_merge_freeList+0x350>
  802bb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb7:	75 17                	jne    802bd0 <insert_sorted_with_merge_freeList+0x367>
  802bb9:	83 ec 04             	sub    $0x4,%esp
  802bbc:	68 24 3c 80 00       	push   $0x803c24
  802bc1:	68 48 01 00 00       	push   $0x148
  802bc6:	68 d3 3b 80 00       	push   $0x803bd3
  802bcb:	e8 ed d6 ff ff       	call   8002bd <_panic>
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 10                	mov    (%eax),%edx
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	89 10                	mov    %edx,(%eax)
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	74 0b                	je     802bee <insert_sorted_with_merge_freeList+0x385>
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	8b 00                	mov    (%eax),%eax
  802be8:	8b 55 08             	mov    0x8(%ebp),%edx
  802beb:	89 50 04             	mov    %edx,0x4(%eax)
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf4:	89 10                	mov    %edx,(%eax)
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfc:	89 50 04             	mov    %edx,0x4(%eax)
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	8b 00                	mov    (%eax),%eax
  802c04:	85 c0                	test   %eax,%eax
  802c06:	75 08                	jne    802c10 <insert_sorted_with_merge_freeList+0x3a7>
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c10:	a1 44 41 80 00       	mov    0x804144,%eax
  802c15:	40                   	inc    %eax
  802c16:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802c1b:	e9 a2 03 00 00       	jmp    802fc2 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	8b 50 08             	mov    0x8(%eax),%edx
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2c:	01 c2                	add    %eax,%edx
  802c2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c31:	8b 40 08             	mov    0x8(%eax),%eax
  802c34:	39 c2                	cmp    %eax,%edx
  802c36:	0f 83 ae 00 00 00    	jae    802cea <insert_sorted_with_merge_freeList+0x481>
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	8b 50 08             	mov    0x8(%eax),%edx
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 48 08             	mov    0x8(%eax),%ecx
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c4e:	01 c8                	add    %ecx,%eax
  802c50:	39 c2                	cmp    %eax,%edx
  802c52:	0f 85 92 00 00 00    	jne    802cea <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5b:	8b 50 0c             	mov    0xc(%eax),%edx
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	8b 40 0c             	mov    0xc(%eax),%eax
  802c64:	01 c2                	add    %eax,%edx
  802c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c69:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	8b 50 08             	mov    0x8(%eax),%edx
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c86:	75 17                	jne    802c9f <insert_sorted_with_merge_freeList+0x436>
  802c88:	83 ec 04             	sub    $0x4,%esp
  802c8b:	68 b0 3b 80 00       	push   $0x803bb0
  802c90:	68 51 01 00 00       	push   $0x151
  802c95:	68 d3 3b 80 00       	push   $0x803bd3
  802c9a:	e8 1e d6 ff ff       	call   8002bd <_panic>
  802c9f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	89 10                	mov    %edx,(%eax)
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	8b 00                	mov    (%eax),%eax
  802caf:	85 c0                	test   %eax,%eax
  802cb1:	74 0d                	je     802cc0 <insert_sorted_with_merge_freeList+0x457>
  802cb3:	a1 48 41 80 00       	mov    0x804148,%eax
  802cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  802cbb:	89 50 04             	mov    %edx,0x4(%eax)
  802cbe:	eb 08                	jmp    802cc8 <insert_sorted_with_merge_freeList+0x45f>
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	a3 48 41 80 00       	mov    %eax,0x804148
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cda:	a1 54 41 80 00       	mov    0x804154,%eax
  802cdf:	40                   	inc    %eax
  802ce0:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802ce5:	e9 d8 02 00 00       	jmp    802fc2 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	8b 50 08             	mov    0x8(%eax),%edx
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf6:	01 c2                	add    %eax,%edx
  802cf8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cfb:	8b 40 08             	mov    0x8(%eax),%eax
  802cfe:	39 c2                	cmp    %eax,%edx
  802d00:	0f 85 ba 00 00 00    	jne    802dc0 <insert_sorted_with_merge_freeList+0x557>
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	8b 50 08             	mov    0x8(%eax),%edx
  802d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0f:	8b 48 08             	mov    0x8(%eax),%ecx
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	8b 40 0c             	mov    0xc(%eax),%eax
  802d18:	01 c8                	add    %ecx,%eax
  802d1a:	39 c2                	cmp    %eax,%edx
  802d1c:	0f 86 9e 00 00 00    	jbe    802dc0 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802d22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d25:	8b 50 0c             	mov    0xc(%eax),%edx
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2e:	01 c2                	add    %eax,%edx
  802d30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d33:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802d36:	8b 45 08             	mov    0x8(%ebp),%eax
  802d39:	8b 50 08             	mov    0x8(%eax),%edx
  802d3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d3f:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	8b 50 08             	mov    0x8(%eax),%edx
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d5c:	75 17                	jne    802d75 <insert_sorted_with_merge_freeList+0x50c>
  802d5e:	83 ec 04             	sub    $0x4,%esp
  802d61:	68 b0 3b 80 00       	push   $0x803bb0
  802d66:	68 5b 01 00 00       	push   $0x15b
  802d6b:	68 d3 3b 80 00       	push   $0x803bd3
  802d70:	e8 48 d5 ff ff       	call   8002bd <_panic>
  802d75:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	89 10                	mov    %edx,(%eax)
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	8b 00                	mov    (%eax),%eax
  802d85:	85 c0                	test   %eax,%eax
  802d87:	74 0d                	je     802d96 <insert_sorted_with_merge_freeList+0x52d>
  802d89:	a1 48 41 80 00       	mov    0x804148,%eax
  802d8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d91:	89 50 04             	mov    %edx,0x4(%eax)
  802d94:	eb 08                	jmp    802d9e <insert_sorted_with_merge_freeList+0x535>
  802d96:	8b 45 08             	mov    0x8(%ebp),%eax
  802d99:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802da1:	a3 48 41 80 00       	mov    %eax,0x804148
  802da6:	8b 45 08             	mov    0x8(%ebp),%eax
  802da9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db0:	a1 54 41 80 00       	mov    0x804154,%eax
  802db5:	40                   	inc    %eax
  802db6:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802dbb:	e9 02 02 00 00       	jmp    802fc2 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	8b 50 08             	mov    0x8(%eax),%edx
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcc:	01 c2                	add    %eax,%edx
  802dce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dd1:	8b 40 08             	mov    0x8(%eax),%eax
  802dd4:	39 c2                	cmp    %eax,%edx
  802dd6:	0f 85 ae 01 00 00    	jne    802f8a <insert_sorted_with_merge_freeList+0x721>
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	8b 50 08             	mov    0x8(%eax),%edx
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	8b 48 08             	mov    0x8(%eax),%ecx
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dee:	01 c8                	add    %ecx,%eax
  802df0:	39 c2                	cmp    %eax,%edx
  802df2:	0f 85 92 01 00 00    	jne    802f8a <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	8b 40 0c             	mov    0xc(%eax),%eax
  802e04:	01 c2                	add    %eax,%edx
  802e06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e09:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0c:	01 c2                	add    %eax,%edx
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	8b 50 08             	mov    0x8(%eax),%edx
  802e24:	8b 45 08             	mov    0x8(%ebp),%eax
  802e27:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802e2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e37:	8b 50 08             	mov    0x8(%eax),%edx
  802e3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3d:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802e40:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e44:	75 17                	jne    802e5d <insert_sorted_with_merge_freeList+0x5f4>
  802e46:	83 ec 04             	sub    $0x4,%esp
  802e49:	68 7b 3c 80 00       	push   $0x803c7b
  802e4e:	68 63 01 00 00       	push   $0x163
  802e53:	68 d3 3b 80 00       	push   $0x803bd3
  802e58:	e8 60 d4 ff ff       	call   8002bd <_panic>
  802e5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e60:	8b 00                	mov    (%eax),%eax
  802e62:	85 c0                	test   %eax,%eax
  802e64:	74 10                	je     802e76 <insert_sorted_with_merge_freeList+0x60d>
  802e66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e6e:	8b 52 04             	mov    0x4(%edx),%edx
  802e71:	89 50 04             	mov    %edx,0x4(%eax)
  802e74:	eb 0b                	jmp    802e81 <insert_sorted_with_merge_freeList+0x618>
  802e76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e79:	8b 40 04             	mov    0x4(%eax),%eax
  802e7c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e81:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e84:	8b 40 04             	mov    0x4(%eax),%eax
  802e87:	85 c0                	test   %eax,%eax
  802e89:	74 0f                	je     802e9a <insert_sorted_with_merge_freeList+0x631>
  802e8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8e:	8b 40 04             	mov    0x4(%eax),%eax
  802e91:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e94:	8b 12                	mov    (%edx),%edx
  802e96:	89 10                	mov    %edx,(%eax)
  802e98:	eb 0a                	jmp    802ea4 <insert_sorted_with_merge_freeList+0x63b>
  802e9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9d:	8b 00                	mov    (%eax),%eax
  802e9f:	a3 38 41 80 00       	mov    %eax,0x804138
  802ea4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ead:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb7:	a1 44 41 80 00       	mov    0x804144,%eax
  802ebc:	48                   	dec    %eax
  802ebd:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802ec2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ec6:	75 17                	jne    802edf <insert_sorted_with_merge_freeList+0x676>
  802ec8:	83 ec 04             	sub    $0x4,%esp
  802ecb:	68 b0 3b 80 00       	push   $0x803bb0
  802ed0:	68 64 01 00 00       	push   $0x164
  802ed5:	68 d3 3b 80 00       	push   $0x803bd3
  802eda:	e8 de d3 ff ff       	call   8002bd <_panic>
  802edf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ee5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee8:	89 10                	mov    %edx,(%eax)
  802eea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eed:	8b 00                	mov    (%eax),%eax
  802eef:	85 c0                	test   %eax,%eax
  802ef1:	74 0d                	je     802f00 <insert_sorted_with_merge_freeList+0x697>
  802ef3:	a1 48 41 80 00       	mov    0x804148,%eax
  802ef8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802efb:	89 50 04             	mov    %edx,0x4(%eax)
  802efe:	eb 08                	jmp    802f08 <insert_sorted_with_merge_freeList+0x69f>
  802f00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f03:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f08:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0b:	a3 48 41 80 00       	mov    %eax,0x804148
  802f10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f13:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1a:	a1 54 41 80 00       	mov    0x804154,%eax
  802f1f:	40                   	inc    %eax
  802f20:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f29:	75 17                	jne    802f42 <insert_sorted_with_merge_freeList+0x6d9>
  802f2b:	83 ec 04             	sub    $0x4,%esp
  802f2e:	68 b0 3b 80 00       	push   $0x803bb0
  802f33:	68 65 01 00 00       	push   $0x165
  802f38:	68 d3 3b 80 00       	push   $0x803bd3
  802f3d:	e8 7b d3 ff ff       	call   8002bd <_panic>
  802f42:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	89 10                	mov    %edx,(%eax)
  802f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f50:	8b 00                	mov    (%eax),%eax
  802f52:	85 c0                	test   %eax,%eax
  802f54:	74 0d                	je     802f63 <insert_sorted_with_merge_freeList+0x6fa>
  802f56:	a1 48 41 80 00       	mov    0x804148,%eax
  802f5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f5e:	89 50 04             	mov    %edx,0x4(%eax)
  802f61:	eb 08                	jmp    802f6b <insert_sorted_with_merge_freeList+0x702>
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	a3 48 41 80 00       	mov    %eax,0x804148
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7d:	a1 54 41 80 00       	mov    0x804154,%eax
  802f82:	40                   	inc    %eax
  802f83:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802f88:	eb 38                	jmp    802fc2 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f8a:	a1 40 41 80 00       	mov    0x804140,%eax
  802f8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f96:	74 07                	je     802f9f <insert_sorted_with_merge_freeList+0x736>
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	eb 05                	jmp    802fa4 <insert_sorted_with_merge_freeList+0x73b>
  802f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  802fa4:	a3 40 41 80 00       	mov    %eax,0x804140
  802fa9:	a1 40 41 80 00       	mov    0x804140,%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	0f 85 a7 fb ff ff    	jne    802b5d <insert_sorted_with_merge_freeList+0x2f4>
  802fb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fba:	0f 85 9d fb ff ff    	jne    802b5d <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802fc0:	eb 00                	jmp    802fc2 <insert_sorted_with_merge_freeList+0x759>
  802fc2:	90                   	nop
  802fc3:	c9                   	leave  
  802fc4:	c3                   	ret    

00802fc5 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802fc5:	55                   	push   %ebp
  802fc6:	89 e5                	mov    %esp,%ebp
  802fc8:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802fce:	89 d0                	mov    %edx,%eax
  802fd0:	c1 e0 02             	shl    $0x2,%eax
  802fd3:	01 d0                	add    %edx,%eax
  802fd5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fdc:	01 d0                	add    %edx,%eax
  802fde:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fe5:	01 d0                	add    %edx,%eax
  802fe7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fee:	01 d0                	add    %edx,%eax
  802ff0:	c1 e0 04             	shl    $0x4,%eax
  802ff3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802ff6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802ffd:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803000:	83 ec 0c             	sub    $0xc,%esp
  803003:	50                   	push   %eax
  803004:	e8 ee eb ff ff       	call   801bf7 <sys_get_virtual_time>
  803009:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80300c:	eb 41                	jmp    80304f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80300e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803011:	83 ec 0c             	sub    $0xc,%esp
  803014:	50                   	push   %eax
  803015:	e8 dd eb ff ff       	call   801bf7 <sys_get_virtual_time>
  80301a:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80301d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803020:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803023:	29 c2                	sub    %eax,%edx
  803025:	89 d0                	mov    %edx,%eax
  803027:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80302a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80302d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803030:	89 d1                	mov    %edx,%ecx
  803032:	29 c1                	sub    %eax,%ecx
  803034:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80303a:	39 c2                	cmp    %eax,%edx
  80303c:	0f 97 c0             	seta   %al
  80303f:	0f b6 c0             	movzbl %al,%eax
  803042:	29 c1                	sub    %eax,%ecx
  803044:	89 c8                	mov    %ecx,%eax
  803046:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803049:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80304c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80304f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803052:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803055:	72 b7                	jb     80300e <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803057:	90                   	nop
  803058:	c9                   	leave  
  803059:	c3                   	ret    

0080305a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80305a:	55                   	push   %ebp
  80305b:	89 e5                	mov    %esp,%ebp
  80305d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803060:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803067:	eb 03                	jmp    80306c <busy_wait+0x12>
  803069:	ff 45 fc             	incl   -0x4(%ebp)
  80306c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80306f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803072:	72 f5                	jb     803069 <busy_wait+0xf>
	return i;
  803074:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803077:	c9                   	leave  
  803078:	c3                   	ret    
  803079:	66 90                	xchg   %ax,%ax
  80307b:	90                   	nop

0080307c <__udivdi3>:
  80307c:	55                   	push   %ebp
  80307d:	57                   	push   %edi
  80307e:	56                   	push   %esi
  80307f:	53                   	push   %ebx
  803080:	83 ec 1c             	sub    $0x1c,%esp
  803083:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803087:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80308b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80308f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803093:	89 ca                	mov    %ecx,%edx
  803095:	89 f8                	mov    %edi,%eax
  803097:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80309b:	85 f6                	test   %esi,%esi
  80309d:	75 2d                	jne    8030cc <__udivdi3+0x50>
  80309f:	39 cf                	cmp    %ecx,%edi
  8030a1:	77 65                	ja     803108 <__udivdi3+0x8c>
  8030a3:	89 fd                	mov    %edi,%ebp
  8030a5:	85 ff                	test   %edi,%edi
  8030a7:	75 0b                	jne    8030b4 <__udivdi3+0x38>
  8030a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ae:	31 d2                	xor    %edx,%edx
  8030b0:	f7 f7                	div    %edi
  8030b2:	89 c5                	mov    %eax,%ebp
  8030b4:	31 d2                	xor    %edx,%edx
  8030b6:	89 c8                	mov    %ecx,%eax
  8030b8:	f7 f5                	div    %ebp
  8030ba:	89 c1                	mov    %eax,%ecx
  8030bc:	89 d8                	mov    %ebx,%eax
  8030be:	f7 f5                	div    %ebp
  8030c0:	89 cf                	mov    %ecx,%edi
  8030c2:	89 fa                	mov    %edi,%edx
  8030c4:	83 c4 1c             	add    $0x1c,%esp
  8030c7:	5b                   	pop    %ebx
  8030c8:	5e                   	pop    %esi
  8030c9:	5f                   	pop    %edi
  8030ca:	5d                   	pop    %ebp
  8030cb:	c3                   	ret    
  8030cc:	39 ce                	cmp    %ecx,%esi
  8030ce:	77 28                	ja     8030f8 <__udivdi3+0x7c>
  8030d0:	0f bd fe             	bsr    %esi,%edi
  8030d3:	83 f7 1f             	xor    $0x1f,%edi
  8030d6:	75 40                	jne    803118 <__udivdi3+0x9c>
  8030d8:	39 ce                	cmp    %ecx,%esi
  8030da:	72 0a                	jb     8030e6 <__udivdi3+0x6a>
  8030dc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030e0:	0f 87 9e 00 00 00    	ja     803184 <__udivdi3+0x108>
  8030e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030eb:	89 fa                	mov    %edi,%edx
  8030ed:	83 c4 1c             	add    $0x1c,%esp
  8030f0:	5b                   	pop    %ebx
  8030f1:	5e                   	pop    %esi
  8030f2:	5f                   	pop    %edi
  8030f3:	5d                   	pop    %ebp
  8030f4:	c3                   	ret    
  8030f5:	8d 76 00             	lea    0x0(%esi),%esi
  8030f8:	31 ff                	xor    %edi,%edi
  8030fa:	31 c0                	xor    %eax,%eax
  8030fc:	89 fa                	mov    %edi,%edx
  8030fe:	83 c4 1c             	add    $0x1c,%esp
  803101:	5b                   	pop    %ebx
  803102:	5e                   	pop    %esi
  803103:	5f                   	pop    %edi
  803104:	5d                   	pop    %ebp
  803105:	c3                   	ret    
  803106:	66 90                	xchg   %ax,%ax
  803108:	89 d8                	mov    %ebx,%eax
  80310a:	f7 f7                	div    %edi
  80310c:	31 ff                	xor    %edi,%edi
  80310e:	89 fa                	mov    %edi,%edx
  803110:	83 c4 1c             	add    $0x1c,%esp
  803113:	5b                   	pop    %ebx
  803114:	5e                   	pop    %esi
  803115:	5f                   	pop    %edi
  803116:	5d                   	pop    %ebp
  803117:	c3                   	ret    
  803118:	bd 20 00 00 00       	mov    $0x20,%ebp
  80311d:	89 eb                	mov    %ebp,%ebx
  80311f:	29 fb                	sub    %edi,%ebx
  803121:	89 f9                	mov    %edi,%ecx
  803123:	d3 e6                	shl    %cl,%esi
  803125:	89 c5                	mov    %eax,%ebp
  803127:	88 d9                	mov    %bl,%cl
  803129:	d3 ed                	shr    %cl,%ebp
  80312b:	89 e9                	mov    %ebp,%ecx
  80312d:	09 f1                	or     %esi,%ecx
  80312f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803133:	89 f9                	mov    %edi,%ecx
  803135:	d3 e0                	shl    %cl,%eax
  803137:	89 c5                	mov    %eax,%ebp
  803139:	89 d6                	mov    %edx,%esi
  80313b:	88 d9                	mov    %bl,%cl
  80313d:	d3 ee                	shr    %cl,%esi
  80313f:	89 f9                	mov    %edi,%ecx
  803141:	d3 e2                	shl    %cl,%edx
  803143:	8b 44 24 08          	mov    0x8(%esp),%eax
  803147:	88 d9                	mov    %bl,%cl
  803149:	d3 e8                	shr    %cl,%eax
  80314b:	09 c2                	or     %eax,%edx
  80314d:	89 d0                	mov    %edx,%eax
  80314f:	89 f2                	mov    %esi,%edx
  803151:	f7 74 24 0c          	divl   0xc(%esp)
  803155:	89 d6                	mov    %edx,%esi
  803157:	89 c3                	mov    %eax,%ebx
  803159:	f7 e5                	mul    %ebp
  80315b:	39 d6                	cmp    %edx,%esi
  80315d:	72 19                	jb     803178 <__udivdi3+0xfc>
  80315f:	74 0b                	je     80316c <__udivdi3+0xf0>
  803161:	89 d8                	mov    %ebx,%eax
  803163:	31 ff                	xor    %edi,%edi
  803165:	e9 58 ff ff ff       	jmp    8030c2 <__udivdi3+0x46>
  80316a:	66 90                	xchg   %ax,%ax
  80316c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803170:	89 f9                	mov    %edi,%ecx
  803172:	d3 e2                	shl    %cl,%edx
  803174:	39 c2                	cmp    %eax,%edx
  803176:	73 e9                	jae    803161 <__udivdi3+0xe5>
  803178:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80317b:	31 ff                	xor    %edi,%edi
  80317d:	e9 40 ff ff ff       	jmp    8030c2 <__udivdi3+0x46>
  803182:	66 90                	xchg   %ax,%ax
  803184:	31 c0                	xor    %eax,%eax
  803186:	e9 37 ff ff ff       	jmp    8030c2 <__udivdi3+0x46>
  80318b:	90                   	nop

0080318c <__umoddi3>:
  80318c:	55                   	push   %ebp
  80318d:	57                   	push   %edi
  80318e:	56                   	push   %esi
  80318f:	53                   	push   %ebx
  803190:	83 ec 1c             	sub    $0x1c,%esp
  803193:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803197:	8b 74 24 34          	mov    0x34(%esp),%esi
  80319b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80319f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031ab:	89 f3                	mov    %esi,%ebx
  8031ad:	89 fa                	mov    %edi,%edx
  8031af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031b3:	89 34 24             	mov    %esi,(%esp)
  8031b6:	85 c0                	test   %eax,%eax
  8031b8:	75 1a                	jne    8031d4 <__umoddi3+0x48>
  8031ba:	39 f7                	cmp    %esi,%edi
  8031bc:	0f 86 a2 00 00 00    	jbe    803264 <__umoddi3+0xd8>
  8031c2:	89 c8                	mov    %ecx,%eax
  8031c4:	89 f2                	mov    %esi,%edx
  8031c6:	f7 f7                	div    %edi
  8031c8:	89 d0                	mov    %edx,%eax
  8031ca:	31 d2                	xor    %edx,%edx
  8031cc:	83 c4 1c             	add    $0x1c,%esp
  8031cf:	5b                   	pop    %ebx
  8031d0:	5e                   	pop    %esi
  8031d1:	5f                   	pop    %edi
  8031d2:	5d                   	pop    %ebp
  8031d3:	c3                   	ret    
  8031d4:	39 f0                	cmp    %esi,%eax
  8031d6:	0f 87 ac 00 00 00    	ja     803288 <__umoddi3+0xfc>
  8031dc:	0f bd e8             	bsr    %eax,%ebp
  8031df:	83 f5 1f             	xor    $0x1f,%ebp
  8031e2:	0f 84 ac 00 00 00    	je     803294 <__umoddi3+0x108>
  8031e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8031ed:	29 ef                	sub    %ebp,%edi
  8031ef:	89 fe                	mov    %edi,%esi
  8031f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031f5:	89 e9                	mov    %ebp,%ecx
  8031f7:	d3 e0                	shl    %cl,%eax
  8031f9:	89 d7                	mov    %edx,%edi
  8031fb:	89 f1                	mov    %esi,%ecx
  8031fd:	d3 ef                	shr    %cl,%edi
  8031ff:	09 c7                	or     %eax,%edi
  803201:	89 e9                	mov    %ebp,%ecx
  803203:	d3 e2                	shl    %cl,%edx
  803205:	89 14 24             	mov    %edx,(%esp)
  803208:	89 d8                	mov    %ebx,%eax
  80320a:	d3 e0                	shl    %cl,%eax
  80320c:	89 c2                	mov    %eax,%edx
  80320e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803212:	d3 e0                	shl    %cl,%eax
  803214:	89 44 24 04          	mov    %eax,0x4(%esp)
  803218:	8b 44 24 08          	mov    0x8(%esp),%eax
  80321c:	89 f1                	mov    %esi,%ecx
  80321e:	d3 e8                	shr    %cl,%eax
  803220:	09 d0                	or     %edx,%eax
  803222:	d3 eb                	shr    %cl,%ebx
  803224:	89 da                	mov    %ebx,%edx
  803226:	f7 f7                	div    %edi
  803228:	89 d3                	mov    %edx,%ebx
  80322a:	f7 24 24             	mull   (%esp)
  80322d:	89 c6                	mov    %eax,%esi
  80322f:	89 d1                	mov    %edx,%ecx
  803231:	39 d3                	cmp    %edx,%ebx
  803233:	0f 82 87 00 00 00    	jb     8032c0 <__umoddi3+0x134>
  803239:	0f 84 91 00 00 00    	je     8032d0 <__umoddi3+0x144>
  80323f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803243:	29 f2                	sub    %esi,%edx
  803245:	19 cb                	sbb    %ecx,%ebx
  803247:	89 d8                	mov    %ebx,%eax
  803249:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80324d:	d3 e0                	shl    %cl,%eax
  80324f:	89 e9                	mov    %ebp,%ecx
  803251:	d3 ea                	shr    %cl,%edx
  803253:	09 d0                	or     %edx,%eax
  803255:	89 e9                	mov    %ebp,%ecx
  803257:	d3 eb                	shr    %cl,%ebx
  803259:	89 da                	mov    %ebx,%edx
  80325b:	83 c4 1c             	add    $0x1c,%esp
  80325e:	5b                   	pop    %ebx
  80325f:	5e                   	pop    %esi
  803260:	5f                   	pop    %edi
  803261:	5d                   	pop    %ebp
  803262:	c3                   	ret    
  803263:	90                   	nop
  803264:	89 fd                	mov    %edi,%ebp
  803266:	85 ff                	test   %edi,%edi
  803268:	75 0b                	jne    803275 <__umoddi3+0xe9>
  80326a:	b8 01 00 00 00       	mov    $0x1,%eax
  80326f:	31 d2                	xor    %edx,%edx
  803271:	f7 f7                	div    %edi
  803273:	89 c5                	mov    %eax,%ebp
  803275:	89 f0                	mov    %esi,%eax
  803277:	31 d2                	xor    %edx,%edx
  803279:	f7 f5                	div    %ebp
  80327b:	89 c8                	mov    %ecx,%eax
  80327d:	f7 f5                	div    %ebp
  80327f:	89 d0                	mov    %edx,%eax
  803281:	e9 44 ff ff ff       	jmp    8031ca <__umoddi3+0x3e>
  803286:	66 90                	xchg   %ax,%ax
  803288:	89 c8                	mov    %ecx,%eax
  80328a:	89 f2                	mov    %esi,%edx
  80328c:	83 c4 1c             	add    $0x1c,%esp
  80328f:	5b                   	pop    %ebx
  803290:	5e                   	pop    %esi
  803291:	5f                   	pop    %edi
  803292:	5d                   	pop    %ebp
  803293:	c3                   	ret    
  803294:	3b 04 24             	cmp    (%esp),%eax
  803297:	72 06                	jb     80329f <__umoddi3+0x113>
  803299:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80329d:	77 0f                	ja     8032ae <__umoddi3+0x122>
  80329f:	89 f2                	mov    %esi,%edx
  8032a1:	29 f9                	sub    %edi,%ecx
  8032a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032a7:	89 14 24             	mov    %edx,(%esp)
  8032aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032b2:	8b 14 24             	mov    (%esp),%edx
  8032b5:	83 c4 1c             	add    $0x1c,%esp
  8032b8:	5b                   	pop    %ebx
  8032b9:	5e                   	pop    %esi
  8032ba:	5f                   	pop    %edi
  8032bb:	5d                   	pop    %ebp
  8032bc:	c3                   	ret    
  8032bd:	8d 76 00             	lea    0x0(%esi),%esi
  8032c0:	2b 04 24             	sub    (%esp),%eax
  8032c3:	19 fa                	sbb    %edi,%edx
  8032c5:	89 d1                	mov    %edx,%ecx
  8032c7:	89 c6                	mov    %eax,%esi
  8032c9:	e9 71 ff ff ff       	jmp    80323f <__umoddi3+0xb3>
  8032ce:	66 90                	xchg   %ax,%ax
  8032d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032d4:	72 ea                	jb     8032c0 <__umoddi3+0x134>
  8032d6:	89 d9                	mov    %ebx,%ecx
  8032d8:	e9 62 ff ff ff       	jmp    80323f <__umoddi3+0xb3>
