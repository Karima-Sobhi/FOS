
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 44 01 00 00       	call   80017a <libmain>
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
  80008c:	68 e0 32 80 00       	push   $0x8032e0
  800091:	6a 12                	push   $0x12
  800093:	68 fc 32 80 00       	push   $0x8032fc
  800098:	e8 19 02 00 00       	call   8002b6 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 ef 13 00 00       	call   801496 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  8000aa:	e8 0e 1b 00 00       	call   801bbd <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 19 33 80 00       	push   $0x803319
  8000b7:	50                   	push   %eax
  8000b8:	e8 d1 15 00 00       	call   80168e <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 1c 33 80 00       	push   $0x80331c
  8000cb:	e8 9a 04 00 00       	call   80056a <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  8000d3:	e8 0a 1c 00 00       	call   801ce2 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 44 33 80 00       	push   $0x803344
  8000e0:	e8 85 04 00 00       	call   80056a <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 28 23 00 00       	push   $0x2328
  8000f0:	e8 c9 2e 00 00       	call   802fbe <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000f8:	90                   	nop
  8000f9:	e8 fe 1b 00 00       	call   801cfc <gettst>
  8000fe:	83 f8 02             	cmp    $0x2,%eax
  800101:	75 f6                	jne    8000f9 <_main+0xc1>

	int freeFrames = sys_calculate_free_frames() ;
  800103:	e8 bc 17 00 00       	call   8018c4 <sys_calculate_free_frames>
  800108:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 ec             	pushl  -0x14(%ebp)
  800111:	e8 4e 16 00 00       	call   801764 <sfree>
  800116:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 64 33 80 00       	push   $0x803364
  800121:	e8 44 04 00 00       	call   80056a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  800129:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800130:	e8 8f 17 00 00       	call   8018c4 <sys_calculate_free_frames>
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	39 c2                	cmp    %eax,%edx
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 7c 33 80 00       	push   $0x80337c
  80014b:	6a 2a                	push   $0x2a
  80014d:	68 fc 32 80 00       	push   $0x8032fc
  800152:	e8 5f 01 00 00       	call   8002b6 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 1c 34 80 00       	push   $0x80341c
  80015f:	e8 06 04 00 00       	call   80056a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	68 40 34 80 00       	push   $0x803440
  80016f:	e8 f6 03 00 00       	call   80056a <cprintf>
  800174:	83 c4 10             	add    $0x10,%esp

	return;
  800177:	90                   	nop
}
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800180:	e8 1f 1a 00 00       	call   801ba4 <sys_getenvindex>
  800185:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018b:	89 d0                	mov    %edx,%eax
  80018d:	c1 e0 03             	shl    $0x3,%eax
  800190:	01 d0                	add    %edx,%eax
  800192:	01 c0                	add    %eax,%eax
  800194:	01 d0                	add    %edx,%eax
  800196:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80019d:	01 d0                	add    %edx,%eax
  80019f:	c1 e0 04             	shl    $0x4,%eax
  8001a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001b7:	84 c0                	test   %al,%al
  8001b9:	74 0f                	je     8001ca <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	05 5c 05 00 00       	add    $0x55c,%eax
  8001c5:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ce:	7e 0a                	jle    8001da <libmain+0x60>
		binaryname = argv[0];
  8001d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 0c             	pushl  0xc(%ebp)
  8001e0:	ff 75 08             	pushl  0x8(%ebp)
  8001e3:	e8 50 fe ff ff       	call   800038 <_main>
  8001e8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001eb:	e8 c1 17 00 00       	call   8019b1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 a4 34 80 00       	push   $0x8034a4
  8001f8:	e8 6d 03 00 00       	call   80056a <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800200:	a1 20 40 80 00       	mov    0x804020,%eax
  800205:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80020b:	a1 20 40 80 00       	mov    0x804020,%eax
  800210:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 cc 34 80 00       	push   $0x8034cc
  800220:	e8 45 03 00 00       	call   80056a <cprintf>
  800225:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800228:	a1 20 40 80 00       	mov    0x804020,%eax
  80022d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80023e:	a1 20 40 80 00       	mov    0x804020,%eax
  800243:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800249:	51                   	push   %ecx
  80024a:	52                   	push   %edx
  80024b:	50                   	push   %eax
  80024c:	68 f4 34 80 00       	push   $0x8034f4
  800251:	e8 14 03 00 00       	call   80056a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 40 80 00       	mov    0x804020,%eax
  80025e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 4c 35 80 00       	push   $0x80354c
  80026d:	e8 f8 02 00 00       	call   80056a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 a4 34 80 00       	push   $0x8034a4
  80027d:	e8 e8 02 00 00       	call   80056a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800285:	e8 41 17 00 00       	call   8019cb <sys_enable_interrupt>

	// exit gracefully
	exit();
  80028a:	e8 19 00 00 00       	call   8002a8 <exit>
}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 00                	push   $0x0
  80029d:	e8 ce 18 00 00       	call   801b70 <sys_destroy_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <exit>:

void
exit(void)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ae:	e8 23 19 00 00       	call   801bd6 <sys_exit_env>
}
  8002b3:	90                   	nop
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    

008002b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8002bf:	83 c0 04             	add    $0x4,%eax
  8002c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002c5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ca:	85 c0                	test   %eax,%eax
  8002cc:	74 16                	je     8002e4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ce:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	50                   	push   %eax
  8002d7:	68 60 35 80 00       	push   $0x803560
  8002dc:	e8 89 02 00 00       	call   80056a <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e4:	a1 00 40 80 00       	mov    0x804000,%eax
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	50                   	push   %eax
  8002f0:	68 65 35 80 00       	push   $0x803565
  8002f5:	e8 70 02 00 00       	call   80056a <cprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	ff 75 f4             	pushl  -0xc(%ebp)
  800306:	50                   	push   %eax
  800307:	e8 f3 01 00 00       	call   8004ff <vcprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	6a 00                	push   $0x0
  800314:	68 81 35 80 00       	push   $0x803581
  800319:	e8 e1 01 00 00       	call   8004ff <vcprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800321:	e8 82 ff ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  800326:	eb fe                	jmp    800326 <_panic+0x70>

00800328 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80032e:	a1 20 40 80 00       	mov    0x804020,%eax
  800333:	8b 50 74             	mov    0x74(%eax),%edx
  800336:	8b 45 0c             	mov    0xc(%ebp),%eax
  800339:	39 c2                	cmp    %eax,%edx
  80033b:	74 14                	je     800351 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 84 35 80 00       	push   $0x803584
  800345:	6a 26                	push   $0x26
  800347:	68 d0 35 80 00       	push   $0x8035d0
  80034c:	e8 65 ff ff ff       	call   8002b6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800358:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035f:	e9 c2 00 00 00       	jmp    800426 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800367:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	01 d0                	add    %edx,%eax
  800373:	8b 00                	mov    (%eax),%eax
  800375:	85 c0                	test   %eax,%eax
  800377:	75 08                	jne    800381 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800379:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80037c:	e9 a2 00 00 00       	jmp    800423 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800381:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800388:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038f:	eb 69                	jmp    8003fa <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800391:	a1 20 40 80 00       	mov    0x804020,%eax
  800396:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80039c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	01 c0                	add    %eax,%eax
  8003a3:	01 d0                	add    %edx,%eax
  8003a5:	c1 e0 03             	shl    $0x3,%eax
  8003a8:	01 c8                	add    %ecx,%eax
  8003aa:	8a 40 04             	mov    0x4(%eax),%al
  8003ad:	84 c0                	test   %al,%al
  8003af:	75 46                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003bf:	89 d0                	mov    %edx,%eax
  8003c1:	01 c0                	add    %eax,%eax
  8003c3:	01 d0                	add    %edx,%eax
  8003c5:	c1 e0 03             	shl    $0x3,%eax
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c8                	add    %ecx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ea:	39 c2                	cmp    %eax,%edx
  8003ec:	75 09                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003f5:	eb 12                	jmp    800409 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f7:	ff 45 e8             	incl   -0x18(%ebp)
  8003fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ff:	8b 50 74             	mov    0x74(%eax),%edx
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	39 c2                	cmp    %eax,%edx
  800407:	77 88                	ja     800391 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800409:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80040d:	75 14                	jne    800423 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 dc 35 80 00       	push   $0x8035dc
  800417:	6a 3a                	push   $0x3a
  800419:	68 d0 35 80 00       	push   $0x8035d0
  80041e:	e8 93 fe ff ff       	call   8002b6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800423:	ff 45 f0             	incl   -0x10(%ebp)
  800426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800429:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042c:	0f 8c 32 ff ff ff    	jl     800364 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800432:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800439:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800440:	eb 26                	jmp    800468 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800442:	a1 20 40 80 00       	mov    0x804020,%eax
  800447:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80044d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800450:	89 d0                	mov    %edx,%eax
  800452:	01 c0                	add    %eax,%eax
  800454:	01 d0                	add    %edx,%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	01 c8                	add    %ecx,%eax
  80045b:	8a 40 04             	mov    0x4(%eax),%al
  80045e:	3c 01                	cmp    $0x1,%al
  800460:	75 03                	jne    800465 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800462:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800465:	ff 45 e0             	incl   -0x20(%ebp)
  800468:	a1 20 40 80 00       	mov    0x804020,%eax
  80046d:	8b 50 74             	mov    0x74(%eax),%edx
  800470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800473:	39 c2                	cmp    %eax,%edx
  800475:	77 cb                	ja     800442 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047d:	74 14                	je     800493 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 30 36 80 00       	push   $0x803630
  800487:	6a 44                	push   $0x44
  800489:	68 d0 35 80 00       	push   $0x8035d0
  80048e:	e8 23 fe ff ff       	call   8002b6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800493:	90                   	nop
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	89 0a                	mov    %ecx,(%edx)
  8004a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ac:	88 d1                	mov    %dl,%cl
  8004ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bf:	75 2c                	jne    8004ed <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c1:	a0 24 40 80 00       	mov    0x804024,%al
  8004c6:	0f b6 c0             	movzbl %al,%eax
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	8b 12                	mov    (%edx),%edx
  8004ce:	89 d1                	mov    %edx,%ecx
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	83 c2 08             	add    $0x8,%edx
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	50                   	push   %eax
  8004da:	51                   	push   %ecx
  8004db:	52                   	push   %edx
  8004dc:	e8 22 13 00 00       	call   801803 <sys_cputs>
  8004e1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	8b 40 04             	mov    0x4(%eax),%eax
  8004f3:	8d 50 01             	lea    0x1(%eax),%edx
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fc:	90                   	nop
  8004fd:	c9                   	leave  
  8004fe:	c3                   	ret    

008004ff <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800508:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050f:	00 00 00 
	b.cnt = 0;
  800512:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800519:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800528:	50                   	push   %eax
  800529:	68 96 04 80 00       	push   $0x800496
  80052e:	e8 11 02 00 00       	call   800744 <vprintfmt>
  800533:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800536:	a0 24 40 80 00       	mov    0x804024,%al
  80053b:	0f b6 c0             	movzbl %al,%eax
  80053e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800544:	83 ec 04             	sub    $0x4,%esp
  800547:	50                   	push   %eax
  800548:	52                   	push   %edx
  800549:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054f:	83 c0 08             	add    $0x8,%eax
  800552:	50                   	push   %eax
  800553:	e8 ab 12 00 00       	call   801803 <sys_cputs>
  800558:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80055b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800562:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <cprintf>:

int cprintf(const char *fmt, ...) {
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800570:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800577:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	ff 75 f4             	pushl  -0xc(%ebp)
  800586:	50                   	push   %eax
  800587:	e8 73 ff ff ff       	call   8004ff <vcprintf>
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800592:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80059d:	e8 0f 14 00 00       	call   8019b1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b1:	50                   	push   %eax
  8005b2:	e8 48 ff ff ff       	call   8004ff <vcprintf>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005bd:	e8 09 14 00 00       	call   8019cb <sys_enable_interrupt>
	return cnt;
  8005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 14             	sub    $0x14,%esp
  8005ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005da:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e5:	77 55                	ja     80063c <printnum+0x75>
  8005e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ea:	72 05                	jb     8005f1 <printnum+0x2a>
  8005ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ef:	77 4b                	ja     80063c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ff:	52                   	push   %edx
  800600:	50                   	push   %eax
  800601:	ff 75 f4             	pushl  -0xc(%ebp)
  800604:	ff 75 f0             	pushl  -0x10(%ebp)
  800607:	e8 68 2a 00 00       	call   803074 <__udivdi3>
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 20             	pushl  0x20(%ebp)
  800615:	53                   	push   %ebx
  800616:	ff 75 18             	pushl  0x18(%ebp)
  800619:	52                   	push   %edx
  80061a:	50                   	push   %eax
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	ff 75 08             	pushl  0x8(%ebp)
  800621:	e8 a1 ff ff ff       	call   8005c7 <printnum>
  800626:	83 c4 20             	add    $0x20,%esp
  800629:	eb 1a                	jmp    800645 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 20             	pushl  0x20(%ebp)
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	ff d0                	call   *%eax
  800639:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063c:	ff 4d 1c             	decl   0x1c(%ebp)
  80063f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800643:	7f e6                	jg     80062b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800645:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800648:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800653:	53                   	push   %ebx
  800654:	51                   	push   %ecx
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	e8 28 2b 00 00       	call   803184 <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 94 38 80 00       	add    $0x803894,%eax
  800664:	8a 00                	mov    (%eax),%al
  800666:	0f be c0             	movsbl %al,%eax
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	50                   	push   %eax
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
}
  800678:	90                   	nop
  800679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800681:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800685:	7e 1c                	jle    8006a3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 50 08             	lea    0x8(%eax),%edx
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	89 10                	mov    %edx,(%eax)
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	83 e8 08             	sub    $0x8,%eax
  80069c:	8b 50 04             	mov    0x4(%eax),%edx
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	eb 40                	jmp    8006e3 <getuint+0x65>
	else if (lflag)
  8006a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a7:	74 1e                	je     8006c7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 04             	lea    0x4(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 04             	sub    $0x4,%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	eb 1c                	jmp    8006e3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	8d 50 04             	lea    0x4(%eax),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	89 10                	mov    %edx,(%eax)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	83 e8 04             	sub    $0x4,%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e3:	5d                   	pop    %ebp
  8006e4:	c3                   	ret    

008006e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ec:	7e 1c                	jle    80070a <getint+0x25>
		return va_arg(*ap, long long);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	8d 50 08             	lea    0x8(%eax),%edx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 10                	mov    %edx,(%eax)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	83 e8 08             	sub    $0x8,%eax
  800703:	8b 50 04             	mov    0x4(%eax),%edx
  800706:	8b 00                	mov    (%eax),%eax
  800708:	eb 38                	jmp    800742 <getint+0x5d>
	else if (lflag)
  80070a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070e:	74 1a                	je     80072a <getint+0x45>
		return va_arg(*ap, long);
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	8d 50 04             	lea    0x4(%eax),%edx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	89 10                	mov    %edx,(%eax)
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	99                   	cltd   
  800728:	eb 18                	jmp    800742 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 04             	lea    0x4(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 04             	sub    $0x4,%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	99                   	cltd   
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	56                   	push   %esi
  800748:	53                   	push   %ebx
  800749:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074c:	eb 17                	jmp    800765 <vprintfmt+0x21>
			if (ch == '\0')
  80074e:	85 db                	test   %ebx,%ebx
  800750:	0f 84 af 03 00 00    	je     800b05 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	53                   	push   %ebx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	8d 50 01             	lea    0x1(%eax),%edx
  80076b:	89 55 10             	mov    %edx,0x10(%ebp)
  80076e:	8a 00                	mov    (%eax),%al
  800770:	0f b6 d8             	movzbl %al,%ebx
  800773:	83 fb 25             	cmp    $0x25,%ebx
  800776:	75 d6                	jne    80074e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800778:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800783:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80078a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800791:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a9:	83 f8 55             	cmp    $0x55,%eax
  8007ac:	0f 87 2b 03 00 00    	ja     800add <vprintfmt+0x399>
  8007b2:	8b 04 85 b8 38 80 00 	mov    0x8038b8(,%eax,4),%eax
  8007b9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007bb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bf:	eb d7                	jmp    800798 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c5:	eb d1                	jmp    800798 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d1:	89 d0                	mov    %edx,%eax
  8007d3:	c1 e0 02             	shl    $0x2,%eax
  8007d6:	01 d0                	add    %edx,%eax
  8007d8:	01 c0                	add    %eax,%eax
  8007da:	01 d8                	add    %ebx,%eax
  8007dc:	83 e8 30             	sub    $0x30,%eax
  8007df:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8a 00                	mov    (%eax),%al
  8007e7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ea:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ed:	7e 3e                	jle    80082d <vprintfmt+0xe9>
  8007ef:	83 fb 39             	cmp    $0x39,%ebx
  8007f2:	7f 39                	jg     80082d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f7:	eb d5                	jmp    8007ce <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 c0 04             	add    $0x4,%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080d:	eb 1f                	jmp    80082e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800813:	79 83                	jns    800798 <vprintfmt+0x54>
				width = 0;
  800815:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081c:	e9 77 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800821:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800828:	e9 6b ff ff ff       	jmp    800798 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800832:	0f 89 60 ff ff ff    	jns    800798 <vprintfmt+0x54>
				width = precision, precision = -1;
  800838:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800845:	e9 4e ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084d:	e9 46 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 c0 04             	add    $0x4,%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	50                   	push   %eax
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	ff d0                	call   *%eax
  80086f:	83 c4 10             	add    $0x10,%esp
			break;
  800872:	e9 89 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	83 c0 04             	add    $0x4,%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	83 e8 04             	sub    $0x4,%eax
  800886:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800888:	85 db                	test   %ebx,%ebx
  80088a:	79 02                	jns    80088e <vprintfmt+0x14a>
				err = -err;
  80088c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088e:	83 fb 64             	cmp    $0x64,%ebx
  800891:	7f 0b                	jg     80089e <vprintfmt+0x15a>
  800893:	8b 34 9d 00 37 80 00 	mov    0x803700(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 a5 38 80 00       	push   $0x8038a5
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 5e 02 00 00       	call   800b0d <printfmt>
  8008af:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b2:	e9 49 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b7:	56                   	push   %esi
  8008b8:	68 ae 38 80 00       	push   $0x8038ae
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	ff 75 08             	pushl  0x8(%ebp)
  8008c3:	e8 45 02 00 00       	call   800b0d <printfmt>
  8008c8:	83 c4 10             	add    $0x10,%esp
			break;
  8008cb:	e9 30 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 e8 04             	sub    $0x4,%eax
  8008df:	8b 30                	mov    (%eax),%esi
  8008e1:	85 f6                	test   %esi,%esi
  8008e3:	75 05                	jne    8008ea <vprintfmt+0x1a6>
				p = "(null)";
  8008e5:	be b1 38 80 00       	mov    $0x8038b1,%esi
			if (width > 0 && padc != '-')
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7e 6d                	jle    80095d <vprintfmt+0x219>
  8008f0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f4:	74 67                	je     80095d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	50                   	push   %eax
  8008fd:	56                   	push   %esi
  8008fe:	e8 0c 03 00 00       	call   800c0f <strnlen>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800909:	eb 16                	jmp    800921 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091e:	ff 4d e4             	decl   -0x1c(%ebp)
  800921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800925:	7f e4                	jg     80090b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800927:	eb 34                	jmp    80095d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800929:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092d:	74 1c                	je     80094b <vprintfmt+0x207>
  80092f:	83 fb 1f             	cmp    $0x1f,%ebx
  800932:	7e 05                	jle    800939 <vprintfmt+0x1f5>
  800934:	83 fb 7e             	cmp    $0x7e,%ebx
  800937:	7e 12                	jle    80094b <vprintfmt+0x207>
					putch('?', putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	6a 3f                	push   $0x3f
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
  800949:	eb 0f                	jmp    80095a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	53                   	push   %ebx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	ff 4d e4             	decl   -0x1c(%ebp)
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	8d 70 01             	lea    0x1(%eax),%esi
  800962:	8a 00                	mov    (%eax),%al
  800964:	0f be d8             	movsbl %al,%ebx
  800967:	85 db                	test   %ebx,%ebx
  800969:	74 24                	je     80098f <vprintfmt+0x24b>
  80096b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096f:	78 b8                	js     800929 <vprintfmt+0x1e5>
  800971:	ff 4d e0             	decl   -0x20(%ebp)
  800974:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800978:	79 af                	jns    800929 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097a:	eb 13                	jmp    80098f <vprintfmt+0x24b>
				putch(' ', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	6a 20                	push   $0x20
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	ff d0                	call   *%eax
  800989:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098c:	ff 4d e4             	decl   -0x1c(%ebp)
  80098f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800993:	7f e7                	jg     80097c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800995:	e9 66 01 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a3:	50                   	push   %eax
  8009a4:	e8 3c fd ff ff       	call   8006e5 <getint>
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b8:	85 d2                	test   %edx,%edx
  8009ba:	79 23                	jns    8009df <vprintfmt+0x29b>
				putch('-', putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	6a 2d                	push   $0x2d
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	ff d0                	call   *%eax
  8009c9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d2:	f7 d8                	neg    %eax
  8009d4:	83 d2 00             	adc    $0x0,%edx
  8009d7:	f7 da                	neg    %edx
  8009d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e6:	e9 bc 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f4:	50                   	push   %eax
  8009f5:	e8 84 fc ff ff       	call   80067e <getuint>
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a03:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0a:	e9 98 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 58                	push   $0x58
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 58                	push   $0x58
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 58                	push   $0x58
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			break;
  800a3f:	e9 bc 00 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 30                	push   $0x30
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	6a 78                	push   $0x78
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	83 c0 04             	add    $0x4,%eax
  800a6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	83 e8 04             	sub    $0x4,%eax
  800a73:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a86:	eb 1f                	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a91:	50                   	push   %eax
  800a92:	e8 e7 fb ff ff       	call   80067e <getuint>
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	52                   	push   %edx
  800ab2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab9:	ff 75 f0             	pushl  -0x10(%ebp)
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 00 fb ff ff       	call   8005c7 <printnum>
  800ac7:	83 c4 20             	add    $0x20,%esp
			break;
  800aca:	eb 34                	jmp    800b00 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	53                   	push   %ebx
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
  800ad8:	83 c4 10             	add    $0x10,%esp
			break;
  800adb:	eb 23                	jmp    800b00 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	6a 25                	push   $0x25
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	ff d0                	call   *%eax
  800aea:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aed:	ff 4d 10             	decl   0x10(%ebp)
  800af0:	eb 03                	jmp    800af5 <vprintfmt+0x3b1>
  800af2:	ff 4d 10             	decl   0x10(%ebp)
  800af5:	8b 45 10             	mov    0x10(%ebp),%eax
  800af8:	48                   	dec    %eax
  800af9:	8a 00                	mov    (%eax),%al
  800afb:	3c 25                	cmp    $0x25,%al
  800afd:	75 f3                	jne    800af2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aff:	90                   	nop
		}
	}
  800b00:	e9 47 fc ff ff       	jmp    80074c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b05:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b09:	5b                   	pop    %ebx
  800b0a:	5e                   	pop    %esi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b13:	8d 45 10             	lea    0x10(%ebp),%eax
  800b16:	83 c0 04             	add    $0x4,%eax
  800b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b22:	50                   	push   %eax
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	ff 75 08             	pushl  0x8(%ebp)
  800b29:	e8 16 fc ff ff       	call   800744 <vprintfmt>
  800b2e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b31:	90                   	nop
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8b 40 08             	mov    0x8(%eax),%eax
  800b3d:	8d 50 01             	lea    0x1(%eax),%edx
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	8b 10                	mov    (%eax),%edx
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8b 40 04             	mov    0x4(%eax),%eax
  800b51:	39 c2                	cmp    %eax,%edx
  800b53:	73 12                	jae    800b67 <sprintputch+0x33>
		*b->buf++ = ch;
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b60:	89 0a                	mov    %ecx,(%edx)
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	88 10                	mov    %dl,(%eax)
}
  800b67:	90                   	nop
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	01 d0                	add    %edx,%eax
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8f:	74 06                	je     800b97 <vsnprintf+0x2d>
  800b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b95:	7f 07                	jg     800b9e <vsnprintf+0x34>
		return -E_INVAL;
  800b97:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9c:	eb 20                	jmp    800bbe <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9e:	ff 75 14             	pushl  0x14(%ebp)
  800ba1:	ff 75 10             	pushl  0x10(%ebp)
  800ba4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba7:	50                   	push   %eax
  800ba8:	68 34 0b 80 00       	push   $0x800b34
  800bad:	e8 92 fb ff ff       	call   800744 <vprintfmt>
  800bb2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc9:	83 c0 04             	add    $0x4,%eax
  800bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 89 ff ff ff       	call   800b6a <vsnprintf>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf9:	eb 06                	jmp    800c01 <strlen+0x15>
		n++;
  800bfb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfe:	ff 45 08             	incl   0x8(%ebp)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	84 c0                	test   %al,%al
  800c08:	75 f1                	jne    800bfb <strlen+0xf>
		n++;
	return n;
  800c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1c:	eb 09                	jmp    800c27 <strnlen+0x18>
		n++;
  800c1e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c21:	ff 45 08             	incl   0x8(%ebp)
  800c24:	ff 4d 0c             	decl   0xc(%ebp)
  800c27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2b:	74 09                	je     800c36 <strnlen+0x27>
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	84 c0                	test   %al,%al
  800c34:	75 e8                	jne    800c1e <strnlen+0xf>
		n++;
	return n;
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    

00800c3b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c47:	90                   	nop
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8d 50 01             	lea    0x1(%eax),%edx
  800c4e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c54:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c57:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c5a:	8a 12                	mov    (%edx),%dl
  800c5c:	88 10                	mov    %dl,(%eax)
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	84 c0                	test   %al,%al
  800c62:	75 e4                	jne    800c48 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7c:	eb 1f                	jmp    800c9d <strncpy+0x34>
		*dst++ = *src;
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8d 50 01             	lea    0x1(%eax),%edx
  800c84:	89 55 08             	mov    %edx,0x8(%ebp)
  800c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	74 03                	je     800c9a <strncpy+0x31>
			src++;
  800c97:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c9a:	ff 45 fc             	incl   -0x4(%ebp)
  800c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca3:	72 d9                	jb     800c7e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cba:	74 30                	je     800cec <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cbc:	eb 16                	jmp    800cd4 <strlcpy+0x2a>
			*dst++ = *src++;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8d 50 01             	lea    0x1(%eax),%edx
  800cc4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd0:	8a 12                	mov    (%edx),%dl
  800cd2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd4:	ff 4d 10             	decl   0x10(%ebp)
  800cd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdb:	74 09                	je     800ce6 <strlcpy+0x3c>
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	75 d8                	jne    800cbe <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf2:	29 c2                	sub    %eax,%edx
  800cf4:	89 d0                	mov    %edx,%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cfb:	eb 06                	jmp    800d03 <strcmp+0xb>
		p++, q++;
  800cfd:	ff 45 08             	incl   0x8(%ebp)
  800d00:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 0e                	je     800d1a <strcmp+0x22>
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 10                	mov    (%eax),%dl
  800d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	38 c2                	cmp    %al,%dl
  800d18:	74 e3                	je     800cfd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	0f b6 d0             	movzbl %al,%edx
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	0f b6 c0             	movzbl %al,%eax
  800d2a:	29 c2                	sub    %eax,%edx
  800d2c:	89 d0                	mov    %edx,%eax
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d33:	eb 09                	jmp    800d3e <strncmp+0xe>
		n--, p++, q++;
  800d35:	ff 4d 10             	decl   0x10(%ebp)
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d42:	74 17                	je     800d5b <strncmp+0x2b>
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	84 c0                	test   %al,%al
  800d4b:	74 0e                	je     800d5b <strncmp+0x2b>
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 10                	mov    (%eax),%dl
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	38 c2                	cmp    %al,%dl
  800d59:	74 da                	je     800d35 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5f:	75 07                	jne    800d68 <strncmp+0x38>
		return 0;
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
  800d66:	eb 14                	jmp    800d7c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f b6 d0             	movzbl %al,%edx
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f b6 c0             	movzbl %al,%eax
  800d78:	29 c2                	sub    %eax,%edx
  800d7a:	89 d0                	mov    %edx,%eax
}
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 04             	sub    $0x4,%esp
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8a:	eb 12                	jmp    800d9e <strchr+0x20>
		if (*s == c)
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d94:	75 05                	jne    800d9b <strchr+0x1d>
			return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	eb 11                	jmp    800dac <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	84 c0                	test   %al,%al
  800da5:	75 e5                	jne    800d8c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 04             	sub    $0x4,%esp
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dba:	eb 0d                	jmp    800dc9 <strfind+0x1b>
		if (*s == c)
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc4:	74 0e                	je     800dd4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	84 c0                	test   %al,%al
  800dd0:	75 ea                	jne    800dbc <strfind+0xe>
  800dd2:	eb 01                	jmp    800dd5 <strfind+0x27>
		if (*s == c)
			break;
  800dd4:	90                   	nop
	return (char *) s;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd8:	c9                   	leave  
  800dd9:	c3                   	ret    

00800dda <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dec:	eb 0e                	jmp    800dfc <memset+0x22>
		*p++ = c;
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfa:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dfc:	ff 4d f8             	decl   -0x8(%ebp)
  800dff:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e03:	79 e9                	jns    800dee <memset+0x14>
		*p++ = c;

	return v;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e1c:	eb 16                	jmp    800e34 <memcpy+0x2a>
		*d++ = *s++;
  800e1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e21:	8d 50 01             	lea    0x1(%eax),%edx
  800e24:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e30:	8a 12                	mov    (%edx),%dl
  800e32:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	75 dd                	jne    800e1e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5e:	73 50                	jae    800eb0 <memmove+0x6a>
  800e60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e6b:	76 43                	jbe    800eb0 <memmove+0x6a>
		s += n;
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e73:	8b 45 10             	mov    0x10(%ebp),%eax
  800e76:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e79:	eb 10                	jmp    800e8b <memmove+0x45>
			*--d = *--s;
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	ff 4d fc             	decl   -0x4(%ebp)
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e84:	8a 10                	mov    (%eax),%dl
  800e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e89:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e91:	89 55 10             	mov    %edx,0x10(%ebp)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	75 e3                	jne    800e7b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e98:	eb 23                	jmp    800ebd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eac:	8a 12                	mov    (%edx),%dl
  800eae:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	75 dd                	jne    800e9a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed4:	eb 2a                	jmp    800f00 <memcmp+0x3e>
		if (*s1 != *s2)
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed9:	8a 10                	mov    (%eax),%dl
  800edb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	38 c2                	cmp    %al,%dl
  800ee2:	74 16                	je     800efa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	0f b6 d0             	movzbl %al,%edx
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	0f b6 c0             	movzbl %al,%eax
  800ef4:	29 c2                	sub    %eax,%edx
  800ef6:	89 d0                	mov    %edx,%eax
  800ef8:	eb 18                	jmp    800f12 <memcmp+0x50>
		s1++, s2++;
  800efa:	ff 45 fc             	incl   -0x4(%ebp)
  800efd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f06:	89 55 10             	mov    %edx,0x10(%ebp)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	75 c9                	jne    800ed6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f20:	01 d0                	add    %edx,%eax
  800f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f25:	eb 15                	jmp    800f3c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 d0             	movzbl %al,%edx
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	0f b6 c0             	movzbl %al,%eax
  800f35:	39 c2                	cmp    %eax,%edx
  800f37:	74 0d                	je     800f46 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f42:	72 e3                	jb     800f27 <memfind+0x13>
  800f44:	eb 01                	jmp    800f47 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f46:	90                   	nop
	return (void *) s;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4a:	c9                   	leave  
  800f4b:	c3                   	ret    

00800f4c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f59:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f60:	eb 03                	jmp    800f65 <strtol+0x19>
		s++;
  800f62:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 20                	cmp    $0x20,%al
  800f6c:	74 f4                	je     800f62 <strtol+0x16>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 09                	cmp    $0x9,%al
  800f75:	74 eb                	je     800f62 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 2b                	cmp    $0x2b,%al
  800f7e:	75 05                	jne    800f85 <strtol+0x39>
		s++;
  800f80:	ff 45 08             	incl   0x8(%ebp)
  800f83:	eb 13                	jmp    800f98 <strtol+0x4c>
	else if (*s == '-')
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 2d                	cmp    $0x2d,%al
  800f8c:	75 0a                	jne    800f98 <strtol+0x4c>
		s++, neg = 1;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	74 06                	je     800fa4 <strtol+0x58>
  800f9e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa2:	75 20                	jne    800fc4 <strtol+0x78>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 17                	jne    800fc4 <strtol+0x78>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	40                   	inc    %eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	3c 78                	cmp    $0x78,%al
  800fb5:	75 0d                	jne    800fc4 <strtol+0x78>
		s += 2, base = 16;
  800fb7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fbb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc2:	eb 28                	jmp    800fec <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc8:	75 15                	jne    800fdf <strtol+0x93>
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3c 30                	cmp    $0x30,%al
  800fd1:	75 0c                	jne    800fdf <strtol+0x93>
		s++, base = 8;
  800fd3:	ff 45 08             	incl   0x8(%ebp)
  800fd6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fdd:	eb 0d                	jmp    800fec <strtol+0xa0>
	else if (base == 0)
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 07                	jne    800fec <strtol+0xa0>
		base = 10;
  800fe5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 2f                	cmp    $0x2f,%al
  800ff3:	7e 19                	jle    80100e <strtol+0xc2>
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 39                	cmp    $0x39,%al
  800ffc:	7f 10                	jg     80100e <strtol+0xc2>
			dig = *s - '0';
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	0f be c0             	movsbl %al,%eax
  801006:	83 e8 30             	sub    $0x30,%eax
  801009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100c:	eb 42                	jmp    801050 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	3c 60                	cmp    $0x60,%al
  801015:	7e 19                	jle    801030 <strtol+0xe4>
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	3c 7a                	cmp    $0x7a,%al
  80101e:	7f 10                	jg     801030 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	0f be c0             	movsbl %al,%eax
  801028:	83 e8 57             	sub    $0x57,%eax
  80102b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102e:	eb 20                	jmp    801050 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 40                	cmp    $0x40,%al
  801037:	7e 39                	jle    801072 <strtol+0x126>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 5a                	cmp    $0x5a,%al
  801040:	7f 30                	jg     801072 <strtol+0x126>
			dig = *s - 'A' + 10;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	0f be c0             	movsbl %al,%eax
  80104a:	83 e8 37             	sub    $0x37,%eax
  80104d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801053:	3b 45 10             	cmp    0x10(%ebp),%eax
  801056:	7d 19                	jge    801071 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801058:	ff 45 08             	incl   0x8(%ebp)
  80105b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801062:	89 c2                	mov    %eax,%edx
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	01 d0                	add    %edx,%eax
  801069:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80106c:	e9 7b ff ff ff       	jmp    800fec <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801071:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801072:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801076:	74 08                	je     801080 <strtol+0x134>
		*endptr = (char *) s;
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801080:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801084:	74 07                	je     80108d <strtol+0x141>
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	f7 d8                	neg    %eax
  80108b:	eb 03                	jmp    801090 <strtol+0x144>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <ltostr>:

void
ltostr(long value, char *str)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010aa:	79 13                	jns    8010bf <ltostr+0x2d>
	{
		neg = 1;
  8010ac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010bc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c7:	99                   	cltd   
  8010c8:	f7 f9                	idiv   %ecx
  8010ca:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d0:	8d 50 01             	lea    0x1(%eax),%edx
  8010d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d6:	89 c2                	mov    %eax,%edx
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	01 d0                	add    %edx,%eax
  8010dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e0:	83 c2 30             	add    $0x30,%edx
  8010e3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ed:	f7 e9                	imul   %ecx
  8010ef:	c1 fa 02             	sar    $0x2,%edx
  8010f2:	89 c8                	mov    %ecx,%eax
  8010f4:	c1 f8 1f             	sar    $0x1f,%eax
  8010f7:	29 c2                	sub    %eax,%edx
  8010f9:	89 d0                	mov    %edx,%eax
  8010fb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801101:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801106:	f7 e9                	imul   %ecx
  801108:	c1 fa 02             	sar    $0x2,%edx
  80110b:	89 c8                	mov    %ecx,%eax
  80110d:	c1 f8 1f             	sar    $0x1f,%eax
  801110:	29 c2                	sub    %eax,%edx
  801112:	89 d0                	mov    %edx,%eax
  801114:	c1 e0 02             	shl    $0x2,%eax
  801117:	01 d0                	add    %edx,%eax
  801119:	01 c0                	add    %eax,%eax
  80111b:	29 c1                	sub    %eax,%ecx
  80111d:	89 ca                	mov    %ecx,%edx
  80111f:	85 d2                	test   %edx,%edx
  801121:	75 9c                	jne    8010bf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80112a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112d:	48                   	dec    %eax
  80112e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801131:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801135:	74 3d                	je     801174 <ltostr+0xe2>
		start = 1 ;
  801137:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113e:	eb 34                	jmp    801174 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 d0                	add    %edx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80114d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	01 c2                	add    %eax,%edx
  801155:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	01 c8                	add    %ecx,%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801161:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8a 45 eb             	mov    -0x15(%ebp),%al
  80116c:	88 02                	mov    %al,(%edx)
		start++ ;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801171:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801177:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80117a:	7c c4                	jl     801140 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80117c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 d0                	add    %edx,%eax
  801184:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801190:	ff 75 08             	pushl  0x8(%ebp)
  801193:	e8 54 fa ff ff       	call   800bec <strlen>
  801198:	83 c4 04             	add    $0x4,%esp
  80119b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119e:	ff 75 0c             	pushl  0xc(%ebp)
  8011a1:	e8 46 fa ff ff       	call   800bec <strlen>
  8011a6:	83 c4 04             	add    $0x4,%esp
  8011a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ba:	eb 17                	jmp    8011d3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d0:	ff 45 fc             	incl   -0x4(%ebp)
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d9:	7c e1                	jl     8011bc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e9:	eb 1f                	jmp    80120a <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f9:	01 c2                	add    %eax,%edx
  8011fb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 c8                	add    %ecx,%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801207:	ff 45 f8             	incl   -0x8(%ebp)
  80120a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801210:	7c d9                	jl     8011eb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801212:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801215:	8b 45 10             	mov    0x10(%ebp),%eax
  801218:	01 d0                	add    %edx,%eax
  80121a:	c6 00 00             	movb   $0x0,(%eax)
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	8b 00                	mov    (%eax),%eax
  801231:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801243:	eb 0c                	jmp    801251 <strsplit+0x31>
			*string++ = 0;
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 08             	mov    %edx,0x8(%ebp)
  80124e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	84 c0                	test   %al,%al
  801258:	74 18                	je     801272 <strsplit+0x52>
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	0f be c0             	movsbl %al,%eax
  801262:	50                   	push   %eax
  801263:	ff 75 0c             	pushl  0xc(%ebp)
  801266:	e8 13 fb ff ff       	call   800d7e <strchr>
  80126b:	83 c4 08             	add    $0x8,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	75 d3                	jne    801245 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 5a                	je     8012d5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	83 f8 0f             	cmp    $0xf,%eax
  801283:	75 07                	jne    80128c <strsplit+0x6c>
		{
			return 0;
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
  80128a:	eb 66                	jmp    8012f2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80128c:	8b 45 14             	mov    0x14(%ebp),%eax
  80128f:	8b 00                	mov    (%eax),%eax
  801291:	8d 48 01             	lea    0x1(%eax),%ecx
  801294:	8b 55 14             	mov    0x14(%ebp),%edx
  801297:	89 0a                	mov    %ecx,(%edx)
  801299:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	01 c2                	add    %eax,%edx
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012aa:	eb 03                	jmp    8012af <strsplit+0x8f>
			string++;
  8012ac:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	84 c0                	test   %al,%al
  8012b6:	74 8b                	je     801243 <strsplit+0x23>
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	0f be c0             	movsbl %al,%eax
  8012c0:	50                   	push   %eax
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	e8 b5 fa ff ff       	call   800d7e <strchr>
  8012c9:	83 c4 08             	add    $0x8,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	74 dc                	je     8012ac <strsplit+0x8c>
			string++;
	}
  8012d0:	e9 6e ff ff ff       	jmp    801243 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	01 d0                	add    %edx,%eax
  8012e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 1f                	je     801322 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801303:	e8 1d 00 00 00       	call   801325 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801308:	83 ec 0c             	sub    $0xc,%esp
  80130b:	68 10 3a 80 00       	push   $0x803a10
  801310:	e8 55 f2 ff ff       	call   80056a <cprintf>
  801315:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801318:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80131f:	00 00 00 
	}
}
  801322:	90                   	nop
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80132b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801332:	00 00 00 
  801335:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80133c:	00 00 00 
  80133f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801346:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801349:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801350:	00 00 00 
  801353:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80135a:	00 00 00 
  80135d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801364:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801367:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80136e:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  801371:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801380:	2d 00 10 00 00       	sub    $0x1000,%eax
  801385:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  80138a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801391:	a1 20 41 80 00       	mov    0x804120,%eax
  801396:	c1 e0 04             	shl    $0x4,%eax
  801399:	89 c2                	mov    %eax,%edx
  80139b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139e:	01 d0                	add    %edx,%eax
  8013a0:	48                   	dec    %eax
  8013a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ac:	f7 75 f0             	divl   -0x10(%ebp)
  8013af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b2:	29 d0                	sub    %edx,%eax
  8013b4:	89 c2                	mov    %eax,%edx
  8013b6:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  8013bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013c5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013ca:	83 ec 04             	sub    $0x4,%esp
  8013cd:	6a 06                	push   $0x6
  8013cf:	52                   	push   %edx
  8013d0:	50                   	push   %eax
  8013d1:	e8 71 05 00 00       	call   801947 <sys_allocate_chunk>
  8013d6:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013d9:	a1 20 41 80 00       	mov    0x804120,%eax
  8013de:	83 ec 0c             	sub    $0xc,%esp
  8013e1:	50                   	push   %eax
  8013e2:	e8 e6 0b 00 00       	call   801fcd <initialize_MemBlocksList>
  8013e7:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8013ea:	a1 48 41 80 00       	mov    0x804148,%eax
  8013ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8013f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013f6:	75 14                	jne    80140c <initialize_dyn_block_system+0xe7>
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	68 35 3a 80 00       	push   $0x803a35
  801400:	6a 2b                	push   $0x2b
  801402:	68 53 3a 80 00       	push   $0x803a53
  801407:	e8 aa ee ff ff       	call   8002b6 <_panic>
  80140c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80140f:	8b 00                	mov    (%eax),%eax
  801411:	85 c0                	test   %eax,%eax
  801413:	74 10                	je     801425 <initialize_dyn_block_system+0x100>
  801415:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801418:	8b 00                	mov    (%eax),%eax
  80141a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80141d:	8b 52 04             	mov    0x4(%edx),%edx
  801420:	89 50 04             	mov    %edx,0x4(%eax)
  801423:	eb 0b                	jmp    801430 <initialize_dyn_block_system+0x10b>
  801425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801428:	8b 40 04             	mov    0x4(%eax),%eax
  80142b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801433:	8b 40 04             	mov    0x4(%eax),%eax
  801436:	85 c0                	test   %eax,%eax
  801438:	74 0f                	je     801449 <initialize_dyn_block_system+0x124>
  80143a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80143d:	8b 40 04             	mov    0x4(%eax),%eax
  801440:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801443:	8b 12                	mov    (%edx),%edx
  801445:	89 10                	mov    %edx,(%eax)
  801447:	eb 0a                	jmp    801453 <initialize_dyn_block_system+0x12e>
  801449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80144c:	8b 00                	mov    (%eax),%eax
  80144e:	a3 48 41 80 00       	mov    %eax,0x804148
  801453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801456:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80145c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80145f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801466:	a1 54 41 80 00       	mov    0x804154,%eax
  80146b:	48                   	dec    %eax
  80146c:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  801471:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801474:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  80147b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801485:	83 ec 0c             	sub    $0xc,%esp
  801488:	ff 75 e4             	pushl  -0x1c(%ebp)
  80148b:	e8 d2 13 00 00       	call   802862 <insert_sorted_with_merge_freeList>
  801490:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  801493:	90                   	nop
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80149c:	e8 53 fe ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a5:	75 07                	jne    8014ae <malloc+0x18>
  8014a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ac:	eb 61                	jmp    80150f <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  8014ae:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8014b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bb:	01 d0                	add    %edx,%eax
  8014bd:	48                   	dec    %eax
  8014be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014c9:	f7 75 f4             	divl   -0xc(%ebp)
  8014cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cf:	29 d0                	sub    %edx,%eax
  8014d1:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014d4:	e8 3c 08 00 00       	call   801d15 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	74 2d                	je     80150a <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  8014dd:	83 ec 0c             	sub    $0xc,%esp
  8014e0:	ff 75 08             	pushl  0x8(%ebp)
  8014e3:	e8 3e 0f 00 00       	call   802426 <alloc_block_FF>
  8014e8:	83 c4 10             	add    $0x10,%esp
  8014eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8014ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014f2:	74 16                	je     80150a <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8014f4:	83 ec 0c             	sub    $0xc,%esp
  8014f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8014fa:	e8 48 0c 00 00       	call   802147 <insert_sorted_allocList>
  8014ff:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  801502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801505:	8b 40 08             	mov    0x8(%eax),%eax
  801508:	eb 05                	jmp    80150f <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  80150a:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  80150f:	c9                   	leave  
  801510:	c3                   	ret    

00801511 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80151d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801520:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801525:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	83 ec 08             	sub    $0x8,%esp
  80152e:	50                   	push   %eax
  80152f:	68 40 40 80 00       	push   $0x804040
  801534:	e8 71 0b 00 00       	call   8020aa <find_block>
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  80153f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801542:	8b 50 0c             	mov    0xc(%eax),%edx
  801545:	8b 45 08             	mov    0x8(%ebp),%eax
  801548:	83 ec 08             	sub    $0x8,%esp
  80154b:	52                   	push   %edx
  80154c:	50                   	push   %eax
  80154d:	e8 bd 03 00 00       	call   80190f <sys_free_user_mem>
  801552:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801555:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801559:	75 14                	jne    80156f <free+0x5e>
  80155b:	83 ec 04             	sub    $0x4,%esp
  80155e:	68 35 3a 80 00       	push   $0x803a35
  801563:	6a 71                	push   $0x71
  801565:	68 53 3a 80 00       	push   $0x803a53
  80156a:	e8 47 ed ff ff       	call   8002b6 <_panic>
  80156f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801572:	8b 00                	mov    (%eax),%eax
  801574:	85 c0                	test   %eax,%eax
  801576:	74 10                	je     801588 <free+0x77>
  801578:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157b:	8b 00                	mov    (%eax),%eax
  80157d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801580:	8b 52 04             	mov    0x4(%edx),%edx
  801583:	89 50 04             	mov    %edx,0x4(%eax)
  801586:	eb 0b                	jmp    801593 <free+0x82>
  801588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158b:	8b 40 04             	mov    0x4(%eax),%eax
  80158e:	a3 44 40 80 00       	mov    %eax,0x804044
  801593:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801596:	8b 40 04             	mov    0x4(%eax),%eax
  801599:	85 c0                	test   %eax,%eax
  80159b:	74 0f                	je     8015ac <free+0x9b>
  80159d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a0:	8b 40 04             	mov    0x4(%eax),%eax
  8015a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015a6:	8b 12                	mov    (%edx),%edx
  8015a8:	89 10                	mov    %edx,(%eax)
  8015aa:	eb 0a                	jmp    8015b6 <free+0xa5>
  8015ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015af:	8b 00                	mov    (%eax),%eax
  8015b1:	a3 40 40 80 00       	mov    %eax,0x804040
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015c9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015ce:	48                   	dec    %eax
  8015cf:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  8015d4:	83 ec 0c             	sub    $0xc,%esp
  8015d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8015da:	e8 83 12 00 00       	call   802862 <insert_sorted_with_merge_freeList>
  8015df:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8015e2:	90                   	nop
  8015e3:	c9                   	leave  
  8015e4:	c3                   	ret    

008015e5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	83 ec 28             	sub    $0x28,%esp
  8015eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ee:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f1:	e8 fe fc ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015fa:	75 0a                	jne    801606 <smalloc+0x21>
  8015fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801601:	e9 86 00 00 00       	jmp    80168c <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  801606:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80160d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801613:	01 d0                	add    %edx,%eax
  801615:	48                   	dec    %eax
  801616:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161c:	ba 00 00 00 00       	mov    $0x0,%edx
  801621:	f7 75 f4             	divl   -0xc(%ebp)
  801624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801627:	29 d0                	sub    %edx,%eax
  801629:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80162c:	e8 e4 06 00 00       	call   801d15 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801631:	85 c0                	test   %eax,%eax
  801633:	74 52                	je     801687 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  801635:	83 ec 0c             	sub    $0xc,%esp
  801638:	ff 75 0c             	pushl  0xc(%ebp)
  80163b:	e8 e6 0d 00 00       	call   802426 <alloc_block_FF>
  801640:	83 c4 10             	add    $0x10,%esp
  801643:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801646:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80164a:	75 07                	jne    801653 <smalloc+0x6e>
			return NULL ;
  80164c:	b8 00 00 00 00       	mov    $0x0,%eax
  801651:	eb 39                	jmp    80168c <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  801653:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801656:	8b 40 08             	mov    0x8(%eax),%eax
  801659:	89 c2                	mov    %eax,%edx
  80165b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80165f:	52                   	push   %edx
  801660:	50                   	push   %eax
  801661:	ff 75 0c             	pushl  0xc(%ebp)
  801664:	ff 75 08             	pushl  0x8(%ebp)
  801667:	e8 2e 04 00 00       	call   801a9a <sys_createSharedObject>
  80166c:	83 c4 10             	add    $0x10,%esp
  80166f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  801672:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801676:	79 07                	jns    80167f <smalloc+0x9a>
			return (void*)NULL ;
  801678:	b8 00 00 00 00       	mov    $0x0,%eax
  80167d:	eb 0d                	jmp    80168c <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  80167f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801682:	8b 40 08             	mov    0x8(%eax),%eax
  801685:	eb 05                	jmp    80168c <smalloc+0xa7>
		}
		return (void*)NULL ;
  801687:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801694:	e8 5b fc ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801699:	83 ec 08             	sub    $0x8,%esp
  80169c:	ff 75 0c             	pushl  0xc(%ebp)
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	e8 1d 04 00 00       	call   801ac4 <sys_getSizeOfSharedObject>
  8016a7:	83 c4 10             	add    $0x10,%esp
  8016aa:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  8016ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016b1:	75 0a                	jne    8016bd <sget+0x2f>
			return NULL ;
  8016b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b8:	e9 83 00 00 00       	jmp    801740 <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  8016bd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ca:	01 d0                	add    %edx,%eax
  8016cc:	48                   	dec    %eax
  8016cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d8:	f7 75 f0             	divl   -0x10(%ebp)
  8016db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016de:	29 d0                	sub    %edx,%eax
  8016e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016e3:	e8 2d 06 00 00       	call   801d15 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016e8:	85 c0                	test   %eax,%eax
  8016ea:	74 4f                	je     80173b <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8016ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ef:	83 ec 0c             	sub    $0xc,%esp
  8016f2:	50                   	push   %eax
  8016f3:	e8 2e 0d 00 00       	call   802426 <alloc_block_FF>
  8016f8:	83 c4 10             	add    $0x10,%esp
  8016fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8016fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801702:	75 07                	jne    80170b <sget+0x7d>
					return (void*)NULL ;
  801704:	b8 00 00 00 00       	mov    $0x0,%eax
  801709:	eb 35                	jmp    801740 <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  80170b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80170e:	8b 40 08             	mov    0x8(%eax),%eax
  801711:	83 ec 04             	sub    $0x4,%esp
  801714:	50                   	push   %eax
  801715:	ff 75 0c             	pushl  0xc(%ebp)
  801718:	ff 75 08             	pushl  0x8(%ebp)
  80171b:	e8 c1 03 00 00       	call   801ae1 <sys_getSharedObject>
  801720:	83 c4 10             	add    $0x10,%esp
  801723:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  801726:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80172a:	79 07                	jns    801733 <sget+0xa5>
				return (void*)NULL ;
  80172c:	b8 00 00 00 00       	mov    $0x0,%eax
  801731:	eb 0d                	jmp    801740 <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  801733:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801736:	8b 40 08             	mov    0x8(%eax),%eax
  801739:	eb 05                	jmp    801740 <sget+0xb2>


		}
	return (void*)NULL ;
  80173b:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801740:	c9                   	leave  
  801741:	c3                   	ret    

00801742 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801742:	55                   	push   %ebp
  801743:	89 e5                	mov    %esp,%ebp
  801745:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801748:	e8 a7 fb ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	68 60 3a 80 00       	push   $0x803a60
  801755:	68 f9 00 00 00       	push   $0xf9
  80175a:	68 53 3a 80 00       	push   $0x803a53
  80175f:	e8 52 eb ff ff       	call   8002b6 <_panic>

00801764 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801764:	55                   	push   %ebp
  801765:	89 e5                	mov    %esp,%ebp
  801767:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80176a:	83 ec 04             	sub    $0x4,%esp
  80176d:	68 88 3a 80 00       	push   $0x803a88
  801772:	68 0d 01 00 00       	push   $0x10d
  801777:	68 53 3a 80 00       	push   $0x803a53
  80177c:	e8 35 eb ff ff       	call   8002b6 <_panic>

00801781 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801787:	83 ec 04             	sub    $0x4,%esp
  80178a:	68 ac 3a 80 00       	push   $0x803aac
  80178f:	68 18 01 00 00       	push   $0x118
  801794:	68 53 3a 80 00       	push   $0x803a53
  801799:	e8 18 eb ff ff       	call   8002b6 <_panic>

0080179e <shrink>:

}
void shrink(uint32 newSize)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a4:	83 ec 04             	sub    $0x4,%esp
  8017a7:	68 ac 3a 80 00       	push   $0x803aac
  8017ac:	68 1d 01 00 00       	push   $0x11d
  8017b1:	68 53 3a 80 00       	push   $0x803a53
  8017b6:	e8 fb ea ff ff       	call   8002b6 <_panic>

008017bb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c1:	83 ec 04             	sub    $0x4,%esp
  8017c4:	68 ac 3a 80 00       	push   $0x803aac
  8017c9:	68 22 01 00 00       	push   $0x122
  8017ce:	68 53 3a 80 00       	push   $0x803a53
  8017d3:	e8 de ea ff ff       	call   8002b6 <_panic>

008017d8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	57                   	push   %edi
  8017dc:	56                   	push   %esi
  8017dd:	53                   	push   %ebx
  8017de:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ea:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ed:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017f0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017f3:	cd 30                	int    $0x30
  8017f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017fb:	83 c4 10             	add    $0x10,%esp
  8017fe:	5b                   	pop    %ebx
  8017ff:	5e                   	pop    %esi
  801800:	5f                   	pop    %edi
  801801:	5d                   	pop    %ebp
  801802:	c3                   	ret    

00801803 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	8b 45 10             	mov    0x10(%ebp),%eax
  80180c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80180f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	52                   	push   %edx
  80181b:	ff 75 0c             	pushl  0xc(%ebp)
  80181e:	50                   	push   %eax
  80181f:	6a 00                	push   $0x0
  801821:	e8 b2 ff ff ff       	call   8017d8 <syscall>
  801826:	83 c4 18             	add    $0x18,%esp
}
  801829:	90                   	nop
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <sys_cgetc>:

int
sys_cgetc(void)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 01                	push   $0x1
  80183b:	e8 98 ff ff ff       	call   8017d8 <syscall>
  801840:	83 c4 18             	add    $0x18,%esp
}
  801843:	c9                   	leave  
  801844:	c3                   	ret    

00801845 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801848:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	52                   	push   %edx
  801855:	50                   	push   %eax
  801856:	6a 05                	push   $0x5
  801858:	e8 7b ff ff ff       	call   8017d8 <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	56                   	push   %esi
  801866:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801867:	8b 75 18             	mov    0x18(%ebp),%esi
  80186a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80186d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801870:	8b 55 0c             	mov    0xc(%ebp),%edx
  801873:	8b 45 08             	mov    0x8(%ebp),%eax
  801876:	56                   	push   %esi
  801877:	53                   	push   %ebx
  801878:	51                   	push   %ecx
  801879:	52                   	push   %edx
  80187a:	50                   	push   %eax
  80187b:	6a 06                	push   $0x6
  80187d:	e8 56 ff ff ff       	call   8017d8 <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801888:	5b                   	pop    %ebx
  801889:	5e                   	pop    %esi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    

0080188c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80188f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	52                   	push   %edx
  80189c:	50                   	push   %eax
  80189d:	6a 07                	push   $0x7
  80189f:	e8 34 ff ff ff       	call   8017d8 <syscall>
  8018a4:	83 c4 18             	add    $0x18,%esp
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	ff 75 0c             	pushl  0xc(%ebp)
  8018b5:	ff 75 08             	pushl  0x8(%ebp)
  8018b8:	6a 08                	push   $0x8
  8018ba:	e8 19 ff ff ff       	call   8017d8 <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 09                	push   $0x9
  8018d3:	e8 00 ff ff ff       	call   8017d8 <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 0a                	push   $0xa
  8018ec:	e8 e7 fe ff ff       	call   8017d8 <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	6a 0b                	push   $0xb
  801905:	e8 ce fe ff ff       	call   8017d8 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	ff 75 0c             	pushl  0xc(%ebp)
  80191b:	ff 75 08             	pushl  0x8(%ebp)
  80191e:	6a 0f                	push   $0xf
  801920:	e8 b3 fe ff ff       	call   8017d8 <syscall>
  801925:	83 c4 18             	add    $0x18,%esp
	return;
  801928:	90                   	nop
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	ff 75 08             	pushl  0x8(%ebp)
  80193a:	6a 10                	push   $0x10
  80193c:	e8 97 fe ff ff       	call   8017d8 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
	return ;
  801944:	90                   	nop
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	ff 75 10             	pushl  0x10(%ebp)
  801951:	ff 75 0c             	pushl  0xc(%ebp)
  801954:	ff 75 08             	pushl  0x8(%ebp)
  801957:	6a 11                	push   $0x11
  801959:	e8 7a fe ff ff       	call   8017d8 <syscall>
  80195e:	83 c4 18             	add    $0x18,%esp
	return ;
  801961:	90                   	nop
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 0c                	push   $0xc
  801973:	e8 60 fe ff ff       	call   8017d8 <syscall>
  801978:	83 c4 18             	add    $0x18,%esp
}
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	ff 75 08             	pushl  0x8(%ebp)
  80198b:	6a 0d                	push   $0xd
  80198d:	e8 46 fe ff ff       	call   8017d8 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 0e                	push   $0xe
  8019a6:	e8 2d fe ff ff       	call   8017d8 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 13                	push   $0x13
  8019c0:	e8 13 fe ff ff       	call   8017d8 <syscall>
  8019c5:	83 c4 18             	add    $0x18,%esp
}
  8019c8:	90                   	nop
  8019c9:	c9                   	leave  
  8019ca:	c3                   	ret    

008019cb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 14                	push   $0x14
  8019da:	e8 f9 fd ff ff       	call   8017d8 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	90                   	nop
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
  8019e8:	83 ec 04             	sub    $0x4,%esp
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019f1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	50                   	push   %eax
  8019fe:	6a 15                	push   $0x15
  801a00:	e8 d3 fd ff ff       	call   8017d8 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	90                   	nop
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 16                	push   $0x16
  801a1a:	e8 b9 fd ff ff       	call   8017d8 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	90                   	nop
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	ff 75 0c             	pushl  0xc(%ebp)
  801a34:	50                   	push   %eax
  801a35:	6a 17                	push   $0x17
  801a37:	e8 9c fd ff ff       	call   8017d8 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	52                   	push   %edx
  801a51:	50                   	push   %eax
  801a52:	6a 1a                	push   $0x1a
  801a54:	e8 7f fd ff ff       	call   8017d8 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a61:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	52                   	push   %edx
  801a6e:	50                   	push   %eax
  801a6f:	6a 18                	push   $0x18
  801a71:	e8 62 fd ff ff       	call   8017d8 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	90                   	nop
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	52                   	push   %edx
  801a8c:	50                   	push   %eax
  801a8d:	6a 19                	push   $0x19
  801a8f:	e8 44 fd ff ff       	call   8017d8 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	90                   	nop
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	83 ec 04             	sub    $0x4,%esp
  801aa0:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aa6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	51                   	push   %ecx
  801ab3:	52                   	push   %edx
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	50                   	push   %eax
  801ab8:	6a 1b                	push   $0x1b
  801aba:	e8 19 fd ff ff       	call   8017d8 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ac7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	52                   	push   %edx
  801ad4:	50                   	push   %eax
  801ad5:	6a 1c                	push   $0x1c
  801ad7:	e8 fc fc ff ff       	call   8017d8 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ae4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aea:	8b 45 08             	mov    0x8(%ebp),%eax
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	51                   	push   %ecx
  801af2:	52                   	push   %edx
  801af3:	50                   	push   %eax
  801af4:	6a 1d                	push   $0x1d
  801af6:	e8 dd fc ff ff       	call   8017d8 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    

00801b00 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	52                   	push   %edx
  801b10:	50                   	push   %eax
  801b11:	6a 1e                	push   $0x1e
  801b13:	e8 c0 fc ff ff       	call   8017d8 <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 1f                	push   $0x1f
  801b2c:	e8 a7 fc ff ff       	call   8017d8 <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
}
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	6a 00                	push   $0x0
  801b3e:	ff 75 14             	pushl  0x14(%ebp)
  801b41:	ff 75 10             	pushl  0x10(%ebp)
  801b44:	ff 75 0c             	pushl  0xc(%ebp)
  801b47:	50                   	push   %eax
  801b48:	6a 20                	push   $0x20
  801b4a:	e8 89 fc ff ff       	call   8017d8 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	6a 00                	push   $0x0
  801b5c:	6a 00                	push   $0x0
  801b5e:	6a 00                	push   $0x0
  801b60:	6a 00                	push   $0x0
  801b62:	50                   	push   %eax
  801b63:	6a 21                	push   $0x21
  801b65:	e8 6e fc ff ff       	call   8017d8 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	90                   	nop
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	50                   	push   %eax
  801b7f:	6a 22                	push   $0x22
  801b81:	e8 52 fc ff ff       	call   8017d8 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 02                	push   $0x2
  801b9a:	e8 39 fc ff ff       	call   8017d8 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 03                	push   $0x3
  801bb3:	e8 20 fc ff ff       	call   8017d8 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 04                	push   $0x4
  801bcc:	e8 07 fc ff ff       	call   8017d8 <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <sys_exit_env>:


void sys_exit_env(void)
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 23                	push   $0x23
  801be5:	e8 ee fb ff ff       	call   8017d8 <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
}
  801bed:	90                   	nop
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
  801bf3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bf6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf9:	8d 50 04             	lea    0x4(%eax),%edx
  801bfc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	52                   	push   %edx
  801c06:	50                   	push   %eax
  801c07:	6a 24                	push   $0x24
  801c09:	e8 ca fb ff ff       	call   8017d8 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
	return result;
  801c11:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c1a:	89 01                	mov    %eax,(%ecx)
  801c1c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	c9                   	leave  
  801c23:	c2 04 00             	ret    $0x4

00801c26 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	ff 75 10             	pushl  0x10(%ebp)
  801c30:	ff 75 0c             	pushl  0xc(%ebp)
  801c33:	ff 75 08             	pushl  0x8(%ebp)
  801c36:	6a 12                	push   $0x12
  801c38:	e8 9b fb ff ff       	call   8017d8 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c40:	90                   	nop
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 25                	push   $0x25
  801c52:	e8 81 fb ff ff       	call   8017d8 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
}
  801c5a:	c9                   	leave  
  801c5b:	c3                   	ret    

00801c5c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	83 ec 04             	sub    $0x4,%esp
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c68:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	50                   	push   %eax
  801c75:	6a 26                	push   $0x26
  801c77:	e8 5c fb ff ff       	call   8017d8 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7f:	90                   	nop
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <rsttst>:
void rsttst()
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 28                	push   $0x28
  801c91:	e8 42 fb ff ff       	call   8017d8 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
	return ;
  801c99:	90                   	nop
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 04             	sub    $0x4,%esp
  801ca2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ca8:	8b 55 18             	mov    0x18(%ebp),%edx
  801cab:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801caf:	52                   	push   %edx
  801cb0:	50                   	push   %eax
  801cb1:	ff 75 10             	pushl  0x10(%ebp)
  801cb4:	ff 75 0c             	pushl  0xc(%ebp)
  801cb7:	ff 75 08             	pushl  0x8(%ebp)
  801cba:	6a 27                	push   $0x27
  801cbc:	e8 17 fb ff ff       	call   8017d8 <syscall>
  801cc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc4:	90                   	nop
}
  801cc5:	c9                   	leave  
  801cc6:	c3                   	ret    

00801cc7 <chktst>:
void chktst(uint32 n)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	ff 75 08             	pushl  0x8(%ebp)
  801cd5:	6a 29                	push   $0x29
  801cd7:	e8 fc fa ff ff       	call   8017d8 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdf:	90                   	nop
}
  801ce0:	c9                   	leave  
  801ce1:	c3                   	ret    

00801ce2 <inctst>:

void inctst()
{
  801ce2:	55                   	push   %ebp
  801ce3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 2a                	push   $0x2a
  801cf1:	e8 e2 fa ff ff       	call   8017d8 <syscall>
  801cf6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf9:	90                   	nop
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <gettst>:
uint32 gettst()
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 2b                	push   $0x2b
  801d0b:	e8 c8 fa ff ff       	call   8017d8 <syscall>
  801d10:	83 c4 18             	add    $0x18,%esp
}
  801d13:	c9                   	leave  
  801d14:	c3                   	ret    

00801d15 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 2c                	push   $0x2c
  801d27:	e8 ac fa ff ff       	call   8017d8 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
  801d2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d32:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d36:	75 07                	jne    801d3f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d38:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3d:	eb 05                	jmp    801d44 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 2c                	push   $0x2c
  801d58:	e8 7b fa ff ff       	call   8017d8 <syscall>
  801d5d:	83 c4 18             	add    $0x18,%esp
  801d60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d63:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d67:	75 07                	jne    801d70 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d69:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6e:	eb 05                	jmp    801d75 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
  801d7a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 2c                	push   $0x2c
  801d89:	e8 4a fa ff ff       	call   8017d8 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
  801d91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d94:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d98:	75 07                	jne    801da1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9f:	eb 05                	jmp    801da6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801da1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
  801dab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 2c                	push   $0x2c
  801dba:	e8 19 fa ff ff       	call   8017d8 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
  801dc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dc5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dc9:	75 07                	jne    801dd2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dcb:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd0:	eb 05                	jmp    801dd7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	ff 75 08             	pushl  0x8(%ebp)
  801de7:	6a 2d                	push   $0x2d
  801de9:	e8 ea f9 ff ff       	call   8017d8 <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
	return ;
  801df1:	90                   	nop
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801df8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e01:	8b 45 08             	mov    0x8(%ebp),%eax
  801e04:	6a 00                	push   $0x0
  801e06:	53                   	push   %ebx
  801e07:	51                   	push   %ecx
  801e08:	52                   	push   %edx
  801e09:	50                   	push   %eax
  801e0a:	6a 2e                	push   $0x2e
  801e0c:	e8 c7 f9 ff ff       	call   8017d8 <syscall>
  801e11:	83 c4 18             	add    $0x18,%esp
}
  801e14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	52                   	push   %edx
  801e29:	50                   	push   %eax
  801e2a:	6a 2f                	push   $0x2f
  801e2c:	e8 a7 f9 ff ff       	call   8017d8 <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e3c:	83 ec 0c             	sub    $0xc,%esp
  801e3f:	68 bc 3a 80 00       	push   $0x803abc
  801e44:	e8 21 e7 ff ff       	call   80056a <cprintf>
  801e49:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e53:	83 ec 0c             	sub    $0xc,%esp
  801e56:	68 e8 3a 80 00       	push   $0x803ae8
  801e5b:	e8 0a e7 ff ff       	call   80056a <cprintf>
  801e60:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e63:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e67:	a1 38 41 80 00       	mov    0x804138,%eax
  801e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e6f:	eb 56                	jmp    801ec7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e75:	74 1c                	je     801e93 <print_mem_block_lists+0x5d>
  801e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7a:	8b 50 08             	mov    0x8(%eax),%edx
  801e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e80:	8b 48 08             	mov    0x8(%eax),%ecx
  801e83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e86:	8b 40 0c             	mov    0xc(%eax),%eax
  801e89:	01 c8                	add    %ecx,%eax
  801e8b:	39 c2                	cmp    %eax,%edx
  801e8d:	73 04                	jae    801e93 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e8f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e96:	8b 50 08             	mov    0x8(%eax),%edx
  801e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9f:	01 c2                	add    %eax,%edx
  801ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea4:	8b 40 08             	mov    0x8(%eax),%eax
  801ea7:	83 ec 04             	sub    $0x4,%esp
  801eaa:	52                   	push   %edx
  801eab:	50                   	push   %eax
  801eac:	68 fd 3a 80 00       	push   $0x803afd
  801eb1:	e8 b4 e6 ff ff       	call   80056a <cprintf>
  801eb6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ebf:	a1 40 41 80 00       	mov    0x804140,%eax
  801ec4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ecb:	74 07                	je     801ed4 <print_mem_block_lists+0x9e>
  801ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed0:	8b 00                	mov    (%eax),%eax
  801ed2:	eb 05                	jmp    801ed9 <print_mem_block_lists+0xa3>
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	a3 40 41 80 00       	mov    %eax,0x804140
  801ede:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	75 8a                	jne    801e71 <print_mem_block_lists+0x3b>
  801ee7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eeb:	75 84                	jne    801e71 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801eed:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ef1:	75 10                	jne    801f03 <print_mem_block_lists+0xcd>
  801ef3:	83 ec 0c             	sub    $0xc,%esp
  801ef6:	68 0c 3b 80 00       	push   $0x803b0c
  801efb:	e8 6a e6 ff ff       	call   80056a <cprintf>
  801f00:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f03:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f0a:	83 ec 0c             	sub    $0xc,%esp
  801f0d:	68 30 3b 80 00       	push   $0x803b30
  801f12:	e8 53 e6 ff ff       	call   80056a <cprintf>
  801f17:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f1a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f1e:	a1 40 40 80 00       	mov    0x804040,%eax
  801f23:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f26:	eb 56                	jmp    801f7e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f2c:	74 1c                	je     801f4a <print_mem_block_lists+0x114>
  801f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f31:	8b 50 08             	mov    0x8(%eax),%edx
  801f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f37:	8b 48 08             	mov    0x8(%eax),%ecx
  801f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f40:	01 c8                	add    %ecx,%eax
  801f42:	39 c2                	cmp    %eax,%edx
  801f44:	73 04                	jae    801f4a <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f46:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4d:	8b 50 08             	mov    0x8(%eax),%edx
  801f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f53:	8b 40 0c             	mov    0xc(%eax),%eax
  801f56:	01 c2                	add    %eax,%edx
  801f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5b:	8b 40 08             	mov    0x8(%eax),%eax
  801f5e:	83 ec 04             	sub    $0x4,%esp
  801f61:	52                   	push   %edx
  801f62:	50                   	push   %eax
  801f63:	68 fd 3a 80 00       	push   $0x803afd
  801f68:	e8 fd e5 ff ff       	call   80056a <cprintf>
  801f6d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f76:	a1 48 40 80 00       	mov    0x804048,%eax
  801f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f82:	74 07                	je     801f8b <print_mem_block_lists+0x155>
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	8b 00                	mov    (%eax),%eax
  801f89:	eb 05                	jmp    801f90 <print_mem_block_lists+0x15a>
  801f8b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f90:	a3 48 40 80 00       	mov    %eax,0x804048
  801f95:	a1 48 40 80 00       	mov    0x804048,%eax
  801f9a:	85 c0                	test   %eax,%eax
  801f9c:	75 8a                	jne    801f28 <print_mem_block_lists+0xf2>
  801f9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa2:	75 84                	jne    801f28 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fa4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fa8:	75 10                	jne    801fba <print_mem_block_lists+0x184>
  801faa:	83 ec 0c             	sub    $0xc,%esp
  801fad:	68 48 3b 80 00       	push   $0x803b48
  801fb2:	e8 b3 e5 ff ff       	call   80056a <cprintf>
  801fb7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fba:	83 ec 0c             	sub    $0xc,%esp
  801fbd:	68 bc 3a 80 00       	push   $0x803abc
  801fc2:	e8 a3 e5 ff ff       	call   80056a <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp

}
  801fca:	90                   	nop
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801fd3:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fda:	00 00 00 
  801fdd:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fe4:	00 00 00 
  801fe7:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801fee:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801ff1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ff8:	e9 9e 00 00 00       	jmp    80209b <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  801ffd:	a1 50 40 80 00       	mov    0x804050,%eax
  802002:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802005:	c1 e2 04             	shl    $0x4,%edx
  802008:	01 d0                	add    %edx,%eax
  80200a:	85 c0                	test   %eax,%eax
  80200c:	75 14                	jne    802022 <initialize_MemBlocksList+0x55>
  80200e:	83 ec 04             	sub    $0x4,%esp
  802011:	68 70 3b 80 00       	push   $0x803b70
  802016:	6a 43                	push   $0x43
  802018:	68 93 3b 80 00       	push   $0x803b93
  80201d:	e8 94 e2 ff ff       	call   8002b6 <_panic>
  802022:	a1 50 40 80 00       	mov    0x804050,%eax
  802027:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202a:	c1 e2 04             	shl    $0x4,%edx
  80202d:	01 d0                	add    %edx,%eax
  80202f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802035:	89 10                	mov    %edx,(%eax)
  802037:	8b 00                	mov    (%eax),%eax
  802039:	85 c0                	test   %eax,%eax
  80203b:	74 18                	je     802055 <initialize_MemBlocksList+0x88>
  80203d:	a1 48 41 80 00       	mov    0x804148,%eax
  802042:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802048:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80204b:	c1 e1 04             	shl    $0x4,%ecx
  80204e:	01 ca                	add    %ecx,%edx
  802050:	89 50 04             	mov    %edx,0x4(%eax)
  802053:	eb 12                	jmp    802067 <initialize_MemBlocksList+0x9a>
  802055:	a1 50 40 80 00       	mov    0x804050,%eax
  80205a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205d:	c1 e2 04             	shl    $0x4,%edx
  802060:	01 d0                	add    %edx,%eax
  802062:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802067:	a1 50 40 80 00       	mov    0x804050,%eax
  80206c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206f:	c1 e2 04             	shl    $0x4,%edx
  802072:	01 d0                	add    %edx,%eax
  802074:	a3 48 41 80 00       	mov    %eax,0x804148
  802079:	a1 50 40 80 00       	mov    0x804050,%eax
  80207e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802081:	c1 e2 04             	shl    $0x4,%edx
  802084:	01 d0                	add    %edx,%eax
  802086:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80208d:	a1 54 41 80 00       	mov    0x804154,%eax
  802092:	40                   	inc    %eax
  802093:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802098:	ff 45 f4             	incl   -0xc(%ebp)
  80209b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209e:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020a1:	0f 82 56 ff ff ff    	jb     801ffd <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  8020a7:	90                   	nop
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8020b0:	a1 38 41 80 00       	mov    0x804138,%eax
  8020b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020b8:	eb 18                	jmp    8020d2 <find_block+0x28>
	{
		if (ele->sva==va)
  8020ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020bd:	8b 40 08             	mov    0x8(%eax),%eax
  8020c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020c3:	75 05                	jne    8020ca <find_block+0x20>
			return ele;
  8020c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c8:	eb 7b                	jmp    802145 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  8020ca:	a1 40 41 80 00       	mov    0x804140,%eax
  8020cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020d6:	74 07                	je     8020df <find_block+0x35>
  8020d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020db:	8b 00                	mov    (%eax),%eax
  8020dd:	eb 05                	jmp    8020e4 <find_block+0x3a>
  8020df:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e4:	a3 40 41 80 00       	mov    %eax,0x804140
  8020e9:	a1 40 41 80 00       	mov    0x804140,%eax
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	75 c8                	jne    8020ba <find_block+0x10>
  8020f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f6:	75 c2                	jne    8020ba <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020f8:	a1 40 40 80 00       	mov    0x804040,%eax
  8020fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802100:	eb 18                	jmp    80211a <find_block+0x70>
	{
		if (ele->sva==va)
  802102:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802105:	8b 40 08             	mov    0x8(%eax),%eax
  802108:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80210b:	75 05                	jne    802112 <find_block+0x68>
					return ele;
  80210d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802110:	eb 33                	jmp    802145 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  802112:	a1 48 40 80 00       	mov    0x804048,%eax
  802117:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80211a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80211e:	74 07                	je     802127 <find_block+0x7d>
  802120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802123:	8b 00                	mov    (%eax),%eax
  802125:	eb 05                	jmp    80212c <find_block+0x82>
  802127:	b8 00 00 00 00       	mov    $0x0,%eax
  80212c:	a3 48 40 80 00       	mov    %eax,0x804048
  802131:	a1 48 40 80 00       	mov    0x804048,%eax
  802136:	85 c0                	test   %eax,%eax
  802138:	75 c8                	jne    802102 <find_block+0x58>
  80213a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80213e:	75 c2                	jne    802102 <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  802140:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802145:	c9                   	leave  
  802146:	c3                   	ret    

00802147 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802147:	55                   	push   %ebp
  802148:	89 e5                	mov    %esp,%ebp
  80214a:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  80214d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802152:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802155:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802159:	75 62                	jne    8021bd <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80215b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80215f:	75 14                	jne    802175 <insert_sorted_allocList+0x2e>
  802161:	83 ec 04             	sub    $0x4,%esp
  802164:	68 70 3b 80 00       	push   $0x803b70
  802169:	6a 69                	push   $0x69
  80216b:	68 93 3b 80 00       	push   $0x803b93
  802170:	e8 41 e1 ff ff       	call   8002b6 <_panic>
  802175:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	89 10                	mov    %edx,(%eax)
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	8b 00                	mov    (%eax),%eax
  802185:	85 c0                	test   %eax,%eax
  802187:	74 0d                	je     802196 <insert_sorted_allocList+0x4f>
  802189:	a1 40 40 80 00       	mov    0x804040,%eax
  80218e:	8b 55 08             	mov    0x8(%ebp),%edx
  802191:	89 50 04             	mov    %edx,0x4(%eax)
  802194:	eb 08                	jmp    80219e <insert_sorted_allocList+0x57>
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	a3 44 40 80 00       	mov    %eax,0x804044
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	a3 40 40 80 00       	mov    %eax,0x804040
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021b5:	40                   	inc    %eax
  8021b6:	a3 4c 40 80 00       	mov    %eax,0x80404c
  8021bb:	eb 72                	jmp    80222f <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  8021bd:	a1 40 40 80 00       	mov    0x804040,%eax
  8021c2:	8b 50 08             	mov    0x8(%eax),%edx
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	8b 40 08             	mov    0x8(%eax),%eax
  8021cb:	39 c2                	cmp    %eax,%edx
  8021cd:	76 60                	jbe    80222f <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  8021cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d3:	75 14                	jne    8021e9 <insert_sorted_allocList+0xa2>
  8021d5:	83 ec 04             	sub    $0x4,%esp
  8021d8:	68 70 3b 80 00       	push   $0x803b70
  8021dd:	6a 6d                	push   $0x6d
  8021df:	68 93 3b 80 00       	push   $0x803b93
  8021e4:	e8 cd e0 ff ff       	call   8002b6 <_panic>
  8021e9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f2:	89 10                	mov    %edx,(%eax)
  8021f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f7:	8b 00                	mov    (%eax),%eax
  8021f9:	85 c0                	test   %eax,%eax
  8021fb:	74 0d                	je     80220a <insert_sorted_allocList+0xc3>
  8021fd:	a1 40 40 80 00       	mov    0x804040,%eax
  802202:	8b 55 08             	mov    0x8(%ebp),%edx
  802205:	89 50 04             	mov    %edx,0x4(%eax)
  802208:	eb 08                	jmp    802212 <insert_sorted_allocList+0xcb>
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	a3 44 40 80 00       	mov    %eax,0x804044
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	a3 40 40 80 00       	mov    %eax,0x804040
  80221a:	8b 45 08             	mov    0x8(%ebp),%eax
  80221d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802224:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802229:	40                   	inc    %eax
  80222a:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  80222f:	a1 40 40 80 00       	mov    0x804040,%eax
  802234:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802237:	e9 b9 01 00 00       	jmp    8023f5 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	8b 50 08             	mov    0x8(%eax),%edx
  802242:	a1 40 40 80 00       	mov    0x804040,%eax
  802247:	8b 40 08             	mov    0x8(%eax),%eax
  80224a:	39 c2                	cmp    %eax,%edx
  80224c:	76 7c                	jbe    8022ca <insert_sorted_allocList+0x183>
  80224e:	8b 45 08             	mov    0x8(%ebp),%eax
  802251:	8b 50 08             	mov    0x8(%eax),%edx
  802254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802257:	8b 40 08             	mov    0x8(%eax),%eax
  80225a:	39 c2                	cmp    %eax,%edx
  80225c:	73 6c                	jae    8022ca <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  80225e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802262:	74 06                	je     80226a <insert_sorted_allocList+0x123>
  802264:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802268:	75 14                	jne    80227e <insert_sorted_allocList+0x137>
  80226a:	83 ec 04             	sub    $0x4,%esp
  80226d:	68 ac 3b 80 00       	push   $0x803bac
  802272:	6a 75                	push   $0x75
  802274:	68 93 3b 80 00       	push   $0x803b93
  802279:	e8 38 e0 ff ff       	call   8002b6 <_panic>
  80227e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802281:	8b 50 04             	mov    0x4(%eax),%edx
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	89 50 04             	mov    %edx,0x4(%eax)
  80228a:	8b 45 08             	mov    0x8(%ebp),%eax
  80228d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802290:	89 10                	mov    %edx,(%eax)
  802292:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802295:	8b 40 04             	mov    0x4(%eax),%eax
  802298:	85 c0                	test   %eax,%eax
  80229a:	74 0d                	je     8022a9 <insert_sorted_allocList+0x162>
  80229c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229f:	8b 40 04             	mov    0x4(%eax),%eax
  8022a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a5:	89 10                	mov    %edx,(%eax)
  8022a7:	eb 08                	jmp    8022b1 <insert_sorted_allocList+0x16a>
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	a3 40 40 80 00       	mov    %eax,0x804040
  8022b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b7:	89 50 04             	mov    %edx,0x4(%eax)
  8022ba:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022bf:	40                   	inc    %eax
  8022c0:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  8022c5:	e9 59 01 00 00       	jmp    802423 <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	8b 50 08             	mov    0x8(%eax),%edx
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	8b 40 08             	mov    0x8(%eax),%eax
  8022d6:	39 c2                	cmp    %eax,%edx
  8022d8:	0f 86 98 00 00 00    	jbe    802376 <insert_sorted_allocList+0x22f>
  8022de:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e1:	8b 50 08             	mov    0x8(%eax),%edx
  8022e4:	a1 44 40 80 00       	mov    0x804044,%eax
  8022e9:	8b 40 08             	mov    0x8(%eax),%eax
  8022ec:	39 c2                	cmp    %eax,%edx
  8022ee:	0f 83 82 00 00 00    	jae    802376 <insert_sorted_allocList+0x22f>
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	8b 50 08             	mov    0x8(%eax),%edx
  8022fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fd:	8b 00                	mov    (%eax),%eax
  8022ff:	8b 40 08             	mov    0x8(%eax),%eax
  802302:	39 c2                	cmp    %eax,%edx
  802304:	73 70                	jae    802376 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  802306:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230a:	74 06                	je     802312 <insert_sorted_allocList+0x1cb>
  80230c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802310:	75 14                	jne    802326 <insert_sorted_allocList+0x1df>
  802312:	83 ec 04             	sub    $0x4,%esp
  802315:	68 e4 3b 80 00       	push   $0x803be4
  80231a:	6a 7c                	push   $0x7c
  80231c:	68 93 3b 80 00       	push   $0x803b93
  802321:	e8 90 df ff ff       	call   8002b6 <_panic>
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	8b 10                	mov    (%eax),%edx
  80232b:	8b 45 08             	mov    0x8(%ebp),%eax
  80232e:	89 10                	mov    %edx,(%eax)
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	8b 00                	mov    (%eax),%eax
  802335:	85 c0                	test   %eax,%eax
  802337:	74 0b                	je     802344 <insert_sorted_allocList+0x1fd>
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	8b 00                	mov    (%eax),%eax
  80233e:	8b 55 08             	mov    0x8(%ebp),%edx
  802341:	89 50 04             	mov    %edx,0x4(%eax)
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 55 08             	mov    0x8(%ebp),%edx
  80234a:	89 10                	mov    %edx,(%eax)
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802352:	89 50 04             	mov    %edx,0x4(%eax)
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	8b 00                	mov    (%eax),%eax
  80235a:	85 c0                	test   %eax,%eax
  80235c:	75 08                	jne    802366 <insert_sorted_allocList+0x21f>
  80235e:	8b 45 08             	mov    0x8(%ebp),%eax
  802361:	a3 44 40 80 00       	mov    %eax,0x804044
  802366:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80236b:	40                   	inc    %eax
  80236c:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  802371:	e9 ad 00 00 00       	jmp    802423 <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	8b 50 08             	mov    0x8(%eax),%edx
  80237c:	a1 44 40 80 00       	mov    0x804044,%eax
  802381:	8b 40 08             	mov    0x8(%eax),%eax
  802384:	39 c2                	cmp    %eax,%edx
  802386:	76 65                	jbe    8023ed <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802388:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80238c:	75 17                	jne    8023a5 <insert_sorted_allocList+0x25e>
  80238e:	83 ec 04             	sub    $0x4,%esp
  802391:	68 18 3c 80 00       	push   $0x803c18
  802396:	68 80 00 00 00       	push   $0x80
  80239b:	68 93 3b 80 00       	push   $0x803b93
  8023a0:	e8 11 df ff ff       	call   8002b6 <_panic>
  8023a5:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	89 50 04             	mov    %edx,0x4(%eax)
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	8b 40 04             	mov    0x4(%eax),%eax
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	74 0c                	je     8023c7 <insert_sorted_allocList+0x280>
  8023bb:	a1 44 40 80 00       	mov    0x804044,%eax
  8023c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c3:	89 10                	mov    %edx,(%eax)
  8023c5:	eb 08                	jmp    8023cf <insert_sorted_allocList+0x288>
  8023c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ca:	a3 40 40 80 00       	mov    %eax,0x804040
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	a3 44 40 80 00       	mov    %eax,0x804044
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023e5:	40                   	inc    %eax
  8023e6:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8023eb:	eb 36                	jmp    802423 <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8023ed:	a1 48 40 80 00       	mov    0x804048,%eax
  8023f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f9:	74 07                	je     802402 <insert_sorted_allocList+0x2bb>
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 00                	mov    (%eax),%eax
  802400:	eb 05                	jmp    802407 <insert_sorted_allocList+0x2c0>
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
  802407:	a3 48 40 80 00       	mov    %eax,0x804048
  80240c:	a1 48 40 80 00       	mov    0x804048,%eax
  802411:	85 c0                	test   %eax,%eax
  802413:	0f 85 23 fe ff ff    	jne    80223c <insert_sorted_allocList+0xf5>
  802419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241d:	0f 85 19 fe ff ff    	jne    80223c <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  802423:	90                   	nop
  802424:	c9                   	leave  
  802425:	c3                   	ret    

00802426 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802426:	55                   	push   %ebp
  802427:	89 e5                	mov    %esp,%ebp
  802429:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  80242c:	a1 38 41 80 00       	mov    0x804138,%eax
  802431:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802434:	e9 7c 01 00 00       	jmp    8025b5 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 40 0c             	mov    0xc(%eax),%eax
  80243f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802442:	0f 85 90 00 00 00    	jne    8024d8 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  80244e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802452:	75 17                	jne    80246b <alloc_block_FF+0x45>
  802454:	83 ec 04             	sub    $0x4,%esp
  802457:	68 3b 3c 80 00       	push   $0x803c3b
  80245c:	68 ba 00 00 00       	push   $0xba
  802461:	68 93 3b 80 00       	push   $0x803b93
  802466:	e8 4b de ff ff       	call   8002b6 <_panic>
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	85 c0                	test   %eax,%eax
  802472:	74 10                	je     802484 <alloc_block_FF+0x5e>
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247c:	8b 52 04             	mov    0x4(%edx),%edx
  80247f:	89 50 04             	mov    %edx,0x4(%eax)
  802482:	eb 0b                	jmp    80248f <alloc_block_FF+0x69>
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 04             	mov    0x4(%eax),%eax
  80248a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 40 04             	mov    0x4(%eax),%eax
  802495:	85 c0                	test   %eax,%eax
  802497:	74 0f                	je     8024a8 <alloc_block_FF+0x82>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 40 04             	mov    0x4(%eax),%eax
  80249f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a2:	8b 12                	mov    (%edx),%edx
  8024a4:	89 10                	mov    %edx,(%eax)
  8024a6:	eb 0a                	jmp    8024b2 <alloc_block_FF+0x8c>
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 00                	mov    (%eax),%eax
  8024ad:	a3 38 41 80 00       	mov    %eax,0x804138
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c5:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ca:	48                   	dec    %eax
  8024cb:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  8024d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d3:	e9 10 01 00 00       	jmp    8025e8 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  8024d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024db:	8b 40 0c             	mov    0xc(%eax),%eax
  8024de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e1:	0f 86 c6 00 00 00    	jbe    8025ad <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8024e7:	a1 48 41 80 00       	mov    0x804148,%eax
  8024ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8024ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024f3:	75 17                	jne    80250c <alloc_block_FF+0xe6>
  8024f5:	83 ec 04             	sub    $0x4,%esp
  8024f8:	68 3b 3c 80 00       	push   $0x803c3b
  8024fd:	68 c2 00 00 00       	push   $0xc2
  802502:	68 93 3b 80 00       	push   $0x803b93
  802507:	e8 aa dd ff ff       	call   8002b6 <_panic>
  80250c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250f:	8b 00                	mov    (%eax),%eax
  802511:	85 c0                	test   %eax,%eax
  802513:	74 10                	je     802525 <alloc_block_FF+0xff>
  802515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802518:	8b 00                	mov    (%eax),%eax
  80251a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80251d:	8b 52 04             	mov    0x4(%edx),%edx
  802520:	89 50 04             	mov    %edx,0x4(%eax)
  802523:	eb 0b                	jmp    802530 <alloc_block_FF+0x10a>
  802525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802528:	8b 40 04             	mov    0x4(%eax),%eax
  80252b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802533:	8b 40 04             	mov    0x4(%eax),%eax
  802536:	85 c0                	test   %eax,%eax
  802538:	74 0f                	je     802549 <alloc_block_FF+0x123>
  80253a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253d:	8b 40 04             	mov    0x4(%eax),%eax
  802540:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802543:	8b 12                	mov    (%edx),%edx
  802545:	89 10                	mov    %edx,(%eax)
  802547:	eb 0a                	jmp    802553 <alloc_block_FF+0x12d>
  802549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254c:	8b 00                	mov    (%eax),%eax
  80254e:	a3 48 41 80 00       	mov    %eax,0x804148
  802553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802556:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802566:	a1 54 41 80 00       	mov    0x804154,%eax
  80256b:	48                   	dec    %eax
  80256c:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 50 08             	mov    0x8(%eax),%edx
  802577:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80257a:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  80257d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802580:	8b 55 08             	mov    0x8(%ebp),%edx
  802583:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	8b 40 0c             	mov    0xc(%eax),%eax
  80258c:	2b 45 08             	sub    0x8(%ebp),%eax
  80258f:	89 c2                	mov    %eax,%edx
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 50 08             	mov    0x8(%eax),%edx
  80259d:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a0:	01 c2                	add    %eax,%edx
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  8025a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ab:	eb 3b                	jmp    8025e8 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025ad:	a1 40 41 80 00       	mov    0x804140,%eax
  8025b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b9:	74 07                	je     8025c2 <alloc_block_FF+0x19c>
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	8b 00                	mov    (%eax),%eax
  8025c0:	eb 05                	jmp    8025c7 <alloc_block_FF+0x1a1>
  8025c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c7:	a3 40 41 80 00       	mov    %eax,0x804140
  8025cc:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d1:	85 c0                	test   %eax,%eax
  8025d3:	0f 85 60 fe ff ff    	jne    802439 <alloc_block_FF+0x13>
  8025d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025dd:	0f 85 56 fe ff ff    	jne    802439 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  8025e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
  8025ed:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8025f0:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025f7:	a1 38 41 80 00       	mov    0x804138,%eax
  8025fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ff:	eb 3a                	jmp    80263b <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	8b 40 0c             	mov    0xc(%eax),%eax
  802607:	3b 45 08             	cmp    0x8(%ebp),%eax
  80260a:	72 27                	jb     802633 <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  80260c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802610:	75 0b                	jne    80261d <alloc_block_BF+0x33>
					best_size= element->size;
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 40 0c             	mov    0xc(%eax),%eax
  802618:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80261b:	eb 16                	jmp    802633 <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 50 0c             	mov    0xc(%eax),%edx
  802623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802626:	39 c2                	cmp    %eax,%edx
  802628:	77 09                	ja     802633 <alloc_block_BF+0x49>
					best_size=element->size;
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 40 0c             	mov    0xc(%eax),%eax
  802630:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802633:	a1 40 41 80 00       	mov    0x804140,%eax
  802638:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263f:	74 07                	je     802648 <alloc_block_BF+0x5e>
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 00                	mov    (%eax),%eax
  802646:	eb 05                	jmp    80264d <alloc_block_BF+0x63>
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
  80264d:	a3 40 41 80 00       	mov    %eax,0x804140
  802652:	a1 40 41 80 00       	mov    0x804140,%eax
  802657:	85 c0                	test   %eax,%eax
  802659:	75 a6                	jne    802601 <alloc_block_BF+0x17>
  80265b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265f:	75 a0                	jne    802601 <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  802661:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802665:	0f 84 d3 01 00 00    	je     80283e <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  80266b:	a1 38 41 80 00       	mov    0x804138,%eax
  802670:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802673:	e9 98 01 00 00       	jmp    802810 <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267e:	0f 86 da 00 00 00    	jbe    80275e <alloc_block_BF+0x174>
  802684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802687:	8b 50 0c             	mov    0xc(%eax),%edx
  80268a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268d:	39 c2                	cmp    %eax,%edx
  80268f:	0f 85 c9 00 00 00    	jne    80275e <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802695:	a1 48 41 80 00       	mov    0x804148,%eax
  80269a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  80269d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026a1:	75 17                	jne    8026ba <alloc_block_BF+0xd0>
  8026a3:	83 ec 04             	sub    $0x4,%esp
  8026a6:	68 3b 3c 80 00       	push   $0x803c3b
  8026ab:	68 ea 00 00 00       	push   $0xea
  8026b0:	68 93 3b 80 00       	push   $0x803b93
  8026b5:	e8 fc db ff ff       	call   8002b6 <_panic>
  8026ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	74 10                	je     8026d3 <alloc_block_BF+0xe9>
  8026c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026cb:	8b 52 04             	mov    0x4(%edx),%edx
  8026ce:	89 50 04             	mov    %edx,0x4(%eax)
  8026d1:	eb 0b                	jmp    8026de <alloc_block_BF+0xf4>
  8026d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d6:	8b 40 04             	mov    0x4(%eax),%eax
  8026d9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e1:	8b 40 04             	mov    0x4(%eax),%eax
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	74 0f                	je     8026f7 <alloc_block_BF+0x10d>
  8026e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026eb:	8b 40 04             	mov    0x4(%eax),%eax
  8026ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026f1:	8b 12                	mov    (%edx),%edx
  8026f3:	89 10                	mov    %edx,(%eax)
  8026f5:	eb 0a                	jmp    802701 <alloc_block_BF+0x117>
  8026f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fa:	8b 00                	mov    (%eax),%eax
  8026fc:	a3 48 41 80 00       	mov    %eax,0x804148
  802701:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802704:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80270d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802714:	a1 54 41 80 00       	mov    0x804154,%eax
  802719:	48                   	dec    %eax
  80271a:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 50 08             	mov    0x8(%eax),%edx
  802725:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802728:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  80272b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272e:	8b 55 08             	mov    0x8(%ebp),%edx
  802731:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	8b 40 0c             	mov    0xc(%eax),%eax
  80273a:	2b 45 08             	sub    0x8(%ebp),%eax
  80273d:	89 c2                	mov    %eax,%edx
  80273f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802742:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 50 08             	mov    0x8(%eax),%edx
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	01 c2                	add    %eax,%edx
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802756:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802759:	e9 e5 00 00 00       	jmp    802843 <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 50 0c             	mov    0xc(%eax),%edx
  802764:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802767:	39 c2                	cmp    %eax,%edx
  802769:	0f 85 99 00 00 00    	jne    802808 <alloc_block_BF+0x21e>
  80276f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802772:	3b 45 08             	cmp    0x8(%ebp),%eax
  802775:	0f 85 8d 00 00 00    	jne    802808 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  80277b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  802781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802785:	75 17                	jne    80279e <alloc_block_BF+0x1b4>
  802787:	83 ec 04             	sub    $0x4,%esp
  80278a:	68 3b 3c 80 00       	push   $0x803c3b
  80278f:	68 f7 00 00 00       	push   $0xf7
  802794:	68 93 3b 80 00       	push   $0x803b93
  802799:	e8 18 db ff ff       	call   8002b6 <_panic>
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	8b 00                	mov    (%eax),%eax
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	74 10                	je     8027b7 <alloc_block_BF+0x1cd>
  8027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027aa:	8b 00                	mov    (%eax),%eax
  8027ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027af:	8b 52 04             	mov    0x4(%edx),%edx
  8027b2:	89 50 04             	mov    %edx,0x4(%eax)
  8027b5:	eb 0b                	jmp    8027c2 <alloc_block_BF+0x1d8>
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 40 04             	mov    0x4(%eax),%eax
  8027bd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c5:	8b 40 04             	mov    0x4(%eax),%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	74 0f                	je     8027db <alloc_block_BF+0x1f1>
  8027cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cf:	8b 40 04             	mov    0x4(%eax),%eax
  8027d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d5:	8b 12                	mov    (%edx),%edx
  8027d7:	89 10                	mov    %edx,(%eax)
  8027d9:	eb 0a                	jmp    8027e5 <alloc_block_BF+0x1fb>
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	a3 38 41 80 00       	mov    %eax,0x804138
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f8:	a1 44 41 80 00       	mov    0x804144,%eax
  8027fd:	48                   	dec    %eax
  8027fe:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  802803:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802806:	eb 3b                	jmp    802843 <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802808:	a1 40 41 80 00       	mov    0x804140,%eax
  80280d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802810:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802814:	74 07                	je     80281d <alloc_block_BF+0x233>
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 00                	mov    (%eax),%eax
  80281b:	eb 05                	jmp    802822 <alloc_block_BF+0x238>
  80281d:	b8 00 00 00 00       	mov    $0x0,%eax
  802822:	a3 40 41 80 00       	mov    %eax,0x804140
  802827:	a1 40 41 80 00       	mov    0x804140,%eax
  80282c:	85 c0                	test   %eax,%eax
  80282e:	0f 85 44 fe ff ff    	jne    802678 <alloc_block_BF+0x8e>
  802834:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802838:	0f 85 3a fe ff ff    	jne    802678 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  80283e:	b8 00 00 00 00       	mov    $0x0,%eax
  802843:	c9                   	leave  
  802844:	c3                   	ret    

00802845 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802845:	55                   	push   %ebp
  802846:	89 e5                	mov    %esp,%ebp
  802848:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  80284b:	83 ec 04             	sub    $0x4,%esp
  80284e:	68 5c 3c 80 00       	push   $0x803c5c
  802853:	68 04 01 00 00       	push   $0x104
  802858:	68 93 3b 80 00       	push   $0x803b93
  80285d:	e8 54 da ff ff       	call   8002b6 <_panic>

00802862 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
  802865:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802868:	a1 38 41 80 00       	mov    0x804138,%eax
  80286d:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  802870:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802875:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802878:	a1 38 41 80 00       	mov    0x804138,%eax
  80287d:	85 c0                	test   %eax,%eax
  80287f:	75 68                	jne    8028e9 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802881:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802885:	75 17                	jne    80289e <insert_sorted_with_merge_freeList+0x3c>
  802887:	83 ec 04             	sub    $0x4,%esp
  80288a:	68 70 3b 80 00       	push   $0x803b70
  80288f:	68 14 01 00 00       	push   $0x114
  802894:	68 93 3b 80 00       	push   $0x803b93
  802899:	e8 18 da ff ff       	call   8002b6 <_panic>
  80289e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a7:	89 10                	mov    %edx,(%eax)
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	8b 00                	mov    (%eax),%eax
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	74 0d                	je     8028bf <insert_sorted_with_merge_freeList+0x5d>
  8028b2:	a1 38 41 80 00       	mov    0x804138,%eax
  8028b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ba:	89 50 04             	mov    %edx,0x4(%eax)
  8028bd:	eb 08                	jmp    8028c7 <insert_sorted_with_merge_freeList+0x65>
  8028bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ca:	a3 38 41 80 00       	mov    %eax,0x804138
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d9:	a1 44 41 80 00       	mov    0x804144,%eax
  8028de:	40                   	inc    %eax
  8028df:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8028e4:	e9 d2 06 00 00       	jmp    802fbb <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ec:	8b 50 08             	mov    0x8(%eax),%edx
  8028ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f2:	8b 40 08             	mov    0x8(%eax),%eax
  8028f5:	39 c2                	cmp    %eax,%edx
  8028f7:	0f 83 22 01 00 00    	jae    802a1f <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8028fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802900:	8b 50 08             	mov    0x8(%eax),%edx
  802903:	8b 45 08             	mov    0x8(%ebp),%eax
  802906:	8b 40 0c             	mov    0xc(%eax),%eax
  802909:	01 c2                	add    %eax,%edx
  80290b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290e:	8b 40 08             	mov    0x8(%eax),%eax
  802911:	39 c2                	cmp    %eax,%edx
  802913:	0f 85 9e 00 00 00    	jne    8029b7 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  802919:	8b 45 08             	mov    0x8(%ebp),%eax
  80291c:	8b 50 08             	mov    0x8(%eax),%edx
  80291f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802922:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  802925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802928:	8b 50 0c             	mov    0xc(%eax),%edx
  80292b:	8b 45 08             	mov    0x8(%ebp),%eax
  80292e:	8b 40 0c             	mov    0xc(%eax),%eax
  802931:	01 c2                	add    %eax,%edx
  802933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802936:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  802939:	8b 45 08             	mov    0x8(%ebp),%eax
  80293c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	8b 50 08             	mov    0x8(%eax),%edx
  802949:	8b 45 08             	mov    0x8(%ebp),%eax
  80294c:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80294f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802953:	75 17                	jne    80296c <insert_sorted_with_merge_freeList+0x10a>
  802955:	83 ec 04             	sub    $0x4,%esp
  802958:	68 70 3b 80 00       	push   $0x803b70
  80295d:	68 21 01 00 00       	push   $0x121
  802962:	68 93 3b 80 00       	push   $0x803b93
  802967:	e8 4a d9 ff ff       	call   8002b6 <_panic>
  80296c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	89 10                	mov    %edx,(%eax)
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	8b 00                	mov    (%eax),%eax
  80297c:	85 c0                	test   %eax,%eax
  80297e:	74 0d                	je     80298d <insert_sorted_with_merge_freeList+0x12b>
  802980:	a1 48 41 80 00       	mov    0x804148,%eax
  802985:	8b 55 08             	mov    0x8(%ebp),%edx
  802988:	89 50 04             	mov    %edx,0x4(%eax)
  80298b:	eb 08                	jmp    802995 <insert_sorted_with_merge_freeList+0x133>
  80298d:	8b 45 08             	mov    0x8(%ebp),%eax
  802990:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	a3 48 41 80 00       	mov    %eax,0x804148
  80299d:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a7:	a1 54 41 80 00       	mov    0x804154,%eax
  8029ac:	40                   	inc    %eax
  8029ad:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  8029b2:	e9 04 06 00 00       	jmp    802fbb <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  8029b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029bb:	75 17                	jne    8029d4 <insert_sorted_with_merge_freeList+0x172>
  8029bd:	83 ec 04             	sub    $0x4,%esp
  8029c0:	68 70 3b 80 00       	push   $0x803b70
  8029c5:	68 26 01 00 00       	push   $0x126
  8029ca:	68 93 3b 80 00       	push   $0x803b93
  8029cf:	e8 e2 d8 ff ff       	call   8002b6 <_panic>
  8029d4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	89 10                	mov    %edx,(%eax)
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	8b 00                	mov    (%eax),%eax
  8029e4:	85 c0                	test   %eax,%eax
  8029e6:	74 0d                	je     8029f5 <insert_sorted_with_merge_freeList+0x193>
  8029e8:	a1 38 41 80 00       	mov    0x804138,%eax
  8029ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f0:	89 50 04             	mov    %edx,0x4(%eax)
  8029f3:	eb 08                	jmp    8029fd <insert_sorted_with_merge_freeList+0x19b>
  8029f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	a3 38 41 80 00       	mov    %eax,0x804138
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0f:	a1 44 41 80 00       	mov    0x804144,%eax
  802a14:	40                   	inc    %eax
  802a15:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802a1a:	e9 9c 05 00 00       	jmp    802fbb <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	8b 50 08             	mov    0x8(%eax),%edx
  802a25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a28:	8b 40 08             	mov    0x8(%eax),%eax
  802a2b:	39 c2                	cmp    %eax,%edx
  802a2d:	0f 86 16 01 00 00    	jbe    802b49 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  802a33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a36:	8b 50 08             	mov    0x8(%eax),%edx
  802a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3f:	01 c2                	add    %eax,%edx
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	8b 40 08             	mov    0x8(%eax),%eax
  802a47:	39 c2                	cmp    %eax,%edx
  802a49:	0f 85 92 00 00 00    	jne    802ae1 <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802a4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a52:	8b 50 0c             	mov    0xc(%eax),%edx
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	8b 40 0c             	mov    0xc(%eax),%eax
  802a5b:	01 c2                	add    %eax,%edx
  802a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a60:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802a63:	8b 45 08             	mov    0x8(%ebp),%eax
  802a66:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a70:	8b 50 08             	mov    0x8(%eax),%edx
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a7d:	75 17                	jne    802a96 <insert_sorted_with_merge_freeList+0x234>
  802a7f:	83 ec 04             	sub    $0x4,%esp
  802a82:	68 70 3b 80 00       	push   $0x803b70
  802a87:	68 31 01 00 00       	push   $0x131
  802a8c:	68 93 3b 80 00       	push   $0x803b93
  802a91:	e8 20 d8 ff ff       	call   8002b6 <_panic>
  802a96:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	89 10                	mov    %edx,(%eax)
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	8b 00                	mov    (%eax),%eax
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	74 0d                	je     802ab7 <insert_sorted_with_merge_freeList+0x255>
  802aaa:	a1 48 41 80 00       	mov    0x804148,%eax
  802aaf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab2:	89 50 04             	mov    %edx,0x4(%eax)
  802ab5:	eb 08                	jmp    802abf <insert_sorted_with_merge_freeList+0x25d>
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	a3 48 41 80 00       	mov    %eax,0x804148
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ad1:	a1 54 41 80 00       	mov    0x804154,%eax
  802ad6:	40                   	inc    %eax
  802ad7:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802adc:	e9 da 04 00 00       	jmp    802fbb <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802ae1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ae5:	75 17                	jne    802afe <insert_sorted_with_merge_freeList+0x29c>
  802ae7:	83 ec 04             	sub    $0x4,%esp
  802aea:	68 18 3c 80 00       	push   $0x803c18
  802aef:	68 37 01 00 00       	push   $0x137
  802af4:	68 93 3b 80 00       	push   $0x803b93
  802af9:	e8 b8 d7 ff ff       	call   8002b6 <_panic>
  802afe:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b04:	8b 45 08             	mov    0x8(%ebp),%eax
  802b07:	89 50 04             	mov    %edx,0x4(%eax)
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	8b 40 04             	mov    0x4(%eax),%eax
  802b10:	85 c0                	test   %eax,%eax
  802b12:	74 0c                	je     802b20 <insert_sorted_with_merge_freeList+0x2be>
  802b14:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b19:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1c:	89 10                	mov    %edx,(%eax)
  802b1e:	eb 08                	jmp    802b28 <insert_sorted_with_merge_freeList+0x2c6>
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	a3 38 41 80 00       	mov    %eax,0x804138
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b39:	a1 44 41 80 00       	mov    0x804144,%eax
  802b3e:	40                   	inc    %eax
  802b3f:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802b44:	e9 72 04 00 00       	jmp    802fbb <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802b49:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b51:	e9 35 04 00 00       	jmp    802f8b <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 00                	mov    (%eax),%eax
  802b5b:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	8b 50 08             	mov    0x8(%eax),%edx
  802b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b67:	8b 40 08             	mov    0x8(%eax),%eax
  802b6a:	39 c2                	cmp    %eax,%edx
  802b6c:	0f 86 11 04 00 00    	jbe    802f83 <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b75:	8b 50 08             	mov    0x8(%eax),%edx
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7e:	01 c2                	add    %eax,%edx
  802b80:	8b 45 08             	mov    0x8(%ebp),%eax
  802b83:	8b 40 08             	mov    0x8(%eax),%eax
  802b86:	39 c2                	cmp    %eax,%edx
  802b88:	0f 83 8b 00 00 00    	jae    802c19 <insert_sorted_with_merge_freeList+0x3b7>
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	8b 50 08             	mov    0x8(%eax),%edx
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9a:	01 c2                	add    %eax,%edx
  802b9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ba2:	39 c2                	cmp    %eax,%edx
  802ba4:	73 73                	jae    802c19 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802ba6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802baa:	74 06                	je     802bb2 <insert_sorted_with_merge_freeList+0x350>
  802bac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb0:	75 17                	jne    802bc9 <insert_sorted_with_merge_freeList+0x367>
  802bb2:	83 ec 04             	sub    $0x4,%esp
  802bb5:	68 e4 3b 80 00       	push   $0x803be4
  802bba:	68 48 01 00 00       	push   $0x148
  802bbf:	68 93 3b 80 00       	push   $0x803b93
  802bc4:	e8 ed d6 ff ff       	call   8002b6 <_panic>
  802bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bcc:	8b 10                	mov    (%eax),%edx
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	89 10                	mov    %edx,(%eax)
  802bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd6:	8b 00                	mov    (%eax),%eax
  802bd8:	85 c0                	test   %eax,%eax
  802bda:	74 0b                	je     802be7 <insert_sorted_with_merge_freeList+0x385>
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	8b 55 08             	mov    0x8(%ebp),%edx
  802be4:	89 50 04             	mov    %edx,0x4(%eax)
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 55 08             	mov    0x8(%ebp),%edx
  802bed:	89 10                	mov    %edx,(%eax)
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf5:	89 50 04             	mov    %edx,0x4(%eax)
  802bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfb:	8b 00                	mov    (%eax),%eax
  802bfd:	85 c0                	test   %eax,%eax
  802bff:	75 08                	jne    802c09 <insert_sorted_with_merge_freeList+0x3a7>
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c09:	a1 44 41 80 00       	mov    0x804144,%eax
  802c0e:	40                   	inc    %eax
  802c0f:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802c14:	e9 a2 03 00 00       	jmp    802fbb <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802c19:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1c:	8b 50 08             	mov    0x8(%eax),%edx
  802c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c22:	8b 40 0c             	mov    0xc(%eax),%eax
  802c25:	01 c2                	add    %eax,%edx
  802c27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c2a:	8b 40 08             	mov    0x8(%eax),%eax
  802c2d:	39 c2                	cmp    %eax,%edx
  802c2f:	0f 83 ae 00 00 00    	jae    802ce3 <insert_sorted_with_merge_freeList+0x481>
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	8b 50 08             	mov    0x8(%eax),%edx
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	8b 48 08             	mov    0x8(%eax),%ecx
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 40 0c             	mov    0xc(%eax),%eax
  802c47:	01 c8                	add    %ecx,%eax
  802c49:	39 c2                	cmp    %eax,%edx
  802c4b:	0f 85 92 00 00 00    	jne    802ce3 <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c54:	8b 50 0c             	mov    0xc(%eax),%edx
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c5d:	01 c2                	add    %eax,%edx
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	8b 50 08             	mov    0x8(%eax),%edx
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c7f:	75 17                	jne    802c98 <insert_sorted_with_merge_freeList+0x436>
  802c81:	83 ec 04             	sub    $0x4,%esp
  802c84:	68 70 3b 80 00       	push   $0x803b70
  802c89:	68 51 01 00 00       	push   $0x151
  802c8e:	68 93 3b 80 00       	push   $0x803b93
  802c93:	e8 1e d6 ff ff       	call   8002b6 <_panic>
  802c98:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	89 10                	mov    %edx,(%eax)
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	8b 00                	mov    (%eax),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	74 0d                	je     802cb9 <insert_sorted_with_merge_freeList+0x457>
  802cac:	a1 48 41 80 00       	mov    0x804148,%eax
  802cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb4:	89 50 04             	mov    %edx,0x4(%eax)
  802cb7:	eb 08                	jmp    802cc1 <insert_sorted_with_merge_freeList+0x45f>
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	a3 48 41 80 00       	mov    %eax,0x804148
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd3:	a1 54 41 80 00       	mov    0x804154,%eax
  802cd8:	40                   	inc    %eax
  802cd9:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802cde:	e9 d8 02 00 00       	jmp    802fbb <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce6:	8b 50 08             	mov    0x8(%eax),%edx
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 40 0c             	mov    0xc(%eax),%eax
  802cef:	01 c2                	add    %eax,%edx
  802cf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf4:	8b 40 08             	mov    0x8(%eax),%eax
  802cf7:	39 c2                	cmp    %eax,%edx
  802cf9:	0f 85 ba 00 00 00    	jne    802db9 <insert_sorted_with_merge_freeList+0x557>
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	8b 50 08             	mov    0x8(%eax),%edx
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 48 08             	mov    0x8(%eax),%ecx
  802d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d11:	01 c8                	add    %ecx,%eax
  802d13:	39 c2                	cmp    %eax,%edx
  802d15:	0f 86 9e 00 00 00    	jbe    802db9 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802d1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	8b 40 0c             	mov    0xc(%eax),%eax
  802d27:	01 c2                	add    %eax,%edx
  802d29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2c:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	8b 50 08             	mov    0x8(%eax),%edx
  802d35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d38:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	8b 50 08             	mov    0x8(%eax),%edx
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d55:	75 17                	jne    802d6e <insert_sorted_with_merge_freeList+0x50c>
  802d57:	83 ec 04             	sub    $0x4,%esp
  802d5a:	68 70 3b 80 00       	push   $0x803b70
  802d5f:	68 5b 01 00 00       	push   $0x15b
  802d64:	68 93 3b 80 00       	push   $0x803b93
  802d69:	e8 48 d5 ff ff       	call   8002b6 <_panic>
  802d6e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	89 10                	mov    %edx,(%eax)
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	8b 00                	mov    (%eax),%eax
  802d7e:	85 c0                	test   %eax,%eax
  802d80:	74 0d                	je     802d8f <insert_sorted_with_merge_freeList+0x52d>
  802d82:	a1 48 41 80 00       	mov    0x804148,%eax
  802d87:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8a:	89 50 04             	mov    %edx,0x4(%eax)
  802d8d:	eb 08                	jmp    802d97 <insert_sorted_with_merge_freeList+0x535>
  802d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d92:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	a3 48 41 80 00       	mov    %eax,0x804148
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802da9:	a1 54 41 80 00       	mov    0x804154,%eax
  802dae:	40                   	inc    %eax
  802daf:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802db4:	e9 02 02 00 00       	jmp    802fbb <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	8b 50 08             	mov    0x8(%eax),%edx
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc5:	01 c2                	add    %eax,%edx
  802dc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dca:	8b 40 08             	mov    0x8(%eax),%eax
  802dcd:	39 c2                	cmp    %eax,%edx
  802dcf:	0f 85 ae 01 00 00    	jne    802f83 <insert_sorted_with_merge_freeList+0x721>
  802dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd8:	8b 50 08             	mov    0x8(%eax),%edx
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 48 08             	mov    0x8(%eax),%ecx
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	8b 40 0c             	mov    0xc(%eax),%eax
  802de7:	01 c8                	add    %ecx,%eax
  802de9:	39 c2                	cmp    %eax,%edx
  802deb:	0f 85 92 01 00 00    	jne    802f83 <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df4:	8b 50 0c             	mov    0xc(%eax),%edx
  802df7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802dfd:	01 c2                	add    %eax,%edx
  802dff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e02:	8b 40 0c             	mov    0xc(%eax),%eax
  802e05:	01 c2                	add    %eax,%edx
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	8b 50 08             	mov    0x8(%eax),%edx
  802e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e20:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802e23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e26:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802e2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e30:	8b 50 08             	mov    0x8(%eax),%edx
  802e33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e36:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802e39:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e3d:	75 17                	jne    802e56 <insert_sorted_with_merge_freeList+0x5f4>
  802e3f:	83 ec 04             	sub    $0x4,%esp
  802e42:	68 3b 3c 80 00       	push   $0x803c3b
  802e47:	68 63 01 00 00       	push   $0x163
  802e4c:	68 93 3b 80 00       	push   $0x803b93
  802e51:	e8 60 d4 ff ff       	call   8002b6 <_panic>
  802e56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e59:	8b 00                	mov    (%eax),%eax
  802e5b:	85 c0                	test   %eax,%eax
  802e5d:	74 10                	je     802e6f <insert_sorted_with_merge_freeList+0x60d>
  802e5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e62:	8b 00                	mov    (%eax),%eax
  802e64:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e67:	8b 52 04             	mov    0x4(%edx),%edx
  802e6a:	89 50 04             	mov    %edx,0x4(%eax)
  802e6d:	eb 0b                	jmp    802e7a <insert_sorted_with_merge_freeList+0x618>
  802e6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e72:	8b 40 04             	mov    0x4(%eax),%eax
  802e75:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7d:	8b 40 04             	mov    0x4(%eax),%eax
  802e80:	85 c0                	test   %eax,%eax
  802e82:	74 0f                	je     802e93 <insert_sorted_with_merge_freeList+0x631>
  802e84:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e87:	8b 40 04             	mov    0x4(%eax),%eax
  802e8a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e8d:	8b 12                	mov    (%edx),%edx
  802e8f:	89 10                	mov    %edx,(%eax)
  802e91:	eb 0a                	jmp    802e9d <insert_sorted_with_merge_freeList+0x63b>
  802e93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e96:	8b 00                	mov    (%eax),%eax
  802e98:	a3 38 41 80 00       	mov    %eax,0x804138
  802e9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb0:	a1 44 41 80 00       	mov    0x804144,%eax
  802eb5:	48                   	dec    %eax
  802eb6:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802ebb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ebf:	75 17                	jne    802ed8 <insert_sorted_with_merge_freeList+0x676>
  802ec1:	83 ec 04             	sub    $0x4,%esp
  802ec4:	68 70 3b 80 00       	push   $0x803b70
  802ec9:	68 64 01 00 00       	push   $0x164
  802ece:	68 93 3b 80 00       	push   $0x803b93
  802ed3:	e8 de d3 ff ff       	call   8002b6 <_panic>
  802ed8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ede:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee1:	89 10                	mov    %edx,(%eax)
  802ee3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	85 c0                	test   %eax,%eax
  802eea:	74 0d                	je     802ef9 <insert_sorted_with_merge_freeList+0x697>
  802eec:	a1 48 41 80 00       	mov    0x804148,%eax
  802ef1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ef4:	89 50 04             	mov    %edx,0x4(%eax)
  802ef7:	eb 08                	jmp    802f01 <insert_sorted_with_merge_freeList+0x69f>
  802ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f04:	a3 48 41 80 00       	mov    %eax,0x804148
  802f09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f0c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f13:	a1 54 41 80 00       	mov    0x804154,%eax
  802f18:	40                   	inc    %eax
  802f19:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802f1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f22:	75 17                	jne    802f3b <insert_sorted_with_merge_freeList+0x6d9>
  802f24:	83 ec 04             	sub    $0x4,%esp
  802f27:	68 70 3b 80 00       	push   $0x803b70
  802f2c:	68 65 01 00 00       	push   $0x165
  802f31:	68 93 3b 80 00       	push   $0x803b93
  802f36:	e8 7b d3 ff ff       	call   8002b6 <_panic>
  802f3b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f41:	8b 45 08             	mov    0x8(%ebp),%eax
  802f44:	89 10                	mov    %edx,(%eax)
  802f46:	8b 45 08             	mov    0x8(%ebp),%eax
  802f49:	8b 00                	mov    (%eax),%eax
  802f4b:	85 c0                	test   %eax,%eax
  802f4d:	74 0d                	je     802f5c <insert_sorted_with_merge_freeList+0x6fa>
  802f4f:	a1 48 41 80 00       	mov    0x804148,%eax
  802f54:	8b 55 08             	mov    0x8(%ebp),%edx
  802f57:	89 50 04             	mov    %edx,0x4(%eax)
  802f5a:	eb 08                	jmp    802f64 <insert_sorted_with_merge_freeList+0x702>
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	a3 48 41 80 00       	mov    %eax,0x804148
  802f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f76:	a1 54 41 80 00       	mov    0x804154,%eax
  802f7b:	40                   	inc    %eax
  802f7c:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802f81:	eb 38                	jmp    802fbb <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f83:	a1 40 41 80 00       	mov    0x804140,%eax
  802f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f8f:	74 07                	je     802f98 <insert_sorted_with_merge_freeList+0x736>
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	8b 00                	mov    (%eax),%eax
  802f96:	eb 05                	jmp    802f9d <insert_sorted_with_merge_freeList+0x73b>
  802f98:	b8 00 00 00 00       	mov    $0x0,%eax
  802f9d:	a3 40 41 80 00       	mov    %eax,0x804140
  802fa2:	a1 40 41 80 00       	mov    0x804140,%eax
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	0f 85 a7 fb ff ff    	jne    802b56 <insert_sorted_with_merge_freeList+0x2f4>
  802faf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fb3:	0f 85 9d fb ff ff    	jne    802b56 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802fb9:	eb 00                	jmp    802fbb <insert_sorted_with_merge_freeList+0x759>
  802fbb:	90                   	nop
  802fbc:	c9                   	leave  
  802fbd:	c3                   	ret    

00802fbe <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802fbe:	55                   	push   %ebp
  802fbf:	89 e5                	mov    %esp,%ebp
  802fc1:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc7:	89 d0                	mov    %edx,%eax
  802fc9:	c1 e0 02             	shl    $0x2,%eax
  802fcc:	01 d0                	add    %edx,%eax
  802fce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fd5:	01 d0                	add    %edx,%eax
  802fd7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fde:	01 d0                	add    %edx,%eax
  802fe0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fe7:	01 d0                	add    %edx,%eax
  802fe9:	c1 e0 04             	shl    $0x4,%eax
  802fec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802fef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802ff6:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802ff9:	83 ec 0c             	sub    $0xc,%esp
  802ffc:	50                   	push   %eax
  802ffd:	e8 ee eb ff ff       	call   801bf0 <sys_get_virtual_time>
  803002:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803005:	eb 41                	jmp    803048 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803007:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80300a:	83 ec 0c             	sub    $0xc,%esp
  80300d:	50                   	push   %eax
  80300e:	e8 dd eb ff ff       	call   801bf0 <sys_get_virtual_time>
  803013:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803016:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803019:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301c:	29 c2                	sub    %eax,%edx
  80301e:	89 d0                	mov    %edx,%eax
  803020:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803023:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803026:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803029:	89 d1                	mov    %edx,%ecx
  80302b:	29 c1                	sub    %eax,%ecx
  80302d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803030:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803033:	39 c2                	cmp    %eax,%edx
  803035:	0f 97 c0             	seta   %al
  803038:	0f b6 c0             	movzbl %al,%eax
  80303b:	29 c1                	sub    %eax,%ecx
  80303d:	89 c8                	mov    %ecx,%eax
  80303f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803042:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803045:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80304e:	72 b7                	jb     803007 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803050:	90                   	nop
  803051:	c9                   	leave  
  803052:	c3                   	ret    

00803053 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803053:	55                   	push   %ebp
  803054:	89 e5                	mov    %esp,%ebp
  803056:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803060:	eb 03                	jmp    803065 <busy_wait+0x12>
  803062:	ff 45 fc             	incl   -0x4(%ebp)
  803065:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803068:	3b 45 08             	cmp    0x8(%ebp),%eax
  80306b:	72 f5                	jb     803062 <busy_wait+0xf>
	return i;
  80306d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803070:	c9                   	leave  
  803071:	c3                   	ret    
  803072:	66 90                	xchg   %ax,%ax

00803074 <__udivdi3>:
  803074:	55                   	push   %ebp
  803075:	57                   	push   %edi
  803076:	56                   	push   %esi
  803077:	53                   	push   %ebx
  803078:	83 ec 1c             	sub    $0x1c,%esp
  80307b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80307f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803083:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803087:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80308b:	89 ca                	mov    %ecx,%edx
  80308d:	89 f8                	mov    %edi,%eax
  80308f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803093:	85 f6                	test   %esi,%esi
  803095:	75 2d                	jne    8030c4 <__udivdi3+0x50>
  803097:	39 cf                	cmp    %ecx,%edi
  803099:	77 65                	ja     803100 <__udivdi3+0x8c>
  80309b:	89 fd                	mov    %edi,%ebp
  80309d:	85 ff                	test   %edi,%edi
  80309f:	75 0b                	jne    8030ac <__udivdi3+0x38>
  8030a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8030a6:	31 d2                	xor    %edx,%edx
  8030a8:	f7 f7                	div    %edi
  8030aa:	89 c5                	mov    %eax,%ebp
  8030ac:	31 d2                	xor    %edx,%edx
  8030ae:	89 c8                	mov    %ecx,%eax
  8030b0:	f7 f5                	div    %ebp
  8030b2:	89 c1                	mov    %eax,%ecx
  8030b4:	89 d8                	mov    %ebx,%eax
  8030b6:	f7 f5                	div    %ebp
  8030b8:	89 cf                	mov    %ecx,%edi
  8030ba:	89 fa                	mov    %edi,%edx
  8030bc:	83 c4 1c             	add    $0x1c,%esp
  8030bf:	5b                   	pop    %ebx
  8030c0:	5e                   	pop    %esi
  8030c1:	5f                   	pop    %edi
  8030c2:	5d                   	pop    %ebp
  8030c3:	c3                   	ret    
  8030c4:	39 ce                	cmp    %ecx,%esi
  8030c6:	77 28                	ja     8030f0 <__udivdi3+0x7c>
  8030c8:	0f bd fe             	bsr    %esi,%edi
  8030cb:	83 f7 1f             	xor    $0x1f,%edi
  8030ce:	75 40                	jne    803110 <__udivdi3+0x9c>
  8030d0:	39 ce                	cmp    %ecx,%esi
  8030d2:	72 0a                	jb     8030de <__udivdi3+0x6a>
  8030d4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030d8:	0f 87 9e 00 00 00    	ja     80317c <__udivdi3+0x108>
  8030de:	b8 01 00 00 00       	mov    $0x1,%eax
  8030e3:	89 fa                	mov    %edi,%edx
  8030e5:	83 c4 1c             	add    $0x1c,%esp
  8030e8:	5b                   	pop    %ebx
  8030e9:	5e                   	pop    %esi
  8030ea:	5f                   	pop    %edi
  8030eb:	5d                   	pop    %ebp
  8030ec:	c3                   	ret    
  8030ed:	8d 76 00             	lea    0x0(%esi),%esi
  8030f0:	31 ff                	xor    %edi,%edi
  8030f2:	31 c0                	xor    %eax,%eax
  8030f4:	89 fa                	mov    %edi,%edx
  8030f6:	83 c4 1c             	add    $0x1c,%esp
  8030f9:	5b                   	pop    %ebx
  8030fa:	5e                   	pop    %esi
  8030fb:	5f                   	pop    %edi
  8030fc:	5d                   	pop    %ebp
  8030fd:	c3                   	ret    
  8030fe:	66 90                	xchg   %ax,%ax
  803100:	89 d8                	mov    %ebx,%eax
  803102:	f7 f7                	div    %edi
  803104:	31 ff                	xor    %edi,%edi
  803106:	89 fa                	mov    %edi,%edx
  803108:	83 c4 1c             	add    $0x1c,%esp
  80310b:	5b                   	pop    %ebx
  80310c:	5e                   	pop    %esi
  80310d:	5f                   	pop    %edi
  80310e:	5d                   	pop    %ebp
  80310f:	c3                   	ret    
  803110:	bd 20 00 00 00       	mov    $0x20,%ebp
  803115:	89 eb                	mov    %ebp,%ebx
  803117:	29 fb                	sub    %edi,%ebx
  803119:	89 f9                	mov    %edi,%ecx
  80311b:	d3 e6                	shl    %cl,%esi
  80311d:	89 c5                	mov    %eax,%ebp
  80311f:	88 d9                	mov    %bl,%cl
  803121:	d3 ed                	shr    %cl,%ebp
  803123:	89 e9                	mov    %ebp,%ecx
  803125:	09 f1                	or     %esi,%ecx
  803127:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80312b:	89 f9                	mov    %edi,%ecx
  80312d:	d3 e0                	shl    %cl,%eax
  80312f:	89 c5                	mov    %eax,%ebp
  803131:	89 d6                	mov    %edx,%esi
  803133:	88 d9                	mov    %bl,%cl
  803135:	d3 ee                	shr    %cl,%esi
  803137:	89 f9                	mov    %edi,%ecx
  803139:	d3 e2                	shl    %cl,%edx
  80313b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80313f:	88 d9                	mov    %bl,%cl
  803141:	d3 e8                	shr    %cl,%eax
  803143:	09 c2                	or     %eax,%edx
  803145:	89 d0                	mov    %edx,%eax
  803147:	89 f2                	mov    %esi,%edx
  803149:	f7 74 24 0c          	divl   0xc(%esp)
  80314d:	89 d6                	mov    %edx,%esi
  80314f:	89 c3                	mov    %eax,%ebx
  803151:	f7 e5                	mul    %ebp
  803153:	39 d6                	cmp    %edx,%esi
  803155:	72 19                	jb     803170 <__udivdi3+0xfc>
  803157:	74 0b                	je     803164 <__udivdi3+0xf0>
  803159:	89 d8                	mov    %ebx,%eax
  80315b:	31 ff                	xor    %edi,%edi
  80315d:	e9 58 ff ff ff       	jmp    8030ba <__udivdi3+0x46>
  803162:	66 90                	xchg   %ax,%ax
  803164:	8b 54 24 08          	mov    0x8(%esp),%edx
  803168:	89 f9                	mov    %edi,%ecx
  80316a:	d3 e2                	shl    %cl,%edx
  80316c:	39 c2                	cmp    %eax,%edx
  80316e:	73 e9                	jae    803159 <__udivdi3+0xe5>
  803170:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803173:	31 ff                	xor    %edi,%edi
  803175:	e9 40 ff ff ff       	jmp    8030ba <__udivdi3+0x46>
  80317a:	66 90                	xchg   %ax,%ax
  80317c:	31 c0                	xor    %eax,%eax
  80317e:	e9 37 ff ff ff       	jmp    8030ba <__udivdi3+0x46>
  803183:	90                   	nop

00803184 <__umoddi3>:
  803184:	55                   	push   %ebp
  803185:	57                   	push   %edi
  803186:	56                   	push   %esi
  803187:	53                   	push   %ebx
  803188:	83 ec 1c             	sub    $0x1c,%esp
  80318b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80318f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803193:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803197:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80319b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80319f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031a3:	89 f3                	mov    %esi,%ebx
  8031a5:	89 fa                	mov    %edi,%edx
  8031a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031ab:	89 34 24             	mov    %esi,(%esp)
  8031ae:	85 c0                	test   %eax,%eax
  8031b0:	75 1a                	jne    8031cc <__umoddi3+0x48>
  8031b2:	39 f7                	cmp    %esi,%edi
  8031b4:	0f 86 a2 00 00 00    	jbe    80325c <__umoddi3+0xd8>
  8031ba:	89 c8                	mov    %ecx,%eax
  8031bc:	89 f2                	mov    %esi,%edx
  8031be:	f7 f7                	div    %edi
  8031c0:	89 d0                	mov    %edx,%eax
  8031c2:	31 d2                	xor    %edx,%edx
  8031c4:	83 c4 1c             	add    $0x1c,%esp
  8031c7:	5b                   	pop    %ebx
  8031c8:	5e                   	pop    %esi
  8031c9:	5f                   	pop    %edi
  8031ca:	5d                   	pop    %ebp
  8031cb:	c3                   	ret    
  8031cc:	39 f0                	cmp    %esi,%eax
  8031ce:	0f 87 ac 00 00 00    	ja     803280 <__umoddi3+0xfc>
  8031d4:	0f bd e8             	bsr    %eax,%ebp
  8031d7:	83 f5 1f             	xor    $0x1f,%ebp
  8031da:	0f 84 ac 00 00 00    	je     80328c <__umoddi3+0x108>
  8031e0:	bf 20 00 00 00       	mov    $0x20,%edi
  8031e5:	29 ef                	sub    %ebp,%edi
  8031e7:	89 fe                	mov    %edi,%esi
  8031e9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031ed:	89 e9                	mov    %ebp,%ecx
  8031ef:	d3 e0                	shl    %cl,%eax
  8031f1:	89 d7                	mov    %edx,%edi
  8031f3:	89 f1                	mov    %esi,%ecx
  8031f5:	d3 ef                	shr    %cl,%edi
  8031f7:	09 c7                	or     %eax,%edi
  8031f9:	89 e9                	mov    %ebp,%ecx
  8031fb:	d3 e2                	shl    %cl,%edx
  8031fd:	89 14 24             	mov    %edx,(%esp)
  803200:	89 d8                	mov    %ebx,%eax
  803202:	d3 e0                	shl    %cl,%eax
  803204:	89 c2                	mov    %eax,%edx
  803206:	8b 44 24 08          	mov    0x8(%esp),%eax
  80320a:	d3 e0                	shl    %cl,%eax
  80320c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803210:	8b 44 24 08          	mov    0x8(%esp),%eax
  803214:	89 f1                	mov    %esi,%ecx
  803216:	d3 e8                	shr    %cl,%eax
  803218:	09 d0                	or     %edx,%eax
  80321a:	d3 eb                	shr    %cl,%ebx
  80321c:	89 da                	mov    %ebx,%edx
  80321e:	f7 f7                	div    %edi
  803220:	89 d3                	mov    %edx,%ebx
  803222:	f7 24 24             	mull   (%esp)
  803225:	89 c6                	mov    %eax,%esi
  803227:	89 d1                	mov    %edx,%ecx
  803229:	39 d3                	cmp    %edx,%ebx
  80322b:	0f 82 87 00 00 00    	jb     8032b8 <__umoddi3+0x134>
  803231:	0f 84 91 00 00 00    	je     8032c8 <__umoddi3+0x144>
  803237:	8b 54 24 04          	mov    0x4(%esp),%edx
  80323b:	29 f2                	sub    %esi,%edx
  80323d:	19 cb                	sbb    %ecx,%ebx
  80323f:	89 d8                	mov    %ebx,%eax
  803241:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803245:	d3 e0                	shl    %cl,%eax
  803247:	89 e9                	mov    %ebp,%ecx
  803249:	d3 ea                	shr    %cl,%edx
  80324b:	09 d0                	or     %edx,%eax
  80324d:	89 e9                	mov    %ebp,%ecx
  80324f:	d3 eb                	shr    %cl,%ebx
  803251:	89 da                	mov    %ebx,%edx
  803253:	83 c4 1c             	add    $0x1c,%esp
  803256:	5b                   	pop    %ebx
  803257:	5e                   	pop    %esi
  803258:	5f                   	pop    %edi
  803259:	5d                   	pop    %ebp
  80325a:	c3                   	ret    
  80325b:	90                   	nop
  80325c:	89 fd                	mov    %edi,%ebp
  80325e:	85 ff                	test   %edi,%edi
  803260:	75 0b                	jne    80326d <__umoddi3+0xe9>
  803262:	b8 01 00 00 00       	mov    $0x1,%eax
  803267:	31 d2                	xor    %edx,%edx
  803269:	f7 f7                	div    %edi
  80326b:	89 c5                	mov    %eax,%ebp
  80326d:	89 f0                	mov    %esi,%eax
  80326f:	31 d2                	xor    %edx,%edx
  803271:	f7 f5                	div    %ebp
  803273:	89 c8                	mov    %ecx,%eax
  803275:	f7 f5                	div    %ebp
  803277:	89 d0                	mov    %edx,%eax
  803279:	e9 44 ff ff ff       	jmp    8031c2 <__umoddi3+0x3e>
  80327e:	66 90                	xchg   %ax,%ax
  803280:	89 c8                	mov    %ecx,%eax
  803282:	89 f2                	mov    %esi,%edx
  803284:	83 c4 1c             	add    $0x1c,%esp
  803287:	5b                   	pop    %ebx
  803288:	5e                   	pop    %esi
  803289:	5f                   	pop    %edi
  80328a:	5d                   	pop    %ebp
  80328b:	c3                   	ret    
  80328c:	3b 04 24             	cmp    (%esp),%eax
  80328f:	72 06                	jb     803297 <__umoddi3+0x113>
  803291:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803295:	77 0f                	ja     8032a6 <__umoddi3+0x122>
  803297:	89 f2                	mov    %esi,%edx
  803299:	29 f9                	sub    %edi,%ecx
  80329b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80329f:	89 14 24             	mov    %edx,(%esp)
  8032a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032a6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032aa:	8b 14 24             	mov    (%esp),%edx
  8032ad:	83 c4 1c             	add    $0x1c,%esp
  8032b0:	5b                   	pop    %ebx
  8032b1:	5e                   	pop    %esi
  8032b2:	5f                   	pop    %edi
  8032b3:	5d                   	pop    %ebp
  8032b4:	c3                   	ret    
  8032b5:	8d 76 00             	lea    0x0(%esi),%esi
  8032b8:	2b 04 24             	sub    (%esp),%eax
  8032bb:	19 fa                	sbb    %edi,%edx
  8032bd:	89 d1                	mov    %edx,%ecx
  8032bf:	89 c6                	mov    %eax,%esi
  8032c1:	e9 71 ff ff ff       	jmp    803237 <__umoddi3+0xb3>
  8032c6:	66 90                	xchg   %ax,%ax
  8032c8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8032cc:	72 ea                	jb     8032b8 <__umoddi3+0x134>
  8032ce:	89 d9                	mov    %ebx,%ecx
  8032d0:	e9 62 ff ff ff       	jmp    803237 <__umoddi3+0xb3>
