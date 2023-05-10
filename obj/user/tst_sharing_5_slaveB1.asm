
obj/user/tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 1e 01 00 00       	call   800154 <libmain>
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
  80003b:	83 ec 28             	sub    $0x28,%esp
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
  80008c:	68 c0 32 80 00       	push   $0x8032c0
  800091:	6a 12                	push   $0x12
  800093:	68 dc 32 80 00       	push   $0x8032dc
  800098:	e8 f3 01 00 00       	call   800290 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 c9 13 00 00       	call   801470 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 e8 1a 00 00       	call   801b97 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 f9 32 80 00       	push   $0x8032f9
  8000b7:	50                   	push   %eax
  8000b8:	e8 ab 15 00 00       	call   801668 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 fc 32 80 00       	push   $0x8032fc
  8000cb:	e8 74 04 00 00       	call   800544 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000d3:	e8 e4 1b 00 00       	call   801cbc <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 24 33 80 00       	push   $0x803324
  8000e0:	e8 5f 04 00 00       	call   800544 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 70 17 00 00       	push   $0x1770
  8000f0:	e8 a3 2e 00 00       	call   802f98 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp

	int freeFrames = sys_calculate_free_frames() ;
  8000f8:	e8 a1 17 00 00       	call   80189e <sys_calculate_free_frames>
  8000fd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 ec             	pushl  -0x14(%ebp)
  800106:	e8 33 16 00 00       	call   80173e <sfree>
  80010b:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	68 44 33 80 00       	push   $0x803344
  800116:	e8 29 04 00 00       	call   800544 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  80011e:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800125:	e8 74 17 00 00       	call   80189e <sys_calculate_free_frames>
  80012a:	89 c2                	mov    %eax,%edx
  80012c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80012f:	29 c2                	sub    %eax,%edx
  800131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800134:	39 c2                	cmp    %eax,%edx
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 5c 33 80 00       	push   $0x80335c
  800140:	6a 27                	push   $0x27
  800142:	68 dc 32 80 00       	push   $0x8032dc
  800147:	e8 44 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80014c:	e8 6b 1b 00 00       	call   801cbc <inctst>
	return;
  800151:	90                   	nop
}
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80015a:	e8 1f 1a 00 00       	call   801b7e <sys_getenvindex>
  80015f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800162:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800165:	89 d0                	mov    %edx,%eax
  800167:	c1 e0 03             	shl    $0x3,%eax
  80016a:	01 d0                	add    %edx,%eax
  80016c:	01 c0                	add    %eax,%eax
  80016e:	01 d0                	add    %edx,%eax
  800170:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800177:	01 d0                	add    %edx,%eax
  800179:	c1 e0 04             	shl    $0x4,%eax
  80017c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800181:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800186:	a1 20 40 80 00       	mov    0x804020,%eax
  80018b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800191:	84 c0                	test   %al,%al
  800193:	74 0f                	je     8001a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800195:	a1 20 40 80 00       	mov    0x804020,%eax
  80019a:	05 5c 05 00 00       	add    $0x55c,%eax
  80019f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a8:	7e 0a                	jle    8001b4 <libmain+0x60>
		binaryname = argv[0];
  8001aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ad:	8b 00                	mov    (%eax),%eax
  8001af:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	e8 76 fe ff ff       	call   800038 <_main>
  8001c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001c5:	e8 c1 17 00 00       	call   80198b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 1c 34 80 00       	push   $0x80341c
  8001d2:	e8 6d 03 00 00       	call   800544 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001da:	a1 20 40 80 00       	mov    0x804020,%eax
  8001df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	52                   	push   %edx
  8001f4:	50                   	push   %eax
  8001f5:	68 44 34 80 00       	push   $0x803444
  8001fa:	e8 45 03 00 00       	call   800544 <cprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800202:	a1 20 40 80 00       	mov    0x804020,%eax
  800207:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80020d:	a1 20 40 80 00       	mov    0x804020,%eax
  800212:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800218:	a1 20 40 80 00       	mov    0x804020,%eax
  80021d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800223:	51                   	push   %ecx
  800224:	52                   	push   %edx
  800225:	50                   	push   %eax
  800226:	68 6c 34 80 00       	push   $0x80346c
  80022b:	e8 14 03 00 00       	call   800544 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 c4 34 80 00       	push   $0x8034c4
  800247:	e8 f8 02 00 00       	call   800544 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 1c 34 80 00       	push   $0x80341c
  800257:	e8 e8 02 00 00       	call   800544 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025f:	e8 41 17 00 00       	call   8019a5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800264:	e8 19 00 00 00       	call   800282 <exit>
}
  800269:	90                   	nop
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	6a 00                	push   $0x0
  800277:	e8 ce 18 00 00       	call   801b4a <sys_destroy_env>
  80027c:	83 c4 10             	add    $0x10,%esp
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <exit>:

void
exit(void)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800288:	e8 23 19 00 00       	call   801bb0 <sys_exit_env>
}
  80028d:	90                   	nop
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800296:	8d 45 10             	lea    0x10(%ebp),%eax
  800299:	83 c0 04             	add    $0x4,%eax
  80029c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80029f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002a4:	85 c0                	test   %eax,%eax
  8002a6:	74 16                	je     8002be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	50                   	push   %eax
  8002b1:	68 d8 34 80 00       	push   $0x8034d8
  8002b6:	e8 89 02 00 00       	call   800544 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 00 40 80 00       	mov    0x804000,%eax
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 dd 34 80 00       	push   $0x8034dd
  8002cf:	e8 70 02 00 00       	call   800544 <cprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e0:	50                   	push   %eax
  8002e1:	e8 f3 01 00 00       	call   8004d9 <vcprintf>
  8002e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	6a 00                	push   $0x0
  8002ee:	68 f9 34 80 00       	push   $0x8034f9
  8002f3:	e8 e1 01 00 00       	call   8004d9 <vcprintf>
  8002f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002fb:	e8 82 ff ff ff       	call   800282 <exit>

	// should not return here
	while (1) ;
  800300:	eb fe                	jmp    800300 <_panic+0x70>

00800302 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800308:	a1 20 40 80 00       	mov    0x804020,%eax
  80030d:	8b 50 74             	mov    0x74(%eax),%edx
  800310:	8b 45 0c             	mov    0xc(%ebp),%eax
  800313:	39 c2                	cmp    %eax,%edx
  800315:	74 14                	je     80032b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800317:	83 ec 04             	sub    $0x4,%esp
  80031a:	68 fc 34 80 00       	push   $0x8034fc
  80031f:	6a 26                	push   $0x26
  800321:	68 48 35 80 00       	push   $0x803548
  800326:	e8 65 ff ff ff       	call   800290 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80032b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800332:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800339:	e9 c2 00 00 00       	jmp    800400 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80033e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800341:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	01 d0                	add    %edx,%eax
  80034d:	8b 00                	mov    (%eax),%eax
  80034f:	85 c0                	test   %eax,%eax
  800351:	75 08                	jne    80035b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800353:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800356:	e9 a2 00 00 00       	jmp    8003fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80035b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800362:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800369:	eb 69                	jmp    8003d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80036b:	a1 20 40 80 00       	mov    0x804020,%eax
  800370:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800376:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800379:	89 d0                	mov    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	01 d0                	add    %edx,%eax
  80037f:	c1 e0 03             	shl    $0x3,%eax
  800382:	01 c8                	add    %ecx,%eax
  800384:	8a 40 04             	mov    0x4(%eax),%al
  800387:	84 c0                	test   %al,%al
  800389:	75 46                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038b:	a1 20 40 80 00       	mov    0x804020,%eax
  800390:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800396:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800399:	89 d0                	mov    %edx,%eax
  80039b:	01 c0                	add    %eax,%eax
  80039d:	01 d0                	add    %edx,%eax
  80039f:	c1 e0 03             	shl    $0x3,%eax
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	8b 00                	mov    (%eax),%eax
  8003a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c4:	39 c2                	cmp    %eax,%edx
  8003c6:	75 09                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003cf:	eb 12                	jmp    8003e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d1:	ff 45 e8             	incl   -0x18(%ebp)
  8003d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d9:	8b 50 74             	mov    0x74(%eax),%edx
  8003dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003df:	39 c2                	cmp    %eax,%edx
  8003e1:	77 88                	ja     80036b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003e7:	75 14                	jne    8003fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	68 54 35 80 00       	push   $0x803554
  8003f1:	6a 3a                	push   $0x3a
  8003f3:	68 48 35 80 00       	push   $0x803548
  8003f8:	e8 93 fe ff ff       	call   800290 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003fd:	ff 45 f0             	incl   -0x10(%ebp)
  800400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800403:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800406:	0f 8c 32 ff ff ff    	jl     80033e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80040c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800413:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80041a:	eb 26                	jmp    800442 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80041c:	a1 20 40 80 00       	mov    0x804020,%eax
  800421:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800427:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042a:	89 d0                	mov    %edx,%eax
  80042c:	01 c0                	add    %eax,%eax
  80042e:	01 d0                	add    %edx,%eax
  800430:	c1 e0 03             	shl    $0x3,%eax
  800433:	01 c8                	add    %ecx,%eax
  800435:	8a 40 04             	mov    0x4(%eax),%al
  800438:	3c 01                	cmp    $0x1,%al
  80043a:	75 03                	jne    80043f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80043c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043f:	ff 45 e0             	incl   -0x20(%ebp)
  800442:	a1 20 40 80 00       	mov    0x804020,%eax
  800447:	8b 50 74             	mov    0x74(%eax),%edx
  80044a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044d:	39 c2                	cmp    %eax,%edx
  80044f:	77 cb                	ja     80041c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800454:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800457:	74 14                	je     80046d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	68 a8 35 80 00       	push   $0x8035a8
  800461:	6a 44                	push   $0x44
  800463:	68 48 35 80 00       	push   $0x803548
  800468:	e8 23 fe ff ff       	call   800290 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80046d:	90                   	nop
  80046e:	c9                   	leave  
  80046f:	c3                   	ret    

00800470 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	8d 48 01             	lea    0x1(%eax),%ecx
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	89 0a                	mov    %ecx,(%edx)
  800483:	8b 55 08             	mov    0x8(%ebp),%edx
  800486:	88 d1                	mov    %dl,%cl
  800488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80048f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	3d ff 00 00 00       	cmp    $0xff,%eax
  800499:	75 2c                	jne    8004c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80049b:	a0 24 40 80 00       	mov    0x804024,%al
  8004a0:	0f b6 c0             	movzbl %al,%eax
  8004a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a6:	8b 12                	mov    (%edx),%edx
  8004a8:	89 d1                	mov    %edx,%ecx
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	83 c2 08             	add    $0x8,%edx
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	50                   	push   %eax
  8004b4:	51                   	push   %ecx
  8004b5:	52                   	push   %edx
  8004b6:	e8 22 13 00 00       	call   8017dd <sys_cputs>
  8004bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ca:	8b 40 04             	mov    0x4(%eax),%eax
  8004cd:	8d 50 01             	lea    0x1(%eax),%edx
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004d6:	90                   	nop
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e9:	00 00 00 
	b.cnt = 0;
  8004ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004f6:	ff 75 0c             	pushl  0xc(%ebp)
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800502:	50                   	push   %eax
  800503:	68 70 04 80 00       	push   $0x800470
  800508:	e8 11 02 00 00       	call   80071e <vprintfmt>
  80050d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800510:	a0 24 40 80 00       	mov    0x804024,%al
  800515:	0f b6 c0             	movzbl %al,%eax
  800518:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	50                   	push   %eax
  800522:	52                   	push   %edx
  800523:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800529:	83 c0 08             	add    $0x8,%eax
  80052c:	50                   	push   %eax
  80052d:	e8 ab 12 00 00       	call   8017dd <sys_cputs>
  800532:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800535:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80053c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <cprintf>:

int cprintf(const char *fmt, ...) {
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80054a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800551:	8d 45 0c             	lea    0xc(%ebp),%eax
  800554:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	ff 75 f4             	pushl  -0xc(%ebp)
  800560:	50                   	push   %eax
  800561:	e8 73 ff ff ff       	call   8004d9 <vcprintf>
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800577:	e8 0f 14 00 00       	call   80198b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80057c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 f4             	pushl  -0xc(%ebp)
  80058b:	50                   	push   %eax
  80058c:	e8 48 ff ff ff       	call   8004d9 <vcprintf>
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800597:	e8 09 14 00 00       	call   8019a5 <sys_enable_interrupt>
	return cnt;
  80059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	53                   	push   %ebx
  8005a5:	83 ec 14             	sub    $0x14,%esp
  8005a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005bf:	77 55                	ja     800616 <printnum+0x75>
  8005c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c4:	72 05                	jb     8005cb <printnum+0x2a>
  8005c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c9:	77 4b                	ja     800616 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d9:	52                   	push   %edx
  8005da:	50                   	push   %eax
  8005db:	ff 75 f4             	pushl  -0xc(%ebp)
  8005de:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e1:	e8 66 2a 00 00       	call   80304c <__udivdi3>
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	83 ec 04             	sub    $0x4,%esp
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	53                   	push   %ebx
  8005f0:	ff 75 18             	pushl  0x18(%ebp)
  8005f3:	52                   	push   %edx
  8005f4:	50                   	push   %eax
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 08             	pushl  0x8(%ebp)
  8005fb:	e8 a1 ff ff ff       	call   8005a1 <printnum>
  800600:	83 c4 20             	add    $0x20,%esp
  800603:	eb 1a                	jmp    80061f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 20             	pushl  0x20(%ebp)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	ff d0                	call   *%eax
  800613:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800616:	ff 4d 1c             	decl   0x1c(%ebp)
  800619:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80061d:	7f e6                	jg     800605 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80061f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800622:	bb 00 00 00 00       	mov    $0x0,%ebx
  800627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062d:	53                   	push   %ebx
  80062e:	51                   	push   %ecx
  80062f:	52                   	push   %edx
  800630:	50                   	push   %eax
  800631:	e8 26 2b 00 00       	call   80315c <__umoddi3>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	05 14 38 80 00       	add    $0x803814,%eax
  80063e:	8a 00                	mov    (%eax),%al
  800640:	0f be c0             	movsbl %al,%eax
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	50                   	push   %eax
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	ff d0                	call   *%eax
  80064f:	83 c4 10             	add    $0x10,%esp
}
  800652:	90                   	nop
  800653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800656:	c9                   	leave  
  800657:	c3                   	ret    

00800658 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80065b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80065f:	7e 1c                	jle    80067d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	8d 50 08             	lea    0x8(%eax),%edx
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	89 10                	mov    %edx,(%eax)
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	83 e8 08             	sub    $0x8,%eax
  800676:	8b 50 04             	mov    0x4(%eax),%edx
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	eb 40                	jmp    8006bd <getuint+0x65>
	else if (lflag)
  80067d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800681:	74 1e                	je     8006a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 04             	lea    0x4(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	ba 00 00 00 00       	mov    $0x0,%edx
  80069f:	eb 1c                	jmp    8006bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 50 04             	lea    0x4(%eax),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	89 10                	mov    %edx,(%eax)
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	83 e8 04             	sub    $0x4,%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006bd:	5d                   	pop    %ebp
  8006be:	c3                   	ret    

008006bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c6:	7e 1c                	jle    8006e4 <getint+0x25>
		return va_arg(*ap, long long);
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	8d 50 08             	lea    0x8(%eax),%edx
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	89 10                	mov    %edx,(%eax)
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	83 e8 08             	sub    $0x8,%eax
  8006dd:	8b 50 04             	mov    0x4(%eax),%edx
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	eb 38                	jmp    80071c <getint+0x5d>
	else if (lflag)
  8006e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e8:	74 1a                	je     800704 <getint+0x45>
		return va_arg(*ap, long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 04             	lea    0x4(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 04             	sub    $0x4,%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	99                   	cltd   
  800702:	eb 18                	jmp    80071c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 04             	lea    0x4(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 04             	sub    $0x4,%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	99                   	cltd   
}
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	56                   	push   %esi
  800722:	53                   	push   %ebx
  800723:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	eb 17                	jmp    80073f <vprintfmt+0x21>
			if (ch == '\0')
  800728:	85 db                	test   %ebx,%ebx
  80072a:	0f 84 af 03 00 00    	je     800adf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	53                   	push   %ebx
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073f:	8b 45 10             	mov    0x10(%ebp),%eax
  800742:	8d 50 01             	lea    0x1(%eax),%edx
  800745:	89 55 10             	mov    %edx,0x10(%ebp)
  800748:	8a 00                	mov    (%eax),%al
  80074a:	0f b6 d8             	movzbl %al,%ebx
  80074d:	83 fb 25             	cmp    $0x25,%ebx
  800750:	75 d6                	jne    800728 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800752:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800756:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80075d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800764:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80076b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	8d 50 01             	lea    0x1(%eax),%edx
  800778:	89 55 10             	mov    %edx,0x10(%ebp)
  80077b:	8a 00                	mov    (%eax),%al
  80077d:	0f b6 d8             	movzbl %al,%ebx
  800780:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800783:	83 f8 55             	cmp    $0x55,%eax
  800786:	0f 87 2b 03 00 00    	ja     800ab7 <vprintfmt+0x399>
  80078c:	8b 04 85 38 38 80 00 	mov    0x803838(,%eax,4),%eax
  800793:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800795:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800799:	eb d7                	jmp    800772 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80079f:	eb d1                	jmp    800772 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ab:	89 d0                	mov    %edx,%eax
  8007ad:	c1 e0 02             	shl    $0x2,%eax
  8007b0:	01 d0                	add    %edx,%eax
  8007b2:	01 c0                	add    %eax,%eax
  8007b4:	01 d8                	add    %ebx,%eax
  8007b6:	83 e8 30             	sub    $0x30,%eax
  8007b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bf:	8a 00                	mov    (%eax),%al
  8007c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c7:	7e 3e                	jle    800807 <vprintfmt+0xe9>
  8007c9:	83 fb 39             	cmp    $0x39,%ebx
  8007cc:	7f 39                	jg     800807 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d1:	eb d5                	jmp    8007a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	83 c0 04             	add    $0x4,%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	83 e8 04             	sub    $0x4,%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e7:	eb 1f                	jmp    800808 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	79 83                	jns    800772 <vprintfmt+0x54>
				width = 0;
  8007ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f6:	e9 77 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800802:	e9 6b ff ff ff       	jmp    800772 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800807:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800808:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080c:	0f 89 60 ff ff ff    	jns    800772 <vprintfmt+0x54>
				width = precision, precision = -1;
  800812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800818:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80081f:	e9 4e ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800824:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800827:	e9 46 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			break;
  80084c:	e9 89 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800862:	85 db                	test   %ebx,%ebx
  800864:	79 02                	jns    800868 <vprintfmt+0x14a>
				err = -err;
  800866:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800868:	83 fb 64             	cmp    $0x64,%ebx
  80086b:	7f 0b                	jg     800878 <vprintfmt+0x15a>
  80086d:	8b 34 9d 80 36 80 00 	mov    0x803680(,%ebx,4),%esi
  800874:	85 f6                	test   %esi,%esi
  800876:	75 19                	jne    800891 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800878:	53                   	push   %ebx
  800879:	68 25 38 80 00       	push   $0x803825
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 5e 02 00 00       	call   800ae7 <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80088c:	e9 49 02 00 00       	jmp    800ada <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800891:	56                   	push   %esi
  800892:	68 2e 38 80 00       	push   $0x80382e
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	ff 75 08             	pushl  0x8(%ebp)
  80089d:	e8 45 02 00 00       	call   800ae7 <printfmt>
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 30 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 30                	mov    (%eax),%esi
  8008bb:	85 f6                	test   %esi,%esi
  8008bd:	75 05                	jne    8008c4 <vprintfmt+0x1a6>
				p = "(null)";
  8008bf:	be 31 38 80 00       	mov    $0x803831,%esi
			if (width > 0 && padc != '-')
  8008c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c8:	7e 6d                	jle    800937 <vprintfmt+0x219>
  8008ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ce:	74 67                	je     800937 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	50                   	push   %eax
  8008d7:	56                   	push   %esi
  8008d8:	e8 0c 03 00 00       	call   800be9 <strnlen>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e3:	eb 16                	jmp    8008fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	50                   	push   %eax
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	ff d0                	call   *%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ff:	7f e4                	jg     8008e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800901:	eb 34                	jmp    800937 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800903:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800907:	74 1c                	je     800925 <vprintfmt+0x207>
  800909:	83 fb 1f             	cmp    $0x1f,%ebx
  80090c:	7e 05                	jle    800913 <vprintfmt+0x1f5>
  80090e:	83 fb 7e             	cmp    $0x7e,%ebx
  800911:	7e 12                	jle    800925 <vprintfmt+0x207>
					putch('?', putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	6a 3f                	push   $0x3f
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	eb 0f                	jmp    800934 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	53                   	push   %ebx
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800934:	ff 4d e4             	decl   -0x1c(%ebp)
  800937:	89 f0                	mov    %esi,%eax
  800939:	8d 70 01             	lea    0x1(%eax),%esi
  80093c:	8a 00                	mov    (%eax),%al
  80093e:	0f be d8             	movsbl %al,%ebx
  800941:	85 db                	test   %ebx,%ebx
  800943:	74 24                	je     800969 <vprintfmt+0x24b>
  800945:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800949:	78 b8                	js     800903 <vprintfmt+0x1e5>
  80094b:	ff 4d e0             	decl   -0x20(%ebp)
  80094e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800952:	79 af                	jns    800903 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800954:	eb 13                	jmp    800969 <vprintfmt+0x24b>
				putch(' ', putdat);
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	6a 20                	push   $0x20
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	ff d0                	call   *%eax
  800963:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800966:	ff 4d e4             	decl   -0x1c(%ebp)
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7f e7                	jg     800956 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80096f:	e9 66 01 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 e8             	pushl  -0x18(%ebp)
  80097a:	8d 45 14             	lea    0x14(%ebp),%eax
  80097d:	50                   	push   %eax
  80097e:	e8 3c fd ff ff       	call   8006bf <getint>
  800983:	83 c4 10             	add    $0x10,%esp
  800986:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800989:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80098c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800992:	85 d2                	test   %edx,%edx
  800994:	79 23                	jns    8009b9 <vprintfmt+0x29b>
				putch('-', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	6a 2d                	push   $0x2d
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ac:	f7 d8                	neg    %eax
  8009ae:	83 d2 00             	adc    $0x0,%edx
  8009b1:	f7 da                	neg    %edx
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c0:	e9 bc 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ce:	50                   	push   %eax
  8009cf:	e8 84 fc ff ff       	call   800658 <getuint>
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e4:	e9 98 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 58                	push   $0x58
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 58                	push   $0x58
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	6a 58                	push   $0x58
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	ff d0                	call   *%eax
  800a16:	83 c4 10             	add    $0x10,%esp
			break;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 30                	push   $0x30
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 78                	push   $0x78
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 c0 04             	add    $0x4,%eax
  800a44:	89 45 14             	mov    %eax,0x14(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	83 e8 04             	sub    $0x4,%eax
  800a4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a60:	eb 1f                	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 e7 fb ff ff       	call   800658 <getuint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a88:	83 ec 04             	sub    $0x4,%esp
  800a8b:	52                   	push   %edx
  800a8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a8f:	50                   	push   %eax
  800a90:	ff 75 f4             	pushl  -0xc(%ebp)
  800a93:	ff 75 f0             	pushl  -0x10(%ebp)
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 08             	pushl  0x8(%ebp)
  800a9c:	e8 00 fb ff ff       	call   8005a1 <printnum>
  800aa1:	83 c4 20             	add    $0x20,%esp
			break;
  800aa4:	eb 34                	jmp    800ada <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	53                   	push   %ebx
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	ff d0                	call   *%eax
  800ab2:	83 c4 10             	add    $0x10,%esp
			break;
  800ab5:	eb 23                	jmp    800ada <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 25                	push   $0x25
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac7:	ff 4d 10             	decl   0x10(%ebp)
  800aca:	eb 03                	jmp    800acf <vprintfmt+0x3b1>
  800acc:	ff 4d 10             	decl   0x10(%ebp)
  800acf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad2:	48                   	dec    %eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	3c 25                	cmp    $0x25,%al
  800ad7:	75 f3                	jne    800acc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ad9:	90                   	nop
		}
	}
  800ada:	e9 47 fc ff ff       	jmp    800726 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800adf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae3:	5b                   	pop    %ebx
  800ae4:	5e                   	pop    %esi
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aed:	8d 45 10             	lea    0x10(%ebp),%eax
  800af0:	83 c0 04             	add    $0x4,%eax
  800af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af6:	8b 45 10             	mov    0x10(%ebp),%eax
  800af9:	ff 75 f4             	pushl  -0xc(%ebp)
  800afc:	50                   	push   %eax
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	e8 16 fc ff ff       	call   80071e <vprintfmt>
  800b08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0b:	90                   	nop
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 40 08             	mov    0x8(%eax),%eax
  800b17:	8d 50 01             	lea    0x1(%eax),%edx
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	8b 10                	mov    (%eax),%edx
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	8b 40 04             	mov    0x4(%eax),%eax
  800b2b:	39 c2                	cmp    %eax,%edx
  800b2d:	73 12                	jae    800b41 <sprintputch+0x33>
		*b->buf++ = ch;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 48 01             	lea    0x1(%eax),%ecx
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	89 0a                	mov    %ecx,(%edx)
  800b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3f:	88 10                	mov    %dl,(%eax)
}
  800b41:	90                   	nop
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	01 d0                	add    %edx,%eax
  800b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b69:	74 06                	je     800b71 <vsnprintf+0x2d>
  800b6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6f:	7f 07                	jg     800b78 <vsnprintf+0x34>
		return -E_INVAL;
  800b71:	b8 03 00 00 00       	mov    $0x3,%eax
  800b76:	eb 20                	jmp    800b98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b78:	ff 75 14             	pushl  0x14(%ebp)
  800b7b:	ff 75 10             	pushl  0x10(%ebp)
  800b7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b81:	50                   	push   %eax
  800b82:	68 0e 0b 80 00       	push   $0x800b0e
  800b87:	e8 92 fb ff ff       	call   80071e <vprintfmt>
  800b8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba3:	83 c0 04             	add    $0x4,%eax
  800ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	ff 75 f4             	pushl  -0xc(%ebp)
  800baf:	50                   	push   %eax
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	ff 75 08             	pushl  0x8(%ebp)
  800bb6:	e8 89 ff ff ff       	call   800b44 <vsnprintf>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd3:	eb 06                	jmp    800bdb <strlen+0x15>
		n++;
  800bd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 f1                	jne    800bd5 <strlen+0xf>
		n++;
	return n;
  800be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf6:	eb 09                	jmp    800c01 <strnlen+0x18>
		n++;
  800bf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfb:	ff 45 08             	incl   0x8(%ebp)
  800bfe:	ff 4d 0c             	decl   0xc(%ebp)
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	74 09                	je     800c10 <strnlen+0x27>
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 e8                	jne    800bf8 <strnlen+0xf>
		n++;
	return n;
  800c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c13:	c9                   	leave  
  800c14:	c3                   	ret    

00800c15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c21:	90                   	nop
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8d 50 01             	lea    0x1(%eax),%edx
  800c28:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c34:	8a 12                	mov    (%edx),%dl
  800c36:	88 10                	mov    %dl,(%eax)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	84 c0                	test   %al,%al
  800c3c:	75 e4                	jne    800c22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c56:	eb 1f                	jmp    800c77 <strncpy+0x34>
		*dst++ = *src;
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8a 12                	mov    (%edx),%dl
  800c66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	84 c0                	test   %al,%al
  800c6f:	74 03                	je     800c74 <strncpy+0x31>
			src++;
  800c71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c74:	ff 45 fc             	incl   -0x4(%ebp)
  800c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7d:	72 d9                	jb     800c58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c94:	74 30                	je     800cc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c96:	eb 16                	jmp    800cae <strlcpy+0x2a>
			*dst++ = *src++;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8d 50 01             	lea    0x1(%eax),%edx
  800c9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800caa:	8a 12                	mov    (%edx),%dl
  800cac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cae:	ff 4d 10             	decl   0x10(%ebp)
  800cb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb5:	74 09                	je     800cc0 <strlcpy+0x3c>
  800cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	84 c0                	test   %al,%al
  800cbe:	75 d8                	jne    800c98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccc:	29 c2                	sub    %eax,%edx
  800cce:	89 d0                	mov    %edx,%eax
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd5:	eb 06                	jmp    800cdd <strcmp+0xb>
		p++, q++;
  800cd7:	ff 45 08             	incl   0x8(%ebp)
  800cda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	74 0e                	je     800cf4 <strcmp+0x22>
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 10                	mov    (%eax),%dl
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	38 c2                	cmp    %al,%dl
  800cf2:	74 e3                	je     800cd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	0f b6 d0             	movzbl %al,%edx
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	0f b6 c0             	movzbl %al,%eax
  800d04:	29 c2                	sub    %eax,%edx
  800d06:	89 d0                	mov    %edx,%eax
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0d:	eb 09                	jmp    800d18 <strncmp+0xe>
		n--, p++, q++;
  800d0f:	ff 4d 10             	decl   0x10(%ebp)
  800d12:	ff 45 08             	incl   0x8(%ebp)
  800d15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1c:	74 17                	je     800d35 <strncmp+0x2b>
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strncmp+0x2b>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 da                	je     800d0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	75 07                	jne    800d42 <strncmp+0x38>
		return 0;
  800d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d40:	eb 14                	jmp    800d56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	0f b6 d0             	movzbl %al,%edx
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	0f b6 c0             	movzbl %al,%eax
  800d52:	29 c2                	sub    %eax,%edx
  800d54:	89 d0                	mov    %edx,%eax
}
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d64:	eb 12                	jmp    800d78 <strchr+0x20>
		if (*s == c)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6e:	75 05                	jne    800d75 <strchr+0x1d>
			return (char *) s;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	eb 11                	jmp    800d86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	84 c0                	test   %al,%al
  800d7f:	75 e5                	jne    800d66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 04             	sub    $0x4,%esp
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d94:	eb 0d                	jmp    800da3 <strfind+0x1b>
		if (*s == c)
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9e:	74 0e                	je     800dae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	75 ea                	jne    800d96 <strfind+0xe>
  800dac:	eb 01                	jmp    800daf <strfind+0x27>
		if (*s == c)
			break;
  800dae:	90                   	nop
	return (char *) s;
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dc6:	eb 0e                	jmp    800dd6 <memset+0x22>
		*p++ = c;
  800dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcb:	8d 50 01             	lea    0x1(%eax),%edx
  800dce:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dd6:	ff 4d f8             	decl   -0x8(%ebp)
  800dd9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ddd:	79 e9                	jns    800dc8 <memset+0x14>
		*p++ = c;

	return v;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800df6:	eb 16                	jmp    800e0e <memcpy+0x2a>
		*d++ = *s++;
  800df8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfb:	8d 50 01             	lea    0x1(%eax),%edx
  800dfe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e0a:	8a 12                	mov    (%edx),%dl
  800e0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e14:	89 55 10             	mov    %edx,0x10(%ebp)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	75 dd                	jne    800df8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e38:	73 50                	jae    800e8a <memmove+0x6a>
  800e3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e45:	76 43                	jbe    800e8a <memmove+0x6a>
		s += n;
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e53:	eb 10                	jmp    800e65 <memmove+0x45>
			*--d = *--s;
  800e55:	ff 4d f8             	decl   -0x8(%ebp)
  800e58:	ff 4d fc             	decl   -0x4(%ebp)
  800e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5e:	8a 10                	mov    (%eax),%dl
  800e60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	75 e3                	jne    800e55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e72:	eb 23                	jmp    800e97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e77:	8d 50 01             	lea    0x1(%eax),%edx
  800e7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e86:	8a 12                	mov    (%edx),%dl
  800e88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e90:	89 55 10             	mov    %edx,0x10(%ebp)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	75 dd                	jne    800e74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eae:	eb 2a                	jmp    800eda <memcmp+0x3e>
		if (*s1 != *s2)
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 10                	mov    (%eax),%dl
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	38 c2                	cmp    %al,%dl
  800ebc:	74 16                	je     800ed4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	0f b6 d0             	movzbl %al,%edx
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f b6 c0             	movzbl %al,%eax
  800ece:	29 c2                	sub    %eax,%edx
  800ed0:	89 d0                	mov    %edx,%eax
  800ed2:	eb 18                	jmp    800eec <memcmp+0x50>
		s1++, s2++;
  800ed4:	ff 45 fc             	incl   -0x4(%ebp)
  800ed7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eda:	8b 45 10             	mov    0x10(%ebp),%eax
  800edd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	75 c9                	jne    800eb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  800efa:	01 d0                	add    %edx,%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eff:	eb 15                	jmp    800f16 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	0f b6 d0             	movzbl %al,%edx
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	39 c2                	cmp    %eax,%edx
  800f11:	74 0d                	je     800f20 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f13:	ff 45 08             	incl   0x8(%ebp)
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f1c:	72 e3                	jb     800f01 <memfind+0x13>
  800f1e:	eb 01                	jmp    800f21 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f20:	90                   	nop
	return (void *) s;
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3a:	eb 03                	jmp    800f3f <strtol+0x19>
		s++;
  800f3c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 20                	cmp    $0x20,%al
  800f46:	74 f4                	je     800f3c <strtol+0x16>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 09                	cmp    $0x9,%al
  800f4f:	74 eb                	je     800f3c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2b                	cmp    $0x2b,%al
  800f58:	75 05                	jne    800f5f <strtol+0x39>
		s++;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	eb 13                	jmp    800f72 <strtol+0x4c>
	else if (*s == '-')
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 2d                	cmp    $0x2d,%al
  800f66:	75 0a                	jne    800f72 <strtol+0x4c>
		s++, neg = 1;
  800f68:	ff 45 08             	incl   0x8(%ebp)
  800f6b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f76:	74 06                	je     800f7e <strtol+0x58>
  800f78:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f7c:	75 20                	jne    800f9e <strtol+0x78>
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 30                	cmp    $0x30,%al
  800f85:	75 17                	jne    800f9e <strtol+0x78>
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	40                   	inc    %eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3c 78                	cmp    $0x78,%al
  800f8f:	75 0d                	jne    800f9e <strtol+0x78>
		s += 2, base = 16;
  800f91:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f95:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f9c:	eb 28                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa2:	75 15                	jne    800fb9 <strtol+0x93>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 0c                	jne    800fb9 <strtol+0x93>
		s++, base = 8;
  800fad:	ff 45 08             	incl   0x8(%ebp)
  800fb0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb7:	eb 0d                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0)
  800fb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbd:	75 07                	jne    800fc6 <strtol+0xa0>
		base = 10;
  800fbf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 2f                	cmp    $0x2f,%al
  800fcd:	7e 19                	jle    800fe8 <strtol+0xc2>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 39                	cmp    $0x39,%al
  800fd6:	7f 10                	jg     800fe8 <strtol+0xc2>
			dig = *s - '0';
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 30             	sub    $0x30,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe6:	eb 42                	jmp    80102a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 60                	cmp    $0x60,%al
  800fef:	7e 19                	jle    80100a <strtol+0xe4>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 7a                	cmp    $0x7a,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 57             	sub    $0x57,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 20                	jmp    80102a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 40                	cmp    $0x40,%al
  801011:	7e 39                	jle    80104c <strtol+0x126>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 5a                	cmp    $0x5a,%al
  80101a:	7f 30                	jg     80104c <strtol+0x126>
			dig = *s - 'A' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 37             	sub    $0x37,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80102a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801030:	7d 19                	jge    80104b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801038:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103c:	89 c2                	mov    %eax,%edx
  80103e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801041:	01 d0                	add    %edx,%eax
  801043:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801046:	e9 7b ff ff ff       	jmp    800fc6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80104b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80104c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801050:	74 08                	je     80105a <strtol+0x134>
		*endptr = (char *) s;
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80105a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105e:	74 07                	je     801067 <strtol+0x141>
  801060:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801063:	f7 d8                	neg    %eax
  801065:	eb 03                	jmp    80106a <strtol+0x144>
  801067:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <ltostr>:

void
ltostr(long value, char *str)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801079:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801080:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801084:	79 13                	jns    801099 <ltostr+0x2d>
	{
		neg = 1;
  801086:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801093:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801096:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a1:	99                   	cltd   
  8010a2:	f7 f9                	idiv   %ecx
  8010a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010aa:	8d 50 01             	lea    0x1(%eax),%edx
  8010ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b0:	89 c2                	mov    %eax,%edx
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	01 d0                	add    %edx,%eax
  8010b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ba:	83 c2 30             	add    $0x30,%edx
  8010bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e0:	f7 e9                	imul   %ecx
  8010e2:	c1 fa 02             	sar    $0x2,%edx
  8010e5:	89 c8                	mov    %ecx,%eax
  8010e7:	c1 f8 1f             	sar    $0x1f,%eax
  8010ea:	29 c2                	sub    %eax,%edx
  8010ec:	89 d0                	mov    %edx,%eax
  8010ee:	c1 e0 02             	shl    $0x2,%eax
  8010f1:	01 d0                	add    %edx,%eax
  8010f3:	01 c0                	add    %eax,%eax
  8010f5:	29 c1                	sub    %eax,%ecx
  8010f7:	89 ca                	mov    %ecx,%edx
  8010f9:	85 d2                	test   %edx,%edx
  8010fb:	75 9c                	jne    801099 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801104:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801107:	48                   	dec    %eax
  801108:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80110b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80110f:	74 3d                	je     80114e <ltostr+0xe2>
		start = 1 ;
  801111:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801118:	eb 34                	jmp    80114e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80111a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	01 d0                	add    %edx,%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	01 c2                	add    %eax,%edx
  80112f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	01 c8                	add    %ecx,%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80113b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	01 c2                	add    %eax,%edx
  801143:	8a 45 eb             	mov    -0x15(%ebp),%al
  801146:	88 02                	mov    %al,(%edx)
		start++ ;
  801148:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80114b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80114e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801151:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801154:	7c c4                	jl     80111a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801156:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801161:	90                   	nop
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80116a:	ff 75 08             	pushl  0x8(%ebp)
  80116d:	e8 54 fa ff ff       	call   800bc6 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	e8 46 fa ff ff       	call   800bc6 <strlen>
  801180:	83 c4 04             	add    $0x4,%esp
  801183:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801186:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80118d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801194:	eb 17                	jmp    8011ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801196:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	01 c2                	add    %eax,%edx
  80119e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	01 c8                	add    %ecx,%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011aa:	ff 45 fc             	incl   -0x4(%ebp)
  8011ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011b3:	7c e1                	jl     801196 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011c3:	eb 1f                	jmp    8011e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c8:	8d 50 01             	lea    0x1(%eax),%edx
  8011cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 c2                	add    %eax,%edx
  8011d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	01 c8                	add    %ecx,%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011e1:	ff 45 f8             	incl   -0x8(%ebp)
  8011e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c d9                	jl     8011c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801206:	8b 45 14             	mov    0x14(%ebp),%eax
  801209:	8b 00                	mov    (%eax),%eax
  80120b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	01 d0                	add    %edx,%eax
  801217:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	eb 0c                	jmp    80122b <strsplit+0x31>
			*string++ = 0;
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8d 50 01             	lea    0x1(%eax),%edx
  801225:	89 55 08             	mov    %edx,0x8(%ebp)
  801228:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	84 c0                	test   %al,%al
  801232:	74 18                	je     80124c <strsplit+0x52>
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	0f be c0             	movsbl %al,%eax
  80123c:	50                   	push   %eax
  80123d:	ff 75 0c             	pushl  0xc(%ebp)
  801240:	e8 13 fb ff ff       	call   800d58 <strchr>
  801245:	83 c4 08             	add    $0x8,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	75 d3                	jne    80121f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	84 c0                	test   %al,%al
  801253:	74 5a                	je     8012af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	83 f8 0f             	cmp    $0xf,%eax
  80125d:	75 07                	jne    801266 <strsplit+0x6c>
		{
			return 0;
  80125f:	b8 00 00 00 00       	mov    $0x0,%eax
  801264:	eb 66                	jmp    8012cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	8d 48 01             	lea    0x1(%eax),%ecx
  80126e:	8b 55 14             	mov    0x14(%ebp),%edx
  801271:	89 0a                	mov    %ecx,(%edx)
  801273:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127a:	8b 45 10             	mov    0x10(%ebp),%eax
  80127d:	01 c2                	add    %eax,%edx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801284:	eb 03                	jmp    801289 <strsplit+0x8f>
			string++;
  801286:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	84 c0                	test   %al,%al
  801290:	74 8b                	je     80121d <strsplit+0x23>
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	50                   	push   %eax
  80129b:	ff 75 0c             	pushl  0xc(%ebp)
  80129e:	e8 b5 fa ff ff       	call   800d58 <strchr>
  8012a3:	83 c4 08             	add    $0x8,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	74 dc                	je     801286 <strsplit+0x8c>
			string++;
	}
  8012aa:	e9 6e ff ff ff       	jmp    80121d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b3:	8b 00                	mov    (%eax),%eax
  8012b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	74 1f                	je     8012fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012dd:	e8 1d 00 00 00       	call   8012ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	68 90 39 80 00       	push   $0x803990
  8012ea:	e8 55 f2 ff ff       	call   800544 <cprintf>
  8012ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012f2:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012f9:	00 00 00 
	}
}
  8012fc:	90                   	nop
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    

008012ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801305:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80130c:	00 00 00 
  80130f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801316:	00 00 00 
  801319:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801320:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801323:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80132a:	00 00 00 
  80132d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801334:	00 00 00 
  801337:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80133e:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801341:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801348:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80134b:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801355:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80135a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80135f:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801364:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80136b:	a1 20 41 80 00       	mov    0x804120,%eax
  801370:	c1 e0 04             	shl    $0x4,%eax
  801373:	89 c2                	mov    %eax,%edx
  801375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	48                   	dec    %eax
  80137b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80137e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801381:	ba 00 00 00 00       	mov    $0x0,%edx
  801386:	f7 75 f0             	divl   -0x10(%ebp)
  801389:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80138c:	29 d0                	sub    %edx,%eax
  80138e:	89 c2                	mov    %eax,%edx
  801390:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801397:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80139a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139f:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a4:	83 ec 04             	sub    $0x4,%esp
  8013a7:	6a 06                	push   $0x6
  8013a9:	52                   	push   %edx
  8013aa:	50                   	push   %eax
  8013ab:	e8 71 05 00 00       	call   801921 <sys_allocate_chunk>
  8013b0:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013b3:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b8:	83 ec 0c             	sub    $0xc,%esp
  8013bb:	50                   	push   %eax
  8013bc:	e8 e6 0b 00 00       	call   801fa7 <initialize_MemBlocksList>
  8013c1:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8013c4:	a1 48 41 80 00       	mov    0x804148,%eax
  8013c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8013cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013d0:	75 14                	jne    8013e6 <initialize_dyn_block_system+0xe7>
  8013d2:	83 ec 04             	sub    $0x4,%esp
  8013d5:	68 b5 39 80 00       	push   $0x8039b5
  8013da:	6a 2b                	push   $0x2b
  8013dc:	68 d3 39 80 00       	push   $0x8039d3
  8013e1:	e8 aa ee ff ff       	call   800290 <_panic>
  8013e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e9:	8b 00                	mov    (%eax),%eax
  8013eb:	85 c0                	test   %eax,%eax
  8013ed:	74 10                	je     8013ff <initialize_dyn_block_system+0x100>
  8013ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f2:	8b 00                	mov    (%eax),%eax
  8013f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013f7:	8b 52 04             	mov    0x4(%edx),%edx
  8013fa:	89 50 04             	mov    %edx,0x4(%eax)
  8013fd:	eb 0b                	jmp    80140a <initialize_dyn_block_system+0x10b>
  8013ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801402:	8b 40 04             	mov    0x4(%eax),%eax
  801405:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80140a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80140d:	8b 40 04             	mov    0x4(%eax),%eax
  801410:	85 c0                	test   %eax,%eax
  801412:	74 0f                	je     801423 <initialize_dyn_block_system+0x124>
  801414:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801417:	8b 40 04             	mov    0x4(%eax),%eax
  80141a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80141d:	8b 12                	mov    (%edx),%edx
  80141f:	89 10                	mov    %edx,(%eax)
  801421:	eb 0a                	jmp    80142d <initialize_dyn_block_system+0x12e>
  801423:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801426:	8b 00                	mov    (%eax),%eax
  801428:	a3 48 41 80 00       	mov    %eax,0x804148
  80142d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801430:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801436:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801439:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801440:	a1 54 41 80 00       	mov    0x804154,%eax
  801445:	48                   	dec    %eax
  801446:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  80144b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80144e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801455:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801458:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  80145f:	83 ec 0c             	sub    $0xc,%esp
  801462:	ff 75 e4             	pushl  -0x1c(%ebp)
  801465:	e8 d2 13 00 00       	call   80283c <insert_sorted_with_merge_freeList>
  80146a:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80146d:	90                   	nop
  80146e:	c9                   	leave  
  80146f:	c3                   	ret    

00801470 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801476:	e8 53 fe ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  80147b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80147f:	75 07                	jne    801488 <malloc+0x18>
  801481:	b8 00 00 00 00       	mov    $0x0,%eax
  801486:	eb 61                	jmp    8014e9 <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801488:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80148f:	8b 55 08             	mov    0x8(%ebp),%edx
  801492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801495:	01 d0                	add    %edx,%eax
  801497:	48                   	dec    %eax
  801498:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80149b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149e:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a3:	f7 75 f4             	divl   -0xc(%ebp)
  8014a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a9:	29 d0                	sub    %edx,%eax
  8014ab:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014ae:	e8 3c 08 00 00       	call   801cef <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	74 2d                	je     8014e4 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	ff 75 08             	pushl  0x8(%ebp)
  8014bd:	e8 3e 0f 00 00       	call   802400 <alloc_block_FF>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8014c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014cc:	74 16                	je     8014e4 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8014ce:	83 ec 0c             	sub    $0xc,%esp
  8014d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8014d4:	e8 48 0c 00 00       	call   802121 <insert_sorted_allocList>
  8014d9:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8014dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014df:	8b 40 08             	mov    0x8(%eax),%eax
  8014e2:	eb 05                	jmp    8014e9 <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8014e4:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8014f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ff:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	50                   	push   %eax
  801509:	68 40 40 80 00       	push   $0x804040
  80150e:	e8 71 0b 00 00       	call   802084 <find_block>
  801513:	83 c4 10             	add    $0x10,%esp
  801516:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  801519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151c:	8b 50 0c             	mov    0xc(%eax),%edx
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	83 ec 08             	sub    $0x8,%esp
  801525:	52                   	push   %edx
  801526:	50                   	push   %eax
  801527:	e8 bd 03 00 00       	call   8018e9 <sys_free_user_mem>
  80152c:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  80152f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801533:	75 14                	jne    801549 <free+0x5e>
  801535:	83 ec 04             	sub    $0x4,%esp
  801538:	68 b5 39 80 00       	push   $0x8039b5
  80153d:	6a 71                	push   $0x71
  80153f:	68 d3 39 80 00       	push   $0x8039d3
  801544:	e8 47 ed ff ff       	call   800290 <_panic>
  801549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	85 c0                	test   %eax,%eax
  801550:	74 10                	je     801562 <free+0x77>
  801552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801555:	8b 00                	mov    (%eax),%eax
  801557:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80155a:	8b 52 04             	mov    0x4(%edx),%edx
  80155d:	89 50 04             	mov    %edx,0x4(%eax)
  801560:	eb 0b                	jmp    80156d <free+0x82>
  801562:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801565:	8b 40 04             	mov    0x4(%eax),%eax
  801568:	a3 44 40 80 00       	mov    %eax,0x804044
  80156d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801570:	8b 40 04             	mov    0x4(%eax),%eax
  801573:	85 c0                	test   %eax,%eax
  801575:	74 0f                	je     801586 <free+0x9b>
  801577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157a:	8b 40 04             	mov    0x4(%eax),%eax
  80157d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801580:	8b 12                	mov    (%edx),%edx
  801582:	89 10                	mov    %edx,(%eax)
  801584:	eb 0a                	jmp    801590 <free+0xa5>
  801586:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801589:	8b 00                	mov    (%eax),%eax
  80158b:	a3 40 40 80 00       	mov    %eax,0x804040
  801590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801593:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015a3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015a8:	48                   	dec    %eax
  8015a9:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8015ae:	83 ec 0c             	sub    $0xc,%esp
  8015b1:	ff 75 f0             	pushl  -0x10(%ebp)
  8015b4:	e8 83 12 00 00       	call   80283c <insert_sorted_with_merge_freeList>
  8015b9:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015bc:	90                   	nop
  8015bd:	c9                   	leave  
  8015be:	c3                   	ret    

008015bf <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	83 ec 28             	sub    $0x28,%esp
  8015c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c8:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015cb:	e8 fe fc ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  8015d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015d4:	75 0a                	jne    8015e0 <smalloc+0x21>
  8015d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015db:	e9 86 00 00 00       	jmp    801666 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8015e0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ed:	01 d0                	add    %edx,%eax
  8015ef:	48                   	dec    %eax
  8015f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fb:	f7 75 f4             	divl   -0xc(%ebp)
  8015fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801601:	29 d0                	sub    %edx,%eax
  801603:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801606:	e8 e4 06 00 00       	call   801cef <sys_isUHeapPlacementStrategyFIRSTFIT>
  80160b:	85 c0                	test   %eax,%eax
  80160d:	74 52                	je     801661 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  80160f:	83 ec 0c             	sub    $0xc,%esp
  801612:	ff 75 0c             	pushl  0xc(%ebp)
  801615:	e8 e6 0d 00 00       	call   802400 <alloc_block_FF>
  80161a:	83 c4 10             	add    $0x10,%esp
  80161d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801620:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801624:	75 07                	jne    80162d <smalloc+0x6e>
			return NULL ;
  801626:	b8 00 00 00 00       	mov    $0x0,%eax
  80162b:	eb 39                	jmp    801666 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80162d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801630:	8b 40 08             	mov    0x8(%eax),%eax
  801633:	89 c2                	mov    %eax,%edx
  801635:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801639:	52                   	push   %edx
  80163a:	50                   	push   %eax
  80163b:	ff 75 0c             	pushl  0xc(%ebp)
  80163e:	ff 75 08             	pushl  0x8(%ebp)
  801641:	e8 2e 04 00 00       	call   801a74 <sys_createSharedObject>
  801646:	83 c4 10             	add    $0x10,%esp
  801649:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80164c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801650:	79 07                	jns    801659 <smalloc+0x9a>
			return (void*)NULL ;
  801652:	b8 00 00 00 00       	mov    $0x0,%eax
  801657:	eb 0d                	jmp    801666 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  801659:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165c:	8b 40 08             	mov    0x8(%eax),%eax
  80165f:	eb 05                	jmp    801666 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801661:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801666:	c9                   	leave  
  801667:	c3                   	ret    

00801668 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801668:	55                   	push   %ebp
  801669:	89 e5                	mov    %esp,%ebp
  80166b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80166e:	e8 5b fc ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801673:	83 ec 08             	sub    $0x8,%esp
  801676:	ff 75 0c             	pushl  0xc(%ebp)
  801679:	ff 75 08             	pushl  0x8(%ebp)
  80167c:	e8 1d 04 00 00       	call   801a9e <sys_getSizeOfSharedObject>
  801681:	83 c4 10             	add    $0x10,%esp
  801684:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801687:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80168b:	75 0a                	jne    801697 <sget+0x2f>
			return NULL ;
  80168d:	b8 00 00 00 00       	mov    $0x0,%eax
  801692:	e9 83 00 00 00       	jmp    80171a <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801697:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80169e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a4:	01 d0                	add    %edx,%eax
  8016a6:	48                   	dec    %eax
  8016a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b2:	f7 75 f0             	divl   -0x10(%ebp)
  8016b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b8:	29 d0                	sub    %edx,%eax
  8016ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016bd:	e8 2d 06 00 00       	call   801cef <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	74 4f                	je     801715 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	83 ec 0c             	sub    $0xc,%esp
  8016cc:	50                   	push   %eax
  8016cd:	e8 2e 0d 00 00       	call   802400 <alloc_block_FF>
  8016d2:	83 c4 10             	add    $0x10,%esp
  8016d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8016d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016dc:	75 07                	jne    8016e5 <sget+0x7d>
					return (void*)NULL ;
  8016de:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e3:	eb 35                	jmp    80171a <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8016e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e8:	8b 40 08             	mov    0x8(%eax),%eax
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	50                   	push   %eax
  8016ef:	ff 75 0c             	pushl  0xc(%ebp)
  8016f2:	ff 75 08             	pushl  0x8(%ebp)
  8016f5:	e8 c1 03 00 00       	call   801abb <sys_getSharedObject>
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801700:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801704:	79 07                	jns    80170d <sget+0xa5>
				return (void*)NULL ;
  801706:	b8 00 00 00 00       	mov    $0x0,%eax
  80170b:	eb 0d                	jmp    80171a <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  80170d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801710:	8b 40 08             	mov    0x8(%eax),%eax
  801713:	eb 05                	jmp    80171a <sget+0xb2>


		}
	return (void*)NULL ;
  801715:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80171a:	c9                   	leave  
  80171b:	c3                   	ret    

0080171c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80171c:	55                   	push   %ebp
  80171d:	89 e5                	mov    %esp,%ebp
  80171f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801722:	e8 a7 fb ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801727:	83 ec 04             	sub    $0x4,%esp
  80172a:	68 e0 39 80 00       	push   $0x8039e0
  80172f:	68 f9 00 00 00       	push   $0xf9
  801734:	68 d3 39 80 00       	push   $0x8039d3
  801739:	e8 52 eb ff ff       	call   800290 <_panic>

0080173e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801744:	83 ec 04             	sub    $0x4,%esp
  801747:	68 08 3a 80 00       	push   $0x803a08
  80174c:	68 0d 01 00 00       	push   $0x10d
  801751:	68 d3 39 80 00       	push   $0x8039d3
  801756:	e8 35 eb ff ff       	call   800290 <_panic>

0080175b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80175b:	55                   	push   %ebp
  80175c:	89 e5                	mov    %esp,%ebp
  80175e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801761:	83 ec 04             	sub    $0x4,%esp
  801764:	68 2c 3a 80 00       	push   $0x803a2c
  801769:	68 18 01 00 00       	push   $0x118
  80176e:	68 d3 39 80 00       	push   $0x8039d3
  801773:	e8 18 eb ff ff       	call   800290 <_panic>

00801778 <shrink>:

}
void shrink(uint32 newSize)
{
  801778:	55                   	push   %ebp
  801779:	89 e5                	mov    %esp,%ebp
  80177b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	68 2c 3a 80 00       	push   $0x803a2c
  801786:	68 1d 01 00 00       	push   $0x11d
  80178b:	68 d3 39 80 00       	push   $0x8039d3
  801790:	e8 fb ea ff ff       	call   800290 <_panic>

00801795 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
  801798:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80179b:	83 ec 04             	sub    $0x4,%esp
  80179e:	68 2c 3a 80 00       	push   $0x803a2c
  8017a3:	68 22 01 00 00       	push   $0x122
  8017a8:	68 d3 39 80 00       	push   $0x8039d3
  8017ad:	e8 de ea ff ff       	call   800290 <_panic>

008017b2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017b2:	55                   	push   %ebp
  8017b3:	89 e5                	mov    %esp,%ebp
  8017b5:	57                   	push   %edi
  8017b6:	56                   	push   %esi
  8017b7:	53                   	push   %ebx
  8017b8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017c7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017ca:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017cd:	cd 30                	int    $0x30
  8017cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017d5:	83 c4 10             	add    $0x10,%esp
  8017d8:	5b                   	pop    %ebx
  8017d9:	5e                   	pop    %esi
  8017da:	5f                   	pop    %edi
  8017db:	5d                   	pop    %ebp
  8017dc:	c3                   	ret    

008017dd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	83 ec 04             	sub    $0x4,%esp
  8017e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017e9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	52                   	push   %edx
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	50                   	push   %eax
  8017f9:	6a 00                	push   $0x0
  8017fb:	e8 b2 ff ff ff       	call   8017b2 <syscall>
  801800:	83 c4 18             	add    $0x18,%esp
}
  801803:	90                   	nop
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <sys_cgetc>:

int
sys_cgetc(void)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 01                	push   $0x1
  801815:	e8 98 ff ff ff       	call   8017b2 <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801822:	8b 55 0c             	mov    0xc(%ebp),%edx
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	52                   	push   %edx
  80182f:	50                   	push   %eax
  801830:	6a 05                	push   $0x5
  801832:	e8 7b ff ff ff       	call   8017b2 <syscall>
  801837:	83 c4 18             	add    $0x18,%esp
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	56                   	push   %esi
  801840:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801841:	8b 75 18             	mov    0x18(%ebp),%esi
  801844:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801847:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80184a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	56                   	push   %esi
  801851:	53                   	push   %ebx
  801852:	51                   	push   %ecx
  801853:	52                   	push   %edx
  801854:	50                   	push   %eax
  801855:	6a 06                	push   $0x6
  801857:	e8 56 ff ff ff       	call   8017b2 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801862:	5b                   	pop    %ebx
  801863:	5e                   	pop    %esi
  801864:	5d                   	pop    %ebp
  801865:	c3                   	ret    

00801866 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186c:	8b 45 08             	mov    0x8(%ebp),%eax
  80186f:	6a 00                	push   $0x0
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	52                   	push   %edx
  801876:	50                   	push   %eax
  801877:	6a 07                	push   $0x7
  801879:	e8 34 ff ff ff       	call   8017b2 <syscall>
  80187e:	83 c4 18             	add    $0x18,%esp
}
  801881:	c9                   	leave  
  801882:	c3                   	ret    

00801883 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801883:	55                   	push   %ebp
  801884:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	ff 75 0c             	pushl  0xc(%ebp)
  80188f:	ff 75 08             	pushl  0x8(%ebp)
  801892:	6a 08                	push   $0x8
  801894:	e8 19 ff ff ff       	call   8017b2 <syscall>
  801899:	83 c4 18             	add    $0x18,%esp
}
  80189c:	c9                   	leave  
  80189d:	c3                   	ret    

0080189e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 09                	push   $0x9
  8018ad:	e8 00 ff ff ff       	call   8017b2 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 0a                	push   $0xa
  8018c6:	e8 e7 fe ff ff       	call   8017b2 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 0b                	push   $0xb
  8018df:	e8 ce fe ff ff       	call   8017b2 <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	ff 75 0c             	pushl  0xc(%ebp)
  8018f5:	ff 75 08             	pushl  0x8(%ebp)
  8018f8:	6a 0f                	push   $0xf
  8018fa:	e8 b3 fe ff ff       	call   8017b2 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
	return;
  801902:	90                   	nop
}
  801903:	c9                   	leave  
  801904:	c3                   	ret    

00801905 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	ff 75 0c             	pushl  0xc(%ebp)
  801911:	ff 75 08             	pushl  0x8(%ebp)
  801914:	6a 10                	push   $0x10
  801916:	e8 97 fe ff ff       	call   8017b2 <syscall>
  80191b:	83 c4 18             	add    $0x18,%esp
	return ;
  80191e:	90                   	nop
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	ff 75 10             	pushl  0x10(%ebp)
  80192b:	ff 75 0c             	pushl  0xc(%ebp)
  80192e:	ff 75 08             	pushl  0x8(%ebp)
  801931:	6a 11                	push   $0x11
  801933:	e8 7a fe ff ff       	call   8017b2 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
	return ;
  80193b:	90                   	nop
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 0c                	push   $0xc
  80194d:	e8 60 fe ff ff       	call   8017b2 <syscall>
  801952:	83 c4 18             	add    $0x18,%esp
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	ff 75 08             	pushl  0x8(%ebp)
  801965:	6a 0d                	push   $0xd
  801967:	e8 46 fe ff ff       	call   8017b2 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 0e                	push   $0xe
  801980:	e8 2d fe ff ff       	call   8017b2 <syscall>
  801985:	83 c4 18             	add    $0x18,%esp
}
  801988:	90                   	nop
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 13                	push   $0x13
  80199a:	e8 13 fe ff ff       	call   8017b2 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	90                   	nop
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 14                	push   $0x14
  8019b4:	e8 f9 fd ff ff       	call   8017b2 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	90                   	nop
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_cputc>:


void
sys_cputc(const char c)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 04             	sub    $0x4,%esp
  8019c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	50                   	push   %eax
  8019d8:	6a 15                	push   $0x15
  8019da:	e8 d3 fd ff ff       	call   8017b2 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	90                   	nop
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 16                	push   $0x16
  8019f4:	e8 b9 fd ff ff       	call   8017b2 <syscall>
  8019f9:	83 c4 18             	add    $0x18,%esp
}
  8019fc:	90                   	nop
  8019fd:	c9                   	leave  
  8019fe:	c3                   	ret    

008019ff <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	ff 75 0c             	pushl  0xc(%ebp)
  801a0e:	50                   	push   %eax
  801a0f:	6a 17                	push   $0x17
  801a11:	e8 9c fd ff ff       	call   8017b2 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a21:	8b 45 08             	mov    0x8(%ebp),%eax
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	52                   	push   %edx
  801a2b:	50                   	push   %eax
  801a2c:	6a 1a                	push   $0x1a
  801a2e:	e8 7f fd ff ff       	call   8017b2 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	52                   	push   %edx
  801a48:	50                   	push   %eax
  801a49:	6a 18                	push   $0x18
  801a4b:	e8 62 fd ff ff       	call   8017b2 <syscall>
  801a50:	83 c4 18             	add    $0x18,%esp
}
  801a53:	90                   	nop
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	52                   	push   %edx
  801a66:	50                   	push   %eax
  801a67:	6a 19                	push   $0x19
  801a69:	e8 44 fd ff ff       	call   8017b2 <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	90                   	nop
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	83 ec 04             	sub    $0x4,%esp
  801a7a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a80:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a83:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	6a 00                	push   $0x0
  801a8c:	51                   	push   %ecx
  801a8d:	52                   	push   %edx
  801a8e:	ff 75 0c             	pushl  0xc(%ebp)
  801a91:	50                   	push   %eax
  801a92:	6a 1b                	push   $0x1b
  801a94:	e8 19 fd ff ff       	call   8017b2 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	52                   	push   %edx
  801aae:	50                   	push   %eax
  801aaf:	6a 1c                	push   $0x1c
  801ab1:	e8 fc fc ff ff       	call   8017b2 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801abe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	51                   	push   %ecx
  801acc:	52                   	push   %edx
  801acd:	50                   	push   %eax
  801ace:	6a 1d                	push   $0x1d
  801ad0:	e8 dd fc ff ff       	call   8017b2 <syscall>
  801ad5:	83 c4 18             	add    $0x18,%esp
}
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801add:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	52                   	push   %edx
  801aea:	50                   	push   %eax
  801aeb:	6a 1e                	push   $0x1e
  801aed:	e8 c0 fc ff ff       	call   8017b2 <syscall>
  801af2:	83 c4 18             	add    $0x18,%esp
}
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 1f                	push   $0x1f
  801b06:	e8 a7 fc ff ff       	call   8017b2 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	ff 75 14             	pushl  0x14(%ebp)
  801b1b:	ff 75 10             	pushl  0x10(%ebp)
  801b1e:	ff 75 0c             	pushl  0xc(%ebp)
  801b21:	50                   	push   %eax
  801b22:	6a 20                	push   $0x20
  801b24:	e8 89 fc ff ff       	call   8017b2 <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	50                   	push   %eax
  801b3d:	6a 21                	push   $0x21
  801b3f:	e8 6e fc ff ff       	call   8017b2 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	90                   	nop
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	50                   	push   %eax
  801b59:	6a 22                	push   $0x22
  801b5b:	e8 52 fc ff ff       	call   8017b2 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 02                	push   $0x2
  801b74:	e8 39 fc ff ff       	call   8017b2 <syscall>
  801b79:	83 c4 18             	add    $0x18,%esp
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	6a 00                	push   $0x0
  801b8b:	6a 03                	push   $0x3
  801b8d:	e8 20 fc ff ff       	call   8017b2 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	c9                   	leave  
  801b96:	c3                   	ret    

00801b97 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 04                	push   $0x4
  801ba6:	e8 07 fc ff ff       	call   8017b2 <syscall>
  801bab:	83 c4 18             	add    $0x18,%esp
}
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_exit_env>:


void sys_exit_env(void)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 23                	push   $0x23
  801bbf:	e8 ee fb ff ff       	call   8017b2 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	90                   	nop
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bd0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bd3:	8d 50 04             	lea    0x4(%eax),%edx
  801bd6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	52                   	push   %edx
  801be0:	50                   	push   %eax
  801be1:	6a 24                	push   $0x24
  801be3:	e8 ca fb ff ff       	call   8017b2 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
	return result;
  801beb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bf1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bf4:	89 01                	mov    %eax,(%ecx)
  801bf6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfc:	c9                   	leave  
  801bfd:	c2 04 00             	ret    $0x4

00801c00 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	ff 75 10             	pushl  0x10(%ebp)
  801c0a:	ff 75 0c             	pushl  0xc(%ebp)
  801c0d:	ff 75 08             	pushl  0x8(%ebp)
  801c10:	6a 12                	push   $0x12
  801c12:	e8 9b fb ff ff       	call   8017b2 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
	return ;
  801c1a:	90                   	nop
}
  801c1b:	c9                   	leave  
  801c1c:	c3                   	ret    

00801c1d <sys_rcr2>:
uint32 sys_rcr2()
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 25                	push   $0x25
  801c2c:	e8 81 fb ff ff       	call   8017b2 <syscall>
  801c31:	83 c4 18             	add    $0x18,%esp
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	83 ec 04             	sub    $0x4,%esp
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c42:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	50                   	push   %eax
  801c4f:	6a 26                	push   $0x26
  801c51:	e8 5c fb ff ff       	call   8017b2 <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
	return ;
  801c59:	90                   	nop
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <rsttst>:
void rsttst()
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 28                	push   $0x28
  801c6b:	e8 42 fb ff ff       	call   8017b2 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
	return ;
  801c73:	90                   	nop
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 04             	sub    $0x4,%esp
  801c7c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c82:	8b 55 18             	mov    0x18(%ebp),%edx
  801c85:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c89:	52                   	push   %edx
  801c8a:	50                   	push   %eax
  801c8b:	ff 75 10             	pushl  0x10(%ebp)
  801c8e:	ff 75 0c             	pushl  0xc(%ebp)
  801c91:	ff 75 08             	pushl  0x8(%ebp)
  801c94:	6a 27                	push   $0x27
  801c96:	e8 17 fb ff ff       	call   8017b2 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9e:	90                   	nop
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <chktst>:
void chktst(uint32 n)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	ff 75 08             	pushl  0x8(%ebp)
  801caf:	6a 29                	push   $0x29
  801cb1:	e8 fc fa ff ff       	call   8017b2 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb9:	90                   	nop
}
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <inctst>:

void inctst()
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 2a                	push   $0x2a
  801ccb:	e8 e2 fa ff ff       	call   8017b2 <syscall>
  801cd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd3:	90                   	nop
}
  801cd4:	c9                   	leave  
  801cd5:	c3                   	ret    

00801cd6 <gettst>:
uint32 gettst()
{
  801cd6:	55                   	push   %ebp
  801cd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 2b                	push   $0x2b
  801ce5:	e8 c8 fa ff ff       	call   8017b2 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
  801cf2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 2c                	push   $0x2c
  801d01:	e8 ac fa ff ff       	call   8017b2 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
  801d09:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d0c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d10:	75 07                	jne    801d19 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d12:	b8 01 00 00 00       	mov    $0x1,%eax
  801d17:	eb 05                	jmp    801d1e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 2c                	push   $0x2c
  801d32:	e8 7b fa ff ff       	call   8017b2 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
  801d3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d3d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d41:	75 07                	jne    801d4a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d43:	b8 01 00 00 00       	mov    $0x1,%eax
  801d48:	eb 05                	jmp    801d4f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 2c                	push   $0x2c
  801d63:	e8 4a fa ff ff       	call   8017b2 <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
  801d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d6e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d72:	75 07                	jne    801d7b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d74:	b8 01 00 00 00       	mov    $0x1,%eax
  801d79:	eb 05                	jmp    801d80 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 2c                	push   $0x2c
  801d94:	e8 19 fa ff ff       	call   8017b2 <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
  801d9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d9f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801da3:	75 07                	jne    801dac <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801da5:	b8 01 00 00 00       	mov    $0x1,%eax
  801daa:	eb 05                	jmp    801db1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	ff 75 08             	pushl  0x8(%ebp)
  801dc1:	6a 2d                	push   $0x2d
  801dc3:	e8 ea f9 ff ff       	call   8017b2 <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dcb:	90                   	nop
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dd2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	6a 00                	push   $0x0
  801de0:	53                   	push   %ebx
  801de1:	51                   	push   %ecx
  801de2:	52                   	push   %edx
  801de3:	50                   	push   %eax
  801de4:	6a 2e                	push   $0x2e
  801de6:	e8 c7 f9 ff ff       	call   8017b2 <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
}
  801dee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801df6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	52                   	push   %edx
  801e03:	50                   	push   %eax
  801e04:	6a 2f                	push   $0x2f
  801e06:	e8 a7 f9 ff ff       	call   8017b2 <syscall>
  801e0b:	83 c4 18             	add    $0x18,%esp
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e16:	83 ec 0c             	sub    $0xc,%esp
  801e19:	68 3c 3a 80 00       	push   $0x803a3c
  801e1e:	e8 21 e7 ff ff       	call   800544 <cprintf>
  801e23:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e26:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e2d:	83 ec 0c             	sub    $0xc,%esp
  801e30:	68 68 3a 80 00       	push   $0x803a68
  801e35:	e8 0a e7 ff ff       	call   800544 <cprintf>
  801e3a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e3d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e41:	a1 38 41 80 00       	mov    0x804138,%eax
  801e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e49:	eb 56                	jmp    801ea1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e4f:	74 1c                	je     801e6d <print_mem_block_lists+0x5d>
  801e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e54:	8b 50 08             	mov    0x8(%eax),%edx
  801e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5a:	8b 48 08             	mov    0x8(%eax),%ecx
  801e5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e60:	8b 40 0c             	mov    0xc(%eax),%eax
  801e63:	01 c8                	add    %ecx,%eax
  801e65:	39 c2                	cmp    %eax,%edx
  801e67:	73 04                	jae    801e6d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e69:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e70:	8b 50 08             	mov    0x8(%eax),%edx
  801e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e76:	8b 40 0c             	mov    0xc(%eax),%eax
  801e79:	01 c2                	add    %eax,%edx
  801e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7e:	8b 40 08             	mov    0x8(%eax),%eax
  801e81:	83 ec 04             	sub    $0x4,%esp
  801e84:	52                   	push   %edx
  801e85:	50                   	push   %eax
  801e86:	68 7d 3a 80 00       	push   $0x803a7d
  801e8b:	e8 b4 e6 ff ff       	call   800544 <cprintf>
  801e90:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e96:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e99:	a1 40 41 80 00       	mov    0x804140,%eax
  801e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ea1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea5:	74 07                	je     801eae <print_mem_block_lists+0x9e>
  801ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaa:	8b 00                	mov    (%eax),%eax
  801eac:	eb 05                	jmp    801eb3 <print_mem_block_lists+0xa3>
  801eae:	b8 00 00 00 00       	mov    $0x0,%eax
  801eb3:	a3 40 41 80 00       	mov    %eax,0x804140
  801eb8:	a1 40 41 80 00       	mov    0x804140,%eax
  801ebd:	85 c0                	test   %eax,%eax
  801ebf:	75 8a                	jne    801e4b <print_mem_block_lists+0x3b>
  801ec1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ec5:	75 84                	jne    801e4b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ec7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ecb:	75 10                	jne    801edd <print_mem_block_lists+0xcd>
  801ecd:	83 ec 0c             	sub    $0xc,%esp
  801ed0:	68 8c 3a 80 00       	push   $0x803a8c
  801ed5:	e8 6a e6 ff ff       	call   800544 <cprintf>
  801eda:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801edd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ee4:	83 ec 0c             	sub    $0xc,%esp
  801ee7:	68 b0 3a 80 00       	push   $0x803ab0
  801eec:	e8 53 e6 ff ff       	call   800544 <cprintf>
  801ef1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ef4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ef8:	a1 40 40 80 00       	mov    0x804040,%eax
  801efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f00:	eb 56                	jmp    801f58 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f02:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f06:	74 1c                	je     801f24 <print_mem_block_lists+0x114>
  801f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0b:	8b 50 08             	mov    0x8(%eax),%edx
  801f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f11:	8b 48 08             	mov    0x8(%eax),%ecx
  801f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f17:	8b 40 0c             	mov    0xc(%eax),%eax
  801f1a:	01 c8                	add    %ecx,%eax
  801f1c:	39 c2                	cmp    %eax,%edx
  801f1e:	73 04                	jae    801f24 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f20:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f27:	8b 50 08             	mov    0x8(%eax),%edx
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f30:	01 c2                	add    %eax,%edx
  801f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f35:	8b 40 08             	mov    0x8(%eax),%eax
  801f38:	83 ec 04             	sub    $0x4,%esp
  801f3b:	52                   	push   %edx
  801f3c:	50                   	push   %eax
  801f3d:	68 7d 3a 80 00       	push   $0x803a7d
  801f42:	e8 fd e5 ff ff       	call   800544 <cprintf>
  801f47:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f50:	a1 48 40 80 00       	mov    0x804048,%eax
  801f55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5c:	74 07                	je     801f65 <print_mem_block_lists+0x155>
  801f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f61:	8b 00                	mov    (%eax),%eax
  801f63:	eb 05                	jmp    801f6a <print_mem_block_lists+0x15a>
  801f65:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6a:	a3 48 40 80 00       	mov    %eax,0x804048
  801f6f:	a1 48 40 80 00       	mov    0x804048,%eax
  801f74:	85 c0                	test   %eax,%eax
  801f76:	75 8a                	jne    801f02 <print_mem_block_lists+0xf2>
  801f78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7c:	75 84                	jne    801f02 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f7e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f82:	75 10                	jne    801f94 <print_mem_block_lists+0x184>
  801f84:	83 ec 0c             	sub    $0xc,%esp
  801f87:	68 c8 3a 80 00       	push   $0x803ac8
  801f8c:	e8 b3 e5 ff ff       	call   800544 <cprintf>
  801f91:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f94:	83 ec 0c             	sub    $0xc,%esp
  801f97:	68 3c 3a 80 00       	push   $0x803a3c
  801f9c:	e8 a3 e5 ff ff       	call   800544 <cprintf>
  801fa1:	83 c4 10             	add    $0x10,%esp

}
  801fa4:	90                   	nop
  801fa5:	c9                   	leave  
  801fa6:	c3                   	ret    

00801fa7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fa7:	55                   	push   %ebp
  801fa8:	89 e5                	mov    %esp,%ebp
  801faa:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801fad:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fb4:	00 00 00 
  801fb7:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fbe:	00 00 00 
  801fc1:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801fc8:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801fcb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fd2:	e9 9e 00 00 00       	jmp    802075 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  801fd7:	a1 50 40 80 00       	mov    0x804050,%eax
  801fdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdf:	c1 e2 04             	shl    $0x4,%edx
  801fe2:	01 d0                	add    %edx,%eax
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	75 14                	jne    801ffc <initialize_MemBlocksList+0x55>
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	68 f0 3a 80 00       	push   $0x803af0
  801ff0:	6a 43                	push   $0x43
  801ff2:	68 13 3b 80 00       	push   $0x803b13
  801ff7:	e8 94 e2 ff ff       	call   800290 <_panic>
  801ffc:	a1 50 40 80 00       	mov    0x804050,%eax
  802001:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802004:	c1 e2 04             	shl    $0x4,%edx
  802007:	01 d0                	add    %edx,%eax
  802009:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80200f:	89 10                	mov    %edx,(%eax)
  802011:	8b 00                	mov    (%eax),%eax
  802013:	85 c0                	test   %eax,%eax
  802015:	74 18                	je     80202f <initialize_MemBlocksList+0x88>
  802017:	a1 48 41 80 00       	mov    0x804148,%eax
  80201c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802022:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802025:	c1 e1 04             	shl    $0x4,%ecx
  802028:	01 ca                	add    %ecx,%edx
  80202a:	89 50 04             	mov    %edx,0x4(%eax)
  80202d:	eb 12                	jmp    802041 <initialize_MemBlocksList+0x9a>
  80202f:	a1 50 40 80 00       	mov    0x804050,%eax
  802034:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802037:	c1 e2 04             	shl    $0x4,%edx
  80203a:	01 d0                	add    %edx,%eax
  80203c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802041:	a1 50 40 80 00       	mov    0x804050,%eax
  802046:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802049:	c1 e2 04             	shl    $0x4,%edx
  80204c:	01 d0                	add    %edx,%eax
  80204e:	a3 48 41 80 00       	mov    %eax,0x804148
  802053:	a1 50 40 80 00       	mov    0x804050,%eax
  802058:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205b:	c1 e2 04             	shl    $0x4,%edx
  80205e:	01 d0                	add    %edx,%eax
  802060:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802067:	a1 54 41 80 00       	mov    0x804154,%eax
  80206c:	40                   	inc    %eax
  80206d:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802072:	ff 45 f4             	incl   -0xc(%ebp)
  802075:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802078:	3b 45 08             	cmp    0x8(%ebp),%eax
  80207b:	0f 82 56 ff ff ff    	jb     801fd7 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802081:	90                   	nop
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80208a:	a1 38 41 80 00       	mov    0x804138,%eax
  80208f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802092:	eb 18                	jmp    8020ac <find_block+0x28>
	{
		if (ele->sva==va)
  802094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802097:	8b 40 08             	mov    0x8(%eax),%eax
  80209a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80209d:	75 05                	jne    8020a4 <find_block+0x20>
			return ele;
  80209f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a2:	eb 7b                	jmp    80211f <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8020a4:	a1 40 41 80 00       	mov    0x804140,%eax
  8020a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020b0:	74 07                	je     8020b9 <find_block+0x35>
  8020b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020b5:	8b 00                	mov    (%eax),%eax
  8020b7:	eb 05                	jmp    8020be <find_block+0x3a>
  8020b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020be:	a3 40 41 80 00       	mov    %eax,0x804140
  8020c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	75 c8                	jne    802094 <find_block+0x10>
  8020cc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020d0:	75 c2                	jne    802094 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020d2:	a1 40 40 80 00       	mov    0x804040,%eax
  8020d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020da:	eb 18                	jmp    8020f4 <find_block+0x70>
	{
		if (ele->sva==va)
  8020dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020df:	8b 40 08             	mov    0x8(%eax),%eax
  8020e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020e5:	75 05                	jne    8020ec <find_block+0x68>
					return ele;
  8020e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ea:	eb 33                	jmp    80211f <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020ec:	a1 48 40 80 00       	mov    0x804048,%eax
  8020f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020f4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f8:	74 07                	je     802101 <find_block+0x7d>
  8020fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020fd:	8b 00                	mov    (%eax),%eax
  8020ff:	eb 05                	jmp    802106 <find_block+0x82>
  802101:	b8 00 00 00 00       	mov    $0x0,%eax
  802106:	a3 48 40 80 00       	mov    %eax,0x804048
  80210b:	a1 48 40 80 00       	mov    0x804048,%eax
  802110:	85 c0                	test   %eax,%eax
  802112:	75 c8                	jne    8020dc <find_block+0x58>
  802114:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802118:	75 c2                	jne    8020dc <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  80211a:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802127:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80212c:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  80212f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802133:	75 62                	jne    802197 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802135:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802139:	75 14                	jne    80214f <insert_sorted_allocList+0x2e>
  80213b:	83 ec 04             	sub    $0x4,%esp
  80213e:	68 f0 3a 80 00       	push   $0x803af0
  802143:	6a 69                	push   $0x69
  802145:	68 13 3b 80 00       	push   $0x803b13
  80214a:	e8 41 e1 ff ff       	call   800290 <_panic>
  80214f:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	89 10                	mov    %edx,(%eax)
  80215a:	8b 45 08             	mov    0x8(%ebp),%eax
  80215d:	8b 00                	mov    (%eax),%eax
  80215f:	85 c0                	test   %eax,%eax
  802161:	74 0d                	je     802170 <insert_sorted_allocList+0x4f>
  802163:	a1 40 40 80 00       	mov    0x804040,%eax
  802168:	8b 55 08             	mov    0x8(%ebp),%edx
  80216b:	89 50 04             	mov    %edx,0x4(%eax)
  80216e:	eb 08                	jmp    802178 <insert_sorted_allocList+0x57>
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	a3 44 40 80 00       	mov    %eax,0x804044
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	a3 40 40 80 00       	mov    %eax,0x804040
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80218f:	40                   	inc    %eax
  802190:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802195:	eb 72                	jmp    802209 <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802197:	a1 40 40 80 00       	mov    0x804040,%eax
  80219c:	8b 50 08             	mov    0x8(%eax),%edx
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	8b 40 08             	mov    0x8(%eax),%eax
  8021a5:	39 c2                	cmp    %eax,%edx
  8021a7:	76 60                	jbe    802209 <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8021a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ad:	75 14                	jne    8021c3 <insert_sorted_allocList+0xa2>
  8021af:	83 ec 04             	sub    $0x4,%esp
  8021b2:	68 f0 3a 80 00       	push   $0x803af0
  8021b7:	6a 6d                	push   $0x6d
  8021b9:	68 13 3b 80 00       	push   $0x803b13
  8021be:	e8 cd e0 ff ff       	call   800290 <_panic>
  8021c3:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cc:	89 10                	mov    %edx,(%eax)
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	8b 00                	mov    (%eax),%eax
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	74 0d                	je     8021e4 <insert_sorted_allocList+0xc3>
  8021d7:	a1 40 40 80 00       	mov    0x804040,%eax
  8021dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8021df:	89 50 04             	mov    %edx,0x4(%eax)
  8021e2:	eb 08                	jmp    8021ec <insert_sorted_allocList+0xcb>
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	a3 44 40 80 00       	mov    %eax,0x804044
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	a3 40 40 80 00       	mov    %eax,0x804040
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021fe:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802203:	40                   	inc    %eax
  802204:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  802209:	a1 40 40 80 00       	mov    0x804040,%eax
  80220e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802211:	e9 b9 01 00 00       	jmp    8023cf <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  802216:	8b 45 08             	mov    0x8(%ebp),%eax
  802219:	8b 50 08             	mov    0x8(%eax),%edx
  80221c:	a1 40 40 80 00       	mov    0x804040,%eax
  802221:	8b 40 08             	mov    0x8(%eax),%eax
  802224:	39 c2                	cmp    %eax,%edx
  802226:	76 7c                	jbe    8022a4 <insert_sorted_allocList+0x183>
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	8b 50 08             	mov    0x8(%eax),%edx
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	8b 40 08             	mov    0x8(%eax),%eax
  802234:	39 c2                	cmp    %eax,%edx
  802236:	73 6c                	jae    8022a4 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802238:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80223c:	74 06                	je     802244 <insert_sorted_allocList+0x123>
  80223e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802242:	75 14                	jne    802258 <insert_sorted_allocList+0x137>
  802244:	83 ec 04             	sub    $0x4,%esp
  802247:	68 2c 3b 80 00       	push   $0x803b2c
  80224c:	6a 75                	push   $0x75
  80224e:	68 13 3b 80 00       	push   $0x803b13
  802253:	e8 38 e0 ff ff       	call   800290 <_panic>
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	8b 50 04             	mov    0x4(%eax),%edx
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	89 50 04             	mov    %edx,0x4(%eax)
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226a:	89 10                	mov    %edx,(%eax)
  80226c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226f:	8b 40 04             	mov    0x4(%eax),%eax
  802272:	85 c0                	test   %eax,%eax
  802274:	74 0d                	je     802283 <insert_sorted_allocList+0x162>
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 40 04             	mov    0x4(%eax),%eax
  80227c:	8b 55 08             	mov    0x8(%ebp),%edx
  80227f:	89 10                	mov    %edx,(%eax)
  802281:	eb 08                	jmp    80228b <insert_sorted_allocList+0x16a>
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	a3 40 40 80 00       	mov    %eax,0x804040
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 55 08             	mov    0x8(%ebp),%edx
  802291:	89 50 04             	mov    %edx,0x4(%eax)
  802294:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802299:	40                   	inc    %eax
  80229a:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  80229f:	e9 59 01 00 00       	jmp    8023fd <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	8b 50 08             	mov    0x8(%eax),%edx
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 40 08             	mov    0x8(%eax),%eax
  8022b0:	39 c2                	cmp    %eax,%edx
  8022b2:	0f 86 98 00 00 00    	jbe    802350 <insert_sorted_allocList+0x22f>
  8022b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bb:	8b 50 08             	mov    0x8(%eax),%edx
  8022be:	a1 44 40 80 00       	mov    0x804044,%eax
  8022c3:	8b 40 08             	mov    0x8(%eax),%eax
  8022c6:	39 c2                	cmp    %eax,%edx
  8022c8:	0f 83 82 00 00 00    	jae    802350 <insert_sorted_allocList+0x22f>
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	8b 50 08             	mov    0x8(%eax),%edx
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 00                	mov    (%eax),%eax
  8022d9:	8b 40 08             	mov    0x8(%eax),%eax
  8022dc:	39 c2                	cmp    %eax,%edx
  8022de:	73 70                	jae    802350 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8022e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e4:	74 06                	je     8022ec <insert_sorted_allocList+0x1cb>
  8022e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ea:	75 14                	jne    802300 <insert_sorted_allocList+0x1df>
  8022ec:	83 ec 04             	sub    $0x4,%esp
  8022ef:	68 64 3b 80 00       	push   $0x803b64
  8022f4:	6a 7c                	push   $0x7c
  8022f6:	68 13 3b 80 00       	push   $0x803b13
  8022fb:	e8 90 df ff ff       	call   800290 <_panic>
  802300:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802303:	8b 10                	mov    (%eax),%edx
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	89 10                	mov    %edx,(%eax)
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	8b 00                	mov    (%eax),%eax
  80230f:	85 c0                	test   %eax,%eax
  802311:	74 0b                	je     80231e <insert_sorted_allocList+0x1fd>
  802313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802316:	8b 00                	mov    (%eax),%eax
  802318:	8b 55 08             	mov    0x8(%ebp),%edx
  80231b:	89 50 04             	mov    %edx,0x4(%eax)
  80231e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802321:	8b 55 08             	mov    0x8(%ebp),%edx
  802324:	89 10                	mov    %edx,(%eax)
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232c:	89 50 04             	mov    %edx,0x4(%eax)
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	8b 00                	mov    (%eax),%eax
  802334:	85 c0                	test   %eax,%eax
  802336:	75 08                	jne    802340 <insert_sorted_allocList+0x21f>
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	a3 44 40 80 00       	mov    %eax,0x804044
  802340:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802345:	40                   	inc    %eax
  802346:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80234b:	e9 ad 00 00 00       	jmp    8023fd <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802350:	8b 45 08             	mov    0x8(%ebp),%eax
  802353:	8b 50 08             	mov    0x8(%eax),%edx
  802356:	a1 44 40 80 00       	mov    0x804044,%eax
  80235b:	8b 40 08             	mov    0x8(%eax),%eax
  80235e:	39 c2                	cmp    %eax,%edx
  802360:	76 65                	jbe    8023c7 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802362:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802366:	75 17                	jne    80237f <insert_sorted_allocList+0x25e>
  802368:	83 ec 04             	sub    $0x4,%esp
  80236b:	68 98 3b 80 00       	push   $0x803b98
  802370:	68 80 00 00 00       	push   $0x80
  802375:	68 13 3b 80 00       	push   $0x803b13
  80237a:	e8 11 df ff ff       	call   800290 <_panic>
  80237f:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	89 50 04             	mov    %edx,0x4(%eax)
  80238b:	8b 45 08             	mov    0x8(%ebp),%eax
  80238e:	8b 40 04             	mov    0x4(%eax),%eax
  802391:	85 c0                	test   %eax,%eax
  802393:	74 0c                	je     8023a1 <insert_sorted_allocList+0x280>
  802395:	a1 44 40 80 00       	mov    0x804044,%eax
  80239a:	8b 55 08             	mov    0x8(%ebp),%edx
  80239d:	89 10                	mov    %edx,(%eax)
  80239f:	eb 08                	jmp    8023a9 <insert_sorted_allocList+0x288>
  8023a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a4:	a3 40 40 80 00       	mov    %eax,0x804040
  8023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ac:	a3 44 40 80 00       	mov    %eax,0x804044
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ba:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023bf:	40                   	inc    %eax
  8023c0:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8023c5:	eb 36                	jmp    8023fd <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8023c7:	a1 48 40 80 00       	mov    0x804048,%eax
  8023cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d3:	74 07                	je     8023dc <insert_sorted_allocList+0x2bb>
  8023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d8:	8b 00                	mov    (%eax),%eax
  8023da:	eb 05                	jmp    8023e1 <insert_sorted_allocList+0x2c0>
  8023dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e1:	a3 48 40 80 00       	mov    %eax,0x804048
  8023e6:	a1 48 40 80 00       	mov    0x804048,%eax
  8023eb:	85 c0                	test   %eax,%eax
  8023ed:	0f 85 23 fe ff ff    	jne    802216 <insert_sorted_allocList+0xf5>
  8023f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f7:	0f 85 19 fe ff ff    	jne    802216 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8023fd:	90                   	nop
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802406:	a1 38 41 80 00       	mov    0x804138,%eax
  80240b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240e:	e9 7c 01 00 00       	jmp    80258f <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802416:	8b 40 0c             	mov    0xc(%eax),%eax
  802419:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241c:	0f 85 90 00 00 00    	jne    8024b2 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802428:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242c:	75 17                	jne    802445 <alloc_block_FF+0x45>
  80242e:	83 ec 04             	sub    $0x4,%esp
  802431:	68 bb 3b 80 00       	push   $0x803bbb
  802436:	68 ba 00 00 00       	push   $0xba
  80243b:	68 13 3b 80 00       	push   $0x803b13
  802440:	e8 4b de ff ff       	call   800290 <_panic>
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	8b 00                	mov    (%eax),%eax
  80244a:	85 c0                	test   %eax,%eax
  80244c:	74 10                	je     80245e <alloc_block_FF+0x5e>
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	8b 00                	mov    (%eax),%eax
  802453:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802456:	8b 52 04             	mov    0x4(%edx),%edx
  802459:	89 50 04             	mov    %edx,0x4(%eax)
  80245c:	eb 0b                	jmp    802469 <alloc_block_FF+0x69>
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 40 04             	mov    0x4(%eax),%eax
  802464:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	8b 40 04             	mov    0x4(%eax),%eax
  80246f:	85 c0                	test   %eax,%eax
  802471:	74 0f                	je     802482 <alloc_block_FF+0x82>
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 40 04             	mov    0x4(%eax),%eax
  802479:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247c:	8b 12                	mov    (%edx),%edx
  80247e:	89 10                	mov    %edx,(%eax)
  802480:	eb 0a                	jmp    80248c <alloc_block_FF+0x8c>
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	8b 00                	mov    (%eax),%eax
  802487:	a3 38 41 80 00       	mov    %eax,0x804138
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80249f:	a1 44 41 80 00       	mov    0x804144,%eax
  8024a4:	48                   	dec    %eax
  8024a5:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8024aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ad:	e9 10 01 00 00       	jmp    8025c2 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024bb:	0f 86 c6 00 00 00    	jbe    802587 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8024c1:	a1 48 41 80 00       	mov    0x804148,%eax
  8024c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8024c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024cd:	75 17                	jne    8024e6 <alloc_block_FF+0xe6>
  8024cf:	83 ec 04             	sub    $0x4,%esp
  8024d2:	68 bb 3b 80 00       	push   $0x803bbb
  8024d7:	68 c2 00 00 00       	push   $0xc2
  8024dc:	68 13 3b 80 00       	push   $0x803b13
  8024e1:	e8 aa dd ff ff       	call   800290 <_panic>
  8024e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e9:	8b 00                	mov    (%eax),%eax
  8024eb:	85 c0                	test   %eax,%eax
  8024ed:	74 10                	je     8024ff <alloc_block_FF+0xff>
  8024ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f2:	8b 00                	mov    (%eax),%eax
  8024f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024f7:	8b 52 04             	mov    0x4(%edx),%edx
  8024fa:	89 50 04             	mov    %edx,0x4(%eax)
  8024fd:	eb 0b                	jmp    80250a <alloc_block_FF+0x10a>
  8024ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802502:	8b 40 04             	mov    0x4(%eax),%eax
  802505:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80250a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250d:	8b 40 04             	mov    0x4(%eax),%eax
  802510:	85 c0                	test   %eax,%eax
  802512:	74 0f                	je     802523 <alloc_block_FF+0x123>
  802514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802517:	8b 40 04             	mov    0x4(%eax),%eax
  80251a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80251d:	8b 12                	mov    (%edx),%edx
  80251f:	89 10                	mov    %edx,(%eax)
  802521:	eb 0a                	jmp    80252d <alloc_block_FF+0x12d>
  802523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802526:	8b 00                	mov    (%eax),%eax
  802528:	a3 48 41 80 00       	mov    %eax,0x804148
  80252d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802530:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802539:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802540:	a1 54 41 80 00       	mov    0x804154,%eax
  802545:	48                   	dec    %eax
  802546:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 50 08             	mov    0x8(%eax),%edx
  802551:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802554:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255a:	8b 55 08             	mov    0x8(%ebp),%edx
  80255d:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 40 0c             	mov    0xc(%eax),%eax
  802566:	2b 45 08             	sub    0x8(%ebp),%eax
  802569:	89 c2                	mov    %eax,%edx
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 50 08             	mov    0x8(%eax),%edx
  802577:	8b 45 08             	mov    0x8(%ebp),%eax
  80257a:	01 c2                	add    %eax,%edx
  80257c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257f:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802585:	eb 3b                	jmp    8025c2 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802587:	a1 40 41 80 00       	mov    0x804140,%eax
  80258c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802593:	74 07                	je     80259c <alloc_block_FF+0x19c>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	eb 05                	jmp    8025a1 <alloc_block_FF+0x1a1>
  80259c:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a1:	a3 40 41 80 00       	mov    %eax,0x804140
  8025a6:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ab:	85 c0                	test   %eax,%eax
  8025ad:	0f 85 60 fe ff ff    	jne    802413 <alloc_block_FF+0x13>
  8025b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b7:	0f 85 56 fe ff ff    	jne    802413 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8025bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c2:	c9                   	leave  
  8025c3:	c3                   	ret    

008025c4 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8025c4:	55                   	push   %ebp
  8025c5:	89 e5                	mov    %esp,%ebp
  8025c7:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8025ca:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025d1:	a1 38 41 80 00       	mov    0x804138,%eax
  8025d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d9:	eb 3a                	jmp    802615 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8025db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025de:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e4:	72 27                	jb     80260d <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8025e6:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8025ea:	75 0b                	jne    8025f7 <alloc_block_BF+0x33>
					best_size= element->size;
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8025f5:	eb 16                	jmp    80260d <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 50 0c             	mov    0xc(%eax),%edx
  8025fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802600:	39 c2                	cmp    %eax,%edx
  802602:	77 09                	ja     80260d <alloc_block_BF+0x49>
					best_size=element->size;
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 40 0c             	mov    0xc(%eax),%eax
  80260a:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80260d:	a1 40 41 80 00       	mov    0x804140,%eax
  802612:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802619:	74 07                	je     802622 <alloc_block_BF+0x5e>
  80261b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261e:	8b 00                	mov    (%eax),%eax
  802620:	eb 05                	jmp    802627 <alloc_block_BF+0x63>
  802622:	b8 00 00 00 00       	mov    $0x0,%eax
  802627:	a3 40 41 80 00       	mov    %eax,0x804140
  80262c:	a1 40 41 80 00       	mov    0x804140,%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	75 a6                	jne    8025db <alloc_block_BF+0x17>
  802635:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802639:	75 a0                	jne    8025db <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80263b:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  80263f:	0f 84 d3 01 00 00    	je     802818 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802645:	a1 38 41 80 00       	mov    0x804138,%eax
  80264a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264d:	e9 98 01 00 00       	jmp    8027ea <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802655:	3b 45 08             	cmp    0x8(%ebp),%eax
  802658:	0f 86 da 00 00 00    	jbe    802738 <alloc_block_BF+0x174>
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 50 0c             	mov    0xc(%eax),%edx
  802664:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802667:	39 c2                	cmp    %eax,%edx
  802669:	0f 85 c9 00 00 00    	jne    802738 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  80266f:	a1 48 41 80 00       	mov    0x804148,%eax
  802674:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802677:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80267b:	75 17                	jne    802694 <alloc_block_BF+0xd0>
  80267d:	83 ec 04             	sub    $0x4,%esp
  802680:	68 bb 3b 80 00       	push   $0x803bbb
  802685:	68 ea 00 00 00       	push   $0xea
  80268a:	68 13 3b 80 00       	push   $0x803b13
  80268f:	e8 fc db ff ff       	call   800290 <_panic>
  802694:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802697:	8b 00                	mov    (%eax),%eax
  802699:	85 c0                	test   %eax,%eax
  80269b:	74 10                	je     8026ad <alloc_block_BF+0xe9>
  80269d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a0:	8b 00                	mov    (%eax),%eax
  8026a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026a5:	8b 52 04             	mov    0x4(%edx),%edx
  8026a8:	89 50 04             	mov    %edx,0x4(%eax)
  8026ab:	eb 0b                	jmp    8026b8 <alloc_block_BF+0xf4>
  8026ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b0:	8b 40 04             	mov    0x4(%eax),%eax
  8026b3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bb:	8b 40 04             	mov    0x4(%eax),%eax
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	74 0f                	je     8026d1 <alloc_block_BF+0x10d>
  8026c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c5:	8b 40 04             	mov    0x4(%eax),%eax
  8026c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026cb:	8b 12                	mov    (%edx),%edx
  8026cd:	89 10                	mov    %edx,(%eax)
  8026cf:	eb 0a                	jmp    8026db <alloc_block_BF+0x117>
  8026d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d4:	8b 00                	mov    (%eax),%eax
  8026d6:	a3 48 41 80 00       	mov    %eax,0x804148
  8026db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ee:	a1 54 41 80 00       	mov    0x804154,%eax
  8026f3:	48                   	dec    %eax
  8026f4:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	8b 50 08             	mov    0x8(%eax),%edx
  8026ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802702:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  802705:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802708:	8b 55 08             	mov    0x8(%ebp),%edx
  80270b:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 40 0c             	mov    0xc(%eax),%eax
  802714:	2b 45 08             	sub    0x8(%ebp),%eax
  802717:	89 c2                	mov    %eax,%edx
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 50 08             	mov    0x8(%eax),%edx
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	01 c2                	add    %eax,%edx
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802730:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802733:	e9 e5 00 00 00       	jmp    80281d <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273b:	8b 50 0c             	mov    0xc(%eax),%edx
  80273e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802741:	39 c2                	cmp    %eax,%edx
  802743:	0f 85 99 00 00 00    	jne    8027e2 <alloc_block_BF+0x21e>
  802749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274f:	0f 85 8d 00 00 00    	jne    8027e2 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802758:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  80275b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275f:	75 17                	jne    802778 <alloc_block_BF+0x1b4>
  802761:	83 ec 04             	sub    $0x4,%esp
  802764:	68 bb 3b 80 00       	push   $0x803bbb
  802769:	68 f7 00 00 00       	push   $0xf7
  80276e:	68 13 3b 80 00       	push   $0x803b13
  802773:	e8 18 db ff ff       	call   800290 <_panic>
  802778:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	85 c0                	test   %eax,%eax
  80277f:	74 10                	je     802791 <alloc_block_BF+0x1cd>
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 00                	mov    (%eax),%eax
  802786:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802789:	8b 52 04             	mov    0x4(%edx),%edx
  80278c:	89 50 04             	mov    %edx,0x4(%eax)
  80278f:	eb 0b                	jmp    80279c <alloc_block_BF+0x1d8>
  802791:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802794:	8b 40 04             	mov    0x4(%eax),%eax
  802797:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 40 04             	mov    0x4(%eax),%eax
  8027a2:	85 c0                	test   %eax,%eax
  8027a4:	74 0f                	je     8027b5 <alloc_block_BF+0x1f1>
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027af:	8b 12                	mov    (%edx),%edx
  8027b1:	89 10                	mov    %edx,(%eax)
  8027b3:	eb 0a                	jmp    8027bf <alloc_block_BF+0x1fb>
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 00                	mov    (%eax),%eax
  8027ba:	a3 38 41 80 00       	mov    %eax,0x804138
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d2:	a1 44 41 80 00       	mov    0x804144,%eax
  8027d7:	48                   	dec    %eax
  8027d8:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8027dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e0:	eb 3b                	jmp    80281d <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8027e2:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ee:	74 07                	je     8027f7 <alloc_block_BF+0x233>
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	eb 05                	jmp    8027fc <alloc_block_BF+0x238>
  8027f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fc:	a3 40 41 80 00       	mov    %eax,0x804140
  802801:	a1 40 41 80 00       	mov    0x804140,%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	0f 85 44 fe ff ff    	jne    802652 <alloc_block_BF+0x8e>
  80280e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802812:	0f 85 3a fe ff ff    	jne    802652 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  802818:	b8 00 00 00 00       	mov    $0x0,%eax
  80281d:	c9                   	leave  
  80281e:	c3                   	ret    

0080281f <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  80281f:	55                   	push   %ebp
  802820:	89 e5                	mov    %esp,%ebp
  802822:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802825:	83 ec 04             	sub    $0x4,%esp
  802828:	68 dc 3b 80 00       	push   $0x803bdc
  80282d:	68 04 01 00 00       	push   $0x104
  802832:	68 13 3b 80 00       	push   $0x803b13
  802837:	e8 54 da ff ff       	call   800290 <_panic>

0080283c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802842:	a1 38 41 80 00       	mov    0x804138,%eax
  802847:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  80284a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80284f:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802852:	a1 38 41 80 00       	mov    0x804138,%eax
  802857:	85 c0                	test   %eax,%eax
  802859:	75 68                	jne    8028c3 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80285b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80285f:	75 17                	jne    802878 <insert_sorted_with_merge_freeList+0x3c>
  802861:	83 ec 04             	sub    $0x4,%esp
  802864:	68 f0 3a 80 00       	push   $0x803af0
  802869:	68 14 01 00 00       	push   $0x114
  80286e:	68 13 3b 80 00       	push   $0x803b13
  802873:	e8 18 da ff ff       	call   800290 <_panic>
  802878:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80287e:	8b 45 08             	mov    0x8(%ebp),%eax
  802881:	89 10                	mov    %edx,(%eax)
  802883:	8b 45 08             	mov    0x8(%ebp),%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	74 0d                	je     802899 <insert_sorted_with_merge_freeList+0x5d>
  80288c:	a1 38 41 80 00       	mov    0x804138,%eax
  802891:	8b 55 08             	mov    0x8(%ebp),%edx
  802894:	89 50 04             	mov    %edx,0x4(%eax)
  802897:	eb 08                	jmp    8028a1 <insert_sorted_with_merge_freeList+0x65>
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a4:	a3 38 41 80 00       	mov    %eax,0x804138
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b3:	a1 44 41 80 00       	mov    0x804144,%eax
  8028b8:	40                   	inc    %eax
  8028b9:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8028be:	e9 d2 06 00 00       	jmp    802f95 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	8b 50 08             	mov    0x8(%eax),%edx
  8028c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cc:	8b 40 08             	mov    0x8(%eax),%eax
  8028cf:	39 c2                	cmp    %eax,%edx
  8028d1:	0f 83 22 01 00 00    	jae    8029f9 <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8028d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028da:	8b 50 08             	mov    0x8(%eax),%edx
  8028dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e3:	01 c2                	add    %eax,%edx
  8028e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e8:	8b 40 08             	mov    0x8(%eax),%eax
  8028eb:	39 c2                	cmp    %eax,%edx
  8028ed:	0f 85 9e 00 00 00    	jne    802991 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8028f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f6:	8b 50 08             	mov    0x8(%eax),%edx
  8028f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fc:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8028ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802902:	8b 50 0c             	mov    0xc(%eax),%edx
  802905:	8b 45 08             	mov    0x8(%ebp),%eax
  802908:	8b 40 0c             	mov    0xc(%eax),%eax
  80290b:	01 c2                	add    %eax,%edx
  80290d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802910:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802913:	8b 45 08             	mov    0x8(%ebp),%eax
  802916:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  80291d:	8b 45 08             	mov    0x8(%ebp),%eax
  802920:	8b 50 08             	mov    0x8(%eax),%edx
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802929:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80292d:	75 17                	jne    802946 <insert_sorted_with_merge_freeList+0x10a>
  80292f:	83 ec 04             	sub    $0x4,%esp
  802932:	68 f0 3a 80 00       	push   $0x803af0
  802937:	68 21 01 00 00       	push   $0x121
  80293c:	68 13 3b 80 00       	push   $0x803b13
  802941:	e8 4a d9 ff ff       	call   800290 <_panic>
  802946:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	89 10                	mov    %edx,(%eax)
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	8b 00                	mov    (%eax),%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	74 0d                	je     802967 <insert_sorted_with_merge_freeList+0x12b>
  80295a:	a1 48 41 80 00       	mov    0x804148,%eax
  80295f:	8b 55 08             	mov    0x8(%ebp),%edx
  802962:	89 50 04             	mov    %edx,0x4(%eax)
  802965:	eb 08                	jmp    80296f <insert_sorted_with_merge_freeList+0x133>
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	a3 48 41 80 00       	mov    %eax,0x804148
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802981:	a1 54 41 80 00       	mov    0x804154,%eax
  802986:	40                   	inc    %eax
  802987:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  80298c:	e9 04 06 00 00       	jmp    802f95 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802991:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802995:	75 17                	jne    8029ae <insert_sorted_with_merge_freeList+0x172>
  802997:	83 ec 04             	sub    $0x4,%esp
  80299a:	68 f0 3a 80 00       	push   $0x803af0
  80299f:	68 26 01 00 00       	push   $0x126
  8029a4:	68 13 3b 80 00       	push   $0x803b13
  8029a9:	e8 e2 d8 ff ff       	call   800290 <_panic>
  8029ae:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	89 10                	mov    %edx,(%eax)
  8029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bc:	8b 00                	mov    (%eax),%eax
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	74 0d                	je     8029cf <insert_sorted_with_merge_freeList+0x193>
  8029c2:	a1 38 41 80 00       	mov    0x804138,%eax
  8029c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ca:	89 50 04             	mov    %edx,0x4(%eax)
  8029cd:	eb 08                	jmp    8029d7 <insert_sorted_with_merge_freeList+0x19b>
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	a3 38 41 80 00       	mov    %eax,0x804138
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e9:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ee:	40                   	inc    %eax
  8029ef:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8029f4:	e9 9c 05 00 00       	jmp    802f95 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  8029f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fc:	8b 50 08             	mov    0x8(%eax),%edx
  8029ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a02:	8b 40 08             	mov    0x8(%eax),%eax
  802a05:	39 c2                	cmp    %eax,%edx
  802a07:	0f 86 16 01 00 00    	jbe    802b23 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a10:	8b 50 08             	mov    0x8(%eax),%edx
  802a13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a16:	8b 40 0c             	mov    0xc(%eax),%eax
  802a19:	01 c2                	add    %eax,%edx
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	8b 40 08             	mov    0x8(%eax),%eax
  802a21:	39 c2                	cmp    %eax,%edx
  802a23:	0f 85 92 00 00 00    	jne    802abb <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2c:	8b 50 0c             	mov    0xc(%eax),%edx
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	8b 40 0c             	mov    0xc(%eax),%eax
  802a35:	01 c2                	add    %eax,%edx
  802a37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3a:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a47:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4a:	8b 50 08             	mov    0x8(%eax),%edx
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a57:	75 17                	jne    802a70 <insert_sorted_with_merge_freeList+0x234>
  802a59:	83 ec 04             	sub    $0x4,%esp
  802a5c:	68 f0 3a 80 00       	push   $0x803af0
  802a61:	68 31 01 00 00       	push   $0x131
  802a66:	68 13 3b 80 00       	push   $0x803b13
  802a6b:	e8 20 d8 ff ff       	call   800290 <_panic>
  802a70:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	89 10                	mov    %edx,(%eax)
  802a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7e:	8b 00                	mov    (%eax),%eax
  802a80:	85 c0                	test   %eax,%eax
  802a82:	74 0d                	je     802a91 <insert_sorted_with_merge_freeList+0x255>
  802a84:	a1 48 41 80 00       	mov    0x804148,%eax
  802a89:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8c:	89 50 04             	mov    %edx,0x4(%eax)
  802a8f:	eb 08                	jmp    802a99 <insert_sorted_with_merge_freeList+0x25d>
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	a3 48 41 80 00       	mov    %eax,0x804148
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aab:	a1 54 41 80 00       	mov    0x804154,%eax
  802ab0:	40                   	inc    %eax
  802ab1:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802ab6:	e9 da 04 00 00       	jmp    802f95 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802abb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802abf:	75 17                	jne    802ad8 <insert_sorted_with_merge_freeList+0x29c>
  802ac1:	83 ec 04             	sub    $0x4,%esp
  802ac4:	68 98 3b 80 00       	push   $0x803b98
  802ac9:	68 37 01 00 00       	push   $0x137
  802ace:	68 13 3b 80 00       	push   $0x803b13
  802ad3:	e8 b8 d7 ff ff       	call   800290 <_panic>
  802ad8:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	89 50 04             	mov    %edx,0x4(%eax)
  802ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae7:	8b 40 04             	mov    0x4(%eax),%eax
  802aea:	85 c0                	test   %eax,%eax
  802aec:	74 0c                	je     802afa <insert_sorted_with_merge_freeList+0x2be>
  802aee:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802af3:	8b 55 08             	mov    0x8(%ebp),%edx
  802af6:	89 10                	mov    %edx,(%eax)
  802af8:	eb 08                	jmp    802b02 <insert_sorted_with_merge_freeList+0x2c6>
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	a3 38 41 80 00       	mov    %eax,0x804138
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b13:	a1 44 41 80 00       	mov    0x804144,%eax
  802b18:	40                   	inc    %eax
  802b19:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b1e:	e9 72 04 00 00       	jmp    802f95 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802b23:	a1 38 41 80 00       	mov    0x804138,%eax
  802b28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b2b:	e9 35 04 00 00       	jmp    802f65 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 00                	mov    (%eax),%eax
  802b35:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	8b 50 08             	mov    0x8(%eax),%edx
  802b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b41:	8b 40 08             	mov    0x8(%eax),%eax
  802b44:	39 c2                	cmp    %eax,%edx
  802b46:	0f 86 11 04 00 00    	jbe    802f5d <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4f:	8b 50 08             	mov    0x8(%eax),%edx
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	8b 40 0c             	mov    0xc(%eax),%eax
  802b58:	01 c2                	add    %eax,%edx
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	8b 40 08             	mov    0x8(%eax),%eax
  802b60:	39 c2                	cmp    %eax,%edx
  802b62:	0f 83 8b 00 00 00    	jae    802bf3 <insert_sorted_with_merge_freeList+0x3b7>
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	8b 50 08             	mov    0x8(%eax),%edx
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	8b 40 0c             	mov    0xc(%eax),%eax
  802b74:	01 c2                	add    %eax,%edx
  802b76:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b79:	8b 40 08             	mov    0x8(%eax),%eax
  802b7c:	39 c2                	cmp    %eax,%edx
  802b7e:	73 73                	jae    802bf3 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802b80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b84:	74 06                	je     802b8c <insert_sorted_with_merge_freeList+0x350>
  802b86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8a:	75 17                	jne    802ba3 <insert_sorted_with_merge_freeList+0x367>
  802b8c:	83 ec 04             	sub    $0x4,%esp
  802b8f:	68 64 3b 80 00       	push   $0x803b64
  802b94:	68 48 01 00 00       	push   $0x148
  802b99:	68 13 3b 80 00       	push   $0x803b13
  802b9e:	e8 ed d6 ff ff       	call   800290 <_panic>
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 10                	mov    (%eax),%edx
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	89 10                	mov    %edx,(%eax)
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	8b 00                	mov    (%eax),%eax
  802bb2:	85 c0                	test   %eax,%eax
  802bb4:	74 0b                	je     802bc1 <insert_sorted_with_merge_freeList+0x385>
  802bb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb9:	8b 00                	mov    (%eax),%eax
  802bbb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bbe:	89 50 04             	mov    %edx,0x4(%eax)
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc7:	89 10                	mov    %edx,(%eax)
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bcf:	89 50 04             	mov    %edx,0x4(%eax)
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	85 c0                	test   %eax,%eax
  802bd9:	75 08                	jne    802be3 <insert_sorted_with_merge_freeList+0x3a7>
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802be3:	a1 44 41 80 00       	mov    0x804144,%eax
  802be8:	40                   	inc    %eax
  802be9:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802bee:	e9 a2 03 00 00       	jmp    802f95 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	8b 50 08             	mov    0x8(%eax),%edx
  802bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bff:	01 c2                	add    %eax,%edx
  802c01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c04:	8b 40 08             	mov    0x8(%eax),%eax
  802c07:	39 c2                	cmp    %eax,%edx
  802c09:	0f 83 ae 00 00 00    	jae    802cbd <insert_sorted_with_merge_freeList+0x481>
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	8b 50 08             	mov    0x8(%eax),%edx
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	8b 48 08             	mov    0x8(%eax),%ecx
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c21:	01 c8                	add    %ecx,%eax
  802c23:	39 c2                	cmp    %eax,%edx
  802c25:	0f 85 92 00 00 00    	jne    802cbd <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	8b 50 0c             	mov    0xc(%eax),%edx
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	8b 40 0c             	mov    0xc(%eax),%eax
  802c37:	01 c2                	add    %eax,%edx
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c49:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4c:	8b 50 08             	mov    0x8(%eax),%edx
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c59:	75 17                	jne    802c72 <insert_sorted_with_merge_freeList+0x436>
  802c5b:	83 ec 04             	sub    $0x4,%esp
  802c5e:	68 f0 3a 80 00       	push   $0x803af0
  802c63:	68 51 01 00 00       	push   $0x151
  802c68:	68 13 3b 80 00       	push   $0x803b13
  802c6d:	e8 1e d6 ff ff       	call   800290 <_panic>
  802c72:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	89 10                	mov    %edx,(%eax)
  802c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c80:	8b 00                	mov    (%eax),%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	74 0d                	je     802c93 <insert_sorted_with_merge_freeList+0x457>
  802c86:	a1 48 41 80 00       	mov    0x804148,%eax
  802c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8e:	89 50 04             	mov    %edx,0x4(%eax)
  802c91:	eb 08                	jmp    802c9b <insert_sorted_with_merge_freeList+0x45f>
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	a3 48 41 80 00       	mov    %eax,0x804148
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cad:	a1 54 41 80 00       	mov    0x804154,%eax
  802cb2:	40                   	inc    %eax
  802cb3:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802cb8:	e9 d8 02 00 00       	jmp    802f95 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	8b 50 08             	mov    0x8(%eax),%edx
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc9:	01 c2                	add    %eax,%edx
  802ccb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cce:	8b 40 08             	mov    0x8(%eax),%eax
  802cd1:	39 c2                	cmp    %eax,%edx
  802cd3:	0f 85 ba 00 00 00    	jne    802d93 <insert_sorted_with_merge_freeList+0x557>
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	8b 50 08             	mov    0x8(%eax),%edx
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 48 08             	mov    0x8(%eax),%ecx
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ceb:	01 c8                	add    %ecx,%eax
  802ced:	39 c2                	cmp    %eax,%edx
  802cef:	0f 86 9e 00 00 00    	jbe    802d93 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802cf5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf8:	8b 50 0c             	mov    0xc(%eax),%edx
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802d01:	01 c2                	add    %eax,%edx
  802d03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d06:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802d09:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0c:	8b 50 08             	mov    0x8(%eax),%edx
  802d0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d12:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	8b 50 08             	mov    0x8(%eax),%edx
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d2f:	75 17                	jne    802d48 <insert_sorted_with_merge_freeList+0x50c>
  802d31:	83 ec 04             	sub    $0x4,%esp
  802d34:	68 f0 3a 80 00       	push   $0x803af0
  802d39:	68 5b 01 00 00       	push   $0x15b
  802d3e:	68 13 3b 80 00       	push   $0x803b13
  802d43:	e8 48 d5 ff ff       	call   800290 <_panic>
  802d48:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d51:	89 10                	mov    %edx,(%eax)
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	74 0d                	je     802d69 <insert_sorted_with_merge_freeList+0x52d>
  802d5c:	a1 48 41 80 00       	mov    0x804148,%eax
  802d61:	8b 55 08             	mov    0x8(%ebp),%edx
  802d64:	89 50 04             	mov    %edx,0x4(%eax)
  802d67:	eb 08                	jmp    802d71 <insert_sorted_with_merge_freeList+0x535>
  802d69:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	a3 48 41 80 00       	mov    %eax,0x804148
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d83:	a1 54 41 80 00       	mov    0x804154,%eax
  802d88:	40                   	inc    %eax
  802d89:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802d8e:	e9 02 02 00 00       	jmp    802f95 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	8b 50 08             	mov    0x8(%eax),%edx
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9f:	01 c2                	add    %eax,%edx
  802da1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da4:	8b 40 08             	mov    0x8(%eax),%eax
  802da7:	39 c2                	cmp    %eax,%edx
  802da9:	0f 85 ae 01 00 00    	jne    802f5d <insert_sorted_with_merge_freeList+0x721>
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	8b 50 08             	mov    0x8(%eax),%edx
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 48 08             	mov    0x8(%eax),%ecx
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc1:	01 c8                	add    %ecx,%eax
  802dc3:	39 c2                	cmp    %eax,%edx
  802dc5:	0f 85 92 01 00 00    	jne    802f5d <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dce:	8b 50 0c             	mov    0xc(%eax),%edx
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd7:	01 c2                	add    %eax,%edx
  802dd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ddc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddf:	01 c2                	add    %eax,%edx
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802de7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dea:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802df1:	8b 45 08             	mov    0x8(%ebp),%eax
  802df4:	8b 50 08             	mov    0x8(%eax),%edx
  802df7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfa:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802dfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e07:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e0a:	8b 50 08             	mov    0x8(%eax),%edx
  802e0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e10:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802e13:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e17:	75 17                	jne    802e30 <insert_sorted_with_merge_freeList+0x5f4>
  802e19:	83 ec 04             	sub    $0x4,%esp
  802e1c:	68 bb 3b 80 00       	push   $0x803bbb
  802e21:	68 63 01 00 00       	push   $0x163
  802e26:	68 13 3b 80 00       	push   $0x803b13
  802e2b:	e8 60 d4 ff ff       	call   800290 <_panic>
  802e30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e33:	8b 00                	mov    (%eax),%eax
  802e35:	85 c0                	test   %eax,%eax
  802e37:	74 10                	je     802e49 <insert_sorted_with_merge_freeList+0x60d>
  802e39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e3c:	8b 00                	mov    (%eax),%eax
  802e3e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e41:	8b 52 04             	mov    0x4(%edx),%edx
  802e44:	89 50 04             	mov    %edx,0x4(%eax)
  802e47:	eb 0b                	jmp    802e54 <insert_sorted_with_merge_freeList+0x618>
  802e49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e4c:	8b 40 04             	mov    0x4(%eax),%eax
  802e4f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e54:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e57:	8b 40 04             	mov    0x4(%eax),%eax
  802e5a:	85 c0                	test   %eax,%eax
  802e5c:	74 0f                	je     802e6d <insert_sorted_with_merge_freeList+0x631>
  802e5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e61:	8b 40 04             	mov    0x4(%eax),%eax
  802e64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e67:	8b 12                	mov    (%edx),%edx
  802e69:	89 10                	mov    %edx,(%eax)
  802e6b:	eb 0a                	jmp    802e77 <insert_sorted_with_merge_freeList+0x63b>
  802e6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e70:	8b 00                	mov    (%eax),%eax
  802e72:	a3 38 41 80 00       	mov    %eax,0x804138
  802e77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e8a:	a1 44 41 80 00       	mov    0x804144,%eax
  802e8f:	48                   	dec    %eax
  802e90:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802e95:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e99:	75 17                	jne    802eb2 <insert_sorted_with_merge_freeList+0x676>
  802e9b:	83 ec 04             	sub    $0x4,%esp
  802e9e:	68 f0 3a 80 00       	push   $0x803af0
  802ea3:	68 64 01 00 00       	push   $0x164
  802ea8:	68 13 3b 80 00       	push   $0x803b13
  802ead:	e8 de d3 ff ff       	call   800290 <_panic>
  802eb2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebb:	89 10                	mov    %edx,(%eax)
  802ebd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	85 c0                	test   %eax,%eax
  802ec4:	74 0d                	je     802ed3 <insert_sorted_with_merge_freeList+0x697>
  802ec6:	a1 48 41 80 00       	mov    0x804148,%eax
  802ecb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ece:	89 50 04             	mov    %edx,0x4(%eax)
  802ed1:	eb 08                	jmp    802edb <insert_sorted_with_merge_freeList+0x69f>
  802ed3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802edb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ede:	a3 48 41 80 00       	mov    %eax,0x804148
  802ee3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eed:	a1 54 41 80 00       	mov    0x804154,%eax
  802ef2:	40                   	inc    %eax
  802ef3:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802ef8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802efc:	75 17                	jne    802f15 <insert_sorted_with_merge_freeList+0x6d9>
  802efe:	83 ec 04             	sub    $0x4,%esp
  802f01:	68 f0 3a 80 00       	push   $0x803af0
  802f06:	68 65 01 00 00       	push   $0x165
  802f0b:	68 13 3b 80 00       	push   $0x803b13
  802f10:	e8 7b d3 ff ff       	call   800290 <_panic>
  802f15:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1e:	89 10                	mov    %edx,(%eax)
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	8b 00                	mov    (%eax),%eax
  802f25:	85 c0                	test   %eax,%eax
  802f27:	74 0d                	je     802f36 <insert_sorted_with_merge_freeList+0x6fa>
  802f29:	a1 48 41 80 00       	mov    0x804148,%eax
  802f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f31:	89 50 04             	mov    %edx,0x4(%eax)
  802f34:	eb 08                	jmp    802f3e <insert_sorted_with_merge_freeList+0x702>
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	a3 48 41 80 00       	mov    %eax,0x804148
  802f46:	8b 45 08             	mov    0x8(%ebp),%eax
  802f49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f50:	a1 54 41 80 00       	mov    0x804154,%eax
  802f55:	40                   	inc    %eax
  802f56:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802f5b:	eb 38                	jmp    802f95 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f5d:	a1 40 41 80 00       	mov    0x804140,%eax
  802f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f69:	74 07                	je     802f72 <insert_sorted_with_merge_freeList+0x736>
  802f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6e:	8b 00                	mov    (%eax),%eax
  802f70:	eb 05                	jmp    802f77 <insert_sorted_with_merge_freeList+0x73b>
  802f72:	b8 00 00 00 00       	mov    $0x0,%eax
  802f77:	a3 40 41 80 00       	mov    %eax,0x804140
  802f7c:	a1 40 41 80 00       	mov    0x804140,%eax
  802f81:	85 c0                	test   %eax,%eax
  802f83:	0f 85 a7 fb ff ff    	jne    802b30 <insert_sorted_with_merge_freeList+0x2f4>
  802f89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8d:	0f 85 9d fb ff ff    	jne    802b30 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802f93:	eb 00                	jmp    802f95 <insert_sorted_with_merge_freeList+0x759>
  802f95:	90                   	nop
  802f96:	c9                   	leave  
  802f97:	c3                   	ret    

00802f98 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802f98:	55                   	push   %ebp
  802f99:	89 e5                	mov    %esp,%ebp
  802f9b:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802f9e:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa1:	89 d0                	mov    %edx,%eax
  802fa3:	c1 e0 02             	shl    $0x2,%eax
  802fa6:	01 d0                	add    %edx,%eax
  802fa8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802faf:	01 d0                	add    %edx,%eax
  802fb1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fb8:	01 d0                	add    %edx,%eax
  802fba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fc1:	01 d0                	add    %edx,%eax
  802fc3:	c1 e0 04             	shl    $0x4,%eax
  802fc6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802fc9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802fd0:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802fd3:	83 ec 0c             	sub    $0xc,%esp
  802fd6:	50                   	push   %eax
  802fd7:	e8 ee eb ff ff       	call   801bca <sys_get_virtual_time>
  802fdc:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802fdf:	eb 41                	jmp    803022 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802fe1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802fe4:	83 ec 0c             	sub    $0xc,%esp
  802fe7:	50                   	push   %eax
  802fe8:	e8 dd eb ff ff       	call   801bca <sys_get_virtual_time>
  802fed:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802ff0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802ff3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ff6:	29 c2                	sub    %eax,%edx
  802ff8:	89 d0                	mov    %edx,%eax
  802ffa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802ffd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803000:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803003:	89 d1                	mov    %edx,%ecx
  803005:	29 c1                	sub    %eax,%ecx
  803007:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80300a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80300d:	39 c2                	cmp    %eax,%edx
  80300f:	0f 97 c0             	seta   %al
  803012:	0f b6 c0             	movzbl %al,%eax
  803015:	29 c1                	sub    %eax,%ecx
  803017:	89 c8                	mov    %ecx,%eax
  803019:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80301c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80301f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803025:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803028:	72 b7                	jb     802fe1 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80302a:	90                   	nop
  80302b:	c9                   	leave  
  80302c:	c3                   	ret    

0080302d <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80302d:	55                   	push   %ebp
  80302e:	89 e5                	mov    %esp,%ebp
  803030:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803033:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80303a:	eb 03                	jmp    80303f <busy_wait+0x12>
  80303c:	ff 45 fc             	incl   -0x4(%ebp)
  80303f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803042:	3b 45 08             	cmp    0x8(%ebp),%eax
  803045:	72 f5                	jb     80303c <busy_wait+0xf>
	return i;
  803047:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80304a:	c9                   	leave  
  80304b:	c3                   	ret    

0080304c <__udivdi3>:
  80304c:	55                   	push   %ebp
  80304d:	57                   	push   %edi
  80304e:	56                   	push   %esi
  80304f:	53                   	push   %ebx
  803050:	83 ec 1c             	sub    $0x1c,%esp
  803053:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803057:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80305b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80305f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803063:	89 ca                	mov    %ecx,%edx
  803065:	89 f8                	mov    %edi,%eax
  803067:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80306b:	85 f6                	test   %esi,%esi
  80306d:	75 2d                	jne    80309c <__udivdi3+0x50>
  80306f:	39 cf                	cmp    %ecx,%edi
  803071:	77 65                	ja     8030d8 <__udivdi3+0x8c>
  803073:	89 fd                	mov    %edi,%ebp
  803075:	85 ff                	test   %edi,%edi
  803077:	75 0b                	jne    803084 <__udivdi3+0x38>
  803079:	b8 01 00 00 00       	mov    $0x1,%eax
  80307e:	31 d2                	xor    %edx,%edx
  803080:	f7 f7                	div    %edi
  803082:	89 c5                	mov    %eax,%ebp
  803084:	31 d2                	xor    %edx,%edx
  803086:	89 c8                	mov    %ecx,%eax
  803088:	f7 f5                	div    %ebp
  80308a:	89 c1                	mov    %eax,%ecx
  80308c:	89 d8                	mov    %ebx,%eax
  80308e:	f7 f5                	div    %ebp
  803090:	89 cf                	mov    %ecx,%edi
  803092:	89 fa                	mov    %edi,%edx
  803094:	83 c4 1c             	add    $0x1c,%esp
  803097:	5b                   	pop    %ebx
  803098:	5e                   	pop    %esi
  803099:	5f                   	pop    %edi
  80309a:	5d                   	pop    %ebp
  80309b:	c3                   	ret    
  80309c:	39 ce                	cmp    %ecx,%esi
  80309e:	77 28                	ja     8030c8 <__udivdi3+0x7c>
  8030a0:	0f bd fe             	bsr    %esi,%edi
  8030a3:	83 f7 1f             	xor    $0x1f,%edi
  8030a6:	75 40                	jne    8030e8 <__udivdi3+0x9c>
  8030a8:	39 ce                	cmp    %ecx,%esi
  8030aa:	72 0a                	jb     8030b6 <__udivdi3+0x6a>
  8030ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030b0:	0f 87 9e 00 00 00    	ja     803154 <__udivdi3+0x108>
  8030b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030bb:	89 fa                	mov    %edi,%edx
  8030bd:	83 c4 1c             	add    $0x1c,%esp
  8030c0:	5b                   	pop    %ebx
  8030c1:	5e                   	pop    %esi
  8030c2:	5f                   	pop    %edi
  8030c3:	5d                   	pop    %ebp
  8030c4:	c3                   	ret    
  8030c5:	8d 76 00             	lea    0x0(%esi),%esi
  8030c8:	31 ff                	xor    %edi,%edi
  8030ca:	31 c0                	xor    %eax,%eax
  8030cc:	89 fa                	mov    %edi,%edx
  8030ce:	83 c4 1c             	add    $0x1c,%esp
  8030d1:	5b                   	pop    %ebx
  8030d2:	5e                   	pop    %esi
  8030d3:	5f                   	pop    %edi
  8030d4:	5d                   	pop    %ebp
  8030d5:	c3                   	ret    
  8030d6:	66 90                	xchg   %ax,%ax
  8030d8:	89 d8                	mov    %ebx,%eax
  8030da:	f7 f7                	div    %edi
  8030dc:	31 ff                	xor    %edi,%edi
  8030de:	89 fa                	mov    %edi,%edx
  8030e0:	83 c4 1c             	add    $0x1c,%esp
  8030e3:	5b                   	pop    %ebx
  8030e4:	5e                   	pop    %esi
  8030e5:	5f                   	pop    %edi
  8030e6:	5d                   	pop    %ebp
  8030e7:	c3                   	ret    
  8030e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030ed:	89 eb                	mov    %ebp,%ebx
  8030ef:	29 fb                	sub    %edi,%ebx
  8030f1:	89 f9                	mov    %edi,%ecx
  8030f3:	d3 e6                	shl    %cl,%esi
  8030f5:	89 c5                	mov    %eax,%ebp
  8030f7:	88 d9                	mov    %bl,%cl
  8030f9:	d3 ed                	shr    %cl,%ebp
  8030fb:	89 e9                	mov    %ebp,%ecx
  8030fd:	09 f1                	or     %esi,%ecx
  8030ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803103:	89 f9                	mov    %edi,%ecx
  803105:	d3 e0                	shl    %cl,%eax
  803107:	89 c5                	mov    %eax,%ebp
  803109:	89 d6                	mov    %edx,%esi
  80310b:	88 d9                	mov    %bl,%cl
  80310d:	d3 ee                	shr    %cl,%esi
  80310f:	89 f9                	mov    %edi,%ecx
  803111:	d3 e2                	shl    %cl,%edx
  803113:	8b 44 24 08          	mov    0x8(%esp),%eax
  803117:	88 d9                	mov    %bl,%cl
  803119:	d3 e8                	shr    %cl,%eax
  80311b:	09 c2                	or     %eax,%edx
  80311d:	89 d0                	mov    %edx,%eax
  80311f:	89 f2                	mov    %esi,%edx
  803121:	f7 74 24 0c          	divl   0xc(%esp)
  803125:	89 d6                	mov    %edx,%esi
  803127:	89 c3                	mov    %eax,%ebx
  803129:	f7 e5                	mul    %ebp
  80312b:	39 d6                	cmp    %edx,%esi
  80312d:	72 19                	jb     803148 <__udivdi3+0xfc>
  80312f:	74 0b                	je     80313c <__udivdi3+0xf0>
  803131:	89 d8                	mov    %ebx,%eax
  803133:	31 ff                	xor    %edi,%edi
  803135:	e9 58 ff ff ff       	jmp    803092 <__udivdi3+0x46>
  80313a:	66 90                	xchg   %ax,%ax
  80313c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803140:	89 f9                	mov    %edi,%ecx
  803142:	d3 e2                	shl    %cl,%edx
  803144:	39 c2                	cmp    %eax,%edx
  803146:	73 e9                	jae    803131 <__udivdi3+0xe5>
  803148:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80314b:	31 ff                	xor    %edi,%edi
  80314d:	e9 40 ff ff ff       	jmp    803092 <__udivdi3+0x46>
  803152:	66 90                	xchg   %ax,%ax
  803154:	31 c0                	xor    %eax,%eax
  803156:	e9 37 ff ff ff       	jmp    803092 <__udivdi3+0x46>
  80315b:	90                   	nop

0080315c <__umoddi3>:
  80315c:	55                   	push   %ebp
  80315d:	57                   	push   %edi
  80315e:	56                   	push   %esi
  80315f:	53                   	push   %ebx
  803160:	83 ec 1c             	sub    $0x1c,%esp
  803163:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803167:	8b 74 24 34          	mov    0x34(%esp),%esi
  80316b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80316f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803173:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803177:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80317b:	89 f3                	mov    %esi,%ebx
  80317d:	89 fa                	mov    %edi,%edx
  80317f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803183:	89 34 24             	mov    %esi,(%esp)
  803186:	85 c0                	test   %eax,%eax
  803188:	75 1a                	jne    8031a4 <__umoddi3+0x48>
  80318a:	39 f7                	cmp    %esi,%edi
  80318c:	0f 86 a2 00 00 00    	jbe    803234 <__umoddi3+0xd8>
  803192:	89 c8                	mov    %ecx,%eax
  803194:	89 f2                	mov    %esi,%edx
  803196:	f7 f7                	div    %edi
  803198:	89 d0                	mov    %edx,%eax
  80319a:	31 d2                	xor    %edx,%edx
  80319c:	83 c4 1c             	add    $0x1c,%esp
  80319f:	5b                   	pop    %ebx
  8031a0:	5e                   	pop    %esi
  8031a1:	5f                   	pop    %edi
  8031a2:	5d                   	pop    %ebp
  8031a3:	c3                   	ret    
  8031a4:	39 f0                	cmp    %esi,%eax
  8031a6:	0f 87 ac 00 00 00    	ja     803258 <__umoddi3+0xfc>
  8031ac:	0f bd e8             	bsr    %eax,%ebp
  8031af:	83 f5 1f             	xor    $0x1f,%ebp
  8031b2:	0f 84 ac 00 00 00    	je     803264 <__umoddi3+0x108>
  8031b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8031bd:	29 ef                	sub    %ebp,%edi
  8031bf:	89 fe                	mov    %edi,%esi
  8031c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031c5:	89 e9                	mov    %ebp,%ecx
  8031c7:	d3 e0                	shl    %cl,%eax
  8031c9:	89 d7                	mov    %edx,%edi
  8031cb:	89 f1                	mov    %esi,%ecx
  8031cd:	d3 ef                	shr    %cl,%edi
  8031cf:	09 c7                	or     %eax,%edi
  8031d1:	89 e9                	mov    %ebp,%ecx
  8031d3:	d3 e2                	shl    %cl,%edx
  8031d5:	89 14 24             	mov    %edx,(%esp)
  8031d8:	89 d8                	mov    %ebx,%eax
  8031da:	d3 e0                	shl    %cl,%eax
  8031dc:	89 c2                	mov    %eax,%edx
  8031de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031e2:	d3 e0                	shl    %cl,%eax
  8031e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ec:	89 f1                	mov    %esi,%ecx
  8031ee:	d3 e8                	shr    %cl,%eax
  8031f0:	09 d0                	or     %edx,%eax
  8031f2:	d3 eb                	shr    %cl,%ebx
  8031f4:	89 da                	mov    %ebx,%edx
  8031f6:	f7 f7                	div    %edi
  8031f8:	89 d3                	mov    %edx,%ebx
  8031fa:	f7 24 24             	mull   (%esp)
  8031fd:	89 c6                	mov    %eax,%esi
  8031ff:	89 d1                	mov    %edx,%ecx
  803201:	39 d3                	cmp    %edx,%ebx
  803203:	0f 82 87 00 00 00    	jb     803290 <__umoddi3+0x134>
  803209:	0f 84 91 00 00 00    	je     8032a0 <__umoddi3+0x144>
  80320f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803213:	29 f2                	sub    %esi,%edx
  803215:	19 cb                	sbb    %ecx,%ebx
  803217:	89 d8                	mov    %ebx,%eax
  803219:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80321d:	d3 e0                	shl    %cl,%eax
  80321f:	89 e9                	mov    %ebp,%ecx
  803221:	d3 ea                	shr    %cl,%edx
  803223:	09 d0                	or     %edx,%eax
  803225:	89 e9                	mov    %ebp,%ecx
  803227:	d3 eb                	shr    %cl,%ebx
  803229:	89 da                	mov    %ebx,%edx
  80322b:	83 c4 1c             	add    $0x1c,%esp
  80322e:	5b                   	pop    %ebx
  80322f:	5e                   	pop    %esi
  803230:	5f                   	pop    %edi
  803231:	5d                   	pop    %ebp
  803232:	c3                   	ret    
  803233:	90                   	nop
  803234:	89 fd                	mov    %edi,%ebp
  803236:	85 ff                	test   %edi,%edi
  803238:	75 0b                	jne    803245 <__umoddi3+0xe9>
  80323a:	b8 01 00 00 00       	mov    $0x1,%eax
  80323f:	31 d2                	xor    %edx,%edx
  803241:	f7 f7                	div    %edi
  803243:	89 c5                	mov    %eax,%ebp
  803245:	89 f0                	mov    %esi,%eax
  803247:	31 d2                	xor    %edx,%edx
  803249:	f7 f5                	div    %ebp
  80324b:	89 c8                	mov    %ecx,%eax
  80324d:	f7 f5                	div    %ebp
  80324f:	89 d0                	mov    %edx,%eax
  803251:	e9 44 ff ff ff       	jmp    80319a <__umoddi3+0x3e>
  803256:	66 90                	xchg   %ax,%ax
  803258:	89 c8                	mov    %ecx,%eax
  80325a:	89 f2                	mov    %esi,%edx
  80325c:	83 c4 1c             	add    $0x1c,%esp
  80325f:	5b                   	pop    %ebx
  803260:	5e                   	pop    %esi
  803261:	5f                   	pop    %edi
  803262:	5d                   	pop    %ebp
  803263:	c3                   	ret    
  803264:	3b 04 24             	cmp    (%esp),%eax
  803267:	72 06                	jb     80326f <__umoddi3+0x113>
  803269:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80326d:	77 0f                	ja     80327e <__umoddi3+0x122>
  80326f:	89 f2                	mov    %esi,%edx
  803271:	29 f9                	sub    %edi,%ecx
  803273:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803277:	89 14 24             	mov    %edx,(%esp)
  80327a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80327e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803282:	8b 14 24             	mov    (%esp),%edx
  803285:	83 c4 1c             	add    $0x1c,%esp
  803288:	5b                   	pop    %ebx
  803289:	5e                   	pop    %esi
  80328a:	5f                   	pop    %edi
  80328b:	5d                   	pop    %ebp
  80328c:	c3                   	ret    
  80328d:	8d 76 00             	lea    0x0(%esi),%esi
  803290:	2b 04 24             	sub    (%esp),%eax
  803293:	19 fa                	sbb    %edi,%edx
  803295:	89 d1                	mov    %edx,%ecx
  803297:	89 c6                	mov    %eax,%esi
  803299:	e9 71 ff ff ff       	jmp    80320f <__umoddi3+0xb3>
  80329e:	66 90                	xchg   %ax,%ax
  8032a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032a4:	72 ea                	jb     803290 <__umoddi3+0x134>
  8032a6:	89 d9                	mov    %ebx,%ecx
  8032a8:	e9 62 ff ff ff       	jmp    80320f <__umoddi3+0xb3>
