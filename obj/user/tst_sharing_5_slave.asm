
obj/user/tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 ff 00 00 00       	call   800135 <libmain>
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
  80008c:	68 e0 31 80 00       	push   $0x8031e0
  800091:	6a 12                	push   $0x12
  800093:	68 fc 31 80 00       	push   $0x8031fc
  800098:	e8 d4 01 00 00       	call   800271 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 aa 13 00 00       	call   801451 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int expected;
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 c9 1a 00 00       	call   801b78 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 17 32 80 00       	push   $0x803217
  8000b7:	50                   	push   %eax
  8000b8:	e8 8c 15 00 00       	call   801649 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000c3:	e8 b7 17 00 00       	call   80187f <sys_calculate_free_frames>
  8000c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 1c 32 80 00       	push   $0x80321c
  8000d3:	e8 4d 04 00 00       	call   800525 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e1:	e8 39 16 00 00       	call   80171f <sfree>
  8000e6:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	68 40 32 80 00       	push   $0x803240
  8000f1:	e8 2f 04 00 00       	call   800525 <cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 81 17 00 00       	call   80187f <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	expected = 1;
  80010a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  800111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800114:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 58 32 80 00       	push   $0x803258
  800121:	6a 24                	push   $0x24
  800123:	68 fc 31 80 00       	push   $0x8031fc
  800128:	e8 44 01 00 00       	call   800271 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80012d:	e8 6b 1b 00 00       	call   801c9d <inctst>

	return;
  800132:	90                   	nop
}
  800133:	c9                   	leave  
  800134:	c3                   	ret    

00800135 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013b:	e8 1f 1a 00 00       	call   801b5f <sys_getenvindex>
  800140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800143:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800146:	89 d0                	mov    %edx,%eax
  800148:	c1 e0 03             	shl    $0x3,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	01 c0                	add    %eax,%eax
  80014f:	01 d0                	add    %edx,%eax
  800151:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800158:	01 d0                	add    %edx,%eax
  80015a:	c1 e0 04             	shl    $0x4,%eax
  80015d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800162:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800167:	a1 20 40 80 00       	mov    0x804020,%eax
  80016c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800172:	84 c0                	test   %al,%al
  800174:	74 0f                	je     800185 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800176:	a1 20 40 80 00       	mov    0x804020,%eax
  80017b:	05 5c 05 00 00       	add    $0x55c,%eax
  800180:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800185:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800189:	7e 0a                	jle    800195 <libmain+0x60>
		binaryname = argv[0];
  80018b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018e:	8b 00                	mov    (%eax),%eax
  800190:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	ff 75 0c             	pushl  0xc(%ebp)
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	e8 95 fe ff ff       	call   800038 <_main>
  8001a3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a6:	e8 c1 17 00 00       	call   80196c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 fc 32 80 00       	push   $0x8032fc
  8001b3:	e8 6d 03 00 00       	call   800525 <cprintf>
  8001b8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d1:	83 ec 04             	sub    $0x4,%esp
  8001d4:	52                   	push   %edx
  8001d5:	50                   	push   %eax
  8001d6:	68 24 33 80 00       	push   $0x803324
  8001db:	e8 45 03 00 00       	call   800525 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fe:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800204:	51                   	push   %ecx
  800205:	52                   	push   %edx
  800206:	50                   	push   %eax
  800207:	68 4c 33 80 00       	push   $0x80334c
  80020c:	e8 14 03 00 00       	call   800525 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800214:	a1 20 40 80 00       	mov    0x804020,%eax
  800219:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 a4 33 80 00       	push   $0x8033a4
  800228:	e8 f8 02 00 00       	call   800525 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 fc 32 80 00       	push   $0x8032fc
  800238:	e8 e8 02 00 00       	call   800525 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800240:	e8 41 17 00 00       	call   801986 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800245:	e8 19 00 00 00       	call   800263 <exit>
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	6a 00                	push   $0x0
  800258:	e8 ce 18 00 00       	call   801b2b <sys_destroy_env>
  80025d:	83 c4 10             	add    $0x10,%esp
}
  800260:	90                   	nop
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <exit>:

void
exit(void)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800269:	e8 23 19 00 00       	call   801b91 <sys_exit_env>
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800277:	8d 45 10             	lea    0x10(%ebp),%eax
  80027a:	83 c0 04             	add    $0x4,%eax
  80027d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800280:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800285:	85 c0                	test   %eax,%eax
  800287:	74 16                	je     80029f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800289:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	50                   	push   %eax
  800292:	68 b8 33 80 00       	push   $0x8033b8
  800297:	e8 89 02 00 00       	call   800525 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029f:	a1 00 40 80 00       	mov    0x804000,%eax
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	50                   	push   %eax
  8002ab:	68 bd 33 80 00       	push   $0x8033bd
  8002b0:	e8 70 02 00 00       	call   800525 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c1:	50                   	push   %eax
  8002c2:	e8 f3 01 00 00       	call   8004ba <vcprintf>
  8002c7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	6a 00                	push   $0x0
  8002cf:	68 d9 33 80 00       	push   $0x8033d9
  8002d4:	e8 e1 01 00 00       	call   8004ba <vcprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002dc:	e8 82 ff ff ff       	call   800263 <exit>

	// should not return here
	while (1) ;
  8002e1:	eb fe                	jmp    8002e1 <_panic+0x70>

008002e3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ee:	8b 50 74             	mov    0x74(%eax),%edx
  8002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f4:	39 c2                	cmp    %eax,%edx
  8002f6:	74 14                	je     80030c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	68 dc 33 80 00       	push   $0x8033dc
  800300:	6a 26                	push   $0x26
  800302:	68 28 34 80 00       	push   $0x803428
  800307:	e8 65 ff ff ff       	call   800271 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80030c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800313:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80031a:	e9 c2 00 00 00       	jmp    8003e1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80031f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800322:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	01 d0                	add    %edx,%eax
  80032e:	8b 00                	mov    (%eax),%eax
  800330:	85 c0                	test   %eax,%eax
  800332:	75 08                	jne    80033c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800334:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800337:	e9 a2 00 00 00       	jmp    8003de <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80033c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800343:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80034a:	eb 69                	jmp    8003b5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80034c:	a1 20 40 80 00       	mov    0x804020,%eax
  800351:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800357:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80035a:	89 d0                	mov    %edx,%eax
  80035c:	01 c0                	add    %eax,%eax
  80035e:	01 d0                	add    %edx,%eax
  800360:	c1 e0 03             	shl    $0x3,%eax
  800363:	01 c8                	add    %ecx,%eax
  800365:	8a 40 04             	mov    0x4(%eax),%al
  800368:	84 c0                	test   %al,%al
  80036a:	75 46                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80036c:	a1 20 40 80 00       	mov    0x804020,%eax
  800371:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800377:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037a:	89 d0                	mov    %edx,%eax
  80037c:	01 c0                	add    %eax,%eax
  80037e:	01 d0                	add    %edx,%eax
  800380:	c1 e0 03             	shl    $0x3,%eax
  800383:	01 c8                	add    %ecx,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80038a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800392:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800397:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	01 c8                	add    %ecx,%eax
  8003a3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a5:	39 c2                	cmp    %eax,%edx
  8003a7:	75 09                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003a9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b0:	eb 12                	jmp    8003c4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b2:	ff 45 e8             	incl   -0x18(%ebp)
  8003b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ba:	8b 50 74             	mov    0x74(%eax),%edx
  8003bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c0:	39 c2                	cmp    %eax,%edx
  8003c2:	77 88                	ja     80034c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c8:	75 14                	jne    8003de <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	68 34 34 80 00       	push   $0x803434
  8003d2:	6a 3a                	push   $0x3a
  8003d4:	68 28 34 80 00       	push   $0x803428
  8003d9:	e8 93 fe ff ff       	call   800271 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003de:	ff 45 f0             	incl   -0x10(%ebp)
  8003e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e7:	0f 8c 32 ff ff ff    	jl     80031f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003fb:	eb 26                	jmp    800423 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800402:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800408:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80040b:	89 d0                	mov    %edx,%eax
  80040d:	01 c0                	add    %eax,%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	c1 e0 03             	shl    $0x3,%eax
  800414:	01 c8                	add    %ecx,%eax
  800416:	8a 40 04             	mov    0x4(%eax),%al
  800419:	3c 01                	cmp    $0x1,%al
  80041b:	75 03                	jne    800420 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80041d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800420:	ff 45 e0             	incl   -0x20(%ebp)
  800423:	a1 20 40 80 00       	mov    0x804020,%eax
  800428:	8b 50 74             	mov    0x74(%eax),%edx
  80042b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042e:	39 c2                	cmp    %eax,%edx
  800430:	77 cb                	ja     8003fd <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800435:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800438:	74 14                	je     80044e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80043a:	83 ec 04             	sub    $0x4,%esp
  80043d:	68 88 34 80 00       	push   $0x803488
  800442:	6a 44                	push   $0x44
  800444:	68 28 34 80 00       	push   $0x803428
  800449:	e8 23 fe ff ff       	call   800271 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044e:	90                   	nop
  80044f:	c9                   	leave  
  800450:	c3                   	ret    

00800451 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
  800454:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 48 01             	lea    0x1(%eax),%ecx
  80045f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800462:	89 0a                	mov    %ecx,(%edx)
  800464:	8b 55 08             	mov    0x8(%ebp),%edx
  800467:	88 d1                	mov    %dl,%cl
  800469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800470:	8b 45 0c             	mov    0xc(%ebp),%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	3d ff 00 00 00       	cmp    $0xff,%eax
  80047a:	75 2c                	jne    8004a8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80047c:	a0 24 40 80 00       	mov    0x804024,%al
  800481:	0f b6 c0             	movzbl %al,%eax
  800484:	8b 55 0c             	mov    0xc(%ebp),%edx
  800487:	8b 12                	mov    (%edx),%edx
  800489:	89 d1                	mov    %edx,%ecx
  80048b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048e:	83 c2 08             	add    $0x8,%edx
  800491:	83 ec 04             	sub    $0x4,%esp
  800494:	50                   	push   %eax
  800495:	51                   	push   %ecx
  800496:	52                   	push   %edx
  800497:	e8 22 13 00 00       	call   8017be <sys_cputs>
  80049c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	8b 40 04             	mov    0x4(%eax),%eax
  8004ae:	8d 50 01             	lea    0x1(%eax),%edx
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b7:	90                   	nop
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ca:	00 00 00 
	b.cnt = 0;
  8004cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d7:	ff 75 0c             	pushl  0xc(%ebp)
  8004da:	ff 75 08             	pushl  0x8(%ebp)
  8004dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e3:	50                   	push   %eax
  8004e4:	68 51 04 80 00       	push   $0x800451
  8004e9:	e8 11 02 00 00       	call   8006ff <vprintfmt>
  8004ee:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f1:	a0 24 40 80 00       	mov    0x804024,%al
  8004f6:	0f b6 c0             	movzbl %al,%eax
  8004f9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	50                   	push   %eax
  800503:	52                   	push   %edx
  800504:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80050a:	83 c0 08             	add    $0x8,%eax
  80050d:	50                   	push   %eax
  80050e:	e8 ab 12 00 00       	call   8017be <sys_cputs>
  800513:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800516:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80051d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800523:	c9                   	leave  
  800524:	c3                   	ret    

00800525 <cprintf>:

int cprintf(const char *fmt, ...) {
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800532:	8d 45 0c             	lea    0xc(%ebp),%eax
  800535:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	50                   	push   %eax
  800542:	e8 73 ff ff ff       	call   8004ba <vcprintf>
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800558:	e8 0f 14 00 00       	call   80196c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80055d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800560:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 f4             	pushl  -0xc(%ebp)
  80056c:	50                   	push   %eax
  80056d:	e8 48 ff ff ff       	call   8004ba <vcprintf>
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800578:	e8 09 14 00 00       	call   801986 <sys_enable_interrupt>
	return cnt;
  80057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	53                   	push   %ebx
  800586:	83 ec 14             	sub    $0x14,%esp
  800589:	8b 45 10             	mov    0x10(%ebp),%eax
  80058c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800595:	8b 45 18             	mov    0x18(%ebp),%eax
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
  80059d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a0:	77 55                	ja     8005f7 <printnum+0x75>
  8005a2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a5:	72 05                	jb     8005ac <printnum+0x2a>
  8005a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005aa:	77 4b                	ja     8005f7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005af:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ba:	52                   	push   %edx
  8005bb:	50                   	push   %eax
  8005bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c2:	e8 b5 29 00 00       	call   802f7c <__udivdi3>
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	ff 75 20             	pushl  0x20(%ebp)
  8005d0:	53                   	push   %ebx
  8005d1:	ff 75 18             	pushl  0x18(%ebp)
  8005d4:	52                   	push   %edx
  8005d5:	50                   	push   %eax
  8005d6:	ff 75 0c             	pushl  0xc(%ebp)
  8005d9:	ff 75 08             	pushl  0x8(%ebp)
  8005dc:	e8 a1 ff ff ff       	call   800582 <printnum>
  8005e1:	83 c4 20             	add    $0x20,%esp
  8005e4:	eb 1a                	jmp    800600 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e6:	83 ec 08             	sub    $0x8,%esp
  8005e9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	ff d0                	call   *%eax
  8005f4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f7:	ff 4d 1c             	decl   0x1c(%ebp)
  8005fa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fe:	7f e6                	jg     8005e6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800600:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800603:	bb 00 00 00 00       	mov    $0x0,%ebx
  800608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060e:	53                   	push   %ebx
  80060f:	51                   	push   %ecx
  800610:	52                   	push   %edx
  800611:	50                   	push   %eax
  800612:	e8 75 2a 00 00       	call   80308c <__umoddi3>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	05 f4 36 80 00       	add    $0x8036f4,%eax
  80061f:	8a 00                	mov    (%eax),%al
  800621:	0f be c0             	movsbl %al,%eax
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	ff 75 0c             	pushl  0xc(%ebp)
  80062a:	50                   	push   %eax
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	ff d0                	call   *%eax
  800630:	83 c4 10             	add    $0x10,%esp
}
  800633:	90                   	nop
  800634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800637:	c9                   	leave  
  800638:	c3                   	ret    

00800639 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800639:	55                   	push   %ebp
  80063a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80063c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800640:	7e 1c                	jle    80065e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	8d 50 08             	lea    0x8(%eax),%edx
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	89 10                	mov    %edx,(%eax)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	83 e8 08             	sub    $0x8,%eax
  800657:	8b 50 04             	mov    0x4(%eax),%edx
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	eb 40                	jmp    80069e <getuint+0x65>
	else if (lflag)
  80065e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800662:	74 1e                	je     800682 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	8d 50 04             	lea    0x4(%eax),%edx
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	89 10                	mov    %edx,(%eax)
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	83 e8 04             	sub    $0x4,%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	ba 00 00 00 00       	mov    $0x0,%edx
  800680:	eb 1c                	jmp    80069e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 10                	mov    %edx,(%eax)
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069e:	5d                   	pop    %ebp
  80069f:	c3                   	ret    

008006a0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a7:	7e 1c                	jle    8006c5 <getint+0x25>
		return va_arg(*ap, long long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 08             	lea    0x8(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 08             	sub    $0x8,%eax
  8006be:	8b 50 04             	mov    0x4(%eax),%edx
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	eb 38                	jmp    8006fd <getint+0x5d>
	else if (lflag)
  8006c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c9:	74 1a                	je     8006e5 <getint+0x45>
		return va_arg(*ap, long);
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	8d 50 04             	lea    0x4(%eax),%edx
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	89 10                	mov    %edx,(%eax)
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	83 e8 04             	sub    $0x4,%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	99                   	cltd   
  8006e3:	eb 18                	jmp    8006fd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	8d 50 04             	lea    0x4(%eax),%edx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 10                	mov    %edx,(%eax)
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	99                   	cltd   
}
  8006fd:	5d                   	pop    %ebp
  8006fe:	c3                   	ret    

008006ff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	56                   	push   %esi
  800703:	53                   	push   %ebx
  800704:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800707:	eb 17                	jmp    800720 <vprintfmt+0x21>
			if (ch == '\0')
  800709:	85 db                	test   %ebx,%ebx
  80070b:	0f 84 af 03 00 00    	je     800ac0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	53                   	push   %ebx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	ff d0                	call   *%eax
  80071d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800720:	8b 45 10             	mov    0x10(%ebp),%eax
  800723:	8d 50 01             	lea    0x1(%eax),%edx
  800726:	89 55 10             	mov    %edx,0x10(%ebp)
  800729:	8a 00                	mov    (%eax),%al
  80072b:	0f b6 d8             	movzbl %al,%ebx
  80072e:	83 fb 25             	cmp    $0x25,%ebx
  800731:	75 d6                	jne    800709 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800733:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800737:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800745:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80074c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800753:	8b 45 10             	mov    0x10(%ebp),%eax
  800756:	8d 50 01             	lea    0x1(%eax),%edx
  800759:	89 55 10             	mov    %edx,0x10(%ebp)
  80075c:	8a 00                	mov    (%eax),%al
  80075e:	0f b6 d8             	movzbl %al,%ebx
  800761:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800764:	83 f8 55             	cmp    $0x55,%eax
  800767:	0f 87 2b 03 00 00    	ja     800a98 <vprintfmt+0x399>
  80076d:	8b 04 85 18 37 80 00 	mov    0x803718(,%eax,4),%eax
  800774:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800776:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80077a:	eb d7                	jmp    800753 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800780:	eb d1                	jmp    800753 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800782:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800789:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80078c:	89 d0                	mov    %edx,%eax
  80078e:	c1 e0 02             	shl    $0x2,%eax
  800791:	01 d0                	add    %edx,%eax
  800793:	01 c0                	add    %eax,%eax
  800795:	01 d8                	add    %ebx,%eax
  800797:	83 e8 30             	sub    $0x30,%eax
  80079a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80079d:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a8:	7e 3e                	jle    8007e8 <vprintfmt+0xe9>
  8007aa:	83 fb 39             	cmp    $0x39,%ebx
  8007ad:	7f 39                	jg     8007e8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007af:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b2:	eb d5                	jmp    800789 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c8:	eb 1f                	jmp    8007e9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ce:	79 83                	jns    800753 <vprintfmt+0x54>
				width = 0;
  8007d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d7:	e9 77 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e3:	e9 6b ff ff ff       	jmp    800753 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	0f 89 60 ff ff ff    	jns    800753 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800800:	e9 4e ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800805:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800808:	e9 46 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 c0 04             	add    $0x4,%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	83 e8 04             	sub    $0x4,%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	50                   	push   %eax
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
			break;
  80082d:	e9 89 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	83 c0 04             	add    $0x4,%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	83 e8 04             	sub    $0x4,%eax
  800841:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800843:	85 db                	test   %ebx,%ebx
  800845:	79 02                	jns    800849 <vprintfmt+0x14a>
				err = -err;
  800847:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800849:	83 fb 64             	cmp    $0x64,%ebx
  80084c:	7f 0b                	jg     800859 <vprintfmt+0x15a>
  80084e:	8b 34 9d 60 35 80 00 	mov    0x803560(,%ebx,4),%esi
  800855:	85 f6                	test   %esi,%esi
  800857:	75 19                	jne    800872 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800859:	53                   	push   %ebx
  80085a:	68 05 37 80 00       	push   $0x803705
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	ff 75 08             	pushl  0x8(%ebp)
  800865:	e8 5e 02 00 00       	call   800ac8 <printfmt>
  80086a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086d:	e9 49 02 00 00       	jmp    800abb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800872:	56                   	push   %esi
  800873:	68 0e 37 80 00       	push   $0x80370e
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	e8 45 02 00 00       	call   800ac8 <printfmt>
  800883:	83 c4 10             	add    $0x10,%esp
			break;
  800886:	e9 30 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 c0 04             	add    $0x4,%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 30                	mov    (%eax),%esi
  80089c:	85 f6                	test   %esi,%esi
  80089e:	75 05                	jne    8008a5 <vprintfmt+0x1a6>
				p = "(null)";
  8008a0:	be 11 37 80 00       	mov    $0x803711,%esi
			if (width > 0 && padc != '-')
  8008a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a9:	7e 6d                	jle    800918 <vprintfmt+0x219>
  8008ab:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008af:	74 67                	je     800918 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	50                   	push   %eax
  8008b8:	56                   	push   %esi
  8008b9:	e8 0c 03 00 00       	call   800bca <strnlen>
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c4:	eb 16                	jmp    8008dc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	50                   	push   %eax
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8008dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e0:	7f e4                	jg     8008c6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e2:	eb 34                	jmp    800918 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e8:	74 1c                	je     800906 <vprintfmt+0x207>
  8008ea:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ed:	7e 05                	jle    8008f4 <vprintfmt+0x1f5>
  8008ef:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f2:	7e 12                	jle    800906 <vprintfmt+0x207>
					putch('?', putdat);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	6a 3f                	push   $0x3f
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	ff d0                	call   *%eax
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	eb 0f                	jmp    800915 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	53                   	push   %ebx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800915:	ff 4d e4             	decl   -0x1c(%ebp)
  800918:	89 f0                	mov    %esi,%eax
  80091a:	8d 70 01             	lea    0x1(%eax),%esi
  80091d:	8a 00                	mov    (%eax),%al
  80091f:	0f be d8             	movsbl %al,%ebx
  800922:	85 db                	test   %ebx,%ebx
  800924:	74 24                	je     80094a <vprintfmt+0x24b>
  800926:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092a:	78 b8                	js     8008e4 <vprintfmt+0x1e5>
  80092c:	ff 4d e0             	decl   -0x20(%ebp)
  80092f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800933:	79 af                	jns    8008e4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800935:	eb 13                	jmp    80094a <vprintfmt+0x24b>
				putch(' ', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 20                	push   $0x20
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800947:	ff 4d e4             	decl   -0x1c(%ebp)
  80094a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094e:	7f e7                	jg     800937 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800950:	e9 66 01 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 e8             	pushl  -0x18(%ebp)
  80095b:	8d 45 14             	lea    0x14(%ebp),%eax
  80095e:	50                   	push   %eax
  80095f:	e8 3c fd ff ff       	call   8006a0 <getint>
  800964:	83 c4 10             	add    $0x10,%esp
  800967:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80096d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800970:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800973:	85 d2                	test   %edx,%edx
  800975:	79 23                	jns    80099a <vprintfmt+0x29b>
				putch('-', putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	6a 2d                	push   $0x2d
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	ff d0                	call   *%eax
  800984:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098d:	f7 d8                	neg    %eax
  80098f:	83 d2 00             	adc    $0x0,%edx
  800992:	f7 da                	neg    %edx
  800994:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800997:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80099a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a1:	e9 bc 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8009af:	50                   	push   %eax
  8009b0:	e8 84 fc ff ff       	call   800639 <getuint>
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009be:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c5:	e9 98 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 58                	push   $0x58
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	6a 58                	push   $0x58
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
  8009e7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 58                	push   $0x58
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
			break;
  8009fa:	e9 bc 00 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 30                	push   $0x30
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 78                	push   $0x78
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 c0 04             	add    $0x4,%eax
  800a25:	89 45 14             	mov    %eax,0x14(%ebp)
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	83 e8 04             	sub    $0x4,%eax
  800a2e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a41:	eb 1f                	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 e8             	pushl  -0x18(%ebp)
  800a49:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4c:	50                   	push   %eax
  800a4d:	e8 e7 fb ff ff       	call   800639 <getuint>
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a62:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a69:	83 ec 04             	sub    $0x4,%esp
  800a6c:	52                   	push   %edx
  800a6d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 00 fb ff ff       	call   800582 <printnum>
  800a82:	83 c4 20             	add    $0x20,%esp
			break;
  800a85:	eb 34                	jmp    800abb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	53                   	push   %ebx
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			break;
  800a96:	eb 23                	jmp    800abb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	6a 25                	push   $0x25
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	ff d0                	call   *%eax
  800aa5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa8:	ff 4d 10             	decl   0x10(%ebp)
  800aab:	eb 03                	jmp    800ab0 <vprintfmt+0x3b1>
  800aad:	ff 4d 10             	decl   0x10(%ebp)
  800ab0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab3:	48                   	dec    %eax
  800ab4:	8a 00                	mov    (%eax),%al
  800ab6:	3c 25                	cmp    $0x25,%al
  800ab8:	75 f3                	jne    800aad <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aba:	90                   	nop
		}
	}
  800abb:	e9 47 fc ff ff       	jmp    800707 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ace:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ada:	ff 75 f4             	pushl  -0xc(%ebp)
  800add:	50                   	push   %eax
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	ff 75 08             	pushl  0x8(%ebp)
  800ae4:	e8 16 fc ff ff       	call   8006ff <vprintfmt>
  800ae9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800aec:	90                   	nop
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 40 08             	mov    0x8(%eax),%eax
  800af8:	8d 50 01             	lea    0x1(%eax),%edx
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	8b 10                	mov    (%eax),%edx
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	8b 40 04             	mov    0x4(%eax),%eax
  800b0c:	39 c2                	cmp    %eax,%edx
  800b0e:	73 12                	jae    800b22 <sprintputch+0x33>
		*b->buf++ = ch;
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	8b 00                	mov    (%eax),%eax
  800b15:	8d 48 01             	lea    0x1(%eax),%ecx
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	89 0a                	mov    %ecx,(%edx)
  800b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b20:	88 10                	mov    %dl,(%eax)
}
  800b22:	90                   	nop
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	01 d0                	add    %edx,%eax
  800b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b4a:	74 06                	je     800b52 <vsnprintf+0x2d>
  800b4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b50:	7f 07                	jg     800b59 <vsnprintf+0x34>
		return -E_INVAL;
  800b52:	b8 03 00 00 00       	mov    $0x3,%eax
  800b57:	eb 20                	jmp    800b79 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b59:	ff 75 14             	pushl  0x14(%ebp)
  800b5c:	ff 75 10             	pushl  0x10(%ebp)
  800b5f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b62:	50                   	push   %eax
  800b63:	68 ef 0a 80 00       	push   $0x800aef
  800b68:	e8 92 fb ff ff       	call   8006ff <vprintfmt>
  800b6d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b73:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b79:	c9                   	leave  
  800b7a:	c3                   	ret    

00800b7b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b81:	8d 45 10             	lea    0x10(%ebp),%eax
  800b84:	83 c0 04             	add    $0x4,%eax
  800b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b90:	50                   	push   %eax
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	ff 75 08             	pushl  0x8(%ebp)
  800b97:	e8 89 ff ff ff       	call   800b25 <vsnprintf>
  800b9c:	83 c4 10             	add    $0x10,%esp
  800b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb4:	eb 06                	jmp    800bbc <strlen+0x15>
		n++;
  800bb6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb9:	ff 45 08             	incl   0x8(%ebp)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	84 c0                	test   %al,%al
  800bc3:	75 f1                	jne    800bb6 <strlen+0xf>
		n++;
	return n;
  800bc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd7:	eb 09                	jmp    800be2 <strnlen+0x18>
		n++;
  800bd9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bdc:	ff 45 08             	incl   0x8(%ebp)
  800bdf:	ff 4d 0c             	decl   0xc(%ebp)
  800be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be6:	74 09                	je     800bf1 <strnlen+0x27>
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	84 c0                	test   %al,%al
  800bef:	75 e8                	jne    800bd9 <strnlen+0xf>
		n++;
	return n;
  800bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c02:	90                   	nop
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8d 50 01             	lea    0x1(%eax),%edx
  800c09:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c12:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c15:	8a 12                	mov    (%edx),%dl
  800c17:	88 10                	mov    %dl,(%eax)
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	84 c0                	test   %al,%al
  800c1d:	75 e4                	jne    800c03 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 1f                	jmp    800c58 <strncpy+0x34>
		*dst++ = *src;
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8d 50 01             	lea    0x1(%eax),%edx
  800c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c45:	8a 12                	mov    (%edx),%dl
  800c47:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	84 c0                	test   %al,%al
  800c50:	74 03                	je     800c55 <strncpy+0x31>
			src++;
  800c52:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c55:	ff 45 fc             	incl   -0x4(%ebp)
  800c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c5e:	72 d9                	jb     800c39 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c60:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c75:	74 30                	je     800ca7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c77:	eb 16                	jmp    800c8f <strlcpy+0x2a>
			*dst++ = *src++;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8d 50 01             	lea    0x1(%eax),%edx
  800c7f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c88:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8b:	8a 12                	mov    (%edx),%dl
  800c8d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8f:	ff 4d 10             	decl   0x10(%ebp)
  800c92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c96:	74 09                	je     800ca1 <strlcpy+0x3c>
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	84 c0                	test   %al,%al
  800c9f:	75 d8                	jne    800c79 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cad:	29 c2                	sub    %eax,%edx
  800caf:	89 d0                	mov    %edx,%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb6:	eb 06                	jmp    800cbe <strcmp+0xb>
		p++, q++;
  800cb8:	ff 45 08             	incl   0x8(%ebp)
  800cbb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	84 c0                	test   %al,%al
  800cc5:	74 0e                	je     800cd5 <strcmp+0x22>
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 10                	mov    (%eax),%dl
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	38 c2                	cmp    %al,%dl
  800cd3:	74 e3                	je     800cb8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	0f b6 d0             	movzbl %al,%edx
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	0f b6 c0             	movzbl %al,%eax
  800ce5:	29 c2                	sub    %eax,%edx
  800ce7:	89 d0                	mov    %edx,%eax
}
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cee:	eb 09                	jmp    800cf9 <strncmp+0xe>
		n--, p++, q++;
  800cf0:	ff 4d 10             	decl   0x10(%ebp)
  800cf3:	ff 45 08             	incl   0x8(%ebp)
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfd:	74 17                	je     800d16 <strncmp+0x2b>
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strncmp+0x2b>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 da                	je     800cf0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1a:	75 07                	jne    800d23 <strncmp+0x38>
		return 0;
  800d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d21:	eb 14                	jmp    800d37 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	0f b6 d0             	movzbl %al,%edx
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 c0             	movzbl %al,%eax
  800d33:	29 c2                	sub    %eax,%edx
  800d35:	89 d0                	mov    %edx,%eax
}
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 04             	sub    $0x4,%esp
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d45:	eb 12                	jmp    800d59 <strchr+0x20>
		if (*s == c)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4f:	75 05                	jne    800d56 <strchr+0x1d>
			return (char *) s;
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	eb 11                	jmp    800d67 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d56:	ff 45 08             	incl   0x8(%ebp)
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	84 c0                	test   %al,%al
  800d60:	75 e5                	jne    800d47 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d75:	eb 0d                	jmp    800d84 <strfind+0x1b>
		if (*s == c)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7f:	74 0e                	je     800d8f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d81:	ff 45 08             	incl   0x8(%ebp)
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	84 c0                	test   %al,%al
  800d8b:	75 ea                	jne    800d77 <strfind+0xe>
  800d8d:	eb 01                	jmp    800d90 <strfind+0x27>
		if (*s == c)
			break;
  800d8f:	90                   	nop
	return (char *) s;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da7:	eb 0e                	jmp    800db7 <memset+0x22>
		*p++ = c;
  800da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dac:	8d 50 01             	lea    0x1(%eax),%edx
  800daf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db7:	ff 4d f8             	decl   -0x8(%ebp)
  800dba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dbe:	79 e9                	jns    800da9 <memset+0x14>
		*p++ = c;

	return v;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd7:	eb 16                	jmp    800def <memcpy+0x2a>
		*d++ = *s++;
  800dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800deb:	8a 12                	mov    (%edx),%dl
  800ded:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df5:	89 55 10             	mov    %edx,0x10(%ebp)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	75 dd                	jne    800dd9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dff:	c9                   	leave  
  800e00:	c3                   	ret    

00800e01 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e16:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e19:	73 50                	jae    800e6b <memmove+0x6a>
  800e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e26:	76 43                	jbe    800e6b <memmove+0x6a>
		s += n;
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e34:	eb 10                	jmp    800e46 <memmove+0x45>
			*--d = *--s;
  800e36:	ff 4d f8             	decl   -0x8(%ebp)
  800e39:	ff 4d fc             	decl   -0x4(%ebp)
  800e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3f:	8a 10                	mov    (%eax),%dl
  800e41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e44:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 e3                	jne    800e36 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e53:	eb 23                	jmp    800e78 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e58:	8d 50 01             	lea    0x1(%eax),%edx
  800e5b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e61:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e64:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e67:	8a 12                	mov    (%edx),%dl
  800e69:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e71:	89 55 10             	mov    %edx,0x10(%ebp)
  800e74:	85 c0                	test   %eax,%eax
  800e76:	75 dd                	jne    800e55 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8f:	eb 2a                	jmp    800ebb <memcmp+0x3e>
		if (*s1 != *s2)
  800e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e94:	8a 10                	mov    (%eax),%dl
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	38 c2                	cmp    %al,%dl
  800e9d:	74 16                	je     800eb5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	0f b6 d0             	movzbl %al,%edx
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f b6 c0             	movzbl %al,%eax
  800eaf:	29 c2                	sub    %eax,%edx
  800eb1:	89 d0                	mov    %edx,%eax
  800eb3:	eb 18                	jmp    800ecd <memcmp+0x50>
		s1++, s2++;
  800eb5:	ff 45 fc             	incl   -0x4(%ebp)
  800eb8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	75 c9                	jne    800e91 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  800edb:	01 d0                	add    %edx,%eax
  800edd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee0:	eb 15                	jmp    800ef7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	0f b6 d0             	movzbl %al,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	39 c2                	cmp    %eax,%edx
  800ef2:	74 0d                	je     800f01 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef4:	ff 45 08             	incl   0x8(%ebp)
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800efd:	72 e3                	jb     800ee2 <memfind+0x13>
  800eff:	eb 01                	jmp    800f02 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f01:	90                   	nop
	return (void *) s;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f14:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1b:	eb 03                	jmp    800f20 <strtol+0x19>
		s++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 20                	cmp    $0x20,%al
  800f27:	74 f4                	je     800f1d <strtol+0x16>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 09                	cmp    $0x9,%al
  800f30:	74 eb                	je     800f1d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	3c 2b                	cmp    $0x2b,%al
  800f39:	75 05                	jne    800f40 <strtol+0x39>
		s++;
  800f3b:	ff 45 08             	incl   0x8(%ebp)
  800f3e:	eb 13                	jmp    800f53 <strtol+0x4c>
	else if (*s == '-')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2d                	cmp    $0x2d,%al
  800f47:	75 0a                	jne    800f53 <strtol+0x4c>
		s++, neg = 1;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f57:	74 06                	je     800f5f <strtol+0x58>
  800f59:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5d:	75 20                	jne    800f7f <strtol+0x78>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 30                	cmp    $0x30,%al
  800f66:	75 17                	jne    800f7f <strtol+0x78>
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	40                   	inc    %eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	3c 78                	cmp    $0x78,%al
  800f70:	75 0d                	jne    800f7f <strtol+0x78>
		s += 2, base = 16;
  800f72:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f76:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7d:	eb 28                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f83:	75 15                	jne    800f9a <strtol+0x93>
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 30                	cmp    $0x30,%al
  800f8c:	75 0c                	jne    800f9a <strtol+0x93>
		s++, base = 8;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f98:	eb 0d                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0)
  800f9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9e:	75 07                	jne    800fa7 <strtol+0xa0>
		base = 10;
  800fa0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	3c 2f                	cmp    $0x2f,%al
  800fae:	7e 19                	jle    800fc9 <strtol+0xc2>
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	3c 39                	cmp    $0x39,%al
  800fb7:	7f 10                	jg     800fc9 <strtol+0xc2>
			dig = *s - '0';
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	0f be c0             	movsbl %al,%eax
  800fc1:	83 e8 30             	sub    $0x30,%eax
  800fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc7:	eb 42                	jmp    80100b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 60                	cmp    $0x60,%al
  800fd0:	7e 19                	jle    800feb <strtol+0xe4>
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 7a                	cmp    $0x7a,%al
  800fd9:	7f 10                	jg     800feb <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f be c0             	movsbl %al,%eax
  800fe3:	83 e8 57             	sub    $0x57,%eax
  800fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe9:	eb 20                	jmp    80100b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3c 40                	cmp    $0x40,%al
  800ff2:	7e 39                	jle    80102d <strtol+0x126>
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 5a                	cmp    $0x5a,%al
  800ffb:	7f 30                	jg     80102d <strtol+0x126>
			dig = *s - 'A' + 10;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f be c0             	movsbl %al,%eax
  801005:	83 e8 37             	sub    $0x37,%eax
  801008:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80100b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801011:	7d 19                	jge    80102c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801019:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101d:	89 c2                	mov    %eax,%edx
  80101f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801027:	e9 7b ff ff ff       	jmp    800fa7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80102c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80102d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801031:	74 08                	je     80103b <strtol+0x134>
		*endptr = (char *) s;
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	8b 55 08             	mov    0x8(%ebp),%edx
  801039:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80103b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103f:	74 07                	je     801048 <strtol+0x141>
  801041:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801044:	f7 d8                	neg    %eax
  801046:	eb 03                	jmp    80104b <strtol+0x144>
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <ltostr>:

void
ltostr(long value, char *str)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801053:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80105a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801061:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801065:	79 13                	jns    80107a <ltostr+0x2d>
	{
		neg = 1;
  801067:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801074:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801077:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801082:	99                   	cltd   
  801083:	f7 f9                	idiv   %ecx
  801085:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801088:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108b:	8d 50 01             	lea    0x1(%eax),%edx
  80108e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801091:	89 c2                	mov    %eax,%edx
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	01 d0                	add    %edx,%eax
  801098:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80109b:	83 c2 30             	add    $0x30,%edx
  80109e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a8:	f7 e9                	imul   %ecx
  8010aa:	c1 fa 02             	sar    $0x2,%edx
  8010ad:	89 c8                	mov    %ecx,%eax
  8010af:	c1 f8 1f             	sar    $0x1f,%eax
  8010b2:	29 c2                	sub    %eax,%edx
  8010b4:	89 d0                	mov    %edx,%eax
  8010b6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c1:	f7 e9                	imul   %ecx
  8010c3:	c1 fa 02             	sar    $0x2,%edx
  8010c6:	89 c8                	mov    %ecx,%eax
  8010c8:	c1 f8 1f             	sar    $0x1f,%eax
  8010cb:	29 c2                	sub    %eax,%edx
  8010cd:	89 d0                	mov    %edx,%eax
  8010cf:	c1 e0 02             	shl    $0x2,%eax
  8010d2:	01 d0                	add    %edx,%eax
  8010d4:	01 c0                	add    %eax,%eax
  8010d6:	29 c1                	sub    %eax,%ecx
  8010d8:	89 ca                	mov    %ecx,%edx
  8010da:	85 d2                	test   %edx,%edx
  8010dc:	75 9c                	jne    80107a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	48                   	dec    %eax
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f0:	74 3d                	je     80112f <ltostr+0xe2>
		start = 1 ;
  8010f2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f9:	eb 34                	jmp    80112f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	01 d0                	add    %edx,%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 c2                	add    %eax,%edx
  801110:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80111c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	01 c2                	add    %eax,%edx
  801124:	8a 45 eb             	mov    -0x15(%ebp),%al
  801127:	88 02                	mov    %al,(%edx)
		start++ ;
  801129:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80112c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801132:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801135:	7c c4                	jl     8010fb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801137:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	01 d0                	add    %edx,%eax
  80113f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801142:	90                   	nop
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80114b:	ff 75 08             	pushl  0x8(%ebp)
  80114e:	e8 54 fa ff ff       	call   800ba7 <strlen>
  801153:	83 c4 04             	add    $0x4,%esp
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801159:	ff 75 0c             	pushl  0xc(%ebp)
  80115c:	e8 46 fa ff ff       	call   800ba7 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801175:	eb 17                	jmp    80118e <strcconcat+0x49>
		final[s] = str1[s] ;
  801177:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117a:	8b 45 10             	mov    0x10(%ebp),%eax
  80117d:	01 c2                	add    %eax,%edx
  80117f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	01 c8                	add    %ecx,%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80118b:	ff 45 fc             	incl   -0x4(%ebp)
  80118e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801191:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801194:	7c e1                	jl     801177 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801196:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80119d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a4:	eb 1f                	jmp    8011c5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 c2                	add    %eax,%edx
  8011b6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	01 c8                	add    %ecx,%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c2:	ff 45 f8             	incl   -0x8(%ebp)
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011cb:	7c d9                	jl     8011a6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d8:	90                   	nop
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ea:	8b 00                	mov    (%eax),%eax
  8011ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	01 d0                	add    %edx,%eax
  8011f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fe:	eb 0c                	jmp    80120c <strsplit+0x31>
			*string++ = 0;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8d 50 01             	lea    0x1(%eax),%edx
  801206:	89 55 08             	mov    %edx,0x8(%ebp)
  801209:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	84 c0                	test   %al,%al
  801213:	74 18                	je     80122d <strsplit+0x52>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	50                   	push   %eax
  80121e:	ff 75 0c             	pushl  0xc(%ebp)
  801221:	e8 13 fb ff ff       	call   800d39 <strchr>
  801226:	83 c4 08             	add    $0x8,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	75 d3                	jne    801200 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	84 c0                	test   %al,%al
  801234:	74 5a                	je     801290 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801236:	8b 45 14             	mov    0x14(%ebp),%eax
  801239:	8b 00                	mov    (%eax),%eax
  80123b:	83 f8 0f             	cmp    $0xf,%eax
  80123e:	75 07                	jne    801247 <strsplit+0x6c>
		{
			return 0;
  801240:	b8 00 00 00 00       	mov    $0x0,%eax
  801245:	eb 66                	jmp    8012ad <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 48 01             	lea    0x1(%eax),%ecx
  80124f:	8b 55 14             	mov    0x14(%ebp),%edx
  801252:	89 0a                	mov    %ecx,(%edx)
  801254:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	01 c2                	add    %eax,%edx
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801265:	eb 03                	jmp    80126a <strsplit+0x8f>
			string++;
  801267:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	74 8b                	je     8011fe <strsplit+0x23>
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	0f be c0             	movsbl %al,%eax
  80127b:	50                   	push   %eax
  80127c:	ff 75 0c             	pushl  0xc(%ebp)
  80127f:	e8 b5 fa ff ff       	call   800d39 <strchr>
  801284:	83 c4 08             	add    $0x8,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	74 dc                	je     801267 <strsplit+0x8c>
			string++;
	}
  80128b:	e9 6e ff ff ff       	jmp    8011fe <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801290:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801291:	8b 45 14             	mov    0x14(%ebp),%eax
  801294:	8b 00                	mov    (%eax),%eax
  801296:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	74 1f                	je     8012dd <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012be:	e8 1d 00 00 00       	call   8012e0 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	68 70 38 80 00       	push   $0x803870
  8012cb:	e8 55 f2 ff ff       	call   800525 <cprintf>
  8012d0:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d3:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012da:	00 00 00 
	}
}
  8012dd:	90                   	nop
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8012e6:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012ed:	00 00 00 
  8012f0:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8012f7:	00 00 00 
  8012fa:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801301:	00 00 00 
		LIST_INIT(&AllocMemBlocksList);
  801304:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80130b:	00 00 00 
  80130e:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801315:	00 00 00 
  801318:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80131f:	00 00 00 

		MAX_MEM_BLOCK_CNT = NUM_OF_UHEAP_PAGES ;
  801322:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801329:	00 02 00 
		MemBlockNodes =(struct MemBlock*)USER_DYN_BLKS_ARRAY ;
  80132c:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801336:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80133b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801340:	a3 50 40 80 00       	mov    %eax,0x804050
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY,ROUNDUP(MAX_MEM_BLOCK_CNT * sizeof(struct MemBlock),PAGE_SIZE),PERM_USER|PERM_WRITEABLE);
  801345:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80134c:	a1 20 41 80 00       	mov    0x804120,%eax
  801351:	c1 e0 04             	shl    $0x4,%eax
  801354:	89 c2                	mov    %eax,%edx
  801356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801359:	01 d0                	add    %edx,%eax
  80135b:	48                   	dec    %eax
  80135c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80135f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801362:	ba 00 00 00 00       	mov    $0x0,%edx
  801367:	f7 75 f0             	divl   -0x10(%ebp)
  80136a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80136d:	29 d0                	sub    %edx,%eax
  80136f:	89 c2                	mov    %eax,%edx
  801371:	c7 45 e8 00 00 e0 7f 	movl   $0x7fe00000,-0x18(%ebp)
  801378:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80137b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801380:	2d 00 10 00 00       	sub    $0x1000,%eax
  801385:	83 ec 04             	sub    $0x4,%esp
  801388:	6a 06                	push   $0x6
  80138a:	52                   	push   %edx
  80138b:	50                   	push   %eax
  80138c:	e8 71 05 00 00       	call   801902 <sys_allocate_chunk>
  801391:	83 c4 10             	add    $0x10,%esp
		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801394:	a1 20 41 80 00       	mov    0x804120,%eax
  801399:	83 ec 0c             	sub    $0xc,%esp
  80139c:	50                   	push   %eax
  80139d:	e8 e6 0b 00 00       	call   801f88 <initialize_MemBlocksList>
  8013a2:	83 c4 10             	add    $0x10,%esp

		struct MemBlock  *block_node;
		block_node = AvailableMemBlocksList.lh_first;
  8013a5:	a1 48 41 80 00       	mov    0x804148,%eax
  8013aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		LIST_REMOVE(&(AvailableMemBlocksList),block_node);
  8013ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8013b1:	75 14                	jne    8013c7 <initialize_dyn_block_system+0xe7>
  8013b3:	83 ec 04             	sub    $0x4,%esp
  8013b6:	68 95 38 80 00       	push   $0x803895
  8013bb:	6a 2b                	push   $0x2b
  8013bd:	68 b3 38 80 00       	push   $0x8038b3
  8013c2:	e8 aa ee ff ff       	call   800271 <_panic>
  8013c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ca:	8b 00                	mov    (%eax),%eax
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	74 10                	je     8013e0 <initialize_dyn_block_system+0x100>
  8013d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d3:	8b 00                	mov    (%eax),%eax
  8013d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013d8:	8b 52 04             	mov    0x4(%edx),%edx
  8013db:	89 50 04             	mov    %edx,0x4(%eax)
  8013de:	eb 0b                	jmp    8013eb <initialize_dyn_block_system+0x10b>
  8013e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e3:	8b 40 04             	mov    0x4(%eax),%eax
  8013e6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ee:	8b 40 04             	mov    0x4(%eax),%eax
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	74 0f                	je     801404 <initialize_dyn_block_system+0x124>
  8013f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f8:	8b 40 04             	mov    0x4(%eax),%eax
  8013fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013fe:	8b 12                	mov    (%edx),%edx
  801400:	89 10                	mov    %edx,(%eax)
  801402:	eb 0a                	jmp    80140e <initialize_dyn_block_system+0x12e>
  801404:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801407:	8b 00                	mov    (%eax),%eax
  801409:	a3 48 41 80 00       	mov    %eax,0x804148
  80140e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80141a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801421:	a1 54 41 80 00       	mov    0x804154,%eax
  801426:	48                   	dec    %eax
  801427:	a3 54 41 80 00       	mov    %eax,0x804154
		block_node->sva = USER_HEAP_START ;
  80142c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80142f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
		block_node->size = ((USER_HEAP_MAX - USER_HEAP_START));
  801436:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801439:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)

		insert_sorted_with_merge_freeList(block_node);
  801440:	83 ec 0c             	sub    $0xc,%esp
  801443:	ff 75 e4             	pushl  -0x1c(%ebp)
  801446:	e8 d2 13 00 00       	call   80281d <insert_sorted_with_merge_freeList>
  80144b:	83 c4 10             	add    $0x10,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
}
  80144e:	90                   	nop
  80144f:	c9                   	leave  
  801450:	c3                   	ret    

00801451 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801451:	55                   	push   %ebp
  801452:	89 e5                	mov    %esp,%ebp
  801454:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801457:	e8 53 fe ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  80145c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801460:	75 07                	jne    801469 <malloc+0x18>
  801462:	b8 00 00 00 00       	mov    $0x0,%eax
  801467:	eb 61                	jmp    8014ca <malloc+0x79>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	size= ROUNDUP(size,PAGE_SIZE);
  801469:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801470:	8b 55 08             	mov    0x8(%ebp),%edx
  801473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801476:	01 d0                	add    %edx,%eax
  801478:	48                   	dec    %eax
  801479:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80147c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147f:	ba 00 00 00 00       	mov    $0x0,%edx
  801484:	f7 75 f4             	divl   -0xc(%ebp)
  801487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148a:	29 d0                	sub    %edx,%eax
  80148c:	89 45 08             	mov    %eax,0x8(%ebp)
	    			if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80148f:	e8 3c 08 00 00       	call   801cd0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801494:	85 c0                	test   %eax,%eax
  801496:	74 2d                	je     8014c5 <malloc+0x74>
	    			{
	    				struct MemBlock * ff_block = alloc_block_FF(size);
  801498:	83 ec 0c             	sub    $0xc,%esp
  80149b:	ff 75 08             	pushl  0x8(%ebp)
  80149e:	e8 3e 0f 00 00       	call   8023e1 <alloc_block_FF>
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	    				if(ff_block!=NULL)
  8014a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8014ad:	74 16                	je     8014c5 <malloc+0x74>
	    				{

	    					insert_sorted_allocList(ff_block);
  8014af:	83 ec 0c             	sub    $0xc,%esp
  8014b2:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b5:	e8 48 0c 00 00       	call   802102 <insert_sorted_allocList>
  8014ba:	83 c4 10             	add    $0x10,%esp
	    					return (void*) ff_block->sva ;
  8014bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014c0:	8b 40 08             	mov    0x8(%eax),%eax
  8014c3:	eb 05                	jmp    8014ca <malloc+0x79>

	    				}
	}
	    			return (void*) NULL ;
  8014c5:	b8 00 00 00 00       	mov    $0x0,%eax
	//		to the required allocation size (space should be on 4 KB BOUNDARY)
	//	2) if no suitable space found, return NULL
	// 	3) Return pointer containing the virtual address of allocated space,
	//
	//Use sys_isUHeapPlacementStrategyFIRSTFIT()... to check the current strategy
}
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock *elementForEach;
		virtual_address = ROUNDDOWN(virtual_address, PAGE_SIZE);
  8014d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014e0:	89 45 08             	mov    %eax,0x8(%ebp)
	//	if (is_mallocPages[indexindex((uint32) virtual_address)] == 1) {
		elementForEach = find_block(&AllocMemBlocksList,(uint32)virtual_address);
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	83 ec 08             	sub    $0x8,%esp
  8014e9:	50                   	push   %eax
  8014ea:	68 40 40 80 00       	push   $0x804040
  8014ef:	e8 71 0b 00 00       	call   802065 <find_block>
  8014f4:	83 c4 10             	add    $0x10,%esp
  8014f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		sys_free_user_mem((uint32) virtual_address, elementForEach->size);
  8014fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fd:	8b 50 0c             	mov    0xc(%eax),%edx
  801500:	8b 45 08             	mov    0x8(%ebp),%eax
  801503:	83 ec 08             	sub    $0x8,%esp
  801506:	52                   	push   %edx
  801507:	50                   	push   %eax
  801508:	e8 bd 03 00 00       	call   8018ca <sys_free_user_mem>
  80150d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,elementForEach);
  801510:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801514:	75 14                	jne    80152a <free+0x5e>
  801516:	83 ec 04             	sub    $0x4,%esp
  801519:	68 95 38 80 00       	push   $0x803895
  80151e:	6a 71                	push   $0x71
  801520:	68 b3 38 80 00       	push   $0x8038b3
  801525:	e8 47 ed ff ff       	call   800271 <_panic>
  80152a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152d:	8b 00                	mov    (%eax),%eax
  80152f:	85 c0                	test   %eax,%eax
  801531:	74 10                	je     801543 <free+0x77>
  801533:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801536:	8b 00                	mov    (%eax),%eax
  801538:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80153b:	8b 52 04             	mov    0x4(%edx),%edx
  80153e:	89 50 04             	mov    %edx,0x4(%eax)
  801541:	eb 0b                	jmp    80154e <free+0x82>
  801543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801546:	8b 40 04             	mov    0x4(%eax),%eax
  801549:	a3 44 40 80 00       	mov    %eax,0x804044
  80154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801551:	8b 40 04             	mov    0x4(%eax),%eax
  801554:	85 c0                	test   %eax,%eax
  801556:	74 0f                	je     801567 <free+0x9b>
  801558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155b:	8b 40 04             	mov    0x4(%eax),%eax
  80155e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801561:	8b 12                	mov    (%edx),%edx
  801563:	89 10                	mov    %edx,(%eax)
  801565:	eb 0a                	jmp    801571 <free+0xa5>
  801567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156a:	8b 00                	mov    (%eax),%eax
  80156c:	a3 40 40 80 00       	mov    %eax,0x804040
  801571:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801574:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80157a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801584:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801589:	48                   	dec    %eax
  80158a:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(elementForEach);
  80158f:	83 ec 0c             	sub    $0xc,%esp
  801592:	ff 75 f0             	pushl  -0x10(%ebp)
  801595:	e8 83 12 00 00       	call   80281d <insert_sorted_with_merge_freeList>
  80159a:	83 c4 10             	add    $0x10,%esp
	//you should get the size of the given allocation using its address
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80159d:	90                   	nop
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 28             	sub    $0x28,%esp
  8015a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a9:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ac:	e8 fe fc ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  8015b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b5:	75 0a                	jne    8015c1 <smalloc+0x21>
  8015b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015bc:	e9 86 00 00 00       	jmp    801647 <smalloc+0xa7>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code

	size=ROUNDUP(size,PAGE_SIZE);
  8015c1:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ce:	01 d0                	add    %edx,%eax
  8015d0:	48                   	dec    %eax
  8015d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015dc:	f7 75 f4             	divl   -0xc(%ebp)
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	29 d0                	sub    %edx,%eax
  8015e4:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015e7:	e8 e4 06 00 00       	call   801cd0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	74 52                	je     801642 <smalloc+0xa2>
		{
		struct MemBlock * ff_block ;
		ff_block = alloc_block_FF(size);
  8015f0:	83 ec 0c             	sub    $0xc,%esp
  8015f3:	ff 75 0c             	pushl  0xc(%ebp)
  8015f6:	e8 e6 0d 00 00       	call   8023e1 <alloc_block_FF>
  8015fb:	83 c4 10             	add    $0x10,%esp
  8015fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(ff_block==NULL)
  801601:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801605:	75 07                	jne    80160e <smalloc+0x6e>
			return NULL ;
  801607:	b8 00 00 00 00       	mov    $0x0,%eax
  80160c:	eb 39                	jmp    801647 <smalloc+0xa7>

		int obj_id =sys_createSharedObject(sharedVarName,size,isWritable,(void*)ff_block->sva);
  80160e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801611:	8b 40 08             	mov    0x8(%eax),%eax
  801614:	89 c2                	mov    %eax,%edx
  801616:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80161a:	52                   	push   %edx
  80161b:	50                   	push   %eax
  80161c:	ff 75 0c             	pushl  0xc(%ebp)
  80161f:	ff 75 08             	pushl  0x8(%ebp)
  801622:	e8 2e 04 00 00       	call   801a55 <sys_createSharedObject>
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(obj_id < 0)
  80162d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801631:	79 07                	jns    80163a <smalloc+0x9a>
			return (void*)NULL ;
  801633:	b8 00 00 00 00       	mov    $0x0,%eax
  801638:	eb 0d                	jmp    801647 <smalloc+0xa7>
		else
		    return (void*)ff_block->sva ;
  80163a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163d:	8b 40 08             	mov    0x8(%eax),%eax
  801640:	eb 05                	jmp    801647 <smalloc+0xa7>
		}
		return (void*)NULL ;
  801642:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space of the required range
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80164f:	e8 5b fc ff ff       	call   8012af <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801654:	83 ec 08             	sub    $0x8,%esp
  801657:	ff 75 0c             	pushl  0xc(%ebp)
  80165a:	ff 75 08             	pushl  0x8(%ebp)
  80165d:	e8 1d 04 00 00       	call   801a7f <sys_getSizeOfSharedObject>
  801662:	83 c4 10             	add    $0x10,%esp
  801665:	89 45 f4             	mov    %eax,-0xc(%ebp)

		if(size == 0)
  801668:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80166c:	75 0a                	jne    801678 <sget+0x2f>
			return NULL ;
  80166e:	b8 00 00 00 00       	mov    $0x0,%eax
  801673:	e9 83 00 00 00       	jmp    8016fb <sget+0xb2>
		size=ROUNDUP(size,PAGE_SIZE);
  801678:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80167f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801682:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801685:	01 d0                	add    %edx,%eax
  801687:	48                   	dec    %eax
  801688:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80168b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168e:	ba 00 00 00 00       	mov    $0x0,%edx
  801693:	f7 75 f0             	divl   -0x10(%ebp)
  801696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801699:	29 d0                	sub    %edx,%eax
  80169b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80169e:	e8 2d 06 00 00       	call   801cd0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	74 4f                	je     8016f6 <sget+0xad>
		{
			struct MemBlock * ff_block ;
				ff_block = alloc_block_FF(size);
  8016a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016aa:	83 ec 0c             	sub    $0xc,%esp
  8016ad:	50                   	push   %eax
  8016ae:	e8 2e 0d 00 00       	call   8023e1 <alloc_block_FF>
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
				if(ff_block==NULL)
  8016b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8016bd:	75 07                	jne    8016c6 <sget+0x7d>
					return (void*)NULL ;
  8016bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c4:	eb 35                	jmp    8016fb <sget+0xb2>

		int obj_id =sys_getSharedObject((int)ownerEnvID,sharedVarName,(void*)ff_block->sva);
  8016c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016c9:	8b 40 08             	mov    0x8(%eax),%eax
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	50                   	push   %eax
  8016d0:	ff 75 0c             	pushl  0xc(%ebp)
  8016d3:	ff 75 08             	pushl  0x8(%ebp)
  8016d6:	e8 c1 03 00 00       	call   801a9c <sys_getSharedObject>
  8016db:	83 c4 10             	add    $0x10,%esp
  8016de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if(obj_id<0)
  8016e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016e5:	79 07                	jns    8016ee <sget+0xa5>
				return (void*)NULL ;
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ec:	eb 0d                	jmp    8016fb <sget+0xb2>
			else
				return (void*)ff_block->sva ;
  8016ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f1:	8b 40 08             	mov    0x8(%eax),%eax
  8016f4:	eb 05                	jmp    8016fb <sget+0xb2>


		}
	return (void*)NULL ;
  8016f6:	b8 00 00 00 00       	mov    $0x0,%eax

	//This function should find the space for sharing the variable
	// ******** ON 4KB BOUNDARY ******************* //

	//Use sys_isUHeapPlacementStrategyFIRSTFIT() to check the current strategy
}
  8016fb:	c9                   	leave  
  8016fc:	c3                   	ret    

008016fd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8016fd:	55                   	push   %ebp
  8016fe:	89 e5                	mov    %esp,%ebp
  801700:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801703:	e8 a7 fb ff ff       	call   8012af <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	68 c0 38 80 00       	push   $0x8038c0
  801710:	68 f9 00 00 00       	push   $0xf9
  801715:	68 b3 38 80 00       	push   $0x8038b3
  80171a:	e8 52 eb ff ff       	call   800271 <_panic>

0080171f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801725:	83 ec 04             	sub    $0x4,%esp
  801728:	68 e8 38 80 00       	push   $0x8038e8
  80172d:	68 0d 01 00 00       	push   $0x10d
  801732:	68 b3 38 80 00       	push   $0x8038b3
  801737:	e8 35 eb ff ff       	call   800271 <_panic>

0080173c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801742:	83 ec 04             	sub    $0x4,%esp
  801745:	68 0c 39 80 00       	push   $0x80390c
  80174a:	68 18 01 00 00       	push   $0x118
  80174f:	68 b3 38 80 00       	push   $0x8038b3
  801754:	e8 18 eb ff ff       	call   800271 <_panic>

00801759 <shrink>:

}
void shrink(uint32 newSize)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80175f:	83 ec 04             	sub    $0x4,%esp
  801762:	68 0c 39 80 00       	push   $0x80390c
  801767:	68 1d 01 00 00       	push   $0x11d
  80176c:	68 b3 38 80 00       	push   $0x8038b3
  801771:	e8 fb ea ff ff       	call   800271 <_panic>

00801776 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80177c:	83 ec 04             	sub    $0x4,%esp
  80177f:	68 0c 39 80 00       	push   $0x80390c
  801784:	68 22 01 00 00       	push   $0x122
  801789:	68 b3 38 80 00       	push   $0x8038b3
  80178e:	e8 de ea ff ff       	call   800271 <_panic>

00801793 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	57                   	push   %edi
  801797:	56                   	push   %esi
  801798:	53                   	push   %ebx
  801799:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80179c:	8b 45 08             	mov    0x8(%ebp),%eax
  80179f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017a8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017ab:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017ae:	cd 30                	int    $0x30
  8017b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	5b                   	pop    %ebx
  8017ba:	5e                   	pop    %esi
  8017bb:	5f                   	pop    %edi
  8017bc:	5d                   	pop    %ebp
  8017bd:	c3                   	ret    

008017be <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 04             	sub    $0x4,%esp
  8017c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017ca:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	6a 00                	push   $0x0
  8017d3:	6a 00                	push   $0x0
  8017d5:	52                   	push   %edx
  8017d6:	ff 75 0c             	pushl  0xc(%ebp)
  8017d9:	50                   	push   %eax
  8017da:	6a 00                	push   $0x0
  8017dc:	e8 b2 ff ff ff       	call   801793 <syscall>
  8017e1:	83 c4 18             	add    $0x18,%esp
}
  8017e4:	90                   	nop
  8017e5:	c9                   	leave  
  8017e6:	c3                   	ret    

008017e7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8017ea:	6a 00                	push   $0x0
  8017ec:	6a 00                	push   $0x0
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 01                	push   $0x1
  8017f6:	e8 98 ff ff ff       	call   801793 <syscall>
  8017fb:	83 c4 18             	add    $0x18,%esp
}
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801803:	8b 55 0c             	mov    0xc(%ebp),%edx
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	52                   	push   %edx
  801810:	50                   	push   %eax
  801811:	6a 05                	push   $0x5
  801813:	e8 7b ff ff ff       	call   801793 <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	56                   	push   %esi
  801821:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801822:	8b 75 18             	mov    0x18(%ebp),%esi
  801825:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801828:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	56                   	push   %esi
  801832:	53                   	push   %ebx
  801833:	51                   	push   %ecx
  801834:	52                   	push   %edx
  801835:	50                   	push   %eax
  801836:	6a 06                	push   $0x6
  801838:	e8 56 ff ff ff       	call   801793 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801843:	5b                   	pop    %ebx
  801844:	5e                   	pop    %esi
  801845:	5d                   	pop    %ebp
  801846:	c3                   	ret    

00801847 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80184a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	6a 00                	push   $0x0
  801856:	52                   	push   %edx
  801857:	50                   	push   %eax
  801858:	6a 07                	push   $0x7
  80185a:	e8 34 ff ff ff       	call   801793 <syscall>
  80185f:	83 c4 18             	add    $0x18,%esp
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801867:	6a 00                	push   $0x0
  801869:	6a 00                	push   $0x0
  80186b:	6a 00                	push   $0x0
  80186d:	ff 75 0c             	pushl  0xc(%ebp)
  801870:	ff 75 08             	pushl  0x8(%ebp)
  801873:	6a 08                	push   $0x8
  801875:	e8 19 ff ff ff       	call   801793 <syscall>
  80187a:	83 c4 18             	add    $0x18,%esp
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801882:	6a 00                	push   $0x0
  801884:	6a 00                	push   $0x0
  801886:	6a 00                	push   $0x0
  801888:	6a 00                	push   $0x0
  80188a:	6a 00                	push   $0x0
  80188c:	6a 09                	push   $0x9
  80188e:	e8 00 ff ff ff       	call   801793 <syscall>
  801893:	83 c4 18             	add    $0x18,%esp
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    

00801898 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801898:	55                   	push   %ebp
  801899:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 0a                	push   $0xa
  8018a7:	e8 e7 fe ff ff       	call   801793 <syscall>
  8018ac:	83 c4 18             	add    $0x18,%esp
}
  8018af:	c9                   	leave  
  8018b0:	c3                   	ret    

008018b1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018b1:	55                   	push   %ebp
  8018b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 0b                	push   $0xb
  8018c0:	e8 ce fe ff ff       	call   801793 <syscall>
  8018c5:	83 c4 18             	add    $0x18,%esp
}
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	ff 75 0c             	pushl  0xc(%ebp)
  8018d6:	ff 75 08             	pushl  0x8(%ebp)
  8018d9:	6a 0f                	push   $0xf
  8018db:	e8 b3 fe ff ff       	call   801793 <syscall>
  8018e0:	83 c4 18             	add    $0x18,%esp
	return;
  8018e3:	90                   	nop
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	ff 75 0c             	pushl  0xc(%ebp)
  8018f2:	ff 75 08             	pushl  0x8(%ebp)
  8018f5:	6a 10                	push   $0x10
  8018f7:	e8 97 fe ff ff       	call   801793 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ff:	90                   	nop
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	ff 75 10             	pushl  0x10(%ebp)
  80190c:	ff 75 0c             	pushl  0xc(%ebp)
  80190f:	ff 75 08             	pushl  0x8(%ebp)
  801912:	6a 11                	push   $0x11
  801914:	e8 7a fe ff ff       	call   801793 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
	return ;
  80191c:	90                   	nop
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 0c                	push   $0xc
  80192e:	e8 60 fe ff ff       	call   801793 <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	ff 75 08             	pushl  0x8(%ebp)
  801946:	6a 0d                	push   $0xd
  801948:	e8 46 fe ff ff       	call   801793 <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 0e                	push   $0xe
  801961:	e8 2d fe ff ff       	call   801793 <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	90                   	nop
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 13                	push   $0x13
  80197b:	e8 13 fe ff ff       	call   801793 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	90                   	nop
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 14                	push   $0x14
  801995:	e8 f9 fd ff ff       	call   801793 <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
}
  80199d:	90                   	nop
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
  8019a3:	83 ec 04             	sub    $0x4,%esp
  8019a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019ac:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	50                   	push   %eax
  8019b9:	6a 15                	push   $0x15
  8019bb:	e8 d3 fd ff ff       	call   801793 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	90                   	nop
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 16                	push   $0x16
  8019d5:	e8 b9 fd ff ff       	call   801793 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
}
  8019dd:	90                   	nop
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	ff 75 0c             	pushl  0xc(%ebp)
  8019ef:	50                   	push   %eax
  8019f0:	6a 17                	push   $0x17
  8019f2:	e8 9c fd ff ff       	call   801793 <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	52                   	push   %edx
  801a0c:	50                   	push   %eax
  801a0d:	6a 1a                	push   $0x1a
  801a0f:	e8 7f fd ff ff       	call   801793 <syscall>
  801a14:	83 c4 18             	add    $0x18,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	52                   	push   %edx
  801a29:	50                   	push   %eax
  801a2a:	6a 18                	push   $0x18
  801a2c:	e8 62 fd ff ff       	call   801793 <syscall>
  801a31:	83 c4 18             	add    $0x18,%esp
}
  801a34:	90                   	nop
  801a35:	c9                   	leave  
  801a36:	c3                   	ret    

00801a37 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	52                   	push   %edx
  801a47:	50                   	push   %eax
  801a48:	6a 19                	push   $0x19
  801a4a:	e8 44 fd ff ff       	call   801793 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	90                   	nop
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	83 ec 04             	sub    $0x4,%esp
  801a5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a61:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a64:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	51                   	push   %ecx
  801a6e:	52                   	push   %edx
  801a6f:	ff 75 0c             	pushl  0xc(%ebp)
  801a72:	50                   	push   %eax
  801a73:	6a 1b                	push   $0x1b
  801a75:	e8 19 fd ff ff       	call   801793 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	52                   	push   %edx
  801a8f:	50                   	push   %eax
  801a90:	6a 1c                	push   $0x1c
  801a92:	e8 fc fc ff ff       	call   801793 <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	51                   	push   %ecx
  801aad:	52                   	push   %edx
  801aae:	50                   	push   %eax
  801aaf:	6a 1d                	push   $0x1d
  801ab1:	e8 dd fc ff ff       	call   801793 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801abe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	52                   	push   %edx
  801acb:	50                   	push   %eax
  801acc:	6a 1e                	push   $0x1e
  801ace:	e8 c0 fc ff ff       	call   801793 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	c9                   	leave  
  801ad7:	c3                   	ret    

00801ad8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ad8:	55                   	push   %ebp
  801ad9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 1f                	push   $0x1f
  801ae7:	e8 a7 fc ff ff       	call   801793 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	6a 00                	push   $0x0
  801af9:	ff 75 14             	pushl  0x14(%ebp)
  801afc:	ff 75 10             	pushl  0x10(%ebp)
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	50                   	push   %eax
  801b03:	6a 20                	push   $0x20
  801b05:	e8 89 fc ff ff       	call   801793 <syscall>
  801b0a:	83 c4 18             	add    $0x18,%esp
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	50                   	push   %eax
  801b1e:	6a 21                	push   $0x21
  801b20:	e8 6e fc ff ff       	call   801793 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	90                   	nop
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	50                   	push   %eax
  801b3a:	6a 22                	push   $0x22
  801b3c:	e8 52 fc ff ff       	call   801793 <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 02                	push   $0x2
  801b55:	e8 39 fc ff ff       	call   801793 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 03                	push   $0x3
  801b6e:	e8 20 fc ff ff       	call   801793 <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 04                	push   $0x4
  801b87:	e8 07 fc ff ff       	call   801793 <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sys_exit_env>:


void sys_exit_env(void)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 23                	push   $0x23
  801ba0:	e8 ee fb ff ff       	call   801793 <syscall>
  801ba5:	83 c4 18             	add    $0x18,%esp
}
  801ba8:	90                   	nop
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
  801bae:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bb1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bb4:	8d 50 04             	lea    0x4(%eax),%edx
  801bb7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	52                   	push   %edx
  801bc1:	50                   	push   %eax
  801bc2:	6a 24                	push   $0x24
  801bc4:	e8 ca fb ff ff       	call   801793 <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
	return result;
  801bcc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bd2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bd5:	89 01                	mov    %eax,(%ecx)
  801bd7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	c9                   	leave  
  801bde:	c2 04 00             	ret    $0x4

00801be1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	ff 75 10             	pushl  0x10(%ebp)
  801beb:	ff 75 0c             	pushl  0xc(%ebp)
  801bee:	ff 75 08             	pushl  0x8(%ebp)
  801bf1:	6a 12                	push   $0x12
  801bf3:	e8 9b fb ff ff       	call   801793 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfb:	90                   	nop
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_rcr2>:
uint32 sys_rcr2()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 25                	push   $0x25
  801c0d:	e8 81 fb ff ff       	call   801793 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 04             	sub    $0x4,%esp
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c23:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	6a 00                	push   $0x0
  801c2f:	50                   	push   %eax
  801c30:	6a 26                	push   $0x26
  801c32:	e8 5c fb ff ff       	call   801793 <syscall>
  801c37:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3a:	90                   	nop
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <rsttst>:
void rsttst()
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 28                	push   $0x28
  801c4c:	e8 42 fb ff ff       	call   801793 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
	return ;
  801c54:	90                   	nop
}
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c63:	8b 55 18             	mov    0x18(%ebp),%edx
  801c66:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c6a:	52                   	push   %edx
  801c6b:	50                   	push   %eax
  801c6c:	ff 75 10             	pushl  0x10(%ebp)
  801c6f:	ff 75 0c             	pushl  0xc(%ebp)
  801c72:	ff 75 08             	pushl  0x8(%ebp)
  801c75:	6a 27                	push   $0x27
  801c77:	e8 17 fb ff ff       	call   801793 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7f:	90                   	nop
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <chktst>:
void chktst(uint32 n)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	ff 75 08             	pushl  0x8(%ebp)
  801c90:	6a 29                	push   $0x29
  801c92:	e8 fc fa ff ff       	call   801793 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9a:	90                   	nop
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <inctst>:

void inctst()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 2a                	push   $0x2a
  801cac:	e8 e2 fa ff ff       	call   801793 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb4:	90                   	nop
}
  801cb5:	c9                   	leave  
  801cb6:	c3                   	ret    

00801cb7 <gettst>:
uint32 gettst()
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 2b                	push   $0x2b
  801cc6:	e8 c8 fa ff ff       	call   801793 <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
}
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 2c                	push   $0x2c
  801ce2:	e8 ac fa ff ff       	call   801793 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
  801cea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ced:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801cf1:	75 07                	jne    801cfa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801cf3:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf8:	eb 05                	jmp    801cff <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801cfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cff:	c9                   	leave  
  801d00:	c3                   	ret    

00801d01 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
  801d04:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 2c                	push   $0x2c
  801d13:	e8 7b fa ff ff       	call   801793 <syscall>
  801d18:	83 c4 18             	add    $0x18,%esp
  801d1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d1e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d22:	75 07                	jne    801d2b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d24:	b8 01 00 00 00       	mov    $0x1,%eax
  801d29:	eb 05                	jmp    801d30 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 2c                	push   $0x2c
  801d44:	e8 4a fa ff ff       	call   801793 <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
  801d4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d4f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d53:	75 07                	jne    801d5c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d55:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5a:	eb 05                	jmp    801d61 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d61:	c9                   	leave  
  801d62:	c3                   	ret    

00801d63 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d63:	55                   	push   %ebp
  801d64:	89 e5                	mov    %esp,%ebp
  801d66:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 2c                	push   $0x2c
  801d75:	e8 19 fa ff ff       	call   801793 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
  801d7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d80:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d84:	75 07                	jne    801d8d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d86:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8b:	eb 05                	jmp    801d92 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	ff 75 08             	pushl  0x8(%ebp)
  801da2:	6a 2d                	push   $0x2d
  801da4:	e8 ea f9 ff ff       	call   801793 <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dac:	90                   	nop
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801db3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	6a 00                	push   $0x0
  801dc1:	53                   	push   %ebx
  801dc2:	51                   	push   %ecx
  801dc3:	52                   	push   %edx
  801dc4:	50                   	push   %eax
  801dc5:	6a 2e                	push   $0x2e
  801dc7:	e8 c7 f9 ff ff       	call   801793 <syscall>
  801dcc:	83 c4 18             	add    $0x18,%esp
}
  801dcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801dd7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	52                   	push   %edx
  801de4:	50                   	push   %eax
  801de5:	6a 2f                	push   $0x2f
  801de7:	e8 a7 f9 ff ff       	call   801793 <syscall>
  801dec:	83 c4 18             	add    $0x18,%esp
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801df7:	83 ec 0c             	sub    $0xc,%esp
  801dfa:	68 1c 39 80 00       	push   $0x80391c
  801dff:	e8 21 e7 ff ff       	call   800525 <cprintf>
  801e04:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e07:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e0e:	83 ec 0c             	sub    $0xc,%esp
  801e11:	68 48 39 80 00       	push   $0x803948
  801e16:	e8 0a e7 ff ff       	call   800525 <cprintf>
  801e1b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e1e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e22:	a1 38 41 80 00       	mov    0x804138,%eax
  801e27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e2a:	eb 56                	jmp    801e82 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e30:	74 1c                	je     801e4e <print_mem_block_lists+0x5d>
  801e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e35:	8b 50 08             	mov    0x8(%eax),%edx
  801e38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3b:	8b 48 08             	mov    0x8(%eax),%ecx
  801e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e41:	8b 40 0c             	mov    0xc(%eax),%eax
  801e44:	01 c8                	add    %ecx,%eax
  801e46:	39 c2                	cmp    %eax,%edx
  801e48:	73 04                	jae    801e4e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e4a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e51:	8b 50 08             	mov    0x8(%eax),%edx
  801e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e57:	8b 40 0c             	mov    0xc(%eax),%eax
  801e5a:	01 c2                	add    %eax,%edx
  801e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e5f:	8b 40 08             	mov    0x8(%eax),%eax
  801e62:	83 ec 04             	sub    $0x4,%esp
  801e65:	52                   	push   %edx
  801e66:	50                   	push   %eax
  801e67:	68 5d 39 80 00       	push   $0x80395d
  801e6c:	e8 b4 e6 ff ff       	call   800525 <cprintf>
  801e71:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e7a:	a1 40 41 80 00       	mov    0x804140,%eax
  801e7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e86:	74 07                	je     801e8f <print_mem_block_lists+0x9e>
  801e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8b:	8b 00                	mov    (%eax),%eax
  801e8d:	eb 05                	jmp    801e94 <print_mem_block_lists+0xa3>
  801e8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e94:	a3 40 41 80 00       	mov    %eax,0x804140
  801e99:	a1 40 41 80 00       	mov    0x804140,%eax
  801e9e:	85 c0                	test   %eax,%eax
  801ea0:	75 8a                	jne    801e2c <print_mem_block_lists+0x3b>
  801ea2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ea6:	75 84                	jne    801e2c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ea8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eac:	75 10                	jne    801ebe <print_mem_block_lists+0xcd>
  801eae:	83 ec 0c             	sub    $0xc,%esp
  801eb1:	68 6c 39 80 00       	push   $0x80396c
  801eb6:	e8 6a e6 ff ff       	call   800525 <cprintf>
  801ebb:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ebe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	68 90 39 80 00       	push   $0x803990
  801ecd:	e8 53 e6 ff ff       	call   800525 <cprintf>
  801ed2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ed5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ed9:	a1 40 40 80 00       	mov    0x804040,%eax
  801ede:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee1:	eb 56                	jmp    801f39 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ee3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ee7:	74 1c                	je     801f05 <print_mem_block_lists+0x114>
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	8b 50 08             	mov    0x8(%eax),%edx
  801eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef2:	8b 48 08             	mov    0x8(%eax),%ecx
  801ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef8:	8b 40 0c             	mov    0xc(%eax),%eax
  801efb:	01 c8                	add    %ecx,%eax
  801efd:	39 c2                	cmp    %eax,%edx
  801eff:	73 04                	jae    801f05 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f01:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	8b 50 08             	mov    0x8(%eax),%edx
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f11:	01 c2                	add    %eax,%edx
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	8b 40 08             	mov    0x8(%eax),%eax
  801f19:	83 ec 04             	sub    $0x4,%esp
  801f1c:	52                   	push   %edx
  801f1d:	50                   	push   %eax
  801f1e:	68 5d 39 80 00       	push   $0x80395d
  801f23:	e8 fd e5 ff ff       	call   800525 <cprintf>
  801f28:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f31:	a1 48 40 80 00       	mov    0x804048,%eax
  801f36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f3d:	74 07                	je     801f46 <print_mem_block_lists+0x155>
  801f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f42:	8b 00                	mov    (%eax),%eax
  801f44:	eb 05                	jmp    801f4b <print_mem_block_lists+0x15a>
  801f46:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4b:	a3 48 40 80 00       	mov    %eax,0x804048
  801f50:	a1 48 40 80 00       	mov    0x804048,%eax
  801f55:	85 c0                	test   %eax,%eax
  801f57:	75 8a                	jne    801ee3 <print_mem_block_lists+0xf2>
  801f59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f5d:	75 84                	jne    801ee3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f5f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f63:	75 10                	jne    801f75 <print_mem_block_lists+0x184>
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	68 a8 39 80 00       	push   $0x8039a8
  801f6d:	e8 b3 e5 ff ff       	call   800525 <cprintf>
  801f72:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f75:	83 ec 0c             	sub    $0xc,%esp
  801f78:	68 1c 39 80 00       	push   $0x80391c
  801f7d:	e8 a3 e5 ff ff       	call   800525 <cprintf>
  801f82:	83 c4 10             	add    $0x10,%esp

}
  801f85:	90                   	nop
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801f8e:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801f95:	00 00 00 
  801f98:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801f9f:	00 00 00 
  801fa2:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801fa9:	00 00 00 
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  801fac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fb3:	e9 9e 00 00 00       	jmp    802056 <initialize_MemBlocksList+0xce>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
  801fb8:	a1 50 40 80 00       	mov    0x804050,%eax
  801fbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fc0:	c1 e2 04             	shl    $0x4,%edx
  801fc3:	01 d0                	add    %edx,%eax
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	75 14                	jne    801fdd <initialize_MemBlocksList+0x55>
  801fc9:	83 ec 04             	sub    $0x4,%esp
  801fcc:	68 d0 39 80 00       	push   $0x8039d0
  801fd1:	6a 43                	push   $0x43
  801fd3:	68 f3 39 80 00       	push   $0x8039f3
  801fd8:	e8 94 e2 ff ff       	call   800271 <_panic>
  801fdd:	a1 50 40 80 00       	mov    0x804050,%eax
  801fe2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe5:	c1 e2 04             	shl    $0x4,%edx
  801fe8:	01 d0                	add    %edx,%eax
  801fea:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801ff0:	89 10                	mov    %edx,(%eax)
  801ff2:	8b 00                	mov    (%eax),%eax
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	74 18                	je     802010 <initialize_MemBlocksList+0x88>
  801ff8:	a1 48 41 80 00       	mov    0x804148,%eax
  801ffd:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802003:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802006:	c1 e1 04             	shl    $0x4,%ecx
  802009:	01 ca                	add    %ecx,%edx
  80200b:	89 50 04             	mov    %edx,0x4(%eax)
  80200e:	eb 12                	jmp    802022 <initialize_MemBlocksList+0x9a>
  802010:	a1 50 40 80 00       	mov    0x804050,%eax
  802015:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802018:	c1 e2 04             	shl    $0x4,%edx
  80201b:	01 d0                	add    %edx,%eax
  80201d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802022:	a1 50 40 80 00       	mov    0x804050,%eax
  802027:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202a:	c1 e2 04             	shl    $0x4,%edx
  80202d:	01 d0                	add    %edx,%eax
  80202f:	a3 48 41 80 00       	mov    %eax,0x804148
  802034:	a1 50 40 80 00       	mov    0x804050,%eax
  802039:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80203c:	c1 e2 04             	shl    $0x4,%edx
  80203f:	01 d0                	add    %edx,%eax
  802041:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802048:	a1 54 41 80 00       	mov    0x804154,%eax
  80204d:	40                   	inc    %eax
  80204e:	a3 54 41 80 00       	mov    %eax,0x804154
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
		int i ;
		for(i= 0 ; i<numOfBlocks ; i++)
  802053:	ff 45 f4             	incl   -0xc(%ebp)
  802056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802059:	3b 45 08             	cmp    0x8(%ebp),%eax
  80205c:	0f 82 56 ff ff ff    	jb     801fb8 <initialize_MemBlocksList+0x30>
		{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&(MemBlockNodes[i]));
		}
}
  802062:	90                   	nop
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  80206b:	a1 38 41 80 00       	mov    0x804138,%eax
  802070:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802073:	eb 18                	jmp    80208d <find_block+0x28>
	{
		if (ele->sva==va)
  802075:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802078:	8b 40 08             	mov    0x8(%eax),%eax
  80207b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80207e:	75 05                	jne    802085 <find_block+0x20>
			return ele;
  802080:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802083:	eb 7b                	jmp    802100 <find_block+0x9b>
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *ele;


	LIST_FOREACH(ele, &(FreeMemBlocksList))
  802085:	a1 40 41 80 00       	mov    0x804140,%eax
  80208a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80208d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802091:	74 07                	je     80209a <find_block+0x35>
  802093:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802096:	8b 00                	mov    (%eax),%eax
  802098:	eb 05                	jmp    80209f <find_block+0x3a>
  80209a:	b8 00 00 00 00       	mov    $0x0,%eax
  80209f:	a3 40 41 80 00       	mov    %eax,0x804140
  8020a4:	a1 40 41 80 00       	mov    0x804140,%eax
  8020a9:	85 c0                	test   %eax,%eax
  8020ab:	75 c8                	jne    802075 <find_block+0x10>
  8020ad:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020b1:	75 c2                	jne    802075 <find_block+0x10>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020b3:	a1 40 40 80 00       	mov    0x804040,%eax
  8020b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020bb:	eb 18                	jmp    8020d5 <find_block+0x70>
	{
		if (ele->sva==va)
  8020bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c0:	8b 40 08             	mov    0x8(%eax),%eax
  8020c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020c6:	75 05                	jne    8020cd <find_block+0x68>
					return ele;
  8020c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020cb:	eb 33                	jmp    802100 <find_block+0x9b>
	{
		if (ele->sva==va)
			return ele;

		}
	LIST_FOREACH(ele, &(AllocMemBlocksList))
  8020cd:	a1 48 40 80 00       	mov    0x804048,%eax
  8020d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020d9:	74 07                	je     8020e2 <find_block+0x7d>
  8020db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020de:	8b 00                	mov    (%eax),%eax
  8020e0:	eb 05                	jmp    8020e7 <find_block+0x82>
  8020e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e7:	a3 48 40 80 00       	mov    %eax,0x804048
  8020ec:	a1 48 40 80 00       	mov    0x804048,%eax
  8020f1:	85 c0                	test   %eax,%eax
  8020f3:	75 c8                	jne    8020bd <find_block+0x58>
  8020f5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f9:	75 c2                	jne    8020bd <find_block+0x58>
	{
		if (ele->sva==va)
					return ele;
	}
return NULL;
  8020fb:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802100:	c9                   	leave  
  802101:	c3                   	ret    

00802102 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802102:	55                   	push   %ebp
  802103:	89 e5                	mov    %esp,%ebp
  802105:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;

int x =LIST_SIZE(&AllocMemBlocksList);
  802108:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80210d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	if((x==0))
  802110:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802114:	75 62                	jne    802178 <insert_sorted_allocList+0x76>
	{
	//	blockToInsert=AllocMemBlocksList.lh_first;
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  802116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80211a:	75 14                	jne    802130 <insert_sorted_allocList+0x2e>
  80211c:	83 ec 04             	sub    $0x4,%esp
  80211f:	68 d0 39 80 00       	push   $0x8039d0
  802124:	6a 69                	push   $0x69
  802126:	68 f3 39 80 00       	push   $0x8039f3
  80212b:	e8 41 e1 ff ff       	call   800271 <_panic>
  802130:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802136:	8b 45 08             	mov    0x8(%ebp),%eax
  802139:	89 10                	mov    %edx,(%eax)
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	8b 00                	mov    (%eax),%eax
  802140:	85 c0                	test   %eax,%eax
  802142:	74 0d                	je     802151 <insert_sorted_allocList+0x4f>
  802144:	a1 40 40 80 00       	mov    0x804040,%eax
  802149:	8b 55 08             	mov    0x8(%ebp),%edx
  80214c:	89 50 04             	mov    %edx,0x4(%eax)
  80214f:	eb 08                	jmp    802159 <insert_sorted_allocList+0x57>
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	a3 44 40 80 00       	mov    %eax,0x804044
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	a3 40 40 80 00       	mov    %eax,0x804040
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80216b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802170:	40                   	inc    %eax
  802171:	a3 4c 40 80 00       	mov    %eax,0x80404c
  802176:	eb 72                	jmp    8021ea <insert_sorted_allocList+0xe8>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
  802178:	a1 40 40 80 00       	mov    0x804040,%eax
  80217d:	8b 50 08             	mov    0x8(%eax),%edx
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	8b 40 08             	mov    0x8(%eax),%eax
  802186:	39 c2                	cmp    %eax,%edx
  802188:	76 60                	jbe    8021ea <insert_sorted_allocList+0xe8>
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
  80218a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80218e:	75 14                	jne    8021a4 <insert_sorted_allocList+0xa2>
  802190:	83 ec 04             	sub    $0x4,%esp
  802193:	68 d0 39 80 00       	push   $0x8039d0
  802198:	6a 6d                	push   $0x6d
  80219a:	68 f3 39 80 00       	push   $0x8039f3
  80219f:	e8 cd e0 ff ff       	call   800271 <_panic>
  8021a4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	89 10                	mov    %edx,(%eax)
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	8b 00                	mov    (%eax),%eax
  8021b4:	85 c0                	test   %eax,%eax
  8021b6:	74 0d                	je     8021c5 <insert_sorted_allocList+0xc3>
  8021b8:	a1 40 40 80 00       	mov    0x804040,%eax
  8021bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c0:	89 50 04             	mov    %edx,0x4(%eax)
  8021c3:	eb 08                	jmp    8021cd <insert_sorted_allocList+0xcb>
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	a3 44 40 80 00       	mov    %eax,0x804044
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	a3 40 40 80 00       	mov    %eax,0x804040
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021df:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021e4:	40                   	inc    %eax
  8021e5:	a3 4c 40 80 00       	mov    %eax,0x80404c
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8021ea:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021f2:	e9 b9 01 00 00       	jmp    8023b0 <insert_sorted_allocList+0x2ae>
	{


		if ((blockToInsert->sva>AllocMemBlocksList.lh_first->sva)&&blockToInsert->sva<element->sva)
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	8b 50 08             	mov    0x8(%eax),%edx
  8021fd:	a1 40 40 80 00       	mov    0x804040,%eax
  802202:	8b 40 08             	mov    0x8(%eax),%eax
  802205:	39 c2                	cmp    %eax,%edx
  802207:	76 7c                	jbe    802285 <insert_sorted_allocList+0x183>
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	8b 50 08             	mov    0x8(%eax),%edx
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	8b 40 08             	mov    0x8(%eax),%eax
  802215:	39 c2                	cmp    %eax,%edx
  802217:	73 6c                	jae    802285 <insert_sorted_allocList+0x183>
		{
			LIST_INSERT_BEFORE(&AllocMemBlocksList,element,blockToInsert);
  802219:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80221d:	74 06                	je     802225 <insert_sorted_allocList+0x123>
  80221f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802223:	75 14                	jne    802239 <insert_sorted_allocList+0x137>
  802225:	83 ec 04             	sub    $0x4,%esp
  802228:	68 0c 3a 80 00       	push   $0x803a0c
  80222d:	6a 75                	push   $0x75
  80222f:	68 f3 39 80 00       	push   $0x8039f3
  802234:	e8 38 e0 ff ff       	call   800271 <_panic>
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	8b 50 04             	mov    0x4(%eax),%edx
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	89 50 04             	mov    %edx,0x4(%eax)
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224b:	89 10                	mov    %edx,(%eax)
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 40 04             	mov    0x4(%eax),%eax
  802253:	85 c0                	test   %eax,%eax
  802255:	74 0d                	je     802264 <insert_sorted_allocList+0x162>
  802257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225a:	8b 40 04             	mov    0x4(%eax),%eax
  80225d:	8b 55 08             	mov    0x8(%ebp),%edx
  802260:	89 10                	mov    %edx,(%eax)
  802262:	eb 08                	jmp    80226c <insert_sorted_allocList+0x16a>
  802264:	8b 45 08             	mov    0x8(%ebp),%eax
  802267:	a3 40 40 80 00       	mov    %eax,0x804040
  80226c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226f:	8b 55 08             	mov    0x8(%ebp),%edx
  802272:	89 50 04             	mov    %edx,0x4(%eax)
  802275:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80227a:	40                   	inc    %eax
  80227b:	a3 4c 40 80 00       	mov    %eax,0x80404c

		break;}
  802280:	e9 59 01 00 00       	jmp    8023de <insert_sorted_allocList+0x2dc>

	else if ((blockToInsert->sva>element->sva)&&(blockToInsert->sva<AllocMemBlocksList.lh_last->sva)&&blockToInsert->sva<LIST_NEXT(element)->sva)
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	8b 50 08             	mov    0x8(%eax),%edx
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 40 08             	mov    0x8(%eax),%eax
  802291:	39 c2                	cmp    %eax,%edx
  802293:	0f 86 98 00 00 00    	jbe    802331 <insert_sorted_allocList+0x22f>
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	8b 50 08             	mov    0x8(%eax),%edx
  80229f:	a1 44 40 80 00       	mov    0x804044,%eax
  8022a4:	8b 40 08             	mov    0x8(%eax),%eax
  8022a7:	39 c2                	cmp    %eax,%edx
  8022a9:	0f 83 82 00 00 00    	jae    802331 <insert_sorted_allocList+0x22f>
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	8b 50 08             	mov    0x8(%eax),%edx
  8022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b8:	8b 00                	mov    (%eax),%eax
  8022ba:	8b 40 08             	mov    0x8(%eax),%eax
  8022bd:	39 c2                	cmp    %eax,%edx
  8022bf:	73 70                	jae    802331 <insert_sorted_allocList+0x22f>
	{

	LIST_INSERT_AFTER(&AllocMemBlocksList,element,blockToInsert);
  8022c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c5:	74 06                	je     8022cd <insert_sorted_allocList+0x1cb>
  8022c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022cb:	75 14                	jne    8022e1 <insert_sorted_allocList+0x1df>
  8022cd:	83 ec 04             	sub    $0x4,%esp
  8022d0:	68 44 3a 80 00       	push   $0x803a44
  8022d5:	6a 7c                	push   $0x7c
  8022d7:	68 f3 39 80 00       	push   $0x8039f3
  8022dc:	e8 90 df ff ff       	call   800271 <_panic>
  8022e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e4:	8b 10                	mov    (%eax),%edx
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	89 10                	mov    %edx,(%eax)
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	8b 00                	mov    (%eax),%eax
  8022f0:	85 c0                	test   %eax,%eax
  8022f2:	74 0b                	je     8022ff <insert_sorted_allocList+0x1fd>
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 00                	mov    (%eax),%eax
  8022f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022fc:	89 50 04             	mov    %edx,0x4(%eax)
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	8b 55 08             	mov    0x8(%ebp),%edx
  802305:	89 10                	mov    %edx,(%eax)
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230d:	89 50 04             	mov    %edx,0x4(%eax)
  802310:	8b 45 08             	mov    0x8(%ebp),%eax
  802313:	8b 00                	mov    (%eax),%eax
  802315:	85 c0                	test   %eax,%eax
  802317:	75 08                	jne    802321 <insert_sorted_allocList+0x21f>
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	a3 44 40 80 00       	mov    %eax,0x804044
  802321:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802326:	40                   	inc    %eax
  802327:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  80232c:	e9 ad 00 00 00       	jmp    8023de <insert_sorted_allocList+0x2dc>
	}else if (blockToInsert->sva>AllocMemBlocksList.lh_last->sva)
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	8b 50 08             	mov    0x8(%eax),%edx
  802337:	a1 44 40 80 00       	mov    0x804044,%eax
  80233c:	8b 40 08             	mov    0x8(%eax),%eax
  80233f:	39 c2                	cmp    %eax,%edx
  802341:	76 65                	jbe    8023a8 <insert_sorted_allocList+0x2a6>
	{
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
  802343:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802347:	75 17                	jne    802360 <insert_sorted_allocList+0x25e>
  802349:	83 ec 04             	sub    $0x4,%esp
  80234c:	68 78 3a 80 00       	push   $0x803a78
  802351:	68 80 00 00 00       	push   $0x80
  802356:	68 f3 39 80 00       	push   $0x8039f3
  80235b:	e8 11 df ff ff       	call   800271 <_panic>
  802360:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	89 50 04             	mov    %edx,0x4(%eax)
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	8b 40 04             	mov    0x4(%eax),%eax
  802372:	85 c0                	test   %eax,%eax
  802374:	74 0c                	je     802382 <insert_sorted_allocList+0x280>
  802376:	a1 44 40 80 00       	mov    0x804044,%eax
  80237b:	8b 55 08             	mov    0x8(%ebp),%edx
  80237e:	89 10                	mov    %edx,(%eax)
  802380:	eb 08                	jmp    80238a <insert_sorted_allocList+0x288>
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	a3 40 40 80 00       	mov    %eax,0x804040
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	a3 44 40 80 00       	mov    %eax,0x804044
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80239b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023a0:	40                   	inc    %eax
  8023a1:	a3 4c 40 80 00       	mov    %eax,0x80404c
		break;
  8023a6:	eb 36                	jmp    8023de <insert_sorted_allocList+0x2dc>
	 }
	else if (AllocMemBlocksList.lh_first->sva>blockToInsert->sva)
		{
		LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert );
		}
	LIST_FOREACH(element, &(AllocMemBlocksList))
  8023a8:	a1 48 40 80 00       	mov    0x804048,%eax
  8023ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b4:	74 07                	je     8023bd <insert_sorted_allocList+0x2bb>
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 00                	mov    (%eax),%eax
  8023bb:	eb 05                	jmp    8023c2 <insert_sorted_allocList+0x2c0>
  8023bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c2:	a3 48 40 80 00       	mov    %eax,0x804048
  8023c7:	a1 48 40 80 00       	mov    0x804048,%eax
  8023cc:	85 c0                	test   %eax,%eax
  8023ce:	0f 85 23 fe ff ff    	jne    8021f7 <insert_sorted_allocList+0xf5>
  8023d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d8:	0f 85 19 fe ff ff    	jne    8021f7 <insert_sorted_allocList+0xf5>
			LIST_INSERT_TAIL(&AllocMemBlocksList,blockToInsert );
		break;

	}
	}
}
  8023de:	90                   	nop
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
  8023e4:	83 ec 18             	sub    $0x18,%esp
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8023e7:	a1 38 41 80 00       	mov    0x804138,%eax
  8023ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ef:	e9 7c 01 00 00       	jmp    802570 <alloc_block_FF+0x18f>
		{
			// case 2
				if(element->size == size)
  8023f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023fd:	0f 85 90 00 00 00    	jne    802493 <alloc_block_FF+0xb2>
				{
					tmp_block=element;
  802403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802406:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&FreeMemBlocksList,element);
  802409:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80240d:	75 17                	jne    802426 <alloc_block_FF+0x45>
  80240f:	83 ec 04             	sub    $0x4,%esp
  802412:	68 9b 3a 80 00       	push   $0x803a9b
  802417:	68 ba 00 00 00       	push   $0xba
  80241c:	68 f3 39 80 00       	push   $0x8039f3
  802421:	e8 4b de ff ff       	call   800271 <_panic>
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 00                	mov    (%eax),%eax
  80242b:	85 c0                	test   %eax,%eax
  80242d:	74 10                	je     80243f <alloc_block_FF+0x5e>
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	8b 00                	mov    (%eax),%eax
  802434:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802437:	8b 52 04             	mov    0x4(%edx),%edx
  80243a:	89 50 04             	mov    %edx,0x4(%eax)
  80243d:	eb 0b                	jmp    80244a <alloc_block_FF+0x69>
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 40 04             	mov    0x4(%eax),%eax
  802445:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 40 04             	mov    0x4(%eax),%eax
  802450:	85 c0                	test   %eax,%eax
  802452:	74 0f                	je     802463 <alloc_block_FF+0x82>
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245d:	8b 12                	mov    (%edx),%edx
  80245f:	89 10                	mov    %edx,(%eax)
  802461:	eb 0a                	jmp    80246d <alloc_block_FF+0x8c>
  802463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802466:	8b 00                	mov    (%eax),%eax
  802468:	a3 38 41 80 00       	mov    %eax,0x804138
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802480:	a1 44 41 80 00       	mov    0x804144,%eax
  802485:	48                   	dec    %eax
  802486:	a3 44 41 80 00       	mov    %eax,0x804144
					return tmp_block;
  80248b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248e:	e9 10 01 00 00       	jmp    8025a3 <alloc_block_FF+0x1c2>
				}
				 // case 3
				else if(element->size > size)
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	8b 40 0c             	mov    0xc(%eax),%eax
  802499:	3b 45 08             	cmp    0x8(%ebp),%eax
  80249c:	0f 86 c6 00 00 00    	jbe    802568 <alloc_block_FF+0x187>
				{
					// the new block are created
					tmp_block = AvailableMemBlocksList.lh_first ;
  8024a2:	a1 48 41 80 00       	mov    0x804148,%eax
  8024a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
					LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  8024aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024ae:	75 17                	jne    8024c7 <alloc_block_FF+0xe6>
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	68 9b 3a 80 00       	push   $0x803a9b
  8024b8:	68 c2 00 00 00       	push   $0xc2
  8024bd:	68 f3 39 80 00       	push   $0x8039f3
  8024c2:	e8 aa dd ff ff       	call   800271 <_panic>
  8024c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ca:	8b 00                	mov    (%eax),%eax
  8024cc:	85 c0                	test   %eax,%eax
  8024ce:	74 10                	je     8024e0 <alloc_block_FF+0xff>
  8024d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d3:	8b 00                	mov    (%eax),%eax
  8024d5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024d8:	8b 52 04             	mov    0x4(%edx),%edx
  8024db:	89 50 04             	mov    %edx,0x4(%eax)
  8024de:	eb 0b                	jmp    8024eb <alloc_block_FF+0x10a>
  8024e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e3:	8b 40 04             	mov    0x4(%eax),%eax
  8024e6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ee:	8b 40 04             	mov    0x4(%eax),%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	74 0f                	je     802504 <alloc_block_FF+0x123>
  8024f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f8:	8b 40 04             	mov    0x4(%eax),%eax
  8024fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024fe:	8b 12                	mov    (%edx),%edx
  802500:	89 10                	mov    %edx,(%eax)
  802502:	eb 0a                	jmp    80250e <alloc_block_FF+0x12d>
  802504:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802507:	8b 00                	mov    (%eax),%eax
  802509:	a3 48 41 80 00       	mov    %eax,0x804148
  80250e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802511:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802521:	a1 54 41 80 00       	mov    0x804154,%eax
  802526:	48                   	dec    %eax
  802527:	a3 54 41 80 00       	mov    %eax,0x804154
					tmp_block->sva=element->sva;
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 50 08             	mov    0x8(%eax),%edx
  802532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802535:	89 50 08             	mov    %edx,0x8(%eax)
					tmp_block->size=size;
  802538:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253b:	8b 55 08             	mov    0x8(%ebp),%edx
  80253e:	89 50 0c             	mov    %edx,0xc(%eax)
					//update block with remaining space
					element->size-=size;
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 40 0c             	mov    0xc(%eax),%eax
  802547:	2b 45 08             	sub    0x8(%ebp),%eax
  80254a:	89 c2                	mov    %eax,%edx
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	89 50 0c             	mov    %edx,0xc(%eax)
					element->sva = element->sva + size;
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 50 08             	mov    0x8(%eax),%edx
  802558:	8b 45 08             	mov    0x8(%ebp),%eax
  80255b:	01 c2                	add    %eax,%edx
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	89 50 08             	mov    %edx,0x8(%eax)
					// return back the new block
					return tmp_block ;
  802563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802566:	eb 3b                	jmp    8025a3 <alloc_block_FF+0x1c2>
//
//
//			return NULL ;

	struct MemBlock  *element , *tmp_block;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  802568:	a1 40 41 80 00       	mov    0x804140,%eax
  80256d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802574:	74 07                	je     80257d <alloc_block_FF+0x19c>
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 00                	mov    (%eax),%eax
  80257b:	eb 05                	jmp    802582 <alloc_block_FF+0x1a1>
  80257d:	b8 00 00 00 00       	mov    $0x0,%eax
  802582:	a3 40 41 80 00       	mov    %eax,0x804140
  802587:	a1 40 41 80 00       	mov    0x804140,%eax
  80258c:	85 c0                	test   %eax,%eax
  80258e:	0f 85 60 fe ff ff    	jne    8023f4 <alloc_block_FF+0x13>
  802594:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802598:	0f 85 56 fe ff ff    	jne    8023f4 <alloc_block_FF+0x13>
					// return back the new block
					return tmp_block ;
				}
		}
		// case 1
	  return NULL ;}
  80259e:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a3:	c9                   	leave  
  8025a4:	c3                   	ret    

008025a5 <alloc_block_BF>:
//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================

struct MemBlock *alloc_block_BF(uint32 size)
{
  8025a5:	55                   	push   %ebp
  8025a6:	89 e5                	mov    %esp,%ebp
  8025a8:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
  8025ab:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025b2:	a1 38 41 80 00       	mov    0x804138,%eax
  8025b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ba:	eb 3a                	jmp    8025f6 <alloc_block_BF+0x51>
		{
			if(element->size >= size)
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025c5:	72 27                	jb     8025ee <alloc_block_BF+0x49>
			{
				if(best_size==-1)
  8025c7:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  8025cb:	75 0b                	jne    8025d8 <alloc_block_BF+0x33>
					best_size= element->size;
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8025d6:	eb 16                	jmp    8025ee <alloc_block_BF+0x49>
				else if(best_size >= element->size)
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 50 0c             	mov    0xc(%eax),%edx
  8025de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e1:	39 c2                	cmp    %eax,%edx
  8025e3:	77 09                	ja     8025ee <alloc_block_BF+0x49>
					best_size=element->size;
  8025e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock *element,*tmp_block ;
		int best_size = -1  ;
		LIST_FOREACH(element, &(FreeMemBlocksList))
  8025ee:	a1 40 41 80 00       	mov    0x804140,%eax
  8025f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fa:	74 07                	je     802603 <alloc_block_BF+0x5e>
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	8b 00                	mov    (%eax),%eax
  802601:	eb 05                	jmp    802608 <alloc_block_BF+0x63>
  802603:	b8 00 00 00 00       	mov    $0x0,%eax
  802608:	a3 40 41 80 00       	mov    %eax,0x804140
  80260d:	a1 40 41 80 00       	mov    0x804140,%eax
  802612:	85 c0                	test   %eax,%eax
  802614:	75 a6                	jne    8025bc <alloc_block_BF+0x17>
  802616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261a:	75 a0                	jne    8025bc <alloc_block_BF+0x17>
					best_size= element->size;
				else if(best_size >= element->size)
					best_size=element->size;
			}
		}
		if(best_size != -1)
  80261c:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  802620:	0f 84 d3 01 00 00    	je     8027f9 <alloc_block_BF+0x254>
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  802626:	a1 38 41 80 00       	mov    0x804138,%eax
  80262b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262e:	e9 98 01 00 00       	jmp    8027cb <alloc_block_BF+0x226>
			{
			 if((best_size > size) && (best_size == element->size))
  802633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802636:	3b 45 08             	cmp    0x8(%ebp),%eax
  802639:	0f 86 da 00 00 00    	jbe    802719 <alloc_block_BF+0x174>
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	8b 50 0c             	mov    0xc(%eax),%edx
  802645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802648:	39 c2                	cmp    %eax,%edx
  80264a:	0f 85 c9 00 00 00    	jne    802719 <alloc_block_BF+0x174>
			  {
				// the new block are created
			    tmp_block = AvailableMemBlocksList.lh_first ;
  802650:	a1 48 41 80 00       	mov    0x804148,%eax
  802655:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&(AvailableMemBlocksList),tmp_block);
  802658:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80265c:	75 17                	jne    802675 <alloc_block_BF+0xd0>
  80265e:	83 ec 04             	sub    $0x4,%esp
  802661:	68 9b 3a 80 00       	push   $0x803a9b
  802666:	68 ea 00 00 00       	push   $0xea
  80266b:	68 f3 39 80 00       	push   $0x8039f3
  802670:	e8 fc db ff ff       	call   800271 <_panic>
  802675:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802678:	8b 00                	mov    (%eax),%eax
  80267a:	85 c0                	test   %eax,%eax
  80267c:	74 10                	je     80268e <alloc_block_BF+0xe9>
  80267e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802681:	8b 00                	mov    (%eax),%eax
  802683:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802686:	8b 52 04             	mov    0x4(%edx),%edx
  802689:	89 50 04             	mov    %edx,0x4(%eax)
  80268c:	eb 0b                	jmp    802699 <alloc_block_BF+0xf4>
  80268e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802691:	8b 40 04             	mov    0x4(%eax),%eax
  802694:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802699:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269c:	8b 40 04             	mov    0x4(%eax),%eax
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	74 0f                	je     8026b2 <alloc_block_BF+0x10d>
  8026a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a6:	8b 40 04             	mov    0x4(%eax),%eax
  8026a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026ac:	8b 12                	mov    (%edx),%edx
  8026ae:	89 10                	mov    %edx,(%eax)
  8026b0:	eb 0a                	jmp    8026bc <alloc_block_BF+0x117>
  8026b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b5:	8b 00                	mov    (%eax),%eax
  8026b7:	a3 48 41 80 00       	mov    %eax,0x804148
  8026bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026cf:	a1 54 41 80 00       	mov    0x804154,%eax
  8026d4:	48                   	dec    %eax
  8026d5:	a3 54 41 80 00       	mov    %eax,0x804154
				tmp_block->sva=element->sva;
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 50 08             	mov    0x8(%eax),%edx
  8026e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e3:	89 50 08             	mov    %edx,0x8(%eax)
				tmp_block->size=size;
  8026e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ec:	89 50 0c             	mov    %edx,0xc(%eax)
				//update block with remaining space
				element->size-=size;
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f5:	2b 45 08             	sub    0x8(%ebp),%eax
  8026f8:	89 c2                	mov    %eax,%edx
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	89 50 0c             	mov    %edx,0xc(%eax)
				element->sva = element->sva + size;
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	8b 50 08             	mov    0x8(%eax),%edx
  802706:	8b 45 08             	mov    0x8(%ebp),%eax
  802709:	01 c2                	add    %eax,%edx
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	89 50 08             	mov    %edx,0x8(%eax)
				// return back the new block
				return tmp_block ;
  802711:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802714:	e9 e5 00 00 00       	jmp    8027fe <alloc_block_BF+0x259>

			  }
			else if((element->size == best_size)&&(best_size == size))
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 50 0c             	mov    0xc(%eax),%edx
  80271f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802722:	39 c2                	cmp    %eax,%edx
  802724:	0f 85 99 00 00 00    	jne    8027c3 <alloc_block_BF+0x21e>
  80272a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802730:	0f 85 8d 00 00 00    	jne    8027c3 <alloc_block_BF+0x21e>
			  {
				tmp_block=element;
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	89 45 ec             	mov    %eax,-0x14(%ebp)
				LIST_REMOVE(&FreeMemBlocksList,element);
  80273c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802740:	75 17                	jne    802759 <alloc_block_BF+0x1b4>
  802742:	83 ec 04             	sub    $0x4,%esp
  802745:	68 9b 3a 80 00       	push   $0x803a9b
  80274a:	68 f7 00 00 00       	push   $0xf7
  80274f:	68 f3 39 80 00       	push   $0x8039f3
  802754:	e8 18 db ff ff       	call   800271 <_panic>
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 00                	mov    (%eax),%eax
  80275e:	85 c0                	test   %eax,%eax
  802760:	74 10                	je     802772 <alloc_block_BF+0x1cd>
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 00                	mov    (%eax),%eax
  802767:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276a:	8b 52 04             	mov    0x4(%edx),%edx
  80276d:	89 50 04             	mov    %edx,0x4(%eax)
  802770:	eb 0b                	jmp    80277d <alloc_block_BF+0x1d8>
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 40 04             	mov    0x4(%eax),%eax
  802778:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 40 04             	mov    0x4(%eax),%eax
  802783:	85 c0                	test   %eax,%eax
  802785:	74 0f                	je     802796 <alloc_block_BF+0x1f1>
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 40 04             	mov    0x4(%eax),%eax
  80278d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802790:	8b 12                	mov    (%edx),%edx
  802792:	89 10                	mov    %edx,(%eax)
  802794:	eb 0a                	jmp    8027a0 <alloc_block_BF+0x1fb>
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 00                	mov    (%eax),%eax
  80279b:	a3 38 41 80 00       	mov    %eax,0x804138
  8027a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b3:	a1 44 41 80 00       	mov    0x804144,%eax
  8027b8:	48                   	dec    %eax
  8027b9:	a3 44 41 80 00       	mov    %eax,0x804144
				return tmp_block;
  8027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c1:	eb 3b                	jmp    8027fe <alloc_block_BF+0x259>
					best_size=element->size;
			}
		}
		if(best_size != -1)
		{
			LIST_FOREACH(element, &(FreeMemBlocksList))
  8027c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027cf:	74 07                	je     8027d8 <alloc_block_BF+0x233>
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 00                	mov    (%eax),%eax
  8027d6:	eb 05                	jmp    8027dd <alloc_block_BF+0x238>
  8027d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8027dd:	a3 40 41 80 00       	mov    %eax,0x804140
  8027e2:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e7:	85 c0                	test   %eax,%eax
  8027e9:	0f 85 44 fe ff ff    	jne    802633 <alloc_block_BF+0x8e>
  8027ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f3:	0f 85 3a fe ff ff    	jne    802633 <alloc_block_BF+0x8e>
				LIST_REMOVE(&FreeMemBlocksList,element);
				return tmp_block;
			 }
			}
		}
		return NULL ;}
  8027f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fe:	c9                   	leave  
  8027ff:	c3                   	ret    

00802800 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS1 - BONUS] [DYNAMIC ALLOCATOR] alloc_block_NF
	// Write your code here, remove the panic and write your code
	panic("alloc_block_NF() is not implemented yet...!!");
  802806:	83 ec 04             	sub    $0x4,%esp
  802809:	68 bc 3a 80 00       	push   $0x803abc
  80280e:	68 04 01 00 00       	push   $0x104
  802813:	68 f3 39 80 00       	push   $0x8039f3
  802818:	e8 54 da ff ff       	call   800271 <_panic>

0080281d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{struct MemBlock * blk_itr;
  80281d:	55                   	push   %ebp
  80281e:	89 e5                	mov    %esp,%ebp
  802820:	83 ec 18             	sub    $0x18,%esp
struct MemBlock * next;
struct MemBlock * first = LIST_FIRST(&(FreeMemBlocksList));
  802823:	a1 38 41 80 00       	mov    0x804138,%eax
  802828:	89 45 f0             	mov    %eax,-0x10(%ebp)
struct MemBlock * last = LIST_LAST(&(FreeMemBlocksList));
  80282b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802830:	89 45 ec             	mov    %eax,-0x14(%ebp)

if(LIST_EMPTY(&(FreeMemBlocksList)))
  802833:	a1 38 41 80 00       	mov    0x804138,%eax
  802838:	85 c0                	test   %eax,%eax
  80283a:	75 68                	jne    8028a4 <insert_sorted_with_merge_freeList+0x87>
			{

				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  80283c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802840:	75 17                	jne    802859 <insert_sorted_with_merge_freeList+0x3c>
  802842:	83 ec 04             	sub    $0x4,%esp
  802845:	68 d0 39 80 00       	push   $0x8039d0
  80284a:	68 14 01 00 00       	push   $0x114
  80284f:	68 f3 39 80 00       	push   $0x8039f3
  802854:	e8 18 da ff ff       	call   800271 <_panic>
  802859:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80285f:	8b 45 08             	mov    0x8(%ebp),%eax
  802862:	89 10                	mov    %edx,(%eax)
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	8b 00                	mov    (%eax),%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	74 0d                	je     80287a <insert_sorted_with_merge_freeList+0x5d>
  80286d:	a1 38 41 80 00       	mov    0x804138,%eax
  802872:	8b 55 08             	mov    0x8(%ebp),%edx
  802875:	89 50 04             	mov    %edx,0x4(%eax)
  802878:	eb 08                	jmp    802882 <insert_sorted_with_merge_freeList+0x65>
  80287a:	8b 45 08             	mov    0x8(%ebp),%eax
  80287d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802882:	8b 45 08             	mov    0x8(%ebp),%eax
  802885:	a3 38 41 80 00       	mov    %eax,0x804138
  80288a:	8b 45 08             	mov    0x8(%ebp),%eax
  80288d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802894:	a1 44 41 80 00       	mov    0x804144,%eax
  802899:	40                   	inc    %eax
  80289a:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  80289f:	e9 d2 06 00 00       	jmp    802f76 <insert_sorted_with_merge_freeList+0x759>
				LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);

			}
else
{
	if( blockToInsert->sva  < first->sva )
  8028a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a7:	8b 50 08             	mov    0x8(%eax),%edx
  8028aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ad:	8b 40 08             	mov    0x8(%eax),%eax
  8028b0:	39 c2                	cmp    %eax,%edx
  8028b2:	0f 83 22 01 00 00    	jae    8029da <insert_sorted_with_merge_freeList+0x1bd>
	{
                if( blockToInsert->sva + blockToInsert->size == first->sva)
  8028b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bb:	8b 50 08             	mov    0x8(%eax),%edx
  8028be:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c4:	01 c2                	add    %eax,%edx
  8028c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c9:	8b 40 08             	mov    0x8(%eax),%eax
  8028cc:	39 c2                	cmp    %eax,%edx
  8028ce:	0f 85 9e 00 00 00    	jne    802972 <insert_sorted_with_merge_freeList+0x155>
                {

                	first->sva = blockToInsert->sva;
  8028d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d7:	8b 50 08             	mov    0x8(%eax),%edx
  8028da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dd:	89 50 08             	mov    %edx,0x8(%eax)
                	first->size = first->size + blockToInsert->size;
  8028e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e3:	8b 50 0c             	mov    0xc(%eax),%edx
  8028e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ec:	01 c2                	add    %eax,%edx
  8028ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f1:	89 50 0c             	mov    %edx,0xc(%eax)
                	blockToInsert->size = blockToInsert->sva = 0;
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  8028fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802901:	8b 50 08             	mov    0x8(%eax),%edx
  802904:	8b 45 08             	mov    0x8(%ebp),%eax
  802907:	89 50 0c             	mov    %edx,0xc(%eax)
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  80290a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80290e:	75 17                	jne    802927 <insert_sorted_with_merge_freeList+0x10a>
  802910:	83 ec 04             	sub    $0x4,%esp
  802913:	68 d0 39 80 00       	push   $0x8039d0
  802918:	68 21 01 00 00       	push   $0x121
  80291d:	68 f3 39 80 00       	push   $0x8039f3
  802922:	e8 4a d9 ff ff       	call   800271 <_panic>
  802927:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80292d:	8b 45 08             	mov    0x8(%ebp),%eax
  802930:	89 10                	mov    %edx,(%eax)
  802932:	8b 45 08             	mov    0x8(%ebp),%eax
  802935:	8b 00                	mov    (%eax),%eax
  802937:	85 c0                	test   %eax,%eax
  802939:	74 0d                	je     802948 <insert_sorted_with_merge_freeList+0x12b>
  80293b:	a1 48 41 80 00       	mov    0x804148,%eax
  802940:	8b 55 08             	mov    0x8(%ebp),%edx
  802943:	89 50 04             	mov    %edx,0x4(%eax)
  802946:	eb 08                	jmp    802950 <insert_sorted_with_merge_freeList+0x133>
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	a3 48 41 80 00       	mov    %eax,0x804148
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802962:	a1 54 41 80 00       	mov    0x804154,%eax
  802967:	40                   	inc    %eax
  802968:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  80296d:	e9 04 06 00 00       	jmp    802f76 <insert_sorted_with_merge_freeList+0x759>
                	LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
                }

                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
  802972:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802976:	75 17                	jne    80298f <insert_sorted_with_merge_freeList+0x172>
  802978:	83 ec 04             	sub    $0x4,%esp
  80297b:	68 d0 39 80 00       	push   $0x8039d0
  802980:	68 26 01 00 00       	push   $0x126
  802985:	68 f3 39 80 00       	push   $0x8039f3
  80298a:	e8 e2 d8 ff ff       	call   800271 <_panic>
  80298f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	89 10                	mov    %edx,(%eax)
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	85 c0                	test   %eax,%eax
  8029a1:	74 0d                	je     8029b0 <insert_sorted_with_merge_freeList+0x193>
  8029a3:	a1 38 41 80 00       	mov    0x804138,%eax
  8029a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ab:	89 50 04             	mov    %edx,0x4(%eax)
  8029ae:	eb 08                	jmp    8029b8 <insert_sorted_with_merge_freeList+0x19b>
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	a3 38 41 80 00       	mov    %eax,0x804138
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ca:	a1 44 41 80 00       	mov    0x804144,%eax
  8029cf:	40                   	inc    %eax
  8029d0:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  8029d5:	e9 9c 05 00 00       	jmp    802f76 <insert_sorted_with_merge_freeList+0x759>
                else
                {
                	LIST_INSERT_HEAD(&(FreeMemBlocksList),  blockToInsert);
                }
	}
    else if(blockToInsert->sva > last->sva)
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	8b 50 08             	mov    0x8(%eax),%edx
  8029e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e3:	8b 40 08             	mov    0x8(%eax),%eax
  8029e6:	39 c2                	cmp    %eax,%edx
  8029e8:	0f 86 16 01 00 00    	jbe    802b04 <insert_sorted_with_merge_freeList+0x2e7>
 	{

				if(last->sva + last->size == blockToInsert->sva)
  8029ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f1:	8b 50 08             	mov    0x8(%eax),%edx
  8029f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029fa:	01 c2                	add    %eax,%edx
  8029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ff:	8b 40 08             	mov    0x8(%eax),%eax
  802a02:	39 c2                	cmp    %eax,%edx
  802a04:	0f 85 92 00 00 00    	jne    802a9c <insert_sorted_with_merge_freeList+0x27f>
				{

					last->size = last->size + blockToInsert->size;
  802a0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a0d:	8b 50 0c             	mov    0xc(%eax),%edx
  802a10:	8b 45 08             	mov    0x8(%ebp),%eax
  802a13:	8b 40 0c             	mov    0xc(%eax),%eax
  802a16:	01 c2                	add    %eax,%edx
  802a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1b:	89 50 0c             	mov    %edx,0xc(%eax)
					blockToInsert->size = blockToInsert->sva = 0;
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	8b 50 08             	mov    0x8(%eax),%edx
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	89 50 0c             	mov    %edx,0xc(%eax)
					LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802a34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a38:	75 17                	jne    802a51 <insert_sorted_with_merge_freeList+0x234>
  802a3a:	83 ec 04             	sub    $0x4,%esp
  802a3d:	68 d0 39 80 00       	push   $0x8039d0
  802a42:	68 31 01 00 00       	push   $0x131
  802a47:	68 f3 39 80 00       	push   $0x8039f3
  802a4c:	e8 20 d8 ff ff       	call   800271 <_panic>
  802a51:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a57:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5a:	89 10                	mov    %edx,(%eax)
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	8b 00                	mov    (%eax),%eax
  802a61:	85 c0                	test   %eax,%eax
  802a63:	74 0d                	je     802a72 <insert_sorted_with_merge_freeList+0x255>
  802a65:	a1 48 41 80 00       	mov    0x804148,%eax
  802a6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6d:	89 50 04             	mov    %edx,0x4(%eax)
  802a70:	eb 08                	jmp    802a7a <insert_sorted_with_merge_freeList+0x25d>
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7d:	a3 48 41 80 00       	mov    %eax,0x804148
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8c:	a1 54 41 80 00       	mov    0x804154,%eax
  802a91:	40                   	inc    %eax
  802a92:	a3 54 41 80 00       	mov    %eax,0x804154
						}
				}
        }

}
}
  802a97:	e9 da 04 00 00       	jmp    802f76 <insert_sorted_with_merge_freeList+0x759>

				}

				else
				{
					LIST_INSERT_TAIL(&(FreeMemBlocksList),  blockToInsert);
  802a9c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa0:	75 17                	jne    802ab9 <insert_sorted_with_merge_freeList+0x29c>
  802aa2:	83 ec 04             	sub    $0x4,%esp
  802aa5:	68 78 3a 80 00       	push   $0x803a78
  802aaa:	68 37 01 00 00       	push   $0x137
  802aaf:	68 f3 39 80 00       	push   $0x8039f3
  802ab4:	e8 b8 d7 ff ff       	call   800271 <_panic>
  802ab9:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802abf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac2:	89 50 04             	mov    %edx,0x4(%eax)
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	8b 40 04             	mov    0x4(%eax),%eax
  802acb:	85 c0                	test   %eax,%eax
  802acd:	74 0c                	je     802adb <insert_sorted_with_merge_freeList+0x2be>
  802acf:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ad4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad7:	89 10                	mov    %edx,(%eax)
  802ad9:	eb 08                	jmp    802ae3 <insert_sorted_with_merge_freeList+0x2c6>
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	a3 38 41 80 00       	mov    %eax,0x804138
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af4:	a1 44 41 80 00       	mov    0x804144,%eax
  802af9:	40                   	inc    %eax
  802afa:	a3 44 41 80 00       	mov    %eax,0x804144
						}
				}
        }

}
}
  802aff:	e9 72 04 00 00       	jmp    802f76 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802b04:	a1 38 41 80 00       	mov    0x804138,%eax
  802b09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b0c:	e9 35 04 00 00       	jmp    802f46 <insert_sorted_with_merge_freeList+0x729>
				{
				     next=LIST_NEXT(blk_itr);
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	89 45 e8             	mov    %eax,-0x18(%ebp)


					if( (blockToInsert->sva > blk_itr->sva) )
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	8b 50 08             	mov    0x8(%eax),%edx
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	8b 40 08             	mov    0x8(%eax),%eax
  802b25:	39 c2                	cmp    %eax,%edx
  802b27:	0f 86 11 04 00 00    	jbe    802f3e <insert_sorted_with_merge_freeList+0x721>
						{
							if(((blk_itr->sva) + (blk_itr->size) < blockToInsert->sva && (blockToInsert->sva) + (blockToInsert->size) < next->sva))
  802b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b30:	8b 50 08             	mov    0x8(%eax),%edx
  802b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b36:	8b 40 0c             	mov    0xc(%eax),%eax
  802b39:	01 c2                	add    %eax,%edx
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	8b 40 08             	mov    0x8(%eax),%eax
  802b41:	39 c2                	cmp    %eax,%edx
  802b43:	0f 83 8b 00 00 00    	jae    802bd4 <insert_sorted_with_merge_freeList+0x3b7>
  802b49:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4c:	8b 50 08             	mov    0x8(%eax),%edx
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	8b 40 0c             	mov    0xc(%eax),%eax
  802b55:	01 c2                	add    %eax,%edx
  802b57:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b5a:	8b 40 08             	mov    0x8(%eax),%eax
  802b5d:	39 c2                	cmp    %eax,%edx
  802b5f:	73 73                	jae    802bd4 <insert_sorted_with_merge_freeList+0x3b7>
							{
								LIST_INSERT_AFTER(&(FreeMemBlocksList), blk_itr, blockToInsert);
  802b61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b65:	74 06                	je     802b6d <insert_sorted_with_merge_freeList+0x350>
  802b67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b6b:	75 17                	jne    802b84 <insert_sorted_with_merge_freeList+0x367>
  802b6d:	83 ec 04             	sub    $0x4,%esp
  802b70:	68 44 3a 80 00       	push   $0x803a44
  802b75:	68 48 01 00 00       	push   $0x148
  802b7a:	68 f3 39 80 00       	push   $0x8039f3
  802b7f:	e8 ed d6 ff ff       	call   800271 <_panic>
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	8b 10                	mov    (%eax),%edx
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	89 10                	mov    %edx,(%eax)
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	8b 00                	mov    (%eax),%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	74 0b                	je     802ba2 <insert_sorted_with_merge_freeList+0x385>
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 00                	mov    (%eax),%eax
  802b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba8:	89 10                	mov    %edx,(%eax)
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb0:	89 50 04             	mov    %edx,0x4(%eax)
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	75 08                	jne    802bc4 <insert_sorted_with_merge_freeList+0x3a7>
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bc4:	a1 44 41 80 00       	mov    0x804144,%eax
  802bc9:	40                   	inc    %eax
  802bca:	a3 44 41 80 00       	mov    %eax,0x804144
								break;
  802bcf:	e9 a2 03 00 00       	jmp    802f76 <insert_sorted_with_merge_freeList+0x759>

							}
							else if((blockToInsert->sva + blockToInsert->size) < next->sva  && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	8b 50 08             	mov    0x8(%eax),%edx
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802be0:	01 c2                	add    %eax,%edx
  802be2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802be5:	8b 40 08             	mov    0x8(%eax),%eax
  802be8:	39 c2                	cmp    %eax,%edx
  802bea:	0f 83 ae 00 00 00    	jae    802c9e <insert_sorted_with_merge_freeList+0x481>
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	8b 50 08             	mov    0x8(%eax),%edx
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 48 08             	mov    0x8(%eax),%ecx
  802bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bff:	8b 40 0c             	mov    0xc(%eax),%eax
  802c02:	01 c8                	add    %ecx,%eax
  802c04:	39 c2                	cmp    %eax,%edx
  802c06:	0f 85 92 00 00 00    	jne    802c9e <insert_sorted_with_merge_freeList+0x481>
							{

								blk_itr->size=blk_itr->size+blockToInsert->size;
  802c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0f:	8b 50 0c             	mov    0xc(%eax),%edx
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	8b 40 0c             	mov    0xc(%eax),%eax
  802c18:	01 c2                	add    %eax,%edx
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	89 50 0c             	mov    %edx,0xc(%eax)
								 blockToInsert->size=blockToInsert->sva=0;
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	8b 50 08             	mov    0x8(%eax),%edx
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	89 50 0c             	mov    %edx,0xc(%eax)
								 LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802c36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3a:	75 17                	jne    802c53 <insert_sorted_with_merge_freeList+0x436>
  802c3c:	83 ec 04             	sub    $0x4,%esp
  802c3f:	68 d0 39 80 00       	push   $0x8039d0
  802c44:	68 51 01 00 00       	push   $0x151
  802c49:	68 f3 39 80 00       	push   $0x8039f3
  802c4e:	e8 1e d6 ff ff       	call   800271 <_panic>
  802c53:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	89 10                	mov    %edx,(%eax)
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	8b 00                	mov    (%eax),%eax
  802c63:	85 c0                	test   %eax,%eax
  802c65:	74 0d                	je     802c74 <insert_sorted_with_merge_freeList+0x457>
  802c67:	a1 48 41 80 00       	mov    0x804148,%eax
  802c6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6f:	89 50 04             	mov    %edx,0x4(%eax)
  802c72:	eb 08                	jmp    802c7c <insert_sorted_with_merge_freeList+0x45f>
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	a3 48 41 80 00       	mov    %eax,0x804148
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8e:	a1 54 41 80 00       	mov    0x804154,%eax
  802c93:	40                   	inc    %eax
  802c94:	a3 54 41 80 00       	mov    %eax,0x804154
								 break;
  802c99:	e9 d8 02 00 00       	jmp    802f76 <insert_sorted_with_merge_freeList+0x759>

							}
							else if( (blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva > (blk_itr->sva + blk_itr->size))
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	8b 50 08             	mov    0x8(%eax),%edx
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	8b 40 0c             	mov    0xc(%eax),%eax
  802caa:	01 c2                	add    %eax,%edx
  802cac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802caf:	8b 40 08             	mov    0x8(%eax),%eax
  802cb2:	39 c2                	cmp    %eax,%edx
  802cb4:	0f 85 ba 00 00 00    	jne    802d74 <insert_sorted_with_merge_freeList+0x557>
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	8b 50 08             	mov    0x8(%eax),%edx
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 48 08             	mov    0x8(%eax),%ecx
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccc:	01 c8                	add    %ecx,%eax
  802cce:	39 c2                	cmp    %eax,%edx
  802cd0:	0f 86 9e 00 00 00    	jbe    802d74 <insert_sorted_with_merge_freeList+0x557>
							{
								next->size = next->size + blockToInsert->size;
  802cd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd9:	8b 50 0c             	mov    0xc(%eax),%edx
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce2:	01 c2                	add    %eax,%edx
  802ce4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce7:	89 50 0c             	mov    %edx,0xc(%eax)
								next->sva = blockToInsert->sva;
  802cea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ced:	8b 50 08             	mov    0x8(%eax),%edx
  802cf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf3:	89 50 08             	mov    %edx,0x8(%eax)

								blockToInsert->size = blockToInsert->sva = 0;
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	8b 50 08             	mov    0x8(%eax),%edx
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802d0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d10:	75 17                	jne    802d29 <insert_sorted_with_merge_freeList+0x50c>
  802d12:	83 ec 04             	sub    $0x4,%esp
  802d15:	68 d0 39 80 00       	push   $0x8039d0
  802d1a:	68 5b 01 00 00       	push   $0x15b
  802d1f:	68 f3 39 80 00       	push   $0x8039f3
  802d24:	e8 48 d5 ff ff       	call   800271 <_panic>
  802d29:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	89 10                	mov    %edx,(%eax)
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	8b 00                	mov    (%eax),%eax
  802d39:	85 c0                	test   %eax,%eax
  802d3b:	74 0d                	je     802d4a <insert_sorted_with_merge_freeList+0x52d>
  802d3d:	a1 48 41 80 00       	mov    0x804148,%eax
  802d42:	8b 55 08             	mov    0x8(%ebp),%edx
  802d45:	89 50 04             	mov    %edx,0x4(%eax)
  802d48:	eb 08                	jmp    802d52 <insert_sorted_with_merge_freeList+0x535>
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	a3 48 41 80 00       	mov    %eax,0x804148
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d64:	a1 54 41 80 00       	mov    0x804154,%eax
  802d69:	40                   	inc    %eax
  802d6a:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802d6f:	e9 02 02 00 00       	jmp    802f76 <insert_sorted_with_merge_freeList+0x759>
							}
							else if ((blockToInsert->sva + blockToInsert->size) == next->sva && blockToInsert->sva == (blk_itr->sva + blk_itr->size))
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	8b 50 08             	mov    0x8(%eax),%edx
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d80:	01 c2                	add    %eax,%edx
  802d82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d85:	8b 40 08             	mov    0x8(%eax),%eax
  802d88:	39 c2                	cmp    %eax,%edx
  802d8a:	0f 85 ae 01 00 00    	jne    802f3e <insert_sorted_with_merge_freeList+0x721>
  802d90:	8b 45 08             	mov    0x8(%ebp),%eax
  802d93:	8b 50 08             	mov    0x8(%eax),%edx
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 48 08             	mov    0x8(%eax),%ecx
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802da2:	01 c8                	add    %ecx,%eax
  802da4:	39 c2                	cmp    %eax,%edx
  802da6:	0f 85 92 01 00 00    	jne    802f3e <insert_sorted_with_merge_freeList+0x721>
							{
								blk_itr->size = blk_itr->size + blockToInsert->size + next->size;
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	8b 50 0c             	mov    0xc(%eax),%edx
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	8b 40 0c             	mov    0xc(%eax),%eax
  802db8:	01 c2                	add    %eax,%edx
  802dba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc0:	01 c2                	add    %eax,%edx
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size = blockToInsert->sva=0;
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	8b 50 08             	mov    0x8(%eax),%edx
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	89 50 0c             	mov    %edx,0xc(%eax)
								next->size = next->sva = 0;
  802dde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802de1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  802de8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802deb:	8b 50 08             	mov    0x8(%eax),%edx
  802dee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802df1:	89 50 0c             	mov    %edx,0xc(%eax)
								LIST_REMOVE(&FreeMemBlocksList, next);
  802df4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802df8:	75 17                	jne    802e11 <insert_sorted_with_merge_freeList+0x5f4>
  802dfa:	83 ec 04             	sub    $0x4,%esp
  802dfd:	68 9b 3a 80 00       	push   $0x803a9b
  802e02:	68 63 01 00 00       	push   $0x163
  802e07:	68 f3 39 80 00       	push   $0x8039f3
  802e0c:	e8 60 d4 ff ff       	call   800271 <_panic>
  802e11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e14:	8b 00                	mov    (%eax),%eax
  802e16:	85 c0                	test   %eax,%eax
  802e18:	74 10                	je     802e2a <insert_sorted_with_merge_freeList+0x60d>
  802e1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e22:	8b 52 04             	mov    0x4(%edx),%edx
  802e25:	89 50 04             	mov    %edx,0x4(%eax)
  802e28:	eb 0b                	jmp    802e35 <insert_sorted_with_merge_freeList+0x618>
  802e2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e2d:	8b 40 04             	mov    0x4(%eax),%eax
  802e30:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e35:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e38:	8b 40 04             	mov    0x4(%eax),%eax
  802e3b:	85 c0                	test   %eax,%eax
  802e3d:	74 0f                	je     802e4e <insert_sorted_with_merge_freeList+0x631>
  802e3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e42:	8b 40 04             	mov    0x4(%eax),%eax
  802e45:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e48:	8b 12                	mov    (%edx),%edx
  802e4a:	89 10                	mov    %edx,(%eax)
  802e4c:	eb 0a                	jmp    802e58 <insert_sorted_with_merge_freeList+0x63b>
  802e4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e51:	8b 00                	mov    (%eax),%eax
  802e53:	a3 38 41 80 00       	mov    %eax,0x804138
  802e58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e61:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6b:	a1 44 41 80 00       	mov    0x804144,%eax
  802e70:	48                   	dec    %eax
  802e71:	a3 44 41 80 00       	mov    %eax,0x804144
								LIST_INSERT_HEAD(&AvailableMemBlocksList, next );
  802e76:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e7a:	75 17                	jne    802e93 <insert_sorted_with_merge_freeList+0x676>
  802e7c:	83 ec 04             	sub    $0x4,%esp
  802e7f:	68 d0 39 80 00       	push   $0x8039d0
  802e84:	68 64 01 00 00       	push   $0x164
  802e89:	68 f3 39 80 00       	push   $0x8039f3
  802e8e:	e8 de d3 ff ff       	call   800271 <_panic>
  802e93:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9c:	89 10                	mov    %edx,(%eax)
  802e9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	74 0d                	je     802eb4 <insert_sorted_with_merge_freeList+0x697>
  802ea7:	a1 48 41 80 00       	mov    0x804148,%eax
  802eac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802eaf:	89 50 04             	mov    %edx,0x4(%eax)
  802eb2:	eb 08                	jmp    802ebc <insert_sorted_with_merge_freeList+0x69f>
  802eb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ebc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebf:	a3 48 41 80 00       	mov    %eax,0x804148
  802ec4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ece:	a1 54 41 80 00       	mov    0x804154,%eax
  802ed3:	40                   	inc    %eax
  802ed4:	a3 54 41 80 00       	mov    %eax,0x804154
							    LIST_INSERT_HEAD(&AvailableMemBlocksList, blockToInsert );
  802ed9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802edd:	75 17                	jne    802ef6 <insert_sorted_with_merge_freeList+0x6d9>
  802edf:	83 ec 04             	sub    $0x4,%esp
  802ee2:	68 d0 39 80 00       	push   $0x8039d0
  802ee7:	68 65 01 00 00       	push   $0x165
  802eec:	68 f3 39 80 00       	push   $0x8039f3
  802ef1:	e8 7b d3 ff ff       	call   800271 <_panic>
  802ef6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	89 10                	mov    %edx,(%eax)
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	8b 00                	mov    (%eax),%eax
  802f06:	85 c0                	test   %eax,%eax
  802f08:	74 0d                	je     802f17 <insert_sorted_with_merge_freeList+0x6fa>
  802f0a:	a1 48 41 80 00       	mov    0x804148,%eax
  802f0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f12:	89 50 04             	mov    %edx,0x4(%eax)
  802f15:	eb 08                	jmp    802f1f <insert_sorted_with_merge_freeList+0x702>
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	a3 48 41 80 00       	mov    %eax,0x804148
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f31:	a1 54 41 80 00       	mov    0x804154,%eax
  802f36:	40                   	inc    %eax
  802f37:	a3 54 41 80 00       	mov    %eax,0x804154
								break;
  802f3c:	eb 38                	jmp    802f76 <insert_sorted_with_merge_freeList+0x759>

	}

    else{

				LIST_FOREACH(blk_itr, &(FreeMemBlocksList))
  802f3e:	a1 40 41 80 00       	mov    0x804140,%eax
  802f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f4a:	74 07                	je     802f53 <insert_sorted_with_merge_freeList+0x736>
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	eb 05                	jmp    802f58 <insert_sorted_with_merge_freeList+0x73b>
  802f53:	b8 00 00 00 00       	mov    $0x0,%eax
  802f58:	a3 40 41 80 00       	mov    %eax,0x804140
  802f5d:	a1 40 41 80 00       	mov    0x804140,%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	0f 85 a7 fb ff ff    	jne    802b11 <insert_sorted_with_merge_freeList+0x2f4>
  802f6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6e:	0f 85 9d fb ff ff    	jne    802b11 <insert_sorted_with_merge_freeList+0x2f4>
						}
				}
        }

}
}
  802f74:	eb 00                	jmp    802f76 <insert_sorted_with_merge_freeList+0x759>
  802f76:	90                   	nop
  802f77:	c9                   	leave  
  802f78:	c3                   	ret    
  802f79:	66 90                	xchg   %ax,%ax
  802f7b:	90                   	nop

00802f7c <__udivdi3>:
  802f7c:	55                   	push   %ebp
  802f7d:	57                   	push   %edi
  802f7e:	56                   	push   %esi
  802f7f:	53                   	push   %ebx
  802f80:	83 ec 1c             	sub    $0x1c,%esp
  802f83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802f87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802f8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802f8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802f93:	89 ca                	mov    %ecx,%edx
  802f95:	89 f8                	mov    %edi,%eax
  802f97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802f9b:	85 f6                	test   %esi,%esi
  802f9d:	75 2d                	jne    802fcc <__udivdi3+0x50>
  802f9f:	39 cf                	cmp    %ecx,%edi
  802fa1:	77 65                	ja     803008 <__udivdi3+0x8c>
  802fa3:	89 fd                	mov    %edi,%ebp
  802fa5:	85 ff                	test   %edi,%edi
  802fa7:	75 0b                	jne    802fb4 <__udivdi3+0x38>
  802fa9:	b8 01 00 00 00       	mov    $0x1,%eax
  802fae:	31 d2                	xor    %edx,%edx
  802fb0:	f7 f7                	div    %edi
  802fb2:	89 c5                	mov    %eax,%ebp
  802fb4:	31 d2                	xor    %edx,%edx
  802fb6:	89 c8                	mov    %ecx,%eax
  802fb8:	f7 f5                	div    %ebp
  802fba:	89 c1                	mov    %eax,%ecx
  802fbc:	89 d8                	mov    %ebx,%eax
  802fbe:	f7 f5                	div    %ebp
  802fc0:	89 cf                	mov    %ecx,%edi
  802fc2:	89 fa                	mov    %edi,%edx
  802fc4:	83 c4 1c             	add    $0x1c,%esp
  802fc7:	5b                   	pop    %ebx
  802fc8:	5e                   	pop    %esi
  802fc9:	5f                   	pop    %edi
  802fca:	5d                   	pop    %ebp
  802fcb:	c3                   	ret    
  802fcc:	39 ce                	cmp    %ecx,%esi
  802fce:	77 28                	ja     802ff8 <__udivdi3+0x7c>
  802fd0:	0f bd fe             	bsr    %esi,%edi
  802fd3:	83 f7 1f             	xor    $0x1f,%edi
  802fd6:	75 40                	jne    803018 <__udivdi3+0x9c>
  802fd8:	39 ce                	cmp    %ecx,%esi
  802fda:	72 0a                	jb     802fe6 <__udivdi3+0x6a>
  802fdc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802fe0:	0f 87 9e 00 00 00    	ja     803084 <__udivdi3+0x108>
  802fe6:	b8 01 00 00 00       	mov    $0x1,%eax
  802feb:	89 fa                	mov    %edi,%edx
  802fed:	83 c4 1c             	add    $0x1c,%esp
  802ff0:	5b                   	pop    %ebx
  802ff1:	5e                   	pop    %esi
  802ff2:	5f                   	pop    %edi
  802ff3:	5d                   	pop    %ebp
  802ff4:	c3                   	ret    
  802ff5:	8d 76 00             	lea    0x0(%esi),%esi
  802ff8:	31 ff                	xor    %edi,%edi
  802ffa:	31 c0                	xor    %eax,%eax
  802ffc:	89 fa                	mov    %edi,%edx
  802ffe:	83 c4 1c             	add    $0x1c,%esp
  803001:	5b                   	pop    %ebx
  803002:	5e                   	pop    %esi
  803003:	5f                   	pop    %edi
  803004:	5d                   	pop    %ebp
  803005:	c3                   	ret    
  803006:	66 90                	xchg   %ax,%ax
  803008:	89 d8                	mov    %ebx,%eax
  80300a:	f7 f7                	div    %edi
  80300c:	31 ff                	xor    %edi,%edi
  80300e:	89 fa                	mov    %edi,%edx
  803010:	83 c4 1c             	add    $0x1c,%esp
  803013:	5b                   	pop    %ebx
  803014:	5e                   	pop    %esi
  803015:	5f                   	pop    %edi
  803016:	5d                   	pop    %ebp
  803017:	c3                   	ret    
  803018:	bd 20 00 00 00       	mov    $0x20,%ebp
  80301d:	89 eb                	mov    %ebp,%ebx
  80301f:	29 fb                	sub    %edi,%ebx
  803021:	89 f9                	mov    %edi,%ecx
  803023:	d3 e6                	shl    %cl,%esi
  803025:	89 c5                	mov    %eax,%ebp
  803027:	88 d9                	mov    %bl,%cl
  803029:	d3 ed                	shr    %cl,%ebp
  80302b:	89 e9                	mov    %ebp,%ecx
  80302d:	09 f1                	or     %esi,%ecx
  80302f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803033:	89 f9                	mov    %edi,%ecx
  803035:	d3 e0                	shl    %cl,%eax
  803037:	89 c5                	mov    %eax,%ebp
  803039:	89 d6                	mov    %edx,%esi
  80303b:	88 d9                	mov    %bl,%cl
  80303d:	d3 ee                	shr    %cl,%esi
  80303f:	89 f9                	mov    %edi,%ecx
  803041:	d3 e2                	shl    %cl,%edx
  803043:	8b 44 24 08          	mov    0x8(%esp),%eax
  803047:	88 d9                	mov    %bl,%cl
  803049:	d3 e8                	shr    %cl,%eax
  80304b:	09 c2                	or     %eax,%edx
  80304d:	89 d0                	mov    %edx,%eax
  80304f:	89 f2                	mov    %esi,%edx
  803051:	f7 74 24 0c          	divl   0xc(%esp)
  803055:	89 d6                	mov    %edx,%esi
  803057:	89 c3                	mov    %eax,%ebx
  803059:	f7 e5                	mul    %ebp
  80305b:	39 d6                	cmp    %edx,%esi
  80305d:	72 19                	jb     803078 <__udivdi3+0xfc>
  80305f:	74 0b                	je     80306c <__udivdi3+0xf0>
  803061:	89 d8                	mov    %ebx,%eax
  803063:	31 ff                	xor    %edi,%edi
  803065:	e9 58 ff ff ff       	jmp    802fc2 <__udivdi3+0x46>
  80306a:	66 90                	xchg   %ax,%ax
  80306c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803070:	89 f9                	mov    %edi,%ecx
  803072:	d3 e2                	shl    %cl,%edx
  803074:	39 c2                	cmp    %eax,%edx
  803076:	73 e9                	jae    803061 <__udivdi3+0xe5>
  803078:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80307b:	31 ff                	xor    %edi,%edi
  80307d:	e9 40 ff ff ff       	jmp    802fc2 <__udivdi3+0x46>
  803082:	66 90                	xchg   %ax,%ax
  803084:	31 c0                	xor    %eax,%eax
  803086:	e9 37 ff ff ff       	jmp    802fc2 <__udivdi3+0x46>
  80308b:	90                   	nop

0080308c <__umoddi3>:
  80308c:	55                   	push   %ebp
  80308d:	57                   	push   %edi
  80308e:	56                   	push   %esi
  80308f:	53                   	push   %ebx
  803090:	83 ec 1c             	sub    $0x1c,%esp
  803093:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803097:	8b 74 24 34          	mov    0x34(%esp),%esi
  80309b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80309f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8030a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8030ab:	89 f3                	mov    %esi,%ebx
  8030ad:	89 fa                	mov    %edi,%edx
  8030af:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8030b3:	89 34 24             	mov    %esi,(%esp)
  8030b6:	85 c0                	test   %eax,%eax
  8030b8:	75 1a                	jne    8030d4 <__umoddi3+0x48>
  8030ba:	39 f7                	cmp    %esi,%edi
  8030bc:	0f 86 a2 00 00 00    	jbe    803164 <__umoddi3+0xd8>
  8030c2:	89 c8                	mov    %ecx,%eax
  8030c4:	89 f2                	mov    %esi,%edx
  8030c6:	f7 f7                	div    %edi
  8030c8:	89 d0                	mov    %edx,%eax
  8030ca:	31 d2                	xor    %edx,%edx
  8030cc:	83 c4 1c             	add    $0x1c,%esp
  8030cf:	5b                   	pop    %ebx
  8030d0:	5e                   	pop    %esi
  8030d1:	5f                   	pop    %edi
  8030d2:	5d                   	pop    %ebp
  8030d3:	c3                   	ret    
  8030d4:	39 f0                	cmp    %esi,%eax
  8030d6:	0f 87 ac 00 00 00    	ja     803188 <__umoddi3+0xfc>
  8030dc:	0f bd e8             	bsr    %eax,%ebp
  8030df:	83 f5 1f             	xor    $0x1f,%ebp
  8030e2:	0f 84 ac 00 00 00    	je     803194 <__umoddi3+0x108>
  8030e8:	bf 20 00 00 00       	mov    $0x20,%edi
  8030ed:	29 ef                	sub    %ebp,%edi
  8030ef:	89 fe                	mov    %edi,%esi
  8030f1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8030f5:	89 e9                	mov    %ebp,%ecx
  8030f7:	d3 e0                	shl    %cl,%eax
  8030f9:	89 d7                	mov    %edx,%edi
  8030fb:	89 f1                	mov    %esi,%ecx
  8030fd:	d3 ef                	shr    %cl,%edi
  8030ff:	09 c7                	or     %eax,%edi
  803101:	89 e9                	mov    %ebp,%ecx
  803103:	d3 e2                	shl    %cl,%edx
  803105:	89 14 24             	mov    %edx,(%esp)
  803108:	89 d8                	mov    %ebx,%eax
  80310a:	d3 e0                	shl    %cl,%eax
  80310c:	89 c2                	mov    %eax,%edx
  80310e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803112:	d3 e0                	shl    %cl,%eax
  803114:	89 44 24 04          	mov    %eax,0x4(%esp)
  803118:	8b 44 24 08          	mov    0x8(%esp),%eax
  80311c:	89 f1                	mov    %esi,%ecx
  80311e:	d3 e8                	shr    %cl,%eax
  803120:	09 d0                	or     %edx,%eax
  803122:	d3 eb                	shr    %cl,%ebx
  803124:	89 da                	mov    %ebx,%edx
  803126:	f7 f7                	div    %edi
  803128:	89 d3                	mov    %edx,%ebx
  80312a:	f7 24 24             	mull   (%esp)
  80312d:	89 c6                	mov    %eax,%esi
  80312f:	89 d1                	mov    %edx,%ecx
  803131:	39 d3                	cmp    %edx,%ebx
  803133:	0f 82 87 00 00 00    	jb     8031c0 <__umoddi3+0x134>
  803139:	0f 84 91 00 00 00    	je     8031d0 <__umoddi3+0x144>
  80313f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803143:	29 f2                	sub    %esi,%edx
  803145:	19 cb                	sbb    %ecx,%ebx
  803147:	89 d8                	mov    %ebx,%eax
  803149:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80314d:	d3 e0                	shl    %cl,%eax
  80314f:	89 e9                	mov    %ebp,%ecx
  803151:	d3 ea                	shr    %cl,%edx
  803153:	09 d0                	or     %edx,%eax
  803155:	89 e9                	mov    %ebp,%ecx
  803157:	d3 eb                	shr    %cl,%ebx
  803159:	89 da                	mov    %ebx,%edx
  80315b:	83 c4 1c             	add    $0x1c,%esp
  80315e:	5b                   	pop    %ebx
  80315f:	5e                   	pop    %esi
  803160:	5f                   	pop    %edi
  803161:	5d                   	pop    %ebp
  803162:	c3                   	ret    
  803163:	90                   	nop
  803164:	89 fd                	mov    %edi,%ebp
  803166:	85 ff                	test   %edi,%edi
  803168:	75 0b                	jne    803175 <__umoddi3+0xe9>
  80316a:	b8 01 00 00 00       	mov    $0x1,%eax
  80316f:	31 d2                	xor    %edx,%edx
  803171:	f7 f7                	div    %edi
  803173:	89 c5                	mov    %eax,%ebp
  803175:	89 f0                	mov    %esi,%eax
  803177:	31 d2                	xor    %edx,%edx
  803179:	f7 f5                	div    %ebp
  80317b:	89 c8                	mov    %ecx,%eax
  80317d:	f7 f5                	div    %ebp
  80317f:	89 d0                	mov    %edx,%eax
  803181:	e9 44 ff ff ff       	jmp    8030ca <__umoddi3+0x3e>
  803186:	66 90                	xchg   %ax,%ax
  803188:	89 c8                	mov    %ecx,%eax
  80318a:	89 f2                	mov    %esi,%edx
  80318c:	83 c4 1c             	add    $0x1c,%esp
  80318f:	5b                   	pop    %ebx
  803190:	5e                   	pop    %esi
  803191:	5f                   	pop    %edi
  803192:	5d                   	pop    %ebp
  803193:	c3                   	ret    
  803194:	3b 04 24             	cmp    (%esp),%eax
  803197:	72 06                	jb     80319f <__umoddi3+0x113>
  803199:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80319d:	77 0f                	ja     8031ae <__umoddi3+0x122>
  80319f:	89 f2                	mov    %esi,%edx
  8031a1:	29 f9                	sub    %edi,%ecx
  8031a3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8031a7:	89 14 24             	mov    %edx,(%esp)
  8031aa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031ae:	8b 44 24 04          	mov    0x4(%esp),%eax
  8031b2:	8b 14 24             	mov    (%esp),%edx
  8031b5:	83 c4 1c             	add    $0x1c,%esp
  8031b8:	5b                   	pop    %ebx
  8031b9:	5e                   	pop    %esi
  8031ba:	5f                   	pop    %edi
  8031bb:	5d                   	pop    %ebp
  8031bc:	c3                   	ret    
  8031bd:	8d 76 00             	lea    0x0(%esi),%esi
  8031c0:	2b 04 24             	sub    (%esp),%eax
  8031c3:	19 fa                	sbb    %edi,%edx
  8031c5:	89 d1                	mov    %edx,%ecx
  8031c7:	89 c6                	mov    %eax,%esi
  8031c9:	e9 71 ff ff ff       	jmp    80313f <__umoddi3+0xb3>
  8031ce:	66 90                	xchg   %ax,%ax
  8031d0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8031d4:	72 ea                	jb     8031c0 <__umoddi3+0x134>
  8031d6:	89 d9                	mov    %ebx,%ecx
  8031d8:	e9 62 ff ff ff       	jmp    80313f <__umoddi3+0xb3>
