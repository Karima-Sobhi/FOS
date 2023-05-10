
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 10 01 00 00       	call   800146 <libmain>
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
	// Testing scenario 5_1: Kill ONE program has shared variables and it free it
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 00 32 80 00       	push   $0x803200
  80004a:	e8 62 15 00 00       	call   8015b1 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 2d 18 00 00       	call   801890 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 c5 18 00 00       	call   801930 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 10 32 80 00       	push   $0x803210
  800079:	e8 b8 04 00 00       	call   800536 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 43 32 80 00       	push   $0x803243
  800099:	e8 64 1a 00 00       	call   801b02 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 71 1a 00 00       	call   801b20 <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 ce 17 00 00       	call   801890 <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 4c 32 80 00       	push   $0x80324c
  8000cb:	e8 66 04 00 00       	call   800536 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 5e 1a 00 00       	call   801b3c <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 aa 17 00 00       	call   801890 <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 42 18 00 00       	call   801930 <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 27                	je     800120 <_main+0xe8>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ff:	68 80 32 80 00       	push   $0x803280
  800104:	e8 2d 04 00 00       	call   800536 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 d0 32 80 00       	push   $0x8032d0
  800114:	6a 1e                	push   $0x1e
  800116:	68 06 33 80 00       	push   $0x803306
  80011b:	e8 62 01 00 00       	call   800282 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 e4             	pushl  -0x1c(%ebp)
  800126:	68 1c 33 80 00       	push   $0x80331c
  80012b:	e8 06 04 00 00       	call   800536 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 7c 33 80 00       	push   $0x80337c
  80013b:	e8 f6 03 00 00       	call   800536 <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
	return;
  800143:	90                   	nop
}
  800144:	c9                   	leave  
  800145:	c3                   	ret    

00800146 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80014c:	e8 1f 1a 00 00       	call   801b70 <sys_getenvindex>
  800151:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800157:	89 d0                	mov    %edx,%eax
  800159:	c1 e0 03             	shl    $0x3,%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	01 c0                	add    %eax,%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800169:	01 d0                	add    %edx,%eax
  80016b:	c1 e0 04             	shl    $0x4,%eax
  80016e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800173:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 20 40 80 00       	mov    0x804020,%eax
  80017d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800183:	84 c0                	test   %al,%al
  800185:	74 0f                	je     800196 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800187:	a1 20 40 80 00       	mov    0x804020,%eax
  80018c:	05 5c 05 00 00       	add    $0x55c,%eax
  800191:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019a:	7e 0a                	jle    8001a6 <libmain+0x60>
		binaryname = argv[0];
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a6:	83 ec 08             	sub    $0x8,%esp
  8001a9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	e8 84 fe ff ff       	call   800038 <_main>
  8001b4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b7:	e8 c1 17 00 00       	call   80197d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 e0 33 80 00       	push   $0x8033e0
  8001c4:	e8 6d 03 00 00       	call   800536 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	52                   	push   %edx
  8001e6:	50                   	push   %eax
  8001e7:	68 08 34 80 00       	push   $0x803408
  8001ec:	e8 45 03 00 00       	call   800536 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80020a:	a1 20 40 80 00       	mov    0x804020,%eax
  80020f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800215:	51                   	push   %ecx
  800216:	52                   	push   %edx
  800217:	50                   	push   %eax
  800218:	68 30 34 80 00       	push   $0x803430
  80021d:	e8 14 03 00 00       	call   800536 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 88 34 80 00       	push   $0x803488
  800239:	e8 f8 02 00 00       	call   800536 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 e0 33 80 00       	push   $0x8033e0
  800249:	e8 e8 02 00 00       	call   800536 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800251:	e8 41 17 00 00       	call   801997 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800256:	e8 19 00 00 00       	call   800274 <exit>
}
  80025b:	90                   	nop
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	6a 00                	push   $0x0
  800269:	e8 ce 18 00 00       	call   801b3c <sys_destroy_env>
  80026e:	83 c4 10             	add    $0x10,%esp
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <exit>:

void
exit(void)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027a:	e8 23 19 00 00       	call   801ba2 <sys_exit_env>
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800288:	8d 45 10             	lea    0x10(%ebp),%eax
  80028b:	83 c0 04             	add    $0x4,%eax
  80028e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800291:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	74 16                	je     8002b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	50                   	push   %eax
  8002a3:	68 9c 34 80 00       	push   $0x80349c
  8002a8:	e8 89 02 00 00       	call   800536 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 a1 34 80 00       	push   $0x8034a1
  8002c1:	e8 70 02 00 00       	call   800536 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d2:	50                   	push   %eax
  8002d3:	e8 f3 01 00 00       	call   8004cb <vcprintf>
  8002d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	6a 00                	push   $0x0
  8002e0:	68 bd 34 80 00       	push   $0x8034bd
  8002e5:	e8 e1 01 00 00       	call   8004cb <vcprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ed:	e8 82 ff ff ff       	call   800274 <exit>

	// should not return here
	while (1) ;
  8002f2:	eb fe                	jmp    8002f2 <_panic+0x70>

008002f4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ff:	8b 50 74             	mov    0x74(%eax),%edx
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	39 c2                	cmp    %eax,%edx
  800307:	74 14                	je     80031d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 c0 34 80 00       	push   $0x8034c0
  800311:	6a 26                	push   $0x26
  800313:	68 0c 35 80 00       	push   $0x80350c
  800318:	e8 65 ff ff ff       	call   800282 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800324:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80032b:	e9 c2 00 00 00       	jmp    8003f2 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800333:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	01 d0                	add    %edx,%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	85 c0                	test   %eax,%eax
  800343:	75 08                	jne    80034d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800345:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800348:	e9 a2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800354:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80035b:	eb 69                	jmp    8003c6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035d:	a1 20 40 80 00       	mov    0x804020,%eax
  800362:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800368:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80036b:	89 d0                	mov    %edx,%eax
  80036d:	01 c0                	add    %eax,%eax
  80036f:	01 d0                	add    %edx,%eax
  800371:	c1 e0 03             	shl    $0x3,%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8a 40 04             	mov    0x4(%eax),%al
  800379:	84 c0                	test   %al,%al
  80037b:	75 46                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037d:	a1 20 40 80 00       	mov    0x804020,%eax
  800382:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800388:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80038b:	89 d0                	mov    %edx,%eax
  80038d:	01 c0                	add    %eax,%eax
  80038f:	01 d0                	add    %edx,%eax
  800391:	c1 e0 03             	shl    $0x3,%eax
  800394:	01 c8                	add    %ecx,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80039b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	01 c8                	add    %ecx,%eax
  8003b4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b6:	39 c2                	cmp    %eax,%edx
  8003b8:	75 09                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003c1:	eb 12                	jmp    8003d5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c3:	ff 45 e8             	incl   -0x18(%ebp)
  8003c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003cb:	8b 50 74             	mov    0x74(%eax),%edx
  8003ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d1:	39 c2                	cmp    %eax,%edx
  8003d3:	77 88                	ja     80035d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d9:	75 14                	jne    8003ef <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	68 18 35 80 00       	push   $0x803518
  8003e3:	6a 3a                	push   $0x3a
  8003e5:	68 0c 35 80 00       	push   $0x80350c
  8003ea:	e8 93 fe ff ff       	call   800282 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ef:	ff 45 f0             	incl   -0x10(%ebp)
  8003f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f8:	0f 8c 32 ff ff ff    	jl     800330 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800405:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80040c:	eb 26                	jmp    800434 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040e:	a1 20 40 80 00       	mov    0x804020,%eax
  800413:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800419:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	01 c0                	add    %eax,%eax
  800420:	01 d0                	add    %edx,%eax
  800422:	c1 e0 03             	shl    $0x3,%eax
  800425:	01 c8                	add    %ecx,%eax
  800427:	8a 40 04             	mov    0x4(%eax),%al
  80042a:	3c 01                	cmp    $0x1,%al
  80042c:	75 03                	jne    800431 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800431:	ff 45 e0             	incl   -0x20(%ebp)
  800434:	a1 20 40 80 00       	mov    0x804020,%eax
  800439:	8b 50 74             	mov    0x74(%eax),%edx
  80043c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043f:	39 c2                	cmp    %eax,%edx
  800441:	77 cb                	ja     80040e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800446:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800449:	74 14                	je     80045f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80044b:	83 ec 04             	sub    $0x4,%esp
  80044e:	68 6c 35 80 00       	push   $0x80356c
  800453:	6a 44                	push   $0x44
  800455:	68 0c 35 80 00       	push   $0x80350c
  80045a:	e8 23 fe ff ff       	call   800282 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045f:	90                   	nop
  800460:	c9                   	leave  
  800461:	c3                   	ret    

00800462 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 48 01             	lea    0x1(%eax),%ecx
  800470:	8b 55 0c             	mov    0xc(%ebp),%edx
  800473:	89 0a                	mov    %ecx,(%edx)
  800475:	8b 55 08             	mov    0x8(%ebp),%edx
  800478:	88 d1                	mov    %dl,%cl
  80047a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800481:	8b 45 0c             	mov    0xc(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048b:	75 2c                	jne    8004b9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048d:	a0 24 40 80 00       	mov    0x804024,%al
  800492:	0f b6 c0             	movzbl %al,%eax
  800495:	8b 55 0c             	mov    0xc(%ebp),%edx
  800498:	8b 12                	mov    (%edx),%edx
  80049a:	89 d1                	mov    %edx,%ecx
  80049c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049f:	83 c2 08             	add    $0x8,%edx
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	50                   	push   %eax
  8004a6:	51                   	push   %ecx
  8004a7:	52                   	push   %edx
  8004a8:	e8 22 13 00 00       	call   8017cf <sys_cputs>
  8004ad:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bc:	8b 40 04             	mov    0x4(%eax),%eax
  8004bf:	8d 50 01             	lea    0x1(%eax),%edx
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c8:	90                   	nop
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004db:	00 00 00 
	b.cnt = 0;
  8004de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	50                   	push   %eax
  8004f5:	68 62 04 80 00       	push   $0x800462
  8004fa:	e8 11 02 00 00       	call   800710 <vprintfmt>
  8004ff:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800502:	a0 24 40 80 00       	mov    0x804024,%al
  800507:	0f b6 c0             	movzbl %al,%eax
  80050a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800510:	83 ec 04             	sub    $0x4,%esp
  800513:	50                   	push   %eax
  800514:	52                   	push   %edx
  800515:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051b:	83 c0 08             	add    $0x8,%eax
  80051e:	50                   	push   %eax
  80051f:	e8 ab 12 00 00       	call   8017cf <sys_cputs>
  800524:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800527:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <cprintf>:

int cprintf(const char *fmt, ...) {
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80053c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800543:	8d 45 0c             	lea    0xc(%ebp),%eax
  800546:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	ff 75 f4             	pushl  -0xc(%ebp)
  800552:	50                   	push   %eax
  800553:	e8 73 ff ff ff       	call   8004cb <vcprintf>
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800569:	e8 0f 14 00 00       	call   80197d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800571:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 f4             	pushl  -0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	e8 48 ff ff ff       	call   8004cb <vcprintf>
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800589:	e8 09 14 00 00       	call   801997 <sys_enable_interrupt>
	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	53                   	push   %ebx
  800597:	83 ec 14             	sub    $0x14,%esp
  80059a:	8b 45 10             	mov    0x10(%ebp),%eax
  80059d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b1:	77 55                	ja     800608 <printnum+0x75>
  8005b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b6:	72 05                	jb     8005bd <printnum+0x2a>
  8005b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005bb:	77 4b                	ja     800608 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	52                   	push   %edx
  8005cc:	50                   	push   %eax
  8005cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d3:	e8 b4 29 00 00       	call   802f8c <__udivdi3>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	83 ec 04             	sub    $0x4,%esp
  8005de:	ff 75 20             	pushl  0x20(%ebp)
  8005e1:	53                   	push   %ebx
  8005e2:	ff 75 18             	pushl  0x18(%ebp)
  8005e5:	52                   	push   %edx
  8005e6:	50                   	push   %eax
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 08             	pushl  0x8(%ebp)
  8005ed:	e8 a1 ff ff ff       	call   800593 <printnum>
  8005f2:	83 c4 20             	add    $0x20,%esp
  8005f5:	eb 1a                	jmp    800611 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	ff 75 0c             	pushl  0xc(%ebp)
  8005fd:	ff 75 20             	pushl  0x20(%ebp)
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800608:	ff 4d 1c             	decl   0x1c(%ebp)
  80060b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060f:	7f e6                	jg     8005f7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800611:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800614:	bb 00 00 00 00       	mov    $0x0,%ebx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061f:	53                   	push   %ebx
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	50                   	push   %eax
  800623:	e8 74 2a 00 00       	call   80309c <__umoddi3>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	05 d4 37 80 00       	add    $0x8037d4,%eax
  800630:	8a 00                	mov    (%eax),%al
  800632:	0f be c0             	movsbl %al,%eax
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	ff 75 0c             	pushl  0xc(%ebp)
  80063b:	50                   	push   %eax
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	ff d0                	call   *%eax
  800641:	83 c4 10             	add    $0x10,%esp
}
  800644:	90                   	nop
  800645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800648:	c9                   	leave  
  800649:	c3                   	ret    

0080064a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064a:	55                   	push   %ebp
  80064b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800651:	7e 1c                	jle    80066f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	8d 50 08             	lea    0x8(%eax),%edx
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	89 10                	mov    %edx,(%eax)
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	83 e8 08             	sub    $0x8,%eax
  800668:	8b 50 04             	mov    0x4(%eax),%edx
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	eb 40                	jmp    8006af <getuint+0x65>
	else if (lflag)
  80066f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800673:	74 1e                	je     800693 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800675:	8b 45 08             	mov    0x8(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	8d 50 04             	lea    0x4(%eax),%edx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	89 10                	mov    %edx,(%eax)
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	83 e8 04             	sub    $0x4,%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	eb 1c                	jmp    8006af <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 04             	lea    0x4(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 04             	sub    $0x4,%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006af:	5d                   	pop    %ebp
  8006b0:	c3                   	ret    

008006b1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getint+0x25>
		return va_arg(*ap, long long);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 08             	lea    0x8(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 08             	sub    $0x8,%eax
  8006cf:	8b 50 04             	mov    0x4(%eax),%edx
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	eb 38                	jmp    80070e <getint+0x5d>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1a                	je     8006f6 <getint+0x45>
		return va_arg(*ap, long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	99                   	cltd   
  8006f4:	eb 18                	jmp    80070e <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	8d 50 04             	lea    0x4(%eax),%edx
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	89 10                	mov    %edx,(%eax)
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	83 e8 04             	sub    $0x4,%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	99                   	cltd   
}
  80070e:	5d                   	pop    %ebp
  80070f:	c3                   	ret    

00800710 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	56                   	push   %esi
  800714:	53                   	push   %ebx
  800715:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800718:	eb 17                	jmp    800731 <vprintfmt+0x21>
			if (ch == '\0')
  80071a:	85 db                	test   %ebx,%ebx
  80071c:	0f 84 af 03 00 00    	je     800ad1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	53                   	push   %ebx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	ff d0                	call   *%eax
  80072e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800731:	8b 45 10             	mov    0x10(%ebp),%eax
  800734:	8d 50 01             	lea    0x1(%eax),%edx
  800737:	89 55 10             	mov    %edx,0x10(%ebp)
  80073a:	8a 00                	mov    (%eax),%al
  80073c:	0f b6 d8             	movzbl %al,%ebx
  80073f:	83 fb 25             	cmp    $0x25,%ebx
  800742:	75 d6                	jne    80071a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800744:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800748:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800756:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800764:	8b 45 10             	mov    0x10(%ebp),%eax
  800767:	8d 50 01             	lea    0x1(%eax),%edx
  80076a:	89 55 10             	mov    %edx,0x10(%ebp)
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800775:	83 f8 55             	cmp    $0x55,%eax
  800778:	0f 87 2b 03 00 00    	ja     800aa9 <vprintfmt+0x399>
  80077e:	8b 04 85 f8 37 80 00 	mov    0x8037f8(,%eax,4),%eax
  800785:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800787:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078b:	eb d7                	jmp    800764 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800791:	eb d1                	jmp    800764 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800793:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80079a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079d:	89 d0                	mov    %edx,%eax
  80079f:	c1 e0 02             	shl    $0x2,%eax
  8007a2:	01 d0                	add    %edx,%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	01 d8                	add    %ebx,%eax
  8007a8:	83 e8 30             	sub    $0x30,%eax
  8007ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b1:	8a 00                	mov    (%eax),%al
  8007b3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b9:	7e 3e                	jle    8007f9 <vprintfmt+0xe9>
  8007bb:	83 fb 39             	cmp    $0x39,%ebx
  8007be:	7f 39                	jg     8007f9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c3:	eb d5                	jmp    80079a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	83 c0 04             	add    $0x4,%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	83 e8 04             	sub    $0x4,%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d9:	eb 1f                	jmp    8007fa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007df:	79 83                	jns    800764 <vprintfmt+0x54>
				width = 0;
  8007e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e8:	e9 77 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ed:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f4:	e9 6b ff ff ff       	jmp    800764 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fe:	0f 89 60 ff ff ff    	jns    800764 <vprintfmt+0x54>
				width = precision, precision = -1;
  800804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800807:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800811:	e9 4e ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800816:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800819:	e9 46 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	83 c0 04             	add    $0x4,%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	83 e8 04             	sub    $0x4,%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	50                   	push   %eax
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
			break;
  80083e:	e9 89 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 e8 04             	sub    $0x4,%eax
  800852:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800854:	85 db                	test   %ebx,%ebx
  800856:	79 02                	jns    80085a <vprintfmt+0x14a>
				err = -err;
  800858:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80085a:	83 fb 64             	cmp    $0x64,%ebx
  80085d:	7f 0b                	jg     80086a <vprintfmt+0x15a>
  80085f:	8b 34 9d 40 36 80 00 	mov    0x803640(,%ebx,4),%esi
  800866:	85 f6                	test   %esi,%esi
  800868:	75 19                	jne    800883 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086a:	53                   	push   %ebx
  80086b:	68 e5 37 80 00       	push   $0x8037e5
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	ff 75 08             	pushl  0x8(%ebp)
  800876:	e8 5e 02 00 00       	call   800ad9 <printfmt>
  80087b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087e:	e9 49 02 00 00       	jmp    800acc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800883:	56                   	push   %esi
  800884:	68 ee 37 80 00       	push   $0x8037ee
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	ff 75 08             	pushl  0x8(%ebp)
  80088f:	e8 45 02 00 00       	call   800ad9 <printfmt>
  800894:	83 c4 10             	add    $0x10,%esp
			break;
  800897:	e9 30 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 c0 04             	add    $0x4,%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 e8 04             	sub    $0x4,%eax
  8008ab:	8b 30                	mov    (%eax),%esi
  8008ad:	85 f6                	test   %esi,%esi
  8008af:	75 05                	jne    8008b6 <vprintfmt+0x1a6>
				p = "(null)";
  8008b1:	be f1 37 80 00       	mov    $0x8037f1,%esi
			if (width > 0 && padc != '-')
  8008b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ba:	7e 6d                	jle    800929 <vprintfmt+0x219>
  8008bc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c0:	74 67                	je     800929 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	50                   	push   %eax
  8008c9:	56                   	push   %esi
  8008ca:	e8 0c 03 00 00       	call   800bdb <strnlen>
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d5:	eb 16                	jmp    8008ed <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	50                   	push   %eax
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	ff d0                	call   *%eax
  8008e7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f1:	7f e4                	jg     8008d7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f3:	eb 34                	jmp    800929 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f9:	74 1c                	je     800917 <vprintfmt+0x207>
  8008fb:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fe:	7e 05                	jle    800905 <vprintfmt+0x1f5>
  800900:	83 fb 7e             	cmp    $0x7e,%ebx
  800903:	7e 12                	jle    800917 <vprintfmt+0x207>
					putch('?', putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	6a 3f                	push   $0x3f
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	eb 0f                	jmp    800926 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	53                   	push   %ebx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	ff 4d e4             	decl   -0x1c(%ebp)
  800929:	89 f0                	mov    %esi,%eax
  80092b:	8d 70 01             	lea    0x1(%eax),%esi
  80092e:	8a 00                	mov    (%eax),%al
  800930:	0f be d8             	movsbl %al,%ebx
  800933:	85 db                	test   %ebx,%ebx
  800935:	74 24                	je     80095b <vprintfmt+0x24b>
  800937:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093b:	78 b8                	js     8008f5 <vprintfmt+0x1e5>
  80093d:	ff 4d e0             	decl   -0x20(%ebp)
  800940:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800944:	79 af                	jns    8008f5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800946:	eb 13                	jmp    80095b <vprintfmt+0x24b>
				putch(' ', putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	6a 20                	push   $0x20
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800958:	ff 4d e4             	decl   -0x1c(%ebp)
  80095b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095f:	7f e7                	jg     800948 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800961:	e9 66 01 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 e8             	pushl  -0x18(%ebp)
  80096c:	8d 45 14             	lea    0x14(%ebp),%eax
  80096f:	50                   	push   %eax
  800970:	e8 3c fd ff ff       	call   8006b1 <getint>
  800975:	83 c4 10             	add    $0x10,%esp
  800978:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800984:	85 d2                	test   %edx,%edx
  800986:	79 23                	jns    8009ab <vprintfmt+0x29b>
				putch('-', putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	6a 2d                	push   $0x2d
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	ff d0                	call   *%eax
  800995:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099e:	f7 d8                	neg    %eax
  8009a0:	83 d2 00             	adc    $0x0,%edx
  8009a3:	f7 da                	neg    %edx
  8009a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b2:	e9 bc 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bd:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c0:	50                   	push   %eax
  8009c1:	e8 84 fc ff ff       	call   80064a <getuint>
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d6:	e9 98 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 58                	push   $0x58
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	6a 58                	push   $0x58
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 58                	push   $0x58
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			break;
  800a0b:	e9 bc 00 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	6a 30                	push   $0x30
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	ff d0                	call   *%eax
  800a1d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 78                	push   $0x78
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 c0 04             	add    $0x4,%eax
  800a36:	89 45 14             	mov    %eax,0x14(%ebp)
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 e8 04             	sub    $0x4,%eax
  800a3f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a52:	eb 1f                	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5d:	50                   	push   %eax
  800a5e:	e8 e7 fb ff ff       	call   80064a <getuint>
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a69:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a6c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a73:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7a:	83 ec 04             	sub    $0x4,%esp
  800a7d:	52                   	push   %edx
  800a7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a81:	50                   	push   %eax
  800a82:	ff 75 f4             	pushl  -0xc(%ebp)
  800a85:	ff 75 f0             	pushl  -0x10(%ebp)
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	ff 75 08             	pushl  0x8(%ebp)
  800a8e:	e8 00 fb ff ff       	call   800593 <printnum>
  800a93:	83 c4 20             	add    $0x20,%esp
			break;
  800a96:	eb 34                	jmp    800acc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	53                   	push   %ebx
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			break;
  800aa7:	eb 23                	jmp    800acc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	6a 25                	push   $0x25
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	ff d0                	call   *%eax
  800ab6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab9:	ff 4d 10             	decl   0x10(%ebp)
  800abc:	eb 03                	jmp    800ac1 <vprintfmt+0x3b1>
  800abe:	ff 4d 10             	decl   0x10(%ebp)
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	48                   	dec    %eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	3c 25                	cmp    $0x25,%al
  800ac9:	75 f3                	jne    800abe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800acb:	90                   	nop
		}
	}
  800acc:	e9 47 fc ff ff       	jmp    800718 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad5:	5b                   	pop    %ebx
  800ad6:	5e                   	pop    %esi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae2:	83 c0 04             	add    $0x4,%eax
  800ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  800aeb:	ff 75 f4             	pushl  -0xc(%ebp)
  800aee:	50                   	push   %eax
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 16 fc ff ff       	call   800710 <vprintfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afd:	90                   	nop
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	8b 40 08             	mov    0x8(%eax),%eax
  800b09:	8d 50 01             	lea    0x1(%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8b 10                	mov    (%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	8b 40 04             	mov    0x4(%eax),%eax
  800b1d:	39 c2                	cmp    %eax,%edx
  800b1f:	73 12                	jae    800b33 <sprintputch+0x33>
		*b->buf++ = ch;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	8d 48 01             	lea    0x1(%eax),%ecx
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 0a                	mov    %ecx,(%edx)
  800b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b31:	88 10                	mov    %dl,(%eax)
}
  800b33:	90                   	nop
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	01 d0                	add    %edx,%eax
  800b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5b:	74 06                	je     800b63 <vsnprintf+0x2d>
  800b5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b61:	7f 07                	jg     800b6a <vsnprintf+0x34>
		return -E_INVAL;
  800b63:	b8 03 00 00 00       	mov    $0x3,%eax
  800b68:	eb 20                	jmp    800b8a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b6a:	ff 75 14             	pushl  0x14(%ebp)
  800b6d:	ff 75 10             	pushl  0x10(%ebp)
  800b70:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 00 0b 80 00       	push   $0x800b00
  800b79:	e8 92 fb ff ff       	call   800710 <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b84:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 89 ff ff ff       	call   800b36 <vsnprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc5:	eb 06                	jmp    800bcd <strlen+0x15>
		n++;
  800bc7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bca:	ff 45 08             	incl   0x8(%ebp)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 f1                	jne    800bc7 <strlen+0xf>
		n++;
	return n;
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be8:	eb 09                	jmp    800bf3 <strnlen+0x18>
		n++;
  800bea:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 4d 0c             	decl   0xc(%ebp)
  800bf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf7:	74 09                	je     800c02 <strnlen+0x27>
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	75 e8                	jne    800bea <strnlen+0xf>
		n++;
	return n;
  800c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c13:	90                   	nop
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c23:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c26:	8a 12                	mov    (%edx),%dl
  800c28:	88 10                	mov    %dl,(%eax)
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	84 c0                	test   %al,%al
  800c2e:	75 e4                	jne    800c14 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c48:	eb 1f                	jmp    800c69 <strncpy+0x34>
		*dst++ = *src;
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 08             	mov    %edx,0x8(%ebp)
  800c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	84 c0                	test   %al,%al
  800c61:	74 03                	je     800c66 <strncpy+0x31>
			src++;
  800c63:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c66:	ff 45 fc             	incl   -0x4(%ebp)
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6f:	72 d9                	jb     800c4a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c86:	74 30                	je     800cb8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c88:	eb 16                	jmp    800ca0 <strlcpy+0x2a>
			*dst++ = *src++;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8d 50 01             	lea    0x1(%eax),%edx
  800c90:	89 55 08             	mov    %edx,0x8(%ebp)
  800c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9c:	8a 12                	mov    (%edx),%dl
  800c9e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca0:	ff 4d 10             	decl   0x10(%ebp)
  800ca3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca7:	74 09                	je     800cb2 <strlcpy+0x3c>
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	75 d8                	jne    800c8a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbe:	29 c2                	sub    %eax,%edx
  800cc0:	89 d0                	mov    %edx,%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc7:	eb 06                	jmp    800ccf <strcmp+0xb>
		p++, q++;
  800cc9:	ff 45 08             	incl   0x8(%ebp)
  800ccc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	84 c0                	test   %al,%al
  800cd6:	74 0e                	je     800ce6 <strcmp+0x22>
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 10                	mov    (%eax),%dl
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	38 c2                	cmp    %al,%dl
  800ce4:	74 e3                	je     800cc9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	0f b6 d0             	movzbl %al,%edx
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	0f b6 c0             	movzbl %al,%eax
  800cf6:	29 c2                	sub    %eax,%edx
  800cf8:	89 d0                	mov    %edx,%eax
}
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cff:	eb 09                	jmp    800d0a <strncmp+0xe>
		n--, p++, q++;
  800d01:	ff 4d 10             	decl   0x10(%ebp)
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 17                	je     800d27 <strncmp+0x2b>
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	74 0e                	je     800d27 <strncmp+0x2b>
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 10                	mov    (%eax),%dl
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	38 c2                	cmp    %al,%dl
  800d25:	74 da                	je     800d01 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2b:	75 07                	jne    800d34 <strncmp+0x38>
		return 0;
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	eb 14                	jmp    800d48 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 d0             	movzbl %al,%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	0f b6 c0             	movzbl %al,%eax
  800d44:	29 c2                	sub    %eax,%edx
  800d46:	89 d0                	mov    %edx,%eax
}
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d56:	eb 12                	jmp    800d6a <strchr+0x20>
		if (*s == c)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d60:	75 05                	jne    800d67 <strchr+0x1d>
			return (char *) s;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	eb 11                	jmp    800d78 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	84 c0                	test   %al,%al
  800d71:	75 e5                	jne    800d58 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 0d                	jmp    800d95 <strfind+0x1b>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	74 0e                	je     800da0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 ea                	jne    800d88 <strfind+0xe>
  800d9e:	eb 01                	jmp    800da1 <strfind+0x27>
		if (*s == c)
			break;
  800da0:	90                   	nop
	return (char *) s;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db8:	eb 0e                	jmp    800dc8 <memset+0x22>
		*p++ = c;
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc8:	ff 4d f8             	decl   -0x8(%ebp)
  800dcb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcf:	79 e9                	jns    800dba <memset+0x14>
		*p++ = c;

	return v;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de8:	eb 16                	jmp    800e00 <memcpy+0x2a>
		*d++ = *s++;
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dfc:	8a 12                	mov    (%edx),%dl
  800dfe:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e06:	89 55 10             	mov    %edx,0x10(%ebp)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	75 dd                	jne    800dea <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2a:	73 50                	jae    800e7c <memmove+0x6a>
  800e2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	01 d0                	add    %edx,%eax
  800e34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e37:	76 43                	jbe    800e7c <memmove+0x6a>
		s += n;
  800e39:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e42:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e45:	eb 10                	jmp    800e57 <memmove+0x45>
			*--d = *--s;
  800e47:	ff 4d f8             	decl   -0x8(%ebp)
  800e4a:	ff 4d fc             	decl   -0x4(%ebp)
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8a 10                	mov    (%eax),%dl
  800e52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e55:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e57:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	75 e3                	jne    800e47 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e64:	eb 23                	jmp    800e89 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e75:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e78:	8a 12                	mov    (%edx),%dl
  800e7a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e82:	89 55 10             	mov    %edx,0x10(%ebp)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	75 dd                	jne    800e66 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ea0:	eb 2a                	jmp    800ecc <memcmp+0x3e>
		if (*s1 != *s2)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8a 10                	mov    (%eax),%dl
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	38 c2                	cmp    %al,%dl
  800eae:	74 16                	je     800ec6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	0f b6 d0             	movzbl %al,%edx
  800eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	0f b6 c0             	movzbl %al,%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	eb 18                	jmp    800ede <memcmp+0x50>
		s1++, s2++;
  800ec6:	ff 45 fc             	incl   -0x4(%ebp)
  800ec9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	75 c9                	jne    800ea2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef1:	eb 15                	jmp    800f08 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 d0             	movzbl %al,%edx
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	0f b6 c0             	movzbl %al,%eax
  800f01:	39 c2                	cmp    %eax,%edx
  800f03:	74 0d                	je     800f12 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f05:	ff 45 08             	incl   0x8(%ebp)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0e:	72 e3                	jb     800ef3 <memfind+0x13>
  800f10:	eb 01                	jmp    800f13 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f12:	90                   	nop
	return (void *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2c:	eb 03                	jmp    800f31 <strtol+0x19>
		s++;
  800f2e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 20                	cmp    $0x20,%al
  800f38:	74 f4                	je     800f2e <strtol+0x16>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 09                	cmp    $0x9,%al
  800f41:	74 eb                	je     800f2e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 2b                	cmp    $0x2b,%al
  800f4a:	75 05                	jne    800f51 <strtol+0x39>
		s++;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	eb 13                	jmp    800f64 <strtol+0x4c>
	else if (*s == '-')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2d                	cmp    $0x2d,%al
  800f58:	75 0a                	jne    800f64 <strtol+0x4c>
		s++, neg = 1;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f68:	74 06                	je     800f70 <strtol+0x58>
  800f6a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6e:	75 20                	jne    800f90 <strtol+0x78>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 30                	cmp    $0x30,%al
  800f77:	75 17                	jne    800f90 <strtol+0x78>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	40                   	inc    %eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 78                	cmp    $0x78,%al
  800f81:	75 0d                	jne    800f90 <strtol+0x78>
		s += 2, base = 16;
  800f83:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f87:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8e:	eb 28                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f94:	75 15                	jne    800fab <strtol+0x93>
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 30                	cmp    $0x30,%al
  800f9d:	75 0c                	jne    800fab <strtol+0x93>
		s++, base = 8;
  800f9f:	ff 45 08             	incl   0x8(%ebp)
  800fa2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa9:	eb 0d                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0)
  800fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faf:	75 07                	jne    800fb8 <strtol+0xa0>
		base = 10;
  800fb1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2f                	cmp    $0x2f,%al
  800fbf:	7e 19                	jle    800fda <strtol+0xc2>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3c 39                	cmp    $0x39,%al
  800fc8:	7f 10                	jg     800fda <strtol+0xc2>
			dig = *s - '0';
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f be c0             	movsbl %al,%eax
  800fd2:	83 e8 30             	sub    $0x30,%eax
  800fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd8:	eb 42                	jmp    80101c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 60                	cmp    $0x60,%al
  800fe1:	7e 19                	jle    800ffc <strtol+0xe4>
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 7a                	cmp    $0x7a,%al
  800fea:	7f 10                	jg     800ffc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	0f be c0             	movsbl %al,%eax
  800ff4:	83 e8 57             	sub    $0x57,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ffa:	eb 20                	jmp    80101c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 40                	cmp    $0x40,%al
  801003:	7e 39                	jle    80103e <strtol+0x126>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	3c 5a                	cmp    $0x5a,%al
  80100c:	7f 30                	jg     80103e <strtol+0x126>
			dig = *s - 'A' + 10;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f be c0             	movsbl %al,%eax
  801016:	83 e8 37             	sub    $0x37,%eax
  801019:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801022:	7d 19                	jge    80103d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801024:	ff 45 08             	incl   0x8(%ebp)
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102e:	89 c2                	mov    %eax,%edx
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801033:	01 d0                	add    %edx,%eax
  801035:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801038:	e9 7b ff ff ff       	jmp    800fb8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801042:	74 08                	je     80104c <strtol+0x134>
		*endptr = (char *) s;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80104c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801050:	74 07                	je     801059 <strtol+0x141>
  801052:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801055:	f7 d8                	neg    %eax
  801057:	eb 03                	jmp    80105c <strtol+0x144>
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <ltostr>:

void
ltostr(long value, char *str)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80106b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801076:	79 13                	jns    80108b <ltostr+0x2d>
	{
		neg = 1;
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801085:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801088:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801093:	99                   	cltd   
  801094:	f7 f9                	idiv   %ecx
  801096:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	8d 50 01             	lea    0x1(%eax),%edx
  80109f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ac:	83 c2 30             	add    $0x30,%edx
  8010af:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b9:	f7 e9                	imul   %ecx
  8010bb:	c1 fa 02             	sar    $0x2,%edx
  8010be:	89 c8                	mov    %ecx,%eax
  8010c0:	c1 f8 1f             	sar    $0x1f,%eax
  8010c3:	29 c2                	sub    %eax,%edx
  8010c5:	89 d0                	mov    %edx,%eax
  8010c7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d2:	f7 e9                	imul   %ecx
  8010d4:	c1 fa 02             	sar    $0x2,%edx
  8010d7:	89 c8                	mov    %ecx,%eax
  8010d9:	c1 f8 1f             	sar    $0x1f,%eax
  8010dc:	29 c2                	sub    %eax,%edx
  8010de:	89 d0                	mov    %edx,%eax
  8010e0:	c1 e0 02             	shl    $0x2,%eax
  8010e3:	01 d0                	add    %edx,%eax
  8010e5:	01 c0                	add    %eax,%eax
  8010e7:	29 c1                	sub    %eax,%ecx
  8010e9:	89 ca                	mov    %ecx,%edx
  8010eb:	85 d2                	test   %edx,%edx
  8010ed:	75 9c                	jne    80108b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	48                   	dec    %eax
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801101:	74 3d                	je     801140 <ltostr+0xe2>
		start = 1 ;
  801103:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80110a:	eb 34                	jmp    801140 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80110c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	01 c2                	add    %eax,%edx
  801121:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 c8                	add    %ecx,%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	01 c2                	add    %eax,%edx
  801135:	8a 45 eb             	mov    -0x15(%ebp),%al
  801138:	88 02                	mov    %al,(%edx)
		start++ ;
  80113a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801146:	7c c4                	jl     80110c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801148:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801153:	90                   	nop
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80115c:	ff 75 08             	pushl  0x8(%ebp)
  80115f:	e8 54 fa ff ff       	call   800bb8 <strlen>
  801164:	83 c4 04             	add    $0x4,%esp
  801167:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80116a:	ff 75 0c             	pushl  0xc(%ebp)
  80116d:	e8 46 fa ff ff       	call   800bb8 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801178:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801186:	eb 17                	jmp    80119f <strcconcat+0x49>
		final[s] = str1[s] ;
  801188:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	01 c2                	add    %eax,%edx
  801190:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	01 c8                	add    %ecx,%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80119c:	ff 45 fc             	incl   -0x4(%ebp)
  80119f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a5:	7c e1                	jl     801188 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b5:	eb 1f                	jmp    8011d6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ba:	8d 50 01             	lea    0x1(%eax),%edx
  8011bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c0:	89 c2                	mov    %eax,%edx
  8011c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c5:	01 c2                	add    %eax,%edx
  8011c7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	01 c8                	add    %ecx,%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d3:	ff 45 f8             	incl   -0x8(%ebp)
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011dc:	7c d9                	jl     8011b7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e9:	90                   	nop
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801204:	8b 45 10             	mov    0x10(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120f:	eb 0c                	jmp    80121d <strsplit+0x31>
			*string++ = 0;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8d 50 01             	lea    0x1(%eax),%edx
  801217:	89 55 08             	mov    %edx,0x8(%ebp)
  80121a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	84 c0                	test   %al,%al
  801224:	74 18                	je     80123e <strsplit+0x52>
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	0f be c0             	movsbl %al,%eax
  80122e:	50                   	push   %eax
  80122f:	ff 75 0c             	pushl  0xc(%ebp)
  801232:	e8 13 fb ff ff       	call   800d4a <strchr>
  801237:	83 c4 08             	add    $0x8,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 d3                	jne    801211 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	74 5a                	je     8012a1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	83 f8 0f             	cmp    $0xf,%eax
  80124f:	75 07                	jne    801258 <strsplit+0x6c>
		{
			return 0;
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	eb 66                	jmp    8012be <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801258:	8b 45 14             	mov    0x14(%ebp),%eax
  80125b:	8b 00                	mov    (%eax),%eax
  80125d:	8d 48 01             	lea    0x1(%eax),%ecx
  801260:	8b 55 14             	mov    0x14(%ebp),%edx
  801263:	89 0a                	mov    %ecx,(%edx)
  801265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	01 c2                	add    %eax,%edx
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801276:	eb 03                	jmp    80127b <strsplit+0x8f>
			string++;
  801278:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	84 c0                	test   %al,%al
  801282:	74 8b                	je     80120f <strsplit+0x23>
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	0f be c0             	movsbl %al,%eax
  80128c:	50                   	push   %eax
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	e8 b5 fa ff ff       	call   800d4a <strchr>
  801295:	83 c4 08             	add    $0x8,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	74 dc                	je     801278 <strsplit+0x8c>
			string++;
	}
  80129c:	e9 6e ff ff ff       	jmp    80120f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012a1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	8b 00                	mov    (%eax),%eax
  8012a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 1f                	je     8012ee <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cf:	e8 1d 00 00 00       	call   8012f1 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	68 50 39 80 00       	push   $0x803950
  8012dc:	e8 55 f2 ff ff       	call   800536 <cprintf>
  8012e1:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e4:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012eb:	00 00 00 
	}
}
  8012ee:	90                   	nop
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8012f7:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012fe:	00 00 00 
  801301:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801308:	00 00 00 
  80130b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801312:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801315:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80131c:	00 00 00 
  80131f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801326:	00 00 00 
  801329:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801330:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801333:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80133a:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80133d:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801347:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80134c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801351:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801356:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80135d:	a1 20 41 80 00       	mov    0x804120,%eax
  801362:	c1 e0 04             	shl    $0x4,%eax
  801365:	89 c2                	mov    %eax,%edx
  801367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136a:	01 d0                	add    %edx,%eax
  80136c:	48                   	dec    %eax
  80136d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801370:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801373:	ba 00 00 00 00       	mov    $0x0,%edx
  801378:	f7 75 f0             	divl   -0x10(%ebp)
  80137b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80137e:	29 d0                	sub    %edx,%eax
  801380:	89 c2                	mov    %eax,%edx
  801382:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801389:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80138c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801391:	2d 00 10 00 00       	sub    $0x1000,%eax
  801396:	83 ec 04             	sub    $0x4,%esp
  801399:	6a 06                	push   $0x6
  80139b:	52                   	push   %edx
  80139c:	50                   	push   %eax
  80139d:	e8 71 05 00 00       	call   801913 <sys_allocate_chunk>
  8013a2:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013a5:	a1 20 41 80 00       	mov    0x804120,%eax
  8013aa:	83 ec 0c             	sub    $0xc,%esp
  8013ad:	50                   	push   %eax
  8013ae:	e8 e6 0b 00 00       	call   801f99 <initialize_MemBlocksList>
  8013b3:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8013b6:	a1 48 41 80 00       	mov    0x804148,%eax
  8013bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8013be:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013c2:	75 14                	jne    8013d8 <initialize_dyn_block_system+0xe7>
  8013c4:	83 ec 04             	sub    $0x4,%esp
  8013c7:	68 75 39 80 00       	push   $0x803975
  8013cc:	6a 2b                	push   $0x2b
  8013ce:	68 93 39 80 00       	push   $0x803993
  8013d3:	e8 aa ee ff ff       	call   800282 <_panic>
  8013d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013db:	8b 00                	mov    (%eax),%eax
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	74 10                	je     8013f1 <initialize_dyn_block_system+0x100>
  8013e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e4:	8b 00                	mov    (%eax),%eax
  8013e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013e9:	8b 52 04             	mov    0x4(%edx),%edx
  8013ec:	89 50 04             	mov    %edx,0x4(%eax)
  8013ef:	eb 0b                	jmp    8013fc <initialize_dyn_block_system+0x10b>
  8013f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f4:	8b 40 04             	mov    0x4(%eax),%eax
  8013f7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ff:	8b 40 04             	mov    0x4(%eax),%eax
  801402:	85 c0                	test   %eax,%eax
  801404:	74 0f                	je     801415 <initialize_dyn_block_system+0x124>
  801406:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801409:	8b 40 04             	mov    0x4(%eax),%eax
  80140c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80140f:	8b 12                	mov    (%edx),%edx
  801411:	89 10                	mov    %edx,(%eax)
  801413:	eb 0a                	jmp    80141f <initialize_dyn_block_system+0x12e>
  801415:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801418:	8b 00                	mov    (%eax),%eax
  80141a:	a3 48 41 80 00       	mov    %eax,0x804148
  80141f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801422:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80142b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801432:	a1 54 41 80 00       	mov    0x804154,%eax
  801437:	48                   	dec    %eax
  801438:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  80143d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801440:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80144a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801451:	83 ec 0c             	sub    $0xc,%esp
  801454:	ff 75 e4             	pushl  -0x1c(%ebp)
  801457:	e8 d2 13 00 00       	call   80282e <insert_sorted_with_merge_freeList>
  80145c:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80145f:	90                   	nop
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801468:	e8 53 fe ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  80146d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801471:	75 07                	jne    80147a <malloc+0x18>
  801473:	b8 00 00 00 00       	mov    $0x0,%eax
  801478:	eb 61                	jmp    8014db <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  80147a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801481:	8b 55 08             	mov    0x8(%ebp),%edx
  801484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801487:	01 d0                	add    %edx,%eax
  801489:	48                   	dec    %eax
  80148a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80148d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801490:	ba 00 00 00 00       	mov    $0x0,%edx
  801495:	f7 75 f4             	divl   -0xc(%ebp)
  801498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149b:	29 d0                	sub    %edx,%eax
  80149d:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014a0:	e8 3c 08 00 00       	call   801ce1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014a5:	85 c0                	test   %eax,%eax
  8014a7:	74 2d                	je     8014d6 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8014a9:	83 ec 0c             	sub    $0xc,%esp
  8014ac:	ff 75 08             	pushl  0x8(%ebp)
  8014af:	e8 3e 0f 00 00       	call   8023f2 <alloc_block_FF>
  8014b4:	83 c4 10             	add    $0x10,%esp
  8014b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8014ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014be:	74 16                	je     8014d6 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8014c0:	83 ec 0c             	sub    $0xc,%esp
  8014c3:	ff 75 ec             	pushl  -0x14(%ebp)
  8014c6:	e8 48 0c 00 00       	call   802113 <insert_sorted_allocList>
  8014cb:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8014ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014d1:	8b 40 08             	mov    0x8(%eax),%eax
  8014d4:	eb 05                	jmp    8014db <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8014d6:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014f1:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	83 ec 08             	sub    $0x8,%esp
  8014fa:	50                   	push   %eax
  8014fb:	68 40 40 80 00       	push   $0x804040
  801500:	e8 71 0b 00 00       	call   802076 <find_block>
  801505:	83 c4 10             	add    $0x10,%esp
  801508:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80150b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150e:	8b 50 0c             	mov    0xc(%eax),%edx
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
  801514:	83 ec 08             	sub    $0x8,%esp
  801517:	52                   	push   %edx
  801518:	50                   	push   %eax
  801519:	e8 bd 03 00 00       	call   8018db <sys_free_user_mem>
  80151e:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801521:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801525:	75 14                	jne    80153b <free+0x5e>
  801527:	83 ec 04             	sub    $0x4,%esp
  80152a:	68 75 39 80 00       	push   $0x803975
  80152f:	6a 71                	push   $0x71
  801531:	68 93 39 80 00       	push   $0x803993
  801536:	e8 47 ed ff ff       	call   800282 <_panic>
  80153b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153e:	8b 00                	mov    (%eax),%eax
  801540:	85 c0                	test   %eax,%eax
  801542:	74 10                	je     801554 <free+0x77>
  801544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801547:	8b 00                	mov    (%eax),%eax
  801549:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80154c:	8b 52 04             	mov    0x4(%edx),%edx
  80154f:	89 50 04             	mov    %edx,0x4(%eax)
  801552:	eb 0b                	jmp    80155f <free+0x82>
  801554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801557:	8b 40 04             	mov    0x4(%eax),%eax
  80155a:	a3 44 40 80 00       	mov    %eax,0x804044
  80155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801562:	8b 40 04             	mov    0x4(%eax),%eax
  801565:	85 c0                	test   %eax,%eax
  801567:	74 0f                	je     801578 <free+0x9b>
  801569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156c:	8b 40 04             	mov    0x4(%eax),%eax
  80156f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801572:	8b 12                	mov    (%edx),%edx
  801574:	89 10                	mov    %edx,(%eax)
  801576:	eb 0a                	jmp    801582 <free+0xa5>
  801578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157b:	8b 00                	mov    (%eax),%eax
  80157d:	a3 40 40 80 00       	mov    %eax,0x804040
  801582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801585:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80158b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801595:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80159a:	48                   	dec    %eax
  80159b:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8015a0:	83 ec 0c             	sub    $0xc,%esp
  8015a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8015a6:	e8 83 12 00 00       	call   80282e <insert_sorted_with_merge_freeList>
  8015ab:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015ae:	90                   	nop
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	83 ec 28             	sub    $0x28,%esp
  8015b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ba:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015bd:	e8 fe fc ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c6:	75 0a                	jne    8015d2 <smalloc+0x21>
  8015c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cd:	e9 86 00 00 00       	jmp    801658 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8015d2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	01 d0                	add    %edx,%eax
  8015e1:	48                   	dec    %eax
  8015e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ed:	f7 75 f4             	divl   -0xc(%ebp)
  8015f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f3:	29 d0                	sub    %edx,%eax
  8015f5:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015f8:	e8 e4 06 00 00       	call   801ce1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015fd:	85 c0                	test   %eax,%eax
  8015ff:	74 52                	je     801653 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	ff 75 0c             	pushl  0xc(%ebp)
  801607:	e8 e6 0d 00 00       	call   8023f2 <alloc_block_FF>
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801612:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801616:	75 07                	jne    80161f <smalloc+0x6e>
			return NULL ;
  801618:	b8 00 00 00 00       	mov    $0x0,%eax
  80161d:	eb 39                	jmp    801658 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80161f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801622:	8b 40 08             	mov    0x8(%eax),%eax
  801625:	89 c2                	mov    %eax,%edx
  801627:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80162b:	52                   	push   %edx
  80162c:	50                   	push   %eax
  80162d:	ff 75 0c             	pushl  0xc(%ebp)
  801630:	ff 75 08             	pushl  0x8(%ebp)
  801633:	e8 2e 04 00 00       	call   801a66 <sys_createSharedObject>
  801638:	83 c4 10             	add    $0x10,%esp
  80163b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80163e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801642:	79 07                	jns    80164b <smalloc+0x9a>
			return (void*)NULL ;
  801644:	b8 00 00 00 00       	mov    $0x0,%eax
  801649:	eb 0d                	jmp    801658 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  80164b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164e:	8b 40 08             	mov    0x8(%eax),%eax
  801651:	eb 05                	jmp    801658 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801660:	e8 5b fc ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801665:	83 ec 08             	sub    $0x8,%esp
  801668:	ff 75 0c             	pushl  0xc(%ebp)
  80166b:	ff 75 08             	pushl  0x8(%ebp)
  80166e:	e8 1d 04 00 00       	call   801a90 <sys_getSizeOfSharedObject>
  801673:	83 c4 10             	add    $0x10,%esp
  801676:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801679:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80167d:	75 0a                	jne    801689 <sget+0x2f>
			return NULL ;
  80167f:	b8 00 00 00 00       	mov    $0x0,%eax
  801684:	e9 83 00 00 00       	jmp    80170c <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801689:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801690:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801696:	01 d0                	add    %edx,%eax
  801698:	48                   	dec    %eax
  801699:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80169c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169f:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a4:	f7 75 f0             	divl   -0x10(%ebp)
  8016a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016aa:	29 d0                	sub    %edx,%eax
  8016ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016af:	e8 2d 06 00 00       	call   801ce1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	74 4f                	je     801707 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8016b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bb:	83 ec 0c             	sub    $0xc,%esp
  8016be:	50                   	push   %eax
  8016bf:	e8 2e 0d 00 00       	call   8023f2 <alloc_block_FF>
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8016ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016ce:	75 07                	jne    8016d7 <sget+0x7d>
					return (void*)NULL ;
  8016d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d5:	eb 35                	jmp    80170c <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8016d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016da:	8b 40 08             	mov    0x8(%eax),%eax
  8016dd:	83 ec 04             	sub    $0x4,%esp
  8016e0:	50                   	push   %eax
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	ff 75 08             	pushl  0x8(%ebp)
  8016e7:	e8 c1 03 00 00       	call   801aad <sys_getSharedObject>
  8016ec:	83 c4 10             	add    $0x10,%esp
  8016ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8016f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016f6:	79 07                	jns    8016ff <sget+0xa5>
				return (void*)NULL ;
  8016f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fd:	eb 0d                	jmp    80170c <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8016ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801702:	8b 40 08             	mov    0x8(%eax),%eax
  801705:	eb 05                	jmp    80170c <sget+0xb2>


		}
	return (void*)NULL ;
  801707:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80170c:	c9                   	leave  
  80170d:	c3                   	ret    

0080170e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801714:	e8 a7 fb ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801719:	83 ec 04             	sub    $0x4,%esp
  80171c:	68 a0 39 80 00       	push   $0x8039a0
  801721:	68 f9 00 00 00       	push   $0xf9
  801726:	68 93 39 80 00       	push   $0x803993
  80172b:	e8 52 eb ff ff       	call   800282 <_panic>

00801730 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801736:	83 ec 04             	sub    $0x4,%esp
  801739:	68 c8 39 80 00       	push   $0x8039c8
  80173e:	68 0d 01 00 00       	push   $0x10d
  801743:	68 93 39 80 00       	push   $0x803993
  801748:	e8 35 eb ff ff       	call   800282 <_panic>

0080174d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801753:	83 ec 04             	sub    $0x4,%esp
  801756:	68 ec 39 80 00       	push   $0x8039ec
  80175b:	68 18 01 00 00       	push   $0x118
  801760:	68 93 39 80 00       	push   $0x803993
  801765:	e8 18 eb ff ff       	call   800282 <_panic>

0080176a <shrink>:

}
void shrink(uint32 newSize)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801770:	83 ec 04             	sub    $0x4,%esp
  801773:	68 ec 39 80 00       	push   $0x8039ec
  801778:	68 1d 01 00 00       	push   $0x11d
  80177d:	68 93 39 80 00       	push   $0x803993
  801782:	e8 fb ea ff ff       	call   800282 <_panic>

00801787 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178d:	83 ec 04             	sub    $0x4,%esp
  801790:	68 ec 39 80 00       	push   $0x8039ec
  801795:	68 22 01 00 00       	push   $0x122
  80179a:	68 93 39 80 00       	push   $0x803993
  80179f:	e8 de ea ff ff       	call   800282 <_panic>

008017a4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017a4:	55                   	push   %ebp
  8017a5:	89 e5                	mov    %esp,%ebp
  8017a7:	57                   	push   %edi
  8017a8:	56                   	push   %esi
  8017a9:	53                   	push   %ebx
  8017aa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017b9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017bc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017bf:	cd 30                	int    $0x30
  8017c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	5b                   	pop    %ebx
  8017cb:	5e                   	pop    %esi
  8017cc:	5f                   	pop    %edi
  8017cd:	5d                   	pop    %ebp
  8017ce:	c3                   	ret    

008017cf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017cf:	55                   	push   %ebp
  8017d0:	89 e5                	mov    %esp,%ebp
  8017d2:	83 ec 04             	sub    $0x4,%esp
  8017d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017db:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017df:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e2:	6a 00                	push   $0x0
  8017e4:	6a 00                	push   $0x0
  8017e6:	52                   	push   %edx
  8017e7:	ff 75 0c             	pushl  0xc(%ebp)
  8017ea:	50                   	push   %eax
  8017eb:	6a 00                	push   $0x0
  8017ed:	e8 b2 ff ff ff       	call   8017a4 <syscall>
  8017f2:	83 c4 18             	add    $0x18,%esp
}
  8017f5:	90                   	nop
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 00                	push   $0x0
  801805:	6a 01                	push   $0x1
  801807:	e8 98 ff ff ff       	call   8017a4 <syscall>
  80180c:	83 c4 18             	add    $0x18,%esp
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801814:	8b 55 0c             	mov    0xc(%ebp),%edx
  801817:	8b 45 08             	mov    0x8(%ebp),%eax
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	52                   	push   %edx
  801821:	50                   	push   %eax
  801822:	6a 05                	push   $0x5
  801824:	e8 7b ff ff ff       	call   8017a4 <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	56                   	push   %esi
  801832:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801833:	8b 75 18             	mov    0x18(%ebp),%esi
  801836:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801839:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80183c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80183f:	8b 45 08             	mov    0x8(%ebp),%eax
  801842:	56                   	push   %esi
  801843:	53                   	push   %ebx
  801844:	51                   	push   %ecx
  801845:	52                   	push   %edx
  801846:	50                   	push   %eax
  801847:	6a 06                	push   $0x6
  801849:	e8 56 ff ff ff       	call   8017a4 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801854:	5b                   	pop    %ebx
  801855:	5e                   	pop    %esi
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    

00801858 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80185b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185e:	8b 45 08             	mov    0x8(%ebp),%eax
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 00                	push   $0x0
  801867:	52                   	push   %edx
  801868:	50                   	push   %eax
  801869:	6a 07                	push   $0x7
  80186b:	e8 34 ff ff ff       	call   8017a4 <syscall>
  801870:	83 c4 18             	add    $0x18,%esp
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	ff 75 0c             	pushl  0xc(%ebp)
  801881:	ff 75 08             	pushl  0x8(%ebp)
  801884:	6a 08                	push   $0x8
  801886:	e8 19 ff ff ff       	call   8017a4 <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 09                	push   $0x9
  80189f:	e8 00 ff ff ff       	call   8017a4 <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 0a                	push   $0xa
  8018b8:	e8 e7 fe ff ff       	call   8017a4 <syscall>
  8018bd:	83 c4 18             	add    $0x18,%esp
}
  8018c0:	c9                   	leave  
  8018c1:	c3                   	ret    

008018c2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 0b                	push   $0xb
  8018d1:	e8 ce fe ff ff       	call   8017a4 <syscall>
  8018d6:	83 c4 18             	add    $0x18,%esp
}
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	ff 75 0c             	pushl  0xc(%ebp)
  8018e7:	ff 75 08             	pushl  0x8(%ebp)
  8018ea:	6a 0f                	push   $0xf
  8018ec:	e8 b3 fe ff ff       	call   8017a4 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
	return;
  8018f4:	90                   	nop
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	ff 75 0c             	pushl  0xc(%ebp)
  801903:	ff 75 08             	pushl  0x8(%ebp)
  801906:	6a 10                	push   $0x10
  801908:	e8 97 fe ff ff       	call   8017a4 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
	return ;
  801910:	90                   	nop
}
  801911:	c9                   	leave  
  801912:	c3                   	ret    

00801913 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	ff 75 10             	pushl  0x10(%ebp)
  80191d:	ff 75 0c             	pushl  0xc(%ebp)
  801920:	ff 75 08             	pushl  0x8(%ebp)
  801923:	6a 11                	push   $0x11
  801925:	e8 7a fe ff ff       	call   8017a4 <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
	return ;
  80192d:	90                   	nop
}
  80192e:	c9                   	leave  
  80192f:	c3                   	ret    

00801930 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 0c                	push   $0xc
  80193f:	e8 60 fe ff ff       	call   8017a4 <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
}
  801947:	c9                   	leave  
  801948:	c3                   	ret    

00801949 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	ff 75 08             	pushl  0x8(%ebp)
  801957:	6a 0d                	push   $0xd
  801959:	e8 46 fe ff ff       	call   8017a4 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 0e                	push   $0xe
  801972:	e8 2d fe ff ff       	call   8017a4 <syscall>
  801977:	83 c4 18             	add    $0x18,%esp
}
  80197a:	90                   	nop
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 13                	push   $0x13
  80198c:	e8 13 fe ff ff       	call   8017a4 <syscall>
  801991:	83 c4 18             	add    $0x18,%esp
}
  801994:	90                   	nop
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 14                	push   $0x14
  8019a6:	e8 f9 fd ff ff       	call   8017a4 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 04             	sub    $0x4,%esp
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019bd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	50                   	push   %eax
  8019ca:	6a 15                	push   $0x15
  8019cc:	e8 d3 fd ff ff       	call   8017a4 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	90                   	nop
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 16                	push   $0x16
  8019e6:	e8 b9 fd ff ff       	call   8017a4 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	90                   	nop
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	ff 75 0c             	pushl  0xc(%ebp)
  801a00:	50                   	push   %eax
  801a01:	6a 17                	push   $0x17
  801a03:	e8 9c fd ff ff       	call   8017a4 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	52                   	push   %edx
  801a1d:	50                   	push   %eax
  801a1e:	6a 1a                	push   $0x1a
  801a20:	e8 7f fd ff ff       	call   8017a4 <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	52                   	push   %edx
  801a3a:	50                   	push   %eax
  801a3b:	6a 18                	push   $0x18
  801a3d:	e8 62 fd ff ff       	call   8017a4 <syscall>
  801a42:	83 c4 18             	add    $0x18,%esp
}
  801a45:	90                   	nop
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	52                   	push   %edx
  801a58:	50                   	push   %eax
  801a59:	6a 19                	push   $0x19
  801a5b:	e8 44 fd ff ff       	call   8017a4 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	90                   	nop
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
  801a69:	83 ec 04             	sub    $0x4,%esp
  801a6c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a72:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a75:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a79:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7c:	6a 00                	push   $0x0
  801a7e:	51                   	push   %ecx
  801a7f:	52                   	push   %edx
  801a80:	ff 75 0c             	pushl  0xc(%ebp)
  801a83:	50                   	push   %eax
  801a84:	6a 1b                	push   $0x1b
  801a86:	e8 19 fd ff ff       	call   8017a4 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	52                   	push   %edx
  801aa0:	50                   	push   %eax
  801aa1:	6a 1c                	push   $0x1c
  801aa3:	e8 fc fc ff ff       	call   8017a4 <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ab0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	51                   	push   %ecx
  801abe:	52                   	push   %edx
  801abf:	50                   	push   %eax
  801ac0:	6a 1d                	push   $0x1d
  801ac2:	e8 dd fc ff ff       	call   8017a4 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	52                   	push   %edx
  801adc:	50                   	push   %eax
  801add:	6a 1e                	push   $0x1e
  801adf:	e8 c0 fc ff ff       	call   8017a4 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 1f                	push   $0x1f
  801af8:	e8 a7 fc ff ff       	call   8017a4 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	6a 00                	push   $0x0
  801b0a:	ff 75 14             	pushl  0x14(%ebp)
  801b0d:	ff 75 10             	pushl  0x10(%ebp)
  801b10:	ff 75 0c             	pushl  0xc(%ebp)
  801b13:	50                   	push   %eax
  801b14:	6a 20                	push   $0x20
  801b16:	e8 89 fc ff ff       	call   8017a4 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	50                   	push   %eax
  801b2f:	6a 21                	push   $0x21
  801b31:	e8 6e fc ff ff       	call   8017a4 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	90                   	nop
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	50                   	push   %eax
  801b4b:	6a 22                	push   $0x22
  801b4d:	e8 52 fc ff ff       	call   8017a4 <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 02                	push   $0x2
  801b66:	e8 39 fc ff ff       	call   8017a4 <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 03                	push   $0x3
  801b7f:	e8 20 fc ff ff       	call   8017a4 <syscall>
  801b84:	83 c4 18             	add    $0x18,%esp
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 04                	push   $0x4
  801b98:	e8 07 fc ff ff       	call   8017a4 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_exit_env>:


void sys_exit_env(void)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 23                	push   $0x23
  801bb1:	e8 ee fb ff ff       	call   8017a4 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	90                   	nop
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
  801bbf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bc2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bc5:	8d 50 04             	lea    0x4(%eax),%edx
  801bc8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	52                   	push   %edx
  801bd2:	50                   	push   %eax
  801bd3:	6a 24                	push   $0x24
  801bd5:	e8 ca fb ff ff       	call   8017a4 <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
	return result;
  801bdd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801be0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801be3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be6:	89 01                	mov    %eax,(%ecx)
  801be8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	c9                   	leave  
  801bef:	c2 04 00             	ret    $0x4

00801bf2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	ff 75 10             	pushl  0x10(%ebp)
  801bfc:	ff 75 0c             	pushl  0xc(%ebp)
  801bff:	ff 75 08             	pushl  0x8(%ebp)
  801c02:	6a 12                	push   $0x12
  801c04:	e8 9b fb ff ff       	call   8017a4 <syscall>
  801c09:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0c:	90                   	nop
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <sys_rcr2>:
uint32 sys_rcr2()
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 25                	push   $0x25
  801c1e:	e8 81 fb ff ff       	call   8017a4 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
  801c2b:	83 ec 04             	sub    $0x4,%esp
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c34:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	50                   	push   %eax
  801c41:	6a 26                	push   $0x26
  801c43:	e8 5c fb ff ff       	call   8017a4 <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4b:	90                   	nop
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <rsttst>:
void rsttst()
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 28                	push   $0x28
  801c5d:	e8 42 fb ff ff       	call   8017a4 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
	return ;
  801c65:	90                   	nop
}
  801c66:	c9                   	leave  
  801c67:	c3                   	ret    

00801c68 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
  801c6b:	83 ec 04             	sub    $0x4,%esp
  801c6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c71:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c74:	8b 55 18             	mov    0x18(%ebp),%edx
  801c77:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c7b:	52                   	push   %edx
  801c7c:	50                   	push   %eax
  801c7d:	ff 75 10             	pushl  0x10(%ebp)
  801c80:	ff 75 0c             	pushl  0xc(%ebp)
  801c83:	ff 75 08             	pushl  0x8(%ebp)
  801c86:	6a 27                	push   $0x27
  801c88:	e8 17 fb ff ff       	call   8017a4 <syscall>
  801c8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c90:	90                   	nop
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <chktst>:
void chktst(uint32 n)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	ff 75 08             	pushl  0x8(%ebp)
  801ca1:	6a 29                	push   $0x29
  801ca3:	e8 fc fa ff ff       	call   8017a4 <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cab:	90                   	nop
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <inctst>:

void inctst()
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 2a                	push   $0x2a
  801cbd:	e8 e2 fa ff ff       	call   8017a4 <syscall>
  801cc2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc5:	90                   	nop
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <gettst>:
uint32 gettst()
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 2b                	push   $0x2b
  801cd7:	e8 c8 fa ff ff       	call   8017a4 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 2c                	push   $0x2c
  801cf3:	e8 ac fa ff ff       	call   8017a4 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
  801cfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cfe:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d02:	75 07                	jne    801d0b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d04:	b8 01 00 00 00       	mov    $0x1,%eax
  801d09:	eb 05                	jmp    801d10 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 2c                	push   $0x2c
  801d24:	e8 7b fa ff ff       	call   8017a4 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
  801d2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d2f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d33:	75 07                	jne    801d3c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d35:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3a:	eb 05                	jmp    801d41 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 2c                	push   $0x2c
  801d55:	e8 4a fa ff ff       	call   8017a4 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
  801d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d60:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d64:	75 07                	jne    801d6d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d66:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6b:	eb 05                	jmp    801d72 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 2c                	push   $0x2c
  801d86:	e8 19 fa ff ff       	call   8017a4 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
  801d8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d91:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d95:	75 07                	jne    801d9e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d97:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9c:	eb 05                	jmp    801da3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	ff 75 08             	pushl  0x8(%ebp)
  801db3:	6a 2d                	push   $0x2d
  801db5:	e8 ea f9 ff ff       	call   8017a4 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbd:	90                   	nop
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dc4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	6a 00                	push   $0x0
  801dd2:	53                   	push   %ebx
  801dd3:	51                   	push   %ecx
  801dd4:	52                   	push   %edx
  801dd5:	50                   	push   %eax
  801dd6:	6a 2e                	push   $0x2e
  801dd8:	e8 c7 f9 ff ff       	call   8017a4 <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
}
  801de0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801de8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	52                   	push   %edx
  801df5:	50                   	push   %eax
  801df6:	6a 2f                	push   $0x2f
  801df8:	e8 a7 f9 ff ff       	call   8017a4 <syscall>
  801dfd:	83 c4 18             	add    $0x18,%esp
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e08:	83 ec 0c             	sub    $0xc,%esp
  801e0b:	68 fc 39 80 00       	push   $0x8039fc
  801e10:	e8 21 e7 ff ff       	call   800536 <cprintf>
  801e15:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e18:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e1f:	83 ec 0c             	sub    $0xc,%esp
  801e22:	68 28 3a 80 00       	push   $0x803a28
  801e27:	e8 0a e7 ff ff       	call   800536 <cprintf>
  801e2c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e2f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e33:	a1 38 41 80 00       	mov    0x804138,%eax
  801e38:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e3b:	eb 56                	jmp    801e93 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e41:	74 1c                	je     801e5f <print_mem_block_lists+0x5d>
  801e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e46:	8b 50 08             	mov    0x8(%eax),%edx
  801e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4c:	8b 48 08             	mov    0x8(%eax),%ecx
  801e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e52:	8b 40 0c             	mov    0xc(%eax),%eax
  801e55:	01 c8                	add    %ecx,%eax
  801e57:	39 c2                	cmp    %eax,%edx
  801e59:	73 04                	jae    801e5f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e5b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e62:	8b 50 08             	mov    0x8(%eax),%edx
  801e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e68:	8b 40 0c             	mov    0xc(%eax),%eax
  801e6b:	01 c2                	add    %eax,%edx
  801e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e70:	8b 40 08             	mov    0x8(%eax),%eax
  801e73:	83 ec 04             	sub    $0x4,%esp
  801e76:	52                   	push   %edx
  801e77:	50                   	push   %eax
  801e78:	68 3d 3a 80 00       	push   $0x803a3d
  801e7d:	e8 b4 e6 ff ff       	call   800536 <cprintf>
  801e82:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e88:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e8b:	a1 40 41 80 00       	mov    0x804140,%eax
  801e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e97:	74 07                	je     801ea0 <print_mem_block_lists+0x9e>
  801e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9c:	8b 00                	mov    (%eax),%eax
  801e9e:	eb 05                	jmp    801ea5 <print_mem_block_lists+0xa3>
  801ea0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea5:	a3 40 41 80 00       	mov    %eax,0x804140
  801eaa:	a1 40 41 80 00       	mov    0x804140,%eax
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	75 8a                	jne    801e3d <print_mem_block_lists+0x3b>
  801eb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb7:	75 84                	jne    801e3d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801eb9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ebd:	75 10                	jne    801ecf <print_mem_block_lists+0xcd>
  801ebf:	83 ec 0c             	sub    $0xc,%esp
  801ec2:	68 4c 3a 80 00       	push   $0x803a4c
  801ec7:	e8 6a e6 ff ff       	call   800536 <cprintf>
  801ecc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ecf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ed6:	83 ec 0c             	sub    $0xc,%esp
  801ed9:	68 70 3a 80 00       	push   $0x803a70
  801ede:	e8 53 e6 ff ff       	call   800536 <cprintf>
  801ee3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ee6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801eea:	a1 40 40 80 00       	mov    0x804040,%eax
  801eef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef2:	eb 56                	jmp    801f4a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ef4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ef8:	74 1c                	je     801f16 <print_mem_block_lists+0x114>
  801efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efd:	8b 50 08             	mov    0x8(%eax),%edx
  801f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f03:	8b 48 08             	mov    0x8(%eax),%ecx
  801f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f09:	8b 40 0c             	mov    0xc(%eax),%eax
  801f0c:	01 c8                	add    %ecx,%eax
  801f0e:	39 c2                	cmp    %eax,%edx
  801f10:	73 04                	jae    801f16 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f12:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	8b 50 08             	mov    0x8(%eax),%edx
  801f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f22:	01 c2                	add    %eax,%edx
  801f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f27:	8b 40 08             	mov    0x8(%eax),%eax
  801f2a:	83 ec 04             	sub    $0x4,%esp
  801f2d:	52                   	push   %edx
  801f2e:	50                   	push   %eax
  801f2f:	68 3d 3a 80 00       	push   $0x803a3d
  801f34:	e8 fd e5 ff ff       	call   800536 <cprintf>
  801f39:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f42:	a1 48 40 80 00       	mov    0x804048,%eax
  801f47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f4e:	74 07                	je     801f57 <print_mem_block_lists+0x155>
  801f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f53:	8b 00                	mov    (%eax),%eax
  801f55:	eb 05                	jmp    801f5c <print_mem_block_lists+0x15a>
  801f57:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5c:	a3 48 40 80 00       	mov    %eax,0x804048
  801f61:	a1 48 40 80 00       	mov    0x804048,%eax
  801f66:	85 c0                	test   %eax,%eax
  801f68:	75 8a                	jne    801ef4 <print_mem_block_lists+0xf2>
  801f6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f6e:	75 84                	jne    801ef4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f70:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f74:	75 10                	jne    801f86 <print_mem_block_lists+0x184>
  801f76:	83 ec 0c             	sub    $0xc,%esp
  801f79:	68 88 3a 80 00       	push   $0x803a88
  801f7e:	e8 b3 e5 ff ff       	call   800536 <cprintf>
  801f83:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f86:	83 ec 0c             	sub    $0xc,%esp
  801f89:	68 fc 39 80 00       	push   $0x8039fc
  801f8e:	e8 a3 e5 ff ff       	call   800536 <cprintf>
  801f93:	83 c4 10             	add    $0x10,%esp

}
  801f96:	90                   	nop
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801f9f:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fa6:	00 00 00 
  801fa9:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fb0:	00 00 00 
  801fb3:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801fba:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801fbd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fc4:	e9 9e 00 00 00       	jmp    802067 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  801fc9:	a1 50 40 80 00       	mov    0x804050,%eax
  801fce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd1:	c1 e2 04             	shl    $0x4,%edx
  801fd4:	01 d0                	add    %edx,%eax
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	75 14                	jne    801fee <initialize_MemBlocksList+0x55>
  801fda:	83 ec 04             	sub    $0x4,%esp
  801fdd:	68 b0 3a 80 00       	push   $0x803ab0
  801fe2:	6a 43                	push   $0x43
  801fe4:	68 d3 3a 80 00       	push   $0x803ad3
  801fe9:	e8 94 e2 ff ff       	call   800282 <_panic>
  801fee:	a1 50 40 80 00       	mov    0x804050,%eax
  801ff3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff6:	c1 e2 04             	shl    $0x4,%edx
  801ff9:	01 d0                	add    %edx,%eax
  801ffb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802001:	89 10                	mov    %edx,(%eax)
  802003:	8b 00                	mov    (%eax),%eax
  802005:	85 c0                	test   %eax,%eax
  802007:	74 18                	je     802021 <initialize_MemBlocksList+0x88>
  802009:	a1 48 41 80 00       	mov    0x804148,%eax
  80200e:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802014:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802017:	c1 e1 04             	shl    $0x4,%ecx
  80201a:	01 ca                	add    %ecx,%edx
  80201c:	89 50 04             	mov    %edx,0x4(%eax)
  80201f:	eb 12                	jmp    802033 <initialize_MemBlocksList+0x9a>
  802021:	a1 50 40 80 00       	mov    0x804050,%eax
  802026:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802029:	c1 e2 04             	shl    $0x4,%edx
  80202c:	01 d0                	add    %edx,%eax
  80202e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802033:	a1 50 40 80 00       	mov    0x804050,%eax
  802038:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203b:	c1 e2 04             	shl    $0x4,%edx
  80203e:	01 d0                	add    %edx,%eax
  802040:	a3 48 41 80 00       	mov    %eax,0x804148
  802045:	a1 50 40 80 00       	mov    0x804050,%eax
  80204a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204d:	c1 e2 04             	shl    $0x4,%edx
  802050:	01 d0                	add    %edx,%eax
  802052:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802059:	a1 54 41 80 00       	mov    0x804154,%eax
  80205e:	40                   	inc    %eax
  80205f:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802064:	ff 45 f4             	incl   -0xc(%ebp)
  802067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80206d:	0f 82 56 ff ff ff    	jb     801fc9 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802073:	90                   	nop
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80207c:	a1 38 41 80 00       	mov    0x804138,%eax
  802081:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802084:	eb 18                	jmp    80209e <find_block+0x28>
	{
		if (ele->sva==va)
  802086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802089:	8b 40 08             	mov    0x8(%eax),%eax
  80208c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80208f:	75 05                	jne    802096 <find_block+0x20>
			return ele;
  802091:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802094:	eb 7b                	jmp    802111 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802096:	a1 40 41 80 00       	mov    0x804140,%eax
  80209b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80209e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020a2:	74 07                	je     8020ab <find_block+0x35>
  8020a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a7:	8b 00                	mov    (%eax),%eax
  8020a9:	eb 05                	jmp    8020b0 <find_block+0x3a>
  8020ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b0:	a3 40 41 80 00       	mov    %eax,0x804140
  8020b5:	a1 40 41 80 00       	mov    0x804140,%eax
  8020ba:	85 c0                	test   %eax,%eax
  8020bc:	75 c8                	jne    802086 <find_block+0x10>
  8020be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020c2:	75 c2                	jne    802086 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020c4:	a1 40 40 80 00       	mov    0x804040,%eax
  8020c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020cc:	eb 18                	jmp    8020e6 <find_block+0x70>
	{
		if (ele->sva==va)
  8020ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d1:	8b 40 08             	mov    0x8(%eax),%eax
  8020d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020d7:	75 05                	jne    8020de <find_block+0x68>
					return ele;
  8020d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020dc:	eb 33                	jmp    802111 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020de:	a1 48 40 80 00       	mov    0x804048,%eax
  8020e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020e6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020ea:	74 07                	je     8020f3 <find_block+0x7d>
  8020ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ef:	8b 00                	mov    (%eax),%eax
  8020f1:	eb 05                	jmp    8020f8 <find_block+0x82>
  8020f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f8:	a3 48 40 80 00       	mov    %eax,0x804048
  8020fd:	a1 48 40 80 00       	mov    0x804048,%eax
  802102:	85 c0                	test   %eax,%eax
  802104:	75 c8                	jne    8020ce <find_block+0x58>
  802106:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80210a:	75 c2                	jne    8020ce <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  80210c:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802119:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80211e:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802121:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802125:	75 62                	jne    802189 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802127:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80212b:	75 14                	jne    802141 <insert_sorted_allocList+0x2e>
  80212d:	83 ec 04             	sub    $0x4,%esp
  802130:	68 b0 3a 80 00       	push   $0x803ab0
  802135:	6a 69                	push   $0x69
  802137:	68 d3 3a 80 00       	push   $0x803ad3
  80213c:	e8 41 e1 ff ff       	call   800282 <_panic>
  802141:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	89 10                	mov    %edx,(%eax)
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	8b 00                	mov    (%eax),%eax
  802151:	85 c0                	test   %eax,%eax
  802153:	74 0d                	je     802162 <insert_sorted_allocList+0x4f>
  802155:	a1 40 40 80 00       	mov    0x804040,%eax
  80215a:	8b 55 08             	mov    0x8(%ebp),%edx
  80215d:	89 50 04             	mov    %edx,0x4(%eax)
  802160:	eb 08                	jmp    80216a <insert_sorted_allocList+0x57>
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	a3 44 40 80 00       	mov    %eax,0x804044
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	a3 40 40 80 00       	mov    %eax,0x804040
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80217c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802181:	40                   	inc    %eax
  802182:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802187:	eb 72                	jmp    8021fb <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802189:	a1 40 40 80 00       	mov    0x804040,%eax
  80218e:	8b 50 08             	mov    0x8(%eax),%edx
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	8b 40 08             	mov    0x8(%eax),%eax
  802197:	39 c2                	cmp    %eax,%edx
  802199:	76 60                	jbe    8021fb <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80219b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80219f:	75 14                	jne    8021b5 <insert_sorted_allocList+0xa2>
  8021a1:	83 ec 04             	sub    $0x4,%esp
  8021a4:	68 b0 3a 80 00       	push   $0x803ab0
  8021a9:	6a 6d                	push   $0x6d
  8021ab:	68 d3 3a 80 00       	push   $0x803ad3
  8021b0:	e8 cd e0 ff ff       	call   800282 <_panic>
  8021b5:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	89 10                	mov    %edx,(%eax)
  8021c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c3:	8b 00                	mov    (%eax),%eax
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	74 0d                	je     8021d6 <insert_sorted_allocList+0xc3>
  8021c9:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d1:	89 50 04             	mov    %edx,0x4(%eax)
  8021d4:	eb 08                	jmp    8021de <insert_sorted_allocList+0xcb>
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	a3 44 40 80 00       	mov    %eax,0x804044
  8021de:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e1:	a3 40 40 80 00       	mov    %eax,0x804040
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021f5:	40                   	inc    %eax
  8021f6:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8021fb:	a1 40 40 80 00       	mov    0x804040,%eax
  802200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802203:	e9 b9 01 00 00       	jmp    8023c1 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	8b 50 08             	mov    0x8(%eax),%edx
  80220e:	a1 40 40 80 00       	mov    0x804040,%eax
  802213:	8b 40 08             	mov    0x8(%eax),%eax
  802216:	39 c2                	cmp    %eax,%edx
  802218:	76 7c                	jbe    802296 <insert_sorted_allocList+0x183>
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	8b 50 08             	mov    0x8(%eax),%edx
  802220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802223:	8b 40 08             	mov    0x8(%eax),%eax
  802226:	39 c2                	cmp    %eax,%edx
  802228:	73 6c                	jae    802296 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80222a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222e:	74 06                	je     802236 <insert_sorted_allocList+0x123>
  802230:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802234:	75 14                	jne    80224a <insert_sorted_allocList+0x137>
  802236:	83 ec 04             	sub    $0x4,%esp
  802239:	68 ec 3a 80 00       	push   $0x803aec
  80223e:	6a 75                	push   $0x75
  802240:	68 d3 3a 80 00       	push   $0x803ad3
  802245:	e8 38 e0 ff ff       	call   800282 <_panic>
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 50 04             	mov    0x4(%eax),%edx
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	89 50 04             	mov    %edx,0x4(%eax)
  802256:	8b 45 08             	mov    0x8(%ebp),%eax
  802259:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80225c:	89 10                	mov    %edx,(%eax)
  80225e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802261:	8b 40 04             	mov    0x4(%eax),%eax
  802264:	85 c0                	test   %eax,%eax
  802266:	74 0d                	je     802275 <insert_sorted_allocList+0x162>
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	8b 40 04             	mov    0x4(%eax),%eax
  80226e:	8b 55 08             	mov    0x8(%ebp),%edx
  802271:	89 10                	mov    %edx,(%eax)
  802273:	eb 08                	jmp    80227d <insert_sorted_allocList+0x16a>
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	a3 40 40 80 00       	mov    %eax,0x804040
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	8b 55 08             	mov    0x8(%ebp),%edx
  802283:	89 50 04             	mov    %edx,0x4(%eax)
  802286:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80228b:	40                   	inc    %eax
  80228c:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  802291:	e9 59 01 00 00       	jmp    8023ef <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	8b 50 08             	mov    0x8(%eax),%edx
  80229c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229f:	8b 40 08             	mov    0x8(%eax),%eax
  8022a2:	39 c2                	cmp    %eax,%edx
  8022a4:	0f 86 98 00 00 00    	jbe    802342 <insert_sorted_allocList+0x22f>
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	8b 50 08             	mov    0x8(%eax),%edx
  8022b0:	a1 44 40 80 00       	mov    0x804044,%eax
  8022b5:	8b 40 08             	mov    0x8(%eax),%eax
  8022b8:	39 c2                	cmp    %eax,%edx
  8022ba:	0f 83 82 00 00 00    	jae    802342 <insert_sorted_allocList+0x22f>
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	8b 50 08             	mov    0x8(%eax),%edx
  8022c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c9:	8b 00                	mov    (%eax),%eax
  8022cb:	8b 40 08             	mov    0x8(%eax),%eax
  8022ce:	39 c2                	cmp    %eax,%edx
  8022d0:	73 70                	jae    802342 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8022d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d6:	74 06                	je     8022de <insert_sorted_allocList+0x1cb>
  8022d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022dc:	75 14                	jne    8022f2 <insert_sorted_allocList+0x1df>
  8022de:	83 ec 04             	sub    $0x4,%esp
  8022e1:	68 24 3b 80 00       	push   $0x803b24
  8022e6:	6a 7c                	push   $0x7c
  8022e8:	68 d3 3a 80 00       	push   $0x803ad3
  8022ed:	e8 90 df ff ff       	call   800282 <_panic>
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	8b 10                	mov    (%eax),%edx
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	89 10                	mov    %edx,(%eax)
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	8b 00                	mov    (%eax),%eax
  802301:	85 c0                	test   %eax,%eax
  802303:	74 0b                	je     802310 <insert_sorted_allocList+0x1fd>
  802305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802308:	8b 00                	mov    (%eax),%eax
  80230a:	8b 55 08             	mov    0x8(%ebp),%edx
  80230d:	89 50 04             	mov    %edx,0x4(%eax)
  802310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802313:	8b 55 08             	mov    0x8(%ebp),%edx
  802316:	89 10                	mov    %edx,(%eax)
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231e:	89 50 04             	mov    %edx,0x4(%eax)
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	8b 00                	mov    (%eax),%eax
  802326:	85 c0                	test   %eax,%eax
  802328:	75 08                	jne    802332 <insert_sorted_allocList+0x21f>
  80232a:	8b 45 08             	mov    0x8(%ebp),%eax
  80232d:	a3 44 40 80 00       	mov    %eax,0x804044
  802332:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802337:	40                   	inc    %eax
  802338:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80233d:	e9 ad 00 00 00       	jmp    8023ef <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	8b 50 08             	mov    0x8(%eax),%edx
  802348:	a1 44 40 80 00       	mov    0x804044,%eax
  80234d:	8b 40 08             	mov    0x8(%eax),%eax
  802350:	39 c2                	cmp    %eax,%edx
  802352:	76 65                	jbe    8023b9 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802354:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802358:	75 17                	jne    802371 <insert_sorted_allocList+0x25e>
  80235a:	83 ec 04             	sub    $0x4,%esp
  80235d:	68 58 3b 80 00       	push   $0x803b58
  802362:	68 80 00 00 00       	push   $0x80
  802367:	68 d3 3a 80 00       	push   $0x803ad3
  80236c:	e8 11 df ff ff       	call   800282 <_panic>
  802371:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802377:	8b 45 08             	mov    0x8(%ebp),%eax
  80237a:	89 50 04             	mov    %edx,0x4(%eax)
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	8b 40 04             	mov    0x4(%eax),%eax
  802383:	85 c0                	test   %eax,%eax
  802385:	74 0c                	je     802393 <insert_sorted_allocList+0x280>
  802387:	a1 44 40 80 00       	mov    0x804044,%eax
  80238c:	8b 55 08             	mov    0x8(%ebp),%edx
  80238f:	89 10                	mov    %edx,(%eax)
  802391:	eb 08                	jmp    80239b <insert_sorted_allocList+0x288>
  802393:	8b 45 08             	mov    0x8(%ebp),%eax
  802396:	a3 40 40 80 00       	mov    %eax,0x804040
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	a3 44 40 80 00       	mov    %eax,0x804044
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ac:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023b1:	40                   	inc    %eax
  8023b2:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8023b7:	eb 36                	jmp    8023ef <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8023b9:	a1 48 40 80 00       	mov    0x804048,%eax
  8023be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c5:	74 07                	je     8023ce <insert_sorted_allocList+0x2bb>
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 00                	mov    (%eax),%eax
  8023cc:	eb 05                	jmp    8023d3 <insert_sorted_allocList+0x2c0>
  8023ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d3:	a3 48 40 80 00       	mov    %eax,0x804048
  8023d8:	a1 48 40 80 00       	mov    0x804048,%eax
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	0f 85 23 fe ff ff    	jne    802208 <insert_sorted_allocList+0xf5>
  8023e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e9:	0f 85 19 fe ff ff    	jne    802208 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8023ef:	90                   	nop
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8023f8:	a1 38 41 80 00       	mov    0x804138,%eax
  8023fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802400:	e9 7c 01 00 00       	jmp    802581 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802408:	8b 40 0c             	mov    0xc(%eax),%eax
  80240b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240e:	0f 85 90 00 00 00    	jne    8024a4 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802417:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  80241a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241e:	75 17                	jne    802437 <alloc_block_FF+0x45>
  802420:	83 ec 04             	sub    $0x4,%esp
  802423:	68 7b 3b 80 00       	push   $0x803b7b
  802428:	68 ba 00 00 00       	push   $0xba
  80242d:	68 d3 3a 80 00       	push   $0x803ad3
  802432:	e8 4b de ff ff       	call   800282 <_panic>
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 00                	mov    (%eax),%eax
  80243c:	85 c0                	test   %eax,%eax
  80243e:	74 10                	je     802450 <alloc_block_FF+0x5e>
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	8b 00                	mov    (%eax),%eax
  802445:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802448:	8b 52 04             	mov    0x4(%edx),%edx
  80244b:	89 50 04             	mov    %edx,0x4(%eax)
  80244e:	eb 0b                	jmp    80245b <alloc_block_FF+0x69>
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	8b 40 04             	mov    0x4(%eax),%eax
  802456:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 40 04             	mov    0x4(%eax),%eax
  802461:	85 c0                	test   %eax,%eax
  802463:	74 0f                	je     802474 <alloc_block_FF+0x82>
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 40 04             	mov    0x4(%eax),%eax
  80246b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246e:	8b 12                	mov    (%edx),%edx
  802470:	89 10                	mov    %edx,(%eax)
  802472:	eb 0a                	jmp    80247e <alloc_block_FF+0x8c>
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	a3 38 41 80 00       	mov    %eax,0x804138
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802491:	a1 44 41 80 00       	mov    0x804144,%eax
  802496:	48                   	dec    %eax
  802497:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  80249c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249f:	e9 10 01 00 00       	jmp    8025b4 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8024aa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ad:	0f 86 c6 00 00 00    	jbe    802579 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8024b3:	a1 48 41 80 00       	mov    0x804148,%eax
  8024b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8024bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024bf:	75 17                	jne    8024d8 <alloc_block_FF+0xe6>
  8024c1:	83 ec 04             	sub    $0x4,%esp
  8024c4:	68 7b 3b 80 00       	push   $0x803b7b
  8024c9:	68 c2 00 00 00       	push   $0xc2
  8024ce:	68 d3 3a 80 00       	push   $0x803ad3
  8024d3:	e8 aa dd ff ff       	call   800282 <_panic>
  8024d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024db:	8b 00                	mov    (%eax),%eax
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	74 10                	je     8024f1 <alloc_block_FF+0xff>
  8024e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e4:	8b 00                	mov    (%eax),%eax
  8024e6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024e9:	8b 52 04             	mov    0x4(%edx),%edx
  8024ec:	89 50 04             	mov    %edx,0x4(%eax)
  8024ef:	eb 0b                	jmp    8024fc <alloc_block_FF+0x10a>
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	8b 40 04             	mov    0x4(%eax),%eax
  8024f7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ff:	8b 40 04             	mov    0x4(%eax),%eax
  802502:	85 c0                	test   %eax,%eax
  802504:	74 0f                	je     802515 <alloc_block_FF+0x123>
  802506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802509:	8b 40 04             	mov    0x4(%eax),%eax
  80250c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80250f:	8b 12                	mov    (%edx),%edx
  802511:	89 10                	mov    %edx,(%eax)
  802513:	eb 0a                	jmp    80251f <alloc_block_FF+0x12d>
  802515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802518:	8b 00                	mov    (%eax),%eax
  80251a:	a3 48 41 80 00       	mov    %eax,0x804148
  80251f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802522:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802528:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802532:	a1 54 41 80 00       	mov    0x804154,%eax
  802537:	48                   	dec    %eax
  802538:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 50 08             	mov    0x8(%eax),%edx
  802543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802546:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254c:	8b 55 08             	mov    0x8(%ebp),%edx
  80254f:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 40 0c             	mov    0xc(%eax),%eax
  802558:	2b 45 08             	sub    0x8(%ebp),%eax
  80255b:	89 c2                	mov    %eax,%edx
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 50 08             	mov    0x8(%eax),%edx
  802569:	8b 45 08             	mov    0x8(%ebp),%eax
  80256c:	01 c2                	add    %eax,%edx
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802574:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802577:	eb 3b                	jmp    8025b4 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802579:	a1 40 41 80 00       	mov    0x804140,%eax
  80257e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802581:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802585:	74 07                	je     80258e <alloc_block_FF+0x19c>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 00                	mov    (%eax),%eax
  80258c:	eb 05                	jmp    802593 <alloc_block_FF+0x1a1>
  80258e:	b8 00 00 00 00       	mov    $0x0,%eax
  802593:	a3 40 41 80 00       	mov    %eax,0x804140
  802598:	a1 40 41 80 00       	mov    0x804140,%eax
  80259d:	85 c0                	test   %eax,%eax
  80259f:	0f 85 60 fe ff ff    	jne    802405 <alloc_block_FF+0x13>
  8025a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a9:	0f 85 56 fe ff ff    	jne    802405 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8025af:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b4:	c9                   	leave  
  8025b5:	c3                   	ret    

008025b6 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
  8025b9:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8025bc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025c3:	a1 38 41 80 00       	mov    0x804138,%eax
  8025c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025cb:	eb 3a                	jmp    802607 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d6:	72 27                	jb     8025ff <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8025d8:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8025dc:	75 0b                	jne    8025e9 <alloc_block_BF+0x33>
					best_size= element->size;
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8025e7:	eb 16                	jmp    8025ff <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 50 0c             	mov    0xc(%eax),%edx
  8025ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f2:	39 c2                	cmp    %eax,%edx
  8025f4:	77 09                	ja     8025ff <alloc_block_BF+0x49>
					best_size=element->size;
  8025f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025ff:	a1 40 41 80 00       	mov    0x804140,%eax
  802604:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260b:	74 07                	je     802614 <alloc_block_BF+0x5e>
  80260d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802610:	8b 00                	mov    (%eax),%eax
  802612:	eb 05                	jmp    802619 <alloc_block_BF+0x63>
  802614:	b8 00 00 00 00       	mov    $0x0,%eax
  802619:	a3 40 41 80 00       	mov    %eax,0x804140
  80261e:	a1 40 41 80 00       	mov    0x804140,%eax
  802623:	85 c0                	test   %eax,%eax
  802625:	75 a6                	jne    8025cd <alloc_block_BF+0x17>
  802627:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262b:	75 a0                	jne    8025cd <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80262d:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802631:	0f 84 d3 01 00 00    	je     80280a <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802637:	a1 38 41 80 00       	mov    0x804138,%eax
  80263c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263f:	e9 98 01 00 00       	jmp    8027dc <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802647:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264a:	0f 86 da 00 00 00    	jbe    80272a <alloc_block_BF+0x174>
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 50 0c             	mov    0xc(%eax),%edx
  802656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802659:	39 c2                	cmp    %eax,%edx
  80265b:	0f 85 c9 00 00 00    	jne    80272a <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802661:	a1 48 41 80 00       	mov    0x804148,%eax
  802666:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802669:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80266d:	75 17                	jne    802686 <alloc_block_BF+0xd0>
  80266f:	83 ec 04             	sub    $0x4,%esp
  802672:	68 7b 3b 80 00       	push   $0x803b7b
  802677:	68 ea 00 00 00       	push   $0xea
  80267c:	68 d3 3a 80 00       	push   $0x803ad3
  802681:	e8 fc db ff ff       	call   800282 <_panic>
  802686:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802689:	8b 00                	mov    (%eax),%eax
  80268b:	85 c0                	test   %eax,%eax
  80268d:	74 10                	je     80269f <alloc_block_BF+0xe9>
  80268f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802697:	8b 52 04             	mov    0x4(%edx),%edx
  80269a:	89 50 04             	mov    %edx,0x4(%eax)
  80269d:	eb 0b                	jmp    8026aa <alloc_block_BF+0xf4>
  80269f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a2:	8b 40 04             	mov    0x4(%eax),%eax
  8026a5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ad:	8b 40 04             	mov    0x4(%eax),%eax
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	74 0f                	je     8026c3 <alloc_block_BF+0x10d>
  8026b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026bd:	8b 12                	mov    (%edx),%edx
  8026bf:	89 10                	mov    %edx,(%eax)
  8026c1:	eb 0a                	jmp    8026cd <alloc_block_BF+0x117>
  8026c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	a3 48 41 80 00       	mov    %eax,0x804148
  8026cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e0:	a1 54 41 80 00       	mov    0x804154,%eax
  8026e5:	48                   	dec    %eax
  8026e6:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	8b 50 08             	mov    0x8(%eax),%edx
  8026f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f4:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8026f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8026fd:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 40 0c             	mov    0xc(%eax),%eax
  802706:	2b 45 08             	sub    0x8(%ebp),%eax
  802709:	89 c2                	mov    %eax,%edx
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	8b 50 08             	mov    0x8(%eax),%edx
  802717:	8b 45 08             	mov    0x8(%ebp),%eax
  80271a:	01 c2                	add    %eax,%edx
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802722:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802725:	e9 e5 00 00 00       	jmp    80280f <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 50 0c             	mov    0xc(%eax),%edx
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	39 c2                	cmp    %eax,%edx
  802735:	0f 85 99 00 00 00    	jne    8027d4 <alloc_block_BF+0x21e>
  80273b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802741:	0f 85 8d 00 00 00    	jne    8027d4 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  80274d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802751:	75 17                	jne    80276a <alloc_block_BF+0x1b4>
  802753:	83 ec 04             	sub    $0x4,%esp
  802756:	68 7b 3b 80 00       	push   $0x803b7b
  80275b:	68 f7 00 00 00       	push   $0xf7
  802760:	68 d3 3a 80 00       	push   $0x803ad3
  802765:	e8 18 db ff ff       	call   800282 <_panic>
  80276a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276d:	8b 00                	mov    (%eax),%eax
  80276f:	85 c0                	test   %eax,%eax
  802771:	74 10                	je     802783 <alloc_block_BF+0x1cd>
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	8b 00                	mov    (%eax),%eax
  802778:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277b:	8b 52 04             	mov    0x4(%edx),%edx
  80277e:	89 50 04             	mov    %edx,0x4(%eax)
  802781:	eb 0b                	jmp    80278e <alloc_block_BF+0x1d8>
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 40 04             	mov    0x4(%eax),%eax
  802789:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 40 04             	mov    0x4(%eax),%eax
  802794:	85 c0                	test   %eax,%eax
  802796:	74 0f                	je     8027a7 <alloc_block_BF+0x1f1>
  802798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279b:	8b 40 04             	mov    0x4(%eax),%eax
  80279e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a1:	8b 12                	mov    (%edx),%edx
  8027a3:	89 10                	mov    %edx,(%eax)
  8027a5:	eb 0a                	jmp    8027b1 <alloc_block_BF+0x1fb>
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 00                	mov    (%eax),%eax
  8027ac:	a3 38 41 80 00       	mov    %eax,0x804138
  8027b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c4:	a1 44 41 80 00       	mov    0x804144,%eax
  8027c9:	48                   	dec    %eax
  8027ca:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8027cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d2:	eb 3b                	jmp    80280f <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8027d4:	a1 40 41 80 00       	mov    0x804140,%eax
  8027d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e0:	74 07                	je     8027e9 <alloc_block_BF+0x233>
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	eb 05                	jmp    8027ee <alloc_block_BF+0x238>
  8027e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ee:	a3 40 41 80 00       	mov    %eax,0x804140
  8027f3:	a1 40 41 80 00       	mov    0x804140,%eax
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	0f 85 44 fe ff ff    	jne    802644 <alloc_block_BF+0x8e>
  802800:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802804:	0f 85 3a fe ff ff    	jne    802644 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80280a:	b8 00 00 00 00       	mov    $0x0,%eax
  80280f:	c9                   	leave  
  802810:	c3                   	ret    

00802811 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802811:	55                   	push   %ebp
  802812:	89 e5                	mov    %esp,%ebp
  802814:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802817:	83 ec 04             	sub    $0x4,%esp
  80281a:	68 9c 3b 80 00       	push   $0x803b9c
  80281f:	68 04 01 00 00       	push   $0x104
  802824:	68 d3 3a 80 00       	push   $0x803ad3
  802829:	e8 54 da ff ff       	call   800282 <_panic>

0080282e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80282e:	55                   	push   %ebp
  80282f:	89 e5                	mov    %esp,%ebp
  802831:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802834:	a1 38 41 80 00       	mov    0x804138,%eax
  802839:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  80283c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802841:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802844:	a1 38 41 80 00       	mov    0x804138,%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	75 68                	jne    8028b5 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80284d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802851:	75 17                	jne    80286a <insert_sorted_with_merge_freeList+0x3c>
  802853:	83 ec 04             	sub    $0x4,%esp
  802856:	68 b0 3a 80 00       	push   $0x803ab0
  80285b:	68 14 01 00 00       	push   $0x114
  802860:	68 d3 3a 80 00       	push   $0x803ad3
  802865:	e8 18 da ff ff       	call   800282 <_panic>
  80286a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802870:	8b 45 08             	mov    0x8(%ebp),%eax
  802873:	89 10                	mov    %edx,(%eax)
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	8b 00                	mov    (%eax),%eax
  80287a:	85 c0                	test   %eax,%eax
  80287c:	74 0d                	je     80288b <insert_sorted_with_merge_freeList+0x5d>
  80287e:	a1 38 41 80 00       	mov    0x804138,%eax
  802883:	8b 55 08             	mov    0x8(%ebp),%edx
  802886:	89 50 04             	mov    %edx,0x4(%eax)
  802889:	eb 08                	jmp    802893 <insert_sorted_with_merge_freeList+0x65>
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802893:	8b 45 08             	mov    0x8(%ebp),%eax
  802896:	a3 38 41 80 00       	mov    %eax,0x804138
  80289b:	8b 45 08             	mov    0x8(%ebp),%eax
  80289e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a5:	a1 44 41 80 00       	mov    0x804144,%eax
  8028aa:	40                   	inc    %eax
  8028ab:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8028b0:	e9 d2 06 00 00       	jmp    802f87 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8028b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b8:	8b 50 08             	mov    0x8(%eax),%edx
  8028bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028be:	8b 40 08             	mov    0x8(%eax),%eax
  8028c1:	39 c2                	cmp    %eax,%edx
  8028c3:	0f 83 22 01 00 00    	jae    8029eb <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cc:	8b 50 08             	mov    0x8(%eax),%edx
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d5:	01 c2                	add    %eax,%edx
  8028d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028da:	8b 40 08             	mov    0x8(%eax),%eax
  8028dd:	39 c2                	cmp    %eax,%edx
  8028df:	0f 85 9e 00 00 00    	jne    802983 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e8:	8b 50 08             	mov    0x8(%eax),%edx
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8028f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f4:	8b 50 0c             	mov    0xc(%eax),%edx
  8028f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fd:	01 c2                	add    %eax,%edx
  8028ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802902:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802905:	8b 45 08             	mov    0x8(%ebp),%eax
  802908:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	8b 50 08             	mov    0x8(%eax),%edx
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80291b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80291f:	75 17                	jne    802938 <insert_sorted_with_merge_freeList+0x10a>
  802921:	83 ec 04             	sub    $0x4,%esp
  802924:	68 b0 3a 80 00       	push   $0x803ab0
  802929:	68 21 01 00 00       	push   $0x121
  80292e:	68 d3 3a 80 00       	push   $0x803ad3
  802933:	e8 4a d9 ff ff       	call   800282 <_panic>
  802938:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	89 10                	mov    %edx,(%eax)
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	8b 00                	mov    (%eax),%eax
  802948:	85 c0                	test   %eax,%eax
  80294a:	74 0d                	je     802959 <insert_sorted_with_merge_freeList+0x12b>
  80294c:	a1 48 41 80 00       	mov    0x804148,%eax
  802951:	8b 55 08             	mov    0x8(%ebp),%edx
  802954:	89 50 04             	mov    %edx,0x4(%eax)
  802957:	eb 08                	jmp    802961 <insert_sorted_with_merge_freeList+0x133>
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	a3 48 41 80 00       	mov    %eax,0x804148
  802969:	8b 45 08             	mov    0x8(%ebp),%eax
  80296c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802973:	a1 54 41 80 00       	mov    0x804154,%eax
  802978:	40                   	inc    %eax
  802979:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  80297e:	e9 04 06 00 00       	jmp    802f87 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802983:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802987:	75 17                	jne    8029a0 <insert_sorted_with_merge_freeList+0x172>
  802989:	83 ec 04             	sub    $0x4,%esp
  80298c:	68 b0 3a 80 00       	push   $0x803ab0
  802991:	68 26 01 00 00       	push   $0x126
  802996:	68 d3 3a 80 00       	push   $0x803ad3
  80299b:	e8 e2 d8 ff ff       	call   800282 <_panic>
  8029a0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	89 10                	mov    %edx,(%eax)
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	8b 00                	mov    (%eax),%eax
  8029b0:	85 c0                	test   %eax,%eax
  8029b2:	74 0d                	je     8029c1 <insert_sorted_with_merge_freeList+0x193>
  8029b4:	a1 38 41 80 00       	mov    0x804138,%eax
  8029b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bc:	89 50 04             	mov    %edx,0x4(%eax)
  8029bf:	eb 08                	jmp    8029c9 <insert_sorted_with_merge_freeList+0x19b>
  8029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	a3 38 41 80 00       	mov    %eax,0x804138
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029db:	a1 44 41 80 00       	mov    0x804144,%eax
  8029e0:	40                   	inc    %eax
  8029e1:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8029e6:	e9 9c 05 00 00       	jmp    802f87 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	8b 50 08             	mov    0x8(%eax),%edx
  8029f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f4:	8b 40 08             	mov    0x8(%eax),%eax
  8029f7:	39 c2                	cmp    %eax,%edx
  8029f9:	0f 86 16 01 00 00    	jbe    802b15 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  8029ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a02:	8b 50 08             	mov    0x8(%eax),%edx
  802a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a08:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0b:	01 c2                	add    %eax,%edx
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	8b 40 08             	mov    0x8(%eax),%eax
  802a13:	39 c2                	cmp    %eax,%edx
  802a15:	0f 85 92 00 00 00    	jne    802aad <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1e:	8b 50 0c             	mov    0xc(%eax),%edx
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	8b 40 0c             	mov    0xc(%eax),%eax
  802a27:	01 c2                	add    %eax,%edx
  802a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2c:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	8b 50 08             	mov    0x8(%eax),%edx
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a49:	75 17                	jne    802a62 <insert_sorted_with_merge_freeList+0x234>
  802a4b:	83 ec 04             	sub    $0x4,%esp
  802a4e:	68 b0 3a 80 00       	push   $0x803ab0
  802a53:	68 31 01 00 00       	push   $0x131
  802a58:	68 d3 3a 80 00       	push   $0x803ad3
  802a5d:	e8 20 d8 ff ff       	call   800282 <_panic>
  802a62:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	89 10                	mov    %edx,(%eax)
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	8b 00                	mov    (%eax),%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	74 0d                	je     802a83 <insert_sorted_with_merge_freeList+0x255>
  802a76:	a1 48 41 80 00       	mov    0x804148,%eax
  802a7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7e:	89 50 04             	mov    %edx,0x4(%eax)
  802a81:	eb 08                	jmp    802a8b <insert_sorted_with_merge_freeList+0x25d>
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8e:	a3 48 41 80 00       	mov    %eax,0x804148
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9d:	a1 54 41 80 00       	mov    0x804154,%eax
  802aa2:	40                   	inc    %eax
  802aa3:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802aa8:	e9 da 04 00 00       	jmp    802f87 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802aad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab1:	75 17                	jne    802aca <insert_sorted_with_merge_freeList+0x29c>
  802ab3:	83 ec 04             	sub    $0x4,%esp
  802ab6:	68 58 3b 80 00       	push   $0x803b58
  802abb:	68 37 01 00 00       	push   $0x137
  802ac0:	68 d3 3a 80 00       	push   $0x803ad3
  802ac5:	e8 b8 d7 ff ff       	call   800282 <_panic>
  802aca:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	89 50 04             	mov    %edx,0x4(%eax)
  802ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad9:	8b 40 04             	mov    0x4(%eax),%eax
  802adc:	85 c0                	test   %eax,%eax
  802ade:	74 0c                	je     802aec <insert_sorted_with_merge_freeList+0x2be>
  802ae0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ae5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae8:	89 10                	mov    %edx,(%eax)
  802aea:	eb 08                	jmp    802af4 <insert_sorted_with_merge_freeList+0x2c6>
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	a3 38 41 80 00       	mov    %eax,0x804138
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802afc:	8b 45 08             	mov    0x8(%ebp),%eax
  802aff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b05:	a1 44 41 80 00       	mov    0x804144,%eax
  802b0a:	40                   	inc    %eax
  802b0b:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b10:	e9 72 04 00 00       	jmp    802f87 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802b15:	a1 38 41 80 00       	mov    0x804138,%eax
  802b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b1d:	e9 35 04 00 00       	jmp    802f57 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 00                	mov    (%eax),%eax
  802b27:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2d:	8b 50 08             	mov    0x8(%eax),%edx
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 40 08             	mov    0x8(%eax),%eax
  802b36:	39 c2                	cmp    %eax,%edx
  802b38:	0f 86 11 04 00 00    	jbe    802f4f <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 50 08             	mov    0x8(%eax),%edx
  802b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b47:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4a:	01 c2                	add    %eax,%edx
  802b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4f:	8b 40 08             	mov    0x8(%eax),%eax
  802b52:	39 c2                	cmp    %eax,%edx
  802b54:	0f 83 8b 00 00 00    	jae    802be5 <insert_sorted_with_merge_freeList+0x3b7>
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	8b 50 08             	mov    0x8(%eax),%edx
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	8b 40 0c             	mov    0xc(%eax),%eax
  802b66:	01 c2                	add    %eax,%edx
  802b68:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6b:	8b 40 08             	mov    0x8(%eax),%eax
  802b6e:	39 c2                	cmp    %eax,%edx
  802b70:	73 73                	jae    802be5 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802b72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b76:	74 06                	je     802b7e <insert_sorted_with_merge_freeList+0x350>
  802b78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7c:	75 17                	jne    802b95 <insert_sorted_with_merge_freeList+0x367>
  802b7e:	83 ec 04             	sub    $0x4,%esp
  802b81:	68 24 3b 80 00       	push   $0x803b24
  802b86:	68 48 01 00 00       	push   $0x148
  802b8b:	68 d3 3a 80 00       	push   $0x803ad3
  802b90:	e8 ed d6 ff ff       	call   800282 <_panic>
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	8b 10                	mov    (%eax),%edx
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	89 10                	mov    %edx,(%eax)
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 0b                	je     802bb3 <insert_sorted_with_merge_freeList+0x385>
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb0:	89 50 04             	mov    %edx,0x4(%eax)
  802bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb9:	89 10                	mov    %edx,(%eax)
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc1:	89 50 04             	mov    %edx,0x4(%eax)
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	8b 00                	mov    (%eax),%eax
  802bc9:	85 c0                	test   %eax,%eax
  802bcb:	75 08                	jne    802bd5 <insert_sorted_with_merge_freeList+0x3a7>
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bd5:	a1 44 41 80 00       	mov    0x804144,%eax
  802bda:	40                   	inc    %eax
  802bdb:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802be0:	e9 a2 03 00 00       	jmp    802f87 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802be5:	8b 45 08             	mov    0x8(%ebp),%eax
  802be8:	8b 50 08             	mov    0x8(%eax),%edx
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf1:	01 c2                	add    %eax,%edx
  802bf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bf6:	8b 40 08             	mov    0x8(%eax),%eax
  802bf9:	39 c2                	cmp    %eax,%edx
  802bfb:	0f 83 ae 00 00 00    	jae    802caf <insert_sorted_with_merge_freeList+0x481>
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	8b 50 08             	mov    0x8(%eax),%edx
  802c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0a:	8b 48 08             	mov    0x8(%eax),%ecx
  802c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c10:	8b 40 0c             	mov    0xc(%eax),%eax
  802c13:	01 c8                	add    %ecx,%eax
  802c15:	39 c2                	cmp    %eax,%edx
  802c17:	0f 85 92 00 00 00    	jne    802caf <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 50 0c             	mov    0xc(%eax),%edx
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	8b 40 0c             	mov    0xc(%eax),%eax
  802c29:	01 c2                	add    %eax,%edx
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	8b 50 08             	mov    0x8(%eax),%edx
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c47:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4b:	75 17                	jne    802c64 <insert_sorted_with_merge_freeList+0x436>
  802c4d:	83 ec 04             	sub    $0x4,%esp
  802c50:	68 b0 3a 80 00       	push   $0x803ab0
  802c55:	68 51 01 00 00       	push   $0x151
  802c5a:	68 d3 3a 80 00       	push   $0x803ad3
  802c5f:	e8 1e d6 ff ff       	call   800282 <_panic>
  802c64:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	89 10                	mov    %edx,(%eax)
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	8b 00                	mov    (%eax),%eax
  802c74:	85 c0                	test   %eax,%eax
  802c76:	74 0d                	je     802c85 <insert_sorted_with_merge_freeList+0x457>
  802c78:	a1 48 41 80 00       	mov    0x804148,%eax
  802c7d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c80:	89 50 04             	mov    %edx,0x4(%eax)
  802c83:	eb 08                	jmp    802c8d <insert_sorted_with_merge_freeList+0x45f>
  802c85:	8b 45 08             	mov    0x8(%ebp),%eax
  802c88:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c90:	a3 48 41 80 00       	mov    %eax,0x804148
  802c95:	8b 45 08             	mov    0x8(%ebp),%eax
  802c98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9f:	a1 54 41 80 00       	mov    0x804154,%eax
  802ca4:	40                   	inc    %eax
  802ca5:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802caa:	e9 d8 02 00 00       	jmp    802f87 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	8b 50 08             	mov    0x8(%eax),%edx
  802cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbb:	01 c2                	add    %eax,%edx
  802cbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc0:	8b 40 08             	mov    0x8(%eax),%eax
  802cc3:	39 c2                	cmp    %eax,%edx
  802cc5:	0f 85 ba 00 00 00    	jne    802d85 <insert_sorted_with_merge_freeList+0x557>
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	8b 50 08             	mov    0x8(%eax),%edx
  802cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd4:	8b 48 08             	mov    0x8(%eax),%ecx
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 40 0c             	mov    0xc(%eax),%eax
  802cdd:	01 c8                	add    %ecx,%eax
  802cdf:	39 c2                	cmp    %eax,%edx
  802ce1:	0f 86 9e 00 00 00    	jbe    802d85 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802ce7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cea:	8b 50 0c             	mov    0xc(%eax),%edx
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf3:	01 c2                	add    %eax,%edx
  802cf5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf8:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	8b 50 08             	mov    0x8(%eax),%edx
  802d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d04:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802d07:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	8b 50 08             	mov    0x8(%eax),%edx
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d21:	75 17                	jne    802d3a <insert_sorted_with_merge_freeList+0x50c>
  802d23:	83 ec 04             	sub    $0x4,%esp
  802d26:	68 b0 3a 80 00       	push   $0x803ab0
  802d2b:	68 5b 01 00 00       	push   $0x15b
  802d30:	68 d3 3a 80 00       	push   $0x803ad3
  802d35:	e8 48 d5 ff ff       	call   800282 <_panic>
  802d3a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	89 10                	mov    %edx,(%eax)
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	85 c0                	test   %eax,%eax
  802d4c:	74 0d                	je     802d5b <insert_sorted_with_merge_freeList+0x52d>
  802d4e:	a1 48 41 80 00       	mov    0x804148,%eax
  802d53:	8b 55 08             	mov    0x8(%ebp),%edx
  802d56:	89 50 04             	mov    %edx,0x4(%eax)
  802d59:	eb 08                	jmp    802d63 <insert_sorted_with_merge_freeList+0x535>
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	a3 48 41 80 00       	mov    %eax,0x804148
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d75:	a1 54 41 80 00       	mov    0x804154,%eax
  802d7a:	40                   	inc    %eax
  802d7b:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802d80:	e9 02 02 00 00       	jmp    802f87 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	8b 50 08             	mov    0x8(%eax),%edx
  802d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d91:	01 c2                	add    %eax,%edx
  802d93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d96:	8b 40 08             	mov    0x8(%eax),%eax
  802d99:	39 c2                	cmp    %eax,%edx
  802d9b:	0f 85 ae 01 00 00    	jne    802f4f <insert_sorted_with_merge_freeList+0x721>
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	8b 50 08             	mov    0x8(%eax),%edx
  802da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daa:	8b 48 08             	mov    0x8(%eax),%ecx
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	8b 40 0c             	mov    0xc(%eax),%eax
  802db3:	01 c8                	add    %ecx,%eax
  802db5:	39 c2                	cmp    %eax,%edx
  802db7:	0f 85 92 01 00 00    	jne    802f4f <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc9:	01 c2                	add    %eax,%edx
  802dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dce:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd1:	01 c2                	add    %eax,%edx
  802dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd6:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	8b 50 08             	mov    0x8(%eax),%edx
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802def:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802df9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfc:	8b 50 08             	mov    0x8(%eax),%edx
  802dff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e02:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802e05:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e09:	75 17                	jne    802e22 <insert_sorted_with_merge_freeList+0x5f4>
  802e0b:	83 ec 04             	sub    $0x4,%esp
  802e0e:	68 7b 3b 80 00       	push   $0x803b7b
  802e13:	68 63 01 00 00       	push   $0x163
  802e18:	68 d3 3a 80 00       	push   $0x803ad3
  802e1d:	e8 60 d4 ff ff       	call   800282 <_panic>
  802e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	85 c0                	test   %eax,%eax
  802e29:	74 10                	je     802e3b <insert_sorted_with_merge_freeList+0x60d>
  802e2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2e:	8b 00                	mov    (%eax),%eax
  802e30:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e33:	8b 52 04             	mov    0x4(%edx),%edx
  802e36:	89 50 04             	mov    %edx,0x4(%eax)
  802e39:	eb 0b                	jmp    802e46 <insert_sorted_with_merge_freeList+0x618>
  802e3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3e:	8b 40 04             	mov    0x4(%eax),%eax
  802e41:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e49:	8b 40 04             	mov    0x4(%eax),%eax
  802e4c:	85 c0                	test   %eax,%eax
  802e4e:	74 0f                	je     802e5f <insert_sorted_with_merge_freeList+0x631>
  802e50:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e53:	8b 40 04             	mov    0x4(%eax),%eax
  802e56:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e59:	8b 12                	mov    (%edx),%edx
  802e5b:	89 10                	mov    %edx,(%eax)
  802e5d:	eb 0a                	jmp    802e69 <insert_sorted_with_merge_freeList+0x63b>
  802e5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e62:	8b 00                	mov    (%eax),%eax
  802e64:	a3 38 41 80 00       	mov    %eax,0x804138
  802e69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e6c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e7c:	a1 44 41 80 00       	mov    0x804144,%eax
  802e81:	48                   	dec    %eax
  802e82:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802e87:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e8b:	75 17                	jne    802ea4 <insert_sorted_with_merge_freeList+0x676>
  802e8d:	83 ec 04             	sub    $0x4,%esp
  802e90:	68 b0 3a 80 00       	push   $0x803ab0
  802e95:	68 64 01 00 00       	push   $0x164
  802e9a:	68 d3 3a 80 00       	push   $0x803ad3
  802e9f:	e8 de d3 ff ff       	call   800282 <_panic>
  802ea4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eaa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ead:	89 10                	mov    %edx,(%eax)
  802eaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb2:	8b 00                	mov    (%eax),%eax
  802eb4:	85 c0                	test   %eax,%eax
  802eb6:	74 0d                	je     802ec5 <insert_sorted_with_merge_freeList+0x697>
  802eb8:	a1 48 41 80 00       	mov    0x804148,%eax
  802ebd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ec0:	89 50 04             	mov    %edx,0x4(%eax)
  802ec3:	eb 08                	jmp    802ecd <insert_sorted_with_merge_freeList+0x69f>
  802ec5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ecd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed0:	a3 48 41 80 00       	mov    %eax,0x804148
  802ed5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802edf:	a1 54 41 80 00       	mov    0x804154,%eax
  802ee4:	40                   	inc    %eax
  802ee5:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802eea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eee:	75 17                	jne    802f07 <insert_sorted_with_merge_freeList+0x6d9>
  802ef0:	83 ec 04             	sub    $0x4,%esp
  802ef3:	68 b0 3a 80 00       	push   $0x803ab0
  802ef8:	68 65 01 00 00       	push   $0x165
  802efd:	68 d3 3a 80 00       	push   $0x803ad3
  802f02:	e8 7b d3 ff ff       	call   800282 <_panic>
  802f07:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	89 10                	mov    %edx,(%eax)
  802f12:	8b 45 08             	mov    0x8(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	85 c0                	test   %eax,%eax
  802f19:	74 0d                	je     802f28 <insert_sorted_with_merge_freeList+0x6fa>
  802f1b:	a1 48 41 80 00       	mov    0x804148,%eax
  802f20:	8b 55 08             	mov    0x8(%ebp),%edx
  802f23:	89 50 04             	mov    %edx,0x4(%eax)
  802f26:	eb 08                	jmp    802f30 <insert_sorted_with_merge_freeList+0x702>
  802f28:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f30:	8b 45 08             	mov    0x8(%ebp),%eax
  802f33:	a3 48 41 80 00       	mov    %eax,0x804148
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f42:	a1 54 41 80 00       	mov    0x804154,%eax
  802f47:	40                   	inc    %eax
  802f48:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802f4d:	eb 38                	jmp    802f87 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f4f:	a1 40 41 80 00       	mov    0x804140,%eax
  802f54:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f57:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f5b:	74 07                	je     802f64 <insert_sorted_with_merge_freeList+0x736>
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	8b 00                	mov    (%eax),%eax
  802f62:	eb 05                	jmp    802f69 <insert_sorted_with_merge_freeList+0x73b>
  802f64:	b8 00 00 00 00       	mov    $0x0,%eax
  802f69:	a3 40 41 80 00       	mov    %eax,0x804140
  802f6e:	a1 40 41 80 00       	mov    0x804140,%eax
  802f73:	85 c0                	test   %eax,%eax
  802f75:	0f 85 a7 fb ff ff    	jne    802b22 <insert_sorted_with_merge_freeList+0x2f4>
  802f7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7f:	0f 85 9d fb ff ff    	jne    802b22 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802f85:	eb 00                	jmp    802f87 <insert_sorted_with_merge_freeList+0x759>
  802f87:	90                   	nop
  802f88:	c9                   	leave  
  802f89:	c3                   	ret    
  802f8a:	66 90                	xchg   %ax,%ax

00802f8c <__udivdi3>:
  802f8c:	55                   	push   %ebp
  802f8d:	57                   	push   %edi
  802f8e:	56                   	push   %esi
  802f8f:	53                   	push   %ebx
  802f90:	83 ec 1c             	sub    $0x1c,%esp
  802f93:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f97:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802fa3:	89 ca                	mov    %ecx,%edx
  802fa5:	89 f8                	mov    %edi,%eax
  802fa7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802fab:	85 f6                	test   %esi,%esi
  802fad:	75 2d                	jne    802fdc <__udivdi3+0x50>
  802faf:	39 cf                	cmp    %ecx,%edi
  802fb1:	77 65                	ja     803018 <__udivdi3+0x8c>
  802fb3:	89 fd                	mov    %edi,%ebp
  802fb5:	85 ff                	test   %edi,%edi
  802fb7:	75 0b                	jne    802fc4 <__udivdi3+0x38>
  802fb9:	b8 01 00 00 00       	mov    $0x1,%eax
  802fbe:	31 d2                	xor    %edx,%edx
  802fc0:	f7 f7                	div    %edi
  802fc2:	89 c5                	mov    %eax,%ebp
  802fc4:	31 d2                	xor    %edx,%edx
  802fc6:	89 c8                	mov    %ecx,%eax
  802fc8:	f7 f5                	div    %ebp
  802fca:	89 c1                	mov    %eax,%ecx
  802fcc:	89 d8                	mov    %ebx,%eax
  802fce:	f7 f5                	div    %ebp
  802fd0:	89 cf                	mov    %ecx,%edi
  802fd2:	89 fa                	mov    %edi,%edx
  802fd4:	83 c4 1c             	add    $0x1c,%esp
  802fd7:	5b                   	pop    %ebx
  802fd8:	5e                   	pop    %esi
  802fd9:	5f                   	pop    %edi
  802fda:	5d                   	pop    %ebp
  802fdb:	c3                   	ret    
  802fdc:	39 ce                	cmp    %ecx,%esi
  802fde:	77 28                	ja     803008 <__udivdi3+0x7c>
  802fe0:	0f bd fe             	bsr    %esi,%edi
  802fe3:	83 f7 1f             	xor    $0x1f,%edi
  802fe6:	75 40                	jne    803028 <__udivdi3+0x9c>
  802fe8:	39 ce                	cmp    %ecx,%esi
  802fea:	72 0a                	jb     802ff6 <__udivdi3+0x6a>
  802fec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802ff0:	0f 87 9e 00 00 00    	ja     803094 <__udivdi3+0x108>
  802ff6:	b8 01 00 00 00       	mov    $0x1,%eax
  802ffb:	89 fa                	mov    %edi,%edx
  802ffd:	83 c4 1c             	add    $0x1c,%esp
  803000:	5b                   	pop    %ebx
  803001:	5e                   	pop    %esi
  803002:	5f                   	pop    %edi
  803003:	5d                   	pop    %ebp
  803004:	c3                   	ret    
  803005:	8d 76 00             	lea    0x0(%esi),%esi
  803008:	31 ff                	xor    %edi,%edi
  80300a:	31 c0                	xor    %eax,%eax
  80300c:	89 fa                	mov    %edi,%edx
  80300e:	83 c4 1c             	add    $0x1c,%esp
  803011:	5b                   	pop    %ebx
  803012:	5e                   	pop    %esi
  803013:	5f                   	pop    %edi
  803014:	5d                   	pop    %ebp
  803015:	c3                   	ret    
  803016:	66 90                	xchg   %ax,%ax
  803018:	89 d8                	mov    %ebx,%eax
  80301a:	f7 f7                	div    %edi
  80301c:	31 ff                	xor    %edi,%edi
  80301e:	89 fa                	mov    %edi,%edx
  803020:	83 c4 1c             	add    $0x1c,%esp
  803023:	5b                   	pop    %ebx
  803024:	5e                   	pop    %esi
  803025:	5f                   	pop    %edi
  803026:	5d                   	pop    %ebp
  803027:	c3                   	ret    
  803028:	bd 20 00 00 00       	mov    $0x20,%ebp
  80302d:	89 eb                	mov    %ebp,%ebx
  80302f:	29 fb                	sub    %edi,%ebx
  803031:	89 f9                	mov    %edi,%ecx
  803033:	d3 e6                	shl    %cl,%esi
  803035:	89 c5                	mov    %eax,%ebp
  803037:	88 d9                	mov    %bl,%cl
  803039:	d3 ed                	shr    %cl,%ebp
  80303b:	89 e9                	mov    %ebp,%ecx
  80303d:	09 f1                	or     %esi,%ecx
  80303f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803043:	89 f9                	mov    %edi,%ecx
  803045:	d3 e0                	shl    %cl,%eax
  803047:	89 c5                	mov    %eax,%ebp
  803049:	89 d6                	mov    %edx,%esi
  80304b:	88 d9                	mov    %bl,%cl
  80304d:	d3 ee                	shr    %cl,%esi
  80304f:	89 f9                	mov    %edi,%ecx
  803051:	d3 e2                	shl    %cl,%edx
  803053:	8b 44 24 08          	mov    0x8(%esp),%eax
  803057:	88 d9                	mov    %bl,%cl
  803059:	d3 e8                	shr    %cl,%eax
  80305b:	09 c2                	or     %eax,%edx
  80305d:	89 d0                	mov    %edx,%eax
  80305f:	89 f2                	mov    %esi,%edx
  803061:	f7 74 24 0c          	divl   0xc(%esp)
  803065:	89 d6                	mov    %edx,%esi
  803067:	89 c3                	mov    %eax,%ebx
  803069:	f7 e5                	mul    %ebp
  80306b:	39 d6                	cmp    %edx,%esi
  80306d:	72 19                	jb     803088 <__udivdi3+0xfc>
  80306f:	74 0b                	je     80307c <__udivdi3+0xf0>
  803071:	89 d8                	mov    %ebx,%eax
  803073:	31 ff                	xor    %edi,%edi
  803075:	e9 58 ff ff ff       	jmp    802fd2 <__udivdi3+0x46>
  80307a:	66 90                	xchg   %ax,%ax
  80307c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803080:	89 f9                	mov    %edi,%ecx
  803082:	d3 e2                	shl    %cl,%edx
  803084:	39 c2                	cmp    %eax,%edx
  803086:	73 e9                	jae    803071 <__udivdi3+0xe5>
  803088:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80308b:	31 ff                	xor    %edi,%edi
  80308d:	e9 40 ff ff ff       	jmp    802fd2 <__udivdi3+0x46>
  803092:	66 90                	xchg   %ax,%ax
  803094:	31 c0                	xor    %eax,%eax
  803096:	e9 37 ff ff ff       	jmp    802fd2 <__udivdi3+0x46>
  80309b:	90                   	nop

0080309c <__umoddi3>:
  80309c:	55                   	push   %ebp
  80309d:	57                   	push   %edi
  80309e:	56                   	push   %esi
  80309f:	53                   	push   %ebx
  8030a0:	83 ec 1c             	sub    $0x1c,%esp
  8030a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8030a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8030ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030bb:	89 f3                	mov    %esi,%ebx
  8030bd:	89 fa                	mov    %edi,%edx
  8030bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030c3:	89 34 24             	mov    %esi,(%esp)
  8030c6:	85 c0                	test   %eax,%eax
  8030c8:	75 1a                	jne    8030e4 <__umoddi3+0x48>
  8030ca:	39 f7                	cmp    %esi,%edi
  8030cc:	0f 86 a2 00 00 00    	jbe    803174 <__umoddi3+0xd8>
  8030d2:	89 c8                	mov    %ecx,%eax
  8030d4:	89 f2                	mov    %esi,%edx
  8030d6:	f7 f7                	div    %edi
  8030d8:	89 d0                	mov    %edx,%eax
  8030da:	31 d2                	xor    %edx,%edx
  8030dc:	83 c4 1c             	add    $0x1c,%esp
  8030df:	5b                   	pop    %ebx
  8030e0:	5e                   	pop    %esi
  8030e1:	5f                   	pop    %edi
  8030e2:	5d                   	pop    %ebp
  8030e3:	c3                   	ret    
  8030e4:	39 f0                	cmp    %esi,%eax
  8030e6:	0f 87 ac 00 00 00    	ja     803198 <__umoddi3+0xfc>
  8030ec:	0f bd e8             	bsr    %eax,%ebp
  8030ef:	83 f5 1f             	xor    $0x1f,%ebp
  8030f2:	0f 84 ac 00 00 00    	je     8031a4 <__umoddi3+0x108>
  8030f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8030fd:	29 ef                	sub    %ebp,%edi
  8030ff:	89 fe                	mov    %edi,%esi
  803101:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803105:	89 e9                	mov    %ebp,%ecx
  803107:	d3 e0                	shl    %cl,%eax
  803109:	89 d7                	mov    %edx,%edi
  80310b:	89 f1                	mov    %esi,%ecx
  80310d:	d3 ef                	shr    %cl,%edi
  80310f:	09 c7                	or     %eax,%edi
  803111:	89 e9                	mov    %ebp,%ecx
  803113:	d3 e2                	shl    %cl,%edx
  803115:	89 14 24             	mov    %edx,(%esp)
  803118:	89 d8                	mov    %ebx,%eax
  80311a:	d3 e0                	shl    %cl,%eax
  80311c:	89 c2                	mov    %eax,%edx
  80311e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803122:	d3 e0                	shl    %cl,%eax
  803124:	89 44 24 04          	mov    %eax,0x4(%esp)
  803128:	8b 44 24 08          	mov    0x8(%esp),%eax
  80312c:	89 f1                	mov    %esi,%ecx
  80312e:	d3 e8                	shr    %cl,%eax
  803130:	09 d0                	or     %edx,%eax
  803132:	d3 eb                	shr    %cl,%ebx
  803134:	89 da                	mov    %ebx,%edx
  803136:	f7 f7                	div    %edi
  803138:	89 d3                	mov    %edx,%ebx
  80313a:	f7 24 24             	mull   (%esp)
  80313d:	89 c6                	mov    %eax,%esi
  80313f:	89 d1                	mov    %edx,%ecx
  803141:	39 d3                	cmp    %edx,%ebx
  803143:	0f 82 87 00 00 00    	jb     8031d0 <__umoddi3+0x134>
  803149:	0f 84 91 00 00 00    	je     8031e0 <__umoddi3+0x144>
  80314f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803153:	29 f2                	sub    %esi,%edx
  803155:	19 cb                	sbb    %ecx,%ebx
  803157:	89 d8                	mov    %ebx,%eax
  803159:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80315d:	d3 e0                	shl    %cl,%eax
  80315f:	89 e9                	mov    %ebp,%ecx
  803161:	d3 ea                	shr    %cl,%edx
  803163:	09 d0                	or     %edx,%eax
  803165:	89 e9                	mov    %ebp,%ecx
  803167:	d3 eb                	shr    %cl,%ebx
  803169:	89 da                	mov    %ebx,%edx
  80316b:	83 c4 1c             	add    $0x1c,%esp
  80316e:	5b                   	pop    %ebx
  80316f:	5e                   	pop    %esi
  803170:	5f                   	pop    %edi
  803171:	5d                   	pop    %ebp
  803172:	c3                   	ret    
  803173:	90                   	nop
  803174:	89 fd                	mov    %edi,%ebp
  803176:	85 ff                	test   %edi,%edi
  803178:	75 0b                	jne    803185 <__umoddi3+0xe9>
  80317a:	b8 01 00 00 00       	mov    $0x1,%eax
  80317f:	31 d2                	xor    %edx,%edx
  803181:	f7 f7                	div    %edi
  803183:	89 c5                	mov    %eax,%ebp
  803185:	89 f0                	mov    %esi,%eax
  803187:	31 d2                	xor    %edx,%edx
  803189:	f7 f5                	div    %ebp
  80318b:	89 c8                	mov    %ecx,%eax
  80318d:	f7 f5                	div    %ebp
  80318f:	89 d0                	mov    %edx,%eax
  803191:	e9 44 ff ff ff       	jmp    8030da <__umoddi3+0x3e>
  803196:	66 90                	xchg   %ax,%ax
  803198:	89 c8                	mov    %ecx,%eax
  80319a:	89 f2                	mov    %esi,%edx
  80319c:	83 c4 1c             	add    $0x1c,%esp
  80319f:	5b                   	pop    %ebx
  8031a0:	5e                   	pop    %esi
  8031a1:	5f                   	pop    %edi
  8031a2:	5d                   	pop    %ebp
  8031a3:	c3                   	ret    
  8031a4:	3b 04 24             	cmp    (%esp),%eax
  8031a7:	72 06                	jb     8031af <__umoddi3+0x113>
  8031a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8031ad:	77 0f                	ja     8031be <__umoddi3+0x122>
  8031af:	89 f2                	mov    %esi,%edx
  8031b1:	29 f9                	sub    %edi,%ecx
  8031b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031b7:	89 14 24             	mov    %edx,(%esp)
  8031ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031c2:	8b 14 24             	mov    (%esp),%edx
  8031c5:	83 c4 1c             	add    $0x1c,%esp
  8031c8:	5b                   	pop    %ebx
  8031c9:	5e                   	pop    %esi
  8031ca:	5f                   	pop    %edi
  8031cb:	5d                   	pop    %ebp
  8031cc:	c3                   	ret    
  8031cd:	8d 76 00             	lea    0x0(%esi),%esi
  8031d0:	2b 04 24             	sub    (%esp),%eax
  8031d3:	19 fa                	sbb    %edi,%edx
  8031d5:	89 d1                	mov    %edx,%ecx
  8031d7:	89 c6                	mov    %eax,%esi
  8031d9:	e9 71 ff ff ff       	jmp    80314f <__umoddi3+0xb3>
  8031de:	66 90                	xchg   %ax,%ax
  8031e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031e4:	72 ea                	jb     8031d0 <__umoddi3+0x134>
  8031e6:	89 d9                	mov    %ebx,%ecx
  8031e8:	e9 62 ff ff ff       	jmp    80314f <__umoddi3+0xb3>
