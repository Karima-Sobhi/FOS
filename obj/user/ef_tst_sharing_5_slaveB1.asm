
obj/user/ef_tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 05 01 00 00       	call   80013b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 40 80 00       	mov    0x804020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 40 80 00       	mov    0x804020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 a0 32 80 00       	push   $0x8032a0
  800091:	6a 12                	push   $0x12
  800093:	68 bc 32 80 00       	push   $0x8032bc
  800098:	e8 da 01 00 00       	call   800277 <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 dc 1a 00 00       	call   801b7e <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 dc 32 80 00       	push   $0x8032dc
  8000aa:	50                   	push   %eax
  8000ab:	e8 9f 15 00 00       	call   80164f <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 e0 32 80 00       	push   $0x8032e0
  8000be:	e8 68 04 00 00       	call   80052b <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 08 33 80 00       	push   $0x803308
  8000ce:	e8 58 04 00 00       	call   80052b <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 70 17 00 00       	push   $0x1770
  8000de:	e8 9c 2e 00 00       	call   802f7f <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 9a 17 00 00       	call   801885 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 2c 16 00 00       	call   801725 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 28 33 80 00       	push   $0x803328
  800104:	e8 22 04 00 00       	call   80052b <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  80010c:	e8 74 17 00 00       	call   801885 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 40 33 80 00       	push   $0x803340
  800127:	6a 20                	push   $0x20
  800129:	68 bc 32 80 00       	push   $0x8032bc
  80012e:	e8 44 01 00 00       	call   800277 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800133:	e8 6b 1b 00 00       	call   801ca3 <inctst>
	return;
  800138:	90                   	nop
}
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800141:	e8 1f 1a 00 00       	call   801b65 <sys_getenvindex>
  800146:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	c1 e0 03             	shl    $0x3,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	01 c0                	add    %eax,%eax
  800155:	01 d0                	add    %edx,%eax
  800157:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015e:	01 d0                	add    %edx,%eax
  800160:	c1 e0 04             	shl    $0x4,%eax
  800163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800168:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016d:	a1 20 40 80 00       	mov    0x804020,%eax
  800172:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800178:	84 c0                	test   %al,%al
  80017a:	74 0f                	je     80018b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80017c:	a1 20 40 80 00       	mov    0x804020,%eax
  800181:	05 5c 05 00 00       	add    $0x55c,%eax
  800186:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018f:	7e 0a                	jle    80019b <libmain+0x60>
		binaryname = argv[0];
  800191:	8b 45 0c             	mov    0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	ff 75 0c             	pushl  0xc(%ebp)
  8001a1:	ff 75 08             	pushl  0x8(%ebp)
  8001a4:	e8 8f fe ff ff       	call   800038 <_main>
  8001a9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ac:	e8 c1 17 00 00       	call   801972 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 00 34 80 00       	push   $0x803400
  8001b9:	e8 6d 03 00 00       	call   80052b <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	52                   	push   %edx
  8001db:	50                   	push   %eax
  8001dc:	68 28 34 80 00       	push   $0x803428
  8001e1:	e8 45 03 00 00       	call   80052b <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ee:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80020a:	51                   	push   %ecx
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 50 34 80 00       	push   $0x803450
  800212:	e8 14 03 00 00       	call   80052b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 a8 34 80 00       	push   $0x8034a8
  80022e:	e8 f8 02 00 00       	call   80052b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 00 34 80 00       	push   $0x803400
  80023e:	e8 e8 02 00 00       	call   80052b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800246:	e8 41 17 00 00       	call   80198c <sys_enable_interrupt>

	// exit gracefully
	exit();
  80024b:	e8 19 00 00 00       	call   800269 <exit>
}
  800250:	90                   	nop
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	6a 00                	push   $0x0
  80025e:	e8 ce 18 00 00       	call   801b31 <sys_destroy_env>
  800263:	83 c4 10             	add    $0x10,%esp
}
  800266:	90                   	nop
  800267:	c9                   	leave  
  800268:	c3                   	ret    

00800269 <exit>:

void
exit(void)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026f:	e8 23 19 00 00       	call   801b97 <sys_exit_env>
}
  800274:	90                   	nop
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80027d:	8d 45 10             	lea    0x10(%ebp),%eax
  800280:	83 c0 04             	add    $0x4,%eax
  800283:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800286:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028b:	85 c0                	test   %eax,%eax
  80028d:	74 16                	je     8002a5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80028f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	50                   	push   %eax
  800298:	68 bc 34 80 00       	push   $0x8034bc
  80029d:	e8 89 02 00 00       	call   80052b <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a5:	a1 00 40 80 00       	mov    0x804000,%eax
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	50                   	push   %eax
  8002b1:	68 c1 34 80 00       	push   $0x8034c1
  8002b6:	e8 70 02 00 00       	call   80052b <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002be:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c7:	50                   	push   %eax
  8002c8:	e8 f3 01 00 00       	call   8004c0 <vcprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	6a 00                	push   $0x0
  8002d5:	68 dd 34 80 00       	push   $0x8034dd
  8002da:	e8 e1 01 00 00       	call   8004c0 <vcprintf>
  8002df:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e2:	e8 82 ff ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  8002e7:	eb fe                	jmp    8002e7 <_panic+0x70>

008002e9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f4:	8b 50 74             	mov    0x74(%eax),%edx
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 e0 34 80 00       	push   $0x8034e0
  800306:	6a 26                	push   $0x26
  800308:	68 2c 35 80 00       	push   $0x80352c
  80030d:	e8 65 ff ff ff       	call   800277 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800319:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800320:	e9 c2 00 00 00       	jmp    8003e7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	75 08                	jne    800342 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80033a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80033d:	e9 a2 00 00 00       	jmp    8003e4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800342:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800349:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800350:	eb 69                	jmp    8003bb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800352:	a1 20 40 80 00       	mov    0x804020,%eax
  800357:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80035d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800360:	89 d0                	mov    %edx,%eax
  800362:	01 c0                	add    %eax,%eax
  800364:	01 d0                	add    %edx,%eax
  800366:	c1 e0 03             	shl    $0x3,%eax
  800369:	01 c8                	add    %ecx,%eax
  80036b:	8a 40 04             	mov    0x4(%eax),%al
  80036e:	84 c0                	test   %al,%al
  800370:	75 46                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800372:	a1 20 40 80 00       	mov    0x804020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800390:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 c8                	add    %ecx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	75 09                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003af:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b6:	eb 12                	jmp    8003ca <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b8:	ff 45 e8             	incl   -0x18(%ebp)
  8003bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c0:	8b 50 74             	mov    0x74(%eax),%edx
  8003c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c6:	39 c2                	cmp    %eax,%edx
  8003c8:	77 88                	ja     800352 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ce:	75 14                	jne    8003e4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d0:	83 ec 04             	sub    $0x4,%esp
  8003d3:	68 38 35 80 00       	push   $0x803538
  8003d8:	6a 3a                	push   $0x3a
  8003da:	68 2c 35 80 00       	push   $0x80352c
  8003df:	e8 93 fe ff ff       	call   800277 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e4:	ff 45 f0             	incl   -0x10(%ebp)
  8003e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003ed:	0f 8c 32 ff ff ff    	jl     800325 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800401:	eb 26                	jmp    800429 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800403:	a1 20 40 80 00       	mov    0x804020,%eax
  800408:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800411:	89 d0                	mov    %edx,%eax
  800413:	01 c0                	add    %eax,%eax
  800415:	01 d0                	add    %edx,%eax
  800417:	c1 e0 03             	shl    $0x3,%eax
  80041a:	01 c8                	add    %ecx,%eax
  80041c:	8a 40 04             	mov    0x4(%eax),%al
  80041f:	3c 01                	cmp    $0x1,%al
  800421:	75 03                	jne    800426 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800423:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800426:	ff 45 e0             	incl   -0x20(%ebp)
  800429:	a1 20 40 80 00       	mov    0x804020,%eax
  80042e:	8b 50 74             	mov    0x74(%eax),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	39 c2                	cmp    %eax,%edx
  800436:	77 cb                	ja     800403 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80043e:	74 14                	je     800454 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 8c 35 80 00       	push   $0x80358c
  800448:	6a 44                	push   $0x44
  80044a:	68 2c 35 80 00       	push   $0x80352c
  80044f:	e8 23 fe ff ff       	call   800277 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800454:	90                   	nop
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	8d 48 01             	lea    0x1(%eax),%ecx
  800465:	8b 55 0c             	mov    0xc(%ebp),%edx
  800468:	89 0a                	mov    %ecx,(%edx)
  80046a:	8b 55 08             	mov    0x8(%ebp),%edx
  80046d:	88 d1                	mov    %dl,%cl
  80046f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800472:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800480:	75 2c                	jne    8004ae <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800482:	a0 24 40 80 00       	mov    0x804024,%al
  800487:	0f b6 c0             	movzbl %al,%eax
  80048a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048d:	8b 12                	mov    (%edx),%edx
  80048f:	89 d1                	mov    %edx,%ecx
  800491:	8b 55 0c             	mov    0xc(%ebp),%edx
  800494:	83 c2 08             	add    $0x8,%edx
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	50                   	push   %eax
  80049b:	51                   	push   %ecx
  80049c:	52                   	push   %edx
  80049d:	e8 22 13 00 00       	call   8017c4 <sys_cputs>
  8004a2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b1:	8b 40 04             	mov    0x4(%eax),%eax
  8004b4:	8d 50 01             	lea    0x1(%eax),%edx
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004bd:	90                   	nop
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d0:	00 00 00 
	b.cnt = 0;
  8004d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004da:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	ff 75 08             	pushl  0x8(%ebp)
  8004e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e9:	50                   	push   %eax
  8004ea:	68 57 04 80 00       	push   $0x800457
  8004ef:	e8 11 02 00 00       	call   800705 <vprintfmt>
  8004f4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f7:	a0 24 40 80 00       	mov    0x804024,%al
  8004fc:	0f b6 c0             	movzbl %al,%eax
  8004ff:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	50                   	push   %eax
  800509:	52                   	push   %edx
  80050a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800510:	83 c0 08             	add    $0x8,%eax
  800513:	50                   	push   %eax
  800514:	e8 ab 12 00 00       	call   8017c4 <sys_cputs>
  800519:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80051c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800523:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800529:	c9                   	leave  
  80052a:	c3                   	ret    

0080052b <cprintf>:

int cprintf(const char *fmt, ...) {
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800531:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800538:	8d 45 0c             	lea    0xc(%ebp),%eax
  80053b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 f4             	pushl  -0xc(%ebp)
  800547:	50                   	push   %eax
  800548:	e8 73 ff ff ff       	call   8004c0 <vcprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800553:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800556:	c9                   	leave  
  800557:	c3                   	ret    

00800558 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800558:	55                   	push   %ebp
  800559:	89 e5                	mov    %esp,%ebp
  80055b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80055e:	e8 0f 14 00 00       	call   801972 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800563:	8d 45 0c             	lea    0xc(%ebp),%eax
  800566:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	ff 75 f4             	pushl  -0xc(%ebp)
  800572:	50                   	push   %eax
  800573:	e8 48 ff ff ff       	call   8004c0 <vcprintf>
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80057e:	e8 09 14 00 00       	call   80198c <sys_enable_interrupt>
	return cnt;
  800583:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800586:	c9                   	leave  
  800587:	c3                   	ret    

00800588 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	53                   	push   %ebx
  80058c:	83 ec 14             	sub    $0x14,%esp
  80058f:	8b 45 10             	mov    0x10(%ebp),%eax
  800592:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059b:	8b 45 18             	mov    0x18(%ebp),%eax
  80059e:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a6:	77 55                	ja     8005fd <printnum+0x75>
  8005a8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ab:	72 05                	jb     8005b2 <printnum+0x2a>
  8005ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b0:	77 4b                	ja     8005fd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c0:	52                   	push   %edx
  8005c1:	50                   	push   %eax
  8005c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c8:	e8 67 2a 00 00       	call   803034 <__udivdi3>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	ff 75 20             	pushl  0x20(%ebp)
  8005d6:	53                   	push   %ebx
  8005d7:	ff 75 18             	pushl  0x18(%ebp)
  8005da:	52                   	push   %edx
  8005db:	50                   	push   %eax
  8005dc:	ff 75 0c             	pushl  0xc(%ebp)
  8005df:	ff 75 08             	pushl  0x8(%ebp)
  8005e2:	e8 a1 ff ff ff       	call   800588 <printnum>
  8005e7:	83 c4 20             	add    $0x20,%esp
  8005ea:	eb 1a                	jmp    800606 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 20             	pushl  0x20(%ebp)
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	ff d0                	call   *%eax
  8005fa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fd:	ff 4d 1c             	decl   0x1c(%ebp)
  800600:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800604:	7f e6                	jg     8005ec <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800606:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800609:	bb 00 00 00 00       	mov    $0x0,%ebx
  80060e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800614:	53                   	push   %ebx
  800615:	51                   	push   %ecx
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	e8 27 2b 00 00       	call   803144 <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 f4 37 80 00       	add    $0x8037f4,%eax
  800625:	8a 00                	mov    (%eax),%al
  800627:	0f be c0             	movsbl %al,%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	ff d0                	call   *%eax
  800636:	83 c4 10             	add    $0x10,%esp
}
  800639:	90                   	nop
  80063a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800642:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800646:	7e 1c                	jle    800664 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 50 08             	lea    0x8(%eax),%edx
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	89 10                	mov    %edx,(%eax)
  800655:	8b 45 08             	mov    0x8(%ebp),%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	83 e8 08             	sub    $0x8,%eax
  80065d:	8b 50 04             	mov    0x4(%eax),%edx
  800660:	8b 00                	mov    (%eax),%eax
  800662:	eb 40                	jmp    8006a4 <getuint+0x65>
	else if (lflag)
  800664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800668:	74 1e                	je     800688 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	8d 50 04             	lea    0x4(%eax),%edx
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	89 10                	mov    %edx,(%eax)
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	83 e8 04             	sub    $0x4,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
  800686:	eb 1c                	jmp    8006a4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	8d 50 04             	lea    0x4(%eax),%edx
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	89 10                	mov    %edx,(%eax)
  800695:	8b 45 08             	mov    0x8(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	83 e8 04             	sub    $0x4,%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a4:	5d                   	pop    %ebp
  8006a5:	c3                   	ret    

008006a6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ad:	7e 1c                	jle    8006cb <getint+0x25>
		return va_arg(*ap, long long);
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	8d 50 08             	lea    0x8(%eax),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	89 10                	mov    %edx,(%eax)
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	83 e8 08             	sub    $0x8,%eax
  8006c4:	8b 50 04             	mov    0x4(%eax),%edx
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	eb 38                	jmp    800703 <getint+0x5d>
	else if (lflag)
  8006cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006cf:	74 1a                	je     8006eb <getint+0x45>
		return va_arg(*ap, long);
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	8d 50 04             	lea    0x4(%eax),%edx
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	89 10                	mov    %edx,(%eax)
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	83 e8 04             	sub    $0x4,%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	99                   	cltd   
  8006e9:	eb 18                	jmp    800703 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 04             	lea    0x4(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	99                   	cltd   
}
  800703:	5d                   	pop    %ebp
  800704:	c3                   	ret    

00800705 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	56                   	push   %esi
  800709:	53                   	push   %ebx
  80070a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070d:	eb 17                	jmp    800726 <vprintfmt+0x21>
			if (ch == '\0')
  80070f:	85 db                	test   %ebx,%ebx
  800711:	0f 84 af 03 00 00    	je     800ac6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	53                   	push   %ebx
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	ff d0                	call   *%eax
  800723:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	8b 45 10             	mov    0x10(%ebp),%eax
  800729:	8d 50 01             	lea    0x1(%eax),%edx
  80072c:	89 55 10             	mov    %edx,0x10(%ebp)
  80072f:	8a 00                	mov    (%eax),%al
  800731:	0f b6 d8             	movzbl %al,%ebx
  800734:	83 fb 25             	cmp    $0x25,%ebx
  800737:	75 d6                	jne    80070f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800739:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80073d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800744:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800752:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800759:	8b 45 10             	mov    0x10(%ebp),%eax
  80075c:	8d 50 01             	lea    0x1(%eax),%edx
  80075f:	89 55 10             	mov    %edx,0x10(%ebp)
  800762:	8a 00                	mov    (%eax),%al
  800764:	0f b6 d8             	movzbl %al,%ebx
  800767:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80076a:	83 f8 55             	cmp    $0x55,%eax
  80076d:	0f 87 2b 03 00 00    	ja     800a9e <vprintfmt+0x399>
  800773:	8b 04 85 18 38 80 00 	mov    0x803818(,%eax,4),%eax
  80077a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80077c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800780:	eb d7                	jmp    800759 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800782:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800786:	eb d1                	jmp    800759 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800788:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80078f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	c1 e0 02             	shl    $0x2,%eax
  800797:	01 d0                	add    %edx,%eax
  800799:	01 c0                	add    %eax,%eax
  80079b:	01 d8                	add    %ebx,%eax
  80079d:	83 e8 30             	sub    $0x30,%eax
  8007a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a6:	8a 00                	mov    (%eax),%al
  8007a8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ab:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ae:	7e 3e                	jle    8007ee <vprintfmt+0xe9>
  8007b0:	83 fb 39             	cmp    $0x39,%ebx
  8007b3:	7f 39                	jg     8007ee <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b8:	eb d5                	jmp    80078f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	83 c0 04             	add    $0x4,%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	83 e8 04             	sub    $0x4,%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007ce:	eb 1f                	jmp    8007ef <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d4:	79 83                	jns    800759 <vprintfmt+0x54>
				width = 0;
  8007d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007dd:	e9 77 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e9:	e9 6b ff ff ff       	jmp    800759 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007ee:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f3:	0f 89 60 ff ff ff    	jns    800759 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800806:	e9 4e ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80080e:	e9 46 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	83 c0 04             	add    $0x4,%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	50                   	push   %eax
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
			break;
  800833:	e9 89 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 c0 04             	add    $0x4,%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 e8 04             	sub    $0x4,%eax
  800847:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800849:	85 db                	test   %ebx,%ebx
  80084b:	79 02                	jns    80084f <vprintfmt+0x14a>
				err = -err;
  80084d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80084f:	83 fb 64             	cmp    $0x64,%ebx
  800852:	7f 0b                	jg     80085f <vprintfmt+0x15a>
  800854:	8b 34 9d 60 36 80 00 	mov    0x803660(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 05 38 80 00       	push   $0x803805
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	ff 75 08             	pushl  0x8(%ebp)
  80086b:	e8 5e 02 00 00       	call   800ace <printfmt>
  800870:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800873:	e9 49 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800878:	56                   	push   %esi
  800879:	68 0e 38 80 00       	push   $0x80380e
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 45 02 00 00       	call   800ace <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			break;
  80088c:	e9 30 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 c0 04             	add    $0x4,%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 e8 04             	sub    $0x4,%eax
  8008a0:	8b 30                	mov    (%eax),%esi
  8008a2:	85 f6                	test   %esi,%esi
  8008a4:	75 05                	jne    8008ab <vprintfmt+0x1a6>
				p = "(null)";
  8008a6:	be 11 38 80 00       	mov    $0x803811,%esi
			if (width > 0 && padc != '-')
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	7e 6d                	jle    80091e <vprintfmt+0x219>
  8008b1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b5:	74 67                	je     80091e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	56                   	push   %esi
  8008bf:	e8 0c 03 00 00       	call   800bd0 <strnlen>
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ca:	eb 16                	jmp    8008e2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008cc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008df:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	7f e4                	jg     8008cc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e8:	eb 34                	jmp    80091e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008ee:	74 1c                	je     80090c <vprintfmt+0x207>
  8008f0:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f3:	7e 05                	jle    8008fa <vprintfmt+0x1f5>
  8008f5:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f8:	7e 12                	jle    80090c <vprintfmt+0x207>
					putch('?', putdat);
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	6a 3f                	push   $0x3f
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	ff d0                	call   *%eax
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	eb 0f                	jmp    80091b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	53                   	push   %ebx
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	ff d0                	call   *%eax
  800918:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091b:	ff 4d e4             	decl   -0x1c(%ebp)
  80091e:	89 f0                	mov    %esi,%eax
  800920:	8d 70 01             	lea    0x1(%eax),%esi
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
  800928:	85 db                	test   %ebx,%ebx
  80092a:	74 24                	je     800950 <vprintfmt+0x24b>
  80092c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800930:	78 b8                	js     8008ea <vprintfmt+0x1e5>
  800932:	ff 4d e0             	decl   -0x20(%ebp)
  800935:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800939:	79 af                	jns    8008ea <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093b:	eb 13                	jmp    800950 <vprintfmt+0x24b>
				putch(' ', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	6a 20                	push   $0x20
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094d:	ff 4d e4             	decl   -0x1c(%ebp)
  800950:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800954:	7f e7                	jg     80093d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800956:	e9 66 01 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 e8             	pushl  -0x18(%ebp)
  800961:	8d 45 14             	lea    0x14(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	e8 3c fd ff ff       	call   8006a6 <getint>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800970:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800979:	85 d2                	test   %edx,%edx
  80097b:	79 23                	jns    8009a0 <vprintfmt+0x29b>
				putch('-', putdat);
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	6a 2d                	push   $0x2d
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800993:	f7 d8                	neg    %eax
  800995:	83 d2 00             	adc    $0x0,%edx
  800998:	f7 da                	neg    %edx
  80099a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a7:	e9 bc 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b5:	50                   	push   %eax
  8009b6:	e8 84 fc ff ff       	call   80063f <getuint>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009cb:	e9 98 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	6a 58                	push   $0x58
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	ff d0                	call   *%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 58                	push   $0x58
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	6a 58                	push   $0x58
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			break;
  800a00:	e9 bc 00 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	6a 30                	push   $0x30
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	6a 78                	push   $0x78
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	ff d0                	call   *%eax
  800a22:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a40:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a47:	eb 1f                	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a52:	50                   	push   %eax
  800a53:	e8 e7 fb ff ff       	call   80063f <getuint>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a61:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a68:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6f:	83 ec 04             	sub    $0x4,%esp
  800a72:	52                   	push   %edx
  800a73:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a76:	50                   	push   %eax
  800a77:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7a:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	ff 75 08             	pushl  0x8(%ebp)
  800a83:	e8 00 fb ff ff       	call   800588 <printnum>
  800a88:	83 c4 20             	add    $0x20,%esp
			break;
  800a8b:	eb 34                	jmp    800ac1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			break;
  800a9c:	eb 23                	jmp    800ac1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 25                	push   $0x25
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aae:	ff 4d 10             	decl   0x10(%ebp)
  800ab1:	eb 03                	jmp    800ab6 <vprintfmt+0x3b1>
  800ab3:	ff 4d 10             	decl   0x10(%ebp)
  800ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab9:	48                   	dec    %eax
  800aba:	8a 00                	mov    (%eax),%al
  800abc:	3c 25                	cmp    $0x25,%al
  800abe:	75 f3                	jne    800ab3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac0:	90                   	nop
		}
	}
  800ac1:	e9 47 fc ff ff       	jmp    80070d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aca:	5b                   	pop    %ebx
  800acb:	5e                   	pop    %esi
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    

00800ace <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800add:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae3:	50                   	push   %eax
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	ff 75 08             	pushl  0x8(%ebp)
  800aea:	e8 16 fc ff ff       	call   800705 <vprintfmt>
  800aef:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af2:	90                   	nop
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	8b 40 08             	mov    0x8(%eax),%eax
  800afe:	8d 50 01             	lea    0x1(%eax),%edx
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	8b 10                	mov    (%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	8b 40 04             	mov    0x4(%eax),%eax
  800b12:	39 c2                	cmp    %eax,%edx
  800b14:	73 12                	jae    800b28 <sprintputch+0x33>
		*b->buf++ = ch;
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8b 00                	mov    (%eax),%eax
  800b1b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b21:	89 0a                	mov    %ecx,(%edx)
  800b23:	8b 55 08             	mov    0x8(%ebp),%edx
  800b26:	88 10                	mov    %dl,(%eax)
}
  800b28:	90                   	nop
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b50:	74 06                	je     800b58 <vsnprintf+0x2d>
  800b52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b56:	7f 07                	jg     800b5f <vsnprintf+0x34>
		return -E_INVAL;
  800b58:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5d:	eb 20                	jmp    800b7f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5f:	ff 75 14             	pushl  0x14(%ebp)
  800b62:	ff 75 10             	pushl  0x10(%ebp)
  800b65:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b68:	50                   	push   %eax
  800b69:	68 f5 0a 80 00       	push   $0x800af5
  800b6e:	e8 92 fb ff ff       	call   800705 <vprintfmt>
  800b73:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b79:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b87:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8a:	83 c0 04             	add    $0x4,%eax
  800b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	ff 75 f4             	pushl  -0xc(%ebp)
  800b96:	50                   	push   %eax
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	ff 75 08             	pushl  0x8(%ebp)
  800b9d:	e8 89 ff ff ff       	call   800b2b <vsnprintf>
  800ba2:	83 c4 10             	add    $0x10,%esp
  800ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bba:	eb 06                	jmp    800bc2 <strlen+0x15>
		n++;
  800bbc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbf:	ff 45 08             	incl   0x8(%ebp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8a 00                	mov    (%eax),%al
  800bc7:	84 c0                	test   %al,%al
  800bc9:	75 f1                	jne    800bbc <strlen+0xf>
		n++;
	return n;
  800bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bdd:	eb 09                	jmp    800be8 <strnlen+0x18>
		n++;
  800bdf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be2:	ff 45 08             	incl   0x8(%ebp)
  800be5:	ff 4d 0c             	decl   0xc(%ebp)
  800be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bec:	74 09                	je     800bf7 <strnlen+0x27>
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8a 00                	mov    (%eax),%al
  800bf3:	84 c0                	test   %al,%al
  800bf5:	75 e8                	jne    800bdf <strnlen+0xf>
		n++;
	return n;
  800bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c08:	90                   	nop
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8d 50 01             	lea    0x1(%eax),%edx
  800c0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c18:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1b:	8a 12                	mov    (%edx),%dl
  800c1d:	88 10                	mov    %dl,(%eax)
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 e4                	jne    800c09 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3d:	eb 1f                	jmp    800c5e <strncpy+0x34>
		*dst++ = *src;
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8d 50 01             	lea    0x1(%eax),%edx
  800c45:	89 55 08             	mov    %edx,0x8(%ebp)
  800c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4b:	8a 12                	mov    (%edx),%dl
  800c4d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	84 c0                	test   %al,%al
  800c56:	74 03                	je     800c5b <strncpy+0x31>
			src++;
  800c58:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c5b:	ff 45 fc             	incl   -0x4(%ebp)
  800c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c61:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c64:	72 d9                	jb     800c3f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c66:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7b:	74 30                	je     800cad <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c7d:	eb 16                	jmp    800c95 <strlcpy+0x2a>
			*dst++ = *src++;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8d 50 01             	lea    0x1(%eax),%edx
  800c85:	89 55 08             	mov    %edx,0x8(%ebp)
  800c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c95:	ff 4d 10             	decl   0x10(%ebp)
  800c98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9c:	74 09                	je     800ca7 <strlcpy+0x3c>
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	84 c0                	test   %al,%al
  800ca5:	75 d8                	jne    800c7f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cad:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb3:	29 c2                	sub    %eax,%edx
  800cb5:	89 d0                	mov    %edx,%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cbc:	eb 06                	jmp    800cc4 <strcmp+0xb>
		p++, q++;
  800cbe:	ff 45 08             	incl   0x8(%ebp)
  800cc1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	74 0e                	je     800cdb <strcmp+0x22>
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 10                	mov    (%eax),%dl
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	38 c2                	cmp    %al,%dl
  800cd9:	74 e3                	je     800cbe <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	0f b6 d0             	movzbl %al,%edx
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 c0             	movzbl %al,%eax
  800ceb:	29 c2                	sub    %eax,%edx
  800ced:	89 d0                	mov    %edx,%eax
}
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf4:	eb 09                	jmp    800cff <strncmp+0xe>
		n--, p++, q++;
  800cf6:	ff 4d 10             	decl   0x10(%ebp)
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d03:	74 17                	je     800d1c <strncmp+0x2b>
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	84 c0                	test   %al,%al
  800d0c:	74 0e                	je     800d1c <strncmp+0x2b>
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 10                	mov    (%eax),%dl
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	38 c2                	cmp    %al,%dl
  800d1a:	74 da                	je     800cf6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d20:	75 07                	jne    800d29 <strncmp+0x38>
		return 0;
  800d22:	b8 00 00 00 00       	mov    $0x0,%eax
  800d27:	eb 14                	jmp    800d3d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 d0             	movzbl %al,%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 c0             	movzbl %al,%eax
  800d39:	29 c2                	sub    %eax,%edx
  800d3b:	89 d0                	mov    %edx,%eax
}
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4b:	eb 12                	jmp    800d5f <strchr+0x20>
		if (*s == c)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d55:	75 05                	jne    800d5c <strchr+0x1d>
			return (char *) s;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	eb 11                	jmp    800d6d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	75 e5                	jne    800d4d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6d:	c9                   	leave  
  800d6e:	c3                   	ret    

00800d6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 04             	sub    $0x4,%esp
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7b:	eb 0d                	jmp    800d8a <strfind+0x1b>
		if (*s == c)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d85:	74 0e                	je     800d95 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d87:	ff 45 08             	incl   0x8(%ebp)
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	75 ea                	jne    800d7d <strfind+0xe>
  800d93:	eb 01                	jmp    800d96 <strfind+0x27>
		if (*s == c)
			break;
  800d95:	90                   	nop
	return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da7:	8b 45 10             	mov    0x10(%ebp),%eax
  800daa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dad:	eb 0e                	jmp    800dbd <memset+0x22>
		*p++ = c;
  800daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db2:	8d 50 01             	lea    0x1(%eax),%edx
  800db5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dbd:	ff 4d f8             	decl   -0x8(%ebp)
  800dc0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dc4:	79 e9                	jns    800daf <memset+0x14>
		*p++ = c;

	return v;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    

00800dcb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ddd:	eb 16                	jmp    800df5 <memcpy+0x2a>
		*d++ = *s++;
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de2:	8d 50 01             	lea    0x1(%eax),%edx
  800de5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800deb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df1:	8a 12                	mov    (%edx),%dl
  800df3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df5:	8b 45 10             	mov    0x10(%ebp),%eax
  800df8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	75 dd                	jne    800ddf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    

00800e07 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1f:	73 50                	jae    800e71 <memmove+0x6a>
  800e21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e24:	8b 45 10             	mov    0x10(%ebp),%eax
  800e27:	01 d0                	add    %edx,%eax
  800e29:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2c:	76 43                	jbe    800e71 <memmove+0x6a>
		s += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e3a:	eb 10                	jmp    800e4c <memmove+0x45>
			*--d = *--s;
  800e3c:	ff 4d f8             	decl   -0x8(%ebp)
  800e3f:	ff 4d fc             	decl   -0x4(%ebp)
  800e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e45:	8a 10                	mov    (%eax),%dl
  800e47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 e3                	jne    800e3c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e59:	eb 23                	jmp    800e7e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5e:	8d 50 01             	lea    0x1(%eax),%edx
  800e61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e71:	8b 45 10             	mov    0x10(%ebp),%eax
  800e74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e77:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	75 dd                	jne    800e5b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e81:	c9                   	leave  
  800e82:	c3                   	ret    

00800e83 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e95:	eb 2a                	jmp    800ec1 <memcmp+0x3e>
		if (*s1 != *s2)
  800e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9a:	8a 10                	mov    (%eax),%dl
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	38 c2                	cmp    %al,%dl
  800ea3:	74 16                	je     800ebb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	0f b6 d0             	movzbl %al,%edx
  800ead:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 c0             	movzbl %al,%eax
  800eb5:	29 c2                	sub    %eax,%edx
  800eb7:	89 d0                	mov    %edx,%eax
  800eb9:	eb 18                	jmp    800ed3 <memcmp+0x50>
		s1++, s2++;
  800ebb:	ff 45 fc             	incl   -0x4(%ebp)
  800ebe:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec7:	89 55 10             	mov    %edx,0x10(%ebp)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	75 c9                	jne    800e97 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ece:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed3:	c9                   	leave  
  800ed4:	c3                   	ret    

00800ed5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee6:	eb 15                	jmp    800efd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 d0             	movzbl %al,%edx
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	0f b6 c0             	movzbl %al,%eax
  800ef6:	39 c2                	cmp    %eax,%edx
  800ef8:	74 0d                	je     800f07 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800efa:	ff 45 08             	incl   0x8(%ebp)
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f03:	72 e3                	jb     800ee8 <memfind+0x13>
  800f05:	eb 01                	jmp    800f08 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f07:	90                   	nop
	return (void *) s;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f1a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f21:	eb 03                	jmp    800f26 <strtol+0x19>
		s++;
  800f23:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 20                	cmp    $0x20,%al
  800f2d:	74 f4                	je     800f23 <strtol+0x16>
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	3c 09                	cmp    $0x9,%al
  800f36:	74 eb                	je     800f23 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	3c 2b                	cmp    $0x2b,%al
  800f3f:	75 05                	jne    800f46 <strtol+0x39>
		s++;
  800f41:	ff 45 08             	incl   0x8(%ebp)
  800f44:	eb 13                	jmp    800f59 <strtol+0x4c>
	else if (*s == '-')
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	3c 2d                	cmp    $0x2d,%al
  800f4d:	75 0a                	jne    800f59 <strtol+0x4c>
		s++, neg = 1;
  800f4f:	ff 45 08             	incl   0x8(%ebp)
  800f52:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5d:	74 06                	je     800f65 <strtol+0x58>
  800f5f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f63:	75 20                	jne    800f85 <strtol+0x78>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 30                	cmp    $0x30,%al
  800f6c:	75 17                	jne    800f85 <strtol+0x78>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	40                   	inc    %eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 78                	cmp    $0x78,%al
  800f76:	75 0d                	jne    800f85 <strtol+0x78>
		s += 2, base = 16;
  800f78:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f7c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f83:	eb 28                	jmp    800fad <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f89:	75 15                	jne    800fa0 <strtol+0x93>
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	3c 30                	cmp    $0x30,%al
  800f92:	75 0c                	jne    800fa0 <strtol+0x93>
		s++, base = 8;
  800f94:	ff 45 08             	incl   0x8(%ebp)
  800f97:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f9e:	eb 0d                	jmp    800fad <strtol+0xa0>
	else if (base == 0)
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	75 07                	jne    800fad <strtol+0xa0>
		base = 10;
  800fa6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 2f                	cmp    $0x2f,%al
  800fb4:	7e 19                	jle    800fcf <strtol+0xc2>
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 39                	cmp    $0x39,%al
  800fbd:	7f 10                	jg     800fcf <strtol+0xc2>
			dig = *s - '0';
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	0f be c0             	movsbl %al,%eax
  800fc7:	83 e8 30             	sub    $0x30,%eax
  800fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fcd:	eb 42                	jmp    801011 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 60                	cmp    $0x60,%al
  800fd6:	7e 19                	jle    800ff1 <strtol+0xe4>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3c 7a                	cmp    $0x7a,%al
  800fdf:	7f 10                	jg     800ff1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be c0             	movsbl %al,%eax
  800fe9:	83 e8 57             	sub    $0x57,%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fef:	eb 20                	jmp    801011 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 40                	cmp    $0x40,%al
  800ff8:	7e 39                	jle    801033 <strtol+0x126>
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 5a                	cmp    $0x5a,%al
  801001:	7f 30                	jg     801033 <strtol+0x126>
			dig = *s - 'A' + 10;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	0f be c0             	movsbl %al,%eax
  80100b:	83 e8 37             	sub    $0x37,%eax
  80100e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801014:	3b 45 10             	cmp    0x10(%ebp),%eax
  801017:	7d 19                	jge    801032 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801019:	ff 45 08             	incl   0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801023:	89 c2                	mov    %eax,%edx
  801025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80102d:	e9 7b ff ff ff       	jmp    800fad <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801032:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801033:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801037:	74 08                	je     801041 <strtol+0x134>
		*endptr = (char *) s;
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	8b 55 08             	mov    0x8(%ebp),%edx
  80103f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801041:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801045:	74 07                	je     80104e <strtol+0x141>
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104a:	f7 d8                	neg    %eax
  80104c:	eb 03                	jmp    801051 <strtol+0x144>
  80104e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <ltostr>:

void
ltostr(long value, char *str)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801060:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801067:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106b:	79 13                	jns    801080 <ltostr+0x2d>
	{
		neg = 1;
  80106d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80107a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80107d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801088:	99                   	cltd   
  801089:	f7 f9                	idiv   %ecx
  80108b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	8d 50 01             	lea    0x1(%eax),%edx
  801094:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801097:	89 c2                	mov    %eax,%edx
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	01 d0                	add    %edx,%eax
  80109e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a1:	83 c2 30             	add    $0x30,%edx
  8010a4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ae:	f7 e9                	imul   %ecx
  8010b0:	c1 fa 02             	sar    $0x2,%edx
  8010b3:	89 c8                	mov    %ecx,%eax
  8010b5:	c1 f8 1f             	sar    $0x1f,%eax
  8010b8:	29 c2                	sub    %eax,%edx
  8010ba:	89 d0                	mov    %edx,%eax
  8010bc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	c1 e0 02             	shl    $0x2,%eax
  8010d8:	01 d0                	add    %edx,%eax
  8010da:	01 c0                	add    %eax,%eax
  8010dc:	29 c1                	sub    %eax,%ecx
  8010de:	89 ca                	mov    %ecx,%edx
  8010e0:	85 d2                	test   %edx,%edx
  8010e2:	75 9c                	jne    801080 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ee:	48                   	dec    %eax
  8010ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f6:	74 3d                	je     801135 <ltostr+0xe2>
		start = 1 ;
  8010f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010ff:	eb 34                	jmp    801135 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	01 d0                	add    %edx,%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80110e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	01 c2                	add    %eax,%edx
  801116:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c8                	add    %ecx,%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801122:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	01 c2                	add    %eax,%edx
  80112a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80112d:	88 02                	mov    %al,(%edx)
		start++ ;
  80112f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801132:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801138:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113b:	7c c4                	jl     801101 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80113d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	01 d0                	add    %edx,%eax
  801145:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801148:	90                   	nop
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801151:	ff 75 08             	pushl  0x8(%ebp)
  801154:	e8 54 fa ff ff       	call   800bad <strlen>
  801159:	83 c4 04             	add    $0x4,%esp
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	e8 46 fa ff ff       	call   800bad <strlen>
  801167:	83 c4 04             	add    $0x4,%esp
  80116a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801174:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117b:	eb 17                	jmp    801194 <strcconcat+0x49>
		final[s] = str1[s] ;
  80117d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	01 c2                	add    %eax,%edx
  801185:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	01 c8                	add    %ecx,%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801191:	ff 45 fc             	incl   -0x4(%ebp)
  801194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801197:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80119a:	7c e1                	jl     80117d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80119c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011aa:	eb 1f                	jmp    8011cb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011af:	8d 50 01             	lea    0x1(%eax),%edx
  8011b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011b5:	89 c2                	mov    %eax,%edx
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	01 c2                	add    %eax,%edx
  8011bc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 c8                	add    %ecx,%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c8:	ff 45 f8             	incl   -0x8(%ebp)
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d1:	7c d9                	jl     8011ac <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	c6 00 00             	movb   $0x0,(%eax)
}
  8011de:	90                   	nop
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	8b 00                	mov    (%eax),%eax
  8011f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	01 d0                	add    %edx,%eax
  8011fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801204:	eb 0c                	jmp    801212 <strsplit+0x31>
			*string++ = 0;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 08             	mov    %edx,0x8(%ebp)
  80120f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	84 c0                	test   %al,%al
  801219:	74 18                	je     801233 <strsplit+0x52>
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	0f be c0             	movsbl %al,%eax
  801223:	50                   	push   %eax
  801224:	ff 75 0c             	pushl  0xc(%ebp)
  801227:	e8 13 fb ff ff       	call   800d3f <strchr>
  80122c:	83 c4 08             	add    $0x8,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	75 d3                	jne    801206 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	84 c0                	test   %al,%al
  80123a:	74 5a                	je     801296 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80123c:	8b 45 14             	mov    0x14(%ebp),%eax
  80123f:	8b 00                	mov    (%eax),%eax
  801241:	83 f8 0f             	cmp    $0xf,%eax
  801244:	75 07                	jne    80124d <strsplit+0x6c>
		{
			return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 66                	jmp    8012b3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80124d:	8b 45 14             	mov    0x14(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 48 01             	lea    0x1(%eax),%ecx
  801255:	8b 55 14             	mov    0x14(%ebp),%edx
  801258:	89 0a                	mov    %ecx,(%edx)
  80125a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	01 c2                	add    %eax,%edx
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126b:	eb 03                	jmp    801270 <strsplit+0x8f>
			string++;
  80126d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	84 c0                	test   %al,%al
  801277:	74 8b                	je     801204 <strsplit+0x23>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	0f be c0             	movsbl %al,%eax
  801281:	50                   	push   %eax
  801282:	ff 75 0c             	pushl  0xc(%ebp)
  801285:	e8 b5 fa ff ff       	call   800d3f <strchr>
  80128a:	83 c4 08             	add    $0x8,%esp
  80128d:	85 c0                	test   %eax,%eax
  80128f:	74 dc                	je     80126d <strsplit+0x8c>
			string++;
	}
  801291:	e9 6e ff ff ff       	jmp    801204 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801296:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801297:	8b 45 14             	mov    0x14(%ebp),%eax
  80129a:	8b 00                	mov    (%eax),%eax
  80129c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a6:	01 d0                	add    %edx,%eax
  8012a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	74 1f                	je     8012e3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012c4:	e8 1d 00 00 00       	call   8012e6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	68 70 39 80 00       	push   $0x803970
  8012d1:	e8 55 f2 ff ff       	call   80052b <cprintf>
  8012d6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d9:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012e0:	00 00 00 
	}
}
  8012e3:	90                   	nop
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8012ec:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012f3:	00 00 00 
  8012f6:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8012fd:	00 00 00 
  801300:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801307:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  80130a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801311:	00 00 00 
  801314:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80131b:	00 00 00 
  80131e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801325:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801328:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80132f:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801332:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801341:	2d 00 10 00 00       	sub    $0x1000,%eax
  801346:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80134b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801352:	a1 20 41 80 00       	mov    0x804120,%eax
  801357:	c1 e0 04             	shl    $0x4,%eax
  80135a:	89 c2                	mov    %eax,%edx
  80135c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135f:	01 d0                	add    %edx,%eax
  801361:	48                   	dec    %eax
  801362:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801365:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801368:	ba 00 00 00 00       	mov    $0x0,%edx
  80136d:	f7 75 f0             	divl   -0x10(%ebp)
  801370:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801373:	29 d0                	sub    %edx,%eax
  801375:	89 c2                	mov    %eax,%edx
  801377:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  80137e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801381:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801386:	2d 00 10 00 00       	sub    $0x1000,%eax
  80138b:	83 ec 04             	sub    $0x4,%esp
  80138e:	6a 06                	push   $0x6
  801390:	52                   	push   %edx
  801391:	50                   	push   %eax
  801392:	e8 71 05 00 00       	call   801908 <sys_allocate_chunk>
  801397:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80139a:	a1 20 41 80 00       	mov    0x804120,%eax
  80139f:	83 ec 0c             	sub    $0xc,%esp
  8013a2:	50                   	push   %eax
  8013a3:	e8 e6 0b 00 00       	call   801f8e <initialize_MemBlocksList>
  8013a8:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8013ab:	a1 48 41 80 00       	mov    0x804148,%eax
  8013b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8013b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013b7:	75 14                	jne    8013cd <initialize_dyn_block_system+0xe7>
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	68 95 39 80 00       	push   $0x803995
  8013c1:	6a 2b                	push   $0x2b
  8013c3:	68 b3 39 80 00       	push   $0x8039b3
  8013c8:	e8 aa ee ff ff       	call   800277 <_panic>
  8013cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d0:	8b 00                	mov    (%eax),%eax
  8013d2:	85 c0                	test   %eax,%eax
  8013d4:	74 10                	je     8013e6 <initialize_dyn_block_system+0x100>
  8013d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d9:	8b 00                	mov    (%eax),%eax
  8013db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013de:	8b 52 04             	mov    0x4(%edx),%edx
  8013e1:	89 50 04             	mov    %edx,0x4(%eax)
  8013e4:	eb 0b                	jmp    8013f1 <initialize_dyn_block_system+0x10b>
  8013e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e9:	8b 40 04             	mov    0x4(%eax),%eax
  8013ec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f4:	8b 40 04             	mov    0x4(%eax),%eax
  8013f7:	85 c0                	test   %eax,%eax
  8013f9:	74 0f                	je     80140a <initialize_dyn_block_system+0x124>
  8013fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013fe:	8b 40 04             	mov    0x4(%eax),%eax
  801401:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801404:	8b 12                	mov    (%edx),%edx
  801406:	89 10                	mov    %edx,(%eax)
  801408:	eb 0a                	jmp    801414 <initialize_dyn_block_system+0x12e>
  80140a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80140d:	8b 00                	mov    (%eax),%eax
  80140f:	a3 48 41 80 00       	mov    %eax,0x804148
  801414:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801417:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80141d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801420:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801427:	a1 54 41 80 00       	mov    0x804154,%eax
  80142c:	48                   	dec    %eax
  80142d:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801432:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801435:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80143c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80143f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801446:	83 ec 0c             	sub    $0xc,%esp
  801449:	ff 75 e4             	pushl  -0x1c(%ebp)
  80144c:	e8 d2 13 00 00       	call   802823 <insert_sorted_with_merge_freeList>
  801451:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801454:	90                   	nop
  801455:	c9                   	leave  
  801456:	c3                   	ret    

00801457 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80145d:	e8 53 fe ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801462:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801466:	75 07                	jne    80146f <malloc+0x18>
  801468:	b8 00 00 00 00       	mov    $0x0,%eax
  80146d:	eb 61                	jmp    8014d0 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  80146f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801476:	8b 55 08             	mov    0x8(%ebp),%edx
  801479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147c:	01 d0                	add    %edx,%eax
  80147e:	48                   	dec    %eax
  80147f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801485:	ba 00 00 00 00       	mov    $0x0,%edx
  80148a:	f7 75 f4             	divl   -0xc(%ebp)
  80148d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801490:	29 d0                	sub    %edx,%eax
  801492:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801495:	e8 3c 08 00 00       	call   801cd6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80149a:	85 c0                	test   %eax,%eax
  80149c:	74 2d                	je     8014cb <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  80149e:	83 ec 0c             	sub    $0xc,%esp
  8014a1:	ff 75 08             	pushl  0x8(%ebp)
  8014a4:	e8 3e 0f 00 00       	call   8023e7 <alloc_block_FF>
  8014a9:	83 c4 10             	add    $0x10,%esp
  8014ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8014af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014b3:	74 16                	je     8014cb <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8014b5:	83 ec 0c             	sub    $0xc,%esp
  8014b8:	ff 75 ec             	pushl  -0x14(%ebp)
  8014bb:	e8 48 0c 00 00       	call   802108 <insert_sorted_allocList>
  8014c0:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8014c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c6:	8b 40 08             	mov    0x8(%eax),%eax
  8014c9:	eb 05                	jmp    8014d0 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8014cb:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014e6:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8014e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ec:	83 ec 08             	sub    $0x8,%esp
  8014ef:	50                   	push   %eax
  8014f0:	68 40 40 80 00       	push   $0x804040
  8014f5:	e8 71 0b 00 00       	call   80206b <find_block>
  8014fa:	83 c4 10             	add    $0x10,%esp
  8014fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801503:	8b 50 0c             	mov    0xc(%eax),%edx
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	83 ec 08             	sub    $0x8,%esp
  80150c:	52                   	push   %edx
  80150d:	50                   	push   %eax
  80150e:	e8 bd 03 00 00       	call   8018d0 <sys_free_user_mem>
  801513:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801516:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80151a:	75 14                	jne    801530 <free+0x5e>
  80151c:	83 ec 04             	sub    $0x4,%esp
  80151f:	68 95 39 80 00       	push   $0x803995
  801524:	6a 71                	push   $0x71
  801526:	68 b3 39 80 00       	push   $0x8039b3
  80152b:	e8 47 ed ff ff       	call   800277 <_panic>
  801530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801533:	8b 00                	mov    (%eax),%eax
  801535:	85 c0                	test   %eax,%eax
  801537:	74 10                	je     801549 <free+0x77>
  801539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153c:	8b 00                	mov    (%eax),%eax
  80153e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801541:	8b 52 04             	mov    0x4(%edx),%edx
  801544:	89 50 04             	mov    %edx,0x4(%eax)
  801547:	eb 0b                	jmp    801554 <free+0x82>
  801549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154c:	8b 40 04             	mov    0x4(%eax),%eax
  80154f:	a3 44 40 80 00       	mov    %eax,0x804044
  801554:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801557:	8b 40 04             	mov    0x4(%eax),%eax
  80155a:	85 c0                	test   %eax,%eax
  80155c:	74 0f                	je     80156d <free+0x9b>
  80155e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801561:	8b 40 04             	mov    0x4(%eax),%eax
  801564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801567:	8b 12                	mov    (%edx),%edx
  801569:	89 10                	mov    %edx,(%eax)
  80156b:	eb 0a                	jmp    801577 <free+0xa5>
  80156d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801570:	8b 00                	mov    (%eax),%eax
  801572:	a3 40 40 80 00       	mov    %eax,0x804040
  801577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801580:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801583:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80158a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80158f:	48                   	dec    %eax
  801590:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  801595:	83 ec 0c             	sub    $0xc,%esp
  801598:	ff 75 f0             	pushl  -0x10(%ebp)
  80159b:	e8 83 12 00 00       	call   802823 <insert_sorted_with_merge_freeList>
  8015a0:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015a3:	90                   	nop
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	83 ec 28             	sub    $0x28,%esp
  8015ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8015af:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b2:	e8 fe fc ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015bb:	75 0a                	jne    8015c7 <smalloc+0x21>
  8015bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c2:	e9 86 00 00 00       	jmp    80164d <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8015c7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d4:	01 d0                	add    %edx,%eax
  8015d6:	48                   	dec    %eax
  8015d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e2:	f7 75 f4             	divl   -0xc(%ebp)
  8015e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e8:	29 d0                	sub    %edx,%eax
  8015ea:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015ed:	e8 e4 06 00 00       	call   801cd6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015f2:	85 c0                	test   %eax,%eax
  8015f4:	74 52                	je     801648 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  8015f6:	83 ec 0c             	sub    $0xc,%esp
  8015f9:	ff 75 0c             	pushl  0xc(%ebp)
  8015fc:	e8 e6 0d 00 00       	call   8023e7 <alloc_block_FF>
  801601:	83 c4 10             	add    $0x10,%esp
  801604:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801607:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80160b:	75 07                	jne    801614 <smalloc+0x6e>
			return NULL ;
  80160d:	b8 00 00 00 00       	mov    $0x0,%eax
  801612:	eb 39                	jmp    80164d <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801614:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801617:	8b 40 08             	mov    0x8(%eax),%eax
  80161a:	89 c2                	mov    %eax,%edx
  80161c:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801620:	52                   	push   %edx
  801621:	50                   	push   %eax
  801622:	ff 75 0c             	pushl  0xc(%ebp)
  801625:	ff 75 08             	pushl  0x8(%ebp)
  801628:	e8 2e 04 00 00       	call   801a5b <sys_createSharedObject>
  80162d:	83 c4 10             	add    $0x10,%esp
  801630:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801633:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801637:	79 07                	jns    801640 <smalloc+0x9a>
			return (void*)NULL ;
  801639:	b8 00 00 00 00       	mov    $0x0,%eax
  80163e:	eb 0d                	jmp    80164d <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801640:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801643:	8b 40 08             	mov    0x8(%eax),%eax
  801646:	eb 05                	jmp    80164d <smalloc+0xa7>
		}
		return (void*)NULL ;
  801648:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801655:	e8 5b fc ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80165a:	83 ec 08             	sub    $0x8,%esp
  80165d:	ff 75 0c             	pushl  0xc(%ebp)
  801660:	ff 75 08             	pushl  0x8(%ebp)
  801663:	e8 1d 04 00 00       	call   801a85 <sys_getSizeOfSharedObject>
  801668:	83 c4 10             	add    $0x10,%esp
  80166b:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  80166e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801672:	75 0a                	jne    80167e <sget+0x2f>
			return NULL ;
  801674:	b8 00 00 00 00       	mov    $0x0,%eax
  801679:	e9 83 00 00 00       	jmp    801701 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  80167e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801685:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168b:	01 d0                	add    %edx,%eax
  80168d:	48                   	dec    %eax
  80168e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801691:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801694:	ba 00 00 00 00       	mov    $0x0,%edx
  801699:	f7 75 f0             	divl   -0x10(%ebp)
  80169c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169f:	29 d0                	sub    %edx,%eax
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016a4:	e8 2d 06 00 00       	call   801cd6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016a9:	85 c0                	test   %eax,%eax
  8016ab:	74 4f                	je     8016fc <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8016ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b0:	83 ec 0c             	sub    $0xc,%esp
  8016b3:	50                   	push   %eax
  8016b4:	e8 2e 0d 00 00       	call   8023e7 <alloc_block_FF>
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8016bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016c3:	75 07                	jne    8016cc <sget+0x7d>
					return (void*)NULL ;
  8016c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ca:	eb 35                	jmp    801701 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8016cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016cf:	8b 40 08             	mov    0x8(%eax),%eax
  8016d2:	83 ec 04             	sub    $0x4,%esp
  8016d5:	50                   	push   %eax
  8016d6:	ff 75 0c             	pushl  0xc(%ebp)
  8016d9:	ff 75 08             	pushl  0x8(%ebp)
  8016dc:	e8 c1 03 00 00       	call   801aa2 <sys_getSharedObject>
  8016e1:	83 c4 10             	add    $0x10,%esp
  8016e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8016e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016eb:	79 07                	jns    8016f4 <sget+0xa5>
				return (void*)NULL ;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f2:	eb 0d                	jmp    801701 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8016f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f7:	8b 40 08             	mov    0x8(%eax),%eax
  8016fa:	eb 05                	jmp    801701 <sget+0xb2>


		}
	return (void*)NULL ;
  8016fc:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801709:	e8 a7 fb ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80170e:	83 ec 04             	sub    $0x4,%esp
  801711:	68 c0 39 80 00       	push   $0x8039c0
  801716:	68 f9 00 00 00       	push   $0xf9
  80171b:	68 b3 39 80 00       	push   $0x8039b3
  801720:	e8 52 eb ff ff       	call   800277 <_panic>

00801725 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	68 e8 39 80 00       	push   $0x8039e8
  801733:	68 0d 01 00 00       	push   $0x10d
  801738:	68 b3 39 80 00       	push   $0x8039b3
  80173d:	e8 35 eb ff ff       	call   800277 <_panic>

00801742 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801748:	83 ec 04             	sub    $0x4,%esp
  80174b:	68 0c 3a 80 00       	push   $0x803a0c
  801750:	68 18 01 00 00       	push   $0x118
  801755:	68 b3 39 80 00       	push   $0x8039b3
  80175a:	e8 18 eb ff ff       	call   800277 <_panic>

0080175f <shrink>:

}
void shrink(uint32 newSize)
{
  80175f:	55                   	push   %ebp
  801760:	89 e5                	mov    %esp,%ebp
  801762:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801765:	83 ec 04             	sub    $0x4,%esp
  801768:	68 0c 3a 80 00       	push   $0x803a0c
  80176d:	68 1d 01 00 00       	push   $0x11d
  801772:	68 b3 39 80 00       	push   $0x8039b3
  801777:	e8 fb ea ff ff       	call   800277 <_panic>

0080177c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	68 0c 3a 80 00       	push   $0x803a0c
  80178a:	68 22 01 00 00       	push   $0x122
  80178f:	68 b3 39 80 00       	push   $0x8039b3
  801794:	e8 de ea ff ff       	call   800277 <_panic>

00801799 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	57                   	push   %edi
  80179d:	56                   	push   %esi
  80179e:	53                   	push   %ebx
  80179f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ae:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017b1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017b4:	cd 30                	int    $0x30
  8017b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	5b                   	pop    %ebx
  8017c0:	5e                   	pop    %esi
  8017c1:	5f                   	pop    %edi
  8017c2:	5d                   	pop    %ebp
  8017c3:	c3                   	ret    

008017c4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017c4:	55                   	push   %ebp
  8017c5:	89 e5                	mov    %esp,%ebp
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	52                   	push   %edx
  8017dc:	ff 75 0c             	pushl  0xc(%ebp)
  8017df:	50                   	push   %eax
  8017e0:	6a 00                	push   $0x0
  8017e2:	e8 b2 ff ff ff       	call   801799 <syscall>
  8017e7:	83 c4 18             	add    $0x18,%esp
}
  8017ea:	90                   	nop
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <sys_cgetc>:

int
sys_cgetc(void)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 01                	push   $0x1
  8017fc:	e8 98 ff ff ff       	call   801799 <syscall>
  801801:	83 c4 18             	add    $0x18,%esp
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801809:	8b 55 0c             	mov    0xc(%ebp),%edx
  80180c:	8b 45 08             	mov    0x8(%ebp),%eax
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	52                   	push   %edx
  801816:	50                   	push   %eax
  801817:	6a 05                	push   $0x5
  801819:	e8 7b ff ff ff       	call   801799 <syscall>
  80181e:	83 c4 18             	add    $0x18,%esp
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	56                   	push   %esi
  801827:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801828:	8b 75 18             	mov    0x18(%ebp),%esi
  80182b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80182e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801831:	8b 55 0c             	mov    0xc(%ebp),%edx
  801834:	8b 45 08             	mov    0x8(%ebp),%eax
  801837:	56                   	push   %esi
  801838:	53                   	push   %ebx
  801839:	51                   	push   %ecx
  80183a:	52                   	push   %edx
  80183b:	50                   	push   %eax
  80183c:	6a 06                	push   $0x6
  80183e:	e8 56 ff ff ff       	call   801799 <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
}
  801846:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801849:	5b                   	pop    %ebx
  80184a:	5e                   	pop    %esi
  80184b:	5d                   	pop    %ebp
  80184c:	c3                   	ret    

0080184d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801850:	8b 55 0c             	mov    0xc(%ebp),%edx
  801853:	8b 45 08             	mov    0x8(%ebp),%eax
  801856:	6a 00                	push   $0x0
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	52                   	push   %edx
  80185d:	50                   	push   %eax
  80185e:	6a 07                	push   $0x7
  801860:	e8 34 ff ff ff       	call   801799 <syscall>
  801865:	83 c4 18             	add    $0x18,%esp
}
  801868:	c9                   	leave  
  801869:	c3                   	ret    

0080186a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80186d:	6a 00                	push   $0x0
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	ff 75 0c             	pushl  0xc(%ebp)
  801876:	ff 75 08             	pushl  0x8(%ebp)
  801879:	6a 08                	push   $0x8
  80187b:	e8 19 ff ff ff       	call   801799 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	c9                   	leave  
  801884:	c3                   	ret    

00801885 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 09                	push   $0x9
  801894:	e8 00 ff ff ff       	call   801799 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 0a                	push   $0xa
  8018ad:	e8 e7 fe ff ff       	call   801799 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 0b                	push   $0xb
  8018c6:	e8 ce fe ff ff       	call   801799 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	ff 75 08             	pushl  0x8(%ebp)
  8018df:	6a 0f                	push   $0xf
  8018e1:	e8 b3 fe ff ff       	call   801799 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
	return;
  8018e9:	90                   	nop
}
  8018ea:	c9                   	leave  
  8018eb:	c3                   	ret    

008018ec <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	ff 75 0c             	pushl  0xc(%ebp)
  8018f8:	ff 75 08             	pushl  0x8(%ebp)
  8018fb:	6a 10                	push   $0x10
  8018fd:	e8 97 fe ff ff       	call   801799 <syscall>
  801902:	83 c4 18             	add    $0x18,%esp
	return ;
  801905:	90                   	nop
}
  801906:	c9                   	leave  
  801907:	c3                   	ret    

00801908 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	ff 75 10             	pushl  0x10(%ebp)
  801912:	ff 75 0c             	pushl  0xc(%ebp)
  801915:	ff 75 08             	pushl  0x8(%ebp)
  801918:	6a 11                	push   $0x11
  80191a:	e8 7a fe ff ff       	call   801799 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
	return ;
  801922:	90                   	nop
}
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 0c                	push   $0xc
  801934:	e8 60 fe ff ff       	call   801799 <syscall>
  801939:	83 c4 18             	add    $0x18,%esp
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	ff 75 08             	pushl  0x8(%ebp)
  80194c:	6a 0d                	push   $0xd
  80194e:	e8 46 fe ff ff       	call   801799 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 0e                	push   $0xe
  801967:	e8 2d fe ff ff       	call   801799 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	90                   	nop
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 13                	push   $0x13
  801981:	e8 13 fe ff ff       	call   801799 <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	90                   	nop
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 14                	push   $0x14
  80199b:	e8 f9 fd ff ff       	call   801799 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	90                   	nop
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	83 ec 04             	sub    $0x4,%esp
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019b2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	50                   	push   %eax
  8019bf:	6a 15                	push   $0x15
  8019c1:	e8 d3 fd ff ff       	call   801799 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	90                   	nop
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 16                	push   $0x16
  8019db:	e8 b9 fd ff ff       	call   801799 <syscall>
  8019e0:	83 c4 18             	add    $0x18,%esp
}
  8019e3:	90                   	nop
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	50                   	push   %eax
  8019f6:	6a 17                	push   $0x17
  8019f8:	e8 9c fd ff ff       	call   801799 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	52                   	push   %edx
  801a12:	50                   	push   %eax
  801a13:	6a 1a                	push   $0x1a
  801a15:	e8 7f fd ff ff       	call   801799 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	52                   	push   %edx
  801a2f:	50                   	push   %eax
  801a30:	6a 18                	push   $0x18
  801a32:	e8 62 fd ff ff       	call   801799 <syscall>
  801a37:	83 c4 18             	add    $0x18,%esp
}
  801a3a:	90                   	nop
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a43:	8b 45 08             	mov    0x8(%ebp),%eax
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	52                   	push   %edx
  801a4d:	50                   	push   %eax
  801a4e:	6a 19                	push   $0x19
  801a50:	e8 44 fd ff ff       	call   801799 <syscall>
  801a55:	83 c4 18             	add    $0x18,%esp
}
  801a58:	90                   	nop
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
  801a5e:	83 ec 04             	sub    $0x4,%esp
  801a61:	8b 45 10             	mov    0x10(%ebp),%eax
  801a64:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a67:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a6a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	6a 00                	push   $0x0
  801a73:	51                   	push   %ecx
  801a74:	52                   	push   %edx
  801a75:	ff 75 0c             	pushl  0xc(%ebp)
  801a78:	50                   	push   %eax
  801a79:	6a 1b                	push   $0x1b
  801a7b:	e8 19 fd ff ff       	call   801799 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	52                   	push   %edx
  801a95:	50                   	push   %eax
  801a96:	6a 1c                	push   $0x1c
  801a98:	e8 fc fc ff ff       	call   801799 <syscall>
  801a9d:	83 c4 18             	add    $0x18,%esp
}
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801aa5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	51                   	push   %ecx
  801ab3:	52                   	push   %edx
  801ab4:	50                   	push   %eax
  801ab5:	6a 1d                	push   $0x1d
  801ab7:	e8 dd fc ff ff       	call   801799 <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ac4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	52                   	push   %edx
  801ad1:	50                   	push   %eax
  801ad2:	6a 1e                	push   $0x1e
  801ad4:	e8 c0 fc ff ff       	call   801799 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 1f                	push   $0x1f
  801aed:	e8 a7 fc ff ff       	call   801799 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801afa:	8b 45 08             	mov    0x8(%ebp),%eax
  801afd:	6a 00                	push   $0x0
  801aff:	ff 75 14             	pushl  0x14(%ebp)
  801b02:	ff 75 10             	pushl  0x10(%ebp)
  801b05:	ff 75 0c             	pushl  0xc(%ebp)
  801b08:	50                   	push   %eax
  801b09:	6a 20                	push   $0x20
  801b0b:	e8 89 fc ff ff       	call   801799 <syscall>
  801b10:	83 c4 18             	add    $0x18,%esp
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	50                   	push   %eax
  801b24:	6a 21                	push   $0x21
  801b26:	e8 6e fc ff ff       	call   801799 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	90                   	nop
  801b2f:	c9                   	leave  
  801b30:	c3                   	ret    

00801b31 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	50                   	push   %eax
  801b40:	6a 22                	push   $0x22
  801b42:	e8 52 fc ff ff       	call   801799 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 02                	push   $0x2
  801b5b:	e8 39 fc ff ff       	call   801799 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 03                	push   $0x3
  801b74:	e8 20 fc ff ff       	call   801799 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 04                	push   $0x4
  801b8d:	e8 07 fc ff ff       	call   801799 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_exit_env>:


void sys_exit_env(void)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 23                	push   $0x23
  801ba6:	e8 ee fb ff ff       	call   801799 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	90                   	nop
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bb7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bba:	8d 50 04             	lea    0x4(%eax),%edx
  801bbd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	52                   	push   %edx
  801bc7:	50                   	push   %eax
  801bc8:	6a 24                	push   $0x24
  801bca:	e8 ca fb ff ff       	call   801799 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
	return result;
  801bd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bd8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bdb:	89 01                	mov    %eax,(%ecx)
  801bdd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	c9                   	leave  
  801be4:	c2 04 00             	ret    $0x4

00801be7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801be7:	55                   	push   %ebp
  801be8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	ff 75 10             	pushl  0x10(%ebp)
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	ff 75 08             	pushl  0x8(%ebp)
  801bf7:	6a 12                	push   $0x12
  801bf9:	e8 9b fb ff ff       	call   801799 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801c01:	90                   	nop
}
  801c02:	c9                   	leave  
  801c03:	c3                   	ret    

00801c04 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c04:	55                   	push   %ebp
  801c05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 25                	push   $0x25
  801c13:	e8 81 fb ff ff       	call   801799 <syscall>
  801c18:	83 c4 18             	add    $0x18,%esp
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	83 ec 04             	sub    $0x4,%esp
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c29:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	50                   	push   %eax
  801c36:	6a 26                	push   $0x26
  801c38:	e8 5c fb ff ff       	call   801799 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c40:	90                   	nop
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <rsttst>:
void rsttst()
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 28                	push   $0x28
  801c52:	e8 42 fb ff ff       	call   801799 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5a:	90                   	nop
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	83 ec 04             	sub    $0x4,%esp
  801c63:	8b 45 14             	mov    0x14(%ebp),%eax
  801c66:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c69:	8b 55 18             	mov    0x18(%ebp),%edx
  801c6c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c70:	52                   	push   %edx
  801c71:	50                   	push   %eax
  801c72:	ff 75 10             	pushl  0x10(%ebp)
  801c75:	ff 75 0c             	pushl  0xc(%ebp)
  801c78:	ff 75 08             	pushl  0x8(%ebp)
  801c7b:	6a 27                	push   $0x27
  801c7d:	e8 17 fb ff ff       	call   801799 <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
	return ;
  801c85:	90                   	nop
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <chktst>:
void chktst(uint32 n)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	ff 75 08             	pushl  0x8(%ebp)
  801c96:	6a 29                	push   $0x29
  801c98:	e8 fc fa ff ff       	call   801799 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca0:	90                   	nop
}
  801ca1:	c9                   	leave  
  801ca2:	c3                   	ret    

00801ca3 <inctst>:

void inctst()
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 2a                	push   $0x2a
  801cb2:	e8 e2 fa ff ff       	call   801799 <syscall>
  801cb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cba:	90                   	nop
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <gettst>:
uint32 gettst()
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 2b                	push   $0x2b
  801ccc:	e8 c8 fa ff ff       	call   801799 <syscall>
  801cd1:	83 c4 18             	add    $0x18,%esp
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
  801cd9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 2c                	push   $0x2c
  801ce8:	e8 ac fa ff ff       	call   801799 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
  801cf0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801cf3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cf7:	75 07                	jne    801d00 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cf9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfe:	eb 05                	jmp    801d05 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 2c                	push   $0x2c
  801d19:	e8 7b fa ff ff       	call   801799 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
  801d21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d24:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d28:	75 07                	jne    801d31 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2f:	eb 05                	jmp    801d36 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 2c                	push   $0x2c
  801d4a:	e8 4a fa ff ff       	call   801799 <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
  801d52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d55:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d59:	75 07                	jne    801d62 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d60:	eb 05                	jmp    801d67 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d67:	c9                   	leave  
  801d68:	c3                   	ret    

00801d69 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d69:	55                   	push   %ebp
  801d6a:	89 e5                	mov    %esp,%ebp
  801d6c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 2c                	push   $0x2c
  801d7b:	e8 19 fa ff ff       	call   801799 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
  801d83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d86:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d8a:	75 07                	jne    801d93 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d8c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d91:	eb 05                	jmp    801d98 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	ff 75 08             	pushl  0x8(%ebp)
  801da8:	6a 2d                	push   $0x2d
  801daa:	e8 ea f9 ff ff       	call   801799 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
	return ;
  801db2:	90                   	nop
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801db9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc5:	6a 00                	push   $0x0
  801dc7:	53                   	push   %ebx
  801dc8:	51                   	push   %ecx
  801dc9:	52                   	push   %edx
  801dca:	50                   	push   %eax
  801dcb:	6a 2e                	push   $0x2e
  801dcd:	e8 c7 f9 ff ff       	call   801799 <syscall>
  801dd2:	83 c4 18             	add    $0x18,%esp
}
  801dd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ddd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de0:	8b 45 08             	mov    0x8(%ebp),%eax
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	52                   	push   %edx
  801dea:	50                   	push   %eax
  801deb:	6a 2f                	push   $0x2f
  801ded:	e8 a7 f9 ff ff       	call   801799 <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801dfd:	83 ec 0c             	sub    $0xc,%esp
  801e00:	68 1c 3a 80 00       	push   $0x803a1c
  801e05:	e8 21 e7 ff ff       	call   80052b <cprintf>
  801e0a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e14:	83 ec 0c             	sub    $0xc,%esp
  801e17:	68 48 3a 80 00       	push   $0x803a48
  801e1c:	e8 0a e7 ff ff       	call   80052b <cprintf>
  801e21:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e24:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e28:	a1 38 41 80 00       	mov    0x804138,%eax
  801e2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e30:	eb 56                	jmp    801e88 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e36:	74 1c                	je     801e54 <print_mem_block_lists+0x5d>
  801e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3b:	8b 50 08             	mov    0x8(%eax),%edx
  801e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e41:	8b 48 08             	mov    0x8(%eax),%ecx
  801e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e47:	8b 40 0c             	mov    0xc(%eax),%eax
  801e4a:	01 c8                	add    %ecx,%eax
  801e4c:	39 c2                	cmp    %eax,%edx
  801e4e:	73 04                	jae    801e54 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e50:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	8b 50 08             	mov    0x8(%eax),%edx
  801e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e60:	01 c2                	add    %eax,%edx
  801e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e65:	8b 40 08             	mov    0x8(%eax),%eax
  801e68:	83 ec 04             	sub    $0x4,%esp
  801e6b:	52                   	push   %edx
  801e6c:	50                   	push   %eax
  801e6d:	68 5d 3a 80 00       	push   $0x803a5d
  801e72:	e8 b4 e6 ff ff       	call   80052b <cprintf>
  801e77:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e80:	a1 40 41 80 00       	mov    0x804140,%eax
  801e85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e8c:	74 07                	je     801e95 <print_mem_block_lists+0x9e>
  801e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e91:	8b 00                	mov    (%eax),%eax
  801e93:	eb 05                	jmp    801e9a <print_mem_block_lists+0xa3>
  801e95:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9a:	a3 40 41 80 00       	mov    %eax,0x804140
  801e9f:	a1 40 41 80 00       	mov    0x804140,%eax
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	75 8a                	jne    801e32 <print_mem_block_lists+0x3b>
  801ea8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eac:	75 84                	jne    801e32 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801eae:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eb2:	75 10                	jne    801ec4 <print_mem_block_lists+0xcd>
  801eb4:	83 ec 0c             	sub    $0xc,%esp
  801eb7:	68 6c 3a 80 00       	push   $0x803a6c
  801ebc:	e8 6a e6 ff ff       	call   80052b <cprintf>
  801ec1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ec4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ecb:	83 ec 0c             	sub    $0xc,%esp
  801ece:	68 90 3a 80 00       	push   $0x803a90
  801ed3:	e8 53 e6 ff ff       	call   80052b <cprintf>
  801ed8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801edb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801edf:	a1 40 40 80 00       	mov    0x804040,%eax
  801ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee7:	eb 56                	jmp    801f3f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ee9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eed:	74 1c                	je     801f0b <print_mem_block_lists+0x114>
  801eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef2:	8b 50 08             	mov    0x8(%eax),%edx
  801ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef8:	8b 48 08             	mov    0x8(%eax),%ecx
  801efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efe:	8b 40 0c             	mov    0xc(%eax),%eax
  801f01:	01 c8                	add    %ecx,%eax
  801f03:	39 c2                	cmp    %eax,%edx
  801f05:	73 04                	jae    801f0b <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f07:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	8b 50 08             	mov    0x8(%eax),%edx
  801f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f14:	8b 40 0c             	mov    0xc(%eax),%eax
  801f17:	01 c2                	add    %eax,%edx
  801f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1c:	8b 40 08             	mov    0x8(%eax),%eax
  801f1f:	83 ec 04             	sub    $0x4,%esp
  801f22:	52                   	push   %edx
  801f23:	50                   	push   %eax
  801f24:	68 5d 3a 80 00       	push   $0x803a5d
  801f29:	e8 fd e5 ff ff       	call   80052b <cprintf>
  801f2e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f34:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f37:	a1 48 40 80 00       	mov    0x804048,%eax
  801f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f43:	74 07                	je     801f4c <print_mem_block_lists+0x155>
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	8b 00                	mov    (%eax),%eax
  801f4a:	eb 05                	jmp    801f51 <print_mem_block_lists+0x15a>
  801f4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f51:	a3 48 40 80 00       	mov    %eax,0x804048
  801f56:	a1 48 40 80 00       	mov    0x804048,%eax
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	75 8a                	jne    801ee9 <print_mem_block_lists+0xf2>
  801f5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f63:	75 84                	jne    801ee9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f65:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f69:	75 10                	jne    801f7b <print_mem_block_lists+0x184>
  801f6b:	83 ec 0c             	sub    $0xc,%esp
  801f6e:	68 a8 3a 80 00       	push   $0x803aa8
  801f73:	e8 b3 e5 ff ff       	call   80052b <cprintf>
  801f78:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f7b:	83 ec 0c             	sub    $0xc,%esp
  801f7e:	68 1c 3a 80 00       	push   $0x803a1c
  801f83:	e8 a3 e5 ff ff       	call   80052b <cprintf>
  801f88:	83 c4 10             	add    $0x10,%esp

}
  801f8b:	90                   	nop
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f8e:	55                   	push   %ebp
  801f8f:	89 e5                	mov    %esp,%ebp
  801f91:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801f94:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801f9b:	00 00 00 
  801f9e:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fa5:	00 00 00 
  801fa8:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801faf:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801fb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fb9:	e9 9e 00 00 00       	jmp    80205c <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  801fbe:	a1 50 40 80 00       	mov    0x804050,%eax
  801fc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc6:	c1 e2 04             	shl    $0x4,%edx
  801fc9:	01 d0                	add    %edx,%eax
  801fcb:	85 c0                	test   %eax,%eax
  801fcd:	75 14                	jne    801fe3 <initialize_MemBlocksList+0x55>
  801fcf:	83 ec 04             	sub    $0x4,%esp
  801fd2:	68 d0 3a 80 00       	push   $0x803ad0
  801fd7:	6a 43                	push   $0x43
  801fd9:	68 f3 3a 80 00       	push   $0x803af3
  801fde:	e8 94 e2 ff ff       	call   800277 <_panic>
  801fe3:	a1 50 40 80 00       	mov    0x804050,%eax
  801fe8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801feb:	c1 e2 04             	shl    $0x4,%edx
  801fee:	01 d0                	add    %edx,%eax
  801ff0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ff6:	89 10                	mov    %edx,(%eax)
  801ff8:	8b 00                	mov    (%eax),%eax
  801ffa:	85 c0                	test   %eax,%eax
  801ffc:	74 18                	je     802016 <initialize_MemBlocksList+0x88>
  801ffe:	a1 48 41 80 00       	mov    0x804148,%eax
  802003:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802009:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80200c:	c1 e1 04             	shl    $0x4,%ecx
  80200f:	01 ca                	add    %ecx,%edx
  802011:	89 50 04             	mov    %edx,0x4(%eax)
  802014:	eb 12                	jmp    802028 <initialize_MemBlocksList+0x9a>
  802016:	a1 50 40 80 00       	mov    0x804050,%eax
  80201b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80201e:	c1 e2 04             	shl    $0x4,%edx
  802021:	01 d0                	add    %edx,%eax
  802023:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802028:	a1 50 40 80 00       	mov    0x804050,%eax
  80202d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802030:	c1 e2 04             	shl    $0x4,%edx
  802033:	01 d0                	add    %edx,%eax
  802035:	a3 48 41 80 00       	mov    %eax,0x804148
  80203a:	a1 50 40 80 00       	mov    0x804050,%eax
  80203f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802042:	c1 e2 04             	shl    $0x4,%edx
  802045:	01 d0                	add    %edx,%eax
  802047:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80204e:	a1 54 41 80 00       	mov    0x804154,%eax
  802053:	40                   	inc    %eax
  802054:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802059:	ff 45 f4             	incl   -0xc(%ebp)
  80205c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802062:	0f 82 56 ff ff ff    	jb     801fbe <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802068:	90                   	nop
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802071:	a1 38 41 80 00       	mov    0x804138,%eax
  802076:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802079:	eb 18                	jmp    802093 <find_block+0x28>
	{
		if (ele->sva==va)
  80207b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80207e:	8b 40 08             	mov    0x8(%eax),%eax
  802081:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802084:	75 05                	jne    80208b <find_block+0x20>
			return ele;
  802086:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802089:	eb 7b                	jmp    802106 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80208b:	a1 40 41 80 00       	mov    0x804140,%eax
  802090:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802093:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802097:	74 07                	je     8020a0 <find_block+0x35>
  802099:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80209c:	8b 00                	mov    (%eax),%eax
  80209e:	eb 05                	jmp    8020a5 <find_block+0x3a>
  8020a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a5:	a3 40 41 80 00       	mov    %eax,0x804140
  8020aa:	a1 40 41 80 00       	mov    0x804140,%eax
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	75 c8                	jne    80207b <find_block+0x10>
  8020b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020b7:	75 c2                	jne    80207b <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020b9:	a1 40 40 80 00       	mov    0x804040,%eax
  8020be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020c1:	eb 18                	jmp    8020db <find_block+0x70>
	{
		if (ele->sva==va)
  8020c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c6:	8b 40 08             	mov    0x8(%eax),%eax
  8020c9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020cc:	75 05                	jne    8020d3 <find_block+0x68>
					return ele;
  8020ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d1:	eb 33                	jmp    802106 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020d3:	a1 48 40 80 00       	mov    0x804048,%eax
  8020d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020db:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020df:	74 07                	je     8020e8 <find_block+0x7d>
  8020e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e4:	8b 00                	mov    (%eax),%eax
  8020e6:	eb 05                	jmp    8020ed <find_block+0x82>
  8020e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ed:	a3 48 40 80 00       	mov    %eax,0x804048
  8020f2:	a1 48 40 80 00       	mov    0x804048,%eax
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	75 c8                	jne    8020c3 <find_block+0x58>
  8020fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020ff:	75 c2                	jne    8020c3 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802101:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  80210e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802113:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802116:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80211a:	75 62                	jne    80217e <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80211c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802120:	75 14                	jne    802136 <insert_sorted_allocList+0x2e>
  802122:	83 ec 04             	sub    $0x4,%esp
  802125:	68 d0 3a 80 00       	push   $0x803ad0
  80212a:	6a 69                	push   $0x69
  80212c:	68 f3 3a 80 00       	push   $0x803af3
  802131:	e8 41 e1 ff ff       	call   800277 <_panic>
  802136:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	89 10                	mov    %edx,(%eax)
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	8b 00                	mov    (%eax),%eax
  802146:	85 c0                	test   %eax,%eax
  802148:	74 0d                	je     802157 <insert_sorted_allocList+0x4f>
  80214a:	a1 40 40 80 00       	mov    0x804040,%eax
  80214f:	8b 55 08             	mov    0x8(%ebp),%edx
  802152:	89 50 04             	mov    %edx,0x4(%eax)
  802155:	eb 08                	jmp    80215f <insert_sorted_allocList+0x57>
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	a3 44 40 80 00       	mov    %eax,0x804044
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	a3 40 40 80 00       	mov    %eax,0x804040
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802171:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802176:	40                   	inc    %eax
  802177:	a3 4c 40 80 00       	mov    %eax,0x80404c
  80217c:	eb 72                	jmp    8021f0 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  80217e:	a1 40 40 80 00       	mov    0x804040,%eax
  802183:	8b 50 08             	mov    0x8(%eax),%edx
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	8b 40 08             	mov    0x8(%eax),%eax
  80218c:	39 c2                	cmp    %eax,%edx
  80218e:	76 60                	jbe    8021f0 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802190:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802194:	75 14                	jne    8021aa <insert_sorted_allocList+0xa2>
  802196:	83 ec 04             	sub    $0x4,%esp
  802199:	68 d0 3a 80 00       	push   $0x803ad0
  80219e:	6a 6d                	push   $0x6d
  8021a0:	68 f3 3a 80 00       	push   $0x803af3
  8021a5:	e8 cd e0 ff ff       	call   800277 <_panic>
  8021aa:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	89 10                	mov    %edx,(%eax)
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8b 00                	mov    (%eax),%eax
  8021ba:	85 c0                	test   %eax,%eax
  8021bc:	74 0d                	je     8021cb <insert_sorted_allocList+0xc3>
  8021be:	a1 40 40 80 00       	mov    0x804040,%eax
  8021c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c6:	89 50 04             	mov    %edx,0x4(%eax)
  8021c9:	eb 08                	jmp    8021d3 <insert_sorted_allocList+0xcb>
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	a3 44 40 80 00       	mov    %eax,0x804044
  8021d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d6:	a3 40 40 80 00       	mov    %eax,0x804040
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ea:	40                   	inc    %eax
  8021eb:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8021f0:	a1 40 40 80 00       	mov    0x804040,%eax
  8021f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f8:	e9 b9 01 00 00       	jmp    8023b6 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	8b 50 08             	mov    0x8(%eax),%edx
  802203:	a1 40 40 80 00       	mov    0x804040,%eax
  802208:	8b 40 08             	mov    0x8(%eax),%eax
  80220b:	39 c2                	cmp    %eax,%edx
  80220d:	76 7c                	jbe    80228b <insert_sorted_allocList+0x183>
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	8b 50 08             	mov    0x8(%eax),%edx
  802215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802218:	8b 40 08             	mov    0x8(%eax),%eax
  80221b:	39 c2                	cmp    %eax,%edx
  80221d:	73 6c                	jae    80228b <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80221f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802223:	74 06                	je     80222b <insert_sorted_allocList+0x123>
  802225:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802229:	75 14                	jne    80223f <insert_sorted_allocList+0x137>
  80222b:	83 ec 04             	sub    $0x4,%esp
  80222e:	68 0c 3b 80 00       	push   $0x803b0c
  802233:	6a 75                	push   $0x75
  802235:	68 f3 3a 80 00       	push   $0x803af3
  80223a:	e8 38 e0 ff ff       	call   800277 <_panic>
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	8b 50 04             	mov    0x4(%eax),%edx
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	89 50 04             	mov    %edx,0x4(%eax)
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802251:	89 10                	mov    %edx,(%eax)
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 40 04             	mov    0x4(%eax),%eax
  802259:	85 c0                	test   %eax,%eax
  80225b:	74 0d                	je     80226a <insert_sorted_allocList+0x162>
  80225d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802260:	8b 40 04             	mov    0x4(%eax),%eax
  802263:	8b 55 08             	mov    0x8(%ebp),%edx
  802266:	89 10                	mov    %edx,(%eax)
  802268:	eb 08                	jmp    802272 <insert_sorted_allocList+0x16a>
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	a3 40 40 80 00       	mov    %eax,0x804040
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 55 08             	mov    0x8(%ebp),%edx
  802278:	89 50 04             	mov    %edx,0x4(%eax)
  80227b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802280:	40                   	inc    %eax
  802281:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  802286:	e9 59 01 00 00       	jmp    8023e4 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	8b 50 08             	mov    0x8(%eax),%edx
  802291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802294:	8b 40 08             	mov    0x8(%eax),%eax
  802297:	39 c2                	cmp    %eax,%edx
  802299:	0f 86 98 00 00 00    	jbe    802337 <insert_sorted_allocList+0x22f>
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	8b 50 08             	mov    0x8(%eax),%edx
  8022a5:	a1 44 40 80 00       	mov    0x804044,%eax
  8022aa:	8b 40 08             	mov    0x8(%eax),%eax
  8022ad:	39 c2                	cmp    %eax,%edx
  8022af:	0f 83 82 00 00 00    	jae    802337 <insert_sorted_allocList+0x22f>
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	8b 50 08             	mov    0x8(%eax),%edx
  8022bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022be:	8b 00                	mov    (%eax),%eax
  8022c0:	8b 40 08             	mov    0x8(%eax),%eax
  8022c3:	39 c2                	cmp    %eax,%edx
  8022c5:	73 70                	jae    802337 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8022c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022cb:	74 06                	je     8022d3 <insert_sorted_allocList+0x1cb>
  8022cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d1:	75 14                	jne    8022e7 <insert_sorted_allocList+0x1df>
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	68 44 3b 80 00       	push   $0x803b44
  8022db:	6a 7c                	push   $0x7c
  8022dd:	68 f3 3a 80 00       	push   $0x803af3
  8022e2:	e8 90 df ff ff       	call   800277 <_panic>
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	8b 10                	mov    (%eax),%edx
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	89 10                	mov    %edx,(%eax)
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	8b 00                	mov    (%eax),%eax
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	74 0b                	je     802305 <insert_sorted_allocList+0x1fd>
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	8b 00                	mov    (%eax),%eax
  8022ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802302:	89 50 04             	mov    %edx,0x4(%eax)
  802305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802308:	8b 55 08             	mov    0x8(%ebp),%edx
  80230b:	89 10                	mov    %edx,(%eax)
  80230d:	8b 45 08             	mov    0x8(%ebp),%eax
  802310:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802313:	89 50 04             	mov    %edx,0x4(%eax)
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	8b 00                	mov    (%eax),%eax
  80231b:	85 c0                	test   %eax,%eax
  80231d:	75 08                	jne    802327 <insert_sorted_allocList+0x21f>
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	a3 44 40 80 00       	mov    %eax,0x804044
  802327:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80232c:	40                   	inc    %eax
  80232d:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802332:	e9 ad 00 00 00       	jmp    8023e4 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	8b 50 08             	mov    0x8(%eax),%edx
  80233d:	a1 44 40 80 00       	mov    0x804044,%eax
  802342:	8b 40 08             	mov    0x8(%eax),%eax
  802345:	39 c2                	cmp    %eax,%edx
  802347:	76 65                	jbe    8023ae <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802349:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80234d:	75 17                	jne    802366 <insert_sorted_allocList+0x25e>
  80234f:	83 ec 04             	sub    $0x4,%esp
  802352:	68 78 3b 80 00       	push   $0x803b78
  802357:	68 80 00 00 00       	push   $0x80
  80235c:	68 f3 3a 80 00       	push   $0x803af3
  802361:	e8 11 df ff ff       	call   800277 <_panic>
  802366:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	89 50 04             	mov    %edx,0x4(%eax)
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	8b 40 04             	mov    0x4(%eax),%eax
  802378:	85 c0                	test   %eax,%eax
  80237a:	74 0c                	je     802388 <insert_sorted_allocList+0x280>
  80237c:	a1 44 40 80 00       	mov    0x804044,%eax
  802381:	8b 55 08             	mov    0x8(%ebp),%edx
  802384:	89 10                	mov    %edx,(%eax)
  802386:	eb 08                	jmp    802390 <insert_sorted_allocList+0x288>
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	a3 40 40 80 00       	mov    %eax,0x804040
  802390:	8b 45 08             	mov    0x8(%ebp),%eax
  802393:	a3 44 40 80 00       	mov    %eax,0x804044
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023a1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023a6:	40                   	inc    %eax
  8023a7:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8023ac:	eb 36                	jmp    8023e4 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8023ae:	a1 48 40 80 00       	mov    0x804048,%eax
  8023b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ba:	74 07                	je     8023c3 <insert_sorted_allocList+0x2bb>
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 00                	mov    (%eax),%eax
  8023c1:	eb 05                	jmp    8023c8 <insert_sorted_allocList+0x2c0>
  8023c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c8:	a3 48 40 80 00       	mov    %eax,0x804048
  8023cd:	a1 48 40 80 00       	mov    0x804048,%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	0f 85 23 fe ff ff    	jne    8021fd <insert_sorted_allocList+0xf5>
  8023da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023de:	0f 85 19 fe ff ff    	jne    8021fd <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8023e4:	90                   	nop
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
  8023ea:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8023ed:	a1 38 41 80 00       	mov    0x804138,%eax
  8023f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f5:	e9 7c 01 00 00       	jmp    802576 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  8023fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802400:	3b 45 08             	cmp    0x8(%ebp),%eax
  802403:	0f 85 90 00 00 00    	jne    802499 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  80240f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802413:	75 17                	jne    80242c <alloc_block_FF+0x45>
  802415:	83 ec 04             	sub    $0x4,%esp
  802418:	68 9b 3b 80 00       	push   $0x803b9b
  80241d:	68 ba 00 00 00       	push   $0xba
  802422:	68 f3 3a 80 00       	push   $0x803af3
  802427:	e8 4b de ff ff       	call   800277 <_panic>
  80242c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242f:	8b 00                	mov    (%eax),%eax
  802431:	85 c0                	test   %eax,%eax
  802433:	74 10                	je     802445 <alloc_block_FF+0x5e>
  802435:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802438:	8b 00                	mov    (%eax),%eax
  80243a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80243d:	8b 52 04             	mov    0x4(%edx),%edx
  802440:	89 50 04             	mov    %edx,0x4(%eax)
  802443:	eb 0b                	jmp    802450 <alloc_block_FF+0x69>
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	8b 40 04             	mov    0x4(%eax),%eax
  80244b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	8b 40 04             	mov    0x4(%eax),%eax
  802456:	85 c0                	test   %eax,%eax
  802458:	74 0f                	je     802469 <alloc_block_FF+0x82>
  80245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245d:	8b 40 04             	mov    0x4(%eax),%eax
  802460:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802463:	8b 12                	mov    (%edx),%edx
  802465:	89 10                	mov    %edx,(%eax)
  802467:	eb 0a                	jmp    802473 <alloc_block_FF+0x8c>
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	8b 00                	mov    (%eax),%eax
  80246e:	a3 38 41 80 00       	mov    %eax,0x804138
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802486:	a1 44 41 80 00       	mov    0x804144,%eax
  80248b:	48                   	dec    %eax
  80248c:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  802491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802494:	e9 10 01 00 00       	jmp    8025a9 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 40 0c             	mov    0xc(%eax),%eax
  80249f:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024a2:	0f 86 c6 00 00 00    	jbe    80256e <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8024a8:	a1 48 41 80 00       	mov    0x804148,%eax
  8024ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8024b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024b4:	75 17                	jne    8024cd <alloc_block_FF+0xe6>
  8024b6:	83 ec 04             	sub    $0x4,%esp
  8024b9:	68 9b 3b 80 00       	push   $0x803b9b
  8024be:	68 c2 00 00 00       	push   $0xc2
  8024c3:	68 f3 3a 80 00       	push   $0x803af3
  8024c8:	e8 aa dd ff ff       	call   800277 <_panic>
  8024cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d0:	8b 00                	mov    (%eax),%eax
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	74 10                	je     8024e6 <alloc_block_FF+0xff>
  8024d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d9:	8b 00                	mov    (%eax),%eax
  8024db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024de:	8b 52 04             	mov    0x4(%edx),%edx
  8024e1:	89 50 04             	mov    %edx,0x4(%eax)
  8024e4:	eb 0b                	jmp    8024f1 <alloc_block_FF+0x10a>
  8024e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ec:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f4:	8b 40 04             	mov    0x4(%eax),%eax
  8024f7:	85 c0                	test   %eax,%eax
  8024f9:	74 0f                	je     80250a <alloc_block_FF+0x123>
  8024fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fe:	8b 40 04             	mov    0x4(%eax),%eax
  802501:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802504:	8b 12                	mov    (%edx),%edx
  802506:	89 10                	mov    %edx,(%eax)
  802508:	eb 0a                	jmp    802514 <alloc_block_FF+0x12d>
  80250a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	a3 48 41 80 00       	mov    %eax,0x804148
  802514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802517:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80251d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802520:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802527:	a1 54 41 80 00       	mov    0x804154,%eax
  80252c:	48                   	dec    %eax
  80252d:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 50 08             	mov    0x8(%eax),%edx
  802538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253b:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  80253e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802541:	8b 55 08             	mov    0x8(%ebp),%edx
  802544:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 40 0c             	mov    0xc(%eax),%eax
  80254d:	2b 45 08             	sub    0x8(%ebp),%eax
  802550:	89 c2                	mov    %eax,%edx
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 50 08             	mov    0x8(%eax),%edx
  80255e:	8b 45 08             	mov    0x8(%ebp),%eax
  802561:	01 c2                	add    %eax,%edx
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256c:	eb 3b                	jmp    8025a9 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80256e:	a1 40 41 80 00       	mov    0x804140,%eax
  802573:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802576:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257a:	74 07                	je     802583 <alloc_block_FF+0x19c>
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	8b 00                	mov    (%eax),%eax
  802581:	eb 05                	jmp    802588 <alloc_block_FF+0x1a1>
  802583:	b8 00 00 00 00       	mov    $0x0,%eax
  802588:	a3 40 41 80 00       	mov    %eax,0x804140
  80258d:	a1 40 41 80 00       	mov    0x804140,%eax
  802592:	85 c0                	test   %eax,%eax
  802594:	0f 85 60 fe ff ff    	jne    8023fa <alloc_block_FF+0x13>
  80259a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259e:	0f 85 56 fe ff ff    	jne    8023fa <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8025a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
  8025ae:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8025b1:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025b8:	a1 38 41 80 00       	mov    0x804138,%eax
  8025bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c0:	eb 3a                	jmp    8025fc <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025cb:	72 27                	jb     8025f4 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8025cd:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8025d1:	75 0b                	jne    8025de <alloc_block_BF+0x33>
					best_size= element->size;
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8025dc:	eb 16                	jmp    8025f4 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 50 0c             	mov    0xc(%eax),%edx
  8025e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e7:	39 c2                	cmp    %eax,%edx
  8025e9:	77 09                	ja     8025f4 <alloc_block_BF+0x49>
					best_size=element->size;
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f1:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025f4:	a1 40 41 80 00       	mov    0x804140,%eax
  8025f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802600:	74 07                	je     802609 <alloc_block_BF+0x5e>
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 00                	mov    (%eax),%eax
  802607:	eb 05                	jmp    80260e <alloc_block_BF+0x63>
  802609:	b8 00 00 00 00       	mov    $0x0,%eax
  80260e:	a3 40 41 80 00       	mov    %eax,0x804140
  802613:	a1 40 41 80 00       	mov    0x804140,%eax
  802618:	85 c0                	test   %eax,%eax
  80261a:	75 a6                	jne    8025c2 <alloc_block_BF+0x17>
  80261c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802620:	75 a0                	jne    8025c2 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802622:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802626:	0f 84 d3 01 00 00    	je     8027ff <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80262c:	a1 38 41 80 00       	mov    0x804138,%eax
  802631:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802634:	e9 98 01 00 00       	jmp    8027d1 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263f:	0f 86 da 00 00 00    	jbe    80271f <alloc_block_BF+0x174>
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 50 0c             	mov    0xc(%eax),%edx
  80264b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264e:	39 c2                	cmp    %eax,%edx
  802650:	0f 85 c9 00 00 00    	jne    80271f <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802656:	a1 48 41 80 00       	mov    0x804148,%eax
  80265b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80265e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802662:	75 17                	jne    80267b <alloc_block_BF+0xd0>
  802664:	83 ec 04             	sub    $0x4,%esp
  802667:	68 9b 3b 80 00       	push   $0x803b9b
  80266c:	68 ea 00 00 00       	push   $0xea
  802671:	68 f3 3a 80 00       	push   $0x803af3
  802676:	e8 fc db ff ff       	call   800277 <_panic>
  80267b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267e:	8b 00                	mov    (%eax),%eax
  802680:	85 c0                	test   %eax,%eax
  802682:	74 10                	je     802694 <alloc_block_BF+0xe9>
  802684:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802687:	8b 00                	mov    (%eax),%eax
  802689:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80268c:	8b 52 04             	mov    0x4(%edx),%edx
  80268f:	89 50 04             	mov    %edx,0x4(%eax)
  802692:	eb 0b                	jmp    80269f <alloc_block_BF+0xf4>
  802694:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802697:	8b 40 04             	mov    0x4(%eax),%eax
  80269a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80269f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a2:	8b 40 04             	mov    0x4(%eax),%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	74 0f                	je     8026b8 <alloc_block_BF+0x10d>
  8026a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ac:	8b 40 04             	mov    0x4(%eax),%eax
  8026af:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026b2:	8b 12                	mov    (%edx),%edx
  8026b4:	89 10                	mov    %edx,(%eax)
  8026b6:	eb 0a                	jmp    8026c2 <alloc_block_BF+0x117>
  8026b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bb:	8b 00                	mov    (%eax),%eax
  8026bd:	a3 48 41 80 00       	mov    %eax,0x804148
  8026c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d5:	a1 54 41 80 00       	mov    0x804154,%eax
  8026da:	48                   	dec    %eax
  8026db:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 50 08             	mov    0x8(%eax),%edx
  8026e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e9:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8026ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f2:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fb:	2b 45 08             	sub    0x8(%ebp),%eax
  8026fe:	89 c2                	mov    %eax,%edx
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802709:	8b 50 08             	mov    0x8(%eax),%edx
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	01 c2                	add    %eax,%edx
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802717:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271a:	e9 e5 00 00 00       	jmp    802804 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 50 0c             	mov    0xc(%eax),%edx
  802725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802728:	39 c2                	cmp    %eax,%edx
  80272a:	0f 85 99 00 00 00    	jne    8027c9 <alloc_block_BF+0x21e>
  802730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802733:	3b 45 08             	cmp    0x8(%ebp),%eax
  802736:	0f 85 8d 00 00 00    	jne    8027c9 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802742:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802746:	75 17                	jne    80275f <alloc_block_BF+0x1b4>
  802748:	83 ec 04             	sub    $0x4,%esp
  80274b:	68 9b 3b 80 00       	push   $0x803b9b
  802750:	68 f7 00 00 00       	push   $0xf7
  802755:	68 f3 3a 80 00       	push   $0x803af3
  80275a:	e8 18 db ff ff       	call   800277 <_panic>
  80275f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802762:	8b 00                	mov    (%eax),%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	74 10                	je     802778 <alloc_block_BF+0x1cd>
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802770:	8b 52 04             	mov    0x4(%edx),%edx
  802773:	89 50 04             	mov    %edx,0x4(%eax)
  802776:	eb 0b                	jmp    802783 <alloc_block_BF+0x1d8>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 40 04             	mov    0x4(%eax),%eax
  80277e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802786:	8b 40 04             	mov    0x4(%eax),%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	74 0f                	je     80279c <alloc_block_BF+0x1f1>
  80278d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802790:	8b 40 04             	mov    0x4(%eax),%eax
  802793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802796:	8b 12                	mov    (%edx),%edx
  802798:	89 10                	mov    %edx,(%eax)
  80279a:	eb 0a                	jmp    8027a6 <alloc_block_BF+0x1fb>
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	a3 38 41 80 00       	mov    %eax,0x804138
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b9:	a1 44 41 80 00       	mov    0x804144,%eax
  8027be:	48                   	dec    %eax
  8027bf:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8027c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c7:	eb 3b                	jmp    802804 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8027c9:	a1 40 41 80 00       	mov    0x804140,%eax
  8027ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d5:	74 07                	je     8027de <alloc_block_BF+0x233>
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 00                	mov    (%eax),%eax
  8027dc:	eb 05                	jmp    8027e3 <alloc_block_BF+0x238>
  8027de:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e3:	a3 40 41 80 00       	mov    %eax,0x804140
  8027e8:	a1 40 41 80 00       	mov    0x804140,%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	0f 85 44 fe ff ff    	jne    802639 <alloc_block_BF+0x8e>
  8027f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f9:	0f 85 3a fe ff ff    	jne    802639 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  8027ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802804:	c9                   	leave  
  802805:	c3                   	ret    

00802806 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
  802809:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80280c:	83 ec 04             	sub    $0x4,%esp
  80280f:	68 bc 3b 80 00       	push   $0x803bbc
  802814:	68 04 01 00 00       	push   $0x104
  802819:	68 f3 3a 80 00       	push   $0x803af3
  80281e:	e8 54 da ff ff       	call   800277 <_panic>

00802823 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802823:	55                   	push   %ebp
  802824:	89 e5                	mov    %esp,%ebp
  802826:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802829:	a1 38 41 80 00       	mov    0x804138,%eax
  80282e:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802831:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802836:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802839:	a1 38 41 80 00       	mov    0x804138,%eax
  80283e:	85 c0                	test   %eax,%eax
  802840:	75 68                	jne    8028aa <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802842:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802846:	75 17                	jne    80285f <insert_sorted_with_merge_freeList+0x3c>
  802848:	83 ec 04             	sub    $0x4,%esp
  80284b:	68 d0 3a 80 00       	push   $0x803ad0
  802850:	68 14 01 00 00       	push   $0x114
  802855:	68 f3 3a 80 00       	push   $0x803af3
  80285a:	e8 18 da ff ff       	call   800277 <_panic>
  80285f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802865:	8b 45 08             	mov    0x8(%ebp),%eax
  802868:	89 10                	mov    %edx,(%eax)
  80286a:	8b 45 08             	mov    0x8(%ebp),%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	85 c0                	test   %eax,%eax
  802871:	74 0d                	je     802880 <insert_sorted_with_merge_freeList+0x5d>
  802873:	a1 38 41 80 00       	mov    0x804138,%eax
  802878:	8b 55 08             	mov    0x8(%ebp),%edx
  80287b:	89 50 04             	mov    %edx,0x4(%eax)
  80287e:	eb 08                	jmp    802888 <insert_sorted_with_merge_freeList+0x65>
  802880:	8b 45 08             	mov    0x8(%ebp),%eax
  802883:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	a3 38 41 80 00       	mov    %eax,0x804138
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289a:	a1 44 41 80 00       	mov    0x804144,%eax
  80289f:	40                   	inc    %eax
  8028a0:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8028a5:	e9 d2 06 00 00       	jmp    802f7c <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8028aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ad:	8b 50 08             	mov    0x8(%eax),%edx
  8028b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b3:	8b 40 08             	mov    0x8(%eax),%eax
  8028b6:	39 c2                	cmp    %eax,%edx
  8028b8:	0f 83 22 01 00 00    	jae    8029e0 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8028be:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c1:	8b 50 08             	mov    0x8(%eax),%edx
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ca:	01 c2                	add    %eax,%edx
  8028cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cf:	8b 40 08             	mov    0x8(%eax),%eax
  8028d2:	39 c2                	cmp    %eax,%edx
  8028d4:	0f 85 9e 00 00 00    	jne    802978 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8028da:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dd:	8b 50 08             	mov    0x8(%eax),%edx
  8028e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e3:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8028e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f2:	01 c2                	add    %eax,%edx
  8028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f7:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802904:	8b 45 08             	mov    0x8(%ebp),%eax
  802907:	8b 50 08             	mov    0x8(%eax),%edx
  80290a:	8b 45 08             	mov    0x8(%ebp),%eax
  80290d:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802910:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802914:	75 17                	jne    80292d <insert_sorted_with_merge_freeList+0x10a>
  802916:	83 ec 04             	sub    $0x4,%esp
  802919:	68 d0 3a 80 00       	push   $0x803ad0
  80291e:	68 21 01 00 00       	push   $0x121
  802923:	68 f3 3a 80 00       	push   $0x803af3
  802928:	e8 4a d9 ff ff       	call   800277 <_panic>
  80292d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802933:	8b 45 08             	mov    0x8(%ebp),%eax
  802936:	89 10                	mov    %edx,(%eax)
  802938:	8b 45 08             	mov    0x8(%ebp),%eax
  80293b:	8b 00                	mov    (%eax),%eax
  80293d:	85 c0                	test   %eax,%eax
  80293f:	74 0d                	je     80294e <insert_sorted_with_merge_freeList+0x12b>
  802941:	a1 48 41 80 00       	mov    0x804148,%eax
  802946:	8b 55 08             	mov    0x8(%ebp),%edx
  802949:	89 50 04             	mov    %edx,0x4(%eax)
  80294c:	eb 08                	jmp    802956 <insert_sorted_with_merge_freeList+0x133>
  80294e:	8b 45 08             	mov    0x8(%ebp),%eax
  802951:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	a3 48 41 80 00       	mov    %eax,0x804148
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802968:	a1 54 41 80 00       	mov    0x804154,%eax
  80296d:	40                   	inc    %eax
  80296e:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802973:	e9 04 06 00 00       	jmp    802f7c <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802978:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80297c:	75 17                	jne    802995 <insert_sorted_with_merge_freeList+0x172>
  80297e:	83 ec 04             	sub    $0x4,%esp
  802981:	68 d0 3a 80 00       	push   $0x803ad0
  802986:	68 26 01 00 00       	push   $0x126
  80298b:	68 f3 3a 80 00       	push   $0x803af3
  802990:	e8 e2 d8 ff ff       	call   800277 <_panic>
  802995:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	89 10                	mov    %edx,(%eax)
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	8b 00                	mov    (%eax),%eax
  8029a5:	85 c0                	test   %eax,%eax
  8029a7:	74 0d                	je     8029b6 <insert_sorted_with_merge_freeList+0x193>
  8029a9:	a1 38 41 80 00       	mov    0x804138,%eax
  8029ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b1:	89 50 04             	mov    %edx,0x4(%eax)
  8029b4:	eb 08                	jmp    8029be <insert_sorted_with_merge_freeList+0x19b>
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	a3 38 41 80 00       	mov    %eax,0x804138
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d0:	a1 44 41 80 00       	mov    0x804144,%eax
  8029d5:	40                   	inc    %eax
  8029d6:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8029db:	e9 9c 05 00 00       	jmp    802f7c <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	8b 50 08             	mov    0x8(%eax),%edx
  8029e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e9:	8b 40 08             	mov    0x8(%eax),%eax
  8029ec:	39 c2                	cmp    %eax,%edx
  8029ee:	0f 86 16 01 00 00    	jbe    802b0a <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  8029f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f7:	8b 50 08             	mov    0x8(%eax),%edx
  8029fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802a00:	01 c2                	add    %eax,%edx
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	8b 40 08             	mov    0x8(%eax),%eax
  802a08:	39 c2                	cmp    %eax,%edx
  802a0a:	0f 85 92 00 00 00    	jne    802aa2 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802a10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a13:	8b 50 0c             	mov    0xc(%eax),%edx
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1c:	01 c2                	add    %eax,%edx
  802a1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a21:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	8b 50 08             	mov    0x8(%eax),%edx
  802a34:	8b 45 08             	mov    0x8(%ebp),%eax
  802a37:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a3e:	75 17                	jne    802a57 <insert_sorted_with_merge_freeList+0x234>
  802a40:	83 ec 04             	sub    $0x4,%esp
  802a43:	68 d0 3a 80 00       	push   $0x803ad0
  802a48:	68 31 01 00 00       	push   $0x131
  802a4d:	68 f3 3a 80 00       	push   $0x803af3
  802a52:	e8 20 d8 ff ff       	call   800277 <_panic>
  802a57:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	89 10                	mov    %edx,(%eax)
  802a62:	8b 45 08             	mov    0x8(%ebp),%eax
  802a65:	8b 00                	mov    (%eax),%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	74 0d                	je     802a78 <insert_sorted_with_merge_freeList+0x255>
  802a6b:	a1 48 41 80 00       	mov    0x804148,%eax
  802a70:	8b 55 08             	mov    0x8(%ebp),%edx
  802a73:	89 50 04             	mov    %edx,0x4(%eax)
  802a76:	eb 08                	jmp    802a80 <insert_sorted_with_merge_freeList+0x25d>
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	a3 48 41 80 00       	mov    %eax,0x804148
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a92:	a1 54 41 80 00       	mov    0x804154,%eax
  802a97:	40                   	inc    %eax
  802a98:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802a9d:	e9 da 04 00 00       	jmp    802f7c <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802aa2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa6:	75 17                	jne    802abf <insert_sorted_with_merge_freeList+0x29c>
  802aa8:	83 ec 04             	sub    $0x4,%esp
  802aab:	68 78 3b 80 00       	push   $0x803b78
  802ab0:	68 37 01 00 00       	push   $0x137
  802ab5:	68 f3 3a 80 00       	push   $0x803af3
  802aba:	e8 b8 d7 ff ff       	call   800277 <_panic>
  802abf:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	89 50 04             	mov    %edx,0x4(%eax)
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	8b 40 04             	mov    0x4(%eax),%eax
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	74 0c                	je     802ae1 <insert_sorted_with_merge_freeList+0x2be>
  802ad5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ada:	8b 55 08             	mov    0x8(%ebp),%edx
  802add:	89 10                	mov    %edx,(%eax)
  802adf:	eb 08                	jmp    802ae9 <insert_sorted_with_merge_freeList+0x2c6>
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	a3 38 41 80 00       	mov    %eax,0x804138
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afa:	a1 44 41 80 00       	mov    0x804144,%eax
  802aff:	40                   	inc    %eax
  802b00:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b05:	e9 72 04 00 00       	jmp    802f7c <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802b0a:	a1 38 41 80 00       	mov    0x804138,%eax
  802b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b12:	e9 35 04 00 00       	jmp    802f4c <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	8b 00                	mov    (%eax),%eax
  802b1c:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b22:	8b 50 08             	mov    0x8(%eax),%edx
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 40 08             	mov    0x8(%eax),%eax
  802b2b:	39 c2                	cmp    %eax,%edx
  802b2d:	0f 86 11 04 00 00    	jbe    802f44 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 50 08             	mov    0x8(%eax),%edx
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3f:	01 c2                	add    %eax,%edx
  802b41:	8b 45 08             	mov    0x8(%ebp),%eax
  802b44:	8b 40 08             	mov    0x8(%eax),%eax
  802b47:	39 c2                	cmp    %eax,%edx
  802b49:	0f 83 8b 00 00 00    	jae    802bda <insert_sorted_with_merge_freeList+0x3b7>
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	8b 50 08             	mov    0x8(%eax),%edx
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5b:	01 c2                	add    %eax,%edx
  802b5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b60:	8b 40 08             	mov    0x8(%eax),%eax
  802b63:	39 c2                	cmp    %eax,%edx
  802b65:	73 73                	jae    802bda <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802b67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b6b:	74 06                	je     802b73 <insert_sorted_with_merge_freeList+0x350>
  802b6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b71:	75 17                	jne    802b8a <insert_sorted_with_merge_freeList+0x367>
  802b73:	83 ec 04             	sub    $0x4,%esp
  802b76:	68 44 3b 80 00       	push   $0x803b44
  802b7b:	68 48 01 00 00       	push   $0x148
  802b80:	68 f3 3a 80 00       	push   $0x803af3
  802b85:	e8 ed d6 ff ff       	call   800277 <_panic>
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 10                	mov    (%eax),%edx
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	89 10                	mov    %edx,(%eax)
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	8b 00                	mov    (%eax),%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	74 0b                	je     802ba8 <insert_sorted_with_merge_freeList+0x385>
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 00                	mov    (%eax),%eax
  802ba2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba5:	89 50 04             	mov    %edx,0x4(%eax)
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	8b 55 08             	mov    0x8(%ebp),%edx
  802bae:	89 10                	mov    %edx,(%eax)
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb6:	89 50 04             	mov    %edx,0x4(%eax)
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	8b 00                	mov    (%eax),%eax
  802bbe:	85 c0                	test   %eax,%eax
  802bc0:	75 08                	jne    802bca <insert_sorted_with_merge_freeList+0x3a7>
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bca:	a1 44 41 80 00       	mov    0x804144,%eax
  802bcf:	40                   	inc    %eax
  802bd0:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802bd5:	e9 a2 03 00 00       	jmp    802f7c <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	8b 50 08             	mov    0x8(%eax),%edx
  802be0:	8b 45 08             	mov    0x8(%ebp),%eax
  802be3:	8b 40 0c             	mov    0xc(%eax),%eax
  802be6:	01 c2                	add    %eax,%edx
  802be8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802beb:	8b 40 08             	mov    0x8(%eax),%eax
  802bee:	39 c2                	cmp    %eax,%edx
  802bf0:	0f 83 ae 00 00 00    	jae    802ca4 <insert_sorted_with_merge_freeList+0x481>
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	8b 50 08             	mov    0x8(%eax),%edx
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 48 08             	mov    0x8(%eax),%ecx
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 40 0c             	mov    0xc(%eax),%eax
  802c08:	01 c8                	add    %ecx,%eax
  802c0a:	39 c2                	cmp    %eax,%edx
  802c0c:	0f 85 92 00 00 00    	jne    802ca4 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	8b 50 0c             	mov    0xc(%eax),%edx
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1e:	01 c2                	add    %eax,%edx
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	8b 50 08             	mov    0x8(%eax),%edx
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c40:	75 17                	jne    802c59 <insert_sorted_with_merge_freeList+0x436>
  802c42:	83 ec 04             	sub    $0x4,%esp
  802c45:	68 d0 3a 80 00       	push   $0x803ad0
  802c4a:	68 51 01 00 00       	push   $0x151
  802c4f:	68 f3 3a 80 00       	push   $0x803af3
  802c54:	e8 1e d6 ff ff       	call   800277 <_panic>
  802c59:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	89 10                	mov    %edx,(%eax)
  802c64:	8b 45 08             	mov    0x8(%ebp),%eax
  802c67:	8b 00                	mov    (%eax),%eax
  802c69:	85 c0                	test   %eax,%eax
  802c6b:	74 0d                	je     802c7a <insert_sorted_with_merge_freeList+0x457>
  802c6d:	a1 48 41 80 00       	mov    0x804148,%eax
  802c72:	8b 55 08             	mov    0x8(%ebp),%edx
  802c75:	89 50 04             	mov    %edx,0x4(%eax)
  802c78:	eb 08                	jmp    802c82 <insert_sorted_with_merge_freeList+0x45f>
  802c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	a3 48 41 80 00       	mov    %eax,0x804148
  802c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c94:	a1 54 41 80 00       	mov    0x804154,%eax
  802c99:	40                   	inc    %eax
  802c9a:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802c9f:	e9 d8 02 00 00       	jmp    802f7c <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	8b 50 08             	mov    0x8(%eax),%edx
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb0:	01 c2                	add    %eax,%edx
  802cb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb5:	8b 40 08             	mov    0x8(%eax),%eax
  802cb8:	39 c2                	cmp    %eax,%edx
  802cba:	0f 85 ba 00 00 00    	jne    802d7a <insert_sorted_with_merge_freeList+0x557>
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	8b 50 08             	mov    0x8(%eax),%edx
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 48 08             	mov    0x8(%eax),%ecx
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd2:	01 c8                	add    %ecx,%eax
  802cd4:	39 c2                	cmp    %eax,%edx
  802cd6:	0f 86 9e 00 00 00    	jbe    802d7a <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802cdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cdf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce8:	01 c2                	add    %eax,%edx
  802cea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ced:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	8b 50 08             	mov    0x8(%eax),%edx
  802cf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf9:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	8b 50 08             	mov    0x8(%eax),%edx
  802d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0f:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d16:	75 17                	jne    802d2f <insert_sorted_with_merge_freeList+0x50c>
  802d18:	83 ec 04             	sub    $0x4,%esp
  802d1b:	68 d0 3a 80 00       	push   $0x803ad0
  802d20:	68 5b 01 00 00       	push   $0x15b
  802d25:	68 f3 3a 80 00       	push   $0x803af3
  802d2a:	e8 48 d5 ff ff       	call   800277 <_panic>
  802d2f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	89 10                	mov    %edx,(%eax)
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	8b 00                	mov    (%eax),%eax
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	74 0d                	je     802d50 <insert_sorted_with_merge_freeList+0x52d>
  802d43:	a1 48 41 80 00       	mov    0x804148,%eax
  802d48:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4b:	89 50 04             	mov    %edx,0x4(%eax)
  802d4e:	eb 08                	jmp    802d58 <insert_sorted_with_merge_freeList+0x535>
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	a3 48 41 80 00       	mov    %eax,0x804148
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6a:	a1 54 41 80 00       	mov    0x804154,%eax
  802d6f:	40                   	inc    %eax
  802d70:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802d75:	e9 02 02 00 00       	jmp    802f7c <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	8b 50 08             	mov    0x8(%eax),%edx
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	8b 40 0c             	mov    0xc(%eax),%eax
  802d86:	01 c2                	add    %eax,%edx
  802d88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8b:	8b 40 08             	mov    0x8(%eax),%eax
  802d8e:	39 c2                	cmp    %eax,%edx
  802d90:	0f 85 ae 01 00 00    	jne    802f44 <insert_sorted_with_merge_freeList+0x721>
  802d96:	8b 45 08             	mov    0x8(%ebp),%eax
  802d99:	8b 50 08             	mov    0x8(%eax),%edx
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 48 08             	mov    0x8(%eax),%ecx
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 40 0c             	mov    0xc(%eax),%eax
  802da8:	01 c8                	add    %ecx,%eax
  802daa:	39 c2                	cmp    %eax,%edx
  802dac:	0f 85 92 01 00 00    	jne    802f44 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db5:	8b 50 0c             	mov    0xc(%eax),%edx
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbe:	01 c2                	add    %eax,%edx
  802dc0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc6:	01 c2                	add    %eax,%edx
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	8b 50 08             	mov    0x8(%eax),%edx
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802de4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802dee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df1:	8b 50 08             	mov    0x8(%eax),%edx
  802df4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df7:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802dfa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802dfe:	75 17                	jne    802e17 <insert_sorted_with_merge_freeList+0x5f4>
  802e00:	83 ec 04             	sub    $0x4,%esp
  802e03:	68 9b 3b 80 00       	push   $0x803b9b
  802e08:	68 63 01 00 00       	push   $0x163
  802e0d:	68 f3 3a 80 00       	push   $0x803af3
  802e12:	e8 60 d4 ff ff       	call   800277 <_panic>
  802e17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1a:	8b 00                	mov    (%eax),%eax
  802e1c:	85 c0                	test   %eax,%eax
  802e1e:	74 10                	je     802e30 <insert_sorted_with_merge_freeList+0x60d>
  802e20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e23:	8b 00                	mov    (%eax),%eax
  802e25:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e28:	8b 52 04             	mov    0x4(%edx),%edx
  802e2b:	89 50 04             	mov    %edx,0x4(%eax)
  802e2e:	eb 0b                	jmp    802e3b <insert_sorted_with_merge_freeList+0x618>
  802e30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e33:	8b 40 04             	mov    0x4(%eax),%eax
  802e36:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3e:	8b 40 04             	mov    0x4(%eax),%eax
  802e41:	85 c0                	test   %eax,%eax
  802e43:	74 0f                	je     802e54 <insert_sorted_with_merge_freeList+0x631>
  802e45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e48:	8b 40 04             	mov    0x4(%eax),%eax
  802e4b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e4e:	8b 12                	mov    (%edx),%edx
  802e50:	89 10                	mov    %edx,(%eax)
  802e52:	eb 0a                	jmp    802e5e <insert_sorted_with_merge_freeList+0x63b>
  802e54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e57:	8b 00                	mov    (%eax),%eax
  802e59:	a3 38 41 80 00       	mov    %eax,0x804138
  802e5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e61:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e71:	a1 44 41 80 00       	mov    0x804144,%eax
  802e76:	48                   	dec    %eax
  802e77:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802e7c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e80:	75 17                	jne    802e99 <insert_sorted_with_merge_freeList+0x676>
  802e82:	83 ec 04             	sub    $0x4,%esp
  802e85:	68 d0 3a 80 00       	push   $0x803ad0
  802e8a:	68 64 01 00 00       	push   $0x164
  802e8f:	68 f3 3a 80 00       	push   $0x803af3
  802e94:	e8 de d3 ff ff       	call   800277 <_panic>
  802e99:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea2:	89 10                	mov    %edx,(%eax)
  802ea4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea7:	8b 00                	mov    (%eax),%eax
  802ea9:	85 c0                	test   %eax,%eax
  802eab:	74 0d                	je     802eba <insert_sorted_with_merge_freeList+0x697>
  802ead:	a1 48 41 80 00       	mov    0x804148,%eax
  802eb2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eb5:	89 50 04             	mov    %edx,0x4(%eax)
  802eb8:	eb 08                	jmp    802ec2 <insert_sorted_with_merge_freeList+0x69f>
  802eba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ec2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec5:	a3 48 41 80 00       	mov    %eax,0x804148
  802eca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ecd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed4:	a1 54 41 80 00       	mov    0x804154,%eax
  802ed9:	40                   	inc    %eax
  802eda:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802edf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee3:	75 17                	jne    802efc <insert_sorted_with_merge_freeList+0x6d9>
  802ee5:	83 ec 04             	sub    $0x4,%esp
  802ee8:	68 d0 3a 80 00       	push   $0x803ad0
  802eed:	68 65 01 00 00       	push   $0x165
  802ef2:	68 f3 3a 80 00       	push   $0x803af3
  802ef7:	e8 7b d3 ff ff       	call   800277 <_panic>
  802efc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	89 10                	mov    %edx,(%eax)
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	8b 00                	mov    (%eax),%eax
  802f0c:	85 c0                	test   %eax,%eax
  802f0e:	74 0d                	je     802f1d <insert_sorted_with_merge_freeList+0x6fa>
  802f10:	a1 48 41 80 00       	mov    0x804148,%eax
  802f15:	8b 55 08             	mov    0x8(%ebp),%edx
  802f18:	89 50 04             	mov    %edx,0x4(%eax)
  802f1b:	eb 08                	jmp    802f25 <insert_sorted_with_merge_freeList+0x702>
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	a3 48 41 80 00       	mov    %eax,0x804148
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f37:	a1 54 41 80 00       	mov    0x804154,%eax
  802f3c:	40                   	inc    %eax
  802f3d:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802f42:	eb 38                	jmp    802f7c <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f44:	a1 40 41 80 00       	mov    0x804140,%eax
  802f49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f50:	74 07                	je     802f59 <insert_sorted_with_merge_freeList+0x736>
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	8b 00                	mov    (%eax),%eax
  802f57:	eb 05                	jmp    802f5e <insert_sorted_with_merge_freeList+0x73b>
  802f59:	b8 00 00 00 00       	mov    $0x0,%eax
  802f5e:	a3 40 41 80 00       	mov    %eax,0x804140
  802f63:	a1 40 41 80 00       	mov    0x804140,%eax
  802f68:	85 c0                	test   %eax,%eax
  802f6a:	0f 85 a7 fb ff ff    	jne    802b17 <insert_sorted_with_merge_freeList+0x2f4>
  802f70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f74:	0f 85 9d fb ff ff    	jne    802b17 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802f7a:	eb 00                	jmp    802f7c <insert_sorted_with_merge_freeList+0x759>
  802f7c:	90                   	nop
  802f7d:	c9                   	leave  
  802f7e:	c3                   	ret    

00802f7f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802f7f:	55                   	push   %ebp
  802f80:	89 e5                	mov    %esp,%ebp
  802f82:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802f85:	8b 55 08             	mov    0x8(%ebp),%edx
  802f88:	89 d0                	mov    %edx,%eax
  802f8a:	c1 e0 02             	shl    $0x2,%eax
  802f8d:	01 d0                	add    %edx,%eax
  802f8f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f96:	01 d0                	add    %edx,%eax
  802f98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802f9f:	01 d0                	add    %edx,%eax
  802fa1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fa8:	01 d0                	add    %edx,%eax
  802faa:	c1 e0 04             	shl    $0x4,%eax
  802fad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802fb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802fb7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802fba:	83 ec 0c             	sub    $0xc,%esp
  802fbd:	50                   	push   %eax
  802fbe:	e8 ee eb ff ff       	call   801bb1 <sys_get_virtual_time>
  802fc3:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802fc6:	eb 41                	jmp    803009 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802fc8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802fcb:	83 ec 0c             	sub    $0xc,%esp
  802fce:	50                   	push   %eax
  802fcf:	e8 dd eb ff ff       	call   801bb1 <sys_get_virtual_time>
  802fd4:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802fd7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802fda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdd:	29 c2                	sub    %eax,%edx
  802fdf:	89 d0                	mov    %edx,%eax
  802fe1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802fe4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fea:	89 d1                	mov    %edx,%ecx
  802fec:	29 c1                	sub    %eax,%ecx
  802fee:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ff1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff4:	39 c2                	cmp    %eax,%edx
  802ff6:	0f 97 c0             	seta   %al
  802ff9:	0f b6 c0             	movzbl %al,%eax
  802ffc:	29 c1                	sub    %eax,%ecx
  802ffe:	89 c8                	mov    %ecx,%eax
  803000:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803003:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803006:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80300f:	72 b7                	jb     802fc8 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803011:	90                   	nop
  803012:	c9                   	leave  
  803013:	c3                   	ret    

00803014 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803014:	55                   	push   %ebp
  803015:	89 e5                	mov    %esp,%ebp
  803017:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80301a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803021:	eb 03                	jmp    803026 <busy_wait+0x12>
  803023:	ff 45 fc             	incl   -0x4(%ebp)
  803026:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803029:	3b 45 08             	cmp    0x8(%ebp),%eax
  80302c:	72 f5                	jb     803023 <busy_wait+0xf>
	return i;
  80302e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803031:	c9                   	leave  
  803032:	c3                   	ret    
  803033:	90                   	nop

00803034 <__udivdi3>:
  803034:	55                   	push   %ebp
  803035:	57                   	push   %edi
  803036:	56                   	push   %esi
  803037:	53                   	push   %ebx
  803038:	83 ec 1c             	sub    $0x1c,%esp
  80303b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80303f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803043:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803047:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80304b:	89 ca                	mov    %ecx,%edx
  80304d:	89 f8                	mov    %edi,%eax
  80304f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803053:	85 f6                	test   %esi,%esi
  803055:	75 2d                	jne    803084 <__udivdi3+0x50>
  803057:	39 cf                	cmp    %ecx,%edi
  803059:	77 65                	ja     8030c0 <__udivdi3+0x8c>
  80305b:	89 fd                	mov    %edi,%ebp
  80305d:	85 ff                	test   %edi,%edi
  80305f:	75 0b                	jne    80306c <__udivdi3+0x38>
  803061:	b8 01 00 00 00       	mov    $0x1,%eax
  803066:	31 d2                	xor    %edx,%edx
  803068:	f7 f7                	div    %edi
  80306a:	89 c5                	mov    %eax,%ebp
  80306c:	31 d2                	xor    %edx,%edx
  80306e:	89 c8                	mov    %ecx,%eax
  803070:	f7 f5                	div    %ebp
  803072:	89 c1                	mov    %eax,%ecx
  803074:	89 d8                	mov    %ebx,%eax
  803076:	f7 f5                	div    %ebp
  803078:	89 cf                	mov    %ecx,%edi
  80307a:	89 fa                	mov    %edi,%edx
  80307c:	83 c4 1c             	add    $0x1c,%esp
  80307f:	5b                   	pop    %ebx
  803080:	5e                   	pop    %esi
  803081:	5f                   	pop    %edi
  803082:	5d                   	pop    %ebp
  803083:	c3                   	ret    
  803084:	39 ce                	cmp    %ecx,%esi
  803086:	77 28                	ja     8030b0 <__udivdi3+0x7c>
  803088:	0f bd fe             	bsr    %esi,%edi
  80308b:	83 f7 1f             	xor    $0x1f,%edi
  80308e:	75 40                	jne    8030d0 <__udivdi3+0x9c>
  803090:	39 ce                	cmp    %ecx,%esi
  803092:	72 0a                	jb     80309e <__udivdi3+0x6a>
  803094:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803098:	0f 87 9e 00 00 00    	ja     80313c <__udivdi3+0x108>
  80309e:	b8 01 00 00 00       	mov    $0x1,%eax
  8030a3:	89 fa                	mov    %edi,%edx
  8030a5:	83 c4 1c             	add    $0x1c,%esp
  8030a8:	5b                   	pop    %ebx
  8030a9:	5e                   	pop    %esi
  8030aa:	5f                   	pop    %edi
  8030ab:	5d                   	pop    %ebp
  8030ac:	c3                   	ret    
  8030ad:	8d 76 00             	lea    0x0(%esi),%esi
  8030b0:	31 ff                	xor    %edi,%edi
  8030b2:	31 c0                	xor    %eax,%eax
  8030b4:	89 fa                	mov    %edi,%edx
  8030b6:	83 c4 1c             	add    $0x1c,%esp
  8030b9:	5b                   	pop    %ebx
  8030ba:	5e                   	pop    %esi
  8030bb:	5f                   	pop    %edi
  8030bc:	5d                   	pop    %ebp
  8030bd:	c3                   	ret    
  8030be:	66 90                	xchg   %ax,%ax
  8030c0:	89 d8                	mov    %ebx,%eax
  8030c2:	f7 f7                	div    %edi
  8030c4:	31 ff                	xor    %edi,%edi
  8030c6:	89 fa                	mov    %edi,%edx
  8030c8:	83 c4 1c             	add    $0x1c,%esp
  8030cb:	5b                   	pop    %ebx
  8030cc:	5e                   	pop    %esi
  8030cd:	5f                   	pop    %edi
  8030ce:	5d                   	pop    %ebp
  8030cf:	c3                   	ret    
  8030d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030d5:	89 eb                	mov    %ebp,%ebx
  8030d7:	29 fb                	sub    %edi,%ebx
  8030d9:	89 f9                	mov    %edi,%ecx
  8030db:	d3 e6                	shl    %cl,%esi
  8030dd:	89 c5                	mov    %eax,%ebp
  8030df:	88 d9                	mov    %bl,%cl
  8030e1:	d3 ed                	shr    %cl,%ebp
  8030e3:	89 e9                	mov    %ebp,%ecx
  8030e5:	09 f1                	or     %esi,%ecx
  8030e7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030eb:	89 f9                	mov    %edi,%ecx
  8030ed:	d3 e0                	shl    %cl,%eax
  8030ef:	89 c5                	mov    %eax,%ebp
  8030f1:	89 d6                	mov    %edx,%esi
  8030f3:	88 d9                	mov    %bl,%cl
  8030f5:	d3 ee                	shr    %cl,%esi
  8030f7:	89 f9                	mov    %edi,%ecx
  8030f9:	d3 e2                	shl    %cl,%edx
  8030fb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030ff:	88 d9                	mov    %bl,%cl
  803101:	d3 e8                	shr    %cl,%eax
  803103:	09 c2                	or     %eax,%edx
  803105:	89 d0                	mov    %edx,%eax
  803107:	89 f2                	mov    %esi,%edx
  803109:	f7 74 24 0c          	divl   0xc(%esp)
  80310d:	89 d6                	mov    %edx,%esi
  80310f:	89 c3                	mov    %eax,%ebx
  803111:	f7 e5                	mul    %ebp
  803113:	39 d6                	cmp    %edx,%esi
  803115:	72 19                	jb     803130 <__udivdi3+0xfc>
  803117:	74 0b                	je     803124 <__udivdi3+0xf0>
  803119:	89 d8                	mov    %ebx,%eax
  80311b:	31 ff                	xor    %edi,%edi
  80311d:	e9 58 ff ff ff       	jmp    80307a <__udivdi3+0x46>
  803122:	66 90                	xchg   %ax,%ax
  803124:	8b 54 24 08          	mov    0x8(%esp),%edx
  803128:	89 f9                	mov    %edi,%ecx
  80312a:	d3 e2                	shl    %cl,%edx
  80312c:	39 c2                	cmp    %eax,%edx
  80312e:	73 e9                	jae    803119 <__udivdi3+0xe5>
  803130:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803133:	31 ff                	xor    %edi,%edi
  803135:	e9 40 ff ff ff       	jmp    80307a <__udivdi3+0x46>
  80313a:	66 90                	xchg   %ax,%ax
  80313c:	31 c0                	xor    %eax,%eax
  80313e:	e9 37 ff ff ff       	jmp    80307a <__udivdi3+0x46>
  803143:	90                   	nop

00803144 <__umoddi3>:
  803144:	55                   	push   %ebp
  803145:	57                   	push   %edi
  803146:	56                   	push   %esi
  803147:	53                   	push   %ebx
  803148:	83 ec 1c             	sub    $0x1c,%esp
  80314b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80314f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803153:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803157:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80315b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80315f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803163:	89 f3                	mov    %esi,%ebx
  803165:	89 fa                	mov    %edi,%edx
  803167:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80316b:	89 34 24             	mov    %esi,(%esp)
  80316e:	85 c0                	test   %eax,%eax
  803170:	75 1a                	jne    80318c <__umoddi3+0x48>
  803172:	39 f7                	cmp    %esi,%edi
  803174:	0f 86 a2 00 00 00    	jbe    80321c <__umoddi3+0xd8>
  80317a:	89 c8                	mov    %ecx,%eax
  80317c:	89 f2                	mov    %esi,%edx
  80317e:	f7 f7                	div    %edi
  803180:	89 d0                	mov    %edx,%eax
  803182:	31 d2                	xor    %edx,%edx
  803184:	83 c4 1c             	add    $0x1c,%esp
  803187:	5b                   	pop    %ebx
  803188:	5e                   	pop    %esi
  803189:	5f                   	pop    %edi
  80318a:	5d                   	pop    %ebp
  80318b:	c3                   	ret    
  80318c:	39 f0                	cmp    %esi,%eax
  80318e:	0f 87 ac 00 00 00    	ja     803240 <__umoddi3+0xfc>
  803194:	0f bd e8             	bsr    %eax,%ebp
  803197:	83 f5 1f             	xor    $0x1f,%ebp
  80319a:	0f 84 ac 00 00 00    	je     80324c <__umoddi3+0x108>
  8031a0:	bf 20 00 00 00       	mov    $0x20,%edi
  8031a5:	29 ef                	sub    %ebp,%edi
  8031a7:	89 fe                	mov    %edi,%esi
  8031a9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031ad:	89 e9                	mov    %ebp,%ecx
  8031af:	d3 e0                	shl    %cl,%eax
  8031b1:	89 d7                	mov    %edx,%edi
  8031b3:	89 f1                	mov    %esi,%ecx
  8031b5:	d3 ef                	shr    %cl,%edi
  8031b7:	09 c7                	or     %eax,%edi
  8031b9:	89 e9                	mov    %ebp,%ecx
  8031bb:	d3 e2                	shl    %cl,%edx
  8031bd:	89 14 24             	mov    %edx,(%esp)
  8031c0:	89 d8                	mov    %ebx,%eax
  8031c2:	d3 e0                	shl    %cl,%eax
  8031c4:	89 c2                	mov    %eax,%edx
  8031c6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ca:	d3 e0                	shl    %cl,%eax
  8031cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031d0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031d4:	89 f1                	mov    %esi,%ecx
  8031d6:	d3 e8                	shr    %cl,%eax
  8031d8:	09 d0                	or     %edx,%eax
  8031da:	d3 eb                	shr    %cl,%ebx
  8031dc:	89 da                	mov    %ebx,%edx
  8031de:	f7 f7                	div    %edi
  8031e0:	89 d3                	mov    %edx,%ebx
  8031e2:	f7 24 24             	mull   (%esp)
  8031e5:	89 c6                	mov    %eax,%esi
  8031e7:	89 d1                	mov    %edx,%ecx
  8031e9:	39 d3                	cmp    %edx,%ebx
  8031eb:	0f 82 87 00 00 00    	jb     803278 <__umoddi3+0x134>
  8031f1:	0f 84 91 00 00 00    	je     803288 <__umoddi3+0x144>
  8031f7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031fb:	29 f2                	sub    %esi,%edx
  8031fd:	19 cb                	sbb    %ecx,%ebx
  8031ff:	89 d8                	mov    %ebx,%eax
  803201:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803205:	d3 e0                	shl    %cl,%eax
  803207:	89 e9                	mov    %ebp,%ecx
  803209:	d3 ea                	shr    %cl,%edx
  80320b:	09 d0                	or     %edx,%eax
  80320d:	89 e9                	mov    %ebp,%ecx
  80320f:	d3 eb                	shr    %cl,%ebx
  803211:	89 da                	mov    %ebx,%edx
  803213:	83 c4 1c             	add    $0x1c,%esp
  803216:	5b                   	pop    %ebx
  803217:	5e                   	pop    %esi
  803218:	5f                   	pop    %edi
  803219:	5d                   	pop    %ebp
  80321a:	c3                   	ret    
  80321b:	90                   	nop
  80321c:	89 fd                	mov    %edi,%ebp
  80321e:	85 ff                	test   %edi,%edi
  803220:	75 0b                	jne    80322d <__umoddi3+0xe9>
  803222:	b8 01 00 00 00       	mov    $0x1,%eax
  803227:	31 d2                	xor    %edx,%edx
  803229:	f7 f7                	div    %edi
  80322b:	89 c5                	mov    %eax,%ebp
  80322d:	89 f0                	mov    %esi,%eax
  80322f:	31 d2                	xor    %edx,%edx
  803231:	f7 f5                	div    %ebp
  803233:	89 c8                	mov    %ecx,%eax
  803235:	f7 f5                	div    %ebp
  803237:	89 d0                	mov    %edx,%eax
  803239:	e9 44 ff ff ff       	jmp    803182 <__umoddi3+0x3e>
  80323e:	66 90                	xchg   %ax,%ax
  803240:	89 c8                	mov    %ecx,%eax
  803242:	89 f2                	mov    %esi,%edx
  803244:	83 c4 1c             	add    $0x1c,%esp
  803247:	5b                   	pop    %ebx
  803248:	5e                   	pop    %esi
  803249:	5f                   	pop    %edi
  80324a:	5d                   	pop    %ebp
  80324b:	c3                   	ret    
  80324c:	3b 04 24             	cmp    (%esp),%eax
  80324f:	72 06                	jb     803257 <__umoddi3+0x113>
  803251:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803255:	77 0f                	ja     803266 <__umoddi3+0x122>
  803257:	89 f2                	mov    %esi,%edx
  803259:	29 f9                	sub    %edi,%ecx
  80325b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80325f:	89 14 24             	mov    %edx,(%esp)
  803262:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803266:	8b 44 24 04          	mov    0x4(%esp),%eax
  80326a:	8b 14 24             	mov    (%esp),%edx
  80326d:	83 c4 1c             	add    $0x1c,%esp
  803270:	5b                   	pop    %ebx
  803271:	5e                   	pop    %esi
  803272:	5f                   	pop    %edi
  803273:	5d                   	pop    %ebp
  803274:	c3                   	ret    
  803275:	8d 76 00             	lea    0x0(%esi),%esi
  803278:	2b 04 24             	sub    (%esp),%eax
  80327b:	19 fa                	sbb    %edi,%edx
  80327d:	89 d1                	mov    %edx,%ecx
  80327f:	89 c6                	mov    %eax,%esi
  803281:	e9 71 ff ff ff       	jmp    8031f7 <__umoddi3+0xb3>
  803286:	66 90                	xchg   %ax,%ax
  803288:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80328c:	72 ea                	jb     803278 <__umoddi3+0x134>
  80328e:	89 d9                	mov    %ebx,%ecx
  803290:	e9 62 ff ff ff       	jmp    8031f7 <__umoddi3+0xb3>
